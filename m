Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A77D524748
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 09:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351155AbiELHrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 03:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351132AbiELHqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 03:46:55 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FCC3B3E5;
        Thu, 12 May 2022 00:46:51 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24C5M89N007075;
        Thu, 12 May 2022 07:46:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=rwQzzGuF0a2Ee6HDIGyhvnnYSGRvC/jU8t7gT9JQ/CQ=;
 b=RcfPWrnyuy2lIFpgU3DUT1WqkXZLb9TXR/IV7QGOI5uHQfJ35U8iBmjIdSNGKaIG7Gr+
 EZWNMEq9OB62e13f8YOv8YgnwrdqkuG2Au9Nc1bt/0k3MgtGkdcR375h3u4ApJ7OMFbO
 wBYyS+aTLsdq8S8iyo9vcPbIOEqXKLT8bDetxNIt/3LAMXnHzk04Tb+/Fr26ryzEKqf1
 ycbB9QSJsEC5RuEf7Bk8ej7rFw/Q7H4ZmlVUHM+UJImBuvWC/MP7JBb7OG8jEni7wrVs
 uo/PddIv+v+1QHiBzl2M2tHlRfZaqCJlI1+LRqWj3m6MES8SIGWma/m3YgpfFjd+Hdqi qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0v1d2e27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 07:46:20 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24C7WGPN005553;
        Thu, 12 May 2022 07:46:19 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0v1d2e1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 07:46:19 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24C7csAS023729;
        Thu, 12 May 2022 07:46:17 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3fwgd8w4v4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 07:46:17 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24C7WaXU41419126
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 07:32:37 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E0959A4053;
        Thu, 12 May 2022 07:46:14 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD2BDA4040;
        Thu, 12 May 2022 07:46:06 +0000 (GMT)
Received: from hbathini-workstation.ibm.com.com (unknown [9.211.109.30])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 May 2022 07:46:06 +0000 (GMT)
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
Subject: [PATCH 2/5] bpf ppc64: add support for atomic fetch operations
Date:   Thu, 12 May 2022 13:15:43 +0530
Message-Id: <20220512074546.231616-3-hbathini@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220512074546.231616-1-hbathini@linux.ibm.com>
References: <20220512074546.231616-1-hbathini@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -Kjc5MyExrba6Kgq84NamC5URDXi8djS
X-Proofpoint-GUID: uZhAT8ckYT2tjDdvIUVwf_XF3de9gv-s
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

Adding instructions for ppc64 for

atomic[64]_fetch_add
atomic[64]_fetch_and
atomic[64]_fetch_or
atomic[64]_fetch_xor

Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
---
 arch/powerpc/net/bpf_jit_comp64.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index b34ed88167f0..504fa459f9f3 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -792,17 +792,25 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 			else
 				EMIT(PPC_RAW_LWARX(tmp2_reg, tmp1_reg, dst_reg, 0));
 
+			/* Save old value in _R0 */
+			if (imm & BPF_FETCH)
+				EMIT(PPC_RAW_MR(_R0, tmp2_reg));
+
 			switch (imm) {
 			case BPF_ADD:
+			case BPF_ADD | BPF_FETCH:
 				EMIT(PPC_RAW_ADD(tmp2_reg, tmp2_reg, src_reg));
 				break;
 			case BPF_AND:
+			case BPF_AND | BPF_FETCH:
 				EMIT(PPC_RAW_AND(tmp2_reg, tmp2_reg, src_reg));
 				break;
 			case BPF_OR:
+			case BPF_OR | BPF_FETCH:
 				EMIT(PPC_RAW_OR(tmp2_reg, tmp2_reg, src_reg));
 				break;
 			case BPF_XOR:
+			case BPF_XOR | BPF_FETCH:
 				EMIT(PPC_RAW_XOR(tmp2_reg, tmp2_reg, src_reg));
 				break;
 			default:
@@ -812,13 +820,17 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 				return -EOPNOTSUPP;
 			}
 
-			/* store result back */
+			/* store new value */
 			if (size == BPF_DW)
 				EMIT(PPC_RAW_STDCX(tmp2_reg, tmp1_reg, dst_reg));
 			else
 				EMIT(PPC_RAW_STWCX(tmp2_reg, tmp1_reg, dst_reg));
 			/* we're done if this succeeded */
 			PPC_BCC_SHORT(COND_NE, tmp_idx);
+
+			/* For the BPF_FETCH variant, get old value into src_reg */
+			if (imm & BPF_FETCH)
+				EMIT(PPC_RAW_MR(src_reg, _R0));
 			break;
 
 		/*
-- 
2.35.1

