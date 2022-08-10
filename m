Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 103F058EFBB
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 17:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbiHJPw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 11:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232330AbiHJPv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 11:51:56 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA7F65A889;
        Wed, 10 Aug 2022 08:51:48 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id z16so18166031wrh.12;
        Wed, 10 Aug 2022 08:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=h9HHmdtmbDaBgAkYhJr0MaG2LsaIMYK3/tGmura3Q/c=;
        b=RkQDnrNrgozMvW1slfCx3exnfLZSPNL0SE3J0CmXcn4NPQmzKH1nUhVoCi4rJ/bGhQ
         qWkiTJzALDavZu1xxA3ht8UtZU4n6tL4iHm1Zx/Em0r6K4Qe5KsTNb1lHxoLPs9CxUrL
         ZNGihmk1LOvOohQDQ1AY3Ulw8RiLhtDxqyohg/rvq0SO7NQvrO7saW7gPAaH7++iBvJP
         Jl1azWCXpOvZRwom0TDdfqiZB33KjKODuKkdpzGyNypg8/uceMD9cO1ihA+jI9r5ZcC3
         TYYoAUSpD/Fkw5BOO1iG7WSOK8lPFUPa6a5TlPYgWBB6P/+e3jyrNxZORTfBjtmz0zUS
         rYzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=h9HHmdtmbDaBgAkYhJr0MaG2LsaIMYK3/tGmura3Q/c=;
        b=0LfNvTPH2qZ+KX9ACd8KRmyHu9J1ET1iWSsVtX1cN61HxUyjR9FbT5JSOkpa1bPx2S
         sxCPDRDRDlQ4GGmJlrsXs+rbQTmjkqNDx40vzRJWxxt0+U1d5ZM3anwNdN73QdW3vQXR
         /nJS+y5M90Vw9bgkkLhL4T/KqOHvHrdlyqg/3x7l12O73dJ8mJj7w2TvLQOxOv3HFb5K
         mQ9Han2qcLIC39zUZP5yuMvUvYRJANsZvKT3kfmR5PcV3EIPERASNER8bR9jDJtcGqEf
         agid8xSFJHCyTZeQnYhEH32LOiEaSRrS0AJzxMspbVInrC3luObq0+0wJDnVV4NwXkLJ
         HjZQ==
X-Gm-Message-State: ACgBeo0BANQt2Qbz9Ye2kVCVr/kJlX1xk75O+ccuY2UjekERRsrqBDKA
        ig4nRVo23PzU0PDWahba4+LyHuL69N8=
X-Google-Smtp-Source: AA6agR6ZNn9gZ3GD3qgxjdOVbL8JXumKhuxwUdsZoAGuCONXxJ2F64wM4uAcQJPM/4Jm+GN1m/z5nQ==
X-Received: by 2002:a5d:634d:0:b0:220:5ff7:3969 with SMTP id b13-20020a5d634d000000b002205ff73969mr16857681wrw.709.1660146706405;
        Wed, 10 Aug 2022 08:51:46 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id ay1-20020a05600c1e0100b003a342933727sm3004519wmb.3.2022.08.10.08.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 08:51:46 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next io_uring 07/11] net/tcp: optimise tcp ubuf refcounting
Date:   Wed, 10 Aug 2022 16:49:15 +0100
Message-Id: <9a42187cdc9ce034fd23179c7b31d7cc6a54bd45.1660124059.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1660124059.git.asml.silence@gmail.com>
References: <cover.1660124059.git.asml.silence@gmail.com>
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

Add UARGFL_CALLER_PINNED letting protocols know that the caller holds a
reference to the ubuf_info and so it doesn't need additional refcounting
for purposes of keeping it alive. With that TCP can save a refcount
put/get pair per send when used with ->msg_ubuf.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/skbuff.h | 7 +++++++
 net/ipv4/tcp.c         | 9 ++++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 2b2e0020030b..45fe7f0648d0 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -522,6 +522,13 @@ enum {
 #define SKBFL_ALL_ZEROCOPY	(SKBFL_ZEROCOPY_FRAG | SKBFL_PURE_ZEROCOPY | \
 				 SKBFL_DONT_ORPHAN | SKBFL_MANAGED_FRAG_REFS)
 
+enum {
+	/* The caller holds a reference during the submission so the ubuf won't
+	 * be freed until we return.
+	 */
+	UARGFL_CALLER_PINNED = BIT(0),
+};
+
 /*
  * The callback notifies userspace to release buffers when skb DMA is done in
  * lower device, the skb last reference should be 0 when calling this.
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 3152da8f4763..4925107de57d 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1229,7 +1229,8 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 
 		if (msg->msg_ubuf) {
 			uarg = msg->msg_ubuf;
-			net_zcopy_get(uarg);
+			if (!(uarg->flags & UARGFL_CALLER_PINNED))
+				net_zcopy_get(uarg);
 			zc = sk->sk_route_caps & NETIF_F_SG;
 		} else if (sock_flag(sk, SOCK_ZEROCOPY)) {
 			uarg = msg_zerocopy_realloc(sk, size, skb_zcopy(skb));
@@ -1455,7 +1456,8 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 		tcp_push(sk, flags, mss_now, tp->nonagle, size_goal);
 	}
 out_nopush:
-	net_zcopy_put(uarg);
+	if (uarg && !(uarg->flags & UARGFL_CALLER_PINNED))
+		net_zcopy_put(uarg);
 	return copied + copied_syn;
 
 do_error:
@@ -1464,7 +1466,8 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 	if (copied + copied_syn)
 		goto out;
 out_err:
-	net_zcopy_put_abort(uarg, true);
+	if (uarg && !(uarg->flags & UARGFL_CALLER_PINNED))
+		net_zcopy_put_abort(uarg, true);
 	err = sk_stream_error(sk, flags, err);
 	/* make sure we wake any epoll edge trigger waiter */
 	if (unlikely(tcp_rtx_and_write_queues_empty(sk) && err == -EAGAIN)) {
-- 
2.37.0

