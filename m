Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD5FF14287A
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 11:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgATKua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 05:50:30 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:33164 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbgATKu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 05:50:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=OCp9nsRDYcWQsrV3GjryqLOSAJxrAWhH+tupDptDjZo=; b=G2Unp/Kt5L8sqcRcZviY2SFcr
        YPso8Lk+HuRnFhCgRGPkqSajiuXbYlc/M+AW3gxjxO604q0mH71Suv+HduzqpTa+I4BavJ0yCV8fd
        K9YZSh99KUPq0ix7i2+FrIiEOGQUplA/be98njgBOFTPSXJ7o54X4vNNsisZ6ePdPDlNHEKTznFVq
        fqyUN7uFkkrXBcnBK5GwzKpvXA17gS+wT8hdp0WZWKQok8EDjyIk7YemEc+prQPVKKuE8/dklRCjY
        EcpumKNUKaMqnBBC1+IrtgZJxcNscvU+1z8szaDfPYhnvQaE+bUotpT0VoPkcMoXrNhbr7dgKS7hT
        vnAKfX2/g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:40826)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1itUdT-0005bt-Vi; Mon, 20 Jan 2020 10:50:24 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1itUdQ-0002mK-U8; Mon, 20 Jan 2020 10:50:20 +0000
Date:   Mon, 20 Jan 2020 10:50:20 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC net-next] net: phy: Add basic support for Synopsys XPCS
 using a PHY driver
Message-ID: <20200120105020.GB25745@shell.armlinux.org.uk>
References: <4953fc69a26bee930bccdeb612f1ce740a4294df.1578921062.git.Jose.Abreu@synopsys.com>
 <20200113133845.GD11788@lunn.ch>
 <BN8PR12MB32666F34D45D7881BDD4CAB3D3350@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200113141817.GN25745@shell.armlinux.org.uk>
 <BN8PR12MB3266EC7870338BA4A65E8A6CD3320@BN8PR12MB3266.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN8PR12MB3266EC7870338BA4A65E8A6CD3320@BN8PR12MB3266.namprd12.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 20, 2020 at 10:31:17AM +0000, Jose Abreu wrote:
> From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> Date: Jan/13/2020, 14:18:17 (UTC+00:00)
> 
> > I've recently suggested a patch to phylink to add a generic helper to
> > read the state from a generic 802.3 clause 37 PCS, but I guess that
> > won't be sufficient for an XPCS.  However, it should give some clues
> > if you're intending to use phylink.
> 
> So, I think for my particular setup (that has no "real" PHY) we can have 
> something like this in SW PoV:
> 
> stmmac -> xpcs -> SW-PHY / Fixed PHY
> 
> - stmmac + xpcs state would be handled by phylink (MAC side)
> - SW-PHY / Fixed PHY state would be handled by phylink (PHY side)
> 
> This would need updates for Fixed PHY to support >1G speeds.

You don't want to do that if you have 1G SFPs.  Yes, you *can* do it
and make it work, but you miss out completely on the fact that the
link is supposed to be negotiated across the SFP link for 1G speeds,
and then you're into the realms of having to provide users ways to
edit the DT and reboot if the parameters at the link partner change.

Please, avoid fixed-links with SFPs where possible, and let's
implement things correctly.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
