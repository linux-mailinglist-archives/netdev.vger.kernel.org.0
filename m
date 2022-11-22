Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF91634329
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 19:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233478AbiKVSAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 13:00:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233207AbiKVSAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 13:00:07 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91048C77F
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 10:00:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=kdE+iTz7HdZsAUbIuguuCGxCwNValpGxi9IgpjV9eGI=; b=a1BplfK0145jUXUkm6G/Q+xtRt
        8cDMfGG69PaNzFx5Tq3Vra29YGYP2l0HPvqJYmgad0fB5Rb9HJqipofFHJ7Xg7HGF/Np5l1p4GgAv
        hpC+p9x2Dy3l2w1jNkwN5dEV0r1nutgZJ9Q09pdy26h1BwcbO0mjfRoDsx6ut48kJ1kMIySUnZpDI
        bPc3HfHsAb01O0rfwjXnrinUKolLfaybBW0opChu+GaWFLs5fs/7f8m20PpV04fcQzNVI22WE42R0
        xkUmqU/o7gmsKk8suhuopZ2aTjtTowqteBXLNvbUO12ORzp4OkdwCG2Uot8HlJd7fgy/LIN0YFNQY
        PHZnzD3Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35386)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oxXYs-0001ra-At; Tue, 22 Nov 2022 17:59:58 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oxXYk-0003Un-Qe; Tue, 22 Nov 2022 17:59:50 +0000
Date:   Tue, 22 Nov 2022 17:59:50 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Raag Jadav <raagjadav@gmail.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Marek Behun <marek.behun@nic.cz>
Subject: Re: [PATCH v4 net-next 0/8] Let phylink manage in-band AN for the PHY
Message-ID: <Y30OFnm0kFV0isE8@shell.armlinux.org.uk>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
 <c1b102aa-1597-0552-641b-56a811a2520e@seco.com>
 <20221121194444.ran2bec6fhfk72lt@skbuf>
 <4bf812ec-f59b-6f64-b1e0-0feb54138bad@seco.com>
 <20221122001700.hilrumuzc5ulkafi@skbuf>
 <522f823f-70d2-d595-1f2b-1ca447c6f288@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522f823f-70d2-d595-1f2b-1ca447c6f288@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 11:10:03AM -0500, Sean Anderson wrote:
> So maybe we should do (PHY_AN_INBAND_ON | PHY_AN_INBAND_OFF) in that
> case. That said, RGMII in-band is not supported by phylink (yet).

I think people use it - why do you think it isn't supportable?

Why would it need to be any different from something like SGMII? One
can implement a "phylink_pcs" that responds appropriately when in RGMII
mode (which I believe is what others have done.)

Note that Marvell net drivers always register a PCS no matter what
interface mode is being used - I believe the hardware has the ability
to read the RGMII in-band and in that case it's just the same
registers that one has to read to get the status as SGMII.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
