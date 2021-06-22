Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40F643B0233
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 13:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhFVLD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 07:03:27 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1880 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229900AbhFVLD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 07:03:27 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15MAYPVe098323;
        Tue, 22 Jun 2021 07:00:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=9nHUOsGnQ4ITyyoVw8BZrQaCw6OVDI7T1vsgnDQpwCg=;
 b=hL/Ll5jjmLIXyBzOCcu+P0jb5A1OaXkC3i6HiaWiw3fYixTg7ewley7sQ0PB8lK6Gigz
 sCCU5AO9oy6FqE+U2B+2EowW2WFnx9bX8Y1wCMGBnxo2jJg4oJs4IwG25RifbrtxXQ1Y
 VTQ+4hOC5bidm9WLyr83Yeb5Kn7dWXo2/nSlZrPji5TYqqi8eCHnasrrn3LMrxsOZ9NI
 XsB3G8zXI+LIxthlGsSKai4riQW6ukmmx7pP/budGihyoS1fhOWebUTeRa5obNdoWHNa
 fATkk80KCjVcLRi1uTlOZtJA+ngpsR1sSMiSAyKhsxvJmle70cnHMecf2Y58y6++sUB+ Pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39bct1kef8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 07:00:45 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15MAZGk0102561;
        Tue, 22 Jun 2021 07:00:44 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39bct1ked4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 07:00:44 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15MB0g54030094;
        Tue, 22 Jun 2021 11:00:42 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3998788scd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 11:00:41 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15MB0d4S18022790
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 11:00:39 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E30E4C063;
        Tue, 22 Jun 2021 11:00:39 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7C3F94C052;
        Tue, 22 Jun 2021 11:00:31 +0000 (GMT)
Received: from bangoria.ibmuc.com (unknown [9.199.39.114])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Jun 2021 11:00:31 +0000 (GMT)
From:   Ravi Bangoria <ravi.bangoria@linux.ibm.com>
To:     ast@kernel.org
Cc:     ravi.bangoria@linux.ibm.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, daniel@iogearbox.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, naveen.n.rao@linux.vnet.ibm.com
Subject: [PATCH] x86 bpf: Fix extable offset calculation
Date:   Tue, 22 Jun 2021 16:30:26 +0530
Message-Id: <20210622110026.1157847-1-ravi.bangoria@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <CAADnVQJux+8n-vpuK9FqTLuj4cXrp04pGkpvKaUdAPXLQ4c-PQ@mail.gmail.com>
References: <CAADnVQJux+8n-vpuK9FqTLuj4cXrp04pGkpvKaUdAPXLQ4c-PQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: m5cZHEWeG_2oqjpn46IGUBN2XvLtFzNO
X-Proofpoint-ORIG-GUID: 9Qn6mGwQMYpKccXinhBoUQTuOf87DwyJ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-22_05:2021-06-21,2021-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 priorityscore=1501 impostorscore=0 clxscore=1011 phishscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106220067
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 4c5de127598e1 ("bpf: Emit explicit NULL pointer checks
for PROBE_LDX instructions.") is emitting couple of instructions
before actual load. Consider those additional instructions while
calculating extable offset.

Fixes: 4c5de127598e1 ("bpf: Emit explicit NULL pointer checks for PROBE_LDX instructions.")
Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
---
 arch/x86/net/bpf_jit_comp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 2a2e290fa5d8..231a8178cc11 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1297,7 +1297,7 @@ st:			if (is_imm8(insn->off))
 			emit_ldx(&prog, BPF_SIZE(insn->code), dst_reg, src_reg, insn->off);
 			if (BPF_MODE(insn->code) == BPF_PROBE_MEM) {
 				struct exception_table_entry *ex;
-				u8 *_insn = image + proglen;
+				u8 *_insn = image + proglen + (u8)(start_of_ldx - temp);
 				s64 delta;
 
 				/* populate jmp_offset for JMP above */
-- 
2.30.2

