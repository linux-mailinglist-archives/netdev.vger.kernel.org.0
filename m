Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5545671F7
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 17:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiGEPCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 11:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232410AbiGEPCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 11:02:14 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B42515FF2;
        Tue,  5 Jul 2022 08:02:01 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id v14so17965305wra.5;
        Tue, 05 Jul 2022 08:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GzLsAsxy95Fx76UEZFPuQaGwMf2vIR+G+ARPeYpyXs4=;
        b=UtZqPl6VuQcFKVyoE0m4M/ucDCoYfxGDoydFFTFdz8JcqeSF5qHI56kr0FmSCRmKQV
         Y05fIA5HjqzAilH2s3+vQTKL8iweuJoqI1X6qyQVBvh0RrhBouebHr9CA0a/fRau3cz3
         fE4hjvSdDLe2lrc+ce78EouI3mDI3sONIS0l1Qq8lxkoOesTg5SPX3tjyRbj1WYbT7jX
         zKNPxJ/q7T8pTNf7Z4icOTZfjOn/DBxelt/9z3uUf3GkOsaSlWfavoEDrzYF3U8SN8Rr
         3eJPo8sjGIcyWgiMo7ZqkzoIkCBKM8HfxRwT9C899dG3YBzlzvP5aMKPZ6oNN+p+GdBY
         SNvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GzLsAsxy95Fx76UEZFPuQaGwMf2vIR+G+ARPeYpyXs4=;
        b=xHVGyNFS4bHobXWdxl/5o3Fs91XYie2TSmNxwLESLBUm9T3lA7xP5PMpv6UHKM0Kc2
         /YF3BqIU2xkjiEsTxX73mK8Z71CyNEXIrPMbrOEeL7+wqFy5tq8qmpplrX0mNYwreOo2
         zw9s9JLV8Vedn6e0XTDxzx7r/Pt0ukhod/AqQ68O1GDs8cOsxHfF5MSdBjdcKUmJgGzy
         psY5WRBUNvAgx67tlFzajUHQH3p3J4yaNCSqr/YUUsHRvQeo55mV6AgWYA+s6thkgdJ2
         BmYED5Wr5vC7oYbgou0KI7HMjnQt+Ge82c214KnMxME7VilRyCs93YEs+BphRU7yxqsx
         reAQ==
X-Gm-Message-State: AJIora/VkQydiLvUwD6nSrORbLFgKK3ooYDvFpMuDdWUlk2ncUTsQyhH
        yYGTTYUuYUSAIuTikovwGV340WADbM7A4A==
X-Google-Smtp-Source: AGRyM1uLLTELWeUDiGk8a+3owFmoMQvgcLMkMVHcxwokk6AYmB+pAUhin1uHsB1AHeKR5c0qfvcZsA==
X-Received: by 2002:a05:6000:1861:b0:21b:a8a2:858d with SMTP id d1-20020a056000186100b0021ba8a2858dmr33600051wri.53.1657033319713;
        Tue, 05 Jul 2022 08:01:59 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id k27-20020adfd23b000000b0021d728d687asm2518200wrh.36.2022.07.05.08.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 08:01:59 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v3 10/25] ipv6/udp: support zc with managed data
Date:   Tue,  5 Jul 2022 16:01:10 +0100
Message-Id: <74c0f3cf7ff2464b0025a590ce9e716adb350be7.1656318994.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1656318994.git.asml.silence@gmail.com>
References: <cover.1656318994.git.asml.silence@gmail.com>
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

Just as with ipv4/udp make ipv6/udp to take advantage of managed data
and propagate SKBFL_MANAGED_FRAG_REFS to skb_zerocopy_iter_dgram().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/ip6_output.c | 57 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 43 insertions(+), 14 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index fc74ce3ed8cc..34eb3b5da5e2 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1542,18 +1542,35 @@ static int __ip6_append_data(struct sock *sk,
 	    rt->dst.dev->features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM))
 		csummode = CHECKSUM_PARTIAL;
 
-	if (flags & MSG_ZEROCOPY && length && sock_flag(sk, SOCK_ZEROCOPY)) {
-		uarg = msg_zerocopy_realloc(sk, length, skb_zcopy(skb));
-		if (!uarg)
-			return -ENOBUFS;
-		extra_uref = !skb_zcopy(skb);	/* only ref on new uarg */
-		if (rt->dst.dev->features & NETIF_F_SG &&
-		    csummode == CHECKSUM_PARTIAL) {
-			paged = true;
-			zc = true;
-		} else {
-			uarg->zerocopy = 0;
-			skb_zcopy_set(skb, uarg, &extra_uref);
+	if ((flags & MSG_ZEROCOPY) && length) {
+		struct msghdr *msg = from;
+
+		if (getfrag == ip_generic_getfrag && msg->msg_ubuf) {
+			if (skb_zcopy(skb) && msg->msg_ubuf != skb_zcopy(skb))
+				return -EINVAL;
+
+			/* Leave uarg NULL if can't zerocopy, callers should
+			 * be able to handle it.
+			 */
+			if ((rt->dst.dev->features & NETIF_F_SG) &&
+			    csummode == CHECKSUM_PARTIAL) {
+				paged = true;
+				zc = true;
+				uarg = msg->msg_ubuf;
+			}
+		} else if (sock_flag(sk, SOCK_ZEROCOPY)) {
+			uarg = msg_zerocopy_realloc(sk, length, skb_zcopy(skb));
+			if (!uarg)
+				return -ENOBUFS;
+			extra_uref = !skb_zcopy(skb);	/* only ref on new uarg */
+			if (rt->dst.dev->features & NETIF_F_SG &&
+			    csummode == CHECKSUM_PARTIAL) {
+				paged = true;
+				zc = true;
+			} else {
+				uarg->zerocopy = 0;
+				skb_zcopy_set(skb, uarg, &extra_uref);
+			}
 		}
 	}
 
@@ -1747,13 +1764,14 @@ static int __ip6_append_data(struct sock *sk,
 				err = -EFAULT;
 				goto error;
 			}
-		} else if (!uarg || !uarg->zerocopy) {
+		} else if (!zc) {
 			int i = skb_shinfo(skb)->nr_frags;
 
 			err = -ENOMEM;
 			if (!sk_page_frag_refill(sk, pfrag))
 				goto error;
 
+			skb_zcopy_downgrade_managed(skb);
 			if (!skb_can_coalesce(skb, i, pfrag->page,
 					      pfrag->offset)) {
 				err = -EMSGSIZE;
@@ -1778,7 +1796,18 @@ static int __ip6_append_data(struct sock *sk,
 			skb->truesize += copy;
 			wmem_alloc_delta += copy;
 		} else {
-			err = skb_zerocopy_iter_dgram(skb, from, copy);
+			struct msghdr *msg = from;
+
+			if (!skb_shinfo(skb)->nr_frags) {
+				if (msg->msg_managed_data)
+					skb_shinfo(skb)->flags |= SKBFL_MANAGED_FRAG_REFS;
+			} else {
+				/* appending, don't mix managed and unmanaged */
+				if (!msg->msg_managed_data)
+					skb_zcopy_downgrade_managed(skb);
+			}
+
+			err = skb_zerocopy_iter_dgram(skb, msg, copy);
 			if (err < 0)
 				goto error;
 		}
-- 
2.36.1

