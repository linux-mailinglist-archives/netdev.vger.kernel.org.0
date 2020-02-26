Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8119716FBC6
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 11:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727550AbgBZKMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 05:12:55 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45312 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbgBZKMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 05:12:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=CAamW1A7wSi+dl1kSJ3MLj0iB7qeqpYQKI22daCCGM8=; b=v6DlCO/OJmb9kQvoiXW+Zr432
        8BvCAsk7BQEZrQZMpP9iJSc7ZzWQ1beEXWg6f1rkJar2gHLh0bO6C6g55IjbliVm8GG4wOPoJ5Ua6
        vdY5znpf7BdEkxFYx1esKe7H+3s72RVuWJei0owKFkgQfwQhq1p1LxnrcjjwuMtgy8iRnkfHSDWCU
        ppAdE2TIyan/4aiw8Za37GFy7p9KLPAfuhtItrM+Jis7E9Z6EPwm8rGSfhBsW5F9DrRXs0k6PUwkh
        r9XT5Ir1bufpF5nVPFO5gkuAhgxd3lpmT5fPbnsxbBNoWcWXG+AklBbInbQTfslvbHfTUtRdAfMqJ
        fNfXuKgBA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57116)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j6tfp-0006nj-Vd; Wed, 26 Feb 2020 10:12:14 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j6tfh-0008KB-0V; Wed, 26 Feb 2020 10:12:05 +0000
Date:   Wed, 26 Feb 2020 10:12:04 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Felix Fietkau <nbd@nbd.name>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Jose Abreu <joabreu@synopsys.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next 5/8] net: dpaa2-mac: use resolved link config in
 mac_link_up()
Message-ID: <20200226101204.GW25745@shell.armlinux.org.uk>
References: <20200225093703.GS25745@shell.armlinux.org.uk>
 <E1j6WgG-0000TJ-CC@rmk-PC.armlinux.org.uk>
 <DB8PR04MB68282F710FB598B977C36F99E0ED0@DB8PR04MB6828.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB68282F710FB598B977C36F99E0ED0@DB8PR04MB6828.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 04:36:32PM +0000, Ioana Ciornei wrote:
> > Subject: [PATCH net-next 5/8] net: dpaa2-mac: use resolved link config in
> > mac_link_up()
> > 
> > Convert the DPAA2 ethernet driver to use the finalised link parameters in
> > mac_link_up() rather than the parameters in mac_config(), which are more
> > suited to the needs of the DPAA2 MC firmware than those available via
> > mac_config().
> > 
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> 
> Tested-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Thanks.

> > +
> > +		/* This is lossy; the firmware really should take the pause
> > +		 * enablement status rather than pause/asym pause status.
> > +		 */
> 
> In what sense it's lossy? I cannot see how information can be lost by translating the rx/tx pause state to pause/asym.
> If it's just about the unnecessary double translation, then I agree.. this could have been done in an easier manner.

If you're just translating rx/tx to pause/asym and then doing the
reverse, then it isn't lossy, but if the firmware is resolving
pause/asym according to the table in IEEE 802.3, then it will be
lossy.

If the firmware doesn't interpret the bits, then why not do the
sensible thing and just pass the enablement status rather than
trying to confusingly encode it back to pause/asym?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
