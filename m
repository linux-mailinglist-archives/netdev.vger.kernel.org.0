Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 204D86017B1
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 21:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbiJQTb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 15:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiJQTbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 15:31:07 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF782792DC
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 12:30:07 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id mx8so8024787qvb.8
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 12:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9wY3gSsexc1VgVHk2fH9vu+EKnpwXlKiD5+ZhfMgiPg=;
        b=CS69dyF4+WvKilGViq7BFFpX4K8fzf/BqZdkFIrT8qMy2tzLI8zzVV8pzQ/ANgfJzZ
         O/aJ9qwRfl6bbyNkmwliq+OAK+XGvfklQ8wsXs+pg4IdRaI4vT/SHv9wZf97329CzSK5
         jvK7/cHrCR4C6z8aEUwshk5EtV34pUXpEcuBfWEGXeY/tso+G4PZMVfwxkPO91kdviHG
         3fWNs5+ZZoe/RrwQ63eHBIoouD0o3WOXalJg5/hmzjq8yC1qq0uI1EXX34k/nwSOttiY
         FuzjqQNacsljuDDOQ3njII0wdK7B5HnDRoffnLPXx4NRMtyi72/Mzr69dh/HcZlhA86O
         B5VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9wY3gSsexc1VgVHk2fH9vu+EKnpwXlKiD5+ZhfMgiPg=;
        b=8LKEwDOr0+r+rXwTcWCTGGQ/B2moqNI3FRiAInBjXH19ixxMu3tL1CCj7hY3cLcJ2I
         rJgFUEl05YfN0MJxa2/tZaG7Vg8Qp6TgpSXygYhNH39mXB1Sa+UjD9fXWfOoFfbzeSZl
         K9nw0Xui3AEPe8z64lWAjgpTfhJ/+ZqnavdQHv8OOSLFl9BCzyVZkO4zan6yHAMlm6/3
         LqFLJFo8LmLla3qsidOu58bISaM1Q+MyWQu73C3dju39/TefRQdI7D4YSMmRlEqH7h/o
         pQ6gFVscMJ01FDrUNVkkbP3Cg77zyODJrC7qpyOScmtK3XMkXW6rOZ5NCx4HB1IO+jWq
         6PtA==
X-Gm-Message-State: ACrzQf02GVc/7TEDy0nfqwLAuwwPDOFUxNCrONGKlSSGuLFIK2XkbODd
        URB1yJkAyKWgTqwgkv7q1h0sROl/K6PjZA==
X-Google-Smtp-Source: AMsMyM7Zc3wEbOVQyevRLpc0DTHyWcyzZIgMU0N4wHBGo0iM8lI39yJfxw1CCLkb4A89xlCFKjFC7A==
X-Received: by 2002:ad4:5d68:0:b0:4af:af07:580b with SMTP id fn8-20020ad45d68000000b004afaf07580bmr9373826qvb.14.1666034972627;
        Mon, 17 Oct 2022 12:29:32 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id x6-20020ac86b46000000b0035ba48c032asm423831qts.25.2022.10.17.12.29.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 12:29:32 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        ovs-dev@openvswitch.org
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
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Aaron Conole <aconole@redhat.com>
Subject: [PATCH net-next 1/4] net: move the ct helper function to nf_conntrack_helper for ovs and tc
Date:   Mon, 17 Oct 2022 15:29:25 -0400
Message-Id: <58b6aab35c6fc541b683a6aba9538c8d5b84b875.1666034595.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1666034595.git.lucien.xin@gmail.com>
References: <cover.1666034595.git.lucien.xin@gmail.com>
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

Move ovs_ct_helper from openvswitch to nf_conntrack_helper and rename
as nf_ct_helper so that it can be used in TC act_ct in the next patch.
Note that it also adds the checks for the family and proto, as in TC
act_ct, the packets with correct family and proto are not guaranteed.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/netfilter/nf_conntrack_helper.h |  2 +
 net/netfilter/nf_conntrack_helper.c         | 71 +++++++++++++++++++++
 net/openvswitch/conntrack.c                 | 61 +-----------------
 3 files changed, 74 insertions(+), 60 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 9939c366f720..6c32e59fc16f 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -115,6 +115,8 @@ struct nf_conn_help *nf_ct_helper_ext_add(struct nf_conn *ct, gfp_t gfp);
 int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 			      gfp_t flags);
 
+int nf_ct_helper(struct sk_buff *skb, u16 proto);
+
 void nf_ct_helper_destroy(struct nf_conn *ct);
 
 static inline struct nf_conn_help *nfct_help(const struct nf_conn *ct)
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index ff737a76052e..83615e479f87 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -26,7 +26,9 @@
 #include <net/netfilter/nf_conntrack_extend.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
+#include <net/netfilter/nf_conntrack_seqadj.h>
 #include <net/netfilter/nf_log.h>
+#include <net/ip.h>
 
 static DEFINE_MUTEX(nf_ct_helper_mutex);
 struct hlist_head *nf_ct_helper_hash __read_mostly;
@@ -240,6 +242,75 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 }
 EXPORT_SYMBOL_GPL(__nf_ct_try_assign_helper);
 
+/* 'skb' should already be pulled to nh_ofs. */
+int nf_ct_helper(struct sk_buff *skb, u16 proto)
+{
+	const struct nf_conntrack_helper *helper;
+	const struct nf_conn_help *help;
+	enum ip_conntrack_info ctinfo;
+	unsigned int protoff;
+	struct nf_conn *ct;
+	int err;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (!ct || ctinfo == IP_CT_RELATED_REPLY)
+		return NF_ACCEPT;
+
+	help = nfct_help(ct);
+	if (!help)
+		return NF_ACCEPT;
+
+	helper = rcu_dereference(help->helper);
+	if (!helper)
+		return NF_ACCEPT;
+
+	if (helper->tuple.src.l3num != NFPROTO_UNSPEC &&
+	    helper->tuple.src.l3num != proto)
+		return NF_ACCEPT;
+
+	switch (proto) {
+	case NFPROTO_IPV4:
+		protoff = ip_hdrlen(skb);
+		proto = ip_hdr(skb)->protocol;
+		break;
+	case NFPROTO_IPV6: {
+		u8 nexthdr = ipv6_hdr(skb)->nexthdr;
+		__be16 frag_off;
+		int ofs;
+
+		ofs = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &nexthdr,
+				       &frag_off);
+		if (ofs < 0 || (frag_off & htons(~0x7)) != 0) {
+			pr_debug("proto header not found\n");
+			return NF_ACCEPT;
+		}
+		protoff = ofs;
+		proto = nexthdr;
+		break;
+	}
+	default:
+		WARN_ONCE(1, "helper invoked on non-IP family!");
+		return NF_DROP;
+	}
+
+	if (helper->tuple.dst.protonum != proto)
+		return NF_ACCEPT;
+
+	err = helper->help(skb, protoff, ct, ctinfo);
+	if (err != NF_ACCEPT)
+		return err;
+
+	/* Adjust seqs after helper.  This is needed due to some helpers (e.g.,
+	 * FTP with NAT) adusting the TCP payload size when mangling IP
+	 * addresses and/or port numbers in the text-based control connection.
+	 */
+	if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) &&
+	    !nf_ct_seq_adjust(skb, ct, ctinfo, protoff))
+		return NF_DROP;
+	return NF_ACCEPT;
+}
+EXPORT_SYMBOL_GPL(nf_ct_helper);
+
 /* appropriate ct lock protecting must be taken by caller */
 static int unhelp(struct nf_conn *ct, void *me)
 {
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index c7b10234cf7c..19b5c54615c8 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -434,65 +434,6 @@ static int ovs_ct_set_labels(struct nf_conn *ct, struct sw_flow_key *key,
 	return 0;
 }
 
-/* 'skb' should already be pulled to nh_ofs. */
-static int ovs_ct_helper(struct sk_buff *skb, u16 proto)
-{
-	const struct nf_conntrack_helper *helper;
-	const struct nf_conn_help *help;
-	enum ip_conntrack_info ctinfo;
-	unsigned int protoff;
-	struct nf_conn *ct;
-	int err;
-
-	ct = nf_ct_get(skb, &ctinfo);
-	if (!ct || ctinfo == IP_CT_RELATED_REPLY)
-		return NF_ACCEPT;
-
-	help = nfct_help(ct);
-	if (!help)
-		return NF_ACCEPT;
-
-	helper = rcu_dereference(help->helper);
-	if (!helper)
-		return NF_ACCEPT;
-
-	switch (proto) {
-	case NFPROTO_IPV4:
-		protoff = ip_hdrlen(skb);
-		break;
-	case NFPROTO_IPV6: {
-		u8 nexthdr = ipv6_hdr(skb)->nexthdr;
-		__be16 frag_off;
-		int ofs;
-
-		ofs = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &nexthdr,
-				       &frag_off);
-		if (ofs < 0 || (frag_off & htons(~0x7)) != 0) {
-			pr_debug("proto header not found\n");
-			return NF_ACCEPT;
-		}
-		protoff = ofs;
-		break;
-	}
-	default:
-		WARN_ONCE(1, "helper invoked on non-IP family!");
-		return NF_DROP;
-	}
-
-	err = helper->help(skb, protoff, ct, ctinfo);
-	if (err != NF_ACCEPT)
-		return err;
-
-	/* Adjust seqs after helper.  This is needed due to some helpers (e.g.,
-	 * FTP with NAT) adusting the TCP payload size when mangling IP
-	 * addresses and/or port numbers in the text-based control connection.
-	 */
-	if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) &&
-	    !nf_ct_seq_adjust(skb, ct, ctinfo, protoff))
-		return NF_DROP;
-	return NF_ACCEPT;
-}
-
 /* Returns 0 on success, -EINPROGRESS if 'skb' is stolen, or other nonzero
  * value if 'skb' is freed.
  */
@@ -1038,7 +979,7 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
 		 */
 		if ((nf_ct_is_confirmed(ct) ? !cached || add_helper :
 					      info->commit) &&
-		    ovs_ct_helper(skb, info->family) != NF_ACCEPT) {
+		    nf_ct_helper(skb, info->family) != NF_ACCEPT) {
 			return -EINVAL;
 		}
 
-- 
2.31.1

