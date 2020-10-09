Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5405F288CCC
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 17:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389308AbgJIPe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 11:34:59 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:18802 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389252AbgJIPe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 11:34:59 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 099FUPDI019606;
        Fri, 9 Oct 2020 08:34:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=MharBup91CZHNOZxGep4IoLgVXRoflqRzhC3qmkMnGg=;
 b=DgCwK5pousNbtHbkUzqtO9Bn0/nSZrWi540rrV/kWmAUTmiE+Pw2AOdVzhtUAeLv8wT8
 d8sg7IuIeTnkenlB++2tZ+LkfWmwFDb1+qVmEVqkK7oedrla4GlP/TZG9kiGU+9V9Ktz
 3FageGGryLfXKgm4+AUUBvXxokbcHzHRQcxTW1dJlZTOZLM1fH3ZioQ+Y0+yWGvulp5I
 alx2fpDZGri4AoEYwTHiHxN8/5Gl4wfA57Ax9974X+QaH8x1Av5MDuIBTxowLFW/S+p4
 WvBGcbZHbKzVuF/GIqT3jqDcslem0U2Bjt72z1WDRuVwhE739WTdlYMsKU4vzZAyQBy/ nQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3429h8bbsn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 09 Oct 2020 08:34:52 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Oct
 2020 08:34:51 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 9 Oct 2020 08:34:51 -0700
Received: from hyd1schalla-dt.marvell.com (hyd1schalla-dt.marvell.com [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id CB17C3F703F;
        Fri,  9 Oct 2020 08:34:47 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <kuba@kernel.org>, <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>, Srujana Challa <schalla@marvell.com>
Subject: [PATCH v4,net-next,01/13] octeontx2-pf: move lmt flush to include/linux/soc
Date:   Fri, 9 Oct 2020 21:04:09 +0530
Message-ID: <20201009153421.30562-2-schalla@marvell.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201009153421.30562-1-schalla@marvell.com>
References: <20201009153421.30562-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-09_06:2020-10-09,2020-10-09 signatures=0
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
index c99577961cc4..80fdfeb7f750 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10431,6 +10431,7 @@ M:	Srujana Challa <schalla@marvell.com>
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
 F:	drivers/crypto/marvell/
+F:	include/linux/soc/marvell/octeontx2/
 
 MARVELL GIGABIT ETHERNET DRIVERS (skge/sky2)
 M:	Mirko Lindner <mlindner@marvell.com>
@@ -10503,6 +10504,7 @@ M:	hariprasad <hkelam@marvell.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/marvell/octeontx2/nic/
+F:	include/linux/soc/marvell/octeontx2/
 
 MARVELL OCTEONTX2 RVU ADMIN FUNCTION DRIVER
 M:	Sunil Goutham <sgoutham@marvell.com>
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index ac47762cce9b..12311964d9d6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -16,6 +16,7 @@
 #include <linux/net_tstamp.h>
 #include <linux/ptp_clock_kernel.h>
 #include <linux/timecounter.h>
+#include <linux/soc/marvell/octeontx2/asm.h>
 
 #include <mbox.h>
 #include "otx2_reg.h"
@@ -420,21 +421,9 @@ static inline u64 otx2_atomic64_add(u64 incr, u64 *ptr)
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
2.28.0

