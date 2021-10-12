Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62045429E63
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 09:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233801AbhJLHQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 03:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233775AbhJLHQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 03:16:50 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F66C061570
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 00:14:49 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1maBzk-0002MU-3d; Tue, 12 Oct 2021 09:14:40 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1maBzi-0007ok-Fh; Tue, 12 Oct 2021 09:14:38 +0200
Date:   Tue, 12 Oct 2021 09:14:38 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     alexandru.tachici@analog.com
Cc:     andrew@lunn.ch, davem@davemloft.net, devicetree@vger.kernel.org,
        hkallweit1@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, robh+dt@kernel.org
Subject: Re: [PATCH v3 3/8] net: phy: Add BaseT1 auto-negotiation registers
Message-ID: <20211012071438.GB938@pengutronix.de>
References: <20211011142215.9013-1-alexandru.tachici@analog.com>
 <20211011142215.9013-4-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211011142215.9013-4-alexandru.tachici@analog.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:53:18 up 236 days, 10:17, 115 users,  load average: 0.45, 0.49,
 0.41
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 11, 2021 at 05:22:10PM +0300, alexandru.tachici@analog.com wrote:
> From: Alexandru Tachici <alexandru.tachici@analog.com>
> 
> Added BASE-T1 AN advertisement register (Registers 7.514, 7.515, and
> 7.516) and BASE-T1 AN LP Base Page ability register (Registers 7.517,
> 7.518, and 7.519).
> 
> Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
> ---
>  include/uapi/linux/mdio.h | 40 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
> 
> diff --git a/include/uapi/linux/mdio.h b/include/uapi/linux/mdio.h
> index 8ae82fe3aece..58ac5cdf7eb4 100644
> --- a/include/uapi/linux/mdio.h
> +++ b/include/uapi/linux/mdio.h
> @@ -67,6 +67,14 @@
>  #define MDIO_AN_10GBT_STAT	33	/* 10GBASE-T auto-negotiation status */
>  #define MDIO_PMA_10T1L_STAT	2295	/* 10BASE-T1L PMA status */
>  #define MDIO_PCS_10T1L_CTRL	2278	/* 10BASE-T1L PCS control */
> +#define MDIO_AN_T1_CTRL		512	/* BASE-T1 AN control */
> +#define MDIO_AN_T1_STAT		513	/* BASE-T1 AN status */
> +#define MDIO_AN_T1_ADV_L	514	/* BASE-T1 AN advertisement register [15:0] */
> +#define MDIO_AN_T1_ADV_M	515	/* BASE-T1 AN advertisement register [31:16] */
> +#define MDIO_AN_T1_ADV_H	516	/* BASE-T1 AN advertisement register [47:32] */
> +#define MDIO_AN_T1_LP_L		517	/* BASE-T1 AN LP's base page register [15:0] */
> +#define MDIO_AN_T1_LP_M		518	/* BASE-T1 AN LP's base page register [31:16] */
> +#define MDIO_AN_T1_LP_H		519	/* BASE-T1 AN LP's base page register [47:32] */

Please use same wording as in the spec: "BASE-T1 AN LP Base Page ability
register".

>  /* LASI (Link Alarm Status Interrupt) registers, defined by XENPAK MSA. */
>  #define MDIO_PMA_LASI_RXCTRL	0x9000	/* RX_ALARM control */
> @@ -278,6 +286,38 @@
>  #define MDIO_PCS_10T1L_CTRL_LB		0x4000	/* Enable PCS level loopback mode */
>  #define MDIO_PCS_10T1L_CTRL_RESET	0x8000	/* PCS reset */
>  
> +/* BASE-T1 auto-negotiation advertisement register [15:0] */
> +#define MDIO_AN_T1_ADV_L_PAUSE_CAP	ADVERTISE_PAUSE_CAP
> +#define MDIO_AN_T1_ADV_L_PAUSE_ASYM	ADVERTISE_PAUSE_ASYM
> +#define MDIO_AN_T1_ADV_L_FORCE_MS	0x1000	/* Force Master/slave Configuration */
> +#define MDIO_AN_T1_ADV_L_REMOTE_FAULT	ADVERTISE_RFAULT
> +#define MDIO_AN_T1_ADV_L_ACK		ADVERTISE_LPACK
> +#define MDIO_AN_T1_ADV_L_NEXT_PAGE_REQ	ADVERTISE_NPAGE
> +
> +/* BASE-T1 auto-negotiation advertisement register [31:16] */
> +#define MDIO_AN_T1_ADV_M_B10L		0x4000	/* device is compatible with 10BASE-T1L */
> +#define MDIO_AN_T1_ADV_M_MST		0x0010	/* advertise master preference */

Hm.. MDIO_AN_T1_ADV_M_MST is T4 of Link codeword Base Page. The spec says:
"Transmitted Nonce Field (T[4:0]) is a 5-bit wide field whose lower 4
bits contains a random or pseudorandom number. A new value shall be
generated for each entry to the Ability Detect state"

Should we actually do it?

> +/* BASE-T1 auto-negotiation advertisement register [47:32] */
> +#define MDIO_AN_T1_ADV_H_10L_TX_HI_REQ	0x1000	/* 10BASE-T1L High Level Transmit Request */
> +#define MDIO_AN_T1_ADV_H_10L_TX_HI	0x2000	/* 10BASE-T1L High Level Transmit Ability */
> +
> +/* BASE-T1 AN LP's base page register [15:0] */
> +#define MDIO_AN_T1_LP_L_PAUSE_CAP	LPA_PAUSE_CAP
> +#define MDIO_AN_T1_LP_L_PAUSE_ASYM	LPA_PAUSE_ASYM
> +#define MDIO_AN_T1_LP_L_FORCE_MS	0x1000	/* LP Force Master/slave Configuration */
> +#define MDIO_AN_T1_LP_L_REMOTE_FAULT	LPA_RFAULT
> +#define MDIO_AN_T1_LP_L_ACK		LPA_LPACK
> +#define MDIO_AN_T1_LP_L_NEXT_PAGE_REQ	LPA_NPAGE
> +
> +/* BASE-T1 AN LP's base page register [31:16] */
> +#define MDIO_AN_T1_LP_M_MST		0x0080	/* LP master preference */

0x0080 is A2 == 1000BASE-T1 ability. Not master preference (T4).

> +#define MDIO_AN_T1_LP_M_B10L		0x4000	/* LP is compatible with 10BASE-T1L */
> +
> +/* BASE-T1 AN LP's base page register [47:32] */
> +#define MDIO_AN_T1_LP_H_10L_TX_HI_REQ	0x1000	/* 10BASE-T1L High Level LP Transmit Request */
> +#define MDIO_AN_T1_LP_H_10L_TX_HI	0x2000	/* 10BASE-T1L High Level LP Transmit Ability */
> +
>  /* EEE Supported/Advertisement/LP Advertisement registers.
>   *
>   * EEE capability Register (3.20), Advertisement (7.60) and
> -- 
> 2.25.1
> 
> 

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
