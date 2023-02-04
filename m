Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D57368ACC7
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 23:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233203AbjBDWDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 17:03:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232699AbjBDWC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 17:02:58 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B0416AF2
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 14:02:56 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id m26so9283683qtp.9
        for <netdev@vger.kernel.org>; Sat, 04 Feb 2023 14:02:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=79Ovqe76w/JYL9kRl2YoGLdQuqI8hAu0+om6jffVsHE=;
        b=na5cYYWsnipoxhrsya9pMYMPEj9e4BOVpLWsPaDfM5RKavCfZbLePqBXTk0HPfe/JX
         asKo6yi2NXX9QoMsfD2zIxMjoOyWEOSJxrQm1hOPBUCQ1RZ1N80OdnjqKyS9/5v8/TqV
         1Zi5Wn7xYjw1m8VwUFcyLYpx3lmCXqqR9fh+rLZEFCD5ZrjeFTgnM9ZZkZmVCxHzopSX
         G0kOpZC7Zd8l1n+lsGmwnpXsBkc5DDPv2Wj5+ZA4DptPbDHRYdh/tNQP3wh5dPAuzPIL
         Yncju/9yfrdxpQztBHFVqSLGgTovt7JP6m9PuUrM5r0uLJh/IN1ugunAz1ZCOYCcCZsV
         vWdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=79Ovqe76w/JYL9kRl2YoGLdQuqI8hAu0+om6jffVsHE=;
        b=onVgATMB16BbcfKuaYVwPAaHUYAHfEB3sdq7nsyfr2OI8+Vrqva2krJmu1W8jFMCHO
         uDVfU87HMnt3ilsWLeG3FXbE2oYoxhJGbTYHYTSPNHKwJud7qx2m4hMoBPT09rvj3S7C
         RRGSYr7OcbjsqOliJ/xv0fpHC0rsAxMa9hTqbyZtQftmZcxmKB8RgQK1tDwqn4pP5suH
         jf4DSXe6wCIdVUTxoFMNoxRqI3e6+NLmm0jZNVr5B+4gdlp2XjHi5cJmgdTTpFNvLaOX
         u9BzOB3X7BU6dMBpgdB7qhIFM7nSirHZfWtIpxtqFD+v/zQn8W3uZIEfEi4YURZxnBYD
         FyCg==
X-Gm-Message-State: AO0yUKXvqN6+E+QeuPpkAR+LcA09VBfozoZXvm0KYUea/aC7VMnB0UKh
        IzzxhtYEwdQdPvN1w283zRR7Jx5A6u1BTQ==
X-Google-Smtp-Source: AK7set+glAJ6NTReAvqrbA54SZRDRWlK7PzMh6VNCgGiZ/f3++DIEfEjY/Gnj48j/hbJ/DDG3eTgtA==
X-Received: by 2002:ac8:5f8e:0:b0:3b9:e2a6:cb0b with SMTP id j14-20020ac85f8e000000b003b9e2a6cb0bmr18038316qta.12.1675548176206;
        Sat, 04 Feb 2023 14:02:56 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id dm40-20020a05620a1d6800b006fef61300fesm4423061qkb.16.2023.02.04.14.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 14:02:55 -0800 (PST)
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
Subject: [PATCH net-next 3/5] openvswitch: move key and ovs_cb update out of handle_fragments
Date:   Sat,  4 Feb 2023 17:02:49 -0500
Message-Id: <cc0b888a0284dea4a20dd50a5c5614c67ccff4df.1675548023.git.lucien.xin@gmail.com>
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

This patch has no functional changes and just moves key and ovs_cb update
out of handle_fragments, and skb_clear_hash() and skb->ignore_df change
into handle_fragments(), to make it easier to move the duplicate code
from handle_fragments() into nf_conntrack_ovs later.

Note that it changes to pass info->family to handle_fragments() instead
of key for the packet type check, as info->family is set according to
key->eth.type in ovs_ct_copy_action() when creating the action.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/openvswitch/conntrack.c | 37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 47a58657b1e4..962e2f70e597 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -437,13 +437,12 @@ static int ovs_ct_set_labels(struct nf_conn *ct, struct sw_flow_key *key,
 /* Returns 0 on success, -EINPROGRESS if 'skb' is stolen, or other nonzero
  * value if 'skb' is freed.
  */
-static int handle_fragments(struct net *net, struct sw_flow_key *key,
-			    u16 zone, struct sk_buff *skb)
+static int handle_fragments(struct net *net, struct sk_buff *skb,
+			    u16 zone, u8 family, u8 *proto, u16 *mru)
 {
-	struct ovs_skb_cb ovs_cb = *OVS_CB(skb);
 	int err;
 
-	if (key->eth.type == htons(ETH_P_IP)) {
+	if (family == NFPROTO_IPV4) {
 		enum ip_defrag_users user = IP_DEFRAG_CONNTRACK_IN + zone;
 
 		memset(IPCB(skb), 0, sizeof(struct inet_skb_parm));
@@ -451,9 +450,9 @@ static int handle_fragments(struct net *net, struct sw_flow_key *key,
 		if (err)
 			return err;
 
-		ovs_cb.mru = IPCB(skb)->frag_max_size;
+		*mru = IPCB(skb)->frag_max_size;
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
-	} else if (key->eth.type == htons(ETH_P_IPV6)) {
+	} else if (family == NFPROTO_IPV6) {
 		enum ip6_defrag_users user = IP6_DEFRAG_CONNTRACK_IN + zone;
 
 		memset(IP6CB(skb), 0, sizeof(struct inet6_skb_parm));
@@ -464,22 +463,35 @@ static int handle_fragments(struct net *net, struct sw_flow_key *key,
 			return err;
 		}
 
-		key->ip.proto = ipv6_hdr(skb)->nexthdr;
-		ovs_cb.mru = IP6CB(skb)->frag_max_size;
+		*proto = ipv6_hdr(skb)->nexthdr;
+		*mru = IP6CB(skb)->frag_max_size;
 #endif
 	} else {
 		kfree_skb(skb);
 		return -EPFNOSUPPORT;
 	}
 
+	skb_clear_hash(skb);
+	skb->ignore_df = 1;
+
+	return 0;
+}
+
+static int ovs_ct_handle_fragments(struct net *net, struct sw_flow_key *key,
+				   u16 zone, int family, struct sk_buff *skb)
+{
+	struct ovs_skb_cb ovs_cb = *OVS_CB(skb);
+	int err;
+
+	err = handle_fragments(net, skb, zone, family, &key->ip.proto, &ovs_cb.mru);
+	if (err)
+		return err;
+
 	/* The key extracted from the fragment that completed this datagram
 	 * likely didn't have an L4 header, so regenerate it.
 	 */
 	ovs_flow_key_update_l3l4(skb, key);
-
 	key->ip.frag = OVS_FRAG_TYPE_NONE;
-	skb_clear_hash(skb);
-	skb->ignore_df = 1;
 	*OVS_CB(skb) = ovs_cb;
 
 	return 0;
@@ -1111,7 +1123,8 @@ int ovs_ct_execute(struct net *net, struct sk_buff *skb,
 	}
 
 	if (key->ip.frag != OVS_FRAG_TYPE_NONE) {
-		err = handle_fragments(net, key, info->zone.id, skb);
+		err = ovs_ct_handle_fragments(net, key, info->zone.id,
+					      info->family, skb);
 		if (err)
 			return err;
 	}
-- 
2.31.1

