Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37B0E413457
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 15:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233111AbhIUNhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 09:37:39 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23616 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233011AbhIUNhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 09:37:38 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18LCGU9j016385;
        Tue, 21 Sep 2021 09:35:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=tmAe9vLqhDbevzn0ku3hw+EsIDViVBdUogEZZMpWIaU=;
 b=qzn7hvFWvwRH5YUG6fcR7OWsl7hdxZB8MYzR4J5bnp9iNByHEkrzEAcxDMQzxGUycsCh
 aASN0mnG/buK9EoSbZ/X+PbMPz0oLd7Mv9H/zpBEDAMqYm97OULU68/WlrdReCPQedwV
 5ph25vcq6+MPEwVICSYt84Ozo1alSLdi2gDlINBvIBpy3H0sdkeEqjxEgYyTiFYff/Uo
 6kfWnC1IWrxVdhdyF+US56JeYgn/XUZhPyFhzU4wNfADbdM1axh7eE2FxE0Z2hhSO95r
 trbLKitgeiIgSQnYFpNYoi0yOJPJtULRu62CCm5Sxya1uRNchliAhrcTguNIPf/shMbq jA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7f15jgrh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 09:35:41 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18LCtCCl032435;
        Tue, 21 Sep 2021 09:35:40 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7f15jgpy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 09:35:40 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18LDNF8Q008085;
        Tue, 21 Sep 2021 13:30:37 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3b57r9njnx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 13:30:37 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18LDUXEF47710654
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Sep 2021 13:30:33 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35AA84C05E;
        Tue, 21 Sep 2021 13:30:33 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18F314C046;
        Tue, 21 Sep 2021 13:30:29 +0000 (GMT)
Received: from hbathini-workstation.ibm.com.com (unknown [9.43.117.91])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 21 Sep 2021 13:30:28 +0000 (GMT)
From:   Hari Bathini <hbathini@linux.ibm.com>
To:     naveen.n.rao@linux.ibm.com, christophe.leroy@csgroup.eu,
        mpe@ellerman.id.au, ast@kernel.org, daniel@iogearbox.net
Cc:     paulus@samba.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Hari Bathini <hbathini@linux.ibm.com>
Subject: [PATCH v3 8/8] bpf ppc32: Access only if addr is kernel address
Date:   Tue, 21 Sep 2021 18:59:43 +0530
Message-Id: <20210921132943.489732-9-hbathini@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210921132943.489732-1-hbathini@linux.ibm.com>
References: <20210921132943.489732-1-hbathini@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: eRC9qyM7YPkJN-zPFN7we_L_WNyx5pKU
X-Proofpoint-GUID: WwzNd9atNVBqQYu5SbxFFQo32EHCV-XU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-21_01,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 mlxscore=0 phishscore=0 impostorscore=0 spamscore=0 priorityscore=1501
 suspectscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109210083
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

Changes in v3:
* Updated jump for PPC_BCC to always be the same while emitting
  a NOP instruction when needed.


 arch/powerpc/net/bpf_jit_comp32.c | 35 +++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/arch/powerpc/net/bpf_jit_comp32.c b/arch/powerpc/net/bpf_jit_comp32.c
index 1239643f532c..59849e1230d2 100644
--- a/arch/powerpc/net/bpf_jit_comp32.c
+++ b/arch/powerpc/net/bpf_jit_comp32.c
@@ -825,6 +825,41 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 		case BPF_LDX | BPF_MEM | BPF_DW: /* dst = *(u64 *)(ul) (src + off) */
 			fallthrough;
 		case BPF_LDX | BPF_PROBE_MEM | BPF_DW:
+			/*
+			 * As PTR_TO_BTF_ID that uses BPF_PROBE_MEM mode could either be a valid
+			 * kernel pointer or NULL but not a userspace address, execute BPF_PROBE_MEM
+			 * load only if addr is kernel address (see is_kernel_addr()), otherwise
+			 * set dst_reg=0 and move on.
+			 */
+			if (BPF_MODE(code) == BPF_PROBE_MEM) {
+				EMIT(PPC_RAW_ADDI(b2p[TMP_REG], src_reg, off));
+				PPC_LI32(_R0, TASK_SIZE);
+				EMIT(PPC_RAW_CMPLW(b2p[TMP_REG], _R0));
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

