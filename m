Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4BA01CF9D4
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 17:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730821AbgELPxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 11:53:15 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14334 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730287AbgELPxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 11:53:15 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04CFlNXf018924
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 08:53:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=EAZaFtu1f4mqdWfnHlV6sxdmyV5QwpLTzCD6zPOQrCo=;
 b=U/dAG2fe8MW8BQDVqRxVqDI0WZDdHIjvJ/LxZFNM77PJw8JlsMYaOWcBZmCUnjYvg8VV
 TQXO1nUuFAlcp61KOdn6/oaTpPnoX9uAT6RSmqjg2qidjuHleC9GfWBkJbcuo6wwoACr
 YJHSf3jZXIOAPwCBY/HsHzBavmCI8/ocwOY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30yx7a87sg-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 08:53:14 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 12 May 2020 08:52:35 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 917F63700839; Tue, 12 May 2020 08:52:33 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/8] bpf: change btf_iter func proto prefix to "bpf_iter_"
Date:   Tue, 12 May 2020 08:52:33 -0700
Message-ID: <20200512155233.1080305-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200512155232.1080167-1-yhs@fb.com>
References: <20200512155232.1080167-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-12_05:2020-05-11,2020-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 mlxlogscore=999 clxscore=1015 bulkscore=0 mlxscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120119
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is to be consistent with tracing and lsm programs
which have prefix "bpf_trace_" and "bpf_lsm_" respectively.

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h    | 6 +++---
 tools/lib/bpf/libbpf.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index cf4b6e44f2bc..ab94dfd8826f 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1131,10 +1131,10 @@ struct bpf_link *bpf_link_get_from_fd(u32 ufd);
 int bpf_obj_pin_user(u32 ufd, const char __user *pathname);
 int bpf_obj_get_user(const char __user *pathname, int flags);
=20
-#define BPF_ITER_FUNC_PREFIX "__bpf_iter__"
+#define BPF_ITER_FUNC_PREFIX "bpf_iter_"
 #define DEFINE_BPF_ITER_FUNC(target, args...)			\
-	extern int __bpf_iter__ ## target(args);		\
-	int __init __bpf_iter__ ## target(args) { return 0; }
+	extern int bpf_iter_ ## target(args);			\
+	int __init bpf_iter_ ## target(args) { return 0; }
=20
 typedef int (*bpf_iter_init_seq_priv_t)(void *private_data);
 typedef void (*bpf_iter_fini_seq_priv_t)(void *private_data);
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 3da66540b54b..d063c247615f 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6897,7 +6897,7 @@ static int bpf_object__collect_st_ops_relos(struct =
bpf_object *obj,
=20
 #define BTF_TRACE_PREFIX "btf_trace_"
 #define BTF_LSM_PREFIX "bpf_lsm_"
-#define BTF_ITER_PREFIX "__bpf_iter__"
+#define BTF_ITER_PREFIX "bpf_iter_"
 #define BTF_MAX_NAME_SIZE 128
=20
 static int find_btf_by_prefix_kind(const struct btf *btf, const char *pr=
efix,
--=20
2.24.1

