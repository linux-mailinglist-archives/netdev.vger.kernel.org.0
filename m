Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA21568ACC8
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 23:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbjBDWDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 17:03:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232813AbjBDWC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 17:02:59 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B61A298C6
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 14:02:58 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id g18so6990236qtb.6
        for <netdev@vger.kernel.org>; Sat, 04 Feb 2023 14:02:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IEaLXczlGF6QiWh17Q0HZk+D3OpE/6hVdkCgSrs4VZk=;
        b=YG6YBqg1CDS0gIeFJ2Sh5ydbbNuxfy5oK7vb+i1OU9JAEz4nh35vdZHqg2zJRPH6h8
         AzqiIiNlpdej8mh4r2VGcHB2ceFC4vpeSccu5QBpBk8aqxTFJZJHDZb1YR++VE7rHLyM
         omormcUi+MAx0bvT7rvIQyvTvI0yNS/UrVo/4Jf04Stes9Gu2RPiof+8rsXMzqesEKVm
         9vKegSZ3uDKi0FQgx2I1TA+Rw5Q7qE5ozr/F78YxDXMlCiJmdSvxq0x6MTo4S/PUchUM
         Bi48KTqqYdSs+3P6OaVZFzvLWS/vhc8E/oRLW09q1rn6iYSlaGDCubor6fG8LzPTegu0
         1H/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IEaLXczlGF6QiWh17Q0HZk+D3OpE/6hVdkCgSrs4VZk=;
        b=HXKO6Xv2tTTmJ8wtHhJcPB+2gCfJjvlzVz8lmIuvKOEHC98zABHrkjI8SbC/dHtg/Z
         UNKyR9AJ398Ke97bUfy0usgvXpbqc3HgHg5DJ1S0tG1q0+R8+z1t7rhYA3jSvhhiX6MZ
         OUA0Z6mr1jkNStFrYB8jnp+WaiyJlLEaj+MPNdDufTM6eA2yoZTBLDhmFwHilqpuluG9
         qjoVoH63Quqao7lvJmhWFEugaflvdb25vprZTyDZuJ/wTW60/q6/y4DyqQzTfH0gCnzG
         BPN2nP7sLgidAPNmnuWDoiDHk6eLLHf67jVW3obhDXnp1Hmc0A8b4seP6Q3UXmNlGOmZ
         a5jQ==
X-Gm-Message-State: AO0yUKVAlJ2q74lIAyM/4MLO45QmvMc2fGZYVPgR+J7JGMkdXuG7DeYQ
        lQYOV4ILll8+ZxMFbClxMk4SIh69BPDoeQ==
X-Google-Smtp-Source: AK7set++ljiFg3W6ae+m1ZcT+MCbDG9rNzhCAiMoGHIz7FBwEWxIZEvlb5Koq0PbmUrMbcXY6ILLTw==
X-Received: by 2002:a05:622a:1181:b0:3b9:bd28:bb80 with SMTP id m1-20020a05622a118100b003b9bd28bb80mr25170100qtk.15.1675548177238;
        Sat, 04 Feb 2023 14:02:57 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id dm40-20020a05620a1d6800b006fef61300fesm4423061qkb.16.2023.02.04.14.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 14:02:56 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>
Subject: [PATCH net-next 4/5] net: sched: move frag check and tc_skb_cb update out of handle_fragments
Date:   Sat,  4 Feb 2023 17:02:50 -0500
Message-Id: <5249cc943bcd7182453283ac17ca68cdc79e8676.1675548023.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1675548023.git.lucien.xin@gmail.com>
References: <cover.1675548023.git.lucien.xin@gmail.com>
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

This patch has no functional changes and just moves frag check and
tc_skb_cb update out of handle_fragments, to make it easier to move
the duplicate code from handle_fragments() into nf_conntrack_ovs later.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sched/act_ct.c | 71 +++++++++++++++++++++++++---------------------
 1 file changed, 39 insertions(+), 32 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 0a1ecc972a8b..9f133ed93815 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -778,29 +778,10 @@ static int tcf_ct_ipv6_is_fragment(struct sk_buff *skb, bool *frag)
 	return 0;
 }
 
-static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
-				   u8 family, u16 zone, bool *defrag)
+static int handle_fragments(struct net *net, struct sk_buff *skb,
+			    u16 zone, u8 family, u16 *mru)
 {
-	enum ip_conntrack_info ctinfo;
-	struct nf_conn *ct;
-	int err = 0;
-	bool frag;
-	u16 mru;
-
-	/* Previously seen (loopback)? Ignore. */
-	ct = nf_ct_get(skb, &ctinfo);
-	if ((ct && !nf_ct_is_template(ct)) || ctinfo == IP_CT_UNTRACKED)
-		return 0;
-
-	if (family == NFPROTO_IPV4)
-		err = tcf_ct_ipv4_is_fragment(skb, &frag);
-	else
-		err = tcf_ct_ipv6_is_fragment(skb, &frag);
-	if (err || !frag)
-		return err;
-
-	skb_get(skb);
-	mru = tc_skb_cb(skb)->mru;
+	int err;
 
 	if (family == NFPROTO_IPV4) {
 		enum ip_defrag_users user = IP_DEFRAG_CONNTRACK_IN + zone;
@@ -812,10 +793,8 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 		if (err && err != -EINPROGRESS)
 			return err;
 
-		if (!err) {
-			*defrag = true;
-			mru = IPCB(skb)->frag_max_size;
-		}
+		if (!err)
+			*mru = IPCB(skb)->frag_max_size;
 	} else { /* NFPROTO_IPV6 */
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
 		enum ip6_defrag_users user = IP6_DEFRAG_CONNTRACK_IN + zone;
@@ -825,18 +804,14 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 		if (err && err != -EINPROGRESS)
 			goto out_free;
 
-		if (!err) {
-			*defrag = true;
-			mru = IP6CB(skb)->frag_max_size;
-		}
+		if (!err)
+			*mru = IP6CB(skb)->frag_max_size;
 #else
 		err = -EOPNOTSUPP;
 		goto out_free;
 #endif
 	}
 
-	if (err != -EINPROGRESS)
-		tc_skb_cb(skb)->mru = mru;
 	skb_clear_hash(skb);
 	skb->ignore_df = 1;
 	return err;
@@ -846,6 +821,38 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 	return err;
 }
 
+static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
+				   u8 family, u16 zone, bool *defrag)
+{
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
+	int err = 0;
+	bool frag;
+	u16 mru;
+
+	/* Previously seen (loopback)? Ignore. */
+	ct = nf_ct_get(skb, &ctinfo);
+	if ((ct && !nf_ct_is_template(ct)) || ctinfo == IP_CT_UNTRACKED)
+		return 0;
+
+	if (family == NFPROTO_IPV4)
+		err = tcf_ct_ipv4_is_fragment(skb, &frag);
+	else
+		err = tcf_ct_ipv6_is_fragment(skb, &frag);
+	if (err || !frag)
+		return err;
+
+	skb_get(skb);
+	err = handle_fragments(net, skb, zone, family, &mru);
+	if (err)
+		return err;
+
+	*defrag = true;
+	tc_skb_cb(skb)->mru = mru;
+
+	return 0;
+}
+
 static void tcf_ct_params_free(struct tcf_ct_params *params)
 {
 	if (params->helper) {
-- 
2.31.1

