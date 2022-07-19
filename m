Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1BF578FB6
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 03:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236633AbiGSBPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 21:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236545AbiGSBP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 21:15:27 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40714B4B5;
        Mon, 18 Jul 2022 18:15:16 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id z12so19465715wrq.7;
        Mon, 18 Jul 2022 18:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ts5M1FkSDKEV6z1+fbLMiaVQjjXAHsvTEpwlzSRqc9o=;
        b=njQ+iMmaDDOyJ4AnZxwp9839DpnrRkmeY87gB8PRRmKk1pqZNXu/UzDMNEfrc9hFAj
         6GypQmGqp7zDoiUzDVTxa7jM9bkWqk7Fpi/ATViTF3g1Piv7qVZBtPUIp4L/GP/8qLRZ
         T85Jy9lCFLaYlhc3sKRddkQarLXaHanJDDlvmwvE/HyK7rWDVYuPUPOZQztjofpYp9R5
         qN9Qu54Iw21QRcsussugrApryj1NHNOiTnKUrvhhb4s7mmgIODSBngKthB7r62kkDzFQ
         c0W6ocuyDFAF620L1rc/VVClSrDP9t0XYTmUkcuoT+bMelDPq223OSxcKGEi7zer09+v
         aQZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ts5M1FkSDKEV6z1+fbLMiaVQjjXAHsvTEpwlzSRqc9o=;
        b=YqlbJWJ1UfQC9SqdYU48OrgJ/ZUHIktViUODjba2mDBbhGY6H3wtUtqLmKqrVTkZ+n
         BrK0g4GBlCh0qzpjZs59X5tiotAAMQkayYRnntzAE0S04ER9khX4qTNsQ+M8WjZ7WDmF
         J81ZvNAMCngwMwIddjh3QeOnHgZm/nVbbr5+kgs68lrBc0CFhS8eu9vtU69D+3QCmxmB
         QA6T+9rEB38drnQLJuPEhYgNgsQ/2zZ3CISelMj7Qo2EPPwj9fcm1a167RUndk9WOVnC
         9sFEozZTUGIilStUWOo8J2vbzpWoQVyS/CRZVlykbssvTkAJqUOLeFOzZpK0D8BPH/IC
         PICA==
X-Gm-Message-State: AJIora92/HH23biQVKoagnwAgFEsI80OrEERtqXzbasGQFmUL3Gql97K
        N2AZlb0lhEL/HyljpH37RwE=
X-Google-Smtp-Source: AGRyM1uBxN6ueu25ugyU/Nm+xd2EziP+hnMxr8cknE7QtLc/sVPLCfYc8QJsDSHe00VhMea4oRu6Nw==
X-Received: by 2002:a05:6000:15c3:b0:21d:9f5a:df83 with SMTP id y3-20020a05600015c300b0021d9f5adf83mr25329703wry.360.1658193314211;
        Mon, 18 Jul 2022 18:15:14 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id y11-20020adff14b000000b0021db7b0162esm11840239wro.105.2022.07.18.18.15.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 18:15:13 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [net-next PATCH v2 05/15] net: dsa: qca8k: move fdb/vlan/mib init functions to common code
Date:   Tue, 19 Jul 2022 02:57:16 +0200
Message-Id: <20220719005726.8739-7-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220719005726.8739-1-ansuelsmth@gmail.com>
References: <20220719005726.8739-1-ansuelsmth@gmail.com>
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

The same fdb,vlan and mib function are used by drivers based on qca8k
family switch.
Move them to common code to make them accessible also by other drivers.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c   | 364 -----------------------------
 drivers/net/dsa/qca/qca8k-common.c | 361 ++++++++++++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h        |  15 ++
 3 files changed, 376 insertions(+), 364 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 3178ae023d2a..e17567a4b99f 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -441,370 +441,6 @@ static struct regmap_config qca8k_regmap_config = {
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
-	u32 reg[3];
-	int ret;
-
-	/* load the ARL table into an array */
-	ret = qca8k_bulk_read(priv, QCA8K_REG_ATU_DATA0, reg, sizeof(reg));
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
-	u32 reg[3] = { 0 };
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
-	qca8k_bulk_write(priv, QCA8K_REG_ATU_DATA0, reg, sizeof(reg));
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
-	ret = qca8k_write(priv, QCA8K_REG_ATU_FUNC, reg);
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
-		ret = qca8k_read(priv, QCA8K_REG_ATU_FUNC, &reg);
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
-	ret = qca8k_write(priv, QCA8K_REG_VTU_FUNC1, reg);
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
-		ret = qca8k_read(priv, QCA8K_REG_VTU_FUNC1, &reg);
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
-	ret = qca8k_read(priv, QCA8K_REG_VTU_FUNC0, &reg);
-	if (ret < 0)
-		goto out;
-	reg |= QCA8K_VTU_FUNC0_VALID | QCA8K_VTU_FUNC0_IVL_EN;
-	reg &= ~QCA8K_VTU_FUNC0_EG_MODE_PORT_MASK(port);
-	if (untagged)
-		reg |= QCA8K_VTU_FUNC0_EG_MODE_PORT_UNTAG(port);
-	else
-		reg |= QCA8K_VTU_FUNC0_EG_MODE_PORT_TAG(port);
-
-	ret = qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
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
-	ret = qca8k_read(priv, QCA8K_REG_VTU_FUNC0, &reg);
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
-		ret = qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
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
-	ret = qca8k_write(priv, QCA8K_REG_MODULE_EN, QCA8K_MODULE_EN_MIB);
-
-exit:
-	mutex_unlock(&priv->reg_mutex);
-	return ret;
-}
-
 static void
 qca8k_port_set_status(struct qca8k_priv *priv, int port, int enable)
 {
diff --git a/drivers/net/dsa/qca/qca8k-common.c b/drivers/net/dsa/qca/qca8k-common.c
index 91b3ad048392..926a66363cf8 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -146,3 +146,364 @@ int qca8k_bulk_write(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 
 	return 0;
 }
+
+static int qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
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
+	u32 reg[3];
+	int ret;
+
+	/* load the ARL table into an array */
+	ret = qca8k_bulk_read(priv, QCA8K_REG_ATU_DATA0, reg, sizeof(reg));
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
+void
+qca8k_fdb_write(struct qca8k_priv *priv, u16 vid, u8 port_mask, const u8 *mac,
+		u8 aging)
+{
+	u32 reg[3] = { 0 };
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
+	qca8k_bulk_write(priv, QCA8K_REG_ATU_DATA0, reg, sizeof(reg));
+}
+
+int
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
+	ret = qca8k_write(priv, QCA8K_REG_ATU_FUNC, reg);
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
+		ret = qca8k_read(priv, QCA8K_REG_ATU_FUNC, &reg);
+		if (ret < 0)
+			return ret;
+		if (reg & QCA8K_ATU_FUNC_FULL)
+			return -1;
+	}
+
+	return 0;
+}
+
+int
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
+int
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
+int
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
+int
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
+int
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
+	ret = qca8k_write(priv, QCA8K_REG_VTU_FUNC1, reg);
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
+		ret = qca8k_read(priv, QCA8K_REG_VTU_FUNC1, &reg);
+		if (ret < 0)
+			return ret;
+		if (reg & QCA8K_VTU_FUNC1_FULL)
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
+int
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
+	ret = qca8k_read(priv, QCA8K_REG_VTU_FUNC0, &reg);
+	if (ret < 0)
+		goto out;
+	reg |= QCA8K_VTU_FUNC0_VALID | QCA8K_VTU_FUNC0_IVL_EN;
+	reg &= ~QCA8K_VTU_FUNC0_EG_MODE_PORT_MASK(port);
+	if (untagged)
+		reg |= QCA8K_VTU_FUNC0_EG_MODE_PORT_UNTAG(port);
+	else
+		reg |= QCA8K_VTU_FUNC0_EG_MODE_PORT_TAG(port);
+
+	ret = qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
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
+int
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
+	ret = qca8k_read(priv, QCA8K_REG_VTU_FUNC0, &reg);
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
+		ret = qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
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
+	ret = qca8k_write(priv, QCA8K_REG_MODULE_EN, QCA8K_MODULE_EN_MIB);
+
+exit:
+	mutex_unlock(&priv->reg_mutex);
+	return ret;
+}
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index 78dbecc41a3d..f9493354d74f 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -425,6 +425,7 @@ struct qca8k_fdb {
 /* Common setup function */
 extern const struct qca8k_mib_desc ar8327_mib[];
 extern const struct regmap_access_table qca8k_readable_table;
+int qca8k_mib_init(struct qca8k_priv *priv);
 
 /* Common read/write/rmw function */
 int qca8k_read(struct qca8k_priv *priv, u32 reg, u32 *val);
@@ -434,4 +435,18 @@ int qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val);
 int qca8k_bulk_read(struct qca8k_priv *priv, u32 reg, u32 *val, int len);
 int qca8k_bulk_write(struct qca8k_priv *priv, u32 reg, u32 *val, int len);
 
+/* Common ops function */
+int qca8k_fdb_access(struct qca8k_priv *priv, enum qca8k_fdb_cmd cmd, int port);
+int qca8k_fdb_next(struct qca8k_priv *priv, struct qca8k_fdb *fdb, int port);
+int qca8k_fdb_add(struct qca8k_priv *priv, const u8 *mac, u16 port_mask,
+		  u16 vid, u8 aging);
+int qca8k_fdb_del(struct qca8k_priv *priv, const u8 *mac, u16 port_mask, u16 vid);
+void qca8k_fdb_flush(struct qca8k_priv *priv);
+int qca8k_fdb_search_and_insert(struct qca8k_priv *priv, u8 port_mask,
+				const u8 *mac, u16 vid);
+int qca8k_fdb_search_and_del(struct qca8k_priv *priv, u8 port_mask,
+			     const u8 *mac, u16 vid);
+int qca8k_vlan_add(struct qca8k_priv *priv, u8 port, u16 vid, bool untagged);
+int qca8k_vlan_del(struct qca8k_priv *priv, u8 port, u16 vid);
+
 #endif /* __QCA8K_H */
-- 
2.36.1

