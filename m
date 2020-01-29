Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E010614CB7C
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 14:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgA2NfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 08:35:13 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40694 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbgA2NfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 08:35:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wxeUFLAMJRRXFDd8By5e4fuIBUVCs8tICzOb3hySSKY=; b=D03/xwCyZvQwdqaURGy9lMkVG
        Nt9i4FejBcsr4rq2uNdqJTK4IMl+mf8TOlApEG2+yVaZNFdhdQGkCX4mGFDm7irlrKve92Q6xpSqu
        bzSQNPTN+CsA9pjRF2AXMfQ9viW1AyOgDB6whBRheC6nAjidj+5pz67gLC/yuBZxh9M1BIV1FX0i4
        jjGbkRls/btalXKvky4kkbUT7MVzpw0SaXWP4TKvrDnv1N+V29pOSP1kRQndapgsbgnPT49PwH9k9
        PYTtiwzkrJESpf3FlOK/RIvpQ9i9d+y1OO+nmCPq8sud5O/XPp3p1Z7WKReIzNKu+8gvtCuRj4cDq
        K37m3c93A==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:33244)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iwnUi-0005aK-NO; Wed, 29 Jan 2020 13:35:00 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iwnUf-0003R4-6X; Wed, 29 Jan 2020 13:34:57 +0000
Date:   Wed, 29 Jan 2020 13:34:57 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ykaukab@suse.de" <ykaukab@suse.de>
Subject: Re: [PATCH net-next 2/2] dpaa_eth: support all modes with rate
 adapting PHYs
Message-ID: <20200129133457.GG25745@shell.armlinux.org.uk>
References: <1579701573-6609-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1579701573-6609-3-git-send-email-madalin.bucur@oss.nxp.com>
 <eaaf792f-c590-a0df-824f-c28a85b1887c@gmail.com>
 <DB8PR04MB698538EB0ED388D39771E159EC0F0@DB8PR04MB6985.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB698538EB0ED388D39771E159EC0F0@DB8PR04MB6985.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 23, 2020 at 07:20:58AM +0000, Madalin Bucur (OSS) wrote:
> There has been a long email thread [1] related to this particular issue.
> Please note USXGMII is one of the supported modes of the AQR PHYs but
> unfortunately not a mode our SoC is capable to use. The DPAA 1 platforms
> do not support USXGMII, they use a serial interface to the PHY, called
> anywhere in the DPAA SoC and PHY datasheets XFI. We're left with "xgmii"
> compatible in the device tree because that's what was available at the
> time in the kernel for 10G and because in the SoC XGMII is the actual
> MII that connects the MAC to the SoC internal blocks that are part of
> the physical layer. Because we have an internal PCS, the DPAA SoC to
> external PHY connection is a PHY-layer internal connection, that has
> no official denomination derived from a standard. In the industry, this
> is called XFI.

People in industry call 1000BASE-X "SGMII" as well, despite SGMII being
a Cisco modification of 1000BASE-X.  They are compatible up to a point
but they do not inter-operate.  What terms industry uses does not make
those terms correct, and does not mean we should continue their cockups.
The same is true for the XFI.  Get over it.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
