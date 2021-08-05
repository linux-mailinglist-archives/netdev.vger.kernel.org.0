Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2C23E0D79
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 07:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236878AbhHEFBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 01:01:53 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45688 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233118AbhHEFBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 01:01:51 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1754s6jD027352
        for <netdev@vger.kernel.org>; Wed, 4 Aug 2021 22:01:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=DgzkZCqlwoibU3Ql8/M8GfRLWeSvFcxUBBtgL39KVao=;
 b=YtOivO6zd6ajPJK5WtLeKZfp0jvJrF2vknXbY3v6yZhoWRbbVJ/xFrnzWWphGe8RXlwg
 AOm0NKipzIglR8g03S2xXfFkBXBCNLYm7L10UXTeoUIgnjcq4tSkvkipY/Iaop6ACh1c
 sWUiH8Y63XaiPeVZuGC+1eAE16h/Jo/IqkI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3a7ke7qe0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 22:01:37 -0700
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 4 Aug 2021 22:01:36 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id F34C2294203D; Wed,  4 Aug 2021 22:01:31 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf-next 2/4] bpf: selftests: Add sk_state to bpf_tcp_helpers.h
Date:   Wed, 4 Aug 2021 22:01:31 -0700
Message-ID: <20210805050131.1350420-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210805050119.1349009-1-kafai@fb.com>
References: <20210805050119.1349009-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: _DAVu2-OORchVCVz9SQxrJYqa1_V9FyD
X-Proofpoint-ORIG-GUID: _DAVu2-OORchVCVz9SQxrJYqa1_V9FyD
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-05_01:2021-08-04,2021-08-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 mlxlogscore=999 impostorscore=0 bulkscore=0 spamscore=0 suspectscore=0
 malwarescore=0 priorityscore=1501 adultscore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108050028
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add sk_state define to bpf_tcp_helpers.h.  Rename the existing
global variable "sk_state" in the kfunc_call test to "sk_state_res".

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/testing/selftests/bpf/bpf_tcp_helpers.h               | 1 +
 tools/testing/selftests/bpf/prog_tests/kfunc_call.c         | 2 +-
 tools/testing/selftests/bpf/progs/kfunc_call_test_subprog.c | 4 ++--
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/bpf_tcp_helpers.h b/tools/testin=
g/selftests/bpf/bpf_tcp_helpers.h
index 029589c008c9..e49b7c450b42 100644
--- a/tools/testing/selftests/bpf/bpf_tcp_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
@@ -27,6 +27,7 @@ enum sk_pacing {
=20
 struct sock {
 	struct sock_common	__sk_common;
+#define sk_state		__sk_common.skc_state
 	unsigned long		sk_pacing_rate;
 	__u32			sk_pacing_status; /* see enum sk_pacing */
 } __attribute__((preserve_access_index));
diff --git a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c b/tools/=
testing/selftests/bpf/prog_tests/kfunc_call.c
index 30a7b9b837bf..9611f2bc50df 100644
--- a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
+++ b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
@@ -44,7 +44,7 @@ static void test_subprog(void)
 	ASSERT_OK(err, "bpf_prog_test_run(test1)");
 	ASSERT_EQ(retval, 10, "test1-retval");
 	ASSERT_NEQ(skel->data->active_res, -1, "active_res");
-	ASSERT_EQ(skel->data->sk_state, BPF_TCP_CLOSE, "sk_state");
+	ASSERT_EQ(skel->data->sk_state_res, BPF_TCP_CLOSE, "sk_state_res");
=20
 	kfunc_call_test_subprog__destroy(skel);
 }
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test_subprog.c =
b/tools/testing/selftests/bpf/progs/kfunc_call_test_subprog.c
index b2dcb7d9cb03..5fbd9e232d44 100644
--- a/tools/testing/selftests/bpf/progs/kfunc_call_test_subprog.c
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_test_subprog.c
@@ -9,7 +9,7 @@ extern __u64 bpf_kfunc_call_test1(struct sock *sk, __u32 =
a, __u64 b,
 				  __u32 c, __u64 d) __ksym;
 extern struct sock *bpf_kfunc_call_test3(struct sock *sk) __ksym;
 int active_res =3D -1;
-int sk_state =3D -1;
+int sk_state_res =3D -1;
=20
 int __noinline f1(struct __sk_buff *skb)
 {
@@ -28,7 +28,7 @@ int __noinline f1(struct __sk_buff *skb)
 	if (active)
 		active_res =3D *active;
=20
-	sk_state =3D bpf_kfunc_call_test3((struct sock *)sk)->__sk_common.skc_s=
tate;
+	sk_state_res =3D bpf_kfunc_call_test3((struct sock *)sk)->sk_state;
=20
 	return (__u32)bpf_kfunc_call_test1((struct sock *)sk, 1, 2, 3, 4);
 }
--=20
2.30.2

