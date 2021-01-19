Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6FE42FB8D0
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 15:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394769AbhASNsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 08:48:35 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:53624 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389322AbhASKCd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 05:02:33 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10JA0JM7030222;
        Tue, 19 Jan 2021 02:01:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=5GgxiZeK4y1PapAD+Qbjvma7e7RoVRAtuInKsq8JrLg=;
 b=TZcWJnm0NjAXB0qer3R8obx6emkqtzKv4nbxqrveSrr9yfB6pLrCDNYRlOI6rut9ZXm+
 8Gu1IoMCTkHAEHVLa/HnoX5EhejCekX9OQqapG6jA9mHOxym1FmWUgpp+vr6AUcp4zEP
 Kg10Cs509v8lkigiyIXzPKwudy66LunRgRewtqOKAQWSYkxN0+vPxvxZ0SAImgCRgjbH
 vVDwRlPqFRTwANYjotl0l1Z0yf7ioExCsnLEVX2tSKm6bmJTqe2Z7pzr0uCvLlywxBP4
 O9jnhy+9dkOdjHHKbif26y+wpvk4zCxEyA96lr2D1MOvoStPWra3bOXa/ZyjXLXMmc9y Nw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 363xcue7uj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 02:01:33 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 19 Jan
 2021 02:01:32 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 19 Jan
 2021 02:01:31 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 19 Jan 2021 02:01:31 -0800
Received: from hyd1584.marvell.com (unknown [10.29.37.82])
        by maili.marvell.com (Postfix) with ESMTP id B3C543F703F;
        Tue, 19 Jan 2021 02:01:28 -0800 (PST)
From:   George Cherian <george.cherian@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <george.cherian@marvell.com>, <corbet@lwn.net>
Subject: [PATCH net-next 2/2] docs: octeontx2: Add Documentation for NIX health reporters
Date:   Tue, 19 Jan 2021 15:31:20 +0530
Message-ID: <20210119100120.2614730-3-george.cherian@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210119100120.2614730-1-george.cherian@marvell.com>
References: <20210119100120.2614730-1-george.cherian@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-19_02:2021-01-18,2021-01-19 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add devlink health reporter documentation for NIX block.

Signed-off-by: George Cherian <george.cherian@marvell.com>
---
 .../ethernet/marvell/octeontx2.rst            | 70 +++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst b/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
index 61e850460e18..dd5cd69467be 100644
--- a/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
+++ b/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
@@ -217,3 +217,73 @@ For example::
 	 NPA_AF_ERR:
 	        NPA Error Interrupt Reg : 4096
 	        AQ Doorbell Error
+
+
+NIX Reporters
+-------------
+The NIX reporters are responsible for reporting and recovering the following group of errors:
+
+1. GENERAL events
+
+   - Receive mirror/multicast packet drop due to insufficient buffer.
+   - SMQ Flush operation.
+
+2. ERROR events
+
+   - Memory Fault due to WQE read/write from multicast/mirror buffer.
+   - Receive multicast/mirror replication list error.
+   - Receive packet on an unmapped PF.
+   - Fault due to NIX_AQ_INST_S read or NIX_AQ_RES_S write.
+   - AQ Doorbell Error.
+
+3. RAS events
+
+   - RAS Error Reporting for NIX Receive Multicast/Mirror Entry Structure.
+   - RAS Error Reporting for WQE/Packet Data read from Multicast/Mirror Buffer..
+   - RAS Error Reporting for NIX_AQ_INST_S/NIX_AQ_RES_S.
+
+4. RVU events
+
+   - Error due to unmapped slot.
+
+Sample Output::
+
+	~# ./devlink health
+	pci/0002:01:00.0:
+	  reporter hw_npa_intr
+	    state healthy error 0 recover 0 grace_period 0 auto_recover true auto_dump true
+	  reporter hw_npa_gen
+	    state healthy error 0 recover 0 grace_period 0 auto_recover true auto_dump true
+	  reporter hw_npa_err
+	    state healthy error 0 recover 0 grace_period 0 auto_recover true auto_dump true
+	  reporter hw_npa_ras
+	    state healthy error 0 recover 0 grace_period 0 auto_recover true auto_dump true
+	  reporter hw_nix_intr
+	    state healthy error 1121 recover 1121 last_dump_date 2021-01-19 last_dump_time 05:42:26 grace_period 0 auto_recover true auto_dump true
+	  reporter hw_nix_gen
+	    state healthy error 949 recover 949 last_dump_date 2021-01-19 last_dump_time 05:42:43 grace_period 0 auto_recover true auto_dump true
+	  reporter hw_nix_err
+	    state healthy error 1147 recover 1147 last_dump_date 2021-01-19 last_dump_time 05:42:59 grace_period 0 auto_recover true auto_dump true
+	  reporter hw_nix_ras
+	    state healthy error 409 recover 409 last_dump_date 2021-01-19 last_dump_time 05:43:16 grace_period 0 auto_recover true auto_dump true
+
+Each reporter dumps the
+
+ - Error Type
+ - Error Register value
+ - Reason in words
+
+For example::
+
+	~# devlink health dump show pci/0002:01:00.0 reporter hw_nix_intr
+	 NIX_AF_RVU:
+	        NIX RVU Interrupt Reg : 1
+	        Unmap Slot Error
+	~# devlink health dump show pci/0002:01:00.0 reporter hw_nix_gen
+	 NIX_AF_GENERAL:
+	        NIX General Interrupt Reg : 1
+	        Rx multicast pkt drop
+	~# devlink health dump show pci/0002:01:00.0 reporter hw_nix_err
+	 NIX_AF_ERR:
+	        NIX Error Interrupt Reg : 64
+	        Rx on unmapped PF_FUNC
-- 
2.25.1

