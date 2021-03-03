Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 672E932C3F1
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235481AbhCDAJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:09:24 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:47459 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1842580AbhCCIH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 03:07:57 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0UQD.Zw3_1614757930;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UQD.Zw3_1614757930)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 03 Mar 2021 15:52:15 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     shuah@kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] selftests/bpf: Simplify the calculation of variables
Date:   Wed,  3 Mar 2021 15:52:10 +0800
Message-Id: <1614757930-17197-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warnings:

./tools/testing/selftests/bpf/test_sockmap.c:735:35-37: WARNING !A || A
&& B is equivalent to !A || B.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 tools/testing/selftests/bpf/test_sockmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 427ca00..eefd445 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -732,7 +732,7 @@ static int sendmsg_test(struct sockmap_options *opt)
 		 * socket is not a valid test. So in this case lets not
 		 * enable kTLS but still run the test.
 		 */
-		if (!txmsg_redir || (txmsg_redir && txmsg_ingress)) {
+		if (!txmsg_redir || txmsg_ingress) {
 			err = sockmap_init_ktls(opt->verbose, rx_fd);
 			if (err)
 				return err;
-- 
1.8.3.1

