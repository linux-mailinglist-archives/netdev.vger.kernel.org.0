Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 385DD4C90FA
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 17:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235227AbiCAQ6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 11:58:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232656AbiCAQ6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 11:58:32 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F424DF63;
        Tue,  1 Mar 2022 08:57:50 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id ev16-20020a17090aead000b001bc3835fea8so2748693pjb.0;
        Tue, 01 Mar 2022 08:57:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zo/7GfGlOnzofFvvg9nl2uRoZm9krz9UZhB43diZ0xQ=;
        b=RNqA+/co2oe/6+gH0Z9qupty7/bWWmJnkIwk8N7n+UbysnG+ErCb3lADt8G0pVTK3U
         aUYi8LzRI/WMW8YKctdfQAb9HQ3r841bhMzzT57HtSqb3V7pjcDrNyHlysvuZI4J7t6M
         Z8rJNpG+H/lgc/3MBfbKhxOQCgD4O/vBczqOso2xjc1Z1GYcTI/YOUZzL6PaEbbuRNpQ
         zzv1qF2/mDvo7zrcKiJSr1+p7XyEE3Q/qbSd52AvM58dDLvULCuEk1EBa1mlN5hPjlDK
         vITfq18YvRdvc9rdJxzKosjdnYWLAPf4Cu8aBQ8d9e1K8ddOQzqwCnsO6h6ucHAZZsaV
         vflw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zo/7GfGlOnzofFvvg9nl2uRoZm9krz9UZhB43diZ0xQ=;
        b=rIVy0RmrLJyPiuunKwtzNp1NmqhWDjDc2A8W+HrB11MLB5lFIwXHz6ue0Vpro5bgTU
         g1UQNd0ubtw6wwstmQR3iD+Jxyf37DHNuohgUoAnULizfm9nyDL3n3xUDLV8CNjL5X+f
         Oh6lbDajDwzscjDPr+ygXbbgp8saIzlHWQX7dAMplN4yGzW7JRL/2fx/vYVPa1nIofxh
         /P8vmR0R/15Els/n7IWvB7Elrie60ZKbLVQloYUtFv0MnGfUnPhRsgcbdli6SsUURUj5
         7rKRbj3RagztUmbwhDaYSCkGthdPYfd5FcMvG84vn3+AW8seYdjuDQJfjO4S4UtGKrjF
         w9HA==
X-Gm-Message-State: AOAM5335KwkccFvT7HoiV62IIgw7VnA3KbR0razTLSQsHYOEV0b/WUM0
        uEs847aN10qnlGZK0xHzP+g8/GTe/oVB4Yjb
X-Google-Smtp-Source: ABdhPJyaTAyeGUQ7KahmWWxURRoepGSsTwC6E1Q1U1J+cTHYHX7a5lqwlr97c/hx8naBMGtBkz43Kw==
X-Received: by 2002:a17:902:b289:b0:14f:ebc2:8b85 with SMTP id u9-20020a170902b28900b0014febc28b85mr25905806plr.39.1646153870098;
        Tue, 01 Mar 2022 08:57:50 -0800 (PST)
Received: from localhost.localdomain ([223.212.58.71])
        by smtp.gmail.com with ESMTPSA id k17-20020a056a00169100b004f3c2ac6600sm17887468pfc.116.2022.03.01.08.57.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 08:57:49 -0800 (PST)
From:   Yuntao Wang <ytcoode@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yuntao Wang <ytcoode@gmail.com>
Subject: [PATCH bpf-next] libbpf: Add a check to ensure that page_cnt is non-zero
Date:   Wed,  2 Mar 2022 00:57:37 +0800
Message-Id: <20220301165737.672007-1-ytcoode@gmail.com>
X-Mailer: git-send-email 2.35.1
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

The page_cnt parameter is used to specify the number of memory pages
allocated for each per-CPU buffer, it must be non-zero and a power of 2.

Currently, the __perf_buffer__new() function attempts to validate that
the page_cnt is a power of 2 but forgets checking for the case where
page_cnt is zero, we can fix it by replacing 'page_cnt & (page_cnt - 1)'
with '!is_power_of_2(page_cnt)'.

Thus we also don't need to add a check in perf_buffer__new_v0_6_0() to
make sure that page_cnt is non-zero and the check for zero in
perf_buffer__new_raw_v0_6_0() can also be removed.

The code is cleaner and more readable.

Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
---
 tools/lib/bpf/libbpf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index be6480e260c4..4dd1d82cd5b9 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -33,6 +33,7 @@
 #include <linux/filter.h>
 #include <linux/list.h>
 #include <linux/limits.h>
+#include <linux/log2.h>
 #include <linux/perf_event.h>
 #include <linux/ring_buffer.h>
 #include <linux/version.h>
@@ -10951,7 +10952,7 @@ struct perf_buffer *perf_buffer__new_raw_v0_6_0(int map_fd, size_t page_cnt,
 {
 	struct perf_buffer_params p = {};
 
-	if (page_cnt == 0 || !attr)
+	if (!attr)
 		return libbpf_err_ptr(-EINVAL);
 
 	if (!OPTS_VALID(opts, perf_buffer_raw_opts))
@@ -10992,7 +10993,7 @@ static struct perf_buffer *__perf_buffer__new(int map_fd, size_t page_cnt,
 	__u32 map_info_len;
 	int err, i, j, n;
 
-	if (page_cnt & (page_cnt - 1)) {
+	if (!is_power_of_2(page_cnt)) {
 		pr_warn("page count should be power of two, but is %zu\n",
 			page_cnt);
 		return ERR_PTR(-EINVAL);
-- 
2.35.1

