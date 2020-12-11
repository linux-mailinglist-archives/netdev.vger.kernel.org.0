Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 464EB2D702B
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 07:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436500AbgLKG07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 01:26:59 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:35956 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390439AbgLKG0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 01:26:37 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BB6P8Wg004878;
        Thu, 10 Dec 2020 22:25:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=evAYFG9kHFC9v1umCoYWYwPgpQzenxuYrwG7jG0dTcg=;
 b=d/YP/LIEcp1iyxN5WSbBCbk1suze/J0W0GZLYTqXpjLm7hvSCWLoQ0ZOEkmlAfcN7YRM
 Cq43Yn7Gd0k9kKYexR177xcBCUkuc6MPo1+ovIc/VKQBfNq+G5P1bVgnr6NWcXGDOlk7
 KVcgL7cahOfyIbPzvk+uiKfTpJ66zMxdzWOwD6Eo8Johl8x8Zi8pRl2a/syhFmHhzGxL
 I3dm9g8IIcAL3FRGQIrQpitGkNSH4ZNEKzdcmT3kNH6kXxTW2J4HaYslnIRIAkydG5Ne
 MKtp6doxjcKducOo/+CLdqC3ULjJMT593FsyHCjdiF1G3cZwUmY29iX04oeIah8Z9YJ2 /Q== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 358akrhyvs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 22:25:52 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 10 Dec
 2020 22:25:50 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 10 Dec
 2020 22:25:49 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 10 Dec 2020 22:25:49 -0800
Received: from hyd1584.marvell.com (unknown [10.29.37.82])
        by maili.marvell.com (Postfix) with ESMTP id 69C163F703F;
        Thu, 10 Dec 2020 22:25:46 -0800 (PST)
From:   George Cherian <george.cherian@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <george.cherian@marvell.com>, <willemdebruijn.kernel@gmail.com>,
        <saeed@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH 3/3] docs: octeontx2: Add Documentation for NPA health reporters
Date:   Fri, 11 Dec 2020 11:55:26 +0530
Message-ID: <20201211062526.2302643-4-george.cherian@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201211062526.2302643-1-george.cherian@marvell.com>
References: <20201211062526.2302643-1-george.cherian@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-11_01:2020-12-09,2020-12-11 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Documentation for devlink health reporters for NPA block.

Signed-off-by: George Cherian <george.cherian@marvell.com>
---
 .../ethernet/marvell/octeontx2.rst            | 50 +++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst b/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
index 88f508338c5f..d3fcf536d14e 100644
--- a/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
+++ b/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
@@ -12,6 +12,7 @@ Contents
 - `Overview`_
 - `Drivers`_
 - `Basic packet flow`_
+- `Devlink health reporters`_
 
 Overview
 ========
@@ -157,3 +158,52 @@ Egress
 3. The SQ descriptor ring is maintained in buffers allocated from SQ mapped pool of NPA block LF.
 4. NIX block transmits the pkt on the designated channel.
 5. NPC MCAM entries can be installed to divert pkt onto a different channel.
+
+Devlink health reporters
+========================
+
+NPA Reporters
+-------------
+The NPA reporters are responsible for reporting and recovering the following group of errors
+1. GENERAL events
+   - Error due to operation of unmapped PF.
+   - Error due to disabled alloc/free for other HW blocks (NIX, SSO, TIM, DPI and AURA).
+2. ERROR events
+   - Fault due to NPA_AQ_INST_S read or NPA_AQ_RES_S write.
+   - AQ Doorbell Error.
+3. RAS events
+   - RAS Error Reporting for NPA_AQ_INST_S/NPA_AQ_RES_S.
+4. RVU events
+   - Error due to unmapped slot.
+
+Sample Output
+-------------
+~# devlink health
+pci/0002:01:00.0:
+  reporter hw_npa_intr
+      state healthy error 2872 recover 2872 last_dump_date 2020-12-10 last_dump_time 09:39:09 grace_period 0 auto_recover true auto_dump true
+  reporter hw_npa_gen
+      state healthy error 2872 recover 2872 last_dump_date 2020-12-11 last_dump_time 04:43:04 grace_period 0 auto_recover true auto_dump true
+  reporter hw_npa_err
+      state healthy error 2871 recover 2871 last_dump_date 2020-12-10 last_dump_time 09:39:17 grace_period 0 auto_recover true auto_dump true
+   reporter hw_npa_ras
+      state healthy error 0 recover 0 last_dump_date 2020-12-10 last_dump_time 09:32:40 grace_period 0 auto_recover true auto_dump true
+
+Each reporter dumps the
+ - Error Type
+ - Error Register value
+ - Reason in words
+
+For eg:
+~# devlink health dump show  pci/0002:01:00.0 reporter hw_npa_gen
+ NPA_AF_GENERAL:
+         NPA General Interrupt Reg : 1
+         NIX0: free disabled RX
+~# devlink health dump show  pci/0002:01:00.0 reporter hw_npa_intr
+ NPA_AF_RVU:
+         NPA RVU Interrupt Reg : 1
+         Unmap Slot Error
+~# devlink health dump show  pci/0002:01:00.0 reporter hw_npa_err
+ NPA_AF_ERR:
+        NPA Error Interrupt Reg : 4096
+        AQ Doorbell Error
-- 
2.25.1

