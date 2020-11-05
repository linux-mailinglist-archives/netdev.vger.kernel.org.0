Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 017CF2A7EEE
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 13:49:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730429AbgKEMtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 07:49:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgKEMtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 07:49:06 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E96C0613CF
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 04:49:06 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id c18so1473022wme.2
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 04:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MZYX1Jtswi9EobHzQrigCKEKpGP1HMr8FYDPquGnRcA=;
        b=IuQeH70ueg96pzZ86GvnOwHZKNzd5sUpIpV+SJJQqlpmf9trKGfipnGDoL5cvwSOzS
         QqoetynU8x1TRkSOIQ3a9o5Ye6gHP8D9DSHyuh5sWIfqJp7+08XOuc8dLkYIXGBu0X16
         WrV+p+hPCqYCXG9OU5XuIVBHrZNcpK6MJfSfE4ymjfnbcJCpgIDnsRHipSg5mbWyvq8y
         pGoISYBfrqoaj/pefu8gpK3LOjL3gKISm3IFHUoQo9J8pgkxgml7WOeo7Lka4XjGc2Rh
         iNQTRKw+ooWlioXE+bLEnaVyyoiSS6C8kk8dz+02ZyhZNhWELvI7po29gdSMUepvbQ8I
         ESZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MZYX1Jtswi9EobHzQrigCKEKpGP1HMr8FYDPquGnRcA=;
        b=CkzQeiyWmlREchv8x3hk1jPL4vmSgM15GqOKG4TP7KFme8EM/kNwV6H/Zeaeo7pR82
         /AOKOhIy0K3svOcrMLh5yPzCjieCh6g7SoB6GKIHOnfw+ujehxwuotJgFOO+Wm3p/cIk
         xe+600J5Mn2u7Kto2r3yP2VtvM22ZXcjFk1msKtZDSomazh/Iqi1WwwowxqO6ntDA1Yl
         NJJvVoQlnq+CB0NWbC5LlYYrwIUgorMRGrD1xr3c/SbUl5vFyD/yaf9Pu/5nbTOSTSII
         +mP2HbpPGnS3HTkiDTq8HmMM5txsMu4Vun+oJCla+/H8Xi4q1rmWs3DxR7hjVa8e3B5A
         yHBA==
X-Gm-Message-State: AOAM532tlZFR+khfyydh8mhduswhShbFxRblThWRwYoOWxLxKFT27AZ6
        TTsRo/F2ZkUapjGftVrtmyM=
X-Google-Smtp-Source: ABdhPJyVOVTq3sWxEvd3mKymwNEBK/xQEeF1i8CKqgBSjkIeR6Rk0iOUzvbhszGn4q0VSmJfmOdzEA==
X-Received: by 2002:a1c:9695:: with SMTP id y143mr2601687wmd.70.1604580545170;
        Thu, 05 Nov 2020 04:49:05 -0800 (PST)
Received: from [192.168.8.114] ([37.172.191.42])
        by smtp.gmail.com with ESMTPSA id o3sm2361092wru.15.2020.11.05.04.49.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 04:49:04 -0800 (PST)
Subject: Re: [RESEND PATCH] bonding: wait for sysfs kobject destruction before
 freeing struct slave
To:     Jamie Iles <jamie@nuviainc.com>, netdev@vger.kernel.org
Cc:     Qiushi Wu <wu000273@umn.edu>, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
References: <20201105084108.3432509-1-jamie@nuviainc.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <89416a2d-8a9b-f225-3c2a-16210df25e61@gmail.com>
Date:   Thu, 5 Nov 2020 13:49:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201105084108.3432509-1-jamie@nuviainc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/5/20 9:41 AM, Jamie Iles wrote:
> syzkaller found that with CONFIG_DEBUG_KOBJECT_RELEASE=y, releasing a
> struct slave device could result in the following splat:
> 
>

> This is a potential use-after-free if the sysfs nodes are being accessed
> whilst removing the struct slave, so wait for the object destruction to
> complete before freeing the struct slave itself.
> 
> Fixes: 07699f9a7c8d ("bonding: add sysfs /slave dir for bond slave devices.")
> Fixes: a068aab42258 ("bonding: Fix reference count leak in bond_sysfs_slave_add.")
> Cc: Qiushi Wu <wu000273@umn.edu>
> Cc: Jay Vosburgh <j.vosburgh@gmail.com>
> Cc: Veaceslav Falico <vfalico@gmail.com>
> Cc: Andy Gospodarek <andy@greyhouse.net>
> Signed-off-by: Jamie Iles <jamie@nuviainc.com>
> ---
>  drivers/net/bonding/bond_sysfs_slave.c | 12 ++++++++++++
>  include/net/bonding.h                  |  2 ++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/drivers/net/bonding/bond_sysfs_slave.c b/drivers/net/bonding/bond_sysfs_slave.c
> index 9b8346638f69..2fdbcf9692c5 100644
> --- a/drivers/net/bonding/bond_sysfs_slave.c
> +++ b/drivers/net/bonding/bond_sysfs_slave.c
> @@ -136,7 +136,15 @@ static const struct sysfs_ops slave_sysfs_ops = {
>  	.show = slave_show,
>  };
>  
> +static void slave_release(struct kobject *kobj)
> +{
> +	struct slave *slave = to_slave(kobj);
> +
> +	complete(&slave->kobj_unregister_done);
> +}
> +
>  static struct kobj_type slave_ktype = {
> +	.release = slave_release,
>  #ifdef CONFIG_SYSFS
>  	.sysfs_ops = &slave_sysfs_ops,
>  #endif
> @@ -147,10 +155,12 @@ int bond_sysfs_slave_add(struct slave *slave)
>  	const struct slave_attribute **a;
>  	int err;
>  
> +	init_completion(&slave->kobj_unregister_done);
>  	err = kobject_init_and_add(&slave->kobj, &slave_ktype,
>  				   &(slave->dev->dev.kobj), "bonding_slave");
>  	if (err) {
>  		kobject_put(&slave->kobj);
> +		wait_for_completion(&slave->kobj_unregister_done);
>  		return err;
>  	}
>  
> @@ -158,6 +168,7 @@ int bond_sysfs_slave_add(struct slave *slave)
>  		err = sysfs_create_file(&slave->kobj, &((*a)->attr));
>  		if (err) {
>  			kobject_put(&slave->kobj);
> +			wait_for_completion(&slave->kobj_unregister_done);
>  			return err;
>  		}
>  	}
> @@ -173,4 +184,5 @@ void bond_sysfs_slave_del(struct slave *slave)
>  		sysfs_remove_file(&slave->kobj, &((*a)->attr));
>  
>  	kobject_put(&slave->kobj);
> +	wait_for_completion(&slave->kobj_unregister_done);
>  }
> diff --git a/include/net/bonding.h b/include/net/bonding.h
> index 7d132cc1e584..78d771d2ffd3 100644
> --- a/include/net/bonding.h
> +++ b/include/net/bonding.h
> @@ -25,6 +25,7 @@
>  #include <linux/etherdevice.h>
>  #include <linux/reciprocal_div.h>
>  #include <linux/if_link.h>
> +#include <linux/completion.h>
>  
>  #include <net/bond_3ad.h>
>  #include <net/bond_alb.h>
> @@ -182,6 +183,7 @@ struct slave {
>  #endif
>  	struct delayed_work notify_work;
>  	struct kobject kobj;
> +	struct completion kobj_unregister_done;
>  	struct rtnl_link_stats64 slave_stats;
>  };


This seems weird, are we going to wait for a completion while RTNL is held ?
I am pretty sure this could be exploited by malicious user/syzbot.

The .release() handler could instead perform a refcounted
bond_free_slave() action.



