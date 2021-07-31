Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A250F3DC698
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 17:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233253AbhGaPYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 11:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233035AbhGaPYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 11:24:18 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 878D2C06175F;
        Sat, 31 Jul 2021 08:24:10 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id n11so7782371wmd.2;
        Sat, 31 Jul 2021 08:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DG4A4tNX9wbSgsJJ/yJib+8x4YVCnaUAeYlAsPRh2hc=;
        b=tp3gS877v7M4UEpsnZt2SUK4rQGqT//xubcPqN9NfoQNX1gum2qZVZFYZ9nW8v4v5y
         l0dPRYLNqPm2X7ech+VtDHaGYkgWs+aTTmqbarmE0J+PL9auXfWpGQwD59LGN5cJWr7K
         LF/d4grCv2qP9/N8kaEej5xnHCh8J+7pY/hv16UnRZXuDw4PXFTA1LMMNTx/PcGTvjiG
         Nqks2+gRCjMDg3FKb/0nIATesSRNRjbOXNtK095IJYSKZu4Lr+QeHZW9XYvw71xJsVgN
         onEg0zrdVQPu2RfmUsdUdhnQcCk9p1pSnaUhJ3mwpo4gniB4CVBrIC1a+wQVWf4JwUv8
         kHsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DG4A4tNX9wbSgsJJ/yJib+8x4YVCnaUAeYlAsPRh2hc=;
        b=YXkj7lZ6ZA9FsbRA6zXkhHtBe67J2nwbEsWgYD4EUo5s4+ay4Y3rqbUpOFoaVq3KJI
         1Z1ZJ+3T9ONECmJ7f3NuqjJSfToMilL+PV+DunLSxosrYEVjx9z63pgzndLRbJGn5QTz
         m6j6OFudLoAtvbUGsCrQGaeWo1z8IXh17QPATTQ9E5T+8PqP2WapqcF9opyqb3eILtvo
         jE1zsKsb4WROBnTM59ubqwCDEwPSuO+g68g4cqXTIdJXyqqZykkTAbRviJVQOXrnjZsB
         obsqx+fX/R1rdvJ63tN5HnMR84O+xGIl8enrbRDpGweFo0TMOTwo4qMylkKSiZaUd0UV
         Rqyg==
X-Gm-Message-State: AOAM531MQr0rNs0p8fD89ic+tr8QfhuMn78GfnJTrDikV9/xAxw12UF1
        /n/Z8gsKvRrt7aKQVa2R3sM=
X-Google-Smtp-Source: ABdhPJxP3vNjMX+MWJfAm5qDmhCZ8BO3ZF30bp0VS6xU0JUdgyg6K2Z/6zM6I8lCzlenEorawYZBGA==
X-Received: by 2002:a7b:cd14:: with SMTP id f20mr8443280wmj.113.1627745049058;
        Sat, 31 Jul 2021 08:24:09 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id n8sm4845267wms.11.2021.07.31.08.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 08:24:08 -0700 (PDT)
Date:   Sat, 31 Jul 2021 18:24:07 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, Woojung.Huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 net-next 08/10] net: dsa: microchip: add support for
 port mirror operations
Message-ID: <20210731152407.t2shn7filil5ztrb@skbuf>
References: <20210723173108.459770-1-prasanna.vengateshan@microchip.com>
 <20210723173108.459770-9-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210723173108.459770-9-prasanna.vengateshan@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 11:01:06PM +0530, Prasanna Vengateshan wrote:
> Added support for port_mirror_add() and port_mirror_del operations
> 
> Sniffing is limited to one port & alert the user if any new
> sniffing port is selected
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> ---
>  drivers/net/dsa/microchip/lan937x_main.c | 83 ++++++++++++++++++++++++
>  1 file changed, 83 insertions(+)
> 
> diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
> index 3380a4617725..171c46f37fa4 100644
> --- a/drivers/net/dsa/microchip/lan937x_main.c
> +++ b/drivers/net/dsa/microchip/lan937x_main.c
> @@ -129,6 +129,87 @@ static void lan937x_port_stp_state_set(struct dsa_switch *ds, int port,
>  	mutex_unlock(&dev->dev_mutex);
>  }
>  
> +static int lan937x_port_mirror_add(struct dsa_switch *ds, int port,
> +				   struct dsa_mall_mirror_tc_entry *mirror,
> +				   bool ingress)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	int ret, p;
> +	u8 data;
> +
> +	/* Configure ingress/egress mirroring*/
> +	if (ingress)
> +		ret = lan937x_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_RX,
> +				       true);
> +	else
> +		ret = lan937x_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_TX,
> +				       true);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Configure sniffer port meanwhile limit to one sniffer port
> +	 * Check if any of the port is already set for sniffing
> +	 * If yes, instruct the user to remove the previous entry & exit
> +	 */
> +	for (p = 0; p < dev->port_cnt; p++) {
> +		/*Skip the current sniffing port*/
> +		if (p == mirror->to_local_port)
> +			continue;
> +
> +		ret = lan937x_pread8(dev, p, P_MIRROR_CTRL, &data);
> +		if (ret < 0)
> +			return ret;
> +
> +		if (data & PORT_MIRROR_SNIFFER) {
> +			dev_err(dev->dev,
> +				"Delete existing rules towards %s & try\n",
> +				dsa_to_port(ds, p)->name);
> +			return -EBUSY;
> +		}
> +	}

I think this check should be placed before you enable
PORT_MIRROR_RX/PORT_MIRROR_TX.

> +
> +	ret = lan937x_port_cfg(dev, mirror->to_local_port, P_MIRROR_CTRL,
> +			       PORT_MIRROR_SNIFFER, true);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = lan937x_cfg(dev, S_MIRROR_CTRL, SW_MIRROR_RX_TX, false);
> +
> +	return ret;

You can forgo an assignment to "ret" here and do "return lan937x_cfg(...)"
