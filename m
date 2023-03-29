Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B000A6CD6DB
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 11:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbjC2Jse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 05:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbjC2Jsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 05:48:32 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095191990;
        Wed, 29 Mar 2023 02:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=au9j1RKX6uBNeqzDDu1OuVZGAvYR+PBKjc7fF9etf8g=; b=uQR1dij+ectpu7hzYEJ45EbjLP
        sQ/NxyhnOmjLTKzzlicb6edwu3KbL2D9pfnGksaT1qEvWY28vo3bmL+uWaB3oSQwJBHho1RPlZ4ZH
        Yw8gA5FGztN+Szwpc3fs00oAbQIliZ3Fbv7UOaoGaC3gtDXLlZn8VVEPw/bCiIxeBLoWGkWRYPRQm
        He4yJWhNFMe+Y8c3Gc9d4L5Cebsh0LzVydvvdbW3NeKnckV7xbaXPbHFyoDRBR8+/d1n/4YEKgyBq
        vHrBAElZLL1vlGjGB3R9dcOLxSE0iVbDHcos/7joOAQS0mcNtMSpCzh7Lq0i6nfx9MJF2UtzEcM6l
        NH2HaebA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41268)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1phSPd-0008J7-UH; Wed, 29 Mar 2023 10:48:13 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1phSPZ-0007Pv-Qo; Wed, 29 Mar 2023 10:48:09 +0100
Date:   Wed, 29 Mar 2023 10:48:09 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     "Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Looi, Hong Aun" <hong.aun.looi@intel.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Lai, Peter Jun Ann" <peter.jun.ann.lai@intel.com>
Subject: Re: [PATCH net v3 1/3] net: phylink: add phylink_expects_phy() method
Message-ID: <ZCQJWcdfmualIjvX@shell.armlinux.org.uk>
References: <20230324081656.2969663-1-michael.wei.hong.sit@intel.com>
 <20230324081656.2969663-2-michael.wei.hong.sit@intel.com>
 <20230328185720.6239e4a7@kernel.org>
 <ZCP+aIoUTw2laZ3/@shell.armlinux.org.uk>
 <PH0PR11MB7587808A98658C9F075A0C309D899@PH0PR11MB7587.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR11MB7587808A98658C9F075A0C309D899@PH0PR11MB7587.namprd11.prod.outlook.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 09:34:05AM +0000, Sit, Michael Wei Hong wrote:
> 
> 
> > -----Original Message-----
> > From: Russell King <linux@armlinux.org.uk>
> > Sent: Wednesday, March 29, 2023 5:01 PM
> > To: Jakub Kicinski <kuba@kernel.org>
> > Cc: Sit, Michael Wei Hong <michael.wei.hong.sit@intel.com>;
> > Giuseppe Cavallaro <peppe.cavallaro@st.com>; Alexandre Torgue
> > <alexandre.torgue@foss.st.com>; Jose Abreu
> > <joabreu@synopsys.com>; David S . Miller <davem@davemloft.net>;
> > Eric Dumazet <edumazet@google.com>; Paolo Abeni
> > <pabeni@redhat.com>; Maxime Coquelin
> > <mcoquelin.stm32@gmail.com>; Ong, Boon Leong
> > <boon.leong.ong@intel.com>; netdev@vger.kernel.org; linux-
> > stm32@st-md-mailman.stormreply.com; linux-arm-
> > kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Looi,
> > Hong Aun <hong.aun.looi@intel.com>; Voon, Weifeng
> > <weifeng.voon@intel.com>; Lai, Peter Jun Ann
> > <peter.jun.ann.lai@intel.com>
> > Subject: Re: [PATCH net v3 1/3] net: phylink: add
> > phylink_expects_phy() method
> > 
> > On Tue, Mar 28, 2023 at 06:57:20PM -0700, Jakub Kicinski wrote:
> > > On Fri, 24 Mar 2023 16:16:54 +0800 Michael Sit Wei Hong wrote:
> > > > Provide phylink_expects_phy() to allow MAC drivers to check if it
> > is
> > > > expecting a PHY to attach to. Since fixed-linked setups do not
> > need
> > > > to attach to a PHY.
> > > >
> > > > Provides a boolean value as to if the MAC should expect a PHY.
> > > > returns true if a PHY is expected.
> > > >
> > > > Signed-off-by: Michael Sit Wei Hong
> > <michael.wei.hong.sit@intel.com>
> > >
> > > Russell, looks good?
> > 
> > Not really, given that phylink_attach_phy() will refuse to attach a
> > PHY
> > when:
> > 
> >         if (WARN_ON(pl->cfg_link_an_mode == MLO_AN_FIXED ||
> >                     (pl->cfg_link_an_mode == MLO_AN_INBAND &&
> >                      phy_interface_mode_is_8023z(interface) && !pl-
> > >sfp_bus)))
> >                 return -EINVAL;
> > 
> > So, if we introduce a helper named "phylink_expects_phy" that
> > returns true when cfg_link_an_mode == MLO_AN_INBAND and the
> > interface mode is e.g. 1000base-X, but then someone tries to attach
> > a PHY, the kernel spits out a warning, backtrace, and a return value
> > of -EINVAL, things are going to look really rather stupid.
> > 
> Should we check for these 3 conditions as well then?
> (pl->cfg_link_an_mode == MLO_AN_INBAND &&
> phy_interface_mode_is_8023z(interface) && !pl->sfp_bus)
> to determine if phylink expects a phy.

If there's a sfp bus, then we don't expect a PHY from the MAC driver
(as there can only be one PHY attached), and as phylink_expects_phy()
is for the MAC driver to use, we should be returning false if
pl->sfp_bus != NULL.

	pl->cfg_link_an_mode == MLO_AN_FIXED ||
	(pl->cfg_link_an_mode == MLO_AN_INBAND &&
	 phy_interface_mode_is_8023z(interface))

Is true when we're in fixed-link mode, or if we're in in-band mode
and using 1000base-X or 25000base-X. These are the conditions that
we don't expect the MAC driver to give us a PHY.

To put that in positive logic, we expect a PHY from the MAC when
we're in PHY mode, or when we're in in-band mode and using SGMII,
QSGMII, USXGMII, RGMII, etc.

The reason for the extra "&& !pl->sfp_bus" in phylink_attach_phy()
is to allow SFPs to connect to the MAC using inband mode with
1000base-X and 2500base-X interface modes. These are not for the
MAC-side of things though.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
