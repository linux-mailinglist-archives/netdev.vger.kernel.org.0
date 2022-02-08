Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 415D14ADC16
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 16:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245039AbiBHPLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 10:11:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234102AbiBHPLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 10:11:38 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DCD2C061577
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 07:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1xpv6tU+daClITjGVgZnNWJ0Q1IIyAM5+CrB5DoTP0k=; b=ZX7Z7J9mRAZKjCKHejFo1bVILp
        BuTNsZp7BtQfgwBWBN1yoruTbPS7LdU2MbUxZbbrjbWgmafkXGVwXi7NgG6RkQlZxQwOPEcvKbiCi
        MyY81+VJJKsGtW5D9JotCN1zCmSHA4WOEjzm3b6cTu2VrFUd13mNZXLPIogISVg+P/bP2ZwilAP5K
        NVkGuYtNkMDq037G5dgeQgmsYNn/42q8H+JfxPkHJZwn/uvuC8Y3wn58NZLm4okG70pdb/oXySIO/
        UGJMMyZhb9hC7VoB7YJNR22Y6SRI5vmAfBANK3h4aX7jRNp2JCvlStlvX12dNkBtZO9WS5aa7EPvR
        H+uMLgPA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57154)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nHS9U-0003I7-IX; Tue, 08 Feb 2022 15:11:32 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nHS9S-0000ey-Am; Tue, 08 Feb 2022 15:11:30 +0000
Date:   Tue, 8 Feb 2022 15:11:30 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH CFT net-next 0/6] net: dsa: qca8k: convert to phylink_pcs and
 mark as non-legacy
Message-ID: <YgKIIq2baq4yERS5@shell.armlinux.org.uk>
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

This series adds support into DSA for the mac_select_pcs method, and
converts qca8k to make use of this, eventually marking qca8k as non-
legacy.

Patch 1 adds DSA support for mac_select_pcs.
Patch 2 and patch 3 moves code around in qca8k to make patch 4 more
readable.
Patch 4 does a simple conversion to phylink_pcs.
Patch 5 moves the serdes configuration to phylink_pcs.
Patch 6 marks qca8k as non-legacy.

 drivers/net/dsa/qca8k.c | 738 +++++++++++++++++++++++++++---------------------
 drivers/net/dsa/qca8k.h |   8 +
 include/net/dsa.h       |   3 +
 net/dsa/port.c          |  15 +
 4 files changed, 436 insertions(+), 328 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
