Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A17831E8DC
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 12:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbhBRKyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 05:54:14 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:55475 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231331AbhBRJZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 04:25:45 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0UOtQgUB_1613640280;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UOtQgUB_1613640280)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 18 Feb 2021 17:24:44 +0800
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
Subject: [PATCH] perf machine: Use true and false for bool variable
Date:   Thu, 18 Feb 2021 17:24:39 +0800
Message-Id: <1613640279-56480-1-git-send-email-jiapeng.chong@linux.alibaba.com>
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
 tools/perf/util/machine.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 1e9d3f9..f7ee29b 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1997,8 +1997,8 @@ int machine__process_event(struct machine *machine, union perf_event *event,
 static bool symbol__match_regex(struct symbol *sym, regex_t *regex)
 {
 	if (!regexec(regex, sym->name, 0, NULL, 0))
-		return 1;
-	return 0;
+		return true;
+	return false;
 }
 
 static void ip__resolve_ams(struct thread *thread,
-- 
1.8.3.1

