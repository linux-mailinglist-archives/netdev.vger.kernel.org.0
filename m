Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3562355ED50
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbiF1TB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232558AbiF1TAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:00:31 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E5619C37;
        Tue, 28 Jun 2022 12:00:17 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id pk21so27742763ejb.2;
        Tue, 28 Jun 2022 12:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uwEtcy35/eb1UWEX+Is4VwPssXK9wNrE3mSEGTaJXGY=;
        b=impo2pz/qgTx3Q122rqabF7MTpnmkKigg+V9UX2iMgo8WHV4Ob7vNSwHYUJByleSer
         dN8gTCeWBGEqh7o7UPtLX989YCC507wXDZ/1GtJOcTyoZ6FDhQBNtR1w2AvPUv+zgVtZ
         Ey9lLpvKDtW36yfzJGo6juQ7lwf3K0YWkvt1lPKpgQGRoizBFrn9MSQrI9xdhwzlI84C
         ge8brGCFbL+heirfkLR1Xgjhl8D6sE0t7FfLEYNv4eXNqAhqWG9ooywAPcQC93W8Vfo+
         OCxg508DUpDFQGSoVIfXd96A+U2aqjm50f0A+ISfGUoQrYfzTaXeez0WHkMZFL5ZGg+Q
         bWVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uwEtcy35/eb1UWEX+Is4VwPssXK9wNrE3mSEGTaJXGY=;
        b=wci9xFn1TE+HKxJedW85nDG7JAie1kt3F3s57TSjPEIxHBHO3R2vPZljm4OJDdWJzx
         ve7Cww0f69j0D6woGqIf7yX9V0Auxjmh4qxA3XNgZrWsRg04DUZmopEgXlQC8fE/QLM/
         KjWnlCG8E0KYG9qn/Uzujyd+lmG8w6xL00DdFCdsGjagqgOVXy1YRa6y6UgWLuxsMTFm
         KVkeTYL1RKlT85jxN2k0aqOfI9E4+7j1JtKbJCdfUCtrTeev1Pvu7tnS8N/0xZ8nIq1f
         6GPVT5q7JOZihFh4k7DJZoBTdU1WFR3fBQBBRlGLTCUzlxBjvV8BNfSTWrR4dtHRc0KO
         yk1A==
X-Gm-Message-State: AJIora8I230EOd3c1yGIO7dYhEdqT4rsppRKagy2X5Bx+akE3+KaYaNN
        BvLnX+wenbizjLmsHW4C0KqAv+ECtV992Q==
X-Google-Smtp-Source: AGRyM1uOhjeZnS3uNRqg1lzXBPlNIwFv28U4mRmy/6A+x0G2p7vStFJeuEOZdP5LbQH1DyGBm2ZBMA==
X-Received: by 2002:a17:906:2dd:b0:712:1293:3dd8 with SMTP id 29-20020a17090602dd00b0071212933dd8mr19335681ejk.448.1656442815171;
        Tue, 28 Jun 2022 12:00:15 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t21-20020a05640203d500b0043573c59ea0sm9758451edw.90.2022.06.28.12.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 12:00:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next v3 19/29] io_uring: rename IORING_OP_FILES_UPDATE
Date:   Tue, 28 Jun 2022 19:56:41 +0100
Message-Id: <93e0583f37ea7fe64fac4aab782ed9266320666d.1653992701.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1653992701.git.asml.silence@gmail.com>
References: <cover.1653992701.git.asml.silence@gmail.com>
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
 fs/io_uring.c                 | 23 +++++++++++++++++------
 include/uapi/linux/io_uring.h | 12 +++++++++++-
 2 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 22427893549a..e9fc7e076c7f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -730,6 +730,7 @@ struct io_rsrc_update {
 	u64				arg;
 	u32				nr_args;
 	u32				offset;
+	unsigned			type;
 };
 
 struct io_fadvise {
@@ -1280,7 +1281,7 @@ static const struct io_op_def io_op_defs[] = {
 	},
 	[IORING_OP_OPENAT] = {},
 	[IORING_OP_CLOSE] = {},
-	[IORING_OP_FILES_UPDATE] = {
+	[IORING_OP_RSRC_UPDATE] = {
 		.audit_skip		= 1,
 		.iopoll			= 1,
 	},
@@ -8268,7 +8269,7 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
-static int io_files_update_prep(struct io_kiocb *req,
+static int io_rsrc_update_prep(struct io_kiocb *req,
 				const struct io_uring_sqe *sqe)
 {
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
@@ -8280,6 +8281,7 @@ static int io_files_update_prep(struct io_kiocb *req,
 	req->rsrc_update.nr_args = READ_ONCE(sqe->len);
 	if (!req->rsrc_update.nr_args)
 		return -EINVAL;
+	req->rsrc_update.type = READ_ONCE(sqe->ioprio);
 	req->rsrc_update.arg = READ_ONCE(sqe->addr);
 	return 0;
 }
@@ -8308,6 +8310,15 @@ static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
+static int io_rsrc_update(struct io_kiocb *req, unsigned int issue_flags)
+{
+	switch (req->rsrc_update.type) {
+	case IORING_RSRC_UPDATE_FILES:
+		return io_files_update(req, issue_flags);
+	}
+	return -EINVAL;
+}
+
 static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	switch (req->opcode) {
@@ -8352,8 +8363,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_openat_prep(req, sqe);
 	case IORING_OP_CLOSE:
 		return io_close_prep(req, sqe);
-	case IORING_OP_FILES_UPDATE:
-		return io_files_update_prep(req, sqe);
+	case IORING_OP_RSRC_UPDATE:
+		return io_rsrc_update_prep(req, sqe);
 	case IORING_OP_STATX:
 		return io_statx_prep(req, sqe);
 	case IORING_OP_FADVISE:
@@ -8661,8 +8672,8 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	case IORING_OP_CLOSE:
 		ret = io_close(req, issue_flags);
 		break;
-	case IORING_OP_FILES_UPDATE:
-		ret = io_files_update(req, issue_flags);
+	case IORING_OP_RSRC_UPDATE:
+		ret = io_rsrc_update(req, issue_flags);
 		break;
 	case IORING_OP_STATX:
 		ret = io_statx(req, issue_flags);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 96193bbda2e4..5f574558b96c 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -162,7 +162,8 @@ enum io_uring_op {
 	IORING_OP_FALLOCATE,
 	IORING_OP_OPENAT,
 	IORING_OP_CLOSE,
-	IORING_OP_FILES_UPDATE,
+	IORING_OP_RSRC_UPDATE,
+	IORING_OP_FILES_UPDATE = IORING_OP_RSRC_UPDATE,
 	IORING_OP_STATX,
 	IORING_OP_READ,
 	IORING_OP_WRITE,
@@ -210,6 +211,7 @@ enum io_uring_op {
 #define IORING_TIMEOUT_ETIME_SUCCESS	(1U << 5)
 #define IORING_TIMEOUT_CLOCK_MASK	(IORING_TIMEOUT_BOOTTIME | IORING_TIMEOUT_REALTIME)
 #define IORING_TIMEOUT_UPDATE_MASK	(IORING_TIMEOUT_UPDATE | IORING_LINK_TIMEOUT_UPDATE)
+
 /*
  * sqe->splice_flags
  * extends splice(2) flags
@@ -258,6 +260,14 @@ enum io_uring_op {
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
  * IO completion data structure (Completion Queue Entry)
  */
-- 
2.36.1

