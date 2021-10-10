Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9127427E46
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 03:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbhJJB6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 21:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbhJJB6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 21:58:13 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F80C061570;
        Sat,  9 Oct 2021 18:56:15 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id t16so30046192eds.9;
        Sat, 09 Oct 2021 18:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AciBJHMxPSxj5ixrhgamlXUQnrChehe6osViae8/6fM=;
        b=IX7HVU6TmY/A/vH86L1VMP3KP8RG1ku2vfHBEXYuOM3RapUwhgkZw3rZvjcVwX/65U
         pEE/6X4lZ76lhiDMDKmKubLFOsKnTARWe6Zig0mcIy0QJBG2X/ZNpB7fHmOPJNYMbMtB
         L/6NlaYwgRR/OYJOhO3sEwg0Jj9OPOP6N8Zy49dPZgB/NLcztafTF0H7rxBQa+Bg1VR6
         pzte2oDMCo/rWtu2CWuviOVgPttwYnTSMOIDPtA6tWU2NUL9eOlJCXYeWHO0AIqlpOsT
         J4p1sybWRkR8JOZrpUYoi6b4maT8u0sSbW/7wvhrc8mMoEWL/WBq1QuOE+V0p8kSIiGY
         5V4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AciBJHMxPSxj5ixrhgamlXUQnrChehe6osViae8/6fM=;
        b=gWnnXxnWG+cRWkimk2Fdq54U61eoo8Ktl2yrPp1aknMEaBaz//hQKMOETFK4aMoBE2
         X8aXg9WFp0/QhnIuhkWDeFfBBTsb+mb9VPutSKI5WMeG8/lB7FQFW7+CmiD4QW6A0lj2
         cYJOeNCvaCv7g+iEiUlb83eQDBB7MhYcjH+auEkOny7YCMq6NCxzUJW+CfGDgfSfI4ep
         74D1jKMWQ6RkEI/cTSGBiujR7kNKfv1PZbWrho7pYx/aWa3JgVKVM+X/vme2Na+rLL2d
         qsxUCuP8aoamTHdjRk5LSCJm5nSm27NvzntIFSWKNPs9B482qjzRMdA/D8kl7zsXHo5p
         PjPQ==
X-Gm-Message-State: AOAM533E9Etyh9wr1+4TV7zxLyU0/ZJ5Ff1KhF/89qaIVk4/7aeOgwE1
        Sv6HhxBufUe9MXmsoSLCg8A=
X-Google-Smtp-Source: ABdhPJz2LeTPz8SzGM7AA26+/Q3t7R4bFeMIAoLpaXt0VQcHX9607I9tnc6KmGKJdOgIiopG5GGLxA==
X-Received: by 2002:a50:a2a5:: with SMTP id 34mr28154145edm.150.1633830973894;
        Sat, 09 Oct 2021 18:56:13 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id x11sm1877253edj.62.2021.10.09.18.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 18:56:13 -0700 (PDT)
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
Subject: [net-next PATCH v3 04/13] drivers: net: dsa: qca8k: add support for cpu port 6
Date:   Sun, 10 Oct 2021 03:55:54 +0200
Message-Id: <20211010015603.24483-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211010015603.24483-1-ansuelsmth@gmail.com>
References: <20211010015603.24483-1-ansuelsmth@gmail.com>
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
index 863eeac6eace..91334fa23183 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -977,17 +977,34 @@ qca8k_setup_mac_pwr_sel(struct qca8k_priv *priv)
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
 
 	mutex_init(&priv->reg_mutex);
@@ -1024,7 +1041,7 @@ qca8k_setup(struct dsa_switch *ds)
 		dev_warn(priv->dev, "mib init failed");
 
 	/* Enable QCA header mode on the cpu port */
-	ret = qca8k_write(priv, QCA8K_REG_PORT_HDR_CTRL(QCA8K_CPU_PORT),
+	ret = qca8k_write(priv, QCA8K_REG_PORT_HDR_CTRL(cpu_port),
 			  QCA8K_PORT_HDR_CTRL_ALL << QCA8K_PORT_HDR_CTRL_TX_S |
 			  QCA8K_PORT_HDR_CTRL_ALL << QCA8K_PORT_HDR_CTRL_RX_S);
 	if (ret) {
@@ -1046,10 +1063,10 @@ qca8k_setup(struct dsa_switch *ds)
 
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
 
@@ -1057,7 +1074,7 @@ qca8k_setup(struct dsa_switch *ds)
 	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
 		/* CPU port gets connected to all user ports of the switch */
 		if (dsa_is_cpu_port(ds, i)) {
-			ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(QCA8K_CPU_PORT),
+			ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(cpu_port),
 					QCA8K_PORT_LOOKUP_MEMBER, dsa_user_ports(ds));
 			if (ret)
 				return ret;
@@ -1069,7 +1086,7 @@ qca8k_setup(struct dsa_switch *ds)
 
 			ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
 					QCA8K_PORT_LOOKUP_MEMBER,
-					BIT(QCA8K_CPU_PORT));
+					BIT(cpu_port));
 			if (ret)
 				return ret;
 
@@ -1578,9 +1595,12 @@ static int
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
@@ -1607,7 +1627,9 @@ static void
 qca8k_port_bridge_leave(struct dsa_switch *ds, int port, struct net_device *br)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
-	int i;
+	int cpu_port, i;
+
+	cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
 
 	for (i = 1; i < QCA8K_NUM_PORTS; i++) {
 		if (dsa_to_port(ds, i)->bridge_dev != br)
@@ -1624,7 +1646,7 @@ qca8k_port_bridge_leave(struct dsa_switch *ds, int port, struct net_device *br)
 	 * this port
 	 */
 	qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
-		  QCA8K_PORT_LOOKUP_MEMBER, BIT(QCA8K_CPU_PORT));
+		  QCA8K_PORT_LOOKUP_MEMBER, BIT(cpu_port));
 }
 
 static int
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 3fded69a6839..5df0f0ef6526 100644
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

