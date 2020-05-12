Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 448931CF9CF
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 17:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730950AbgELPwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 11:52:51 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30598 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730938AbgELPws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 11:52:48 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04CFmavc019323
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 08:52:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=0gn3DYWf7vSzgvHKf7yhzTD38S/kpXqhd1hjZMOlyVc=;
 b=CBWYN/0kyliUsni7KjsPe32EVyDtXPJUxB3tgZvXMMBzBvBFeGX9wz+RSm4IOHTQ8Ruk
 9tmj6lD+j4AyzKjmfQZCziJvV+6vi78Vi9IkNYd4sORlCg1N0PyQ1OJBsJ3V4jOI8QsB
 TaP271Dduq3NDGRgjtM0FTRi1Kg/Zex4FXk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30xcgsd77s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 08:52:47 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 12 May 2020 08:52:46 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 439D83700839; Tue, 12 May 2020 08:52:40 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 8/8] samples/bpf: remove compiler warnings
Date:   Tue, 12 May 2020 08:52:40 -0700
Message-ID: <20200512155240.1080830-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200512155232.1080167-1-yhs@fb.com>
References: <20200512155232.1080167-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-12_05:2020-05-11,2020-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 spamscore=0 impostorscore=0 suspectscore=0 adultscore=0 phishscore=0
 bulkscore=0 clxscore=1015 malwarescore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005120120
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 5fbc220862fc ("tools/libpf: Add offsetof/container_of macro
in bpf_helpers.h") added macros offsetof/container_of to
bpf_helpers.h. Unfortunately, it caused compilation warnings
below for a few samples/bpf programs:
  In file included from /data/users/yhs/work/net-next/samples/bpf/sockex2=
_kern.c:4:
  In file included from /data/users/yhs/work/net-next/include/uapi/linux/=
in.h:24:
  In file included from /data/users/yhs/work/net-next/include/linux/socke=
t.h:8:
  In file included from /data/users/yhs/work/net-next/include/linux/uio.h=
:8:
  /data/users/yhs/work/net-next/include/linux/kernel.h:992:9: warning: 'c=
ontainer_of' macro redefined [-Wmacro-redefined]
          ^
  /data/users/yhs/work/net-next/tools/lib/bpf/bpf_helpers.h:46:9: note: p=
revious definition is here
          ^
  1 warning generated.
    CLANG-bpf  samples/bpf/sockex3_kern.o

In all these cases, bpf_helpers.h is included first, followed by other
standard headers. The macro container_of is defined unconditionally
in kernel.h, causing the compiler warning.

The fix is to move bpf_helpers.h after standard headers.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 samples/bpf/offwaketime_kern.c | 4 ++--
 samples/bpf/sockex2_kern.c     | 4 ++--
 samples/bpf/sockex3_kern.c     | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/samples/bpf/offwaketime_kern.c b/samples/bpf/offwaketime_ker=
n.c
index c4ec10dbfc3b..d459f73412a4 100644
--- a/samples/bpf/offwaketime_kern.c
+++ b/samples/bpf/offwaketime_kern.c
@@ -5,12 +5,12 @@
  * License as published by the Free Software Foundation.
  */
 #include <uapi/linux/bpf.h>
-#include <bpf/bpf_helpers.h>
-#include <bpf/bpf_tracing.h>
 #include <uapi/linux/ptrace.h>
 #include <uapi/linux/perf_event.h>
 #include <linux/version.h>
 #include <linux/sched.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
=20
 #define _(P) ({typeof(P) val; bpf_probe_read(&val, sizeof(val), &P); val=
;})
=20
diff --git a/samples/bpf/sockex2_kern.c b/samples/bpf/sockex2_kern.c
index a41dd520bc53..b7997541f7ee 100644
--- a/samples/bpf/sockex2_kern.c
+++ b/samples/bpf/sockex2_kern.c
@@ -1,12 +1,12 @@
 #include <uapi/linux/bpf.h>
-#include <bpf/bpf_helpers.h>
-#include "bpf_legacy.h"
 #include <uapi/linux/in.h>
 #include <uapi/linux/if.h>
 #include <uapi/linux/if_ether.h>
 #include <uapi/linux/ip.h>
 #include <uapi/linux/ipv6.h>
 #include <uapi/linux/if_tunnel.h>
+#include <bpf/bpf_helpers.h>
+#include "bpf_legacy.h"
 #define IP_MF		0x2000
 #define IP_OFFSET	0x1FFF
=20
diff --git a/samples/bpf/sockex3_kern.c b/samples/bpf/sockex3_kern.c
index 36d4dac23549..779a5249c418 100644
--- a/samples/bpf/sockex3_kern.c
+++ b/samples/bpf/sockex3_kern.c
@@ -5,8 +5,6 @@
  * License as published by the Free Software Foundation.
  */
 #include <uapi/linux/bpf.h>
-#include <bpf/bpf_helpers.h>
-#include "bpf_legacy.h"
 #include <uapi/linux/in.h>
 #include <uapi/linux/if.h>
 #include <uapi/linux/if_ether.h>
@@ -14,6 +12,8 @@
 #include <uapi/linux/ipv6.h>
 #include <uapi/linux/if_tunnel.h>
 #include <uapi/linux/mpls.h>
+#include <bpf/bpf_helpers.h>
+#include "bpf_legacy.h"
 #define IP_MF		0x2000
 #define IP_OFFSET	0x1FFF
=20
--=20
2.24.1

