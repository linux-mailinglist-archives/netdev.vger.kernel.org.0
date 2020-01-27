Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF5FF14A5B9
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 15:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbgA0OIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 09:08:46 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:36640 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbgA0OIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 09:08:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=WNZMMHq/DEgG2TAGsW1GLa13iz6G/nCCbL9fpHEwYPE=; b=FJji4eBDh1ncH1ZpXMPgURV3X
        dj1fYyBWuwF70IsvJrIIE8pTPyUYE0/omNoeZ6ZFi9f1KcaYnYyi0SXUDRN+3PG8Vsa0EuD0Vr2Q7
        qGOZeb1BzO9bhPdcEhw0pyqm0qABjwayRlhAJ89aF9NweV2ti36BDhvY8dJOyEcp8+/NLoi5Fm3QW
        sqo5Hs14PuNUyI9zILJIq24F3qvL3hjBYtsgl5/EjFAoGnZdTVN4p9+01ynjloljDjTG+W7zjWbUd
        xa5oblOkpcDijdJ4uxP9XT/tEQgWsj4JYbmuS7oq/bDW+lVFqAnNtG4bc3uuNFSV7NREbZVHYEP5p
        rG+EnFRcg==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:39866)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iw54A-0001kz-Ej; Mon, 27 Jan 2020 14:08:38 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iw546-0001SA-KA; Mon, 27 Jan 2020 14:08:34 +0000
Date:   Mon, 27 Jan 2020 14:08:34 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC net-next 6/8] net: phylink: Configure MAC/PCS when link is
 up without PHY
Message-ID: <20200127140834.GW25745@shell.armlinux.org.uk>
References: <cover.1580122909.git.Jose.Abreu@synopsys.com>
 <9a2136885d9a892ff170be88fdffeda82c778a10.1580122909.git.Jose.Abreu@synopsys.com>
 <20200127112102.GT25745@shell.armlinux.org.uk>
 <BN8PR12MB3266714AE9EC1A97218120B3D30B0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200127114600.GU25745@shell.armlinux.org.uk>
 <20200127140038.GD13647@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200127140038.GD13647@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 27, 2020 at 03:00:38PM +0100, Andrew Lunn wrote:
> > Yes, I realise that, but it comes with the expense of potentially
> > breaking mvneta and mvpp2, where the settings are automatically
> > passed between the PCS and MAC in hardware. I also believe DSA
> > works around this, and I need to look at that.
> 
> Hi Russell
> 
> The mv88e6xxx driver has code for when SGMII is used. It transfers the
> negotiated speed from the PCS to the MAC.
> 
> But it recently turned out something like this is also needed for
> other link modes involving the SERDES. It used to work, i think
> because Phylink would initially configure the MAC approximately right,
> or the mv88e6xxx driver was looking at phylink state it should not.
> But it no longer works.

Can you give a hint which platform this is and how to reproduce it
please?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
