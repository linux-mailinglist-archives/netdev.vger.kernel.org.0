Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB911D7069
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 07:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgERFf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 01:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbgERFf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 01:35:29 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD176C061A0C
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 22:35:28 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id q9so4488815pjm.2
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 22:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=n5rBrLqTSNuecLSarBrAncb2ZKihnbMFkUgkJ3BSmZ8=;
        b=rTsgpFaOqFylOG05PnTbNPz54bCYvr5cqXlmY988D7sA/YU/q6VEU1CyS+TEYtxhwv
         aVS9epVqowPougKGtEeJwXZKkh5SJ/9qomJDqcBLbw6SM+CYjWzMk154kRePDV3HDepN
         r9dscfBwNUJujyaCgBQvXf6dnnj+BMcVYPBWXPESVpKZP6euWRUNgRV9Y0IJ1FQEZTz5
         c9L7UeCrZIt4bEazbeeFNjQMvTqdHGzji7m0B1ALYv6HXlrOvnEM+yw1VtitoMPjpbg3
         BNR+cReMgJ67srFbsMzKrFvsSLtj23R68XO5JvTUDL8HlQ0U+rpjB0G0XHkjldf/2id4
         uRVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=n5rBrLqTSNuecLSarBrAncb2ZKihnbMFkUgkJ3BSmZ8=;
        b=bWDbmZ/bUSo8Il450LuHxcCJbK4fBN+N0H0cFWf6K5kbPW/rlyI8D7587jBt25PaCx
         G5RyJF5XetS2zsvgttInD9X96va4iLS53X+hEIJPSA7l/A9zbyNotktIMRF8gnkDkkgG
         LLKbVekTyJ6XHW/oIFh+cnp1jq9tMLRC4xt2Ss7s7h2qkpHgq9vFGOn35mZOQXjUeohm
         kcaj40kAROIiE+GnS4Oem3GroWz3VEfVOI5aVRNb5tvnMyXGD+YBhidYrk4Q8VGk9hms
         sC7yUjKkP6fmbYbCbJIkiZhjFbBKVo8YBtvavlNJ8hjbeEx7Jn0U6ws8+evTgaX8IUMq
         Gg3A==
X-Gm-Message-State: AOAM531lt0w9W4e0brv9u+MSeWmQUmGlmYLbCGCvbXzBXJbhk3i4mWA5
        lEgP1mwmNGaxaAzv8Lp+q5LT+hZ+
X-Google-Smtp-Source: ABdhPJzeg6aWdakWlemg6zyB9uemi0PWm1Ng8AZVFBtgoOpwdZdaOYlzG6zxnWL/08QZ0xNxSG7SrQ==
X-Received: by 2002:a17:902:bc89:: with SMTP id bb9mr14992928plb.101.1589780128018;
        Sun, 17 May 2020 22:35:28 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j16sm7535776pfa.179.2020.05.17.22.35.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 17 May 2020 22:35:27 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec] esp4: improve xfrm4_beet_gso_segment() to be more readable
Date:   Mon, 18 May 2020 13:35:19 +0800
Message-Id: <ad586dda50caf7a29cb1d8b760d38d550a662bc9.1589780119.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to improve the code to make xfrm4_beet_gso_segment()
more readable, and keep consistent with xfrm6_beet_gso_segment().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/esp4_offload.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 9b1d451..d14133e 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -141,20 +141,23 @@ static struct sk_buff *xfrm4_beet_gso_segment(struct xfrm_state *x,
 
 	skb->transport_header += x->props.header_len;
 
-	if (proto == IPPROTO_BEETPH) {
-		struct ip_beet_phdr *ph = (struct ip_beet_phdr *)skb->data;
-
-		skb->transport_header += ph->hdrlen * 8;
-		proto = ph->nexthdr;
-	} else if (x->sel.family == AF_INET6) {
+	if (x->sel.family != AF_INET6) {
+		if (proto == IPPROTO_BEETPH) {
+			struct ip_beet_phdr *ph =
+				(struct ip_beet_phdr *)skb->data;
+
+			skb->transport_header += ph->hdrlen * 8;
+			proto = ph->nexthdr;
+		} else {
+			skb->transport_header -= IPV4_BEET_PHMAXLEN;
+		}
+	} else {
 		__be16 frag;
 
 		skb->transport_header +=
 			ipv6_skip_exthdr(skb, 0, &proto, &frag);
 		if (proto == IPPROTO_TCP)
 			skb_shinfo(skb)->gso_type |= SKB_GSO_TCPV4;
-	} else {
-		skb->transport_header -= IPV4_BEET_PHMAXLEN;
 	}
 
 	__skb_pull(skb, skb_transport_offset(skb));
-- 
2.1.0

