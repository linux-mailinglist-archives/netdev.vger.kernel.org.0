Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 843B2123F18
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 06:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbfLRF0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 00:26:02 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58646 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725881AbfLRF0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 00:26:01 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBI5Lj4h005187
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 21:26:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=D6y+3jdJqwqJD4nYHmnSjqa/fowots0vevcZpt+xqds=;
 b=Nuj+JCB76/Fb51X9OXlrNNzd+v++3mzC6i40EhUM4jzONgEbhi0m0MWdmuVkRQBfO3yq
 cGhI/K0XqyfcjyjWDbrRwMh2sA5feooOEvfXAtyi5JHUWHL4VGcQIZhGhhczSlk2f4m1
 vVn2LImTHTSAkhIUqwFd67KF4FcW4Mu4kP4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wxph0p1kq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 21:26:00 -0800
Received: from intmgw003.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 17 Dec 2019 21:25:59 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 657872EC17A4; Tue, 17 Dec 2019 21:25:58 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 2/3] libbpf: remove BPF_EMBED_OBJ macro from libbpf.h
Date:   Tue, 17 Dec 2019 21:25:51 -0800
Message-ID: <20191218052552.2915188-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191218052552.2915188-1-andriin@fb.com>
References: <20191218052552.2915188-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-17_05:2019-12-17,2019-12-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 clxscore=1015 mlxscore=0 adultscore=0 spamscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912180041
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop BPF_EMBED_OBJ and struct bpf_embed_data now that skeleton automatically
embeds contents of its source object file. While BPF_EMBED_OBJ is useful
independently of skeleton, we are currently don't have any use cases utilizing
it, so let's remove them until/if we need it.

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.h | 35 -----------------------------------
 1 file changed, 35 deletions(-)

diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 6340823871e2..f7084235bae9 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -600,41 +600,6 @@ bpf_program__bpil_offs_to_addr(struct bpf_prog_info_linear *info_linear);
  */
 LIBBPF_API int libbpf_num_possible_cpus(void);
 
-struct bpf_embed_data {
-	void *data;
-	size_t size;
-};
-
-#define BPF_EMBED_OBJ_DECLARE(NAME)					\
-extern struct bpf_embed_data NAME##_embed;				\
-extern char NAME##_data[];						\
-extern char NAME##_data_end[];
-
-#define __BPF_EMBED_OBJ(NAME, PATH, SZ, ASM_TYPE)			\
-asm (									\
-"	.pushsection \".rodata\", \"a\", @progbits		\n"	\
-"	.global "#NAME"_data					\n"	\
-#NAME"_data:							\n"	\
-"	.incbin \"" PATH "\"					\n"	\
-"	.global "#NAME"_data_end				\n"	\
-#NAME"_data_end:						\n"	\
-"	.global "#NAME"_embed					\n"	\
-"	.type "#NAME"_embed, @object				\n"	\
-"	.size "#NAME"_size, "#SZ"				\n"	\
-"	.align 8,						\n"	\
-#NAME"_embed:							\n"	\
-"	"ASM_TYPE" "#NAME"_data					\n"	\
-"	"ASM_TYPE" "#NAME"_data_end - "#NAME"_data 		\n"	\
-"	.popsection						\n"	\
-);									\
-BPF_EMBED_OBJ_DECLARE(NAME)
-
-#if __SIZEOF_POINTER__ == 4
-#define BPF_EMBED_OBJ(NAME, PATH) __BPF_EMBED_OBJ(NAME, PATH, 8, ".long")
-#else
-#define BPF_EMBED_OBJ(NAME, PATH) __BPF_EMBED_OBJ(NAME, PATH, 16, ".quad")
-#endif
-
 struct bpf_map_skeleton {
 	const char *name;
 	struct bpf_map **map;
-- 
2.17.1

