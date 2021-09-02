Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5ABE3FF244
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 19:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346610AbhIBRYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 13:24:09 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50362 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346622AbhIBRYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 13:24:06 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 182HLiXr010103
        for <netdev@vger.kernel.org>; Thu, 2 Sep 2021 10:23:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=+0OKELJbaUjJ8mLdcHMhrhFNTG4KwMxKY8J3mE+V+D8=;
 b=LKcFocF6lJKaam0fRXC/KqUU6t+zGn6XW7ZSwcl1AljMtnObrezOfZPmfrByqcPEDACb
 cmNGMNxebx93yg18cvJS6Yxzik9l5xxvnbTtDBmLP9Tb9dMq8/+poH44IpaBJIJ3nT6F
 r4Z7zgUnykI7Mrs8GM33vwzT8JZP6Ae2hj8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3atdwu5de1-16
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 10:23:07 -0700
Received: from intmgw001.38.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 2 Sep 2021 10:22:58 -0700
Received: by devbig030.frc3.facebook.com (Postfix, from userid 158236)
        id 356C05FE24B4; Thu,  2 Sep 2021 10:20:07 -0700 (PDT)
From:   Dave Marchevsky <davemarchevsky@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, <netdev@vger.kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>
Subject: [PATCH v4 bpf-next 9/9] selftests/bpf: Add test for bpf_printk w/ 0 fmt args
Date:   Thu, 2 Sep 2021 10:19:29 -0700
Message-ID: <20210902171929.3922667-10-davemarchevsky@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210902171929.3922667-1-davemarchevsky@fb.com>
References: <20210902171929.3922667-1-davemarchevsky@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: Y9yqnfpGz6x-F9bFfiAre4BMTa7y1r4N
X-Proofpoint-ORIG-GUID: Y9yqnfpGz6x-F9bFfiAre4BMTa7y1r4N
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-02_04:2021-09-02,2021-09-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 mlxlogscore=911 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 adultscore=0 clxscore=1015 suspectscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109020100
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This corner case isn't covered by existing selftests' use of bpf_printk.

Just test compilation, not output, as trace_vprintk already tests
trace_pipe output.

Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
---
 tools/testing/selftests/bpf/progs/trace_vprintk.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/trace_vprintk.c b/tools/te=
sting/selftests/bpf/progs/trace_vprintk.c
index 255e2f018efe..33455e48a9ab 100644
--- a/tools/testing/selftests/bpf/progs/trace_vprintk.c
+++ b/tools/testing/selftests/bpf/progs/trace_vprintk.c
@@ -23,3 +23,10 @@ int sys_enter(void *ctx)
 		one, 2, three, 4, five, 6, seven, 8, nine, 10, ++trace_vprintk_ran);
 	return 0;
 }
+
+SEC("fentry/__x64_sys_nanosleep")
+int zero_fmt_args(void *ctx)
+{
+	bpf_printk("\t"); // runner doesn't search for this, just ensure it com=
piles
+	return 0;
+}
--=20
2.30.2

