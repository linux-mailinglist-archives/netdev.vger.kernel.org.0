Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3848471080
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 03:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346088AbhLKCHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 21:07:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345777AbhLKCGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 21:06:21 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32161C0698CE;
        Fri, 10 Dec 2021 18:02:39 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id x10so17836144edd.5;
        Fri, 10 Dec 2021 18:02:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G+El3VU7kFi+f+gSiUl3JhZawQPXtAaFeZtpDHNPJt4=;
        b=Fy/am/hIzudEgAzEnUSGP0lUmPDNqqaOT/6Zh2vJa7oAmRbIjiZviyz1gaX9j0ixZQ
         Q1Q31oUaUZvk0ZCjNUvM7qPZT3bdew0hLazye9FlVFjLYn374ByrRIe/p1zaBXD+uJRi
         76XTrvOi6NQpGfoxxQEeVhNwh9K4L5G+7SFrpuJYSjl+r2tXsATFnoGoQW+pib507UUQ
         vYa1qZtt+nfaW/C/bnBmLHTaTycjFxyV7u7FbaGwYFJTuIOjTBjKVuAXtGgCF2aZYO+o
         T5Ncgr5GSXEnG8P/qidZfP8C+JpPEwemgEovTpHRZ4uQNtxTEyXwwzBMslTH6Ub8giBr
         Mfmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G+El3VU7kFi+f+gSiUl3JhZawQPXtAaFeZtpDHNPJt4=;
        b=AzRVqoRhfK2VZUMbIXrr/08/2uRseyVmYMc+ThB40247+AUu2/yK7qGAtZU5d0vo7s
         pVt1f8cKafuqj3u6YHPUzxgTJlc3773a7JabfjR0/9et1HZtu5ZP/yXNXs6Ffk0k0EJO
         hrNWtXPGpfAov9mt/Z7+z3DSvKJUq+kRouWMHaKQCEfaXoXC3ysFZEtRMfSeILkyQOCw
         DqPeEkMZZvUnznSsffD2RC4rDuOyHf2z4fXWYLxsT1I1EbU6QDETpXzS5Ii3J9qgp+PQ
         FCIvtK65VzJQnmFFJzSmT3VHdVYXrd4hoIbpKG1knzr2fmwvpG0mvPuIzTJ4RT+tIpCf
         2p1Q==
X-Gm-Message-State: AOAM533C0+6Yr91Xm6CnVsCNdc5B+8HzcZ4EMJzFGgjmLSC4Hv4eZLiB
        N5aGYDOd1aph77mLPdvLzd8=
X-Google-Smtp-Source: ABdhPJz+itcEf+MBjBAM5A2JoTH5tjABvSfeQYjiEiPqpoNOJ1giOFe+2lB71D6WEtsSoWjGl0KGSw==
X-Received: by 2002:a17:906:3085:: with SMTP id 5mr27661554ejv.365.1639188157629;
        Fri, 10 Dec 2021 18:02:37 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id p13sm2265956eds.38.2021.12.10.18.02.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 18:02:37 -0800 (PST)
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
Subject: [net-next RFC PATCH v3 12/14] net: dsa: qca8k: add support for mib autocast in Ethernet packet
Date:   Sat, 11 Dec 2021 03:01:50 +0100
Message-Id: <20211211020155.10114-19-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211211020155.10114-1-ansuelsmth@gmail.com>
References: <20211211020155.10114-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The switch can autocast MIB counter using Ethernet packet.
Add support for this and provide a handler for the tagger.
The switch will send packet with MIB counter for each port, the switch
will use completion API to wait for the correct packet to be received
and will complete the task only when each packet is received.
Although the handler will drop all the other packet, we still have to
consume each MIB packet to complete the request. This is done to prevent
mixed data with concurrent ethtool request.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 102 +++++++++++++++++++++++++++++++++++++++-
 drivers/net/dsa/qca8k.h |  18 ++++++-
 2 files changed, 117 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 0f1a604f015e..624df3b0fd9f 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -794,7 +794,10 @@ qca8k_mib_init(struct qca8k_priv *priv)
 	int ret;
 
 	mutex_lock(&priv->reg_mutex);
-	ret = regmap_set_bits(priv->regmap, QCA8K_REG_MIB, QCA8K_MIB_FLUSH | QCA8K_MIB_BUSY);
+	ret = regmap_update_bits(priv->regmap, QCA8K_REG_MIB,
+				 QCA8K_MIB_FUNC | QCA8K_MIB_BUSY,
+				 FIELD_PREP(QCA8K_MIB_FUNC, QCA8K_MIB_FLUSH) |
+				 QCA8K_MIB_BUSY);
 	if (ret)
 		goto exit;
 
@@ -1865,6 +1868,97 @@ qca8k_get_strings(struct dsa_switch *ds, int port, u32 stringset, uint8_t *data)
 			ETH_GSTRING_LEN);
 }
 
+static void qca8k_mib_autocast_handler(struct dsa_port *dp, struct sk_buff *skb)
+{
+	const struct qca8k_match_data *match_data;
+	struct qca8k_mib_hdr_data *mib_hdr_data;
+	struct qca8k_priv *priv = dp->ds->priv;
+	const struct qca8k_mib_desc *mib;
+	struct mib_ethhdr *mib_ethhdr;
+	int i, mib_len, offset = 0;
+	u64 *data;
+	u8 port;
+
+	mib_ethhdr = (struct mib_ethhdr *)skb_mac_header(skb);
+	mib_hdr_data = &priv->mib_hdr_data;
+
+	/* The switch autocast every port. Ignore other packet and
+	 * parse only the requested one.
+	 */
+	port = FIELD_GET(QCA_HDR_RECV_SOURCE_PORT, ntohs(mib_ethhdr->hdr));
+	if (port != mib_hdr_data->req_port)
+		goto exit;
+
+	match_data = device_get_match_data(priv->dev);
+	data = mib_hdr_data->data;
+
+	for (i = 0; i < match_data->mib_count; i++) {
+		mib = &ar8327_mib[i];
+
+		/* First 3 mib are present in the skb head */
+		if (i < 3) {
+			data[i] = mib_ethhdr->data[i];
+			continue;
+		}
+
+		mib_len = sizeof(uint32_t);
+
+		/* Some mib are 64 bit wide */
+		if (mib->size == 2)
+			mib_len = sizeof(uint64_t);
+
+		/* Copy the mib value from packet to the */
+		memcpy(data + i, skb->data + offset, mib_len);
+
+		/* Set the offset for the next mib */
+		offset += mib_len;
+	}
+
+exit:
+	/* Complete on receiving all the mib packet */
+	if (refcount_dec_and_test(&mib_hdr_data->port_parsed))
+		complete(&mib_hdr_data->rw_done);
+}
+
+static int
+qca8k_get_ethtool_stats_eth(struct dsa_switch *ds, int port, u64 *data)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct qca8k_mib_hdr_data *mib_hdr_data;
+	struct qca8k_priv *priv = ds->priv;
+	int ret;
+
+	mib_hdr_data = &priv->mib_hdr_data;
+
+	mutex_lock(&mib_hdr_data->mutex);
+
+	reinit_completion(&mib_hdr_data->rw_done);
+
+	mib_hdr_data->req_port = dp->index;
+	mib_hdr_data->data = data;
+	refcount_set(&mib_hdr_data->port_parsed, QCA8K_NUM_PORTS);
+
+	mutex_lock(&priv->reg_mutex);
+
+	/* Send mib autocast request */
+	ret = regmap_update_bits(priv->regmap, QCA8K_REG_MIB,
+				 QCA8K_MIB_FUNC | QCA8K_MIB_BUSY,
+				 FIELD_PREP(QCA8K_MIB_FUNC, QCA8K_MIB_CAST) |
+				 QCA8K_MIB_BUSY);
+
+	mutex_unlock(&priv->reg_mutex);
+
+	if (ret)
+		goto exit;
+
+	ret = wait_for_completion_timeout(&mib_hdr_data->rw_done, QCA8K_ETHERNET_TIMEOUT);
+
+	mutex_unlock(&mib_hdr_data->mutex);
+
+exit:
+	return ret;
+}
+
 static void
 qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
 			uint64_t *data)
@@ -1876,6 +1970,10 @@ qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
 	u32 hi = 0;
 	int ret;
 
+	if (priv->master_oper &&
+	    qca8k_get_ethtool_stats_eth(ds, port, data) > 0)
+		return;
+
 	match_data = of_device_get_match_data(priv->dev);
 
 	for (i = 0; i < match_data->mib_count; i++) {
@@ -2572,7 +2670,7 @@ static int qca8k_connect_tag_protocol(struct dsa_switch *ds,
 		init_completion(&qca8k_priv->mdio_hdr_data.rw_done);
 
 		priv->rw_reg_ack_handler = qca8k_rw_reg_ack_handler;
-
+		priv->mib_autocast_handler = qca8k_mib_autocast_handler;
 		break;
 	default:
 		return -EOPNOTSUPP;
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 307c56466082..e46320487834 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -66,7 +66,7 @@
 #define QCA8K_REG_MODULE_EN				0x030
 #define   QCA8K_MODULE_EN_MIB				BIT(0)
 #define QCA8K_REG_MIB					0x034
-#define   QCA8K_MIB_FLUSH				BIT(24)
+#define   QCA8K_MIB_FUNC				GENMASK(26, 24)
 #define   QCA8K_MIB_CPU_KEEP				BIT(20)
 #define   QCA8K_MIB_BUSY				BIT(17)
 #define QCA8K_MDIO_MASTER_CTRL				0x3c
@@ -316,6 +316,12 @@ enum qca8k_vlan_cmd {
 	QCA8K_VLAN_READ = 6,
 };
 
+enum qca8k_mid_cmd {
+	QCA8K_MIB_FLUSH = 1,
+	QCA8K_MIB_FLUSH_PORT = 2,
+	QCA8K_MIB_CAST = 3,
+};
+
 struct ar8xxx_port_status {
 	int enabled;
 };
@@ -339,6 +345,15 @@ struct qca8k_mdio_hdr_data {
 	u32 data[4];
 };
 
+struct qca8k_mib_hdr_data {
+	struct completion rw_done;
+	struct mutex mutex; /* Process one command at time */
+	refcount_t port_parsed; /* Counter to track parsed port */
+	u8 req_port;
+	u64 *data; /* pointer to ethtool data */
+	bool ready;
+};
+
 struct qca8k_ports_config {
 	bool sgmii_rx_clk_falling_edge;
 	bool sgmii_tx_clk_falling_edge;
@@ -366,6 +381,7 @@ struct qca8k_priv {
 	struct gpio_desc *reset_gpio;
 	unsigned int port_mtu[QCA8K_NUM_PORTS];
 	struct qca8k_mdio_hdr_data mdio_hdr_data;
+	struct qca8k_mib_hdr_data mib_hdr_data;
 };
 
 struct qca8k_mib_desc {
-- 
2.32.0

