Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB89F37635F
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 12:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235904AbhEGKRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 06:17:25 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:36333 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229812AbhEGKRR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 06:17:17 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0UY2dchp_1620382555;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UY2dchp_1620382555)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 07 May 2021 18:16:14 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     mcgrof@kernel.org
Cc:     keescook@chromium.org, yzaikin@google.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] sysctl: Remove redundant assignment to first
Date:   Fri,  7 May 2021 18:15:54 +0800
Message-Id: <1620382554-62511-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable first is set to '0', but this value is never read as it is
not used later on, hence it is a redundant assignment and can be
removed.

Clean up the following clang-analyzer warning:

kernel/sysctl.c:1562:4: warning: Value stored to 'first' is never read
[clang-analyzer-deadcode.DeadStores].

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 kernel/sysctl.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 14edf84..58beeba 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1559,7 +1559,6 @@ int proc_do_large_bitmap(struct ctl_table *table, int write,
 			}
 
 			bitmap_set(tmp_bitmap, val_a, val_b - val_a + 1);
-			first = 0;
 			proc_skip_char(&p, &left, '\n');
 		}
 		left += skipped;
-- 
1.8.3.1

