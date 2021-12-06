Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C84146A3EA
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 19:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346465AbhLFSZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 13:25:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43237 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345823AbhLFSZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 13:25:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638814930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RZkFdHmlIbhrNvUnEjpWtl+zx8wCdUbbYsIx13CR0fo=;
        b=SYK2A0L5hdsx0Rr9beKS5MEBL8b1wirVqoknesRV/4J5F4gcE+iwT8l6cDUTMyuP1MEW4H
        ACxgg5RNbeutOM6Iac7ovccX8Gw5XY7cW5EIjItIJQxm8cBSzM3cLFFweAMmKwi/w/ImLo
        X1yxTWTb6M02cyWFOE+wqNkayD/XjXg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-274-GxQlyT_ZOyCviCNmspsEdA-1; Mon, 06 Dec 2021 13:22:09 -0500
X-MC-Unique: GxQlyT_ZOyCviCNmspsEdA-1
Received: by mail-wm1-f69.google.com with SMTP id 138-20020a1c0090000000b00338bb803204so6485684wma.1
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 10:22:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RZkFdHmlIbhrNvUnEjpWtl+zx8wCdUbbYsIx13CR0fo=;
        b=jtoxPdFSbWdQPJD1S7lySK2Kc+bUsryyWt5sLvYxmsyY3zEY9FPgQIca/vLuzEgfNw
         cPzYeM0LAZSYSNOFp7CLVWaeiO7BjhKO1emaCgQ9LdRso2vlRe1qAuh8Cc0WmY/MgVh6
         sR/LEgzgJj5Rxn79FqE0FFsKqp3PASCUrfF7LBHB9BdpbnuF3ce221VMC3135iwYglXW
         nMvFhE6lCHF4RZsvjEavW11RlNRCo2qjrTmg+ogQ1L5Bj1xI84JjPuti3Go6ttoqn3q3
         W7tU1t8Qbidq0xFb1UmMo52hs0v8P57Vn62Y76kRCw1JJWsIXiY1E5CzFlZRM3wbXCu5
         HXVg==
X-Gm-Message-State: AOAM531AnynpLLUiQYeYj9VhSdCG3euZ6CBUbikA6KiQF62tAjg7Wwos
        DCZ0frrelxJu9s0LDfI2zOKJHa0jyMddI835LRTZlbjT9mhGKJZkUnqG5n/+KAvZz4LCkfnOAxK
        /Ia4lSJmFYQyCtiOS
X-Received: by 2002:a5d:5445:: with SMTP id w5mr46351353wrv.163.1638814928510;
        Mon, 06 Dec 2021 10:22:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwTXVCZom8L/68AuKHIUjvvTz9GaoveM9Kqr23ffl9Fq8a9Iha37VDsGcNvh1ExEQ/BMsvHfQ==
X-Received: by 2002:a5d:5445:: with SMTP id w5mr46351331wrv.163.1638814928334;
        Mon, 06 Dec 2021 10:22:08 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id c10sm13629701wrb.81.2021.12.06.10.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 10:22:07 -0800 (PST)
Date:   Mon, 6 Dec 2021 19:22:06 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Russell Strong <russell@strong.id.au>
Subject: [PATCH net-next 1/4] ipv6: Define dscp_t and stop taking ECN bits
 into account in ip6-rules
Message-ID: <7430f57f0949081f54e633c69f2800ae577e8605.1638814614.git.gnault@redhat.com>
References: <cover.1638814614.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1638814614.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define a dscp_t type and its appropriate helpers that ensure ECN bits
are not taken into account when handling DSCP.

Use this new type to replace the tclass field of fib6_rule, so that
ip6-rules don't get influenced by ECN bits anymore.

Before this patch, ip6-rules didn't make any distinction between the
DSCP and ECN bits. Therefore, rules specifying a DSCP (tos or dsfield
options in iproute2) stopped working as soon a packets had at least one
of its ECN bits set (as a work around one could create four rules for
each DSCP value to match, one for each possible ECN value).

After this patch ip6-rules only compare the DSCP bits. ECN doesn't
influence the result anymore. Also, ip6-rules now must have the ECN
bits cleared or they will be rejected.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 include/net/inet_dscp.h | 54 +++++++++++++++++++++++++++++++++++++++++
 include/net/ipv6.h      |  6 +++++
 net/ipv6/fib6_rules.c   | 18 +++++++++-----
 3 files changed, 72 insertions(+), 6 deletions(-)
 create mode 100644 include/net/inet_dscp.h

diff --git a/include/net/inet_dscp.h b/include/net/inet_dscp.h
new file mode 100644
index 000000000000..e7f7e182529c
--- /dev/null
+++ b/include/net/inet_dscp.h
@@ -0,0 +1,54 @@
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
+ * A dscp_t variable stores a DSCP value, without the CU (or ECN) bits.
+ * Using dscp_t allows to strictly separate DSCP and ECN bits, thus avoid bugs
+ * where ECN bits are erroneously taken into account during FIB lookups or
+ * policy routing.
+ */
+typedef u8 __bitwise dscp_t;
+
+#define INET_DSCP_MASK 0xfc
+#define INET_DSCP_SHIFT 2
+
+static inline dscp_t inet_dsfield_to_dscp(__u8 dsfield)
+{
+	return (__force dscp_t)(dsfield >> INET_DSCP_SHIFT);
+}
+
+static inline __u8 inet_dscp_to_dsfield(dscp_t dscp)
+{
+	return (__force __u8)dscp << INET_DSCP_SHIFT;
+}
+
+static inline bool inet_validate_dscp(__u8 val)
+{
+	return !(val & ~INET_DSCP_MASK);
+}
+
+#endif /* _INET_DSCP_H */
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 53ac7707ca70..3a457db7a4f6 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -18,6 +18,7 @@
 #include <net/ndisc.h>
 #include <net/flow.h>
 #include <net/flow_dissector.h>
+#include <net/inet_dscp.h>
 #include <net/snmp.h>
 #include <net/netns/hash.h>
 
@@ -965,6 +966,11 @@ static inline u8 ip6_tclass(__be32 flowinfo)
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
index dcedfe29d9d9..82d95d00214c 100644
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
@@ -353,6 +354,12 @@ static int fib6_rule_configure(struct fib_rule *rule, struct sk_buff *skb,
 	struct net *net = sock_net(skb->sk);
 	struct fib6_rule *rule6 = (struct fib6_rule *) rule;
 
+	if (!inet_validate_dscp(frh->tos)) {
+		NL_SET_ERR_MSG(extack, "Invalid dsfield (tos): ECN bits must be 0");
+		goto errout;
+	}
+	rule6->dscp = inet_dsfield_to_dscp(frh->tos);
+
 	if (rule->action == FR_ACT_TO_TBL && !rule->l3mdev) {
 		if (rule->table == RT6_TABLE_UNSPEC) {
 			NL_SET_ERR_MSG(extack, "Invalid table");
@@ -373,7 +380,6 @@ static int fib6_rule_configure(struct fib_rule *rule, struct sk_buff *skb,
 
 	rule6->src.plen = frh->src_len;
 	rule6->dst.plen = frh->dst_len;
-	rule6->tclass = frh->tos;
 
 	if (fib_rule_requires_fldissect(rule))
 		net->ipv6.fib6_rules_require_fldissect++;
@@ -406,7 +412,7 @@ static int fib6_rule_compare(struct fib_rule *rule, struct fib_rule_hdr *frh,
 	if (frh->dst_len && (rule6->dst.plen != frh->dst_len))
 		return 0;
 
-	if (frh->tos && (rule6->tclass != frh->tos))
+	if (frh->tos && inet_dscp_to_dsfield(rule6->dscp) != frh->tos)
 		return 0;
 
 	if (frh->src_len &&
@@ -427,7 +433,7 @@ static int fib6_rule_fill(struct fib_rule *rule, struct sk_buff *skb,
 
 	frh->dst_len = rule6->dst.plen;
 	frh->src_len = rule6->src.plen;
-	frh->tos = rule6->tclass;
+	frh->tos = inet_dscp_to_dsfield(rule6->dscp);
 
 	if ((rule6->dst.plen &&
 	     nla_put_in6_addr(skb, FRA_DST, &rule6->dst.addr)) ||
-- 
2.21.3

