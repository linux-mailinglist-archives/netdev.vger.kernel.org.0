Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3E45E57C
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 15:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbfGCN2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 09:28:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13298 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726760AbfGCN2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 09:28:17 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x63DS9RB121008
        for <netdev@vger.kernel.org>; Wed, 3 Jul 2019 09:28:16 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tguuc3ud0-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 09:28:11 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Wed, 3 Jul 2019 14:27:34 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 3 Jul 2019 14:27:31 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x63DRUFr6684844
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Jul 2019 13:27:30 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1DBC4C052;
        Wed,  3 Jul 2019 13:27:29 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B81784C04E;
        Wed,  3 Jul 2019 13:27:29 +0000 (GMT)
Received: from white.boeblingen.de.ibm.com (unknown [9.152.98.248])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  3 Jul 2019 13:27:29 +0000 (GMT)
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, ys114321@gmail.com,
        daniel@iogearbox.net
Cc:     Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v2 bpf-next 1/4] selftests/bpf: compile progs with -D__TARGET_ARCH_$(ARCH)
Date:   Wed,  3 Jul 2019 15:27:08 +0200
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190703132711.57169-1-iii@linux.ibm.com>
References: <20190703132711.57169-1-iii@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19070313-4275-0000-0000-00000348B565
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19070313-4276-0000-0000-00003858D13E
Message-Id: <20190703132711.57169-2-iii@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-03_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=566 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907030164
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
index de1754a8f5fe..3bba232e4d31 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
+include ../../../scripts/Makefile.arch
 
 LIBDIR := ../../../lib
 BPFDIR := $(LIBDIR)/bpf
@@ -137,7 +138,8 @@ CLANG_SYS_INCLUDES := $(shell $(CLANG) -v -E - </dev/null 2>&1 \
 
 CLANG_FLAGS = -I. -I./include/uapi -I../../../include/uapi \
 	      $(CLANG_SYS_INCLUDES) \
-	      -Wno-compare-distinct-pointer-types
+	      -Wno-compare-distinct-pointer-types \
+	      -D__TARGET_ARCH_$(ARCH)
 
 $(OUTPUT)/test_l4lb_noinline.o: CLANG_FLAGS += -fno-inline
 $(OUTPUT)/test_xdp_noinline.o: CLANG_FLAGS += -fno-inline
-- 
2.21.0

