Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6C538901C
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 16:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351744AbhESOPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 10:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347156AbhESOPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 10:15:13 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 104E3C06175F;
        Wed, 19 May 2021 07:13:53 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id b7so6787024wmh.5;
        Wed, 19 May 2021 07:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s131NxggirtYayrqVgml5tnn47Lq2po2FNWURr3UV60=;
        b=up/h7cwepeCuFW+ckvA0R+rz9NuxgcdzFtCroymGVDqws1W/s6gFloH3vRSqhKaE5n
         omNKmKsgaOAfsWKMoJMoH2rBz6rR+G58CG2/uX6/+fRwjCdCWU5LZmJKJwkuAvICxFxj
         bNgqvzk9t6A6uyofRjy4yqIIAV7kEitGGWHfwi//1xJId75jyxflFwJDPh++CBCxzjw/
         Tio+Bb3vf1SjIYQN+kzQ58TZ/f7gv9mR0qDWMxNC17d157sUxGYylXL+yX+wMrZLpk1a
         4WFvdH522N7X4w+pQ3rkG6nN3RDN1u5U3Ve3Ony2u6ReBCCVc2Hv1fv9aRTE2xeLeDiS
         cl9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s131NxggirtYayrqVgml5tnn47Lq2po2FNWURr3UV60=;
        b=kzGQ9etwRbU7KMAie/qKrL0DHWkbGSFawXShReTFNeJv/E6r1EdKyjIkz5+1voAvyS
         kPao2Ev0FETk5zlaIcOlZngXKDM+Ki4BZvrqaLLUvEsu4hlutXAGfCa8/cxRL8UoYbHG
         Rj2adKoBJ/ZwgPxyVhe6NWZowHLOnJWosCVErWZx7GEwzHqQs8x07H351U+l8x8JF5BU
         fygtslrAlRq9PXv+rcdeY2zrCmgaYkGyAhmrUL0PaD/K+HzWdZlLSPbUdpd6f9eJhJt8
         LCqVGViZV2a0r9+liv4J1LQDhJ2XR6pcFWomfMX+pHggQ4OkduhX0w967EcX9S2UNFOC
         vwsA==
X-Gm-Message-State: AOAM533OlLXtAQr0gj4g2TuN/ZLgpghgvfd1lAnVyUzq/R6a6Xt3MVAA
        oxa5wKAySI57vEZSJSsFgf07MaWxsg4EwJ73
X-Google-Smtp-Source: ABdhPJx0QoPK2jma1uj4ND6DDUZDCBgmBm1nwwPanzBqRODdr3IEM5yDjEtkx2J0XPiyNsX1dmtJjg==
X-Received: by 2002:a7b:c8ce:: with SMTP id f14mr11831466wml.81.1621433631479;
        Wed, 19 May 2021 07:13:51 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.154])
        by smtp.gmail.com with ESMTPSA id z3sm6233569wrq.42.2021.05.19.07.13.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 07:13:51 -0700 (PDT)
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
Subject: [PATCH 01/23] io_uring: shuffle rarely used ctx fields
Date:   Wed, 19 May 2021 15:13:12 +0100
Message-Id: <485abb65cf032f4ddf13dcc0bd60e5475638efc2.1621424513.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621424513.git.asml.silence@gmail.com>
References: <cover.1621424513.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a bunch of scattered around ctx fields that are almost never
used, e.g. only on ring exit, plunge them to the end, better locality,
better aesthetically.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9ac5e278a91e..7e3410ce100a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -367,9 +367,6 @@ struct io_ring_ctx {
 		unsigned		cached_cq_overflow;
 		unsigned long		sq_check_overflow;
 
-		/* hashed buffered write serialization */
-		struct io_wq_hash	*hash_map;
-
 		struct list_head	defer_list;
 		struct list_head	timeout_list;
 		struct list_head	cq_overflow_list;
@@ -386,9 +383,6 @@ struct io_ring_ctx {
 
 	struct io_rings	*rings;
 
-	/* Only used for accounting purposes */
-	struct mm_struct	*mm_account;
-
 	const struct cred	*sq_creds;	/* cred used for __io_sq_thread() */
 	struct io_sq_data	*sq_data;	/* if using sq thread polling */
 
@@ -409,14 +403,6 @@ struct io_ring_ctx {
 	unsigned		nr_user_bufs;
 	struct io_mapped_ubuf	**user_bufs;
 
-	struct user_struct	*user;
-
-	struct completion	ref_comp;
-
-#if defined(CONFIG_UNIX)
-	struct socket		*ring_sock;
-#endif
-
 	struct xarray		io_buffers;
 
 	struct xarray		personalities;
@@ -460,12 +446,24 @@ struct io_ring_ctx {
 
 	struct io_restriction		restrictions;
 
-	/* exit task_work */
-	struct callback_head		*exit_task_work;
-
 	/* Keep this last, we don't need it for the fast path */
-	struct work_struct		exit_work;
-	struct list_head		tctx_list;
+	struct {
+		#if defined(CONFIG_UNIX)
+			struct socket		*ring_sock;
+		#endif
+		/* hashed buffered write serialization */
+		struct io_wq_hash		*hash_map;
+
+		/* Only used for accounting purposes */
+		struct user_struct		*user;
+		struct mm_struct		*mm_account;
+
+		/* ctx exit and cancelation */
+		struct callback_head		*exit_task_work;
+		struct work_struct		exit_work;
+		struct list_head		tctx_list;
+		struct completion		ref_comp;
+	};
 };
 
 struct io_uring_task {
-- 
2.31.1

