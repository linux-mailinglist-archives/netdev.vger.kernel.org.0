Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E53F68ACC5
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 23:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232778AbjBDWC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 17:02:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjBDWC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 17:02:58 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3C828D02
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 14:02:55 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id x10so2298628qtr.2
        for <netdev@vger.kernel.org>; Sat, 04 Feb 2023 14:02:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FuDBrXU4+E45kmb8ZgGQqxxMM91AsT7CgRV8FYbNF0E=;
        b=b3Q6kMH75a5wr7M1oAYyHvqLzJn5+R4DajkXaf9OdbbPbIASROaPVI3YP8X+gk+09X
         8k1SIe1cou5q6qHpexEQznTerfDn9aoK2Mugp11dzTjjUrW6EgG6tVel6z0mKHPXqp4p
         LrWWcVRbCyW8HUn2jvGrC8/45oaQWS0uO+pcW4KGODiRlV8GVOlAX1oPNUYBqSRu/I6w
         9xMZiNuy8NUyGhl4Ui1PankjKpiqcpZfyMRCYcYrdXFIv3tuQuba6j5imLQOcjjAkvox
         CxRDEWB+Vt12Mln5nP8aYbuHpFk5UETBTVo+VaPMQKQkz/vVQEI606qCGml8FiFlzwwQ
         ZkaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FuDBrXU4+E45kmb8ZgGQqxxMM91AsT7CgRV8FYbNF0E=;
        b=p0vHHv2T/7CYTuwWpycP1J7+tmxIG/zlL6IqhdlzvIOk+Bb5LtMpEVAIPx2OUlBM4l
         qiVpEENEkD8Wh8DgHOuTiwoKGWNqjjnfmwPLU7jbNPvv/TxuVxLiq6N5ydl2JMIaYn5j
         GuB0FRWlfd/1JsGjQGr3wUS574kAlSwLhw83ehVckZ/PnpTY8W447GEq/U4iVT1my3os
         HCLyLg+TCwmUxqma9fe+d6uPMuovbGm2ZLvPn0cioTnn8LYJLOYiWOgmUa70m/wbo00F
         LTil/wHzZYFXgB82klHrBaOxohm/sB6q7aIfC7dMkbWZHCT3QxpKLqk4ZRn09QpVotNH
         Go4g==
X-Gm-Message-State: AO0yUKVI5BndZxoFJxcOKAnZRrL/KsivBUU7IhpsqKgXTBbtoBsZNTAb
        +9mC9AKfSagn/6RqSbTJ2htg4zm093M=
X-Google-Smtp-Source: AK7set8hOZ26cyHW+ZRtslyPGoKiQMYiVPjtwj1goH8BsrTzHyyDC8RP/m3Cm35Ct+GU+Eq6Ebg0wg==
X-Received: by 2002:a05:622a:207:b0:3b6:30dd:d472 with SMTP id b7-20020a05622a020700b003b630ddd472mr22135338qtx.44.1675548174180;
        Sat, 04 Feb 2023 14:02:54 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id dm40-20020a05620a1d6800b006fef61300fesm4423061qkb.16.2023.02.04.14.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 14:02:53 -0800 (PST)
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
Subject: [PATCH net-next 1/5] net: create nf_conntrack_ovs for ovs and tc use
Date:   Sat,  4 Feb 2023 17:02:47 -0500
Message-Id: <6eca3cf10a8c06f733fac943bcb997c06ec5daa3.1675548023.git.lucien.xin@gmail.com>
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

Similar to nf_nat_ovs created by Commit ebddb1404900 ("net: move the
nat function to nf_nat_ovs for ovs and tc"), this patch is to create
nf_conntrack_ovs to get these functions shared by OVS and TC only.

There are nf_ct_helper() and nf_ct_add_helper() from nf_conntrak_helper
in this patch, and will be more in the following patches.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/netfilter/Kconfig               |   6 ++
 net/netfilter/Makefile              |   1 +
 net/netfilter/nf_conntrack_helper.c |  98 --------------------------
 net/netfilter/nf_conntrack_ovs.c    | 104 ++++++++++++++++++++++++++++
 net/openvswitch/Kconfig             |   1 +
 net/sched/Kconfig                   |   1 +
 6 files changed, 113 insertions(+), 98 deletions(-)
 create mode 100644 net/netfilter/nf_conntrack_ovs.c

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index f71b41c7ce2f..645664f462e5 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -189,6 +189,12 @@ config NF_CONNTRACK_LABELS
 	  to connection tracking entries.  It can be used with xtables connlabel
 	  match and the nftables ct expression.
 
+config NF_CONNTRACK_OVS
+	bool "Connection tracking for openvswitch"
+	help
+	  This option enables support for openvswitch.  It can be used by
+	  openvswitch and tc conntrack.
+
 config NF_CT_PROTO_DCCP
 	bool 'DCCP protocol connection tracking support'
 	depends on NETFILTER_ADVANCED
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index ba2a6b5e93d9..5ffef1cd6143 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -11,6 +11,7 @@ nf_conntrack-$(CONFIG_NF_CONNTRACK_TIMEOUT) += nf_conntrack_timeout.o
 nf_conntrack-$(CONFIG_NF_CONNTRACK_TIMESTAMP) += nf_conntrack_timestamp.o
 nf_conntrack-$(CONFIG_NF_CONNTRACK_EVENTS) += nf_conntrack_ecache.o
 nf_conntrack-$(CONFIG_NF_CONNTRACK_LABELS) += nf_conntrack_labels.o
+nf_conntrack-$(CONFIG_NF_CONNTRACK_OVS) += nf_conntrack_ovs.o
 nf_conntrack-$(CONFIG_NF_CT_PROTO_DCCP) += nf_conntrack_proto_dccp.o
 nf_conntrack-$(CONFIG_NF_CT_PROTO_SCTP) += nf_conntrack_proto_sctp.o
 nf_conntrack-$(CONFIG_NF_CT_PROTO_GRE) += nf_conntrack_proto_gre.o
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 48ea6d0264b5..0c4db2f2ac43 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -242,104 +242,6 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 }
 EXPORT_SYMBOL_GPL(__nf_ct_try_assign_helper);
 
-/* 'skb' should already be pulled to nh_ofs. */
-int nf_ct_helper(struct sk_buff *skb, struct nf_conn *ct,
-		 enum ip_conntrack_info ctinfo, u16 proto)
-{
-	const struct nf_conntrack_helper *helper;
-	const struct nf_conn_help *help;
-	unsigned int protoff;
-	int err;
-
-	if (ctinfo == IP_CT_RELATED_REPLY)
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
-	if (helper->tuple.src.l3num != NFPROTO_UNSPEC &&
-	    helper->tuple.src.l3num != proto)
-		return NF_ACCEPT;
-
-	switch (proto) {
-	case NFPROTO_IPV4:
-		protoff = ip_hdrlen(skb);
-		proto = ip_hdr(skb)->protocol;
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
-		proto = nexthdr;
-		break;
-	}
-	default:
-		WARN_ONCE(1, "helper invoked on non-IP family!");
-		return NF_DROP;
-	}
-
-	if (helper->tuple.dst.protonum != proto)
-		return NF_ACCEPT;
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
-EXPORT_SYMBOL_GPL(nf_ct_helper);
-
-int nf_ct_add_helper(struct nf_conn *ct, const char *name, u8 family,
-		     u8 proto, bool nat, struct nf_conntrack_helper **hp)
-{
-	struct nf_conntrack_helper *helper;
-	struct nf_conn_help *help;
-	int ret = 0;
-
-	helper = nf_conntrack_helper_try_module_get(name, family, proto);
-	if (!helper)
-		return -EINVAL;
-
-	help = nf_ct_helper_ext_add(ct, GFP_KERNEL);
-	if (!help) {
-		nf_conntrack_helper_put(helper);
-		return -ENOMEM;
-	}
-#if IS_ENABLED(CONFIG_NF_NAT)
-	if (nat) {
-		ret = nf_nat_helper_try_module_get(name, family, proto);
-		if (ret) {
-			nf_conntrack_helper_put(helper);
-			return ret;
-		}
-	}
-#endif
-	rcu_assign_pointer(help->helper, helper);
-	*hp = helper;
-	return ret;
-}
-EXPORT_SYMBOL_GPL(nf_ct_add_helper);
-
 /* appropriate ct lock protecting must be taken by caller */
 static int unhelp(struct nf_conn *ct, void *me)
 {
diff --git a/net/netfilter/nf_conntrack_ovs.c b/net/netfilter/nf_conntrack_ovs.c
new file mode 100644
index 000000000000..eff4d53f8b8c
--- /dev/null
+++ b/net/netfilter/nf_conntrack_ovs.c
@@ -0,0 +1,104 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Support ct functions for openvswitch and used by OVS and TC conntrack. */
+
+#include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_seqadj.h>
+#include <net/ip.h>
+
+/* 'skb' should already be pulled to nh_ofs. */
+int nf_ct_helper(struct sk_buff *skb, struct nf_conn *ct,
+		 enum ip_conntrack_info ctinfo, u16 proto)
+{
+	const struct nf_conntrack_helper *helper;
+	const struct nf_conn_help *help;
+	unsigned int protoff;
+	int err;
+
+	if (ctinfo == IP_CT_RELATED_REPLY)
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
+int nf_ct_add_helper(struct nf_conn *ct, const char *name, u8 family,
+		     u8 proto, bool nat, struct nf_conntrack_helper **hp)
+{
+	struct nf_conntrack_helper *helper;
+	struct nf_conn_help *help;
+	int ret = 0;
+
+	helper = nf_conntrack_helper_try_module_get(name, family, proto);
+	if (!helper)
+		return -EINVAL;
+
+	help = nf_ct_helper_ext_add(ct, GFP_KERNEL);
+	if (!help) {
+		nf_conntrack_helper_put(helper);
+		return -ENOMEM;
+	}
+#if IS_ENABLED(CONFIG_NF_NAT)
+	if (nat) {
+		ret = nf_nat_helper_try_module_get(name, family, proto);
+		if (ret) {
+			nf_conntrack_helper_put(helper);
+			return ret;
+		}
+	}
+#endif
+	rcu_assign_pointer(help->helper, helper);
+	*hp = helper;
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nf_ct_add_helper);
diff --git a/net/openvswitch/Kconfig b/net/openvswitch/Kconfig
index 747d537a3f06..5863b0016192 100644
--- a/net/openvswitch/Kconfig
+++ b/net/openvswitch/Kconfig
@@ -15,6 +15,7 @@ config OPENVSWITCH
 	select NET_MPLS_GSO
 	select DST_CACHE
 	select NET_NSH
+	select NF_CONNTRACK_OVS if NF_NF_CONNTRACK
 	select NF_NAT_OVS if NF_NAT
 	help
 	  Open vSwitch is a multilayer Ethernet switch targeted at virtualized
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index de18a0dda6df..ae40f9e39b4f 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -977,6 +977,7 @@ config NET_ACT_TUNNEL_KEY
 config NET_ACT_CT
 	tristate "connection tracking tc action"
 	depends on NET_CLS_ACT && NF_CONNTRACK && (!NF_NAT || NF_NAT) && NF_FLOW_TABLE
+	select NF_CONNTRACK_OVS
 	select NF_NAT_OVS if NF_NAT
 	help
 	  Say Y here to allow sending the packets to conntrack module.
-- 
2.31.1

