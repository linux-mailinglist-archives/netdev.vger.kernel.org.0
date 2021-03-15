Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EED233B499
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 14:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbhCONbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 09:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbhCONbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 09:31:01 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 927B6C06174A;
        Mon, 15 Mar 2021 06:31:01 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id n9so19498172pgi.7;
        Mon, 15 Mar 2021 06:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C2lzz6jIzx+Vnv5jzmRecZmwAHLB3q74dtaf4ZVkRWM=;
        b=BUUKsuxR3NSckzePNUzO6VJ4bGoFbkiU24IqVMTTOON+LYKzr7HNAL4DznkPCW0DJN
         GqFO7jYPQkkvqS+PN2RA3tYoSP12M6di6P/h1jM8E3BqFqVSF2uQCa8P4oTSkZJzpuCY
         GkMmUw04VA6SuTKX1CoXrx82kEZ7JbmDa/ciH5Xrx2Pzj8Y8Mr4IJhaXtocWodYcgIUi
         xR4XqxGkz0i3IY9DZXBCMsAOmmUejJj4iIviUa0PEiXZumTaU3h3QlCDuwAOJzr4120f
         /7AsNHnjw9qh6YIQ7XyGz/d0kPCXU19P2T+saI71/E3JLFITm6TxpZuodqRRSl4soL10
         4HYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C2lzz6jIzx+Vnv5jzmRecZmwAHLB3q74dtaf4ZVkRWM=;
        b=luKmikmPsLgkBCRG2rkbbcxX30BDPqCzx450ICJFiqTs9njwKrJJIfcRebozE2Ba9N
         NOm7XsVS3ZMrVaHXJxBNbqLLhcZY67vwGMeKRnZxQXW3GX2pHcuz1+V2GLi4clsEjLxQ
         nDNjaEyVprXMbBgHHPD058PzOY6buqh9E81OkaDGxqVVrGi7uLNg9qG4jEJJjjPLXMRD
         NmjKcTFSyEr/NSTbSVz/j7oUCZz44iZRSu16sqyi7H7yU/NQkR6SzBjYGrYVzkLK68xs
         ekTv28ZihrD95jvqAUdgwG7b2U5WbLps0UFZjGpuM+7qFzBNdxPlhJuj/AVnMvZnYDl4
         wapQ==
X-Gm-Message-State: AOAM5311sTBSTujt7e+vPe65Jlj1r5/0uZtnxMijwRWBcdf81B84r4AB
        1Avfez2IVWrjIpgkVENHXS4=
X-Google-Smtp-Source: ABdhPJwAwcy939e/8tT2fBbIqybgQaZV+UU2Zb/8Hg5xT5plwP2hSus0QH4YaoUX8MAtlEGwpjleAA==
X-Received: by 2002:aa7:9202:0:b029:1f2:9439:f4b4 with SMTP id 2-20020aa792020000b02901f29439f4b4mr10159808pfo.12.1615815060986;
        Mon, 15 Mar 2021 06:31:00 -0700 (PDT)
Received: from localhost.localdomain ([205.220.128.205])
        by smtp.gmail.com with ESMTPSA id q25sm13620380pff.104.2021.03.15.06.30.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 06:31:00 -0700 (PDT)
From:   Pedro Tammela <pctammela@gmail.com>
Cc:     Pedro Tammela <pctammela@gmail.com>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] bpf: selftests: remove unused 'nospace_err' in tests for batched ops in array maps
Date:   Mon, 15 Mar 2021 14:29:51 +0100
Message-Id: <20210315132954.603108-1-pctammela@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This seems to be a reminiscent from the hashmap tests.

Signed-off-by: Pedro Tammela <pctammela@gmail.com>
---
 tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c b/tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c
index f0a64d8ac59a..e42ea1195d18 100644
--- a/tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c
+++ b/tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c
@@ -55,7 +55,6 @@ void test_array_map_batch_ops(void)
 	int map_fd, *keys, *values, *visited;
 	__u32 count, total, total_success;
 	const __u32 max_entries = 10;
-	bool nospace_err;
 	__u64 batch = 0;
 	int err, step;
 	DECLARE_LIBBPF_OPTS(bpf_map_batch_opts, opts,
@@ -90,7 +89,6 @@ void test_array_map_batch_ops(void)
 		 * elements each.
 		 */
 		count = step;
-		nospace_err = false;
 		while (true) {
 			err = bpf_map_lookup_batch(map_fd,
 						total ? &batch : NULL, &batch,
@@ -107,9 +105,6 @@ void test_array_map_batch_ops(void)
 
 		}
 
-		if (nospace_err == true)
-			continue;
-
 		CHECK(total != max_entries, "lookup with steps",
 		      "total = %u, max_entries = %u\n", total, max_entries);
 
-- 
2.25.1

