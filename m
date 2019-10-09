Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3A3D0840
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 09:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfJIHaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 03:30:05 -0400
Received: from mail-eopbgr720054.outbound.protection.outlook.com ([40.107.72.54]:42466
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725776AbfJIHaF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 03:30:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PWowcD8RCgSWzcYRfvS8Hh3SRIcycaIeJ33BxK2nm/OK/6aGVNyJtPZDe1QB6PC/wvt8UR19t0HETp5ODbqdn3QwDkYfGdiaaHcm4hmKO9adyyAdgt+zWoSTkFgaY89e0hJObaqFORGpYoXiKirI3/ffBJjYMhvSS8fN4BpfG2f1ss7jzHLSiYUmM7nExhB8TkcMmTb99lvPH43y6TFBbSgOAQ9JjvGjUo2HaPaF8rOqzIETI7e8gZWt/XQF77JLK79+JxaTu3fYO186T22tHiOSWxNeQxCYehcByc7Wjuv1o4p2u1IkVz2h2nlnz4vyHD0gc3BV90npVLIxoJQSmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+bZJNYOv4ZWN2g4MNLRnnY+3/fHW4Oofm0sv58wwsZM=;
 b=FosU3JqIjNYFQsjOPdnL4P1H1m310yn9KXi50ZAc4PatqM5nDtUkDaM281wQCIjJ9otFN0UhVJCLmZ/M6JKgyWizenPj1H+yotN5G/Hc5SHIEy2BkGYmnvcHYr7AkIUjIC2egtTjaZGJ40ssb2F4rrBNFBhN5m3J4Dxj4Vts6KCA9KW0vGhvLx78yq4hGSb02XHXjtv0pAiVx4PvhEJtQ40ytv2HxjGizCnw1EQP4yVVllXAbeUjK7dJqxrOqzGL+0TRpQ0SNEHrrQ9sFovNCP+HBhCywLlmQboLYI6B1jBrS9MdQq9cyOYT40NgV/pxR9OWvv+4yS505MMEJo+XLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+bZJNYOv4ZWN2g4MNLRnnY+3/fHW4Oofm0sv58wwsZM=;
 b=SGf2BAV1yQ3pJhHfEN0KyNR7e2uCgD2oP0giXC8wFXyzudAM9uv9T0Jv+J1y2m3HlhC6YdzcKEmOtpTitONOxLeKgUgs/QoIa1coPkqHJXTYxPerzJ8nnCIcH8+skyENYxrNCQLYwY7NOk6AaKHsUtW1xGu4WqkRqyP48MnmV88=
Received: from SN4PR0201CA0052.namprd02.prod.outlook.com
 (2603:10b6:803:20::14) by BN6PR02MB2770.namprd02.prod.outlook.com
 (2603:10b6:404:102::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2347.16; Wed, 9 Oct
 2019 07:30:02 +0000
Received: from BL2NAM02FT016.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::202) by SN4PR0201CA0052.outlook.office365.com
 (2603:10b6:803:20::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2347.16 via Frontend
 Transport; Wed, 9 Oct 2019 07:30:02 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 BL2NAM02FT016.mail.protection.outlook.com (10.152.77.171) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2327.21
 via Frontend Transport; Wed, 9 Oct 2019 07:30:01 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <appana.durga.rao@xilinx.com>)
        id 1iI6Q5-00066D-2e; Wed, 09 Oct 2019 00:30:01 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <appana.durga.rao@xilinx.com>)
        id 1iI6Pz-0005Um-Vg; Wed, 09 Oct 2019 00:29:56 -0700
Received: from xsj-pvapsmtp01 (mailhub.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x997TqvY018594;
        Wed, 9 Oct 2019 00:29:52 -0700
Received: from [10.140.6.6] (helo=xhdappanad40.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <appana.durga.rao@xilinx.com>)
        id 1iI6Pv-0005UH-RI; Wed, 09 Oct 2019 00:29:52 -0700
From:   Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        michal.simek@xilinx.com, anssi.hannula@bitwise.fi
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>
Subject: [PATCH] net: can: xilinx_can: Fix flags field initialization for axi can
Date:   Wed,  9 Oct 2019 12:59:47 +0530
Message-Id: <1570606187-30935-1-git-send-email-appana.durga.rao@xilinx.com>
X-Mailer: git-send-email 2.7.4
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(376002)(396003)(136003)(199004)(189003)(478600001)(47776003)(16586007)(106002)(51416003)(8676002)(70586007)(7696005)(70206006)(48376002)(2906002)(81166006)(316002)(81156014)(26005)(5660300002)(8936002)(14444005)(36386004)(186003)(50226002)(4744005)(356004)(6666004)(9786002)(2616005)(4326008)(107886003)(50466002)(486006)(305945005)(126002)(36756003)(336012)(426003)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR02MB2770;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 363b656d-5d7d-4d56-d93c-08d74c8a7f28
X-MS-TrafficTypeDiagnostic: BN6PR02MB2770:
X-Microsoft-Antispam-PRVS: <BN6PR02MB2770D55D9A90CA5A52E0A83DDC950@BN6PR02MB2770.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-Forefront-PRVS: 018577E36E
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kHclkjCRrwJZM2V9wym+7+IPRhl49at1R8/JP+Bs73f1k6OwiK1l0TmL6qKJhE2dfrwDKx/gAyxMws3NYaVaeGS9Tb0BKbD/EfDmJ2qPo3SPscN22pZMPuWjIq1jKUQJAREoYk4MChGMrpAL4goekVRNpRFcS6iUABhNHb7Qf2qua5caWT1o75K7kiF0AxS1pP3SY24j5jQr7j9lWEK2/bOFLZNvuYbvz1yGqjrdzheVgS8EhfceAMTn0dgk4i3W5vBpVN0uCp4vycJ/f7+tYgor3LKFpMoazqm+CWbDSH2ZLUQ3i6Oj286TVAkV6yMXgD0oXi5kmI8dmd8Rf1XRN2OI5OhNEqd3UTVSqWix7YZvQxDkYoMsPCN0ARWYdRletgaocg1Ge5XLMb1SSRh0j5CMeQSlqgg/gl0ZXp65ko4=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2019 07:30:01.7054
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 363b656d-5d7d-4d56-d93c-08d74c8a7f28
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR02MB2770
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

AXI CANIP doesn't support tx fifo empty interrupt feature(TXFEMP),
update the flags filed in the driver for AXI CAN case accordingly.

Fixes: 3281b380ec9f ("can: xilinx_can: Fix flags field initialization for axi can and canps")
Reported-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Signed-off-by: Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>
---
 drivers/net/can/xilinx_can.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 911b34316c9d..7c482b2d78d2 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -1599,7 +1599,6 @@ static const struct xcan_devtype_data xcan_zynq_data = {
 
 static const struct xcan_devtype_data xcan_axi_data = {
 	.cantype = XAXI_CAN,
-	.flags = XCAN_FLAG_TXFEMP,
 	.bittiming_const = &xcan_bittiming_const,
 	.btr_ts2_shift = XCAN_BTR_TS2_SHIFT,
 	.btr_sjw_shift = XCAN_BTR_SJW_SHIFT,
-- 
2.7.4

