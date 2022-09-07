Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96C275AFD8E
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 09:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbiIGHan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 03:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbiIGHaE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 03:30:04 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B6D42ACB
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 00:29:58 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id s15so14933624ljp.5
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 00:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=xcZiUF25x0J4Yo8A8w6/0Lc7jLNoAwjTXamqNDpVJdM=;
        b=ATfBna3ULQNA/YPUT0OlhGd5LHmDWt4J0mnJm7HVkuIBzgHUfwgWZ66z1PiGdlkk3d
         mW076wnEIO4xfWD1+4JgMu3VLk8hzfH5vTKNF2ZwqIOrq9CFwBvfqwM5lJF5YcdO5BDf
         u4rr3ZCJ1FhADA+ugy+7gHHod2Z3/yS13vHl8WlW680tJb2Ql1vEpn5xRUlTkKQ0sCNo
         phZybadwpraPJyV1EOBa9Ba8O2DfKKRZPWJvgu8juy2g3fCdzvZUZQovC/zAvTLKHyNR
         EjvFg4VK0Zr2Bo1wx3pOiJx53zXC4iWTKuL9DjuwRUFUE0iDqhkc4+aQayqNgIZjNs4k
         ZmVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=xcZiUF25x0J4Yo8A8w6/0Lc7jLNoAwjTXamqNDpVJdM=;
        b=5tUWFNDnXC8Wpr8BTEvZ39Ihu33B2J23lcJbTLk9EP+2jc/S5t5oFDCJMK62+gsLiL
         W2Ad8o8DsX/beFVtqYtlw7Nt/IwpgD1P+W7hcWJ6fLGajc8IjAivg1B4CVpvcZtqmRfC
         8GMTdqoeNEXCZ9YQXnuCLLR94v2jUzCaGkhr4kpeAo3X2b5e3ZxCxA3rJnbGJrzRGCeO
         cu2R8FDA7Hhd8okAv22LB7AOxdyCaIcBN5XlOst3XThRiw9f5+zio4tRHFxyV6H15NbK
         OAL4XRetVCRCsuAXRi6bYbU6LhBTrnIz7LF0tqL9OQSdLbMhLN6cnT4Jy2k+ijWQuDY0
         jwbQ==
X-Gm-Message-State: ACgBeo12oYBuUGrnDK6QLabRWdyGUIcFDL2bAwFNFS5FpahItKqSfAv2
        WSXqw6CROR7HHJqt16c5mDOmGSqyRqnUx8P8
X-Google-Smtp-Source: AA6agR4dn1X3xGQpdw0b0rqnUnWbr+6FyY3f44c9YplJvEohg9gJgQ3ia8E/ljfgFJ2lqrIbulZs8A==
X-Received: by 2002:a2e:aa13:0:b0:264:eb98:b7fd with SMTP id bf19-20020a2eaa13000000b00264eb98b7fdmr554052ljb.26.1662535796713;
        Wed, 07 Sep 2022 00:29:56 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id w3-20020ac25983000000b0048a83336343sm2275507lfn.252.2022.09.07.00.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 00:29:56 -0700 (PDT)
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
Subject: [PATCH net-next v5 3/6] net: dsa: Introduce dsa tagger data operation.
Date:   Wed,  7 Sep 2022 09:29:47 +0200
Message-Id: <20220907072950.2329571-4-mattias.forsblad@gmail.com>
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

