Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA533FEAA8
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 10:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244467AbhIBIdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 04:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243772AbhIBIdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 04:33:37 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37CBC061575
        for <netdev@vger.kernel.org>; Thu,  2 Sep 2021 01:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=xX+kNEOYZp3bJ3dTnTctIZyXNrdpAFSI7OwVO318ukI=; b=iI2Qfbj3LFEGk46LmPVAu3HKf
        ZG8UOW7m5R1cm3mAmLWj40fBljqRWE6g+WWMYbc9wxBV2pTYMCqyyj9n3OWDy5Qy99diNukG6yi0c
        9Og3FQfxC5hYIarKIhEnsQOmZMeSQ7wF0qXh+1Gz1oaPGTpvQc6VGnjEfTGSWv1H6xsCrPRR80zSA
        Hi8PKYZnD/4WXbcpGI66OcePX5wkUFg5O1NWjvwVg2P24U2LGvEtmkyh1CgTkJEtNcsL8ymASXsdw
        LvQ0Ad6csvxU5yQdlQi6nHso610MIVj35/38P4Q4NguxpKbWj3Kya5Wtv3hj/zOHlBEGKIemKXqYp
        e339m1n8w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48074)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mLi95-00019M-Sv; Thu, 02 Sep 2021 09:32:27 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mLi92-0007fg-Fb; Thu, 02 Sep 2021 09:32:24 +0100
Date:   Thu, 2 Sep 2021 09:32:24 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] net: stmmac: fix MAC not working when system resume back
 with WoL enabled
Message-ID: <20210902083224.GC22278@shell.armlinux.org.uk>
References: <20210901090228.11308-1-qiangqing.zhang@nxp.com>
 <20210901092149.fmap4ac7jxf754ao@skbuf>
 <DB8PR04MB6795CCAE06AA7CEB5CCEC521E6CD9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210901105611.y27yymlyi5e4hys5@skbuf>
 <DB8PR04MB67956C22F601DA8B7DC147D5E6CD9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210901132547.GB22278@shell.armlinux.org.uk>
 <DB8PR04MB6795BB2A13AED5F6E56D08A0E6CE9@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DB8PR04MB6795BB2A13AED5F6E56D08A0E6CE9@DB8PR04MB6795.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 02, 2021 at 07:28:44AM +0000, Joakim Zhang wrote:
> 
> Hi Russell,
> 
> > -----Original Message-----
> > From: Russell King <linux@armlinux.org.uk>
> > Sent: 2021年9月1日 21:26
> > To: Joakim Zhang <qiangqing.zhang@nxp.com>
> > Cc: Vladimir Oltean <olteanv@gmail.com>; peppe.cavallaro@st.com;
> > alexandre.torgue@foss.st.com; joabreu@synopsys.com;
> > davem@davemloft.net; kuba@kernel.org; mcoquelin.stm32@gmail.com;
> > netdev@vger.kernel.org; andrew@lunn.ch; f.fainelli@gmail.com;
> > hkallweit1@gmail.com; dl-linux-imx <linux-imx@nxp.com>
> > Subject: Re: [PATCH] net: stmmac: fix MAC not working when system resume
> > back with WoL enabled
> > 
> > This means you need to have the phy <-> mac link up during
> > suspend, and in that case, yes, you do not want to call
> > phylink_stop() or phylink_start().
> 
> I have a question here, why need to have the phy<->mac link up during suspend?

You need the link up because I think from reading the code, it is _not_
the PHY that is triggering the wakeup in the configuration you are using,
but the MAC.

If the link is down, the PHY can't pass the received packet to the MAC,
and the MAC can't recognise the magic packet.

FEC doesn't have this. FEC relies purely on the PHY detecting the magic
packet, which is much more power efficient, because it means the MAC
doesn't need to be powered up and operational while the rest of the
system is suspended.

> As you described in past thread, phylink_stop() and phylink_start() also need to be called even with
> WoL active.

That was with the assumption that the PHY was detecting the magic
packet. It isn't for stmmac - stmmac can be configured to bypass
the configuration of the PHY for this and uses the MAC to detect
this instead. If the MAC is doing the detecting for WoL, then you
need network connectivity to be functional from the network cable
through the PHY and up to the MAC.

So, bringing the link down at suspend in this case _will_ break
WoL. The PHY isn't the device detecting the magic packet, it is the
MAC, and the MAC must be able to see the network traffic.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
