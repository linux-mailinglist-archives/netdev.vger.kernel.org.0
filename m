Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A308D3071A0
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 09:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbhA1IhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 03:37:15 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:45074 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231561AbhA1Ig2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 03:36:28 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R471e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0UN7j3SL_1611822913;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0UN7j3SL_1611822913)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 28 Jan 2021 16:35:30 +0800
From:   Abaci Team <abaci-bugfix@linux.alibaba.com>
To:     peterz@infradead.org
Cc:     mingo@redhat.com, acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@redhat.com,
        namhyung@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Abaci Team <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH] bpf: Simplify bool conversion
Date:   Thu, 28 Jan 2021 16:35:12 +0800
Message-Id: <1611822912-3746-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:
./tools/perf/builtin-script.c:2789:36-41: WARNING: conversion to bool
not needed here
./tools/perf/builtin-script.c:3237:48-53: WARNING: conversion to bool
not needed here

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Suggested-by: Yang Li <oswb@linux.alibaba.com>
Signed-off-by: Abaci Team <abaci-bugfix@linux.alibaba.com>
---
 tools/perf/builtin-script.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 42dad4a..3646a1c 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -2786,7 +2786,7 @@ static int parse_output_fields(const struct option *opt __maybe_unused,
 				break;
 		}
 		if (i == imax && strcmp(tok, "flags") == 0) {
-			print_flags = change == REMOVE ? false : true;
+			print_flags = change != REMOVE;
 			continue;
 		}
 		if (i == imax) {
@@ -3234,7 +3234,7 @@ static char *get_script_path(const char *script_root, const char *suffix)
 
 static bool is_top_script(const char *script_path)
 {
-	return ends_with(script_path, "top") == NULL ? false : true;
+	return ends_with(script_path, "top") != NULL;
 }
 
 static int has_required_arg(char *script_path)
-- 
1.8.3.1

