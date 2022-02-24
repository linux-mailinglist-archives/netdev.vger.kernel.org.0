Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE8D34C3145
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 17:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiBXQaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 11:30:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiBXQaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 11:30:07 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8801C7EB4
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 08:29:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hmOb6sS0rjImnEIuZ1CMwjM/aO0v0FODYFQFp1xbsf0=; b=QJtaniQshTr15wEMPNMnyAvwxf
        XgdoyXLNaiTTu7CeeAjCEZmH+b04MvgJcLTnvp8a2mUcL0HtrBwFPM1jtHJUBg2OGyV/aPVoOWHtv
        83HXpHabUuvZAQbL6DRbKk5maUkcddBh6z/woV1jNlNcbZSWAAwXJaFYZ/7bP39kN3+5rC91OoMDS
        xlknkalG/bSJvFlFdhKEuKYC209zDseSE8K6YZNLPV3SdhX/spMyLMZD24qE06nmvvjvLXPHV0/v5
        /AT2IjS4mWk3puyR2ikEpSaaZyiQYv+zsdbJ6d57mgdEbe7uu2EKAnuU/Xqe6pChbsvZ3m+W5U1RV
        HSugjCqA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:39184 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nNGmB-0004Cc-Su; Thu, 24 Feb 2022 16:15:31 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nNGmB-00AOj0-A8; Thu, 24 Feb 2022 16:15:31 +0000
In-Reply-To: <YhevAJyU87bfCzfs@shell.armlinux.org.uk>
References: <YhevAJyU87bfCzfs@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Marek Beh__n <kabel@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH RFC net-next 4/6] net: dsa: sja1105: mark as non-legacy
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nNGmB-00AOj0-A8@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 24 Feb 2022 16:15:31 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sja1105 DSA driver does not have a phylink_mac_config() method
implementation, it is safe to mark this as a non-legacy driver.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index b5c36f808df1..8f061cce77f0 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1396,6 +1396,12 @@ static void sja1105_phylink_get_caps(struct dsa_switch *ds, int port,
 {
 	struct sja1105_private *priv = ds->priv;
 
+	/* This driver does not make use of the speed, duplex, pause or the
+	 * advertisement in its mac_config, so it is safe to mark this driver
+	 * as non-legacy.
+	 */
+	config->legacy_pre_march2020 = false;
+
 	/* The SJA1105 MAC programming model is through the static config
 	 * (the xMII Mode table cannot be dynamically reconfigured), and
 	 * we have to program that early.
-- 
2.30.2

