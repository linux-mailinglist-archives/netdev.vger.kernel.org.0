Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3233D5B1E9A
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 15:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232443AbiIHNVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 09:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232349AbiIHNVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 09:21:22 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8AA57CB5C
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 06:21:17 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id f11so13679573lfa.6
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 06:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=xcZiUF25x0J4Yo8A8w6/0Lc7jLNoAwjTXamqNDpVJdM=;
        b=jshaJKlVbJo6rJZB66DYU44ZD4CUsHVgl1AHHYmODUhXasXPXSwaZ3mTQIzctHBlbR
         F1RBprUaIc0oY+rhPHkuwM6Vyrp0aTx2ro1bz8McY1W/4fxXuNGUP9fDPWOxGStFswWq
         mnUb9bHM3wY4vRkrxWsQFsfq8wcJruwGn7XUjbCm3hlbf5lv6L+dk5yGkt/w2dxBVaN7
         yZQpgvx5DC9amw/mUj8YcHEtgxgF12MW7KYE2DDmQJWfkC261+uFpKlym72OHIhi1/Ii
         ATf1uk6GH6UdLyLsVDTPRA6OktYsk7nxl5BdC+5G1ybqOKoWooNzkLjTl+198ftP1RS4
         yqUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=xcZiUF25x0J4Yo8A8w6/0Lc7jLNoAwjTXamqNDpVJdM=;
        b=2b6RdDvzSA25dnOmvILuO+kqzoTOeKovd7EGJ+/QZopThsbE7ntQjRNCT3Qf4NGApf
         dy4aW4I55YqemmYlXv6XRGkD7Rg0soOO6GOd3PH69Zw6mDJtzpGKK4BWt1v2Mdu8EU94
         7cu2rN7LYTodp3EWKHlZQhfjDxfEQb5+euO2Lho7+Skm0TqwLton5uXHbJK6yc3Jhyzt
         QuShq2z+ruijDLsppUxOKHzMkDVx/uuglcoWx1k8v6nXrxfluIbkJFpCIxuwzMFoRCii
         xbv+L0m1ZNv9X5rP0hJt0IyY0860xU4ugEdAifgLgQWlUSWAOiSyx8TOk69U2iFIPQ4P
         vnwg==
X-Gm-Message-State: ACgBeo3DM/HD5dALw2fvgcw2eU71mo1heH2SbMTbil2CHCrp2cMLsZ42
        repWdi2BxK8sHfRfy9YPvXQiIj1EVMGVSQE2
X-Google-Smtp-Source: AA6agR7th9/Exqk7ZfJMDdvLSiTY1qZNOiCmln1pOSQYt3UNNPxe3BbszHYafMnZEV7akK3GWGp9WA==
X-Received: by 2002:a05:6512:3b21:b0:492:aef6:b5a7 with SMTP id f33-20020a0565123b2100b00492aef6b5a7mr2985986lfv.270.1662643275521;
        Thu, 08 Sep 2022 06:21:15 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id j6-20020a056512344600b00498f32ae907sm104837lfr.95.2022.09.08.06.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 06:21:15 -0700 (PDT)
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
Subject: [PATCH net-next v7 3/6] net: dsa: Introduce dsa tagger data operation.
Date:   Thu,  8 Sep 2022 15:21:06 +0200
Message-Id: <20220908132109.3213080-4-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220908132109.3213080-1-mattias.forsblad@gmail.com>
References: <20220908132109.3213080-1-mattias.forsblad@gmail.com>
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

