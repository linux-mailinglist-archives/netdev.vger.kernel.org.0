Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8376989ACE
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 12:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727748AbfHLKHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 06:07:02 -0400
Received: from mail-eopbgr770078.outbound.protection.outlook.com ([40.107.77.78]:44346
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727409AbfHLKHC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 06:07:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F14PKUYDbliNZs/E+3AkeBuMT5rtyFVqTaoZVR60M3+Vyojm56aQob3+oYowVzxHfQ/lES7S9iUM0odhoM07+VJ8vK7ZrN6c2sd4uAi98OviFi6Dm+ZrnO0YmBpDiVtbD+31yvF/m5ritPFovdQO5t/ATUXMHuQ/TrHyo2qmCyC4E1RGihGBXbphPL+j5UV0cN2j79nZsAw8Yt+OXiCUbHtltbf/5JNdZHGa9CbY77CcXuf5GIf0PqqxZXL3IuhB69yTUIt0bTZjGZX/3aHEi2gxnNviMbJkDUNalhS429X7F3eTbVOZlDvm3UvuRWuLJY5q9FYvRgS9IrI0shePmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XEzoY0em8tcyd3SujX5IHtKC6ikj6UNssIrG7GpE20M=;
 b=QH4AMC5QZ3+nSOEthNuby0M5pxgIHDNnlMHRpo2jnCNXRYj/DvG8UE6up4aId+R9QFGkgDKQtBGZDRa4K2DbeluvNZvmVE1lb6rxua6/Kpgu4M0tIFsP718p5PkOd1WBtJJbTi5W4oufBhWuVK5g8wAD63KIGV2JIhd7zE3WvXwRduLHZ8dB/JLmcbIRTh+DUIr/2vo+N3SWiJ9EwfGLtZmZ2+ZHF8rm1lccpeWvXeiJ8QZVw8SBQgVgbuhcB2hcAaJuHSoCLSKs95tEa7JdUVf1LeL7Xs4qnj/jtbqbvtk4h+GsG0HEBzQ2TANBRDeBEduL++l9NmMDnv1Im7BmiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XEzoY0em8tcyd3SujX5IHtKC6ikj6UNssIrG7GpE20M=;
 b=tUbIJyXo8Retmbspgnn/7VqmXzf0tWTCUJ1yjHbJXUNx1zfIVMIV0Ht6g1lmFP9J9iHDDJSrNqVD3ktOKPitTKXtjkC+opKI/9b56Y4zDiicDgOAWvysw7zgBUlAla4I3+gnJVzTPfekQMLXxAkENi4VmT2lkCYUy5ews0TT0hc=
Received: from SN4PR0201CA0037.namprd02.prod.outlook.com
 (2603:10b6:803:2e::23) by SN1PR02MB3808.namprd02.prod.outlook.com
 (2603:10b6:802:31::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.21; Mon, 12 Aug
 2019 10:07:00 +0000
Received: from CY1NAM02FT012.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::201) by SN4PR0201CA0037.outlook.office365.com
 (2603:10b6:803:2e::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.14 via Frontend
 Transport; Mon, 12 Aug 2019 10:07:00 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 CY1NAM02FT012.mail.protection.outlook.com (10.152.75.158) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Mon, 12 Aug 2019 10:06:58 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <appana.durga.rao@xilinx.com>)
        id 1hx7EA-0002PA-5n; Mon, 12 Aug 2019 03:06:58 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <appana.durga.rao@xilinx.com>)
        id 1hx7E5-0004P8-1x; Mon, 12 Aug 2019 03:06:53 -0700
Received: from xsj-pvapsmtp01 (xsj-smtp.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x7CA6oEb003599;
        Mon, 12 Aug 2019 03:06:51 -0700
Received: from [10.140.6.6] (helo=xhdappanad40.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <appana.durga.rao@xilinx.com>)
        id 1hx7E2-0004OP-AF; Mon, 12 Aug 2019 03:06:50 -0700
From:   Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        michal.simek@xilinx.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>
Subject: [PATCH v2 0/5] can: xilinx_can: Bug fixes
Date:   Mon, 12 Aug 2019 15:36:41 +0530
Message-Id: <1565604406-4920-1-git-send-email-appana.durga.rao@xilinx.com>
X-Mailer: git-send-email 2.7.4
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(376002)(396003)(136003)(2980300002)(199004)(189003)(356004)(478600001)(14444005)(6666004)(16586007)(106002)(48376002)(316002)(36386004)(107886003)(81166006)(81156014)(8676002)(6636002)(4326008)(305945005)(5660300002)(4744005)(186003)(2906002)(26005)(36756003)(63266004)(70206006)(70586007)(50226002)(8936002)(476003)(336012)(126002)(47776003)(50466002)(2616005)(7696005)(51416003)(486006)(9786002)(426003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN1PR02MB3808;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e5259a4-bb52-4adf-2eef-08d71f0cd049
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:SN1PR02MB3808;
X-MS-TrafficTypeDiagnostic: SN1PR02MB3808:
X-Microsoft-Antispam-PRVS: <SN1PR02MB38080D876B3BC8068D286823DCD30@SN1PR02MB3808.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:1122;
X-Forefront-PRVS: 012792EC17
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 5Fu+XKACbIE6R4b9bEJGCldsrPjzKSTMk7TNEW70ZgM0P3r3rYnQZFjRMhdFfcmT5blrEWzS0+5g1mSWfIyujibMflkD30hCcK7NoK6R6ls3BBTPuZX5A06s2XPwkMWMqtRWfCX5gsU0PwbJIPA7IDhnsIBGc1858S5PiqtIceZ2LFEHUsOYx9i182Dz91hj2UfSeCmj35ehw31pAV6KgriPokAMm55vE8UitqT3BXsREzh81634wEZ1YjW2PCmgTzMKDcZkP2I1O6e2t0AA03thUoVlcmBpubZ8Ik4SbbNQIfUEvYlZSRdU7FAD59rTL5k8kFUMZbKvUk+xWoDKUvxH5NYv24xM+ffCJW0UZZ/I8KDgf+LpM7ajPdLHSqgRmuXiQX+ss6HgQ2bzZcu+uzBB/ougpU2/JMVivEP6tPI=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2019 10:06:58.6867
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e5259a4-bb52-4adf-2eef-08d71f0cd049
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR02MB3808
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series fixes below issues
--> Bugs in the driver w.r.to CANFD 2.0 IP support
--> Defer the probe if clock is not found

Changes for v2:
[1/5]:
--> Improved commit description
[1/5] and [5/5]:
--> Added sob line
[1/5], [2/5], [3/5], [4/5], [5/5]:
--> Added Fixes tag in the commit description

Appana Durga Kedareswara rao (3):
  can: xilinx_can: Fix FSR register handling in the rx path
  can: xilinx_can: Fix the data updation logic for CANFD FD frames
  can: xilinx_can: Fix FSR register FL and RI mask values for canfd 2.0

Srinivas Neeli (1):
  can: xilinx_can: Fix the data phase btr1 calculation

Venkatesh Yadav Abbarapu (1):
  can: xilinx_can: Skip error message on deferred probe

 drivers/net/can/xilinx_can.c | 162 +++++++++++++++++++------------------------
 1 file changed, 72 insertions(+), 90 deletions(-)

-- 
2.7.4

