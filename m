Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 904871BD1A9
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 03:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgD2BVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 21:21:43 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51722 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726493AbgD2BVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 21:21:41 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03T1Kt2l000433
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 18:21:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ZYT3YfR3IYQKxOqOTLsGDFeuDmT3A6jGoIfpPtPkm1Y=;
 b=DICEfs9k8a4g4xRyeQhgzzJ8IEhwTWF11PDflRdiPyLUYWe7ok4MWVgZYdrRa0GHkoMT
 5OYfzob2tuGo6Z4iA2P0J7mqjbmhmiZ484OWmmJ9q8Kou7M01ckQQncsuCCdrMHTKGfJ
 HMlky36YjbYR1vj3RN5ev58cRpYX9sh8cFE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30nq53x80v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 18:21:39 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 18:21:39 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id E37B92EC30E4; Tue, 28 Apr 2020 18:21:34 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Carlos Neira <cneirabustos@gmail.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 10/11] selftests/bpf: fix bpf_link leak in ns_current_pid_tgid selftest
Date:   Tue, 28 Apr 2020 18:21:10 -0700
Message-ID: <20200429012111.277390-11-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200429012111.277390-1-andriin@fb.com>
References: <20200429012111.277390-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_15:2020-04-28,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=640
 spamscore=0 lowpriorityscore=0 suspectscore=8 impostorscore=0
 priorityscore=1501 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290008
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If condition is inverted, but it's also just not necessary.

Cc: Carlos Neira <cneirabustos@gmail.com>
Fixes: 1c1052e0140a ("tools/testing/selftests/bpf: Add self-tests for new=
 helper bpf_get_ns_current_pid_tgid.")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c=
 b/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
index 542240e16564..e74dc501b27f 100644
--- a/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
+++ b/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
@@ -80,9 +80,6 @@ void test_ns_current_pid_tgid(void)
 		  "User pid/tgid %llu BPF pid/tgid %llu\n", id, bss.pid_tgid))
 		goto cleanup;
 cleanup:
-	if (!link) {
-		bpf_link__destroy(link);
-		link =3D NULL;
-	}
+	bpf_link__destroy(link);
 	bpf_object__close(obj);
 }
--=20
2.24.1

