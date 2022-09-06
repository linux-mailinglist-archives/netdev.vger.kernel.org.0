Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 569435ADFE3
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 08:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238488AbiIFGf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 02:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238482AbiIFGfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 02:35:06 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31A01BE9C
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 23:34:59 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id k10so1261299lfm.4
        for <netdev@vger.kernel.org>; Mon, 05 Sep 2022 23:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=xR7jk1cxL6HyoHnT4jNrOqfLdMBTEzlczB/SC3YG1nU=;
        b=T/CLQ9UGhbpMmGadwuZwxVWqNdPyBX2ADpGPZpyR0yVzcJ2MHNqpNChOc0y+S/RtE7
         jmQTV08rVlVoqNt0e5iPFJQA7+oohekrvuDWfE/7G+B67KVBDCGBp1/8GY/rQF6pluhR
         W0tWivNFPUJKnEUKnpxtw0JNsS3sXmau+qVZ7cqRZdgxJ98oZnKVhblOgdwBS7FrwVN2
         tIwo0eB69yxJkUSZffN+bZryoum8sgW5JHT4qXXBuPTp7DZEj7qc/A92Aqzr94zxbv+w
         Mwlid6A5W+rkQFdf0inNGxif2uib++lneXqimfUgIh6DkGwmyq8VQMJ4ZQPOqamqdnzs
         tt8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=xR7jk1cxL6HyoHnT4jNrOqfLdMBTEzlczB/SC3YG1nU=;
        b=7sxcZeyRW4fgOgm446bpMoYcQgGoPHx5bOnMRDEqfjhgOpy6girZtPIxg8ZfQxtcNo
         xbvVrhhxkLGTWYm/xUTOoAKP1N4u0FnN9NhXgIk1GZYYR3YSjAY0Mns3BirmXLRikv24
         tRDWS9sDgQugnDlKGKXLhVias84XdNhSvGkYcyvOxZ1P2el/5wMqi8YkDzifJ50UqEoT
         qTZlWV4cx/qfO5YH6oJF56mT6SO+SppJ1TqF516TdQ1EX5EVWI1qoXIMmDocTfCfrznH
         BquQTbt51LgcqhfTKPdouz16vWakJKAcA8qHbro7tWx3IZn0pELf8ejihkLY3BLKKlF3
         HFUQ==
X-Gm-Message-State: ACgBeo2FEvsSTZm2421ly5K6luenEltOjllupNRZnGOfT3q3CuA1xAYe
        8z3neLengGkvjD2qpTXcushnjCILBxC2wAYF
X-Google-Smtp-Source: AA6agR5XJ0+LyezXrNS4V2sWXgIQ2PCTi+WjweVTIEzK+dVZVekqAFYKrR6eaMC/kB4tvKm0bNVIaQ==
X-Received: by 2002:a05:6512:3404:b0:48c:e32d:c9a0 with SMTP id i4-20020a056512340400b0048ce32dc9a0mr18108720lfr.212.1662446097548;
        Mon, 05 Sep 2022 23:34:57 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id z12-20020a2e8e8c000000b00261bf4e9f90sm1646924ljk.66.2022.09.05.23.34.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 23:34:57 -0700 (PDT)
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
Subject: [PATCH net-next v4 4/6] net: dsa: mv88e6xxxx: Add RMU functionality.
Date:   Tue,  6 Sep 2022 08:34:48 +0200
Message-Id: <20220906063450.3698671-5-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220906063450.3698671-1-mattias.forsblad@gmail.com>
References: <20220906063450.3698671-1-mattias.forsblad@gmail.com>
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

The Marvell SOHO switches supports a secondary control
channel for accessing data in the switch. Special crafted
ethernet frames can access functions in the switch.
These frames is handled by the Remote Management Unit (RMU)
in the switch. Accessing data structures is specially
efficient and lessens the access contention on the MDIO
bus.

Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/Makefile |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c   |  28 ++-
 drivers/net/dsa/mv88e6xxx/chip.h   |  18 ++
 drivers/net/dsa/mv88e6xxx/rmu.c    | 307 +++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/rmu.h    |  28 +++
 5 files changed, 374 insertions(+), 8 deletions(-)
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
index 46e12b53a9e4..bbdf229c9e71 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -42,6 +42,7 @@
 #include "ptp.h"
 #include "serdes.h"
 #include "smi.h"
+#include "rmu.h"
 
 static void assert_reg_lock(struct mv88e6xxx_chip *chip)
 {
@@ -1535,14 +1536,6 @@ static int mv88e6xxx_trunk_setup(struct mv88e6xxx_chip *chip)
 	return 0;
 }
 
-static int mv88e6xxx_rmu_setup(struct mv88e6xxx_chip *chip)
-{
-	if (chip->info->ops->rmu_disable)
-		return chip->info->ops->rmu_disable(chip);
-
-	return 0;
-}
-
 static int mv88e6xxx_pot_setup(struct mv88e6xxx_chip *chip)
 {
 	if (chip->info->ops->pot_clear)
@@ -6867,6 +6860,23 @@ static int mv88e6xxx_crosschip_lag_leave(struct dsa_switch *ds, int sw_index,
 	return err_sync ? : err_pvt;
 }
 
+static int mv88e6xxx_connect_tag_protocol(struct dsa_switch *ds,
+					  enum dsa_tag_protocol proto)
+{
+	struct dsa_tagger_data *tagger_data = ds->tagger_data;
+
+	switch (proto) {
+	case DSA_TAG_PROTO_DSA:
+	case DSA_TAG_PROTO_EDSA:
+		tagger_data->decode_frame2reg = mv88e6xxx_decode_frame2reg_handler;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.get_tag_protocol	= mv88e6xxx_get_tag_protocol,
 	.change_tag_protocol	= mv88e6xxx_change_tag_protocol,
@@ -6932,6 +6942,8 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.crosschip_lag_change	= mv88e6xxx_crosschip_lag_change,
 	.crosschip_lag_join	= mv88e6xxx_crosschip_lag_join,
 	.crosschip_lag_leave	= mv88e6xxx_crosschip_lag_leave,
+	.master_state_change	= mv88e6xxx_master_change,
+	.connect_tag_protocol	= mv88e6xxx_connect_tag_protocol,
 };
 
 static int mv88e6xxx_register_switch(struct mv88e6xxx_chip *chip)
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 7ce3c41f6caf..e81935a9573d 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -282,6 +282,17 @@ struct mv88e6xxx_port {
 	struct devlink_region *region;
 };
 
+struct mv88e6xxx_rmu {
+	/* RMU resources */
+	struct net_device *master_netdev;
+	const struct mv88e6xxx_bus_ops *ops;
+	/* Mutex for RMU operations */
+	struct mutex mutex;
+	u16 got_id;
+	u8 request_cmd;
+	int inband_seqno;
+};
+
 enum mv88e6xxx_region_id {
 	MV88E6XXX_REGION_GLOBAL1 = 0,
 	MV88E6XXX_REGION_GLOBAL2,
@@ -410,6 +421,9 @@ struct mv88e6xxx_chip {
 
 	/* Bridge MST to SID mappings */
 	struct list_head msts;
+
+	/* RMU resources */
+	struct mv88e6xxx_rmu rmu;
 };
 
 struct mv88e6xxx_bus_ops {
@@ -805,4 +819,8 @@ static inline void mv88e6xxx_reg_unlock(struct mv88e6xxx_chip *chip)
 
 int mv88e6xxx_fid_map(struct mv88e6xxx_chip *chip, unsigned long *bitmap);
 
+static inline bool mv88e6xxx_rmu_available(struct mv88e6xxx_chip *chip)
+{
+	return chip->rmu.master_netdev ? 1 : 0;
+}
 #endif /* _MV88E6XXX_CHIP_H */
diff --git a/drivers/net/dsa/mv88e6xxx/rmu.c b/drivers/net/dsa/mv88e6xxx/rmu.c
new file mode 100644
index 000000000000..2109e4557467
--- /dev/null
+++ b/drivers/net/dsa/mv88e6xxx/rmu.c
@@ -0,0 +1,307 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Marvell 88E6xxx Switch Remote Management Unit Support
+ *
+ * Copyright (c) 2022 Mattias Forsblad <mattias.forsblad@gmail.com>
+ *
+ */
+
+#include <asm/unaligned.h>
+#include "rmu.h"
+#include "global1.h"
+
+#define MV88E6XXX_DSA_HLEN	4
+
+static const u8 rmu_dest_addr[ETH_ALEN] = { 0x01, 0x50, 0x43, 0x00, 0x00, 0x00 };
+
+#define MV88E6XXX_RMU_L2_BYTE1_RESV_VAL		0x3e
+#define MV88E6XXX_RMU				1
+#define MV88E6XXX_RMU_PRIO			6
+#define MV88E6XXX_RMU_RESV2			0xf
+
+#define MV88E6XXX_SOURCE_PORT			GENMASK(6, 3)
+#define MV88E6XXX_SOURCE_DEV			GENMASK(5, 0)
+#define MV88E6XXX_CPU_CODE_MASK			GENMASK(7, 6)
+#define MV88E6XXX_TRG_DEV_MASK			GENMASK(4, 0)
+#define MV88E6XXX_RMU_CODE_MASK			GENMASK(1, 1)
+#define MV88E6XXX_RMU_PRIO_MASK			GENMASK(7, 5)
+#define MV88E6XXX_RMU_L2_BYTE1_RESV		GENMASK(7, 2)
+#define MV88E6XXX_RMU_L2_BYTE2_RESV		GENMASK(3, 0)
+
+#define MV88E6XXX_RMU_RESP_FORMAT_1		0x0001
+#define MV88E6XXX_RMU_RESP_FORMAT_2		0x0002
+#define MV88E6XXX_RMU_RESP_ERROR		0xffff
+
+#define MV88E6XXX_RMU_RESP_CODE_GOT_ID		0x0000
+#define MV88E6XXX_RMU_RESP_CODE_DUMP_MIB	0x1020
+
+static void mv88e6xxx_rmu_create_l2(struct sk_buff *skb, struct dsa_port *dp)
+{
+	struct mv88e6xxx_chip *chip = dp->ds->priv;
+	struct ethhdr *eth;
+	u8 *edsa_header;
+	u8 *dsa_header;
+	u8 extra = 0;
+
+	if (chip->tag_protocol == DSA_TAG_PROTO_EDSA)
+		extra = 4;
+
+	/* Create RMU L2 header */
+	dsa_header = skb_push(skb, 6);
+	dsa_header[0] = FIELD_PREP(MV88E6XXX_CPU_CODE_MASK, MV88E6XXX_RMU);
+	dsa_header[0] |= FIELD_PREP(MV88E6XXX_TRG_DEV_MASK, dp->ds->index);
+	dsa_header[1] = FIELD_PREP(MV88E6XXX_RMU_CODE_MASK, 1);
+	dsa_header[1] |= FIELD_PREP(MV88E6XXX_RMU_L2_BYTE1_RESV, MV88E6XXX_RMU_L2_BYTE1_RESV_VAL);
+	dsa_header[2] = FIELD_PREP(MV88E6XXX_RMU_PRIO_MASK, MV88E6XXX_RMU_PRIO);
+	dsa_header[2] |= MV88E6XXX_RMU_L2_BYTE2_RESV;
+	dsa_header[3] = ++chip->rmu.inband_seqno;
+	dsa_header[4] = 0;
+	dsa_header[5] = 0;
+
+	/* Insert RMU MAC destination address /w extra if needed */
+	skb_push(skb, ETH_ALEN * 2 + extra);
+	eth = (struct ethhdr *)skb->data;
+	memcpy(eth->h_dest, rmu_dest_addr, ETH_ALEN);
+	memcpy(eth->h_source, chip->rmu.master_netdev->dev_addr, ETH_ALEN);
+
+	if (extra) {
+		edsa_header = (u8 *)&eth->h_proto;
+		edsa_header[0] = (ETH_P_EDSA >> 8) & 0xff;
+		edsa_header[1] = ETH_P_EDSA & 0xff;
+		edsa_header[2] = 0x00;
+		edsa_header[3] = 0x00;
+	}
+}
+
+static int mv88e6xxx_rmu_send_wait(struct mv88e6xxx_chip *chip, int port,
+				   int request, const char *msg, int len)
+{
+	struct dsa_port *dp;
+	struct sk_buff *skb;
+	unsigned char *data;
+	int ret = 0;
+
+	dp = dsa_to_port(chip->ds, port);
+	if (!dp)
+		return 0;
+
+	skb = netdev_alloc_skb(chip->rmu.master_netdev, 64);
+	if (!skb)
+		return -ENOMEM;
+
+	/* Take height for an eventual EDSA header */
+	skb_reserve(skb, 2 * ETH_HLEN + 4);
+	skb_reset_network_header(skb);
+
+	/* Insert RMU L3 message */
+	data = skb_put(skb, len);
+	memcpy(data, msg, len);
+
+	mv88e6xxx_rmu_create_l2(skb, dp);
+
+	mutex_lock(&chip->rmu.mutex);
+
+	chip->rmu.request_cmd = request;
+
+	ret = dsa_switch_inband_tx(dp->ds, skb, NULL, MV88E6XXX_RMU_WAIT_TIME_MS);
+	if (ret < 0) {
+		dev_err(chip->dev,
+			"RMU: timeout waiting for request %d (%pe) on port %d\n",
+			request, ERR_PTR(ret), port);
+	}
+
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
+	ret = mv88e6xxx_rmu_send_wait(chip, port, MV88E6XXX_RMU_REQ_GET_ID, get_id, 8);
+	if (ret) {
+		dev_dbg(chip->dev, "RMU: error for command GET_ID %pe\n", ERR_PTR(ret));
+		return ret;
+	}
+
+	return 0;
+}
+
+static int mv88e6xxx_rmu_stats_get(struct mv88e6xxx_chip *chip, int port, uint64_t *data)
+{
+	u8 dump_mib[8] = { 0x00, 0x01, 0x00, 0x00, 0x10, 0x20, 0x00, 0x00 };
+	int ret;
+
+	ret = mv88e6xxx_rmu_get_id(chip, port);
+	if (ret)
+		return ret;
+
+	/* Send a GET_MIB command */
+	dump_mib[7] = port;
+	ret = mv88e6xxx_rmu_send_wait(chip, port, MV88E6XXX_RMU_REQ_DUMP_MIB, dump_mib, 8);
+	if (ret) {
+		dev_dbg(chip->dev, "RMU: error for command DUMP_MIB %pe port %d\n",
+			ERR_PTR(ret), port);
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
+void mv88e6xxx_master_change(struct dsa_switch *ds, const struct net_device *master,
+			     bool operational)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	struct dsa_port *cpu_dp;
+	int port;
+
+	cpu_dp = master->dsa_ptr;
+	port = dsa_towards_port(ds, cpu_dp->ds->index, cpu_dp->index);
+
+	mv88e6xxx_reg_lock(chip);
+
+	if (operational) {
+		if (chip->info->ops->rmu_enable) {
+			if (!chip->info->ops->rmu_enable(chip, port))
+				chip->rmu.master_netdev = (struct net_device *)master;
+			else
+				dev_err(chip->dev, "RMU: Unable to enable on port %d", port);
+		}
+
+	} else {
+		chip->rmu.master_netdev = NULL;
+		if (chip->info->ops->rmu_disable)
+			chip->info->ops->rmu_disable(chip);
+	}
+
+	mv88e6xxx_reg_unlock(chip);
+}
+
+static void mv88e6xxx_prod_id_handler(struct dsa_switch *ds, struct sk_buff *skb)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	u16 prodnum;
+
+	prodnum = get_unaligned_be16(&skb->data[2]);
+	chip->rmu.got_id = prodnum;
+	dev_dbg_ratelimited(chip->dev, "RMU: received id OK with product number: 0x%04x\n",
+			    chip->rmu.got_id);
+}
+
+static void mv88e6xxx_mib_handler(struct dsa_switch *ds, struct sk_buff *skb)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	struct mv88e6xxx_port *p;
+	u8 port;
+	int i;
+
+	port = FIELD_GET(MV88E6XXX_SOURCE_PORT, skb->data[7]);
+	p = &chip->ports[port];
+	if (!p) {
+		dev_err_ratelimited(chip->dev, "RMU: illegal port number in response: %d\n", port);
+		return;
+	}
+
+	/* Copy whole array for further
+	 * processing according to chip type
+	 */
+	for (i = 0; i < MV88E6XXX_RMU_MAX_RMON; i++)
+		p->rmu_raw_stats[i] = get_unaligned_be32(&skb->data[12 + i * 4]);
+}
+
+static int mv88e6xxx_validate_mac(struct dsa_switch *ds, struct sk_buff *skb)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	unsigned char *ethhdr;
+
+	/* Check matching MAC */
+	ethhdr = skb_mac_header(skb);
+	if (!ether_addr_equal(chip->rmu.master_netdev->dev_addr, ethhdr)) {
+		dev_dbg_ratelimited(ds->dev, "RMU: mismatching MAC address for request. Rx %pM expecting %pM\n",
+				    ethhdr, chip->rmu.master_netdev->dev_addr);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+void mv88e6xxx_decode_frame2reg_handler(struct net_device *dev, struct sk_buff *skb)
+{
+	struct dsa_port *dp = dev->dsa_ptr;
+	struct dsa_switch *ds = dp->ds;
+	struct mv88e6xxx_chip *chip;
+	int source_device;
+	u8 *dsa_header;
+	u16 format;
+	u16 code;
+	u8 seqno;
+
+	if (mv88e6xxx_validate_mac(ds, skb))
+		return;
+
+	/* Decode Frame2Reg DSA portion */
+	dsa_header = skb->data - 2;
+
+	source_device = FIELD_GET(MV88E6XXX_SOURCE_DEV, dsa_header[0]);
+	ds = dsa_switch_find(ds->dst->index, source_device);
+	if (!ds) {
+		net_dbg_ratelimited("RMU: Didn't find switch with index %d", source_device);
+		return;
+	}
+
+	chip = ds->priv;
+	seqno = dsa_header[3];
+	if (seqno != chip->rmu.inband_seqno) {
+		net_dbg_ratelimited("RMU: wrong seqno received. Was %d, expected %d",
+				    seqno, chip->rmu.inband_seqno);
+		return;
+	}
+
+	/* Pull DSA L2 data */
+	skb_pull(skb, MV88E6XXX_DSA_HLEN);
+
+	format = get_unaligned_be16(&skb->data[0]);
+	if (format != MV88E6XXX_RMU_RESP_FORMAT_1 &&
+	    format != MV88E6XXX_RMU_RESP_FORMAT_2) {
+		net_dbg_ratelimited("RMU: received unknown format 0x%04x", format);
+		return;
+	}
+
+	code = get_unaligned_be16(&skb->data[4]);
+	if (code == MV88E6XXX_RMU_RESP_ERROR) {
+		net_dbg_ratelimited("RMU: error response code 0x%04x", code);
+		return;
+	}
+
+	if (code == MV88E6XXX_RMU_RESP_CODE_GOT_ID)
+		mv88e6xxx_prod_id_handler(ds, skb);
+	else if (code == MV88E6XXX_RMU_RESP_CODE_DUMP_MIB)
+		mv88e6xxx_mib_handler(ds, skb);
+
+	dsa_switch_inband_complete(ds, NULL);
+}
+
+static const struct mv88e6xxx_bus_ops mv88e6xxx_bus_ops = {
+	.get_rmon = mv88e6xxx_rmu_stats_get,
+};
+
+int mv88e6xxx_rmu_setup(struct mv88e6xxx_chip *chip)
+{
+	mutex_init(&chip->rmu.mutex);
+
+	chip->rmu.ops = &mv88e6xxx_bus_ops;
+
+	if (chip->info->ops->rmu_disable)
+		return chip->info->ops->rmu_disable(chip);
+
+	return 0;
+}
diff --git a/drivers/net/dsa/mv88e6xxx/rmu.h b/drivers/net/dsa/mv88e6xxx/rmu.h
new file mode 100644
index 000000000000..cf84b7005331
--- /dev/null
+++ b/drivers/net/dsa/mv88e6xxx/rmu.h
@@ -0,0 +1,28 @@
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
+#define MV88E6XXX_RMU_MAX_RMON			64
+
+#define MV88E6XXX_RMU_REQ_GET_ID		1
+#define MV88E6XXX_RMU_REQ_DUMP_MIB		2
+
+#define MV88E6XXX_RMU_WAIT_TIME_MS		20
+
+int mv88e6xxx_rmu_setup(struct mv88e6xxx_chip *chip);
+
+void mv88e6xxx_master_change(struct dsa_switch *ds, const struct net_device *master,
+			     bool operational);
+
+void mv88e6xxx_decode_frame2reg_handler(struct net_device *dev, struct sk_buff *skb);
+
+#endif /* _MV88E6XXX_RMU_H_ */
-- 
2.25.1

