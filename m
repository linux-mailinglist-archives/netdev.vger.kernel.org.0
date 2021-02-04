Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 246C030FEE0
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 21:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbhBDUvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 15:51:04 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16260 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230027AbhBDUu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 15:50:59 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 114KiI3b018843
        for <netdev@vger.kernel.org>; Thu, 4 Feb 2021 12:50:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=wtfRLaxhtN/XLmbEVOfn0W2L14eyqr9QuV8fJoD1MM8=;
 b=KL7wr6Vpr0kaOHVC70gdGZ+1HJRGQ9uONAjW9/hsMS0pvs9k0UZTp9WSXpZZvwPonxck
 1x6s9Wem4ALru6x8Rt514kxY1MOaNfb3Zro7LVaDt6xBzbfcFVhKNByhcnzGdaf21C3h
 oEi0qUZPGsFqkr455J2HK6JzcYtxlCOCgJ4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 36fvyd0tme-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 12:50:18 -0800
Received: from intmgw001.05.ash7.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 4 Feb 2021 12:50:17 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 2344262E1750; Thu,  4 Feb 2021 12:50:14 -0800 (PST)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-mm@kvack.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <akpm@linux-foundation.org>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, KP Singh <kpsingh@kernel.org>
Subject: [PATCH v4 bpf-next 3/4] libbpf: introduce section "iter.s/" for sleepable bpf_iter program
Date:   Thu, 4 Feb 2021 12:50:00 -0800
Message-ID: <20210204205002.4075937-4-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210204205002.4075937-1-songliubraving@fb.com>
References: <20210204205002.4075937-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-04_10:2021-02-04,2021-02-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 mlxscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 spamscore=0 mlxlogscore=842
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102040128
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sleepable iterator program have access to helper functions like bpf_d_pat=
h.

Acked-by: Yonghong Song <yhs@fb.com>
Acked-by: KP Singh <kpsingh@kernel.org>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 tools/lib/bpf/libbpf.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 2abbc38005684..903ccd7e93206 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8555,6 +8555,11 @@ static const struct bpf_sec_def section_defs[] =3D=
 {
 		.expected_attach_type =3D BPF_TRACE_ITER,
 		.is_attach_btf =3D true,
 		.attach_fn =3D attach_iter),
+	SEC_DEF("iter.s/", TRACING,
+		.expected_attach_type =3D BPF_TRACE_ITER,
+		.is_attach_btf =3D true,
+		.is_sleepable =3D true,
+		.attach_fn =3D attach_iter),
 	BPF_EAPROG_SEC("xdp_devmap/",		BPF_PROG_TYPE_XDP,
 						BPF_XDP_DEVMAP),
 	BPF_EAPROG_SEC("xdp_cpumap/",		BPF_PROG_TYPE_XDP,
--=20
2.24.1

