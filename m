Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30C90D0047
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 20:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729529AbfJHR74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 13:59:56 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26428 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726336AbfJHR7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 13:59:55 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x98HxUYM016722
        for <netdev@vger.kernel.org>; Tue, 8 Oct 2019 10:59:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=76Gk0naCCpsyBqR1yVlnAM0v4hN68Eu2JwrVDrTYsZw=;
 b=ndAcQLmF05EHfzSned+5TckUXNIi6OQ50YvYbyg+CyhRBj/UX8fp4xpAQRvM4RbA+Gfz
 2Er4V4vWihX4xAx0luX7IjuUCKcaXHlnf49RiEfAIe9+sQBy9JiaF6eNNoVsLRib5Jge
 r4F3YTpf+6CVw96/zCr2IUGmtLiwhY1WWZ4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vg6ms6rvx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 10:59:54 -0700
Received: from 2401:db00:30:600c:face:0:1f:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 8 Oct 2019 10:59:53 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id C32498618D3; Tue,  8 Oct 2019 10:59:51 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v5 bpf-next 1/7] selftests/bpf: undo GCC-specific bpf_helpers.h changes
Date:   Tue, 8 Oct 2019 10:59:36 -0700
Message-ID: <20191008175942.1769476-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191008175942.1769476-1-andriin@fb.com>
References: <20191008175942.1769476-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-08_07:2019-10-08,2019-10-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=999 clxscore=1015 spamscore=0 phishscore=0
 bulkscore=0 impostorscore=0 suspectscore=8 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910080143
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
index 15152280db6f..ffd4d8c9a087 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -15,8 +15,6 @@
 			 ##__VA_ARGS__);		\
 })
 
-#ifdef __clang__
-
 /* helper macro to place programs, maps, license in
  * different sections in elf_bpf file. Section names
  * are interpreted by elf_bpf loader
@@ -47,12 +45,6 @@ struct bpf_map_def {
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

