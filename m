Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3AE572817
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 22:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbiGLUzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 16:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234136AbiGLUyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 16:54:53 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C938275F0;
        Tue, 12 Jul 2022 13:53:40 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id bk26so12796424wrb.11;
        Tue, 12 Jul 2022 13:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZyhUoseN7KcL9h32+uJElLshw0im2xlB0TZ9Ykk2TuM=;
        b=K/W12bdjjB492Vw/NxDsoG9XLKOA0bhbPjHXqLPwZwbgYiNIHsr2dMt29RR5G4IrK3
         BZsnR+vs4toRkZ3scnvhn8pOVPz9V/fROfYiiaAs/dprOGshnmWYHbSRSc3GLL7Oki0F
         RVjL3hx5Ru7f/GK/1nxuezIbB5sLtvN2tg+ZQzYEzq2Ne1z0IXjLz36kkLUaOg9dIm1l
         bpePGHId/KZ2/QsgSCOzxxXhi1KQW3nfrPQhw/7DECfWqwOnomgjZEfseM6Z57/z4LYy
         gXzvy8SgT7HJuVLk/lOOh+EUJ4DYn/jcLA+SGRP54yRUAFVQ61eKs3VJ9qjK/kPD3IdG
         0+yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZyhUoseN7KcL9h32+uJElLshw0im2xlB0TZ9Ykk2TuM=;
        b=sQ4qXfVYLpLoAEpSkrZFvf+HZ+/S1ivuEd4wZFSQjiB+e1ik2ALY9dw+Mlo3ZKixK+
         eE8HyA64d9i4EaUH8MwltJVYjdg8I7Ne7G8CCIA/JJ1XAMmFCcTl5OJ0z2r8DBYBJrcP
         3PcJNR1kp771d5n49Ukgwl5/L2NdYxxTCS/lsRp9uq7luSsHVpQAoKIUXW72px6AK7f7
         ONQNQQp/g4creRfnfCdPRujL/c39Y31F9UnTIHFitCOkH/HwnqohJCoC+1wCjF9Csyzr
         AxzXBrmkNEVlVTQFOsCWk+tQjd5eDHarW6PAOPE+4HeY0sGHhLiq3Qvzr8yrQNx1NhlS
         YUAQ==
X-Gm-Message-State: AJIora/IGeW0KtF37WgxrLaGNk+mFALGiIwyYmKaVM11SXPF4kSnRjvI
        OV2nI9gLCkrLEch68eyWn4EQtd5J4yM=
X-Google-Smtp-Source: AGRyM1tv8MryVUOtChYGi7b4XRYgX+c81MKmCTna0ZFQ5ergTSrx6kVXSMRpgh54YLpGYE86Zkjp8g==
X-Received: by 2002:adf:eccb:0:b0:21d:7b41:22c7 with SMTP id s11-20020adfeccb000000b0021d7b4122c7mr22294366wro.543.1657659216773;
        Tue, 12 Jul 2022 13:53:36 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id c14-20020a7bc00e000000b003a044fe7fe7sm89833wmb.9.2022.07.12.13.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 13:53:36 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v5 24/27] io_uring: rename IORING_OP_FILES_UPDATE
Date:   Tue, 12 Jul 2022 21:52:48 +0100
Message-Id: <0a907133907d9af3415a8a7aa1802c6aa97c03c6.1657643355.git.asml.silence@gmail.com>
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

IORING_OP_FILES_UPDATE will be a more generic opcode serving different
resource types, rename it into IORING_OP_RSRC_UPDATE and add subtype
handling.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h | 12 +++++++++++-
 io_uring/opdef.c              |  9 +++++----
 io_uring/rsrc.c               | 17 +++++++++++++++--
 io_uring/rsrc.h               |  4 ++--
 4 files changed, 33 insertions(+), 9 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 7d21fba54b62..37e8c104d31f 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -171,7 +171,8 @@ enum io_uring_op {
 	IORING_OP_FALLOCATE,
 	IORING_OP_OPENAT,
 	IORING_OP_CLOSE,
-	IORING_OP_FILES_UPDATE,
+	IORING_OP_RSRC_UPDATE,
+	IORING_OP_FILES_UPDATE = IORING_OP_RSRC_UPDATE,
 	IORING_OP_STATX,
 	IORING_OP_READ,
 	IORING_OP_WRITE,
@@ -220,6 +221,7 @@ enum io_uring_op {
 #define IORING_TIMEOUT_ETIME_SUCCESS	(1U << 5)
 #define IORING_TIMEOUT_CLOCK_MASK	(IORING_TIMEOUT_BOOTTIME | IORING_TIMEOUT_REALTIME)
 #define IORING_TIMEOUT_UPDATE_MASK	(IORING_TIMEOUT_UPDATE | IORING_LINK_TIMEOUT_UPDATE)
+
 /*
  * sqe->splice_flags
  * extends splice(2) flags
@@ -286,6 +288,14 @@ enum io_uring_op {
  */
 #define IORING_ACCEPT_MULTISHOT	(1U << 0)
 
+
+/*
+ * IORING_OP_RSRC_UPDATE flags
+ */
+enum {
+	IORING_RSRC_UPDATE_FILES,
+};
+
 /*
  * IORING_OP_MSG_RING command types, stored in sqe->addr
  */
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 7ab19bbf3126..72dd2b2d8a9d 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -246,12 +246,13 @@ const struct io_op_def io_op_defs[] = {
 		.prep			= io_close_prep,
 		.issue			= io_close,
 	},
-	[IORING_OP_FILES_UPDATE] = {
+	[IORING_OP_RSRC_UPDATE] = {
 		.audit_skip		= 1,
 		.iopoll			= 1,
-		.name			= "FILES_UPDATE",
-		.prep			= io_files_update_prep,
-		.issue			= io_files_update,
+		.name			= "RSRC_UPDATE",
+		.prep			= io_rsrc_update_prep,
+		.issue			= io_rsrc_update,
+		.ioprio			= 1,
 	},
 	[IORING_OP_STATX] = {
 		.audit_skip		= 1,
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 1182cf0ea1fc..98ce8a93a816 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -21,6 +21,7 @@ struct io_rsrc_update {
 	u64				arg;
 	u32				nr_args;
 	u32				offset;
+	int				type;
 };
 
 static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
@@ -658,7 +659,7 @@ __cold int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
 	return -EINVAL;
 }
 
-int io_files_update_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+int io_rsrc_update_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_rsrc_update *up = io_kiocb_to_cmd(req);
 
@@ -672,6 +673,7 @@ int io_files_update_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (!up->nr_args)
 		return -EINVAL;
 	up->arg = READ_ONCE(sqe->addr);
+	up->type = READ_ONCE(sqe->ioprio);
 	return 0;
 }
 
@@ -711,7 +713,7 @@ static int io_files_update_with_index_alloc(struct io_kiocb *req,
 	return ret;
 }
 
-int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
+static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_rsrc_update *up = io_kiocb_to_cmd(req);
 	struct io_ring_ctx *ctx = req->ctx;
@@ -740,6 +742,17 @@ int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
+int io_rsrc_update(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_rsrc_update *up = io_kiocb_to_cmd(req);
+
+	switch (up->type) {
+	case IORING_RSRC_UPDATE_FILES:
+		return io_files_update(req, issue_flags);
+	}
+	return -EINVAL;
+}
+
 int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
 			  struct io_rsrc_node *node, void *rsrc)
 {
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index af342fd239d0..21813a23215f 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -167,6 +167,6 @@ static inline u64 *io_get_tag_slot(struct io_rsrc_data *data, unsigned int idx)
 	return &data->tags[table_idx][off];
 }
 
-int io_files_update(struct io_kiocb *req, unsigned int issue_flags);
-int io_files_update_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_rsrc_update(struct io_kiocb *req, unsigned int issue_flags);
+int io_rsrc_update_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 #endif
-- 
2.37.0

