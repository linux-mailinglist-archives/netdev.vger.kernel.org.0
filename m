Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2397E4A9A73
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 14:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359158AbiBDN6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 08:58:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:50753 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1359114AbiBDN6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 08:58:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643983097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PWpGiu67AiC3oE0/d+SzQJxNJGhbryomvnZcmmvtbDs=;
        b=XTzXLqp3VfV6eSQnYC4Vp+xUDdeVRX15eToviKssZpfnuOp/ZcMQ9gmX1p3JtZ1F5DrkvQ
        VwAl8YSlUWV+SgMwh2Oa/zJ409qOOFT5ZN2DG31Fdsd3KhUa2kzh2aDNFcubsYjWNErjpD
        PdqnLHvmJdsHzxv7OGJlRcslMqW7OW4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-41-cFnxx8KCPQ-NZolYIBY8PQ-1; Fri, 04 Feb 2022 08:58:16 -0500
X-MC-Unique: cFnxx8KCPQ-NZolYIBY8PQ-1
Received: by mail-wr1-f71.google.com with SMTP id g17-20020adfa591000000b001da86c91c22so2063692wrc.5
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 05:58:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PWpGiu67AiC3oE0/d+SzQJxNJGhbryomvnZcmmvtbDs=;
        b=QQ8tCeGnEXwzTExkDkKSM7w+QoplJ10wkKrHJsM/CIrZbvj2ZxOeJZe4ATVwHJIUm2
         duwM+obGxTFf0hbJ+/mgoa5/AskIlZDjna1RAxrmmDEEiRBxtPOvPwNOxBMnaG/jsom2
         KDOb4QXoTFUnSlRtXJDrdQFN0D6A45rEzHpDlDfq9LQc4/y+xfaS0jXsI2vvavce4z3T
         9Pcc2Gi50Ef2QScfvYCmW+E5ATT3hdUHwwT1zEFT/F7VHFDnyRj4MbG6iXrWpt9/Mzgq
         B8QU7lIQo7UNGeuTx8Lsuss7g9xH6dDz3POh0nbOHy/5mV7LZE+mpq4tGpTNFCLZ2BZe
         2ttA==
X-Gm-Message-State: AOAM5307ZCF+MnHbTxKnoPFJaoPQ0DIAcGaYwl+6U/BaEqOl5ALSCF5y
        nG/f8ebi0TTQaWUS5l2vX2CpWnMGmBtJNlakmsLn98UALoqf+iLXqHJke3q9cmttanjTdZtT4G8
        y1N2aX0LF31XUYVy5
X-Received: by 2002:a05:600c:19ce:: with SMTP id u14mr2370018wmq.92.1643983094698;
        Fri, 04 Feb 2022 05:58:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz4+OfqDCsqaDt3ntATt5WQklrRMhtQlr+cjbb0SsYSl9Q+yfNo3bkBMxOst9TZqctPHUn0sA==
X-Received: by 2002:a05:600c:19ce:: with SMTP id u14mr2370003wmq.92.1643983094424;
        Fri, 04 Feb 2022 05:58:14 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id c13sm2049792wrv.24.2022.02.04.05.58.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 05:58:14 -0800 (PST)
Date:   Fri, 4 Feb 2022 14:58:11 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Russell Strong <russell@strong.id.au>,
        Dave Taht <dave.taht@gmail.com>
Subject: [PATCH net-next 1/4] ipv6: Define dscp_t and stop taking ECN bits
 into account in fib6-rules
Message-ID: <2b4f1d6045d8885cf70a113f194795cf3e1ef453.1643981839.git.gnault@redhat.com>
References: <cover.1643981839.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1643981839.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define a dscp_t type and its appropriate helpers that ensure ECN bits
are not taken into account when handling DSCP.

Use this new type to replace the tclass field of struct fib6_rule, so
that fib6-rules don't get influenced by ECN bits anymore.

Before this patch, fib6-rules didn't make any distinction between the
DSCP and ECN bits. Therefore, rules specifying a DSCP (tos or dsfield
options in iproute2) stopped working as soon a packets had at least one
of its ECN bits set (as a work around one could create four rules for
each DSCP value to match, one for each possible ECN value).

After this patch fib6-rules only compare the DSCP bits. ECN doesn't
influence the result anymore. Also, fib6-rules now must have the ECN
bits cleared or they will be rejected.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 include/net/inet_dscp.h                       | 57 +++++++++++++++++++
 include/net/ipv6.h                            |  6 ++
 net/ipv6/fib6_rules.c                         | 19 +++++--
 tools/testing/selftests/net/fib_rule_tests.sh | 30 +++++++++-
 4 files changed, 105 insertions(+), 7 deletions(-)
 create mode 100644 include/net/inet_dscp.h

diff --git a/include/net/inet_dscp.h b/include/net/inet_dscp.h
new file mode 100644
index 000000000000..72f250dffada
--- /dev/null
+++ b/include/net/inet_dscp.h
@@ -0,0 +1,57 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * inet_dscp.h: helpers for handling differentiated services codepoints (DSCP)
+ *
+ * DSCP is defined in RFC 2474:
+ *
+ *        0   1   2   3   4   5   6   7
+ *      +---+---+---+---+---+---+---+---+
+ *      |         DSCP          |  CU   |
+ *      +---+---+---+---+---+---+---+---+
+ *
+ *        DSCP: differentiated services codepoint
+ *        CU:   currently unused
+ *
+ * The whole DSCP + CU bits form the DS field.
+ * The DS field is also commonly called TOS or Traffic Class (for IPv6).
+ *
+ * Note: the CU bits are now used for Explicit Congestion Notification
+ *       (RFC 3168).
+ */
+
+#ifndef _INET_DSCP_H
+#define _INET_DSCP_H
+
+#include <linux/types.h>
+
+/* Special type for storing DSCP values.
+ *
+ * A dscp_t variable stores a DS field with the CU (ECN) bits cleared.
+ * Using dscp_t allows to strictly separate DSCP and ECN bits, thus avoiding
+ * bugs where ECN bits are erroneously taken into account during FIB lookups
+ * or policy routing.
+ *
+ * Note: to get the real DSCP value contained in a dscp_t variable one would
+ * have to do a bit shift after calling inet_dscp_to_dsfield(). We could have
+ * a helper for that, but there's currently no users.
+ */
+typedef u8 __bitwise dscp_t;
+
+#define INET_DSCP_MASK 0xfc
+
+static inline dscp_t inet_dsfield_to_dscp(__u8 dsfield)
+{
+	return (__force dscp_t)(dsfield & INET_DSCP_MASK);
+}
+
+static inline __u8 inet_dscp_to_dsfield(dscp_t dscp)
+{
+	return (__force __u8)dscp;
+}
+
+static inline bool inet_validate_dscp(__u8 val)
+{
+	return !(val & ~INET_DSCP_MASK);
+}
+
+#endif /* _INET_DSCP_H */
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 082f30256f59..3d898eb6df9c 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -18,6 +18,7 @@
 #include <net/ndisc.h>
 #include <net/flow.h>
 #include <net/flow_dissector.h>
+#include <net/inet_dscp.h>
 #include <net/snmp.h>
 #include <net/netns/hash.h>
 
@@ -975,6 +976,11 @@ static inline u8 ip6_tclass(__be32 flowinfo)
 	return ntohl(flowinfo & IPV6_TCLASS_MASK) >> IPV6_TCLASS_SHIFT;
 }
 
+static inline dscp_t ip6_dscp(__be32 flowinfo)
+{
+	return inet_dsfield_to_dscp(ip6_tclass(flowinfo));
+}
+
 static inline __be32 ip6_make_flowinfo(unsigned int tclass, __be32 flowlabel)
 {
 	return htonl(tclass << IPV6_TCLASS_SHIFT) | flowlabel;
diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
index ec029c86ae06..e2a7b0059669 100644
--- a/net/ipv6/fib6_rules.c
+++ b/net/ipv6/fib6_rules.c
@@ -16,6 +16,7 @@
 #include <linux/indirect_call_wrapper.h>
 
 #include <net/fib_rules.h>
+#include <net/inet_dscp.h>
 #include <net/ipv6.h>
 #include <net/addrconf.h>
 #include <net/ip6_route.h>
@@ -25,14 +26,14 @@ struct fib6_rule {
 	struct fib_rule		common;
 	struct rt6key		src;
 	struct rt6key		dst;
-	u8			tclass;
+	dscp_t			dscp;
 };
 
 static bool fib6_rule_matchall(const struct fib_rule *rule)
 {
 	struct fib6_rule *r = container_of(rule, struct fib6_rule, common);
 
-	if (r->dst.plen || r->src.plen || r->tclass)
+	if (r->dst.plen || r->src.plen || r->dscp)
 		return false;
 	return fib_rule_matchall(rule);
 }
@@ -323,7 +324,7 @@ INDIRECT_CALLABLE_SCOPE int fib6_rule_match(struct fib_rule *rule,
 			return 0;
 	}
 
-	if (r->tclass && r->tclass != ip6_tclass(fl6->flowlabel))
+	if (r->dscp && r->dscp != ip6_dscp(fl6->flowlabel))
 		return 0;
 
 	if (rule->ip_proto && (rule->ip_proto != fl6->flowi6_proto))
@@ -349,6 +350,13 @@ static int fib6_rule_configure(struct fib_rule *rule, struct sk_buff *skb,
 	struct net *net = sock_net(skb->sk);
 	struct fib6_rule *rule6 = (struct fib6_rule *) rule;
 
+	if (!inet_validate_dscp(frh->tos)) {
+		NL_SET_ERR_MSG(extack,
+			       "Invalid dsfield (tos): ECN bits must be 0");
+		goto errout;
+	}
+	rule6->dscp = inet_dsfield_to_dscp(frh->tos);
+
 	if (rule->action == FR_ACT_TO_TBL && !rule->l3mdev) {
 		if (rule->table == RT6_TABLE_UNSPEC) {
 			NL_SET_ERR_MSG(extack, "Invalid table");
@@ -369,7 +377,6 @@ static int fib6_rule_configure(struct fib_rule *rule, struct sk_buff *skb,
 
 	rule6->src.plen = frh->src_len;
 	rule6->dst.plen = frh->dst_len;
-	rule6->tclass = frh->tos;
 
 	if (fib_rule_requires_fldissect(rule))
 		net->ipv6.fib6_rules_require_fldissect++;
@@ -402,7 +409,7 @@ static int fib6_rule_compare(struct fib_rule *rule, struct fib_rule_hdr *frh,
 	if (frh->dst_len && (rule6->dst.plen != frh->dst_len))
 		return 0;
 
-	if (frh->tos && (rule6->tclass != frh->tos))
+	if (frh->tos && inet_dscp_to_dsfield(rule6->dscp) != frh->tos)
 		return 0;
 
 	if (frh->src_len &&
@@ -423,7 +430,7 @@ static int fib6_rule_fill(struct fib_rule *rule, struct sk_buff *skb,
 
 	frh->dst_len = rule6->dst.plen;
 	frh->src_len = rule6->src.plen;
-	frh->tos = rule6->tclass;
+	frh->tos = inet_dscp_to_dsfield(rule6->dscp);
 
 	if ((rule6->dst.plen &&
 	     nla_put_in6_addr(skb, FRA_DST, &rule6->dst.addr)) ||
diff --git a/tools/testing/selftests/net/fib_rule_tests.sh b/tools/testing/selftests/net/fib_rule_tests.sh
index 3b0489910422..d7a9ab3be1d3 100755
--- a/tools/testing/selftests/net/fib_rule_tests.sh
+++ b/tools/testing/selftests/net/fib_rule_tests.sh
@@ -114,10 +114,25 @@ fib_rule6_test_match_n_redirect()
 	log_test $? 0 "rule6 del by pref: $description"
 }
 
+fib_rule6_test_reject()
+{
+	local match="$1"
+	local rc
+
+	$IP -6 rule add $match table $RTABLE 2>/dev/null
+	rc=$?
+	log_test $rc 2 "rule6 check: $match"
+
+	if [ $rc -eq 0 ]; then
+		$IP -6 rule del $match table $RTABLE
+	fi
+}
+
 fib_rule6_test()
 {
 	local getmatch
 	local match
+	local cnt
 
 	# setup the fib rule redirect route
 	$IP -6 route add table $RTABLE default via $GW_IP6 dev $DEV onlink
@@ -128,8 +143,21 @@ fib_rule6_test()
 	match="from $SRC_IP6 iif $DEV"
 	fib_rule6_test_match_n_redirect "$match" "$match" "iif redirect to table"
 
+	# Reject dsfield (tos) options which have ECN bits set
+	for cnt in $(seq 1 3); do
+		match="dsfield $cnt"
+		fib_rule6_test_reject "$match"
+	done
+
+	# Don't take ECN bits into account when matching on dsfield
 	match="tos 0x10"
-	fib_rule6_test_match_n_redirect "$match" "$match" "tos redirect to table"
+	for cnt in "0x10" "0x11" "0x12" "0x13"; do
+		# Using option 'tos' instead of 'dsfield' as old iproute2
+		# versions don't support 'dsfield' in ip rule show.
+		getmatch="tos $cnt"
+		fib_rule6_test_match_n_redirect "$match" "$getmatch" \
+						"$getmatch redirect to table"
+	done
 
 	match="fwmark 0x64"
 	getmatch="mark 0x64"
-- 
2.21.3

