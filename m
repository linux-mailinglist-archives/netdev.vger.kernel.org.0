Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A75D55727EA
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 22:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233176AbiGLUxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 16:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233956AbiGLUxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 16:53:41 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD8ACEB9F;
        Tue, 12 Jul 2022 13:53:16 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id ay25so5410710wmb.1;
        Tue, 12 Jul 2022 13:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XCXfZmOW7gRJPeEUDxdP0X8k7tXP2rnXiHz0tBC0xrs=;
        b=k1XhABbbyFgYPio4xnYEEE2npAsh4iDTVRFhYdo9Tx8++hkR70imBU2qduW2nZ9qnp
         KQl555FWZyHML+pXridL1VGARny18hsV1emlz/9tZEbWzTR5KdRVtJnvWWgO5EFjABsy
         suGFOBfgzTjImHdKx71+pNYBqguuZ8hjn3/slhuOaHQbA6Fa8N3/Dykcf4jY6j2w+oXQ
         rZnxvOEsgJqWl7s+p7caUm1ngatv9GgsVsO+CbAIHWKz3KtItzzAwjyObtttSdqA8y+H
         Pw8HdkK7tCHHsRUMo8E8PgV6tSjz5z5721WGP/AEayk78SOkdZOENbQUu1lJ6X4OjYB6
         Yldw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XCXfZmOW7gRJPeEUDxdP0X8k7tXP2rnXiHz0tBC0xrs=;
        b=q8YaOEK/s+lOb2rBO2qhnM9l0fQ8vWxIhimG4qIa/8lQW8oI9Vt/jnM/SdEfPhMXPr
         iAG/vmVTC0bUPoHxNHIRr432uHI9ph6mpF3Ti2vO9Ek71h5FZk+K77RglxbRGNAOq4bU
         zRQznBujfC9N336Mo7E0lQil4wwqtnUgrFonmsVtQDH58WzDplVK7QTL5GDxHuj+Af50
         maHnAD6SudmUEGpsMrhbKp1v7XZm78i0GV5kUtjet/OUfztQZkagu3ZVH1EibpWn5wzF
         kfbg+08XxhUQtlPbtFaRjmsMpR2cmVNT8LVgikMR3bVmzKyEiXr/nbi4A6Gk3KZfl/zQ
         GDJw==
X-Gm-Message-State: AJIora9JS3BOUJ8GLAgydEhZTMXsDMOLcrZ8u7//MvI5Iz8O1pnQfIg4
        ovLaAkLB7xYo6ThOAUppxEBpqGMVmPo=
X-Google-Smtp-Source: AGRyM1tN6uTuVFmURH7snLFs7M0nKdVHmKgEPj3Qw/eV+oN8YQDLh9pb98++A5OJlJxBbvvRx4s6LA==
X-Received: by 2002:a05:600c:3788:b0:3a2:f2a5:4e61 with SMTP id o8-20020a05600c378800b003a2f2a54e61mr2295347wmr.196.1657659194472;
        Tue, 12 Jul 2022 13:53:14 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id c14-20020a7bc00e000000b003a044fe7fe7sm89833wmb.9.2022.07.12.13.53.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 13:53:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v5 06/27] net: Allow custom iter handler in msghdr
Date:   Tue, 12 Jul 2022 21:52:30 +0100
Message-Id: <a8974e7f0ec87fd1500c1e71dad28d6b7a376818.1657643355.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1657643355.git.asml.silence@gmail.com>
References: <cover.1657643355.git.asml.silence@gmail.com>
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

From: David Ahern <dsahern@kernel.org>

Add support for custom iov_iter handling to msghdr. The idea is that
in-kernel subsystems want control over how an SG is split.

Signed-off-by: David Ahern <dsahern@kernel.org>
[pavel: move callback into msghdr]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/skbuff.h |  7 ++++---
 include/linux/socket.h |  4 ++++
 net/core/datagram.c    | 14 ++++++++++----
 net/core/skbuff.c      |  2 +-
 4 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 8e12b3b9ad6c..a8a2dd4cfdfd 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1776,13 +1776,14 @@ void msg_zerocopy_put_abort(struct ubuf_info *uarg, bool have_uref);
 void msg_zerocopy_callback(struct sk_buff *skb, struct ubuf_info *uarg,
 			   bool success);
 
-int __zerocopy_sg_from_iter(struct sock *sk, struct sk_buff *skb,
-			    struct iov_iter *from, size_t length);
+int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
+			    struct sk_buff *skb, struct iov_iter *from,
+			    size_t length);
 
 static inline int skb_zerocopy_iter_dgram(struct sk_buff *skb,
 					  struct msghdr *msg, int len)
 {
-	return __zerocopy_sg_from_iter(skb->sk, skb, &msg->msg_iter, len);
+	return __zerocopy_sg_from_iter(msg, skb->sk, skb, &msg->msg_iter, len);
 }
 
 int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
diff --git a/include/linux/socket.h b/include/linux/socket.h
index 7bac9fc1cee0..3c11ef18a9cf 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -14,6 +14,8 @@ struct file;
 struct pid;
 struct cred;
 struct socket;
+struct sock;
+struct sk_buff;
 
 #define __sockaddr_check_size(size)	\
 	BUILD_BUG_ON(((size) > sizeof(struct __kernel_sockaddr_storage)))
@@ -70,6 +72,8 @@ struct msghdr {
 	__kernel_size_t	msg_controllen;	/* ancillary data buffer length */
 	struct kiocb	*msg_iocb;	/* ptr to iocb for async requests */
 	struct ubuf_info *msg_ubuf;
+	int (*sg_from_iter)(struct sock *sk, struct sk_buff *skb,
+			    struct iov_iter *from, size_t length);
 };
 
 struct user_msghdr {
diff --git a/net/core/datagram.c b/net/core/datagram.c
index 50f4faeea76c..28cdb79df74d 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -613,10 +613,16 @@ int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
 }
 EXPORT_SYMBOL(skb_copy_datagram_from_iter);
 
-int __zerocopy_sg_from_iter(struct sock *sk, struct sk_buff *skb,
-			    struct iov_iter *from, size_t length)
+int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
+			    struct sk_buff *skb, struct iov_iter *from,
+			    size_t length)
 {
-	int frag = skb_shinfo(skb)->nr_frags;
+	int frag;
+
+	if (msg && msg->sg_from_iter)
+		return msg->sg_from_iter(sk, skb, from, length);
+
+	frag = skb_shinfo(skb)->nr_frags;
 
 	while (length && iov_iter_count(from)) {
 		struct page *pages[MAX_SKB_FRAGS];
@@ -702,7 +708,7 @@ int zerocopy_sg_from_iter(struct sk_buff *skb, struct iov_iter *from)
 	if (skb_copy_datagram_from_iter(skb, 0, from, copy))
 		return -EFAULT;
 
-	return __zerocopy_sg_from_iter(NULL, skb, from, ~0U);
+	return __zerocopy_sg_from_iter(NULL, NULL, skb, from, ~0U);
 }
 EXPORT_SYMBOL(zerocopy_sg_from_iter);
 
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index fc22b3d32052..f5a3ebbc1f7e 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1358,7 +1358,7 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
 	if (orig_uarg && uarg != orig_uarg)
 		return -EEXIST;
 
-	err = __zerocopy_sg_from_iter(sk, skb, &msg->msg_iter, len);
+	err = __zerocopy_sg_from_iter(msg, sk, skb, &msg->msg_iter, len);
 	if (err == -EFAULT || (err == -EMSGSIZE && skb->len == orig_len)) {
 		struct sock *save_sk = skb->sk;
 
-- 
2.37.0

