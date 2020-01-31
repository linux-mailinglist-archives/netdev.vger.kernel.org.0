Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 745A714EBF7
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 12:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgAaLsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 06:48:33 -0500
Received: from mail-bn8nam11on2079.outbound.protection.outlook.com ([40.107.236.79]:36592
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728454AbgAaLsQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 06:48:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g7lAvRBafe+UTSCMBqZtdNoMm7SEP7Jr+WuQzRXNgOjYnsQtLAjgMyFjF4bcusSA7vZG99q+P8RqZrpwVOIt1CHdqEVZUqHZ5bJBaCqTreFImoUcUpCOHqrX/Hdz1Z2LwAy1KP/rGE++PaTU5S9dcyI7oQ4Luip9YG8xkjNTVG748ExoIUbW8k7Pvv25ZxzH9AiV1k3Yw7JGq1zVufIgNnVXPLfTU25SVy4dH6/WJqchTsjSXJ5mgfB1S0Nacq1GvvPuRF3zlo4WJ9vP/4YUg6VG9OqY/rjFaNzNI8KRH7jrRfyLYa07+G6m0MjAUAlyFAVClCaP/PH1ylSKeisyuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bSl7E8xxECs4dyA+dTDWm/ZsppKl25xdERZ8frrwWdQ=;
 b=NkWHLfpi1w8ciGHrf7DgEeD+7tiZoxT8KKhQFZw7SyPh3qqaE7tzkjSBv/GtwJX2BRhRrObzRpG2M5vrH6rWvDfIbMayzDIbMbaWi7XUulDWKslRxpjs9Sm+LVJXiVgFHD8cVMIhOO/PgFKJqmk7Suvv2qkkQyiG3qewiplk0uIskWZy7Wt5/4B9nkl06taFAt6mY3Jz5OeVbwa0YNBE1RZlMhiyKUaCBRfNw2R/WHHeshLIiRMAvMcGXluYOdto5DJXMftGRloOlfJNHslaGSYQq1OB+d7fThj0DDharSMRZBhXnoLTCXF2ETmz/n6oO0fbRi4I2uVpbCCoOdf6Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=xhdpunnaia40.localdomain; dmarc=none action=none
 header.from=xilinx.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bSl7E8xxECs4dyA+dTDWm/ZsppKl25xdERZ8frrwWdQ=;
 b=Y2PKmg3GBOuOXohbCAfxQsJykR50UiMu7TPUmefKn1JeSmnVimPvj1QfOp9AXGdDcOTPf7XtP/UzTxQLUXFVnv3IJVEnPUhhvu/GWYJhL7FFvOmc9/1RTXQQ0Mr8f8GOQWRGJfuJJ2Npi2Qa6yl85fpWrEqohsC6TUobtbybsJc=
Received: from BYAPR02CA0003.namprd02.prod.outlook.com (2603:10b6:a02:ee::16)
 by BN6PR02MB3267.namprd02.prod.outlook.com (2603:10b6:405:63::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.24; Fri, 31 Jan
 2020 11:48:13 +0000
Received: from CY1NAM02FT063.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::202) by BYAPR02CA0003.outlook.office365.com
 (2603:10b6:a02:ee::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.26 via Frontend
 Transport; Fri, 31 Jan 2020 11:48:12 +0000
Authentication-Results: spf=none (sender IP is 149.199.60.83)
 smtp.mailfrom=xhdpunnaia40.localdomain; vger.kernel.org; dkim=none (message
 not signed) header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=xilinx.com;
Received-SPF: None (protection.outlook.com: xhdpunnaia40.localdomain does not
 designate permitted sender hosts)
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 CY1NAM02FT063.mail.protection.outlook.com (10.152.75.161) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2686.25
 via Frontend Transport; Fri, 31 Jan 2020 11:48:12 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1ixUmS-0006bO-1q; Fri, 31 Jan 2020 03:48:12 -0800
Received: from [127.0.0.1] (helo=xsj-smtp-dlp1.xlnx.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1ixUmM-0004pm-TP; Fri, 31 Jan 2020 03:48:06 -0800
Received: from xsj-pvapsmtp01 (mailhost.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id 00VBm5pT012166;
        Fri, 31 Jan 2020 03:48:05 -0800
Received: from [10.140.184.180] (helo=xhdpunnaia40.localdomain)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1ixUmL-0004on-D6; Fri, 31 Jan 2020 03:48:05 -0800
Received: by xhdpunnaia40.localdomain (Postfix, from userid 13245)
        id 8DA29FF8AA; Fri, 31 Jan 2020 17:18:04 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     michal.simek@xilinx.com, anirudha.sarangi@xilinx.com,
        john.linn@xilinx.com, mchehab+samsung@kernel.org,
        gregkh@linuxfoundation.org, nicolas.ferre@microchip.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH v3 -next 2/4] net: emaclite: In kconfig remove arch dependency
Date:   Fri, 31 Jan 2020 17:17:48 +0530
Message-Id: <1580471270-16262-3-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580471270-16262-1-git-send-email-radhey.shyam.pandey@xilinx.com>
References: <1580471270-16262-1-git-send-email-radhey.shyam.pandey@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-Result: No-0.229-7.0-31-1
X-imss-scan-details: No-0.229-7.0-31-1;No-0.229-5.0-31-1
X-TM-AS-User-Approved-Sender: No;No
X-TM-AS-Result-Xfilter: Match text exemption rules:No
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(39860400002)(136003)(376002)(428003)(249900001)(199004)(189003)(356004)(6666004)(8936002)(8676002)(2906002)(6266002)(4744005)(81166006)(81156014)(107886003)(82310400001)(4326008)(450100002)(42186006)(2616005)(26005)(70206006)(42882007)(498600001)(336012)(36756003)(70586007)(5660300002)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR02MB3267;H:xsj-pvapsmtpgw01;FPR:;SPF:None;LANG:en;PTR:unknown-60-83.xilinx.com;A:0;MX:0;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49ce645d-b3ff-457e-89be-08d7a6437371
X-MS-TrafficTypeDiagnostic: BN6PR02MB3267:
X-Microsoft-Antispam-PRVS: <BN6PR02MB326779DB6CD7F859B1AC06D1D5070@BN6PR02MB3267.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 029976C540
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vOjXKkt+qF39q7nnDjR6qF1MDYHDJ6mng1Oiijcr8sqiBotIM49I8wuIFlHNc9ETkshpKAzGjip/Zoy6sA7UGBZiQUsWFW/uESGZVZPm9n8QSnkcV5UN9pU9UA6UIhDXUWeYBWfbN7CBigNaSZI10dkbp4+sZvRIH2qJRQQ5+3DJ+zP7dei3Xon4ftDg39f649hjApeZWr4kUxIDCjSPhcCqqj5FECyz5p+Sld3m4XhyDTKV2m7CsTpdGK8tFHy5xffI83YQCKdZVSfQDm2pXq5rLpEgH3I/Vc2VvouMqE+6yhl9l9r57yNlVMCjMtFQYuNsph2dTOdCo8WKyYi0006zlyN6tK/zeLMlO71raXZB0UzHq64aE+L2y3fj0Ci1SnVrLPpARigTioMJPmFT3icIP9cf4cwgOED1dqnEo47ksWPjmrbkfNAEmBHzffw6
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2020 11:48:12.5524
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 49ce645d-b3ff-457e-89be-08d7a6437371
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR02MB3267
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To enable xilinx_emaclite driver support on zynqmp ultrascale platform
(ARCH64) remove the obsolete ARCH dependency list. Also include HAS_IOMEM
dependency to avoid compilation failure on architectures without IOMEM.

Sanity build test done for microblaze, zynq and zynqmp ultrascale platform.

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
 drivers/net/ethernet/xilinx/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/Kconfig b/drivers/net/ethernet/xilinx/Kconfig
index 6304ebd..0692dd1 100644
--- a/drivers/net/ethernet/xilinx/Kconfig
+++ b/drivers/net/ethernet/xilinx/Kconfig
@@ -18,8 +18,8 @@ if NET_VENDOR_XILINX
 
 config XILINX_EMACLITE
 	tristate "Xilinx 10/100 Ethernet Lite support"
-	depends on PPC32 || MICROBLAZE || ARCH_ZYNQ || MIPS
 	select PHYLIB
+	depends on HAS_IOMEM
 	---help---
 	  This driver supports the 10/100 Ethernet Lite from Xilinx.
 
-- 
2.7.4

