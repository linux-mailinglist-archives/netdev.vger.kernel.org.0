Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 320EC312DAC
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 10:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbhBHJqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 04:46:55 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:55985 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230334AbhBHJoc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 04:44:32 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0UO9surr_1612777422;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UO9surr_1612777422)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 08 Feb 2021 17:43:44 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] bpf: Simplify bool comparison
Date:   Mon,  8 Feb 2021 17:43:36 +0800
Message-Id: <1612777416-34339-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:

./tools/bpf/bpf_dbg.c:893:32-36: WARNING: Comparison to bool.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 tools/bpf/bpf_dbg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpf_dbg.c b/tools/bpf/bpf_dbg.c
index a0ebcdf..a07dfc4 100644
--- a/tools/bpf/bpf_dbg.c
+++ b/tools/bpf/bpf_dbg.c
@@ -890,7 +890,7 @@ static int bpf_run_stepping(struct sock_filter *f, uint16_t bpf_len,
 	bool stop = false;
 	int i = 1;
 
-	while (bpf_curr.Rs == false && stop == false) {
+	while (!bpf_curr.Rs && !stop) {
 		bpf_safe_regs();
 
 		if (i++ == next)
-- 
1.8.3.1

