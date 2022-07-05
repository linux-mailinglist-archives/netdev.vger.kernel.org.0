Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48ADB5671EF
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 17:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbiGEPDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 11:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232664AbiGEPC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 11:02:28 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B171D17AB8;
        Tue,  5 Jul 2022 08:02:09 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id v14so17966064wra.5;
        Tue, 05 Jul 2022 08:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YMXmb32y8VdSZAkM2oglR1DJxfovk6Mh7PEd5Sxoefs=;
        b=jELFjSRlzcn9xlDPOX1/WH9U9Uj9iZljgcpThRvvje5YxcmLuZ7TMQPYVC2rn3V01I
         B0FmKpDsDsUleMfkM+PdZXJtMFwrdRhGUP1f069r775IAQ/s1EHeUKHthiYZneLZQ4+n
         /Aum5A2xzds3LSS25XLQpyutkNP1HZXDWhw3XYRLB160b/CGGga2Sdp2jOFmQLaUQxAg
         bjPDC4x/GatLLnA6P18a0VBczgaYIAafJJb6IOFb0tUxlChWO3FM2gEtAPSJT4hrh3yj
         8ywRJxW/88qz/N23LmNiRn4HWw+a7t2azktkrMoRE13c2smWJSfRPHB9mCVcfYLrclWW
         /pkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YMXmb32y8VdSZAkM2oglR1DJxfovk6Mh7PEd5Sxoefs=;
        b=eed+kd5Tc6w3CagqpzsX8Dsr6ZTlZA61dHNIXTXDi0EqMEOSEKlVEY528wAOHXCBIt
         nRzClxrK2ukkgSJmljjCIs8MxjDG0xDqeleNelq4jwxYjpZy2/tvgtDhJ8eqC7ox+X3c
         AuIbKK4eFn4aGt48riTq9ti4DOujPMr/M0Qje5IMQmf2977M4pQGw/ozfMjF4teMm7T0
         ONlGDVZSNJjqxyAAD1lZS+amprfmHY0FR9x5yzcdzNwK9pd1BndiWivH1+Xo4UhQj77S
         4FJelUDj86IJR3W49wpJsei60PgyeicOU2b0sBqZNYj0DBLYetSdB1DdrennfXywu23L
         KB6w==
X-Gm-Message-State: AJIora/f6f5KQ4ridgIlQcKPiUZ7EHzYm3784X1BvSfgxrXvZQpa//uQ
        XtLDYozCh1yQjrGfxDgbFtgDfHxV4PZopw==
X-Google-Smtp-Source: AGRyM1sO+ytymCyBk1ygSSjz60MpRsgChvHKHCmVQBbLNoyqIVYXSWe5tnugySPYNxhHWGOiduhCgQ==
X-Received: by 2002:a05:6000:a1e:b0:21b:8c8d:3cb5 with SMTP id co30-20020a0560000a1e00b0021b8c8d3cb5mr33104520wrb.372.1657033328765;
        Tue, 05 Jul 2022 08:02:08 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id k27-20020adfd23b000000b0021d728d687asm2518200wrh.36.2022.07.05.08.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 08:02:08 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v3 17/25] io_uring: wire send zc request type
Date:   Tue,  5 Jul 2022 16:01:17 +0100
Message-Id: <c05ea8fc37fb02c086d703f9ff93c25eaf4117a5.1656318994.git.asml.silence@gmail.com>
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

Add a new io_uring opcode IORING_OP_SENDZC. The main distinction from
IORING_OP_SEND is that the user should specify a notification slot
index in sqe::notification_idx and the buffers are safe to reuse only
when the used notification is flushed and completes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |  5 +++
 io_uring/net.c                | 84 +++++++++++++++++++++++++++++++++++
 io_uring/net.h                |  4 ++
 io_uring/opdef.c              | 15 +++++++
 4 files changed, 108 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 9b7ea3e1018f..0e1e179cec1d 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -62,6 +62,10 @@ struct io_uring_sqe {
 	union {
 		__s32	splice_fd_in;
 		__u32	file_index;
+		struct {
+			__u16	notification_idx;
+			__u16	__pad;
+		} __attribute__((packed));
 	};
 	union {
 		struct {
@@ -193,6 +197,7 @@ enum io_uring_op {
 	IORING_OP_GETXATTR,
 	IORING_OP_SOCKET,
 	IORING_OP_URING_CMD,
+	IORING_OP_SENDZC,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/net.c b/io_uring/net.c
index d95c88d83f9f..ef492f1360c8 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -13,6 +13,7 @@
 #include "io_uring.h"
 #include "kbuf.h"
 #include "net.h"
+#include "notif.h"
 
 #if defined(CONFIG_NET)
 struct io_shutdown {
@@ -58,6 +59,14 @@ struct io_sr_msg {
 	unsigned int			flags;
 };
 
+struct io_sendzc {
+	struct file			*file;
+	void __user			*buf;
+	size_t				len;
+	u16				slot_idx;
+	int				msg_flags;
+};
+
 #define IO_APOLL_MULTI_POLLED (REQ_F_APOLL_MULTISHOT | REQ_F_POLLED)
 
 int io_shutdown_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -770,4 +779,79 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 	io_req_set_res(req, ret, 0);
 	return IOU_OK;
 }
+
+int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_sendzc *zc = io_kiocb_to_cmd(req);
+
+	if (READ_ONCE(sqe->ioprio) || READ_ONCE(sqe->addr2) || READ_ONCE(sqe->__pad2[0]))
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
+	msg.msg_managed_data = 0;
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
 #endif
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
index 0be00db9e31c..91d425b43174 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -466,6 +466,21 @@ const struct io_op_def io_op_defs[] = {
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

