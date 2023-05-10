Return-Path: <netdev+bounces-1301-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 03E336FD390
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 03:31:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D74FE1C20B94
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 01:31:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0DC2388;
	Wed, 10 May 2023 01:30:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5BB562E
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 01:30:34 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FFD1BD
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 18:30:33 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-b9a7d92d0f7so12178889276.1
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 18:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683682232; x=1686274232;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pC/bsN2xFpyZ4+FuoZT0PgKg2rhPk2y2/6NLhAcxnFA=;
        b=dHLduUqkBHOhdwLI6pVV2LAASieJvnde+1ayhGFikcH6KVJ8bSPh1oezioulCT9ZCf
         4bZJu0tN8x5m7p+6z/z49fPTcSRrr1JzJqDzODk5EL25Yqkqox4I7WvJkzDO91EKi+We
         jrJdKLS+zWU0fsNm3DeE0FMmXbgaet2olnvkorqx7fAZ0oOh+S56E0gSF6X61rrdtLPa
         jT0H0Y1cg88eG+tTMhdWlyn4rBLv9KZXRIrG5YPRg8W94MqIWAJsUxfdOUnYfU2QATAp
         OFGvIjI99EupAo3PBizuJ6JqfriIC0QTb0N3GrAlOaaCcN0mQyyOli/wP6zj76U7ksqZ
         0wSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683682232; x=1686274232;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pC/bsN2xFpyZ4+FuoZT0PgKg2rhPk2y2/6NLhAcxnFA=;
        b=Y6/a9QqSeZnWRcvZKpp9zfjSlClpbcfk5K4wEpYAg8eabfZz+I87E1GGbpZkxn10Uj
         t1KBeQ+mNt719uHzkwPQattWHQfqn9VplZXfsZhf0LlzIg4PNnj/Dt6DG2E5PEhnuD2C
         Al2Zwjz2z+avYBGBMh56FTov2yAO/ANT/up8srqC9+nkEL3BZbFoeX4dyrT+BTKjTa7g
         wQStdGuiAqXvoXKVOpePrb39yM5zPNaFGsarGLvC/DhD+CO3DHLbtVwNQOSKslmpneMq
         ESNso7qa11OKJAbaM+j1BZIS/SnX59JpKBUHBqOTF8N7OwGqHsWCgAcG16yFjLeYESdC
         9xLQ==
X-Gm-Message-State: AC+VfDzDx466tB76ZQ/wEFnbW7AlEl77m7JO+AemGIspkIoxzOBuuJ+N
	tTwDpJphCkpsUPb5PdARorTc7MYQMfMIWGzCxfpyeYF5veAH+r3Cw0SRoE1Td7GVFSYe+QnbR6v
	8XzJmlcgBSAJ9hOKWY7uZb2dndh/XiD2ZnsPBPzpl4aX9u9xbHvlXlAO/VzY2zSYyU/wNltU5Pq
	K44w==
X-Google-Smtp-Source: ACHHUZ5dyGRksP2RlRLIQcjLffHIaupSEVrSOyl0DRjAJVB6te0yNJqbkXuzCqjNzOyJ7kj+YLB2arMjduViaivWfv8=
X-Received: from obsessiveorange-c2.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1b95])
 (user=benedictwong job=sendgmr) by 2002:a25:1c55:0:b0:ba2:dd0b:c75 with SMTP
 id c82-20020a251c55000000b00ba2dd0b0c75mr3503376ybc.3.1683682232590; Tue, 09
 May 2023 18:30:32 -0700 (PDT)
Date: Wed, 10 May 2023 01:30:22 +0000
In-Reply-To: <20230510013022.2602474-1-benedictwong@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230510013022.2602474-1-benedictwong@google.com>
X-Mailer: git-send-email 2.40.1.521.gf1e218fcd8-goog
Message-ID: <20230510013022.2602474-3-benedictwong@google.com>
Subject: [PATCH ipsec 2/2] xfrm: Ensure policies always checked on XFRM-I
 input path
From: Benedict Wong <benedictwong@google.com>
To: netdev@vger.kernel.org, steffen.klassert@secunet.com, 
	martin@strongswan.org
Cc: nharold@google.com, benedictwong@google.com, evitayan@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This change adds methods in the XFRM-I input path that ensures that
policies are checked prior to processing of the subsequent decapsulated
packet, after which the relevant policies may no longer be resolvable
(due to changing src/dst/proto/etc).

Notably, raw ESP/AH packets did not perform policy checks inherently,
whereas all other encapsulated packets (UDP, TCP encapsulated) do policy
checks after calling xfrm_input handling in the respective encapsulation
layer.

Fixes: b0355dbbf13c ("Fix XFRM-I support for nested ESP tunnels")
Test: Verified with additional Android Kernel Unit tests
Test: Verified against Android CTS
Signed-off-by: Benedict Wong <benedictwong@google.com>
---
 net/xfrm/xfrm_interface_core.c | 54 +++++++++++++++++++++++++++++++---
 1 file changed, 50 insertions(+), 4 deletions(-)

diff --git a/net/xfrm/xfrm_interface_core.c b/net/xfrm/xfrm_interface_core.c
index 1f99dc469027..35279c220bd7 100644
--- a/net/xfrm/xfrm_interface_core.c
+++ b/net/xfrm/xfrm_interface_core.c
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
@@ -945,8 +991,8 @@ static struct pernet_operations xfrmi_net_ops = {
 };
 
 static struct xfrm6_protocol xfrmi_esp6_protocol __read_mostly = {
-	.handler	=	xfrm6_rcv,
-	.input_handler	=	xfrm_input,
+	.handler	=	xfrmi6_rcv,
+	.input_handler	=	xfrmi6_input,
 	.cb_handler	=	xfrmi_rcv_cb,
 	.err_handler	=	xfrmi6_err,
 	.priority	=	10,
@@ -996,8 +1042,8 @@ static struct xfrm6_tunnel xfrmi_ip6ip_handler __read_mostly = {
 #endif
 
 static struct xfrm4_protocol xfrmi_esp4_protocol __read_mostly = {
-	.handler	=	xfrm4_rcv,
-	.input_handler	=	xfrm_input,
+	.handler	=	xfrmi4_rcv,
+	.input_handler	=	xfrmi4_input,
 	.cb_handler	=	xfrmi_rcv_cb,
 	.err_handler	=	xfrmi4_err,
 	.priority	=	10,
-- 
2.40.1.521.gf1e218fcd8-goog


