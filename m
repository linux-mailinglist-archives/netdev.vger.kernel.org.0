Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B26D4CC4E5
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 19:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235678AbiCCSRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 13:17:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235680AbiCCSRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 13:17:31 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2331A39FD
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 10:16:38 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id g7-20020a17090a708700b001bb78857ccdso8419525pjk.1
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 10:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bhvBzCoyUH5Q2UW9eaBJZ/pUOhsdMx7Q/qA4TYp9tCg=;
        b=Rb/Z85wD8xH6SCxRoJH6bcKsIOsfBxMH6ZebEdHV2YlCiACLAr9XZwVmXKQsS8bEEO
         xTITZEd7qGUw/5o9uHobDo7R6hqEemWCZrijNJy/pt97zmjkK2XBXcIzmWLgG9uZhSLX
         wRPqp5KDNteFVrcgF+KVu23kksLuujGfmYuCsVWHPpvRlqRa6BE4fV7htkPixgg1SibX
         8x4wCYlmwgIPXtlLc9iG/5l/yyYwkUyJMKquaqu/lc2W6ytVmNfpNXBeNOucoTS862n7
         I1iDpRYPG3CcL1m9EiKESyz/Z+YKL2aHl6M3+/0aQvZRYo2D2mwAhDYE4IbtIAd3cMvu
         OKPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bhvBzCoyUH5Q2UW9eaBJZ/pUOhsdMx7Q/qA4TYp9tCg=;
        b=v6r9yNgghAv7fVMNBG4VosLJuEU1HUaWPfoeaySFNdBm5ABFBcoJHqqUMZUEOVOl8z
         WlJWpJQi+4iwNF36AjVphJchPb55+9dU1sLgdR62z0RQYRhV9XCvDGh+diez/sDHqbSj
         mCGRsFbeWILBdMkBgx4CCjMkSwFur6+vk7TPUbOsVBOkgedxBoFFt5WlccBFtSEq0Sk3
         re+Z9+qqhQkXtRtWuICXxX6H49CZjtMDsw4qG9FYuBzrrg0dHgrXpVubtJQ1pD7f2bGb
         qX6iobPalNcQI9HrWLTaU2r4Gts2bOg7OwzUGAPOutZT7PPSDDt8jlqUzzOwxiaQ7v7z
         ljSQ==
X-Gm-Message-State: AOAM531vgLgpj2+0h1/+bESlAMfhRADhQc+TGa4YyjK7yuyrZz6gq1JX
        qm49GQ49kXpI5S4NcmSvMNY=
X-Google-Smtp-Source: ABdhPJzFTF2P/zneiE7vBW2ZTXTBenAk0TaJ4VEqsUsb/v/92sTYDK9NUjKmXIQ575db0jouoQB+YQ==
X-Received: by 2002:a17:90b:4a49:b0:1be:e5e1:3a9c with SMTP id lb9-20020a17090b4a4900b001bee5e13a9cmr6558582pjb.211.1646331397570;
        Thu, 03 Mar 2022 10:16:37 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5388:c313:5e37:a261])
        by smtp.gmail.com with ESMTPSA id u14-20020a17090adb4e00b001bee5dd39basm7611016pjx.1.2022.03.03.10.16.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 10:16:37 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        David Ahern <dsahern@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 06/14] ipv6/gro: insert temporary HBH/jumbo header
Date:   Thu,  3 Mar 2022 10:15:59 -0800
Message-Id: <20220303181607.1094358-7-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
In-Reply-To: <20220303181607.1094358-1-eric.dumazet@gmail.com>
References: <20220303181607.1094358-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Following patch will add GRO_IPV6_MAX_SIZE, allowing gro to build
BIG TCP ipv6 packets (bigger than 64K).

This patch changes ipv6_gro_complete() to insert a HBH/jumbo header
so that resulting packet can go through IPv6/TCP stacks.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/ip6_offload.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
index a6a6c1539c28d242ef8c35fcd5ce900512ce912d..d12dba2dd5354dbb79bb80df4038dec2544cddeb 100644
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -342,15 +342,43 @@ static struct sk_buff *ip4ip6_gro_receive(struct list_head *head,
 INDIRECT_CALLABLE_SCOPE int ipv6_gro_complete(struct sk_buff *skb, int nhoff)
 {
 	const struct net_offload *ops;
-	struct ipv6hdr *iph = (struct ipv6hdr *)(skb->data + nhoff);
+	struct ipv6hdr *iph;
 	int err = -ENOSYS;
+	u32 payload_len;
 
 	if (skb->encapsulation) {
 		skb_set_inner_protocol(skb, cpu_to_be16(ETH_P_IPV6));
 		skb_set_inner_network_header(skb, nhoff);
 	}
 
-	iph->payload_len = htons(skb->len - nhoff - sizeof(*iph));
+	payload_len = skb->len - nhoff - sizeof(*iph);
+	if (unlikely(payload_len > IPV6_MAXPLEN)) {
+		struct hop_jumbo_hdr *hop_jumbo;
+		int hoplen = sizeof(*hop_jumbo);
+
+		/* Move network header left */
+		memmove(skb_mac_header(skb) - hoplen, skb_mac_header(skb),
+			skb->transport_header - skb->mac_header);
+		skb->data -= hoplen;
+		skb->len += hoplen;
+		skb->mac_header -= hoplen;
+		skb->network_header -= hoplen;
+		iph = (struct ipv6hdr *)(skb->data + nhoff);
+		hop_jumbo = (struct hop_jumbo_hdr *)(iph + 1);
+
+		/* Build hop-by-hop options */
+		hop_jumbo->nexthdr = iph->nexthdr;
+		hop_jumbo->hdrlen = 0;
+		hop_jumbo->tlv_type = IPV6_TLV_JUMBO;
+		hop_jumbo->tlv_len = 4;
+		hop_jumbo->jumbo_payload_len = htonl(payload_len + hoplen);
+
+		iph->nexthdr = NEXTHDR_HOP;
+		iph->payload_len = 0;
+	} else {
+		iph = (struct ipv6hdr *)(skb->data + nhoff);
+		iph->payload_len = htons(payload_len);
+	}
 
 	nhoff += sizeof(*iph) + ipv6_exthdrs_len(iph, &ops);
 	if (WARN_ON(!ops || !ops->callbacks.gro_complete))
-- 
2.35.1.616.g0bdcbb4464-goog

