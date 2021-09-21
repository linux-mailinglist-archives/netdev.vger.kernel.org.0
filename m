Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D17941341A
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 15:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbhIUNcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 09:32:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61060 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233049AbhIUNcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 09:32:06 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18LCUEhE016240;
        Tue, 21 Sep 2021 09:30:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=NMcinHHQMjEHvuMBynTLTic0D1DugvVzyp3NJCT7MY0=;
 b=jTKgBuEW/X8CJWUeeH2OSWo1HJDDFbDAkaIEktm/wZXGus/cluz7wKprYIVAD52CLQAt
 tGNV64snsILEY7thGtqpqVad5ujFQpnVrLWOqfkDni52S6QHP+V2BjWac/Uwrpr++MLv
 9iPwIHMil3IGUMmEXaRLWBEkATnYSVLg+ctwhKatuuEpS8iYuYZB1KDyK8uA4YeD8kAE
 TA8dBMiUoSh9zH6kb9mr84gkBBhuyiX75ctg3i8ZGvTahtSR2GBsTcD/8wtKIjtDf06T
 fQVxJ+14CTQOPEffHKUu8079LHdx30iZ5ztur6ZFhgwSUaAwct9xRBwSVh/PAcVUGeGE 2Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7ff09j1b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 09:30:05 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18LCUFdi016259;
        Tue, 21 Sep 2021 09:30:05 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7ff09hyu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 09:30:05 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18LDNDMR012281;
        Tue, 21 Sep 2021 13:30:02 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3b57r94bmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 13:30:02 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18LDTwUF40304970
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Sep 2021 13:29:58 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 287984C05A;
        Tue, 21 Sep 2021 13:29:58 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58C974C059;
        Tue, 21 Sep 2021 13:29:54 +0000 (GMT)
Received: from hbathini-workstation.ibm.com.com (unknown [9.43.117.91])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 21 Sep 2021 13:29:54 +0000 (GMT)
From:   Hari Bathini <hbathini@linux.ibm.com>
To:     naveen.n.rao@linux.ibm.com, christophe.leroy@csgroup.eu,
        mpe@ellerman.id.au, ast@kernel.org, daniel@iogearbox.net
Cc:     paulus@samba.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Subject: [PATCH v3 1/8] bpf powerpc: Remove unused SEEN_STACK
Date:   Tue, 21 Sep 2021 18:59:36 +0530
Message-Id: <20210921132943.489732-2-hbathini@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210921132943.489732-1-hbathini@linux.ibm.com>
References: <20210921132943.489732-1-hbathini@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: pJVxfzowkdJDjwKb2v6BQFxMb2BK2_Sw
X-Proofpoint-GUID: yoXJzjG3VymwEE9z8WlJz2jpjO7IPjYJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-21_01,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 adultscore=0 priorityscore=1501 mlxscore=0 impostorscore=0 suspectscore=0
 spamscore=0 phishscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109210082
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ravi Bangoria <ravi.bangoria@linux.ibm.com>

SEEN_STACK is unused on PowerPC. Remove it. Also, have
SEEN_TAILCALL use 0x40000000.

Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---

Changes in v3:
* Added Reviewed-by tag from Chris.


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

