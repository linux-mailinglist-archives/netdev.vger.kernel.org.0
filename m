Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B990CFA972
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 06:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfKMFVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 00:21:37 -0500
Received: from mail-eopbgr690081.outbound.protection.outlook.com ([40.107.69.81]:24550
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726190AbfKMFVg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 00:21:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V4SZtytrNRU3E5wsz2cBLjSoJ7tYQ9zDXe7lXmwSOjtxiSb+d6sa79KDAHIH5jJSndzSje4jZXLsB+tViQkRVVQ9E9pGx6worBJY+mBPdQOxB3rlnJCg9jM7YkBE7dm3LDdCH6x9fnooqJfPppckNOkgfGePkVqmXuWybHcuMTZdkKK45LInOrmnkq+J9zCwf0omvNcb8CDiQR2oAteraoi1V2mCPOJLQD5jDNNxlkEFnK4encVtfIduj46ZTZ6+A2sVwZnMmTLjHEstsNJ7GpGbdH83gdd3BIDgdB239FaSarm4WLE29ohxH09D6zCqrUfQev4NwJrtTa/IyHqT9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=acetoaqJiNUMgz/SIJPNWBTXIyByhfTXXiuTSMlr6DY=;
 b=BBcY2sX27L5f3+vv31yNs7ii1jFcvRsZrkWZuobs61Ufk7X5AZ8qrJyvgFlO+uqjQ7T2zHVvdAhvxlMzl5caPnuOSgIIFv1t82ndcuByVGaUuZsXok/5yjaszokB7WT3cEBJOVBEn5FumIqjMMLqSjPpHKXj1gM/1OvVf1V4dLLMjtaDoGf5bVv5ImVBUk+4fbBzvWatR2dr321jXFF4oQwCe69Hn2CUkpH06XkKoGt77zpJZPUnTgMDAmWDquD/DLeC/Ah1LITmqhjIjeDror70XCg3B2TcfyVOpIBvBpN4QXEL+5nlPjC+qNnFEDXpKByAKhiFDmKOblIwXsCZnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=xhdpunnaia40.localdomain; dmarc=none action=none
 header.from=xilinx.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=acetoaqJiNUMgz/SIJPNWBTXIyByhfTXXiuTSMlr6DY=;
 b=tOJg0yP2IXxrLGr74qI0v6NBBXqHBnQ1Rva0zgAhfLDLvLx5iGB9uioLdsfUVYEVRU95jnq2q/WPJVzcA6VOCYg7g2e/xMMKm20aaYzRIeIuyIDYsMa7UmJ4hsQOEI6ENfqZOxZTOkIdMORFF7l+k1+Tu3k0qTgeIA+1fv4O714=
Received: from SN4PR0201CA0029.namprd02.prod.outlook.com
 (2603:10b6:803:2e::15) by BL0PR02MB6516.namprd02.prod.outlook.com
 (2603:10b6:208:1ca::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2451.23; Wed, 13 Nov
 2019 05:21:33 +0000
Received: from SN1NAM02FT016.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::201) by SN4PR0201CA0029.outlook.office365.com
 (2603:10b6:803:2e::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2430.24 via Frontend
 Transport; Wed, 13 Nov 2019 05:21:33 +0000
Authentication-Results: spf=none (sender IP is 149.199.60.83)
 smtp.mailfrom=xhdpunnaia40.localdomain; vger.kernel.org; dkim=none (message
 not signed) header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=xilinx.com;
Received-SPF: None (protection.outlook.com: xhdpunnaia40.localdomain does not
 designate permitted sender hosts)
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 SN1NAM02FT016.mail.protection.outlook.com (10.152.72.113) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2451.23
 via Frontend Transport; Wed, 13 Nov 2019 05:21:33 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1iUl5w-0000Nb-V6; Tue, 12 Nov 2019 21:21:32 -0800
Received: from [127.0.0.1] (helo=xsj-smtp-dlp1.xlnx.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1iUl5r-0008AH-Q9; Tue, 12 Nov 2019 21:21:27 -0800
Received: from xsj-pvapsmtp01 (smtp.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id xAD5LQHb028116;
        Tue, 12 Nov 2019 21:21:26 -0800
Received: from [10.140.184.180] (helo=xhdpunnaia40.localdomain)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1iUl5q-0008AC-Fl; Tue, 12 Nov 2019 21:21:26 -0800
Received: by xhdpunnaia40.localdomain (Postfix, from userid 13245)
        id AE74E1001C6; Wed, 13 Nov 2019 10:51:25 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     michal.simek@xilinx.com, anirudha.sarangi@xilinx.com,
        john.linn@xilinx.com, mchehab+samsung@kernel.org,
        gregkh@linuxfoundation.org, nicolas.ferre@microchip.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jakub.kicinski@netronome.com,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH v3 net-next] net: axienet: In kconfig remove arch dependency for axi_emac
Date:   Wed, 13 Nov 2019 10:51:23 +0530
Message-Id: <1573622483-2033-1-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.7.4
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-Result: No--3.773-7.0-31-1
X-imss-scan-details: No--3.773-7.0-31-1;No--3.773-5.0-31-1
X-TM-AS-User-Approved-Sender: No;No
X-TM-AS-Result-Xfilter: Match text exemption rules:No
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(376002)(39860400002)(396003)(428003)(249900001)(189003)(199004)(81156014)(8936002)(81166006)(8676002)(42186006)(316002)(356004)(103686004)(16586007)(107886003)(2906002)(6266002)(450100002)(305945005)(4326008)(50226002)(36756003)(42882007)(336012)(47776003)(48376002)(476003)(50466002)(126002)(486006)(26005)(5660300002)(2616005)(51416003)(70206006)(70586007)(498600001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR02MB6516;H:xsj-pvapsmtpgw01;FPR:;SPF:None;LANG:en;PTR:unknown-60-83.xilinx.com;MX:0;A:0;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 448296c3-3438-42ef-e4c8-08d767f95901
X-MS-TrafficTypeDiagnostic: BL0PR02MB6516:
X-Microsoft-Antispam-PRVS: <BL0PR02MB65164BB98A1EBF049290F989D5760@BL0PR02MB6516.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:758;
X-Forefront-PRVS: 0220D4B98D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EDUOffQI9EasjcYortW5QiO5vBT+O90lcn8RbW7sD2OiM5xZEi4/X5Kdydxl+1ezvvAQqq7R5YqhX3B+N6N/erJIplR2ZltXce18q8KCJcS+jxygo+0dReeEpgyRLbIvBmENopFXvcqKKrefk3n8RRTAD9qkaqLRQwVgclCGSNAm/V7YoYZL+/ZqHvHqBO8ofGdNDdwC0Q5xQbbWrnhhraLv4wArg3W8sy+ywt4xMAljsJ55gjKREdXcmcIao3JFChcWD+h+lQaQsQDaJ+HlEyv3jrUgWIPDqP5eH3PqVBDQgOKA7FB6Gqo34DMzsUaBzR6lqA3h1AHgON2NgGXKahz9iqNd7C2qKsOydwHMckX4GA7gvkMgz80XtKZNO6vEK8PH1vYa6EtNqE8ytbIiiXSLQp+vqy3lmz+0mSrnj8WehiGB1wZYVats69Yy1G7F
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2019 05:21:33.3247
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 448296c3-3438-42ef-e4c8-08d767f95901
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB6516
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To enable xilinx axi_emac driver support on zynqmp ultrascale platform
(ARCH64) there are two choices, mention ARCH64 as a dependency list
and other is to check if this ARCH dependency list is really needed.
Later approach seems more reasonable, so remove the obsolete ARCH
dependency list for the axi_emac driver.

Sanity test done for microblaze, zynq and zynqmp ultrascale platform.

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
Changes for v3:
Remove obsolete dependency list. Suggested by Michal and Jakub.
Modified commit description.
---
 drivers/net/ethernet/xilinx/Kconfig |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/Kconfig b/drivers/net/ethernet/xilinx/Kconfig
index 8d994ce..6304ebd 100644
--- a/drivers/net/ethernet/xilinx/Kconfig
+++ b/drivers/net/ethernet/xilinx/Kconfig
@@ -6,7 +6,6 @@
 config NET_VENDOR_XILINX
 	bool "Xilinx devices"
 	default y
-	depends on PPC || PPC32 || MICROBLAZE || ARCH_ZYNQ || MIPS || X86 || ARM || COMPILE_TEST
 	---help---
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 
@@ -26,11 +25,10 @@ config XILINX_EMACLITE
 
 config XILINX_AXI_EMAC
 	tristate "Xilinx 10/100/1000 AXI Ethernet support"
-	depends on MICROBLAZE || X86 || ARM || COMPILE_TEST
 	select PHYLINK
 	---help---
 	  This driver supports the 10/100/1000 Ethernet from Xilinx for the
-	  AXI bus interface used in Xilinx Virtex FPGAs.
+	  AXI bus interface used in Xilinx Virtex FPGAs and Soc's.
 
 config XILINX_LL_TEMAC
 	tristate "Xilinx LL TEMAC (LocalLink Tri-mode Ethernet MAC) driver"
-- 
1.7.1

