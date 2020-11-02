Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37C322A25B7
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 08:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728027AbgKBH6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 02:58:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726819AbgKBH6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 02:58:35 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F60C0617A6
        for <netdev@vger.kernel.org>; Sun,  1 Nov 2020 23:58:35 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id 72so3689966pfv.7
        for <netdev@vger.kernel.org>; Sun, 01 Nov 2020 23:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Chy9Awg/iyWx87zCUlGYnR/1wfg6BP9EYAKD619Z2eM=;
        b=GlHZ9yuMu763hAPwL9OXTKSsD2PtDpmwWHBNjduITh6mfFr59bLzGg4AJuWs2zfl20
         GnTlt2RTt5kA3K568uKKnIugQrIO/lvEOY+PlIV/s+76dbiIfFr4arFHHeFcV22WE5lH
         ugkkLEFfJ5KMWllhBmhSkTm7bXNP6c9czJzAnEqgnt1l5A+QOSgZjJpYOb6EMnQnU4NW
         qYWc+emgdujwjqc1QL+poAw93DdBBSv3Z0Q7KRLiKM7mRKpV4EoYeexoa2jgEmAW2Sna
         9J9uoVV0wY0BZ0GpvTiX1NAckvxLB+NpUTO/y9ktfHf8XngKVPtjjV5TyWYQbhgJZ6GM
         OSQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Chy9Awg/iyWx87zCUlGYnR/1wfg6BP9EYAKD619Z2eM=;
        b=I4ny3K5P8x9+iYTigYjjq4adryroYGyN40H2ZZfuq4PctQNIpjPTbsdtZ+YfVWA+J+
         z3mEblYFr1sCg3qOjibBNkm/p5gBu6T5u8pdWyf1tZ2hr94OkMJW6ogibsx8LinhJOxV
         toZ0AOc1jA2IVAL68S/7/8UEb0Igz71uufPMgXvwraMHCUvg1abOORtL/Q2HuKvkhLOB
         ciRTXyvTHOC7ZojcZ8BwwoCLn7FjKDjtxQG7kSOtvzJsXj7bo3f1+wC3Icbt1Tx2FHUO
         W0az9gyYFa+pN1fgdxljCrNr3NULonte/XjgAZvefCeJo0fLwdKt3KYVIGuswVAUcrlX
         syYA==
X-Gm-Message-State: AOAM532aL5iV8xQio6k7CO2IbWsFGDozvhpOKVcy5uXFwzrrU/lcmPRk
        PkbWIrjmtoyRidQeZe6OM6SyRmEj2oyMJ+0d
X-Google-Smtp-Source: ABdhPJzLruIBtfkn8mHwQjChM9zlYmCbZnpKEkTAv7XdYFISucWRefanTtxjT29mkf6lI0NWBMWhdQ==
X-Received: by 2002:a63:1e05:: with SMTP id e5mr3008pge.435.1604303914831;
        Sun, 01 Nov 2020 23:58:34 -0800 (PST)
Received: from container-ubuntu.lan ([240e:398:25dd:4170::b82])
        by smtp.gmail.com with ESMTPSA id b6sm11618412pgq.58.2020.11.01.23.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 23:58:33 -0800 (PST)
From:   DENG Qingfang <dqfext@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <landen.chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Chuanhong Guo <gch981213@gmail.com>
Subject: [PATCH v2 net-next] net: dsa: mt7530: support setting MTU
Date:   Mon,  2 Nov 2020 15:58:21 +0800
Message-Id: <20201102075821.26873-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MT7530/7531 has a global RX packet length register, which can be used
to set MTU.

Supported packet length values are 1522 (1518 if untagged), 1536, 1552,
and multiple of 1024 (from 2048 to 15360).

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
v1 -> v2:
	Avoid duplication of mt7530_rmw()
	Fix code wrapping
---
 drivers/net/dsa/mt7530.c | 49 ++++++++++++++++++++++++++++++++++++++++
 drivers/net/dsa/mt7530.h | 12 ++++++++++
 2 files changed, 61 insertions(+)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index de7692b763d8..ca39f81de75a 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1021,6 +1021,53 @@ mt7530_port_disable(struct dsa_switch *ds, int port)
 	mutex_unlock(&priv->reg_mutex);
 }
 
+static int
+mt7530_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
+{
+	struct mt7530_priv *priv = ds->priv;
+	struct mii_bus *bus = priv->bus;
+	int length;
+	u32 val;
+
+	/* When a new MTU is set, DSA always set the CPU port's MTU to the
+	 * largest MTU of the slave ports. Because the switch only has a global
+	 * RX length register, only allowing CPU port here is enough.
+	 */
+	if (!dsa_is_cpu_port(ds, port))
+		return 0;
+
+	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
+
+	val = mt7530_mii_read(priv, MT7530_GMACCR);
+	val &= ~MAX_RX_PKT_LEN_MASK;
+
+	/* RX length also includes Ethernet header, MTK tag, and FCS length */
+	length = new_mtu + ETH_HLEN + MTK_HDR_LEN + ETH_FCS_LEN;
+	if (length <= 1522)
+		val |= MAX_RX_PKT_LEN_1522;
+	else if (length <= 1536)
+		val |= MAX_RX_PKT_LEN_1536;
+	else if (length <= 1552)
+		val |= MAX_RX_PKT_LEN_1552;
+	else {
+		val &= ~MAX_RX_JUMBO_MASK;
+		val |= MAX_RX_JUMBO(DIV_ROUND_UP(length, 1024));
+		val |= MAX_RX_PKT_LEN_JUMBO;
+	}
+
+	mt7530_mii_write(priv, MT7530_GMACCR, val);
+
+	mutex_unlock(&bus->mdio_lock);
+
+	return 0;
+}
+
+static int
+mt7530_port_max_mtu(struct dsa_switch *ds, int port)
+{
+	return MT7530_MAX_MTU;
+}
+
 static void
 mt7530_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 {
@@ -2519,6 +2566,8 @@ static const struct dsa_switch_ops mt7530_switch_ops = {
 	.get_sset_count		= mt7530_get_sset_count,
 	.port_enable		= mt7530_port_enable,
 	.port_disable		= mt7530_port_disable,
+	.port_change_mtu	= mt7530_port_change_mtu,
+	.port_max_mtu		= mt7530_port_max_mtu,
 	.port_stp_state_set	= mt7530_stp_state_set,
 	.port_bridge_join	= mt7530_port_bridge_join,
 	.port_bridge_leave	= mt7530_port_bridge_leave,
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 9278a8e3d04e..77a6222d2635 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -11,6 +11,9 @@
 #define MT7530_NUM_FDB_RECORDS		2048
 #define MT7530_ALL_MEMBERS		0xff
 
+#define MTK_HDR_LEN			4
+#define MT7530_MAX_MTU			(15 * 1024 - ETH_HLEN - ETH_FCS_LEN - MTK_HDR_LEN)
+
 enum mt753x_id {
 	ID_MT7530 = 0,
 	ID_MT7621 = 1,
@@ -289,6 +292,15 @@ enum mt7530_vlan_port_attr {
 #define MT7531_DBG_CNT(x)		(0x3018 + (x) * 0x100)
 #define  MT7531_DIS_CLR			BIT(31)
 
+#define MT7530_GMACCR			0x30e0
+#define  MAX_RX_JUMBO(x)		((x) << 2)
+#define  MAX_RX_JUMBO_MASK		GENMASK(5, 2)
+#define  MAX_RX_PKT_LEN_MASK		GENMASK(1, 0)
+#define  MAX_RX_PKT_LEN_1522		0x0
+#define  MAX_RX_PKT_LEN_1536		0x1
+#define  MAX_RX_PKT_LEN_1552		0x2
+#define  MAX_RX_PKT_LEN_JUMBO		0x3
+
 /* Register for MIB */
 #define MT7530_PORT_MIB_COUNTER(x)	(0x4000 + (x) * 0x100)
 #define MT7530_MIB_CCR			0x4fe0
-- 
2.25.1

