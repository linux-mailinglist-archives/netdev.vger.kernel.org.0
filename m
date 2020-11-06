Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE472AA08D
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 23:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728818AbgKFWyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 17:54:12 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14506 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728111AbgKFWyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 17:54:11 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A6MQNeS017206
        for <netdev@vger.kernel.org>; Fri, 6 Nov 2020 14:54:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=hN7Pzg0lXHf+S6bi6++yUUi0RyO/7aF1fpHcGPgDXKM=;
 b=NsumXv38PUpHmizGGI4NIrnO2I94o8JxRb2Ex0pxuiVUN+sgiSi5084PWGIjosC0hIQV
 vIk+WNGrq1SP/Y7inlsyMJyCqvtxHkwmDxjYJ/F9Jxa24eiKxZki39BP4yF2m8m5nMQ3
 FfteVUvPGpgF3uYmnF8QAvMxbXZoNMtMRn8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34mx9pd2vp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 06 Nov 2020 14:54:10 -0800
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 6 Nov 2020 14:54:10 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id E2B8D2946425; Fri,  6 Nov 2020 14:54:02 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf-next] bpf: selftest: Use static globals in tcp_hdr_options and btf_skc_cls_ingress
Date:   Fri, 6 Nov 2020 14:54:02 -0800
Message-ID: <20201106225402.4135741-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-06_06:2020-11-05,2020-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 phishscore=0 spamscore=0 malwarescore=0 impostorscore=0 mlxscore=0
 mlxlogscore=908 suspectscore=13 clxscore=1015 adultscore=0
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011060153
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some globals in the tcp_hdr_options test and btf_skc_cls_ingress test
are not using static scope.  This patch fixes it.

Targeting bpf-next branch as an improvement since it currently does not
break the build.

Fixes: ad2f8eb0095e ("bpf: selftests: Tcp header options")
Fixes: 9a856cae2217 ("bpf: selftest: Add test_btf_skc_cls_ingress")
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 .../selftests/bpf/prog_tests/btf_skc_cls_ingress.c   |  2 +-
 .../selftests/bpf/prog_tests/tcp_hdr_options.c       | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/btf_skc_cls_ingress.c=
 b/tools/testing/selftests/bpf/prog_tests/btf_skc_cls_ingress.c
index 86ccf37e26b3..762f6a9da8b5 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf_skc_cls_ingress.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf_skc_cls_ingress.c
@@ -17,7 +17,7 @@
 #include "test_btf_skc_cls_ingress.skel.h"
=20
 static struct test_btf_skc_cls_ingress *skel;
-struct sockaddr_in6 srv_sa6;
+static struct sockaddr_in6 srv_sa6;
 static __u32 duration;
=20
 #define PROG_PIN_FILE "/sys/fs/bpf/btf_skc_cls_ingress"
diff --git a/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c b/t=
ools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
index c85174cdcb77..08d19cafd5e8 100644
--- a/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
+++ b/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
@@ -18,12 +18,12 @@
 #define LO_ADDR6 "::1"
 #define CG_NAME "/tcpbpf-hdr-opt-test"
=20
-struct bpf_test_option exp_passive_estab_in;
-struct bpf_test_option exp_active_estab_in;
-struct bpf_test_option exp_passive_fin_in;
-struct bpf_test_option exp_active_fin_in;
-struct hdr_stg exp_passive_hdr_stg;
-struct hdr_stg exp_active_hdr_stg =3D { .active =3D true, };
+static struct bpf_test_option exp_passive_estab_in;
+static struct bpf_test_option exp_active_estab_in;
+static struct bpf_test_option exp_passive_fin_in;
+static struct bpf_test_option exp_active_fin_in;
+static struct hdr_stg exp_passive_hdr_stg;
+static struct hdr_stg exp_active_hdr_stg =3D { .active =3D true, };
=20
 static struct test_misc_tcp_hdr_options *misc_skel;
 static struct test_tcp_hdr_options *skel;
--=20
2.24.1

