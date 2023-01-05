Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B42F365F5C5
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 22:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235847AbjAEV2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 16:28:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235829AbjAEV2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 16:28:31 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0662F631BD
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 13:28:31 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id h12-20020a17090a604c00b00225b2dbe4cfso1514381pjm.1
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 13:28:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hZsZN3YhNwmdNSLnQiLP2Ip2rcyZ0nvjqhuYT71F5rU=;
        b=fXtHtLOKHjPRZ2yriP7v8JVwg6VkOmVoQoLm02ACw27679PbqGBd1vsUVnWPDk5Ex6
         KHR03rj6U+91/IHgYp5bwgn7SjwJfcFL/kc00joxq/sXXHKAY8X/SFyglUhsoAxD20FB
         ips/z4Gh6MlSrSzTqt5Gj6gvwtNlEfQnuVx7SEVWpRVidb6Gqr2LHs++0ZTDXVJn7ibV
         hzkmSpTXt0gg1KsIllf24wEXyQ+069JJjN6XpDLbcRRSjfge2QjaQVTzQL44T0m0FCcV
         FUk1DnxSlShHfA9oX9MrYtGYBE+NEmvnee/3LQ6PklsG9w/FzuoT6Y/K/exRLX2HpVBU
         sbwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hZsZN3YhNwmdNSLnQiLP2Ip2rcyZ0nvjqhuYT71F5rU=;
        b=J67xlfO+2mDtExRWkdT6FDaUCXT+Sf4lt5Zi6NOxydZoLTtvWWNlh2gchwIIPrhVsj
         PW1QSgK4cl1ezJVYysxaL3qz79U20iiKrjeuh/pbD1fgj2FZHZvQzWX177tUkb8b2oMn
         6vvX18LGe8mGQJnbIVykqW7VvABir+UciNUJg7IEyE7kCsot7UfRsQ5kXbWQile6PAJ4
         CoApENsef8cuLBtxSWszaKpoejH1pp7P/LjAl7fw+/lrGriuOyZCYUxVCRfaaXgrzL3N
         /JJXOjIhDLOt1h3BE4TgjqLKMR5kEgFDC4Par0sCdykzKgZ5bvn4Qy2zS+y0ChqR3irW
         NHKA==
X-Gm-Message-State: AFqh2krEdsM4glS0gmTs4SUG7r+LpsxtaixrEkA+aSiz6cTEI0/42u/O
        rZrpWeRZsCRrBgP/FK3dHT6sm9w9H82Nl7qYy6uA4l6omJTLKGbqSCU5yGZRslu2MNWXLOPQWoV
        UCbnUQLkRgonA49DbPwo/156vQNwcTFapssVRKeok6oujgVDE8TIWIHMiBR3bh8cY7Os8HGDDc1
        KyaQ==
X-Google-Smtp-Source: AMrXdXugfLgNoR1HJW/I9U5SDk8utnYNs5p/PP5S4vjkwqTY7w0rTB6ahXkyDWYL0gE7HQp4sQ3DJDJz9jeXh/L/dNM=
X-Received: from obsessiveorange-c1.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3039])
 (user=benedictwong job=sendgmr) by 2002:a17:90a:fe88:b0:219:d33d:4689 with
 SMTP id co8-20020a17090afe8800b00219d33d4689mr4319493pjb.233.1672954110282;
 Thu, 05 Jan 2023 13:28:30 -0800 (PST)
Date:   Thu,  5 Jan 2023 21:28:12 +0000
In-Reply-To: <20230105212812.2028732-1-benedictwong@google.com>
Mime-Version: 1.0
References: <20230105212812.2028732-1-benedictwong@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230105212812.2028732-2-benedictwong@google.com>
Subject: [PATCH v3 ipsec] Fix XFRM-I support for nested ESP tunnels
From:   Benedict Wong <benedictwong@google.com>
To:     netdev@vger.kernel.org
Cc:     nharold@google.com, benedictwong@google.com, lorenzo@google.com,
        steffen.klassert@secunet.com
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
 net/xfrm/xfrm_interface_core.c | 54 +++++++++++++++++++++++++++++++---
 net/xfrm/xfrm_policy.c         |  3 ++
 2 files changed, 53 insertions(+), 4 deletions(-)

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
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index e9eb82c5457d..ed0976f8e42b 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3742,6 +3742,9 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 			goto reject;
 		}
 
+		if (if_id)
+			secpath_reset(skb);
+
 		xfrm_pols_put(pols, npols);
 		return 1;
 	}
-- 
2.39.0.314.g84b9a713c41-goog

