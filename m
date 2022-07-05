Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D352E5671E6
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 17:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbiGEPEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 11:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232897AbiGEPCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 11:02:36 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 493111583E;
        Tue,  5 Jul 2022 08:02:13 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id f190so7203896wma.5;
        Tue, 05 Jul 2022 08:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JHn8PFoK9H3KRsAlXjeVIwINrsajhaim20tJSDCud8k=;
        b=hG6Eqe7Xq3ndQPQF0PoPd/7qQ9L5ZrNhYi+zqVKfXIQ511zGtm6EWAMzoDMLwDJxPG
         dUF0BQpxFT+Fout1GLI9EAP5EFJbuYOasnEHZQmpGBAh/lubd4LdmBoCfPX0SqXIi0k9
         iZr0q+ARCS70OFI2YqFNAeByRIurmt+xAv5sEMdC1i/KXQpenRJSSA+GIm7JLPFGPy6p
         xt+jAAYyIGfNpFlXjNj1i9KtbYXo473dvhk+Z/M1cMrmoa1eUrAajbKuds7vntrYEQpf
         SZTuU2dlCe5pKqeAux6EqGMF21sdw1E+OMOKyVaFh+uEraxtPATPmCMvino6oTPrKC9l
         3wXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JHn8PFoK9H3KRsAlXjeVIwINrsajhaim20tJSDCud8k=;
        b=6qeDS/yQlmWk+pd58Bh0xNwga2qub83lKkA3Q2iIu0a10smm9Eh6D4lFDe5eiaR8xT
         SbZOIIJ4agjt/NEaf5w/5KYMxDM4uqjPjPDDtAoC7oyQLZGkd7UPh/v0H4DA0oOM00xX
         qtd80loHBWH9//K+LgakfTHK4W9vYMlXrlka2+WU88fsyVBGb004Cyeb3kCokfBcmQsJ
         M4Drc7IFc4oB3u8lN/bJKa8BSm4KE0cGgKlqlnG4dPYHqzOTCKjXE/9TdzzbOYB/D2Zb
         OsoyJaLq5FlI2DL2Y0YvvmyqJMpWe0KXcmc9mwVtKbOT43kArRoaig0wDhyhNhTrQsTq
         FBEA==
X-Gm-Message-State: AJIora+u0YBJKKmeViEClZ/URpMg8MrI/0clWV+3DxBYLjokkrbMe+y+
        69nWs/s6jYbRxA8IQA3Rjo0bzm6t51uMtQ==
X-Google-Smtp-Source: AGRyM1vcEp0B1UCb1qIt6dc5FJfBScUe8SB25U5gF337Z0QPQD5gMSBhYyz1hmfu6KJxYWshqfehuQ==
X-Received: by 2002:a05:600c:4f54:b0:3a0:4a5b:2692 with SMTP id m20-20020a05600c4f5400b003a04a5b2692mr37580727wmq.109.1657033331360;
        Tue, 05 Jul 2022 08:02:11 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id k27-20020adfd23b000000b0021d728d687asm2518200wrh.36.2022.07.05.08.02.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 08:02:10 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v3 19/25] io_uring: allow to pass addr into sendzc
Date:   Tue,  5 Jul 2022 16:01:19 +0100
Message-Id: <d67af76030bfd2e84f5c22f20d8185d6e7cef17f.1656318994.git.asml.silence@gmail.com>
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

Allow to specify an address to zerocopy sends making it more like
sendto(2).

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |  2 +-
 io_uring/net.c                | 17 ++++++++++++++++-
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 0e1e179cec1d..abb8a9502f6e 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -64,7 +64,7 @@ struct io_uring_sqe {
 		__u32	file_index;
 		struct {
 			__u16	notification_idx;
-			__u16	__pad;
+			__u16	addr_len;
 		} __attribute__((packed));
 	};
 	union {
diff --git a/io_uring/net.c b/io_uring/net.c
index d5b00e07e72b..e63dda89c222 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -65,6 +65,8 @@ struct io_sendzc {
 	size_t				len;
 	u16				slot_idx;
 	int				msg_flags;
+	int				addr_len;
+	void __user			*addr;
 };
 
 #define IO_APOLL_MULTI_POLLED (REQ_F_APOLL_MULTISHOT | REQ_F_POLLED)
@@ -784,7 +786,7 @@ int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_sendzc *zc = io_kiocb_to_cmd(req);
 
-	if (READ_ONCE(sqe->ioprio) || READ_ONCE(sqe->addr2) || READ_ONCE(sqe->__pad2[0]))
+	if (READ_ONCE(sqe->ioprio) || READ_ONCE(sqe->__pad2[0]))
 		return -EINVAL;
 
 	zc->buf = u64_to_user_ptr(READ_ONCE(sqe->addr));
@@ -793,6 +795,10 @@ int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	zc->slot_idx = READ_ONCE(sqe->notification_idx);
 	if (zc->msg_flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
+
+	zc->addr = u64_to_user_ptr(READ_ONCE(sqe->addr2));
+	zc->addr_len = READ_ONCE(sqe->addr_len);
+
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
 		zc->msg_flags |= MSG_CMSG_COMPAT;
@@ -802,6 +808,7 @@ int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 {
+	struct sockaddr_storage address;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_sendzc *zc = io_kiocb_to_cmd(req);
 	struct io_notif_slot *notif_slot;
@@ -836,6 +843,14 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 		return ret;
 	mm_account_pinned_pages(&notif->uarg.mmp, zc->len);
 
+	if (zc->addr) {
+		ret = move_addr_to_kernel(zc->addr, zc->addr_len, &address);
+		if (unlikely(ret < 0))
+			return ret;
+		msg.msg_name = (struct sockaddr *)&address;
+		msg.msg_namelen = zc->addr_len;
+	}
+
 	msg_flags = zc->msg_flags | MSG_ZEROCOPY;
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		msg_flags |= MSG_DONTWAIT;
-- 
2.36.1

