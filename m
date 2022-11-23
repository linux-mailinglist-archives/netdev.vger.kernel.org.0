Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAC5634E61
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 04:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235602AbiKWDgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 22:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235343AbiKWDgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 22:36:11 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4821FD288B
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 19:36:10 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id pq17-20020a17090b3d9100b0020a4c65c3a9so8409827pjb.0
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 19:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FU5rpoqTSw8duVvsLCK/2vdcbXOaeYaQk5soIt5Asjs=;
        b=mZmD0juGzm+Ck1+DVOm2vB4+9Y8XQKMIxD48HUnoSARmUxKI8KTR2EMJvn0D2KIhgj
         3lFGaSD9lwRGgRKkJV/wxGYpgqBp1CNkD4UQV5y/svcx6Pgzc/8MPGJwxnoxS+96ybmp
         nLMF7qNivFUiM1qSQHDqjmVywgselCtZxOXOSRzdIbZvSW9F8a2niOyUGhaFOk6v6QiL
         q+ATxkZrCYe51Ss5ykxQvu1hvDkYfjfnEx8JQKhIK7LZu8i/mcmlXjdtzLeDYbtVkfsa
         KS1Ur9xbDkhIN8MVu2wHD/ERwdi9vC5VLCrrwcUHwY7PNb4z5Bs4pPntGzXy+Fq6kn0G
         p4WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FU5rpoqTSw8duVvsLCK/2vdcbXOaeYaQk5soIt5Asjs=;
        b=eHq1SBCq2zwnJOzUr/PHr0u9djO+vjXo9InCwQGhhjKPQKppy2p6aQJ+9iPsPrGE2u
         HYxm2skC3xnqdgQeDvvmlC2seZwKhyX7M79VIaRQGYReNUiG604oaO3yYJm+JFhWNSNO
         JFJhxgjDNqH3YI4sZQWdF6tj64TDRIZ8pJSFgD3p6MQ6gEYwua6GA3gGU1wrvfTsioTB
         2JoV8Gxk9vusyQQ18RMSFw2yAL/J29bJAeZgdh67tHAAyB7F2QmKfMJoD2EORmzqtAwF
         6O2hQ4Els2OW45J05xK+otdUUw4OuKl4iyCMUJMtSffNAmUMkLoEYTuQbyDYao7db7v6
         h74A==
X-Gm-Message-State: ANoB5pn+NxGH8p5PpREx/DUXXKgZ5WoRDZn7b9zvuTHJx3RDdMP0gv2T
        tB7PP1QoO4LvPM2ZOFqfhyyu6MvbYESEWGPIr8Ma+kAiD0ayL6zIDK2FurX5eBk4OC+4QsINaH+
        ww2hD51I3z5vYRVxwma9FHda9TU7BfM0o9s0dChNjG8qggCzQ90MY3Q+Kw61yIo2SQptNoZB567
        uk/A==
X-Google-Smtp-Source: AA0mqf7ZlEfR2qWICC2WlMIh4NOACpYiBzOhrdZl2FmxGkjkEO2cvYTyihBStq7+CNxUs0ZQ5lrDf8KOtBC1E0kvTDM=
X-Received: from obsessiveorange-c1.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3039])
 (user=benedictwong job=sendgmr) by 2002:a17:902:6a86:b0:188:cfc6:31fb with
 SMTP id n6-20020a1709026a8600b00188cfc631fbmr19658638plk.150.1669174569708;
 Tue, 22 Nov 2022 19:36:09 -0800 (PST)
Date:   Wed, 23 Nov 2022 03:34:55 +0000
In-Reply-To: <20221123033456.1187746-1-benedictwong@google.com>
Mime-Version: 1.0
References: <20221123033456.1187746-1-benedictwong@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221123033456.1187746-2-benedictwong@google.com>
Subject: [PATCH v2 ipsec] Fix XFRM-I support for nested ESP tunnels
From:   Benedict Wong <benedictwong@google.com>
To:     netdev@vger.kernel.org
Cc:     nharold@google.com, benedictwong@google.com, lorenzo@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds support for nested IPsec tunnels by ensuring that
XFRM-I verifies existing policies before decapsulating a subsequent
policies. Addtionally, this clears the secpath entries after policies
are verified, ensuring that previous tunnels with no-longer-valid
do not pollute subsequent policy checks.

This is necessary especially for nested tunnels, as the IP addresses,
protocol and ports may all change, thus not matching the previous
policies. In order to ensure that packets match the relevant inbound
templates, the xfrm_policy_check should be done before handing off to
the inner XFRM protocol to decrypt and decapsulate.

Notably, raw ESP/AH packets did not perform policy checks inherently,
whereas all other encapsulated packets (UDP, TCP encapsulated) do policy
checks after calling xfrm_input handling in the respective encapsulation
layer.

Test: Verified with additional Android Kernel Unit tests
Signed-off-by: Benedict Wong <benedictwong@google.com>
---
 net/xfrm/xfrm_interface.c | 54 ++++++++++++++++++++++++++++++++++++---
 net/xfrm/xfrm_policy.c    |  3 +++
 2 files changed, 53 insertions(+), 4 deletions(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 5a67b120c4db..94a3609548b1 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -310,6 +310,52 @@ static void xfrmi_scrub_packet(struct sk_buff *skb, bool xnet)
 	skb->mark = 0;
 }
 
+static int xfrmi_input(struct sk_buff *skb, int nexthdr, __be32 spi,
+		       int encap_type, unsigned short family)
+{
+	struct sec_path *sp;
+
+	sp = skb_sec_path(skb);
+	if (sp && (sp->len || sp->olen) &&
+	    !xfrm_policy_check(NULL, XFRM_POLICY_IN, skb, family))
+		goto discard;
+
+	XFRM_SPI_SKB_CB(skb)->family = family;
+	if (family == AF_INET) {
+		XFRM_SPI_SKB_CB(skb)->daddroff = offsetof(struct iphdr, daddr);
+		XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip4 = NULL;
+	} else {
+		XFRM_SPI_SKB_CB(skb)->daddroff = offsetof(struct ipv6hdr, daddr);
+		XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip6 = NULL;
+	}
+
+	return xfrm_input(skb, nexthdr, spi, encap_type);
+discard:
+	kfree_skb(skb);
+	return 0;
+}
+
+static int xfrmi4_rcv(struct sk_buff *skb)
+{
+	return xfrmi_input(skb, ip_hdr(skb)->protocol, 0, 0, AF_INET);
+}
+
+static int xfrmi6_rcv(struct sk_buff *skb)
+{
+	return xfrmi_input(skb, skb_network_header(skb)[IP6CB(skb)->nhoff],
+			   0, 0, AF_INET6);
+}
+
+static int xfrmi4_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
+{
+	return xfrmi_input(skb, nexthdr, spi, encap_type, AF_INET);
+}
+
+static int xfrmi6_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
+{
+	return xfrmi_input(skb, nexthdr, spi, encap_type, AF_INET6);
+}
+
 static int xfrmi_rcv_cb(struct sk_buff *skb, int err)
 {
 	const struct xfrm_mode *inner_mode;
@@ -937,8 +983,8 @@ static struct pernet_operations xfrmi_net_ops = {
 };
 
 static struct xfrm6_protocol xfrmi_esp6_protocol __read_mostly = {
-	.handler	=	xfrm6_rcv,
-	.input_handler	=	xfrm_input,
+	.handler	=	xfrmi6_rcv,
+	.input_handler	=	xfrmi6_input,
 	.cb_handler	=	xfrmi_rcv_cb,
 	.err_handler	=	xfrmi6_err,
 	.priority	=	10,
@@ -988,8 +1034,8 @@ static struct xfrm6_tunnel xfrmi_ip6ip_handler __read_mostly = {
 #endif
 
 static struct xfrm4_protocol xfrmi_esp4_protocol __read_mostly = {
-	.handler	=	xfrm4_rcv,
-	.input_handler	=	xfrm_input,
+	.handler	=	xfrmi4_rcv,
+	.input_handler	=	xfrmi4_input,
 	.cb_handler	=	xfrmi_rcv_cb,
 	.err_handler	=	xfrmi4_err,
 	.priority	=	10,
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 3a203c59a11b..bc9cb9bda248 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3670,6 +3670,9 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 			goto reject;
 		}
 
+		if (if_id)
+			secpath_reset(skb);
+
 		xfrm_pols_put(pols, npols);
 		return 1;
 	}
-- 
2.38.1.584.g0f3c55d4c2-goog

