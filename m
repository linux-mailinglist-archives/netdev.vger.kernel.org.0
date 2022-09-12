Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C88895B594E
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 13:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbiILL3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 07:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiILL3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 07:29:07 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52602286F0
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 04:29:05 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id k10so14315967lfm.4
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 04:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=Hl1tqSEry8C/sJXQSPa2ORcCv57fhKeGneXEw89e0Ho=;
        b=M6TnHRgpJy7shOaAZIKoJgbsndD4qCiz4eXxrQ01lec9mHEazGrASEpmUE/jQtDr+L
         anvKBkVtmgRFWMadiqW/Z31DZ84+5yHf+yVhZHvoUC6N18Y+BUZ7YA3nATQlum4QoaAl
         A5QKvQ1ft6LwTKg/agvzNN+sXNAihAtmxC4/FMYbrR9qwBuKvspYP6fP5j9+WVyIhRH9
         /sPKWpb+0opA+pRJElo5zo9phGbmN7gicvVDYqf2a0/M11O2NbIsP1hnSE/6For2JwcM
         GrM103ccXQ/v+Gw8d/oaT9EwemUfOgtD63Ev6wOOS+1wNgZ5W5UnxaVwKoVAj04BJ+oT
         U6UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Hl1tqSEry8C/sJXQSPa2ORcCv57fhKeGneXEw89e0Ho=;
        b=XpJEuEBuqH2Xr4UoUJxI5ykg2pvitOfpnctarWTBzKna3C1xqQROEHPunwosgRvUpA
         Uldx1Edbbi89DJNrTY01wls5gPWNxqMKtP4v85rhk4658MqgTaFw/qEbdSu+YIvtklfP
         RfAmk9gmxYY4CjvNKeJabcukxznKm2Al/EER/LloH0JdYFUUZ03aU/jFE+t+oeRWeyGi
         DcIvFX3ezgj+b7JZlLBA/VYO5RjFvzFPkFuCGgZHTz5iTzjT7v7WbdN18pozMMHIG50x
         PEbUeAzvdA/ch8VZdhtSOEIsDuJRDYmKMYg1RzIpIqQMa/zAPah46UzPzjNzDQ7bnlkR
         YBFw==
X-Gm-Message-State: ACgBeo0BuMaxNDxp8ClMzlDVOGD6KX+0fi7V8ELYZCx8shznKfBtXdvK
        +MZVm0HNf8YM4NYswRHC+fKJOCDsHUJA3aH/
X-Google-Smtp-Source: AA6agR4NqRv9eyY7plQhIbJAv86Tv0DIUPgXg2vESJBSJ9hGXjhHwi6nykw2eIy/uV5u+qpRnWHMAQ==
X-Received: by 2002:a05:6512:3f85:b0:492:c17e:d566 with SMTP id x5-20020a0565123f8500b00492c17ed566mr8175052lfa.341.1662982143291;
        Mon, 12 Sep 2022 04:29:03 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id i14-20020a2e808e000000b0026acf2ae007sm1043269ljg.89.2022.09.12.04.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 04:29:02 -0700 (PDT)
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
Subject: [PATCH net-next v9 4/6] net: dsa: mv88e6xxxx: Add RMU functionality.
Date:   Mon, 12 Sep 2022 13:28:53 +0200
Message-Id: <20220912112855.339804-5-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220912112855.339804-1-mattias.forsblad@gmail.com>
References: <20220912112855.339804-1-mattias.forsblad@gmail.com>
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
 drivers/net/dsa/mv88e6xxx/chip.h   |  20 ++
 drivers/net/dsa/mv88e6xxx/rmu.c    | 309 +++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/rmu.h    |  75 +++++++
 5 files changed, 425 insertions(+), 8 deletions(-)
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
index 46e12b53a9e4..294bf9bbaf3f 100644
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
+		return -EPROTONOSUPPORT;
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
+	.master_state_change	= mv88e6xxx_master_state_change,
+	.connect_tag_protocol	= mv88e6xxx_connect_tag_protocol,
 };
 
 static int mv88e6xxx_register_switch(struct mv88e6xxx_chip *chip)
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 7ce3c41f6caf..fbbee8b997cd 100644
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
@@ -282,6 +283,18 @@ struct mv88e6xxx_port {
 	struct devlink_region *region;
 };
 
+struct mv88e6xxx_rmu {
+	/* RMU resources */
+	struct net_device *master_netdev;
+	const struct mv88e6xxx_bus_ops *smi_ops;
+	struct mv88e6xxx_bus_ops *rmu_ops;
+	/* Mutex for RMU operations */
+	struct mutex mutex;
+	u16 prodnr;
+	struct sk_buff *resp;
+	int seqno;
+};
+
 enum mv88e6xxx_region_id {
 	MV88E6XXX_REGION_GLOBAL1 = 0,
 	MV88E6XXX_REGION_GLOBAL2,
@@ -410,6 +423,9 @@ struct mv88e6xxx_chip {
 
 	/* Bridge MST to SID mappings */
 	struct list_head msts;
+
+	/* RMU resources */
+	struct mv88e6xxx_rmu rmu;
 };
 
 struct mv88e6xxx_bus_ops {
@@ -805,4 +821,8 @@ static inline void mv88e6xxx_reg_unlock(struct mv88e6xxx_chip *chip)
 
 int mv88e6xxx_fid_map(struct mv88e6xxx_chip *chip, unsigned long *bitmap);
 
+static inline bool mv88e6xxx_rmu_available(struct mv88e6xxx_chip *chip)
+{
+	return chip->rmu.master_netdev ? 1 : 0;
+}
 #endif /* _MV88E6XXX_CHIP_H */
diff --git a/drivers/net/dsa/mv88e6xxx/rmu.c b/drivers/net/dsa/mv88e6xxx/rmu.c
new file mode 100644
index 000000000000..38620b1aba04
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
+static void mv88e6xxx_rmu_create_l2(struct dsa_switch *ds, struct sk_buff *skb)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
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
+	dsa_header[0] |= FIELD_PREP(MV88E6XXX_TRG_DEV_MASK, ds->index);
+	dsa_header[1] = FIELD_PREP(MV88E6XXX_RMU_CODE_MASK, 1);
+	dsa_header[1] |= FIELD_PREP(MV88E6XXX_RMU_L2_BYTE1_RESV, MV88E6XXX_RMU_L2_BYTE1_RESV_VAL);
+	dsa_header[2] = FIELD_PREP(MV88E6XXX_RMU_PRIO_MASK, MV88E6XXX_RMU_PRIO);
+	dsa_header[2] |= MV88E6XXX_RMU_L2_BYTE2_RESV;
+	dsa_header[3] = ++chip->rmu.seqno;
+	dsa_header[4] = 0;
+	dsa_header[5] = 0;
+
+	/* Insert RMU MAC destination address /w extra if needed */
+	eth = skb_push(skb, ETH_ALEN * 2 + extra);
+	memcpy(eth->h_dest, mv88e6xxx_rmu_dest_addr, ETH_ALEN);
+	ether_addr_copy(eth->h_source, chip->rmu.master_netdev->dev_addr);
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
+static int mv88e6xxx_rmu_send_wait(struct mv88e6xxx_chip *chip,
+				   const void *req, int req_len,
+				   void *resp, unsigned int *resp_len)
+{
+	struct sk_buff *skb;
+	unsigned char *data;
+	int ret = 0;
+
+	skb = netdev_alloc_skb(chip->rmu.master_netdev, 64);
+	if (!skb)
+		return -ENOMEM;
+
+	/* Take height for an eventual EDSA header */
+	skb_reserve(skb, 2 * ETH_HLEN + 4);
+	skb_reset_network_header(skb);
+
+	/* Insert RMU request message */
+	data = skb_put(skb, req_len);
+	memcpy(data, req, req_len);
+
+	mv88e6xxx_rmu_create_l2(chip->ds, skb);
+
+	mutex_lock(&chip->rmu.mutex);
+
+	ret = dsa_switch_inband_tx(chip->ds, skb, NULL, MV88E6XXX_RMU_WAIT_TIME_MS);
+	if (!ret) {
+		dev_err(chip->dev, "RMU: error waiting for request (%pe)\n",
+			ERR_PTR(ret));
+		goto out;
+	}
+
+	if (chip->rmu.resp->len > *resp_len) {
+		ret = -EMSGSIZE;
+	} else {
+		*resp_len = chip->rmu.resp->len;
+		memcpy(resp, chip->rmu.resp->data, chip->rmu.resp->len);
+	}
+
+	kfree_skb(chip->rmu.resp);
+	chip->rmu.resp = NULL;
+
+out:
+	mutex_unlock(&chip->rmu.mutex);
+
+	return ret > 0 ? 0 : ret;
+}
+
+static int mv88e6xxx_rmu_validate_response(struct mv88e6xxx_rmu_header *resp, int code)
+{
+	if (resp->format != MV88E6XXX_RMU_RESP_FORMAT_1 &&
+	    resp->format != MV88E6XXX_RMU_RESP_FORMAT_2 &&
+	    resp->code != code) {
+		net_dbg_ratelimited("RMU: received unknown format 0x%04x code 0x%04x",
+				    resp->format, resp->code);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int mv88e6xxx_rmu_get_id(struct mv88e6xxx_chip *chip, int port)
+{
+	const u16 req[4] = { MV88E6XXX_RMU_REQ_FORMAT_GET_ID,
+			     MV88E6XXX_RMU_REQ_PAD,
+			     MV88E6XXX_RMU_REQ_CODE_GET_ID,
+			     MV88E6XXX_RMU_REQ_DATA};
+	struct mv88e6xxx_rmu_header resp;
+	int resp_len;
+	int ret = -1;
+
+	resp_len = sizeof(resp);
+	ret = mv88e6xxx_rmu_send_wait(chip, req, sizeof(req),
+				      &resp, &resp_len);
+	if (ret) {
+		dev_dbg(chip->dev, "RMU: error for command GET_ID %pe\n", ERR_PTR(ret));
+		return ret;
+	}
+
+	/* Got response */
+	ret = mv88e6xxx_rmu_validate_response(&resp, MV88E6XXX_RMU_RESP_CODE_GOT_ID);
+	if (ret)
+		return ret;
+
+	chip->rmu.prodnr = resp.prodnr;
+
+	return ret;
+}
+
+static void mv88e6xxx_rmu_stats_get(struct mv88e6xxx_chip *chip, int port, uint64_t *data)
+{
+	u16 req[4] = { MV88E6XXX_RMU_REQ_FORMAT_SOHO,
+		       MV88E6XXX_RMU_REQ_PAD,
+		       MV88E6XXX_RMU_REQ_CODE_DUMP_MIB,
+		       MV88E6XXX_RMU_REQ_DATA};
+	struct mv88e6xxx_dump_mib_resp resp;
+	struct mv88e6xxx_port *p;
+	u8 resp_port;
+	int resp_len;
+	int num_mibs;
+	int ret;
+	int i;
+
+	/* Populate port number in request */
+	req[3] = FIELD_PREP(MV88E6XXX_RMU_REQ_DUMP_MIB_PORT_MASK, port);
+
+	resp_len = sizeof(resp);
+	ret = mv88e6xxx_rmu_send_wait(chip, req, sizeof(req),
+				      &resp, &resp_len);
+	if (ret) {
+		dev_dbg(chip->dev, "RMU: error for command DUMP_MIB %pe port %d\n",
+			ERR_PTR(ret), port);
+		return;
+	}
+
+	/* Got response */
+	ret = mv88e6xxx_rmu_validate_response(&resp.rmu_header, MV88E6XXX_RMU_RESP_CODE_DUMP_MIB);
+	if (ret)
+		return;
+
+	resp_port = FIELD_GET(MV88E6XXX_SOURCE_PORT, resp.portnum);
+	p = &chip->ports[resp_port];
+	if (!p) {
+		dev_err_ratelimited(chip->dev, "RMU: illegal port number in response: %d\n",
+				    resp_port);
+		return;
+	}
+
+	/* Copy MIB array for further processing according to chip type */
+	num_mibs = (resp_len - offsetof(struct mv88e6xxx_dump_mib_resp, mib)) / sizeof(__be32);
+	for (i = 0; i < num_mibs; i++)
+		p->rmu_raw_stats[i] = resp.mib[i];
+
+	/* Update MIB for port */
+	if (chip->info->ops->stats_get_stats)
+		chip->info->ops->stats_get_stats(chip, port, data);
+}
+
+static void mv88e6xxx_disable_rmu(struct mv88e6xxx_chip *chip)
+{
+	chip->smi_ops = chip->rmu.smi_ops;
+	chip->rmu.master_netdev = NULL;
+	if (chip->info->ops->rmu_disable)
+		chip->info->ops->rmu_disable(chip);
+}
+
+static int mv88e6xxx_enable_check_rmu(const struct net_device *master,
+				      struct mv88e6xxx_chip *chip, int port)
+{
+	int ret;
+
+	chip->rmu.master_netdev = (struct net_device *)master;
+
+	/* Check if chip is alive */
+	ret = mv88e6xxx_rmu_get_id(chip, port);
+	if (!ret)
+		return ret;
+
+	chip->smi_ops = chip->rmu.rmu_ops;
+
+	return 0;
+}
+
+void mv88e6xxx_master_state_change(struct dsa_switch *ds, const struct net_device *master,
+				   bool operational)
+{
+	struct dsa_port *cpu_dp = master->dsa_ptr;
+	struct mv88e6xxx_chip *chip = ds->priv;
+	int port;
+	int ret;
+
+	port = dsa_towards_port(ds, cpu_dp->ds->index, cpu_dp->index);
+
+	mv88e6xxx_reg_lock(chip);
+
+	if (operational && chip->info->ops->rmu_enable) {
+		ret = chip->info->ops->rmu_enable(chip, port);
+
+		if (ret == -EOPNOTSUPP)
+			goto out;
+
+		if (!ret) {
+			dev_dbg(chip->dev, "RMU: Enabled on port %d", port);
+
+			ret = mv88e6xxx_enable_check_rmu(master, chip, port);
+			if (!ret)
+				goto out;
+
+		} else {
+			dev_err(chip->dev, "RMU: Unable to enable on port %d %pe",
+				port, ERR_PTR(ret));
+			goto out;
+		}
+	} else {
+		mv88e6xxx_disable_rmu(chip);
+	}
+
+out:
+	mv88e6xxx_reg_unlock(chip);
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
+void mv88e6xxx_decode_frame2reg_handler(struct dsa_switch *ds, struct sk_buff *skb)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	u8 *dsa_header;
+	u8 seqno;
+
+	/* Decode Frame2Reg DSA portion */
+	dsa_header = skb->data - 2;
+
+	if (mv88e6xxx_validate_mac(ds, skb))
+		return;
+
+	seqno = dsa_header[3];
+	if (seqno != chip->rmu.seqno) {
+		net_err_ratelimited("RMU: wrong seqno received. Was %d, expected %d",
+				    seqno, chip->rmu.seqno);
+		return;
+	}
+
+	/* Pull DSA L2 data */
+	skb_pull(skb, MV88E6XXX_DSA_HLEN);
+
+	/* Get an reference for further processing in initiator */
+	chip->rmu.resp = skb_get(skb);
+
+	dsa_switch_inband_complete(ds, NULL);
+}
+
+int mv88e6xxx_rmu_setup(struct mv88e6xxx_chip *chip)
+{
+	mutex_init(&chip->rmu.mutex);
+
+	/* Remember original ops for restore */
+	chip->rmu.smi_ops = chip->smi_ops;
+
+	/* Change rmu ops with our own pointer */
+	chip->rmu.rmu_ops = (struct mv88e6xxx_bus_ops *)chip->rmu.smi_ops;
+	chip->rmu.rmu_ops->get_rmon = mv88e6xxx_rmu_stats_get;
+
+	if (chip->info->ops->rmu_disable)
+		return chip->info->ops->rmu_disable(chip);
+
+	return 0;
+}
diff --git a/drivers/net/dsa/mv88e6xxx/rmu.h b/drivers/net/dsa/mv88e6xxx/rmu.h
new file mode 100644
index 000000000000..ed959cc17568
--- /dev/null
+++ b/drivers/net/dsa/mv88e6xxx/rmu.h
@@ -0,0 +1,75 @@
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
+#define MV88E6XXX_DSA_HLEN	4
+
+#define MV88E6XXX_RMU_MAX_RMON			64
+
+#define MV88E6XXX_RMU_WAIT_TIME_MS		20
+
+static const u8 mv88e6xxx_rmu_dest_addr[ETH_ALEN] = { 0x01, 0x50, 0x43, 0x00, 0x00, 0x00 };
+
+#define MV88E6XXX_RMU_L2_BYTE1_RESV_VAL		0x3e
+#define MV88E6XXX_RMU				1
+#define MV88E6XXX_RMU_PRIO			6
+#define MV88E6XXX_RMU_RESV2			0xf
+
+#define MV88E6XXX_SOURCE_PORT			GENMASK(6, 3)
+#define MV88E6XXX_CPU_CODE_MASK			GENMASK(7, 6)
+#define MV88E6XXX_TRG_DEV_MASK			GENMASK(4, 0)
+#define MV88E6XXX_RMU_CODE_MASK			GENMASK(1, 1)
+#define MV88E6XXX_RMU_PRIO_MASK			GENMASK(7, 5)
+#define MV88E6XXX_RMU_L2_BYTE1_RESV		GENMASK(7, 2)
+#define MV88E6XXX_RMU_L2_BYTE2_RESV		GENMASK(3, 0)
+
+#define MV88E6XXX_RMU_REQ_GET_ID		1
+#define MV88E6XXX_RMU_REQ_DUMP_MIB		2
+
+#define MV88E6XXX_RMU_REQ_FORMAT_GET_ID		0x0000
+#define MV88E6XXX_RMU_REQ_FORMAT_SOHO		0x0001
+#define MV88E6XXX_RMU_REQ_PAD			0x0000
+#define MV88E6XXX_RMU_REQ_CODE_GET_ID		0x0000
+#define MV88E6XXX_RMU_REQ_CODE_DUMP_MIB		0x1020
+#define MV88E6XXX_RMU_REQ_DATA			0x0000
+
+#define MV88E6XXX_RMU_REQ_DUMP_MIB_PORT_MASK	GENMASK(4, 0)
+
+#define MV88E6XXX_RMU_RESP_FORMAT_1		0x0001
+#define MV88E6XXX_RMU_RESP_FORMAT_2		0x0002
+#define MV88E6XXX_RMU_RESP_ERROR		0xffff
+
+#define MV88E6XXX_RMU_RESP_CODE_GOT_ID		0x0000
+#define MV88E6XXX_RMU_RESP_CODE_DUMP_MIB	0x1020
+
+struct mv88e6xxx_rmu_header {
+	__be16 format;
+	__be16 prodnr;
+	__be16 code;
+} __packed;
+
+struct mv88e6xxx_dump_mib_resp {
+	struct mv88e6xxx_rmu_header rmu_header;
+	u8 devnum;
+	u8 portnum;
+	__be32 timestamp;
+	__be32 mib[MV88E6XXX_RMU_MAX_RMON];
+} __packed;
+
+int mv88e6xxx_rmu_setup(struct mv88e6xxx_chip *chip);
+
+void mv88e6xxx_master_state_change(struct dsa_switch *ds, const struct net_device *master,
+				   bool operational);
+
+void mv88e6xxx_decode_frame2reg_handler(struct dsa_switch *ds, struct sk_buff *skb);
+
+#endif /* _MV88E6XXX_RMU_H_ */
-- 
2.25.1

