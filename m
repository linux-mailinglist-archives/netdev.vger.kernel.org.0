Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0925B537888
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 12:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234593AbiE3I6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 04:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234541AbiE3I6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 04:58:40 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB7656204;
        Mon, 30 May 2022 01:58:36 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LBTnM2CPRzjXGm;
        Mon, 30 May 2022 16:57:27 +0800 (CST)
Received: from dggpemm500019.china.huawei.com (7.185.36.180) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 30 May 2022 16:58:32 +0800
Received: from k04.huawei.com (10.67.174.115) by
 dggpemm500019.china.huawei.com (7.185.36.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 30 May 2022 16:58:32 +0800
From:   Pu Lehui <pulehui@huawei.com>
To:     <bpf@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Pu Lehui <pulehui@huawei.com>
Subject: [PATCH bpf-next v3 6/6] selftests/bpf: Remove the casting about jited_ksyms and jited_linfo
Date:   Mon, 30 May 2022 17:28:15 +0800
Message-ID: <20220530092815.1112406-7-pulehui@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220530092815.1112406-1-pulehui@huawei.com>
References: <20220530092815.1112406-1-pulehui@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.115]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500019.china.huawei.com (7.185.36.180)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have unified data extension operation of jited_ksyms and jited_linfo
into zero extension, so there's no need to cast u64 memory address to
long data type.

Signed-off-by: Pu Lehui <pulehui@huawei.com>
---
 tools/testing/selftests/bpf/prog_tests/btf.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/btf.c b/tools/testing/selftests/bpf/prog_tests/btf.c
index e6612f2bd0cf..65bdc4aa0a63 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf.c
@@ -6599,8 +6599,8 @@ static int test_get_linfo(const struct prog_info_raw_test *test,
 	}
 
 	if (CHECK(jited_linfo[0] != jited_ksyms[0],
-		  "jited_linfo[0]:%lx != jited_ksyms[0]:%lx",
-		  (long)(jited_linfo[0]), (long)(jited_ksyms[0]))) {
+		  "jited_linfo[0]:%llx != jited_ksyms[0]:%llx",
+		  jited_linfo[0], jited_ksyms[0])) {
 		err = -1;
 		goto done;
 	}
@@ -6618,16 +6618,16 @@ static int test_get_linfo(const struct prog_info_raw_test *test,
 		}
 
 		if (CHECK(jited_linfo[i] <= jited_linfo[i - 1],
-			  "jited_linfo[%u]:%lx <= jited_linfo[%u]:%lx",
-			  i, (long)jited_linfo[i],
-			  i - 1, (long)(jited_linfo[i - 1]))) {
+			  "jited_linfo[%u]:%llx <= jited_linfo[%u]:%llx",
+			  i, jited_linfo[i],
+			  i - 1, jited_linfo[i - 1])) {
 			err = -1;
 			goto done;
 		}
 
 		if (CHECK(jited_linfo[i] - cur_func_ksyms > cur_func_len,
-			  "jited_linfo[%u]:%lx - %lx > %u",
-			  i, (long)jited_linfo[i], (long)cur_func_ksyms,
+			  "jited_linfo[%u]:%llx - %llx > %u",
+			  i, jited_linfo[i], cur_func_ksyms,
 			  cur_func_len)) {
 			err = -1;
 			goto done;
-- 
2.25.1

