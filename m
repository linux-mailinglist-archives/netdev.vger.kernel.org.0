Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 429473103EB
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 04:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbhBEDz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 22:55:57 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:38825 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229692AbhBEDz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 22:55:56 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0UNvD5Bt_1612497257;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UNvD5Bt_1612497257)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 05 Feb 2021 11:55:05 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     peterz@infradead.org
Cc:     acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@redhat.com,
        namhyung@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] perf tools: Simplify the calculation of variables
Date:   Fri,  5 Feb 2021 11:54:15 +0800
Message-Id: <1612497255-87189-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warnings:

./tools/perf/util/header.c:3809:18-20: WARNING !A || A && B is
equivalent to !A || B.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 tools/perf/util/header.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index c4ed3dc..4fe9e2a 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -3806,7 +3806,7 @@ int perf_session__read_header(struct perf_session *session)
 	 * check for the pipe header regardless of source.
 	 */
 	err = perf_header__read_pipe(session);
-	if (!err || (err && perf_data__is_pipe(data))) {
+	if (!err || perf_data__is_pipe(data)) {
 		data->is_pipe = true;
 		return err;
 	}
-- 
1.8.3.1

