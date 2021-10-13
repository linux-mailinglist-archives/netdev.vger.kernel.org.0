Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C0542B1FB
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 03:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236835AbhJMBSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 21:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236400AbhJMBSf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 21:18:35 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436DFC061749;
        Tue, 12 Oct 2021 18:16:33 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id ec8so3168986edb.6;
        Tue, 12 Oct 2021 18:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=3IAt1FuB6uBCMbNFm5wiYpy/LAKC6HjVdSQQgksgAGs=;
        b=msgzzVZN0FUKbmnnrM0v9MV/uoP6V1GkCmC8Vg82Go55KZUOQ+Y6nO17uZGXvjsxw2
         gB2Q7C9oLcDwiYZhq8FzcB8rAGH2b49hMtAxmyxvfAkeinqsprqkLNwNS/XqF9WyVCJ9
         uqHr+I/qpjr9F2iArIXh3PQaWzsU/bzzSl6OniwLozlaLttzWSRfa2MAJ1O48KjA2llu
         w+6EHKMY5hwvDBbomO0gMtFnSP1WtN1cgSaLdqYI8gRGyWbIhbDmXHFZViOwPKtPxJUe
         DQHD9ujhHe14Cz5FMbqwKJEFSZVZOG9Y0G7ICTR0IK7jzsS8PKoQbKPR1YVvBbGVZ0sw
         100Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3IAt1FuB6uBCMbNFm5wiYpy/LAKC6HjVdSQQgksgAGs=;
        b=LwgIboPb+H1nxTQQGug4wioD4ri/UST+qNVd3nSyQyy5Xpur70ulxwrQutdb4M6qg8
         HBFDZ40lwgcWrKfKvotR8b8tdFqSDltEjATw+xcPNMAObprgD5tU91Erkd+efvXLUA+M
         9daWtE1dUM7QvtUiaVX0sQdpMVQs+p89zxFTMOxugRchSbGpKmcpWrzpYTji9AyAr9MS
         hM81pGVQCIlozh7FUgAsKiBbSlhj1Yo3uOg04tYP3pt07XyGNCBnUvMjccuw1LKxC1mS
         2qPemgIvsXamd9aCkYBF2re3dWAQNBUgRoEMLKIkjK/HUZ54KvWrksPi6bi7rmGwiLM/
         /yXg==
X-Gm-Message-State: AOAM533weeQRQplJbb5GIduEWNSZKbwtzreGOdDZ9F/g8bf2P8Oul+ho
        a9wipB+okLow/E1dm+PWGRI=
X-Google-Smtp-Source: ABdhPJy1oKnkQP+4xb6RjFJWuLgSCK5+49O264isgJfUugLamanEBrtHGp6Y7lxep6uijIXGRdRH5A==
X-Received: by 2002:a50:d085:: with SMTP id v5mr4849907edd.75.1634087791666;
        Tue, 12 Oct 2021 18:16:31 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id v13sm6894630ede.79.2021.10.12.18.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 18:16:31 -0700 (PDT)
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
Subject: [net-next PATCH v6 05/16] net: dsa: qca8k: add support for cpu port 6
Date:   Wed, 13 Oct 2021 03:16:11 +0200
Message-Id: <20211013011622.10537-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013011622.10537-1-ansuelsmth@gmail.com>
References: <20211013011622.10537-1-ansuelsmth@gmail.com>
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
 drivers/net/dsa/qca8k.c | 50 +++++++++++++++++++++++++++++------------
 drivers/net/dsa/qca8k.h |  2 --
 2 files changed, 36 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 22d6e4abb986..1998090a4c6b 100644
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
@@ -1017,13 +1033,14 @@ static int
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
@@ -1065,7 +1082,7 @@ qca8k_setup(struct dsa_switch *ds)
 		dev_warn(priv->dev, "mib init failed");
 
 	/* Enable QCA header mode on the cpu port */
-	ret = qca8k_write(priv, QCA8K_REG_PORT_HDR_CTRL(QCA8K_CPU_PORT),
+	ret = qca8k_write(priv, QCA8K_REG_PORT_HDR_CTRL(cpu_port),
 			  QCA8K_PORT_HDR_CTRL_ALL << QCA8K_PORT_HDR_CTRL_TX_S |
 			  QCA8K_PORT_HDR_CTRL_ALL << QCA8K_PORT_HDR_CTRL_RX_S);
 	if (ret) {
@@ -1087,10 +1104,10 @@ qca8k_setup(struct dsa_switch *ds)
 
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
 
@@ -1098,7 +1115,7 @@ qca8k_setup(struct dsa_switch *ds)
 	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
 		/* CPU port gets connected to all user ports of the switch */
 		if (dsa_is_cpu_port(ds, i)) {
-			ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(QCA8K_CPU_PORT),
+			ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(cpu_port),
 					QCA8K_PORT_LOOKUP_MEMBER, dsa_user_ports(ds));
 			if (ret)
 				return ret;
@@ -1110,7 +1127,7 @@ qca8k_setup(struct dsa_switch *ds)
 
 			ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
 					QCA8K_PORT_LOOKUP_MEMBER,
-					BIT(QCA8K_CPU_PORT));
+					BIT(cpu_port));
 			if (ret)
 				return ret;
 
@@ -1616,9 +1633,12 @@ static int
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
@@ -1645,7 +1665,9 @@ static void
 qca8k_port_bridge_leave(struct dsa_switch *ds, int port, struct net_device *br)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
-	int i;
+	int cpu_port, i;
+
+	cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
 
 	for (i = 1; i < QCA8K_NUM_PORTS; i++) {
 		if (dsa_to_port(ds, i)->bridge_dev != br)
@@ -1662,7 +1684,7 @@ qca8k_port_bridge_leave(struct dsa_switch *ds, int port, struct net_device *br)
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

