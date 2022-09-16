Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 283175BAD38
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 14:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbiIPMS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 08:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbiIPMSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 08:18:34 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A561B14F6
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 05:18:28 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id f9so34568607lfr.3
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 05:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=gYr4/+/VXuVJL9MDBujFWj6YWYU745SughITazFnTEI=;
        b=FTzgkHrb0yyw4Rff/bUsaz0RuGG3RRmn2n29LqMXUkGi2PnqQ7D3Aa18mlmZZhRvNO
         U9ag5jgbVH/mtkbUtJXvp3Uivxzel4QbPFz/Z2jZVXT6MzdKeaZPNz7YTHq2WoUImJ/L
         wnZmEx5Ct4LLHE7UYJz3c8sCPvhH2OGEN/aExWfP9/TxytaXFybqsP5A2lZ+PBBXEAoP
         9N3N3lf6A9Dya2uHWfTxR//BR4Al4fx2WFKrEiym3ZVC7tsyRoejKRLdEMHZYfvp4MN5
         nS+HzMt0pX3JVaWe/UP+hKao+pTyvXikx0luscwD0wTtHRWIrFSt4IfXT5EKBS/rGiBf
         VDUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=gYr4/+/VXuVJL9MDBujFWj6YWYU745SughITazFnTEI=;
        b=vsXOCWj9wzJnNpg+tog7cfx4Jvte/m3GnaGeU59Yg46G2y3HyGQntY0+Tp/jihVisW
         F2GqSBecGqCQ2YyIc/Ouf4BUzvBJTzw6kEuGkXgB0ACX8SHdt5GKms8IP/gJvA3Kr2U+
         i1JM/7YhO5lQDIsXnQExJny2+du34HgqBSYPoFmSuQdsAbCzwTzGB/lisPGlXT6vPw9t
         gEMW9bGdTGrSlPwHF7PjRJMwi5DKxgaUTFnmxRCtIA9TjEe8+oo21PIHncgO1xgoFfYt
         9xhFGCpGQpZazw6e+oY2iTBShr295VCk+s53/8+vWYVymtJmpmxzTtAoFV9VMehrqk5L
         SHyg==
X-Gm-Message-State: ACrzQf06pVYl2qnH7bbqgGP8Fcd85Kk/OCrJcjKfFxdCiuVRuq5NjzdV
        jz3mi0N6pHELgk30ORLDnriFiFPc0p5o+vjnY3M=
X-Google-Smtp-Source: AMsMyM6c8xF0p20XN52/XvslRepOK7d6UV83SYM6/5l9tQoDXxhW+In+GT7Ws3sipf6LRxMoEzfBMw==
X-Received: by 2002:a05:6512:234b:b0:49e:6f0a:b08d with SMTP id p11-20020a056512234b00b0049e6f0ab08dmr1686948lfu.633.1663330706567;
        Fri, 16 Sep 2022 05:18:26 -0700 (PDT)
Received: from wse-c0089.westermo.com (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id h6-20020a0565123c8600b0049f5358062dsm313824lfv.98.2022.09.16.05.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 05:18:26 -0700 (PDT)
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk,
        ansuelsmth@gmail.com, Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: [PATCH net-next v13 3/6] net: dsa: Introduce dsa tagger data operation.
Date:   Fri, 16 Sep 2022 14:18:14 +0200
Message-Id: <20220916121817.4061532-4-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220916121817.4061532-1-mattias.forsblad@gmail.com>
References: <20220916121817.4061532-1-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support connecting dsa tagger for frame2reg decoding
with its associated hookup functions.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
---
 include/linux/dsa/mv88e6xxx.h |  6 ++++++
 net/dsa/dsa_priv.h            |  2 ++
 net/dsa/tag_dsa.c             | 40 +++++++++++++++++++++++++++++++----
 3 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/include/linux/dsa/mv88e6xxx.h b/include/linux/dsa/mv88e6xxx.h
index 8c3d45eca46b..a8b6f3c110e5 100644
--- a/include/linux/dsa/mv88e6xxx.h
+++ b/include/linux/dsa/mv88e6xxx.h
@@ -5,9 +5,15 @@
 #ifndef _NET_DSA_TAG_MV88E6XXX_H
 #define _NET_DSA_TAG_MV88E6XXX_H
 
+#include <net/dsa.h>
 #include <linux/if_vlan.h>
 
 #define MV88E6XXX_VID_STANDALONE	0
 #define MV88E6XXX_VID_BRIDGED		(VLAN_N_VID - 1)
 
+struct dsa_tagger_data {
+	void (*decode_frame2reg)(struct dsa_switch *ds,
+				 struct sk_buff *skb);
+};
+
 #endif
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 614fbba8fe39..3b23b37eb0f4 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -17,6 +17,8 @@
 
 #define DSA_MAX_NUM_OFFLOADING_BRIDGES		BITS_PER_LONG
 
+#define DSA_FRAME2REG_SOURCE_DEV		GENMASK(5, 0)
+
 enum {
 	DSA_NOTIFIER_AGEING_TIME,
 	DSA_NOTIFIER_BRIDGE_JOIN,
diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index e4b6e3f2a3db..e7fdf3b5cb4a 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -198,8 +198,11 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 				  u8 extra)
 {
+	struct dsa_port *cpu_dp = dev->dsa_ptr;
+	struct dsa_tagger_data *tagger_data;
 	bool trap = false, trunk = false;
 	int source_device, source_port;
+	struct dsa_switch *ds;
 	enum dsa_code code;
 	enum dsa_cmd cmd;
 	u8 *dsa_header;
@@ -218,9 +221,16 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 
 		switch (code) {
 		case DSA_CODE_FRAME2REG:
-			/* Remote management is not implemented yet,
-			 * drop.
-			 */
+			source_device = FIELD_GET(DSA_FRAME2REG_SOURCE_DEV, dsa_header[0]);
+			ds = dsa_switch_find(cpu_dp->dst->index, source_device);
+			if (ds) {
+				tagger_data = ds->tagger_data;
+				if (likely(tagger_data->decode_frame2reg))
+					tagger_data->decode_frame2reg(ds, skb);
+			} else {
+				net_err_ratelimited("RMU: Didn't find switch with index %d",
+						    source_device);
+			}
 			return NULL;
 		case DSA_CODE_ARP_MIRROR:
 		case DSA_CODE_POLICY_MIRROR:
@@ -254,7 +264,6 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 	source_port = (dsa_header[1] >> 3) & 0x1f;
 
 	if (trunk) {
-		struct dsa_port *cpu_dp = dev->dsa_ptr;
 		struct dsa_lag *lag;
 
 		/* The exact source port is not available in the tag,
@@ -323,6 +332,25 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
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
@@ -343,6 +371,8 @@ static const struct dsa_device_ops dsa_netdev_ops = {
 	.proto	  = DSA_TAG_PROTO_DSA,
 	.xmit	  = dsa_xmit,
 	.rcv	  = dsa_rcv,
+	.connect  = dsa_tag_connect,
+	.disconnect = dsa_tag_disconnect,
 	.needed_headroom = DSA_HLEN,
 };
 
@@ -385,6 +415,8 @@ static const struct dsa_device_ops edsa_netdev_ops = {
 	.proto	  = DSA_TAG_PROTO_EDSA,
 	.xmit	  = edsa_xmit,
 	.rcv	  = edsa_rcv,
+	.connect  = dsa_tag_connect,
+	.disconnect = dsa_tag_disconnect,
 	.needed_headroom = EDSA_HLEN,
 };
 
-- 
2.25.1

