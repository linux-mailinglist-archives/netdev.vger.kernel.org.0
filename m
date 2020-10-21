Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5571294DB4
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 15:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441769AbgJUNiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 09:38:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38130 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410328AbgJUNiE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 09:38:04 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kVEJS-002p6h-RO; Wed, 21 Oct 2020 15:37:58 +0200
Date:   Wed, 21 Oct 2020 15:37:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Greg Ungerer <gerg@linux-m68k.org>
Cc:     Chris Heally <cphealy@gmail.com>, netdev@vger.kernel.org,
        Fugang Duan <fugang.duan@nxp.com>
Subject: Re: [PATCH] net: ethernet: fec: Replace interrupt driven MDIO with
 polled IO
Message-ID: <20201021133758.GL139700@lunn.ch>
References: <c8143134-1df9-d3bc-8ce7-79cb71148d49@linux-m68k.org>
 <20201020024000.GV456889@lunn.ch>
 <9fa61ea8-11b4-ef3c-c04e-cb124490c9ae@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9fa61ea8-11b4-ef3c-c04e-cb124490c9ae@linux-m68k.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	if (fep->quirks & FEC_QUIRK_CLEAR_SETUP_MII) {
> +		/* Clear MMFR to avoid to generate MII event by writing MSCR.
> +		 * MII event generation condition:
> +		 * - writing MSCR:
> +		 *	- mmfr[31:0]_not_zero & mscr[7:0]_is_zero &
> +		 *	  mscr_reg_data_in[7:0] != 0
> +		 * - writing MMFR:
> +		 *	- mscr[7:0]_not_zero
> +		 */
> +		writel(0, fep->hwp + FEC_MII_DATA);
> +	}

Hi Greg

The last time we discussed this, we decided that if you cannot do the
quirk, you need to wait around for an MDIO interrupt, e.g. call
fec_enet_mdio_wait() after setting FEC_MII_SPEED register.

>  
>  	writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);

	Andrew
