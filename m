Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9916463430C
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 18:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234411AbiKVRyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 12:54:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234525AbiKVRy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 12:54:29 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5FADFCC8
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 09:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vDNIHl7HjUK4qnj+62lmuQ9kdA37W2iOkqCjlLIcJ8s=; b=yydZg85PpfBni/xTNOZCwLzX5L
        ckyTc7wadkbhJ/ZhQ9//zpyowfD7qy2CjJg2x/7rO+HdQSj5xZN0p4VIW7RAxxAIG5VfUH765Rqp4
        kIOc3tQ3VLHG70GSy++myn7ZnET/QAFF/usS5SrFMKQ0l12nmXTucGNVn8MFlDjiK6gnsxbbAPm0v
        IU5T5Kwf/uNtRKrQV/MLbLwBcvuRqVuNHZ15dSlrUMaYM85xWvRmpCUtq8x0xSW2Vag3cH3kz0K79
        ECZXun7iYeLqbLoM8iS36YWabWpBsdoUxqM7iAvRNER6BC+Wj/FF9hUg9ecMa5RxzfXRAtEQjQtdG
        EN0ksdfA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35384)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oxXR4-0001qf-G7; Tue, 22 Nov 2022 17:51:54 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oxXR0-0003Ub-NQ; Tue, 22 Nov 2022 17:51:50 +0000
Date:   Tue, 22 Nov 2022 17:51:50 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
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
        Sean Anderson <sean.anderson@seco.com>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Raag Jadav <raagjadav@gmail.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Marek Behun <marek.behun@nic.cz>
Subject: Re: [PATCH v4 net-next 3/8] net: phy: bcm84881: move the in-band
 capability check where it belongs
Message-ID: <Y30MNsLs164iX3x5@shell.armlinux.org.uk>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
 <20221118000124.2754581-4-vladimir.oltean@nxp.com>
 <Y3yYo63kj+ACdkW1@shell.armlinux.org.uk>
 <20221122122451.5hk5aw4q6mu6t22o@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122122451.5hk5aw4q6mu6t22o@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 02:24:51PM +0200, Vladimir Oltean wrote:
> On Tue, Nov 22, 2022 at 09:38:43AM +0000, Russell King (Oracle) wrote:
> > 88E1111 is the commonly used accessible PHY on gigabit SFPs, as this
> > PHY implements I2C access natively.
> 
> As a side question, I suppose it would be possible to put PHYs on copper
> SFP modules even if they don't natively implement I2C access. In that case,
> if configuration from the host is at all available, how does that happen,
> is there some sort of protocol translator (I2C -> MDIO) on the module?

Modules that provide access to the PHY seem to do so on I2C address 0x56
and require specific I2C access patterns. I think the 88e1111 set a kind
of "standard" and many follow that or similar.

Some just don't give any kind of access to the PHY - for example, the
Mikrotik modules have an AR803x PHY on them, but there is no way to
access it.

> Do you know of any part number for an I2C controlled MDIO controller?

I think many that don't use a microcontroller - for example, when
someone puts an 88x3310, bcm84881, the protocols are very similar but
timing may vary.

Some of the patches from Marek provided a different way - via the 0x50
or 0x51 "eeprom" addresses, accessing specific addresses with in those
spaces, and if I remember correctly, requiring a "password" to enable
access.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
