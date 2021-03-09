Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB113322A8
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 11:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbhCIKLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 05:11:41 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:56822 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230173AbhCIKLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 05:11:18 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0UR53wqt_1615284670;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UR53wqt_1615284670)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 09 Mar 2021 18:11:15 +0800
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
Subject: [PATCH] perf machine: Assign boolean values to a bool variable
Date:   Tue,  9 Mar 2021 18:11:09 +0800
Message-Id: <1615284669-82139-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warnings:

./tools/perf/util/machine.c:2041:9-10: WARNING: return of 0/1 in
function 'symbol__match_regex' with return type bool.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 tools/perf/util/machine.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index b5c2d8b..435771e 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -2038,8 +2038,8 @@ int machine__process_event(struct machine *machine, union perf_event *event,
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

