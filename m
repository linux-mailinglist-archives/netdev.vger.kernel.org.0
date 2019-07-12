Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D53267429
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 19:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbfGLR0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 13:26:21 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63236 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727289AbfGLR0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 13:26:20 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6CHJPnu023189
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 10:26:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=xW6SG4k1Rs+ZlCTlxu2pIGDqZC+9KjbDSxg/KmhEDu4=;
 b=XhkFSGayQhCFW0YMgTPXdT/H+YBE1sd0vkjyAM9yXYoYoE3XcdrabsKAhsc/vHm+cgbi
 0VzWuAB5LTtp8Omr4LqXwkxq+hxuQ9f0zF+bT4vtHXg4XGdoqFU452mp3G6o2AZIE6Mo
 p5uF5GskNdvMyvnqYmFr0VnYCAs8pcpZWsU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tpv120mbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 10:26:19 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 12 Jul 2019 10:26:17 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 695E98614A9; Fri, 12 Jul 2019 10:26:15 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <yhs@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v3 bpf 3/3] selftests/bpf: use typedef'ed arrays as map values
Date:   Fri, 12 Jul 2019 10:25:57 -0700
Message-ID: <20190712172557.4039121-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190712172557.4039121-1-andriin@fb.com>
References: <20190712172557.4039121-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-12_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=993 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907120177
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert few tests that couldn't use typedef'ed arrays due to kernel bug.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c     | 3 ++-
 tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c | 3 +--
 tools/testing/selftests/bpf/progs/test_stacktrace_map.c      | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c b/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
index d06b47a09097..33254b771384 100644
--- a/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
+++ b/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
@@ -47,11 +47,12 @@ struct {
  * issue and avoid complicated C programming massaging.
  * This is an acceptable workaround since there is one entry here.
  */
+typedef __u64 raw_stack_trace_t[2 * MAX_STACK_RAWTP];
 struct {
 	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
 	__uint(max_entries, 1);
 	__type(key, __u32);
-	__u64 (*value)[2 * MAX_STACK_RAWTP];
+	__type(value, raw_stack_trace_t);
 } rawdata_map SEC(".maps");
 
 SEC("tracepoint/raw_syscalls/sys_enter")
diff --git a/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c b/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c
index bbfc8337b6f0..f5638e26865d 100644
--- a/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c
+++ b/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c
@@ -36,8 +36,7 @@ struct {
 	__uint(type, BPF_MAP_TYPE_ARRAY);
 	__uint(max_entries, 128);
 	__type(key, __u32);
-	/* there seems to be a bug in kernel not handling typedef properly */
-	struct bpf_stack_build_id (*value)[PERF_MAX_STACK_DEPTH];
+	__type(value, stack_trace_t);
 } stack_amap SEC(".maps");
 
 /* taken from /sys/kernel/debug/tracing/events/random/urandom_read/format */
diff --git a/tools/testing/selftests/bpf/progs/test_stacktrace_map.c b/tools/testing/selftests/bpf/progs/test_stacktrace_map.c
index 803c15dc109d..fa0be3e10a10 100644
--- a/tools/testing/selftests/bpf/progs/test_stacktrace_map.c
+++ b/tools/testing/selftests/bpf/progs/test_stacktrace_map.c
@@ -35,7 +35,7 @@ struct {
 	__uint(type, BPF_MAP_TYPE_ARRAY);
 	__uint(max_entries, 16384);
 	__type(key, __u32);
-	__u64 (*value)[PERF_MAX_STACK_DEPTH];
+	__type(value, stack_trace_t);
 } stack_amap SEC(".maps");
 
 /* taken from /sys/kernel/debug/tracing/events/sched/sched_switch/format */
-- 
2.17.1

