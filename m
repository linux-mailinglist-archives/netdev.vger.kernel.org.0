Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93C047BD54
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 11:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387469AbfGaJgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 05:36:37 -0400
Received: from mail-eopbgr690064.outbound.protection.outlook.com ([40.107.69.64]:28097
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726791AbfGaJgh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 05:36:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hhxui4unY7j3++fmP4ROBRQxMKikIGHLjMH/5ghpREk4P6qyY6cIgdUs3CJXSYoDG+n1fD4pQn9lmTSHvTptFoFXSVuTvlO+qPA9zBtmrGUhzjovOQRsQv4adi5LBD3DoaSUAA2ze5rqSCVGIEbNvUnfUK9nlUuBt8VH3wrb7gPHjSK6ByKXE+CoPuINqRnziS7shCHkaMkLn+V9QOdYT/OEoWXlFqasTXT7JIuX4uzHabgDwDpqYLbnOwqypSbKPwCNddJC27Dicfmc4SCnOEewlgXfX5QrHpz97SST1epwkSypGPjF1Glu5g+assNa8YSMbctlzUqkIPLqaCefFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9yf92BXfP+wHJsMYT4iWMO0WjCDKv0Ep4u+bd5uCaso=;
 b=cruak1YfEG7pgRGG1wDo90AnRxjTC74MzOKIvRVEuPw8vc/lBJhsVbv693Md6NDa1J9mvyZD7z4K3jBxwmNi97d41Exfngn8UrMgAx7KHXQfaH/WM600c7MphJMg2BFtPVtZPSuoDudDrG9zgiA1YEo0TT16K1HeX2N7d8AvBYC1zNzsZKkIjAFAXQbiXs+s7a8ltMaIjKSAPeECUHQgTa1YikWf7nTiJG3+LHjFNn++z23h4z9Tbcij+ygh9+WZY7WnSqIglGPb/sWcovlpp7jtkuRHmMPoTiAWuvyE5tOCw8qjcSMNBZe/DsIOGVWDCrH/gepBfgJmbtT2fs+1TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=gmail.com
 smtp.mailfrom=xilinx.com;dmarc=bestguesspass action=none
 header.from=xilinx.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9yf92BXfP+wHJsMYT4iWMO0WjCDKv0Ep4u+bd5uCaso=;
 b=IVF9t3jBJ+0oEl8S3SFniLg8nPXs6/454JnC9lqq3IG5ZQZ6e5H5Tm6gQTFGwvvrfKc2VKenEJjLzlpNdpDCbarD0g/attl1oCYM9TH5QlIgDikyzqOiwakr6bVzyoPCWSDjZypyVdY8O7ctzl8f408IzFtMLyD3zKzhu97mRek=
Received: from MWHPR0201CA0047.namprd02.prod.outlook.com
 (2603:10b6:301:73::24) by BYAPR02MB4757.namprd02.prod.outlook.com
 (2603:10b6:a03:4e::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2115.10; Wed, 31 Jul
 2019 09:36:34 +0000
Received: from CY1NAM02FT028.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::209) by MWHPR0201CA0047.outlook.office365.com
 (2603:10b6:301:73::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2136.12 via Frontend
 Transport; Wed, 31 Jul 2019 09:36:34 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 CY1NAM02FT028.mail.protection.outlook.com (10.152.75.132) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2115.10
 via Frontend Transport; Wed, 31 Jul 2019 09:36:33 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1hsl28-00073A-C5; Wed, 31 Jul 2019 02:36:32 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1hsl23-0003o0-8D; Wed, 31 Jul 2019 02:36:27 -0700
Received: from xsj-pvapsmtp01 (maildrop.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x6V9aNtE005093;
        Wed, 31 Jul 2019 02:36:24 -0700
Received: from [10.140.6.13] (helo=xhdharinik40.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1hsl1z-0003my-Ak; Wed, 31 Jul 2019 02:36:23 -0700
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net
Cc:     michal.simek@xilinx.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        harinikatakamlinux@gmail.com, harini.katakam@xilinx.com,
        radhey.shyam.pandey@xilinx.com
Subject: [PATCH 0/2] Fix GMII2RGMII private field
Date:   Wed, 31 Jul 2019 15:06:17 +0530
Message-Id: <1564565779-29537-1-git-send-email-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.7.4
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(346002)(136003)(396003)(2980300002)(199004)(189003)(126002)(486006)(2616005)(16586007)(8676002)(81156014)(426003)(2906002)(476003)(81166006)(47776003)(70586007)(70206006)(356004)(63266004)(44832011)(7696005)(51416003)(36386004)(305945005)(336012)(106002)(26005)(4744005)(6666004)(8936002)(4326008)(107886003)(48376002)(186003)(478600001)(5660300002)(50466002)(50226002)(9786002)(316002)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR02MB4757;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c34c3b34-cdbc-4826-f897-08d7159a9373
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:BYAPR02MB4757;
X-MS-TrafficTypeDiagnostic: BYAPR02MB4757:
X-Microsoft-Antispam-PRVS: <BYAPR02MB47573946DAD500A368809570C9DF0@BYAPR02MB4757.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 011579F31F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: mlelyaOvFV7pxDx7g9CfOkC7aMqlWPCRMqB+J5K147/qOGZwq1SpfvlL+yUAUMt7AddqFEEcgoqRiA8vxH8NAFEgPB8nNRQBNCohpruPa3lZ68yABWHkZAW044tYmiBS7KS1lRhp/Uek+ruNGQKlDRCRHjB2KWVKbopykDmeiD/Q11L4V/UQXYclGoc16l0jyZsWl5gQ4Jd3UPaI2rIs6P38XjsbwscKPEBsCP3OemYD6EzTYtfbQVEeAXHdYSwEYRCbuQx16MkXXCgQ/BY+IyF30kbpXjg6REuXLqaU6Ota3WB/HsV0oxMdO53pQ+0G4MajYRppN1D5xkOA6h8dhydv+vFIKs/pF59/XS5kwZF7WAyQV02ofNvBfiyBSwUi7bH55GdOBon0NdEMxDmACvBTLOYyFkZfLu4nA13+Jm0=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2019 09:36:33.4858
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c34c3b34-cdbc-4826-f897-08d7159a9373
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB4757
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the usage of external phy's priv field by gmii2rgmii driver.

Based on net-next.

Harini Katakam (2):
  include: mdio: Add private field to mdio structure
  net: gmii2rgmii: Switch priv field in mdio device structure

 drivers/net/phy/xilinx_gmii2rgmii.c | 4 ++--
 include/linux/mdio.h                | 3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

-- 
2.7.4

