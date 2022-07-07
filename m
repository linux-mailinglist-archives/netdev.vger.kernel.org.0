Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 769AE56A169
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 13:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235402AbiGGLwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 07:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235453AbiGGLwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 07:52:03 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E8C53D34;
        Thu,  7 Jul 2022 04:51:59 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id v14so25969780wra.5;
        Thu, 07 Jul 2022 04:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZTUZLAGD0xg3XR59NurEq6qMM4sEJfudbtjDr6igBMU=;
        b=ZbaM22Itbey8Qmo0qJC2eAgd5W0HEUHyRE0WU4J02X+R5zQNCzeE1SVXfLz8VAmTaH
         2rD9xSog+LzLTPzMKc5QxEVP7y1HdtWlhPrjhj5nYIOfdXKMKPc/mmjttMy0Pp3+TVVb
         sL3qfvDF2zLuid2DZU87vS3xb7fHXOAmXeqeqAuBrR6UsXa1z5gFqAAC8K/AtUyUuJ9I
         UFa8n9MPxWxYp5PYUcWlcBt4IQxWk63q5pGJqESOWn1OJhJkUfYPilzVixuMmAbFw/85
         QV116M+knsxqG4Jii6abFksP1ohbd2sggwzdFBcH8He4O7bIfe4LM+55J9lwXjKvbWex
         EmRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZTUZLAGD0xg3XR59NurEq6qMM4sEJfudbtjDr6igBMU=;
        b=mc9f5zVU9bICs+VF+mT8WMKwvyZeXQ9lTocHO8viRPsP+SxZSYwVd92DEl7/oyh+nM
         0zgxnEHEy+UNqMKEQJywzD9G65Lql3hJXTBnHr3aPv0kF6AZKekf4HVBGeSvHTOzId4P
         F0fWrx0ja+K3oo3dR3aacxoLjCh+NjZR2tXAtSKCRzt6jHt4mXbn9zfU8i7Mr5y2ZPAP
         gEHNLKWybSYkyUEXOjKPzlE5Wb/+L/6uDEWXfDdrUxUel9qh1oY+1JjA/EWAdBcoexb/
         xJ85wAeNNaX64/olJbbJo2t/xI1UJfPzgSG/IaawCZuKgz3bdx3n3Ymnv+AgT0HR7rsj
         PhGQ==
X-Gm-Message-State: AJIora/qARRnLk++OK17ZUu7Y70mTZihYjcqnjb9FJawLHPLCPFPXw4Y
        /qZdMgyRo4K+aR8jdtBgCLrvYHqWQlYZXODS9E0=
X-Google-Smtp-Source: AGRyM1tIqtvYjP7ZoJQ2q5+WCvqda5YiQWyK5C2RTxsJkCp3EAIBnVSCnRJqpJersAhf/CmaeMeoyg==
X-Received: by 2002:adf:e405:0:b0:21d:86b6:a286 with SMTP id g5-20020adfe405000000b0021d86b6a286mr2609936wrm.29.1657194717264;
        Thu, 07 Jul 2022 04:51:57 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u2-20020a5d5142000000b0021b966abc19sm37982131wrt.19.2022.07.07.04.51.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 04:51:56 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v4 09/27] ipv4/udp: support externally provided ubufs
Date:   Thu,  7 Jul 2022 12:49:40 +0100
Message-Id: <4b97ab89f424a2e84f6a0a58d6e7baeacbcb6e6b.1657194434.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1657194434.git.asml.silence@gmail.com>
References: <cover.1657194434.git.asml.silence@gmail.com>
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

Teach ipv4/udp how to use external ubuf_info provided in msghdr and
also prepare it for managed frags by sprinkling
skb_zcopy_downgrade_managed() when it could mix managed and not managed
frags.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv4/ip_output.c | 44 +++++++++++++++++++++++++++++++-------------
 1 file changed, 31 insertions(+), 13 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 581d1e233260..df7f9dfbe8be 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1017,18 +1017,35 @@ static int __ip_append_data(struct sock *sk,
 	    (!exthdrlen || (rt->dst.dev->features & NETIF_F_HW_ESP_TX_CSUM)))
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
 
@@ -1192,13 +1209,14 @@ static int __ip_append_data(struct sock *sk,
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
-- 
2.36.1

