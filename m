Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 333C267853B
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 19:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbjAWSsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 13:48:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231529AbjAWSsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 13:48:03 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792C610425;
        Mon, 23 Jan 2023 10:47:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=L17bWBvpLq9LtsScoCNuHVlJn5sZdLtTGDRid/gmFMo=; b=lXfJ/CZoABaZ3xsAHT2PM0f77N
        yvlfRbnstflT7++4dUj4JiCHHTLrc+Uik63/Yih4icHxZuAm1yCpoDFH2Q9RyTL12mCxrwJdJYE/k
        /FfMAn504rEflDu89txkQ7V4KA/R7AK/quTJ8MuOStdcI3Wa10eDaKm1+3wOCd7nPZumkaIvm9y3V
        i4oIGT2AGWxNLkyg2GbOQqn9dzz0aBuOq5eCrwKpZTEKZuk19AdnQOWiO1YZkYsnT/owqiwnsDqX1
        LHc6gXnRCwoauWklpi3G98EqKNMkMeAvHg8zNSwwVa8RPx54/n0QzuRiIX0PZnHmCrPajogJwQXXG
        bcXHrPyQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36270)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pK1r2-00055P-JU; Mon, 23 Jan 2023 18:47:40 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pK1qx-0004Xj-DY; Mon, 23 Jan 2023 18:47:35 +0000
Date:   Mon, 23 Jan 2023 18:47:35 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michael Walle <michael@walle.cc>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Xu Liang <lxu@maxlinear.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/5] net: phy: C45-over-C22 access
Message-ID: <Y87WR/T395hKmgKm@shell.armlinux.org.uk>
References: <20230120224011.796097-1-michael@walle.cc>
 <Y87L5r8uzINALLw4@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y87L5r8uzINALLw4@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 07:03:18PM +0100, Andrew Lunn wrote:
> On Fri, Jan 20, 2023 at 11:40:06PM +0100, Michael Walle wrote:
> > After the c22 and c45 access split is finally merged. This can now be
> > posted again. The old version can be found here:
> > https://lore.kernel.org/netdev/20220325213518.2668832-1-michael@walle.cc/
> > Although all the discussion was here:
> > https://lore.kernel.org/netdev/20220323183419.2278676-1-michael@walle.cc/
> > 
> > The goal here is to get the GYP215 and LAN8814 running on the Microchip
> > LAN9668 SoC. The LAN9668 suppports one external bus and unfortunately, the
> > LAN8814 has a bug which makes it impossible to use C45 on that bus.
> > Fortunately, it was the intention of the GPY215 driver to be used on a C22
> > bus. But I think this could have never really worked, because the
> > phy_get_c45_ids() will always do c45 accesses and thus gpy_probe() will
> > fail.
> > 
> > Introduce C45-over-C22 support and use it if the MDIO bus doesn't support
> > C45. Also enable it when a PHY is promoted from C22 to C45.
> 
> I see this breaking up into two problems.
> 
> 1) Scanning the bus and finding device, be it by C22, C45, or C45 over C22.
> 
> 2) Allowing drivers to access C45 register spaces, without caring if
> it is C45 transfers or C45 over C22.
> 
> For scanning the bus we currently have:
> 
> 
>         if (bus->read) {
>                 err = mdiobus_scan_bus_c22(bus);
>                 if (err)
>                         goto error;
>         }
> 
>         prevent_c45_scan = mdiobus_prevent_c45_scan(bus);
> 
>         if (!prevent_c45_scan && bus->read_c45) {
>                 err = mdiobus_scan_bus_c45(bus);
>                 if (err)
>                         goto error;
>         }
> 
> I think we should be adding something like:
> 
> 	else {
> 		if (bus->read) {
> 	                err = mdiobus_scan_bus_c45_over_c22(bus);
> 	                if (err)
> 	                        goto error;
> 	        }
> 	}
> 
> That makes the top level pretty obvious what is going on.
> 
> But i think we need some more cleanup lower down. We now have a clean
> separation in MDIO bus drivers between C22 bus transactions and C45
> transactions bus. But further up it is less clear. PHY drivers should
> be using phy_read_mmd()/phy_write_mmd() etc, which means access the
> C45 address space, but says nothing about what bus transactions to
> use. So that is also quite clean.
> 
> The problem is in the middle.  get_phy_c45_devs_in_pkg() uses
> mdiobus_c45_read(). Does mdiobus_c45_read() mean perform a C45 bus
> transaction, or access the C45 address space? I would say it means
> perform a C45 bus transaction. It does not take a phydev, so we are
> below the concept of PHYs, and so C45 over C22 does not exist at this
> level.

C45-over-C22 is a PHY thing, it isn't generic. We shouldn't go poking
at the PHY C45-over-C22 registers unless we know for certain that the
C22 device we are accessing is a PHY, otherwise we could be writing
into e.g. a switch register or something else.

So, the mdiobus_* API should be the raw bus API. If we want C45 bus
cycles then mdiobus_c45_*() is the API that gives us that, vs C22 bus
cycles through the non-C45 API.

C45-over-C22 being a PHY thing is something that should be handled by
phylib, and currently is. The phylib accessors there will use C45 or
C45-over-C22 as appropriate.

The problem comes with PHYs that maybe don't expose C22 ID registers
but do have C45-over-C22. These aren't detectable without probing
using the C45-over-C22 PHY protocol, but doing that gratuitously will
end up writing values to e.g. switch registers and disrupting their
operation. So I regard that as a very dangerous thing to be doing.

Given that, it seems that such a case could not be automatically
probed, and thus must be described in firmware.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
