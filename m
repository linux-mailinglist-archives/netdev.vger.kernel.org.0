Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADA4E52474C
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 09:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350795AbiELHrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 03:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351169AbiELHrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 03:47:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C7A1B4341;
        Thu, 12 May 2022 00:47:06 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24C5M3OQ006577;
        Thu, 12 May 2022 07:46:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=VBZOjHpgCwwmLhF8DcmwFXQrJpWd7JnASzI13GbYvPk=;
 b=qZ2R2Tp5W8VPBVggMl0z1yixG8r3E5r1Oot/lCwcjHYUOfLNm1mu8bFcmGngNRVpj7GT
 Xbln5VHo4X0xk+9S7TWi7aiy0hhoylvnlvTa/PL1Kioi6YnsKMd86xvJdxJUVvQM5cR6
 inMHBKU9Fq+UOZBERwyfCavmpRKdWUufbeLY4SWDKbA89lIOvTXCOUlLR+EIOnKtacDK
 YQw/mkFkxp9L3gcOpLBthbvh6muNRPbv8GBhR7H0QBcXp7eeDuzZ3E+k6TlcXa+JFqvi
 Av2ovffE43fxK0Jefx+IY6fqP4o1U+iH31O5KIc0eyl+gtnExUIiK3+VjBc/j+gIsF9N lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0v1d2e71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 07:46:38 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24C7DaOY021587;
        Thu, 12 May 2022 07:46:37 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0v1d2e6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 07:46:37 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24C7bKUu028183;
        Thu, 12 May 2022 07:46:34 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 3fwgd8w5qy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 07:46:34 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24C7kWAX43778386
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 07:46:32 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A9C0A4053;
        Thu, 12 May 2022 07:46:32 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 81FEFA4040;
        Thu, 12 May 2022 07:46:24 +0000 (GMT)
Received: from hbathini-workstation.ibm.com.com (unknown [9.211.109.30])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 May 2022 07:46:24 +0000 (GMT)
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
Subject: [PATCH 4/5] bpf ppc32: add support for BPF_ATOMIC bitwise operations
Date:   Thu, 12 May 2022 13:15:45 +0530
Message-Id: <20220512074546.231616-5-hbathini@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220512074546.231616-1-hbathini@linux.ibm.com>
References: <20220512074546.231616-1-hbathini@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3AyS655gaBJcxWFAbUyAryJ4mYuYBicb
X-Proofpoint-GUID: 9Lo--HSV7gwADoNhTag_bcpyUympL_gw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-11_07,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 mlxlogscore=999 impostorscore=0 lowpriorityscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205120034
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding instructions for ppc32 for

atomic_and
atomic_or
atomic_xor
atomic_fetch_add
atomic_fetch_and
atomic_fetch_or
atomic_fetch_xor

Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
---
 arch/powerpc/net/bpf_jit_comp32.c | 45 +++++++++++++++++++++----------
 1 file changed, 31 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/net/bpf_jit_comp32.c b/arch/powerpc/net/bpf_jit_comp32.c
index e46ed1e8c6ca..5604ae1b60ab 100644
--- a/arch/powerpc/net/bpf_jit_comp32.c
+++ b/arch/powerpc/net/bpf_jit_comp32.c
@@ -798,25 +798,42 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 		 * BPF_STX ATOMIC (atomic ops)
 		 */
 		case BPF_STX | BPF_ATOMIC | BPF_W:
-			if (imm != BPF_ADD) {
-				pr_err_ratelimited("eBPF filter atomic op code %02x (@%d) unsupported\n",
-						   code, i);
-				return -ENOTSUPP;
-			}
-
-			/* *(u32 *)(dst + off) += src */
-
 			bpf_set_seen_register(ctx, tmp_reg);
 			/* Get offset into TMP_REG */
 			EMIT(PPC_RAW_LI(tmp_reg, off));
+			tmp_idx = ctx->idx * 4;
 			/* load value from memory into r0 */
 			EMIT(PPC_RAW_LWARX(_R0, tmp_reg, dst_reg, 0));
-			/* add value from src_reg into this */
-			EMIT(PPC_RAW_ADD(_R0, _R0, src_reg));
-			/* store result back */
-			EMIT(PPC_RAW_STWCX(_R0, tmp_reg, dst_reg));
-			/* we're done if this succeeded */
-			PPC_BCC_SHORT(COND_NE, (ctx->idx - 3) * 4);
+			switch (imm) {
+			case BPF_ADD:
+			case BPF_ADD | BPF_FETCH:
+				EMIT(PPC_RAW_ADD(_R0, _R0, src_reg));
+				goto atomic_ops;
+			case BPF_AND:
+			case BPF_AND | BPF_FETCH:
+				EMIT(PPC_RAW_AND(_R0, _R0, src_reg));
+				goto atomic_ops;
+			case BPF_OR:
+			case BPF_OR | BPF_FETCH:
+				EMIT(PPC_RAW_OR(_R0, _R0, src_reg));
+				goto atomic_ops;
+			case BPF_XOR:
+			case BPF_XOR | BPF_FETCH:
+				EMIT(PPC_RAW_XOR(_R0, _R0, src_reg));
+atomic_ops:
+				/* For the BPF_FETCH variant, get old data into src_reg */
+				if (imm & BPF_FETCH)
+					EMIT(PPC_RAW_LWARX(src_reg, tmp_reg, dst_reg, 0));
+				/* store result back */
+				EMIT(PPC_RAW_STWCX(_R0, tmp_reg, dst_reg));
+				/* we're done if this succeeded */
+				PPC_BCC_SHORT(COND_NE, tmp_idx);
+				break;
+			default:
+				pr_err_ratelimited("eBPF filter atomic op code %02x (@%d) unsupported\n",
+						   code, i);
+				return -EOPNOTSUPP;
+			}
 			break;
 
 		case BPF_STX | BPF_ATOMIC | BPF_DW: /* *(u64 *)(dst + off) += src */
-- 
2.35.1

