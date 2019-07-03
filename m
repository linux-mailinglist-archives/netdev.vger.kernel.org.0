Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53BCA5E57B
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 15:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbfGCN2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 09:28:16 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54646 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726760AbfGCN2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 09:28:16 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x63DRaKk144757
        for <netdev@vger.kernel.org>; Wed, 3 Jul 2019 09:28:14 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tgvsq1g96-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 09:28:14 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Wed, 3 Jul 2019 14:28:11 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 3 Jul 2019 14:28:09 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x63DRvr638994190
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Jul 2019 13:27:57 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0BE6B4C040;
        Wed,  3 Jul 2019 13:28:08 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CEE014C044;
        Wed,  3 Jul 2019 13:28:07 +0000 (GMT)
Received: from white.boeblingen.de.ibm.com (unknown [9.152.98.248])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  3 Jul 2019 13:28:07 +0000 (GMT)
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, ys114321@gmail.com,
        daniel@iogearbox.net
Cc:     Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v2 bpf-next 4/4] selftests/bpf: fix compiling loop{1,2,3}.c on s390
Date:   Wed,  3 Jul 2019 15:27:11 +0200
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190703132711.57169-1-iii@linux.ibm.com>
References: <20190703132711.57169-1-iii@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19070313-0020-0000-0000-0000034FD1E7
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19070313-0021-0000-0000-000021A369E3
Message-Id: <20190703132711.57169-5-iii@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-03_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=626 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907030164
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use PT_REGS_RC(ctx) instead of ctx->rax, which is not present on s390.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
---
 tools/testing/selftests/bpf/progs/loop1.c | 2 +-
 tools/testing/selftests/bpf/progs/loop2.c | 2 +-
 tools/testing/selftests/bpf/progs/loop3.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/loop1.c b/tools/testing/selftests/bpf/progs/loop1.c
index dea395af9ea9..7cdb7f878310 100644
--- a/tools/testing/selftests/bpf/progs/loop1.c
+++ b/tools/testing/selftests/bpf/progs/loop1.c
@@ -18,7 +18,7 @@ int nested_loops(volatile struct pt_regs* ctx)
 	for (j = 0; j < 300; j++)
 		for (i = 0; i < j; i++) {
 			if (j & 1)
-				m = ctx->rax;
+				m = PT_REGS_RC(ctx);
 			else
 				m = j;
 			sum += i * m;
diff --git a/tools/testing/selftests/bpf/progs/loop2.c b/tools/testing/selftests/bpf/progs/loop2.c
index 0637bd8e8bcf..9b2f808a2863 100644
--- a/tools/testing/selftests/bpf/progs/loop2.c
+++ b/tools/testing/selftests/bpf/progs/loop2.c
@@ -16,7 +16,7 @@ int while_true(volatile struct pt_regs* ctx)
 	int i = 0;
 
 	while (true) {
-		if (ctx->rax & 1)
+		if (PT_REGS_RC(ctx) & 1)
 			i += 3;
 		else
 			i += 7;
diff --git a/tools/testing/selftests/bpf/progs/loop3.c b/tools/testing/selftests/bpf/progs/loop3.c
index 30a0f6cba080..d727657d51e2 100644
--- a/tools/testing/selftests/bpf/progs/loop3.c
+++ b/tools/testing/selftests/bpf/progs/loop3.c
@@ -16,7 +16,7 @@ int while_true(volatile struct pt_regs* ctx)
 	__u64 i = 0, sum = 0;
 	do {
 		i++;
-		sum += ctx->rax;
+		sum += PT_REGS_RC(ctx);
 	} while (i < 0x100000000ULL);
 	return sum;
 }
-- 
2.21.0

