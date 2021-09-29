Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8296341C349
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 13:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245611AbhI2LVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 07:21:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44020 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231859AbhI2LV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 07:21:29 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18TA4qrk030673;
        Wed, 29 Sep 2021 07:19:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=ZWpHIqp5l0j8Ky+IoPtjh0WeLQd6iPeLN2HuHiozjH4=;
 b=CgB3sn9JzEY2JvS/zrOLmsxoqm82jhxlcsljeA4eR9j5qZquWn/G+uMwD07QOhGSwGFj
 LwNrPRZ0jX11b5GP9tFwXJb7AHkVt6S+3Gure8E/x0wrlMJmn7ZEMVuPa1BkC8Yc3k1V
 zoQDa4Fayw14nG2j6WOqCoUA2STkHFYlk8aZzaFs/hCoOmPb3SthuJK99u0W75O18A3Y
 QTAGW8MRPHbzUXXszKVlRerI4iEzJ0X1Sxhx2kHdS8XEqyVPuH07DM+8XQEinFs9uZqi
 VW16ot1iDvkrSDHqYVf/9N/uJTT55kGCCd6gGWLPDHmrtPYrQHwhsL0yHJbgpnBN7vry BQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bcp2w1ejc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Sep 2021 07:19:11 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18TB6O6G009171;
        Wed, 29 Sep 2021 07:19:11 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bcp2w1ej1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Sep 2021 07:19:11 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18TBC0rm024826;
        Wed, 29 Sep 2021 11:19:09 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3b9uda55kh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Sep 2021 11:19:09 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18TBJ5NH37421448
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 11:19:05 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C80442072;
        Wed, 29 Sep 2021 11:19:05 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8552B42070;
        Wed, 29 Sep 2021 11:19:00 +0000 (GMT)
Received: from hbathini-workstation.ibm.com.com (unknown [9.43.83.199])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 29 Sep 2021 11:19:00 +0000 (GMT)
From:   Hari Bathini <hbathini@linux.ibm.com>
To:     naveen.n.rao@linux.ibm.com, christophe.leroy@csgroup.eu,
        mpe@ellerman.id.au, ast@kernel.org, daniel@iogearbox.net
Cc:     paulus@samba.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Hari Bathini <hbathini@linux.ibm.com>
Subject: [PATCH v4 0/8] bpf powerpc: Add BPF_PROBE_MEM support in powerpc JIT compiler
Date:   Wed, 29 Sep 2021 16:48:47 +0530
Message-Id: <20210929111855.50254-1-hbathini@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3mklSmZIKOAObbZQf-F4yNRi-6FsQX9j
X-Proofpoint-ORIG-GUID: 1qANcUD5KHoFXfvMlJ2b909Vrl8cbcyV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-29_04,2021-09-29_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 phishscore=0 priorityscore=1501 adultscore=0 suspectscore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 mlxlogscore=867 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109290068
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch #1 & #2 are simple cleanup patches. Patch #3 refactors JIT
compiler code with the aim to simplify adding BPF_PROBE_MEM support.
Patch #4 introduces PPC_RAW_BRANCH() macro instead of open coding
branch instruction. Patch #5 & #7 add BPF_PROBE_MEM support for PPC64
& PPC32 JIT compilers respectively. Patch #6 & #8 handle bad userspace
pointers for PPC64 & PPC32 cases respectively.

Changes in v4:
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
 arch/powerpc/net/bpf_jit_comp.c       |  72 ++++++++++++++++--
 arch/powerpc/net/bpf_jit_comp32.c     | 101 ++++++++++++++++++++++----
 arch/powerpc/net/bpf_jit_comp64.c     |  72 ++++++++++++++----
 5 files changed, 224 insertions(+), 42 deletions(-)

-- 
2.31.1

