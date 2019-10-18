Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99EF0DBDE7
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 08:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504522AbfJRGzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 02:55:39 -0400
Received: from mail-eopbgr700061.outbound.protection.outlook.com ([40.107.70.61]:30944
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2504371AbfJRGzi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 02:55:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QCHbjngCPcDIrbSOgPvX9pOytBcvA0uZPcd7syP8kUBVfucBcS3z9gaGjumnfvFbrYw7aAffABUZiIdwfO5cbHOBTZctf7ce8LNFB8zoh3fVKJczzdpZ6spF2TCXMh/CeCFyjnxRjK/jE5JiMLx928Wgzax1EK53CLbPbHukATJX2sp5/D9iWenjurE2Y8DUAgHQWfRWbowgstrqFqS+UKafE7eCZFvA8/IyAVha9QRWHPl2KiX8htew8B30mFoDAcXoh9FoU1psXQfMEz5FtxnBcSBjFvdbBOJtJE+gZLqDHLFAudXq4BM27hezwW8Rmh9W9FCQNstFNRigZyr46w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xO1G94WDG+asGTLvtKONPCA/vXBzNm8of9S3xLiQpsQ=;
 b=YXTzQblSqV7UKDw22Nc8v1UkSDn1HLfnQGSveju9PCxz7htVMsu39Wb+35wptOuaW9sW7XTW+Bgdvtp00exRKyHqPUjnfdQ7WmNwpA2xUqjNjspgdZev7hqV6kAY7GlDwA7eOT9T150FrVH4hLM/wWpOHIjT5roZtO81E7a26dBbEBg9BhPqyhnNa10/hEZqnbGo8MhZ4d7UUrWhFQB6UmvvTJhKqZVheBBeRWV+V/XHFb+thOFve/8qr5TmY0s1BswIe23GKGarYtB9SUT6GJg33QdTqCDQFR4lxQXZYtGRjAEHmX/mnn8hMiuKXLo8NC/AuJXteEIkPJTMvMctTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=davemloft.net smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xO1G94WDG+asGTLvtKONPCA/vXBzNm8of9S3xLiQpsQ=;
 b=ZhSs/Sc9bTXZm7t4qsZmBzQYP1QPLTgMXVoRTFKSGr+2xGTVpH1K64bMmGo1xg0xaIBHm+YPx6Fzp7GN/KAZnNw3cqhZcybtXmcKlpwfx2UBzp1FHPOyMePhjPfhNAA5hQhOE6im3pf26GmSR/O/gWyo+EP436sfD56fxoX6+xE=
Received: from SN6PR02CA0010.namprd02.prod.outlook.com (2603:10b6:805:a2::23)
 by MN2PR02MB6864.namprd02.prod.outlook.com (2603:10b6:208:1d3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2347.23; Fri, 18 Oct
 2019 06:54:55 +0000
Received: from SN1NAM02FT017.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::208) by SN6PR02CA0010.outlook.office365.com
 (2603:10b6:805:a2::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2347.24 via Frontend
 Transport; Fri, 18 Oct 2019 06:54:55 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 SN1NAM02FT017.mail.protection.outlook.com (10.152.72.115) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2367.14
 via Frontend Transport; Fri, 18 Oct 2019 06:54:55 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1iLMA2-0005hV-NB; Thu, 17 Oct 2019 23:54:54 -0700
Received: from localhost ([127.0.0.1] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1iLM9x-0006T4-Hl; Thu, 17 Oct 2019 23:54:49 -0700
Received: from [10.140.184.180] (helo=ubuntu)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <radheys@ubuntu>)
        id 1iLM9w-0006Sv-Ud; Thu, 17 Oct 2019 23:54:49 -0700
Received: by ubuntu (Postfix, from userid 13245)
        id 2BDC410104C; Fri, 18 Oct 2019 12:24:47 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     michal.simek@xilinx.com, anirudha.sarangi@xilinx.com,
        john.linn@xilinx.com, mchehab+samsung@kernel.org,
        gregkh@linuxfoundation.org, nicolas.ferre@microchip.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH net-next] net: axienet: In kconfig add ARM64 as supported platform
Date:   Fri, 18 Oct 2019 12:24:46 +0530
Message-Id: <1571381686-13045-1-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.7.4
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-Result: No--1.901-7.0-31-1
X-imss-scan-details: No--1.901-7.0-31-1;No--1.901-5.0-31-1
X-TM-AS-User-Approved-Sender: No;No
X-TM-AS-Result-Xfilter: Match text exemption rules:No
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(376002)(136003)(39860400002)(189003)(199004)(4326008)(6266002)(2906002)(107886003)(36756003)(186003)(316002)(50226002)(42186006)(106002)(16586007)(51416003)(478600001)(8936002)(81156014)(81166006)(70206006)(356004)(70586007)(48376002)(126002)(50466002)(476003)(8676002)(486006)(5660300002)(305945005)(426003)(336012)(103686004)(26005)(2616005)(47776003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR02MB6864;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34963280-717c-4847-9b9b-08d753981535
X-MS-TrafficTypeDiagnostic: MN2PR02MB6864:
X-Microsoft-Antispam-PRVS: <MN2PR02MB68642FEA057375321FD0E2CAC76C0@MN2PR02MB6864.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 01949FE337
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: srglYuf6HLks9xz+RbADIlAVUE3FGiH5eNBMzbR0QHMEaMmTcEBHgUfL++v7MCBdJki08LBx3cnAqOxK+vSM1Dzhm6UzRZzhb+v4kc4lRcxImIUBG/rd3WO5C61gMKEfMs32kHxGJOfAHfSU18mCdldTnF9xrulKMTMhx2WKuKjEzt4zm2rCotGxX4RN/6pgFDM8eOOEYdNUha63VLxXFz7nRnTuCl/Zra9T3anWj6gU13DPewmMlar5Y2aGFLRBe/w1CvvgNjgPM6FMS7AVWpjN9kptUkocHIL9kNCdghx+n9uRiNZVEMNbRh44uFKPf+mt7/C/1QpUKt04PTxSFL8WPjJDPJLXW2u81hzX9/aOzKN75wqE2zPUdi0jbPo/cLnf9k1pyVG9ON1QPfmnIdCbdtFyuYTlfXY5lhZOTEM=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2019 06:54:55.1042
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 34963280-717c-4847-9b9b-08d753981535
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB6864
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xilinx axi_emac driver is supported on ZynqMP UltraScale platform(ARM64).
So enable it in kconfig. Basic sanity testing is done on zu+ mpsoc zcu102
evaluation board.

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
 drivers/net/ethernet/xilinx/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/Kconfig b/drivers/net/ethernet/xilinx/Kconfig
index 8d994ce..a616bdc 100644
--- a/drivers/net/ethernet/xilinx/Kconfig
+++ b/drivers/net/ethernet/xilinx/Kconfig
@@ -6,7 +6,7 @@
 config NET_VENDOR_XILINX
 	bool "Xilinx devices"
 	default y
-	depends on PPC || PPC32 || MICROBLAZE || ARCH_ZYNQ || MIPS || X86 || ARM || COMPILE_TEST
+	depends on PPC || PPC32 || MICROBLAZE || ARCH_ZYNQ || MIPS || X86 || ARM || ARM64 || COMPILE_TEST
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

