Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94DC2A3BA6
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 06:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbgKCFGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 00:06:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgKCFGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 00:06:38 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB891C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 21:06:38 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id r10so12729198pgb.10
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 21:06:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c2ZIq/WN5UWW2OyUQcxUPOmFj7jajgdxihthAFs+XBE=;
        b=fBiVG5PdvjAu4VxWDNtUrqyJ/hRl2Izs2pp1BI5i7cRrhBI+IP+Lq8Z20pAlAP/UQ8
         w/snYd132m2uhux+2yzZ7qT8M7M7GWRlXDPROyW0jUVxZyJz+TeU6NCgP57lVXpjcBWd
         1a6/Uho+9l7Pf0Ky1QYDWv5xR9mYVS8O7joGHz4hcStw8mnQ/okgNX7KQqw7+kyeLTFj
         ssbB2DF/YEcr5/tcPnVHxjXo5ydw2xJson8HKf8iwwAAN/6FJZqr6gLbzzMustIJzeQo
         fCXAeEDIwTrdGKU3ZlM6poWZdLnPCIOqwHUvv3dv3bkJOCFo/KGxwkb4xy3jisU6z5Qw
         nDLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c2ZIq/WN5UWW2OyUQcxUPOmFj7jajgdxihthAFs+XBE=;
        b=jffeZh6Te5aMi8Ep4dqZYHknXg619EOPwt2ii1ppa80UHBPi8PR4k8zV5SiOM7PZ2P
         XAApP3QMVHjCrdhqYfogfxSi4r1IKbnpJ5mOJ82BvnrzFSiLk8DJyNNDajyi5mPOEhSc
         mzASvyEmjFjJ2QuuoKio6IY8lsWNEJnQNldT4MR0lDlX8i+YEV1qqetaE9YH9sPZ/xom
         mERw6zcTKQprpMV2QS3DByc+w3TZaTJULHWQT3EAF3LFdvbx7giVo9BqQecz4646CRuN
         3U94nNvt9rCllddnS8TUnsfVCIJbtBDFYwbWbbw3B+p5GPVw3vPlBJC5yLPxxqsmi7V8
         6WpQ==
X-Gm-Message-State: AOAM532HT/n+ZWEEiuC4ycoXOW9MwB/b/iOYMNK/uXdlFGNAAHikE8Zz
        8heX5qjfBdbnZER9xQRxgfJoVcqQDrK7MCZX
X-Google-Smtp-Source: ABdhPJxtDUAFRByPSy5fBRDXyJjSudM/OAsc+/acVLsKel8cm3l+hv/qgww0vLgSwTp5dCv01ZD8Dw==
X-Received: by 2002:a17:90a:8d81:: with SMTP id d1mr1903992pjo.174.1604379998046;
        Mon, 02 Nov 2020 21:06:38 -0800 (PST)
Received: from container-ubuntu.lan ([240e:398:25dd:4170::b82])
        by smtp.gmail.com with ESMTPSA id h5sm14962213pfn.12.2020.11.02.21.06.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 21:06:36 -0800 (PST)
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
Subject: [PATCH v3 net-next] net: dsa: mt7530: support setting MTU
Date:   Tue,  3 Nov 2020 13:06:18 +0800
Message-Id: <20201103050618.11419-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MT7530/7531 has a global RX packet length register, which can be used
to set MTU.

Supported packet length values are 1522 (1518 if untagged), 1536,
1552, and multiple of 1024 (from 2048 to 15360).

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
v2 -> v3:
	Fix checkpatch.pl warning
v1 -> v2:
	Avoid duplication of mt7530_rmw()
	Fix code wrapping
---
 drivers/net/dsa/mt7530.c | 49 ++++++++++++++++++++++++++++++++++++++++
 drivers/net/dsa/mt7530.h | 12 ++++++++++
 2 files changed, 61 insertions(+)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 771f58f50d61..6408402a44f5 100644
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
+	if (length <= 1522) {
+		val |= MAX_RX_PKT_LEN_1522;
+	} else if (length <= 1536) {
+		val |= MAX_RX_PKT_LEN_1536;
+	} else if (length <= 1552) {
+		val |= MAX_RX_PKT_LEN_1552;
+	} else {
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
index 9278a8e3d04e..ee3523a7537e 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -11,6 +11,9 @@
 #define MT7530_NUM_FDB_RECORDS		2048
 #define MT7530_ALL_MEMBERS		0xff
 
+#define MTK_HDR_LEN	4
+#define MT7530_MAX_MTU	(15 * 1024 - ETH_HLEN - ETH_FCS_LEN - MTK_HDR_LEN)
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

