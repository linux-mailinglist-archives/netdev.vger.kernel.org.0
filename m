Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D68844A86E2
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 15:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234428AbiBCOsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 09:48:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiBCOsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 09:48:06 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693E8C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 06:48:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=IGltMAYYacqruL0D621VYGxWRCahJMLE4UDPf/HNBNY=; b=vl5VnTkOcQLzhnw2pbIKDn6xTc
        x0600fLfwj2LZrzOlFfMLtL6TWZU9MPcJgmsDrAMjSerOnYmQVCmoe+L07ThL8nqad/chZCIe+/vZ
        dx5pQ7EwhtRDWnY9tx5M/V/DdHmH3+V0GP/ijQFvxfWw5eaJ9rA4AzMsN+qmSPBtoKN4U3kVK9TKk
        V1t8exkBOoLa6Pm0deZfHsfL9dngqpA6HglSjzi7JCWsIngl1wL0Dn7dU1/8USk5BsrI4s1AN6nHL
        jXIRyRifLcnJwvPaJy92KZ8V8EmbKBtxf2KBwJeas+Ff4LjGzyk9bpxwmdSCJwF/fZXRsNH0T+s+z
        /0To1RNw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57012)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nFdP0-0002kZ-Ug; Thu, 03 Feb 2022 14:48:03 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nFdOz-00045W-7d; Thu, 03 Feb 2022 14:48:01 +0000
Date:   Thu, 3 Feb 2022 14:48:01 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH RFC net-next 0/5] net: dsa: b53: convert to
 phylink_generic_validate() and mark as non-legacy
Message-ID: <YfvrIf/FDddglaKE@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
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
 drivers/net/dsa/b53/b53_serdes.c | 17 ++++++----
 drivers/net/dsa/b53/b53_serdes.h |  5 ++-
 drivers/net/dsa/b53/b53_srab.c   | 35 ++++++++++++++++++++-
 5 files changed, 85 insertions(+), 48 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
