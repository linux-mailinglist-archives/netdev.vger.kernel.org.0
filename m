Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCB1C633824
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 10:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbiKVJRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 04:17:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233220AbiKVJRJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 04:17:09 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6521F65FB
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 01:17:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ow0Gykxhi4ZKcT25/UkP0C3OzOAmZWaa81b24KOdtPY=; b=Yi3dDE+f73WiE07rL4Id2T5qJm
        pik4CmzDNHnR/Qwbtu7FFEWmW1UqvH1iJwMeHeQDk/qxRAyshZcIVPiO4OB9ZFuEy3uqPWmkHPvB9
        Yxm2khJYisZXnIZ65TNzHjMi/xC4bd426Tq6MJqpTrtDb2NYsc9FkkS9bmcwCplaZVIg8KvHhB9aE
        uImkDoSqKwcj/hchv+KhhN04kAbxwaUybebMp0WmqWGHY7WRrkBHz+DYFcwBbiYp2FpY3W9J120tc
        u3ee5Kw+NXb7YqLJhhlBsVrg6lONnJUa134kjgwaqCthQtk1vDoisvy/OGYhzGKfhgwEVlpF9z73T
        Tu/mAuMw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35372)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oxPOl-0001EC-Dm; Tue, 22 Nov 2022 09:16:59 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oxPOe-0003Cr-U9; Tue, 22 Nov 2022 09:16:52 +0000
Date:   Tue, 22 Nov 2022 09:16:52 +0000
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
Message-ID: <Y3yThJ+aFxMNjzli@shell.armlinux.org.uk>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
 <c1b102aa-1597-0552-641b-56a811a2520e@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1b102aa-1597-0552-641b-56a811a2520e@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 01:38:31PM -0500, Sean Anderson wrote:
> # dmesg | grep net6
> [    3.826156] fsl_dpaa_mac 1aea000.ethernet net6: renamed from eth3
> [    5.062654] fsl_dpaa_mac 1aea000.ethernet net6: PHY driver does not report in-band autoneg capability, assuming true
> [    5.089724] fsl_dpaa_mac 1aea000.ethernet net6: PHY [0x0000000001afc000:04] driver [RTL8211F Gigabit Ethernet] (irq=POLL)
> [    5.089734] fsl_dpaa_mac 1aea000.ethernet net6: phy: sgmii setting supported 0,00000000,00000000,000062ea advertising 0,00000000,00000000,000062ea
> [    5.089782] fsl_dpaa_mac 1aea000.ethernet net6: configuring for inband/sgmii link mode
> [    5.089786] fsl_dpaa_mac 1aea000.ethernet net6: major config sgmii
> [    5.090951] fsl_dpaa_mac 1aea000.ethernet net6: phylink_mac_config: mode=inband/sgmii/Unknown/Unknown/none adv=0,00000000,00000000,000062ea pause=00 link=0 an=1
> [    5.118325] fsl_dpaa_mac 1aea000.ethernet net6: phy link down sgmii/Unknown/Unknown/none/off
> [    9.214204] fsl_dpaa_mac 1aea000.ethernet net6: phy link up sgmii/1Gbps/Full/none/rx/tx
> [    9.214247] fsl_dpaa_mac 1aea000.ethernet net6: Link is Up - 1Gbps/Full - flow control rx/tx
> 
> I believe this is the same issue I ran into before. This is why I
> defaulted to in-band.

Yes, when operating in SGMII mode, some PHYs:
1) require SGMII in-band to be acknowledged by the MAC
2) provide SGMII in-band but will time out
3) don't provide any SGMII in-band

It sounds like you have case (1), and the options currently are (as
you've identified) to either state in DT that in-band is being used,
or use ovr_an_inband in the driver (if it's a recent conversion that
used in-band mode without needing extra properties.)

Vladimir's patches provide us another way to solve this problem - but
relies upon the PHY drivers being updated to correctly report whether
the hardware will be using in-band. If they don't, then we're lost at
sea and have no idea whether (1) or (3) applies, and in that case we
have to fall back to today's behaviour, which is dependent on
describing it in DT or using ovr_an_inband.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
