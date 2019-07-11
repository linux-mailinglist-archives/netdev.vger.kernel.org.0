Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD9465901
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 16:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728914AbfGKOaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 10:30:10 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10332 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726016AbfGKOaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 10:30:09 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6BETOjC059140
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 10:30:08 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tp5qbm1jx-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 10:30:07 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Thu, 11 Jul 2019 15:30:05 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 11 Jul 2019 15:30:01 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6BEU0K441026016
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 14:30:00 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C51954203F;
        Thu, 11 Jul 2019 14:30:00 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7AE9242042;
        Thu, 11 Jul 2019 14:30:00 +0000 (GMT)
Received: from white.boeblingen.de.ibm.com (unknown [9.152.97.237])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 11 Jul 2019 14:30:00 +0000 (GMT)
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     ys114321@gmail.com, daniel@iogearbox.net, sdf@fomichev.me,
        davem@davemloft.net, ast@kernel.org,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v4 bpf-next 1/4] selftests/bpf: compile progs with -D__TARGET_ARCH_$(SRCARCH)
Date:   Thu, 11 Jul 2019 16:29:27 +0200
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190711142930.68809-1-iii@linux.ibm.com>
References: <20190711142930.68809-1-iii@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19071114-0020-0000-0000-00000352D353
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071114-0021-0000-0000-000021A68D9F
Message-Id: <20190711142930.68809-2-iii@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-11_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=550 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907110163
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This opens up the possibility of accessing registers in an
arch-independent way.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
---
 tools/testing/selftests/bpf/Makefile | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 2620406a53ec..ad84450e4ab8 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
+include ../../../scripts/Makefile.arch
 
 LIBDIR := ../../../lib
 BPFDIR := $(LIBDIR)/bpf
@@ -138,7 +139,8 @@ CLANG_SYS_INCLUDES := $(shell $(CLANG) -v -E - </dev/null 2>&1 \
 
 CLANG_FLAGS = -I. -I./include/uapi -I../../../include/uapi \
 	      $(CLANG_SYS_INCLUDES) \
-	      -Wno-compare-distinct-pointer-types
+	      -Wno-compare-distinct-pointer-types \
+	      -D__TARGET_ARCH_$(SRCARCH)
 
 $(OUTPUT)/test_l4lb_noinline.o: CLANG_FLAGS += -fno-inline
 $(OUTPUT)/test_xdp_noinline.o: CLANG_FLAGS += -fno-inline
-- 
2.21.0

