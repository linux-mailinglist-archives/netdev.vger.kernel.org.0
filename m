Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 348512D72B
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 10:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbfE2IAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 04:00:20 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53292 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfE2IAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 04:00:19 -0400
Received: by mail-wm1-f67.google.com with SMTP id d17so893296wmb.3
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 01:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=clya1YzvdGb3Nmjm3u3YhkUzQ9Kua3gRnoIkhnm5ao4=;
        b=wckKGLY0RKYccTK7dYCAhLfLU7xUwsoBAUOepmSpTDAJs/XJ5Er1MILlvXAGcclM7t
         WCr3WAY7e4mJlwzA5l6PH5N5ognrt3duWt3K+Z+eVS4MmVzs6xcavjqWXj04qMpQoLnT
         H7m7BbpcL1vgdqV349asySZoORUFnTLyN1JhINTyLGWxbn47B1PbEpIMJyhScVKHgEtw
         anI87hM1yFTogXqU89q0GtlfOWPYd59CRMp3rN7ZBk2YjacOJ3dwAs2l1OtT98+AN19U
         pAoklOq3ABaXOOEZRULSUqWGcihsTMPrWmMy0Z81C/F4ZRXV9uCgReNfpKatFc0WiUTN
         cJbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=clya1YzvdGb3Nmjm3u3YhkUzQ9Kua3gRnoIkhnm5ao4=;
        b=s69bBCybRVEQ2HJqp2BwddoHqj0oNsdsdA4vqLzTcJHxnD/iuGZlJrEhmipqLNNwq7
         9YwMpZpG9sWpQp+NkmpckZGL90MX5/K0WEOPw6+YRC8j58T4TsyXua00nERK1ba+HOb3
         e8ye7T4ylOX32J6E3ig46YOAv1HlYDW6hVCUn9O5YaTYiqPtDBhDz2FHs8QbMvO9rQM2
         oOG6KLL3vHqlvHANGKuj1ypqlV03eUQVqQ/Kh0TkKIZm5APb2hRwp+6ZZOGpXwJGTEyn
         xss61nN24OOz64PT1Ca4/ewxVVr6lq8XMQnRTQ3a67PofrnYO+lphKhyfX+N7lPTJgTk
         KBrA==
X-Gm-Message-State: APjAAAUAnKE8Y/g0xiSDFGxxj6BM26HGyMogEt9vnj3c0FpBe7rybPb2
        fAKn3yo6mqNRlZqAzoRzWe33tA==
X-Google-Smtp-Source: APXvYqxhJa3u+jqzpwzAJRIm4iWxnM1/UXJMXqOF6M4BgdCV/ryhFxBhCfo7VMjenUN9a0uoJYrHNA==
X-Received: by 2002:a05:600c:230a:: with SMTP id 10mr6143237wmo.13.1559116817785;
        Wed, 29 May 2019 01:00:17 -0700 (PDT)
Received: from localhost (ip-89-177-126-215.net.upcbroadband.cz. [89.177.126.215])
        by smtp.gmail.com with ESMTPSA id r4sm11821608wrv.34.2019.05.29.01.00.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 29 May 2019 01:00:17 -0700 (PDT)
Date:   Wed, 29 May 2019 10:00:16 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com,
        sthemmin@microsoft.com, dsahern@gmail.com, saeedm@mellanox.com,
        leon@kernel.org, f.fainelli@gmail.com
Subject: Re: [patch net-next v2 7/7] netdevsim: implement fake flash updating
 with notifications
Message-ID: <20190529080016.GD2252@nanopsycho>
References: <20190528114846.1983-1-jiri@resnulli.us>
 <20190528114846.1983-8-jiri@resnulli.us>
 <20190528130115.5062c085@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528130115.5062c085@cakuba.netronome.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, May 28, 2019 at 10:01:15PM CEST, jakub.kicinski@netronome.com wrote:
>On Tue, 28 May 2019 13:48:46 +0200, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>> ---
>> v1->v2:
>> - added debugfs toggle to enable/disable flash status notifications
>
>Could you please add a selftest making use of netdevsim code?

How do you imagine the selftest should look like. What should it test
exactly?


>
>Sorry, I must have liked the feature so much first time I missed this :)
>
>> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
>> index b509b941d5ca..c5c417a3c0ce 100644
>> --- a/drivers/net/netdevsim/dev.c
>> +++ b/drivers/net/netdevsim/dev.c
>> @@ -38,6 +38,8 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
>>  	nsim_dev->ports_ddir = debugfs_create_dir("ports", nsim_dev->ddir);
>>  	if (IS_ERR_OR_NULL(nsim_dev->ports_ddir))
>>  		return PTR_ERR_OR_ZERO(nsim_dev->ports_ddir) ?: -EINVAL;
>> +	debugfs_create_bool("fw_update_status", 0600, nsim_dev->ddir,
>> +			    &nsim_dev->fw_update_status);
>>  	return 0;
>>  }
>>  
>> @@ -220,8 +222,49 @@ static int nsim_dev_reload(struct devlink *devlink,
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
>> +	struct nsim_dev *nsim_dev = devlink_priv(devlink);
>> +	int i;
>> +
>> +	if (nsim_dev->fw_update_status) {
>> +		devlink_flash_update_begin_notify(devlink);
>> +		devlink_flash_update_status_notify(devlink,
>> +						   "Preparing to flash",
>> +						   component, 0, 0);
>> +	}
>> +
>> +	for (i = 0; i < NSIM_DEV_FLASH_SIZE / NSIM_DEV_FLASH_CHUNK_SIZE; i++) {
>> +		if (nsim_dev->fw_update_status)
>> +			devlink_flash_update_status_notify(devlink, "Flashing",
>> +							   component,
>> +							   i * NSIM_DEV_FLASH_CHUNK_SIZE,
>> +							   NSIM_DEV_FLASH_SIZE);
>> +		msleep(NSIM_DEV_FLASH_CHUNK_TIME_MS);
>
>In automated testing it may be a little annoying if this takes > 5sec

I wanted to emulate real device. I can make this 5 sec if you want, no
problem.


>
>> +	}
>> +
>> +	if (nsim_dev->fw_update_status) {
>> +		devlink_flash_update_status_notify(devlink, "Flashing",
>> +						   component,
>> +						   NSIM_DEV_FLASH_SIZE,
>> +						   NSIM_DEV_FLASH_SIZE);
>> +		devlink_flash_update_status_notify(devlink, "Flashing done",
>> +						   component, 0, 0);
>> +		devlink_flash_update_end_notify(devlink);
>> +	}
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
