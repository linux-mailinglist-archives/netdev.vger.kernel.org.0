Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72B5C4C4415
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 13:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240374AbiBYMAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 07:00:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238780AbiBYMAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 07:00:39 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC902614B4
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 04:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=eRV5LkPH0KYq9VzxZXZQiGF/wkBVGXkB1BxB9vZ/1Ao=; b=pEWrTXPJpvfyNcOvMK2PLQcAk2
        dX8l+7dbQlxqjKZwsI4nS5WIvlgre/3U6GafMV6NHgrGKzNJQixFA3Y/seO2YOwDyu8HXO847bfHy
        V7s754Gk5diHl8rUwtzXzwE5E1NUO0QgG8cKBRIrpoNgztGGIRjZxcFOnatWPJ9AKuTCMXQJuonYx
        B39B6f0vi/fwWcQeMBZhIMpCyt8xL5mUlC+Bb3Ke+zSGmVUrDDduEffDFFjjgOxtNqvkZRxg7DrBg
        uSpO2v8jYyDa+c20qMCId1i/g41oYP+rX1AsEotyU0CNuqMx1rVdty1EiR8afwsZQsmPlJMZHzDT4
        /oBv28xA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:46074 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nNZGU-0005Ik-Nb; Fri, 25 Feb 2022 12:00:03 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nNZGU-00AbGh-3Q; Fri, 25 Feb 2022 12:00:02 +0000
In-Reply-To: <YhjEm/Vu+w1XQpGT@shell.armlinux.org.uk>
References: <YhjEm/Vu+w1XQpGT@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Marek Beh__n <kabel@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 1/6] net: dsa: sja1105: populate supported_interfaces
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nNZGU-00AbGh-3Q@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 25 Feb 2022 12:00:02 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Populate the supported interfaces bitmap for the SJA1105 DSA switch.

This switch only supports a static model of configuration, so we
restrict the interface modes to the configured setting.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index b513713be610..90e73a982faf 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1412,6 +1412,18 @@ static void sja1105_mac_link_up(struct dsa_switch *ds, int port,
 	sja1105_inhibit_tx(priv, BIT(port), false);
 }
 
+static void sja1105_phylink_get_caps(struct dsa_switch *ds, int port,
+				     struct phylink_config *config)
+{
+	struct sja1105_private *priv = ds->priv;
+
+	/* The SJA1105 MAC programming model is through the static config
+	 * (the xMII Mode table cannot be dynamically reconfigured), and
+	 * we have to program that early.
+	 */
+	__set_bit(priv->phy_mode[port], config->supported_interfaces);
+}
+
 static void sja1105_phylink_validate(struct dsa_switch *ds, int port,
 				     unsigned long *supported,
 				     struct phylink_link_state *state)
@@ -3152,6 +3164,7 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.set_ageing_time	= sja1105_set_ageing_time,
 	.port_change_mtu	= sja1105_change_mtu,
 	.port_max_mtu		= sja1105_get_max_mtu,
+	.phylink_get_caps	= sja1105_phylink_get_caps,
 	.phylink_validate	= sja1105_phylink_validate,
 	.phylink_mac_config	= sja1105_mac_config,
 	.phylink_mac_link_up	= sja1105_mac_link_up,
-- 
2.30.2

