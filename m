Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 617B7DE933
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 12:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbfJUKSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 06:18:50 -0400
Received: from mail-eopbgr700084.outbound.protection.outlook.com ([40.107.70.84]:40420
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726725AbfJUKSu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 06:18:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nNyK5LChzdXZyibcJ841+kbjmVvjVw5RVeMhZLMOFuzhiJubEyGx3q3YwvWh2lp+/nh1UbRPB/jsUZcSwkeP+58j5zptmB/3UNNt+2IxLJaBv4nDcF6kkRhnfEj7IFHNDzQGfRbcUQA/Uqqf0NHyZAz4CfzasmUBV5qVxWx/Tolk1QuTuSXyUYUuA6d161cXbBLGpcWYQ1jgMjA1TFJGbC29L8MCtt9tQEifHvxiSY29DNMy9lUd5bnSVotepFUzlKxJqoA3UeWYbInf5NColxrusYfND1qfuSNL22WzBSzS2HhEQhZ1L66mMWl51ch3QBu7RBE4PLceq9FM/vKkPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cR3GKjskOOCPvYJv9Rhz71QzX+S+xlM7KhT8MV4tJXU=;
 b=UC/bxpE2bj2qfBw/T6oGHd90opWqDAL54AcWw8fSwHhAojBOM69fXgtByI0yf8C0/L0oxgxXlgYRqaBmNO2lyz0NmIsPjuE5VPb+Xszyg1nLpu97xOcajmT3+J24yGQiIcyXu0SSCKctGiFyx41+Syq/70BXxi5dPkA0IESNMHr3paJuImpuhj9IiLdFAAi42nU+u/dkTmu5nRQr/pK+9VYEnC3aq+SPLHr63ElT80Zkll3vOUtC7RrhUcrc7r7AUbgoXRpE9ivjrsL6eb6BaiL94FECPKF5UBcncmRy42srjUQ3Lnrs0I7iN/zYfQtBpyoI9eB+sBsK37XBZUGsOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cR3GKjskOOCPvYJv9Rhz71QzX+S+xlM7KhT8MV4tJXU=;
 b=ISImCuAv0nzqVk7oP09rTzWpi0XhiWgQlzt+7r2hsdYevG33KE4D//ZC5hzueZ58ByFWn/j5FOtR7T6IoVyAct4jtbLLSzioqs2EnTp+LFTcJLErlbkYh45GE8o0o2nme9OBrk5Vhya/tE1DWN4CavuPH10C9DkY9ZG5VgwR5ko=
Received: from BL0PR02CA0013.namprd02.prod.outlook.com (2603:10b6:207:3c::26)
 by DM6PR02MB5771.namprd02.prod.outlook.com (2603:10b6:5:17a::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2367.20; Mon, 21 Oct
 2019 10:18:46 +0000
Received: from CY1NAM02FT010.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::205) by BL0PR02CA0013.outlook.office365.com
 (2603:10b6:207:3c::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2367.21 via Frontend
 Transport; Mon, 21 Oct 2019 10:18:46 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 CY1NAM02FT010.mail.protection.outlook.com (10.152.75.50) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2367.14
 via Frontend Transport; Mon, 21 Oct 2019 10:18:45 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1iMUlx-0004jV-Ei; Mon, 21 Oct 2019 03:18:45 -0700
Received: from [127.0.0.1] (helo=xsj-smtp-dlp2.xlnx.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1iMUls-0005et-9U; Mon, 21 Oct 2019 03:18:40 -0700
Received: from xsj-pvapsmtp01 (mail.xilinx.com [149.199.38.66] (may be forged))
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x9LAIc4u027034;
        Mon, 21 Oct 2019 03:18:38 -0700
Received: from [10.140.184.180] (helo=ubuntu)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <radheys@ubuntu>)
        id 1iMUlq-0005eQ-9O; Mon, 21 Oct 2019 03:18:38 -0700
Received: by ubuntu (Postfix, from userid 13245)
        id 7C57A10104D; Mon, 21 Oct 2019 15:48:37 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     michal.simek@xilinx.com, anirudha.sarangi@xilinx.com,
        john.linn@xilinx.com, mchehab+samsung@kernel.org,
        gregkh@linuxfoundation.org, nicolas.ferre@microchip.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH v2 net-next] net: axienet: In kconfig add ARM64 as supported platform
Date:   Mon, 21 Oct 2019 15:48:30 +0530
Message-Id: <1571653110-20505-1-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.7.4
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-Result: No--2.045-7.0-31-1
X-imss-scan-details: No--2.045-7.0-31-1;No--2.045-5.0-31-1
X-TM-AS-User-Approved-Sender: No;No
X-TM-AS-Result-Xfilter: Match text exemption rules:No
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39860400002)(376002)(346002)(189003)(199004)(8936002)(8676002)(478600001)(70206006)(2906002)(81156014)(81166006)(70586007)(336012)(47776003)(186003)(305945005)(426003)(51416003)(5660300002)(103686004)(476003)(126002)(2616005)(26005)(486006)(4326008)(50466002)(36756003)(106002)(50226002)(356004)(48376002)(107886003)(6266002)(316002)(6666004)(42186006)(16586007)(42866002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR02MB5771;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1a41145-7369-4f3c-c1d6-08d756100e9c
X-MS-TrafficTypeDiagnostic: DM6PR02MB5771:
X-Microsoft-Antispam-PRVS: <DM6PR02MB5771B895B9D7B93D1F80F985C7690@DM6PR02MB5771.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:372;
X-Forefront-PRVS: 0197AFBD92
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dy9nUZ4AS69p/WwUcYdASlg5AVxkG7PEa7gFc3Z9OywyXQ69PFDaRhbn0BCcR/Xqqzx1rxwa0NwTU20ZTIQJcis7+9wj7++l7eXskGDT8RrQ6v7w9E7Dss/Fx7pLGoGiQtsb2vcGAlF1TSE4aLPzc3ap1eNVlj/OrEOU25YtQDLmaBIkKZyd4uZ1ieX+eiXKLHmqToOQLaUQkh5mDKymTzftZqgWxJ4NLtqHqM9Gd5lbIiJKE4gHHW1jeniPSENr2KPzFP+mXE1CM4I++QFYSfCJjANhFpKU9zg2A6pEe24Eu/S/v/1Rk8mmTduUK1Obe7rsUhzlWkvkLyMNQMHaG0Unltm5T0jv/XCe8LniT4AEhsiqUgABs6cnsgBxvvHnXT5vs5vARLH/+aMcOsJajrh0P88US4d12lpTOTdTA2qDhPUih+WRwX05QqD0o1+A
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2019 10:18:45.9423
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e1a41145-7369-4f3c-c1d6-08d756100e9c
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB5771
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xilinx axi_emac driver is supported on ZynqMP UltraScale platform.
So enable ARCH64 in kconfig. It also removes redundant ARCH_ZYNQ
dependency. Basic sanity testing is done on zu+ mpsoc zcu102
evaluation board.

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
Changes for v2:
Remove redundant ARCH_ZYNQ dependency.
Modified commit description.
---
 drivers/net/ethernet/xilinx/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/Kconfig b/drivers/net/ethernet/xilinx/Kconfig
index 8d994ce..da11876 100644
--- a/drivers/net/ethernet/xilinx/Kconfig
+++ b/drivers/net/ethernet/xilinx/Kconfig
@@ -6,7 +6,7 @@
 config NET_VENDOR_XILINX
 	bool "Xilinx devices"
 	default y
-	depends on PPC || PPC32 || MICROBLAZE || ARCH_ZYNQ || MIPS || X86 || ARM || COMPILE_TEST
+	depends on PPC || PPC32 || MICROBLAZE || MIPS || X86 || ARM || ARM64 || COMPILE_TEST
 	---help---
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 
@@ -26,11 +26,11 @@ config XILINX_EMACLITE
 
 config XILINX_AXI_EMAC
 	tristate "Xilinx 10/100/1000 AXI Ethernet support"
-	depends on MICROBLAZE || X86 || ARM || COMPILE_TEST
+	depends on MICROBLAZE || X86 || ARM || ARM64 || COMPILE_TEST
 	select PHYLINK
 	---help---
 	  This driver supports the 10/100/1000 Ethernet from Xilinx for the
-	  AXI bus interface used in Xilinx Virtex FPGAs.
+	  AXI bus interface used in Xilinx Virtex FPGAs and Soc's.
 
 config XILINX_LL_TEMAC
 	tristate "Xilinx LL TEMAC (LocalLink Tri-mode Ethernet MAC) driver"
-- 
2.7.4

