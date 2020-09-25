Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC3A2277CAE
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 02:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgIYAFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 20:05:01 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15002 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726932AbgIYAE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 20:04:59 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08P03lbY004888
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 17:04:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=9IPB1jI3rUMbeISg8yj5hfLRvqgvoU5ce81vHC34Wg8=;
 b=OSvzvpri90XYikchnmNQcRANI12B3Xw0Zkagdm2csFba3s5umtvxnxh8Da9yjpG41+p6
 0tNjWknWMorLA596lyTGOG4ZKkUDnjcEtgWC+4L70FAUKdnJtQVKdgTBnp0emYsP50EO
 Di2jvzA6M+5u0cMfLSdaomei17iLMbfUEVg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp44wc8-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 17:04:58 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 24 Sep 2020 17:04:56 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id B86452946606; Thu, 24 Sep 2020 17:04:52 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>, <netdev@vger.kernel.org>
Subject: [PATCH v4 bpf-next 12/13] bpf: selftest: Remove enum tcp_ca_state from bpf_tcp_helpers.h
Date:   Thu, 24 Sep 2020 17:04:52 -0700
Message-ID: <20200925000452.3859313-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200925000337.3853598-1-kafai@fb.com>
References: <20200925000337.3853598-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-24_18:2020-09-24,2020-09-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 mlxlogscore=668
 clxscore=1015 phishscore=0 suspectscore=13 spamscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009240174
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The enum tcp_ca_state is available in <linux/tcp.h>.
Remove it from the bpf_tcp_helpers.h to avoid conflict when the bpf prog
needs to include both both <linux/tcp.h> and bpf_tcp_helpers.h.

Modify the bpf_cubic.c and bpf_dctcp.c to use <linux/tcp.h> instead.
The <linux/stddef.h> is needed by <linux/tcp.h>.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/testing/selftests/bpf/bpf_tcp_helpers.h | 8 --------
 tools/testing/selftests/bpf/progs/bpf_cubic.c | 2 ++
 tools/testing/selftests/bpf/progs/bpf_dctcp.c | 2 ++
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/bpf/bpf_tcp_helpers.h b/tools/testin=
g/selftests/bpf/bpf_tcp_helpers.h
index 5bf2fe9b1efa..a0e8b3758bd7 100644
--- a/tools/testing/selftests/bpf/bpf_tcp_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
@@ -115,14 +115,6 @@ enum tcp_ca_event {
 	CA_EVENT_ECN_IS_CE =3D 5,
 };
=20
-enum tcp_ca_state {
-	TCP_CA_Open =3D 0,
-	TCP_CA_Disorder =3D 1,
-	TCP_CA_CWR =3D 2,
-	TCP_CA_Recovery =3D 3,
-	TCP_CA_Loss =3D 4
-};
-
 struct ack_sample {
 	__u32 pkts_acked;
 	__s32 rtt_us;
diff --git a/tools/testing/selftests/bpf/progs/bpf_cubic.c b/tools/testin=
g/selftests/bpf/progs/bpf_cubic.c
index ef574087f1e1..6939bfd8690f 100644
--- a/tools/testing/selftests/bpf/progs/bpf_cubic.c
+++ b/tools/testing/selftests/bpf/progs/bpf_cubic.c
@@ -15,6 +15,8 @@
  */
=20
 #include <linux/bpf.h>
+#include <linux/stddef.h>
+#include <linux/tcp.h>
 #include "bpf_tcp_helpers.h"
=20
 char _license[] SEC("license") =3D "GPL";
diff --git a/tools/testing/selftests/bpf/progs/bpf_dctcp.c b/tools/testin=
g/selftests/bpf/progs/bpf_dctcp.c
index 3fb4260570b1..4dc1a967776a 100644
--- a/tools/testing/selftests/bpf/progs/bpf_dctcp.c
+++ b/tools/testing/selftests/bpf/progs/bpf_dctcp.c
@@ -9,6 +9,8 @@
 #include <stddef.h>
 #include <linux/bpf.h>
 #include <linux/types.h>
+#include <linux/stddef.h>
+#include <linux/tcp.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
 #include "bpf_tcp_helpers.h"
--=20
2.24.1

