Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6255469E2
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 17:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345112AbiFJP4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 11:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243656AbiFJP4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 11:56:40 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 179C6344FE8;
        Fri, 10 Jun 2022 08:56:37 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25ADgdQU000459;
        Fri, 10 Jun 2022 15:56:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=f+2+C36wMDbP1Lz6kw2wjIMFQljszvrYMVi61I/EaUA=;
 b=FWmKbiDJd2hMIVcRSAsC4RD99mvXZTnqbEz0n2BOVOW0ojB61vc4GTIFJIYDafVpX4Hm
 6rifSTp8zRCEm69RvTlKjWLfdilvBGOYNXx/+FTDHEiULdoju1GHNiZqC0EPBiECGIjP
 C8bCX9OJ2EZjVXC4nFxxYv0GZTlZlDripJBDmEz8ypKXN9blux203jCs8wyYBUfOJ6iI
 XY4CXxq3RBmUaPsazgtGUuOHCIFFdRDjpuW/jICrxdb0oqAZGZ5sSyzEAlg1CV25oKu3
 c7UVS/poNClquXL1pWk5yYiu8DpV3rs0j4tWxuCgVjj1x1ZiFex+D6Pw0uyMBBwtpxWq Mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gm72vtmpb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Jun 2022 15:56:02 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25AFu1c1008835;
        Fri, 10 Jun 2022 15:56:02 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gm72vtmnj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Jun 2022 15:56:01 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25AFq2XM015689;
        Fri, 10 Jun 2022 15:55:59 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3gfy196n47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Jun 2022 15:55:59 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25AFtZMc22020402
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jun 2022 15:55:35 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F09834C046;
        Fri, 10 Jun 2022 15:55:56 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A6294C040;
        Fri, 10 Jun 2022 15:55:53 +0000 (GMT)
Received: from hbathini-workstation.in.ibm.com (unknown [9.203.106.231])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 10 Jun 2022 15:55:53 +0000 (GMT)
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
        Jordan Niethe <jniethe5@gmail.com>,
        Russell Currey <ruscur@russell.cc>
Subject: [PATCH v2 0/5] Atomics support for eBPF on powerpc
Date:   Fri, 10 Jun 2022 21:25:47 +0530
Message-Id: <20220610155552.25892-1-hbathini@linux.ibm.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: aemJ9QPeFSbAkEg-8m6HjSLmexGHySvC
X-Proofpoint-GUID: 9KDPoPBpEuTS3D55lso3y3lSDnxBOj3a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-10_06,2022-06-09_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 clxscore=1011
 priorityscore=1501 mlxlogscore=999 mlxscore=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2204290000 definitions=main-2206100061
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds atomic operations to the eBPF instruction set on
powerpc. The instructions that are added here can be summarised with
this list of kernel operations for ppc64:

* atomic[64]_[fetch_]add
* atomic[64]_[fetch_]and
* atomic[64]_[fetch_]or
* atomic[64]_[fetch_]xor
* atomic[64]_xchg
* atomic[64]_cmpxchg

and this list of kernel operations for ppc32:

* atomic_[fetch_]add
* atomic_[fetch_]and
* atomic_[fetch_]or
* atomic_[fetch_]xor
* atomic_xchg
* atomic_cmpxchg

The following are left out of scope for this effort:

* 64 bit operations on ppc32.
* Explicit memory barriers, 16 and 8 bit operations on both ppc32
  & ppc64.

The first patch adds support for bitwsie atomic operations on ppc64.
The next patch adds fetch variant support for these instructions. The
third patch adds support for xchg and cmpxchg atomic operations on
ppc64. Patch #4 adds support for 32-bit atomic bitwise operations on
ppc32. patch #5 adds support for xchg and cmpxchg atomic operations
on ppc32.

Validated these changes successfully with atomics test cases in
test_bpf testsuite and  test_verifier & test_progs selftests.
With test_bpf testsuite:

  all 147 atomics related test cases (both 32-bit & 64-bit) JIT'ed
  successfully on ppc64:

    test_bpf: Summary: 1026 PASSED, 0 FAILED, [1014/1014 JIT'ed]

  all 76 atomics related test cases (32-bit) JIT'ed successfully
  on ppc32:

    test_bpf: Summary: 1027 PASSED, 0 FAILED, [915/1015 JIT'ed]

Changes in v2:
* Moved variable declaration to avoid late declaration error on
  some compilers. Thanks to Russell for pointing this out.
* For ppc64, added an optimization for 32-bit cmpxchg with regard
  to commit 39491867ace5.
* For ppc32, used an additional register (BPF_REG_AX):
    - to avoid clobbering src_reg.
    - to keep the lwarx reservation as intended.
    - to avoid the odd switch/goto construct.
* For ppc32, zero'ed out the higher 32-bit explicitly when required.


Hari Bathini (5):
  bpf ppc64: add support for BPF_ATOMIC bitwise operations
  bpf ppc64: add support for atomic fetch operations
  bpf ppc64: Add instructions for atomic_[cmp]xchg
  bpf ppc32: add support for BPF_ATOMIC bitwise operations
  bpf ppc32: Add instructions for atomic_[cmp]xchg

 arch/powerpc/net/bpf_jit_comp32.c | 72 +++++++++++++++++++----
 arch/powerpc/net/bpf_jit_comp64.c | 96 ++++++++++++++++++++++---------
 2 files changed, 129 insertions(+), 39 deletions(-)

-- 
2.35.3

