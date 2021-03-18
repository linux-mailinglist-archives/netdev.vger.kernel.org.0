Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B62833FCF0
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 02:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbhCRB4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 21:56:35 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:45414 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230221AbhCRB4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 21:56:09 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0USLDzcs_1616032554;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0USLDzcs_1616032554)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 18 Mar 2021 09:56:05 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     shuah@kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] selftests/bpf: fix warning comparing pointer to 0
Date:   Thu, 18 Mar 2021 09:55:52 +0800
Message-Id: <1616032552-39866-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:

./tools/testing/selftests/bpf/progs/fentry_test.c:76:15-16: WARNING
comparing pointer to 0.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 tools/testing/selftests/bpf/progs/fentry_test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/fentry_test.c b/tools/testing/selftests/bpf/progs/fentry_test.c
index 5f645fd..d4247d6 100644
--- a/tools/testing/selftests/bpf/progs/fentry_test.c
+++ b/tools/testing/selftests/bpf/progs/fentry_test.c
@@ -64,7 +64,7 @@ struct bpf_fentry_test_t {
 SEC("fentry/bpf_fentry_test7")
 int BPF_PROG(test7, struct bpf_fentry_test_t *arg)
 {
-	if (arg == 0)
+	if (!arg)
 		test7_result = 1;
 	return 0;
 }
@@ -73,7 +73,7 @@ int BPF_PROG(test7, struct bpf_fentry_test_t *arg)
 SEC("fentry/bpf_fentry_test8")
 int BPF_PROG(test8, struct bpf_fentry_test_t *arg)
 {
-	if (arg->a == 0)
+	if (!arg->a)
 		test8_result = 1;
 	return 0;
 }
-- 
1.8.3.1

