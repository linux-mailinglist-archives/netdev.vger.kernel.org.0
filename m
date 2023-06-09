Return-Path: <netdev+bounces-9466-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AA122729489
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 11:15:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 662D72808F2
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 09:15:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB2FADDA6;
	Fri,  9 Jun 2023 09:15:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0D0C8FA
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 09:15:54 +0000 (UTC)
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7484259FE
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 02:15:25 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-6532671ccc7so1635755b3a.2
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 02:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686302115; x=1688894115;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Xd/ImCtaBGvBWrVuJ5CqmlmP8tgaCJX4GyTufFYbbAo=;
        b=BYZhMXkc4F/rblzYEojRFVeaf0feNNqjEiosMGA1m9+8eY2dy5i2d+VlpvXZRQoHp2
         cgw5TVR5W+kJtQW+IkYsdBRks6JWM3cTUiGVNw1XdobTGIREmV5rEiF8y2VxBNAaY3x5
         GFDpSdibxnsadWZXfwUnLBNdVBAkOjIQllU+Lw0bjud2kxDnPoCIxauV0n1xVa3ZhqXI
         We3x4scdJXKWmFVM+peAnRaox/qO5S6o9l2licWKLlvufOM4wjhVDWy+QjB69ZkaMEbg
         WmGyfAApsk4vpLBl20UnjV3+XCHPuLAx+nA0+2wKuq7hs3T21tyNbwedd/eBr3w6v46J
         sAow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686302115; x=1688894115;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xd/ImCtaBGvBWrVuJ5CqmlmP8tgaCJX4GyTufFYbbAo=;
        b=lTnOtqZyBTE0EEZWLNiA3ObA4VPNAh9pqMoHQLt+h2bj2jdWOzSBXACHbcUzQnwv1S
         IAqn0/8taXUpcBCnblWf18/MVVoaUBqcbicsS6ILjNKLMs4OeI0blG0XHRAHvCKV76AS
         m7Px/Xn57WIYRiTNbyy3PcO7j2i86BZ/CO1KVs2JZ9GoT/IjkYew19gLrJ/JmSa7GgHa
         L4BPkC3f/ydTThJaFa+WfPN5r+jAMf9Wt77SJmG11GayYAxz9q2/TWcgSkZh5Fqj/8qs
         Pbf5Adj62ybJfBpha8zAkt8sjHwJomBjDOjyoh3CDtZARXgRGwaZPIAujACF3A4jKK7+
         7D/Q==
X-Gm-Message-State: AC+VfDzqXRmTD1Hs/6DcUaxGZIfkjC4oBUyc4k7yhETsc4vZAugnqnZs
	ZlyS2NOy76D1RouBbah1ilS64vlXrnZtwg==
X-Google-Smtp-Source: ACHHUZ7IbktyF7a+Tqma5q2g+Se79wPmaUmuN5KMuSWChMV4hHpZKfUBrPiACKG3PXw5QTMqfLKRWQ==
X-Received: by 2002:a05:6a00:b46:b0:64b:f03b:2642 with SMTP id p6-20020a056a000b4600b0064bf03b2642mr932448pfo.23.1686302115007;
        Fri, 09 Jun 2023 02:15:15 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id b9-20020aa78109000000b0065dd1e7c3c2sm2235374pfi.184.2023.06.09.02.15.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 02:15:12 -0700 (PDT)
From: Hangbin Liu <liuhangbin@gmail.com>
To: netdev@vger.kernel.org
Cc: David Ahern <dsahern@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Mahesh Bandewar <maheshb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net] ipvlan: fix bound dev checking for IPv6 l3s mode
Date: Fri,  9 Jun 2023 17:15:02 +0800
Message-Id: <20230609091502.3048339-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The commit 59a0b022aa24 ("ipvlan: Make skb->skb_iif track skb->dev for l3s
mode") fixed ipvlan bonded dev checking by updating skb skb_iif. This fix
works for IPv4, as in raw_v4_input() the dif is from inet_iif(skb), which
is skb->skb_iif when there is no route.

But for IPv6, the fix is not enough, because in ipv6_raw_deliver() ->
raw_v6_match(), the dif is inet6_iif(skb), which is returns IP6CB(skb)->iif
instead of skb->skb_iif if it's not a l3_slave. To fix the IPv6 part
issue. Let's set IP6CB(skb)->iif to correct ifindex.

BTW, ipvlan handles NS/NA specifically. Since it works fine, I will not
reset IP6CB(skb)->iif when addr->atype is IPVL_ICMPV6.

Fixes: c675e06a98a4 ("ipvlan: decouple l3s mode dependencies from other modes")
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2196710
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v2: set IP6CB(skb)->iif instead of setting IP6SKB_L3SLAVE flag
---
 drivers/net/ipvlan/ipvlan_l3s.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ipvlan/ipvlan_l3s.c b/drivers/net/ipvlan/ipvlan_l3s.c
index 71712ea25403..d5b05e803219 100644
--- a/drivers/net/ipvlan/ipvlan_l3s.c
+++ b/drivers/net/ipvlan/ipvlan_l3s.c
@@ -102,6 +102,10 @@ static unsigned int ipvlan_nf_input(void *priv, struct sk_buff *skb,
 
 	skb->dev = addr->master->dev;
 	skb->skb_iif = skb->dev->ifindex;
+#if IS_ENABLED(CONFIG_IPV6)
+	if (addr->atype == IPVL_IPV6)
+		IP6CB(skb)->iif = skb->dev->ifindex;
+#endif
 	len = skb->len + ETH_HLEN;
 	ipvlan_count_rx(addr->master, len, true, false);
 out:
-- 
2.38.1


