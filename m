Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3E46413416
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 15:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233056AbhIUNcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 09:32:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7330 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233042AbhIUNcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 09:32:06 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18LChbhk022380;
        Tue, 21 Sep 2021 09:30:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=Nt/HW0BXDDaCR0QLrLIVHDX3SBFrj5Qpvinm39FfqT4=;
 b=e+lU10TfB8nWMuT2FBh7dH0XtoaO9P/xqQsmoInORRS3+vCX+CkS/uO1RrAw/VjdoXEp
 FUKG/SXspmQ0Y5i+yccsVwboU4Ap4TKK5wLGTA1jIYkreTejEJjQW+bZVScHf8JozSAl
 yZO/O4+KVZeSsyDA2bLavVqUAh9mUcB+V2d5Nrnpq9rgoOdKLCvl18HYFwmrU2W3FSb4
 rMN33UrsnpgW0FDtaJW9ZwYTJL+N55mXCSLgiG5pSRFcwkEYD6Ky6Rn+SXbONyp1z5IZ
 mpjkaLjfZQcEoJ8Uqy2cvCwTTzofyWCnaILwqSlVyHVpJjxxqfNF80ux0LWD2FMdHxHm xQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7fndh952-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 09:30:00 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18LCt4iL002156;
        Tue, 21 Sep 2021 09:29:58 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7fndh93c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 09:29:58 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18LDNEiR010765;
        Tue, 21 Sep 2021 13:29:55 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3b57cjnp50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 13:29:55 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18LDTpWx41746876
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Sep 2021 13:29:52 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B48BF4C071;
        Tue, 21 Sep 2021 13:29:51 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C65FE4C040;
        Tue, 21 Sep 2021 13:29:47 +0000 (GMT)
Received: from hbathini-workstation.ibm.com.com (unknown [9.43.117.91])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 21 Sep 2021 13:29:47 +0000 (GMT)
From:   Hari Bathini <hbathini@linux.ibm.com>
To:     naveen.n.rao@linux.ibm.com, christophe.leroy@csgroup.eu,
        mpe@ellerman.id.au, ast@kernel.org, daniel@iogearbox.net
Cc:     paulus@samba.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Hari Bathini <hbathini@linux.ibm.com>
Subject: [PATCH v3 0/8] bpf powerpc: Add BPF_PROBE_MEM support in powerpc JIT compiler
Date:   Tue, 21 Sep 2021 18:59:35 +0530
Message-Id: <20210921132943.489732-1-hbathini@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HqZUy-qa7iySiP65dyQqucNLU0GKMEbp
X-Proofpoint-ORIG-GUID: 2W1wYTfMEuVOz_p4ioiMYdP7Nab5betP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-21_01,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 clxscore=1015 spamscore=0 impostorscore=0 adultscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=883 malwarescore=0 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109210082
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch #1 & #2 are simple cleanup patches. Patch #3 refactors JIT
compiler code with the aim to simplify adding BPF_PROBE_MEM support.
Patch #4 introduces PPC_RAW_BRANCH() macro instead of open coding
branch instruction. Patch #5 & #7 add BPF_PROBE_MEM support for PPC64
& PPC32 JIT compilers respectively. Patch #6 & #8 handle bad userspace
pointers for PPC64 & PPC32 cases respectively.

Changes in v3:
* Addressed all the review comments from Christophe.

Hari Bathini (4):
  bpf powerpc: refactor JIT compiler code
  powerpc/ppc-opcode: introduce PPC_RAW_BRANCH() macro
  bpf ppc32: Add BPF_PROBE_MEM support for JIT
  bpf ppc32: Access only if addr is kernel address

Ravi Bangoria (4):
  bpf powerpc: Remove unused SEEN_STACK
  bpf powerpc: Remove extra_pass from bpf_jit_build_body()
  bpf ppc64: Add BPF_PROBE_MEM support for JIT
  bpf ppc64: Access only if addr is kernel address

 arch/powerpc/include/asm/ppc-opcode.h |   2 +
 arch/powerpc/net/bpf_jit.h            |  19 +++--
 arch/powerpc/net/bpf_jit_comp.c       |  72 ++++++++++++++--
 arch/powerpc/net/bpf_jit_comp32.c     | 115 ++++++++++++++++++++++----
 arch/powerpc/net/bpf_jit_comp64.c     |  88 ++++++++++++++++----
 5 files changed, 254 insertions(+), 42 deletions(-)

-- 
2.31.1

