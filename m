Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9243BC736
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 09:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbhGFHfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 03:35:53 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45706 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230203AbhGFHfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 03:35:52 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16674QM6185824;
        Tue, 6 Jul 2021 03:32:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=DhBG00BRIDS9kY/TDk/2w+U8fw1d5Z+WFBhN857SAik=;
 b=QyblCeiUXdMoqa3q3MhZIkl4WzRG0zvhrIFL/Yg5XL2u3CrGQjLNCt38BKSAWSKKN3AL
 An5pklNzCAgkc18+lCbQZfvcAA7yqdM3amI5OagQvEzWtEpr4KCu+2cqbcwkydejZwP1
 iCLqBoeV8ykvdsW78KyhkIopu13UL7LQhTYU3dXpzDh8QRyVsuwyrO32+2fpbbogDaQ8
 tj1xg5/8f8w/kb7sshdDfKSST6ulo5nVJdiNxBuIRg/aXkGb4MCZdgiIRWgRzBWGE2jf
 9OaJP2DKctoUt9A/5cU8+qIhQXmlGCo/RFH10Y1mpr1bWv2JNR7vZop3dsB5L4QIqmOt Rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mdbg6xxq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 03:32:41 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16675IOB188846;
        Tue, 6 Jul 2021 03:32:41 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mdbg6xx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 03:32:41 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1667WNZO024949;
        Tue, 6 Jul 2021 07:32:39 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 39jfh88kkv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 07:32:39 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1667WaoW10944922
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Jul 2021 07:32:36 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 69FD75205A;
        Tue,  6 Jul 2021 07:32:36 +0000 (GMT)
Received: from bangoria.ibmuc.com (unknown [9.199.43.134])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id EA0445205F;
        Tue,  6 Jul 2021 07:32:30 +0000 (GMT)
From:   Ravi Bangoria <ravi.bangoria@linux.ibm.com>
To:     naveen.n.rao@linux.ibm.com, mpe@ellerman.id.au, ast@kernel.org,
        daniel@iogearbox.net
Cc:     ravi.bangoria@linux.ibm.com, sandipan@linux.ibm.com,
        paulus@samba.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] bpf powerpc: Remove unused SEEN_STACK
Date:   Tue,  6 Jul 2021 13:02:08 +0530
Message-Id: <20210706073211.349889-2-ravi.bangoria@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210706073211.349889-1-ravi.bangoria@linux.ibm.com>
References: <20210706073211.349889-1-ravi.bangoria@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: cy01iGkQvCtyoumv8h3vh9LnZwa3uABo
X-Proofpoint-GUID: w_ZGQdruiDboe7bzlPoSITu85UJvuUas
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-06_02:2021-07-02,2021-07-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 phishscore=0 impostorscore=0 adultscore=0 malwarescore=0 bulkscore=0
 spamscore=0 suspectscore=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107060035
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SEEN_STACK is unused on PowerPC. Remove it. Also, have
SEEN_TAILCALL use 0x40000000.

Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
---
 arch/powerpc/net/bpf_jit.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/powerpc/net/bpf_jit.h b/arch/powerpc/net/bpf_jit.h
index 99fad093f43e..d6267e93027a 100644
--- a/arch/powerpc/net/bpf_jit.h
+++ b/arch/powerpc/net/bpf_jit.h
@@ -116,8 +116,7 @@ static inline bool is_nearbranch(int offset)
 #define COND_LE		(CR0_GT | COND_CMP_FALSE)
 
 #define SEEN_FUNC	0x20000000 /* might call external helpers */
-#define SEEN_STACK	0x40000000 /* uses BPF stack */
-#define SEEN_TAILCALL	0x80000000 /* uses tail calls */
+#define SEEN_TAILCALL	0x40000000 /* uses tail calls */
 
 #define SEEN_VREG_MASK	0x1ff80000 /* Volatile registers r3-r12 */
 #define SEEN_NVREG_MASK	0x0003ffff /* Non volatile registers r14-r31 */
-- 
2.26.3

