Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B43B567205
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 17:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbiGEPEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 11:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232533AbiGEPCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 11:02:54 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D3341838D;
        Tue,  5 Jul 2022 08:02:17 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id v14so17966786wra.5;
        Tue, 05 Jul 2022 08:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RCosh7FOoSgjGOXo84JblI0oJogt+tqCd1iVGCEaer0=;
        b=ezU4bSCSbej7pZdo37cxHwOyeTZohSfd/AJrTWbD66LONC+237j+fh6TQIdkZYI4pQ
         GizXpAIX9KW7UPDh5uU3FqAE1+P47oAzKZ3btbeX/XPqTXfoMyKAmpgTsfU+zsHl7SiG
         QGuxE26RIisL2xsqLTzfWG3bqC2kfozANyyQ9ZXpJJXXe2L84fYPA4HGtAqc2Q1VLGrB
         sVHb6BOo6vuEJ/ipOoXoCG8C77ss0C1TMKEbQVfh7HgR0dCtsSVcrUtDLUjIix6kLVg5
         RSrkvt8/WyQOPTE5BMqtg9llGtgf/DsDznMjjrgE2gCg+zUDOSURsOH5sH+Tn+QcRIF/
         HzAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RCosh7FOoSgjGOXo84JblI0oJogt+tqCd1iVGCEaer0=;
        b=UIJMWjyZIaep803zITbp96q2memZXB18Jrqru2kfqjlx1Io86JRrhl5l3DEIMEXQvI
         nsg1opkytsifZK4wYgtVQW/TJJSfCDtP+bjqe4z+azUQFGhyf+0SEu0cR7/cun0jX55B
         wKdz00tG61qajwqiFpga5j/VkIrmSp4+t04MiDg/ghE9TIZR3HI40YwdqrQNOfJJy/lx
         d6s1FUShHKDnFDHzuBuyie+OhGaPkKqkqPVTe9ERE7AS5xstN+kvBKD8MTh4MwM3xXP9
         6sYrEKTUbocPQcgxsw/i9mCeDaQlUXKrW2Y3hmvm39MEC7I95DC5CGcmZj6QdomkpnIm
         2Ecw==
X-Gm-Message-State: AJIora8XRn8BTtRZocy7g3rXoL5InQ08C8pPGappkvxONaey636ano3y
        eNWRJ1+5hPK8CWRm4xBKD0DEiZeYlS71lw==
X-Google-Smtp-Source: AGRyM1toH9h98DrWA3/IURKNLs3GlYCxAxnRZUfGwqTThP/Jc8XEgIje+oNCoNe+Els01CPBQopG3g==
X-Received: by 2002:adf:d22f:0:b0:21d:6b26:8c6f with SMTP id k15-20020adfd22f000000b0021d6b268c6fmr10509416wrh.70.1657033336626;
        Tue, 05 Jul 2022 08:02:16 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id k27-20020adfd23b000000b0021d728d687asm2518200wrh.36.2022.07.05.08.02.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 08:02:16 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v3 23/25] io_uring: rename IORING_OP_FILES_UPDATE
Date:   Tue,  5 Jul 2022 16:01:23 +0100
Message-Id: <f5f39b4a4c344919e8f831e85946aefb3c80cf63.1656318994.git.asml.silence@gmail.com>
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
index 2fd4e39a14d3..e62e61ceb494 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -170,7 +170,8 @@ enum io_uring_op {
 	IORING_OP_FALLOCATE,
 	IORING_OP_OPENAT,
 	IORING_OP_CLOSE,
-	IORING_OP_FILES_UPDATE,
+	IORING_OP_RSRC_UPDATE,
+	IORING_OP_FILES_UPDATE = IORING_OP_RSRC_UPDATE,
 	IORING_OP_STATX,
 	IORING_OP_READ,
 	IORING_OP_WRITE,
@@ -219,6 +220,7 @@ enum io_uring_op {
 #define IORING_TIMEOUT_ETIME_SUCCESS	(1U << 5)
 #define IORING_TIMEOUT_CLOCK_MASK	(IORING_TIMEOUT_BOOTTIME | IORING_TIMEOUT_REALTIME)
 #define IORING_TIMEOUT_UPDATE_MASK	(IORING_TIMEOUT_UPDATE | IORING_LINK_TIMEOUT_UPDATE)
+
 /*
  * sqe->splice_flags
  * extends splice(2) flags
@@ -272,6 +274,14 @@ enum io_uring_op {
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
  * IORING_OP_SENDZC flags
  */
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 91d425b43174..431b73e9b378 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -244,12 +244,13 @@ const struct io_op_def io_op_defs[] = {
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
index 3a2a5ef263f0..0c3f95f24cef 100644
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
2.36.1

