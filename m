Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71F25292C4
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 10:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389198AbfEXIRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 04:17:25 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36674 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389046AbfEXIRZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 04:17:25 -0400
Received: by mail-wm1-f67.google.com with SMTP id v22so996932wml.1
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 01:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tRuu2vwbRKnYkdS2MTxBJLoHSsXwF1V1gTt9OrMych8=;
        b=Vr6t4OViswgSrX5J2+EE5VOXynk276WJuS11iZxxPDZzN7dpmdlJiucI1tibczQ7ME
         eUugZ+rd3PIP2XPkBalPAtaB1Zslk/JnyHj8rqgegLuC36UTfX+aWxaKOiL4S+IW1YE+
         gOFs4amTpfMZg+feKqTfZz8j0IsSNjroUCyEQz296eEHWqOe1zQzcSEZ7kcwOSzT5AJO
         ofzE3iOMiYpyuOq4UmHgNJD5FrQIfyiqW+9orPBPjv218CuFHL5haglzrCK08l777o7q
         LQpyFmgDCGoRwE4AYoIXfw92HuaSF7iqo3pHKqsPM8wOdqYHzDdWFuNCtKkGicGA8ges
         P0ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tRuu2vwbRKnYkdS2MTxBJLoHSsXwF1V1gTt9OrMych8=;
        b=FqBBrWjBqMy4W0xCmRRG79b+9/UFrUrXapz3Q+KfnSRsYkUdQ05k+67i+4hd6lF+AN
         EEgcyp6lMRpqf0eHKWPNQw281//2yG7c3tCmiLzxT95gyne2c7YkiJWBBHa+pYxSSZxj
         s1gSgbpNS/oLuCEngo0auidss6lLwauMzzwXw0/BM6jbbuoQI83qnJNbnbheH2fxTnFJ
         NeL2kAKbHUpMELCTZMxe541qK9EDSiApNLY8w8CzHbmP0UFEArnUTdFCd2RFRIP9npLL
         Hf7dCX/H6mS4CPaElsL5UCiIRWItKffcV3xWyyy+qEayZu3qF/YiFSa5Xw6vdgq1csdy
         C6dQ==
X-Gm-Message-State: APjAAAV0UaypafiI3dxHfwpMgBm/TZ+D3RdSvjyKdS4jMyblD/iLPr20
        GIIG3P1Bl2l9WfLOa1L27mm23w==
X-Google-Smtp-Source: APXvYqwPZJwRtDEkZ/oahDz4tboNEZS4MuDMk+AOWQPbjF+5O2uSJX9txvg6tcTwmhzJQAfFPMLOIw==
X-Received: by 2002:a05:600c:230a:: with SMTP id 10mr14250233wmo.13.1558685843164;
        Fri, 24 May 2019 01:17:23 -0700 (PDT)
Received: from localhost (ip-89-176-222-123.net.upcbroadband.cz. [89.176.222.123])
        by smtp.gmail.com with ESMTPSA id e14sm1852913wma.41.2019.05.24.01.17.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 May 2019 01:17:22 -0700 (PDT)
Date:   Fri, 24 May 2019 10:17:21 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com,
        sthemmin@microsoft.com, dsahern@gmail.com, saeedm@mellanox.com,
        leon@kernel.org
Subject: Re: [patch net-next 7/7] netdevsim: implement fake flash updating
 with notifications
Message-ID: <20190524081721.GE2904@nanopsycho>
References: <20190523094510.2317-1-jiri@resnulli.us>
 <20190523094510.2317-8-jiri@resnulli.us>
 <20190523104754.73202b23@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523104754.73202b23@cakuba.netronome.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, May 23, 2019 at 07:47:54PM CEST, jakub.kicinski@netronome.com wrote:
>On Thu, 23 May 2019 11:45:10 +0200, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>> ---
>>  drivers/net/netdevsim/dev.c | 35 +++++++++++++++++++++++++++++++++++
>>  1 file changed, 35 insertions(+)
>> 
>> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
>> index b509b941d5ca..c15b86f9cd2b 100644
>> --- a/drivers/net/netdevsim/dev.c
>> +++ b/drivers/net/netdevsim/dev.c
>> @@ -220,8 +220,43 @@ static int nsim_dev_reload(struct devlink *devlink,
>>  	return 0;
>>  }
>>  
>> +#define NSIM_DEV_FLASH_SIZE 500000
>> +#define NSIM_DEV_FLASH_CHUNK_SIZE 1000
>> +#define NSIM_DEV_FLASH_CHUNK_TIME_MS 10
>> +
>> +static int nsim_dev_flash_update(struct devlink *devlink, const char *file_name,
>> +				 const char *component,
>> +				 struct netlink_ext_ack *extack)
>> +{
>> +	int i;
>> +
>> +	devlink_flash_update_begin_notify(devlink);
>
>Now I wonder if it would be good for the core to send those.  Is it
>down to the driver to send the begin/end notifications because it would
>be wasteful to always send them, or is it some ABI thing?

The thing is the driver update could be triggered by driver itself. For
example in mlxsw, during init the fw is flashed to the supported
version. And we still want notification that it happened.

>
>Also I wonder if it'd be useful for netdevsim to have a mode which
>doesn't send notifications, to test both cases.

Okay. I'll look into adding a debugfs toggle for this.


>
>> +	devlink_flash_update_status_notify(devlink, "Preparing to flash",
>> +					   component, 0, 0);
>> +	for (i = 0; i < NSIM_DEV_FLASH_SIZE / NSIM_DEV_FLASH_CHUNK_SIZE; i++) {
>> +		devlink_flash_update_status_notify(devlink, "Flashing",
>> +						   component,
>> +						   i * NSIM_DEV_FLASH_CHUNK_SIZE,
>> +						   NSIM_DEV_FLASH_SIZE);
>> +		msleep(NSIM_DEV_FLASH_CHUNK_TIME_MS);
>> +	}
>> +	devlink_flash_update_status_notify(devlink, "Flashing",
>> +					   component,
>> +					   NSIM_DEV_FLASH_SIZE,
>> +					   NSIM_DEV_FLASH_SIZE);
>> +
>> +	devlink_flash_update_status_notify(devlink, "Flashing done",
>> +					   component, 0, 0);
>> +
>> +	devlink_flash_update_end_notify(devlink);
>> +
>> +	return 0;
>> +}
>> +
>>  static const struct devlink_ops nsim_dev_devlink_ops = {
>>  	.reload = nsim_dev_reload,
>> +	.flash_update = nsim_dev_flash_update,
>>  };
>>  
>>  static struct nsim_dev *
>
