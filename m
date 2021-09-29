Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 651C341C352
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 13:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245693AbhI2LWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 07:22:14 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56992 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245699AbhI2LVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 07:21:52 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T9HOmm023048;
        Wed, 29 Sep 2021 07:19:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=8uRYQgjx7hrdLFyt5Ht2DsP4CWx0pYcf5wH3eQKSHdE=;
 b=bEfD+TfrNy+wIcCyPgkLt5125wrf7ZJM1TS6fxUyRRzpbdiKEpFXVEFLKSQlx7Wi8rEd
 M2qEpycRebzZTgjWqRXcaNWI+klUst2uVectHbC2Bt2st3KkBYAbj2mBQMAyuNE9jPdQ
 GP+Rv+argjEQ3jmtq/iwYxTEraqegJXXo7NIDrgKpsQIzeYaNzbGGWJdtATAVBZDEuWQ
 wxolwkaGAjIzR1CQXuRVY3ERrKu2hJ0dBkCHn/L83q6s1HNmeDxI6d/CGm1t8O+oN27X
 tzQ94bnMoJiqEMWhiJt9qtbryeaIlDMKdgqLeyGSQuYOHtG19NFRDm3CfJozzTErbiZf +w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bcmusk6um-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Sep 2021 07:19:43 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18TAcDsY005255;
        Wed, 29 Sep 2021 07:19:42 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bcmusk6tv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Sep 2021 07:19:42 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18TBBw0g019748;
        Wed, 29 Sep 2021 11:19:40 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3b9ud9n64m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Sep 2021 11:19:40 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18TBJbwv2687494
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 11:19:37 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3995342072;
        Wed, 29 Sep 2021 11:19:37 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8022F4206C;
        Wed, 29 Sep 2021 11:19:32 +0000 (GMT)
Received: from hbathini-workstation.ibm.com.com (unknown [9.43.83.199])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 29 Sep 2021 11:19:32 +0000 (GMT)
From:   Hari Bathini <hbathini@linux.ibm.com>
To:     naveen.n.rao@linux.ibm.com, christophe.leroy@csgroup.eu,
        mpe@ellerman.id.au, ast@kernel.org, daniel@iogearbox.net
Cc:     paulus@samba.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Hari Bathini <hbathini@linux.ibm.com>
Subject: [PATCH v4 6/8] bpf ppc64: Access only if addr is kernel address
Date:   Wed, 29 Sep 2021 16:48:53 +0530
Message-Id: <20210929111855.50254-7-hbathini@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210929111855.50254-1-hbathini@linux.ibm.com>
References: <20210929111855.50254-1-hbathini@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HMcK7K3ZJpocAL3f7AH4G8rchbuyyfnm
X-Proofpoint-ORIG-GUID: 09EXvebg1u7dnPAWNDECri4yg36calLy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-29_04,2021-09-29_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0 mlxscore=0
 impostorscore=0 priorityscore=1501 mlxlogscore=999 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109290068
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
only if addr is kernel address, otherwise set dst_reg=0 and move on.

This will catch NULL, valid or invalid userspace pointers. Only bad
kernel pointer will be handled by BPF exception table.

[Alexei suggested for x86]
Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
---

Changes in v4:
* Used IS_ENABLED() instead of #ifdef.
* Dropped the else case that is not applicable for PPC64.


 arch/powerpc/net/bpf_jit_comp64.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index 4170999371ee..e1ea64081ae1 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -727,6 +727,32 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 		/* dst = *(u64 *)(ul) (src + off) */
 		case BPF_LDX | BPF_MEM | BPF_DW:
 		case BPF_LDX | BPF_PROBE_MEM | BPF_DW:
+			/*
+			 * As PTR_TO_BTF_ID that uses BPF_PROBE_MEM mode could either be a valid
+			 * kernel pointer or NULL but not a userspace address, execute BPF_PROBE_MEM
+			 * load only if addr is kernel address (see is_kernel_addr()), otherwise
+			 * set dst_reg=0 and move on.
+			 */
+			if (BPF_MODE(code) == BPF_PROBE_MEM) {
+				EMIT(PPC_RAW_ADDI(b2p[TMP_REG_1], src_reg, off));
+				if (IS_ENABLED(CONFIG_PPC_BOOK3E_64))
+					PPC_LI64(b2p[TMP_REG_2], 0x8000000000000000ul);
+				else /* BOOK3S_64 */
+					PPC_LI64(b2p[TMP_REG_2], PAGE_OFFSET);
+				EMIT(PPC_RAW_CMPLD(b2p[TMP_REG_1], b2p[TMP_REG_2]));
+				PPC_BCC(COND_GT, (ctx->idx + 4) * 4);
+				EMIT(PPC_RAW_LI(dst_reg, 0));
+				/*
+				 * Check if 'off' is word aligned because PPC_BPF_LL()
+				 * (BPF_DW case) generates two instructions if 'off' is not
+				 * word-aligned and one instruction otherwise.
+				 */
+				if (BPF_SIZE(code) == BPF_DW && (off & 3))
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

