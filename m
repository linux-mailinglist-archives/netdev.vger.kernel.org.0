Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C421557A41
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 14:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbiFWMZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 08:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbiFWMY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 08:24:59 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B1631DC3
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 05:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xJOlnBVLA6jKgDLDhnntLcNhq2IXUA7xt4ku6EMDRYA=; b=gMqSTppepZ9tR7NCmYgbwGkZFH
        OMoAloXT2pVEVA6DDI/LVYK+8u9PAQHnaVGsGOCzOyBufCq+iySDNRiVLsav6qCqbcszz7714LL81
        8UhqKuJX5j8HIZUH725qFqky6tEZsz/fiKg3qxky4z8W32JPZK76qqVd3cbO/2/BUFv0doqMu9oVG
        o3iKTNjhOrLftAh8RRsCUhfY6ervoSrhTrrIEgVo0l88w7bYpkR3iSP0WhPXtV2nEZc2whWFWDhvL
        RSOKNKpYsvDQknotVTAAL2pt3Nj7HemCdtDNYoov/tXvu1DuZimeaXpsuFChTKwS9RgXfQYkaGXGe
        S6nqAm4g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33000)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o4LtB-0004pk-Eo; Thu, 23 Jun 2022 13:24:49 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o4Lt6-0008Q7-Q6; Thu, 23 Jun 2022 13:24:44 +0100
Date:   Thu, 23 Jun 2022 13:24:44 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 0/2] net: pcs: lynx: consolidate gigabit code
Message-ID: <YrRbjOEEww38JFIK@shell.armlinux.org.uk>
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

This series consolidates the gigabit setup code in the Lynx PCS driver.
In order to do this properly, we first need to fix phylink's
advertisement encoding function to handle QSGMII.

I'd be grateful if someone can test this please.

Thanks.

 drivers/net/pcs/pcs-lynx.c | 56 +++++++++++++++++-----------------------------
 drivers/net/phy/phylink.c  |  1 +
 2 files changed, 22 insertions(+), 35 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
