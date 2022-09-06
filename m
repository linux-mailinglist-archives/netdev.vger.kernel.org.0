Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 796F55ADFDD
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 08:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238521AbiIFGfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 02:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238475AbiIFGfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 02:35:05 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D031AF01
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 23:34:58 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id bt10so15904201lfb.1
        for <netdev@vger.kernel.org>; Mon, 05 Sep 2022 23:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=qzW1nwn6mCHs5IYtq85Q73as0fxswRLfrwzOSL3jaq4=;
        b=l6XcNHoZA/l+kqxjlhp+C6LMcJCw1x66Ttr4QoTklVhME1nXopHv4BYjGm2N1dltT8
         2Iqke+TkIk/88Zj1F3IagCGgYAyWK5y6yaZYV4k/BbKfo7PI3rVcWTRIQV1plzGmGXTV
         NeQ1MlYF8NDow5f+e2Ahsdtx86+V3jFz/3AxdgbBvpB3i6xe2UqQSAWmpcTvgouScosq
         b14et1iThpSm5Yd4CDSlKz/YACihDtVTMxeR4zBwyfd0wVtKKexYxjRWTubLQdwPfk5t
         WD7M0FuM2aTyDFZNoLGKQ1cHiXKuD6E9hgGtWbtCD8pSQ2FzBB7AQTrAjA70ADig+Fga
         7wrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=qzW1nwn6mCHs5IYtq85Q73as0fxswRLfrwzOSL3jaq4=;
        b=2I0Adi9ILuPD13+4rvzuotr545n8U5gjEh4jlorHDzlUhtCD1+9RmooXD++Qr/Tv5Q
         hx/CGpGMivE6zIK/lCCZK4NLMyuhHF6/BY+Ik45y+y87HnjfV4Zzf/Auaj99PCQE5K51
         VdAmRt4Br4Qdjs97fvKz9SVhY9guMQHKwMcKlGyaH8h90oWpeO7+30n5fw7Dkifl3QEk
         jT+1d8/KEW06/NfQ49OliUZVEucfQIDmx/G1knpo3qZYnKBQHkeCsLgYjkwlXJ7Lyd+g
         +DNeR08chcJMc3CfOa81BZuRzLMWglGTPw5r0anBzgeTnI6xSwHbHcg2x/1uHIwK51ct
         n8ig==
X-Gm-Message-State: ACgBeo16pXJse1hhEBwUhy0X99k8MMWxHInFF0M1AClisVVDE0you6Ax
        fS7QADnNKUwFSAlcppN4hvkVkzOYsvEw6w9q
X-Google-Smtp-Source: AA6agR4m09XmTCxJPPa1/4xhRrLx+1ZaiKU6pYtVUDd5WdFPvVzbKIMvhN9dYp/xtcPHZGbRW6rQMw==
X-Received: by 2002:a05:6512:3b2a:b0:494:72a8:bbeb with SMTP id f42-20020a0565123b2a00b0049472a8bbebmr13162613lfv.372.1662446096775;
        Mon, 05 Sep 2022 23:34:56 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id z12-20020a2e8e8c000000b00261bf4e9f90sm1646924ljk.66.2022.09.05.23.34.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 23:34:56 -0700 (PDT)
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
Subject: [PATCH net-next v4 3/6] net: dsa: Introduce dsa tagger data operation.
Date:   Tue,  6 Sep 2022 08:34:47 +0200
Message-Id: <20220906063450.3698671-4-mattias.forsblad@gmail.com>
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

Support connecting dsa tagger for frame2reg decoding
with it's associated hookup functions.

Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
---
 include/net/dsa.h |  5 +++++
 net/dsa/tag_dsa.c | 32 +++++++++++++++++++++++++++++---
 2 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 70a358641235..21f9eadb9543 100644
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

