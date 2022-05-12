Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59528524745
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 09:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351158AbiELHq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 03:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351150AbiELHq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 03:46:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F4A49693;
        Thu, 12 May 2022 00:46:52 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24C7BqHD018633;
        Thu, 12 May 2022 07:46:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=OK5ob7wbXQHK8nfG5zvAbuDQPtoJ3hnL0Wvjx7idLd4=;
 b=dWDu+Ol+PoUEcyZoWxFu+hRUx2QjVTK0o7YLEkzIW98Q8urCNfO4BdQxnVzzICLsQedc
 /Fgj9r7UAV7q1XvtN3LobHKv18BgF0PAFkfXZg6grLT0Mzny85cjEiN79tLjU/FLkxt3
 +RGHLsP+T3PCNU6vKj6o3LfdPLK27iSOZI1+pLOu1H/eT0bvGb9qyNWUD0/DFcUTZVTP
 cLVeS3gEs8jVxxkhSMq2UUwEgreOUqEo6Ry6t+bSmKyn3IttCDBSFK9e9Xeqe6Lg/ppc
 LOjh7vYNF1ua4RWW2gG8q7WQRdJ5CiUAISj6xhZOZkPBYbeMvYT2wDhfPX7b+6uGLls6 Pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0wmt8knf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 07:46:11 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24C7H06N016992;
        Thu, 12 May 2022 07:46:10 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0wmt8kmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 07:46:10 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24C7cjB5003031;
        Thu, 12 May 2022 07:46:08 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3fwgd8xm72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 07:46:08 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24C7jjGG31588714
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 07:45:45 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F3D5AA4055;
        Thu, 12 May 2022 07:46:05 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CCDBAA404D;
        Thu, 12 May 2022 07:45:57 +0000 (GMT)
Received: from hbathini-workstation.ibm.com.com (unknown [9.211.109.30])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 May 2022 07:45:57 +0000 (GMT)
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
Subject: [PATCH 1/5] bpf ppc64: add support for BPF_ATOMIC bitwise operations
Date:   Thu, 12 May 2022 13:15:42 +0530
Message-Id: <20220512074546.231616-2-hbathini@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220512074546.231616-1-hbathini@linux.ibm.com>
References: <20220512074546.231616-1-hbathini@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xwHRNrstbGAF2bxHbm82rn6P-nV7keAg
X-Proofpoint-GUID: 0t7HLR3O5YMIBqPJtx0U6XA9vvX4-JcP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-11_07,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 mlxscore=0 phishscore=0
 malwarescore=0 suspectscore=0 impostorscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205120034
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding instructions for ppc64 for

atomic[64]_and
atomic[64]_or
atomic[64]_xor

Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
---
 arch/powerpc/net/bpf_jit_comp64.c | 57 ++++++++++++++++---------------
 1 file changed, 29 insertions(+), 28 deletions(-)

diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index 183a73f8fcc4..b34ed88167f0 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -782,41 +782,42 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 		 * BPF_STX ATOMIC (atomic ops)
 		 */
 		case BPF_STX | BPF_ATOMIC | BPF_W:
-			if (imm != BPF_ADD) {
-				pr_err_ratelimited(
-					"eBPF filter atomic op code %02x (@%d) unsupported\n",
-					code, i);
-				return -ENOTSUPP;
-			}
-
-			/* *(u32 *)(dst + off) += src */
-
-			/* Get EA into TMP_REG_1 */
-			EMIT(PPC_RAW_ADDI(tmp1_reg, dst_reg, off));
+		case BPF_STX | BPF_ATOMIC | BPF_DW:
+			/* Get offset into TMP_REG_1 */
+			EMIT(PPC_RAW_LI(tmp1_reg, off));
 			tmp_idx = ctx->idx * 4;
 			/* load value from memory into TMP_REG_2 */
-			EMIT(PPC_RAW_LWARX(tmp2_reg, 0, tmp1_reg, 0));
-			/* add value from src_reg into this */
-			EMIT(PPC_RAW_ADD(tmp2_reg, tmp2_reg, src_reg));
-			/* store result back */
-			EMIT(PPC_RAW_STWCX(tmp2_reg, 0, tmp1_reg));
-			/* we're done if this succeeded */
-			PPC_BCC_SHORT(COND_NE, tmp_idx);
-			break;
-		case BPF_STX | BPF_ATOMIC | BPF_DW:
-			if (imm != BPF_ADD) {
+			if (size == BPF_DW)
+				EMIT(PPC_RAW_LDARX(tmp2_reg, tmp1_reg, dst_reg, 0));
+			else
+				EMIT(PPC_RAW_LWARX(tmp2_reg, tmp1_reg, dst_reg, 0));
+
+			switch (imm) {
+			case BPF_ADD:
+				EMIT(PPC_RAW_ADD(tmp2_reg, tmp2_reg, src_reg));
+				break;
+			case BPF_AND:
+				EMIT(PPC_RAW_AND(tmp2_reg, tmp2_reg, src_reg));
+				break;
+			case BPF_OR:
+				EMIT(PPC_RAW_OR(tmp2_reg, tmp2_reg, src_reg));
+				break;
+			case BPF_XOR:
+				EMIT(PPC_RAW_XOR(tmp2_reg, tmp2_reg, src_reg));
+				break;
+			default:
 				pr_err_ratelimited(
 					"eBPF filter atomic op code %02x (@%d) unsupported\n",
 					code, i);
-				return -ENOTSUPP;
+				return -EOPNOTSUPP;
 			}
-			/* *(u64 *)(dst + off) += src */
 
-			EMIT(PPC_RAW_ADDI(tmp1_reg, dst_reg, off));
-			tmp_idx = ctx->idx * 4;
-			EMIT(PPC_RAW_LDARX(tmp2_reg, 0, tmp1_reg, 0));
-			EMIT(PPC_RAW_ADD(tmp2_reg, tmp2_reg, src_reg));
-			EMIT(PPC_RAW_STDCX(tmp2_reg, 0, tmp1_reg));
+			/* store result back */
+			if (size == BPF_DW)
+				EMIT(PPC_RAW_STDCX(tmp2_reg, tmp1_reg, dst_reg));
+			else
+				EMIT(PPC_RAW_STWCX(tmp2_reg, tmp1_reg, dst_reg));
+			/* we're done if this succeeded */
 			PPC_BCC_SHORT(COND_NE, tmp_idx);
 			break;
 
-- 
2.35.1

