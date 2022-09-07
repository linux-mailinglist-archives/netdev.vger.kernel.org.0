Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3925AFD8D
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 09:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbiIGHam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 03:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiIGHaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 03:30:06 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66036422CC
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 00:29:59 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id x14so5691957lfu.10
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 00:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=2skxFPKZXsrGd9NHOewlH/FnXhPb2+y0U3rsrmy5otI=;
        b=M1g8u8VUBVbtyPiE1bMVX/RIQDXN4+p01A9yRua2y36WDttsbQ9aVc4Mizh2fGG5Cj
         BPUKo940KAp19QCPvNK8evHgHXQj+6gVUXdgncE55A02DW79H3gxljTmQVI5HqD24aWZ
         iqk7Ru+OMjvNTVm4mzWE01XlknED/0EhOiJ//ZJKvcag+y663xe5ezyocB/tFNjdpPAx
         CmEpByY8Ry6Hi+RfY3hyBvPZUuCHU/nY7pl6uh4N9waqJMPiYvsi0OY7qcHyJ8XOH2fO
         19kPBzUWvz/9dQgj03XVebhp2Pr1XcFuUPA+3yKt+PlrkpYqC5uKWbmro2qU6/4lX3m9
         u0Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=2skxFPKZXsrGd9NHOewlH/FnXhPb2+y0U3rsrmy5otI=;
        b=tMOZ9p+gYBXGwujS8pRM/uh6YGJC+9cLjykYoMabcCid8e50BucQ9kVG7gC1pXJknh
         1RSw4m6zW0Bc8PHpKioXvZ2p15qNrWNBMT8qZcTvFSI9wet/1eBRhECOyFAWgkMP9ziH
         dpB6b/oyH8Cb/BMCu6YmcQQ+oj4Vdj1wYQHi7dbhtiZb6XgZDCymtSSWyoSmpm+n4FHT
         FZsEZwMk3kfFwybhrTzeLOwL2XuicYQTi9uFCdod4E8KztaJfenc3ERhoGxU8QP3v/6u
         zXcX2aHU0xPbw86pPXxeKa1ohYlx2UBpLr3bXKq2N+vkWSrGZmz3h/WwRwM2RMaaD8AO
         ANlQ==
X-Gm-Message-State: ACgBeo1s1zx3ezO3FGUv3jeAJwqB1jFNsFFSQ2SmRSNUG1F5undZ0asf
        7BXRJm/2oyHsVd8f3jBgZd7bkCuNCf6lGf2T
X-Google-Smtp-Source: AA6agR4Rr7P3mRnZTOYfC5mhzC20Wd7G3IOUxeoxUyCt8tFOHy0InFIhekU6jG1JBKB0EO66iaLAYw==
X-Received: by 2002:a05:6512:13a4:b0:477:a28a:2280 with SMTP id p36-20020a05651213a400b00477a28a2280mr615206lfa.689.1662535797407;
        Wed, 07 Sep 2022 00:29:57 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id w3-20020ac25983000000b0048a83336343sm2275507lfn.252.2022.09.07.00.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 00:29:57 -0700 (PDT)
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
Subject: [PATCH net-next v5 4/6] net: dsa: mv88e6xxxx: Add RMU functionality.
Date:   Wed,  7 Sep 2022 09:29:48 +0200
Message-Id: <20220907072950.2329571-5-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220907072950.2329571-1-mattias.forsblad@gmail.com>
References: <20220907072950.2329571-1-mattias.forsblad@gmail.com>
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
 drivers/net/dsa/mv88e6xxx/rmu.c    | 309 +++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/rmu.h    |  28 +++
 5 files changed, 376 insertions(+), 8 deletions(-)
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
index 000000000000..9b36c437ae31
--- /dev/null
+++ b/drivers/net/dsa/mv88e6xxx/rmu.c
@@ -0,0 +1,309 @@
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
+			if (!chip->info->ops->rmu_enable(chip, port)) {
+				dev_dbg(chip->dev, "RMU: Enabled on port %d", port);
+				chip->rmu.master_netdev = (struct net_device *)master;
+			} else {
+				dev_err(chip->dev, "RMU: Unable to enable on port %d", port);
+			}
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

