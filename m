Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D71D4BAF38
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 10:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437473AbfIWIUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 04:20:42 -0400
Received: from mail-eopbgr750072.outbound.protection.outlook.com ([40.107.75.72]:10669
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392126AbfIWIUl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Sep 2019 04:20:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SH53lWE5IRilySuc/etLrPtxWXahQFsEXotXLBhD3kH+ru3yAZqEXKgBwtrE5eSfvwvr6FJL7hhbE2mGXL9VPoQQIXlWDJ30NT38ivpDdOWADI10inMKER2ywpnoNRAVvtuJHn0VNDBGQbkcYPbe2gFnQubxZOiCxBZTpT1274um/tyafgGtdaTPCvVPU2s1rlEwazKr7xhwEbaW7fFbVtMU33DfcOkUEHm5ydqSxkeaTxHmcLy5RZJd5JV1wCfKlcjAW4BF4tahNV6jV2uvqq7kW/nNw4RF4hww1JlOjk3ZvQOKq60N6n0wNCkI1hrGqm1QlgU3GlsczbH/wHHtNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ICqOTlqjJ2rBaEQ/WiG96Hh1V8jhZ5YQopSP1Pfjd2k=;
 b=Hu+DuIc9INldNWeAq7nIRWaDMOEegrSDPpvQQK1hSFzLxwcjbSg696W/c+V9BNbYD2anNSQsIv/8vvEyi5YVVGXmUy4DZs/Ph1c4w3ZyOzPSW56d/Rjnzop3Zi9f7Xyir5rBq1ESLbnyzgUfdcepmvjJbxJXynNZI2/kBSCHudmRDA5B4dAgMt2ghgtKJHvgTyrOhulKSM8HbJ7wwoi8Lq/2JdrZ+iT2aria2LJvRcihzoE2bWbUfXcIW3Q10qGEb0M+iNsRItgON5Kaba7fK6O84iPjSa4KIg692kDJeJVtLTo8tGNVM27KyxpeVTY78cTeHl3W1Oa4pFcRe3RpIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=gmail.com smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ICqOTlqjJ2rBaEQ/WiG96Hh1V8jhZ5YQopSP1Pfjd2k=;
 b=cG3ASmIDpM/ebsgWPhR5D2DKlq3CqZVO0ZryCOZSBzsMWTZESDVJMUqxx3etkdlsFMROLIBp7xtGeDrbKEx4WKTUXBjmxfH6ADFVlC9Meh0WRxm8cR69ea5KRhpBoioIMKgVqZCoPH4oUkEIl4oIFbmwhbpe21SLAKgH4zJ9AMM=
Received: from DM6PR02CA0024.namprd02.prod.outlook.com (2603:10b6:5:1c::37) by
 BYAPR02MB5335.namprd02.prod.outlook.com (2603:10b6:a03:61::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.21; Mon, 23 Sep 2019 08:19:59 +0000
Received: from SN1NAM02FT017.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::209) by DM6PR02CA0024.outlook.office365.com
 (2603:10b6:5:1c::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.14 via Frontend
 Transport; Mon, 23 Sep 2019 08:19:58 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 SN1NAM02FT017.mail.protection.outlook.com (10.152.72.115) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2284.25
 via Frontend Transport; Mon, 23 Sep 2019 08:19:58 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <shubhrajyoti.datta@xilinx.com>)
        id 1iCJZe-0000Fr-3r; Mon, 23 Sep 2019 01:19:58 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <shubhrajyoti.datta@xilinx.com>)
        id 1iCJZY-0007rJ-Nv; Mon, 23 Sep 2019 01:19:52 -0700
Received: from xsj-pvapsmtp01 (maildrop.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x8N8JkN9030663;
        Mon, 23 Sep 2019 01:19:46 -0700
Received: from [10.140.6.59] (helo=xhdshubhraj40.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <shubhrajyoti.datta@xilinx.com>)
        id 1iCJZR-0007pQ-GV; Mon, 23 Sep 2019 01:19:45 -0700
From:   Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     nicolas.ferre@microchip.com, shubhrajyoti.datta@gmail.com,
        Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
Subject: [RFC PATCH] net: macb: Remove dead code
Date:   Mon, 23 Sep 2019 13:49:42 +0530
Message-Id: <1569226782-19635-1-git-send-email-shubhrajyoti.datta@xilinx.com>
X-Mailer: git-send-email 2.1.1
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(39860400002)(346002)(396003)(199004)(189003)(476003)(48376002)(4326008)(36386004)(36756003)(5660300002)(50466002)(107886003)(6666004)(356004)(106002)(316002)(70586007)(70206006)(486006)(2906002)(81156014)(8936002)(81166006)(478600001)(7696005)(50226002)(44832011)(336012)(5024004)(14444005)(8746002)(8676002)(186003)(426003)(26005)(2616005)(305945005)(126002)(47776003)(9786002)(51416003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR02MB5335;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 96144a38-8bfd-46df-f52d-08d73ffed2bd
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(4709080)(1401327)(4618075)(2017052603328);SRVR:BYAPR02MB5335;
X-MS-TrafficTypeDiagnostic: BYAPR02MB5335:
X-Microsoft-Antispam-PRVS: <BYAPR02MB5335E11751E02A586BED6011AA850@BYAPR02MB5335.namprd02.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-Forefront-PRVS: 0169092318
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: cAVhPuLGsOSIKUiuurcDsNODbo5f8CwqAoknR0FSeB9UdkoIwK0wJnxOq1R7/JA9oNYePLWHQQxyW5LX9IZ5ZfoeTFEG/6quQJm/qc5YHTMjEAVie26Ms1SipWVRn/Z4lvwCFT7GIMwMGXEXL5Ofy0ETAJQRdW3EOgPxS6EFPZfnPesjh4fNIBjb46n/YX9UbDuK6FcVLc5oM0aPaZ8oa9COfs/ivND1jH2aOZwwwP51UN50sqyk9cGdaKM4aAq4eOV+0wTrjmdZb0ocmR3jLXacPz/J+C+E+wEb4BM2qxri7665+zMu5UrjgAfL2elbqIuZEtJD8cAO68O74m1uT15flPfjuHqyrn8aDKgl3FjgTYOnucr01WZ4vfzsuXZEcDTxsj4Pne4hXd8YtVi37SyfUveZzfvcG7j+UPxYXIM=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2019 08:19:58.5001
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 96144a38-8bfd-46df-f52d-08d73ffed2bd
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5335
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

macb_64b_desc is always called when HW_DMA_CAP_64B is defined.
So the return NULL can never be reached. Remove the dead code.

Signed-off-by: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/etherne=
t/cadence/macb_main.c
index 35b59b5..8e8d557 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -165,9 +165,8 @@ static unsigned int macb_adj_dma_desc_idx(struct macb *=
bp, unsigned int desc_idx
 #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
 static struct macb_dma_desc_64 *macb_64b_desc(struct macb *bp, struct macb=
_dma_desc *desc)
 {
-       if (bp->hw_dma_cap & HW_DMA_CAP_64B)
-               return (struct macb_dma_desc_64 *)((void *)desc + sizeof(st=
ruct macb_dma_desc));
-       return NULL;
+       return (struct macb_dma_desc_64 *)((void *)desc
+               + sizeof(struct macb_dma_desc));
 }
 #endif

--
2.1.1

This email and any attachments are intended for the sole use of the named r=
ecipient(s) and contain(s) confidential information that may be proprietary=
, privileged or copyrighted under applicable law. If you are not the intend=
ed recipient, do not read, copy, or forward this email message or any attac=
hments. Delete this email message and any attachments immediately.
