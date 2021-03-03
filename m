Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7262D32C3E9
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234876AbhCDAJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:09:01 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:49938 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346340AbhCCHVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 02:21:33 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0UQBUUCk_1614756040;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UQBUUCk_1614756040)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 03 Mar 2021 15:20:48 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] bpf: Simplify the calculation of variables
Date:   Wed,  3 Mar 2021 15:20:35 +0800
Message-Id: <1614756035-111280-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warnings:

./tools/bpf/bpf_dbg.c:1201:55-57: WARNING !A || A && B is equivalent to
!A || B.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 tools/bpf/bpf_dbg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpf_dbg.c b/tools/bpf/bpf_dbg.c
index a07dfc4..00e560a 100644
--- a/tools/bpf/bpf_dbg.c
+++ b/tools/bpf/bpf_dbg.c
@@ -1198,7 +1198,7 @@ static int cmd_run(char *num)
 		else
 			return CMD_OK;
 		bpf_reset();
-	} while (pcap_next_pkt() && (!has_limit || (has_limit && ++i < pkts)));
+	} while (pcap_next_pkt() && (!has_limit || (++i < pkts)));
 
 	rl_printf("bpf passes:%u fails:%u\n", pass, fail);
 
-- 
1.8.3.1

