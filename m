Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 211A0572821
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 22:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234351AbiGLUzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 16:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234117AbiGLUyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 16:54:37 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B4ABE04;
        Tue, 12 Jul 2022 13:53:36 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id h17so12873849wrx.0;
        Tue, 12 Jul 2022 13:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f+FHjKfi2Y2wFGJfFsXW/4+JIVb8vNyaCizWsPOe68o=;
        b=MjxNJFqouObPHfpi8IsDm/+O6nzEcjAIdJ+Fha0uNZ13V0q9H1ytmdFC0fKg1WmIKp
         TEzghd9lE5wZllrdF3EA2agJw3M8v9Rbqu1gzKbAvtVbKSKCSFHwT2tyN5ClMx440+k9
         72H184I4b0fRQQ9BCQIf2YjqhI4VKnMdhFkEivQxXHPoXWe6ysqjnSIGEAXAJloYPzu9
         4WTO1fqNkAXD7rngWOTHgxlcJdjdQjkAIRvDw1pqfqUdbk41nllVECOcIpQDXbBxLh2X
         jYHd6PqmpKMCJb3utCcp7w50P57l5VOQ/EEx/+GpGbxY03+Y5/Fs/33O+yfuWs+BaJ2v
         Yl7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f+FHjKfi2Y2wFGJfFsXW/4+JIVb8vNyaCizWsPOe68o=;
        b=pB0RMx9kOBrJLeweUHHuMf7LNvrOIYyeKW5iOfI+1Uq77aHTe/ZOHTDTp0YHUFUhzK
         4H+kqleTiDe5xZmrBu+2ZUhRstOdnyDrgWldJjDGCfcajUHvWwvtguhuWyRCXp2W4w3u
         xQhp/tZ4LaR4/46qL8m6NTXBkPZFvOqcuaiyh5hav+jy+j1lkOzCP5GLEc4DFf+wncB7
         bEwQ11kZj3iTDeaB2TU7zbz6Qc5hbpNZ97DcbX/UDY7Z3UmIkCPtrfv0B3TNfH3DIqcG
         uk4quGrSR5opB781KR6St3Ghu4KAqrjUEYA/SX71QdTdPZCVjC2KNJshk0/ViWkuSJ/a
         FjXw==
X-Gm-Message-State: AJIora+uH9jfWOHelhHuyTQkNACyKKyRyw2SL5hDpOAaUnGZFQf5VDBc
        a/x3mhZBMYf1A3y6sxR6OOPwI66Da4c=
X-Google-Smtp-Source: AGRyM1v+7CNGTSY42yWM8UiG0FT052q4/NahMplXT7LsfGwqDMQUdIDVukiakVV0nxw0QMBMhxZQlA==
X-Received: by 2002:adf:f1ca:0:b0:21d:5eec:1320 with SMTP id z10-20020adff1ca000000b0021d5eec1320mr24762908wro.196.1657659214324;
        Tue, 12 Jul 2022 13:53:34 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id c14-20020a7bc00e000000b003a044fe7fe7sm89833wmb.9.2022.07.12.13.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 13:53:33 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v5 22/27] io_uring: sendzc with fixed buffers
Date:   Tue, 12 Jul 2022 21:52:46 +0100
Message-Id: <e1d8bd1b5934e541d90c1824eb4020ae3f5f43f3.1657643355.git.asml.silence@gmail.com>
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

Allow zerocopy sends to use fixed buffers. There is an optimisation for
this case, the network layer don't need to reference the pages, see
SKBFL_MANAGED_FRAG_REFS, so io_uring have to ensure validity of fixed
buffers until the notifier is released.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |  6 +++++-
 io_uring/net.c                | 29 ++++++++++++++++++++++++-----
 2 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 9303bf5236f7..3f2305bc5c79 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -269,9 +269,13 @@ enum io_uring_op {
  * IORING_RECV_MULTISHOT	Multishot recv. Sets IORING_CQE_F_MORE if
  *				the handler will continue to report
  *				CQEs on behalf of the same SQE.
+ *
+ * IORING_RECVSEND_FIXED_BUF	Use registered buffers, the index is stored in
+ *				the buf_index field.
  */
 #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
-#define IORING_RECV_MULTISHOT	(1U << 1)
+#define IORING_RECV_MULTISHOT		(1U << 1)
+#define IORING_RECVSEND_FIXED_BUF	(1U << 2)
 
 /*
  * accept flags stored in sqe->ioprio
diff --git a/io_uring/net.c b/io_uring/net.c
index 2172cf3facd8..0259fbbad591 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -14,6 +14,7 @@
 #include "kbuf.h"
 #include "net.h"
 #include "notif.h"
+#include "rsrc.h"
 
 #if defined(CONFIG_NET)
 struct io_shutdown {
@@ -667,13 +668,23 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_sendzc *zc = io_kiocb_to_cmd(req);
+	struct io_ring_ctx *ctx = req->ctx;
 
 	if (READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3))
 		return -EINVAL;
 
 	zc->flags = READ_ONCE(sqe->ioprio);
-	if (zc->flags & ~IORING_RECVSEND_POLL_FIRST)
+	if (zc->flags & ~(IORING_RECVSEND_POLL_FIRST | IORING_RECVSEND_FIXED_BUF))
 		return -EINVAL;
+	if (zc->flags & IORING_RECVSEND_FIXED_BUF) {
+		unsigned idx = READ_ONCE(sqe->buf_index);
+
+		if (unlikely(idx >= ctx->nr_user_bufs))
+			return -EFAULT;
+		idx = array_index_nospec(idx, ctx->nr_user_bufs);
+		req->imu = READ_ONCE(ctx->user_bufs[idx]);
+		io_req_set_rsrc_node(req, ctx, 0);
+	}
 
 	zc->buf = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	zc->len = READ_ONCE(sqe->len);
@@ -727,10 +738,18 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 	msg.msg_controllen = 0;
 	msg.msg_namelen = 0;
 
-	ret = import_single_range(WRITE, zc->buf, zc->len, &iov, &msg.msg_iter);
-	if (unlikely(ret))
-		return ret;
-	mm_account_pinned_pages(&notif->uarg.mmp, zc->len);
+	if (zc->flags & IORING_RECVSEND_FIXED_BUF) {
+		ret = io_import_fixed(WRITE, &msg.msg_iter, req->imu,
+					(u64)zc->buf, zc->len);
+		if (unlikely(ret))
+				return ret;
+	} else {
+		ret = import_single_range(WRITE, zc->buf, zc->len, &iov,
+					  &msg.msg_iter);
+		if (unlikely(ret))
+			return ret;
+		mm_account_pinned_pages(&notif->uarg.mmp, zc->len);
+	}
 
 	if (zc->addr) {
 		ret = move_addr_to_kernel(zc->addr, zc->addr_len, &address);
-- 
2.37.0

