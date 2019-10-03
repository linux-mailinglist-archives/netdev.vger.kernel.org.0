Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB02CB124
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 23:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733040AbfJCV30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 17:29:26 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61174 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732268AbfJCV3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 17:29:24 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x93LSMek026756
        for <netdev@vger.kernel.org>; Thu, 3 Oct 2019 14:29:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=K4V3nz3THGLG+9+5/A0MKZN3ohOYWc2rVuARlKuAMJM=;
 b=Yai7dA8+sFJw3rooC7VXx61zt+YXi5KDfwgsZTP3qXxwvfjbMDPzCeAFc+W39dyGYjNg
 ZxeqpnTTD/WDpqU2LoJllNtvuJ9oN5ikVV4Kr8kEvMfGDJwD+LH5Wd31ttxrmVmc9JUR
 pNXdJT31LdFXBsIrWb7fKkndkJ7o9v4/Q5k= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vdm68sfej-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 14:29:23 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 3 Oct 2019 14:29:00 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id D6CA38618DE; Thu,  3 Oct 2019 14:28:59 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v3 bpf-next 1/7] selftests/bpf: undo GCC-specific bpf_helpers.h changes
Date:   Thu, 3 Oct 2019 14:28:50 -0700
Message-ID: <20191003212856.1222735-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191003212856.1222735-1-andriin@fb.com>
References: <20191003212856.1222735-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-03_08:2019-10-03,2019-10-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 adultscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 suspectscore=8
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910030172
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Having GCC provide its own bpf-helper.h is not the right approach and is
going to be changed. Undo bpf_helpers.h change before moving
bpf_helpers.h into libbpf.

Acked-by: Song Liu <songliubraving@fb.com>
Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/bpf_helpers.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index 54a50699bbfd..a1d9b97b8e15 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -13,8 +13,6 @@
 			 ##__VA_ARGS__);		\
 })
 
-#ifdef __clang__
-
 /* helper macro to place programs, maps, license in
  * different sections in elf_bpf file. Section names
  * are interpreted by elf_bpf loader
@@ -258,12 +256,6 @@ struct bpf_map_def {
 	unsigned int numa_node;
 };
 
-#else
-
-#include <bpf-helpers.h>
-
-#endif
-
 #define BPF_ANNOTATE_KV_PAIR(name, type_key, type_val)		\
 	struct ____btf_map_##name {				\
 		type_key key;					\
-- 
2.17.1

