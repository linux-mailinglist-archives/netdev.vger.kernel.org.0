Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6A012CEF9F
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 15:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388120AbgLDOQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 09:16:50 -0500
Received: from relay11.mail.gandi.net ([217.70.178.231]:54783 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727918AbgLDOQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 09:16:50 -0500
Received: from localhost (lfbn-lyo-1-997-19.w86-194.abo.wanadoo.fr [86.194.74.19])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id AEE95100003;
        Fri,  4 Dec 2020 14:16:06 +0000 (UTC)
Date:   Fri, 4 Dec 2020 15:16:06 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Steen Hegelund <steen.hegelund@microchip.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH v8 3/4] phy: Add Sparx5 ethernet serdes PHY driver
Message-ID: <20201204141606.GH74177@piout.net>
References: <20201203103015.3735373-1-steen.hegelund@microchip.com>
 <20201203103015.3735373-4-steen.hegelund@microchip.com>
 <20201203215253.GL2333853@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203215253.GL2333853@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/12/2020 22:52:53+0100, Andrew Lunn wrote:
> > +	if (macro->serdestype == SPX5_SDT_6G) {
> > +		value = sdx5_rd(priv, SD6G_LANE_LANE_DF(macro->stpidx));
> > +		analog_sd = SD6G_LANE_LANE_DF_PMA2PCS_RXEI_FILTERED_GET(value);
> > +	} else if (macro->serdestype == SPX5_SDT_10G) {
> > +		value = sdx5_rd(priv, SD10G_LANE_LANE_DF(macro->stpidx));
> > +		analog_sd = SD10G_LANE_LANE_DF_PMA2PCS_RXEI_FILTERED_GET(value);
> > +	} else {
> > +		value = sdx5_rd(priv, SD25G_LANE_LANE_DE(macro->stpidx));
> > +		analog_sd = SD25G_LANE_LANE_DE_LN_PMA_RXEI_GET(value);
> > +	}
> > +	/* Link up is when analog_sd == 0 */
> > +	return analog_sd;
> > +}
> 
> What i have not yet seen is how this code plugs together with
> phylink_pcs_ops?
> 
> Can this hardware also be used for SATA, USB? As far as i understand,
> the Marvell Comphy is multi-purpose, it is used for networking, USB,
> and SATA, etc. Making it a generic PHY then makes sense, because
> different subsystems need to use it.
> 
> But it looks like this is for networking only? So i'm wondering if it
> belongs in driver/net/pcs and it should be accessed using
> phylink_pcs_ops?
> 

Ocelot had PCie on the phys, doesn't Sparx5 have it?

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
