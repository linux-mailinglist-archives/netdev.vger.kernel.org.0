Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A45237BD6E
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 11:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbfGaJkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 05:40:47 -0400
Received: from mail-eopbgr810082.outbound.protection.outlook.com ([40.107.81.82]:3308
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726331AbfGaJkq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 05:40:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U7EXvjpAJrl0xgWHUKcZG83N2DZ27DWOQdQupCuXagKj+MS41PYT8qy14YwPATn7E3kjATOAV2CJsP8lU0W8jieXCtbYP9F5M/qKsBUsR2GvOcsPqTnvNGEXq3GYRJNSKKCBocWwUTbu1uxe1/PGQ2wxXLH6titkEbqBbhsWuSSB+/bSBfygmMSXh/oa0zts0UgqnaM2JXbPsoERGrihgBIwQS17RWafbcADlksqVaKQ50A9AyBbLBP+6MHKmJCY3F/xiuJinD4bKEq9FAA1diPlDu7WWjRf+W2VBZ1ltFdixpGq3NRpWJd8A0XzdBkugoPsjpyblBIH4mGrT2jB1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TE9Fe7TyXqHDJDBmacXUDRxXvG9ES6SmcTNtaPcZSEA=;
 b=czrddoCqbH7d6oMH0YUqCIYT76vb976jJraSDYmgH2dezpWgM/0pWYyRFfD0ffWeyuH9sn2KZwtK50uodgmxn8sM4+0cFZGP6P7s37gPZkTwU2g2u0iks393hPJVibVspDPqFlJGHBU23AIM//6knKSlEIddIKrCyeNQgBQgY5NU6piIj4KCvT1ixh8YZncGD4j8i4ojU48A9wY/onlTrWpsiXCSZXep6hbSUgHFH3ck8WoJXoS9xCrFseB/z6ZP5QfenZ7dvj+HnuNStxFGxGDc2W9t6J4EeJmm6VVu+yJ3lae1eOVFEHCBMnXJDASWwsRU5PtSs/OfpxpdDsaPwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=microchip.com
 smtp.mailfrom=xilinx.com;dmarc=bestguesspass action=none
 header.from=xilinx.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TE9Fe7TyXqHDJDBmacXUDRxXvG9ES6SmcTNtaPcZSEA=;
 b=lLuKv1DG4GqZpTmBM8ANUeaLk8yApSDOIV8zAqUXe4jcy+KHc230QLTkufBehsXnquHTDS2pn8BDNMfaHZuWhTs7t1uuX3Sh+9VhvdlET32Qcjvn4IaEw7FknxD62Vg2tY1x2/GE4oADa7tSHKGe/EMterFTQq7t9XixPTjQz5s=
Received: from SN4PR0201CA0042.namprd02.prod.outlook.com
 (2603:10b6:803:2e::28) by SN6PR02MB4766.namprd02.prod.outlook.com
 (2603:10b6:805:90::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2115.14; Wed, 31 Jul
 2019 09:40:44 +0000
Received: from SN1NAM02FT061.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::201) by SN4PR0201CA0042.outlook.office365.com
 (2603:10b6:803:2e::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2136.14 via Frontend
 Transport; Wed, 31 Jul 2019 09:40:44 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 SN1NAM02FT061.mail.protection.outlook.com (10.152.72.196) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2115.10
 via Frontend Transport; Wed, 31 Jul 2019 09:40:44 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1hsl6B-000748-Fo; Wed, 31 Jul 2019 02:40:43 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1hsl66-0005wT-C3; Wed, 31 Jul 2019 02:40:38 -0700
Received: from [10.140.6.13] (helo=xhdharinik40.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1hsl65-0005rH-3F; Wed, 31 Jul 2019 02:40:37 -0700
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     nicolas.ferre@microchip.com, davem@davemloft.net,
        claudiu.beznea@microchip.com, robh+dt@kernel.org,
        mark.rutland@arm.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        michal.simek@xilinx.com, harinikatakamlinux@gmail.com,
        harini.katakam@xilinx.com, devicetree@vger.kernel.org
Subject: [RFC PATCH 0/2] Macb SGMII status poll thread
Date:   Wed, 31 Jul 2019 15:10:31 +0530
Message-Id: <1564566033-676-1-git-send-email-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.7.4
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(979002)(4636009)(346002)(39860400002)(396003)(136003)(376002)(2980300002)(189003)(199004)(336012)(486006)(36386004)(426003)(6666004)(476003)(70586007)(7696005)(356004)(2906002)(126002)(51416003)(9786002)(70206006)(26005)(2616005)(316002)(63266004)(48376002)(4744005)(106002)(478600001)(44832011)(47776003)(8676002)(50466002)(36756003)(186003)(4326008)(16586007)(81156014)(50226002)(8936002)(305945005)(81166006)(5660300002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR02MB4766;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 45253633-10c3-4862-9bba-08d7159b28c9
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:SN6PR02MB4766;
X-MS-TrafficTypeDiagnostic: SN6PR02MB4766:
X-Microsoft-Antispam-PRVS: <SN6PR02MB476639C4BF5BD02374583F87C9DF0@SN6PR02MB4766.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-Forefront-PRVS: 011579F31F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: OAwlRAcReRq1yuQYUBOfvvH9zanZWqnM3r9LSpnKot1y3qHirVzlWSlJbBi/fz7uHMA30SfLHGIbrxI6cLFSOaH965uTzl6dQY56qA7xl9vq9QiFo72E2H+DT0jixgFB9aiw+WAPm7mrsPgtp5b8jY/POHQRzcD5KUjhN8OYM3HTkhZqCymJEbQQSJWI3bshdAkbXvWi2ONp9zPQaz/6/WeONNXCq4jC7el6crHFaY3yMRenBCvDTSEK61jZRi6FdFzrCS2gvzp/sbi8RNuiB/476w/eerBD6FWprIDfdesUqaQ7ihZLxPfN9vI3Fr3k6th1gbQgUi79iYaJS92xV1xnzesRx9G4khNp6C4gp5XaBYjrBqny+YMQhFvpv2MhDBg4A6cuMylROcOQuztpC8nULUKRIKjd0TI5B3XCf0k=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2019 09:40:44.0666
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 45253633-10c3-4862-9bba-08d7159b28c9
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB4766
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When PS GEM is used with SGMII mode without an external PHY
on board, add a link status reporting mechanism.

Harini Katakam (2):
  dt-bindings: net: macb: Add new property for PS SGMII only
  net: macb: Add SGMII poll thread

 Documentation/devicetree/bindings/net/macb.txt |  4 ++
 drivers/net/ethernet/cadence/macb.h            |  8 ++++
 drivers/net/ethernet/cadence/macb_main.c       | 65 ++++++++++++++++++++++++--
 3 files changed, 73 insertions(+), 4 deletions(-)

-- 
2.7.4

