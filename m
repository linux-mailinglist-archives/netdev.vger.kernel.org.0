Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC01419703
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 17:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234996AbhI0PC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 11:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235043AbhI0PCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 11:02:10 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86BD9C06176D;
        Mon, 27 Sep 2021 08:00:21 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id g2so12014859pfc.6;
        Mon, 27 Sep 2021 08:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jJYGi1zkIeuw27rkatjXNG5PEkuC/aMccRb7Npsrk9s=;
        b=q5dk9iQ7iCsM/K/R7AOh3Xh+VKGOsRc+XWSHpmZv7Caq0zi96dmGo/zw3DT8i4i+BM
         K16jgFMsa4y+jTHux/zPYXYb8oLU/7IgmOIjUjg80pMgI8I3WdqMWda0BPAjATYUHq3P
         hsf8xryrvEdk81fK8Ym6mkMVxkFbt2TrPSnKtYFk507KFw9fZMQy/Ydgws0jKkEUxGgv
         /UwTrPmdfojkawu/sVmNl39t1PpoAFXvcozhUCCA8i+gOgSbrQYNON+Ohw3C54CEPw44
         eKfIxdaItxKqHHjkp1uIBGm+TCMzL/Pc5ggVS2J8RQVVpZk92BcIWwHYvZ8I9DdPj7gF
         k7Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jJYGi1zkIeuw27rkatjXNG5PEkuC/aMccRb7Npsrk9s=;
        b=Jav1dzuYRHnl4wkL770sOthFFbxROCyt3q3hwScslCiTJ12GdlCg24aZRroSXwPZQZ
         Vs107OfFVyT3c+JPA5cDtnoxT6kEi3bgL547wUFTT3VnsvneNDMFp+1fWtQbE0flN9Cu
         mDVNIfY0sqwZjHr4NV0Jkf8OJsP7dtCY7wFDZNZsV5XtfJyj6zewxxl23AvTLW5MREbt
         rrx9pTzQK9TlHmT0Z/oGZit/mzXdfS/2Ssb4ny1b1lDEOW/vqU/v25QDdt6diHZe1DUo
         JWAsqPeWCM4r9ro4eMSM7yHRIjFnMYXhAOBABZgntEeIGYtl6yvwCeABWMu+mKZUISFa
         JjmQ==
X-Gm-Message-State: AOAM530okQfscMyX+B1ncclcxf8YecMwB+pS0wKSawgDHL/UEaoPjbU6
        mKovVL3LAE5WEp6Epsokw04ClyEfrjI=
X-Google-Smtp-Source: ABdhPJwoN4tQsmBitCfE1dnKZP4S+jfZABWlTDVcnRaCZ6nkQY/wbZatxrhC44gSAHJliIUkWbCfwQ==
X-Received: by 2002:a62:804b:0:b0:44b:9369:5def with SMTP id j72-20020a62804b000000b0044b93695defmr348896pfd.29.1632754820812;
        Mon, 27 Sep 2021 08:00:20 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id x9sm20216953pjp.50.2021.09.27.08.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 08:00:20 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v5 11/12] bpf: selftests: Fix fd cleanup in get_branch_snapshot
Date:   Mon, 27 Sep 2021 20:29:40 +0530
Message-Id: <20210927145941.1383001-12-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927145941.1383001-1-memxor@gmail.com>
References: <20210927145941.1383001-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1605; h=from:subject; bh=c77Pl0CO4LVQOtoLfE/1wWJcU2DcI56k8l974/sm848=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhUdxPnociSklHbvXNLA4XcWc4STUr38dyotdAygqz WTAXQ/GJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYVHcTwAKCRBM4MiGSL8Ryu0FEA Cq2BmaI/LXHaK+pfYuffSPliajGf3d1uIk/d6k/Sa+nmvMUDQl/uj1Kb77dVLSg5Cx/gvuwDJxwG9W 3puModv2mQtTQqlZNOszo2FgMc3YN872a6bk/GeAamBUVU+xweoUHTx9mzQToC936eBYjXiV/Tfpt5 Nmwyw7t1n/sBcldGT0tbgFFYHwTOya9MJocZz/2IjSYZ57GiEL8kHpqhvX250685FjlthhZngnJ7nT fcmlM91ZFK1v+htQEPELu9CW89pfmqX5paXIhbB6AKFIFWkVMZgmnxgCjYYksh/ncWbKr9JIMdfy5d y8iN2xkfB8HSENCYyW6HaZ6PRqFJdbwfY/+8m81Iizi2SMDAbBxwgQBMVp5h2adMr0uC37uYdWKumA h80YDFPGqsloGRRyD5QTJwuLXnHwr6zs+AopruaSqN+RD9ygeIIqvZm0Ny9ZDsiZCrExibhSRiqCtE zVroiX6hpfCM3cK0ODe5h/vaDU+/tAqSSjnNyCld4lNQgPwUdBX6o2QR1O6++AMLdDD8P1NePjr6rx 12ecGYMI11ZqKptCCXbVaYTPSTlBxLoltFoWPKMF6pNn6bt7EzumEPuDbH1wi/sP/CeaYBSpXHp0Y7 L6Q7SgehZ2BTTm3PAI4FWbaDquq60kKyM7oNYeGxeEuYczTOUlW0lI1+SUSQ==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cleanup code uses while (cpu++ < cpu_cnt) for closing fds, which means
it starts iterating from 1 for closing fds. If the first fd is -1, it
skips over it and closes garbage fds (typically zero) in the remaining
array. This leads to test failures for future tests when they end up
storing fd 0 (as the slot becomes free due to close(0)) in ldimm64's BTF
fd, ending up trying to match module BTF id with vmlinux.

This was observed as spurious CI failure for the ksym_module_libbpf and
module_attach tests. The test ends up closing fd 0 and breaking libbpf's
assumption that module BTF fd will always be > 0, which leads to the
kernel thinking that we are pointing to a BTF ID in vmlinux BTF.

Cc: Song Liu <songliubraving@fb.com>
Fixes: 025bd7c753aa (selftests/bpf: Add test for bpf_get_branch_snapshot)
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c b/tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c
index f81db9135ae4..67e86f8d8677 100644
--- a/tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c
+++ b/tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c
@@ -38,10 +38,9 @@ static int create_perf_events(void)
 
 static void close_perf_events(void)
 {
-	int cpu = 0;
-	int fd;
+	int cpu, fd;
 
-	while (cpu++ < cpu_cnt) {
+	for (cpu = 0; cpu < cpu_cnt; cpu++) {
 		fd = pfd_array[cpu];
 		if (fd < 0)
 			break;
-- 
2.33.0

