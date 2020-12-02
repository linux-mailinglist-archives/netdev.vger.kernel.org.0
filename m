Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 988E42CC205
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 17:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389116AbgLBQTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 11:19:04 -0500
Received: from mx0a-00154904.pphosted.com ([148.163.133.20]:56372 "EHLO
        mx0a-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728503AbgLBQSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 11:18:48 -0500
Received: from pps.filterd (m0170391.ppops.net [127.0.0.1])
        by mx0a-00154904.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B2G1vFo013375;
        Wed, 2 Dec 2020 11:18:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=smtpout1;
 bh=LK3wlPcq02ms/q02UlZeAFuCGJqTAohQZjmc5EcmfFo=;
 b=dKZQ4XhonMuKGN6UX3xzFeiDqkUmwm3/d+0DgwAN3nApfb2ba5KY8l1sC4WaEHJmeYnz
 bj+8XIwJsjl/VUrHWHoOWe84hDxoYVK2QAkgzL3baW1wGkrANRoa+GdGIZOyJ/HABpDc
 bD63Xjso5yCSHUoWttTNs+mW0BHtNp3BPeJn4TUyeV3L9Ns80JHbTE+UgWNhiOpghkK3
 AV1IZwRPSEiJPPN0ctBe7TeR5U6f9wxiFt19q+Fc7fI65qIXdC8YBOYGsl1vKdxmcbdC
 KxHsjPeccR8xgoCVz5ta3NADwH5nZ3SyTtAofg776b2/mTZrtL0bANUiIUbSsDuOm25q aQ== 
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
        by mx0a-00154904.pphosted.com with ESMTP id 353jk2rpnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Dec 2020 11:18:08 -0500
Received: from pps.filterd (m0134746.ppops.net [127.0.0.1])
        by mx0a-00154901.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B2GEsXG044458;
        Wed, 2 Dec 2020 11:18:07 -0500
Received: from ausxippc110.us.dell.com (AUSXIPPC110.us.dell.com [143.166.85.200])
        by mx0a-00154901.pphosted.com with ESMTP id 3569ejnfje-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Dec 2020 11:18:07 -0500
X-LoopCount0: from 10.173.37.130
X-PREM-Routing: D-Outbound
X-IronPort-AV: E=Sophos;i="5.78,387,1599541200"; 
   d="scan'208";a="1013735379"
From:   Mario Limonciello <mario.limonciello@dell.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org
Cc:     linux-kernel@vger.kernel.org, Linux PM <linux-pm@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Netfin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>,
        David Miller <davem@davemloft.net>, darcari@redhat.com,
        Yijun.Shen@dell.com, Perry.Yuan@dell.com,
        Mario Limonciello <mario.limonciello@dell.com>,
        Yijun Shen <yijun.shen@dell.com>
Subject: [PATCH v2 3/5] e1000e: Add Dell's Comet Lake systems into s0ix heuristics
Date:   Wed,  2 Dec 2020 10:17:46 -0600
Message-Id: <20201202161748.128938-4-mario.limonciello@dell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201202161748.128938-1-mario.limonciello@dell.com>
References: <20201202161748.128938-1-mario.limonciello@dell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_08:2020-11-30,2020-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 impostorscore=0 lowpriorityscore=0 mlxscore=0 spamscore=0 bulkscore=0
 clxscore=1015 suspectscore=0 priorityscore=1501 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020096
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012020096
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dell's Comet Lake Latitude and Precision systems containing i219LM are
properly configured and should use the s0ix flows.

Tested-by: Yijun Shen <yijun.shen@dell.com>
Signed-off-by: Mario Limonciello <mario.limonciello@dell.com>
---
 drivers/net/ethernet/intel/e1000e/s0ix.c | 33 +++++++++++++++++++++---
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/s0ix.c b/drivers/net/ethernet/intel/e1000e/s0ix.c
index c3013edbd9e4..74043e80c32f 100644
--- a/drivers/net/ethernet/intel/e1000e/s0ix.c
+++ b/drivers/net/ethernet/intel/e1000e/s0ix.c
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright(c) 1999 - 2018 Intel Corporation. */
+/* Copyright(c) 1999 - 2018 Intel Corporation.
+ * Copyright(c) 2020 Dell Inc.
+ */
 
 #include <linux/netdevice.h>
 
@@ -44,6 +46,26 @@ static bool e1000e_check_me(u16 device_id)
 	return false;
 }
 
+static bool e1000e_check_subsystem_allowlist(struct pci_dev *dev)
+{
+	if (dev->subsystem_vendor == PCI_VENDOR_ID_DELL) {
+		switch (dev->subsystem_device) {
+		case 0x099f: /* Latitude 5310 */
+		case 0x09a0: /* Latitude 5410 */
+		case 0x09c9: /* Latitude 5410 */
+		case 0x09a1: /* Latitude 5510 */
+		case 0x09a2: /* Precision 3550 */
+		case 0x09c0: /* Latitude 5411 */
+		case 0x09c1: /* Latitude 5511 */
+		case 0x09c2: /* Precision 3551 */
+		case 0x09c3: /* Precision 7550 */
+		case 0x09c4: /* Precision 7750 */
+			return true;
+		}
+	}
+	return false;
+}
+
 void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
 {
 	struct e1000_hw *hw = &adapter->hw;
@@ -273,8 +295,11 @@ void e1000e_maybe_enable_s0ix(struct e1000_adapter *adapter)
 	/* require cannon point or later */
 	if (hw->mac.type < e1000_pch_cnp)
 		return;
-	/* turn off on ME configurations */
-	if (e1000e_check_me(pdev->device))
-		return;
+	/* check for allowlist of systems */
+	if (!e1000e_check_subsystem_allowlist(pdev)) {
+		/* turn off on ME configurations */
+		if (e1000e_check_me(pdev->device))
+			return;
+	}
 	adapter->flags2 |= FLAG2_ENABLE_S0IX_FLOWS;
 }
-- 
2.25.1

