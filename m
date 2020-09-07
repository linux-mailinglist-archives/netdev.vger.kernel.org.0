Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02AC825F3C3
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 09:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgIGHTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 03:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgIGHTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 03:19:42 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F668C061573
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 00:19:41 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id w5so14602381wrp.8
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 00:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iHAh9k3RLvG0ayLeESM8RhfwH1hL5cASS4K5eiNZw6s=;
        b=TuhOSMmUrglov49OE2JxL7acpRJDCZpoo6uZrI/5y59J2xZpiUcY5tOpHfifRKbVl/
         DrTefRkoawXlbfi3LuZEP6431LfLXLKYHO5ggaHNmsfYVLpBQ0lbegwoyTVdednBhzVi
         m8kWVXJnILySGqlfZzdhliVMxPXcIIZ0rTE+IHRlguq/8OioYO6t40uNfLr9CO9XSX07
         GlXePGJOlPDJyJ9xlZl131FV6raIF4wm35VOC1LGDDcApW0Ak+6xes8CnnTeJfyRtriw
         34kNdu1AlfMYyCHu0zl5qu/gtH7U20FGX6YRkywMgqGIXr4YX8+XxCtGH1/7shZPTneN
         pY0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iHAh9k3RLvG0ayLeESM8RhfwH1hL5cASS4K5eiNZw6s=;
        b=jfY82dwJ208niijU2yqjY+phdTtyaJU2z8i5vph9CgATVpNbAlPM9h+h3+7AX26Vf0
         nIrvfGy4SyMEMXALGDNsXtfr5J2c/pA61TJFt9ba4FUUVrljJP5K+NDoD2Gx5fWBFrv6
         1rqrnKqzV+gJ3N/ZbkyupSvn1UCiklRqlfXSS8YeLpGVJ2exx1oDwK3wZl7mkQrqOpjL
         xpISEDYiu2Fd34dhicI9j8NyXpnc2aQXGCQL5xZ9nggRYCx9H7UwQQuQamg6caeACxiL
         LwLkkV0YbJv5f+jIO59gwCZxJtd9Jj+uPgyZCh2vwqGS2dHlbPnaNrtzpdjGdYaZz83a
         i82g==
X-Gm-Message-State: AOAM532eKlldLCPxnmM/0pRw3fDtBRgf1q1U5mqjIRBZ5/oMJ/rGJu1p
        TZ19U3vpKlqXoag9dljGJi3ocA==
X-Google-Smtp-Source: ABdhPJyc4EXJ6y51A5Y0W0GQqdg91GUCHHC8SUh4xBc7IiZtePR/n0A/3WAS3DV1PQFpFwKeoRVDGg==
X-Received: by 2002:a5d:6784:: with SMTP id v4mr14614478wru.215.1599463180209;
        Mon, 07 Sep 2020 00:19:40 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id o4sm23240591wru.55.2020.09.07.00.19.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 00:19:39 -0700 (PDT)
Date:   Mon, 7 Sep 2020 09:19:39 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, kernel-team@fb.com, tariqt@mellanox.com,
        yishaih@mellanox.com, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next] mlx4: make sure to always set the port type
Message-ID: <20200907071939.GK2997@nanopsycho.orion>
References: <20200904200621.2407839-1-kuba@kernel.org>
 <20200906072759.GC55261@unreal>
 <20200906093305.5c901cc5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200907062135.GJ2997@nanopsycho.orion>
 <20200907064830.GK55261@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200907064830.GK55261@unreal>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Sep 07, 2020 at 08:48:30AM CEST, leon@kernel.org wrote:
>On Mon, Sep 07, 2020 at 08:21:35AM +0200, Jiri Pirko wrote:
>> Sun, Sep 06, 2020 at 06:33:05PM CEST, kuba@kernel.org wrote:
>> >On Sun, 6 Sep 2020 10:27:59 +0300 Leon Romanovsky wrote:
>> >> On Fri, Sep 04, 2020 at 01:06:21PM -0700, Jakub Kicinski wrote:
>> >> > Even tho mlx4_core registers the devlink ports, it's mlx4_en
>> >> > and mlx4_ib which set their type. In situations where one of
>> >> > the two is not built yet the machine has ports of given type
>> >> > we see the devlink warning from devlink_port_type_warn() trigger.
>> >> >
>> >> > Having ports of a type not supported by the kernel may seem
>> >> > surprising, but it does occur in practice - when the unsupported
>> >> > port is not plugged in to a switch anyway users are more than happy
>> >> > not to see it (and potentially allocate any resources to it).
>> >> >
>> >> > Set the type in mlx4_core if type-specific driver is not built.
>> >> >
>> >> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>> >> > ---
>> >> >  drivers/net/ethernet/mellanox/mlx4/main.c | 11 +++++++++++
>> >> >  1 file changed, 11 insertions(+)
>> >> >
>> >> > diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
>> >> > index 258c7a96f269..70cf24ba71e4 100644
>> >> > --- a/drivers/net/ethernet/mellanox/mlx4/main.c
>> >> > +++ b/drivers/net/ethernet/mellanox/mlx4/main.c
>> >> > @@ -3031,6 +3031,17 @@ static int mlx4_init_port_info(struct mlx4_dev *dev, int port)
>> >> >  	if (err)
>> >> >  		return err;
>> >> >
>> >> > +	/* Ethernet and IB drivers will normally set the port type,
>> >> > +	 * but if they are not built set the type now to prevent
>> >> > +	 * devlink_port_type_warn() from firing.
>> >> > +	 */
>> >> > +	if (!IS_ENABLED(CONFIG_MLX4_EN) &&
>> >> > +	    dev->caps.port_type[port] == MLX4_PORT_TYPE_ETH)
>> >> > +		devlink_port_type_eth_set(&info->devlink_port, NULL);
>> >>                                                                ^^^^^
>> >>
>> >> Won't it crash in devlink_port_type_eth_set()?
>> >> The first line there dereferences pointer.
>> >>   7612         const struct net_device_ops *ops = netdev->netdev_ops;
>> >
>> >Damn, good catch. It's not supposed to be required. I'll patch devlink.
>>
>> When you set the port type to ethernet, you should have the net_device
>> instance. Why wouldn't you?
>
>It is how mlx4 is implemented, see mlx4_dev_cap() function:
>588         for (i = 1; i <= dev->caps.num_ports; ++i) {
>589                 dev->caps.port_type[i] = MLX4_PORT_TYPE_NONE;
>....
>
>The port type is being set to IB or ETH without relation to net_device,
>fixing it will require very major code rewrite for the stable driver
>that in maintenance mode.

Because the eth driver is not loaded, I see. The purpose of the
WARN in devlink_port_type_eth_set is to prevent drivers from registering
particular port without netdev/ibdev. That is what was repeatedly
happening in the past as the driver developers didn't know they need to
do it or were just lazy to do so.

I wonder if there is any possibility to do both...

>
>>
>>
>> >
>> >> And can we call to devlink_port_type_*_set() without IS_ENABLED() check?
>> >
>> >It'll generate two netlink notifications - not the end of the world but
>> >also doesn't feel super clean.
>
>I would say that such a situation is corner case during the driver init and
>not an end of the world to see double netlink message.
>
>Thanks
