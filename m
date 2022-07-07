Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38A7E56A19C
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 13:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235511AbiGGLxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 07:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235508AbiGGLwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 07:52:22 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91362564D6;
        Thu,  7 Jul 2022 04:52:13 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id n10so652604wrc.4;
        Thu, 07 Jul 2022 04:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vni1PHVYJPc0849HRnVcqqDE9M5XrjitEQZXYPbPv8U=;
        b=OFL5y1oSF8T1GRvkKYNmcScAO4yqIEIk10aaKEg0iKcMwnB03kndXfJ+6GU22pIpS6
         Dl2bySef/N6y6ob07uFgdAx3WnIVQNwBnXZfBr4e1O6kP47J401r/hxgozALSlx7iiAr
         ZsSBYro2Cquf2OidANmoPIaQwmgYQ49NaXV/R9HI9vGIt23/vp4uYp9+MK2TaalejpZV
         53ap9qXS3vgktoRmCMDVsUq6MmxksjBEYBYHk6Y8+BN/qQGgWhBa/5LGBCP4BW2/7mEA
         KmrQYa1tNytiggn4R2pSwlvT7ZLuQuivWfTA9DhNKrGlQEFJYPoVbWDGevQYept512mK
         GVhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vni1PHVYJPc0849HRnVcqqDE9M5XrjitEQZXYPbPv8U=;
        b=Ib0/CD3cj2NOJnw61BAhJbRbRDb6GFq2bg+bP+WMLnrwR2/Nxw6bkqYS/TpkYsyzq9
         CKvCZ69Cd0gJ7O4JzU0JAybdqWl3tFG7atQ5KDhW8y2w+/ChB0JZB6G3n3qHOKXd7fDW
         YBUX9nAE+R79BGzDuhuB3WtmvJb5BooHaiyPxl/t/SksYv3MetPQVSfb4lFCMhGLqO6c
         UaLHQJjNJl95Lf08+jeRr8wsFVOeSR+x7+fd8qTlCvuNvQdMS3XYQndl6FgLEI0tdPOT
         uiBRXMsM14ihEbu5wnMXt79qsgj5hovsyLMM/Sp9aR2MkBtv+T8MQZgIV0YCGqVtr5hh
         GmoA==
X-Gm-Message-State: AJIora8i4dlStjnfAcy5EEebmbp8BcbE3vq0AQF2VyLLRdLTa5TvV0z0
        8Zf8M6E0aZayavxHeIZ0sd5uVjczG5lUj10xHvA=
X-Google-Smtp-Source: AGRyM1srS9rgrWbnnxWf6+ksxm+GW8CP5DpDq8gt1MXiJvO8YXYIJPVtS6K4g/DdssrgxB96d6Ossw==
X-Received: by 2002:adf:fdc4:0:b0:21d:6f76:5193 with SMTP id i4-20020adffdc4000000b0021d6f765193mr14322621wrs.606.1657194731842;
        Thu, 07 Jul 2022 04:52:11 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u2-20020a5d5142000000b0021b966abc19sm37982131wrt.19.2022.07.07.04.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 04:52:11 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v4 22/27] io_uring: sendzc with fixed buffers
Date:   Thu,  7 Jul 2022 12:49:53 +0100
Message-Id: <c9ef20dbfab53aad9256e579aaa1c3abd0621992.1657194434.git.asml.silence@gmail.com>
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
index 25278c9ac6d2..8d050c247d6b 100644
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
2.36.1

