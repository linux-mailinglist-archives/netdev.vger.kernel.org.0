Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 995FC393F12
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 10:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236104AbhE1JAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 05:00:18 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2076 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbhE1JAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 05:00:17 -0400
Received: from dggeml767-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Frz4r4kVqzWnqs;
        Fri, 28 May 2021 16:54:04 +0800 (CST)
Received: from dggema762-chm.china.huawei.com (10.1.198.204) by
 dggeml767-chm.china.huawei.com (10.1.199.177) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 28 May 2021 16:58:40 +0800
Received: from huawei.com (10.175.127.227) by dggema762-chm.china.huawei.com
 (10.1.198.204) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Fri, 28
 May 2021 16:58:40 +0800
From:   Yu Kuai <yukuai3@huawei.com>
To:     <shuah@kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andrii@kernel.org>
CC:     <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yukuai3@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH] selftests/bpf: Fix return value check in attach_bpf()
Date:   Fri, 28 May 2021 17:07:58 +0800
Message-ID: <20210528090758.1108464-1-yukuai3@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggema762-chm.china.huawei.com (10.1.198.204)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use libbpf_get_error() to check the return value of
bpf_program__attach().

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 tools/testing/selftests/bpf/benchs/bench_rename.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/benchs/bench_rename.c b/tools/testing/selftests/bpf/benchs/bench_rename.c
index c7ec114eca56..b7d4a1d74fca 100644
--- a/tools/testing/selftests/bpf/benchs/bench_rename.c
+++ b/tools/testing/selftests/bpf/benchs/bench_rename.c
@@ -65,7 +65,7 @@ static void attach_bpf(struct bpf_program *prog)
 	struct bpf_link *link;
 
 	link = bpf_program__attach(prog);
-	if (!link) {
+	if (libbpf_get_error(link)) {
 		fprintf(stderr, "failed to attach program!\n");
 		exit(1);
 	}
-- 
2.25.4

