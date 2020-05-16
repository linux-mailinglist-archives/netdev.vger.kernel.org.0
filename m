Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53FFF1D5D4D
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 02:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgEPAkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 20:40:33 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:21510 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727827AbgEPAkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 20:40:33 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04G0ZfkW008197
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 17:40:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Hu1o518tlrzL4b6CWHvMR+lyXT6LLyRKwo5aV/6waMg=;
 b=LSkYH5RpdBogzx8F+kN5H7+1XMyvP641ogurD3RpSnCZjqb83dFmHHRFYuzFJyhKSvp3
 lBicFUEMPM6UNEEXVadwF2gfFa3nhGjXZEtr78WeQvTw63GYlWDDDxXYVI4JuO1bdRil
 h2X2DlZmhpnGR/ZV55fJT34FJyh5DUjrFq0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 311v2b3ckg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 17:40:32 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 15 May 2020 17:40:31 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 3B7BB2EC39B6; Fri, 15 May 2020 17:40:22 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <stable@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH 5.4 2/2] selftest/bpf: fix backported test_select_reuseport selftest changes
Date:   Fri, 15 May 2020 17:40:17 -0700
Message-ID: <20200516004018.3500869-2-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200516004018.3500869-1-andriin@fb.com>
References: <20200516004018.3500869-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-15_07:2020-05-15,2020-05-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 cotscore=-2147483648 malwarescore=0 phishscore=0
 spamscore=0 lowpriorityscore=0 suspectscore=8 adultscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=795 clxscore=1015 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005160003
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix up RET_IF as CHECK macro to make selftests compile again.

Fixes: b911c5e8686a ("selftests: bpf: Reset global state between reusepor=
t test runs")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/test_select_reuseport.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_select_reuseport.c b/tools/=
testing/selftests/bpf/test_select_reuseport.c
index 079d0f5a2909..7e4c91f2238d 100644
--- a/tools/testing/selftests/bpf/test_select_reuseport.c
+++ b/tools/testing/selftests/bpf/test_select_reuseport.c
@@ -668,12 +668,12 @@ static void cleanup_per_test(void)
=20
 	for (i =3D 0; i < NR_RESULTS; i++) {
 		err =3D bpf_map_update_elem(result_map, &i, &zero, BPF_ANY);
-		RET_IF(err, "reset elem in result_map",
+		CHECK(err, "reset elem in result_map",
 		       "i:%u err:%d errno:%d\n", i, err, errno);
 	}
=20
 	err =3D bpf_map_update_elem(linum_map, &zero, &zero, BPF_ANY);
-	RET_IF(err, "reset line number in linum_map", "err:%d errno:%d\n",
+	CHECK(err, "reset line number in linum_map", "err:%d errno:%d\n",
 	       err, errno);
=20
 	for (i =3D 0; i < REUSEPORT_ARRAY_SIZE; i++)
--=20
2.24.1

