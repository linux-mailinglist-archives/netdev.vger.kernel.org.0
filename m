Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE7241C35A
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 13:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245711AbhI2LWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 07:22:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17600 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231261AbhI2LWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 07:22:05 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T9BfTU004513;
        Wed, 29 Sep 2021 07:19:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+g8wp0I/DHpzgUrFDoHUxVuRI/eutiJXiCB45G6x38I=;
 b=r1aB7vwOZYybRexjIDEUwEv/8TAYbYNwtIxrKA8b3JpEX8Not6xFrdCvgGk6ewXL1SxD
 6Nn3m5OLSYRFJUQ8vES3reoNrC90jYbsb0hFvMdiITZOk9oYt4JKO0lINN6SydnJ/Yp1
 S1JudFd+CaNLTe0UCY16eRHVztnBSUIvfkbtZTtj9fAjb/IaCCe6t5sfiKp0r1IYZN8Z
 fpY47Ja0Sjm+UNdolUC4r2264kbTVefmNq3EPy10tsWF1ooCbSrbMTsONMAlkm3VcJWA
 66bO8Y9WpfAOyJy7Wt+44Jy1HVZ3GXne/KoAkZAWb2uWDjz6nSLUmzzSZQzyb57Rw4DH lQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bcn9y2n6x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Sep 2021 07:19:54 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18TAR9Bc018533;
        Wed, 29 Sep 2021 07:19:54 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bcn9y2n69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Sep 2021 07:19:54 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18TBDLcu021974;
        Wed, 29 Sep 2021 11:19:51 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 3b9u1k58e7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Sep 2021 11:19:51 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18TBJlrH46006534
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 11:19:47 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6617842059;
        Wed, 29 Sep 2021 11:19:47 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BAD8242074;
        Wed, 29 Sep 2021 11:19:42 +0000 (GMT)
Received: from hbathini-workstation.ibm.com.com (unknown [9.43.83.199])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 29 Sep 2021 11:19:42 +0000 (GMT)
From:   Hari Bathini <hbathini@linux.ibm.com>
To:     naveen.n.rao@linux.ibm.com, christophe.leroy@csgroup.eu,
        mpe@ellerman.id.au, ast@kernel.org, daniel@iogearbox.net
Cc:     paulus@samba.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Hari Bathini <hbathini@linux.ibm.com>
Subject: [PATCH v4 8/8] bpf ppc32: Access only if addr is kernel address
Date:   Wed, 29 Sep 2021 16:48:55 +0530
Message-Id: <20210929111855.50254-9-hbathini@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210929111855.50254-1-hbathini@linux.ibm.com>
References: <20210929111855.50254-1-hbathini@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0r5rBPmu5aLXQxKkUK8bV1NpmjCe6INr
X-Proofpoint-ORIG-GUID: pGdPj2uMhdqx_HZhWITf2bGg7EIsb0PY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-29_04,2021-09-29_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 adultscore=0 bulkscore=0 clxscore=1015
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2109290068
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With KUAP enabled, any kernel code which wants to access userspace
needs to be surrounded by disable-enable KUAP. But that is not
happening for BPF_PROBE_MEM load instruction. Though PPC32 does not
support read protection, considering the fact that PTR_TO_BTF_ID
(which uses BPF_PROBE_MEM mode) could either be a valid kernel pointer
or NULL but should never be a pointer to userspace address, execute
BPF_PROBE_MEM load only if addr is kernel address, otherwise set
dst_reg=0 and move on.

This will catch NULL, valid or invalid userspace pointers. Only bad
kernel pointer will be handled by BPF exception table.

[Alexei suggested for x86]
Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
---

Changes in v4:
* Adjusted the emit code to avoid using temporary reg.


 arch/powerpc/net/bpf_jit_comp32.c | 34 +++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/arch/powerpc/net/bpf_jit_comp32.c b/arch/powerpc/net/bpf_jit_comp32.c
index 6ee13a09c70d..2ac81563c78d 100644
--- a/arch/powerpc/net/bpf_jit_comp32.c
+++ b/arch/powerpc/net/bpf_jit_comp32.c
@@ -818,6 +818,40 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 		case BPF_LDX | BPF_PROBE_MEM | BPF_W:
 		case BPF_LDX | BPF_MEM | BPF_DW: /* dst = *(u64 *)(ul) (src + off) */
 		case BPF_LDX | BPF_PROBE_MEM | BPF_DW:
+			/*
+			 * As PTR_TO_BTF_ID that uses BPF_PROBE_MEM mode could either be a valid
+			 * kernel pointer or NULL but not a userspace address, execute BPF_PROBE_MEM
+			 * load only if addr is kernel address (see is_kernel_addr()), otherwise
+			 * set dst_reg=0 and move on.
+			 */
+			if (BPF_MODE(code) == BPF_PROBE_MEM) {
+				PPC_LI32(_R0, TASK_SIZE - off);
+				EMIT(PPC_RAW_CMPLW(src_reg, _R0));
+				PPC_BCC(COND_GT, (ctx->idx + 5) * 4);
+				EMIT(PPC_RAW_LI(dst_reg, 0));
+				/*
+				 * For BPF_DW case, "li reg_h,0" would be needed when
+				 * !fp->aux->verifier_zext. Emit NOP otherwise.
+				 *
+				 * Note that "li reg_h,0" is emitted for BPF_B/H/W case,
+				 * if necessary. So, jump there insted of emitting an
+				 * additional "li reg_h,0" instruction.
+				 */
+				if (size == BPF_DW && !fp->aux->verifier_zext)
+					EMIT(PPC_RAW_LI(dst_reg_h, 0));
+				else
+					EMIT(PPC_RAW_NOP());
+				/*
+				 * Need to jump two instructions instead of one for BPF_DW case
+				 * as there are two load instructions for dst_reg_h & dst_reg
+				 * respectively.
+				 */
+				if (size == BPF_DW)
+					PPC_JMP((ctx->idx + 3) * 4);
+				else
+					PPC_JMP((ctx->idx + 2) * 4);
+			}
+
 			switch (size) {
 			case BPF_B:
 				EMIT(PPC_RAW_LBZ(dst_reg, src_reg, off));
-- 
2.31.1

