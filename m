Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF84D312C37
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 09:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbhBHItj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 03:49:39 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:56087 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230356AbhBHIq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 03:46:29 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0UO9kPqv_1612773937;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UO9kPqv_1612773937)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 08 Feb 2021 16:45:38 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     daniel@iogearbox.net
Cc:     peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
        mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
        jolsa@redhat.com, namhyung@kernel.org, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH v2] perf script: Simplify bool conversion
Date:   Mon,  8 Feb 2021 16:45:36 +0800
Message-Id: <1612773936-98691-1-git-send-email-yang.lee@linux.alibaba.com>
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
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---

Change in v2:
-Change the subject to "perf script"

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

