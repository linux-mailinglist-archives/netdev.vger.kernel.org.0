Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C21F656A182
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 13:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235567AbiGGLxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 07:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235453AbiGGLwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 07:52:35 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395FC5722A;
        Thu,  7 Jul 2022 04:52:16 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id o16-20020a05600c379000b003a02eaea815so970614wmr.0;
        Thu, 07 Jul 2022 04:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WVXTlEzEGbco4l2SuKTPybZhQRTUVdDBCHHo07YwDPw=;
        b=PHD4hGtVKinSi2VEzrOqtMQcPXveAsfopjXXoh+/bET9mrNZz6XUNb5AE9eVCKMj4J
         968c3dnP8ePBlOJR30F/OAkI+rnOF+yBVbGhqePiHA3k21fsLLzBniqN6+N6fASSBOPs
         va7A3XspOdLLDDqq5GsHgBplFRWLQplcy+2cYwLpIk8OXDD9s9eR5ZyXLce/M/0knooF
         SlbWxGdY7USmZ2a8a11yoXDutWIVb6MTocR6mlpBGneS7Vhzueda1cu1XGNmyVdiNL23
         ny7+AaJcxBtm2wj4SQxLfNcJBKRfak/CCizQb74jR5iCgFSShP9GP6OSGGAWxBSTkXXW
         VcYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WVXTlEzEGbco4l2SuKTPybZhQRTUVdDBCHHo07YwDPw=;
        b=X2m+mYX+1xiPQ2PggYNhI8P2KWKg6yhLdWwVGAyy4tCB7U9WJPWjVTVxYToI29hI62
         sFVMQa0hyOtmJe7rDp7/0+RqFeBNDSfGw11J6aJNwG2OgUPG+Ewk127/imF0fBE+pWoz
         ytTzR18O63hVOLwSxjEU8YnXetpSTpKvnUFlOBRBbrniKDhFZwoTAHhttf3mFTrNYO0O
         Mn4W1FOWGvdFtizYkLb2C+mJ/IlwvXxPAvSsIPjzIGXPOI47A2OV21tA9YCQjNfYV5eM
         OBNxQKMDvL8H1d2KQturXZZo1+Tp/HGu9/UgkIaDNrBuNM2zCydHE88108i2kEbkP22s
         Hqyg==
X-Gm-Message-State: AJIora8RvBkLeGv17oSY08CMfZmC1DY57QzSrZ1YMHWU/zi9yzOJwubl
        U6+ADHzZVxvAggMEHuv8/kxoR6aour3GjliCxAA=
X-Google-Smtp-Source: AGRyM1sKMhMePb4hjwNHAc94LiE8QB3tOND/e1erVmWDOTo2PVOPE6K/0/luTB/4FAETbRvwBw20gg==
X-Received: by 2002:a05:600c:3d11:b0:3a1:8c05:6e75 with SMTP id bh17-20020a05600c3d1100b003a18c056e75mr3949490wmb.203.1657194735504;
        Thu, 07 Jul 2022 04:52:15 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u2-20020a5d5142000000b0021b966abc19sm37982131wrt.19.2022.07.07.04.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 04:52:15 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v4 25/27] io_uring: add zc notification flush requests
Date:   Thu,  7 Jul 2022 12:49:56 +0100
Message-Id: <ee4ce733a3d5e9ad7cae8cd893dab8a40ca43b7d.1657194434.git.asml.silence@gmail.com>
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

Overlay notification control onto IORING_OP_RSRC_UPDATE (former
IORING_OP_FILES_UPDATE). It allows to flush a range of zc notifications
from slots with indexes [sqe->off, sqe->off+sqe->len). If sqe->arg is
not zero, it also copies sqe->arg as a new tag for all flushed
notifications.

Note, it doesn't flush a notification of a slot if there was no requests
attached to it (since last flush or registration).

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |  1 +
 io_uring/rsrc.c               | 38 +++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 9e325179a4f8..cbf9cfbe5fe7 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -294,6 +294,7 @@ enum io_uring_op {
  */
 enum {
 	IORING_RSRC_UPDATE_FILES,
+	IORING_RSRC_UPDATE_NOTIF,
 };
 
 /*
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 98ce8a93a816..088a2dc32e2c 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -15,6 +15,7 @@
 #include "io_uring.h"
 #include "openclose.h"
 #include "rsrc.h"
+#include "notif.h"
 
 struct io_rsrc_update {
 	struct file			*file;
@@ -742,6 +743,41 @@ static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
+static int io_notif_update(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_rsrc_update *up = io_kiocb_to_cmd(req);
+	struct io_ring_ctx *ctx = req->ctx;
+	unsigned len = up->nr_args;
+	unsigned idx_end, idx = up->offset;
+	int ret = 0;
+
+	io_ring_submit_lock(ctx, issue_flags);
+	if (unlikely(check_add_overflow(idx, len, &idx_end))) {
+		ret = -EOVERFLOW;
+		goto out;
+	}
+	if (unlikely(idx_end > ctx->nr_notif_slots)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	for (; idx < idx_end; idx++) {
+		struct io_notif_slot *slot = &ctx->notif_slots[idx];
+
+		if (!slot->notif)
+			continue;
+		if (up->arg)
+			slot->tag = up->arg;
+		io_notif_slot_flush_submit(slot, issue_flags);
+	}
+out:
+	io_ring_submit_unlock(ctx, issue_flags);
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_set_res(req, ret, 0);
+	return IOU_OK;
+}
+
 int io_rsrc_update(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_rsrc_update *up = io_kiocb_to_cmd(req);
@@ -749,6 +785,8 @@ int io_rsrc_update(struct io_kiocb *req, unsigned int issue_flags)
 	switch (up->type) {
 	case IORING_RSRC_UPDATE_FILES:
 		return io_files_update(req, issue_flags);
+	case IORING_RSRC_UPDATE_NOTIF:
+		return io_notif_update(req, issue_flags);
 	}
 	return -EINVAL;
 }
-- 
2.36.1

