Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B25DC314345
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 23:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbhBHWx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 17:53:57 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22648 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230282AbhBHWxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 17:53:52 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 118Mmk0N007188
        for <netdev@vger.kernel.org>; Mon, 8 Feb 2021 14:53:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=wtfRLaxhtN/XLmbEVOfn0W2L14eyqr9QuV8fJoD1MM8=;
 b=RGeiTdmglUkeyJLZpvuA6wDDYxmfwJikOv8Z7w3M8CZ/NuE/EPuYIRIBDszDkvG6U70I
 LEnt1MR7/SkhPBfvxaEs+DU7X+soY7ydOJlvKbDXoZnJ9VsmvmBc6bM9y/7wGjbPmmKd
 tKssEUqYl5VntAZvV+RCasc45r7PLIvQRAg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 36jca9yg12-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 14:53:11 -0800
Received: from intmgw002.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 8 Feb 2021 14:53:09 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 7FC9362E092E; Mon,  8 Feb 2021 14:53:06 -0800 (PST)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-mm@kvack.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <akpm@linux-foundation.org>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, KP Singh <kpsingh@kernel.org>
Subject: [PATCH v5 bpf-next 3/4] libbpf: introduce section "iter.s/" for sleepable bpf_iter program
Date:   Mon, 8 Feb 2021 14:52:54 -0800
Message-ID: <20210208225255.3089073-4-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210208225255.3089073-1-songliubraving@fb.com>
References: <20210208225255.3089073-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-08_16:2021-02-08,2021-02-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=852 phishscore=0
 bulkscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102080127
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

