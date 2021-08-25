Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E079F3F7CF4
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 21:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242541AbhHYT7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 15:59:39 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62492 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S242510AbhHYT7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 15:59:35 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 17PJo4vZ023253
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 12:58:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Gv/yZyXB5760uBwQg0XD45Cph37R+/F7ozHlwLCEuKU=;
 b=bA6SeEHEQTW9lxDz4R8yNFs7+0bBE9aovpsadLEPOAxWL7+yBmTR7FVNRSr1dik7lspf
 UiZxGhoXHyEMbG9xX9q+Rx6Sl7KIDlEd1SZepvE/l+zsCz4tSe7BIdrrFZkW2aMs9nKV
 RBL7wYIhc7w3w2pB6vGUQqEicsVmiyI7ei8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 3an5070rvn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 12:58:48 -0700
Received: from intmgw001.38.frc1.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 25 Aug 2021 12:58:44 -0700
Received: by devbig030.frc3.facebook.com (Postfix, from userid 158236)
        id 28BBB5A34F74; Wed, 25 Aug 2021 12:58:42 -0700 (PDT)
From:   Dave Marchevsky <davemarchevsky@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, <netdev@vger.kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>
Subject: [PATCH v2 bpf-next 6/6] selftests/bpf: add trace_vprintk test prog
Date:   Wed, 25 Aug 2021 12:58:23 -0700
Message-ID: <20210825195823.381016-7-davemarchevsky@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210825195823.381016-1-davemarchevsky@fb.com>
References: <20210825195823.381016-1-davemarchevsky@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: siqcsRFVRoKSbfyQE6sFcoC6H91vIK9V
X-Proofpoint-ORIG-GUID: siqcsRFVRoKSbfyQE6sFcoC6H91vIK9V
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-25_07:2021-08-25,2021-08-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 malwarescore=0
 adultscore=0 bulkscore=0 phishscore=0 impostorscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108250117
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds a test prog for vprintk which confirms that:
  * bpf_trace_vprintk is writing to dmesg
  * __bpf_vprintk macro works as expected
  * >3 args are printed

Approach and code are borrowed from trace_printk test.

Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
---
 tools/testing/selftests/bpf/Makefile          |  3 +-
 .../selftests/bpf/prog_tests/trace_vprintk.c  | 65 +++++++++++++++++++
 .../selftests/bpf/progs/trace_vprintk.c       | 25 +++++++
 3 files changed, 92 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_vprintk.=
c
 create mode 100644 tools/testing/selftests/bpf/progs/trace_vprintk.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftes=
ts/bpf/Makefile
index 2a58b7b5aea4..af5e7a1e9a7c 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -313,7 +313,8 @@ LINKED_SKELS :=3D test_static_linked.skel.h linked_fu=
ncs.skel.h		\
 		linked_vars.skel.h linked_maps.skel.h
=20
 LSKELS :=3D kfunc_call_test.c fentry_test.c fexit_test.c fexit_sleep.c \
-	test_ksyms_module.c test_ringbuf.c atomics.c trace_printk.c
+	test_ksyms_module.c test_ringbuf.c atomics.c trace_printk.c \
+	trace_vprintk.c
 SKEL_BLACKLIST +=3D $$(LSKELS)
=20
 test_static_linked.skel.h-deps :=3D test_static_linked1.o test_static_li=
nked2.o
diff --git a/tools/testing/selftests/bpf/prog_tests/trace_vprintk.c b/too=
ls/testing/selftests/bpf/prog_tests/trace_vprintk.c
new file mode 100644
index 000000000000..9fc1d279b673
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/trace_vprintk.c
@@ -0,0 +1,65 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+
+#include <test_progs.h>
+
+#include "trace_vprintk.lskel.h"
+
+#define TRACEBUF	"/sys/kernel/debug/tracing/trace_pipe"
+#define SEARCHMSG	"1,2,3,4,5,6,7,8,9,10"
+
+void test_trace_vprintk(void)
+{
+	int err =3D 0, iter =3D 0, found =3D 0;
+	struct trace_vprintk__bss *bss;
+	struct trace_vprintk *skel;
+	char *buf =3D NULL;
+	FILE *fp =3D NULL;
+	size_t buflen;
+
+	skel =3D trace_vprintk__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "trace_vprintk__open_and_load"))
+		goto cleanup;
+
+	bss =3D skel->bss;
+
+	err =3D trace_vprintk__attach(skel);
+	if (!ASSERT_OK(err, "trace_vprintk__attach"))
+		goto cleanup;
+
+	fp =3D fopen(TRACEBUF, "r");
+	if (!ASSERT_OK_PTR(fp, "fopen(TRACEBUF)"))
+		goto cleanup;
+
+	/* We do not want to wait forever if this test fails... */
+	fcntl(fileno(fp), F_SETFL, O_NONBLOCK);
+
+	/* wait for tracepoint to trigger */
+	usleep(1);
+	trace_vprintk__detach(skel);
+
+	if (!ASSERT_GT(bss->trace_vprintk_ran, 0, "bss->trace_vprintk_ran"))
+		goto cleanup;
+
+	if (!ASSERT_GT(bss->trace_vprintk_ret, 0, "bss->trace_vprintk_ret"))
+		goto cleanup;
+
+	/* verify our search string is in the trace buffer */
+	while (getline(&buf, &buflen, fp) >=3D 0 || errno =3D=3D EAGAIN) {
+		if (strstr(buf, SEARCHMSG) !=3D NULL)
+			found++;
+		if (found =3D=3D bss->trace_vprintk_ran)
+			break;
+		if (++iter > 1000)
+			break;
+	}
+
+	if (!ASSERT_EQ(found, bss->trace_vprintk_ran, "found"))
+		goto cleanup;
+
+cleanup:
+	trace_vprintk__destroy(skel);
+	free(buf);
+	if (fp)
+		fclose(fp);
+}
diff --git a/tools/testing/selftests/bpf/progs/trace_vprintk.c b/tools/te=
sting/selftests/bpf/progs/trace_vprintk.c
new file mode 100644
index 000000000000..255e2f018efe
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/trace_vprintk.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") =3D "GPL";
+
+int trace_vprintk_ret =3D 0;
+int trace_vprintk_ran =3D 0;
+
+SEC("fentry/__x64_sys_nanosleep")
+int sys_enter(void *ctx)
+{
+	static const char one[] =3D "1";
+	static const char three[] =3D "3";
+	static const char five[] =3D "5";
+	static const char seven[] =3D "7";
+	static const char nine[] =3D "9";
+
+	trace_vprintk_ret =3D __bpf_vprintk("%s,%d,%s,%d,%s,%d,%s,%d,%s,%d %d\n=
",
+		one, 2, three, 4, five, 6, seven, 8, nine, 10, ++trace_vprintk_ran);
+	return 0;
+}
--=20
2.30.2

