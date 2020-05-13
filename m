Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15E171D19B8
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 17:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730046AbgEMPow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 11:44:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41736 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726138AbgEMPow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 11:44:52 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04DFavBB021114;
        Wed, 13 May 2020 11:44:39 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 310hbhnccg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 May 2020 11:44:38 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04DFgUmj038465;
        Wed, 13 May 2020 11:44:38 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 310hbhnc8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 May 2020 11:44:38 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04DFUDhd000372;
        Wed, 13 May 2020 15:44:33 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3100ub1v4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 May 2020 15:44:32 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04DFiU8C36110462
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 May 2020 15:44:30 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3DED8AE057;
        Wed, 13 May 2020 15:44:30 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 972C0AE045;
        Wed, 13 May 2020 15:44:29 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 May 2020 15:44:29 +0000 (GMT)
From:   Sumanth Korikkar <sumanthk@linux.ibm.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     iii@linux.ibm.com, jwi@linux.ibm.com,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>
Subject: [PATCH bpf-next] libbpf: Fix register naming in PT_REGS s390 macros
Date:   Wed, 13 May 2020 17:44:14 +0200
Message-Id: <20200513154414.29972-1-sumanthk@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-13_06:2020-05-13,2020-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 mlxscore=0 phishscore=0 suspectscore=0
 mlxlogscore=860 malwarescore=0 priorityscore=1501 impostorscore=0
 adultscore=0 clxscore=1011 cotscore=-2147483648 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005130135
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix register naming in PT_REGS s390 macros

Fixes: b8ebce86ffe6 ("libbpf: Provide CO-RE variants of PT_REGS macros")
Reviewed-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
---
 tools/lib/bpf/bpf_tracing.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/bpf_tracing.h b/tools/lib/bpf/bpf_tracing.h
index f3f3c3fb98cb..48a9c7c69ef1 100644
--- a/tools/lib/bpf/bpf_tracing.h
+++ b/tools/lib/bpf/bpf_tracing.h
@@ -148,11 +148,11 @@ struct pt_regs;
 #define PT_REGS_PARM3_CORE(x) BPF_CORE_READ((PT_REGS_S390 *)(x), gprs[4])
 #define PT_REGS_PARM4_CORE(x) BPF_CORE_READ((PT_REGS_S390 *)(x), gprs[5])
 #define PT_REGS_PARM5_CORE(x) BPF_CORE_READ((PT_REGS_S390 *)(x), gprs[6])
-#define PT_REGS_RET_CORE(x) BPF_CORE_READ((PT_REGS_S390 *)(x), grps[14])
+#define PT_REGS_RET_CORE(x) BPF_CORE_READ((PT_REGS_S390 *)(x), gprs[14])
 #define PT_REGS_FP_CORE(x) BPF_CORE_READ((PT_REGS_S390 *)(x), gprs[11])
 #define PT_REGS_RC_CORE(x) BPF_CORE_READ((PT_REGS_S390 *)(x), gprs[2])
 #define PT_REGS_SP_CORE(x) BPF_CORE_READ((PT_REGS_S390 *)(x), gprs[15])
-#define PT_REGS_IP_CORE(x) BPF_CORE_READ((PT_REGS_S390 *)(x), pdw.addr)
+#define PT_REGS_IP_CORE(x) BPF_CORE_READ((PT_REGS_S390 *)(x), psw.addr)
 
 #elif defined(bpf_target_arm)
 
-- 
2.17.1

