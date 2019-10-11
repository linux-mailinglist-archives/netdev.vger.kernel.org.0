Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFACFD3761
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 04:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbfJKCEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 22:04:48 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:36388 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727369AbfJKCEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 22:04:47 -0400
Received: by mail-qk1-f196.google.com with SMTP id y189so7530428qkc.3
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 19:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=bVcoGGvX/h92jtkuDhLlbLYWpdvKRSKxkCla/En59C8=;
        b=OOG7jipbDAWgGV+veIsQujfGruoyQu9G/jr9T/E18YnpPUdeozrhnp1lPBEdq7N5a3
         XFTmbRD/jadXM7s6yvgCFIkfyqZpJgZ9bTCaDh/F7VkdsXf3hlmFGZF65gshDFDLCEoH
         sghvu8xL/aQdDM9nVn6TZVSIR+5D2/8RTQnrlV+kkXfsP3HnR7hvT47oXjusrM7+7+Ek
         cTtzeFD+MLE07uzpLh1RgwqXCVZZbW0sXcs6lK9+ZVmIXIaWbBqh+znyN5087qrT603M
         A8ta/0QiUz5S2737MnLZvCGF2nmrAhNAhceNoylG23K38wmVwJFAmWH/HDENd6XB+h8V
         YGZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=bVcoGGvX/h92jtkuDhLlbLYWpdvKRSKxkCla/En59C8=;
        b=rz2vFtZJyHgeNjyNW+SHSBSalpOEwPjWep1MaGF+oXHp5eLeUjzFeeWmmFFB7hI+5G
         ctX7f2H5yk6d1dhUubKgrHC/C6YSyctVywd/omkfPlTa9KuG/Jibo65a9/AVEudgUPbJ
         1DqYrKkc9z7OEdTjuioIOW7TdF7Ee9+mUgtlOxmz6HcUx+8SSnguIfyRv7jFsfj7XTS2
         ERLNPTP1J9bFm801djYs7xiRQl4MUlXyvqYdxLW7YNhrJsP/JylpGAUVUph7e4mWyc68
         ddrY8iPQb57OOJaNRzI8j1484Ib4xvkyon2bHwZp/y0uEbDYbXqLxPSBPRy635k+30Zp
         TnMQ==
X-Gm-Message-State: APjAAAVRQ1cl+OdSL2YG/gbwB/OxBE5w1g0uN9sn3n/v4Fk6KdyAsHgK
        h6NKP9hT/dDWMvU7zMkDFd6I8Y6uR9k=
X-Google-Smtp-Source: APXvYqxrzJEC75Ebh3woM2fqb58zDZGzPo+o2ibrXCQyRiPW3oSqM0mvDTv39z4UK8nFSI6WLdfRnA==
X-Received: by 2002:a37:2ec5:: with SMTP id u188mr13181788qkh.94.1570759486969;
        Thu, 10 Oct 2019 19:04:46 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z141sm3524052qka.126.2019.10.10.19.04.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 19:04:46 -0700 (PDT)
Date:   Thu, 10 Oct 2019 19:04:29 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>, davem@davemloft.net,
        Johannes Berg <johannes@sipsolutions.net>,
        "dsahern@gmail.com" <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, ayal@mellanox.com, moshe@mellanox.com,
        eranbe@mellanox.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 2/4] devlink: propagate extack down to
 health reporter ops
Message-ID: <20191010190429.4511a8de@cakuba.netronome.com>
In-Reply-To: <20191010131851.21438-3-jiri@resnulli.us>
References: <20191010131851.21438-1-jiri@resnulli.us>
        <20191010131851.21438-3-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Oct 2019 15:18:49 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> During health reporter operations, driver might want to fill-up
> the extack message, so propagate extack down to the health reporter ops.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

> @@ -507,11 +507,14 @@ enum devlink_health_reporter_state {
>  struct devlink_health_reporter_ops {
>  	char *name;
>  	int (*recover)(struct devlink_health_reporter *reporter,
> -		       void *priv_ctx);
> +		       void *priv_ctx, struct netlink_ext_ack *extack);
>  	int (*dump)(struct devlink_health_reporter *reporter,
> -		    struct devlink_fmsg *fmsg, void *priv_ctx);
> +		    struct devlink_fmsg *fmsg, void *priv_ctx,
> +		    struct netlink_ext_ack *extack);
>  	int (*diagnose)(struct devlink_health_reporter *reporter,
> -			struct devlink_fmsg *fmsg);
> +			struct devlink_fmsg *fmsg,
> +			struct netlink_ext_ack *extack);
> +

nit: Looks like an extra new line snuck in here?

>  };
>  
>  /**

> @@ -4946,11 +4947,12 @@ int devlink_health_report(struct devlink_health_reporter *reporter,
>  
>  	mutex_lock(&reporter->dump_lock);
>  	/* store current dump of current error, for later analysis */
> -	devlink_health_do_dump(reporter, priv_ctx);
> +	devlink_health_do_dump(reporter, priv_ctx, NULL);
>  	mutex_unlock(&reporter->dump_lock);
>  
>  	if (reporter->auto_recover)
> -		return devlink_health_reporter_recover(reporter, priv_ctx);
> +		return devlink_health_reporter_recover(reporter,
> +						       priv_ctx, NULL);
>  
>  	return 0;
>  }

Thinking about this again - would it be entirely insane to allocate the
extack on the stack here? And if anything gets set output into the logs?

For context the situation here is that the health API can be poked from
user space, but also the recovery actions are triggered automatically
when failure is detected, if so configured (usually we expect them to
be).

When we were adding the extack helper for the drivers to use Johannes
was concerned about printing to logs because that gave us a
disincentive to convert all locations, and people could get surprised
by the logs disappearing when more places are converted to extack [1].

I wonder if this is a special case where outputting to the logs is a
good idea? Really for all auto-recoverable health reporters the extack
argument will just confuse driver authors. If driver uses extack here
instead of printing to the logs information why auto-recovery failed is
likely to get lost.

Am I over-thinking this?

[1] https://www.spinics.net/lists/netdev/msg431998.html
