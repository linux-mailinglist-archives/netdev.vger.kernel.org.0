Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6B041C34D
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 13:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245688AbhI2LVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 07:21:49 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8566 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S245310AbhI2LVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 07:21:48 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18TBC05S026006;
        Wed, 29 Sep 2021 07:19:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=fRx+cPAzd1elS+3LrvPTO2hLFtxNWpauw5tViMZm3h0=;
 b=qttYdHV7+hDVVI9/CIDFw5Myz2flSFZD3wKbxQaafF8hyZrmDvNTN5bRLIT2DQLhHbSx
 B5RUYE97S7CyxAceNX1YMjX0A2G+M3HCDOWZqDn801zGcLsmaaE97ZnoW1me6va1VM5/
 67MfNeDYYg+yfcQeyZQR04+opfAXGcC4/HrGkzcR+oqPW8CceLqYXnkjHBKKQOYF1xn1
 ezepm3xqR2kmdgmJCKfgO2TjLPySN6Tz9FID2JBDxB0u5+xsYSrn2ImWfjjap/mTbiiZ
 9gw+XeXJhy83i1A+xQDKZX1P3qpBEJDZhtn2Gn3zrv3kC12QktJuprfZ4qD8bUyQ9eFV qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bcq2b84rp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Sep 2021 07:19:32 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18TBDWki029002;
        Wed, 29 Sep 2021 07:19:32 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bcq2b84r7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Sep 2021 07:19:32 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18TBBxIx019039;
        Wed, 29 Sep 2021 11:19:30 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3b9uda74ne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Sep 2021 11:19:30 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18TBJQ1946006740
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 11:19:26 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C48F42077;
        Wed, 29 Sep 2021 11:19:26 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8879142074;
        Wed, 29 Sep 2021 11:19:21 +0000 (GMT)
Received: from hbathini-workstation.ibm.com.com (unknown [9.43.83.199])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 29 Sep 2021 11:19:21 +0000 (GMT)
From:   Hari Bathini <hbathini@linux.ibm.com>
To:     naveen.n.rao@linux.ibm.com, christophe.leroy@csgroup.eu,
        mpe@ellerman.id.au, ast@kernel.org, daniel@iogearbox.net
Cc:     paulus@samba.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Hari Bathini <hbathini@linux.ibm.com>
Subject: [PATCH v4 4/8] powerpc/ppc-opcode: introduce PPC_RAW_BRANCH() macro
Date:   Wed, 29 Sep 2021 16:48:51 +0530
Message-Id: <20210929111855.50254-5-hbathini@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210929111855.50254-1-hbathini@linux.ibm.com>
References: <20210929111855.50254-1-hbathini@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Z0ICVfDN9YAe98LH-3DPJiLXkmin7JoX
X-Proofpoint-ORIG-GUID: rdpQPQt2je3ZCfT-NR9owd9pSA46FCVY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-29_04,2021-09-29_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 bulkscore=0 spamscore=0 mlxlogscore=999
 mlxscore=0 priorityscore=1501 suspectscore=0 impostorscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109290068
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define and use PPC_RAW_BRANCH() macro instead of open coding it. This
macro is used while adding BPF_PROBE_MEM support.

Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---

* No changes in v4.


 arch/powerpc/include/asm/ppc-opcode.h | 2 ++
 arch/powerpc/net/bpf_jit.h            | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/ppc-opcode.h b/arch/powerpc/include/asm/ppc-opcode.h
index baea657bc868..f50213e2a3e0 100644
--- a/arch/powerpc/include/asm/ppc-opcode.h
+++ b/arch/powerpc/include/asm/ppc-opcode.h
@@ -566,6 +566,8 @@
 #define PPC_RAW_MTSPR(spr, d)		(0x7c0003a6 | ___PPC_RS(d) | __PPC_SPR(spr))
 #define PPC_RAW_EIEIO()			(0x7c0006ac)
 
+#define PPC_RAW_BRANCH(addr)		(PPC_INST_BRANCH | ((addr) & 0x03fffffc))
+
 /* Deal with instructions that older assemblers aren't aware of */
 #define	PPC_BCCTR_FLUSH		stringify_in_c(.long PPC_INST_BCCTR_FLUSH)
 #define	PPC_CP_ABORT		stringify_in_c(.long PPC_RAW_CP_ABORT)
diff --git a/arch/powerpc/net/bpf_jit.h b/arch/powerpc/net/bpf_jit.h
index 411c63d945c7..0c8f885b8f48 100644
--- a/arch/powerpc/net/bpf_jit.h
+++ b/arch/powerpc/net/bpf_jit.h
@@ -24,8 +24,8 @@
 #define EMIT(instr)		PLANT_INSTR(image, ctx->idx, instr)
 
 /* Long jump; (unconditional 'branch') */
-#define PPC_JMP(dest)		EMIT(PPC_INST_BRANCH |			      \
-				     (((dest) - (ctx->idx * 4)) & 0x03fffffc))
+#define PPC_JMP(dest)		EMIT(PPC_RAW_BRANCH((dest) - (ctx->idx * 4)))
+
 /* blr; (unconditional 'branch' with link) to absolute address */
 #define PPC_BL_ABS(dest)	EMIT(PPC_INST_BL |			      \
 				     (((dest) - (unsigned long)(image + ctx->idx)) & 0x03fffffc))
-- 
2.31.1

