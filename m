Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A92AB52D795
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 17:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240991AbiESPcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 11:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240935AbiESPch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 11:32:37 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 823405C84D;
        Thu, 19 May 2022 08:32:35 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 52196FF804;
        Thu, 19 May 2022 15:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652974354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H/loyWDzc9X11Tf8C5CPf6PW/Ft0RiVlInj9tX+NPZg=;
        b=X+gHFMidJYS9rXgUSgxi0wcZgQRBBccLYdh1vd2TtM1ngJlViD3n8U2EEe4fM/7s1ejXtz
        OywKjjr+VOSTiVUJmxRhQLFhwIwZkFCXQIqycuxFBe1OgyXEUe0/KGF/rCcGBw7QJ6+i75
        HkpmZUlWpnwd+E0a8cEVCJBKbGOVNQgDlrts4q7Iq2v1G9u8tqMDnv/rW6KzDT5GyKL0VX
        JyKXWQ0KYT/F1A3ifJxML5JPFKiydCtzHWn3QuULXAwddXt1LwNdtfaECKW8jrxCLXB40M
        kado6ht4AA/CrLzCeFBEpEx1ENg6hC/v2CbQkY46ZP/Hm84S2HwIkGcNZk0iRA==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v5 02/13] net: dsa: add support for ethtool get_rmon_stats()
Date:   Thu, 19 May 2022 17:30:56 +0200
Message-Id: <20220519153107.696864-3-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220519153107.696864-1-clement.leger@bootlin.com>
References: <20220519153107.696864-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to allow dsa drivers to specify the .get_rmon_stats()
operation.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 include/net/dsa.h |  3 +++
 net/dsa/slave.c   | 13 +++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 14f07275852b..64da5ed27fdc 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -888,6 +888,9 @@ struct dsa_switch_ops {
 				     struct ethtool_eth_mac_stats *mac_stats);
 	void	(*get_eth_ctrl_stats)(struct dsa_switch *ds, int port,
 				      struct ethtool_eth_ctrl_stats *ctrl_stats);
+	void	(*get_rmon_stats)(struct dsa_switch *ds, int port,
+				  struct ethtool_rmon_stats *rmon_stats,
+				  const struct ethtool_rmon_hist_range **ranges);
 	void	(*get_stats64)(struct dsa_switch *ds, int port,
 				   struct rtnl_link_stats64 *s);
 	void	(*self_test)(struct dsa_switch *ds, int port,
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 291197859cea..6cfe07ce06d6 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1002,6 +1002,18 @@ dsa_slave_get_eth_ctrl_stats(struct net_device *dev,
 		ds->ops->get_eth_ctrl_stats(ds, dp->index, ctrl_stats);
 }
 
+static void
+dsa_slave_get_rmon_stats(struct net_device *dev,
+			 struct ethtool_rmon_stats *rmon_stats,
+			 const struct ethtool_rmon_hist_range **ranges)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+
+	if (ds->ops->get_rmon_stats)
+		ds->ops->get_rmon_stats(ds, dp->index, rmon_stats, ranges);
+}
+
 static void dsa_slave_net_selftest(struct net_device *ndev,
 				   struct ethtool_test *etest, u64 *buf)
 {
@@ -2081,6 +2093,7 @@ static const struct ethtool_ops dsa_slave_ethtool_ops = {
 	.get_eth_phy_stats	= dsa_slave_get_eth_phy_stats,
 	.get_eth_mac_stats	= dsa_slave_get_eth_mac_stats,
 	.get_eth_ctrl_stats	= dsa_slave_get_eth_ctrl_stats,
+	.get_rmon_stats		= dsa_slave_get_rmon_stats,
 	.set_wol		= dsa_slave_set_wol,
 	.get_wol		= dsa_slave_get_wol,
 	.set_eee		= dsa_slave_set_eee,
-- 
2.36.0

