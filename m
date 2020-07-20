Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF7E226A70
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 18:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388984AbgGTQeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 12:34:14 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40440 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388986AbgGTQeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 12:34:10 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KGXvjl018889
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 09:34:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ntkMqyXsSqGoH9/qUYKTHfUXe9MnDwrfR3YYXgDvR0M=;
 b=FpwbTdG/fom1In2bnQ0d5X2IEYhJ3Jnxp6M7fLzoh4tCUaM7eHjXHNPfJwX20GlNuTeV
 d3sJ0yiwz15ArAkRDIbM+GKq2v9T1yRGzdz9SNyIszqeLBEsNdwp6R24TUhZ1vOZd2QE
 HPyoVbWPsuNnrhS0Yq4iGqTkQDvryFSbIZM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32bxwfqfy0-18
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 09:34:09 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 20 Jul 2020 09:34:01 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id CF6A8370209A; Mon, 20 Jul 2020 09:33:59 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v2 2/5] tools/bpf: sync btf_ids.h to tools
Date:   Mon, 20 Jul 2020 09:33:59 -0700
Message-ID: <20200720163359.1393079-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200720163358.1392964-1-yhs@fb.com>
References: <20200720163358.1392964-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-20_09:2020-07-20,2020-07-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 bulkscore=0 spamscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 mlxlogscore=786 phishscore=0 adultscore=0 impostorscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007200111
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sync kernel header btf_ids.h to tools directory.
Also define macro CONFIG_DEBUG_INFO_BTF before
including btf_ids.h in prog_tests/resolve_btfids.c
since non-stub definitions for BTF_ID_LIST etc. macros
are defined under CONFIG_DEBUG_INFO_BTF. This
prevented test_progs from failing.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 tools/include/linux/btf_ids.h                         | 11 ++++++++++-
 .../testing/selftests/bpf/prog_tests/resolve_btfids.c |  1 +
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/tools/include/linux/btf_ids.h b/tools/include/linux/btf_ids.=
h
index fe019774f8a7..1cdb56950ffe 100644
--- a/tools/include/linux/btf_ids.h
+++ b/tools/include/linux/btf_ids.h
@@ -3,6 +3,8 @@
 #ifndef _LINUX_BTF_IDS_H
 #define _LINUX_BTF_IDS_H
=20
+#ifdef CONFIG_DEBUG_INFO_BTF
+
 #include <linux/compiler.h> /* for __PASTE */
=20
 /*
@@ -21,7 +23,7 @@
 asm(							\
 ".pushsection " BTF_IDS_SECTION ",\"a\";       \n"	\
 ".local " #symbol " ;                          \n"	\
-".type  " #symbol ", @object;                  \n"	\
+".type  " #symbol ", STT_OBJECT;               \n"	\
 ".size  " #symbol ", 4;                        \n"	\
 #symbol ":                                     \n"	\
 ".zero 4                                       \n"	\
@@ -83,5 +85,12 @@ asm(							\
 ".zero 4                                       \n"	\
 ".popsection;                                  \n");
=20
+#else
+
+#define BTF_ID_LIST(name) static u32 name[5];
+#define BTF_ID(prefix, name)
+#define BTF_ID_UNUSED
+
+#endif /* CONFIG_DEBUG_INFO_BTF */
=20
 #endif
diff --git a/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c b/to=
ols/testing/selftests/bpf/prog_tests/resolve_btfids.c
index 403be6f36cba..22d83bba4e91 100644
--- a/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
+++ b/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
@@ -6,6 +6,7 @@
 #include <bpf/libbpf.h>
 #include <linux/btf.h>
 #include <linux/kernel.h>
+#define CONFIG_DEBUG_INFO_BTF
 #include <linux/btf_ids.h>
 #include "test_progs.h"
=20
--=20
2.24.1

