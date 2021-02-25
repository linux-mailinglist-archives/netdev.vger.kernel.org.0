Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5653C324DA7
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 11:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbhBYKJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 05:09:13 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:52518 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233938AbhBYKFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 05:05:34 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0UPXARES_1614247485;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UPXARES_1614247485)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 25 Feb 2021 18:04:51 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     peterz@infradead.org
Cc:     mingo@redhat.com, acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@redhat.com,
        namhyung@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH v2] perf machine: Use true and false for bool variable
Date:   Thu, 25 Feb 2021 18:04:43 +0800
Message-Id: <1614247483-102665-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warnings:

./tools/perf/util/machine.c:2000:9-10: WARNING: return of 0/1 in
function 'symbol__match_regex' with return type bool.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
Changes in v2:
  - Simplified logic.

 tools/perf/util/machine.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 1e9d3f9..3a69c4f 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1996,9 +1996,7 @@ int machine__process_event(struct machine *machine, union perf_event *event,
 
 static bool symbol__match_regex(struct symbol *sym, regex_t *regex)
 {
-	if (!regexec(regex, sym->name, 0, NULL, 0))
-		return 1;
-	return 0;
+	return regexec(regex, sym->name, 0, NULL, 0) == 0;
 }
 
 static void ip__resolve_ams(struct thread *thread,
-- 
1.8.3.1

