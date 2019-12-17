Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE0091223E5
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 06:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727532AbfLQFhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 00:37:02 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63472 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725812AbfLQFhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 00:37:01 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBH5axwU032433
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 21:37:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=WqTlYCjEzkQ0P1tCM0n8NbfOnh21Q8EIijCpAse+TYI=;
 b=AQX8zqXvpZ5Sc6892eYa7NwvfFpmyHYn1HNFv8SARwEo2ONNUucLP4YHZODTddIqagsD
 ZKKIndeSiRfc68K5X0hjx5prEF3OmiuUs8odYlnQnkabBGP0SWhAu2SH8syXihYVFqEf
 qLEWAVeIpp8Pdss0NP2coNKToB9jlbcjQUc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wwgc0qwpb-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 21:37:00 -0800
Received: from intmgw001.05.ash5.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 16 Dec 2019 21:36:33 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id C1A592EC1AFA; Mon, 16 Dec 2019 21:36:32 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/3] libbpf: remove BPF_EMBED_OBJ macro from libbpf.h
Date:   Mon, 16 Dec 2019 21:36:25 -0800
Message-ID: <20191217053626.2158870-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191217053626.2158870-1-andriin@fb.com>
References: <20191217053626.2158870-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-17_01:2019-12-16,2019-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 impostorscore=0 spamscore=0 phishscore=0 clxscore=1015 suspectscore=8
 mlxlogscore=999 mlxscore=0 priorityscore=1501 lowpriorityscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912170050
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop BPF_EMBED_OBJ and struct bpf_embed_data now that skeleton automatically
embeds contents of its source object file. While BPF_EMBED_OBJ is useful
independently of skeleton, we are currently don't have any use cases utilizing
it, so let's remove them until/if we need it.

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

