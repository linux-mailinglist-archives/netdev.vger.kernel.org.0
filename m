Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1DB34284A5
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 03:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233309AbhJKBcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 21:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233386AbhJKBct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 21:32:49 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D249EC061768;
        Sun, 10 Oct 2021 18:30:48 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id w19so1180025edd.2;
        Sun, 10 Oct 2021 18:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RvcgLEGbaMhvDuwWOKcUYnieM2kaNhY3qJwye4t2Aik=;
        b=A3bNLmkJ0m/S8kPfQ3O/Gr+CtNR+SwGApWSzu0OMIf2ol5uYUDefdUM2edTmAx4pIX
         sNDtvTuUuYDwRMJTKLJEPFgUZFAfetWd37qPbYO1tXLT7SuCJ8AVwKTOxM8qhYhIBw9I
         JNQtY5cesRSOClG7uT1zyo2VZS4RoIM0LZqQm4p6h6gH8boysVrCwiqDi7kGxCPZKyRF
         v6ih7gfwFm+aPmYVBwgz2n8quDeqS70CwBQmDXsATFp9rJWQfjnrmUmWJd3tMdtdI+ss
         y++K1PMGPhBJ0lfWexRRu2fQZZ5XDCfcgFzVkxO4UBFA6kXDHZjPuc/zQ2Lmg1Q1elxX
         2VRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RvcgLEGbaMhvDuwWOKcUYnieM2kaNhY3qJwye4t2Aik=;
        b=WVzkJswutFhTjuNydAQ2O65DaNnOT7ATBhN+0LYbGh8WjjYi7YInnbR42B1jvrsIWV
         ASsGP8E5jDoV9DcbP/p7xQMND1usQTE79v5Jt9AdNbk6ZbkFunXG6GvqH0u8GVxatRrR
         l5EAOazDGF/rd2dBTBTambtd2BP+R3SmoSuxynPb+9PiQE8mo7/pkk3wfyn3KSn2sAtY
         fLF7h4647F8aqlvaOisw4GnUQjM5b8jkDfXMJ1lcF6el111sr4m2pZpjahAsREAxPYUx
         Hq8aTvQSJWs6OrNervQCaLABVKaBstvYuecKZcmKrQtx+6eNdZce/cW0T0CUDUhwdBCN
         MpbA==
X-Gm-Message-State: AOAM530102Mgzof7KklTKMC1HguqPQjJ755o8bLbuHVpfBJ4e6/kKRzj
        7PXA68DJMLj6o6RtMKbS9Ho=
X-Google-Smtp-Source: ABdhPJxhYLNeu3MP+HRd0ATW0hBBuSswmZwy92gJu3gyIRvagrZ1jMhES8Lu8wdqTCpdUX3uHykdVw==
X-Received: by 2002:a17:906:c0d:: with SMTP id s13mr7979501ejf.309.1633915847371;
        Sun, 10 Oct 2021 18:30:47 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id m15sm21314edd.5.2021.10.10.18.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 18:30:47 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v5 05/14] drivers: net: dsa: qca8k: add support for cpu port 6
Date:   Mon, 11 Oct 2021 03:30:15 +0200
Message-Id: <20211011013024.569-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211011013024.569-1-ansuelsmth@gmail.com>
References: <20211011013024.569-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently CPU port is always hardcoded to port 0. This switch have 2 CPU
port. The original intention of this driver seems to be use the
mac06_exchange bit to swap MAC0 with MAC6 in the strange configuration
where device have connected only the CPU port 6. To skip the
introduction of a new binding, rework the driver to address the
secondary CPU port as primary and drop any reference of hardcoded port.
With configuration of mac06 exchange, just skip the definition of port0
and define the CPU port as a secondary. The driver will autoconfigure
the switch to use that as the primary CPU port.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 50 +++++++++++++++++++++++++++++------------
 drivers/net/dsa/qca8k.h |  2 --
 2 files changed, 36 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index e335a4cfcb75..de50116d483e 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -977,6 +977,22 @@ qca8k_setup_mac_pwr_sel(struct qca8k_priv *priv)
 	return ret;
 }
 
+static int qca8k_find_cpu_port(struct dsa_switch *ds)
+{
+	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
+
+	/* Find the connected cpu port. Valid port are 0 or 6 */
+	if (dsa_is_cpu_port(ds, 0))
+		return 0;
+
+	dev_dbg(priv->dev, "port 0 is not the CPU port. Checking port 6");
+
+	if (dsa_is_cpu_port(ds, 6))
+		return 6;
+
+	return -EINVAL;
+}
+
 static int
 qca8k_parse_port_config(struct qca8k_priv *priv)
 {
@@ -1011,13 +1027,14 @@ static int
 qca8k_setup(struct dsa_switch *ds)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
+	u8 cpu_port;
 	int ret, i;
 	u32 mask;
 
-	/* Make sure that port 0 is the cpu port */
-	if (!dsa_is_cpu_port(ds, 0)) {
-		dev_err(priv->dev, "port 0 is not the CPU port");
-		return -EINVAL;
+	cpu_port = qca8k_find_cpu_port(ds);
+	if (cpu_port < 0) {
+		dev_err(priv->dev, "No cpu port configured in both cpu port0 and port6");
+		return cpu_port;
 	}
 
 	/* Parse CPU port config to be later used in phy_link mac_config */
@@ -1059,7 +1076,7 @@ qca8k_setup(struct dsa_switch *ds)
 		dev_warn(priv->dev, "mib init failed");
 
 	/* Enable QCA header mode on the cpu port */
-	ret = qca8k_write(priv, QCA8K_REG_PORT_HDR_CTRL(QCA8K_CPU_PORT),
+	ret = qca8k_write(priv, QCA8K_REG_PORT_HDR_CTRL(cpu_port),
 			  QCA8K_PORT_HDR_CTRL_ALL << QCA8K_PORT_HDR_CTRL_TX_S |
 			  QCA8K_PORT_HDR_CTRL_ALL << QCA8K_PORT_HDR_CTRL_RX_S);
 	if (ret) {
@@ -1081,10 +1098,10 @@ qca8k_setup(struct dsa_switch *ds)
 
 	/* Forward all unknown frames to CPU port for Linux processing */
 	ret = qca8k_write(priv, QCA8K_REG_GLOBAL_FW_CTRL1,
-			  BIT(0) << QCA8K_GLOBAL_FW_CTRL1_IGMP_DP_S |
-			  BIT(0) << QCA8K_GLOBAL_FW_CTRL1_BC_DP_S |
-			  BIT(0) << QCA8K_GLOBAL_FW_CTRL1_MC_DP_S |
-			  BIT(0) << QCA8K_GLOBAL_FW_CTRL1_UC_DP_S);
+			  BIT(cpu_port) << QCA8K_GLOBAL_FW_CTRL1_IGMP_DP_S |
+			  BIT(cpu_port) << QCA8K_GLOBAL_FW_CTRL1_BC_DP_S |
+			  BIT(cpu_port) << QCA8K_GLOBAL_FW_CTRL1_MC_DP_S |
+			  BIT(cpu_port) << QCA8K_GLOBAL_FW_CTRL1_UC_DP_S);
 	if (ret)
 		return ret;
 
@@ -1092,7 +1109,7 @@ qca8k_setup(struct dsa_switch *ds)
 	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
 		/* CPU port gets connected to all user ports of the switch */
 		if (dsa_is_cpu_port(ds, i)) {
-			ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(QCA8K_CPU_PORT),
+			ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(cpu_port),
 					QCA8K_PORT_LOOKUP_MEMBER, dsa_user_ports(ds));
 			if (ret)
 				return ret;
@@ -1104,7 +1121,7 @@ qca8k_setup(struct dsa_switch *ds)
 
 			ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
 					QCA8K_PORT_LOOKUP_MEMBER,
-					BIT(QCA8K_CPU_PORT));
+					BIT(cpu_port));
 			if (ret)
 				return ret;
 
@@ -1610,9 +1627,12 @@ static int
 qca8k_port_bridge_join(struct dsa_switch *ds, int port, struct net_device *br)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
-	int port_mask = BIT(QCA8K_CPU_PORT);
+	int port_mask, cpu_port;
 	int i, ret;
 
+	cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
+	port_mask = BIT(cpu_port);
+
 	for (i = 1; i < QCA8K_NUM_PORTS; i++) {
 		if (dsa_to_port(ds, i)->bridge_dev != br)
 			continue;
@@ -1639,7 +1659,9 @@ static void
 qca8k_port_bridge_leave(struct dsa_switch *ds, int port, struct net_device *br)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
-	int i;
+	int cpu_port, i;
+
+	cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
 
 	for (i = 1; i < QCA8K_NUM_PORTS; i++) {
 		if (dsa_to_port(ds, i)->bridge_dev != br)
@@ -1656,7 +1678,7 @@ qca8k_port_bridge_leave(struct dsa_switch *ds, int port, struct net_device *br)
 	 * this port
 	 */
 	qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
-		  QCA8K_PORT_LOOKUP_MEMBER, BIT(QCA8K_CPU_PORT));
+		  QCA8K_PORT_LOOKUP_MEMBER, BIT(cpu_port));
 }
 
 static int
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index bc9c89dd7e71..781521e6a965 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -24,8 +24,6 @@
 
 #define QCA8K_NUM_FDB_RECORDS				2048
 
-#define QCA8K_CPU_PORT					0
-
 #define QCA8K_PORT_VID_DEF				1
 
 /* Global control registers */
-- 
2.32.0

