Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 114B485CBF
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 10:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731997AbfHHI0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 04:26:33 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:37138 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731592AbfHHI0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 04:26:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=jwxaTIm/AFYo95zIn4GSJClude56iUhYynHxK1wSpGY=; b=e6xc2qlyX7rvW6YuX6sxxvq5H
        K5YLBG5R3W79nHYnYrjeNkeHrLkuv5701JgsuFwSW5p+8ND8JypISpN+cs24cMsYUNoKB2nKUeabd
        fdX9Y63MnRGFCWVw194tJlRcaWuFXqHJTW0hTL03pjW9+1R0qp6vt9yKUr+Dy1mxfh/1ZVg/SlHhg
        lw5uivZaBr4axvrqqkzQguD0RJxwbVH0rUu02Znuo7al1E9xCA5hNYJ8LigVpGXiTKLUMRzxhVOQh
        A0Xrl6p14k/XgOMta/CMfmgw6iDrhLzAB5vMWMU6vqf30uzL5DQxnjKNJudP+lJB9IQoXELa5RZ3g
        fis067yLQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:42380)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hvdkj-0002h1-Db; Thu, 08 Aug 2019 09:26:29 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hvdkg-0002Ik-CQ; Thu, 08 Aug 2019 09:26:26 +0100
Date:   Thu, 8 Aug 2019 09:26:26 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: Clause 73 and USXGMII
Message-ID: <20190808082626.GB5193@shell.armlinux.org.uk>
References: <BN8PR12MB32662070AAC1C34BA47C0763D3D40@BN8PR12MB3266.namprd12.prod.outlook.com>
 <BN8PR12MB3266A710111427071814D371D3D70@BN8PR12MB3266.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN8PR12MB3266A710111427071814D371D3D70@BN8PR12MB3266.namprd12.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Have you tried enabling debug mode in phylink (add #define DEBUG at the
top of the file) ?

Thanks.

On Thu, Aug 08, 2019 at 08:17:29AM +0000, Jose Abreu wrote:
> ++ PHY Experts
> 
> From: Jose Abreu <joabreu@synopsys.com>
> Date: Aug/07/2019, 16:46:23 (UTC+00:00)
> 
> > Hello,
> > 
> > I've some sample code for Clause 73 support using Synopsys based XPCS 
> > but I would like to clarify some things that I noticed.
> > 
> > I'm using USXGMII as interface and a single SERDES that operates at 10G 
> > rate but MAC side is working at 2.5G. Maximum available bandwidth is 
> > therefore 2.5Gbps.
> > 
> > So, I configure USXGMII for 2.5G mode and it works but if I try to limit 
> > the autoneg abilities to 2.5G max then it never finishes:
> > # ethtool enp4s0
> > Settings for enp4s0:
> > 	Supported ports: [ ]
> > 	Supported link modes:   1000baseKX/Full 
> > 	                        2500baseX/Full 
> > 	Supported pause frame use: Symmetric Receive-only
> > 	Supports auto-negotiation: Yes
> > 	Supported FEC modes: Not reported
> > 	Advertised link modes:  1000baseKX/Full 
> > 	                        2500baseX/Full 
> > 	Advertised pause frame use: Symmetric Receive-only
> > 	Advertised auto-negotiation: Yes
> > 	Advertised FEC modes: Not reported
> > 	Speed: Unknown!
> > 	Duplex: Unknown! (255)
> > 	Port: MII
> > 	PHYAD: 0
> > 	Transceiver: internal
> > 	Auto-negotiation: on
> > 	Supports Wake-on: ug
> > 	Wake-on: d
> > 	Current message level: 0x0000003f (63)
> > 			       drv probe link timer ifdown ifup
> > 	Link detected: no
> > 
> > When I do not limit autoneg and I say that maximum limit is 10G then I 
> > get Link Up and autoneg finishes with this outcome:
> > # ethtool enp4s0
> > Settings for enp4s0:
> > 	Supported ports: [ ]
> > 	Supported link modes:   1000baseKX/Full 
> > 	                        2500baseX/Full 
> > 	                        10000baseKX4/Full 
> > 	                        10000baseKR/Full 
> > 	Supported pause frame use: Symmetric Receive-only
> > 	Supports auto-negotiation: Yes
> > 	Supported FEC modes: Not reported
> > 	Advertised link modes:  1000baseKX/Full 
> > 	                        2500baseX/Full 
> > 	                        10000baseKX4/Full 
> > 	                        10000baseKR/Full 
> > 	Advertised pause frame use: Symmetric Receive-only
> > 	Advertised auto-negotiation: Yes
> > 	Advertised FEC modes: Not reported
> > 	Link partner advertised link modes:  1000baseKX/Full 
> > 	                                     2500baseX/Full 
> > 	                                     10000baseKX4/Full 
> > 	                                     10000baseKR/Full 
> > 	Link partner advertised pause frame use: Symmetric Receive-only
> > 	Link partner advertised auto-negotiation: Yes
> > 	Link partner advertised FEC modes: Not reported
> > 	Speed: 2500Mb/s
> > 	Duplex: Full
> > 	Port: MII <- Never mind this, it's a SW issue
> > 	PHYAD: 0
> > 	Transceiver: internal
> > 	Auto-negotiation: on
> > 	Supports Wake-on: ug
> > 	Wake-on: d
> > 	Current message level: 0x0000003f (63)
> > 			       drv probe link timer ifdown ifup
> > 	Link detected: yes
> > 
> > I was expecting that, as MAC side is limited to 2.5G, I should set in 
> > phylink the correct capabilities and then outcome of autoneg would only 
> > have up to 2.5G modes. Am I wrong ?
> > 
> > ---
> > Thanks,
> > Jose Miguel Abreu
> 
> 
> ---
> Thanks,
> Jose Miguel Abreu
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
