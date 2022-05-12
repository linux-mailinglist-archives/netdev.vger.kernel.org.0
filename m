Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C149C524743
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 09:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351086AbiELHqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 03:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351132AbiELHqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 03:46:49 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305E148E45;
        Thu, 12 May 2022 00:46:48 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24C3saF9023733;
        Thu, 12 May 2022 07:46:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=u/HX+YIQDemSbo0tofUx+It043BrUiawINxAJnsesf0=;
 b=EUPTfN/Qwj6fXPZuHJ7NxzBywDvwNAm5f/pNKgPvL1/uhB+nybwvpgIgJ6mpsYidM9kG
 D2z8qye3q1yvA8wsTvGHX2Lf9F1XjO8xE3SWB53nixSbHDic9VWC3ibLR6lALoIJR5Kr
 HVG2wB3NJJjwvNkAmP+lxUaOGRXoISRBb8MItIOJXaKX+iq7YuHdFotJzhydRNd7hwnL
 +mEVhzfsqgT54PuZn0JIDDyR/QG6PHwMj73TB8wvsQAgp9YuTZ2wI5ulyrM5sSxFZHOt
 3T1NZrggfjvTsZdPtsQKJ9e1Ac9zErFn1pIScWewZQlu8ZDnlcr54rW91BYpQOQhbmd/ ZA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0tre3rga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 07:46:03 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24C7YXou012661;
        Thu, 12 May 2022 07:46:02 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0tre3rfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 07:46:02 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24C7bbh7015479;
        Thu, 12 May 2022 07:45:59 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3g0kn78h57-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 07:45:59 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24C7jun936962584
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 07:45:57 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA89CA4055;
        Thu, 12 May 2022 07:45:56 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4873A404D;
        Thu, 12 May 2022 07:45:48 +0000 (GMT)
Received: from hbathini-workstation.ibm.com.com (unknown [9.211.109.30])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 May 2022 07:45:48 +0000 (GMT)
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
        Jordan Niethe <jniethe5@gmail.com>
Subject: [PATCH 0/5] Atomics support for eBPF on powerpc
Date:   Thu, 12 May 2022 13:15:41 +0530
Message-Id: <20220512074546.231616-1-hbathini@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: omjGLebeLYNhEoo0IG3X2s8bSLP1n9Eu
X-Proofpoint-ORIG-GUID: hSg7q-ZNvNhzsiuXlMeeVPo83_4_SAXe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-11_07,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 malwarescore=0 clxscore=1011 bulkscore=0 adultscore=0 mlxlogscore=683
 priorityscore=1501 suspectscore=0 phishscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205120034
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


Hari Bathini (5):
  bpf ppc64: add support for BPF_ATOMIC bitwise operations
  bpf ppc64: add support for atomic fetch operations
  bpf ppc64: Add instructions for atomic_[cmp]xchg
  bpf ppc32: add support for BPF_ATOMIC bitwise operations
  bpf ppc32: Add instructions for atomic_[cmp]xchg

 arch/powerpc/net/bpf_jit_comp32.c | 62 +++++++++++++++++-----
 arch/powerpc/net/bpf_jit_comp64.c | 87 +++++++++++++++++++++----------
 2 files changed, 108 insertions(+), 41 deletions(-)

-- 
2.35.1

