Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9331D319815
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 02:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbhBLBnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 20:43:45 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20296 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229469AbhBLBne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 20:43:34 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 11C1dHwG007130
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 17:42:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=wtfRLaxhtN/XLmbEVOfn0W2L14eyqr9QuV8fJoD1MM8=;
 b=o2IXa4gx+Oj/IRQTwxrGbXc4AHM2TuFisuIH8/Vo/CtuQFZyNtNyEmkIapsrjLmzwPAK
 rmkO3nbGvJd1Tjd1UxX8IjdNhgptPbpYNIhBGq1fp7xjXS2zAEGk3zOYybuvVxn2J9uo
 PelOQHPrvifhGgLDs8a6TfvohhBsFtgAv8g= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 36n70a3rud-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 17:42:53 -0800
Received: from intmgw006.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 11 Feb 2021 17:42:51 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 07DC762E0B5D; Thu, 11 Feb 2021 17:42:48 -0800 (PST)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-mm@kvack.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <akpm@linux-foundation.org>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, KP Singh <kpsingh@kernel.org>
Subject: [PATCH v6 bpf-next 3/4] libbpf: introduce section "iter.s/" for sleepable bpf_iter program
Date:   Thu, 11 Feb 2021 17:42:31 -0800
Message-ID: <20210212014232.414643-4-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210212014232.414643-1-songliubraving@fb.com>
References: <20210212014232.414643-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_07:2021-02-11,2021-02-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=852 lowpriorityscore=0 malwarescore=0 adultscore=0
 clxscore=1015 suspectscore=0 impostorscore=0 mlxscore=0 phishscore=0
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102120008
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

