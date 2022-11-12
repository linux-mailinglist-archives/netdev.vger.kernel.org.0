Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A31FC626990
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 14:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234053AbiKLNP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 08:15:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiKLNPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 08:15:55 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B2518B2B
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 05:15:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=e4Fb6MhKNtqn8XjpTeUYrRtN43sIZ7ji4P9YNs2MEnU=; b=lCYdr/BM/BfSO7pcqF4wPzOYWt
        kjm0HDepRN0YbkFLiqctkRcN6fvLL/7og+Ln0yajzj4QV70kEvyhCXqZmWNwGAATC91IY8nn1GzTu
        oTo0yaTnEJj662horVGVUraGpBCBsBoNi37YxqNh51GPXEZMx+wx56xPlPodGzWZzJdlg/VwzgHyv
        FD3qYtIL/AK3aG434p3SyvIKKqr7gWHtGlgddttWmFmhkjynMa7n7tTYls2IoI/3F6f0yXV8cgGIf
        GO7i4AcnNHhjWt4M9KhSe2sam4kSyqpepM+BtQclRbimxIGdYmeC2onJPay4v49eaDN6N7s+3CLG9
        DS8uRirg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35232)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1otqMO-0007ee-He; Sat, 12 Nov 2022 13:15:48 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1otqMM-00006s-M8; Sat, 12 Nov 2022 13:15:46 +0000
Date:   Sat, 12 Nov 2022 13:15:46 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Tim Harvey <tharvey@gateworks.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: status of rate adaptation
Message-ID: <Y2+cgh4NBQq8EHoX@shell.armlinux.org.uk>
References: <CAJ+vNU3zeNqiGhjTKE8jRjDYR0D7f=iqPLB8phNyA2CWixy7JA@mail.gmail.com>
 <b37de72c-0b5d-7030-a411-6f150d86f2dd@seco.com>
 <2a1590b2-fa9a-f2bf-0ef7-97659244fa9b@seco.com>
 <CAJ+vNU2jc4NefB-kJ0LRtP=ppAXEgoqjofobjbazso7cT2w7PA@mail.gmail.com>
 <b7f31077-c72d-5cd4-30d7-e3e58bb63059@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7f31077-c72d-5cd4-30d7-e3e58bb63059@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 11, 2022 at 04:54:40PM -0500, Sean Anderson wrote:
> > [    8.911932] mvpp2 f2000000.ethernet eth0: PHY
> > [f212a600.mdio-mii:08] driver [Aquantia AQR113C] (irq=POLL)
> > [    8.921577] mvpp2 f2000000.ethernet eth0: phy: 10gbase-r setting
> > supported 00000000,00018000,000e706f advertising
> > 00000000,00018000,000e706f

> > # ethtool eth0
> > Settings for eth0:
> >         Supported ports: [ ]
> >         Supported link modes:   10baseT/Half 10baseT/Full
> >                                 100baseT/Half 100baseT/Full
> 
> 10/100 half duplex aren't achievable with rate matching (and we avoid
> turning them on), so they must be coming from somewhere else. I wonder
> if this is because PHY_INTERFACE_MODE_SGMII is set in
> supported_interfaces.

The reason is due to the way phylink_bringup_phy() works. This is
being called with interface = 10GBASE-R, and the PHY is a C45 PHY,
which means we call phy_get_rate_matching() with 
PHY_INTERFACE_MODE_NA as we don't know whether the PHY will be
switching its interface or not.

Looking at the Aquanta PHY driver, this will return that pause mode
rate matching will be used, so config.rate_matching will be
RATE_MATCH_PAUSE.

phylink_validate() will be called for PHY_INTERFACE_MODE_NA, which
causes it to scan all supported interface modes (as again, we don't
know which will be used by the PHY [*]) and the union of those
results will be used.

So when we e.g. try SGMII mode, caps & mac_capabilities will allow
the half duplex modes through.

Now for the bit marked with [*] - at this point, if rate matching is
will be used, we in fact know which interface mode is going to be in
operation, and it isn't going to change. So maybe we need this instead
in phylink_bringup_phy():

-	if (phy->is_c45 &&
+	config.rate_matching = phy_get_rate_matching(phy, interface);
+	if (phy->is_c45 && config.rate_matching == RATE_MATCH_NONE &&
            interface != PHY_INTERFACE_MODE_RXAUI &&
            interface != PHY_INTERFACE_MODE_XAUI &&
            interface != PHY_INTERFACE_MODE_USXGMII)
                config.interface = PHY_INTERFACE_MODE_NA;
        else
                config.interface = interface;
-	config.rate_matching = phy_get_rate_matching(phy, config.interface);

        ret = phylink_validate(pl, supported, &config);

?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
