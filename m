Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22936427805
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 10:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhJIIMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 04:12:22 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:55534 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229722AbhJIIMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 04:12:21 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0Ur5FUdx_1633766979;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0Ur5FUdx_1633766979)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 09 Oct 2021 16:10:23 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     aelior@marvell.com
Cc:     GR-everest-linux-l2@marvell.com, davem@davemloft.net,
        kuba@kernel.org, linux@armlinux.org.uk, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, chongjiapeng <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] qed: Fix missing error code in qed_slowpath_start()
Date:   Sat,  9 Oct 2021 16:09:26 +0800
Message-Id: <1633766966-115907-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: chongjiapeng <jiapeng.chong@linux.alibaba.com>

The error code is missing in this code scenario, add the error code
'-EINVAL' to the return value 'rc'.

Eliminate the follow smatch warning:

drivers/net/ethernet/qlogic/qed/qed_main.c:1298 qed_slowpath_start()
warn: missing error code 'rc'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Fixes: d51e4af5c209 ("qed: aRFS infrastructure support")
Signed-off-by: chongjiapeng <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/ethernet/qlogic/qed/qed_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 5e7242304ee2..359ad859ae18 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -1295,6 +1295,7 @@ static int qed_slowpath_start(struct qed_dev *cdev,
 			} else {
 				DP_NOTICE(cdev,
 					  "Failed to acquire PTT for aRFS\n");
+				rc = -EINVAL;
 				goto err;
 			}
 		}
-- 
2.19.1.6.gb485710b

