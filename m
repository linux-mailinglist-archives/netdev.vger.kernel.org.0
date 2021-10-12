Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C4E429DD6
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 08:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233321AbhJLGjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 02:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232340AbhJLGja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 02:39:30 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D5EC061570
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 23:37:29 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1maBPY-00073T-Kh; Tue, 12 Oct 2021 08:37:16 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1maBPW-0004VF-72; Tue, 12 Oct 2021 08:37:14 +0200
Date:   Tue, 12 Oct 2021 08:37:14 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     alexandru.tachici@analog.com
Cc:     andrew@lunn.ch, davem@davemloft.net, devicetree@vger.kernel.org,
        hkallweit1@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, robh+dt@kernel.org
Subject: Re: [PATCH v3 2/8] net: phy: Add 10-BaseT1L registers
Message-ID: <20211012063714.GA938@pengutronix.de>
References: <20211011142215.9013-1-alexandru.tachici@analog.com>
 <20211011142215.9013-3-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211011142215.9013-3-alexandru.tachici@analog.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:31:32 up 236 days,  9:55, 106 users,  load average: 0.16, 0.15,
 0.14
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 11, 2021 at 05:22:09PM +0300, alexandru.tachici@analog.com wrote:
> From: Alexandru Tachici <alexandru.tachici@analog.com>
> 
> The 802.3gc specification defines the 10-BaseT1L link
> mode for ethernet trafic on twisted wire pair.
> 
> PMA status register can be used to detect if the phy supports
> 2.4 V TX level and PCS control register can be used to
> enable/disable PCS level loopback.
> 
> Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>

Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>
Thank you!

Question on maintainers: IEEE 802.3 spec, documents register bits in the
little-endian order. In the mdio.h we use big-endian, it makes
comparison with the spec a bit more challenging. May be we should fix
it?

Regards,
Oleksij

> ---
>  include/uapi/linux/mdio.h | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/include/uapi/linux/mdio.h b/include/uapi/linux/mdio.h
> index bdf77dffa5a4..8ae82fe3aece 100644
> --- a/include/uapi/linux/mdio.h
> +++ b/include/uapi/linux/mdio.h
> @@ -65,6 +65,8 @@
>  #define MDIO_PCS_10GBRT_STAT2	33	/* 10GBASE-R/-T PCS status 2 */
>  #define MDIO_AN_10GBT_CTRL	32	/* 10GBASE-T auto-negotiation control */
>  #define MDIO_AN_10GBT_STAT	33	/* 10GBASE-T auto-negotiation status */
> +#define MDIO_PMA_10T1L_STAT	2295	/* 10BASE-T1L PMA status */
> +#define MDIO_PCS_10T1L_CTRL	2278	/* 10BASE-T1L PCS control */
>  
>  /* LASI (Link Alarm Status Interrupt) registers, defined by XENPAK MSA. */
>  #define MDIO_PMA_LASI_RXCTRL	0x9000	/* RX_ALARM control */
> @@ -262,6 +264,20 @@
>  #define MDIO_AN_10GBT_STAT_MS		0x4000	/* Master/slave config */
>  #define MDIO_AN_10GBT_STAT_MSFLT	0x8000	/* Master/slave config fault */
>  
> +/* 10BASE-T1L PMA status register. */
> +#define MDIO_PMA_10T1L_STAT_LINK	0x0001	/* PMA receive link up */
> +#define MDIO_PMA_10T1L_STAT_FAULT	0x0002	/* Fault condition detected */
> +#define MDIO_PMA_10T1L_STAT_POLARITY	0x0004	/* Receive polarity is reversed */
> +#define MDIO_PMA_10T1L_STAT_RECV_FAULT	0x0200	/* Able to detect fault on receive path */
> +#define MDIO_PMA_10T1L_STAT_EEE		0x0400	/* PHY has EEE ability */
> +#define MDIO_PMA_10T1L_STAT_LOW_POWER	0x0800	/* PMA has low-power ability */
> +#define MDIO_PMA_10T1L_STAT_2V4_ABLE	0x1000	/* PHY has 2.4 Vpp operating mode ability */
> +#define MDIO_PMA_10T1L_STAT_LB_ABLE	0x2000	/* PHY has loopback ability */
> +
> +/* 10BASE-T1L PCS control register. */
> +#define MDIO_PCS_10T1L_CTRL_LB		0x4000	/* Enable PCS level loopback mode */
> +#define MDIO_PCS_10T1L_CTRL_RESET	0x8000	/* PCS reset */
> +
>  /* EEE Supported/Advertisement/LP Advertisement registers.
>   *
>   * EEE capability Register (3.20), Advertisement (7.60) and
> -- 
> 2.25.1 



-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
