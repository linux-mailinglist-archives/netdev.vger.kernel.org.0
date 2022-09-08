Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 847D45B1C04
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 13:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbiIHL7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 07:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbiIHL6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 07:58:48 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3F211C7EE
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 04:58:47 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id u18so15021840lfo.8
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 04:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=xcZiUF25x0J4Yo8A8w6/0Lc7jLNoAwjTXamqNDpVJdM=;
        b=U/ej+w0tFrApTEU4CFji46ov0Vz/YZkPhif56RtKdF2QhKg5f0yQHDbxkOWY6idUMI
         3GH1FCjz/jX8dI+2eznw+ooYk0/Bc9ZKp/Ia1ML4lXmjfV6F/AaMSDltQYietiQFDfNe
         JwgXS9n43v4PKpOS6twfii1OyEtXIjYYzYCnYMpBxc3ectoexM2jn0fGnA0HySw7bhfb
         LMx/mHzGr25zwCpWSSGHhViPCpPHfkedeNmJieQ/SUUVKJ1A8Ex/OBo9gKdRvFg29dn3
         AERHTMniDdxveCY/iE/alJ0Eo1VDgGCAX5ghytKrc5oL6osSrd1CJ5S+2vutL6l4esg9
         /30Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=xcZiUF25x0J4Yo8A8w6/0Lc7jLNoAwjTXamqNDpVJdM=;
        b=U0Bp6sb/QR/synxsd0MRBa0iHqhqy3r1amzk7IHV0XC+ASEauos6Ocli/Vayf0KcnF
         Locl/X7WhF5prok/eWHvf81IPTbLX/iOq5tpFXNCMqMq1u90jtSOk8KJu1CNmhCDUmhX
         GbsAOcGH4puRf8HmLB82k/nmgpsEMRg1i+U+8xumbLSz8gKIaH6OffjEnDFFFpm64BVi
         pINvn7LB0ZVYCT7g97v9nKmnc+dcULGFEzEah43aFysnwQfuIfFDhL567LMLFGcJEQYx
         FHgd8YSIRYtb1Odck6Ku0mohaGl5YVlgebOGku90Snn5f/3A7y0sQC/c2XHBS3wT5zNR
         Dmvw==
X-Gm-Message-State: ACgBeo1qyONiT1/kqY+tY7Od0wr8lsemVYsp01yuyVRcBkVoLvX5Cj3S
        ip1KjWn73QFzbS+DPhdYGyCRRUqDXBJRl2+T
X-Google-Smtp-Source: AA6agR7VpE0XXHHG5kVb58TdBOsgoWemcy6k/DQz+RJ2+kdoZAE3ds9KNME3JNhpPIznrMjjA4xllA==
X-Received: by 2002:a05:6512:131f:b0:492:992f:1f3c with SMTP id x31-20020a056512131f00b00492992f1f3cmr2400600lfu.565.1662638325276;
        Thu, 08 Sep 2022 04:58:45 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id s10-20020a2e81ca000000b0026acfbbcb7esm833595ljg.12.2022.09.08.04.58.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 04:58:44 -0700 (PDT)
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
Subject: [PATCH net-next v6 3/6] net: dsa: Introduce dsa tagger data operation.
Date:   Thu,  8 Sep 2022 13:58:32 +0200
Message-Id: <20220908115835.3205487-4-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220908115835.3205487-1-mattias.forsblad@gmail.com>
References: <20220908115835.3205487-1-mattias.forsblad@gmail.com>
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

