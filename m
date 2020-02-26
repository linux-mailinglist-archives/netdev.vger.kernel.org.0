Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C450917088F
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 20:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbgBZTMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 14:12:13 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:52950 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727136AbgBZTMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 14:12:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=KcpXKrnA+tSfLVsLB+Y3FGpvlq2JJa1WqGuNDRsLFVI=; b=wN0aYjMTZnoSDpDhzYIt38EqZ
        RJf1TJ5E/4mJ7s2PkotL8Y9CcARYlFdLFBhJjHRgQbIO/5Ji4MKvPuToTgdMQSVZaBpewmgISApvn
        hoitaH94VzMNRiKYpmU5JELCdxM/6krlabZlxq8GsuMnMbEC+YGGf03ukVz5HXolo+reNStySqmDb
        fBDYKr+Hr7kd+lbHivf4/VbIUkNapTWXz50IuZqT7s59Bzwnylte2jS600ebdyS68R5ngkl1ST3GE
        QEsruSikfBoyALG0il3MrgKBvRV/HfC296Dar4JHNwzc4R1VVd4Ln7DzNJofB0XNL8X+PD9bkXvqD
        rWi72JvXw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:53150)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j726A-00011K-VO; Wed, 26 Feb 2020 19:11:59 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j7263-0000EC-U4; Wed, 26 Feb 2020 19:11:51 +0000
Date:   Wed, 26 Feb 2020 19:11:51 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        John Crispin <john@phrozen.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH net-next v2 1/8] net: phylink: propagate resolved link
 config via mac_link_up()
Message-ID: <20200226191151.GH25745@shell.armlinux.org.uk>
References: <20200226102312.GX25745@shell.armlinux.org.uk>
 <E1j6tqv-0003G6-BO@rmk-PC.armlinux.org.uk>
 <CA+h21hrR1Xkx9gwAT2FHqcH38L=xjWiPxmF2Er7-4fHFTrA8pQ@mail.gmail.com>
 <20200226115549.GZ25745@shell.armlinux.org.uk>
 <CA+h21hqjMBjgQDee8t=Csy5DXVUk9f=PP0hHSDfkuA746ZKzSQ@mail.gmail.com>
 <20200226133614.GA25745@shell.armlinux.org.uk>
 <CA+h21hqHfC0joRDhCQP6MntFdVaApFiC51xk=tUf3+y-C7sX_Q@mail.gmail.com>
 <CA+h21hpzCY=+0U4JgFbqGLS=Sh6SjkSt=4J9e0AGVHKJPOHq1A@mail.gmail.com>
 <DB8PR04MB682837B8182CFC3359B71112E0EA0@DB8PR04MB6828.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB682837B8182CFC3359B71112E0EA0@DB8PR04MB6828.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 06:32:55PM +0000, Ioana Ciornei wrote:
> > Subject: Re: [PATCH net-next v2 1/8] net: phylink: propagate resolved link config
> > via mac_link_up()
> > 
> > On Wed, 26 Feb 2020 at 20:21, Vladimir Oltean <olteanv@gmail.com> wrote:
> > >
> > > On Wed, 26 Feb 2020 at 15:36, Russell King - ARM Linux admin
> > > <linux@armlinux.org.uk> wrote:
> > > >
> > > >
> > > > dpaa2 is complicated by the firmware, and that we can't switch the
> > > > interface mode between (SGMII,1000base-X) and 10G.
> > > >
> > > > If the firmware is in "DPMAC_LINK_TYPE_PHY" mode, it expects to be
> > > > told the current link parameters via the dpmac_set_link_state() call
> > > > - it isn't clear whether that needs to be called for other modes
> > > > with the up/down state (firmware API documentation is poor.)
> > > >
> > >
> > > With PCS control in Linux, I am pretty sure that you don't want
> > > anything other than DPMAC_LINK_TYPE_PHY anyway.
> > > Basically in DPMAC_LINK_TYPE_FIXED, the MC firmware is in control of
> > > the PCS and polls its link state to emit link notifications to objects
> > > connected to the DPMAC. So Linux control of PCS would class with
> > 
> > s/class/clash/
> > 
> > > firmware control of the PCS, leading to undesirable side-effects to
> > > say the least.
> 
> 
> If the DPMAC object is in DPMAC_LINK_TYPE_FIXED, the dpaa2-eth in fact
> does not even connect to a phy so all the phylink interaction is not happening.
> As Vladimir said, in this case it's the MC firmware's job to poll the PCS and
> notify any connected objects of a link change.

Please see the patches I've referred Vladimir to, specifically this:

        if (attr.link_type == DPMAC_LINK_TYPE_PHY) {
                /* FIXME: how do we know whether this DPMAC has a PCS? */
                err = dpaa2_pcs_create(mac, attr.id);
                if (err)
                        goto err_phylink_destroy;

                phylink_add_pcs(mac->phylink, &dpaa2_pcs_phylink_ops);
        }

Hence, if we are not in DPMAC_LINK_TYPE_PHY, then we never talk to
the PCS, thereby satisfying the requirements of the firmware not to
touch the PCS if it's in FIXED mode.

It seems this is becoming a storm in a tea cup.  Please stop.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
