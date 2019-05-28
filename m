Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DCBB2CFE6
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 22:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbfE1UBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 16:01:21 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:34947 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726453AbfE1UBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 16:01:20 -0400
Received: by mail-vs1-f67.google.com with SMTP id q13so119065vso.2
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 13:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=lMGPvzufmojkWxhjR92QUtnyfsMzp3Et8dAEv+gVzv0=;
        b=lQ0Bum2pz/6p6AU6CABWxb6eDsAqwreWNRrUGaipC2ElBt45x7mzTfUZi9XSgy012B
         NYWlxcNdd7NDZNHb+DkiV/QMM//DPwAOEEFbtcQ/OskKbM43QS6TSdHamO/asc0M4Cee
         nZ2ClX4cs2AS1qBvzpWGvpMDOEyDTOpm+xuKslguGUDWncwMcuIPUPyUCYuDWS7Xn2Yh
         Z0PAmr34x7W144uGgKBKoSPjcRj+2VbQkm8incN3LpxVcyizgVtmz8aeGDUPAexXsgnD
         XJVgoioPMCrQe8qi9AGQAoeBJX7l4Yu0u0c8XO4lllgNYUllpaTF384I68jNkSi3MYvw
         BCeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=lMGPvzufmojkWxhjR92QUtnyfsMzp3Et8dAEv+gVzv0=;
        b=m7TqZMOazILAQ1IiOgflA+pVfzBNH8jVBnihPVqEmAnZlLzuzo+4WQTbonufJHdjz2
         i+rjEup6xDXV+KqKVWwuKPlzYG+Rj9KUTEIa09aOUBzoHRSuweGhmi8fQCbhVQi+qn4m
         DoEmJn4ZY4SDp9sYL0QNj0wJJ+s2e9aKi0LVJd5wHcVCZjC7AGhd8tmOvj866Lrhj2xC
         wC5HgkwijY2f7AYZqorXSL372LEw2r3OGepjZPELDHLCduK2Buyj/KpXYWJyQ2oOBnUi
         udOPF8rdtBcXM7pWoEWGbTSXrbNXqKom/IONU+eFVN3zNz0r1z6rUj53XqOA3JsiC+yN
         wLmQ==
X-Gm-Message-State: APjAAAXASAGX4KiGfC0y9MYC0YgEbYLYOYAYzVD0PwkTnMoa2TIpd+wb
        5wYCxsWvXDstD9eqifEwg3bcYw==
X-Google-Smtp-Source: APXvYqzK+jYEsCSfWRA9DTzIp6ezIf4A59nS4hGzrpkJiM856EPnvU83ADqe+Py0afPrGFV9NC8GPA==
X-Received: by 2002:a67:d00e:: with SMTP id r14mr5634vsi.11.1559073679752;
        Tue, 28 May 2019 13:01:19 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id s65sm20442562vkd.36.2019.05.28.13.01.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 28 May 2019 13:01:19 -0700 (PDT)
Date:   Tue, 28 May 2019 13:01:15 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com,
        sthemmin@microsoft.com, dsahern@gmail.com, saeedm@mellanox.com,
        leon@kernel.org, f.fainelli@gmail.com
Subject: Re: [patch net-next v2 7/7] netdevsim: implement fake flash
 updating with notifications
Message-ID: <20190528130115.5062c085@cakuba.netronome.com>
In-Reply-To: <20190528114846.1983-8-jiri@resnulli.us>
References: <20190528114846.1983-1-jiri@resnulli.us>
        <20190528114846.1983-8-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 May 2019 13:48:46 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> ---
> v1->v2:
> - added debugfs toggle to enable/disable flash status notifications

Could you please add a selftest making use of netdevsim code?

Sorry, I must have liked the feature so much first time I missed this :)

> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> index b509b941d5ca..c5c417a3c0ce 100644
> --- a/drivers/net/netdevsim/dev.c
> +++ b/drivers/net/netdevsim/dev.c
> @@ -38,6 +38,8 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
>  	nsim_dev->ports_ddir = debugfs_create_dir("ports", nsim_dev->ddir);
>  	if (IS_ERR_OR_NULL(nsim_dev->ports_ddir))
>  		return PTR_ERR_OR_ZERO(nsim_dev->ports_ddir) ?: -EINVAL;
> +	debugfs_create_bool("fw_update_status", 0600, nsim_dev->ddir,
> +			    &nsim_dev->fw_update_status);
>  	return 0;
>  }
>  
> @@ -220,8 +222,49 @@ static int nsim_dev_reload(struct devlink *devlink,
>  	return 0;
>  }
>  
> +#define NSIM_DEV_FLASH_SIZE 500000
> +#define NSIM_DEV_FLASH_CHUNK_SIZE 1000
> +#define NSIM_DEV_FLASH_CHUNK_TIME_MS 10
> +
> +static int nsim_dev_flash_update(struct devlink *devlink, const char *file_name,
> +				 const char *component,
> +				 struct netlink_ext_ack *extack)
> +{
> +	struct nsim_dev *nsim_dev = devlink_priv(devlink);
> +	int i;
> +
> +	if (nsim_dev->fw_update_status) {
> +		devlink_flash_update_begin_notify(devlink);
> +		devlink_flash_update_status_notify(devlink,
> +						   "Preparing to flash",
> +						   component, 0, 0);
> +	}
> +
> +	for (i = 0; i < NSIM_DEV_FLASH_SIZE / NSIM_DEV_FLASH_CHUNK_SIZE; i++) {
> +		if (nsim_dev->fw_update_status)
> +			devlink_flash_update_status_notify(devlink, "Flashing",
> +							   component,
> +							   i * NSIM_DEV_FLASH_CHUNK_SIZE,
> +							   NSIM_DEV_FLASH_SIZE);
> +		msleep(NSIM_DEV_FLASH_CHUNK_TIME_MS);

In automated testing it may be a little annoying if this takes > 5sec

> +	}
> +
> +	if (nsim_dev->fw_update_status) {
> +		devlink_flash_update_status_notify(devlink, "Flashing",
> +						   component,
> +						   NSIM_DEV_FLASH_SIZE,
> +						   NSIM_DEV_FLASH_SIZE);
> +		devlink_flash_update_status_notify(devlink, "Flashing done",
> +						   component, 0, 0);
> +		devlink_flash_update_end_notify(devlink);
> +	}
> +
> +	return 0;
> +}
> +
>  static const struct devlink_ops nsim_dev_devlink_ops = {
>  	.reload = nsim_dev_reload,
> +	.flash_update = nsim_dev_flash_update,
>  };
>  
>  static struct nsim_dev *
