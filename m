Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6C895FA114
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 17:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbiJJPXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 11:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiJJPXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 11:23:04 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB62172FD8
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 08:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FaKlddo7c3Jt5X53mksqNseoOvcJeO3Cc3JssvT2Wrg=; b=E1p3ddIFgCtcCVyyFt7d3S5UxP
        EYYUraVTJ50QoJgSgq/r7D8u4NmVF4x7u7Culat2y3euR5mV5s3rhX5WEcrZlf9ua6LZrcTOjyyQ6
        wxw6gdBcos/DkD05STbNiyY1CHFdoPWyZIM1rMDQ31sHs87+D63tr3o+GgdbISLjcz9LSPXrNfIDV
        XUxrzYpaASo5ifOIj2PZftYkefI+qcAqNISExPMka9tbtrmusZJ1ZnvT+cnpA9Tp+FINS44c8aiw+
        g8dgusScOxcFf2s/SMFOi1N30nN4QWK2/5iPI1K8NLszrPsFTnnUxzNY4HnLQsxmraJuLNBOdSIkG
        a1Vmydjw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34660)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ohucL-0004pC-6O; Mon, 10 Oct 2022 16:22:57 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ohucI-0001wg-Rp; Mon, 10 Oct 2022 16:22:54 +0100
Date:   Mon, 10 Oct 2022 16:22:54 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: Re: [EXT] Re: [PATCH v3 1/1] net: phylink: add phylink_set_mac_pm()
 helper
Message-ID: <Y0Q4zqhEjzIU2dIX@shell.armlinux.org.uk>
References: <20221007154246.838404-1-shenwei.wang@nxp.com>
 <Y0EmbNyFhT/HsBMh@shell.armlinux.org.uk>
 <PAXPR04MB9185302A6164DC02812B471589209@PAXPR04MB9185.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PAXPR04MB9185302A6164DC02812B471589209@PAXPR04MB9185.eurprd04.prod.outlook.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 10, 2022 at 02:54:24PM +0000, Shenwei Wang wrote:
> > -----Original Message-----
> > From: Russell King <linux@armlinux.org.uk>
> > Sent: Saturday, October 8, 2022 2:28 AM
> > To: Shenwei Wang <shenwei.wang@nxp.com>
> > Cc: Andrew Lunn <andrew@lunn.ch>; Heiner Kallweit <hkallweit1@gmail.com>;
> > David S. Miller <davem@davemloft.net>; Eric Dumazet
> > <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> > <pabeni@redhat.com>; netdev@vger.kernel.org; imx@lists.linux.dev
> > Subject: [EXT] Re: [PATCH v3 1/1] net: phylink: add phylink_set_mac_pm() helper
> > 
> > Caution: EXT Email
> > 
> > On Fri, Oct 07, 2022 at 10:42:46AM -0500, Shenwei Wang wrote:
> > > +/**
> > > + * phylink_set_mac_pm() - set phydev->mac_managed_pm to true
> > > + * @pl: a pointer to a &struct phylink returned from phylink_create()
> > > + *
> > > + * Set the phydev->mac_managed_pm, which is under the phylink
> > > +instance
> > > + * specified by @pl, to true. This is to indicate that the MAC driver
> > > +is
> > > + * responsible for PHY PM.
> > > + *
> > > + * The function can be called in the end of net_device_ops ndo_open()
> > > +method
> > > + * or any place after phy is connected.
> > 
> > May I suggest a different wording:
> > 
> > "If the driver wishes to use this feature, this function should be called each time
> > after the driver connects a PHY with phylink."
> > 
> 
> Your wording is much better. Will use it in the next version.
> 
> > This makes it clear that after one of:
> > 
> > phylink_connect_phy()
> > phylink_of_phy_connect()
> > phylink_fwnode_phy_connect()
> > 
> > has been called, and the driver wants to call this function, the driver needs to
> > call this every time just after the driver connects a PHY.
> > 
> > The alternative is that we store this information away when this function is
> > called, and always update the phydev when one is connected.
> > 
> > There is also the question whether this should also be applied to PHYs on SFP
> > modules or not. Should a network driver using mac managed PM, but also
> > supports SFPs, and a copper SFP is plugged in with an accessible PHY, what
> > should happen if the system goes into a low power state?
> > 
> 
> In theory, the SFP should be covered by this patch too. Since the resume flow is
> Controlled by the value of phydev->mac_managed_pm, it should work in the same
> way after the phydev is linked to the SFP phy instance.

It won't, because the MAC doesn't know when it needs to call your new
function.

Given this, I think a different approach is needed here:

1) require a MAC to call this function after phylink_create() and record
   the configuration in struct phylink, or put a configuration boolean in
   the phylink_config structure (probably better).

2) whenever any PHY is attached, check the status of this feature, and
   pass the configuration on to phylib.

That means MACs don't have to keep calling the function - they declare
early on whether they will be using MAC managed PM or not and then
they're done with that. Keeps it simple.

Russell.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
