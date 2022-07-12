Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 909755727F0
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 22:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234041AbiGLUxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 16:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231857AbiGLUxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 16:53:37 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52869CEB8B;
        Tue, 12 Jul 2022 13:53:15 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id h17so12872942wrx.0;
        Tue, 12 Jul 2022 13:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gX+xYQxM94KdtlI7YGh/i2Kh7GR2uKZ7IifaNrt+CnI=;
        b=qwHfey5WrSh60CwhUhPpq9J8tMgPyA7SZrCS0uF/kzXsPtQ8Qk713E1Zm8O7OEwpli
         BEhdg+7WlQv0h4u5QBgCsk/caRl+1HXHwz84/fL63Oz/UD+QWjJNCoR44z77rirM68xS
         yh4m0OkzkPcCrPHX0m3uMruKKKfY/+u8w7BJGitMF062xQYL0SXHbKAeR09KLaNY5FZH
         syKClEWRPA48a8VLoxlYcPPxN9Sj0j++LO8k4BTQdUOErukuiiWP8+u2rDsuygIV+0xP
         a2ybPvIDpHK/VFiBVVjs9vMnc8PZlCx3p4M45yniprJGOQXUF+kKnIusZrcrdL/WTG7o
         Xvvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gX+xYQxM94KdtlI7YGh/i2Kh7GR2uKZ7IifaNrt+CnI=;
        b=7YauKXK8kAFhqSGt63X2d+NGtKaXOreDSaUmPmoNPtVbDCw1DXm7SFnVXle+w2Rp3g
         ZCtGyaq9KNuwEei81kZP26ZuKY9QAoaAee7eJZAw+ft3FerhtsEDWZvyeNrqOS/l7CsV
         B84IENg1jbLAQrGGbyIOLEOZz7qPYO5oRWKfU8F8Y8py1B4OlCz5KhfcmHPjdI5kFhh3
         J+RYnxbDS84VqGWHJMjd2tYjUySOJZCGoxJ2SvobzMRfeZKwYZm35Xs8vQDnETWtvw3m
         EQGvFQpap1olEqtP0WuPGd99UDTGATMNck1PHjBQ2Go/YQwBVJeJJe/X18ahLm9PICeq
         eE5Q==
X-Gm-Message-State: AJIora9rOpUZVl4lQdZA07iVDzi0HXvzH0bAF8kSg//5LnoJUlz9xBQS
        xDiid21C+wfmxCzoSNlx6BruYIjwjQ4=
X-Google-Smtp-Source: AGRyM1vJO6/TlD4KPbS4LApDW2ydFy9CLGTsitQWz16pq4eg5pqazjcj6Muji88ifwzIrnA1KmbRDw==
X-Received: by 2002:adf:eccb:0:b0:21d:7b41:22c7 with SMTP id s11-20020adfeccb000000b0021d7b4122c7mr22293206wro.543.1657659193344;
        Tue, 12 Jul 2022 13:53:13 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id c14-20020a7bc00e000000b003a044fe7fe7sm89833wmb.9.2022.07.12.13.53.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 13:53:12 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v5 05/27] skbuff: carry external ubuf_info in msghdr
Date:   Tue, 12 Jul 2022 21:52:29 +0100
Message-Id: <2c3ce22ec6939856cef4329d8c95e4c8dfb355d8.1657643355.git.asml.silence@gmail.com>
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

Make possible for network in-kernel callers like io_uring to pass in a
custom ubuf_info by setting it in a new field of struct msghdr.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/socket.h | 1 +
 net/compat.c           | 1 +
 net/socket.c           | 3 +++
 3 files changed, 5 insertions(+)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 17311ad9f9af..7bac9fc1cee0 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -69,6 +69,7 @@ struct msghdr {
 	unsigned int	msg_flags;	/* flags on received message */
 	__kernel_size_t	msg_controllen;	/* ancillary data buffer length */
 	struct kiocb	*msg_iocb;	/* ptr to iocb for async requests */
+	struct ubuf_info *msg_ubuf;
 };
 
 struct user_msghdr {
diff --git a/net/compat.c b/net/compat.c
index 210fc3b4d0d8..6cd2e7683dd0 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -80,6 +80,7 @@ int __get_compat_msghdr(struct msghdr *kmsg,
 		return -EMSGSIZE;
 
 	kmsg->msg_iocb = NULL;
+	kmsg->msg_ubuf = NULL;
 	*ptr = msg.msg_iov;
 	*len = msg.msg_iovlen;
 	return 0;
diff --git a/net/socket.c b/net/socket.c
index 2bc8773d9dc5..ed061609265e 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2106,6 +2106,7 @@ int __sys_sendto(int fd, void __user *buff, size_t len, unsigned int flags,
 	msg.msg_control = NULL;
 	msg.msg_controllen = 0;
 	msg.msg_namelen = 0;
+	msg.msg_ubuf = NULL;
 	if (addr) {
 		err = move_addr_to_kernel(addr, addr_len, &address);
 		if (err < 0)
@@ -2171,6 +2172,7 @@ int __sys_recvfrom(int fd, void __user *ubuf, size_t size, unsigned int flags,
 	msg.msg_namelen = 0;
 	msg.msg_iocb = NULL;
 	msg.msg_flags = 0;
+	msg.msg_ubuf = NULL;
 	if (sock->file->f_flags & O_NONBLOCK)
 		flags |= MSG_DONTWAIT;
 	err = sock_recvmsg(sock, &msg, flags);
@@ -2409,6 +2411,7 @@ int __copy_msghdr_from_user(struct msghdr *kmsg,
 		return -EMSGSIZE;
 
 	kmsg->msg_iocb = NULL;
+	kmsg->msg_ubuf = NULL;
 	*uiov = msg.msg_iov;
 	*nsegs = msg.msg_iovlen;
 	return 0;
-- 
2.37.0

