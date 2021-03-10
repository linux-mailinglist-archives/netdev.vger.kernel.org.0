Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47CA13333C2
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 04:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbhCJDTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 22:19:06 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:54166 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230490AbhCJDSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 22:18:42 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0URBTR1u_1615346312;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0URBTR1u_1615346312)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 10 Mar 2021 11:18:38 +0800
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
Subject: [PATCH] perf tools: Remove redundant code
Date:   Wed, 10 Mar 2021 11:18:25 +0800
Message-Id: <1615346305-16428-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warnings:

./tools/perf/util/evlist.c:1315:5-8: Unneeded variable: "err". Return "-
ENOMEM" on line 1340.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 tools/perf/util/evlist.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 882cd1f..6c2a271 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1313,7 +1313,6 @@ static int evlist__create_syswide_maps(struct evlist *evlist)
 {
 	struct perf_cpu_map *cpus;
 	struct perf_thread_map *threads;
-	int err = -ENOMEM;
 
 	/*
 	 * Try reading /sys/devices/system/cpu/online to get
@@ -1338,7 +1337,7 @@ static int evlist__create_syswide_maps(struct evlist *evlist)
 out_put:
 	perf_cpu_map__put(cpus);
 out:
-	return err;
+	return -ENOMEM;
 }
 
 int evlist__open(struct evlist *evlist)
-- 
1.8.3.1

