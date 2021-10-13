Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334B142CE9F
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 00:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbhJMWlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 18:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbhJMWlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 18:41:37 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C417C061746;
        Wed, 13 Oct 2021 15:39:33 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id w14so16257803edv.11;
        Wed, 13 Oct 2021 15:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=8oVdA1V73m4bLfskC7r4+QXa22tPmC5Gf3mu/KVuCGo=;
        b=N5wN4R4RgcyTwMOgnhrETt/D1MKS74Urrs44gcYPEa/F9vXzhP5DzyXAiIb9ydWAY3
         qaFQVvH1yCDSv30OnD0gOYL57a85QBEcfwEGVxrv4Hkg8T/OyDhEa4EvzInKHG/GrPTR
         jVWcZJIu+ZouFFR6y/ycCCoseMa1sxegXE3wp00vKWUfzs8WR6wcJaAaxNfp+3wiIdCu
         G+s3dPkuB//MrDi6CKSmS9lXSItyjsviEcxyHVAYC72/Zz2q+0LX6QXBueLMPgYq1259
         k3B+6g1pTHLaeZQjJBTvz4aPBjyIALI0Oil3jHYgGLsNVtLDd34VltQSUVF2G3sa2L6E
         ZwDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8oVdA1V73m4bLfskC7r4+QXa22tPmC5Gf3mu/KVuCGo=;
        b=qD3pAz9YcPzu4yxJc8mue2h5Kh+QCdxNbGcNUg3CE4cGj0BpG7j9SNfSXSNZkhu+EQ
         KFlZ8NbsZSRBiMyt6T08GTi+1w9qwd9xYM+v2W++UqGuzT95a6jk8TFAlsO4bHLfWwBl
         rowd8ZVO3DynlBYsdjPq9TJP1Bk7tL2Xn0oDvGvpcs2fHRbtd3H3stT663fojWx2mQa1
         ipDaIZugdb4GUJA/7jQGSFkSVCTZWYqHgnrOiJR+OsG/fjQYzYTYuZhBcC7AwVp7yX98
         hg2ncDUVL/s8M1rFHLFdr0pGzHF3RzKnQUNkwLv31FGRrxPpG6RipR+jQGALMmPe6dIZ
         jzWA==
X-Gm-Message-State: AOAM533/bAFzhq97/28fMZHSa7sbGr047idaLsIKEvF4YerPjQEFq1C+
        Ii8njzpuEU9ToiC0332Rp84=
X-Google-Smtp-Source: ABdhPJz+0D12cB9Tx8NNuebfEbFi504/Bzy5TRq9G6jnqLslv6AHjav8jnOu83jJBE7iR0UUE9j49w==
X-Received: by 2002:a50:e044:: with SMTP id g4mr3188597edl.46.1634164771507;
        Wed, 13 Oct 2021 15:39:31 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id o3sm524735eju.123.2021.10.13.15.39.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 15:39:31 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        John Crispin <john@phrozen.org>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [net-next PATCH v7 05/16] net: dsa: qca8k: add support for cpu port 6
Date:   Thu, 14 Oct 2021 00:39:10 +0200
Message-Id: <20211013223921.4380-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013223921.4380-1-ansuelsmth@gmail.com>
References: <20211013223921.4380-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently CPU port is always hardcoded to port 0. This switch have 2 CPU
ports. The original intention of this driver seems to be use the
mac06_exchange bit to swap MAC0 with MAC6 in the strange configuration
where device have connected only the CPU port 6. To skip the
introduction of a new binding, rework the driver to address the
secondary CPU port as primary and drop any reference of hardcoded port.
With configuration of mac06 exchange, just skip the definition of port0
and define the CPU port as a secondary. The driver will autoconfigure
the switch to use that as the primary CPU port.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 51 +++++++++++++++++++++++++++++------------
 drivers/net/dsa/qca8k.h |  2 --
 2 files changed, 36 insertions(+), 17 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 22d6e4abb986..bbe3fe9cfaa8 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -977,6 +977,22 @@ qca8k_setup_mac_pwr_sel(struct qca8k_priv *priv)
 	return ret;
 }
 
+static int qca8k_find_cpu_port(struct dsa_switch *ds)
+{
+	struct qca8k_priv *priv = ds->priv;
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
@@ -1017,13 +1033,13 @@ static int
 qca8k_setup(struct dsa_switch *ds)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
-	int ret, i;
+	int cpu_port, ret, i;
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
@@ -1065,7 +1081,7 @@ qca8k_setup(struct dsa_switch *ds)
 		dev_warn(priv->dev, "mib init failed");
 
 	/* Enable QCA header mode on the cpu port */
-	ret = qca8k_write(priv, QCA8K_REG_PORT_HDR_CTRL(QCA8K_CPU_PORT),
+	ret = qca8k_write(priv, QCA8K_REG_PORT_HDR_CTRL(cpu_port),
 			  QCA8K_PORT_HDR_CTRL_ALL << QCA8K_PORT_HDR_CTRL_TX_S |
 			  QCA8K_PORT_HDR_CTRL_ALL << QCA8K_PORT_HDR_CTRL_RX_S);
 	if (ret) {
@@ -1087,10 +1103,10 @@ qca8k_setup(struct dsa_switch *ds)
 
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
 
@@ -1098,7 +1114,7 @@ qca8k_setup(struct dsa_switch *ds)
 	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
 		/* CPU port gets connected to all user ports of the switch */
 		if (dsa_is_cpu_port(ds, i)) {
-			ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(QCA8K_CPU_PORT),
+			ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(cpu_port),
 					QCA8K_PORT_LOOKUP_MEMBER, dsa_user_ports(ds));
 			if (ret)
 				return ret;
@@ -1110,7 +1126,7 @@ qca8k_setup(struct dsa_switch *ds)
 
 			ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
 					QCA8K_PORT_LOOKUP_MEMBER,
-					BIT(QCA8K_CPU_PORT));
+					BIT(cpu_port));
 			if (ret)
 				return ret;
 
@@ -1616,9 +1632,12 @@ static int
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
@@ -1645,7 +1664,9 @@ static void
 qca8k_port_bridge_leave(struct dsa_switch *ds, int port, struct net_device *br)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
-	int i;
+	int cpu_port, i;
+
+	cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
 
 	for (i = 1; i < QCA8K_NUM_PORTS; i++) {
 		if (dsa_to_port(ds, i)->bridge_dev != br)
@@ -1662,7 +1683,7 @@ qca8k_port_bridge_leave(struct dsa_switch *ds, int port, struct net_device *br)
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

