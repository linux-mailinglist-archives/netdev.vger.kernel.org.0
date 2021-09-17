Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B183440FC77
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 17:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241710AbhIQPen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 11:34:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31446 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241715AbhIQPeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 11:34:14 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18HFQQFF004754;
        Fri, 17 Sep 2021 11:32:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=rAN3SrFaAi5GYGKhhg0M2VJcDLkU71pG+GBcsc6Hui4=;
 b=DKHQKyxdAK5scS5xXdeTMwKa3APFtN09PN2Yr7ZsiKcG310h5r1jFyFf+S6ZpAYw46h1
 QnrMDubq97qdnuGW328kYldSRE1pXqTTLpx02ItxnufYAUqKvyqMpt+hucvc2WHnBwiW
 XyW+29DxgQ1bt4jM5OboS00okylZ7fNMKftdn54kHkD+f2MjOZXTPwd0IDgkqkflqvMh
 plVigUDf2cnKEAvOhLeCcmJmzXGEYb0c5y40P51O+JF14AEXW8CWHJSbil041nXYJRZO
 KG6nhDLO7sYh9lKtffqb/ffHL6KF0WTnBWCogvggT+qqYjW2wF3fh8Bo0nxWMSTdz90e uQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b4r0creuq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 11:32:17 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18HFU59U020591;
        Fri, 17 Sep 2021 11:32:17 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b4r0creu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 11:32:17 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18HFH210013851;
        Fri, 17 Sep 2021 15:32:15 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3b0m3ag7ju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 15:32:15 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18HFRXK456623424
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Sep 2021 15:27:33 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA9D811C06F;
        Fri, 17 Sep 2021 15:32:11 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46C2111C073;
        Fri, 17 Sep 2021 15:32:06 +0000 (GMT)
Received: from hbathini-workstation.ibm.com (unknown [9.43.59.213])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 17 Sep 2021 15:32:06 +0000 (GMT)
From:   Hari Bathini <hbathini@linux.ibm.com>
To:     naveen.n.rao@linux.ibm.com, mpe@ellerman.id.au, ast@kernel.org,
        daniel@iogearbox.net
Cc:     christophe.leroy@csgroup.eu, paulus@samba.org, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Hari Bathini <hbathini@linux.ibm.com>
Subject: [PATCH v2 6/8] bpf ppc64: Add addr > TASK_SIZE_MAX explicit check
Date:   Fri, 17 Sep 2021 21:00:45 +0530
Message-Id: <20210917153047.177141-7-hbathini@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210917153047.177141-1-hbathini@linux.ibm.com>
References: <20210917153047.177141-1-hbathini@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0OKm82m2Ph6ZTzxupYDbVD0TrPLSXDb2
X-Proofpoint-GUID: MjrNwgkWnA_hjUYk8c0W-83_HaJwsIhA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-17_06,2021-09-17_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 malwarescore=0 adultscore=0 suspectscore=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999 mlxscore=0
 bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109030001 definitions=main-2109170096
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ravi Bangoria <ravi.bangoria@linux.ibm.com>

On PPC64 with KUAP enabled, any kernel code which wants to
access userspace needs to be surrounded by disable-enable KUAP.
But that is not happening for BPF_PROBE_MEM load instruction.
So, when BPF program tries to access invalid userspace address,
page-fault handler considers it as bad KUAP fault:

  Kernel attempted to read user page (d0000000) - exploit attempt? (uid: 0)

Considering the fact that PTR_TO_BTF_ID (which uses BPF_PROBE_MEM
mode) could either be a valid kernel pointer or NULL but should
never be a pointer to userspace address, execute BPF_PROBE_MEM load
only if addr > TASK_SIZE_MAX, otherwise set dst_reg=0 and move on.

This will catch NULL, valid or invalid userspace pointers. Only bad
kernel pointer will be handled by BPF exception table.

[Alexei suggested for x86]
Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
---

Changes in v2:
* Refactored the code based on Christophe's comments.


 arch/powerpc/net/bpf_jit_comp64.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index 2fc10995f243..eb28dbc67151 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -769,6 +769,29 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 		/* dst = *(u64 *)(ul) (src + off) */
 		case BPF_LDX | BPF_MEM | BPF_DW:
 		case BPF_LDX | BPF_PROBE_MEM | BPF_DW:
+			/*
+			 * As PTR_TO_BTF_ID that uses BPF_PROBE_MEM mode could either be a valid
+			 * kernel pointer or NULL but not a userspace address, execute BPF_PROBE_MEM
+			 * load only if addr > TASK_SIZE_MAX, otherwise set dst_reg=0 and move on.
+			 */
+			if (BPF_MODE(code) == BPF_PROBE_MEM) {
+				unsigned int adjusted_idx;
+
+				/*
+				 * Check if 'off' is word aligned because PPC_BPF_LL()
+				 * (BPF_DW case) generates two instructions if 'off' is not
+				 * word-aligned and one instruction otherwise.
+				 */
+				adjusted_idx = ((BPF_SIZE(code) == BPF_DW) && (off & 3)) ? 1 : 0;
+
+				EMIT(PPC_RAW_ADDI(b2p[TMP_REG_1], src_reg, off));
+				PPC_LI64(b2p[TMP_REG_2], TASK_SIZE_MAX);
+				EMIT(PPC_RAW_CMPLD(b2p[TMP_REG_1], b2p[TMP_REG_2]));
+				PPC_BCC(COND_GT, (ctx->idx + 4) * 4);
+				EMIT(PPC_RAW_LI(dst_reg, 0));
+				PPC_JMP((ctx->idx + 2 + adjusted_idx) * 4);
+			}
+
 			switch (size) {
 			case BPF_B:
 				EMIT(PPC_RAW_LBZ(dst_reg, src_reg, off));
-- 
2.31.1

