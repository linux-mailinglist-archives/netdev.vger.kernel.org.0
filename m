Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFD5454F10
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 22:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240871AbhKQVKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 16:10:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240724AbhKQVJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 16:09:14 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995E0C06121D;
        Wed, 17 Nov 2021 13:05:39 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id b15so16976647edd.7;
        Wed, 17 Nov 2021 13:05:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=voHasubOl4yjrBnGvpgDnZaTAFDHFUdqqD3/Df86kaU=;
        b=ZAaA9+J3QDqsQuWcYdwuAVNnHLHZyvMvMg/o3O2gg44YGGKK/xF05asoR5A/aEpGM8
         GFCE2KqQ4f7mX0KwEKmSiFgB3o/v1QimsrN27PW/738XJIMKC4WnCzF7rrJF2ekBPUe0
         Lrl/D3Qh4tQ2zpZ0nwmYXPSTj7BZ1SqZ2cbK7RBvSjOJPqdeRRslZCqO/AmC95RJ9k8N
         NmunusufzAeTW43H/5vvy3nt6BNhFmPi/aczEgLWSvzgqKe+eyMBrmxP1CTsHnKJDmzQ
         +ZwYT5eRgML0fEXWYKSOLyJBVuwocC+KKeqIISUtnuGbYvd70CoIXsCTG6a1q+rSPOLL
         FKMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=voHasubOl4yjrBnGvpgDnZaTAFDHFUdqqD3/Df86kaU=;
        b=z1F2lO+EUJtTVwI0uNueXtXTdBsGD9mVgsjy+dgjqAcu6laylHWJhnG550/W4oMVLT
         49IwN2gA4RtITbPZ/s52T2PqrGsxsIZf5TPtHzeCR37G/vaiMvSVbYJvdltEBDcjfRz4
         3FGnplxORMAMS+FtePqxDgiYRRcdfETXM4y4UXhwPL6hbIWG9XoyMgWlyg1b4LvWRqp/
         bWsKbX0vpLy6eZHXNYMRjON1lVxlhAY7hu9t2Xnl2uej3e/KaXBZfJo/fU9t3jMXJMfz
         GG9o5DbHb5B/lwoRsLyAYskuSK9EOIU0JzYeixqZfWZ71/yWa17QhLdKMGgKs+lD/plg
         I2ng==
X-Gm-Message-State: AOAM53321YDxTjBAt3ebPu2kpCsXaZQvjpjjbCPZ+f0NCyAgLawk/7Xg
        ubrOC+e5zsT3KMYixPf7Rpc=
X-Google-Smtp-Source: ABdhPJwY7FN/r60ySNI4td5AXvv9WlxpshDRuqxQB74DsL273+GUc7iOhIqWPyEhd9c6Y9+E7mdRPw==
X-Received: by 2002:a17:906:a1da:: with SMTP id bx26mr26520839ejb.558.1637183137663;
        Wed, 17 Nov 2021 13:05:37 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id di4sm467070ejc.11.2021.11.17.13.05.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 13:05:37 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [net-next PATCH 19/19] net: dsa: qca8k: split qca8k in common and 8xxx specific code
Date:   Wed, 17 Nov 2021 22:04:51 +0100
Message-Id: <20211117210451.26415-20-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117210451.26415-1-ansuelsmth@gmail.com>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The qca8k family reg structure is used also in the internal ipq40xx
switch. Split qca8k common code from specific code for future
implementation of ipq40xx internal switch based on qca8k.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/Makefile                  |    3 +-
 drivers/net/dsa/qca/{qca8k.c => qca8k-8xxx.c} | 1168 +----------------
 drivers/net/dsa/qca/qca8k-common.c            | 1157 ++++++++++++++++
 drivers/net/dsa/qca/qca8k.h                   |   50 +
 4 files changed, 1222 insertions(+), 1156 deletions(-)
 rename drivers/net/dsa/qca/{qca8k.c => qca8k-8xxx.c} (56%)
 create mode 100644 drivers/net/dsa/qca/qca8k-common.c

diff --git a/drivers/net/dsa/qca/Makefile b/drivers/net/dsa/qca/Makefile
index 16f84acf0246..31ef72d4b20a 100644
--- a/drivers/net/dsa/qca/Makefile
+++ b/drivers/net/dsa/qca/Makefile
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_NET_DSA_AR9331)	+= ar9331.o
-obj-$(CONFIG_NET_DSA_QCA8K)	+= qca8k.o
\ No newline at end of file
+obj-$(CONFIG_NET_DSA_QCA8K)	+= qca8k.o
+qca8k-y 			+= qca8k-common.o qca8k-8xxx.o
\ No newline at end of file
diff --git a/drivers/net/dsa/qca/qca8k.c b/drivers/net/dsa/qca/qca8k-8xxx.c
similarity index 56%
rename from drivers/net/dsa/qca/qca8k.c
rename to drivers/net/dsa/qca/qca8k-8xxx.c
index 260cdac53990..1dbb8fe52457 100644
--- a/drivers/net/dsa/qca/qca8k.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -22,57 +22,6 @@
 
 #include "qca8k.h"
 
-#define MIB_DESC(_s, _o, _n)	\
-	{			\
-		.size = (_s),	\
-		.offset = (_o),	\
-		.name = (_n),	\
-	}
-
-static const struct qca8k_mib_desc ar8327_mib[] = {
-	MIB_DESC(1, 0x00, "RxBroad"),
-	MIB_DESC(1, 0x04, "RxPause"),
-	MIB_DESC(1, 0x08, "RxMulti"),
-	MIB_DESC(1, 0x0c, "RxFcsErr"),
-	MIB_DESC(1, 0x10, "RxAlignErr"),
-	MIB_DESC(1, 0x14, "RxRunt"),
-	MIB_DESC(1, 0x18, "RxFragment"),
-	MIB_DESC(1, 0x1c, "Rx64Byte"),
-	MIB_DESC(1, 0x20, "Rx128Byte"),
-	MIB_DESC(1, 0x24, "Rx256Byte"),
-	MIB_DESC(1, 0x28, "Rx512Byte"),
-	MIB_DESC(1, 0x2c, "Rx1024Byte"),
-	MIB_DESC(1, 0x30, "Rx1518Byte"),
-	MIB_DESC(1, 0x34, "RxMaxByte"),
-	MIB_DESC(1, 0x38, "RxTooLong"),
-	MIB_DESC(2, 0x3c, "RxGoodByte"),
-	MIB_DESC(2, 0x44, "RxBadByte"),
-	MIB_DESC(1, 0x4c, "RxOverFlow"),
-	MIB_DESC(1, 0x50, "Filtered"),
-	MIB_DESC(1, 0x54, "TxBroad"),
-	MIB_DESC(1, 0x58, "TxPause"),
-	MIB_DESC(1, 0x5c, "TxMulti"),
-	MIB_DESC(1, 0x60, "TxUnderRun"),
-	MIB_DESC(1, 0x64, "Tx64Byte"),
-	MIB_DESC(1, 0x68, "Tx128Byte"),
-	MIB_DESC(1, 0x6c, "Tx256Byte"),
-	MIB_DESC(1, 0x70, "Tx512Byte"),
-	MIB_DESC(1, 0x74, "Tx1024Byte"),
-	MIB_DESC(1, 0x78, "Tx1518Byte"),
-	MIB_DESC(1, 0x7c, "TxMaxByte"),
-	MIB_DESC(1, 0x80, "TxOverSize"),
-	MIB_DESC(2, 0x84, "TxByte"),
-	MIB_DESC(1, 0x8c, "TxCollision"),
-	MIB_DESC(1, 0x90, "TxAbortCol"),
-	MIB_DESC(1, 0x94, "TxMultiCol"),
-	MIB_DESC(1, 0x98, "TxSingleCol"),
-	MIB_DESC(1, 0x9c, "TxExcDefer"),
-	MIB_DESC(1, 0xa0, "TxDefer"),
-	MIB_DESC(1, 0xa4, "TxLateCol"),
-	MIB_DESC(1, 0xa8, "RXUnicast"),
-	MIB_DESC(1, 0xac, "TXUnicast"),
-};
-
 /* The 32bit switch registers are accessed indirectly. To achieve this we need
  * to set the page of the register. Track the last page that was set to reduce
  * mdio writes
@@ -228,30 +177,6 @@ qca8k_regmap_update_bits(void *ctx, uint32_t reg, uint32_t mask, uint32_t write_
 	return ret;
 }
 
-static const struct regmap_range qca8k_readable_ranges[] = {
-	regmap_reg_range(0x0000, 0x00e4), /* Global control */
-	regmap_reg_range(0x0100, 0x0168), /* EEE control */
-	regmap_reg_range(0x0200, 0x0270), /* Parser control */
-	regmap_reg_range(0x0400, 0x0454), /* ACL */
-	regmap_reg_range(0x0600, 0x0718), /* Lookup */
-	regmap_reg_range(0x0800, 0x0b70), /* QM */
-	regmap_reg_range(0x0c00, 0x0c80), /* PKT */
-	regmap_reg_range(0x0e00, 0x0e98), /* L3 */
-	regmap_reg_range(0x1000, 0x10ac), /* MIB - Port0 */
-	regmap_reg_range(0x1100, 0x11ac), /* MIB - Port1 */
-	regmap_reg_range(0x1200, 0x12ac), /* MIB - Port2 */
-	regmap_reg_range(0x1300, 0x13ac), /* MIB - Port3 */
-	regmap_reg_range(0x1400, 0x14ac), /* MIB - Port4 */
-	regmap_reg_range(0x1500, 0x15ac), /* MIB - Port5 */
-	regmap_reg_range(0x1600, 0x16ac), /* MIB - Port6 */
-
-};
-
-static const struct regmap_access_table qca8k_readable_table = {
-	.yes_ranges = qca8k_readable_ranges,
-	.n_yes_ranges = ARRAY_SIZE(qca8k_readable_ranges),
-};
-
 static struct regmap_config qca8k_regmap_config = {
 	.reg_bits = 16,
 	.val_bits = 32,
@@ -265,330 +190,6 @@ static struct regmap_config qca8k_regmap_config = {
 	.cache_type = REGCACHE_NONE, /* Explicitly disable CACHE */
 };
 
-static int
-qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
-{
-	u32 val;
-
-	return regmap_read_poll_timeout(priv->regmap, reg, val, !(val & mask), 0,
-				       QCA8K_BUSY_WAIT_TIMEOUT * USEC_PER_MSEC);
-}
-
-static int
-qca8k_fdb_read(struct qca8k_priv *priv, struct qca8k_fdb *fdb)
-{
-	u32 reg[4], val;
-	int i, ret;
-
-	/* load the ARL table into an array */
-	for (i = 0; i < 4; i++) {
-		ret = regmap_read(priv->regmap, QCA8K_REG_ATU_DATA0 + (i * 4), &val);
-		if (ret < 0)
-			return ret;
-
-		reg[i] = val;
-	}
-
-	/* vid - 83:72 */
-	fdb->vid = FIELD_GET(QCA8K_ATU_VID_MASK, reg[2]);
-	/* aging - 67:64 */
-	fdb->aging = FIELD_GET(QCA8K_ATU_STATUS_MASK, reg[2]);
-	/* portmask - 54:48 */
-	fdb->port_mask = FIELD_GET(QCA8K_ATU_PORT_MASK, reg[1]);
-	/* mac - 47:0 */
-	fdb->mac[0] = FIELD_GET(QCA8K_ATU_ADDR0_MASK, reg[1]);
-	fdb->mac[1] = FIELD_GET(QCA8K_ATU_ADDR1_MASK, reg[1]);
-	fdb->mac[2] = FIELD_GET(QCA8K_ATU_ADDR2_MASK, reg[0]);
-	fdb->mac[3] = FIELD_GET(QCA8K_ATU_ADDR3_MASK, reg[0]);
-	fdb->mac[4] = FIELD_GET(QCA8K_ATU_ADDR4_MASK, reg[0]);
-	fdb->mac[5] = FIELD_GET(QCA8K_ATU_ADDR5_MASK, reg[0]);
-
-	return 0;
-}
-
-static void
-qca8k_fdb_write(struct qca8k_priv *priv, u16 vid, u8 port_mask, const u8 *mac,
-		u8 aging)
-{
-	u32 reg[3] = { 0 };
-	int i;
-
-	/* vid - 83:72 */
-	reg[2] = FIELD_PREP(QCA8K_ATU_VID_MASK, vid);
-	/* aging - 67:64 */
-	reg[2] |= FIELD_PREP(QCA8K_ATU_STATUS_MASK, aging);
-	/* portmask - 54:48 */
-	reg[1] = FIELD_PREP(QCA8K_ATU_PORT_MASK, port_mask);
-	/* mac - 47:0 */
-	reg[1] |= FIELD_PREP(QCA8K_ATU_ADDR0_MASK, mac[0]);
-	reg[1] |= FIELD_PREP(QCA8K_ATU_ADDR1_MASK, mac[1]);
-	reg[0] |= FIELD_PREP(QCA8K_ATU_ADDR2_MASK, mac[2]);
-	reg[0] |= FIELD_PREP(QCA8K_ATU_ADDR3_MASK, mac[3]);
-	reg[0] |= FIELD_PREP(QCA8K_ATU_ADDR4_MASK, mac[4]);
-	reg[0] |= FIELD_PREP(QCA8K_ATU_ADDR5_MASK, mac[5]);
-
-	/* load the array into the ARL table */
-	for (i = 0; i < 3; i++)
-		regmap_write(priv->regmap, QCA8K_REG_ATU_DATA0 + (i * 4), reg[i]);
-}
-
-static int
-qca8k_fdb_access(struct qca8k_priv *priv, enum qca8k_fdb_cmd cmd, int port)
-{
-	u32 reg;
-	int ret;
-
-	/* Set the command and FDB index */
-	reg = QCA8K_ATU_FUNC_BUSY;
-	reg |= cmd;
-	if (port >= 0) {
-		reg |= QCA8K_ATU_FUNC_PORT_EN;
-		reg |= FIELD_PREP(QCA8K_ATU_FUNC_PORT_MASK, port);
-	}
-
-	/* Write the function register triggering the table access */
-	ret = regmap_write(priv->regmap, QCA8K_REG_ATU_FUNC, reg);
-	if (ret)
-		return ret;
-
-	/* wait for completion */
-	ret = qca8k_busy_wait(priv, QCA8K_REG_ATU_FUNC, QCA8K_ATU_FUNC_BUSY);
-	if (ret)
-		return ret;
-
-	/* Check for table full violation when adding an entry */
-	if (cmd == QCA8K_FDB_LOAD) {
-		ret = regmap_read(priv->regmap, QCA8K_REG_ATU_FUNC, &reg);
-		if (ret < 0)
-			return ret;
-		if (reg & QCA8K_ATU_FUNC_FULL)
-			return -1;
-	}
-
-	return 0;
-}
-
-static int
-qca8k_fdb_next(struct qca8k_priv *priv, struct qca8k_fdb *fdb, int port)
-{
-	int ret;
-
-	qca8k_fdb_write(priv, fdb->vid, fdb->port_mask, fdb->mac, fdb->aging);
-	ret = qca8k_fdb_access(priv, QCA8K_FDB_NEXT, port);
-	if (ret < 0)
-		return ret;
-
-	return qca8k_fdb_read(priv, fdb);
-}
-
-static int
-qca8k_fdb_add(struct qca8k_priv *priv, const u8 *mac, u16 port_mask,
-	      u16 vid, u8 aging)
-{
-	int ret;
-
-	mutex_lock(&priv->reg_mutex);
-	qca8k_fdb_write(priv, vid, port_mask, mac, aging);
-	ret = qca8k_fdb_access(priv, QCA8K_FDB_LOAD, -1);
-	mutex_unlock(&priv->reg_mutex);
-
-	return ret;
-}
-
-static int
-qca8k_fdb_del(struct qca8k_priv *priv, const u8 *mac, u16 port_mask, u16 vid)
-{
-	int ret;
-
-	mutex_lock(&priv->reg_mutex);
-	qca8k_fdb_write(priv, vid, port_mask, mac, 0);
-	ret = qca8k_fdb_access(priv, QCA8K_FDB_PURGE, -1);
-	mutex_unlock(&priv->reg_mutex);
-
-	return ret;
-}
-
-static void
-qca8k_fdb_flush(struct qca8k_priv *priv)
-{
-	mutex_lock(&priv->reg_mutex);
-	qca8k_fdb_access(priv, QCA8K_FDB_FLUSH, -1);
-	mutex_unlock(&priv->reg_mutex);
-}
-
-static int
-qca8k_fdb_search(struct qca8k_priv *priv, struct qca8k_fdb *fdb, const u8 *mac, u16 vid)
-{
-	int ret;
-
-	mutex_lock(&priv->reg_mutex);
-	qca8k_fdb_write(priv, vid, 0, mac, 0);
-	ret = qca8k_fdb_access(priv, QCA8K_FDB_SEARCH, -1);
-	if (ret < 0)
-		goto exit;
-
-	ret = qca8k_fdb_read(priv, fdb);
-exit:
-	mutex_unlock(&priv->reg_mutex);
-	return ret;
-}
-
-static int
-qca8k_vlan_access(struct qca8k_priv *priv, enum qca8k_vlan_cmd cmd, u16 vid)
-{
-	u32 reg;
-	int ret;
-
-	/* Set the command and VLAN index */
-	reg = QCA8K_VTU_FUNC1_BUSY;
-	reg |= cmd;
-	reg |= FIELD_PREP(QCA8K_VTU_FUNC1_VID_MASK, vid);
-
-	/* Write the function register triggering the table access */
-	ret = regmap_write(priv->regmap, QCA8K_REG_VTU_FUNC1, reg);
-	if (ret)
-		return ret;
-
-	/* wait for completion */
-	ret = qca8k_busy_wait(priv, QCA8K_REG_VTU_FUNC1, QCA8K_VTU_FUNC1_BUSY);
-	if (ret)
-		return ret;
-
-	/* Check for table full violation when adding an entry */
-	if (cmd == QCA8K_VLAN_LOAD) {
-		ret = regmap_read(priv->regmap, QCA8K_REG_VTU_FUNC1, &reg);
-		if (ret < 0)
-			return ret;
-		if (reg & QCA8K_VTU_FUNC1_FULL)
-			return -ENOMEM;
-	}
-
-	return 0;
-}
-
-static int
-qca8k_vlan_add(struct qca8k_priv *priv, u8 port, u16 vid, bool untagged)
-{
-	u32 reg;
-	int ret;
-
-	/*
-	   We do the right thing with VLAN 0 and treat it as untagged while
-	   preserving the tag on egress.
-	 */
-	if (vid == 0)
-		return 0;
-
-	mutex_lock(&priv->reg_mutex);
-	ret = qca8k_vlan_access(priv, QCA8K_VLAN_READ, vid);
-	if (ret < 0)
-		goto out;
-
-	ret = regmap_read(priv->regmap, QCA8K_REG_VTU_FUNC0, &reg);
-	if (ret < 0)
-		goto out;
-	reg |= QCA8K_VTU_FUNC0_VALID | QCA8K_VTU_FUNC0_IVL_EN;
-	reg &= ~QCA8K_VTU_FUNC0_EG_MODE_PORT_MASK(port);
-	if (untagged)
-		reg |= QCA8K_VTU_FUNC0_EG_MODE_PORT_UNTAG(port);
-	else
-		reg |= QCA8K_VTU_FUNC0_EG_MODE_PORT_TAG(port);
-
-	ret = regmap_write(priv->regmap, QCA8K_REG_VTU_FUNC0, reg);
-	if (ret)
-		goto out;
-	ret = qca8k_vlan_access(priv, QCA8K_VLAN_LOAD, vid);
-
-out:
-	mutex_unlock(&priv->reg_mutex);
-
-	return ret;
-}
-
-static int
-qca8k_vlan_del(struct qca8k_priv *priv, u8 port, u16 vid)
-{
-	u32 reg, mask;
-	int ret, i;
-	bool del;
-
-	mutex_lock(&priv->reg_mutex);
-	ret = qca8k_vlan_access(priv, QCA8K_VLAN_READ, vid);
-	if (ret < 0)
-		goto out;
-
-	ret = regmap_read(priv->regmap, QCA8K_REG_VTU_FUNC0, &reg);
-	if (ret < 0)
-		goto out;
-	reg &= ~QCA8K_VTU_FUNC0_EG_MODE_PORT_MASK(port);
-	reg |= QCA8K_VTU_FUNC0_EG_MODE_PORT_NOT(port);
-
-	/* Check if we're the last member to be removed */
-	del = true;
-	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
-		mask = QCA8K_VTU_FUNC0_EG_MODE_PORT_NOT(i);
-
-		if ((reg & mask) != mask) {
-			del = false;
-			break;
-		}
-	}
-
-	if (del) {
-		ret = qca8k_vlan_access(priv, QCA8K_VLAN_PURGE, vid);
-	} else {
-		ret = regmap_write(priv->regmap, QCA8K_REG_VTU_FUNC0, reg);
-		if (ret)
-			goto out;
-		ret = qca8k_vlan_access(priv, QCA8K_VLAN_LOAD, vid);
-	}
-
-out:
-	mutex_unlock(&priv->reg_mutex);
-
-	return ret;
-}
-
-static int
-qca8k_mib_init(struct qca8k_priv *priv)
-{
-	int ret;
-
-	mutex_lock(&priv->reg_mutex);
-	ret = regmap_set_bits(priv->regmap, QCA8K_REG_MIB, QCA8K_MIB_FLUSH | QCA8K_MIB_BUSY);
-	if (ret)
-		goto exit;
-
-	ret = qca8k_busy_wait(priv, QCA8K_REG_MIB, QCA8K_MIB_BUSY);
-	if (ret)
-		goto exit;
-
-	ret = regmap_set_bits(priv->regmap, QCA8K_REG_MIB, QCA8K_MIB_CPU_KEEP);
-	if (ret)
-		goto exit;
-
-	ret = regmap_write(priv->regmap, QCA8K_REG_MODULE_EN, QCA8K_MODULE_EN_MIB);
-
-exit:
-	mutex_unlock(&priv->reg_mutex);
-	return ret;
-}
-
-static void
-qca8k_port_set_status(struct qca8k_priv *priv, int port, int enable)
-{
-	u32 mask = QCA8K_PORT_STATUS_TXMAC | QCA8K_PORT_STATUS_RXMAC;
-
-	/* Port 0 and 6 have no internal PHY */
-	if (port > 0 && port < 6)
-		mask |= QCA8K_PORT_STATUS_LINK_AUTO;
-
-	if (enable)
-		regmap_set_bits(priv->regmap, QCA8K_REG_PORT_STATUS(port), mask);
-	else
-		regmap_clear_bits(priv->regmap, QCA8K_REG_PORT_STATUS(port), mask);
-}
-
 static u32
 qca8k_port_to_phy(int port)
 {
@@ -1571,772 +1172,29 @@ qca8k_phylink_validate(struct dsa_switch *ds, int port,
 	linkmode_and(state->advertising, state->advertising, mask);
 }
 
-static int
-qca8k_phylink_mac_link_state(struct dsa_switch *ds, int port,
-			     struct phylink_link_state *state)
-{
-	struct qca8k_priv *priv = ds->priv;
-	u32 reg;
-	int ret;
-
-	ret = regmap_read(priv->regmap, QCA8K_REG_PORT_STATUS(port), &reg);
-	if (ret < 0)
-		return ret;
-
-	state->link = !!(reg & QCA8K_PORT_STATUS_LINK_UP);
-	state->an_complete = state->link;
-	state->an_enabled = !!(reg & QCA8K_PORT_STATUS_LINK_AUTO);
-	state->duplex = (reg & QCA8K_PORT_STATUS_DUPLEX) ? DUPLEX_FULL :
-							   DUPLEX_HALF;
-
-	switch (reg & QCA8K_PORT_STATUS_SPEED) {
-	case QCA8K_PORT_STATUS_SPEED_10:
-		state->speed = SPEED_10;
-		break;
-	case QCA8K_PORT_STATUS_SPEED_100:
-		state->speed = SPEED_100;
-		break;
-	case QCA8K_PORT_STATUS_SPEED_1000:
-		state->speed = SPEED_1000;
-		break;
-	default:
-		state->speed = SPEED_UNKNOWN;
-		break;
-	}
-
-	state->pause = MLO_PAUSE_NONE;
-	if (reg & QCA8K_PORT_STATUS_RXFLOW)
-		state->pause |= MLO_PAUSE_RX;
-	if (reg & QCA8K_PORT_STATUS_TXFLOW)
-		state->pause |= MLO_PAUSE_TX;
-
-	return 1;
-}
-
-static void
-qca8k_phylink_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
-			    phy_interface_t interface)
-{
-	struct qca8k_priv *priv = ds->priv;
-
-	qca8k_port_set_status(priv, port, 0);
-}
-
-static void
-qca8k_phylink_mac_link_up(struct dsa_switch *ds, int port, unsigned int mode,
-			  phy_interface_t interface, struct phy_device *phydev,
-			  int speed, int duplex, bool tx_pause, bool rx_pause)
-{
-	struct qca8k_priv *priv = ds->priv;
-	u32 reg;
-
-	if (phylink_autoneg_inband(mode)) {
-		reg = QCA8K_PORT_STATUS_LINK_AUTO;
-	} else {
-		switch (speed) {
-		case SPEED_10:
-			reg = QCA8K_PORT_STATUS_SPEED_10;
-			break;
-		case SPEED_100:
-			reg = QCA8K_PORT_STATUS_SPEED_100;
-			break;
-		case SPEED_1000:
-			reg = QCA8K_PORT_STATUS_SPEED_1000;
-			break;
-		default:
-			reg = QCA8K_PORT_STATUS_LINK_AUTO;
-			break;
-		}
-
-		if (duplex == DUPLEX_FULL)
-			reg |= QCA8K_PORT_STATUS_DUPLEX;
-
-		if (rx_pause || dsa_is_cpu_port(ds, port))
-			reg |= QCA8K_PORT_STATUS_RXFLOW;
-
-		if (tx_pause || dsa_is_cpu_port(ds, port))
-			reg |= QCA8K_PORT_STATUS_TXFLOW;
-	}
-
-	reg |= QCA8K_PORT_STATUS_TXMAC | QCA8K_PORT_STATUS_RXMAC;
-
-	regmap_write(priv->regmap, QCA8K_REG_PORT_STATUS(port), reg);
-}
-
-static void
-qca8k_get_strings(struct dsa_switch *ds, int port, u32 stringset, uint8_t *data)
-{
-	const struct qca8k_match_data *match_data;
-	struct qca8k_priv *priv = ds->priv;
-	int i;
-
-	if (stringset != ETH_SS_STATS)
-		return;
-
-	match_data = device_get_match_data(priv->dev);
-
-	for (i = 0; i < match_data->mib_count; i++)
-		strncpy(data + i * ETH_GSTRING_LEN, ar8327_mib[i].name,
-			ETH_GSTRING_LEN);
-}
-
-static void
-qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
-			uint64_t *data)
-{
-	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
-	const struct qca8k_match_data *match_data;
-	const struct qca8k_mib_desc *mib;
-	u32 reg, i, val;
-	u32 hi = 0;
-	int ret;
-
-	match_data = device_get_match_data(priv->dev);
-
-	for (i = 0; i < match_data->mib_count; i++) {
-		mib = &ar8327_mib[i];
-		reg = QCA8K_PORT_MIB_COUNTER(port) + mib->offset;
-
-		ret = regmap_read(priv->regmap, reg, &val);
-		if (ret < 0)
-			continue;
-
-		if (mib->size == 2) {
-			ret = regmap_read(priv->regmap, reg + 4, &hi);
-			if (ret < 0)
-				continue;
-		}
-
-		data[i] = val;
-		if (mib->size == 2)
-			data[i] |= (u64)hi << 32;
-	}
-}
-
-static int
-qca8k_get_sset_count(struct dsa_switch *ds, int port, int sset)
+static u32 qca8k_get_phy_flags(struct dsa_switch *ds, int port)
 {
-	const struct qca8k_match_data *match_data;
 	struct qca8k_priv *priv = ds->priv;
 
-	if (sset != ETH_SS_STATS)
-		return 0;
-
-	match_data = device_get_match_data(priv->dev);
+	/* Communicate to the phy internal driver the switch revision.
+	 * Based on the switch revision different values needs to be
+	 * set to the dbg and mmd reg on the phy.
+	 * The first 2 bit are used to communicate the switch revision
+	 * to the phy driver.
+	 */
+	if (port > 0 && port < 6)
+		return priv->switch_revision;
 
-	return match_data->mib_count;
+	return 0;
 }
 
-static int
-qca8k_set_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *eee)
-{
-	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
-	u32 lpi_en = QCA8K_REG_EEE_CTRL_LPI_EN(port);
-	u32 reg;
-	int ret;
-
-	mutex_lock(&priv->reg_mutex);
-	ret = regmap_read(priv->regmap, QCA8K_REG_EEE_CTRL, &reg);
-	if (ret < 0)
-		goto exit;
-
-	if (eee->eee_enabled)
-		reg |= lpi_en;
-	else
-		reg &= ~lpi_en;
-	ret = regmap_write(priv->regmap, QCA8K_REG_EEE_CTRL, reg);
-
-exit:
-	mutex_unlock(&priv->reg_mutex);
-	return ret;
-}
-
-static int
-qca8k_get_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *e)
-{
-	/* Nothing to do on the port's MAC */
-	return 0;
-}
-
-static void
-qca8k_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
-{
-	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
-	u32 stp_state;
-
-	switch (state) {
-	case BR_STATE_DISABLED:
-		stp_state = QCA8K_PORT_LOOKUP_STATE_DISABLED;
-		break;
-	case BR_STATE_BLOCKING:
-		stp_state = QCA8K_PORT_LOOKUP_STATE_BLOCKING;
-		break;
-	case BR_STATE_LISTENING:
-		stp_state = QCA8K_PORT_LOOKUP_STATE_LISTENING;
-		break;
-	case BR_STATE_LEARNING:
-		stp_state = QCA8K_PORT_LOOKUP_STATE_LEARNING;
-		break;
-	case BR_STATE_FORWARDING:
-	default:
-		stp_state = QCA8K_PORT_LOOKUP_STATE_FORWARD;
-		break;
-	}
-
-	regmap_update_bits(priv->regmap, QCA8K_PORT_LOOKUP_CTRL(port),
-			   QCA8K_PORT_LOOKUP_STATE_MASK, stp_state);
-}
-
-static int
-qca8k_port_bridge_join(struct dsa_switch *ds, int port, struct net_device *br)
-{
-	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
-	int port_mask, cpu_port;
-	int i, ret;
-
-	cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
-	port_mask = BIT(cpu_port);
-
-	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
-		if (dsa_is_cpu_port(ds, i))
-			continue;
-		if (dsa_to_port(ds, i)->bridge_dev != br)
-			continue;
-		/* Add this port to the portvlan mask of the other ports
-		 * in the bridge
-		 */
-		ret = regmap_set_bits(priv->regmap,
-				      QCA8K_PORT_LOOKUP_CTRL(i),
-				      BIT(port));
-		if (ret)
-			return ret;
-		if (i != port)
-			port_mask |= BIT(i);
-	}
-
-	/* Add all other ports to this ports portvlan mask */
-	ret = regmap_update_bits(priv->regmap, QCA8K_PORT_LOOKUP_CTRL(port),
-				 QCA8K_PORT_LOOKUP_MEMBER, port_mask);
-
-	return ret;
-}
-
-static void
-qca8k_port_bridge_leave(struct dsa_switch *ds, int port, struct net_device *br)
-{
-	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
-	int cpu_port, i;
-
-	cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
-
-	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
-		if (dsa_is_cpu_port(ds, i))
-			continue;
-		if (dsa_to_port(ds, i)->bridge_dev != br)
-			continue;
-		/* Remove this port to the portvlan mask of the other ports
-		 * in the bridge
-		 */
-		regmap_clear_bits(priv->regmap,
-				  QCA8K_PORT_LOOKUP_CTRL(i),
-				  BIT(port));
-	}
-
-	/* Set the cpu port to be the only one in the portvlan mask of
-	 * this port
-	 */
-	regmap_update_bits(priv->regmap, QCA8K_PORT_LOOKUP_CTRL(port),
-			   QCA8K_PORT_LOOKUP_MEMBER, BIT(cpu_port));
-}
-
-static void
-qca8k_port_fast_age(struct dsa_switch *ds, int port)
-{
-	struct qca8k_priv *priv = ds->priv;
-
-	mutex_lock(&priv->reg_mutex);
-	qca8k_fdb_access(priv, QCA8K_FDB_FLUSH_PORT, port);
-	mutex_unlock(&priv->reg_mutex);
-}
-
-static int
-qca8k_set_ageing_time(struct dsa_switch *ds, unsigned int msecs)
-{
-	struct qca8k_priv *priv = ds->priv;
-	unsigned int secs = msecs / 1000;
-	u32 val;
-
-	/* AGE_TIME reg is set in 7s step */
-	val = secs / 7;
-
-	if (val > FIELD_MAX(QCA8K_ATU_AGE_TIME_MASK))
-		return -ERANGE;
-
-	return regmap_update_bits(priv->regmap, QCA8K_REG_ATU_CTRL, QCA8K_ATU_AGE_TIME_MASK,
-				  QCA8K_ATU_AGE_TIME(val));
-}
-
-static int
-qca8k_port_enable(struct dsa_switch *ds, int port,
-		  struct phy_device *phy)
-{
-	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
-
-	qca8k_port_set_status(priv, port, 1);
-	priv->port_sts[port].enabled = 1;
-
-	if (dsa_is_user_port(ds, port))
-		phy_support_asym_pause(phy);
-
-	return 0;
-}
-
-static void
-qca8k_port_disable(struct dsa_switch *ds, int port)
-{
-	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
-
-	qca8k_port_set_status(priv, port, 0);
-	priv->port_sts[port].enabled = 0;
-}
-
-static int
-qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
-{
-	struct qca8k_priv *priv = ds->priv;
-	int i, mtu = 0;
-
-	priv->port_mtu[port] = new_mtu;
-
-	for (i = 0; i < QCA8K_NUM_PORTS; i++)
-		if (priv->port_mtu[i] > mtu)
-			mtu = priv->port_mtu[i];
-
-	/* Include L2 header / FCS length */
-	return regmap_write(priv->regmap, QCA8K_MAX_FRAME_SIZE, mtu + ETH_HLEN + ETH_FCS_LEN);
-}
-
-static int
-qca8k_port_max_mtu(struct dsa_switch *ds, int port)
-{
-	return QCA8K_MAX_MTU;
-}
-
-static int
-qca8k_port_fdb_insert(struct qca8k_priv *priv, const u8 *addr,
-		      u16 port_mask, u16 vid)
-{
-	/* Set the vid to the port vlan id if no vid is set */
-	if (!vid)
-		vid = QCA8K_PORT_VID_DEF;
-
-	return qca8k_fdb_add(priv, addr, port_mask, vid,
-			     QCA8K_ATU_STATUS_STATIC);
-}
-
-static int
-qca8k_port_fdb_add(struct dsa_switch *ds, int port,
-		   const unsigned char *addr, u16 vid)
-{
-	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
-	u16 port_mask = BIT(port);
-
-	return qca8k_port_fdb_insert(priv, addr, port_mask, vid);
-}
-
-static int
-qca8k_port_fdb_del(struct dsa_switch *ds, int port,
-		   const unsigned char *addr, u16 vid)
-{
-	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
-	u16 port_mask = BIT(port);
-
-	if (!vid)
-		vid = QCA8K_PORT_VID_DEF;
-
-	return qca8k_fdb_del(priv, addr, port_mask, vid);
-}
-
-static int
-qca8k_port_fdb_dump(struct dsa_switch *ds, int port,
-		    dsa_fdb_dump_cb_t *cb, void *data)
-{
-	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
-	struct qca8k_fdb _fdb = { 0 };
-	int cnt = QCA8K_NUM_FDB_RECORDS;
-	bool is_static;
-	int ret = 0;
-
-	mutex_lock(&priv->reg_mutex);
-	while (cnt-- && !qca8k_fdb_next(priv, &_fdb, port)) {
-		if (!_fdb.aging)
-			break;
-		is_static = (_fdb.aging == QCA8K_ATU_STATUS_STATIC);
-		ret = cb(_fdb.mac, _fdb.vid, is_static, data);
-		if (ret)
-			break;
-	}
-	mutex_unlock(&priv->reg_mutex);
-
-	return 0;
-}
-
-static int
-qca8k_port_mdb_add(struct dsa_switch *ds, int port,
-		   const struct switchdev_obj_port_mdb *mdb)
-{
-	struct qca8k_priv *priv = ds->priv;
-	struct qca8k_fdb fdb = { 0 };
-	const u8 *addr = mdb->addr;
-	u8 port_mask = BIT(port);
-	u16 vid = mdb->vid;
-	int ret;
-
-	/* Check if entry already exist */
-	ret = qca8k_fdb_search(priv, &fdb, addr, vid);
-	if (ret < 0)
-		return ret;
-
-	/* Rule exist. Delete first */
-	if (!fdb.aging) {
-		ret = qca8k_fdb_del(priv, addr, fdb.port_mask, vid);
-		if (ret)
-			return ret;
-	}
-
-	/* Add port to fdb portmask */
-	fdb.port_mask |= port_mask;
-
-	return qca8k_port_fdb_insert(priv, addr, fdb.port_mask, vid);
-}
-
-static int
-qca8k_port_mdb_del(struct dsa_switch *ds, int port,
-		   const struct switchdev_obj_port_mdb *mdb)
-{
-	struct qca8k_priv *priv = ds->priv;
-	struct qca8k_fdb fdb = { 0 };
-	const u8 *addr = mdb->addr;
-	u8 port_mask = BIT(port);
-	u16 vid = mdb->vid;
-	int ret;
-
-	/* Check if entry already exist */
-	ret = qca8k_fdb_search(priv, &fdb, addr, vid);
-	if (ret < 0)
-		return ret;
-
-	/* Rule doesn't exist. Why delete? */
-	if (!fdb.aging)
-		return -EINVAL;
-
-	ret = qca8k_fdb_del(priv, addr, port_mask, vid);
-	if (ret)
-		return ret;
-
-	/* Only port in the rule is this port. Don't re insert */
-	if (fdb.port_mask == port_mask)
-		return 0;
-
-	/* Remove port from port mask */
-	fdb.port_mask &= ~port_mask;
-
-	return qca8k_port_fdb_insert(priv, addr, fdb.port_mask, vid);
-}
-
-static int
-qca8k_port_mirror_add(struct dsa_switch *ds, int port,
-		      struct dsa_mall_mirror_tc_entry *mirror,
-		      bool ingress)
-{
-	struct qca8k_priv *priv = ds->priv;
-	int monitor_port, ret;
-	u32 reg, val;
-
-	/* Check for existent entry */
-	if ((ingress ? priv->mirror_rx : priv->mirror_tx) & BIT(port))
-		return -EEXIST;
-
-	ret = regmap_read(priv->regmap, QCA8K_REG_GLOBAL_FW_CTRL0, &val);
-	if (ret)
-		return ret;
-
-	/* QCA83xx can have only one port set to mirror mode.
-	 * Check that the correct port is requested and return error otherwise.
-	 * When no mirror port is set, the values is set to 0xF
-	 */
-	monitor_port = FIELD_GET(QCA8K_GLOBAL_FW_CTRL0_MIRROR_PORT_NUM, val);
-	if (monitor_port != 0xF && monitor_port != mirror->to_local_port)
-		return -EEXIST;
-
-	/* Set the monitor port */
-	val = FIELD_PREP(QCA8K_GLOBAL_FW_CTRL0_MIRROR_PORT_NUM,
-			 mirror->to_local_port);
-	ret = regmap_update_bits(priv->regmap, QCA8K_REG_GLOBAL_FW_CTRL0,
-				 QCA8K_GLOBAL_FW_CTRL0_MIRROR_PORT_NUM, val);
-	if (ret)
-		return ret;
-
-	if (ingress) {
-		reg = QCA8K_PORT_LOOKUP_CTRL(port);
-		val = QCA8K_PORT_LOOKUP_ING_MIRROR_EN;
-	} else {
-		reg = QCA8K_REG_PORT_HOL_CTRL1(port);
-		val = QCA8K_PORT_HOL_CTRL1_EG_MIRROR_EN;
-	}
-
-	ret = regmap_update_bits(priv->regmap, reg, val, val);
-	if (ret)
-		return ret;
-
-	/* Track mirror port for tx and rx to decide when the
-	 * mirror port has to be disabled.
-	 */
-	if (ingress)
-		priv->mirror_rx |= BIT(port);
-	else
-		priv->mirror_tx |= BIT(port);
-
-	return 0;
-}
-
-static void
-qca8k_port_mirror_del(struct dsa_switch *ds, int port,
-		      struct dsa_mall_mirror_tc_entry *mirror)
-{
-	struct qca8k_priv *priv = ds->priv;
-	u32 reg, val;
-	int ret;
-
-	if (mirror->ingress) {
-		reg = QCA8K_PORT_LOOKUP_CTRL(port);
-		val = QCA8K_PORT_LOOKUP_ING_MIRROR_EN;
-	} else {
-		reg = QCA8K_REG_PORT_HOL_CTRL1(port);
-		val = QCA8K_PORT_HOL_CTRL1_EG_MIRROR_EN;
-	}
-
-	ret = regmap_clear_bits(priv->regmap, reg, val);
-	if (ret)
-		goto err;
-
-	if (mirror->ingress)
-		priv->mirror_rx &= ~BIT(port);
-	else
-		priv->mirror_tx &= ~BIT(port);
-
-	/* No port set to send packet to mirror port. Disable mirror port */
-	if (!priv->mirror_rx && !priv->mirror_tx) {
-		val = FIELD_PREP(QCA8K_GLOBAL_FW_CTRL0_MIRROR_PORT_NUM, 0xF);
-		ret = regmap_update_bits(priv->regmap, QCA8K_REG_GLOBAL_FW_CTRL0,
-					 QCA8K_GLOBAL_FW_CTRL0_MIRROR_PORT_NUM, val);
-		if (ret)
-			goto err;
-	}
-err:
-	dev_err(priv->dev, "Failed to del mirror port from %d", port);
-}
-
-static int
-qca8k_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
-			  struct netlink_ext_ack *extack)
-{
-	struct qca8k_priv *priv = ds->priv;
-	int ret;
-
-	if (vlan_filtering) {
-		ret = regmap_update_bits(priv->regmap, QCA8K_PORT_LOOKUP_CTRL(port),
-					 QCA8K_PORT_LOOKUP_VLAN_MODE_MASK,
-					 QCA8K_PORT_LOOKUP_VLAN_MODE_SECURE);
-	} else {
-		ret = regmap_update_bits(priv->regmap, QCA8K_PORT_LOOKUP_CTRL(port),
-					 QCA8K_PORT_LOOKUP_VLAN_MODE_MASK,
-					 QCA8K_PORT_LOOKUP_VLAN_MODE_NONE);
-	}
-
-	return ret;
-}
-
-static int
-qca8k_port_vlan_add(struct dsa_switch *ds, int port,
-		    const struct switchdev_obj_port_vlan *vlan,
-		    struct netlink_ext_ack *extack)
-{
-	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
-	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
-	struct qca8k_priv *priv = ds->priv;
-	int ret;
-
-	ret = qca8k_vlan_add(priv, port, vlan->vid, untagged);
-	if (ret) {
-		dev_err(priv->dev, "Failed to add VLAN to port %d (%d)", port, ret);
-		return ret;
-	}
-
-	if (pvid) {
-		ret = regmap_update_bits(priv->regmap, QCA8K_EGRESS_VLAN(port),
-					 QCA8K_EGREES_VLAN_PORT_MASK(port),
-					 QCA8K_EGREES_VLAN_PORT(port, vlan->vid));
-		if (ret)
-			return ret;
-
-		ret = regmap_write(priv->regmap, QCA8K_REG_PORT_VLAN_CTRL0(port),
-				   QCA8K_PORT_VLAN_CVID(vlan->vid) |
-				   QCA8K_PORT_VLAN_SVID(vlan->vid));
-	}
-
-	return ret;
-}
-
-static int
-qca8k_port_vlan_del(struct dsa_switch *ds, int port,
-		    const struct switchdev_obj_port_vlan *vlan)
-{
-	struct qca8k_priv *priv = ds->priv;
-	int ret;
-
-	ret = qca8k_vlan_del(priv, port, vlan->vid);
-	if (ret)
-		dev_err(priv->dev, "Failed to delete VLAN from port %d (%d)", port, ret);
-
-	return ret;
-}
-
-static u32 qca8k_get_phy_flags(struct dsa_switch *ds, int port)
-{
-	struct qca8k_priv *priv = ds->priv;
-
-	/* Communicate to the phy internal driver the switch revision.
-	 * Based on the switch revision different values needs to be
-	 * set to the dbg and mmd reg on the phy.
-	 * The first 2 bit are used to communicate the switch revision
-	 * to the phy driver.
-	 */
-	if (port > 0 && port < 6)
-		return priv->switch_revision;
-
-	return 0;
-}
-
-static enum dsa_tag_protocol
-qca8k_get_tag_protocol(struct dsa_switch *ds, int port,
-		       enum dsa_tag_protocol mp)
+static enum dsa_tag_protocol
+qca8k_get_tag_protocol(struct dsa_switch *ds, int port,
+		       enum dsa_tag_protocol mp)
 {
 	return DSA_TAG_PROTO_QCA;
 }
 
-static bool
-qca8k_lag_can_offload(struct dsa_switch *ds,
-		      struct net_device *lag,
-		      struct netdev_lag_upper_info *info)
-{
-	struct dsa_port *dp;
-	int id, members = 0;
-
-	id = dsa_lag_id(ds->dst, lag);
-	if (id < 0 || id >= ds->num_lag_ids)
-		return false;
-
-	dsa_lag_foreach_port(dp, ds->dst, lag)
-		/* Includes the port joining the LAG */
-		members++;
-
-	if (members > QCA8K_NUM_PORTS_FOR_LAG)
-		return false;
-
-	if (info->tx_type != NETDEV_LAG_TX_TYPE_HASH)
-		return false;
-
-	return true;
-}
-
-static int
-qca8k_lag_refresh_portmap(struct dsa_switch *ds, int port,
-			  struct net_device *lag, bool delete)
-{
-	struct qca8k_priv *priv = ds->priv;
-	int ret, id, i;
-	u32 val;
-
-	id = dsa_lag_id(ds->dst, lag);
-
-	/* Read current port member */
-	ret = regmap_read(priv->regmap, QCA8K_REG_GOL_TRUNK_CTRL0, &val);
-	if (ret)
-		return ret;
-
-	/* Shift val to the correct trunk */
-	val >>= QCA8K_REG_GOL_TRUNK_SHIFT(id);
-	val &= QCA8K_REG_GOL_TRUNK_MEMBER_MASK;
-	if (delete)
-		val &= ~BIT(port);
-	else
-		val |= BIT(port);
-
-	/* Update port member. With empty portmap disable trunk */
-	ret = regmap_update_bits(priv->regmap, QCA8K_REG_GOL_TRUNK_CTRL0,
-				 QCA8K_REG_GOL_TRUNK_MEMBER(id) |
-				 QCA8K_REG_GOL_TRUNK_EN(id),
-				 !val << QCA8K_REG_GOL_TRUNK_SHIFT(id) |
-				 val << QCA8K_REG_GOL_TRUNK_SHIFT(id));
-
-	/* Search empty member if adding or port on deleting */
-	for (i = 0; i < 4; i++) {
-		ret = regmap_read(priv->regmap, QCA8K_REG_GOL_TRUNK_CTRL(id), &val);
-		if (ret)
-			return ret;
-
-		val >>= QCA8K_REG_GOL_TRUNK_ID_MEM_ID_SHIFT(id, i);
-		val &= QCA8K_REG_GOL_TRUNK_ID_MEM_ID_MASK;
-
-		if (delete) {
-			/* If port flagged to be disabled assume this member is
-			 * empty
-			 */
-			if (val != QCA8K_REG_GOL_TRUNK_ID_MEM_ID_EN_MASK)
-				continue;
-
-			val &= QCA8K_REG_GOL_TRUNK_ID_MEM_ID_PORT_MASK;
-			if (val != port)
-				continue;
-		} else {
-			/* If port flagged to be enabled assume this member is
-			 * already set
-			 */
-			if (val == QCA8K_REG_GOL_TRUNK_ID_MEM_ID_EN_MASK)
-				continue;
-		}
-
-		/* We find the member to remove */
-		break;
-	}
-
-	/* Set port in the correct port mask or disable port if in delate mode */
-	return regmap_update_bits(priv->regmap, QCA8K_REG_GOL_TRUNK_CTRL(id),
-				  QCA8K_REG_GOL_TRUNK_ID_MEM_ID_EN(id, i) |
-				  QCA8K_REG_GOL_TRUNK_ID_MEM_ID_PORT(id, i),
-				  !delete << QCA8K_REG_GOL_TRUNK_ID_MEM_ID_SHIFT(id, i) |
-				  port << QCA8K_REG_GOL_TRUNK_ID_MEM_ID_SHIFT(id, i));
-}
-
-static int
-qca8k_port_lag_join(struct dsa_switch *ds, int port,
-		    struct net_device *lag,
-		    struct netdev_lag_upper_info *info)
-{
-	if (!qca8k_lag_can_offload(ds, lag, info))
-		return -EOPNOTSUPP;
-
-	return qca8k_lag_refresh_portmap(ds, port, lag, false);
-}
-
-static int
-qca8k_port_lag_leave(struct dsa_switch *ds, int port,
-		     struct net_device *lag)
-{
-	return qca8k_lag_refresh_portmap(ds, port, lag, true);
-}
-
 static const struct dsa_switch_ops qca8k_switch_ops = {
 	.get_tag_protocol	= qca8k_get_tag_protocol,
 	.setup			= qca8k_setup,
diff --git a/drivers/net/dsa/qca/qca8k-common.c b/drivers/net/dsa/qca/qca8k-common.c
new file mode 100644
index 000000000000..fdd5c92a278f
--- /dev/null
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -0,0 +1,1157 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2009 Felix Fietkau <nbd@nbd.name>
+ * Copyright (C) 2011-2012 Gabor Juhos <juhosg@openwrt.org>
+ * Copyright (c) 2015, 2019, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2016 John Crispin <john@phrozen.org>
+ */
+
+#include <linux/module.h>
+#include <linux/phy.h>
+#include <linux/netdevice.h>
+#include <linux/bitfield.h>
+#include <net/dsa.h>
+#include <linux/if_bridge.h>
+
+#include "qca8k.h"
+
+static const struct regmap_range qca8k_readable_ranges[] = {
+	regmap_reg_range(0x0000, 0x00e4), /* Global control */
+	regmap_reg_range(0x0100, 0x0168), /* EEE control */
+	regmap_reg_range(0x0200, 0x0270), /* Parser control */
+	regmap_reg_range(0x0400, 0x0454), /* ACL */
+	regmap_reg_range(0x0600, 0x0718), /* Lookup */
+	regmap_reg_range(0x0800, 0x0b70), /* QM */
+	regmap_reg_range(0x0c00, 0x0c80), /* PKT */
+	regmap_reg_range(0x0e00, 0x0e98), /* L3 */
+	regmap_reg_range(0x1000, 0x10ac), /* MIB - Port0 */
+	regmap_reg_range(0x1100, 0x11ac), /* MIB - Port1 */
+	regmap_reg_range(0x1200, 0x12ac), /* MIB - Port2 */
+	regmap_reg_range(0x1300, 0x13ac), /* MIB - Port3 */
+	regmap_reg_range(0x1400, 0x14ac), /* MIB - Port4 */
+	regmap_reg_range(0x1500, 0x15ac), /* MIB - Port5 */
+	regmap_reg_range(0x1600, 0x16ac), /* MIB - Port6 */
+
+};
+
+const struct regmap_access_table qca8k_readable_table = {
+	.yes_ranges = qca8k_readable_ranges,
+	.n_yes_ranges = ARRAY_SIZE(qca8k_readable_ranges),
+};
+
+#define MIB_DESC(_s, _o, _n)	\
+	{			\
+		.size = (_s),	\
+		.offset = (_o),	\
+		.name = (_n),	\
+	}
+
+static const struct qca8k_mib_desc ar8327_mib[] = {
+	MIB_DESC(1, 0x00, "RxBroad"),
+	MIB_DESC(1, 0x04, "RxPause"),
+	MIB_DESC(1, 0x08, "RxMulti"),
+	MIB_DESC(1, 0x0c, "RxFcsErr"),
+	MIB_DESC(1, 0x10, "RxAlignErr"),
+	MIB_DESC(1, 0x14, "RxRunt"),
+	MIB_DESC(1, 0x18, "RxFragment"),
+	MIB_DESC(1, 0x1c, "Rx64Byte"),
+	MIB_DESC(1, 0x20, "Rx128Byte"),
+	MIB_DESC(1, 0x24, "Rx256Byte"),
+	MIB_DESC(1, 0x28, "Rx512Byte"),
+	MIB_DESC(1, 0x2c, "Rx1024Byte"),
+	MIB_DESC(1, 0x30, "Rx1518Byte"),
+	MIB_DESC(1, 0x34, "RxMaxByte"),
+	MIB_DESC(1, 0x38, "RxTooLong"),
+	MIB_DESC(2, 0x3c, "RxGoodByte"),
+	MIB_DESC(2, 0x44, "RxBadByte"),
+	MIB_DESC(1, 0x4c, "RxOverFlow"),
+	MIB_DESC(1, 0x50, "Filtered"),
+	MIB_DESC(1, 0x54, "TxBroad"),
+	MIB_DESC(1, 0x58, "TxPause"),
+	MIB_DESC(1, 0x5c, "TxMulti"),
+	MIB_DESC(1, 0x60, "TxUnderRun"),
+	MIB_DESC(1, 0x64, "Tx64Byte"),
+	MIB_DESC(1, 0x68, "Tx128Byte"),
+	MIB_DESC(1, 0x6c, "Tx256Byte"),
+	MIB_DESC(1, 0x70, "Tx512Byte"),
+	MIB_DESC(1, 0x74, "Tx1024Byte"),
+	MIB_DESC(1, 0x78, "Tx1518Byte"),
+	MIB_DESC(1, 0x7c, "TxMaxByte"),
+	MIB_DESC(1, 0x80, "TxOverSize"),
+	MIB_DESC(2, 0x84, "TxByte"),
+	MIB_DESC(1, 0x8c, "TxCollision"),
+	MIB_DESC(1, 0x90, "TxAbortCol"),
+	MIB_DESC(1, 0x94, "TxMultiCol"),
+	MIB_DESC(1, 0x98, "TxSingleCol"),
+	MIB_DESC(1, 0x9c, "TxExcDefer"),
+	MIB_DESC(1, 0xa0, "TxDefer"),
+	MIB_DESC(1, 0xa4, "TxLateCol"),
+	MIB_DESC(1, 0xa8, "RXUnicast"),
+	MIB_DESC(1, 0xac, "TXUnicast"),
+};
+
+static int
+qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
+{
+	u32 val;
+
+	return regmap_read_poll_timeout(priv->regmap, reg, val, !(val & mask), 0,
+				       QCA8K_BUSY_WAIT_TIMEOUT * USEC_PER_MSEC);
+}
+
+static int
+qca8k_fdb_read(struct qca8k_priv *priv, struct qca8k_fdb *fdb)
+{
+	u32 reg[4], val;
+	int i, ret;
+
+	/* load the ARL table into an array */
+	for (i = 0; i < 4; i++) {
+		ret = regmap_read(priv->regmap, QCA8K_REG_ATU_DATA0 + (i * 4), &val);
+		if (ret < 0)
+			return ret;
+
+		reg[i] = val;
+	}
+
+	/* vid - 83:72 */
+	fdb->vid = FIELD_GET(QCA8K_ATU_VID_MASK, reg[2]);
+	/* aging - 67:64 */
+	fdb->aging = FIELD_GET(QCA8K_ATU_STATUS_MASK, reg[2]);
+	/* portmask - 54:48 */
+	fdb->port_mask = FIELD_GET(QCA8K_ATU_PORT_MASK, reg[1]);
+	/* mac - 47:0 */
+	fdb->mac[0] = FIELD_GET(QCA8K_ATU_ADDR0_MASK, reg[1]);
+	fdb->mac[1] = FIELD_GET(QCA8K_ATU_ADDR1_MASK, reg[1]);
+	fdb->mac[2] = FIELD_GET(QCA8K_ATU_ADDR2_MASK, reg[0]);
+	fdb->mac[3] = FIELD_GET(QCA8K_ATU_ADDR3_MASK, reg[0]);
+	fdb->mac[4] = FIELD_GET(QCA8K_ATU_ADDR4_MASK, reg[0]);
+	fdb->mac[5] = FIELD_GET(QCA8K_ATU_ADDR5_MASK, reg[0]);
+
+	return 0;
+}
+
+static void
+qca8k_fdb_write(struct qca8k_priv *priv, u16 vid, u8 port_mask, const u8 *mac,
+		u8 aging)
+{
+	u32 reg[3] = { 0 };
+	int i;
+
+	/* vid - 83:72 */
+	reg[2] = FIELD_PREP(QCA8K_ATU_VID_MASK, vid);
+	/* aging - 67:64 */
+	reg[2] |= FIELD_PREP(QCA8K_ATU_STATUS_MASK, aging);
+	/* portmask - 54:48 */
+	reg[1] = FIELD_PREP(QCA8K_ATU_PORT_MASK, port_mask);
+	/* mac - 47:0 */
+	reg[1] |= FIELD_PREP(QCA8K_ATU_ADDR0_MASK, mac[0]);
+	reg[1] |= FIELD_PREP(QCA8K_ATU_ADDR1_MASK, mac[1]);
+	reg[0] |= FIELD_PREP(QCA8K_ATU_ADDR2_MASK, mac[2]);
+	reg[0] |= FIELD_PREP(QCA8K_ATU_ADDR3_MASK, mac[3]);
+	reg[0] |= FIELD_PREP(QCA8K_ATU_ADDR4_MASK, mac[4]);
+	reg[0] |= FIELD_PREP(QCA8K_ATU_ADDR5_MASK, mac[5]);
+
+	/* load the array into the ARL table */
+	for (i = 0; i < 3; i++)
+		regmap_write(priv->regmap, QCA8K_REG_ATU_DATA0 + (i * 4), reg[i]);
+}
+
+static int
+qca8k_fdb_access(struct qca8k_priv *priv, enum qca8k_fdb_cmd cmd, int port)
+{
+	u32 reg;
+	int ret;
+
+	/* Set the command and FDB index */
+	reg = QCA8K_ATU_FUNC_BUSY;
+	reg |= cmd;
+	if (port >= 0) {
+		reg |= QCA8K_ATU_FUNC_PORT_EN;
+		reg |= FIELD_PREP(QCA8K_ATU_FUNC_PORT_MASK, port);
+	}
+
+	/* Write the function register triggering the table access */
+	ret = regmap_write(priv->regmap, QCA8K_REG_ATU_FUNC, reg);
+	if (ret)
+		return ret;
+
+	/* wait for completion */
+	ret = qca8k_busy_wait(priv, QCA8K_REG_ATU_FUNC, QCA8K_ATU_FUNC_BUSY);
+	if (ret)
+		return ret;
+
+	/* Check for table full violation when adding an entry */
+	if (cmd == QCA8K_FDB_LOAD) {
+		ret = regmap_read(priv->regmap, QCA8K_REG_ATU_FUNC, &reg);
+		if (ret < 0)
+			return ret;
+		if (reg & QCA8K_ATU_FUNC_FULL)
+			return -1;
+	}
+
+	return 0;
+}
+
+static int
+qca8k_fdb_next(struct qca8k_priv *priv, struct qca8k_fdb *fdb, int port)
+{
+	int ret;
+
+	qca8k_fdb_write(priv, fdb->vid, fdb->port_mask, fdb->mac, fdb->aging);
+	ret = qca8k_fdb_access(priv, QCA8K_FDB_NEXT, port);
+	if (ret < 0)
+		return ret;
+
+	return qca8k_fdb_read(priv, fdb);
+}
+
+static int
+qca8k_fdb_add(struct qca8k_priv *priv, const u8 *mac, u16 port_mask,
+	      u16 vid, u8 aging)
+{
+	int ret;
+
+	mutex_lock(&priv->reg_mutex);
+	qca8k_fdb_write(priv, vid, port_mask, mac, aging);
+	ret = qca8k_fdb_access(priv, QCA8K_FDB_LOAD, -1);
+	mutex_unlock(&priv->reg_mutex);
+
+	return ret;
+}
+
+static int
+qca8k_fdb_del(struct qca8k_priv *priv, const u8 *mac, u16 port_mask, u16 vid)
+{
+	int ret;
+
+	mutex_lock(&priv->reg_mutex);
+	qca8k_fdb_write(priv, vid, port_mask, mac, 0);
+	ret = qca8k_fdb_access(priv, QCA8K_FDB_PURGE, -1);
+	mutex_unlock(&priv->reg_mutex);
+
+	return ret;
+}
+
+void
+qca8k_fdb_flush(struct qca8k_priv *priv)
+{
+	mutex_lock(&priv->reg_mutex);
+	qca8k_fdb_access(priv, QCA8K_FDB_FLUSH, -1);
+	mutex_unlock(&priv->reg_mutex);
+}
+
+static int
+qca8k_fdb_search(struct qca8k_priv *priv, struct qca8k_fdb *fdb, const u8 *mac, u16 vid)
+{
+	int ret;
+
+	mutex_lock(&priv->reg_mutex);
+	qca8k_fdb_write(priv, vid, 0, mac, 0);
+	ret = qca8k_fdb_access(priv, QCA8K_FDB_SEARCH, -1);
+	if (ret < 0)
+		goto exit;
+
+	ret = qca8k_fdb_read(priv, fdb);
+exit:
+	mutex_unlock(&priv->reg_mutex);
+	return ret;
+}
+
+static int
+qca8k_vlan_access(struct qca8k_priv *priv, enum qca8k_vlan_cmd cmd, u16 vid)
+{
+	u32 reg;
+	int ret;
+
+	/* Set the command and VLAN index */
+	reg = QCA8K_VTU_FUNC1_BUSY;
+	reg |= cmd;
+	reg |= FIELD_PREP(QCA8K_VTU_FUNC1_VID_MASK, vid);
+
+	/* Write the function register triggering the table access */
+	ret = regmap_write(priv->regmap, QCA8K_REG_VTU_FUNC1, reg);
+	if (ret)
+		return ret;
+
+	/* wait for completion */
+	ret = qca8k_busy_wait(priv, QCA8K_REG_VTU_FUNC1, QCA8K_VTU_FUNC1_BUSY);
+	if (ret)
+		return ret;
+
+	/* Check for table full violation when adding an entry */
+	if (cmd == QCA8K_VLAN_LOAD) {
+		ret = regmap_read(priv->regmap, QCA8K_REG_VTU_FUNC1, &reg);
+		if (ret < 0)
+			return ret;
+		if (reg & QCA8K_VTU_FUNC1_FULL)
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int
+qca8k_vlan_add(struct qca8k_priv *priv, u8 port, u16 vid, bool untagged)
+{
+	u32 reg;
+	int ret;
+
+	/* We do the right thing with VLAN 0 and treat it as untagged while
+	 * preserving the tag on egress.
+	 */
+	if (vid == 0)
+		return 0;
+
+	mutex_lock(&priv->reg_mutex);
+	ret = qca8k_vlan_access(priv, QCA8K_VLAN_READ, vid);
+	if (ret < 0)
+		goto out;
+
+	ret = regmap_read(priv->regmap, QCA8K_REG_VTU_FUNC0, &reg);
+	if (ret < 0)
+		goto out;
+	reg |= QCA8K_VTU_FUNC0_VALID | QCA8K_VTU_FUNC0_IVL_EN;
+	reg &= ~QCA8K_VTU_FUNC0_EG_MODE_PORT_MASK(port);
+	if (untagged)
+		reg |= QCA8K_VTU_FUNC0_EG_MODE_PORT_UNTAG(port);
+	else
+		reg |= QCA8K_VTU_FUNC0_EG_MODE_PORT_TAG(port);
+
+	ret = regmap_write(priv->regmap, QCA8K_REG_VTU_FUNC0, reg);
+	if (ret)
+		goto out;
+	ret = qca8k_vlan_access(priv, QCA8K_VLAN_LOAD, vid);
+
+out:
+	mutex_unlock(&priv->reg_mutex);
+
+	return ret;
+}
+
+static int
+qca8k_vlan_del(struct qca8k_priv *priv, u8 port, u16 vid)
+{
+	u32 reg, mask;
+	int ret, i;
+	bool del;
+
+	mutex_lock(&priv->reg_mutex);
+	ret = qca8k_vlan_access(priv, QCA8K_VLAN_READ, vid);
+	if (ret < 0)
+		goto out;
+
+	ret = regmap_read(priv->regmap, QCA8K_REG_VTU_FUNC0, &reg);
+	if (ret < 0)
+		goto out;
+	reg &= ~QCA8K_VTU_FUNC0_EG_MODE_PORT_MASK(port);
+	reg |= QCA8K_VTU_FUNC0_EG_MODE_PORT_NOT(port);
+
+	/* Check if we're the last member to be removed */
+	del = true;
+	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
+		mask = QCA8K_VTU_FUNC0_EG_MODE_PORT_NOT(i);
+
+		if ((reg & mask) != mask) {
+			del = false;
+			break;
+		}
+	}
+
+	if (del) {
+		ret = qca8k_vlan_access(priv, QCA8K_VLAN_PURGE, vid);
+	} else {
+		ret = regmap_write(priv->regmap, QCA8K_REG_VTU_FUNC0, reg);
+		if (ret)
+			goto out;
+		ret = qca8k_vlan_access(priv, QCA8K_VLAN_LOAD, vid);
+	}
+
+out:
+	mutex_unlock(&priv->reg_mutex);
+
+	return ret;
+}
+
+int
+qca8k_mib_init(struct qca8k_priv *priv)
+{
+	int ret;
+
+	mutex_lock(&priv->reg_mutex);
+	ret = regmap_set_bits(priv->regmap, QCA8K_REG_MIB, QCA8K_MIB_FLUSH | QCA8K_MIB_BUSY);
+	if (ret)
+		goto exit;
+
+	ret = qca8k_busy_wait(priv, QCA8K_REG_MIB, QCA8K_MIB_BUSY);
+	if (ret)
+		goto exit;
+
+	ret = regmap_set_bits(priv->regmap, QCA8K_REG_MIB, QCA8K_MIB_CPU_KEEP);
+	if (ret)
+		goto exit;
+
+	ret = regmap_write(priv->regmap, QCA8K_REG_MODULE_EN, QCA8K_MODULE_EN_MIB);
+
+exit:
+	mutex_unlock(&priv->reg_mutex);
+	return ret;
+}
+
+void
+qca8k_port_set_status(struct qca8k_priv *priv, int port, int enable)
+{
+	u32 mask = QCA8K_PORT_STATUS_TXMAC | QCA8K_PORT_STATUS_RXMAC;
+
+	/* Port 0 and 6 have no internal PHY */
+	if (port > 0 && port < 6)
+		mask |= QCA8K_PORT_STATUS_LINK_AUTO;
+
+	if (enable)
+		regmap_set_bits(priv->regmap, QCA8K_REG_PORT_STATUS(port), mask);
+	else
+		regmap_clear_bits(priv->regmap, QCA8K_REG_PORT_STATUS(port), mask);
+}
+
+int
+qca8k_phylink_mac_link_state(struct dsa_switch *ds, int port,
+			     struct phylink_link_state *state)
+{
+	struct qca8k_priv *priv = ds->priv;
+	u32 reg;
+	int ret;
+
+	ret = regmap_read(priv->regmap, QCA8K_REG_PORT_STATUS(port), &reg);
+	if (ret < 0)
+		return ret;
+
+	state->link = !!(reg & QCA8K_PORT_STATUS_LINK_UP);
+	state->an_complete = state->link;
+	state->an_enabled = !!(reg & QCA8K_PORT_STATUS_LINK_AUTO);
+	state->duplex = (reg & QCA8K_PORT_STATUS_DUPLEX) ? DUPLEX_FULL :
+							   DUPLEX_HALF;
+
+	switch (reg & QCA8K_PORT_STATUS_SPEED) {
+	case QCA8K_PORT_STATUS_SPEED_10:
+		state->speed = SPEED_10;
+		break;
+	case QCA8K_PORT_STATUS_SPEED_100:
+		state->speed = SPEED_100;
+		break;
+	case QCA8K_PORT_STATUS_SPEED_1000:
+		state->speed = SPEED_1000;
+		break;
+	default:
+		state->speed = SPEED_UNKNOWN;
+		break;
+	}
+
+	state->pause = MLO_PAUSE_NONE;
+	if (reg & QCA8K_PORT_STATUS_RXFLOW)
+		state->pause |= MLO_PAUSE_RX;
+	if (reg & QCA8K_PORT_STATUS_TXFLOW)
+		state->pause |= MLO_PAUSE_TX;
+
+	return 1;
+}
+
+void
+qca8k_phylink_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
+			    phy_interface_t interface)
+{
+	struct qca8k_priv *priv = ds->priv;
+
+	qca8k_port_set_status(priv, port, 0);
+}
+
+void
+qca8k_phylink_mac_link_up(struct dsa_switch *ds, int port, unsigned int mode,
+			  phy_interface_t interface, struct phy_device *phydev,
+			  int speed, int duplex, bool tx_pause, bool rx_pause)
+{
+	struct qca8k_priv *priv = ds->priv;
+	u32 reg;
+
+	if (phylink_autoneg_inband(mode)) {
+		reg = QCA8K_PORT_STATUS_LINK_AUTO;
+	} else {
+		switch (speed) {
+		case SPEED_10:
+			reg = QCA8K_PORT_STATUS_SPEED_10;
+			break;
+		case SPEED_100:
+			reg = QCA8K_PORT_STATUS_SPEED_100;
+			break;
+		case SPEED_1000:
+			reg = QCA8K_PORT_STATUS_SPEED_1000;
+			break;
+		default:
+			reg = QCA8K_PORT_STATUS_LINK_AUTO;
+			break;
+		}
+
+		if (duplex == DUPLEX_FULL)
+			reg |= QCA8K_PORT_STATUS_DUPLEX;
+
+		if (rx_pause || dsa_is_cpu_port(ds, port))
+			reg |= QCA8K_PORT_STATUS_RXFLOW;
+
+		if (tx_pause || dsa_is_cpu_port(ds, port))
+			reg |= QCA8K_PORT_STATUS_TXFLOW;
+	}
+
+	reg |= QCA8K_PORT_STATUS_TXMAC | QCA8K_PORT_STATUS_RXMAC;
+
+	regmap_write(priv->regmap, QCA8K_REG_PORT_STATUS(port), reg);
+}
+
+void
+qca8k_get_strings(struct dsa_switch *ds, int port, u32 stringset, uint8_t *data)
+{
+	const struct qca8k_match_data *match_data;
+	struct qca8k_priv *priv = ds->priv;
+	int i;
+
+	if (stringset != ETH_SS_STATS)
+		return;
+
+	match_data = device_get_match_data(priv->dev);
+
+	for (i = 0; i < match_data->mib_count; i++)
+		strncpy(data + i * ETH_GSTRING_LEN, ar8327_mib[i].name,
+			ETH_GSTRING_LEN);
+}
+
+void
+qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
+			uint64_t *data)
+{
+	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
+	const struct qca8k_match_data *match_data;
+	const struct qca8k_mib_desc *mib;
+	u32 reg, i, val;
+	u32 hi = 0;
+	int ret;
+
+	match_data = device_get_match_data(priv->dev);
+
+	for (i = 0; i < match_data->mib_count; i++) {
+		mib = &ar8327_mib[i];
+		reg = QCA8K_PORT_MIB_COUNTER(port) + mib->offset;
+
+		ret = regmap_read(priv->regmap, reg, &val);
+		if (ret < 0)
+			continue;
+
+		if (mib->size == 2) {
+			ret = regmap_read(priv->regmap, reg + 4, &hi);
+			if (ret < 0)
+				continue;
+		}
+
+		data[i] = val;
+		if (mib->size == 2)
+			data[i] |= (u64)hi << 32;
+	}
+}
+
+int
+qca8k_get_sset_count(struct dsa_switch *ds, int port, int sset)
+{
+	const struct qca8k_match_data *match_data;
+	struct qca8k_priv *priv = ds->priv;
+
+	if (sset != ETH_SS_STATS)
+		return 0;
+
+	match_data = device_get_match_data(priv->dev);
+
+	return match_data->mib_count;
+}
+
+int
+qca8k_set_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *eee)
+{
+	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
+	u32 lpi_en = QCA8K_REG_EEE_CTRL_LPI_EN(port);
+	u32 reg;
+	int ret;
+
+	mutex_lock(&priv->reg_mutex);
+	ret = regmap_read(priv->regmap, QCA8K_REG_EEE_CTRL, &reg);
+	if (ret < 0)
+		goto exit;
+
+	if (eee->eee_enabled)
+		reg |= lpi_en;
+	else
+		reg &= ~lpi_en;
+	ret = regmap_write(priv->regmap, QCA8K_REG_EEE_CTRL, reg);
+
+exit:
+	mutex_unlock(&priv->reg_mutex);
+	return ret;
+}
+
+int
+qca8k_get_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *e)
+{
+	/* Nothing to do on the port's MAC */
+	return 0;
+}
+
+void
+qca8k_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
+{
+	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
+	u32 stp_state;
+
+	switch (state) {
+	case BR_STATE_DISABLED:
+		stp_state = QCA8K_PORT_LOOKUP_STATE_DISABLED;
+		break;
+	case BR_STATE_BLOCKING:
+		stp_state = QCA8K_PORT_LOOKUP_STATE_BLOCKING;
+		break;
+	case BR_STATE_LISTENING:
+		stp_state = QCA8K_PORT_LOOKUP_STATE_LISTENING;
+		break;
+	case BR_STATE_LEARNING:
+		stp_state = QCA8K_PORT_LOOKUP_STATE_LEARNING;
+		break;
+	case BR_STATE_FORWARDING:
+	default:
+		stp_state = QCA8K_PORT_LOOKUP_STATE_FORWARD;
+		break;
+	}
+
+	regmap_update_bits(priv->regmap, QCA8K_PORT_LOOKUP_CTRL(port),
+			   QCA8K_PORT_LOOKUP_STATE_MASK, stp_state);
+}
+
+int
+qca8k_port_bridge_join(struct dsa_switch *ds, int port, struct net_device *br)
+{
+	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
+	int port_mask, cpu_port;
+	int i, ret;
+
+	cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
+	port_mask = BIT(cpu_port);
+
+	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
+		if (dsa_is_cpu_port(ds, i))
+			continue;
+		if (dsa_to_port(ds, i)->bridge_dev != br)
+			continue;
+		/* Add this port to the portvlan mask of the other ports
+		 * in the bridge
+		 */
+		ret = regmap_set_bits(priv->regmap,
+				      QCA8K_PORT_LOOKUP_CTRL(i),
+				      BIT(port));
+		if (ret)
+			return ret;
+		if (i != port)
+			port_mask |= BIT(i);
+	}
+
+	/* Add all other ports to this ports portvlan mask */
+	ret = regmap_update_bits(priv->regmap, QCA8K_PORT_LOOKUP_CTRL(port),
+				 QCA8K_PORT_LOOKUP_MEMBER, port_mask);
+
+	return ret;
+}
+
+void
+qca8k_port_bridge_leave(struct dsa_switch *ds, int port, struct net_device *br)
+{
+	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
+	int cpu_port, i;
+
+	cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
+
+	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
+		if (dsa_is_cpu_port(ds, i))
+			continue;
+		if (dsa_to_port(ds, i)->bridge_dev != br)
+			continue;
+		/* Remove this port to the portvlan mask of the other ports
+		 * in the bridge
+		 */
+		regmap_clear_bits(priv->regmap,
+				  QCA8K_PORT_LOOKUP_CTRL(i),
+				  BIT(port));
+	}
+
+	/* Set the cpu port to be the only one in the portvlan mask of
+	 * this port
+	 */
+	regmap_update_bits(priv->regmap, QCA8K_PORT_LOOKUP_CTRL(port),
+			   QCA8K_PORT_LOOKUP_MEMBER, BIT(cpu_port));
+}
+
+void
+qca8k_port_fast_age(struct dsa_switch *ds, int port)
+{
+	struct qca8k_priv *priv = ds->priv;
+
+	mutex_lock(&priv->reg_mutex);
+	qca8k_fdb_access(priv, QCA8K_FDB_FLUSH_PORT, port);
+	mutex_unlock(&priv->reg_mutex);
+}
+
+int
+qca8k_set_ageing_time(struct dsa_switch *ds, unsigned int msecs)
+{
+	struct qca8k_priv *priv = ds->priv;
+	unsigned int secs = msecs / 1000;
+	u32 val;
+
+	/* AGE_TIME reg is set in 7s step */
+	val = secs / 7;
+
+	if (val > FIELD_MAX(QCA8K_ATU_AGE_TIME_MASK))
+		return -ERANGE;
+
+	return regmap_update_bits(priv->regmap, QCA8K_REG_ATU_CTRL,
+				  QCA8K_ATU_AGE_TIME_MASK, QCA8K_ATU_AGE_TIME(val));
+}
+
+int
+qca8k_port_enable(struct dsa_switch *ds, int port,
+		  struct phy_device *phy)
+{
+	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
+
+	qca8k_port_set_status(priv, port, 1);
+	priv->port_sts[port].enabled = 1;
+
+	if (dsa_is_user_port(ds, port))
+		phy_support_asym_pause(phy);
+
+	return 0;
+}
+
+void
+qca8k_port_disable(struct dsa_switch *ds, int port)
+{
+	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
+
+	qca8k_port_set_status(priv, port, 0);
+	priv->port_sts[port].enabled = 0;
+}
+
+int
+qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
+{
+	struct qca8k_priv *priv = ds->priv;
+	int i, mtu = 0;
+
+	priv->port_mtu[port] = new_mtu;
+
+	for (i = 0; i < QCA8K_NUM_PORTS; i++)
+		if (priv->port_mtu[i] > mtu)
+			mtu = priv->port_mtu[i];
+
+	/* Include L2 header / FCS length */
+	return regmap_write(priv->regmap, QCA8K_MAX_FRAME_SIZE, mtu + ETH_HLEN + ETH_FCS_LEN);
+}
+
+int
+qca8k_port_max_mtu(struct dsa_switch *ds, int port)
+{
+	return QCA8K_MAX_MTU;
+}
+
+int
+qca8k_port_fdb_insert(struct qca8k_priv *priv, const u8 *addr,
+		      u16 port_mask, u16 vid)
+{
+	/* Set the vid to the port vlan id if no vid is set */
+	if (!vid)
+		vid = QCA8K_PORT_VID_DEF;
+
+	return qca8k_fdb_add(priv, addr, port_mask, vid,
+			     QCA8K_ATU_STATUS_STATIC);
+}
+
+int
+qca8k_port_fdb_add(struct dsa_switch *ds, int port,
+		   const unsigned char *addr, u16 vid)
+{
+	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
+	u16 port_mask = BIT(port);
+
+	return qca8k_port_fdb_insert(priv, addr, port_mask, vid);
+}
+
+int
+qca8k_port_fdb_del(struct dsa_switch *ds, int port,
+		   const unsigned char *addr, u16 vid)
+{
+	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
+	u16 port_mask = BIT(port);
+
+	if (!vid)
+		vid = QCA8K_PORT_VID_DEF;
+
+	return qca8k_fdb_del(priv, addr, port_mask, vid);
+}
+
+int
+qca8k_port_fdb_dump(struct dsa_switch *ds, int port,
+		    dsa_fdb_dump_cb_t *cb, void *data)
+{
+	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
+	struct qca8k_fdb _fdb = { 0 };
+	int cnt = QCA8K_NUM_FDB_RECORDS;
+	bool is_static;
+	int ret = 0;
+
+	mutex_lock(&priv->reg_mutex);
+	while (cnt-- && !qca8k_fdb_next(priv, &_fdb, port)) {
+		if (!_fdb.aging)
+			break;
+		is_static = (_fdb.aging == QCA8K_ATU_STATUS_STATIC);
+		ret = cb(_fdb.mac, _fdb.vid, is_static, data);
+		if (ret)
+			break;
+	}
+	mutex_unlock(&priv->reg_mutex);
+
+	return 0;
+}
+
+int
+qca8k_port_mdb_add(struct dsa_switch *ds, int port,
+		   const struct switchdev_obj_port_mdb *mdb)
+{
+	struct qca8k_priv *priv = ds->priv;
+	struct qca8k_fdb fdb = { 0 };
+	const u8 *addr = mdb->addr;
+	u8 port_mask = BIT(port);
+	u16 vid = mdb->vid;
+	int ret;
+
+	/* Check if entry already exist */
+	ret = qca8k_fdb_search(priv, &fdb, addr, vid);
+	if (ret < 0)
+		return ret;
+
+	/* Rule exist. Delete first */
+	if (!fdb.aging) {
+		ret = qca8k_fdb_del(priv, addr, fdb.port_mask, vid);
+		if (ret)
+			return ret;
+	}
+
+	/* Add port to fdb portmask */
+	fdb.port_mask |= port_mask;
+
+	return qca8k_port_fdb_insert(priv, addr, fdb.port_mask, vid);
+}
+
+int
+qca8k_port_mdb_del(struct dsa_switch *ds, int port,
+		   const struct switchdev_obj_port_mdb *mdb)
+{
+	struct qca8k_priv *priv = ds->priv;
+	struct qca8k_fdb fdb = { 0 };
+	const u8 *addr = mdb->addr;
+	u8 port_mask = BIT(port);
+	u16 vid = mdb->vid;
+	int ret;
+
+	/* Check if entry already exist */
+	ret = qca8k_fdb_search(priv, &fdb, addr, vid);
+	if (ret < 0)
+		return ret;
+
+	/* Rule doesn't exist. Why delete? */
+	if (!fdb.aging)
+		return -EINVAL;
+
+	ret = qca8k_fdb_del(priv, addr, port_mask, vid);
+	if (ret)
+		return ret;
+
+	/* Only port in the rule is this port. Don't re insert */
+	if (fdb.port_mask == port_mask)
+		return 0;
+
+	/* Remove port from port mask */
+	fdb.port_mask &= ~port_mask;
+
+	return qca8k_port_fdb_insert(priv, addr, fdb.port_mask, vid);
+}
+
+int
+qca8k_port_mirror_add(struct dsa_switch *ds, int port,
+		      struct dsa_mall_mirror_tc_entry *mirror,
+		      bool ingress)
+{
+	struct qca8k_priv *priv = ds->priv;
+	int monitor_port, ret;
+	u32 reg, val;
+
+	/* Check for existent entry */
+	if ((ingress ? priv->mirror_rx : priv->mirror_tx) & BIT(port))
+		return -EEXIST;
+
+	ret = regmap_read(priv->regmap, QCA8K_REG_GLOBAL_FW_CTRL0, &val);
+	if (ret)
+		return ret;
+
+	/* QCA83xx can have only one port set to mirror mode.
+	 * Check that the correct port is requested and return error otherwise.
+	 * When no mirror port is set, the values is set to 0xF
+	 */
+	monitor_port = FIELD_GET(QCA8K_GLOBAL_FW_CTRL0_MIRROR_PORT_NUM, val);
+	if (monitor_port != 0xF && monitor_port != mirror->to_local_port)
+		return -EEXIST;
+
+	/* Set the monitor port */
+	val = FIELD_PREP(QCA8K_GLOBAL_FW_CTRL0_MIRROR_PORT_NUM,
+			 mirror->to_local_port);
+	ret = regmap_update_bits(priv->regmap, QCA8K_REG_GLOBAL_FW_CTRL0,
+				 QCA8K_GLOBAL_FW_CTRL0_MIRROR_PORT_NUM, val);
+	if (ret)
+		return ret;
+
+	if (ingress) {
+		reg = QCA8K_PORT_LOOKUP_CTRL(port);
+		val = QCA8K_PORT_LOOKUP_ING_MIRROR_EN;
+	} else {
+		reg = QCA8K_REG_PORT_HOL_CTRL1(port);
+		val = QCA8K_PORT_HOL_CTRL1_EG_MIRROR_EN;
+	}
+
+	ret = regmap_update_bits(priv->regmap, reg, val, val);
+	if (ret)
+		return ret;
+
+	/* Track mirror port for tx and rx to decide when the
+	 * mirror port has to be disabled.
+	 */
+	if (ingress)
+		priv->mirror_rx |= BIT(port);
+	else
+		priv->mirror_tx |= BIT(port);
+
+	return 0;
+}
+
+void
+qca8k_port_mirror_del(struct dsa_switch *ds, int port,
+		      struct dsa_mall_mirror_tc_entry *mirror)
+{
+	struct qca8k_priv *priv = ds->priv;
+	u32 reg, val;
+	int ret;
+
+	if (mirror->ingress) {
+		reg = QCA8K_PORT_LOOKUP_CTRL(port);
+		val = QCA8K_PORT_LOOKUP_ING_MIRROR_EN;
+	} else {
+		reg = QCA8K_REG_PORT_HOL_CTRL1(port);
+		val = QCA8K_PORT_HOL_CTRL1_EG_MIRROR_EN;
+	}
+
+	ret = regmap_clear_bits(priv->regmap, reg, val);
+	if (ret)
+		goto err;
+
+	if (mirror->ingress)
+		priv->mirror_rx &= ~BIT(port);
+	else
+		priv->mirror_tx &= ~BIT(port);
+
+	/* No port set to send packet to mirror port. Disable mirror port */
+	if (!priv->mirror_rx && !priv->mirror_tx) {
+		val = FIELD_PREP(QCA8K_GLOBAL_FW_CTRL0_MIRROR_PORT_NUM, 0xF);
+		ret = regmap_update_bits(priv->regmap, QCA8K_REG_GLOBAL_FW_CTRL0,
+					 QCA8K_GLOBAL_FW_CTRL0_MIRROR_PORT_NUM, val);
+		if (ret)
+			goto err;
+	}
+err:
+	dev_err(priv->dev, "Failed to del mirror port from %d", port);
+}
+
+int
+qca8k_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
+			  struct netlink_ext_ack *extack)
+{
+	struct qca8k_priv *priv = ds->priv;
+	int ret;
+
+	if (vlan_filtering) {
+		ret = regmap_update_bits(priv->regmap, QCA8K_PORT_LOOKUP_CTRL(port),
+					 QCA8K_PORT_LOOKUP_VLAN_MODE_MASK,
+					 QCA8K_PORT_LOOKUP_VLAN_MODE_SECURE);
+	} else {
+		ret = regmap_update_bits(priv->regmap, QCA8K_PORT_LOOKUP_CTRL(port),
+					 QCA8K_PORT_LOOKUP_VLAN_MODE_MASK,
+					 QCA8K_PORT_LOOKUP_VLAN_MODE_NONE);
+	}
+
+	return ret;
+}
+
+int
+qca8k_port_vlan_add(struct dsa_switch *ds, int port,
+		    const struct switchdev_obj_port_vlan *vlan,
+		    struct netlink_ext_ack *extack)
+{
+	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
+	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
+	struct qca8k_priv *priv = ds->priv;
+	int ret;
+
+	ret = qca8k_vlan_add(priv, port, vlan->vid, untagged);
+	if (ret) {
+		dev_err(priv->dev, "Failed to add VLAN to port %d (%d)", port, ret);
+		return ret;
+	}
+
+	if (pvid) {
+		ret = regmap_update_bits(priv->regmap, QCA8K_EGRESS_VLAN(port),
+					 QCA8K_EGREES_VLAN_PORT_MASK(port),
+					 QCA8K_EGREES_VLAN_PORT(port, vlan->vid));
+		if (ret)
+			return ret;
+
+		ret = regmap_write(priv->regmap, QCA8K_REG_PORT_VLAN_CTRL0(port),
+				   QCA8K_PORT_VLAN_CVID(vlan->vid) |
+				   QCA8K_PORT_VLAN_SVID(vlan->vid));
+	}
+
+	return ret;
+}
+
+int
+qca8k_port_vlan_del(struct dsa_switch *ds, int port,
+		    const struct switchdev_obj_port_vlan *vlan)
+{
+	struct qca8k_priv *priv = ds->priv;
+	int ret;
+
+	ret = qca8k_vlan_del(priv, port, vlan->vid);
+	if (ret)
+		dev_err(priv->dev, "Failed to delete VLAN from port %d (%d)", port, ret);
+
+	return ret;
+}
+
+bool
+qca8k_lag_can_offload(struct dsa_switch *ds,
+		      struct net_device *lag,
+		      struct netdev_lag_upper_info *info)
+{
+	struct dsa_port *dp;
+	int id, members = 0;
+
+	id = dsa_lag_id(ds->dst, lag);
+	if (id < 0 || id >= ds->num_lag_ids)
+		return false;
+
+	dsa_lag_foreach_port(dp, ds->dst, lag)
+		/* Includes the port joining the LAG */
+		members++;
+
+	if (members > QCA8K_NUM_PORTS_FOR_LAG)
+		return false;
+
+	if (info->tx_type != NETDEV_LAG_TX_TYPE_HASH)
+		return false;
+
+	return true;
+}
+
+int
+qca8k_lag_refresh_portmap(struct dsa_switch *ds, int port,
+			  struct net_device *lag, bool delete)
+{
+	struct qca8k_priv *priv = ds->priv;
+	int ret, id, i;
+	u32 val;
+
+	id = dsa_lag_id(ds->dst, lag);
+
+	/* Read current port member */
+	ret = regmap_read(priv->regmap, QCA8K_REG_GOL_TRUNK_CTRL0, &val);
+	if (ret)
+		return ret;
+
+	/* Shift val to the correct trunk */
+	val >>= QCA8K_REG_GOL_TRUNK_SHIFT(id);
+	val &= QCA8K_REG_GOL_TRUNK_MEMBER_MASK;
+	if (delete)
+		val &= ~BIT(port);
+	else
+		val |= BIT(port);
+
+	/* Update port member. With empty portmap disable trunk */
+	ret = regmap_update_bits(priv->regmap, QCA8K_REG_GOL_TRUNK_CTRL0,
+				 QCA8K_REG_GOL_TRUNK_MEMBER(id) |
+				 QCA8K_REG_GOL_TRUNK_EN(id),
+				 !val << QCA8K_REG_GOL_TRUNK_SHIFT(id) |
+				 val << QCA8K_REG_GOL_TRUNK_SHIFT(id));
+
+	/* Search empty member if adding or port on deleting */
+	for (i = 0; i < 4; i++) {
+		ret = regmap_read(priv->regmap, QCA8K_REG_GOL_TRUNK_CTRL(id), &val);
+		if (ret)
+			return ret;
+
+		val >>= QCA8K_REG_GOL_TRUNK_ID_MEM_ID_SHIFT(id, i);
+		val &= QCA8K_REG_GOL_TRUNK_ID_MEM_ID_MASK;
+
+		if (delete) {
+			/* If port flagged to be disabled assume this member is
+			 * empty
+			 */
+			if (val != QCA8K_REG_GOL_TRUNK_ID_MEM_ID_EN_MASK)
+				continue;
+
+			val &= QCA8K_REG_GOL_TRUNK_ID_MEM_ID_PORT_MASK;
+			if (val != port)
+				continue;
+		} else {
+			/* If port flagged to be enabled assume this member is
+			 * already set
+			 */
+			if (val == QCA8K_REG_GOL_TRUNK_ID_MEM_ID_EN_MASK)
+				continue;
+		}
+
+		/* We find the member to remove */
+		break;
+	}
+
+	/* Set port in the correct port mask or disable port if in delate mode */
+	return regmap_update_bits(priv->regmap, QCA8K_REG_GOL_TRUNK_CTRL(id),
+				  QCA8K_REG_GOL_TRUNK_ID_MEM_ID_EN(id, i) |
+				  QCA8K_REG_GOL_TRUNK_ID_MEM_ID_PORT(id, i),
+				  !delete << QCA8K_REG_GOL_TRUNK_ID_MEM_ID_SHIFT(id, i) |
+				  port << QCA8K_REG_GOL_TRUNK_ID_MEM_ID_SHIFT(id, i));
+}
+
+int
+qca8k_port_lag_join(struct dsa_switch *ds, int port,
+		    struct net_device *lag,
+		    struct netdev_lag_upper_info *info)
+{
+	if (!qca8k_lag_can_offload(ds, lag, info))
+		return -EOPNOTSUPP;
+
+	return qca8k_lag_refresh_portmap(ds, port, lag, false);
+}
+
+int
+qca8k_port_lag_leave(struct dsa_switch *ds, int port,
+		     struct net_device *lag)
+{
+	return qca8k_lag_refresh_portmap(ds, port, lag, true);
+}
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index 5310022569f3..8e3888bf6823 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -360,4 +360,54 @@ struct qca8k_fdb {
 	u8 mac[6];
 };
 
+/* Common setup function */
+extern const struct regmap_access_table qca8k_readable_table;
+
+void qca8k_fdb_flush(struct qca8k_priv *priv);
+int qca8k_mib_init(struct qca8k_priv *priv);
+void qca8k_port_set_status(struct qca8k_priv *priv, int port, int enable);
+void qca8k_phylink_mac_link_up(struct dsa_switch *ds, int port, unsigned int mode,
+			       phy_interface_t interface, struct phy_device *phydev, int speed,
+			       int duplex, bool tx_pause, bool rx_pause);
+void qca8k_phylink_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
+				 phy_interface_t interface);
+int qca8k_phylink_mac_link_state(struct dsa_switch *ds, int port, struct phylink_link_state *state);
+
+/* Common ops function */
+void qca8k_get_strings(struct dsa_switch *ds, int port, u32 stringset, uint8_t *data);
+void qca8k_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *data);
+int qca8k_get_sset_count(struct dsa_switch *ds, int port, int sset);
+int qca8k_set_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *eee);
+int qca8k_get_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *e);
+void qca8k_port_stp_state_set(struct dsa_switch *ds, int port, u8 state);
+int qca8k_port_bridge_join(struct dsa_switch *ds, int port, struct net_device *br);
+void qca8k_port_bridge_leave(struct dsa_switch *ds, int port, struct net_device *br);
+void qca8k_port_fast_age(struct dsa_switch *ds, int port);
+int qca8k_set_ageing_time(struct dsa_switch *ds, unsigned int msecs);
+int qca8k_port_enable(struct dsa_switch *ds, int port, struct phy_device *phy);
+void qca8k_port_disable(struct dsa_switch *ds, int port);
+int qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu);
+int qca8k_port_max_mtu(struct dsa_switch *ds, int port);
+int qca8k_port_fdb_insert(struct qca8k_priv *priv, const u8 *addr, u16 port_mask, u16 vid);
+int qca8k_port_fdb_add(struct dsa_switch *ds, int port, const unsigned char *addr, u16 vid);
+int qca8k_port_fdb_del(struct dsa_switch *ds, int port, const unsigned char *addr, u16 vid);
+int qca8k_port_fdb_dump(struct dsa_switch *ds, int port, dsa_fdb_dump_cb_t *cb, void *data);
+int qca8k_port_mdb_add(struct dsa_switch *ds, int port, const struct switchdev_obj_port_mdb *mdb);
+int qca8k_port_mdb_del(struct dsa_switch *ds, int port, const struct switchdev_obj_port_mdb *mdb);
+int qca8k_port_mirror_add(struct dsa_switch *ds, int port, struct dsa_mall_mirror_tc_entry *mirror,
+			  bool ingress);
+void qca8k_port_mirror_del(struct dsa_switch *ds, int port,
+			   struct dsa_mall_mirror_tc_entry *mirror);
+int qca8k_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
+			      struct netlink_ext_ack *extack);
+int qca8k_port_vlan_add(struct dsa_switch *ds, int port, const struct switchdev_obj_port_vlan *vlan,
+			struct netlink_ext_ack *extack);
+int qca8k_port_vlan_del(struct dsa_switch *ds, int port,
+			const struct switchdev_obj_port_vlan *vlan);
+bool qca8k_lag_can_offload(struct dsa_switch *ds, struct net_device *lag,
+			   struct netdev_lag_upper_info *info);
+int qca8k_port_lag_join(struct dsa_switch *ds, int port, struct net_device *lag,
+			struct netdev_lag_upper_info *info);
+int qca8k_port_lag_leave(struct dsa_switch *ds, int port, struct net_device *lag);
+
 #endif /* __QCA8K_H */
-- 
2.32.0

