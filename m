Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 980ED5671C9
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 17:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbiGEPB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 11:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232076AbiGEPB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 11:01:56 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD911582D;
        Tue,  5 Jul 2022 08:01:53 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id be14-20020a05600c1e8e00b003a04a458c54so7409056wmb.3;
        Tue, 05 Jul 2022 08:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zggj+sxG7/uMjY/uk4DnCUDf8l/BuhDX6aIfTWAW024=;
        b=h4V4gtMnxqGFJcfzYa/zBiYbxwjXmcKp3K2Esev1ZdXtPpNHo6K5WnAE8+UkWxNfvu
         ahhDHRlk+pUkKUjg/p4ZGhQTNn+ughE9Ux1i/qzoAZ5iqC+WRDYjHnMYrTvHc8Y2ph/T
         Id1c0fFHuV9wy/HQjYYUphFzLwZJR3WxBrklScdp0yZM6gUm2bNSAzGsLJZzCDhex/4j
         E6vSbcG/9u1OBugHSLvJlCyNDKCEpBPWjsuqsI6nIoOEitAoyToSdPjnzah9ypvQFybu
         72Oei49YAdWPDk6gYagFr3OD3M6OLyk8U7Decr74BBnoYd4NzKbFaNT8NEOC9U4qZncl
         10KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zggj+sxG7/uMjY/uk4DnCUDf8l/BuhDX6aIfTWAW024=;
        b=azbfqZ3iI85kcZ+G4pYYJprSxuIibc86qI1DjXxb2HKoMLs9RFC4DvRwPMq5X/xLxP
         T8Bn/WjPaqpHtaj4wZl7T6VjFq/C9sozP5ZIL7xkf9z5NTF2vZZqwHm39lH5xDGxxPSP
         QPe3iDtJUmT4ZFuet2zTV9CpOq+X1XPtElgUJy8Wj6fsE9RWH29rznMnPlIg0sDidMxv
         tpYhr7HNky9p0kyCN1PBfZUPbOwnA1bq3MTzFOwJHiCKJ5nrAWU+GSnHwGijhA+0YhpQ
         hxcM82jtLnHcsz9ugMbCoKLFHr0ZXWxkMdQ35kQ3ViYRXu+rkb1QvaPLnoImK7ciK4Kb
         IBdA==
X-Gm-Message-State: AJIora+m8QkdWjErXsB24cpU1jc7nrW2edxku48qgHkkxPAmuS8pFfP6
        pa2IeOSS9PcklKqy3+1twEpU3MUAKQojxQ==
X-Google-Smtp-Source: AGRyM1thdfxrHq4rCONUe845Gw5mKreCs1UB8JGVmFQs5G+ITm5x3AO8/wi8GdkR74gONs+K38b2sA==
X-Received: by 2002:a05:600c:4ca7:b0:3a0:3905:d441 with SMTP id g39-20020a05600c4ca700b003a03905d441mr37364593wmp.159.1657033311818;
        Tue, 05 Jul 2022 08:01:51 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id k27-20020adfd23b000000b0021d728d687asm2518200wrh.36.2022.07.05.08.01.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 08:01:51 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v3 04/25] skbuff: carry external ubuf_info in msghdr
Date:   Tue,  5 Jul 2022 16:01:04 +0100
Message-Id: <6ca7e21d7a0c1abafc51579a8395c8a9d4963efb.1656318994.git.asml.silence@gmail.com>
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

Make possible for network in-kernel callers like io_uring to pass in a
custom ubuf_info by setting it in a new field of struct msghdr.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/socket.h | 7 +++++++
 io_uring/net.c         | 4 ++++
 net/compat.c           | 2 ++
 net/socket.c           | 6 ++++++
 4 files changed, 19 insertions(+)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 17311ad9f9af..ba84ee614d5a 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -66,9 +66,16 @@ struct msghdr {
 	};
 	bool		msg_control_is_user : 1;
 	bool		msg_get_inq : 1;/* return INQ after receive */
+	/*
+	 * The data pages are pinned and won't be released before ->msg_ubuf
+	 * is released. ->msg_iter should point to a bvec and ->msg_ubuf has
+	 * to be non-NULL.
+	 */
+	bool		msg_managed_data : 1;
 	unsigned int	msg_flags;	/* flags on received message */
 	__kernel_size_t	msg_controllen;	/* ancillary data buffer length */
 	struct kiocb	*msg_iocb;	/* ptr to iocb for async requests */
+	struct ubuf_info *msg_ubuf;
 };
 
 struct user_msghdr {
diff --git a/io_uring/net.c b/io_uring/net.c
index 19a805c3814c..d95c88d83f9f 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -255,6 +255,8 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	msg.msg_control = NULL;
 	msg.msg_controllen = 0;
 	msg.msg_namelen = 0;
+	msg.msg_ubuf = NULL;
+	msg.msg_managed_data = false;
 
 	flags = sr->msg_flags;
 	if (issue_flags & IO_URING_F_NONBLOCK)
@@ -525,6 +527,8 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	msg.msg_flags = 0;
 	msg.msg_controllen = 0;
 	msg.msg_iocb = NULL;
+	msg.msg_ubuf = NULL;
+	msg.msg_managed_data = false;
 
 	flags = sr->msg_flags;
 	if (force_nonblock)
diff --git a/net/compat.c b/net/compat.c
index 210fc3b4d0d8..435846fa85e0 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -80,6 +80,8 @@ int __get_compat_msghdr(struct msghdr *kmsg,
 		return -EMSGSIZE;
 
 	kmsg->msg_iocb = NULL;
+	kmsg->msg_ubuf = NULL;
+	kmsg->msg_managed_data = false;
 	*ptr = msg.msg_iov;
 	*len = msg.msg_iovlen;
 	return 0;
diff --git a/net/socket.c b/net/socket.c
index 2bc8773d9dc5..0963a02b1472 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2106,6 +2106,8 @@ int __sys_sendto(int fd, void __user *buff, size_t len, unsigned int flags,
 	msg.msg_control = NULL;
 	msg.msg_controllen = 0;
 	msg.msg_namelen = 0;
+	msg.msg_ubuf = NULL;
+	msg.msg_managed_data = false;
 	if (addr) {
 		err = move_addr_to_kernel(addr, addr_len, &address);
 		if (err < 0)
@@ -2171,6 +2173,8 @@ int __sys_recvfrom(int fd, void __user *ubuf, size_t size, unsigned int flags,
 	msg.msg_namelen = 0;
 	msg.msg_iocb = NULL;
 	msg.msg_flags = 0;
+	msg.msg_ubuf = NULL;
+	msg.msg_managed_data = false;
 	if (sock->file->f_flags & O_NONBLOCK)
 		flags |= MSG_DONTWAIT;
 	err = sock_recvmsg(sock, &msg, flags);
@@ -2409,6 +2413,8 @@ int __copy_msghdr_from_user(struct msghdr *kmsg,
 		return -EMSGSIZE;
 
 	kmsg->msg_iocb = NULL;
+	kmsg->msg_ubuf = NULL;
+	kmsg->msg_managed_data = false;
 	*uiov = msg.msg_iov;
 	*nsegs = msg.msg_iovlen;
 	return 0;
-- 
2.36.1

