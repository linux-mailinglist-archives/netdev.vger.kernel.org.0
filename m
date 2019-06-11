Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2403C0B6
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 02:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390101AbfFKA46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 20:56:58 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34006 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388927AbfFKA45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 20:56:57 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5B0hYwk012106
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 17:56:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=iidPHiSoo2ogzUL7fWoi/p4Utq22XtaHG55+yK6rt5U=;
 b=LygNiGB+xzI1gL8mIPE4tIBlv5ZS98uTFx2rIaD/zfwMPKRFBjqgOUv5Ppgnur9hRor8
 jdJ4G8GJBYxuAFXrNNm0tDvf0A1vw5hG1CkhsBwrT2fWCndCFfvdrG+iBn15qKrogQnb
 Agybp+USlBic744ApDVdvQkvgqFOulH2qjE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2t1sjx2bte-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 17:56:55 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 10 Jun 2019 17:56:54 -0700
Received: by devvm3632.prn2.facebook.com (Postfix, from userid 172007)
        id 9F764D0D72E4; Mon, 10 Jun 2019 17:56:53 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Hechao Li <hechaol@fb.com>
Smtp-Origin-Hostname: devvm3632.prn2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, <daniel@iogearbox.net>, <ast@kernel.org>,
        <kernel-team@fb.com>, Hechao Li <hechaol@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v6 bpf-next 2/3] selftests/bpf: remove bpf_util.h from BPF C progs
Date:   Mon, 10 Jun 2019 17:56:51 -0700
Message-ID: <20190611005652.3827331-3-hechaol@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190611005652.3827331-1-hechaol@fb.com>
References: <20190611005652.3827331-1-hechaol@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-10_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=13 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906110003
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Though currently there is no problem including bpf_util.h in kernel
space BPF C programs, in next patch in this stack, I will reuse
libbpf_num_possible_cpus() in bpf_util.h thus include libbpf.h in it,
which will cause BPF C programs compile error. Therefore I will first
remove bpf_util.h from all test BPF programs.

This can also make it clear that bpf_util.h is a user-space utility
while bpf_helpers.h is a kernel space utility.

Signed-off-by: Hechao Li <hechaol@fb.com>
---
 tools/testing/selftests/bpf/bpf_endian.h                 | 1 +
 tools/testing/selftests/bpf/progs/sockmap_parse_prog.c   | 1 -
 tools/testing/selftests/bpf/progs/sockmap_tcp_msg_prog.c | 2 +-
 tools/testing/selftests/bpf/progs/sockmap_verdict_prog.c | 1 -
 tools/testing/selftests/bpf/progs/test_sysctl_prog.c     | 5 ++++-
 5 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/bpf_endian.h b/tools/testing/selftests/bpf/bpf_endian.h
index b25595ea4a78..05f036df8a4c 100644
--- a/tools/testing/selftests/bpf/bpf_endian.h
+++ b/tools/testing/selftests/bpf/bpf_endian.h
@@ -2,6 +2,7 @@
 #ifndef __BPF_ENDIAN__
 #define __BPF_ENDIAN__
 
+#include <linux/stddef.h>
 #include <linux/swab.h>
 
 /* LLVM's BPF target selects the endianness of the CPU
diff --git a/tools/testing/selftests/bpf/progs/sockmap_parse_prog.c b/tools/testing/selftests/bpf/progs/sockmap_parse_prog.c
index ed3e4a551c57..9390e0244259 100644
--- a/tools/testing/selftests/bpf/progs/sockmap_parse_prog.c
+++ b/tools/testing/selftests/bpf/progs/sockmap_parse_prog.c
@@ -1,6 +1,5 @@
 #include <linux/bpf.h>
 #include "bpf_helpers.h"
-#include "bpf_util.h"
 #include "bpf_endian.h"
 
 int _version SEC("version") = 1;
diff --git a/tools/testing/selftests/bpf/progs/sockmap_tcp_msg_prog.c b/tools/testing/selftests/bpf/progs/sockmap_tcp_msg_prog.c
index 65fbfdb6cd3a..e80484d98a1a 100644
--- a/tools/testing/selftests/bpf/progs/sockmap_tcp_msg_prog.c
+++ b/tools/testing/selftests/bpf/progs/sockmap_tcp_msg_prog.c
@@ -1,6 +1,6 @@
 #include <linux/bpf.h>
+
 #include "bpf_helpers.h"
-#include "bpf_util.h"
 #include "bpf_endian.h"
 
 int _version SEC("version") = 1;
diff --git a/tools/testing/selftests/bpf/progs/sockmap_verdict_prog.c b/tools/testing/selftests/bpf/progs/sockmap_verdict_prog.c
index bdc22be46f2e..d85c874ef25e 100644
--- a/tools/testing/selftests/bpf/progs/sockmap_verdict_prog.c
+++ b/tools/testing/selftests/bpf/progs/sockmap_verdict_prog.c
@@ -1,6 +1,5 @@
 #include <linux/bpf.h>
 #include "bpf_helpers.h"
-#include "bpf_util.h"
 #include "bpf_endian.h"
 
 int _version SEC("version") = 1;
diff --git a/tools/testing/selftests/bpf/progs/test_sysctl_prog.c b/tools/testing/selftests/bpf/progs/test_sysctl_prog.c
index a295cad805d7..5cbbff416998 100644
--- a/tools/testing/selftests/bpf/progs/test_sysctl_prog.c
+++ b/tools/testing/selftests/bpf/progs/test_sysctl_prog.c
@@ -8,7 +8,6 @@
 #include <linux/bpf.h>
 
 #include "bpf_helpers.h"
-#include "bpf_util.h"
 
 /* Max supported length of a string with unsigned long in base 10 (pow2 - 1). */
 #define MAX_ULONG_STR_LEN 0xF
@@ -16,6 +15,10 @@
 /* Max supported length of sysctl value string (pow2). */
 #define MAX_VALUE_STR_LEN 0x40
 
+#ifndef ARRAY_SIZE
+#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
+#endif
+
 static __always_inline int is_tcp_mem(struct bpf_sysctl *ctx)
 {
 	char tcp_mem_name[] = "net/ipv4/tcp_mem";
-- 
2.17.1

