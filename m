Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D93E7389020
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 16:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353933AbhESOPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 10:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347217AbhESOPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 10:15:14 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C7CDC06175F;
        Wed, 19 May 2021 07:13:54 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id r12so14214939wrp.1;
        Wed, 19 May 2021 07:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z7dUjeyKGkKe7mPGtbrIQS3SETJnccJ7luLK5I56KT0=;
        b=JTpKqXzlK+LuzFismUcwFXaHar/t6U//StFAaKNpUCAC3u05X1nNW25ujeSk+TbTIt
         yvpiKxxRRfYBMsN+5AvXll7oodYpA5XqY52Ybkvl24oaVfZQumC0ghts4+SeQ0KaaycX
         UgrIKHH422hlkHMFONGKmzwFhL6vWA/vHDDT9pVxmOqQyphwaDIDkbrMoBOHvv6G1biF
         JB4Zctq90H+TgAc5llDqSkmI59HKSYkgA4dOM1KUUB+4iPyoSw3aolyzBaipTuN766MH
         WpAeY1TaZir7urK14vQpHGTgzfQbq+z4vsmQ+INXJWQIjdqntHCmiL2DGpXfCcNs8Rwr
         pL9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z7dUjeyKGkKe7mPGtbrIQS3SETJnccJ7luLK5I56KT0=;
        b=pA6BbPtPBc8X1E6grqvHxBLRpIHgnomCl9F+Mau8PkKp23A8JLm1bVosJ1UaUmZDG6
         R2oxC2MfQK/Ey8jyggCrmBzkAnKzXBsGlsibXgYQBnl3Bg9qx27WsHB+6aS7yDNSlmkx
         qDknNovliVNMETqj8uwSQyTJnG+VEFBTY2Om3ZNkqpkyScSPmY60v2xjWvgL0aWRlQCD
         zPj2lMrrgu4dgx027l0F3cHb51HdO3ErKFlCMzotkRm1xzcyKS3u1d2ab9Ye061n+Azf
         gjchD0S4gCpTmbE1OT5QhkKgDqB84IUkLaiLe0O7AqQ3KStrDc4nzrhgwefHDkF8oJxl
         Vs3w==
X-Gm-Message-State: AOAM532U3GWivNGKxMkubDCntqMa64W7brArAIe0bokogb9XsmsulR/3
        op7q3qwsaLXnRqC3n+uioVRth68vhZT0A9Iw
X-Google-Smtp-Source: ABdhPJwyTQyo9hKriKCVc9I2oi9jFiN5ipCN16X8md9iyo0or6DWjVWG0ueCHDflqzV/JCWwGGm2Gw==
X-Received: by 2002:adf:e781:: with SMTP id n1mr14475380wrm.136.1621433632597;
        Wed, 19 May 2021 07:13:52 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.154])
        by smtp.gmail.com with ESMTPSA id z3sm6233569wrq.42.2021.05.19.07.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 07:13:52 -0700 (PDT)
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
Subject: [PATCH 02/23] io_uring: localise fixed resources fields
Date:   Wed, 19 May 2021 15:13:13 +0100
Message-Id: <7672fac6581f2a1656ad6828ebd43ee44c4e808e.1621424513.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621424513.git.asml.silence@gmail.com>
References: <cover.1621424513.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ring has two types of resource-related fields, used for request
submission, and field needed for update/registration. Reshuffle them
into these two groups for better locality and readability. The second
group is not in the hot path, so it's natural to place them somewhere in
the end. Also update an outdated comment.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7e3410ce100a..31eca208f675 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -390,21 +390,17 @@ struct io_ring_ctx {
 	struct list_head	sqd_list;
 
 	/*
-	 * If used, fixed file set. Writers must ensure that ->refs is dead,
-	 * readers must ensure that ->refs is alive as long as the file* is
-	 * used. Only updated through io_uring_register(2).
+	 * Fixed resources fast path, should be accessed only under uring_lock,
+	 * and updated through io_uring_register(2)
 	 */
-	struct io_rsrc_data	*file_data;
+	struct io_rsrc_node	*rsrc_node;
+
 	struct io_file_table	file_table;
 	unsigned		nr_user_files;
-
-	/* if used, fixed mapped user buffers */
-	struct io_rsrc_data	*buf_data;
 	unsigned		nr_user_bufs;
 	struct io_mapped_ubuf	**user_bufs;
 
 	struct xarray		io_buffers;
-
 	struct xarray		personalities;
 	u32			pers_next;
 
@@ -436,16 +432,21 @@ struct io_ring_ctx {
 		bool			poll_multi_file;
 	} ____cacheline_aligned_in_smp;
 
-	struct delayed_work		rsrc_put_work;
-	struct llist_head		rsrc_put_llist;
-	struct list_head		rsrc_ref_list;
-	spinlock_t			rsrc_ref_lock;
-	struct io_rsrc_node		*rsrc_node;
-	struct io_rsrc_node		*rsrc_backup_node;
-	struct io_mapped_ubuf		*dummy_ubuf;
-
 	struct io_restriction		restrictions;
 
+	/* slow path rsrc auxilary data, used by update/register */
+	struct {
+		struct io_rsrc_node		*rsrc_backup_node;
+		struct io_mapped_ubuf		*dummy_ubuf;
+		struct io_rsrc_data		*file_data;
+		struct io_rsrc_data		*buf_data;
+
+		struct delayed_work		rsrc_put_work;
+		struct llist_head		rsrc_put_llist;
+		struct list_head		rsrc_ref_list;
+		spinlock_t			rsrc_ref_lock;
+	};
+
 	/* Keep this last, we don't need it for the fast path */
 	struct {
 		#if defined(CONFIG_UNIX)
-- 
2.31.1

