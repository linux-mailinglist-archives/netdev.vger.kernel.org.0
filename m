Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB79252078E
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 00:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbiEIW17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 18:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbiEIW0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 18:26:03 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3EB7185406
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 15:22:06 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id bo5so13403264pfb.4
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 15:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Vu77qaZ+HoKgSEeugLbfMjppTn8NfczBDAHApl4hhmA=;
        b=GBBGxXVtI2x8YESRHBAqxp2NXUm0X0Mr1Mqb4OlnRSv9+OhATOCb/LuRi3Gm/jfQ2j
         Hgu+GaCPddxogL14HGESEddBUPDbVHNT5TulTBCz/pQf+8luc8RFjxsS2aiP4sDFMdXX
         M/rh5rKRUwkG+uosfF5dAfnbg3sEpgQ5u4+5l0DOOIm+/A24SNTOIxtaR45uAvsv4Jha
         H1VFKOI26zjer4+XsmyjVXG5JFInj7UXetS87iJn3rpy//p1LL6WvyzD43k4QqiJdm8M
         VUtY4qFE4L1N+jfoLHhq8d+9LYb5w0y/W0JGwqibk82uJObJ5Gm5jWOGUijJtj955PQV
         fy5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vu77qaZ+HoKgSEeugLbfMjppTn8NfczBDAHApl4hhmA=;
        b=Kb4CzK6sMQdJZkkwgZ3ACzP0TuwZQAV7j6uUEVccVcmzB8+OWYYx8kMZGnBHLk3crR
         AQzd7YTYiiuVOrrqAz5udeZtu/JBCHjUHEboLXIwWWu80AOvNhU5cEMI2GowI4Vl34CT
         C9xphnkzbRYAlRyI8yPldLOVZ2RnAqL5l9txpVM780sLq/+4/qqHw0ogYaLXObtj6aoj
         K2P3wA+TQ5NLGpsHTa3x4wfYIgX1CrAemhbl1Mt0tgRF4LQuNy7evYxZoqCZ9RuvS7PQ
         n1+d842BUjMm9jJMLBkwRdNZIQa6f4yA4/UJqlIiOg6Xk1b/UWilsY9R9FVPUhqplNS4
         Trcg==
X-Gm-Message-State: AOAM533ZOXxYd0nNAEZ+0xok133s53pvg00U/7xm/aKOJYsuQoaTV7eV
        RizCqheY3woKtBwnGYt+kR4=
X-Google-Smtp-Source: ABdhPJyAf70OztgPUG2Gwqa3V96xrjzfLx+Xfc2d6qeuE6oOt9WXDwvOU/NnMGOegiqep2MQvpAtFg==
X-Received: by 2002:a63:114c:0:b0:3c2:3346:3c2b with SMTP id 12-20020a63114c000000b003c233463c2bmr14511768pgr.226.1652134926662;
        Mon, 09 May 2022 15:22:06 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5d30:4e79:203f:a909])
        by smtp.gmail.com with ESMTPSA id v11-20020a170902f0cb00b0015e8d4eb1efsm395823pla.57.2022.05.09.15.22.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 15:22:06 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v5 net-next 07/13] ipv6/gro: insert temporary HBH/jumbo header
Date:   Mon,  9 May 2022 15:21:43 -0700
Message-Id: <20220509222149.1763877-8-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220509222149.1763877-1-eric.dumazet@gmail.com>
References: <20220509222149.1763877-1-eric.dumazet@gmail.com>
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
2.36.0.512.ge40c2bad7a-goog

