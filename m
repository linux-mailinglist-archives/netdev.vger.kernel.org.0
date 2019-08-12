Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4FC89AE7
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 12:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbfHLKHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 06:07:33 -0400
Received: from mail-eopbgr780074.outbound.protection.outlook.com ([40.107.78.74]:36006
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727559AbfHLKHO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 06:07:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WFxQ5cnXpcK10Yu9qw62qPT4x5T/FKKk+kOYUCsrM33ixPMZ0pCrIE55iBcCz6W4145Ku6WujdqNUmkdkmlfZF06zNTgl5Szhci3tfEXOEya50QV9Gvxkd9jQ7N3DaggsPrqsTsW5VVEr20mtxd2LAKyo63kNsVJyL/oLwBZDxLvw4d1IrwusjvOboojegJd6UEmZ1QnKDSTaSjek92geUbmGb4PXmyFlxa09bSee4Xl8r9GgrFbcDao4KaazFrTkwen31ncok9ba1f8tscV1sZi8UYK1gBqi+iGUZz2jbsULERs3e3PPtgs82REJTkQeE68miGDDEujcSe4N7C4Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gd9Sde4mXA9xbp6C+h9Ib1RAFiN2ZowJDMuKLdP0gqc=;
 b=XQ+eMW7dRNe6RIijB871W92/obEAsSYlI9+axy1Qxuo7d6NBFoxJ3173ZnGQyDbMsSd7YSP0eUxSMmE0RwmyKdLSGiKLX1BpRnwGLPa6CXzDl0PSWJFJSyAd2qNeTMH382yZep7wn5fV9EsHs77XNet0XGTpq/Qq8x3nDvs6blISlBY+uBFvBI+R08iq6odsp2FZDxf8ggiEKS8F1qzQEknn1vB077gN0GXkg9Ehyaa1aesmytrb8HeaZIEz9Zy0N/H4R6e66ruUyDCsSdlSoo8r0sXVWL2mPjsp/PrJGZEHNZxlxEkAOAvyzO+UzHfqYkA22L4QfZOYyJSLx4WFnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 149.199.60.100) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=xilinx.com;dmarc=bestguesspass action=none
 header.from=xilinx.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gd9Sde4mXA9xbp6C+h9Ib1RAFiN2ZowJDMuKLdP0gqc=;
 b=IY022Gbe5KM7+pGMZIyn4u5m/a7EqIJqNRAuFhF4XS3rodDoD214p+gttIicsUFCPHJnn/1J8LqyeR3rK7KW/auJAjbkqMMR2N8fHDEFhPtut5rCIibbxPKLawI/lm7N7nKD6Cwsu3elQzKcktrpvT0NWNsqNgLaRCFuots8sw8=
Received: from CY4PR02CA0007.namprd02.prod.outlook.com (10.169.188.17) by
 BYAPR02MB4823.namprd02.prod.outlook.com (52.135.234.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.20; Mon, 12 Aug 2019 10:07:09 +0000
Received: from SN1NAM02FT015.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::208) by CY4PR02CA0007.outlook.office365.com
 (2603:10b6:903:18::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.16 via Frontend
 Transport; Mon, 12 Aug 2019 10:07:09 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.100)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.100 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.100; helo=xsj-pvapsmtpgw02;
Received: from xsj-pvapsmtpgw02 (149.199.60.100) by
 SN1NAM02FT015.mail.protection.outlook.com (10.152.72.109) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Mon, 12 Aug 2019 10:07:08 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66]:54751 helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw02 with esmtp (Exim 4.63)
        (envelope-from <appana.durga.rao@xilinx.com>)
        id 1hx7EK-0007SN-Bv; Mon, 12 Aug 2019 03:07:08 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <appana.durga.rao@xilinx.com>)
        id 1hx7EF-0004Wy-8A; Mon, 12 Aug 2019 03:07:03 -0700
Received: from xsj-pvapsmtp01 (mailman.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x7CA6r2s032297;
        Mon, 12 Aug 2019 03:06:54 -0700
Received: from [10.140.6.6] (helo=xhdappanad40.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <appana.durga.rao@xilinx.com>)
        id 1hx7E5-0004OP-A3; Mon, 12 Aug 2019 03:06:53 -0700
From:   Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        michal.simek@xilinx.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Venkatesh Yadav Abbarapu <venkatesh.abbarapu@xilinx.com>,
        Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>
Subject: [PATCH v2 1/5] can: xilinx_can: Skip error message on deferred probe
Date:   Mon, 12 Aug 2019 15:36:42 +0530
Message-Id: <1565604406-4920-2-git-send-email-appana.durga.rao@xilinx.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565604406-4920-1-git-send-email-appana.durga.rao@xilinx.com>
References: <1565604406-4920-1-git-send-email-appana.durga.rao@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.100;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(136003)(396003)(376002)(2980300002)(189003)(199004)(50226002)(54906003)(316002)(6636002)(51416003)(7696005)(70206006)(16586007)(70586007)(76176011)(106002)(11346002)(36386004)(36756003)(6666004)(4326008)(8936002)(486006)(2616005)(336012)(8676002)(5660300002)(426003)(356004)(478600001)(14444005)(2906002)(305945005)(81156014)(446003)(47776003)(48376002)(81166006)(50466002)(63266004)(476003)(126002)(107886003)(26005)(15650500001)(186003)(9786002)(5001870100001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR02MB4823;H:xsj-pvapsmtpgw02;FPR:;SPF:Pass;LANG:en;PTR:xapps1.xilinx.com,unknown-60-100.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9369a2b-50c7-43e5-4070-08d71f0cd64a
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:BYAPR02MB4823;
X-MS-TrafficTypeDiagnostic: BYAPR02MB4823:
X-Microsoft-Antispam-PRVS: <BYAPR02MB48235DC7D255CAE77E7AE689DCD30@BYAPR02MB4823.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 012792EC17
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: yB4axrFC+M5ioS++W1yBPc9KjEPXR7Yiztc7zHFRN59tKdc5SialusTqgnHwrZEWeFvROjfdhVLU/5OqHs+jkR5bpgUqZjh+HBkH+n79OM+yfqTEKD/NqaaA/MefsUBocZP7mCjIbFOrjQr9Pf9PpbpHifoeHJ78WRgyfBZV8pfS+EO6/FH5WsBLmPs54Qh59qq+K4PmXIZYx9mTcgZLAMExwI+b+z5Zcm5rAFETnZZhMPS1Ryx0mxdp+rqCXGHdX5v9jWr7+arab+2A0gvL8r076AVzId3swscbHiOV7mZhU79xrE31TpAzE8+z5e0U3tDfbv5Cu8wrlQefLvt5i6+QlnTV2kUz3OZuLfXuvAEg6BK9JNp+Tf1sF8jjr2rUTpoZubB4U3ofgOGtsJaJzj72POM25FdX4+K5sL+iojY=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2019 10:07:08.8581
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d9369a2b-50c7-43e5-4070-08d71f0cd64a
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.100];Helo=[xsj-pvapsmtpgw02]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB4823
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Venkatesh Yadav Abbarapu <venkatesh.abbarapu@xilinx.com>

When can clock is provided from the clock wizard, clock wizard driver may
not be available when can driver probes resulting to the error message
"Device clock not found error".

As this error message is not very userful to the end user, skip printing
it in the case of deferred probe.

Fixes: b1201e44 ("can: xilinx CAN controller support")
Signed-off-by: Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>
Signed-off-by: Venkatesh Yadav Abbarapu <venkatesh.abbarapu@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/net/can/xilinx_can.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index bd95cfa..ac175ab 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -1791,7 +1791,8 @@ static int xcan_probe(struct platform_device *pdev)
 	/* Getting the CAN can_clk info */
 	priv->can_clk = devm_clk_get(&pdev->dev, "can_clk");
 	if (IS_ERR(priv->can_clk)) {
-		dev_err(&pdev->dev, "Device clock not found.\n");
+		if (PTR_ERR(priv->can_clk) != -EPROBE_DEFER)
+			dev_err(&pdev->dev, "Device clock not found.\n");
 		ret = PTR_ERR(priv->can_clk);
 		goto err_free;
 	}
-- 
2.7.4

