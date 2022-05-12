Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0C852474E
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 09:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351168AbiELHra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 03:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351181AbiELHrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 03:47:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E37C91B57A0;
        Thu, 12 May 2022 00:47:18 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24C4tf1p011245;
        Thu, 12 May 2022 07:46:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=sJNqtW7ebykqIJ6MGEZr6hWe/bMGGF1zGAs008xihKQ=;
 b=U7qpwa6FFc9DwyTK5ybiNdjGISAEZUA9ayUluK9WVY6jih3efRrAToAKpI24Hf2wE4De
 2zSdIjIaHa2uRa/vFwsv120UOekDU8AtOUZ+nceOQxPwvJBUqL+ku7Affz4cdoDMjHn5
 +eTOS68WeLAGKR6Kup5yzbsRTTPTeuLCj+dIiy8x88/29QY9bLYgZHakITdVSuNbeJF4
 UKd2KSGGrbu3L2MSp0orpG5VL+uWDw0+a6SfDkEfyH1cVc5Vys/E/a/d4xbHOK10rQUy
 UyipFFpkbq7RpjZp9fxLpRWPSZEJy92wiNDSsOfWA4Z2NE9OuCOHMWNCdgHKwyxi/dEO zA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0un2jxek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 07:46:48 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24C7Ia6b022328;
        Thu, 12 May 2022 07:46:48 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0un2jxd8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 07:46:47 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24C7bckD028290;
        Thu, 12 May 2022 07:46:44 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3fwgd8n500-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 07:46:44 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24C7kKCb29360470
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 07:46:20 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9DAC7A4051;
        Thu, 12 May 2022 07:46:41 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6BC89A4040;
        Thu, 12 May 2022 07:46:33 +0000 (GMT)
Received: from hbathini-workstation.ibm.com.com (unknown [9.211.109.30])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 May 2022 07:46:33 +0000 (GMT)
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
Subject: [PATCH 5/5] bpf ppc32: Add instructions for atomic_[cmp]xchg
Date:   Thu, 12 May 2022 13:15:46 +0530
Message-Id: <20220512074546.231616-6-hbathini@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220512074546.231616-1-hbathini@linux.ibm.com>
References: <20220512074546.231616-1-hbathini@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: r8QtyRJIHN0NPICWmDmD1c4VvQ9qLDwN
X-Proofpoint-ORIG-GUID: DS3bfz7Bz7Ook08vLsStW7dHE20VY3uT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-11_07,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 impostorscore=0 mlxscore=0 suspectscore=0 priorityscore=1501 clxscore=1015
 lowpriorityscore=0 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
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

This adds two atomic opcodes BPF_XCHG and BPF_CMPXCHG on ppc32, both
of which include the BPF_FETCH flag.  The kernel's atomic_cmpxchg
operation fundamentally has 3 operands, but we only have two register
fields. Therefore the operand we compare against (the kernel's API
calls it 'old') is hard-coded to be BPF_REG_R0. Also, kernel's
atomic_cmpxchg returns the previous value at dst_reg + off. JIT the
same for BPF too with return value put in BPF_REG_0.

  BPF_REG_R0 = atomic_cmpxchg(dst_reg + off, BPF_REG_R0, src_reg);

Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
---
 arch/powerpc/net/bpf_jit_comp32.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/powerpc/net/bpf_jit_comp32.c b/arch/powerpc/net/bpf_jit_comp32.c
index 5604ae1b60ab..4690fd6e9e52 100644
--- a/arch/powerpc/net/bpf_jit_comp32.c
+++ b/arch/powerpc/net/bpf_jit_comp32.c
@@ -829,6 +829,23 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 				/* we're done if this succeeded */
 				PPC_BCC_SHORT(COND_NE, tmp_idx);
 				break;
+			case BPF_CMPXCHG:
+				/* Compare with old value in BPF_REG_0 */
+				EMIT(PPC_RAW_CMPW(bpf_to_ppc(BPF_REG_0), _R0));
+				/* Don't set if different from old value */
+				PPC_BCC_SHORT(COND_NE, (ctx->idx + 3) * 4);
+				fallthrough;
+			case BPF_XCHG:
+				/* store new value */
+				EMIT(PPC_RAW_STWCX(src_reg, tmp_reg, dst_reg));
+				PPC_BCC_SHORT(COND_NE, tmp_idx);
+				/*
+				 * Return old value in src_reg for BPF_XCHG &
+				 * BPF_REG_0 for BPF_CMPXCHG.
+				 */
+				EMIT(PPC_RAW_MR(imm == BPF_XCHG ? src_reg : bpf_to_ppc(BPF_REG_0),
+						_R0));
+				break;
 			default:
 				pr_err_ratelimited("eBPF filter atomic op code %02x (@%d) unsupported\n",
 						   code, i);
-- 
2.35.1

