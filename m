Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12520D393C
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 08:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbfJKGNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 02:13:41 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37593 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbfJKGNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 02:13:41 -0400
Received: by mail-wm1-f65.google.com with SMTP id f22so8919544wmc.2
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 23:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Kj0WU5bueYBy8h0yiczVq+nKZ9O8cToZL2AEybLei44=;
        b=SlloHUVm4jBkXlGyJNZ5xOhO5FkHTvRgy402evacbwSk7j/lnFi8fgeH+PSlnkFucQ
         /kZGlWyb+RzlT9osF5feCHsKLeEXaxv60nevU7NOiblIFc8tTs4MHv5HohtH1AJYFdrt
         ORH7PazHINhVXglurhqbM5tthzBmsPRbrGjYftsgi0sf2FNnMN1bm3sYvo7ZPpdlqnP5
         C7d72TCdZL/AeSNGyv9g6+L+1P7tkT2U0kjJZQMcqyr/QxepiZOzE24LcbwqjHDjFMhj
         S0iIB8fIQ028t2DM6xVKxcvBcTlMRikZrCs91ArMji87x8M85W8nOdDuAsEyy0O6RhYP
         4maA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Kj0WU5bueYBy8h0yiczVq+nKZ9O8cToZL2AEybLei44=;
        b=sNj0McJba7WqNawEtbIkX/t8o0gOIEzJ+d6y7s6mCQMTT6vLoYLmE9JhKpEWLu/T4D
         R8R4uAm/U8zbbga09I3/RF02tN2C5O24uVJSJu/iIKuQHhphVdbP+VJmSpD7qcj1opa1
         kYM/2sU1OCLzuyoHBojoy69zVjhsK8RmOYkJ1JAeQFw+lwZ9PJhCApdkDFyBlbZwdWY9
         suttIYkypHjJfSl+4CF1Fi4GX/CLO75EMODoIMTCRSjmJ9KD6+tmQnDXWAywf2kyx0vj
         T9x774evucZVT5OOHqHj+75qqSOaGbJXv61UOpbgfj2mdz0TUcjlofRtGuQUrod3Xe8t
         xEOQ==
X-Gm-Message-State: APjAAAWwyvhMvLQBmyF4XPjF/SYNSUQD92zuzCeJB/O4vFBZ/w2aDPgl
        qSDdWgG3x0hhgfXlia5YdzekKxnGNC8=
X-Google-Smtp-Source: APXvYqxms2LByPVGy9eleFOoAGZ7h8Ub+sUvSNGa0MuBgxii+aCgS55zVaankQS6Z5PvhvSA9ZcTEA==
X-Received: by 2002:a1c:55c4:: with SMTP id j187mr1720332wmb.155.1570774419259;
        Thu, 10 Oct 2019 23:13:39 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id e18sm10852842wrv.63.2019.10.10.23.13.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 23:13:38 -0700 (PDT)
Date:   Fri, 11 Oct 2019 08:13:38 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     davem@davemloft.net, Johannes Berg <johannes@sipsolutions.net>,
        "dsahern@gmail.com" <dsahern@gmail.com>, netdev@vger.kernel.org,
        ayal@mellanox.com, moshe@mellanox.com, eranbe@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next v2 2/4] devlink: propagate extack down to health
 reporter ops
Message-ID: <20191011061338.GG2901@nanopsycho>
References: <20191010131851.21438-1-jiri@resnulli.us>
 <20191010131851.21438-3-jiri@resnulli.us>
 <20191010190429.4511a8de@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010190429.4511a8de@cakuba.netronome.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Oct 11, 2019 at 04:04:29AM CEST, jakub.kicinski@netronome.com wrote:
>On Thu, 10 Oct 2019 15:18:49 +0200, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> During health reporter operations, driver might want to fill-up
>> the extack message, so propagate extack down to the health reporter ops.
>> 
>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>
>> @@ -507,11 +507,14 @@ enum devlink_health_reporter_state {
>>  struct devlink_health_reporter_ops {
>>  	char *name;
>>  	int (*recover)(struct devlink_health_reporter *reporter,
>> -		       void *priv_ctx);
>> +		       void *priv_ctx, struct netlink_ext_ack *extack);
>>  	int (*dump)(struct devlink_health_reporter *reporter,
>> -		    struct devlink_fmsg *fmsg, void *priv_ctx);
>> +		    struct devlink_fmsg *fmsg, void *priv_ctx,
>> +		    struct netlink_ext_ack *extack);
>>  	int (*diagnose)(struct devlink_health_reporter *reporter,
>> -			struct devlink_fmsg *fmsg);
>> +			struct devlink_fmsg *fmsg,
>> +			struct netlink_ext_ack *extack);
>> +
>
>nit: Looks like an extra new line snuck in here?
>
>>  };
>>  
>>  /**
>
>> @@ -4946,11 +4947,12 @@ int devlink_health_report(struct devlink_health_reporter *reporter,
>>  
>>  	mutex_lock(&reporter->dump_lock);
>>  	/* store current dump of current error, for later analysis */
>> -	devlink_health_do_dump(reporter, priv_ctx);
>> +	devlink_health_do_dump(reporter, priv_ctx, NULL);
>>  	mutex_unlock(&reporter->dump_lock);
>>  
>>  	if (reporter->auto_recover)
>> -		return devlink_health_reporter_recover(reporter, priv_ctx);
>> +		return devlink_health_reporter_recover(reporter,
>> +						       priv_ctx, NULL);
>>  
>>  	return 0;
>>  }
>
>Thinking about this again - would it be entirely insane to allocate the
>extack on the stack here? And if anything gets set output into the logs?
>
>For context the situation here is that the health API can be poked from
>user space, but also the recovery actions are triggered automatically
>when failure is detected, if so configured (usually we expect them to
>be).
>
>When we were adding the extack helper for the drivers to use Johannes
>was concerned about printing to logs because that gave us a
>disincentive to convert all locations, and people could get surprised
>by the logs disappearing when more places are converted to extack [1].
>
>I wonder if this is a special case where outputting to the logs is a
>good idea? Really for all auto-recoverable health reporters the extack
>argument will just confuse driver authors. If driver uses extack here
>instead of printing to the logs information why auto-recovery failed is
>likely to get lost.
>
>Am I over-thinking this?

My gut feeling is kidn of odd about allocating some netlink specific
struct and use it separatelly from netlink :/

In any case, I think that this should probably be a separate patch/set.

>
>[1] https://www.spinics.net/lists/netdev/msg431998.html
