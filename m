Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6334040FC65
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 17:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239439AbhIQPdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 11:33:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45550 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234080AbhIQPdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 11:33:17 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18HEx3Tp001646;
        Fri, 17 Sep 2021 11:31:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=Wcxa0KaGI3+VtVzU9bMJvtplPPj38p/AZ9sWvP2LaaA=;
 b=SeHSPxLe0c+WiwDwR9cHvDvMVcCS92PNAOJDyYAlWQadv1GipZrf+u5KVK6M0WHYqgah
 9aHVmj+vBeug4Gv/OT9P5VV1Qm2FWdPsMCRI8AcAkMsuFf0ZBHHLVY9h6sss4ZWAzbM4
 t2cyHEPz1kLpr+pxYejPGsVRg/Me9fYlMeRMHu6a0HXuF/GUEQUEk+EuROfUSu08cJ3t
 ClDbs2WSnvxVOQtaB2yctJSohhBS2fI9NMVNMi0fuo0r4lGufbrDObEWEFjiWZ6Yev0Z
 eSMjZCswsUVzDxsXH5vjHN6DB3X9RIbhG8Y7DPDCa1xBYtM7araFa3fTTr4ETpwRHmkv 6g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b4hdd9r27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 11:31:19 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18HEx9Sk002296;
        Fri, 17 Sep 2021 11:31:19 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b4hdd9r15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 11:31:19 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18HFH42Z013864;
        Fri, 17 Sep 2021 15:31:16 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3b0m3ag6u5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 15:31:16 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18HFVCRr54591906
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Sep 2021 15:31:12 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4187511C06C;
        Fri, 17 Sep 2021 15:31:12 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 788DC11C04A;
        Fri, 17 Sep 2021 15:31:07 +0000 (GMT)
Received: from hbathini-workstation.ibm.com (unknown [9.43.59.213])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 17 Sep 2021 15:31:07 +0000 (GMT)
From:   Hari Bathini <hbathini@linux.ibm.com>
To:     naveen.n.rao@linux.ibm.com, mpe@ellerman.id.au, ast@kernel.org,
        daniel@iogearbox.net
Cc:     christophe.leroy@csgroup.eu, paulus@samba.org, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Hari Bathini <hbathini@linux.ibm.com>
Subject: [PATCH v2 0/8] bpf powerpc: Add BPF_PROBE_MEM support in powerpc JIT compiler
Date:   Fri, 17 Sep 2021 21:00:39 +0530
Message-Id: <20210917153047.177141-1-hbathini@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NiwdhFSYJvedcjoihbSDQzv5XnVuCFni
X-Proofpoint-ORIG-GUID: LWn4aa2SqR6BQP7g4gyz-k1qnP4GEIsV
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-17_06,2021-09-17_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 priorityscore=1501 suspectscore=0 adultscore=0 bulkscore=0 mlxscore=0
 impostorscore=0 mlxlogscore=655 malwarescore=0 lowpriorityscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109170096
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch #1 & #2 are simple cleanup patches. Patch #3 refactors JIT
compiler code with the aim to simplify adding BPF_PROBE_MEM support.
Patch #4 introduces PPC_RAW_BRANCH() macro instead of open coding
branch instruction. Patch #5 & #7 add BPF_PROBE_MEM support for PPC64
& PPC32 JIT compilers respectively. Patch #6 & #8 add explicit
addr > TASK_SIZE_MAX check to handle bad userspace pointers for
PPC64 & PPC32 cases respectively.

Link to v1 posted by Ravi:

  https://lore.kernel.org/all/20210706073211.349889-1-ravi.bangoria@linux.ibm.com/
  ("[PATCH 0/4] bpf powerpc: Add BPF_PROBE_MEM support for 64bit JIT")


Hari Bathini (4):
  bpf powerpc: refactor JIT compiler code
  powerpc/ppc-opcode: introduce PPC_RAW_BRANCH() macro
  bpf ppc32: Add BPF_PROBE_MEM support for JIT
  bpf ppc32: Add addr > TASK_SIZE_MAX explicit check

Ravi Bangoria (4):
  bpf powerpc: Remove unused SEEN_STACK
  bpf powerpc: Remove extra_pass from bpf_jit_build_body()
  bpf ppc64: Add BPF_PROBE_MEM support for JIT
  bpf ppc64: Add addr > TASK_SIZE_MAX explicit check

 arch/powerpc/include/asm/ppc-opcode.h |   2 +
 arch/powerpc/net/bpf_jit.h            |  19 ++--
 arch/powerpc/net/bpf_jit_comp.c       |  75 ++++++++++++++--
 arch/powerpc/net/bpf_jit_comp32.c     | 123 +++++++++++++++++++++-----
 arch/powerpc/net/bpf_jit_comp64.c     | 114 ++++++++++++++++--------
 5 files changed, 260 insertions(+), 73 deletions(-)

-- 
2.31.1

