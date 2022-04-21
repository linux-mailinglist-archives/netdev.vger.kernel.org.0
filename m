Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE10E50AB35
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 00:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442362AbiDUWLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 18:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442357AbiDUWLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 18:11:46 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D7D4ECC7;
        Thu, 21 Apr 2022 15:08:54 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id o18so4314130qtk.7;
        Thu, 21 Apr 2022 15:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s+6sq0ysocGDxIFzN6SvKoSgHYoC0EoPcLIzL8W1CFY=;
        b=ToZENwONoHcYo2LXuNgbM4UWn8UJ9YxfUdvttrNKIqptVF5j1tzHQ/BSlEYrADBgqx
         ujfO80EJ/Uxk7B3Nq9Wd9EesKFg/566hbov8M0ADvfNO686bBbUc6/TVDPsZz+6XAcrA
         25N7q8+mQHke+ZQvJtI9s+suABrnI0TIO57y/Hey+vNR+SOB0IhjhutAma78EzKt2Fzg
         pJfB2FlmxpnXWfRJB2s0igUo0kZlQdO5LHebJGjutGefGvlLd5ab+URhDqvbOz/SWxhV
         cyi0DT4eyOarrl4/XlWklYPpVB0n6+6iEQvJ2U1UKK13EzMrbo+iFdTttRyIhRuUhCLg
         /YuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s+6sq0ysocGDxIFzN6SvKoSgHYoC0EoPcLIzL8W1CFY=;
        b=bKcMjS5XQwQ4gGdcZGk5mhtDSsh/nTsw02mazg7BwhjoWEcYB0RvXa7Kb+CXc4jQhu
         Y3kEj/HYPjg17aTzVttG3dS1OG9+b3BCPDfhm9AxOn3oe9muigp2v0zOloGCADZv52Ok
         7KRGwzbWScyvkfueR4nDRnljHKlJDffmA5+J3w/9xbSVuLKdUCQmzDdo3fdLUIbehyLx
         BFs+IA5IpoFzAkEe3zbS1lAB1KSYh5rgeVyzfJIx9HmtTHkzPA/xv4JCC5czaOILHJAx
         94Q2Bk3b6dHSzfflWs6mIU/o9YgcyKQbcCde4U+76G9xWR977/7+xN856hHgih9LAtbW
         ZY3Q==
X-Gm-Message-State: AOAM5324VtutqcrbwRUlh5Knomny/FcmX5bunTZ2aMdRrxHgK140cOsX
        pkauphV3xnHBHLeDwmFdrg==
X-Google-Smtp-Source: ABdhPJzrGa6UXwoeFH5ikBt8fZO4x+TqbMwPVjTj3OvYXv+9lkNVybcpJ4JLCRUlLeWrGn+YBW6VWw==
X-Received: by 2002:a05:622a:89:b0:2f1:e85f:e0c2 with SMTP id o9-20020a05622a008900b002f1e85fe0c2mr1221744qtw.362.1650578933909;
        Thu, 21 Apr 2022 15:08:53 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-13-57-97-131.us-west-1.compute.amazonaws.com. [13.57.97.131])
        by smtp.gmail.com with ESMTPSA id f14-20020ac87f0e000000b002f28b077974sm205687qtk.87.2022.04.21.15.08.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 15:08:53 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Peilin Ye <peilin.ye@bytedance.com>, "xeb@mail.ru" <xeb@mail.ru>,
        William Tu <u9012063@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH net 2/3] ip6_gre: Make o_seqno start from 0 in native mode
Date:   Thu, 21 Apr 2022 15:08:38 -0700
Message-Id: <950bfd124e4f87bd9e1acbf6303545875c3681fe.1650575919.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1650575919.git.peilin.ye@bytedance.com>
References: <cover.1650575919.git.peilin.ye@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

For IP6GRE and IP6GRETAP devices, currently o_seqno starts from 1 in
native mode.  According to RFC 2890 2.2., "The first datagram is sent
with a sequence number of 0."  Fix it.

It is worth mentioning that o_seqno already starts from 0 in collect_md
mode, see the "if (tunnel->parms.collect_md)" clause in __gre6_xmit(),
where tunnel->o_seqno is passed to gre_build_header() before getting
incremented.

Fixes: c12b395a4664 ("gre: Support GRE over IPv6")
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 net/ipv6/ip6_gre.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 976236736146..d9e4ac94eab4 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -724,6 +724,7 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 {
 	struct ip6_tnl *tunnel = netdev_priv(dev);
 	__be16 protocol;
+	__be16 flags;
 
 	if (dev->type == ARPHRD_ETHER)
 		IPCB(skb)->flags = 0;
@@ -739,7 +740,6 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 	if (tunnel->parms.collect_md) {
 		struct ip_tunnel_info *tun_info;
 		const struct ip_tunnel_key *key;
-		__be16 flags;
 		int tun_hlen;
 
 		tun_info = skb_tunnel_info_txcheck(skb);
@@ -770,15 +770,14 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 						      : 0);
 
 	} else {
-		if (tunnel->parms.o_flags & TUNNEL_SEQ)
-			tunnel->o_seqno++;
-
 		if (skb_cow_head(skb, dev->needed_headroom ?: tunnel->hlen))
 			return -ENOMEM;
 
-		gre_build_header(skb, tunnel->tun_hlen, tunnel->parms.o_flags,
+		flags = tunnel->parms.o_flags;
+
+		gre_build_header(skb, tunnel->tun_hlen, flags,
 				 protocol, tunnel->parms.o_key,
-				 htonl(tunnel->o_seqno));
+				 (flags & TUNNEL_SEQ) ? htonl(tunnel->o_seqno++) : 0);
 	}
 
 	return ip6_tnl_xmit(skb, dev, dsfield, fl6, encap_limit, pmtu,
-- 
2.20.1

