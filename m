Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B16745B6BCF
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 12:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbiIMKnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 06:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbiIMKnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 06:43:37 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7BE85D130
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 03:43:35 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id w8so19378486lft.12
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 03:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=gYr4/+/VXuVJL9MDBujFWj6YWYU745SughITazFnTEI=;
        b=W/vhTRZWGKf/0iPcB5gThyQztdOqqXEss3a4E7k7G+o+zl7+b0rd7/5/5+Cd6fBllT
         y+W4v9NA0FQRkDJ8hYTjO1O/q+T29inUgd1Uy2TbOl3c6LD4Zl0GPnv2wXPRwReMHxMp
         Tj02Z2kDFNdPXnFRkOxPDC/NLfH8ciUxLD5BdwhyjMCgBS5hN7sK8530UWjJxVwBijNO
         ZZAFVDLNbDmuC9eUZI2ECe9JWgLUP6AlkZgSYrdEr5lOZ9VNYDAzvsIZ2Se5owk7Y4dT
         QG28CXqacear4kA8Nw0ORHXHejAndAXhbu/PPMGRLmHVhFB9inqCDxkxrOWJtheHYpSn
         /wQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=gYr4/+/VXuVJL9MDBujFWj6YWYU745SughITazFnTEI=;
        b=yBHHFSfd6v6NVC9eFYOxFcs6cnMyt45+FyRcWR5ahFb8ijpuBs6pg2JNL/d36SJM5W
         jnwLDk7GYicmQAkvOh+MHHvUbaxBt5i2aT0LLGMLQdKG2mhOk90qfBWHX+Mfp/Be6FHM
         3IGKnnLAsTUejXYTT+o8kyfHiEuKVwanEQrSU9wXcyUhUoq+FTApDhndU3GdtoDS0TC0
         LZ1Cudu5M/YBR961k9WMG3UxKzBumO59HeDShtUko6lPz+BFtUxTpmjjyYyhPmpMzbNB
         s075+TLS9in8pz/6x4DAhoAymo4ANsf9RkYuqbJBXYhUGs41VO4pc3cb9BoVl/qcRGeS
         QGLA==
X-Gm-Message-State: ACgBeo2sAAuOLybwQA5yeFmtFdBwXUyhms7gqFszW7DMgPqD7M3ZBP4K
        boe64A3iJYvyMs+T1qubtfqbI2DfWc2rYZ5h
X-Google-Smtp-Source: AA6agR7LsB0v/LzxPDidN+R7hXPEwTVykWDYLpRiDmVCB98eb7U1YSQjJE4KxakGqUqC5WIOnZScEQ==
X-Received: by 2002:a05:6512:1155:b0:49b:e2c9:e8c3 with SMTP id m21-20020a056512115500b0049be2c9e8c3mr1091748lfg.650.1663065814055;
        Tue, 13 Sep 2022 03:43:34 -0700 (PDT)
Received: from wse-c0089.westermo.com (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id i2-20020a2ea362000000b0026bf27c7056sm1018946ljn.67.2022.09.13.03.43.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 03:43:33 -0700 (PDT)
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
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: [PATCH net-next v10 3/6] net: dsa: Introduce dsa tagger data operation.
Date:   Tue, 13 Sep 2022 12:43:17 +0200
Message-Id: <20220913104320.471673-4-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220913104320.471673-1-mattias.forsblad@gmail.com>
References: <20220913104320.471673-1-mattias.forsblad@gmail.com>
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

