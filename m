Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA4E52B7CFD
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 12:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727897AbgKRLom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 06:44:42 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:22748 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726385AbgKRLom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 06:44:42 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AIBf5WF017721;
        Wed, 18 Nov 2020 03:44:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=gZr7hTHbueNB7KsMVBK82bpeQXT3kl3WuuJRjYC920s=;
 b=aNe+o92e0o8I5XJMiFoUJAPU/JNYKzZsHw38IlhvtWkOpwFfyOi9+BsVl0NXDxAa2ga0
 90GiyXCKtnRPjxUqj/8bNLNtl1JcCWzbF2cA/Ot+2FRP4s59qvMTBO+WJz/Wyo/1zjPD
 GgpO+yRsbDesnZxyFWzNdV49GjmL6CowKiWJkq0RGTtMwJA8X456SQgy+z2SmXNOoyTV
 IxjjuSOsSGlJAAYv8drfoeYdNk3xLeq7jUrBGqhPMWlf0OAhV/my6HUdlCL8rabClRLC
 quYhMsGXImMyxypJMqvDyS7LX7d3r+EHWLAKTU4Y4GCGQn42HZUZIBKYsbPO+++DQowy EQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 34tfmsn891-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 18 Nov 2020 03:44:35 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Nov
 2020 03:44:33 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 18 Nov 2020 03:44:33 -0800
Received: from hyd1schalla-dt.marvell.com (hyd1schalla-dt.marvell.com [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id 94DA03F703F;
        Wed, 18 Nov 2020 03:44:30 -0800 (PST)
From:   Srujana Challa <schalla@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <herbert@gondor.apana.org.au>,
        <kuba@kernel.org>, <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>, Srujana Challa <schalla@marvell.com>
Subject: [PATCH v10,net-next,1/3] octeontx2-pf: move lmt flush to include/linux/soc
Date:   Wed, 18 Nov 2020 17:14:14 +0530
Message-ID: <20201118114416.28307-2-schalla@marvell.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20201118114416.28307-1-schalla@marvell.com>
References: <20201118114416.28307-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-18_04:2020-11-17,2020-11-18 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On OcteonTX2 platform CPT instruction enqueue and NIX
packet send are only possible via LMTST operations which
uses LDEOR instruction. This patch moves lmt flush
function from OcteonTX2 nic driver to include/linux/soc
since it will be used by OcteonTX2 CPT and NIC driver for
LMTST.

Signed-off-by: Suheil Chandran <schandran@marvell.com>
Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 MAINTAINERS                                   |  2 ++
 .../marvell/octeontx2/nic/otx2_common.h       | 13 +--------
 include/linux/soc/marvell/octeontx2/asm.h     | 29 +++++++++++++++++++
 3 files changed, 32 insertions(+), 12 deletions(-)
 create mode 100644 include/linux/soc/marvell/octeontx2/asm.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 3341959af0c7..0169168dcd59 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10470,6 +10470,7 @@ M:	Srujana Challa <schalla@marvell.com>
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
 F:	drivers/crypto/marvell/
+F:	include/linux/soc/marvell/octeontx2/
 
 MARVELL GIGABIT ETHERNET DRIVERS (skge/sky2)
 M:	Mirko Lindner <mlindner@marvell.com>
@@ -10542,6 +10543,7 @@ M:	hariprasad <hkelam@marvell.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/marvell/octeontx2/nic/
+F:	include/linux/soc/marvell/octeontx2/
 
 MARVELL OCTEONTX2 RVU ADMIN FUNCTION DRIVER
 M:	Sunil Goutham <sgoutham@marvell.com>
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index b18b45d02165..ceec649bdd13 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -16,6 +16,7 @@
 #include <linux/net_tstamp.h>
 #include <linux/ptp_clock_kernel.h>
 #include <linux/timecounter.h>
+#include <linux/soc/marvell/octeontx2/asm.h>
 
 #include <mbox.h>
 #include <npc.h>
@@ -462,21 +463,9 @@ static inline u64 otx2_atomic64_add(u64 incr, u64 *ptr)
 	return result;
 }
 
-static inline u64 otx2_lmt_flush(uint64_t addr)
-{
-	u64 result = 0;
-
-	__asm__ volatile(".cpu  generic+lse\n"
-			 "ldeor xzr,%x[rf],[%[rs]]"
-			 : [rf]"=r"(result)
-			 : [rs]"r"(addr));
-	return result;
-}
-
 #else
 #define otx2_write128(lo, hi, addr)
 #define otx2_atomic64_add(incr, ptr)		({ *ptr += incr; })
-#define otx2_lmt_flush(addr)			({ 0; })
 #endif
 
 /* Alloc pointer from pool/aura */
diff --git a/include/linux/soc/marvell/octeontx2/asm.h b/include/linux/soc/marvell/octeontx2/asm.h
new file mode 100644
index 000000000000..ae2279fe830a
--- /dev/null
+++ b/include/linux/soc/marvell/octeontx2/asm.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ * Copyright (C) 2020 Marvell.
+ */
+
+#ifndef __SOC_OTX2_ASM_H
+#define __SOC_OTX2_ASM_H
+
+#if defined(CONFIG_ARM64)
+/*
+ * otx2_lmt_flush is used for LMT store operation.
+ * On octeontx2 platform CPT instruction enqueue and
+ * NIX packet send are only possible via LMTST
+ * operations and it uses LDEOR instruction targeting
+ * the coprocessor address.
+ */
+#define otx2_lmt_flush(ioaddr)                          \
+({                                                      \
+	u64 result = 0;                                 \
+	__asm__ volatile(".cpu  generic+lse\n"          \
+			 "ldeor xzr, %x[rf], [%[rs]]"   \
+			 : [rf]"=r" (result)            \
+			 : [rs]"r" (ioaddr));           \
+	(result);                                       \
+})
+#else
+#define otx2_lmt_flush(ioaddr)          ({ 0; })
+#endif
+
+#endif /* __SOC_OTX2_ASM_H */
-- 
2.29.0

