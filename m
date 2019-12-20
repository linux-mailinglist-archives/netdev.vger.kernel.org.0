Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFE9A1277A5
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 09:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727419AbfLTI5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 03:57:21 -0500
Received: from mail-eopbgr680070.outbound.protection.outlook.com ([40.107.68.70]:45125
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727174AbfLTI5V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Dec 2019 03:57:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jDX6K1HoP8SLVWJ7SlxR/dJ/XqhZo0WeiWB9KNGpTp4GjxL/HdRgPB0GpmP5rSkU0cRE3LjRdflAa7xdGWpKou6q35vrn8Jr7HNpEITasojKr6kK5LrgyjGK8L1UTkkTFc46acCzpKLb6a1pj2pIXItwJlonTpwLWGEHFZ4rXjltcZE/XOgAfTxtoz9M478roe2dgSfK4OzJXpkxUW6GU4KUMuBd4gn/xCRRU3LDLRuvN5hfXewQLCs6j+EwGJb3LGXO8MG8ax4LIeeSqqjtj7/JjQI6NYSsZo7Mn9l4DOGJbEJs+wP1igZFtK8cMo5QydygloavYTcisXOKw7Q7Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0uxBbx83RvrSIuPY8exWKLuimI6bnWdhUTj0clOivoA=;
 b=iqEM4jMcr3lPH8XnyJ5mOPGp3B/anYD3e4mZSceNrqIoKaIr3h3G7LU0GQKBtBQIWijhxRwJs8ji6Zd/gNytT/C6tpVX0dct8iJ22sMGnsqVpGggbYEeT1nOBXdefLMUU1gUHWp5u/h/88+LWsXZjPSd7vmPWyYZRsdIuXm0Y+WhuA7nlWpXfa6XQsLDlih7whEk18taGsU956nWAkRWDnf5L+UEV5cZEB6WxItUtXoZWcxFitvbmUZadlSNJIvedwFdy2Y6+zwv16Z8k6IMvXb2QYGQ8G86jyly3DTTn84nE79qk5Ss6+Y64oCffzQwYSnlCkEa8hTrKNfjv7tA8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=xhdpunnaia40.localdomain; dmarc=none action=none
 header.from=xilinx.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0uxBbx83RvrSIuPY8exWKLuimI6bnWdhUTj0clOivoA=;
 b=dsW7C+sczTT4NY56j8PloYnSIfxkuR/bIENLWq04sDHQ3cykqO7o00ueOb5pw+gytuBcXh92fimwzxVZhVZJRsp6/2EJChiVAoHMMmRH8/O/OE2TaDaQ1r1Dc3uOpSVbc8K/8qsBYMtpvPuZLyeVeBK+OTUmKks/aZD3dbkXC14=
Received: from BL0PR02CA0016.namprd02.prod.outlook.com (2603:10b6:207:3c::29)
 by DM6PR02MB4684.namprd02.prod.outlook.com (2603:10b6:5:fe::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2559.16; Fri, 20 Dec
 2019 08:57:16 +0000
Received: from BL2NAM02FT033.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::208) by BL0PR02CA0016.outlook.office365.com
 (2603:10b6:207:3c::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2559.15 via Frontend
 Transport; Fri, 20 Dec 2019 08:57:16 +0000
Authentication-Results: spf=none (sender IP is 149.199.60.83)
 smtp.mailfrom=xhdpunnaia40.localdomain; vger.kernel.org; dkim=none (message
 not signed) header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=xilinx.com;
Received-SPF: None (protection.outlook.com: xhdpunnaia40.localdomain does not
 designate permitted sender hosts)
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 BL2NAM02FT033.mail.protection.outlook.com (10.152.77.163) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2559.14
 via Frontend Transport; Fri, 20 Dec 2019 08:57:16 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1iiE5y-0003Dk-4M; Fri, 20 Dec 2019 00:57:14 -0800
Received: from [127.0.0.1] (helo=xsj-smtp-dlp2.xlnx.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1iiE5s-000101-Ej; Fri, 20 Dec 2019 00:57:08 -0800
Received: from xsj-pvapsmtp01 (mailhub.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id xBK8v7Uv010842;
        Fri, 20 Dec 2019 00:57:07 -0800
Received: from [10.140.184.180] (helo=xhdpunnaia40.localdomain)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1iiE5q-0000zi-RW; Fri, 20 Dec 2019 00:57:07 -0800
Received: by xhdpunnaia40.localdomain (Postfix, from userid 13245)
        id 1141C1053CF; Fri, 20 Dec 2019 14:27:06 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     davem@davemloft.net, michal.simek@xilinx.com
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, git@xilinx.com,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH net-next v2 2/3] net: emaclite: In kconfig remove arch dependency
Date:   Fri, 20 Dec 2019 14:26:59 +0530
Message-Id: <1576832220-9631-3-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576832220-9631-1-git-send-email-radhey.shyam.pandey@xilinx.com>
References: <1576832220-9631-1-git-send-email-radhey.shyam.pandey@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-Result: No-0.229-7.0-31-1
X-imss-scan-details: No-0.229-7.0-31-1;No-0.229-5.0-31-1
X-TM-AS-User-Approved-Sender: No;No
X-TM-AS-Result-Xfilter: Match text exemption rules:No
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(136003)(396003)(346002)(428003)(249900001)(199004)(189003)(42186006)(356004)(6666004)(42882007)(336012)(36756003)(26005)(316002)(4744005)(6636002)(8676002)(81156014)(8936002)(81166006)(498600001)(2906002)(4326008)(5660300002)(107886003)(6266002)(70206006)(70586007)(450100002)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR02MB4684;H:xsj-pvapsmtpgw01;FPR:;SPF:None;LANG:en;PTR:unknown-60-83.xilinx.com;A:0;MX:0;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08d7b073-d432-410a-f915-08d7852a9cca
X-MS-TrafficTypeDiagnostic: DM6PR02MB4684:
X-Microsoft-Antispam-PRVS: <DM6PR02MB4684C303505ED0BED95C81B4D52D0@DM6PR02MB4684.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 025796F161
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HWZvVIc/6LDs4zFWEXouw4fXmt/FNlX9aAxaoE/oysCqsxwPoGA1nqOtFEL3aS32Jca49Y3e8728LVIU7uIjQGVBXBfauBkZHVE5vnckV3iOVIZLWPgX8L6Xvvq0awkl4dlYkf8OPNdETk0Ea6zdi7zi0z7Ud+WSkeikUHpRs2Cdms99V0HlkDOgyQhv893AZKDR7v7Zpr/0QBIeFA7seUK92K1clioJKhPoQWVOoPsr8XvjlTWnjZ9w38w9P+okL3kF9Q/YbbLYTsMjx/6/TdnGoqH080hJ95lLH4jadCUlFfi5XxGPzN5WV6Ud3Q+vJLzG4TClsGYvwelXX4Pd+VQ3V1Lk82jLjpGNwCurTKYsUUJWHCnmDoRiBybxD1qhy3FoplwDZyfAsifmT+zLtqXYGEXxFSItky6T466F+hN+YMAXB+Dsc+zhlDeVcGC1
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2019 08:57:16.0151
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 08d7b073-d432-410a-f915-08d7852a9cca
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB4684
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
Changes for v2:
None
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

