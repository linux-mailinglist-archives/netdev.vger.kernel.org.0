Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C23F5577083
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 19:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232251AbiGPRux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 13:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbiGPRuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 13:50:39 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D551EC72;
        Sat, 16 Jul 2022 10:50:35 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id e15so5708377wro.5;
        Sat, 16 Jul 2022 10:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=7tl82ckDgfUcIaha61NfPIcE18InYXONKJ7q5EvcRGc=;
        b=AnLzUhtARh9T/HSz7s4xdJZp/7mCc7f4cbW+ZO1eMiUfBjZ9BmHBJGUtaEVqDSyJzB
         iRo1MYoj3BDC15074BiTFgliP0qBbP6VfxcoP+mj/bVMfqgrxOK4clPzQ6z8/c4hmqtg
         /AyHvo2FwfWVXBCrcUyAdlAyJxq+j2/n1Gbcyclg/47V0jW8M/xpGt/Ti48oB3jQWUfF
         mDgzZ7NdIxja5F47rEql22IKegydC3O53hHkRtY1AhI9+HgCii84cAAiUa7DEaY5tsPs
         dUlP6W5ssz+snDne8bIAkTWvubsKh4d9LKfa7yGvfCY3BwikWhKKuDNhK5ByL+0SRssb
         l/tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7tl82ckDgfUcIaha61NfPIcE18InYXONKJ7q5EvcRGc=;
        b=DqPm8rtMct4U2jlNgRfuMRU+KcEoLu2BWT/rnlpJUqeQ5qKevVksnuBbse9GEiIBFu
         1xQljvU8I5b34sPgo9b8k144D1DmgG4z3KqchITgpkVPIVklVtLprlpWwnWdPl9YdMBp
         D7lHSv8y3NHDGKK7mXGwLr+ulg3YSPt5vOaSmIrSiSR3aGmQsf2PUMRZGXTA9jD3oY6C
         7/QHPcTHJJO9mmJTlO/xLMa3sSjTkvSCA+xs27hDfmDlBHwN7hEF0lq40N/nSJ82HTJY
         0+2uzIIr4eDdMN7lTHHDA3UJuiE6SMQWEl8oYE20vBmHTRPTF4B/0oXZVg/vLNP0czro
         tFVg==
X-Gm-Message-State: AJIora8QRe22WbKEymiidYVAbHvkWWNVtaBjq3SKVQxbsEBDCqgMmjig
        Vjet2HtmkTuRapa+ZBRPBAI=
X-Google-Smtp-Source: AGRyM1vZlalV4VCBzwSr3JUn2zbdzX/s/XJruc5pvidcnc1cIeGN1V9kp9kRZqJum4I8gqMf1YsFyw==
X-Received: by 2002:a5d:55d0:0:b0:21d:cf5a:7617 with SMTP id i16-20020a5d55d0000000b0021dcf5a7617mr6879026wrw.368.1657993833093;
        Sat, 16 Jul 2022 10:50:33 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id s6-20020adfecc6000000b0021d74906683sm6836108wro.28.2022.07.16.10.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jul 2022 10:50:32 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [net-next RFC PATCH 4/4] net: dsa: qca8k: split qca8k in common and 8xxx specific code
Date:   Sat, 16 Jul 2022 19:49:58 +0200
Message-Id: <20220716174958.22542-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220716174958.22542-1-ansuelsmth@gmail.com>
References: <20220716174958.22542-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The qca8k family reg structure is also used in the internal ipq40xx
switch. Split qca8k common code from specific code for future
implementation of ipq40xx internal switch based on qca8k.

While at it also fix minor wrong format for comments and reallign
function as we had to drop static declaration.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/Makefile                  |    1 +
 drivers/net/dsa/qca/{qca8k.c => qca8k-8xxx.c} | 1210 +----------------
 drivers/net/dsa/qca/qca8k-common.c            | 1174 ++++++++++++++++
 drivers/net/dsa/qca/qca8k.h                   |   58 +
 4 files changed, 1245 insertions(+), 1198 deletions(-)
 rename drivers/net/dsa/qca/{qca8k.c => qca8k-8xxx.c} (64%)
 create mode 100644 drivers/net/dsa/qca/qca8k-common.c

diff --git a/drivers/net/dsa/qca/Makefile b/drivers/net/dsa/qca/Makefile
index 40bb7c27285b..701f1d199e93 100644
--- a/drivers/net/dsa/qca/Makefile
+++ b/drivers/net/dsa/qca/Makefile
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_NET_DSA_AR9331)	+= ar9331.o
 obj-$(CONFIG_NET_DSA_QCA8K)	+= qca8k.o
+qca8k-y 			+= qca8k-common.o qca8k-8xxx.o
diff --git a/drivers/net/dsa/qca/qca8k.c b/drivers/net/dsa/qca/qca8k-8xxx.c
similarity index 64%
rename from drivers/net/dsa/qca/qca8k.c
rename to drivers/net/dsa/qca/qca8k-8xxx.c
index e527d15d5065..85d138fced66 100644
--- a/drivers/net/dsa/qca/qca8k.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -24,57 +24,6 @@
 
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
 static void
 qca8k_split_addr(u32 regaddr, u16 *r1, u16 *r2, u16 *page)
 {
@@ -528,30 +477,6 @@ qca8k_regmap_update_bits(void *ctx, uint32_t reg, uint32_t mask, uint32_t write_
 	return qca8k_regmap_update_bits_mii(priv, reg, mask, write_val);
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
 	.reg_bits = 32,
 	.val_bits = 32,
@@ -567,386 +492,6 @@ static struct regmap_config qca8k_regmap_config = {
 	.max_raw_write = 16,
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
-	u32 reg[QCA8K_ATU_TABLE_SIZE];
-	int ret;
-
-	/* load the ARL table into an array */
-	ret = regmap_bulk_read(priv->regmap, QCA8K_REG_ATU_DATA0, reg,
-			       QCA8K_ATU_TABLE_SIZE);
-	if (ret)
-		return ret;
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
-	u32 reg[QCA8K_ATU_TABLE_SIZE] = { 0 };
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
-	regmap_bulk_write(priv->regmap, QCA8K_REG_ATU_DATA0, reg, QCA8K_ATU_TABLE_SIZE);
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
-qca8k_fdb_search_and_insert(struct qca8k_priv *priv, u8 port_mask,
-			    const u8 *mac, u16 vid)
-{
-	struct qca8k_fdb fdb = { 0 };
-	int ret;
-
-	mutex_lock(&priv->reg_mutex);
-
-	qca8k_fdb_write(priv, vid, 0, mac, 0);
-	ret = qca8k_fdb_access(priv, QCA8K_FDB_SEARCH, -1);
-	if (ret < 0)
-		goto exit;
-
-	ret = qca8k_fdb_read(priv, &fdb);
-	if (ret < 0)
-		goto exit;
-
-	/* Rule exist. Delete first */
-	if (!fdb.aging) {
-		ret = qca8k_fdb_access(priv, QCA8K_FDB_PURGE, -1);
-		if (ret)
-			goto exit;
-	}
-
-	/* Add port to fdb portmask */
-	fdb.port_mask |= port_mask;
-
-	qca8k_fdb_write(priv, vid, fdb.port_mask, mac, fdb.aging);
-	ret = qca8k_fdb_access(priv, QCA8K_FDB_LOAD, -1);
-
-exit:
-	mutex_unlock(&priv->reg_mutex);
-	return ret;
-}
-
-static int
-qca8k_fdb_search_and_del(struct qca8k_priv *priv, u8 port_mask,
-			 const u8 *mac, u16 vid)
-{
-	struct qca8k_fdb fdb = { 0 };
-	int ret;
-
-	mutex_lock(&priv->reg_mutex);
-
-	qca8k_fdb_write(priv, vid, 0, mac, 0);
-	ret = qca8k_fdb_access(priv, QCA8K_FDB_SEARCH, -1);
-	if (ret < 0)
-		goto exit;
-
-	/* Rule doesn't exist. Why delete? */
-	if (!fdb.aging) {
-		ret = -EINVAL;
-		goto exit;
-	}
-
-	ret = qca8k_fdb_access(priv, QCA8K_FDB_PURGE, -1);
-	if (ret)
-		goto exit;
-
-	/* Only port in the rule is this port. Don't re insert */
-	if (fdb.port_mask == port_mask)
-		goto exit;
-
-	/* Remove port from port mask */
-	fdb.port_mask &= ~port_mask;
-
-	qca8k_fdb_write(priv, vid, fdb.port_mask, mac, fdb.aging);
-	ret = qca8k_fdb_access(priv, QCA8K_FDB_LOAD, -1);
-
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
-	ret = regmap_update_bits(priv->regmap, QCA8K_REG_MIB,
-				 QCA8K_MIB_FUNC | QCA8K_MIB_BUSY,
-				 FIELD_PREP(QCA8K_MIB_FUNC, QCA8K_MIB_FLUSH) |
-				 QCA8K_MIB_BUSY);
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
 static int
 qca8k_phy_eth_busy_wait(struct qca8k_mgmt_eth_data *mgmt_eth_data,
 			struct sk_buff *read_skb, u32 *val)
@@ -1990,23 +1535,6 @@ static void qca8k_setup_pcs(struct qca8k_priv *priv, struct qca8k_pcs *qpcs,
 	qpcs->port = port;
 }
 
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
-	match_data = of_device_get_match_data(priv->dev);
-
-	for (i = 0; i < match_data->mib_count; i++)
-		strncpy(data + i * ETH_GSTRING_LEN, ar8327_mib[i].name,
-			ETH_GSTRING_LEN);
-}
-
 static void qca8k_mib_autocast_handler(struct dsa_switch *ds, struct sk_buff *skb)
 {
 	const struct qca8k_match_data *match_data;
@@ -2098,537 +1626,21 @@ qca8k_get_ethtool_stats_eth(struct dsa_switch *ds, int port, u64 *data)
 	return ret;
 }
 
-static void
-qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
-			uint64_t *data)
+static u32 qca8k_get_phy_flags(struct dsa_switch *ds, int port)
 {
-	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
-	const struct qca8k_match_data *match_data;
-	const struct qca8k_mib_desc *mib;
-	u32 reg, i, val;
-	u32 hi = 0;
-	int ret;
+	struct qca8k_priv *priv = ds->priv;
 
-	if (priv->mgmt_master && priv->autocast_mib &&
-	    priv->autocast_mib(ds, port, data) > 0)
-		return;
+	/* Communicate to the phy internal driver the switch revision.
+	 * Based on the switch revision different values needs to be
+	 * set to the dbg and mmd reg on the phy.
+	 * The first 2 bit are used to communicate the switch revision
+	 * to the phy driver.
+	 */
+	if (port > 0 && port < 6)
+		return priv->switch_revision;
 
-	match_data = of_device_get_match_data(priv->dev);
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
-{
-	const struct qca8k_match_data *match_data;
-	struct qca8k_priv *priv = ds->priv;
-
-	if (sset != ETH_SS_STATS)
-		return 0;
-
-	match_data = of_device_get_match_data(priv->dev);
-
-	return match_data->mib_count;
-}
-
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
-static int qca8k_port_bridge_join(struct dsa_switch *ds, int port,
-				  struct dsa_bridge bridge,
-				  bool *tx_fwd_offload,
-				  struct netlink_ext_ack *extack)
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
-		if (!dsa_port_offloads_bridge(dsa_to_port(ds, i), &bridge))
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
-static void qca8k_port_bridge_leave(struct dsa_switch *ds, int port,
-				    struct dsa_bridge bridge)
-{
-	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
-	int cpu_port, i;
-
-	cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
-
-	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
-		if (dsa_is_cpu_port(ds, i))
-			continue;
-		if (!dsa_port_offloads_bridge(dsa_to_port(ds, i), &bridge))
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
-	/* Handle case with 0 as val to NOT disable
-	 * learning
-	 */
-	if (!val)
-		val = 1;
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
-	priv->port_enabled_map |= BIT(port);
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
-	priv->port_enabled_map &= ~BIT(port);
-}
-
-static int
-qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
-{
-	struct qca8k_priv *priv = ds->priv;
-	int ret;
-
-	/* We have only have a general MTU setting.
-	 * DSA always set the CPU port's MTU to the largest MTU of the slave
-	 * ports.
-	 * Setting MTU just for the CPU port is sufficient to correctly set a
-	 * value for every port.
-	 */
-	if (!dsa_is_cpu_port(ds, port))
-		return 0;
-
-	/* To change the MAX_FRAME_SIZE the cpu ports must be off or
-	 * the switch panics.
-	 * Turn off both cpu ports before applying the new value to prevent
-	 * this.
-	 */
-	if (priv->port_enabled_map & BIT(0))
-		qca8k_port_set_status(priv, 0, 0);
-
-	if (priv->port_enabled_map & BIT(6))
-		qca8k_port_set_status(priv, 6, 0);
-
-	/* Include L2 header / FCS length */
-	ret = regmap_write(priv->regmap, QCA8K_MAX_FRAME_SIZE, new_mtu + ETH_HLEN + ETH_FCS_LEN);
-
-	if (priv->port_enabled_map & BIT(0))
-		qca8k_port_set_status(priv, 0, 1);
-
-	if (priv->port_enabled_map & BIT(6))
-		qca8k_port_set_status(priv, 6, 1);
-
-	return ret;
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
-		   const unsigned char *addr, u16 vid,
-		   struct dsa_db db)
-{
-	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
-	u16 port_mask = BIT(port);
-
-	return qca8k_port_fdb_insert(priv, addr, port_mask, vid);
-}
-
-static int
-qca8k_port_fdb_del(struct dsa_switch *ds, int port,
-		   const unsigned char *addr, u16 vid,
-		   struct dsa_db db)
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
-		   const struct switchdev_obj_port_mdb *mdb,
-		   struct dsa_db db)
-{
-	struct qca8k_priv *priv = ds->priv;
-	const u8 *addr = mdb->addr;
-	u16 vid = mdb->vid;
-
-	return qca8k_fdb_search_and_insert(priv, BIT(port), addr, vid);
-}
-
-static int
-qca8k_port_mdb_del(struct dsa_switch *ds, int port,
-		   const struct switchdev_obj_port_mdb *mdb,
-		   struct dsa_db db)
-{
-	struct qca8k_priv *priv = ds->priv;
-	const u8 *addr = mdb->addr;
-	u16 vid = mdb->vid;
-
-	return qca8k_fdb_search_and_del(priv, BIT(port), addr, vid);
-}
-
-static int
-qca8k_port_mirror_add(struct dsa_switch *ds, int port,
-		      struct dsa_mall_mirror_tc_entry *mirror,
-		      bool ingress, struct netlink_ext_ack *extack)
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
+	return 0;
+}
 
 static enum dsa_tag_protocol
 qca8k_get_tag_protocol(struct dsa_switch *ds, int port,
@@ -2637,174 +1649,6 @@ qca8k_get_tag_protocol(struct dsa_switch *ds, int port,
 	return DSA_TAG_PROTO_QCA;
 }
 
-static bool
-qca8k_lag_can_offload(struct dsa_switch *ds, struct dsa_lag lag,
-		      struct netdev_lag_upper_info *info)
-{
-	struct dsa_port *dp;
-	int members = 0;
-
-	if (!lag.id)
-		return false;
-
-	dsa_lag_foreach_port(dp, ds->dst, &lag)
-		/* Includes the port joining the LAG */
-		members++;
-
-	if (members > QCA8K_NUM_PORTS_FOR_LAG)
-		return false;
-
-	if (info->tx_type != NETDEV_LAG_TX_TYPE_HASH)
-		return false;
-
-	if (info->hash_type != NETDEV_LAG_HASH_L2 &&
-	    info->hash_type != NETDEV_LAG_HASH_L23)
-		return false;
-
-	return true;
-}
-
-static int
-qca8k_lag_setup_hash(struct dsa_switch *ds, struct dsa_lag lag,
-		     struct netdev_lag_upper_info *info)
-{
-	struct net_device *lag_dev = lag.dev;
-	struct qca8k_priv *priv = ds->priv;
-	bool unique_lag = true;
-	unsigned int i;
-	u32 hash = 0;
-
-	switch (info->hash_type) {
-	case NETDEV_LAG_HASH_L23:
-		hash |= QCA8K_TRUNK_HASH_SIP_EN;
-		hash |= QCA8K_TRUNK_HASH_DIP_EN;
-		fallthrough;
-	case NETDEV_LAG_HASH_L2:
-		hash |= QCA8K_TRUNK_HASH_SA_EN;
-		hash |= QCA8K_TRUNK_HASH_DA_EN;
-		break;
-	default: /* We should NEVER reach this */
-		return -EOPNOTSUPP;
-	}
-
-	/* Check if we are the unique configured LAG */
-	dsa_lags_foreach_id(i, ds->dst)
-		if (i != lag.id && dsa_lag_by_id(ds->dst, i)) {
-			unique_lag = false;
-			break;
-		}
-
-	/* Hash Mode is global. Make sure the same Hash Mode
-	 * is set to all the 4 possible lag.
-	 * If we are the unique LAG we can set whatever hash
-	 * mode we want.
-	 * To change hash mode it's needed to remove all LAG
-	 * and change the mode with the latest.
-	 */
-	if (unique_lag) {
-		priv->lag_hash_mode = hash;
-	} else if (priv->lag_hash_mode != hash) {
-		netdev_err(lag_dev, "Error: Mismatched Hash Mode across different lag is not supported\n");
-		return -EOPNOTSUPP;
-	}
-
-	return regmap_update_bits(priv->regmap, QCA8K_TRUNK_HASH_EN_CTRL,
-				  QCA8K_TRUNK_HASH_MASK, hash);
-}
-
-static int
-qca8k_lag_refresh_portmap(struct dsa_switch *ds, int port,
-			  struct dsa_lag lag, bool delete)
-{
-	struct qca8k_priv *priv = ds->priv;
-	int ret, id, i;
-	u32 val;
-
-	/* DSA LAG IDs are one-based, hardware is zero-based */
-	id = lag.id - 1;
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
-	for (i = 0; i < QCA8K_NUM_PORTS_FOR_LAG; i++) {
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
-		/* We have found the member to add/remove */
-		break;
-	}
-
-	/* Set port in the correct port mask or disable port if in delete mode */
-	return regmap_update_bits(priv->regmap, QCA8K_REG_GOL_TRUNK_CTRL(id),
-				  QCA8K_REG_GOL_TRUNK_ID_MEM_ID_EN(id, i) |
-				  QCA8K_REG_GOL_TRUNK_ID_MEM_ID_PORT(id, i),
-				  !delete << QCA8K_REG_GOL_TRUNK_ID_MEM_ID_SHIFT(id, i) |
-				  port << QCA8K_REG_GOL_TRUNK_ID_MEM_ID_SHIFT(id, i));
-}
-
-static int
-qca8k_port_lag_join(struct dsa_switch *ds, int port, struct dsa_lag lag,
-		    struct netdev_lag_upper_info *info)
-{
-	int ret;
-
-	if (!qca8k_lag_can_offload(ds, lag, info))
-		return -EOPNOTSUPP;
-
-	ret = qca8k_lag_setup_hash(ds, lag, info);
-	if (ret)
-		return ret;
-
-	return qca8k_lag_refresh_portmap(ds, port, lag, false);
-}
-
-static int
-qca8k_port_lag_leave(struct dsa_switch *ds, int port,
-		     struct dsa_lag lag)
-{
-	return qca8k_lag_refresh_portmap(ds, port, lag, true);
-}
-
 static void
 qca8k_master_change(struct dsa_switch *ds, const struct net_device *master,
 		    bool operational)
@@ -3090,36 +1934,6 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.connect_tag_protocol	= qca8k_connect_tag_protocol,
 };
 
-static int qca8k_read_switch_id(struct qca8k_priv *priv)
-{
-	const struct qca8k_match_data *data;
-	u32 val;
-	u8 id;
-	int ret;
-
-	/* get the switches ID from the compatible */
-	data = of_device_get_match_data(priv->dev);
-	if (!data)
-		return -ENODEV;
-
-	ret = regmap_read(priv->regmap, QCA8K_REG_MASK_CTRL, &val);
-	if (ret < 0)
-		return -ENODEV;
-
-	id = QCA8K_MASK_CTRL_DEVICE_ID(val);
-	if (id != data->id) {
-		dev_err(priv->dev, "Switch id detected %x but expected %x", id, data->id);
-		return -ENODEV;
-	}
-
-	priv->switch_id = id;
-
-	/* Save revision to communicate to the internal PHY driver */
-	priv->switch_revision = QCA8K_MASK_CTRL_REV_ID(val);
-
-	return 0;
-}
-
 static int
 qca8k_sw_probe(struct mdio_device *mdiodev)
 {
diff --git a/drivers/net/dsa/qca/qca8k-common.c b/drivers/net/dsa/qca/qca8k-common.c
new file mode 100644
index 000000000000..b8a18c5e7664
--- /dev/null
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -0,0 +1,1174 @@
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
+#include <linux/of_platform.h>
+#include <linux/if_bridge.h>
+
+#include "qca8k.h"
+
+#define MIB_DESC(_s, _o, _n)	\
+	{			\
+		.size = (_s),	\
+		.offset = (_o),	\
+		.name = (_n),	\
+	}
+
+const struct qca8k_mib_desc ar8327_mib[] = {
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
+	u32 reg[QCA8K_ATU_TABLE_SIZE];
+	int ret;
+
+	/* load the ARL table into an array */
+	ret = regmap_bulk_read(priv->regmap, QCA8K_REG_ATU_DATA0, reg,
+			       QCA8K_ATU_TABLE_SIZE);
+	if (ret)
+		return ret;
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
+	u32 reg[QCA8K_ATU_TABLE_SIZE] = { 0 };
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
+	regmap_bulk_write(priv->regmap, QCA8K_REG_ATU_DATA0, reg, QCA8K_ATU_TABLE_SIZE);
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
+void qca8k_fdb_flush(struct qca8k_priv *priv)
+{
+	mutex_lock(&priv->reg_mutex);
+	qca8k_fdb_access(priv, QCA8K_FDB_FLUSH, -1);
+	mutex_unlock(&priv->reg_mutex);
+}
+
+static int
+qca8k_fdb_search_and_insert(struct qca8k_priv *priv, u8 port_mask,
+			    const u8 *mac, u16 vid)
+{
+	struct qca8k_fdb fdb = { 0 };
+	int ret;
+
+	mutex_lock(&priv->reg_mutex);
+
+	qca8k_fdb_write(priv, vid, 0, mac, 0);
+	ret = qca8k_fdb_access(priv, QCA8K_FDB_SEARCH, -1);
+	if (ret < 0)
+		goto exit;
+
+	ret = qca8k_fdb_read(priv, &fdb);
+	if (ret < 0)
+		goto exit;
+
+	/* Rule exist. Delete first */
+	if (!fdb.aging) {
+		ret = qca8k_fdb_access(priv, QCA8K_FDB_PURGE, -1);
+		if (ret)
+			goto exit;
+	}
+
+	/* Add port to fdb portmask */
+	fdb.port_mask |= port_mask;
+
+	qca8k_fdb_write(priv, vid, fdb.port_mask, mac, fdb.aging);
+	ret = qca8k_fdb_access(priv, QCA8K_FDB_LOAD, -1);
+
+exit:
+	mutex_unlock(&priv->reg_mutex);
+	return ret;
+}
+
+static int
+qca8k_fdb_search_and_del(struct qca8k_priv *priv, u8 port_mask,
+			 const u8 *mac, u16 vid)
+{
+	struct qca8k_fdb fdb = { 0 };
+	int ret;
+
+	mutex_lock(&priv->reg_mutex);
+
+	qca8k_fdb_write(priv, vid, 0, mac, 0);
+	ret = qca8k_fdb_access(priv, QCA8K_FDB_SEARCH, -1);
+	if (ret < 0)
+		goto exit;
+
+	/* Rule doesn't exist. Why delete? */
+	if (!fdb.aging) {
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	ret = qca8k_fdb_access(priv, QCA8K_FDB_PURGE, -1);
+	if (ret)
+		goto exit;
+
+	/* Only port in the rule is this port. Don't re insert */
+	if (fdb.port_mask == port_mask)
+		goto exit;
+
+	/* Remove port from port mask */
+	fdb.port_mask &= ~port_mask;
+
+	qca8k_fdb_write(priv, vid, fdb.port_mask, mac, fdb.aging);
+	ret = qca8k_fdb_access(priv, QCA8K_FDB_LOAD, -1);
+
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
+int qca8k_mib_init(struct qca8k_priv *priv)
+{
+	int ret;
+
+	mutex_lock(&priv->reg_mutex);
+	ret = regmap_update_bits(priv->regmap, QCA8K_REG_MIB,
+				 QCA8K_MIB_FUNC | QCA8K_MIB_BUSY,
+				 FIELD_PREP(QCA8K_MIB_FUNC, QCA8K_MIB_FLUSH) |
+				 QCA8K_MIB_BUSY);
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
+void qca8k_port_set_status(struct qca8k_priv *priv, int port, int enable)
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
+void qca8k_get_strings(struct dsa_switch *ds, int port, u32 stringset, uint8_t *data)
+{
+	const struct qca8k_match_data *match_data;
+	struct qca8k_priv *priv = ds->priv;
+	int i;
+
+	if (stringset != ETH_SS_STATS)
+		return;
+
+	match_data = of_device_get_match_data(priv->dev);
+
+	for (i = 0; i < match_data->mib_count; i++)
+		strncpy(data + i * ETH_GSTRING_LEN, ar8327_mib[i].name,
+			ETH_GSTRING_LEN);
+}
+
+void qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
+			     uint64_t *data)
+{
+	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
+	const struct qca8k_match_data *match_data;
+	const struct qca8k_mib_desc *mib;
+	u32 reg, i, val;
+	u32 hi = 0;
+	int ret;
+
+	if (priv->mgmt_master && priv->autocast_mib &&
+	    priv->autocast_mib(ds, port, data) > 0)
+		return;
+
+	match_data = of_device_get_match_data(priv->dev);
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
+int qca8k_get_sset_count(struct dsa_switch *ds, int port, int sset)
+{
+	const struct qca8k_match_data *match_data;
+	struct qca8k_priv *priv = ds->priv;
+
+	if (sset != ETH_SS_STATS)
+		return 0;
+
+	match_data = of_device_get_match_data(priv->dev);
+
+	return match_data->mib_count;
+}
+
+int qca8k_set_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *eee)
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
+int qca8k_get_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *e)
+{
+	/* Nothing to do on the port's MAC */
+	return 0;
+}
+
+void qca8k_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
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
+int qca8k_port_bridge_join(struct dsa_switch *ds, int port,
+			   struct dsa_bridge bridge,
+			   bool *tx_fwd_offload,
+			   struct netlink_ext_ack *extack)
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
+		if (!dsa_port_offloads_bridge(dsa_to_port(ds, i), &bridge))
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
+void qca8k_port_bridge_leave(struct dsa_switch *ds, int port,
+			     struct dsa_bridge bridge)
+{
+	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
+	int cpu_port, i;
+
+	cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
+
+	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
+		if (dsa_is_cpu_port(ds, i))
+			continue;
+		if (!dsa_port_offloads_bridge(dsa_to_port(ds, i), &bridge))
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
+void qca8k_port_fast_age(struct dsa_switch *ds, int port)
+{
+	struct qca8k_priv *priv = ds->priv;
+
+	mutex_lock(&priv->reg_mutex);
+	qca8k_fdb_access(priv, QCA8K_FDB_FLUSH_PORT, port);
+	mutex_unlock(&priv->reg_mutex);
+}
+
+int qca8k_set_ageing_time(struct dsa_switch *ds, unsigned int msecs)
+{
+	struct qca8k_priv *priv = ds->priv;
+	unsigned int secs = msecs / 1000;
+	u32 val;
+
+	/* AGE_TIME reg is set in 7s step */
+	val = secs / 7;
+
+	/* Handle case with 0 as val to NOT disable
+	 * learning
+	 */
+	if (!val)
+		val = 1;
+
+	return regmap_update_bits(priv->regmap, QCA8K_REG_ATU_CTRL, QCA8K_ATU_AGE_TIME_MASK,
+				  QCA8K_ATU_AGE_TIME(val));
+}
+
+int qca8k_port_enable(struct dsa_switch *ds, int port,
+		      struct phy_device *phy)
+{
+	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
+
+	qca8k_port_set_status(priv, port, 1);
+	priv->port_enabled_map |= BIT(port);
+
+	if (dsa_is_user_port(ds, port))
+		phy_support_asym_pause(phy);
+
+	return 0;
+}
+
+void qca8k_port_disable(struct dsa_switch *ds, int port)
+{
+	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
+
+	qca8k_port_set_status(priv, port, 0);
+	priv->port_enabled_map &= ~BIT(port);
+}
+
+int qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
+{
+	struct qca8k_priv *priv = ds->priv;
+	int ret;
+
+	/* We have only have a general MTU setting.
+	 * DSA always set the CPU port's MTU to the largest MTU of the slave
+	 * ports.
+	 * Setting MTU just for the CPU port is sufficient to correctly set a
+	 * value for every port.
+	 */
+	if (!dsa_is_cpu_port(ds, port))
+		return 0;
+
+	/* To change the MAX_FRAME_SIZE the cpu ports must be off or
+	 * the switch panics.
+	 * Turn off both cpu ports before applying the new value to prevent
+	 * this.
+	 */
+	if (priv->port_enabled_map & BIT(0))
+		qca8k_port_set_status(priv, 0, 0);
+
+	if (priv->port_enabled_map & BIT(6))
+		qca8k_port_set_status(priv, 6, 0);
+
+	/* Include L2 header / FCS length */
+	ret = regmap_write(priv->regmap, QCA8K_MAX_FRAME_SIZE, new_mtu + ETH_HLEN + ETH_FCS_LEN);
+
+	if (priv->port_enabled_map & BIT(0))
+		qca8k_port_set_status(priv, 0, 1);
+
+	if (priv->port_enabled_map & BIT(6))
+		qca8k_port_set_status(priv, 6, 1);
+
+	return ret;
+}
+
+int qca8k_port_max_mtu(struct dsa_switch *ds, int port)
+{
+	return QCA8K_MAX_MTU;
+}
+
+int qca8k_port_fdb_insert(struct qca8k_priv *priv, const u8 *addr,
+			  u16 port_mask, u16 vid)
+{
+	/* Set the vid to the port vlan id if no vid is set */
+	if (!vid)
+		vid = QCA8K_PORT_VID_DEF;
+
+	return qca8k_fdb_add(priv, addr, port_mask, vid,
+			     QCA8K_ATU_STATUS_STATIC);
+}
+
+int qca8k_port_fdb_add(struct dsa_switch *ds, int port,
+		       const unsigned char *addr, u16 vid,
+		       struct dsa_db db)
+{
+	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
+	u16 port_mask = BIT(port);
+
+	return qca8k_port_fdb_insert(priv, addr, port_mask, vid);
+}
+
+int qca8k_port_fdb_del(struct dsa_switch *ds, int port,
+		       const unsigned char *addr, u16 vid,
+		       struct dsa_db db)
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
+int qca8k_port_fdb_dump(struct dsa_switch *ds, int port,
+			dsa_fdb_dump_cb_t *cb, void *data)
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
+int qca8k_port_mdb_add(struct dsa_switch *ds, int port,
+		       const struct switchdev_obj_port_mdb *mdb,
+		       struct dsa_db db)
+{
+	struct qca8k_priv *priv = ds->priv;
+	const u8 *addr = mdb->addr;
+	u16 vid = mdb->vid;
+
+	return qca8k_fdb_search_and_insert(priv, BIT(port), addr, vid);
+}
+
+int qca8k_port_mdb_del(struct dsa_switch *ds, int port,
+		       const struct switchdev_obj_port_mdb *mdb,
+		       struct dsa_db db)
+{
+	struct qca8k_priv *priv = ds->priv;
+	const u8 *addr = mdb->addr;
+	u16 vid = mdb->vid;
+
+	return qca8k_fdb_search_and_del(priv, BIT(port), addr, vid);
+}
+
+int qca8k_port_mirror_add(struct dsa_switch *ds, int port,
+			  struct dsa_mall_mirror_tc_entry *mirror,
+			  bool ingress, struct netlink_ext_ack *extack)
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
+void qca8k_port_mirror_del(struct dsa_switch *ds, int port,
+			   struct dsa_mall_mirror_tc_entry *mirror)
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
+int qca8k_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
+			      struct netlink_ext_ack *extack)
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
+int qca8k_port_vlan_add(struct dsa_switch *ds, int port,
+			const struct switchdev_obj_port_vlan *vlan,
+			struct netlink_ext_ack *extack)
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
+int qca8k_port_vlan_del(struct dsa_switch *ds, int port,
+			const struct switchdev_obj_port_vlan *vlan)
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
+static bool
+qca8k_lag_can_offload(struct dsa_switch *ds, struct dsa_lag lag,
+		      struct netdev_lag_upper_info *info)
+{
+	struct dsa_port *dp;
+	int members = 0;
+
+	if (!lag.id)
+		return false;
+
+	dsa_lag_foreach_port(dp, ds->dst, &lag)
+		/* Includes the port joining the LAG */
+		members++;
+
+	if (members > QCA8K_NUM_PORTS_FOR_LAG)
+		return false;
+
+	if (info->tx_type != NETDEV_LAG_TX_TYPE_HASH)
+		return false;
+
+	if (info->hash_type != NETDEV_LAG_HASH_L2 &&
+	    info->hash_type != NETDEV_LAG_HASH_L23)
+		return false;
+
+	return true;
+}
+
+static int
+qca8k_lag_setup_hash(struct dsa_switch *ds, struct dsa_lag lag,
+		     struct netdev_lag_upper_info *info)
+{
+	struct net_device *lag_dev = lag.dev;
+	struct qca8k_priv *priv = ds->priv;
+	bool unique_lag = true;
+	unsigned int i;
+	u32 hash = 0;
+
+	switch (info->hash_type) {
+	case NETDEV_LAG_HASH_L23:
+		hash |= QCA8K_TRUNK_HASH_SIP_EN;
+		hash |= QCA8K_TRUNK_HASH_DIP_EN;
+		fallthrough;
+	case NETDEV_LAG_HASH_L2:
+		hash |= QCA8K_TRUNK_HASH_SA_EN;
+		hash |= QCA8K_TRUNK_HASH_DA_EN;
+		break;
+	default: /* We should NEVER reach this */
+		return -EOPNOTSUPP;
+	}
+
+	/* Check if we are the unique configured LAG */
+	dsa_lags_foreach_id(i, ds->dst)
+		if (i != lag.id && dsa_lag_by_id(ds->dst, i)) {
+			unique_lag = false;
+			break;
+		}
+
+	/* Hash Mode is global. Make sure the same Hash Mode
+	 * is set to all the 4 possible lag.
+	 * If we are the unique LAG we can set whatever hash
+	 * mode we want.
+	 * To change hash mode it's needed to remove all LAG
+	 * and change the mode with the latest.
+	 */
+	if (unique_lag) {
+		priv->lag_hash_mode = hash;
+	} else if (priv->lag_hash_mode != hash) {
+		netdev_err(lag_dev, "Error: Mismatched Hash Mode across different lag is not supported\n");
+		return -EOPNOTSUPP;
+	}
+
+	return regmap_update_bits(priv->regmap, QCA8K_TRUNK_HASH_EN_CTRL,
+				  QCA8K_TRUNK_HASH_MASK, hash);
+}
+
+static int
+qca8k_lag_refresh_portmap(struct dsa_switch *ds, int port,
+			  struct dsa_lag lag, bool delete)
+{
+	struct qca8k_priv *priv = ds->priv;
+	int ret, id, i;
+	u32 val;
+
+	/* DSA LAG IDs are one-based, hardware is zero-based */
+	id = lag.id - 1;
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
+	for (i = 0; i < QCA8K_NUM_PORTS_FOR_LAG; i++) {
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
+		/* We have found the member to add/remove */
+		break;
+	}
+
+	/* Set port in the correct port mask or disable port if in delete mode */
+	return regmap_update_bits(priv->regmap, QCA8K_REG_GOL_TRUNK_CTRL(id),
+				  QCA8K_REG_GOL_TRUNK_ID_MEM_ID_EN(id, i) |
+				  QCA8K_REG_GOL_TRUNK_ID_MEM_ID_PORT(id, i),
+				  !delete << QCA8K_REG_GOL_TRUNK_ID_MEM_ID_SHIFT(id, i) |
+				  port << QCA8K_REG_GOL_TRUNK_ID_MEM_ID_SHIFT(id, i));
+}
+
+int qca8k_port_lag_join(struct dsa_switch *ds, int port, struct dsa_lag lag,
+			struct netdev_lag_upper_info *info)
+{
+	int ret;
+
+	if (!qca8k_lag_can_offload(ds, lag, info))
+		return -EOPNOTSUPP;
+
+	ret = qca8k_lag_setup_hash(ds, lag, info);
+	if (ret)
+		return ret;
+
+	return qca8k_lag_refresh_portmap(ds, port, lag, false);
+}
+
+int qca8k_port_lag_leave(struct dsa_switch *ds, int port,
+			 struct dsa_lag lag)
+{
+	return qca8k_lag_refresh_portmap(ds, port, lag, true);
+}
+
+int qca8k_read_switch_id(struct qca8k_priv *priv)
+{
+	const struct qca8k_match_data *data;
+	u32 val;
+	u8 id;
+	int ret;
+
+	/* get the switches ID from the compatible */
+	data = of_device_get_match_data(priv->dev);
+	if (!data)
+		return -ENODEV;
+
+	ret = regmap_read(priv->regmap, QCA8K_REG_MASK_CTRL, &val);
+	if (ret < 0)
+		return -ENODEV;
+
+	id = QCA8K_MASK_CTRL_DEVICE_ID(val);
+	if (id != data->id) {
+		dev_err(priv->dev, "Switch id detected %x but expected %x", id, data->id);
+		return -ENODEV;
+	}
+
+	priv->switch_id = id;
+
+	/* Save revision to communicate to the internal PHY driver */
+	priv->switch_revision = QCA8K_MASK_CTRL_REV_ID(val);
+
+	return 0;
+}
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index a306638a7100..96e726e65185 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -419,4 +419,62 @@ struct qca8k_fdb {
 	u8 mac[6];
 };
 
+/* Common setup function */
+extern const struct qca8k_mib_desc ar8327_mib[];
+extern const struct regmap_access_table qca8k_readable_table;
+
+int qca8k_read_switch_id(struct qca8k_priv *priv);
+int qca8k_mib_init(struct qca8k_priv *priv);
+void qca8k_fdb_flush(struct qca8k_priv *priv);
+void qca8k_port_set_status(struct qca8k_priv *priv, int port, int enable);
+
+/* Common ops function */
+void qca8k_get_strings(struct dsa_switch *ds, int port, u32 stringset, uint8_t *data);
+void qca8k_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *data);
+int qca8k_get_sset_count(struct dsa_switch *ds, int port, int sset);
+int qca8k_set_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *eee);
+int qca8k_get_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *e);
+void qca8k_port_stp_state_set(struct dsa_switch *ds, int port, u8 state);
+int qca8k_port_bridge_join(struct dsa_switch *ds, int port,
+			   struct dsa_bridge bridge,
+			   bool *tx_fwd_offload,
+			   struct netlink_ext_ack *extack);
+void qca8k_port_bridge_leave(struct dsa_switch *ds, int port,
+			     struct dsa_bridge bridge);
+void qca8k_port_fast_age(struct dsa_switch *ds, int port);
+int qca8k_set_ageing_time(struct dsa_switch *ds, unsigned int msecs);
+int qca8k_port_enable(struct dsa_switch *ds, int port, struct phy_device *phy);
+void qca8k_port_disable(struct dsa_switch *ds, int port);
+int qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu);
+int qca8k_port_max_mtu(struct dsa_switch *ds, int port);
+int qca8k_port_fdb_insert(struct qca8k_priv *priv, const u8 *addr, u16 port_mask, u16 vid);
+int qca8k_port_fdb_add(struct dsa_switch *ds, int port,
+		       const unsigned char *addr, u16 vid,
+		       struct dsa_db db);
+int qca8k_port_fdb_del(struct dsa_switch *ds, int port,
+		       const unsigned char *addr, u16 vid,
+		       struct dsa_db db);
+int qca8k_port_fdb_dump(struct dsa_switch *ds, int port, dsa_fdb_dump_cb_t *cb, void *data);
+int qca8k_port_mdb_add(struct dsa_switch *ds, int port,
+		       const struct switchdev_obj_port_mdb *mdb,
+		       struct dsa_db db);
+int qca8k_port_mdb_del(struct dsa_switch *ds, int port,
+		       const struct switchdev_obj_port_mdb *mdb,
+		       struct dsa_db db);
+int qca8k_port_mirror_add(struct dsa_switch *ds, int port,
+			  struct dsa_mall_mirror_tc_entry *mirror,
+			  bool ingress, struct netlink_ext_ack *extack);
+void qca8k_port_mirror_del(struct dsa_switch *ds, int port,
+			   struct dsa_mall_mirror_tc_entry *mirror);
+int qca8k_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
+			      struct netlink_ext_ack *extack);
+int qca8k_port_vlan_add(struct dsa_switch *ds, int port, const struct switchdev_obj_port_vlan *vlan,
+			struct netlink_ext_ack *extack);
+int qca8k_port_vlan_del(struct dsa_switch *ds, int port,
+			const struct switchdev_obj_port_vlan *vlan);
+int qca8k_port_lag_join(struct dsa_switch *ds, int port, struct dsa_lag lag,
+			struct netdev_lag_upper_info *info);
+int qca8k_port_lag_leave(struct dsa_switch *ds, int port,
+			 struct dsa_lag lag);
+
 #endif /* __QCA8K_H */
-- 
2.36.1

