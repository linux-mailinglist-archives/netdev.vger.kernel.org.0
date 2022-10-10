Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8505FA1C9
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 18:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiJJQVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 12:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiJJQVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 12:21:51 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A3F73936
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 09:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=C7/TLgl48OEc/EiKxr4IRgvPLdcdAEmzQf9EksVq0fI=; b=WQU/sySpCVKWypy4xkT5LzxpVy
        fRP1GfD9vupDX8wGqwFO5lXaCdweQU5BKkAQRQIsFmBxEtx+iADNxfNIP0bMTCEEaDcak5BYmVNXF
        fNEzZvNXdbeIlpvW8Js/mD/rY3oUYPXd0/Xy5A1R2WdvwucThl2TmzzCD1sBEXWcRHPnX0vedgdCe
        fw/QfSFXYPorGgKgCT9L62ZrxfIhM2DE96LC9DABvzvHrJ3lUse4Tru/Fu0HrmZdC3MHbOdCnVxhG
        YENOpK4//u06okxk1Y5MKPck0XxPEZxmg6h7Hu39CqLBl87RaBxFYv+WXTRySfAiZ1to0pz/fifOK
        zj+K+uMA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34672)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ohvXE-0004sq-GS; Mon, 10 Oct 2022 17:21:44 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ohvXC-0001zJ-QF; Mon, 10 Oct 2022 17:21:42 +0100
Date:   Mon, 10 Oct 2022 17:21:42 +0100
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
Message-ID: <Y0RGlr6hdBIE4Gwg@shell.armlinux.org.uk>
References: <20221007154246.838404-1-shenwei.wang@nxp.com>
 <Y0EmbNyFhT/HsBMh@shell.armlinux.org.uk>
 <PAXPR04MB9185302A6164DC02812B471589209@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <Y0Q4zqhEjzIU2dIX@shell.armlinux.org.uk>
 <PAXPR04MB9185313B299F8788906E0EE789209@PAXPR04MB9185.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PAXPR04MB9185313B299F8788906E0EE789209@PAXPR04MB9185.eurprd04.prod.outlook.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 10, 2022 at 04:11:36PM +0000, Shenwei Wang wrote:
> 
> 
> > -----Original Message-----
> > From: Russell King <linux@armlinux.org.uk>
> > Sent: Monday, October 10, 2022 10:23 AM
> > To: Shenwei Wang <shenwei.wang@nxp.com>
> > Cc: Andrew Lunn <andrew@lunn.ch>; Heiner Kallweit <hkallweit1@gmail.com>;
> > David S. Miller <davem@davemloft.net>; Eric Dumazet
> > > > with an accessible PHY, what should happen if the system goes into a low
> > power state?
> > > >
> > >
> > > In theory, the SFP should be covered by this patch too. Since the
> > > resume flow is Controlled by the value of phydev->mac_managed_pm, it
> > > should work in the same way after the phydev is linked to the SFP phy instance.
> > 
> > It won't, because the MAC doesn't know when it needs to call your new function.
> > 
> > Given this, I think a different approach is needed here:
> > 
> > 1) require a MAC to call this function after phylink_create() and record
> >    the configuration in struct phylink, or put a configuration boolean in
> >    the phylink_config structure (probably better).
> > 
> 
> I prefer to use the function call because it is simple to implement and is easy to use.

	blah->phylink_config.mac_managed_pm = true;

in the appropriate drivers before they call phylink_create() would be
difficult to use?

Given that we use this method to configure the MAC speeds and phy
interface modes already, I'm not sure why we'd want some other approach
for this.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
