Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F04A1524751
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 09:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351171AbiELHr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 03:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351167AbiELHrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 03:47:22 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F411B214C;
        Thu, 12 May 2022 00:47:03 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24C6BqbD020435;
        Thu, 12 May 2022 07:46:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=zW69QzzKdn6pdlFyINgDJeQ9IV/TqDbLws5a/2XMiXE=;
 b=ZhY5eK31LX3VyXlJFEdNTR9JQo3IcDVlFYuyCvwCgKgMJAoQ6GECYjVbmNv1HzReOE4l
 djNgr7mCS5yxsHviuvq1CpeEDZ0mzSFQUXQ0ZoxrFjNR0ge3bll10Ic2UOIAcLRM6RxW
 j/qtQWj0HqdC3Thfs4QQKil2OeAPSCnl/P+H06N55sYfT/+BxtNxjoni344K2p3rOkCE
 yqhIC1RJS+Ag8KzIPWfaPa5DsfqMLspMrnFDhhtISDlwOx0580hqQg/dy05qD539vyUR
 JSYusyfCvaoYPowRTv76cTqCRdrE7BhbMVnhCk6CNqgpGS/Gon/Riw0eZHJN/Grzy+aS Og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0vrnhpgn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 07:46:29 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24C7fQAK003894;
        Thu, 12 May 2022 07:46:28 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0vrnhpg2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 07:46:28 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24C7cDU3028748;
        Thu, 12 May 2022 07:46:26 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3fwgd8w5qu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 07:46:26 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24C7kNE344368192
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 07:46:23 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1132A4051;
        Thu, 12 May 2022 07:46:23 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC729A404D;
        Thu, 12 May 2022 07:46:15 +0000 (GMT)
Received: from hbathini-workstation.ibm.com.com (unknown [9.211.109.30])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 May 2022 07:46:15 +0000 (GMT)
From:   Hari Bathini <hbathini@linux.ibm.com>
To:     bpf@vger.kernel.org, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        netdev@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jordan Niethe <jniethe5@gmail.com>
Subject: [PATCH 3/5] bpf ppc64: Add instructions for atomic_[cmp]xchg
Date:   Thu, 12 May 2022 13:15:44 +0530
Message-Id: <20220512074546.231616-4-hbathini@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220512074546.231616-1-hbathini@linux.ibm.com>
References: <20220512074546.231616-1-hbathini@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dq8kMBU5arO40FMNmGDzMnS6KZZX_aAy
X-Proofpoint-ORIG-GUID: xxorlEwL9ikIAJ6ni7lLw8Rh_YesTnoT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-11_07,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 impostorscore=0 clxscore=1015 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205120034
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds two atomic opcodes BPF_XCHG and BPF_CMPXCHG on ppc64, both
of which include the BPF_FETCH flag.  The kernel's atomic_cmpxchg
operation fundamentally has 3 operands, but we only have two register
fields. Therefore the operand we compare against (the kernel's API
calls it 'old') is hard-coded to be BPF_REG_R0. Also, kernel's
atomic_cmpxchg returns the previous value at dst_reg + off. JIT the
same for BPF too with return value put in BPF_REG_0.

  BPF_REG_R0 = atomic_cmpxchg(dst_reg + off, BPF_REG_R0, src_reg);

Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
---
 arch/powerpc/net/bpf_jit_comp64.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index 504fa459f9f3..df9e20b22ccb 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -783,6 +783,9 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 		 */
 		case BPF_STX | BPF_ATOMIC | BPF_W:
 		case BPF_STX | BPF_ATOMIC | BPF_DW:
+			u32 save_reg = tmp2_reg;
+			u32 ret_reg = src_reg;
+
 			/* Get offset into TMP_REG_1 */
 			EMIT(PPC_RAW_LI(tmp1_reg, off));
 			tmp_idx = ctx->idx * 4;
@@ -813,6 +816,24 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 			case BPF_XOR | BPF_FETCH:
 				EMIT(PPC_RAW_XOR(tmp2_reg, tmp2_reg, src_reg));
 				break;
+			case BPF_CMPXCHG:
+				/*
+				 * Return old value in BPF_REG_0 for BPF_CMPXCHG &
+				 * in src_reg for other cases.
+				 */
+				ret_reg = bpf_to_ppc(BPF_REG_0);
+
+				/* Compare with old value in BPF_R0 */
+				if (size == BPF_DW)
+					EMIT(PPC_RAW_CMPD(bpf_to_ppc(BPF_REG_0), tmp2_reg));
+				else
+					EMIT(PPC_RAW_CMPW(bpf_to_ppc(BPF_REG_0), tmp2_reg));
+				/* Don't set if different from old value */
+				PPC_BCC_SHORT(COND_NE, (ctx->idx + 3) * 4);
+				fallthrough;
+			case BPF_XCHG:
+				save_reg = src_reg;
+				break;
 			default:
 				pr_err_ratelimited(
 					"eBPF filter atomic op code %02x (@%d) unsupported\n",
@@ -822,15 +843,14 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 
 			/* store new value */
 			if (size == BPF_DW)
-				EMIT(PPC_RAW_STDCX(tmp2_reg, tmp1_reg, dst_reg));
+				EMIT(PPC_RAW_STDCX(save_reg, tmp1_reg, dst_reg));
 			else
-				EMIT(PPC_RAW_STWCX(tmp2_reg, tmp1_reg, dst_reg));
+				EMIT(PPC_RAW_STWCX(save_reg, tmp1_reg, dst_reg));
 			/* we're done if this succeeded */
 			PPC_BCC_SHORT(COND_NE, tmp_idx);
 
-			/* For the BPF_FETCH variant, get old value into src_reg */
 			if (imm & BPF_FETCH)
-				EMIT(PPC_RAW_MR(src_reg, _R0));
+				EMIT(PPC_RAW_MR(ret_reg, _R0));
 			break;
 
 		/*
-- 
2.35.1

