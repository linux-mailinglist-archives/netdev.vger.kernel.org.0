Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF8922C50DF
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 10:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389131AbgKZJCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 04:02:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389113AbgKZJCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 04:02:49 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F3BC0617A7
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 01:02:48 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id i2so1277705wrs.4
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 01:02:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=references:user-agent:from:to:cc:subject:in-reply-to:message-id
         :date:mime-version;
        bh=GFyCHi/uBU1dtOcUSYpx65nLIeE0S+Y9gUbYQTFljb0=;
        b=j9d9YS49slF6glftrGUPhNlLNKLxwo0LbWOgMai+Dj2szvu3yv1dneZpHyyZnCPnI9
         TEb4Ua8IM28iztZzrGLOKgglT40/xDKvF28qKzvcDIlkEgaSzfdowuYX60/PQxaMXGS2
         qKjDGJ6TuOtoU9BIYAcXRmmDTQ1nu12VOT0No3UYQ0wA2t+DxoZrpKj6mQe75GT67qNN
         oM0kIIEgqujWcDrNl75vc751AQa8EDzJGpIPxn0AIv6EbzF+xpY7tQ9x3TJXKQOcbBSz
         0UyG3aTzA57/UG9bgSLc76DgnGWc0PowTtkHsA4CtFIIjBuwP/P0fCqxieL0zuWvuR2p
         8Nww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:message-id:date:mime-version;
        bh=GFyCHi/uBU1dtOcUSYpx65nLIeE0S+Y9gUbYQTFljb0=;
        b=M8RterTAUuLGX3Ini8k3lfm1fWzgALPROldev+ruwuRPBYemWhggytE3NUcxtIFd3T
         Xv31aofHE7xGm5e3f4c7l1CgDBG1XvIMQUU3ujqu331d78CiFoyLhvqlgWAskLPGkQaW
         vZ5ndu2fFmlfUn7+fgaFisVXl+HhrXsRsXST95cptlnADxHqrOvb56I+mm3Gp95qepes
         ZQV3zpMaI2Gjs4PCJoQ9RdK9Bq2KqPP6bFXhDl796ZEzCbdL26gCg1fDa/aPDsfkgz+k
         dXT4CZGO5ywSUnWHyKi9+ypJJfSfdPDaolnBKM5uNMQ3SOlgHXwLpKAvAerAGuR/tRW1
         zv8A==
X-Gm-Message-State: AOAM533+lcsgM9TT/PaR8xXK+DGGuw0tl0UBmWxhKtJ0Y1JVulky0Fhn
        fF+yJ3JMY6vc//RmmmVR5AYS/w==
X-Google-Smtp-Source: ABdhPJziBTTVxWQQnfbQPFNqaoBuTqg7asyjyHqQLwLCs96p1DtgCmBzGo7d2qW7QvmtM/nbRnpyaA==
X-Received: by 2002:a5d:6250:: with SMTP id m16mr2597470wrv.400.1606381366987;
        Thu, 26 Nov 2020 01:02:46 -0800 (PST)
Received: from localhost (253.35.17.109.rev.sfr.net. [109.17.35.253])
        by smtp.gmail.com with ESMTPSA id e1sm8912528wra.22.2020.11.26.01.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 01:02:46 -0800 (PST)
References: <20201123153817.1616814-1-ciorneiioana@gmail.com>
 <20201123153817.1616814-7-ciorneiioana@gmail.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Jerome Brunet <jbrunet@baylibre.com>
To:     Ioana Ciornei <ciorneiioana@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Neil Armstrong <narmstrong@baylibre.com>
Subject: Re: [PATCH net-next 06/15] net: phy: meson-gxl: remove the use of
 .ack_callback()
In-reply-to: <20201123153817.1616814-7-ciorneiioana@gmail.com>
Message-ID: <1jim9s8p8r.fsf@starbuckisacylon.baylibre.com>
Date:   Thu, 26 Nov 2020 10:02:44 +0100
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Mon 23 Nov 2020 at 16:38, Ioana Ciornei <ciorneiioana@gmail.com> wrote:

> From: Ioana Ciornei <ioana.ciornei@nxp.com>
>
> In preparation of removing the .ack_interrupt() callback, we must replace
> its occurrences (aka phy_clear_interrupt), from the 2 places where it is
> called from (phy_enable_interrupts and phy_disable_interrupts), with
> equivalent functionality.
>
> This means that clearing interrupts now becomes something that the PHY
> driver is responsible of doing, before enabling interrupts and after
> clearing them. Make this driver follow the new contract.
>
> Cc: Jerome Brunet <jbrunet@baylibre.com>
> Cc: Neil Armstrong <narmstrong@baylibre.com>
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
>  drivers/net/phy/meson-gxl.c | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/meson-gxl.c
> index b16b1cc89165..7e7904fee1d9 100644
> --- a/drivers/net/phy/meson-gxl.c
> +++ b/drivers/net/phy/meson-gxl.c
> @@ -204,22 +204,27 @@ static int meson_gxl_config_intr(struct phy_device *phydev)
>  	int ret;
>  
>  	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
> +		/* Ack any pending IRQ */
> +		ret = meson_gxl_ack_interrupt(phydev);
> +		if (ret)
> +			return ret;
> +
>  		val = INTSRC_ANEG_PR
>  			| INTSRC_PARALLEL_FAULT
>  			| INTSRC_ANEG_LP_ACK
>  			| INTSRC_LINK_DOWN
>  			| INTSRC_REMOTE_FAULT
>  			| INTSRC_ANEG_COMPLETE;
> +		ret = phy_write(phydev, INTSRC_MASK, val);
>  	} else {
>  		val = 0;
> -	}
> +		ret = phy_write(phydev, INTSRC_MASK, val);
>  
> -	/* Ack any pending IRQ */
> -	ret = meson_gxl_ack_interrupt(phydev);
> -	if (ret)
> -		return ret;
> +		/* Ack any pending IRQ */
> +		ret = meson_gxl_ack_interrupt(phydev);
> +	}
>  
> -	return phy_write(phydev, INTSRC_MASK, val);
> +	return ret;

The only thing the above does is clear the irq *after* writing INTSRC_MASK
*only* when the interrupts are not enabled. If that was not the intent,
please let me know.

As it stands, I don't think this hunk is necessary and I would prefer if
it was not included.

>  }
>  
>  static irqreturn_t meson_gxl_handle_interrupt(struct phy_device *phydev)
> @@ -249,7 +254,6 @@ static struct phy_driver meson_gxl_phy[] = {
>  		.soft_reset     = genphy_soft_reset,
>  		.config_init	= meson_gxl_config_init,
>  		.read_status	= meson_gxl_read_status,
> -		.ack_interrupt	= meson_gxl_ack_interrupt,
>  		.config_intr	= meson_gxl_config_intr,
>  		.handle_interrupt = meson_gxl_handle_interrupt,
>  		.suspend        = genphy_suspend,
> @@ -260,7 +264,6 @@ static struct phy_driver meson_gxl_phy[] = {
>  		/* PHY_BASIC_FEATURES */
>  		.flags		= PHY_IS_INTERNAL,
>  		.soft_reset     = genphy_soft_reset,
> -		.ack_interrupt	= meson_gxl_ack_interrupt,
>  		.config_intr	= meson_gxl_config_intr,
>  		.handle_interrupt = meson_gxl_handle_interrupt,
>  		.suspend        = genphy_suspend,

