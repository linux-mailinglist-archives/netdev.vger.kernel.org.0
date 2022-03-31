Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7122A4ED8AA
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 13:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235274AbiCaLqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 07:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232341AbiCaLqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 07:46:24 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1AA20826E;
        Thu, 31 Mar 2022 04:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=qjOv6N2Ojfl1GTfvFmgcb7RvfXAELJnXk4L/PDNXWPI=; b=T+A+nn6HUM5jIjUtvo04f4Hy3E
        ub2pFApFWNxTK4X6Gz6a5I+H27TH+ZONizJnYDZFHr5eRCrWyMAg/Iqtf5tkdIycxeuB10KTL2dAX
        4XToF+qFVWAdcxx625SgfQLZH8oMK51gKOnKmPJH2FRC3+zfEAFBtK9jvpEGbvcZxz6+RNLZuolq4
        usFLNGoUfxouhqq+4OLIeDrIGmD3Y2tFdoXuI79Rmh43+iwyXUQVMfZ9Z7z4QHp6R0p1pPI1HIedZ
        Hm82Gvf4BNiEA0My1oFZXfO/xx72fBidXP21w95NnIWWaxcQvnDG594Q40Mz9VFrR1oTWEMBvWb1v
        V75U+c0w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58050)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nZtE4-0004jC-JU; Thu, 31 Mar 2022 12:44:28 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nZtE3-0007af-6i; Thu, 31 Mar 2022 12:44:27 +0100
Date:   Thu, 31 Mar 2022 12:44:27 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Michael Walle <michael@walle.cc>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Xu Liang <lxu@maxlinear.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 4/5] net: phy: introduce is_c45_over_c22 flag
Message-ID: <YkWUGwi0tbWFyUy/@shell.armlinux.org.uk>
References: <20220323183419.2278676-1-michael@walle.cc>
 <20220323183419.2278676-5-michael@walle.cc>
 <Yjt99k57mM5PQ8bT@lunn.ch>
 <8304fb3578ee38525a158af768691e75@walle.cc>
 <Yju+SGuZ9aB52ARi@lunn.ch>
 <30012bd8256be3be9977bd15d1486c84@walle.cc>
 <YjybB/fseibDU4dT@lunn.ch>
 <0d4a2654acd2cc56f7b17981bf14474e@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d4a2654acd2cc56f7b17981bf14474e@walle.cc>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 24, 2022 at 06:18:14PM +0100, Michael Walle wrote:
> Am 2022-03-24 17:23, schrieb Andrew Lunn:
> > > Isn't it safe to assume that if a PHY implements the indirect
> > > registers for c45 in its c22 space that it will also have a valid
> > > PHY ID and then the it's driver will be probed?
> > 
> > See:
> > https://elixir.bootlin.com/linux/latest/source/drivers/net/phy/phy_device.c#L895
> > 
> > No valid ID in C22 space.
> 
> I actually looked at the datasheet and yes, it implements the
> registers 13 and 14 in c22 to access the c45 space. I couldn't
> find any descriptions of other c22 registers though.

I'm not sure which PHY you're referring to here, but iirc, the later
hardware revisions of the 88x3310 implement the indirect access, but
earlier revisions do not.

> > In general, if the core can do something, it is better than the driver
> > doing it. If the core cannot reliably figure it out, then we have to
> > leave it to the drivers. It could well be we need the drivers to set
> > has_c45. I would prefer that drivers don't touch c45_over_c22 because
> > they don't have the knowledge of what the bus is capable of doing. The
> > only valid case i can think of is for a very oddball PHY which has C45
> > register space, but cannot actually do C45 transfers, and so C45 over
> > C22 is the only option.
> 
> And how would you know that the PHY has the needed registers in c22
> space? Or do we assume that every C45 PHY has these registers?

That's the problem. Currently C22 PHY drivers that do not support the
C45 register space have to set the .read_mmd and .write_mmd methods to
genphy_read_mmd_unsupported/genphy_write_mmd_unsupported which
effectively disables access to the C45 register space. In order for
that to happen, we must have read the C22 PHY ID and bound the driver.

That doesn't help with reading the PHY ID though.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
