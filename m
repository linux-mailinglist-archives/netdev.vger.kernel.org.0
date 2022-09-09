Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8E45B3248
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 10:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbiIIIwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 04:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231608AbiIIIvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 04:51:51 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1240612D1B8
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 01:51:49 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id x14so1533327lfu.10
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 01:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=O651eX+vdQDwumo6UV5G0Dw+0xJjVRxHZkQh9754BII=;
        b=drfHfC8G6tTWLPM5+sunYSbrtA6Oze+KZfihhdAQUQ7gMfhcJ1pZHfZ+TQrAY3gAtz
         9QEQ1zvtNzK+TOPe1Py867LqVk/Kvhx94vuxS14LcEB8rG2jZKC1HQ6Lb99WOazY2/oV
         Pmlsh6k0SK9aAoOtKMG0euYUyYAObXt2coMc0sXO+61GgZuGd3NxKqGa6JzkhPsTE5vO
         P8mMwPGOyVtV9rBBZWKKtRzMsJQqkTIeC5w4qFwR1AWBlwmb3LHwDLYYb838AiYR5Sqb
         ky84npq7RareDkEw1BiTHt6FKiIAAsh9zHMFPkgfoRc6FCfI4pDc+QM8/AHiTdeFKmNo
         e66A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=O651eX+vdQDwumo6UV5G0Dw+0xJjVRxHZkQh9754BII=;
        b=2Qu8QZYfiKDSwNglwd0lIAId53gjG/UK8RLbiYT0vzd1iD0F4srqfoUAhctHZgDowo
         /seny3s9pwDPKtB5J1kk88hBVPhzLy/P6CHcVbUYx9CvpCa+O26xOElULamXwm3vPMyQ
         jLfI6MUC42fkjjcWLTvGFBvomPhOoBZj+JFLibFYbZkUkgTCKgsz2rCbfVlMtBqGusj6
         dyGv0ZMLn99fjHThIzy/pVSvRaDl6MUVEyVOm4zGvHs5x46BeNqg6zzeRsTotsaudzdx
         E+zZbrfRnrBkkwguDn3L0no+BUSh9EW3O2AsoZISE9hjwc9KkL679GgWq4g2YaJWiuTT
         aUpw==
X-Gm-Message-State: ACgBeo06F9IGj7T/zR6q4dysjG1srRjH+wz20wIfhIjHbjNInmLt1chg
        0/ENJt4l4gLuC9VuMbx4AMk/tDfbKpgju+aS
X-Google-Smtp-Source: AA6agR6B/DKFMRWO8GXTnx9ePceo3mnCR+d4LAZ9ZMxGXUDH848ETLbUi1P14Zqzcz001Blo6z8tOw==
X-Received: by 2002:a05:6512:3b09:b0:48b:394e:6b3b with SMTP id f9-20020a0565123b0900b0048b394e6b3bmr3783551lfv.567.1662713507126;
        Fri, 09 Sep 2022 01:51:47 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id q17-20020a05651c055100b00262fae1ffe6sm193956ljp.110.2022.09.09.01.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 01:51:46 -0700 (PDT)
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
Subject: [PATCH net-next v8 6/6] net: dsa: qca8k: Use new convenience functions
Date:   Fri,  9 Sep 2022 10:51:38 +0200
Message-Id: <20220909085138.3539952-7-mattias.forsblad@gmail.com>
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

Use the new common convenience functions for sending and
waiting for frames.

Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 61 +++++++++-----------------------
 1 file changed, 17 insertions(+), 44 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index c181346388a4..4e9bc103c0a5 100644
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

