Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCE75B324C
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 10:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbiIIIwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 04:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbiIIIvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 04:51:51 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F68C12B365
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 01:51:46 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id 9so106076ljr.2
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 01:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=ruv5tr93aYjBezDdb5DTBRfAjKu1mzpocvMW/HyVJOc=;
        b=giOkbYYXtiiHcX7qVPNo3D6u+x84gV+DsFTWwqRGPcylZdKH5G0y8qGvxctczzdpJG
         hgIGFoBvpzizLj7fraF5Dj//m75iHqhBjiQNaPwtqqC4QODX/q8mBjO+hXcRsbMf5FYB
         aEtxVa96uwnwS0BXTQtbksGWGFBlm25EuMPvL4Ji+BG7BCoN09n0Fp8Ssl4c8+wFKzcf
         0fddcbatKJhEsrhI70OTzvN+itVVFT7GIWFTPbI1/9DEI5VW0nN1ZVb30Et+JqAI5Z1A
         WIgJ9p6fmgjD9Y/ivz8PpOSKTmu9O6TNaQpCGVZW1buZDnONF+WlBm77fPQWWjeSVElL
         W0eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ruv5tr93aYjBezDdb5DTBRfAjKu1mzpocvMW/HyVJOc=;
        b=tx0gXS52RB55pwMwn7Nsb6cgQEGlaNPY6vyneT+jPMBvR/KNo/TwROPFOAa5dwhRCX
         GqvUIaWyyjGyVgPIjJXKPTCbxIbaDfoBFkrpVOj9rTBTBUPVMsNA51TT6y8CTJ7ca9ZQ
         DuPGMuWkO2yPiV+RB69ews9nArp4NIZJr6v8BfOQudfWzvrLIJEWVlFFZm/S8ml8tMpj
         xEKrzuLCzolz84hPHaCxw5sF91hq39khYZW2hyoZjn5lSDM2FgDhAC+mtIo13yE5X/rd
         iijDmWIUGGyVY+NTzAK8Q1cZ8QMCaFs/d1+8BibXD3ziCG+pi0Wqbi44F3lIWPqvxorB
         M4bw==
X-Gm-Message-State: ACgBeo3mnwTWM/473kB1IP7M/53dXVwggJYw6kaLq6it4VkQeSdS02rY
        11IE38dKZdRvf+QD1lvecOcyOm0vsaStdsUu
X-Google-Smtp-Source: AA6agR4c8W+kBAp4RnvfIPYmJXw/zsKOle/df+MbRYSW2hcTzqZK1jd+QP6jlK+xr2kPKZUHrdxgiw==
X-Received: by 2002:a05:651c:1941:b0:268:9a35:4a00 with SMTP id bs1-20020a05651c194100b002689a354a00mr3472267ljb.264.1662713504554;
        Fri, 09 Sep 2022 01:51:44 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id q17-20020a05651c055100b00262fae1ffe6sm193956ljp.110.2022.09.09.01.51.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 01:51:44 -0700 (PDT)
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
Subject: [PATCH net-next v8 3/6] net: dsa: Introduce dsa tagger data operation.
Date:   Fri,  9 Sep 2022 10:51:35 +0200
Message-Id: <20220909085138.3539952-4-mattias.forsblad@gmail.com>
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

Support connecting dsa tagger for frame2reg decoding
with it's associated hookup functions.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
---
 include/net/dsa.h |  5 +++++
 net/dsa/tag_dsa.c | 32 +++++++++++++++++++++++++++++---
 2 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 0e8a7ef17490..8510267d6188 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -130,6 +130,11 @@ struct dsa_lag {
 	refcount_t refcount;
 };
 
+struct dsa_tagger_data {
+	void (*decode_frame2reg)(struct net_device *netdev,
+				 struct sk_buff *skb);
+};
+
 struct dsa_switch_tree {
 	struct list_head	list;
 
diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index e4b6e3f2a3db..3dd1dcddaf05 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -198,7 +198,10 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 				  u8 extra)
 {
+	struct dsa_tagger_data *tagger_data;
+	struct dsa_port *dp = dev->dsa_ptr;
 	bool trap = false, trunk = false;
+	struct dsa_switch *ds = dp->ds;
 	int source_device, source_port;
 	enum dsa_code code;
 	enum dsa_cmd cmd;
@@ -218,9 +221,9 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 
 		switch (code) {
 		case DSA_CODE_FRAME2REG:
-			/* Remote management is not implemented yet,
-			 * drop.
-			 */
+			tagger_data = ds->tagger_data;
+			if (likely(tagger_data->decode_frame2reg))
+				tagger_data->decode_frame2reg(dev, skb);
 			return NULL;
 		case DSA_CODE_ARP_MIRROR:
 		case DSA_CODE_POLICY_MIRROR:
@@ -323,6 +326,25 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 	return skb;
 }
 
+static int dsa_tag_connect(struct dsa_switch *ds)
+{
+	struct dsa_tagger_data *tagger_data;
+
+	tagger_data = kzalloc(sizeof(*tagger_data), GFP_KERNEL);
+	if (!tagger_data)
+		return -ENOMEM;
+
+	ds->tagger_data = tagger_data;
+
+	return 0;
+}
+
+static void dsa_tag_disconnect(struct dsa_switch *ds)
+{
+	kfree(ds->tagger_data);
+	ds->tagger_data = NULL;
+}
+
 #if IS_ENABLED(CONFIG_NET_DSA_TAG_DSA)
 
 static struct sk_buff *dsa_xmit(struct sk_buff *skb, struct net_device *dev)
@@ -343,6 +365,8 @@ static const struct dsa_device_ops dsa_netdev_ops = {
 	.proto	  = DSA_TAG_PROTO_DSA,
 	.xmit	  = dsa_xmit,
 	.rcv	  = dsa_rcv,
+	.connect  = dsa_tag_connect,
+	.disconnect = dsa_tag_disconnect,
 	.needed_headroom = DSA_HLEN,
 };
 
@@ -385,6 +409,8 @@ static const struct dsa_device_ops edsa_netdev_ops = {
 	.proto	  = DSA_TAG_PROTO_EDSA,
 	.xmit	  = edsa_xmit,
 	.rcv	  = edsa_rcv,
+	.connect  = dsa_tag_connect,
+	.disconnect = dsa_tag_disconnect,
 	.needed_headroom = EDSA_HLEN,
 };
 
-- 
2.25.1

