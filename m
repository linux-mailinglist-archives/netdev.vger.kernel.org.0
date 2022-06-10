Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C771A5469EC
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 17:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237382AbiFJP4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 11:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346031AbiFJP4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 11:56:46 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3FF1D5029;
        Fri, 10 Jun 2022 08:56:45 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25AECxEt016964;
        Fri, 10 Jun 2022 15:56:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=j46PyfkMy/zK0Yabz4R6McXUoyKqQj/vVMmL324KBo8=;
 b=oypKb4czVCFxzO6M6s//SxBJ9xYS+qdHKqoLXnGj5Q62EgUuqpa9c7V+oZmxX+d75Y8x
 DO7Rje9sx9nM6QvVbXvY2szhw8IbgwxLdZ4bOoqQHdiGf4+MQAMJTnTpWAlALwtsCVRJ
 MpbuWp3jSuY6f57ugYLWreBetbZRAGIvB+AgfjYfrKIv9gT89/l170eYvv8br2Z6Sa6x
 fcHVi579/hf1isNzpY28fAZGSH9KwnvsbL8NpRhr5a5/hVkoth2hSVpgvLXiLuDiGcU8
 EEEb+WDlqFMDloTlii3VaOiI1YbBC5CMYidIDdyQdZA96spa5h+mgYZzgF/WeFKtkkUG YQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gm7h69yx0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Jun 2022 15:56:06 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25AFcj1g007755;
        Fri, 10 Jun 2022 15:56:05 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gm7h69yw9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Jun 2022 15:56:05 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25AFoIT4013077;
        Fri, 10 Jun 2022 15:56:03 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3gfy18xnxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Jun 2022 15:56:03 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25AFu1A521889378
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jun 2022 15:56:01 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C8754C046;
        Fri, 10 Jun 2022 15:56:01 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5366A4C040;
        Fri, 10 Jun 2022 15:55:57 +0000 (GMT)
Received: from hbathini-workstation.in.ibm.com (unknown [9.203.106.231])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 10 Jun 2022 15:55:57 +0000 (GMT)
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
        Jordan Niethe <jniethe5@gmail.com>,
        Russell Currey <ruscur@russell.cc>
Subject: [PATCH v2 1/5] bpf ppc64: add support for BPF_ATOMIC bitwise operations
Date:   Fri, 10 Jun 2022 21:25:48 +0530
Message-Id: <20220610155552.25892-2-hbathini@linux.ibm.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220610155552.25892-1-hbathini@linux.ibm.com>
References: <20220610155552.25892-1-hbathini@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: M5WOpzHduT7Zedk72RlnzxJFzOotDr2J
X-Proofpoint-ORIG-GUID: Vo92_niTa5d-UYM9pXLy97tPNUiiWd2y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-10_06,2022-06-09_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 mlxscore=0 suspectscore=0 clxscore=1015 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 impostorscore=0 spamscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206100061
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

* No changes in v2.


 arch/powerpc/net/bpf_jit_comp64.c | 57 ++++++++++++++++---------------
 1 file changed, 29 insertions(+), 28 deletions(-)

diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index 594c54931e20..c421bedd0e98 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -777,41 +777,42 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
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
2.35.3

