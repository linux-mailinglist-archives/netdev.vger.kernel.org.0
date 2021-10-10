Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 155EC4280AC
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 13:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231949AbhJJLSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 07:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231842AbhJJLSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 07:18:09 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73EF1C061766;
        Sun, 10 Oct 2021 04:16:11 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id d9so31489895edh.5;
        Sun, 10 Oct 2021 04:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZflUlU1Q+G8Wz2IhYw63plsUuHcgO1I3JHgbsz4LQAw=;
        b=fuRVhnPTO7ziNBAGuop123Ueo5El46A093eDgEbZiCv38cO4nl03pII3WGqWOZpfFd
         /srOVsAcbg/Nlh6Ch2/lqdqSIc+St7LsBT/4H97pvQiR1qa4SeL9kT66C5c8Ezfg3Jrr
         YMNRCFe6j5n5vV0HQNp1YONDYA7Q8zCU7feF2CL2JxzuoiqBeLTPZ6Bpr8gvz8Jzi3/N
         rXYZz0HUdRjSupX7avcRz+sW7fss3JuoXOu3jaI8BfoGj77bbxt/ublG6G89kT/t26h+
         3YM5SS/RfAgfg6NL4AyqKTQK2o7XeXmB8Ie8k/JVwRC3LncyCA1nzwKoam46ck0NDBgx
         Tv3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZflUlU1Q+G8Wz2IhYw63plsUuHcgO1I3JHgbsz4LQAw=;
        b=pvaM5qIAkUsqO+kKxW/JcIgB+Zt/LTLoaZjKtgeclXTi74jMSYsXDrLAIKU8HG1aSU
         y3uhX/blcdvC+wVvbJwAHgl7nskl4q4mu6WqDBHRNnF0X3nr3BzcDVznEi8mkT4qvIEE
         vAGwzFOs7UWs5ETcPQh3Jv0idgJK//CeNf6t6VJiJ1YQVyS3stiL9ZIUNknDeleGRpmp
         rQWrKlX7qxF2YUdUD/PbhTyQVkfb+ZhYSWaakanAz3I+sKDLQqGesprYgwJszTW9Otlz
         zxYtMiXDu6PQA8zeFpWO9GACN2uC5zUDtUl87vCln7wjURtp7zo6vKVfvUA/wDNQvihF
         Nj8Q==
X-Gm-Message-State: AOAM531Mv6z0xqZRR3qUWU11Igh80u2/XB5ghsXLVFBMElQj+Ha4UvfV
        vGiZeMbqlyYbpmp3tJ2yGDg=
X-Google-Smtp-Source: ABdhPJw/guKetrT7yuZ6O5tExihhSqvkOaZAc9bSnWlXynPhtgwf3h0BHgAVbSYwvs+LFYVO4I6bTg==
X-Received: by 2002:a17:906:a1c1:: with SMTP id bx1mr10781476ejb.447.1633864569940;
        Sun, 10 Oct 2021 04:16:09 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id z5sm2414438edm.82.2021.10.10.04.16.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 04:16:09 -0700 (PDT)
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
Subject: [net-next PATCH v4 04/13] drivers: net: dsa: qca8k: add support for cpu port 6
Date:   Sun, 10 Oct 2021 13:15:47 +0200
Message-Id: <20211010111556.30447-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211010111556.30447-1-ansuelsmth@gmail.com>
References: <20211010111556.30447-1-ansuelsmth@gmail.com>
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
index 3e4a12d6d61c..df0a622acdd7 100644
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

