Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 846BF4A9A75
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 14:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359161AbiBDN6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 08:58:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:49907 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1359155AbiBDN6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 08:58:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643983099;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MBMyk3IZsR5ozoJLuOW+sHZ0Vu+57g26uCSnHB4yqHg=;
        b=RmWj8lULiS3JwegvZMNYJFj1sxEqzvUVCAkJtbD6aHTO6qHIbswmy7pyIAoK5G1r9aZpa+
        U105yEcMDs5Gf0vdYO8TDU+Y88tN6z1mM6X3fL7nVXNYffeP8qcrkGw9q03QR7YGi9k+nd
        jQMzmeKds21n2DJSXC1ee7aNJ7ASpoA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-373-Bsz1aEktM8-rg8CE3E__gQ-1; Fri, 04 Feb 2022 08:58:18 -0500
X-MC-Unique: Bsz1aEktM8-rg8CE3E__gQ-1
Received: by mail-wr1-f71.google.com with SMTP id s17-20020adf9791000000b001e274a1233bso2010518wrb.2
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 05:58:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MBMyk3IZsR5ozoJLuOW+sHZ0Vu+57g26uCSnHB4yqHg=;
        b=21ZQ5MQHbemSnHTfelbgRJBV7/0JIi4OET1VNfLXaaFnGQIsxzQoMiwpmqwy6nVcS9
         8Br1dxSm+nzCNPP0cpa6G+p0n8Vjz67ELAZGKTms/q8nbDyMbr8Km39SBKz5Vh8/gFch
         3UMRH3qRelVjVQZLjzP6qibUqcJg6c1lWvV9gEGwvZJCf/EIYZRcQ5sTXWaSRESdworr
         FpEvIRNuUoU2loOsuX19uWcR1VTMK+ZW/dW7+D4q2/7WxpFwm3D2Hu4Mmy/iRimat4sE
         OKGaMrN4qAkHLMNCmXl3dmI314bh/Pr/GSnNrrunUEMP2/fxuK5k0nSkQTFHTegyS9/f
         FUdg==
X-Gm-Message-State: AOAM533yMOwHddOCD4Q8ir/qEaJUURypYdNIGy2zW2FtA4CmfzBiw/yX
        mzNecsdCxFTEK7LRdU4aeYbbdjMEImDSX5NdACCf/SGQRpdIPh/dk2p+O1yI7PVwCZbAY9RyCbt
        fSRz/9fIVRd8F0Way
X-Received: by 2002:a05:6000:25c:: with SMTP id m28mr2505936wrz.511.1643983096746;
        Fri, 04 Feb 2022 05:58:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxwFnp0E5TKW9qae8qOTeJ2DC4Arzk0wVFQek4amDQpq4oIdfQziIY2s9OwcMQeIpq8RT1BUQ==
X-Received: by 2002:a05:6000:25c:: with SMTP id m28mr2505922wrz.511.1643983096587;
        Fri, 04 Feb 2022 05:58:16 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id bg26sm10366044wmb.48.2022.02.04.05.58.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 05:58:16 -0800 (PST)
Date:   Fri, 4 Feb 2022 14:58:14 +0100
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
Subject: [PATCH net-next 2/4] ipv4: Stop taking ECN bits into account in
 fib4-rules
Message-ID: <706ed5f33756ea0989373f1e312e248095d458d5.1643981839.git.gnault@redhat.com>
References: <cover.1643981839.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1643981839.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new dscp_t type to replace the tos field of struct fib4_rule,
so that fib4-rules consistently ignore ECN bits.

Before this patch, fib4-rules did accept rules with the high order ECN
bit set (but not the low order one). Also, it relied on its callers
masking the ECN bits of ->flowi4_tos to prevent those from influencing
the result. This was brittle and a few call paths still do the lookup
without masking the ECN bits first.

After this patch fib4-rules only compare the DSCP bits. ECN can't
influence the result anymore, even if the caller didn't mask these
bits. Also, fib4-rules now must have both ECN bits cleared or they will
be rejected.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/ipv4/fib_rules.c                          | 18 ++++++-----
 tools/testing/selftests/net/fib_rule_tests.sh | 30 ++++++++++++++++++-
 2 files changed, 39 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/fib_rules.c b/net/ipv4/fib_rules.c
index e0b6c8b6de57..117c48571cf0 100644
--- a/net/ipv4/fib_rules.c
+++ b/net/ipv4/fib_rules.c
@@ -23,6 +23,7 @@
 #include <linux/list.h>
 #include <linux/rcupdate.h>
 #include <linux/export.h>
+#include <net/inet_dscp.h>
 #include <net/ip.h>
 #include <net/route.h>
 #include <net/tcp.h>
@@ -35,7 +36,7 @@ struct fib4_rule {
 	struct fib_rule		common;
 	u8			dst_len;
 	u8			src_len;
-	u8			tos;
+	dscp_t			dscp;
 	__be32			src;
 	__be32			srcmask;
 	__be32			dst;
@@ -49,7 +50,7 @@ static bool fib4_rule_matchall(const struct fib_rule *rule)
 {
 	struct fib4_rule *r = container_of(rule, struct fib4_rule, common);
 
-	if (r->dst_len || r->src_len || r->tos)
+	if (r->dst_len || r->src_len || r->dscp)
 		return false;
 	return fib_rule_matchall(rule);
 }
@@ -185,7 +186,7 @@ INDIRECT_CALLABLE_SCOPE int fib4_rule_match(struct fib_rule *rule,
 	    ((daddr ^ r->dst) & r->dstmask))
 		return 0;
 
-	if (r->tos && (r->tos != fl4->flowi4_tos))
+	if (r->dscp && r->dscp != inet_dsfield_to_dscp(fl4->flowi4_tos))
 		return 0;
 
 	if (rule->ip_proto && (rule->ip_proto != fl4->flowi4_proto))
@@ -225,10 +226,12 @@ static int fib4_rule_configure(struct fib_rule *rule, struct sk_buff *skb,
 	int err = -EINVAL;
 	struct fib4_rule *rule4 = (struct fib4_rule *) rule;
 
-	if (frh->tos & ~IPTOS_TOS_MASK) {
-		NL_SET_ERR_MSG(extack, "Invalid tos");
+	if (!inet_validate_dscp(frh->tos)) {
+		NL_SET_ERR_MSG(extack,
+			       "Invalid dsfield (tos): ECN bits must be 0");
 		goto errout;
 	}
+	rule4->dscp = inet_dsfield_to_dscp(frh->tos);
 
 	/* split local/main if they are not already split */
 	err = fib_unmerge(net);
@@ -270,7 +273,6 @@ static int fib4_rule_configure(struct fib_rule *rule, struct sk_buff *skb,
 	rule4->srcmask = inet_make_mask(rule4->src_len);
 	rule4->dst_len = frh->dst_len;
 	rule4->dstmask = inet_make_mask(rule4->dst_len);
-	rule4->tos = frh->tos;
 
 	net->ipv4.fib_has_custom_rules = true;
 
@@ -313,7 +315,7 @@ static int fib4_rule_compare(struct fib_rule *rule, struct fib_rule_hdr *frh,
 	if (frh->dst_len && (rule4->dst_len != frh->dst_len))
 		return 0;
 
-	if (frh->tos && (rule4->tos != frh->tos))
+	if (frh->tos && inet_dscp_to_dsfield(rule4->dscp) != frh->tos)
 		return 0;
 
 #ifdef CONFIG_IP_ROUTE_CLASSID
@@ -337,7 +339,7 @@ static int fib4_rule_fill(struct fib_rule *rule, struct sk_buff *skb,
 
 	frh->dst_len = rule4->dst_len;
 	frh->src_len = rule4->src_len;
-	frh->tos = rule4->tos;
+	frh->tos = inet_dscp_to_dsfield(rule4->dscp);
 
 	if ((rule4->dst_len &&
 	     nla_put_in_addr(skb, FRA_DST, rule4->dst)) ||
diff --git a/tools/testing/selftests/net/fib_rule_tests.sh b/tools/testing/selftests/net/fib_rule_tests.sh
index d7a9ab3be1d3..4f70baad867d 100755
--- a/tools/testing/selftests/net/fib_rule_tests.sh
+++ b/tools/testing/selftests/net/fib_rule_tests.sh
@@ -215,10 +215,25 @@ fib_rule4_test_match_n_redirect()
 	log_test $? 0 "rule4 del by pref: $description"
 }
 
+fib_rule4_test_reject()
+{
+	local match="$1"
+	local rc
+
+	$IP rule add $match table $RTABLE 2>/dev/null
+	rc=$?
+	log_test $rc 2 "rule4 check: $match"
+
+	if [ $rc -eq 0 ]; then
+		$IP rule del $match table $RTABLE
+	fi
+}
+
 fib_rule4_test()
 {
 	local getmatch
 	local match
+	local cnt
 
 	# setup the fib rule redirect route
 	$IP route add table $RTABLE default via $GW_IP4 dev $DEV onlink
@@ -234,8 +249,21 @@ fib_rule4_test()
 	fib_rule4_test_match_n_redirect "$match" "$match" "iif redirect to table"
 	ip netns exec testns sysctl -qw net.ipv4.ip_forward=0
 
+	# Reject dsfield (tos) options which have ECN bits set
+	for cnt in $(seq 1 3); do
+		match="dsfield $cnt"
+		fib_rule4_test_reject "$match"
+	done
+
+	# Don't take ECN bits into account when matching on dsfield
 	match="tos 0x10"
-	fib_rule4_test_match_n_redirect "$match" "$match" "tos redirect to table"
+	for cnt in "0x10" "0x11" "0x12" "0x13"; do
+		# Using option 'tos' instead of 'dsfield' as old iproute2
+		# versions don't support 'dsfield' in ip rule show.
+		getmatch="tos $cnt"
+		fib_rule4_test_match_n_redirect "$match" "$getmatch" \
+						"$getmatch redirect to table"
+	done
 
 	match="fwmark 0x64"
 	getmatch="mark 0x64"
-- 
2.21.3

