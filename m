Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6E6613A2A
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 16:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbiJaPgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 11:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbiJaPgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 11:36:17 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17B911838
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 08:36:14 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id z1so1928949qkl.9
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 08:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9wY3gSsexc1VgVHk2fH9vu+EKnpwXlKiD5+ZhfMgiPg=;
        b=YBtXnxkXz5tHp7pecGKVghIIJ1Bvxx/XLfPTW4UwSUl7I9kQeoVeHuCoRd1BlBQ1XG
         BP2kkmf+363LUQx5FEX69vJcTMlyY59WmmL+3X8k16emEx65Ree2vLXESLQ1eybWcK9D
         Lk7nDsJw4K2H6EFS8jdtetNPVGX/ny5CcZIikuLv5mlCC8fxPpXaPTMK15RccYkE28Bf
         +aNrsZedBEUPKggUh0xHFAs+e/L0Ge9QOjJwEvk/BF7a9ky/RV8vQFD5n30zLZe81iPT
         LU36DQ0Od/CVA2kUuY3MiE1CdwQhLeruRk9i0usS46zc5FCBXa72ci9KvUASYmYKT+eK
         +j5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9wY3gSsexc1VgVHk2fH9vu+EKnpwXlKiD5+ZhfMgiPg=;
        b=QxPgFr2aVQjwVngby+g1tBw8Zbp+HfqfwEvxRHyf3gdvGpQnn+RNmy9XXgEm1X6Jx4
         LAJr+ILwAzkr+fNKCxIaGOgqNgJQILxoiafZcEKyhVoCNIQP/8F2+UlcRfxjMCw5HLjz
         UYEmrx60gCQvwetN7y4e6pT/XsCmKejYFNxqlnX8ALGbgDu516d59rI9WO3wQGSH+Mks
         ecr56WsuvDyaU15H3wvGzMJCWl3r/3L9/tNlk2XqTGnxuNqwbKtRrkdiYn+dzrSzPQyK
         yNNeDrGKIbz3Q8Qx2hH8t3GaMHlVOoBbaEMqIc8Mkw0M2Mc+ziSzbkz6eX5Q2B4Y8pzN
         M23w==
X-Gm-Message-State: ACrzQf12VX5ityq9XL0MtAZVOHVSPecdA+aeB6MWAvbQHMTBzeHySlzJ
        9XCnt6WWXWs+sG1+5IsC5yaLo7uq+N9/Ng==
X-Google-Smtp-Source: AMsMyM4aLxq4o/vQ7R5MHHmgmT9QXj2EyeWPy6IiDsjPnh+IwjtwWKdzD/dxJ++KO4+H11B1hO9Xeg==
X-Received: by 2002:a05:620a:150c:b0:6fa:2c95:e4be with SMTP id i12-20020a05620a150c00b006fa2c95e4bemr4266332qkk.584.1667230573686;
        Mon, 31 Oct 2022 08:36:13 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id bi29-20020a05620a319d00b006f956766f76sm4957924qkb.1.2022.10.31.08.36.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 08:36:13 -0700 (PDT)
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
Subject: [PATCHv3 net-next 1/4] net: move the ct helper function to nf_conntrack_helper for ovs and tc
Date:   Mon, 31 Oct 2022 11:36:07 -0400
Message-Id: <77bf40ce177056d460cc7ed32ef4d19d1f7b5290.1667230381.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1667230381.git.lucien.xin@gmail.com>
References: <cover.1667230381.git.lucien.xin@gmail.com>
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

