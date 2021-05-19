Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59AB438906D
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 16:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354349AbhESORO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 10:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354065AbhESOPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 10:15:53 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D32CBC061351;
        Wed, 19 May 2021 07:14:15 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id l11-20020a05600c4f0bb029017a7cd488f5so783549wmq.0;
        Wed, 19 May 2021 07:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZrpYaaroywU12UggXTRtJF/Lf0MpETwhcC/rLkqy6po=;
        b=pAge3JaRar4piwZpSbj0B4ogTM2jlF2q6tuIr1m1iKex512MiGr7a0TTq7MsoEXCl0
         9bUUwqGenxeTKtoB+IXRfvCFNJXbGap+lg+wJxDGJndcKMNzSGFeiipvNz0AIGs46JqJ
         waG3Bs+9Z3BzmP81+Y8jVCS3dbJBKkzWr6txMxelooF0XuMsIejXUUiKVyP3LD/2df9H
         Oyypm1eqJ00LJEkHz+m5ipNqy+V1rkidx7ODcxtaui7RXpNrvqTIr5nEvqBQlr7Z0y++
         NjYHwqAL1DCAs0Gx/eAoFjNWPE+J0BTU6M2P0pD6kKQ/P2bfXmoHdf5ESEnw6nAMEr/J
         c22g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZrpYaaroywU12UggXTRtJF/Lf0MpETwhcC/rLkqy6po=;
        b=SNSAV3cH4W4g2uh/escV7VfKommlsUeZyZLlJavEUWxtUkL/vq10zeu9zetWtIgZoH
         6CtXH9wIfyldcHllTU9978AS4UwoohfbhY/IizdBAxO9hqTH57Mf9ER+F6CdFCr/Q18R
         1SZHSa7Up5CeyGchJYVAeup5vqKCORP3geBRaK55P3PqKr/gPZ5xViSpDBfrxJEIbJcT
         KdrAkODd66CKWiZsNJ605AvLIh7V7HOLw0jiVHc/GdEBIqG3oLDq4yE9QUS6E/oZ54Ee
         DCZ4AdD26e2+cISu1D7yJU5MN+0s0Bb3SQdFgKJL8WXQTVHNwOTh8ChnByxK4prlZrLx
         th2A==
X-Gm-Message-State: AOAM533wEbNks8GXLiCoILtuDsX3U+CbFM0dZzwGdqhA0GhqVbHqBD0j
        J1lzB1TCDmRvh8NTJV/XHKcOCS8jGqbTGNOG
X-Google-Smtp-Source: ABdhPJy2NpqoTl4rWs0j+yQOKB3Vw1oqPVlvZtyxM5uMVS/MmgT2zgeGbjvAbbMNKNMd3NChpRuILw==
X-Received: by 2002:a1c:7702:: with SMTP id t2mr11730397wmi.115.1621433653562;
        Wed, 19 May 2021 07:14:13 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.154])
        by smtp.gmail.com with ESMTPSA id z3sm6233569wrq.42.2021.05.19.07.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 07:14:13 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        "Franz-B . Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>,
        Christian Dietrich <stettberger@dokucode.de>
Subject: [PATCH 19/23] io_uring: pass user_data to bpf executor
Date:   Wed, 19 May 2021 15:13:30 +0100
Message-Id: <cb4d77ad3165084a9abddf72528c4721d7441888.1621424513.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621424513.git.asml.silence@gmail.com>
References: <cover.1621424513.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 16 ++++++++++++++++
 include/uapi/linux/io_uring.h |  4 ++++
 2 files changed, 20 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7c165b2ce8e4..c37846bca863 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -882,6 +882,7 @@ struct io_defer_entry {
 };
 
 struct io_bpf_ctx {
+	struct io_uring_bpf_ctx u;
 	struct io_ring_ctx	*ctx;
 };
 
@@ -10482,6 +10483,15 @@ static bool io_bpf_is_valid_access(int off, int size,
 				   const struct bpf_prog *prog,
 				   struct bpf_insn_access_aux *info)
 {
+	if (off < 0 || off >= sizeof(struct io_uring_bpf_ctx))
+		return false;
+	if (off % size != 0)
+		return false;
+
+	switch (off) {
+	case offsetof(struct io_uring_bpf_ctx, user_data):
+		return size == sizeof_field(struct io_uring_bpf_ctx, user_data);
+	}
 	return false;
 }
 
@@ -10505,6 +10515,8 @@ static void io_bpf_run(struct io_kiocb *req, unsigned int issue_flags)
 		     atomic_read(&req->task->io_uring->in_idle)))
 		goto done;
 
+	memset(&bpf_ctx.u, 0, sizeof(bpf_ctx.u));
+	bpf_ctx.u.user_data = req->user_data;
 	bpf_ctx.ctx = ctx;
 	prog = req->bpf.prog;
 
@@ -10591,6 +10603,10 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(44, __s32,  splice_fd_in);
 	BUILD_BUG_SQE_ELEM(48, __u16,  cq_idx);
 
+	/* should be first, see io_bpf_is_valid_access() */
+	__BUILD_BUG_VERIFY_ELEMENT(struct io_bpf_ctx, 0,
+				   struct io_uring_bpf_ctx, u);
+
 	BUILD_BUG_ON(sizeof(struct io_uring_files_update) !=
 		     sizeof(struct io_uring_rsrc_update));
 	BUILD_BUG_ON(sizeof(struct io_uring_rsrc_update) >
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 25ab804670e1..d7b1713bcfb0 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -403,4 +403,8 @@ struct io_uring_getevents_arg {
 	__u64	ts;
 };
 
+struct io_uring_bpf_ctx {
+	__u64	user_data;
+};
+
 #endif
-- 
2.31.1

