Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91EF13FEC67
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 12:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245611AbhIBKvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 06:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245096AbhIBKu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 06:50:56 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE5FC061575
        for <netdev@vger.kernel.org>; Thu,  2 Sep 2021 03:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=dODB7VvsNIgvayBjg+Qh1UP02EkhmKb7x69BjFgarig=; b=VfaU6OLcExUNayGxyo/d7csrF
        9NQNvUPpXVkPXY3rupP+BNRpqPx+38tHE6weO47hlhhimTfC9ENiWt4mnrr9v8nMJMZGqqsY4yENi
        fHoFfzompvCAHJCwP9BEC/BmOkz0KpxwYGth44EWkbTTL/dYG7C4aIoic5QuBzeeTRzGlRF9QQ9BI
        e+9VcoX8Ty/FGNhjSWlQ/Ig9RwJQvOX7Jgk5dqdSvm3V2HPNCbRPkL0mTzOn8sP6oV+0HdhVD7Ek2
        k1h4Ia26CzuIX0JFlE5XRs3MDR9Jqz2xIEw+4/igMp6tAJ/nkUjeyEsT7aGyVrTjd7QJRvpg6LdK1
        /4UELhC7w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48076)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mLkHy-0001I5-Mf; Thu, 02 Sep 2021 11:49:46 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mLkHv-0007ki-Jb; Thu, 02 Sep 2021 11:49:43 +0100
Date:   Thu, 2 Sep 2021 11:49:43 +0100
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
Message-ID: <20210902104943.GD22278@shell.armlinux.org.uk>
References: <20210901090228.11308-1-qiangqing.zhang@nxp.com>
 <20210901092149.fmap4ac7jxf754ao@skbuf>
 <DB8PR04MB6795CCAE06AA7CEB5CCEC521E6CD9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210901105611.y27yymlyi5e4hys5@skbuf>
 <DB8PR04MB67956C22F601DA8B7DC147D5E6CD9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210901132547.GB22278@shell.armlinux.org.uk>
 <DB8PR04MB6795BB2A13AED5F6E56D08A0E6CE9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210902083224.GC22278@shell.armlinux.org.uk>
 <DB8PR04MB67954F4650408025E6D4EE2AE6CE9@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DB8PR04MB67954F4650408025E6D4EE2AE6CE9@DB8PR04MB6795.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 02, 2021 at 10:26:13AM +0000, Joakim Zhang wrote:
> 
> Hi Russell,
> 
> Thanks a lot!
> 
> > -----Original Message-----
> > From: Russell King <linux@armlinux.org.uk>
> > Sent: 2021年9月2日 16:32
> > To: Joakim Zhang <qiangqing.zhang@nxp.com>
> > Cc: Vladimir Oltean <olteanv@gmail.com>; peppe.cavallaro@st.com;
> > alexandre.torgue@foss.st.com; joabreu@synopsys.com;
> > davem@davemloft.net; kuba@kernel.org; mcoquelin.stm32@gmail.com;
> > netdev@vger.kernel.org; andrew@lunn.ch; f.fainelli@gmail.com;
> > hkallweit1@gmail.com; dl-linux-imx <linux-imx@nxp.com>
> > Subject: Re: [PATCH] net: stmmac: fix MAC not working when system resume
> > back with WoL enabled
> > 
> > On Thu, Sep 02, 2021 at 07:28:44AM +0000, Joakim Zhang wrote:
> > >
> > > Hi Russell,
> > >
> > > > -----Original Message-----
> > > > From: Russell King <linux@armlinux.org.uk>
> > > > Sent: 2021年9月1日 21:26
> > > > To: Joakim Zhang <qiangqing.zhang@nxp.com>
> > > > Cc: Vladimir Oltean <olteanv@gmail.com>; peppe.cavallaro@st.com;
> > > > alexandre.torgue@foss.st.com; joabreu@synopsys.com;
> > > > davem@davemloft.net; kuba@kernel.org; mcoquelin.stm32@gmail.com;
> > > > netdev@vger.kernel.org; andrew@lunn.ch; f.fainelli@gmail.com;
> > > > hkallweit1@gmail.com; dl-linux-imx <linux-imx@nxp.com>
> > > > Subject: Re: [PATCH] net: stmmac: fix MAC not working when system
> > > > resume back with WoL enabled
> > > >
> > > > This means you need to have the phy <-> mac link up during suspend,
> > > > and in that case, yes, you do not want to call
> > > > phylink_stop() or phylink_start().
> > >
> > > I have a question here, why need to have the phy<->mac link up during
> > suspend?
> > 
> > You need the link up because I think from reading the code, it is _not_ the PHY
> > that is triggering the wakeup in the configuration you are using, but the MAC.
> > 
> > If the link is down, the PHY can't pass the received packet to the MAC, and the
> > MAC can't recognise the magic packet.
> 
> Per my understanding, if use PHY-based wakeup, PHY should be active, and MAC can be
> totally suspended. When PHY receive the magic packets, it will generate a signal via wakeup
> PIN (PHY seems all have such PIN) to inform SoC, we can use this to wake up the system.
> Please correct me if I misunderstand.

Correct.

> > FEC doesn't have this. FEC relies purely on the PHY detecting the magic packet,
> > which is much more power efficient, because it means the MAC doesn't need
> > to be powered up and operational while the rest of the system is suspended.
> 
> AFAIK, FEC also use the MAC-based wakeup, when enable FEC WoL feature, it will
> keep MAC receive logic active, PHY pass the received packets to MAC, if MAC detects
> the magic packets, it will generate an interrupt to wake up the system.

You're right.

However, as the PHY is not configured for WoL with FEC, and
fec_suspend() unconditionally calls phy_stop() which will place the PHY
into suspend mode. Maybe the PHY driver there has a NULL phydrv->suspend
method? However, I see that at803x has suspend methods (which I believe
is the PHY that gets used with i.MX products) which will power down the
PHY.

So, how does this work with FEC - because right now I can't see it
working, but you say it does.

I think we need to understand how FEC is working here, and we need a
deeper understanding why stmmac isn't working.

I don't have any iMX systems that support WoL, so this isn't something
I can test. (SolidRun's i.MX platforms do not support any kind of
system power down, so suspend isn't supported.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
