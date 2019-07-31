Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0A3C7BD75
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 11:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728661AbfGaJk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 05:40:58 -0400
Received: from mail-eopbgr750059.outbound.protection.outlook.com ([40.107.75.59]:37505
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726331AbfGaJk5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 05:40:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YgWrA2c9XU3ynhriNY6f00q+OpecP9Zq6LZp5jny6HiHHFrxpiPCrRGla7ObzDIDujYl6CB+72Sl3O0ZOXSdQjLIpZK6nn5gommZwm23MQ8kaVJxvt9zlf87O/fZ3uJYKW4AyY6RTrOo9DBatbrQsDhKADQbYTPPpnyJ2Y1ILU/jEwKZ9VFPqe5dDWKWillAwtZL3NoW0OD5P4H8zGVPJxckPvIYwYiQTV2FK+XC8LsStHDiafSO8a/yr31SxbB0gHAXxnM0iYzog7SXDFpYD/c29ark0iys5Yvf+FfNiS96hgom1/g6GbeOaRViqpmXFflwzTAtFrg1mvhZo/pSxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tkbMHFfxQVFJZtoQkw21YHz12uP4E+Kr6rdpINBCrPc=;
 b=E1SbAOYAvOAvOujIcXI628strb72nfNdUhFV6YdQCkqG8pVILcqnis7vyEh4XvLBEcj0GQM6psGgmcO4gWtPrZo+N8b9YZCJcRbTG2zCKpD1s0EbRzSeYwNNcm3RBvKGN0QoBWFkyElpEks6TRB/7ezLtayJVFW08ajdqzq1qevz5sczkzL50cXvhIwShX3fuuWTmRoN1+nnnS3SPNBX1y2ZWJiEboBHat4RkF86KbJBR3woDiwUTbcvv92kQj+iiMJCwyorZKbbqpIEYnCrrbtJt7ypw0zfgxrgxLPCd49KCT4Xcrlko7Yj30Z9yAOLvz4KWCGaEBL4FIpGplbwdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 149.199.60.100) smtp.rcpttodomain=microchip.com
 smtp.mailfrom=xilinx.com;dmarc=bestguesspass action=none
 header.from=xilinx.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tkbMHFfxQVFJZtoQkw21YHz12uP4E+Kr6rdpINBCrPc=;
 b=jVXpaoL/R18wPKXh36yfGK/kUJ6G3COmdCUfEixvRps1C+aWMuKpbJ4Q5GvDkC8VNBqzPZKisoQZCUWwIl5bZyb7Oxv2YeWnCGkLEJg5LKA9GnAo6eEgVzOpMDRuLOajiyN7Hf1XwUlSDgJQuOyX17nTXWZxpY9QWClFJO3Ouss=
Received: from MN2PR02CA0002.namprd02.prod.outlook.com (2603:10b6:208:fc::15)
 by MN2PR02MB6751.namprd02.prod.outlook.com (2603:10b6:208:1dc::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.14; Wed, 31 Jul
 2019 09:40:54 +0000
Received: from SN1NAM02FT012.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::206) by MN2PR02CA0002.outlook.office365.com
 (2603:10b6:208:fc::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2115.15 via Frontend
 Transport; Wed, 31 Jul 2019 09:40:54 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.100)
 smtp.mailfrom=xilinx.com; microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.100 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.100; helo=xsj-pvapsmtpgw02;
Received: from xsj-pvapsmtpgw02 (149.199.60.100) by
 SN1NAM02FT012.mail.protection.outlook.com (10.152.72.95) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2115.10
 via Frontend Transport; Wed, 31 Jul 2019 09:40:54 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66]:43619 helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw02 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1hsl6L-00067Y-J7; Wed, 31 Jul 2019 02:40:53 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1hsl6G-00060P-Fi; Wed, 31 Jul 2019 02:40:48 -0700
Received: from [10.140.6.13] (helo=xhdharinik40.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1hsl68-0005rH-HM; Wed, 31 Jul 2019 02:40:41 -0700
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     nicolas.ferre@microchip.com, davem@davemloft.net,
        claudiu.beznea@microchip.com, robh+dt@kernel.org,
        mark.rutland@arm.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        michal.simek@xilinx.com, harinikatakamlinux@gmail.com,
        harini.katakam@xilinx.com, devicetree@vger.kernel.org
Subject: [RFC PATCH 1/2] dt-bindings: net: macb: Add new property for PS SGMII only
Date:   Wed, 31 Jul 2019 15:10:32 +0530
Message-Id: <1564566033-676-2-git-send-email-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564566033-676-1-git-send-email-harini.katakam@xilinx.com>
References: <1564566033-676-1-git-send-email-harini.katakam@xilinx.com>
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.100;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(136003)(396003)(376002)(2980300002)(189003)(199004)(48376002)(51416003)(36386004)(16586007)(2906002)(36756003)(7696005)(336012)(9786002)(486006)(50226002)(126002)(44832011)(106002)(316002)(47776003)(11346002)(50466002)(426003)(446003)(476003)(2616005)(26005)(8936002)(478600001)(76176011)(8676002)(186003)(81166006)(81156014)(305945005)(70206006)(5660300002)(63266004)(70586007)(4326008)(4744005)(356004)(6666004)(5001870100001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR02MB6751;H:xsj-pvapsmtpgw02;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-100.xilinx.com,xapps1.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a8a183d-97e5-4c02-b347-08d7159b2eb4
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:MN2PR02MB6751;
X-MS-TrafficTypeDiagnostic: MN2PR02MB6751:
X-Microsoft-Antispam-PRVS: <MN2PR02MB67514047FAFC08BD603A75A3C9DF0@MN2PR02MB6751.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:1332;
X-Forefront-PRVS: 011579F31F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: FHXFqdDjwMdWwLTpLOSogyLIF1KIUpfAAs7rB/FBFSLggpon1T0L92bbXWn50FjXQnVe8CTvWoJWRMsPNCTReScyXXsuga+vf5kKm85SBnXuymWl7pAmeWAgeJ5S315XYZ6lE59K0aAkOvtgbB9clVn950B/jBmrPO3PP6Xq7sfwEEAzrZazWBwLbKetf03sjXlXGCQK543e/+b8cucNmehiE+7YpwPZ5nr0c+W/dxiJZElpUKbsYR/3YmkwRXtlgiOV9z6Gp861cNmrBLOmVXIMHk34gPdiSK8TjXdGnV8RQx4drtAdIrrv0otInnEC74wP9S/UpPl6+fkCXCHr1ZPz7sjCNZ4r55WhKE2b0XHYFFSKeg4tiFBHbtR5cEjcTpL1kFj/PVGemxsKbTcgK78aqksn66jpv5QjYE9mKm0=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2019 09:40:54.0320
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a8a183d-97e5-4c02-b347-08d7159b2eb4
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.100];Helo=[xsj-pvapsmtpgw02]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB6751
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new property to indicate when PS SGMII is used with NO
external PHY on board.

Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
---
 Documentation/devicetree/bindings/net/macb.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/macb.txt b/Documentation/devicetree/bindings/net/macb.txt
index 63c73fa..ae1b109 100644
--- a/Documentation/devicetree/bindings/net/macb.txt
+++ b/Documentation/devicetree/bindings/net/macb.txt
@@ -38,6 +38,10 @@ Optional properties for PHY child node:
   up via magic packet.
 - phy-handle : see ethernet.txt file in the same directory
 
+Optional properties:
+- is-internal-pcspma: Add when GEM's internal SGMII support is used without
+  any external SGMII PHY.
+
 Examples:
 
 	macb0: ethernet@fffc4000 {
-- 
2.7.4

