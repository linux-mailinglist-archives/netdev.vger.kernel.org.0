Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16F5A28546
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 19:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731403AbfEWRsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 13:48:00 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:35809 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730899AbfEWRsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 13:48:00 -0400
Received: by mail-qt1-f194.google.com with SMTP id a39so7789436qtk.2
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 10:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=qaXm/mkC9LLLL+7D5uwNYb3o5bUaaKf/+AX8bXOLWVM=;
        b=OeJVRpwSiq/smYXhNiceTGHSBxeznz2wuFiisL/FPLyKUaW1tUbXbjxW0MHqj/vf/3
         iQoTcGpZpT1eTcV4SaEN2bemi+Jq5wMPa7awGeHxejmDPHKGB4gSUNEdcZjJmcnJ29Vr
         Ecb5RuNx7sym7VDpb6bJDAy6skc6H1WHjDwruXM1cUzVLjQ0LzNCjGIVtNgpORFJeC8q
         8zgrXIJSGxy1HW6Fh6zDLUzOV3d4BvmQoTfd0JzlDSYo1tiCP1yNR4vBiSS49dqcAvF0
         OrV5TIwvOkndhPQOMB4iO6yCx9pyeadfq/Tg7gUblYWh54mjw5CQQidNDVQVV3rohvHG
         GNPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=qaXm/mkC9LLLL+7D5uwNYb3o5bUaaKf/+AX8bXOLWVM=;
        b=pwNWHluvLGT2ORkl+DcVtJmGW6M6Wqhgeij0fgyWLXUZCYLoLIQ67A/iPAGCosM4iY
         cjtZEbtsNyzEKwH+rZdzfdfWww6gRaaw6H5VNlvZ70pIVP0Sxg0PFNvaD//KJEIn0+eJ
         bXIisEI0eNRoGz+j0G2sPu+b9F8yYhz64viRXpgtyXTcHo0jp8m3Nmt9V+W4dgQYmGZD
         6Xfqo0QTLidM40oIUcaH7bWRWaJLZDtrHHruxsuZ0G/ESSI2RNceiAwhMh53jbW/kMyc
         sY7fZrdFd/GCOzFXNGiLkiXWYEyXrpjf/eNXQyi8I//bQuAk+oTPsOZutR6Ksn2RXK4p
         F6Zw==
X-Gm-Message-State: APjAAAUP5GSZY7v7Nq6d82WPnwKgrl4sYLtPwbsx2HnIIyYkaK6qtucE
        otZryZ/zkras4mqTnN93cCQ1Uw==
X-Google-Smtp-Source: APXvYqyAc/GdZ5XNwNJWxZEFiFkeCULHpgIF4qcdOkfhrZVBH0R5dnGHCEgzbblGUCqfwLP7JX0RFQ==
X-Received: by 2002:ac8:65c1:: with SMTP id t1mr83041071qto.13.1558633679482;
        Thu, 23 May 2019 10:47:59 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o13sm15175597qtk.74.2019.05.23.10.47.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 23 May 2019 10:47:59 -0700 (PDT)
Date:   Thu, 23 May 2019 10:47:54 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com,
        sthemmin@microsoft.com, dsahern@gmail.com, saeedm@mellanox.com,
        leon@kernel.org
Subject: Re: [patch net-next 7/7] netdevsim: implement fake flash updating
 with notifications
Message-ID: <20190523104754.73202b23@cakuba.netronome.com>
In-Reply-To: <20190523094510.2317-8-jiri@resnulli.us>
References: <20190523094510.2317-1-jiri@resnulli.us>
        <20190523094510.2317-8-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 May 2019 11:45:10 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  drivers/net/netdevsim/dev.c | 35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> index b509b941d5ca..c15b86f9cd2b 100644
> --- a/drivers/net/netdevsim/dev.c
> +++ b/drivers/net/netdevsim/dev.c
> @@ -220,8 +220,43 @@ static int nsim_dev_reload(struct devlink *devlink,
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
> +	int i;
> +
> +	devlink_flash_update_begin_notify(devlink);

Now I wonder if it would be good for the core to send those.  Is it
down to the driver to send the begin/end notifications because it would
be wasteful to always send them, or is it some ABI thing?

Also I wonder if it'd be useful for netdevsim to have a mode which
doesn't send notifications, to test both cases.

> +	devlink_flash_update_status_notify(devlink, "Preparing to flash",
> +					   component, 0, 0);
> +	for (i = 0; i < NSIM_DEV_FLASH_SIZE / NSIM_DEV_FLASH_CHUNK_SIZE; i++) {
> +		devlink_flash_update_status_notify(devlink, "Flashing",
> +						   component,
> +						   i * NSIM_DEV_FLASH_CHUNK_SIZE,
> +						   NSIM_DEV_FLASH_SIZE);
> +		msleep(NSIM_DEV_FLASH_CHUNK_TIME_MS);
> +	}
> +	devlink_flash_update_status_notify(devlink, "Flashing",
> +					   component,
> +					   NSIM_DEV_FLASH_SIZE,
> +					   NSIM_DEV_FLASH_SIZE);
> +
> +	devlink_flash_update_status_notify(devlink, "Flashing done",
> +					   component, 0, 0);
> +
> +	devlink_flash_update_end_notify(devlink);
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

