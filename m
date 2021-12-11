Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88479471086
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 03:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346114AbhLKCHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 21:07:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345771AbhLKCGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 21:06:21 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4B5C0698CC;
        Fri, 10 Dec 2021 18:02:38 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id x10so17836079edd.5;
        Fri, 10 Dec 2021 18:02:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jSOiAUnjL0sqDtqDJjyAlAPssniWR5UdQu2Q1V5jU0Y=;
        b=Crp3Yut0/N+yvIaOhWU6HVxGwccy059ls2SoLwEru0z9WtZs3h3QABH5rNQw9wHsiG
         vmteiT2F73YzenfRLgg3QY4TA30kjFiHuOrL/8frOs9bbcHzUwbdAvwdwdpclc4wubD/
         ncp9zs7O1fz9/Twy5+iSxN3NuaCNHyqu77SCAMBpHzcvuBBgRJ2vXIQWm/maCcxAYfum
         hRDhQ2G7hSyhLCYMOifvsqTU/oT3sAwqpLlQzMZEUahi2z69IKDa8MeZF/b0yXijZARC
         ZL8Nv8iGooIxF2GoBrbnDty9TEio7y4YF6UwzrUzhTCCvSPm0w/JrX4PO+DnPA061M75
         symA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jSOiAUnjL0sqDtqDJjyAlAPssniWR5UdQu2Q1V5jU0Y=;
        b=EM2yy7dg/4qGcmylVDJLqdUVEb1Xssl3Zbx6z8T7gZiNrPoUODv2smBuYkLeJ0K0UU
         TmomsIKd0en1zkrfwQWQn2ZolUh77FCY/Tt3IOh3RZEwDHxGfyRt3cWiGCP5eY03WeUk
         OGtXjMVqwc/+tFC0x88NalIyeAMEAa3ZL2Wlr6VcofszKYXTrBAdWsY8QM7qgp8G2zyl
         1d2ADkKdk/DIv9JPPk/EXaVXR2/3u4YM4RI3fA/i2yUWuSLXTF7aPhywo8796gk+viuH
         m1O4sgzxvOhW1fsVWqRHcd97H5BBvdgPC2yIM30bx7GycE2Hcq3ZLyJZkyPznG2cpu8q
         y/qw==
X-Gm-Message-State: AOAM5329SMzlWmVvvwKcVxLXcMF2uk1IFbqa7+wTKK+iVAKtoEa+YC1R
        iM0NCxNmfBqR2bRCOtIVj6M=
X-Google-Smtp-Source: ABdhPJyKzPYeQTUedcSfmbugqCKAjGRFoITwVY7jxlKZJCXeXPcl4wM/a7PeRXLveXXL+aoLPwZnvw==
X-Received: by 2002:a17:907:d8e:: with SMTP id go14mr28995630ejc.366.1639188156513;
        Fri, 10 Dec 2021 18:02:36 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id p13sm2265956eds.38.2021.12.10.18.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 18:02:36 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next RFC PATCH v3 12/15] net: dsa: qca8k: add support for mdio read/write in Ethernet packet
Date:   Sat, 11 Dec 2021 03:01:49 +0100
Message-Id: <20211211020155.10114-18-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211211020155.10114-1-ansuelsmth@gmail.com>
References: <20211211020155.10114-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add qca8k side support for mdio read/write in Ethernet packet.
qca8k supports some specially crafted Ethernet packet that can be used
for mdio read/write instead of the legacy method uart/internal mdio.
This add support for the qca8k side to craft the packet and enqueue it.
Each port and the qca8k_priv have a special struct to put data in it.
The completion API is used to wait for the packet to be received back
with the requested data.

The various steps are:
1. Craft the special packet with the qca hdr set to mdio read/write
   mode.
2. Set the lock in the dedicated mdio struct.
3. Reinit the completion.
4. Enqueue the packet.
5. Wait the packet to be received.
6. Use the data set by the tagger to complete the mdio operation.

If the completion timeouts or the ack value is not true, the legacy
mdio way is used.

It has to be considered that in the initial setup mdio is still used and
mdio is still used until DSA is ready to accept and tag packet.

tag_proto_connect() is used to fill the required handler for the tagger
to correctly parse and elaborate the special Ethernet mdio packet.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c     | 189 +++++++++++++++++++++++++++++++++++-
 drivers/net/dsa/qca8k.h     |  12 +++
 include/linux/dsa/tag_qca.h |   2 +-
 3 files changed, 201 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 905fae26e05b..0f1a604f015e 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -20,6 +20,7 @@
 #include <linux/phylink.h>
 #include <linux/gpio/consumer.h>
 #include <linux/etherdevice.h>
+#include <linux/dsa/tag_qca.h>
 
 #include "qca8k.h"
 
@@ -170,6 +171,157 @@ qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val)
 	return regmap_update_bits(priv->regmap, reg, mask, write_val);
 }
 
+static void qca8k_rw_reg_ack_handler(struct dsa_port *dp, struct sk_buff *skb)
+{
+	struct qca8k_mdio_hdr_data *mdio_hdr_data;
+	struct qca8k_priv *priv = dp->ds->priv;
+	struct mdio_ethhdr *mdio_ethhdr;
+	u8 len, cmd;
+
+	mdio_ethhdr = (struct mdio_ethhdr *)skb_mac_header(skb);
+	mdio_hdr_data = &priv->mdio_hdr_data;
+
+	cmd = FIELD_GET(QCA_HDR_MDIO_CMD, mdio_ethhdr->command);
+	len = FIELD_GET(QCA_HDR_MDIO_LENGTH, mdio_ethhdr->command);
+
+	/* Make sure the seq match the requested packet */
+	if (mdio_ethhdr->seq == mdio_hdr_data->seq)
+		mdio_hdr_data->ack = true;
+
+	if (cmd == MDIO_READ) {
+		mdio_hdr_data->data[0] = mdio_ethhdr->mdio_data;
+
+		/* Get the rest of the 12 byte of data */
+		if (len > QCA_HDR_MDIO_DATA1_LEN)
+			memcpy(mdio_hdr_data->data + 1, skb->data,
+			       QCA_HDR_MDIO_DATA2_LEN);
+	}
+
+	complete(&mdio_hdr_data->rw_done);
+}
+
+static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *val,
+					       int seq_num)
+{
+	struct mdio_ethhdr *mdio_ethhdr;
+	struct sk_buff *skb;
+	u16 hdr;
+
+	skb = dev_alloc_skb(QCA_HDR_MDIO_PKG_LEN);
+
+	prefetchw(skb->data);
+
+	skb_reset_mac_header(skb);
+	skb_set_network_header(skb, skb->len);
+
+	mdio_ethhdr = skb_push(skb, QCA_HDR_MDIO_HEADER_LEN + QCA_HDR_LEN);
+
+	hdr = FIELD_PREP(QCA_HDR_XMIT_VERSION, QCA_HDR_VERSION);
+	hdr |= QCA_HDR_XMIT_FROM_CPU;
+	hdr |= FIELD_PREP(QCA_HDR_XMIT_DP_BIT, BIT(0));
+	hdr |= FIELD_PREP(QCA_HDR_XMIT_CONTROL, QCA_HDR_XMIT_TYPE_RW_REG);
+
+	mdio_ethhdr->seq = FIELD_PREP(QCA_HDR_MDIO_SEQ_NUM, seq_num);
+
+	mdio_ethhdr->command = FIELD_PREP(QCA_HDR_MDIO_ADDR, reg);
+	mdio_ethhdr->command |= FIELD_PREP(QCA_HDR_MDIO_LENGTH, 4);
+	mdio_ethhdr->command |= FIELD_PREP(QCA_HDR_MDIO_CMD, cmd);
+	mdio_ethhdr->command |= FIELD_PREP(QCA_HDR_MDIO_CHECK_CODE, MDIO_CHECK_CODE_VAL);
+
+	if (cmd == MDIO_WRITE)
+		mdio_ethhdr->mdio_data = *val;
+
+	mdio_ethhdr->hdr = htons(hdr);
+
+	skb_put_zero(skb, QCA_HDR_MDIO_DATA2_LEN);
+	skb_put_zero(skb, QCA_HDR_MDIO_PADDING_LEN);
+
+	return skb;
+}
+
+static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val)
+{
+	struct qca8k_mdio_hdr_data *mdio_hdr_data = &priv->mdio_hdr_data;
+	struct sk_buff *skb;
+	bool ack;
+	int ret;
+
+	skb = qca8k_alloc_mdio_header(MDIO_READ, reg, NULL, 200);
+	skb->dev = dsa_to_port(priv->ds, 0)->master;
+
+	mutex_lock(&mdio_hdr_data->mutex);
+
+	reinit_completion(&mdio_hdr_data->rw_done);
+	mdio_hdr_data->seq = 200;
+	mdio_hdr_data->ack = false;
+
+	dev_queue_xmit(skb);
+
+	ret = wait_for_completion_timeout(&mdio_hdr_data->rw_done, QCA8K_ETHERNET_TIMEOUT);
+
+	*val = mdio_hdr_data->data[0];
+	ack = mdio_hdr_data->ack;
+
+	mutex_unlock(&mdio_hdr_data->mutex);
+
+	if (ret <= 0)
+		return -ETIMEDOUT;
+
+	if (!ack)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int qca8k_write_eth(struct qca8k_priv *priv, u32 reg, u32 val)
+{
+	struct qca8k_mdio_hdr_data *mdio_hdr_data = &priv->mdio_hdr_data;
+	struct sk_buff *skb;
+	bool ack;
+	int ret;
+
+	skb = qca8k_alloc_mdio_header(MDIO_WRITE, reg, &val, 200);
+	skb->dev = dsa_to_port(priv->ds, 0)->master;
+
+	mutex_lock(&mdio_hdr_data->mutex);
+
+	reinit_completion(&mdio_hdr_data->rw_done);
+	mdio_hdr_data->ack = false;
+	mdio_hdr_data->seq = 200;
+
+	dev_queue_xmit(skb);
+
+	ret = wait_for_completion_timeout(&mdio_hdr_data->rw_done, QCA8K_ETHERNET_TIMEOUT);
+
+	ack = mdio_hdr_data->ack;
+
+	mutex_unlock(&mdio_hdr_data->mutex);
+
+	if (ret <= 0)
+		return -ETIMEDOUT;
+
+	if (!ack)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int
+qca8k_regmap_update_bits_eth(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val)
+{
+	u32 val = 0;
+	int ret;
+
+	ret = qca8k_read_eth(priv, reg, &val);
+	if (ret)
+		return ret;
+
+	val &= ~mask;
+	val |= write_val;
+
+	return qca8k_write_eth(priv, reg, val);
+}
+
 static int
 qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
 {
@@ -178,6 +330,9 @@ qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
 	u16 r1, r2, page;
 	int ret;
 
+	if (priv->master_oper && !qca8k_read_eth(priv, reg, val))
+		return 0;
+
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
@@ -201,6 +356,9 @@ qca8k_regmap_write(void *ctx, uint32_t reg, uint32_t val)
 	u16 r1, r2, page;
 	int ret;
 
+	if (priv->master_oper && !qca8k_write_eth(priv, reg, val))
+		return 0;
+
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
@@ -225,6 +383,10 @@ qca8k_regmap_update_bits(void *ctx, uint32_t reg, uint32_t mask, uint32_t write_
 	u32 val;
 	int ret;
 
+	if (priv->master_oper &&
+	    !qca8k_regmap_update_bits_eth(priv, reg, mask, write_val))
+		return 0;
+
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
@@ -1232,7 +1394,7 @@ qca8k_setup(struct dsa_switch *ds)
 		}
 
 		/* Individual user ports get connected to CPU port only */
-		if (dsa_is_user_port(ds, i)) {
+		if (dsa_is_dsa_port(ds, i)) {
 			ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
 					QCA8K_PORT_LOOKUP_MEMBER,
 					BIT(cpu_port));
@@ -2395,6 +2557,30 @@ qca8k_master_change(struct dsa_switch *ds, const struct net_device *master,
 		priv->master_oper = false;
 }
 
+static int qca8k_connect_tag_protocol(struct dsa_switch *ds,
+				      enum dsa_tag_protocol proto)
+{
+	struct qca8k_priv *qca8k_priv = ds->priv;
+
+	switch (proto) {
+	case DSA_TAG_PROTO_QCA:
+		struct tag_qca_priv *priv;
+
+		priv = ds->tagger_data;
+
+		mutex_init(&qca8k_priv->mdio_hdr_data.mutex);
+		init_completion(&qca8k_priv->mdio_hdr_data.rw_done);
+
+		priv->rw_reg_ack_handler = qca8k_rw_reg_ack_handler;
+
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static const struct dsa_switch_ops qca8k_switch_ops = {
 	.get_tag_protocol	= qca8k_get_tag_protocol,
 	.setup			= qca8k_setup,
@@ -2431,6 +2617,7 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.port_lag_join		= qca8k_port_lag_join,
 	.port_lag_leave		= qca8k_port_lag_leave,
 	.master_state_change	= qca8k_master_change,
+	.connect_tag_protocol	= qca8k_connect_tag_protocol,
 };
 
 static int qca8k_read_switch_id(struct qca8k_priv *priv)
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index fb98536bf3e8..307c56466082 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -11,6 +11,9 @@
 #include <linux/delay.h>
 #include <linux/regmap.h>
 #include <linux/gpio.h>
+#include <linux/dsa/tag_qca.h>
+
+#define QCA8K_ETHERNET_TIMEOUT				100
 
 #define QCA8K_NUM_PORTS					7
 #define QCA8K_NUM_CPU_PORTS				2
@@ -328,6 +331,14 @@ enum {
 	QCA8K_CPU_PORT6,
 };
 
+struct qca8k_mdio_hdr_data {
+	struct completion rw_done;
+	struct mutex mutex; /* Enforce one mdio read/write at time */
+	bool ack;
+	u32 seq;
+	u32 data[4];
+};
+
 struct qca8k_ports_config {
 	bool sgmii_rx_clk_falling_edge;
 	bool sgmii_tx_clk_falling_edge;
@@ -354,6 +365,7 @@ struct qca8k_priv {
 	struct dsa_switch_ops ops;
 	struct gpio_desc *reset_gpio;
 	unsigned int port_mtu[QCA8K_NUM_PORTS];
+	struct qca8k_mdio_hdr_data mdio_hdr_data;
 };
 
 struct qca8k_mib_desc {
diff --git a/include/linux/dsa/tag_qca.h b/include/linux/dsa/tag_qca.h
index f3369b939107..203e72dad9bb 100644
--- a/include/linux/dsa/tag_qca.h
+++ b/include/linux/dsa/tag_qca.h
@@ -56,7 +56,7 @@ struct mdio_ethhdr {
 	u32 command;		/* command bit 31:0 */
 	u32 seq;		/* seq 63:32 */
 	u32 mdio_data;		/* first 4byte mdio */
-	u16 hdr;		/* qca hdr */
+	__be16 hdr;		/* qca hdr */
 } __packed;
 
 enum mdio_cmd {
-- 
2.32.0

