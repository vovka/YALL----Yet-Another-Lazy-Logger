require 'logger'

# This is lazy loger based on standart logger. It can log info to different 
# files, creating them on the fly. Like this: 
# logger.info msg #=> creates 'info.log' file and logs to it
# logger.myfile msg #=> creates 'myfile.log' file and logs to it
##etc
class CustomLogger
  def method_missing *args    
    symbolic_name = args.shift
    msg = args.shift
    
    logger = self.get_logger symbolic_name
    logger.info msg
  end
  
  protected 
  
    def logs_path
      #HARDCODE: 
      File.join File.dirname(__FILE__), 'logs'
    end
    
    def get_logger filename=nil
      filename = filename.to_s if not filename.is_a? String
      filename = 'default' if filename.empty?
      logger_var = eval "@#{filename}"
      if logger_var and not logger_var.nil?
      else
        filepath = File.join self.logs_path, "#{filename}.log"
        logger_var = Logger.new(filepath)
      end
      logger_var
    end
end

class Object
  def logger
    self.class.logger
  end
  
  class << self
    def logger
      @@logger ||= CustomLogger.new
    end
  end
end


