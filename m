Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85FA461765F
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 06:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbiKCFx3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 3 Nov 2022 01:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbiKCFxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 01:53:23 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890CFDFB
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 22:53:20 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A2NW6fT003606
        for <netdev@vger.kernel.org>; Wed, 2 Nov 2022 22:53:20 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kkmtea0gk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 22:53:20 -0700
Received: from twshared19054.43.prn1.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 22:53:19 -0700
Received: by devbig019.vll3.facebook.com (Postfix, from userid 137359)
        id CB41A2102ECD2; Wed,  2 Nov 2022 22:53:09 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 02/10] selftests/bpf: shorten "Total insns/states" column names in veristat
Date:   Wed, 2 Nov 2022 22:52:56 -0700
Message-ID: <20221103055304.2904589-3-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221103055304.2904589-1-andrii@kernel.org>
References: <20221103055304.2904589-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: rv9shTCSBM_ixhfygkaJgq6AdUGVW7fB
X-Proofpoint-ORIG-GUID: rv9shTCSBM_ixhfygkaJgq6AdUGVW7fB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-02_15,2022-11-02_01,2022-06-22_01
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In comparison mode the "Total " part is pretty useless, but takes
a considerable amount of horizontal space. Drop the "Total " parts.

Also make sure that table headers for numerical columns are aligned in
the same fashion as integer values in those columns. This looks better
and is now more obvious with shorter "Insns" and "States" column
headers.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/veristat.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/veristat.c b/tools/testing/selftests/bpf/veristat.c
index 7e1432c06e0c..d553f38a6cee 100644
--- a/tools/testing/selftests/bpf/veristat.c
+++ b/tools/testing/selftests/bpf/veristat.c
@@ -405,13 +405,14 @@ static struct stat_def {
 	const char *header;
 	const char *names[4];
 	bool asc_by_default;
+	bool left_aligned;
 } stat_defs[] = {
-	[FILE_NAME] = { "File", {"file_name", "filename", "file"}, true /* asc */ },
-	[PROG_NAME] = { "Program", {"prog_name", "progname", "prog"}, true /* asc */ },
-	[VERDICT] = { "Verdict", {"verdict"}, true /* asc: failure, success */ },
+	[FILE_NAME] = { "File", {"file_name", "filename", "file"}, true /* asc */, true /* left */ },
+	[PROG_NAME] = { "Program", {"prog_name", "progname", "prog"}, true /* asc */, true /* left */ },
+	[VERDICT] = { "Verdict", {"verdict"}, true /* asc: failure, success */, true /* left */ },
 	[DURATION] = { "Duration (us)", {"duration", "dur"}, },
-	[TOTAL_INSNS] = { "Total insns", {"total_insns", "insns"}, },
-	[TOTAL_STATES] = { "Total states", {"total_states", "states"}, },
+	[TOTAL_INSNS] = { "Insns", {"total_insns", "insns"}, },
+	[TOTAL_STATES] = { "States", {"total_states", "states"}, },
 	[PEAK_STATES] = { "Peak states", {"peak_states"}, },
 	[MAX_STATES_PER_INSN] = { "Max states per insn", {"max_states_per_insn"}, },
 	[MARK_READ_MAX_LEN] = { "Max mark read length", {"max_mark_read_len", "mark_read"}, },
@@ -743,6 +744,7 @@ static void output_header_underlines(void)
 
 static void output_headers(enum resfmt fmt)
 {
+	const char *fmt_str;
 	int i, len;
 
 	for (i = 0; i < env.output_spec.spec_cnt; i++) {
@@ -756,7 +758,8 @@ static void output_headers(enum resfmt fmt)
 				*max_len = len;
 			break;
 		case RESFMT_TABLE:
-			printf("%s%-*s", i == 0 ? "" : COLUMN_SEP,  *max_len, stat_defs[id].header);
+			fmt_str = stat_defs[id].left_aligned ? "%s%-*s" : "%s%*s";
+			printf(fmt_str, i == 0 ? "" : COLUMN_SEP,  *max_len, stat_defs[id].header);
 			if (i == env.output_spec.spec_cnt - 1)
 				printf("\n");
 			break;
-- 
2.30.2

