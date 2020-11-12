Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEC72B11F1
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 23:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgKLWmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 17:42:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgKLWmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 17:42:46 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99265C0613D1;
        Thu, 12 Nov 2020 14:42:46 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id o21so10467037ejb.3;
        Thu, 12 Nov 2020 14:42:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9uIFbwY/aDvICNOe+dyohdf9CD3ZKiy5rbtal4KyUec=;
        b=hjPH1IEw1q+48yggnNsF0VvIje/fklJ3N7wK+2z/3QoXaIF0jkRaPsI7j4pYhQwYsZ
         VQyG1v1ZssLr9Wk0a2Pk2O6RQv1oAb0FreplX9u6BqtWNIk02b8q/LN73YncotR/mp4H
         L/AeE1jpV3bqEx9ZmaWkEdIAgQ7MQK2hdiawdYJn8Bs0Jg4flolUQtLuXtyDP/on9Sh+
         FoKjoY6Jz3A9hy++UBKD6rtmqtnxQzNzZh/F49HwrZ9MjkdD6VKUTUcVF7aSE/v0BYqj
         2fvBTfaATdra26erg0hmMbpTqTPdleYryX4i4YLZ0IDUOhg6iP8KpL0zGAWzNhKmrwtr
         UTqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9uIFbwY/aDvICNOe+dyohdf9CD3ZKiy5rbtal4KyUec=;
        b=sMZOC+fk6GmHt/mbQ8DoqGFUk9gTRt2noHaOsp+BOLfMLBfgzkuehPJ07WrAinQma+
         EL88cW/zRSWTzD2oUqQmhvoXbf1RXkduKCWWzJelZG4BwAfFDmNFHB2zdS/Xv41gZbCM
         29DOcDI4d/Xm9LFZ3g/kc5HJ5o/jTKRAOSs/jhlc1+3fVwLKXb77M2sza4WIBd/54HrE
         dO+Di5pe4ZyEqlxqDZsBUQUfax47T6tASUe9g7EgMHBxW8ZRi8eFPJ/dT7/tu8AyFCQy
         PYHCcX6qn9m1teZE/sN4ARBERFpiOMO+gxpNipi2KLJPo6cvjlDipQH+FHaA5HlOypZw
         TWmA==
X-Gm-Message-State: AOAM5334Qk3qmTftvvk5nQP/bMHqpX3NzY/2K2mSPbIY58vPC3yCWhXi
        Ly9EZGgq3RpV6j37mcAU7Sg=
X-Google-Smtp-Source: ABdhPJw5fghN6w0IhVQiMzse9ol5oPT0cUSXq/kHBww2IzCqi3fWdmBvVsqtoR/WQaBMN3AnXl60YQ==
X-Received: by 2002:a17:907:2063:: with SMTP id qp3mr1642255ejb.314.1605220965351;
        Thu, 12 Nov 2020 14:42:45 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id p1sm2944791edx.4.2020.11.12.14.42.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 14:42:44 -0800 (PST)
Date:   Fri, 13 Nov 2020 00:42:43 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 02/11] net: dsa: microchip: support for
 "ethernet-ports" node
Message-ID: <20201112224243.u6oxe4gnfrv7onkz@skbuf>
References: <20201112153537.22383-1-ceggers@arri.de>
 <20201112153537.22383-3-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112153537.22383-3-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 04:35:28PM +0100, Christian Eggers wrote:
> The dsa.yaml device tree binding allows "ethernet-ports" (preferred) and
> "ports".
>
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> ---
>  drivers/net/dsa/microchip/ksz_common.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> index 71cd1828e25d..a135fd5a9264 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -427,7 +427,9 @@ int ksz_switch_register(struct ksz_device *dev,
>  		ret = of_get_phy_mode(dev->dev->of_node, &interface);
>  		if (ret == 0)
>  			dev->compat_interface = interface;
> -		ports = of_get_child_by_name(dev->dev->of_node, "ports");
> +		ports = of_get_child_by_name(dev->dev->of_node, "ethernet-ports");
> +		if (!ports)
> +			ports = of_get_child_by_name(dev->dev->of_node, "ports");

Man, I didn't think there could be something as uninspired as naming the
private structure of your driver "dev"...

>  		if (ports)
>  			for_each_available_child_of_node(ports, port) {
>  				if (of_property_read_u32(port, "reg",
> --

Either way:

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
