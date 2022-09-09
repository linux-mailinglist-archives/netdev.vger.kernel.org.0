Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C98185B3247
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 10:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbiIIIv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 04:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231504AbiIIIvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 04:51:51 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C80C642E9
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 01:51:48 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id a8so1513419lff.13
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 01:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=l1jwyRrgWZk9ydwmIxs0l3qr3oYAbIS7S0+df2N8X0E=;
        b=gelITtSt4PjZ9Nj1lgX1NrDttSQD5Rqvo2dQChr2IvjlmOkgQEGzGnZTplA87uVbnq
         rW5Ic9FgLzCIK7zLAhzd/spyCk2CyFMQJPLE80aljP4qWZ7zyFyr8FQLL/3E6LLD9EsE
         I3Q31pdK9D8qM7cEaUzEGPkyVvr/vVet7/z4MOgDSy2fuDxODTFccdKzWb9P8xv2vjF+
         i2DctTDfsGCTbelev5/q+Ntf9H8Z3miJzgdavAcM0u4g+5R54Bv6PVxunacDiV7uYlop
         Fx0xDJ+7hlshptVO7byoGUrvCGtYDuRQ2Se5owz+8pvG/QqJc3ArVnSz5KjFo1UNewxK
         bMrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=l1jwyRrgWZk9ydwmIxs0l3qr3oYAbIS7S0+df2N8X0E=;
        b=7cCOen6Mq7wLY+B+XzPPKI93lcgKgPcqfBfPYzo6jxnD9+iAbjrf3DSeA1RWBdTBA4
         qB3UfW6vdAXsJu6PxajN/6qjUE5kjJYIoE/p63QoljCCs/0wDvyXjh12PK3Bg4gbAzRD
         Sx5CXZoj2kD2exwEvsxF0vsU3aYVkEKP3M4o8peHd3Ae/6gPwZG1vFEuUPV43faLR3pN
         KHBxkGPqp0ATFdcmBdB8yPW7NkH4kFNpkCZtEDw0olW+sxo4MmJxFnMwFXw6Fe9qwOKz
         u6hPVJDuAYMD2c7mamzLzmLix8ON2zYuIHdcfsyNoZOOLI//mCXNttOUkkK3PrkyCI+J
         T8NA==
X-Gm-Message-State: ACgBeo0ly/WhTGLAX3/yIcslb9biRgPpzwtn9Rmry7FHrYUndqjEFiq2
        URPZ0viYn7mIpiXFdZ15Xum4o5/MQJik6WYf
X-Google-Smtp-Source: AA6agR6PKwToIgAY6mVXEMmbsFDQkzNH+6wQDur6wq88XVALyj7/k27RjoE8GsUR5ldHPWpACOvIYw==
X-Received: by 2002:a05:6512:3e18:b0:498:fd18:8e12 with SMTP id i24-20020a0565123e1800b00498fd188e12mr381376lfv.249.1662713506283;
        Fri, 09 Sep 2022 01:51:46 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id q17-20020a05651c055100b00262fae1ffe6sm193956ljp.110.2022.09.09.01.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 01:51:45 -0700 (PDT)
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: [PATCH net-next v8 5/6] net: dsa: mv88e6xxx: rmon: Use RMU for reading RMON data
Date:   Fri,  9 Sep 2022 10:51:37 +0200
Message-Id: <20220909085138.3539952-6-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220909085138.3539952-1-mattias.forsblad@gmail.com>
References: <20220909085138.3539952-1-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the Remote Management Unit for efficiently accessing
the RMON data.

Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 36 ++++++++++++++----
 drivers/net/dsa/mv88e6xxx/chip.h |  4 ++
 drivers/net/dsa/mv88e6xxx/rmu.c  | 63 ++++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/smi.c  |  3 ++
 4 files changed, 98 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index bbdf229c9e71..bd16afa2e1a5 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1234,16 +1234,30 @@ static int mv88e6xxx_stats_get_stats(struct mv88e6xxx_chip *chip, int port,
 				     u16 bank1_select, u16 histogram)
 {
 	struct mv88e6xxx_hw_stat *stat;
+	int offset = 0;
+	u64 high;
 	int i, j;
 
 	for (i = 0, j = 0; i < ARRAY_SIZE(mv88e6xxx_hw_stats); i++) {
 		stat = &mv88e6xxx_hw_stats[i];
 		if (stat->type & types) {
-			mv88e6xxx_reg_lock(chip);
-			data[j] = _mv88e6xxx_get_ethtool_stat(chip, stat, port,
-							      bank1_select,
-							      histogram);
-			mv88e6xxx_reg_unlock(chip);
+			if (mv88e6xxx_rmu_available(chip) &&
+			    !(stat->type & STATS_TYPE_PORT)) {
+				if (stat->type & STATS_TYPE_BANK1)
+					offset = 32;
+
+				data[j] = chip->ports[port].rmu_raw_stats[stat->reg + offset];
+				if (stat->size == 8) {
+					high = chip->ports[port].rmu_raw_stats[stat->reg + offset
+							+ 1];
+					data[j] += (high << 32);
+				}
+			} else {
+				mv88e6xxx_reg_lock(chip);
+				data[j] = _mv88e6xxx_get_ethtool_stat(chip, stat, port,
+								      bank1_select, histogram);
+				mv88e6xxx_reg_unlock(chip);
+			}
 
 			j++;
 		}
@@ -1312,10 +1326,9 @@ static void mv88e6xxx_get_stats(struct mv88e6xxx_chip *chip, int port,
 	mv88e6xxx_reg_unlock(chip);
 }
 
-static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
-					uint64_t *data)
+void mv88e6xxx_get_ethtool_stats_mdio(struct mv88e6xxx_chip *chip, int port,
+				      uint64_t *data)
 {
-	struct mv88e6xxx_chip *chip = ds->priv;
 	int ret;
 
 	mv88e6xxx_reg_lock(chip);
@@ -1327,7 +1340,14 @@ static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
 		return;
 
 	mv88e6xxx_get_stats(chip, port, data);
+}
+
+static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
+					uint64_t *data)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
 
+	chip->smi_ops->get_rmon(chip, port, data);
 }
 
 static int mv88e6xxx_get_regs_len(struct dsa_switch *ds, int port)
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 566d18cf5170..5459037067e6 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -266,6 +266,7 @@ struct mv88e6xxx_vlan {
 struct mv88e6xxx_port {
 	struct mv88e6xxx_chip *chip;
 	int port;
+	u64 rmu_raw_stats[64];
 	struct mv88e6xxx_vlan bridge_pvid;
 	u64 serdes_stats[2];
 	u64 atu_member_violation;
@@ -431,6 +432,7 @@ struct mv88e6xxx_bus_ops {
 	int (*read)(struct mv88e6xxx_chip *chip, int addr, int reg, u16 *val);
 	int (*write)(struct mv88e6xxx_chip *chip, int addr, int reg, u16 val);
 	int (*init)(struct mv88e6xxx_chip *chip);
+	void (*get_rmon)(struct mv88e6xxx_chip *chip, int port, uint64_t *data);
 };
 
 struct mv88e6xxx_mdio_bus {
@@ -807,6 +809,8 @@ int mv88e6xxx_wait_mask(struct mv88e6xxx_chip *chip, int addr, int reg,
 int mv88e6xxx_wait_bit(struct mv88e6xxx_chip *chip, int addr, int reg,
 		       int bit, int val);
 struct mii_bus *mv88e6xxx_default_mdio_bus(struct mv88e6xxx_chip *chip);
+void mv88e6xxx_get_ethtool_stats_mdio(struct mv88e6xxx_chip *chip, int port,
+				      uint64_t *data);
 
 static inline void mv88e6xxx_reg_lock(struct mv88e6xxx_chip *chip)
 {
diff --git a/drivers/net/dsa/mv88e6xxx/rmu.c b/drivers/net/dsa/mv88e6xxx/rmu.c
index 20a91629e72b..2f10844dc61e 100644
--- a/drivers/net/dsa/mv88e6xxx/rmu.c
+++ b/drivers/net/dsa/mv88e6xxx/rmu.c
@@ -138,6 +138,62 @@ static int mv88e6xxx_rmu_get_id(struct mv88e6xxx_chip *chip, int port)
 	return 0;
 }
 
+static void mv88e6xxx_rmu_stats_get(struct mv88e6xxx_chip *chip, int port, uint64_t *data)
+{
+	u16 req[4] = { MV88E6XXX_RMU_REQ_FORMAT_SOHO,
+		       MV88E6XXX_RMU_REQ_PAD,
+		       MV88E6XXX_RMU_REQ_CODE_DUMP_MIB,
+		       MV88E6XXX_RMU_REQ_DATA};
+	struct dump_mib_resp resp;
+	struct mv88e6xxx_port *p;
+	u8 resp_port;
+	int resp_len;
+	u16 format;
+	u16 code;
+	int ret;
+	int i;
+
+	/* Populate port number in request */
+	req[3] = FIELD_PREP(MV88E6XXX_RMU_REQ_DUMP_MIB_PORT_MASK, port);
+
+	resp_len = sizeof(resp);
+	ret = mv88e6xxx_rmu_send_wait(chip, port, req, sizeof(req),
+				      &resp, &resp_len);
+	if (ret) {
+		dev_dbg(chip->dev, "RMU: error for command DUMP_MIB %pe port %d\n",
+			ERR_PTR(ret), port);
+		return;
+	}
+
+	/* Got response */
+	format = get_unaligned_be16(&resp.rmu_header.format);
+	code = get_unaligned_be16(&resp.rmu_header.code);
+
+	if (format != MV88E6XXX_RMU_RESP_FORMAT_1 &&
+	    format != MV88E6XXX_RMU_RESP_FORMAT_2 &&
+	    code != MV88E6XXX_RMU_RESP_CODE_DUMP_MIB) {
+		net_dbg_ratelimited("RMU: received unknown format 0x%04x code 0x%04x",
+				    format, code);
+		return;
+	}
+
+	resp_port = FIELD_GET(MV88E6XXX_SOURCE_PORT, resp.portnum);
+	p = &chip->ports[resp_port];
+	if (!p) {
+		dev_err_ratelimited(chip->dev, "RMU: illegal port number in response: %d\n",
+				    resp_port);
+		return;
+	}
+
+	/* Copy array for further processing according to chip type */
+	for (i = 0; i < resp_len - offsetof(struct dump_mib_resp, mib); i++)
+		p->rmu_raw_stats[i] = get_unaligned_be32(&resp.mib[i]);
+
+	/* Update MIB for port */
+	if (chip->info->ops->stats_get_stats)
+		chip->info->ops->stats_get_stats(chip, port, data);
+}
+
 static void mv88e6xxx_disable_rmu(struct mv88e6xxx_chip *chip)
 {
 	chip->smi_ops = chip->rmu.smi_ops;
@@ -263,6 +319,13 @@ int mv88e6xxx_rmu_setup(struct mv88e6xxx_chip *chip)
 {
 	mutex_init(&chip->rmu.mutex);
 
+	/* Remember original ops for restore */
+	chip->rmu.smi_ops = chip->smi_ops;
+
+	/* Change rmu ops with our own pointer */
+	chip->rmu.rmu_ops = (struct mv88e6xxx_bus_ops *)chip->rmu.smi_ops;
+	chip->rmu.rmu_ops->get_rmon = mv88e6xxx_rmu_stats_get;
+
 	if (chip->info->ops->rmu_disable)
 		return chip->info->ops->rmu_disable(chip);
 
diff --git a/drivers/net/dsa/mv88e6xxx/smi.c b/drivers/net/dsa/mv88e6xxx/smi.c
index a990271b7482..ae805c449b85 100644
--- a/drivers/net/dsa/mv88e6xxx/smi.c
+++ b/drivers/net/dsa/mv88e6xxx/smi.c
@@ -83,6 +83,7 @@ static int mv88e6xxx_smi_direct_wait(struct mv88e6xxx_chip *chip,
 static const struct mv88e6xxx_bus_ops mv88e6xxx_smi_direct_ops = {
 	.read = mv88e6xxx_smi_direct_read,
 	.write = mv88e6xxx_smi_direct_write,
+	.get_rmon = mv88e6xxx_get_ethtool_stats_mdio,
 };
 
 static int mv88e6xxx_smi_dual_direct_read(struct mv88e6xxx_chip *chip,
@@ -100,6 +101,7 @@ static int mv88e6xxx_smi_dual_direct_write(struct mv88e6xxx_chip *chip,
 static const struct mv88e6xxx_bus_ops mv88e6xxx_smi_dual_direct_ops = {
 	.read = mv88e6xxx_smi_dual_direct_read,
 	.write = mv88e6xxx_smi_dual_direct_write,
+	.get_rmon = mv88e6xxx_get_ethtool_stats_mdio,
 };
 
 /* Offset 0x00: SMI Command Register
@@ -166,6 +168,7 @@ static const struct mv88e6xxx_bus_ops mv88e6xxx_smi_indirect_ops = {
 	.read = mv88e6xxx_smi_indirect_read,
 	.write = mv88e6xxx_smi_indirect_write,
 	.init = mv88e6xxx_smi_indirect_init,
+	.get_rmon = mv88e6xxx_get_ethtool_stats_mdio,
 };
 
 int mv88e6xxx_smi_init(struct mv88e6xxx_chip *chip,
-- 
2.25.1

