Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9933263D4F8
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 12:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232822AbiK3Lvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 06:51:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234475AbiK3LvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 06:51:16 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA597B4E9;
        Wed, 30 Nov 2022 03:51:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=SeprZaUCrg6YMDUQVxQrpsNw17qVCxSs694K/ikvslE=; b=DnY+sP3ETdi6+M6MeNzJpuGBM6
        3Q6mYmwux7sT7CkxU9xl+BfJZD/l/CWSP7TJ89V45p9uBVpPkx93KWoG0cc3IYXfqmRGy6/3sjbb2
        78COo1ggeQOWJ9vPx3R3AMbUuwvnNPNDg8DA8Wn0cCOnN3ofoQnrNeLi2AjJnyFeBHVx8YX2IsuR+
        3P1WvrTUBxgG1MZWTnEC21nXmOBjnawcYVt7AfFcfeJ1MJ242SqdZYl8tm1PRWZQbayVKpSx/BaSs
        y2BgKvCaFE3O/hRa66dxpbjWwiBKoPLlN/07nYrBtiDMqM2mwRX64X7uXf/sM9qJS6/C7lpYN12V0
        t/t3DfAA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35498)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p0Lc5-0001fp-7X; Wed, 30 Nov 2022 11:50:53 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p0Lc2-0002TM-C2; Wed, 30 Nov 2022 11:50:50 +0000
Date:   Wed, 30 Nov 2022 11:50:50 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Clark Wang <xiaoning.wang@nxp.com>
Cc:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] net: phylink: add sync flag mac_ready to fix resume
 issue with WoL enabled
Message-ID: <Y4dDmvOQwuIYxgro@shell.armlinux.org.uk>
References: <20221130111148.1064475-1-xiaoning.wang@nxp.com>
 <20221130111148.1064475-2-xiaoning.wang@nxp.com>
 <Y4c9PlfEC17pVE08@shell.armlinux.org.uk>
 <HE1PR0402MB2939242DB6E909B4A62109E5F3159@HE1PR0402MB2939.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <HE1PR0402MB2939242DB6E909B4A62109E5F3159@HE1PR0402MB2939.eurprd04.prod.outlook.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 11:32:09AM +0000, Clark Wang wrote:
> Hi Russell,
> 
> > -----Original Message-----
> > From: Russell King <linux@armlinux.org.uk>
> > Sent: 2022年11月30日 19:24
> > To: Clark Wang <xiaoning.wang@nxp.com>
> > Cc: peppe.cavallaro@st.com; alexandre.torgue@foss.st.com;
> > joabreu@synopsys.com; davem@davemloft.net; edumazet@google.com;
> > kuba@kernel.org; pabeni@redhat.com; mcoquelin.stm32@gmail.com;
> > andrew@lunn.ch; hkallweit1@gmail.com; netdev@vger.kernel.org;
> > linux-stm32@st-md-mailman.stormreply.com;
> > linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH 1/2] net: phylink: add sync flag mac_ready to fix resume
> > issue with WoL enabled
> > 
> > On Wed, Nov 30, 2022 at 07:11:47PM +0800, Clark Wang wrote:
> > > Issue we met:
> > > On some platforms, mac cannot work after resumed from the suspend with
> > > WoL enabled.
> > >
> > > The cause of the issue:
> > > 1. phylink_resolve() is in a workqueue which will not be executed immediately.
> > >    This is the call sequence:
> > >        phylink_resolve()->phylink_link_up()->pl->mac_ops->mac_link_up()
> > >    For stmmac driver, mac_link_up() will set the correct speed/duplex...
> > >    values which are from link_state.
> > > 2. In stmmac_resume(), it will call stmmac_hw_setup() after called the
> > >    phylink_resume(). stmmac_core_init() is called in function
> > > stmmac_hw_setup(),
> > 
> > ... and that is where the problem is. Don't call phylink_resume() before your
> > hardware is ready to see a link-up event.
> 
> Thank you very much for your reply!
> 
> You are right.
> 
> However, stmmac requires RXC to have a clock input when performing a reset(in stmmac_hw_setup()). On our board, RXC is provided by the phy.
> 
> In WoL mode, this is not a problem, because the phy will not be down when suspend. RXC will keep output. But in normal suspend(without WoL), the phy will be down, which does not guarantee the output of the RXC of the phy. Therefore, the previous code will call phylink_resume() before stmmac_hw_setup().

I think we need phylink_phy_resume() which stmmac can use to resume the
PHY without resuming phylink, assuming that will output the RXC. Which
PHY driver(s) are used with stmmac?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
