Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 557111039B5
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 13:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729572AbfKTML6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 07:11:58 -0500
Received: from mail-eopbgr730075.outbound.protection.outlook.com ([40.107.73.75]:57120
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729010AbfKTMLt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 07:11:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XOkc8yltdSc2Bxk7XXgFXY9YjpL16YNuQXu/vOuBl8qOWD6a/EMBdbI7fn48NU/u51g76Y/NZRjqmNXV/kMZoZtUmpErWEWW4KPXNQObswtZRsQZthcxvrpZ2+2bnmsn1AGYcUnnh6c35UWCgrwXNe0jTs0agvY5AWvknDqrP882yJcImLvltLqlmH8z6vw0DJ+MpZ477f/R3aT+A6nfoj3LucgQpYkWNZOauaiZ3eMSAKzbJliRUyXu2LdsXvgR85Vk2aYS4JoXqOOCQnpa4X697+8K7fgMBPD5Rm2xsQtIcsI2KheHbnUv++6XbandxQA+YsmvHqtrqPf700oXsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XMncJ9R2rybBL4gEjMNsz2X1ffSoXG9/3O7cYKeYC4Q=;
 b=bAQ24c1CmKUAqCHG0KAmJ+JCmLlRWmTA+/gDZCsunge16K0iBCO6F/z7/hitYtae5jVsk3s+I0tSIdjhOFDAdmwgwOXGP4uU30wU+T8rPXt6j/A75CZPx1tXqTJT+DhUl8h3g6S3FeTbqz+bAhpcYRwv5NR9LYSBGAiYBISBupcssBS8tP1nWfRQ6W9Ae1GBok9aBaIsFtPGLrjRPIVjX/w7gFjDek036l9K0y8A8m29x/sw8E6YsTY6KDrgrerzf7lJiiF/I2vHmR62hoUtdbk2leCAM8JTlAJmh0GieXtrRKKRjyoCgD1gfpqlg3SXH5+8+cvQlhCLcik50S9PJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=grandegger.com smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XMncJ9R2rybBL4gEjMNsz2X1ffSoXG9/3O7cYKeYC4Q=;
 b=LoVb3jDe4y6/dVe3PC0CxQQ5sHBCDZQvRulTXkugJiDLPB9+/JY0bx+1eAIeXLioWdGpJ1RzhRCQrkEwsh0BeBaJxKlBImDGT/rLLDGaWiU8+VgTLNZQS+yyujt024iKfvNmm0Are26kyQV7OQq/TVdTpFbC2maRMM20M0N5tYc=
Received: from DM6PR02CA0128.namprd02.prod.outlook.com (2603:10b6:5:1b4::30)
 by SN6PR02MB4846.namprd02.prod.outlook.com (2603:10b6:805:98::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2451.23; Wed, 20 Nov
 2019 12:11:45 +0000
Received: from BL2NAM02FT032.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::207) by DM6PR02CA0128.outlook.office365.com
 (2603:10b6:5:1b4::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2451.29 via Frontend
 Transport; Wed, 20 Nov 2019 12:11:45 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; grandegger.com; dkim=none (message not signed)
 header.d=none;grandegger.com; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 BL2NAM02FT032.mail.protection.outlook.com (10.152.77.169) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2474.17
 via Frontend Transport; Wed, 20 Nov 2019 12:11:44 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <srinivas.neeli@xilinx.com>)
        id 1iXOpk-0000gb-DN; Wed, 20 Nov 2019 04:11:44 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <srinivas.neeli@xilinx.com>)
        id 1iXOpf-0002gB-9T; Wed, 20 Nov 2019 04:11:39 -0800
Received: from [10.140.6.6] (helo=xhdappanad40.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <srinivas.neeli@xilinx.com>)
        id 1iXOpX-0002fi-MR; Wed, 20 Nov 2019 04:11:32 -0800
From:   Srinivas Neeli <srinivas.neeli@xilinx.com>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        michal.simek@xilinx.com, appanad@xilinx.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        git@xilinx.com, nagasure@xilinx.com,
        Srinivas Neeli <srinivas.neeli@xilinx.com>
Subject: [PATCH 0/2] can: xilinx_can: Bug fixes on can driver
Date:   Wed, 20 Nov 2019 17:41:03 +0530
Message-Id: <1574251865-19592-1-git-send-email-srinivas.neeli@xilinx.com>
X-Mailer: git-send-email 2.7.4
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(396003)(136003)(346002)(189003)(199004)(70206006)(70586007)(186003)(9786002)(50226002)(8936002)(8676002)(81156014)(81166006)(2906002)(106002)(44832011)(336012)(316002)(126002)(426003)(486006)(2616005)(478600001)(16586007)(476003)(36386004)(6636002)(47776003)(107886003)(5660300002)(356004)(305945005)(6666004)(4744005)(7696005)(51416003)(14444005)(26005)(36756003)(50466002)(48376002)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR02MB4846;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1346834c-7a38-481a-980b-08d76db2cfa3
X-MS-TrafficTypeDiagnostic: SN6PR02MB4846:
X-Microsoft-Antispam-PRVS: <SN6PR02MB4846A112ECEFF4D6F80C1FD2AF4F0@SN6PR02MB4846.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 02272225C5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2lih1yrBU8sljcTymTPteFbdI556wAo6ZEdNALF8t+UEBdWKu3+hHxjosu31JUd4vAx3HItNws9AWslfVc3YmVxUMzP4yHBAZien3jUvAP06iycTCQJGrBuFhSHrpkxPg7DQLMG4HPQSnNqWFa+EhgN4/dmW37IcAQZMalW726uJ/0d5Ghp1LYEiizxROvnOzgKaBjQ9Wm+fPYfqCnXJTJBCnA8pqXz2sxHfPYU4eb/PC0yagw3ps2Y69QXrtctEO5Ebs7LrL5r7TPdaQ22EggtY6B/45LwHqTmV2LPx8ggGog/+4fedxm+VM9cmrtClRtSZFqszz3FiFAtcNEpfzIP94S/LasTOlnrCrGbRHDhMHXTrZjr+/l4hjS4Fawa9LIqb64JPYmv5t86nxT4IYU74axXacT11IhKnDljCWZWMy1JgTNm6WJvqMZUi2Uzl
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2019 12:11:44.9704
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1346834c-7a38-481a-980b-08d76db2cfa3
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB4846
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series does the following:
-skip printing error message on deferred probe
-Fix usage of skb memory

Srinivas Neeli (1):
  can: xilinx_can: Fix usage of skb memory

Venkatesh Yadav Abbarapu (1):
  can: xilinx_can: skip error message on deferred probe

 drivers/net/can/xilinx_can.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

-- 
2.7.4

