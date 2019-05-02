Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1A611758
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 12:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbfEBKfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 06:35:53 -0400
Received: from mail-eopbgr760045.outbound.protection.outlook.com ([40.107.76.45]:13075
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726231AbfEBKfJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 06:35:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oHpWHxqskoSlSadAMLt09ozUUUgZ3kzHN+8B/ee8fbI=;
 b=b92kOuk44jUwOEIF/CSUz8pg7uEBY77AMrMhfc7C63ffuXL10DsdVB81CRy7c6MD8lFlTy1B1ImXecnfQl84r1GdbziK0jYWprULykxdnEwBRtlaL6l3X3hs8U6YrujYO+1QFrnm/p9NJ61yaiy8qAd6vDfqfvs5JqK7iJox9nk=
Received: from BN6PR02CA0030.namprd02.prod.outlook.com (2603:10b6:404:5f::16)
 by CY4PR0201MB3396.namprd02.prod.outlook.com (2603:10b6:910:8b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1856.11; Thu, 2 May
 2019 10:35:04 +0000
Received: from CY1NAM02FT024.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::204) by BN6PR02CA0030.outlook.office365.com
 (2603:10b6:404:5f::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1856.10 via Frontend
 Transport; Thu, 2 May 2019 10:35:03 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 CY1NAM02FT024.mail.protection.outlook.com (10.152.74.210) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1856.11
 via Frontend Transport; Thu, 2 May 2019 10:35:02 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1hM93O-0004iW-Fl; Thu, 02 May 2019 03:35:02 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1hM93J-0007Vo-CX; Thu, 02 May 2019 03:34:57 -0700
Received: from xsj-pvapsmtp01 (xsj-smtp.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x42AYsY9031031;
        Thu, 2 May 2019 03:34:55 -0700
Received: from [172.23.155.80] (helo=xhdengvm155080.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <kalyania@xilinx.com>)
        id 1hM93G-0007VC-ML; Thu, 02 May 2019 03:34:54 -0700
Received: by xhdengvm155080.xilinx.com (Postfix, from userid 23151)
        id DA45D81340; Thu,  2 May 2019 16:04:53 +0530 (IST)
From:   Kalyani Akula <kalyani.akula@xilinx.com>
To:     <herbert@gondor.apana.org.au>, <kstewart@linuxfoundation.org>,
        <gregkh@linuxfoundation.org>, <tglx@linutronix.de>,
        <pombredanne@nexb.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <saratcha@xilinx.com>
CC:     Kalyani Akula <kalyania@xilinx.com>,
        Kalyani Akula <kalyani.akula@xilinx.com>
Subject: [RFC PATCH V3 0/4] Add Xilinx's ZynqMP SHA3 driver support
Date:   Thu, 2 May 2019 16:04:38 +0530
Message-ID: <1556793282-17346-1-git-send-email-kalyani.akula@xilinx.com>
X-Mailer: git-send-email 1.9.5
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(136003)(39860400002)(2980300002)(189003)(199004)(81166006)(8936002)(81156014)(110136005)(54906003)(16586007)(36756003)(4326008)(6306002)(103686004)(8676002)(42186006)(36386004)(50226002)(44832011)(2906002)(26005)(478600001)(52956003)(51416003)(48376002)(966005)(50466002)(70586007)(70206006)(106002)(2616005)(336012)(486006)(126002)(476003)(6266002)(426003)(186003)(316002)(107886003)(305945005)(90966002)(2201001)(47776003)(5660300002)(356004)(63266004)(6636002)(6666004);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR0201MB3396;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25eaa23a-e9aa-498e-725b-08d6cee9d61b
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4709054)(2017052603328);SRVR:CY4PR0201MB3396;
X-MS-TrafficTypeDiagnostic: CY4PR0201MB3396:
X-MS-Exchange-PUrlCount: 2
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-Microsoft-Antispam-PRVS: <CY4PR0201MB33966B386B1474B385E8564CAF340@CY4PR0201MB3396.namprd02.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 0025434D2D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 4RyCrrkXPpIRmpPbdRFn/IRL2i3Lkg5jzb87VJRzwCl5SqHSehbGqXTdagJkSgMODCviKXYky4EZ3ep8JcOtgGC9+0u2x/YJr5ItSW3aWVrlkRD851phoU6BaiJkJYct3048SN6s7byWWVatNdVvHN8pfxVXOM1/mTvmi6ruAJB5vwPgcPKWyRv4OAofXsmfaW/PxMcMtimo4Hu7oipFmELlZlbFejFyg9qif+sk4EBDD3D67RFreIMLQtjsZtH5fC9A3gktWhtTFXAoPzjwNZ1FOJixdH5BOTHr83vPhMMYD2Uk2RaSMaG5L1xqQtuj0zrfvwGnJJ3EtRgEfPcPVMGwpaOtD8Yagv9e/EHJIWfdh9vnL4rljOmGeQkN62WIYtQwhAUjGpatkg4SO+VJ4XDIGhAmPVXlyJB810wsFzo=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2019 10:35:02.9474
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 25eaa23a-e9aa-498e-725b-08d6cee9d61b
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0201MB3396
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds support for
- dt-binding docs for Xilinx ZynqMP SHA3 driver
- Adds communication layer support for sha_hash in zynqmp.c
- Adds Xilinx ZynqMP driver for SHA3 Algorithm
- Adds device tree node for ZynqMP SHA3 driver

V3 Changes :
- Removed zynqmp_sha_import and export APIs.The reason as follows
The user space code does an accept on an already accepted FD
when we create AF_ALG socket and call accept on it,
it calls af_alg_accept and not hash_accept.
import and export APIs are called from hash_accept.
The flow is as below
accept--> af_alg_accept-->hash_accept_parent-->hash_accept_parent_nokey
for hash salg_type.
- Resolved comments from 
        https://patchwork.kernel.org/patch/10753719/

V2 Changes :
- Added new patch (2/4) for sha_hash zynqmp API support
- Incorporated code review comments from v1 patch series. Discussed below:
        https://lore.kernel.org/patchwork/patch/1029433/


Kalyani Akula (4):
  dt-bindings: crypto: Add bindings for ZynqMP SHA3 driver
  firmware: xilinx: Add ZynqMP sha_hash API for SHA3 functionality
  crypto: Add Xilinx SHA3 driver
  ARM64: zynqmp: Add Xilinix SHA-384 node.

 .../devicetree/bindings/crypto/zynqmp-sha.txt      |  12 ++
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi             |   4 +
 drivers/crypto/Kconfig                             |  10 +
 drivers/crypto/Makefile                            |   1 +
 drivers/crypto/zynqmp-sha.c                        | 240 +++++++++++++++++++++
 drivers/firmware/xilinx/zynqmp.c                   |  27 +++
 include/linux/firmware/xlnx-zynqmp.h               |   2 +
 7 files changed, 296 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/zynqmp-sha.txt
 create mode 100644 drivers/crypto/zynqmp-sha.c

-- 
1.9.5

