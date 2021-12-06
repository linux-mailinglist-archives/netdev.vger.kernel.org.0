Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A40CE46A3EB
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 19:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346741AbhLFSZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 13:25:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:28343 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345823AbhLFSZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 13:25:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638814933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oCwHpSqqEZ4Asa2uxF8dDn2YXsAfptsVL8pdsQ0kytc=;
        b=Douufr0sufCn1X8YJW4LqaTDm1ddQgmVqzTnZ02yddqf+wauPQNTvJbLLECC4QVWlTWD4H
        l6KhUMJHGaGlN9Svggf0WrHqtVBvh1H8i9IT0ympvjedzJkdw6mOSzR5zawqnpobT0HqCv
        l4QnU2A1lBiDhE5c0QVS95ETEVTi7gI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-329-5_LcOsJyPx6Pz2Xz0atuMg-1; Mon, 06 Dec 2021 13:22:12 -0500
X-MC-Unique: 5_LcOsJyPx6Pz2Xz0atuMg-1
Received: by mail-wm1-f69.google.com with SMTP id y141-20020a1c7d93000000b0033c2ae3583fso6479072wmc.5
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 10:22:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oCwHpSqqEZ4Asa2uxF8dDn2YXsAfptsVL8pdsQ0kytc=;
        b=Tk5Q2cOFulnJCKlkZ/gSv1l4D23lHwTgDg3KfYqQn88/TnKUEr98n7VglsEEhlrIwv
         DzvM+aOadGECp4pv25mfPOic1UkT8er6aUQDKJphuJWcA93EuvT1sGSb3rV7xi4i1YZO
         z4mt6cpnzPB1g6fy9xaOnpqz5ut3EN3S/Zp6g40Rfg71Z/EltU1P0VhdjhkDR7aeOw1A
         3i6POSZ5EnvsSOs2Mpjbmau7a8LSdDqYuRgGPrUzpn4t0RC/XUBysVNlK6E033f3o+sH
         a5mjOxXMYGYvWkUGgNwKnY1vhvr3LztgBy7LoeBCCKFSH5OQ5T8USqFKNGE26l0uJp5j
         pBOA==
X-Gm-Message-State: AOAM532352e7CqnXfEvzT1SOGLH8qwoDIpoA0gKpRkZkMXUAf3U3KBKZ
        h+zprt1eqjeg4ug7+SjD8X8jsmY9f+8UFxkjq+GzdbZ3Txg89VoDzbfT92o6BKtQBZnqDIWm3Yh
        s4I2n9pwoNi12krqe
X-Received: by 2002:adf:8293:: with SMTP id 19mr43784146wrc.167.1638814931546;
        Mon, 06 Dec 2021 10:22:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyXwXqTbNY46yNKYBzOpn1WUnN4lyz3u0NvkaqEVx+JlPj1hZczjYQbLw3ubJ9K55LcOPGCyw==
X-Received: by 2002:adf:8293:: with SMTP id 19mr43784134wrc.167.1638814931389;
        Mon, 06 Dec 2021 10:22:11 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id h204sm126686wmh.33.2021.12.06.10.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 10:22:11 -0800 (PST)
Date:   Mon, 6 Dec 2021 19:22:09 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Russell Strong <russell@strong.id.au>
Subject: [PATCH net-next 2/4] ipv4: Stop taking ECN bits into account in
 ip4-rules
Message-ID: <8c0bfb9ad40ed3da0edf905e226f13ef4cf1adb4.1638814614.git.gnault@redhat.com>
References: <cover.1638814614.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1638814614.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new dscp_t type to replace the tos field of fib4_rule, so that
ip4-rules consistently ignore ECN bits.

Before this patch, ip4-rules did accept rules with the high order ECN
bit set (but not the low order one). Also, it relied on its callers
masking the ECN bits of ->flowi4_tos to prevent those from influencing
the result. This was brittle and a few call paths still do the lookup
without masking the ECN bits first.

After this patch ip4-rules only compare the DSCP bits. ECN can't
influence the result anymore, even if the caller didn't mask these
bits. Also, ip4-rules now must have both ECN bits cleared or they will
be rejected.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/ipv4/fib_rules.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/fib_rules.c b/net/ipv4/fib_rules.c
index d279cb8ac158..d4529350a2e8 100644
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
@@ -230,10 +231,11 @@ static int fib4_rule_configure(struct fib_rule *rule, struct sk_buff *skb,
 	int err = -EINVAL;
 	struct fib4_rule *rule4 = (struct fib4_rule *) rule;
 
-	if (frh->tos & ~IPTOS_TOS_MASK) {
-		NL_SET_ERR_MSG(extack, "Invalid tos");
+	if (!inet_validate_dscp(frh->tos)) {
+		NL_SET_ERR_MSG(extack, "Invalid dsfield (tos): ECN bits must be 0");
 		goto errout;
 	}
+	rule4->dscp = inet_dsfield_to_dscp(frh->tos);
 
 	/* split local/main if they are not already split */
 	err = fib_unmerge(net);
@@ -275,7 +277,6 @@ static int fib4_rule_configure(struct fib_rule *rule, struct sk_buff *skb,
 	rule4->srcmask = inet_make_mask(rule4->src_len);
 	rule4->dst_len = frh->dst_len;
 	rule4->dstmask = inet_make_mask(rule4->dst_len);
-	rule4->tos = frh->tos;
 
 	net->ipv4.fib_has_custom_rules = true;
 
@@ -318,7 +319,7 @@ static int fib4_rule_compare(struct fib_rule *rule, struct fib_rule_hdr *frh,
 	if (frh->dst_len && (rule4->dst_len != frh->dst_len))
 		return 0;
 
-	if (frh->tos && (rule4->tos != frh->tos))
+	if (frh->tos && inet_dscp_to_dsfield(rule4->dscp) != frh->tos)
 		return 0;
 
 #ifdef CONFIG_IP_ROUTE_CLASSID
@@ -342,7 +343,7 @@ static int fib4_rule_fill(struct fib_rule *rule, struct sk_buff *skb,
 
 	frh->dst_len = rule4->dst_len;
 	frh->src_len = rule4->src_len;
-	frh->tos = rule4->tos;
+	frh->tos = inet_dscp_to_dsfield(rule4->dscp);
 
 	if ((rule4->dst_len &&
 	     nla_put_in_addr(skb, FRA_DST, rule4->dst)) ||
-- 
2.21.3

