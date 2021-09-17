Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F8E40FC67
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 17:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239917AbhIQPdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 11:33:33 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1366 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239674AbhIQPdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 11:33:32 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18HEshqW025428;
        Fri, 17 Sep 2021 11:31:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=UdgT/7FHGFSSIkKiy8d7V/ONh1VDUvihFVqIKV0RvSw=;
 b=XUU6uwgETGvQnuxvbzKdeKnXbZNXNMTF9gv6W5K1c0uznQbDvHsLN+RfHjEuQmFuU7mC
 Rh+LrVv6uebnsh5GwDopEoriqrEquL6FlFlXOD7oKkp4hQarhWlgleDactSeqY+4kl8W
 ogHoLxmnrROUzVktXh+b3EfmL19UVDT4/+PhUymz1Xwa/WdNnbdX3uA85fL48nmWxKgB
 lXK+oMcPxb8BlRDo4rqpAAPTGGrSSjkVXtQxTxCLIGMKAoEGs89pUn2qoq+MoD3q7ki0
 F5EhI4cZ1FFLYG+a/aLb/R18zoAwz+4/HoCul+ioMS/pmuGtM9ysx/2BTAOAOv1pW1ix iA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b4k5r7b4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 11:31:36 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18HFJgVc032133;
        Fri, 17 Sep 2021 11:31:36 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b4k5r7b46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 11:31:36 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18HFGlNw028371;
        Fri, 17 Sep 2021 15:31:34 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3b0m3ae0u4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 15:31:34 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18HFQtWO50790830
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Sep 2021 15:26:55 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE34611C069;
        Fri, 17 Sep 2021 15:31:30 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8AF0411C050;
        Fri, 17 Sep 2021 15:31:25 +0000 (GMT)
Received: from hbathini-workstation.ibm.com (unknown [9.43.59.213])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 17 Sep 2021 15:31:25 +0000 (GMT)
From:   Hari Bathini <hbathini@linux.ibm.com>
To:     naveen.n.rao@linux.ibm.com, mpe@ellerman.id.au, ast@kernel.org,
        daniel@iogearbox.net
Cc:     christophe.leroy@csgroup.eu, paulus@samba.org, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Subject: [PATCH v2 1/8] bpf powerpc: Remove unused SEEN_STACK
Date:   Fri, 17 Sep 2021 21:00:40 +0530
Message-Id: <20210917153047.177141-2-hbathini@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210917153047.177141-1-hbathini@linux.ibm.com>
References: <20210917153047.177141-1-hbathini@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4holgyW-rDfb3URCtZ8nM1Ulbf0xLgkr
X-Proofpoint-GUID: xO7zueKA812CWCetqLHMli9ysoYe_PcU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-17_06,2021-09-17_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 adultscore=0 bulkscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 mlxscore=0 mlxlogscore=999 phishscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109170096
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ravi Bangoria <ravi.bangoria@linux.ibm.com>

SEEN_STACK is unused on PowerPC. Remove it. Also, have
SEEN_TAILCALL use 0x40000000.

Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
---

* No changes in v2.


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
2.31.1

