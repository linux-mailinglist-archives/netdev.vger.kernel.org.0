Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55A0F4ED8B5
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 13:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbiCaLwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 07:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbiCaLwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 07:52:41 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31A3204A87;
        Thu, 31 Mar 2022 04:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Z81mBq9n6F6GvxliPO/Y2+LeA5qWcREr5/0B8kb5LaM=; b=nLSSZPWZkz+/pIAbjaTTubmC5s
        UMD2QOgYnp424zA+TSDhHgSRqD6hpcqFaH66YXcK/JY0FLkARmWVQfELouFvHEem0r5l+ZnTnEb+U
        QonJkg9Xnq8GvC2hi3Xui9EshyWZrLLrB0jOWzw6oQGxHlXXpGMcbOfJ34Uv1/DwT+Jr9oxtePZUz
        vle1jDo4biTcHchlI8UmhJo6AIpJ9dgWzLEw2ctTOq95wiEB7eiyX/BllHuDPqY2Qbiu9QmxTMVwl
        axMwulNbVnIbSEp335NZf5rvTXAzi3phwoXvn0Ypb52yoAtvIBUmZMvDBmS4A1cT2vpBXE1CoSK4d
        8cr5tLEA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58052)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nZtK8-0004kC-4n; Thu, 31 Mar 2022 12:50:43 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nZtK6-0007ao-IH; Thu, 31 Mar 2022 12:50:42 +0100
Date:   Thu, 31 Mar 2022 12:50:42 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Xu Liang <lxu@maxlinear.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 4/5] net: phy: introduce is_c45_over_c22 flag
Message-ID: <YkWVku32gbaBAdEH@shell.armlinux.org.uk>
References: <20220323183419.2278676-1-michael@walle.cc>
 <20220323183419.2278676-5-michael@walle.cc>
 <Yjt99k57mM5PQ8bT@lunn.ch>
 <8304fb3578ee38525a158af768691e75@walle.cc>
 <Yju+SGuZ9aB52ARi@lunn.ch>
 <30012bd8256be3be9977bd15d1486c84@walle.cc>
 <YjybB/fseibDU4dT@lunn.ch>
 <0d4a2654acd2cc56f7b17981bf14474e@walle.cc>
 <Yjy+oCLdnu3FrNp+@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yjy+oCLdnu3FrNp+@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 24, 2022 at 07:55:28PM +0100, Andrew Lunn wrote:
> > The
> > > only valid case i can think of is for a very oddball PHY which has C45
> > > register space, but cannot actually do C45 transfers, and so C45 over
> > > C22 is the only option.
> > 
> > And how would you know that the PHY has the needed registers in c22
> > space? Or do we assume that every C45 PHY has these registers?
> 
> I think it is a reasonable assumption at the moment. We have around
> 170 MDIO bus masters in Linux. All but one can do C22.

I don't think that is correct. I'm aware of the Marvell XMDIO driver
that is C45 only, and also xgene's non-rgmii "xfi" variant which is
also C45 only. Note that the xfi variant doesn't reject C22 and makes
no distinction between a C22 and C45 access (so a C22 access to
phy_id = 0 reg = 0 hits C45 phy_id = 0 mmd 0 reg 0.

MDIO drivers are IMHO an utter mess and are in dire need of fixing...
and I'm coming to the conclusion that the bodge of passing both C22
and C45 accesses through the same read/write functions is a huge
mistake, one that is crying out for fixing to prevent more prolification
of this kind of mess.

Yes, it's a lot of work, but I think it needs to be done. Retrofitting
the MDIO drivers with checks etc sounds nice, but if we assume that
patches will continue to be applied to net-next with little review,
we have a losing battle - it would be better to have interfaces designed
to make this kind of mistake impossible.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
