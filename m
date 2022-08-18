Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E97B359817B
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 12:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243824AbiHRK36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 06:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240270AbiHRK3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 06:29:50 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4CE06F572
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 03:29:47 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id v10so1281973ljh.9
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 03:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=kjVDYfx8q5Z156CEAHNw/QbqEtB2Dlc84vppNPIQgX0=;
        b=YU4zU+e66+RxKrXxU2MeqjHDPHtO3KySf44ocOPE3yNuTGtlmVXi9OQ+JV6bjo+qDn
         9p5xsCsUZnigtAlIi1YcgcwZYvFB0+zjdlukeQ6mHS6wU20TNHU+yf8F0itCRmYW463v
         A3Xx/Y26+9GvU8K52fRt/GfuzuxsNuTJx3LtRgV9rK6YD41qsClHz8sidVX6RujD+IfK
         C4BK2yirK+u0HFj26sNBfhU5UqjoCmnwVEt6t5pJKWhc94/ZFV1cYrH+llRai0EIvDeJ
         /6fmfnMavui+du3lODi93WmAOUc3jDG6y5Jcox1KmwAcJ9lAh52yjBlpRyQphEPzuK25
         hcQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=kjVDYfx8q5Z156CEAHNw/QbqEtB2Dlc84vppNPIQgX0=;
        b=EpLl7hobBGhGzihvoLtDxKAJHH0JYphESrF/W7UrjAnRqYoIhBGZ8++8wpxg+kvMf5
         XABjoHAEaagKHHl218O3QOK86I0vdl3Br51uyxPMDUu8bor5Qm9eAdcXwiKNzVtEhYNn
         s8rVUKTEm4JUAY3jY0P3IOgvndDnMWOmuHtOFYItFxj9AGwZ+wONNLjPGmoP65qCQdSH
         1YPFQAssVsQTkC7z4XtdMeuTQEWgAQl6NZ2Zzfnv7lgvRc9kRMpjd1FLmcbaUqmJVbrX
         xerFxyKTYrTEEoBF8Rhn17PYIHz/iOucP5EAXcblbVa33Cx0PWXOkZhdALihX19cK2xR
         JxgQ==
X-Gm-Message-State: ACgBeo27hf5Us2PCQ4OtoN+VSWPy7l2/4fWQO4zOPqA5qteMg0+F8TCU
        tOt1EUApubDfAwdSC/VAXAzQ8falyiq/lQ==
X-Google-Smtp-Source: AA6agR43vOO8vMc3rNt+fjcnkzD7LH+5QL7JTeRB/s7XOFJKavR5Xdfg9vCIIlX3+35fMTP0LzOCWg==
X-Received: by 2002:a2e:80d5:0:b0:25e:6a71:bf27 with SMTP id r21-20020a2e80d5000000b0025e6a71bf27mr687269ljg.472.1660818585654;
        Thu, 18 Aug 2022 03:29:45 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id z10-20020a056512370a00b0048afa5daaf3sm171035lfr.123.2022.08.18.03.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 03:29:45 -0700 (PDT)
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
Subject: [RFC net-next PATCH 2/3] mv88e6xxx: Implement remote management support (RMU)
Date:   Thu, 18 Aug 2022 12:29:23 +0200
Message-Id: <20220818102924.287719-3-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220818102924.287719-1-mattias.forsblad@gmail.com>
References: <20220818102924.287719-1-mattias.forsblad@gmail.com>
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

Implement support for handling RMU layer 3 frames
including receive and transmit.

Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/Makefile  |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c    |  19 ++-
 drivers/net/dsa/mv88e6xxx/chip.h    |  20 +++
 drivers/net/dsa/mv88e6xxx/global1.c |  84 +++++++++
 drivers/net/dsa/mv88e6xxx/global1.h |   3 +
 drivers/net/dsa/mv88e6xxx/rmu.c     | 256 ++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/rmu.h     |  18 ++
 7 files changed, 399 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/rmu.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/rmu.h

diff --git a/drivers/net/dsa/mv88e6xxx/Makefile b/drivers/net/dsa/mv88e6xxx/Makefile
index c8eca2b6f959..105d7bd832c9 100644
--- a/drivers/net/dsa/mv88e6xxx/Makefile
+++ b/drivers/net/dsa/mv88e6xxx/Makefile
@@ -15,3 +15,4 @@ mv88e6xxx-objs += port_hidden.o
 mv88e6xxx-$(CONFIG_NET_DSA_MV88E6XXX_PTP) += ptp.o
 mv88e6xxx-objs += serdes.o
 mv88e6xxx-objs += smi.o
+mv88e6xxx-objs += rmu.o
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 07e9a4da924c..888c6e47dd16 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -42,6 +42,7 @@
 #include "ptp.h"
 #include "serdes.h"
 #include "smi.h"
+#include "rmu.h"
 
 static void assert_reg_lock(struct mv88e6xxx_chip *chip)
 {
@@ -1529,10 +1530,17 @@ static int mv88e6xxx_trunk_setup(struct mv88e6xxx_chip *chip)
 
 static int mv88e6xxx_rmu_setup(struct mv88e6xxx_chip *chip)
 {
+	int ret = 0;
+
 	if (chip->info->ops->rmu_disable)
-		return chip->info->ops->rmu_disable(chip);
+		ret = chip->info->ops->rmu_disable(chip);
 
-	return 0;
+	if (chip->info->ops->rmu_enable) {
+		ret += chip->info->ops->rmu_enable(chip);
+		ret += mv88e6xxx_rmu_init(chip);
+	}
+
+	return ret;
 }
 
 static int mv88e6xxx_pot_setup(struct mv88e6xxx_chip *chip)
@@ -4090,6 +4098,7 @@ static const struct mv88e6xxx_ops mv88e6085_ops = {
 	.ppu_disable = mv88e6185_g1_ppu_disable,
 	.reset = mv88e6185_g1_reset,
 	.rmu_disable = mv88e6085_g1_rmu_disable,
+	.rmu_enable = mv88e6085_g1_rmu_enable,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.stu_getnext = mv88e6352_g1_stu_getnext,
@@ -4173,6 +4182,7 @@ static const struct mv88e6xxx_ops mv88e6097_ops = {
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6085_g1_rmu_disable,
+	.rmu_enable = mv88e6085_g1_rmu_enable,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.phylink_get_caps = mv88e6095_phylink_get_caps,
@@ -5292,6 +5302,7 @@ static const struct mv88e6xxx_ops mv88e6352_ops = {
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6352_g1_rmu_disable,
+	.rmu_enable = mv88e6352_g1_rmu_enable,
 	.atu_get_hash = mv88e6165_g1_atu_get_hash,
 	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
@@ -5359,6 +5370,7 @@ static const struct mv88e6xxx_ops mv88e6390_ops = {
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
+	.rmu_enable = mv88e6390_g1_rmu_enable,
 	.atu_get_hash = mv88e6165_g1_atu_get_hash,
 	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
@@ -5426,6 +5438,7 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
+	.rmu_enable = mv88e6390_g1_rmu_enable,
 	.atu_get_hash = mv88e6165_g1_atu_get_hash,
 	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
@@ -5496,6 +5509,7 @@ static const struct mv88e6xxx_ops mv88e6393x_ops = {
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
+	.rmu_enable = mv88e6390_g1_rmu_enable,
 	.atu_get_hash = mv88e6165_g1_atu_get_hash,
 	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
@@ -6918,6 +6932,7 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.crosschip_lag_change	= mv88e6xxx_crosschip_lag_change,
 	.crosschip_lag_join	= mv88e6xxx_crosschip_lag_join,
 	.crosschip_lag_leave	= mv88e6xxx_crosschip_lag_leave,
+	.inband_receive         = mv88e6xxx_inband_rcv,
 };
 
 static int mv88e6xxx_register_switch(struct mv88e6xxx_chip *chip)
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index e693154cf803..024f45cc1476 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -33,6 +33,8 @@
 
 #define MV88E6XXX_MAX_GPIO	16
 
+#define MV88E6XXX_WAIT_POLL_TIME_MS		200
+
 enum mv88e6xxx_egress_mode {
 	MV88E6XXX_EGRESS_MODE_UNMODIFIED,
 	MV88E6XXX_EGRESS_MODE_UNTAGGED,
@@ -266,6 +268,7 @@ struct mv88e6xxx_vlan {
 struct mv88e6xxx_port {
 	struct mv88e6xxx_chip *chip;
 	int port;
+	u64 rmu_raw_stats[64];
 	struct mv88e6xxx_vlan bridge_pvid;
 	u64 serdes_stats[2];
 	u64 atu_member_violation;
@@ -282,6 +285,18 @@ struct mv88e6xxx_port {
 	struct devlink_region *region;
 };
 
+struct mv88e6xxx_rmu {
+	/* RMU resources */
+	struct net_device *netdev;
+	struct mv88e6xxx_bus_ops *ops;
+	struct completion completion;
+	/* Mutex for RMU operations */
+	struct mutex mutex;
+	u16 got_id;
+	u8 request_cmd;
+	u8 seq_no;
+};
+
 enum mv88e6xxx_region_id {
 	MV88E6XXX_REGION_GLOBAL1 = 0,
 	MV88E6XXX_REGION_GLOBAL2,
@@ -410,12 +425,16 @@ struct mv88e6xxx_chip {
 
 	/* Bridge MST to SID mappings */
 	struct list_head msts;
+
+	/* RMU resources */
+	struct mv88e6xxx_rmu rmu;
 };
 
 struct mv88e6xxx_bus_ops {
 	int (*read)(struct mv88e6xxx_chip *chip, int addr, int reg, u16 *val);
 	int (*write)(struct mv88e6xxx_chip *chip, int addr, int reg, u16 val);
 	int (*init)(struct mv88e6xxx_chip *chip);
+	int (*get_rmon)(struct mv88e6xxx_chip *chip, int port, uint64_t *data);
 };
 
 struct mv88e6xxx_mdio_bus {
@@ -637,6 +656,7 @@ struct mv88e6xxx_ops {
 
 	/* Remote Management Unit operations */
 	int (*rmu_disable)(struct mv88e6xxx_chip *chip);
+	int (*rmu_enable)(struct mv88e6xxx_chip *chip);
 
 	/* Precision Time Protocol operations */
 	const struct mv88e6xxx_ptp_ops *ptp_ops;
diff --git a/drivers/net/dsa/mv88e6xxx/global1.c b/drivers/net/dsa/mv88e6xxx/global1.c
index 5848112036b0..ba756d918e13 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.c
+++ b/drivers/net/dsa/mv88e6xxx/global1.c
@@ -466,18 +466,102 @@ int mv88e6085_g1_rmu_disable(struct mv88e6xxx_chip *chip)
 				      MV88E6085_G1_CTL2_RM_ENABLE, 0);
 }
 
+int mv88e6085_g1_rmu_enable(struct mv88e6xxx_chip *chip)
+{
+	int val = MV88E6352_G1_CTL2_RMU_MODE_DISABLED;
+	int upstream_port = -1;
+
+	upstream_port = dsa_switch_upstream_port(chip->ds);
+	dev_err(chip->dev, "RMU: Enabling on port %d", upstream_port);
+	if (upstream_port < 0)
+		return -1;
+
+	switch (upstream_port) {
+	case 9:
+		val = MV88E6085_G1_CTL2_RM_ENABLE;
+		break;
+	case 10:
+		val = MV88E6085_G1_CTL2_RM_ENABLE | MV88E6085_G1_CTL2_P10RM;
+		break;
+	default:
+		break;
+	}
+
+	return mv88e6xxx_g1_ctl2_mask(chip, MV88E6085_G1_CTL2_P10RM |
+				      MV88E6085_G1_CTL2_RM_ENABLE, val);
+}
+
 int mv88e6352_g1_rmu_disable(struct mv88e6xxx_chip *chip)
 {
 	return mv88e6xxx_g1_ctl2_mask(chip, MV88E6352_G1_CTL2_RMU_MODE_MASK,
 				      MV88E6352_G1_CTL2_RMU_MODE_DISABLED);
 }
 
+int mv88e6352_g1_rmu_enable(struct mv88e6xxx_chip *chip)
+{
+	int val = MV88E6352_G1_CTL2_RMU_MODE_DISABLED;
+	int upstream_port;
+
+	upstream_port = dsa_switch_upstream_port(chip->ds);
+	dev_err(chip->dev, "RMU: Enabling on port %d", upstream_port);
+	if (upstream_port < 0)
+		return -1;
+
+	switch (upstream_port) {
+	case 4:
+		val = MV88E6352_G1_CTL2_RMU_MODE_PORT_4;
+		break;
+	case 5:
+		val = MV88E6352_G1_CTL2_RMU_MODE_PORT_5;
+		break;
+	case 6:
+		val = MV88E6352_G1_CTL2_RMU_MODE_PORT_6;
+		break;
+	default:
+		break;
+	}
+
+	return mv88e6xxx_g1_ctl2_mask(chip, MV88E6352_G1_CTL2_RMU_MODE_MASK,
+			val);
+}
+
 int mv88e6390_g1_rmu_disable(struct mv88e6xxx_chip *chip)
 {
 	return mv88e6xxx_g1_ctl2_mask(chip, MV88E6390_G1_CTL2_RMU_MODE_MASK,
 				      MV88E6390_G1_CTL2_RMU_MODE_DISABLED);
 }
 
+int mv88e6390_g1_rmu_enable(struct mv88e6xxx_chip *chip)
+{
+	int val = MV88E6390_G1_CTL2_RMU_MODE_DISABLED;
+	int upstream_port;
+
+	upstream_port = dsa_switch_upstream_port(chip->ds);
+	dev_err(chip->dev, "RMU: Enabling on port %d", upstream_port);
+	if (upstream_port < 0)
+		return -1;
+
+	switch (upstream_port) {
+	case 0:
+		val = MV88E6390_G1_CTL2_RMU_MODE_PORT_0;
+		break;
+	case 1:
+		val = MV88E6390_G1_CTL2_RMU_MODE_PORT_1;
+		break;
+	case 9:
+		val = MV88E6390_G1_CTL2_RMU_MODE_PORT_9;
+		break;
+	case 10:
+		val = MV88E6390_G1_CTL2_RMU_MODE_PORT_10;
+		break;
+	default:
+		break;
+	}
+
+	return mv88e6xxx_g1_ctl2_mask(chip, MV88E6390_G1_CTL2_RMU_MODE_MASK,
+			val);
+}
+
 int mv88e6390_g1_stats_set_histogram(struct mv88e6xxx_chip *chip)
 {
 	return mv88e6xxx_g1_ctl2_mask(chip, MV88E6390_G1_CTL2_HIST_MODE_MASK,
diff --git a/drivers/net/dsa/mv88e6xxx/global1.h b/drivers/net/dsa/mv88e6xxx/global1.h
index 65958b2a0d3a..7e786503734a 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.h
+++ b/drivers/net/dsa/mv88e6xxx/global1.h
@@ -313,8 +313,11 @@ int mv88e6250_g1_ieee_pri_map(struct mv88e6xxx_chip *chip);
 int mv88e6185_g1_set_cascade_port(struct mv88e6xxx_chip *chip, int port);
 
 int mv88e6085_g1_rmu_disable(struct mv88e6xxx_chip *chip);
+int mv88e6085_g1_rmu_enable(struct mv88e6xxx_chip *chip);
 int mv88e6352_g1_rmu_disable(struct mv88e6xxx_chip *chip);
+int mv88e6352_g1_rmu_enable(struct mv88e6xxx_chip *chip);
 int mv88e6390_g1_rmu_disable(struct mv88e6xxx_chip *chip);
+int mv88e6390_g1_rmu_enable(struct mv88e6xxx_chip *chip);
 
 int mv88e6xxx_g1_set_device_number(struct mv88e6xxx_chip *chip, int index);
 
diff --git a/drivers/net/dsa/mv88e6xxx/rmu.c b/drivers/net/dsa/mv88e6xxx/rmu.c
new file mode 100644
index 000000000000..ac68eef12521
--- /dev/null
+++ b/drivers/net/dsa/mv88e6xxx/rmu.c
@@ -0,0 +1,256 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Marvell 88E6xxx Switch Remote Management Unit Support
+ *
+ * Copyright (c) 2022 Mattias Forsblad <mattias.forsblad@gmail.com>
+ *
+ */
+
+#include "rmu.h"
+#include "global1.h"
+
+#define MAX_RMON 64
+#define RMON_REPLY 2
+
+#define RMU_REQ_GET_ID                 1
+#define RMU_REQ_DUMP_MIB               2
+
+#define RMU_RESP_FORMAT_1              0x0001
+#define RMU_RESP_FORMAT_2              0x0002
+
+#define RMU_RESP_CODE_GOT_ID           0x0000
+#define RMU_RESP_CODE_DUMP_MIB         0x1020
+
+int mv88e6xxx_inband_rcv(struct dsa_switch *ds, struct sk_buff *skb, int seq_no)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	struct mv88e6xxx_port *port;
+	__be16 *prodnum;
+	__be16 *format;
+	__be16 *code;
+	__be32 *mib_data;
+	u8 pkt_dev;
+	u8 pkt_prt;
+	int i;
+
+	if (!skb || !chip)
+		return 0;
+
+	/* Extract response data */
+	format = (__be16 *)&skb->data[0];
+	if (*format != htons(RMU_RESP_FORMAT_1) && (*format != htons(RMU_RESP_FORMAT_2))) {
+		dev_err(chip->dev, "RMU: received unknown format 0x%04x", *format);
+		goto out;
+	}
+
+	code = (__be16 *)&skb->data[4];
+	if (*code == ntohs(0xffff)) {
+		netdev_err(skb->dev, "RMU: error response code 0x%04x", *code);
+		goto out;
+	}
+
+	pkt_dev = skb->data[6] & 0x1f;
+	if (pkt_dev >= DSA_MAX_SWITCHES) {
+		netdev_err(skb->dev, "RMU: response from unknown chip %d\n", *code);
+		goto out;
+	}
+
+	/* Check sequence number */
+	if (seq_no != chip->rmu.seq_no) {
+		netdev_err(skb->dev, "RMU: wrong seqno received %d, expected %d",
+			   seq_no, chip->rmu.seq_no);
+		goto out;
+	}
+
+	/* Check response code */
+	switch (chip->rmu.request_cmd) {
+	case RMU_REQ_GET_ID: {
+		if (*code == RMU_RESP_CODE_GOT_ID) {
+			prodnum = (__be16 *)&skb->data[2];
+			chip->rmu.got_id = *prodnum;
+			dev_info(chip->dev, "RMU: received id OK with product number: 0x%04x\n",
+				 chip->rmu.got_id);
+		} else {
+			dev_err(chip->dev,
+				"RMU: unknown response for GET_ID format 0x%04x code 0x%04x",
+				*format, *code);
+		}
+		break;
+	}
+	case RMU_REQ_DUMP_MIB:
+		if (*code == RMU_RESP_CODE_DUMP_MIB) {
+			pkt_prt = (skb->data[7] & 0x78) >> 3;
+			mib_data = (__be32 *)&skb->data[12];
+			port = &chip->ports[pkt_prt];
+			if (!port) {
+				dev_err(chip->dev, "RMU: illegal port number in response: %d\n",
+					pkt_prt);
+				goto out;
+			}
+
+			/* Copy whole array for further
+			 * processing according to chip type
+			 */
+			for (i = 0; i < MAX_RMON; i++)
+				port->rmu_raw_stats[i] = mib_data[i];
+		}
+		break;
+	default:
+		dev_err(chip->dev,
+			"RMU: unknown response format 0x%04x and code 0x%04x from chip %d\n",
+			*format, *code, chip->ds->index);
+		break;
+	}
+
+out:
+	complete(&chip->rmu.completion);
+
+	return 0;
+}
+
+static int mv88e6xxx_rmu_tx(struct mv88e6xxx_chip *chip, int port,
+			    const char *msg, int len)
+{
+	const struct dsa_device_ops *tag_ops;
+	const struct dsa_port *dp;
+	unsigned char *data;
+	struct sk_buff *skb;
+
+	dp = dsa_to_port(chip->ds, port);
+	if (!dp || !dp->cpu_dp)
+		return 0;
+
+	tag_ops = dp->cpu_dp->tag_ops;
+	if (!tag_ops)
+		return -ENODEV;
+
+	skb = netdev_alloc_skb(chip->rmu.netdev, 64);
+	if (!skb)
+		return -ENOMEM;
+
+	skb_reserve(skb, 2 * ETH_HLEN + tag_ops->needed_headroom);
+	skb_reset_network_header(skb);
+	skb->pkt_type = PACKET_OUTGOING;
+	skb->dev = chip->rmu.netdev;
+
+	/* Create RMU L3 message */
+	data = skb_put(skb, len);
+	memcpy(data, msg, len);
+
+	return tag_ops->inband_xmit(skb, dp->slave, ++chip->rmu.seq_no);
+}
+
+static int mv88e6xxx_rmu_send_wait(struct mv88e6xxx_chip *chip, int port,
+				   int request, const char *msg, int len)
+{
+	const struct dsa_port *dp;
+	struct net_device *master;
+	int ret = 0;
+
+	dp = dsa_to_port(chip->ds, port);
+	if (!dp)
+		return 0;
+
+	master = dp->master;
+
+	mutex_lock(&chip->rmu.mutex);
+
+	chip->rmu.request_cmd = request;
+
+	ret = mv88e6xxx_rmu_tx(chip, port, msg, len);
+	if (ret == -ENODEV) {
+		/* Device not ready yet? Try again later */
+		ret = 0;
+		goto out;
+	}
+
+	if (ret) {
+		dev_err(chip->dev, "RMU: error transmitting request (%d)", ret);
+		goto out;
+	}
+
+	ret = wait_for_completion_timeout(&chip->rmu.completion,
+					  msecs_to_jiffies(MV88E6XXX_WAIT_POLL_TIME_MS));
+	if (ret == 0) {
+		dev_err(chip->dev,
+			"RMU: timeout waiting for request %d (%d) on dev:port %d:%d\n",
+			request, ret, chip->ds->index, port);
+		ret = -ETIMEDOUT;
+	}
+
+out:
+	mutex_unlock(&chip->rmu.mutex);
+
+	return ret > 0 ? 0 : ret;
+}
+
+static int mv88e6xxx_rmu_get_id(struct mv88e6xxx_chip *chip, int port)
+{
+	const u8 get_id[8] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
+	int ret = -1;
+
+	if (chip->rmu.got_id)
+		return 0;
+
+	chip->rmu.netdev = dev_get_by_name(&init_net, "chan0");
+	if (!chip->rmu.netdev) {
+		dev_err(chip->dev, "RMU: unable to get interface");
+		return -ENODEV;
+	}
+
+	ret = mv88e6xxx_rmu_send_wait(chip, port, RMU_REQ_GET_ID, get_id, 8);
+	if (ret) {
+		dev_err(chip->dev, "RMU: error for command GET_ID %d index %d\n", ret,
+			chip->ds->index);
+		return ret;
+	}
+
+	return 0;
+}
+
+int mv88e6xxx_rmu_stats_get(struct mv88e6xxx_chip *chip, int port, uint64_t *data)
+{
+	u8 dump_mib[8] = { 0x00, 0x01, 0x00, 0x00, 0x10, 0x20, 0x00, 0x00 };
+	int ret;
+
+	if (!chip)
+		return 0;
+
+	ret = mv88e6xxx_rmu_get_id(chip, port);
+	if (ret)
+		return ret;
+
+	/* Send a GET_MIB command */
+	dump_mib[7] = port;
+	ret = mv88e6xxx_rmu_send_wait(chip, port, RMU_REQ_DUMP_MIB, dump_mib, 8);
+	if (ret) {
+		dev_err(chip->dev, "RMU: error for command DUMP_MIB %d dev %d:%d\n", ret,
+			chip->ds->index, port);
+		return ret;
+	}
+
+	/* Update MIB for port */
+	if (chip->info->ops->stats_get_stats)
+		return chip->info->ops->stats_get_stats(chip, port, data);
+
+	return 0;
+}
+
+static struct mv88e6xxx_bus_ops mv88e6xxx_bus_ops = {
+	.get_rmon = mv88e6xxx_rmu_stats_get,
+};
+
+int mv88e6xxx_rmu_init(struct mv88e6xxx_chip *chip)
+{
+	int ret = 0;
+
+	dev_info(chip->dev, "RMU: setting up for switch@%d", chip->sw_addr);
+
+	init_completion(&chip->rmu.completion);
+
+	mutex_init(&chip->rmu.mutex);
+
+	chip->rmu.ops = &mv88e6xxx_bus_ops;
+
+	return ret;
+}
diff --git a/drivers/net/dsa/mv88e6xxx/rmu.h b/drivers/net/dsa/mv88e6xxx/rmu.h
new file mode 100644
index 000000000000..3f74e952cad9
--- /dev/null
+++ b/drivers/net/dsa/mv88e6xxx/rmu.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * Marvell 88E6xxx Switch Remote Management Unit Support
+ *
+ * Copyright (c) 2022 Mattias Forsblad <mattias.forsblad@gmail.com>
+ *
+ */
+
+#ifndef _MV88E6XXX_RMU_H_
+#define _MV88E6XXX_RMU_H_
+
+#include "chip.h"
+
+int mv88e6xxx_rmu_init(struct mv88e6xxx_chip *chip);
+
+int mv88e6xxx_inband_rcv(struct dsa_switch *ds, struct sk_buff *skb, int seq_no);
+
+#endif /* _MV88E6XXX_RMU_H_ */
-- 
2.25.1

