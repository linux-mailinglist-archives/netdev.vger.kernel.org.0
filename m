Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E556C56A19B
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 13:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235479AbiGGLwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 07:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235299AbiGGLv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 07:51:56 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6D5353D16;
        Thu,  7 Jul 2022 04:51:55 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id f2so20573459wrr.6;
        Thu, 07 Jul 2022 04:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ESIcpqEeOE2H9HSAO2IL96J2/r6CeXO4wnI7QDaH5RY=;
        b=ETAGPzQ+PnLOB4EYa0scFESA86bruvRcElk9b9Y4U3QaxLYnY3HEapY5KF7vHHOhcE
         Jru5X2GfLfm4tWBUt2/5iGhEt26ap25EeNSY5wfDQ6ilDrmZdzjKNLxcOunXTdpQI5Tb
         zoIsE6RmmQFZlv1kJrIUiMzftPYNnBXaCRl8PdLF9ghbDgEPlnQN4G9mp6vwoIss3VOs
         ipfLivLlFlbnldpMsLc4y75Hpx/lSQmTNwxiNCl4uKOC5/UoP7HCIx9FTW4QAh7lJvH3
         aYXy15Nuc9rL3Y6/tjZqBccAULgSunpasWfIdooNQLiLGIgpJ4mzfxFfHG9FyzEVB98w
         fRpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ESIcpqEeOE2H9HSAO2IL96J2/r6CeXO4wnI7QDaH5RY=;
        b=EmXa4TvjUczQpIbt3fmcfInfALHw1SiYglHtJlAlIa8OJMgafUqQpTQpe1IT88PoeI
         OyygbNd67MS3iCzAc6tKJro8D9LkabqzQmmOzhuucaG0BEpm1wIKTKxVMXlgH1+vOjQo
         8Rof+UCt/p37EhZwk8NxWV215/EqRacEMT6Lv1IBjZfzcjDgRsTm6rk55uiOo1RdeOPC
         uW01cR+XR33Gx8NT2zSr1MroDSKZa8wxL+WGXHuFTe/7cXkEOz115Ehh1AmpzEUL8C2A
         g28FyJRi4xP46YY1/FkqJAItyOndlwrJmfbHoSRrRDhhA1PPrcfpbo8L9M1c/hu2EACw
         V5Sw==
X-Gm-Message-State: AJIora8FfxcS/iwUTp7zn7IFLFNkmP+8ARSV/ShLi3/Jq2YhYCzCrJSD
        cXpN0df8dD3sTlubWpdkmCDS+g/c0uCr63U3ayc=
X-Google-Smtp-Source: AGRyM1v14X8QuP8NSNXvusQcO1+QkRk5Shvjz3de8tUHmqUpdtLeG5GxP3tUhITkWq0urrK3mZ3Z/A==
X-Received: by 2002:a05:6000:49:b0:21d:78fe:34b2 with SMTP id k9-20020a056000004900b0021d78fe34b2mr9887745wrx.200.1657194713955;
        Thu, 07 Jul 2022 04:51:53 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u2-20020a5d5142000000b0021b966abc19sm37982131wrt.19.2022.07.07.04.51.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 04:51:53 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v4 06/27] net: Allow custom iter handler in msghdr
Date:   Thu,  7 Jul 2022 12:49:37 +0100
Message-Id: <968c344a59315ec5d0095584a95bb7dd5a3ac617.1657194434.git.asml.silence@gmail.com>
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
index 50f4faeea76c..b3c05efd659f 100644
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
+	if (msg && msg->sg_from_iter && msg->msg_ubuf == skb_zcopy(skb))
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
2.36.1

