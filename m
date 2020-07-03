Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4480D213F3A
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 20:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgGCSRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 14:17:52 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18782 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726148AbgGCSRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 14:17:52 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 063IDwRL028366
        for <netdev@vger.kernel.org>; Fri, 3 Jul 2020 11:17:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=DwgyjHMuPMCqXecwVQY/ULeBVK+4v1KJQU4thCW+skw=;
 b=J4+wSdt8DAWA2ueBrsHqGPHlEuwyuUc6b5yrWHf2Rhgd7+fS58cxI9sUD5S7ZU/lYWgn
 XgjP7Kwe1IkzdmmiG+l3u/Fek7BD1JQD64jgT0RoigDNC2LQGp8iB4K3wpO/uoNL0uFZ
 y2DNcfWZHe73NLSK0jDpZX+aXkYqq5ZSjOo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 321gw9e8x5-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 11:17:51 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 3 Jul 2020 11:17:45 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id C500A62E4DDC; Fri,  3 Jul 2020 11:17:43 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        <brouer@redhat.com>, Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] selftests/bpf: fix compilation error of bpf_iter_task_stack.c
Date:   Fri, 3 Jul 2020 11:17:19 -0700
Message-ID: <20200703181719.3747072-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-03_14:2020-07-02,2020-07-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 cotscore=-2147483648
 adultscore=0 phishscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 suspectscore=8 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2007030123
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

selftests/bpf shows compilation error as

  libbpf: invalid relo for 'entries' in special section 0xfff2; forgot to
  initialize global var?..

Fix it by initializing 'entries' to zeros.

Fixes: c7568114bc56 ("selftests/bpf: Add bpf_iter test with bpf_get_task_=
stack()")
Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c b/to=
ols/testing/selftests/bpf/progs/bpf_iter_task_stack.c
index e40d32a2ed93d..65899cc71d535 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c
@@ -7,7 +7,7 @@
 char _license[] SEC("license") =3D "GPL";
=20
 #define MAX_STACK_TRACE_DEPTH   64
-unsigned long entries[MAX_STACK_TRACE_DEPTH];
+unsigned long entries[MAX_STACK_TRACE_DEPTH] =3D {0};
 #define SIZE_OF_ULONG (sizeof(unsigned long))
=20
 SEC("iter/task")
--=20
2.24.1

