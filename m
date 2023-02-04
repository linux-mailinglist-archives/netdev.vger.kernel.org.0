Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8248568ACCB
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 23:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbjBDWDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 17:03:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjBDWDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 17:03:00 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D9B298D0
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 14:02:59 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id z5so9292431qtn.8
        for <netdev@vger.kernel.org>; Sat, 04 Feb 2023 14:02:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lVLqPum8MAWL3Q0UL7+myshM1ZzZXKg+sai+uYhGPQU=;
        b=XC6dCk6fbbIxjUvjosgPJZFs+ZyKBmOW5eq6H8yvX6d57NLj6Puouk25bv5eBhBWnH
         KUizGA7EUlNhGeH4r6HzC38XRyOdvK/GcWL0ByKqjn+nBQks5kxNdiL9YZuIdSpw/7Mh
         HuIRHwXuPPbSQ+W3UN+s+/Q5db/by7p3yHl2OMa7qH24zQYykYPlb1f2Xl3nVVAuoDvn
         aBX/mHgLbTlDg3MZDqv+xGaDogC4bphMEKl7XmUJP8eAFvF1wPDbmcy2yrwpAzKTqWsG
         R6wquRutMEr/oNYkf6oW57Utfmn0dgZSpHkFwFNsFZeKFy9h9iaC36KqK5akko/xpDeN
         EzzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lVLqPum8MAWL3Q0UL7+myshM1ZzZXKg+sai+uYhGPQU=;
        b=psxpbD/vzOR9qKuJUbM6Ikrb+MM2GIS2Iy8Gfymi4JMHzEHVOMdet1ZXpMJRBcM9ZW
         eRavjgeGPeBRy2EfsPIg68Txc/4h5Mznno1Cb6KSbMWuMTt/yZALcnKatf70SOV7BhNA
         27AZTQ9k5B6V1pZv3vAKOSses9DGeegqd6DfI6h1MULpdtSqODm8YrbedHg/nXMPEcV2
         Bw4Lh/87BzKHO99aFGMKM1Am2Lxh0l2l3CIK7UIrYRpqmHj2NjssugOmPATG868HtqrG
         M0lU8bWeU+DyMA1zuvae5dR0mPtQcOVzB0Nf+rcQuud9aHMn4Gsxj5TYUZ5OhYYld9C0
         mB9Q==
X-Gm-Message-State: AO0yUKXhRdCbBenPMaHcyF0KvhxwMUNh8PBjNU8p0bQ8eeYyxYWJe9nj
        YcB1JVqUcazgD+/71KnowTfEY35E+xofbQ==
X-Google-Smtp-Source: AK7set+7msUCiRqSPj7FwtPd9A9kvaC3UmXBiE9bIR5TVYdJY5mLGicIqfnGearEC62E8IF92yVozg==
X-Received: by 2002:ac8:7f4e:0:b0:3b8:6c8e:4f8d with SMTP id g14-20020ac87f4e000000b003b86c8e4f8dmr28496693qtk.68.1675548178252;
        Sat, 04 Feb 2023 14:02:58 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id dm40-20020a05620a1d6800b006fef61300fesm4423061qkb.16.2023.02.04.14.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 14:02:58 -0800 (PST)
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
Subject: [PATCH net-next 5/5] net: extract nf_ct_handle_fragments to nf_conntrack_ovs
Date:   Sat,  4 Feb 2023 17:02:51 -0500
Message-Id: <658ca267b02decd564d52139274a0076d164e312.1675548023.git.lucien.xin@gmail.com>
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

Now handle_fragments() in OVS and TC have the similar code, and
this patch removes the duplicate code by moving the function
to nf_conntrack_ovs.

Note that skb_clear_hash(skb) or skb->ignore_df = 1 should be
done only when defrag returns 0, as it does in other places
in kernel.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/netfilter/nf_conntrack.h |  2 ++
 net/netfilter/nf_conntrack_ovs.c     | 48 ++++++++++++++++++++++++++++
 net/openvswitch/conntrack.c          | 45 +-------------------------
 net/sched/act_ct.c                   | 46 ++------------------------
 4 files changed, 53 insertions(+), 88 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index a6e89d7212f8..7bbab8f2b73d 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -363,6 +363,8 @@ static inline struct nf_conntrack_net *nf_ct_pernet(const struct net *net)
 }
 
 int nf_ct_skb_network_trim(struct sk_buff *skb, int family);
+int nf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
+			   u16 zone, u8 family, u8 *proto, u16 *mru);
 
 #define NF_CT_STAT_INC(net, count)	  __this_cpu_inc((net)->ct.stat->count)
 #define NF_CT_STAT_INC_ATOMIC(net, count) this_cpu_inc((net)->ct.stat->count)
diff --git a/net/netfilter/nf_conntrack_ovs.c b/net/netfilter/nf_conntrack_ovs.c
index c60ef71d1aea..52b776bdf526 100644
--- a/net/netfilter/nf_conntrack_ovs.c
+++ b/net/netfilter/nf_conntrack_ovs.c
@@ -3,6 +3,8 @@
 
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_seqadj.h>
+#include <net/netfilter/ipv6/nf_defrag_ipv6.h>
+#include <net/ipv6_frag.h>
 #include <net/ip.h>
 
 /* 'skb' should already be pulled to nh_ofs. */
@@ -128,3 +130,49 @@ int nf_ct_skb_network_trim(struct sk_buff *skb, int family)
 	return pskb_trim_rcsum(skb, len);
 }
 EXPORT_SYMBOL_GPL(nf_ct_skb_network_trim);
+
+/* Returns 0 on success, -EINPROGRESS if 'skb' is stolen, or other nonzero
+ * value if 'skb' is freed.
+ */
+int nf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
+			   u16 zone, u8 family, u8 *proto, u16 *mru)
+{
+	int err;
+
+	if (family == NFPROTO_IPV4) {
+		enum ip_defrag_users user = IP_DEFRAG_CONNTRACK_IN + zone;
+
+		memset(IPCB(skb), 0, sizeof(struct inet_skb_parm));
+		local_bh_disable();
+		err = ip_defrag(net, skb, user);
+		local_bh_enable();
+		if (err)
+			return err;
+
+		*mru = IPCB(skb)->frag_max_size;
+#if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
+	} else if (family == NFPROTO_IPV6) {
+		enum ip6_defrag_users user = IP6_DEFRAG_CONNTRACK_IN + zone;
+
+		memset(IP6CB(skb), 0, sizeof(struct inet6_skb_parm));
+		err = nf_ct_frag6_gather(net, skb, user);
+		if (err) {
+			if (err != -EINPROGRESS)
+				kfree_skb(skb);
+			return err;
+		}
+
+		*proto = ipv6_hdr(skb)->nexthdr;
+		*mru = IP6CB(skb)->frag_max_size;
+#endif
+	} else {
+		kfree_skb(skb);
+		return -EPFNOSUPPORT;
+	}
+
+	skb_clear_hash(skb);
+	skb->ignore_df = 1;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nf_ct_handle_fragments);
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 962e2f70e597..5d40ad02cabc 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -434,56 +434,13 @@ static int ovs_ct_set_labels(struct nf_conn *ct, struct sw_flow_key *key,
 	return 0;
 }
 
-/* Returns 0 on success, -EINPROGRESS if 'skb' is stolen, or other nonzero
- * value if 'skb' is freed.
- */
-static int handle_fragments(struct net *net, struct sk_buff *skb,
-			    u16 zone, u8 family, u8 *proto, u16 *mru)
-{
-	int err;
-
-	if (family == NFPROTO_IPV4) {
-		enum ip_defrag_users user = IP_DEFRAG_CONNTRACK_IN + zone;
-
-		memset(IPCB(skb), 0, sizeof(struct inet_skb_parm));
-		err = ip_defrag(net, skb, user);
-		if (err)
-			return err;
-
-		*mru = IPCB(skb)->frag_max_size;
-#if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
-	} else if (family == NFPROTO_IPV6) {
-		enum ip6_defrag_users user = IP6_DEFRAG_CONNTRACK_IN + zone;
-
-		memset(IP6CB(skb), 0, sizeof(struct inet6_skb_parm));
-		err = nf_ct_frag6_gather(net, skb, user);
-		if (err) {
-			if (err != -EINPROGRESS)
-				kfree_skb(skb);
-			return err;
-		}
-
-		*proto = ipv6_hdr(skb)->nexthdr;
-		*mru = IP6CB(skb)->frag_max_size;
-#endif
-	} else {
-		kfree_skb(skb);
-		return -EPFNOSUPPORT;
-	}
-
-	skb_clear_hash(skb);
-	skb->ignore_df = 1;
-
-	return 0;
-}
-
 static int ovs_ct_handle_fragments(struct net *net, struct sw_flow_key *key,
 				   u16 zone, int family, struct sk_buff *skb)
 {
 	struct ovs_skb_cb ovs_cb = *OVS_CB(skb);
 	int err;
 
-	err = handle_fragments(net, skb, zone, family, &key->ip.proto, &ovs_cb.mru);
+	err = nf_ct_handle_fragments(net, skb, zone, family, &key->ip.proto, &ovs_cb.mru);
 	if (err)
 		return err;
 
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 9f133ed93815..9cc0bc7c71ed 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -778,49 +778,6 @@ static int tcf_ct_ipv6_is_fragment(struct sk_buff *skb, bool *frag)
 	return 0;
 }
 
-static int handle_fragments(struct net *net, struct sk_buff *skb,
-			    u16 zone, u8 family, u16 *mru)
-{
-	int err;
-
-	if (family == NFPROTO_IPV4) {
-		enum ip_defrag_users user = IP_DEFRAG_CONNTRACK_IN + zone;
-
-		memset(IPCB(skb), 0, sizeof(struct inet_skb_parm));
-		local_bh_disable();
-		err = ip_defrag(net, skb, user);
-		local_bh_enable();
-		if (err && err != -EINPROGRESS)
-			return err;
-
-		if (!err)
-			*mru = IPCB(skb)->frag_max_size;
-	} else { /* NFPROTO_IPV6 */
-#if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
-		enum ip6_defrag_users user = IP6_DEFRAG_CONNTRACK_IN + zone;
-
-		memset(IP6CB(skb), 0, sizeof(struct inet6_skb_parm));
-		err = nf_ct_frag6_gather(net, skb, user);
-		if (err && err != -EINPROGRESS)
-			goto out_free;
-
-		if (!err)
-			*mru = IP6CB(skb)->frag_max_size;
-#else
-		err = -EOPNOTSUPP;
-		goto out_free;
-#endif
-	}
-
-	skb_clear_hash(skb);
-	skb->ignore_df = 1;
-	return err;
-
-out_free:
-	kfree_skb(skb);
-	return err;
-}
-
 static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 				   u8 family, u16 zone, bool *defrag)
 {
@@ -828,6 +785,7 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 	struct nf_conn *ct;
 	int err = 0;
 	bool frag;
+	u8 proto;
 	u16 mru;
 
 	/* Previously seen (loopback)? Ignore. */
@@ -843,7 +801,7 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 		return err;
 
 	skb_get(skb);
-	err = handle_fragments(net, skb, zone, family, &mru);
+	err = nf_ct_handle_fragments(net, skb, zone, family, &proto, &mru);
 	if (err)
 		return err;
 
-- 
2.31.1

