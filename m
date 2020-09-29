Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0B527CB2D
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 14:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732313AbgI2MZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 08:25:18 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39000 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728571AbgI2Ldc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 07:33:32 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08TBQ7Cq036419;
        Tue, 29 Sep 2020 11:33:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=5eiKz2brRks+GrpkHtsXF6Gc0uAMNWcrhtU8ADS/XBs=;
 b=DTVGzHKvq/YJJKjoGDdNlt+rnJGpXYffhyqcp3tBIbs7MIQYBcAv8nyTofK4BxvxIYrg
 MZjqnfgsaW7G+mr9nl2iMgH+6PgF8qzlrTZE5clmgu2NQe+z6kp6h+zMQPIxnZzLPxiR
 BI+JT2dFoJe7lHoh4WulGcduOR5wYbZoVpuYOtkTZnkGKQ2dleLycgp2csw5aSBZ1U4u
 i1+1OS7kclxjb2OTLZ4M5TwAx+HSN8maBjKGpX8APNv2FuC2UxbL+WWvgp6VgiSItdka
 Mr3Jc3lQscXbHCDmzYAXtqTrWxfP71Zo5UC6HfoYUoua435hW8ADWnvMeswh4dBet7PD bA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33swkkt5f2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 29 Sep 2020 11:33:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08TBTifZ052058;
        Tue, 29 Sep 2020 11:33:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 33tfjwj5ef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Sep 2020 11:33:12 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08TBXACA028093;
        Tue, 29 Sep 2020 11:33:10 GMT
Received: from localhost.uk.oracle.com (/10.175.172.184) by default (Oracle
 Beehive Gateway v4.0) with ESMTP ; Tue, 29 Sep 2020 04:32:50 -0700
MIME-Version: 1.0
Message-ID: <1601379151-21449-3-git-send-email-alan.maguire@oracle.com>
Date:   Tue, 29 Sep 2020 04:32:31 -0700 (PDT)
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next 2/2] selftests/bpf: ensure snprintf_btf/bpf_iter
 tests compatibility with old vmlinux.h
References: <1601379151-21449-1-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1601379151-21449-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain; charset=ascii
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009290103
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009290102
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii reports that bpf selftests relying on "struct btf_ptr" and BTF_F_*
values will not build as vmlinux.h for older kernels will not include
"struct btf_ptr" or the BTF_F_* enum values.  Undefine and redefine
them to work around this.

Fixes: b72091bd4ee4 ("selftests/bpf: Add test for bpf_seq_printf_btf helper")
Fixes: 076a95f5aff2 ("selftests/bpf: Add bpf_snprintf_btf helper tests")
Reported-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/testing/selftests/bpf/progs/bpf_iter.h       | 23 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/btf_ptr.h        | 27 ++++++++++++++++++++++
 .../selftests/bpf/progs/netif_receive_skb.c        |  2 +-
 3 files changed, 51 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/progs/btf_ptr.h

diff --git a/tools/testing/selftests/bpf/progs/bpf_iter.h b/tools/testing/selftests/bpf/progs/bpf_iter.h
index df682af..6a12554 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter.h
+++ b/tools/testing/selftests/bpf/progs/bpf_iter.h
@@ -14,6 +14,11 @@
 #define bpf_iter__bpf_map_elem bpf_iter__bpf_map_elem___not_used
 #define bpf_iter__bpf_sk_storage_map bpf_iter__bpf_sk_storage_map___not_used
 #define bpf_iter__sockmap bpf_iter__sockmap___not_used
+#define btf_ptr btf_ptr___not_used
+#define BTF_F_COMPACT BTF_F_COMPACT___not_used
+#define BTF_F_NONAME BTF_F_NONAME___not_used
+#define BTF_F_PTR_RAW BTF_F_PTR_RAW___not_used
+#define BTF_F_ZERO BTF_F_ZERO___not_used
 #include "vmlinux.h"
 #undef bpf_iter_meta
 #undef bpf_iter__bpf_map
@@ -28,6 +33,11 @@
 #undef bpf_iter__bpf_map_elem
 #undef bpf_iter__bpf_sk_storage_map
 #undef bpf_iter__sockmap
+#undef btf_ptr
+#undef BTF_F_COMPACT
+#undef BTF_F_NONAME
+#undef BTF_F_PTR_RAW
+#undef BTF_F_ZERO
 
 struct bpf_iter_meta {
 	struct seq_file *seq;
@@ -105,3 +115,16 @@ struct bpf_iter__sockmap {
 	void *key;
 	struct sock *sk;
 };
+
+struct btf_ptr {
+	void *ptr;
+	__u32 type_id;
+	__u32 flags;
+};
+
+enum {
+	BTF_F_COMPACT	=	(1ULL << 0),
+	BTF_F_NONAME	=	(1ULL << 1),
+	BTF_F_PTR_RAW	=	(1ULL << 2),
+	BTF_F_ZERO	=	(1ULL << 3),
+};
diff --git a/tools/testing/selftests/bpf/progs/btf_ptr.h b/tools/testing/selftests/bpf/progs/btf_ptr.h
new file mode 100644
index 0000000..c3c9797
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf_ptr.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2020, Oracle and/or its affiliates. */
+/* "undefine" structs in vmlinux.h, because we "override" them below */
+#define btf_ptr btf_ptr___not_used
+#define BTF_F_COMPACT BTF_F_COMPACT___not_used
+#define BTF_F_NONAME BTF_F_NONAME___not_used
+#define BTF_F_PTR_RAW BTF_F_PTR_RAW___not_used
+#define BTF_F_ZERO BTF_F_ZERO___not_used
+#include "vmlinux.h"
+#undef btf_ptr
+#undef BTF_F_COMPACT
+#undef BTF_F_NONAME
+#undef BTF_F_PTR_RAW
+#undef BTF_F_ZERO
+
+struct btf_ptr {
+	void *ptr;
+	__u32 type_id;
+	__u32 flags;
+};
+
+enum {
+	BTF_F_COMPACT	=	(1ULL << 0),
+	BTF_F_NONAME	=	(1ULL << 1),
+	BTF_F_PTR_RAW	=	(1ULL << 2),
+	BTF_F_ZERO	=	(1ULL << 3),
+};
diff --git a/tools/testing/selftests/bpf/progs/netif_receive_skb.c b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
index b873d80..6b67003 100644
--- a/tools/testing/selftests/bpf/progs/netif_receive_skb.c
+++ b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2020, Oracle and/or its affiliates. */
 
-#include "vmlinux.h"
+#include "btf_ptr.h"
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
 #include <bpf/bpf_core_read.h>
-- 
1.8.3.1

