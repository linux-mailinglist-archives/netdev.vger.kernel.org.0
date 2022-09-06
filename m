Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0195ADFE2
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 08:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238489AbiIFGf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 02:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238450AbiIFGfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 02:35:11 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30AD61CB30
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 23:35:01 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id r27so10776530ljn.0
        for <netdev@vger.kernel.org>; Mon, 05 Sep 2022 23:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=f/0j/+ErzTE6lgqBL+X99uyT3sFRj/WP+OI3F6HeGd4=;
        b=DGdE77zh9R9VItp91XDPWu+I+x8GotwO1PFHntM2flkiDH+6WPQZEjq1NsH2UFKIML
         PzHBA5CVBcTcFtxIgJCVZLdrJ/XFr6TWkrPdd0jl9uHNLGv5SC4KLFQiBP4ZpZajKAV8
         Pri8Df3kuoi13ZqRUdiJq81CVL08ZWGBWdm4xz6Ht3c6pmCWcdKtKKoSp2UQNQiQc2/P
         5nw2Iob+NMVFDBTsnqmtF2CJdO9l+y3JJVPisbX2p90qbWiLWhvY7xQae54k0ETqcWbk
         tvt+7Nsyc5GD7JJBXEhu5192SKv1YAXdBh4iC706qhzUPHeSfdgloc8OZXFMZvSXzr2b
         j2lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=f/0j/+ErzTE6lgqBL+X99uyT3sFRj/WP+OI3F6HeGd4=;
        b=OaIjY11JIAGbiuh5YnXniusUUtncv2q8UurBvCaSzJ8HyVS8TsF0BehITnz6eETSyT
         qnOigiXQR4/c8sinpIFKn9Cs/RWwbwN6/80MudS7dg4CPY8yBrythQedab8/JtyNRBWA
         Dk3uqGj+NaKXoANc+8HmNMOMj3Prrlb1kmZkDsazqtyuVNue4hJSgPdZ8YJ6rAjepNaA
         vVJOIIfGWxiGkS0GPdObP/BSF9+sVz1hXgHJPTcoux7ui6WLgfwIzKslJcJ5MuvN+GFo
         HzuxWLkGNcX6Vcwr10xOF42M67x6S5QWAqvMLYexCSc3vCturA/G1lhaik9Z6PEv2RBw
         2nGA==
X-Gm-Message-State: ACgBeo1MHM7sQ/zh3x0Y+bUTajBeFS6+Ce5J7DwsyDUZq1euXKk/UiNj
        kNu5nC9m7/CfnBRmhhP5l2rujCKlpNajUrPj
X-Google-Smtp-Source: AA6agR68rzVoHtnSKxgptJi4eTRly1WYRtIv07KpytOky40D9Rn9FfhwguKyRofFEAxF22twXLxzJA==
X-Received: by 2002:a05:651c:98d:b0:261:b5c0:121d with SMTP id b13-20020a05651c098d00b00261b5c0121dmr15046344ljq.336.1662446098969;
        Mon, 05 Sep 2022 23:34:58 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id z12-20020a2e8e8c000000b00261bf4e9f90sm1646924ljk.66.2022.09.05.23.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 23:34:58 -0700 (PDT)
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
Subject: [PATCH net-next v4 6/6] net: dsa: qca8k: Use new convenience functions
Date:   Tue,  6 Sep 2022 08:34:50 +0200
Message-Id: <20220906063450.3698671-7-mattias.forsblad@gmail.com>
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

Use the new common convenience functions for sending and
waiting for frames.

Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 61 +++++++++-----------------------
 1 file changed, 17 insertions(+), 44 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 1d3e7782a71f..7c9782be8dfe 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -160,7 +160,7 @@ static void qca8k_rw_reg_ack_handler(struct dsa_switch *ds, struct sk_buff *skb)
 			       QCA_HDR_MGMT_DATA2_LEN);
 	}
 
-	complete(&mgmt_eth_data->rw_done);
+	dsa_switch_inband_complete(ds, &mgmt_eth_data->rw_done);
 }
 
 static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *val,
@@ -228,6 +228,7 @@ static void qca8k_mdio_header_fill_seq_num(struct sk_buff *skb, u32 seq_num)
 static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 {
 	struct qca8k_mgmt_eth_data *mgmt_eth_data = &priv->mgmt_eth_data;
+	struct dsa_switch *ds = priv->ds;
 	struct sk_buff *skb;
 	bool ack;
 	int ret;
@@ -248,17 +249,12 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 
 	skb->dev = priv->mgmt_master;
 
-	reinit_completion(&mgmt_eth_data->rw_done);
-
 	/* Increment seq_num and set it in the mdio pkt */
 	mgmt_eth_data->seq++;
 	qca8k_mdio_header_fill_seq_num(skb, mgmt_eth_data->seq);
 	mgmt_eth_data->ack = false;
 
-	dev_queue_xmit(skb);
-
-	ret = wait_for_completion_timeout(&mgmt_eth_data->rw_done,
-					  msecs_to_jiffies(QCA8K_ETHERNET_TIMEOUT));
+	ret = dsa_switch_inband_tx(ds, skb, &mgmt_eth_data->rw_done, QCA8K_ETHERNET_TIMEOUT);
 
 	*val = mgmt_eth_data->data[0];
 	if (len > QCA_HDR_MGMT_DATA1_LEN)
@@ -280,6 +276,7 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 static int qca8k_write_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 {
 	struct qca8k_mgmt_eth_data *mgmt_eth_data = &priv->mgmt_eth_data;
+	struct dsa_switch *ds = priv->ds;
 	struct sk_buff *skb;
 	bool ack;
 	int ret;
@@ -300,17 +297,12 @@ static int qca8k_write_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 
 	skb->dev = priv->mgmt_master;
 
-	reinit_completion(&mgmt_eth_data->rw_done);
-
 	/* Increment seq_num and set it in the mdio pkt */
 	mgmt_eth_data->seq++;
 	qca8k_mdio_header_fill_seq_num(skb, mgmt_eth_data->seq);
 	mgmt_eth_data->ack = false;
 
-	dev_queue_xmit(skb);
-
-	ret = wait_for_completion_timeout(&mgmt_eth_data->rw_done,
-					  msecs_to_jiffies(QCA8K_ETHERNET_TIMEOUT));
+	ret = dsa_switch_inband_tx(ds, skb, &mgmt_eth_data->rw_done, QCA8K_ETHERNET_TIMEOUT);
 
 	ack = mgmt_eth_data->ack;
 
@@ -441,24 +433,21 @@ static struct regmap_config qca8k_regmap_config = {
 };
 
 static int
-qca8k_phy_eth_busy_wait(struct qca8k_mgmt_eth_data *mgmt_eth_data,
+qca8k_phy_eth_busy_wait(struct qca8k_priv *priv,
 			struct sk_buff *read_skb, u32 *val)
 {
+	struct qca8k_mgmt_eth_data *mgmt_eth_data = &priv->mgmt_eth_data;
 	struct sk_buff *skb = skb_copy(read_skb, GFP_KERNEL);
+	struct dsa_switch *ds = priv->ds;
 	bool ack;
 	int ret;
 
-	reinit_completion(&mgmt_eth_data->rw_done);
-
 	/* Increment seq_num and set it in the copy pkt */
 	mgmt_eth_data->seq++;
 	qca8k_mdio_header_fill_seq_num(skb, mgmt_eth_data->seq);
 	mgmt_eth_data->ack = false;
 
-	dev_queue_xmit(skb);
-
-	ret = wait_for_completion_timeout(&mgmt_eth_data->rw_done,
-					  QCA8K_ETHERNET_TIMEOUT);
+	ret = dsa_switch_inband_tx(ds, skb, &mgmt_eth_data->rw_done, QCA8K_ETHERNET_TIMEOUT);
 
 	ack = mgmt_eth_data->ack;
 
@@ -480,6 +469,7 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 	struct sk_buff *write_skb, *clear_skb, *read_skb;
 	struct qca8k_mgmt_eth_data *mgmt_eth_data;
 	u32 write_val, clear_val = 0, val;
+	struct dsa_switch *ds = priv->ds;
 	struct net_device *mgmt_master;
 	int ret, ret1;
 	bool ack;
@@ -540,17 +530,12 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 	clear_skb->dev = mgmt_master;
 	write_skb->dev = mgmt_master;
 
-	reinit_completion(&mgmt_eth_data->rw_done);
-
 	/* Increment seq_num and set it in the write pkt */
 	mgmt_eth_data->seq++;
 	qca8k_mdio_header_fill_seq_num(write_skb, mgmt_eth_data->seq);
 	mgmt_eth_data->ack = false;
 
-	dev_queue_xmit(write_skb);
-
-	ret = wait_for_completion_timeout(&mgmt_eth_data->rw_done,
-					  QCA8K_ETHERNET_TIMEOUT);
+	ret = dsa_switch_inband_tx(ds, write_skb, &mgmt_eth_data->rw_done, QCA8K_ETHERNET_TIMEOUT);
 
 	ack = mgmt_eth_data->ack;
 
@@ -569,7 +554,7 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 	ret = read_poll_timeout(qca8k_phy_eth_busy_wait, ret1,
 				!(val & QCA8K_MDIO_MASTER_BUSY), 0,
 				QCA8K_BUSY_WAIT_TIMEOUT * USEC_PER_MSEC, false,
-				mgmt_eth_data, read_skb, &val);
+				priv, read_skb, &val);
 
 	if (ret < 0 && ret1 < 0) {
 		ret = ret1;
@@ -577,17 +562,13 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 	}
 
 	if (read) {
-		reinit_completion(&mgmt_eth_data->rw_done);
-
 		/* Increment seq_num and set it in the read pkt */
 		mgmt_eth_data->seq++;
 		qca8k_mdio_header_fill_seq_num(read_skb, mgmt_eth_data->seq);
 		mgmt_eth_data->ack = false;
 
-		dev_queue_xmit(read_skb);
-
-		ret = wait_for_completion_timeout(&mgmt_eth_data->rw_done,
-						  QCA8K_ETHERNET_TIMEOUT);
+		ret = dsa_switch_inband_tx(ds, read_skb, &mgmt_eth_data->rw_done,
+					   QCA8K_ETHERNET_TIMEOUT);
 
 		ack = mgmt_eth_data->ack;
 
@@ -606,17 +587,12 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 		kfree_skb(read_skb);
 	}
 exit:
-	reinit_completion(&mgmt_eth_data->rw_done);
-
 	/* Increment seq_num and set it in the clear pkt */
 	mgmt_eth_data->seq++;
 	qca8k_mdio_header_fill_seq_num(clear_skb, mgmt_eth_data->seq);
 	mgmt_eth_data->ack = false;
 
-	dev_queue_xmit(clear_skb);
-
-	wait_for_completion_timeout(&mgmt_eth_data->rw_done,
-				    QCA8K_ETHERNET_TIMEOUT);
+	ret = dsa_switch_inband_tx(ds, clear_skb, &mgmt_eth_data->rw_done, QCA8K_ETHERNET_TIMEOUT);
 
 	mutex_unlock(&mgmt_eth_data->mutex);
 
@@ -1528,7 +1504,7 @@ static void qca8k_mib_autocast_handler(struct dsa_switch *ds, struct sk_buff *sk
 exit:
 	/* Complete on receiving all the mib packet */
 	if (refcount_dec_and_test(&mib_eth_data->port_parsed))
-		complete(&mib_eth_data->rw_done);
+		dsa_switch_inband_complete(ds, &mib_eth_data->rw_done);
 }
 
 static int
@@ -1543,8 +1519,6 @@ qca8k_get_ethtool_stats_eth(struct dsa_switch *ds, int port, u64 *data)
 
 	mutex_lock(&mib_eth_data->mutex);
 
-	reinit_completion(&mib_eth_data->rw_done);
-
 	mib_eth_data->req_port = dp->index;
 	mib_eth_data->data = data;
 	refcount_set(&mib_eth_data->port_parsed, QCA8K_NUM_PORTS);
@@ -1562,8 +1536,7 @@ qca8k_get_ethtool_stats_eth(struct dsa_switch *ds, int port, u64 *data)
 	if (ret)
 		goto exit;
 
-	ret = wait_for_completion_timeout(&mib_eth_data->rw_done, QCA8K_ETHERNET_TIMEOUT);
-
+	ret = dsa_switch_inband_tx(ds, NULL, &mib_eth_data->rw_done, QCA8K_ETHERNET_TIMEOUT);
 exit:
 	mutex_unlock(&mib_eth_data->mutex);
 
-- 
2.25.1

