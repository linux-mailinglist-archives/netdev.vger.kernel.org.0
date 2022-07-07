Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 137AA56A15B
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 13:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235638AbiGGLxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 07:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235156AbiGGLwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 07:52:20 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C699564D4;
        Thu,  7 Jul 2022 04:52:09 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id v16so14510952wrd.13;
        Thu, 07 Jul 2022 04:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Amvyi7sRZQX7XkAF6Fq2XY73IaNyB2jliYXaDHGEkSw=;
        b=LgtKHeRwQp8kc3bowVQfaG5uoBiciMHLDI4xE8lO05CN4PFKm8rkeFfJxErlz+WKG4
         5DaNe9kdJ/XFFVAFUPOedH2uKKRItGyYSMmo4ubjs/OBH+npSMWWChanO2jx04HN+xHw
         HC8KnwM7cG5t8xvmmhvjuYISAdlqGulo2UMM1gtJLh1MRq3pKLRGmh47kfq+zit006EP
         IbIhSCqE6lOTdh7zW9eVFC5uP9R9PaWrBZAWGBRAZIKE5atWdKPkl0KNOd8g0s+hoyX+
         Vm2a4fID/Wifgo+WCrbNv9UsfhA8FxBsOHGFmJMD8M4RGZ4MbANjNcPeVq0DIJ6Pi9hP
         DMSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Amvyi7sRZQX7XkAF6Fq2XY73IaNyB2jliYXaDHGEkSw=;
        b=SM6ka3SoE1cm7NCPVTjRF2X3QOGuRxWbODiDImNIFZruYsX8AhTK48GE2zkXeKf2hA
         bYnbyInv+IRlH2/pS0JTnCHciOvetpFJuV0+TsaZE7L2tD7Pf3XbMJVDCe0tnyf2FLLq
         n2qtI3JFVb9oQ57JFXAcsyPyWO7ELweVNaiImTTgipfxxENPfvnGr2VQckWZvSqm3MHi
         9kqybAoN6SlVdpeDdBJb7d0a/GTh20iYbIoUfBD0R++RD0rhdk9BzONf6UsBfgoH1mEH
         +9QuB4P2XVikptWFtIdQLlCLbLFyA6PBtGWzFBwvfdjheb1aAsH3wqTxEjEYE1QIpCS2
         EcNw==
X-Gm-Message-State: AJIora8a3GcrRb2n/2MOEtfRFHlJaBU0T2mfpanOYyeY30PmYxNOJPYu
        WRKY7JswiMOj+pG+nRzeU451fOcvhEaDKKh7QcQ=
X-Google-Smtp-Source: AGRyM1u+Fgit1dS8q9qiJpXoytStaVe7gbAJgCir8piHfRZZV7m5IgORR6eRcoAWJDBY47weToyGNQ==
X-Received: by 2002:a05:6000:49:b0:21d:78fe:34b2 with SMTP id k9-20020a056000004900b0021d78fe34b2mr9888737wrx.200.1657194728558;
        Thu, 07 Jul 2022 04:52:08 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u2-20020a5d5142000000b0021b966abc19sm37982131wrt.19.2022.07.07.04.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 04:52:08 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v4 19/27] io_uring: wire send zc request type
Date:   Thu,  7 Jul 2022 12:49:50 +0100
Message-Id: <073ee4f43806aa79b1715d52417944c99e9c5675.1657194434.git.asml.silence@gmail.com>
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

Add a new io_uring opcode IORING_OP_SENDZC. The main distinction from
IORING_OP_SEND is that the user should specify a notification slot
index in sqe::notification_idx and the buffers are safe to reuse only
when the used notification is flushed and completes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |  5 ++
 io_uring/net.c                | 94 +++++++++++++++++++++++++++++++++++
 io_uring/net.h                |  4 ++
 io_uring/opdef.c              | 15 ++++++
 4 files changed, 118 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index f1ba8e934168..a6844908772a 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -63,6 +63,10 @@ struct io_uring_sqe {
 	union {
 		__s32	splice_fd_in;
 		__u32	file_index;
+		struct {
+			__u16	notification_idx;
+			__u16	__pad;
+		};
 	};
 	union {
 		struct {
@@ -194,6 +198,7 @@ enum io_uring_op {
 	IORING_OP_GETXATTR,
 	IORING_OP_SOCKET,
 	IORING_OP_URING_CMD,
+	IORING_OP_SENDZC,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/net.c b/io_uring/net.c
index 2dd61fcf91d8..399267e8f1ef 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -13,6 +13,7 @@
 #include "io_uring.h"
 #include "kbuf.h"
 #include "net.h"
+#include "notif.h"
 
 #if defined(CONFIG_NET)
 struct io_shutdown {
@@ -58,6 +59,15 @@ struct io_sr_msg {
 	unsigned int			flags;
 };
 
+struct io_sendzc {
+	struct file			*file;
+	void __user			*buf;
+	size_t				len;
+	u16				slot_idx;
+	unsigned			msg_flags;
+	unsigned			flags;
+};
+
 #define IO_APOLL_MULTI_POLLED (REQ_F_APOLL_MULTISHOT | REQ_F_POLLED)
 
 int io_shutdown_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -652,6 +662,90 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	return ret;
 }
 
+int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_sendzc *zc = io_kiocb_to_cmd(req);
+
+	if (READ_ONCE(sqe->addr2) || READ_ONCE(sqe->__pad2[0]) ||
+	    READ_ONCE(sqe->addr3))
+		return -EINVAL;
+
+	zc->flags = READ_ONCE(sqe->ioprio);
+	if (zc->flags & ~IORING_RECVSEND_POLL_FIRST)
+		return -EINVAL;
+
+	zc->buf = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	zc->len = READ_ONCE(sqe->len);
+	zc->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
+	zc->slot_idx = READ_ONCE(sqe->notification_idx);
+	if (zc->msg_flags & MSG_DONTWAIT)
+		req->flags |= REQ_F_NOWAIT;
+#ifdef CONFIG_COMPAT
+	if (req->ctx->compat)
+		zc->msg_flags |= MSG_CMSG_COMPAT;
+#endif
+	return 0;
+}
+
+int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_sendzc *zc = io_kiocb_to_cmd(req);
+	struct io_notif_slot *notif_slot;
+	struct io_notif *notif;
+	struct msghdr msg;
+	struct iovec iov;
+	struct socket *sock;
+	unsigned msg_flags;
+	int ret, min_ret = 0;
+
+	if (!(req->flags & REQ_F_POLLED) &&
+	    (zc->flags & IORING_RECVSEND_POLL_FIRST))
+		return -EAGAIN;
+
+	if (issue_flags & IO_URING_F_UNLOCKED)
+		return -EAGAIN;
+	sock = sock_from_file(req->file);
+	if (unlikely(!sock))
+		return -ENOTSOCK;
+
+	notif_slot = io_get_notif_slot(ctx, zc->slot_idx);
+	if (!notif_slot)
+		return -EINVAL;
+	notif = io_get_notif(ctx, notif_slot);
+	if (!notif)
+		return -ENOMEM;
+
+	msg.msg_name = NULL;
+	msg.msg_control = NULL;
+	msg.msg_controllen = 0;
+	msg.msg_namelen = 0;
+
+	ret = import_single_range(WRITE, zc->buf, zc->len, &iov, &msg.msg_iter);
+	if (unlikely(ret))
+		return ret;
+
+	msg_flags = zc->msg_flags | MSG_ZEROCOPY;
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		msg_flags |= MSG_DONTWAIT;
+	if (msg_flags & MSG_WAITALL)
+		min_ret = iov_iter_count(&msg.msg_iter);
+
+	msg.msg_flags = msg_flags;
+	msg.msg_ubuf = &notif->uarg;
+	msg.sg_from_iter = NULL;
+	ret = sock_sendmsg(sock, &msg);
+
+	if (unlikely(ret < min_ret)) {
+		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
+			return -EAGAIN;
+		return ret == -ERESTARTSYS ? -EINTR : ret;
+	}
+
+	io_req_set_res(req, ret, 0);
+	return IOU_OK;
+}
+
 int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_accept *accept = io_kiocb_to_cmd(req);
diff --git a/io_uring/net.h b/io_uring/net.h
index 81d71d164770..1dba8befebb3 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -40,4 +40,8 @@ int io_socket(struct io_kiocb *req, unsigned int issue_flags);
 int io_connect_prep_async(struct io_kiocb *req);
 int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_connect(struct io_kiocb *req, unsigned int issue_flags);
+
+int io_sendzc(struct io_kiocb *req, unsigned int issue_flags);
+int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+
 #endif
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index a7b84b43e6c2..8419b50c1d3b 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -470,6 +470,21 @@ const struct io_op_def io_op_defs[] = {
 		.issue			= io_uring_cmd,
 		.prep_async		= io_uring_cmd_prep_async,
 	},
+	[IORING_OP_SENDZC] = {
+		.name			= "SENDZC",
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
+		.audit_skip		= 1,
+		.ioprio			= 1,
+#if defined(CONFIG_NET)
+		.prep			= io_sendzc_prep,
+		.issue			= io_sendzc,
+#else
+		.prep			= io_eopnotsupp_prep,
+#endif
+
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
-- 
2.36.1

