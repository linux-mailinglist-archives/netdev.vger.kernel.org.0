Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E54E4BF58F
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 11:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiBVKOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 05:14:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbiBVKOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 05:14:43 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB00C13D554
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 02:14:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7zR0xy8+s9tfmUMtJSBJSldQt23GfcdnQ2OMSGovPmU=; b=Ywy93ucYj5FlVNLMmM6hq5gX6z
        SZXwMB/v/V9uP8Hx64eKqwtI5veHsgrkEFJgbMrh821wkUDVZthDEz10mySh4LoXol6iXTK9ccPcq
        7abKBhSheiIT8kQldrEb6Qzib41eu6f9+LOGXsk2t2nXDP+SMa5ALBe+eTCUgoyGOrqBdA8dFYTlG
        VhOC9m+mPzsYz90nLN00xun6+doZHMszseppntgp0TYclCcIY8XpIY6Mf75pWoQrBiXHb5lAAGoVN
        UySavNVKFH1I01cg3Vzfcn5Uu7djGLYZK9KAQYP4QXsvh8NLeifCTK1BA31yiwYGslb2WmSCHYPOv
        yELUQKVg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57406)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nMSBQ-0001OS-8L; Tue, 22 Feb 2022 10:14:12 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nMSBO-0008Bm-HO; Tue, 22 Feb 2022 10:14:10 +0000
Date:   Tue, 22 Feb 2022 10:14:10 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/5] net: dsa: b53: convert to
 phylink_generic_validate() and mark as non-legacy
Message-ID: <YhS3cko8D5c5tr+E@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series converts b53 to use phylink_generic_validate() and also
marks this driver as non-legacy.

Patch 1 cleans up an if() condition to be more readable before we
proceed with the conversion.

Patch 2 populates the supported_interfaces and mac_capabilities members
of phylink_config.

Patch 3 drops the use of phylink_helper_basex_speed() which is now not
necessary.

Patch 4 switches the driver to use phylink_generic_validate()

Patch 5 marks the driver as non-legacy.

 drivers/net/dsa/b53/b53_common.c | 68 +++++++++++++++++++++-------------------
 drivers/net/dsa/b53/b53_priv.h   |  8 ++---
 drivers/net/dsa/b53/b53_serdes.c | 19 +++++++----
 drivers/net/dsa/b53/b53_serdes.h |  5 ++-
 drivers/net/dsa/b53/b53_srab.c   | 35 ++++++++++++++++++++-
 5 files changed, 87 insertions(+), 48 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
