Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED1AC7BD57
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 11:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387549AbfGaJgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 05:36:50 -0400
Received: from mail-eopbgr820048.outbound.protection.outlook.com ([40.107.82.48]:41337
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387471AbfGaJgt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 05:36:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JkytUHe3xlvEb5JxPpLV3DxwuAqFWnzyPf/h2HKludw7zBVzSCHuxY2zwGnkymk0V3g6LNBztIr8ICpBHyas8MeHYrc9lnVP/db3vNR7G/B9kcxyxsedn/vKh6nManip4RA/BsUIohNyfr0pPAIVZ8vaCcMQg7tZx6thCKDvnaXcvReokG+GoU5+vNTUvVVF03G6LwaC7KAqUurzEjTw3BrYb/t5uB4wNFjtQhMK+a7U0+H8HpMSAZ38ZVvwbd8Ig60KUtAUwLoZELp3hDT4ZMnnkBKWNzBOgAqrJSERmeDpw9Ze/sedRvTryY+7QBNs/qp+7mCAmY259XW4Pbzy6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ie2ak99mtBKdSM58gCsEMQOwiHNnAACTd0bZhySeOCg=;
 b=aT34HZy2WN1HobT78MveDd+DI07Gdsv9EN4y2EPGBAY5J33xBG1e5KTIWM/+IZJUQlDQPBuOXHEayZRnAuoE1AhjOVRUTRf7I/aN6R2iaHq0uSX5YtS4ulGsRJ3Wl4ls7yATIa6bRwNKh6pnbeuI6yQSaPj5mJiwdjDFzmHp3l2b29bLJk2RaTHFDJz/i5A4lvKD4yWPWV04h3QQVP/efZKylvW3QR/ZF7wSU8Iwp2y9Zng/6SKTndNlkn2QrEDyCDVuPgoC0/FHA0nXs6HVod0/K2Uc18HieqzihLBX70ihBJvQlzzm6GN0gW+XlOrHETB01HSxOLiLI5xH1Nv/fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=gmail.com
 smtp.mailfrom=xilinx.com;dmarc=bestguesspass action=none
 header.from=xilinx.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ie2ak99mtBKdSM58gCsEMQOwiHNnAACTd0bZhySeOCg=;
 b=KIpLsqf4a0eOBea8O2pCxLgfYg8L8pHFEumBuuLSACjl3bubu1/808K09Zm6IoXWR/08ZlVU7ghCSEZohllfH2RpnzKKoCbuNC04OcbVaAViACss+nJ0apHRBPkBHCfnWOOMsWXwnBt1SJjipZGsGF+ZHZjkwUA0HwarWPCEt7w=
Received: from DM6PR02CA0129.namprd02.prod.outlook.com (2603:10b6:5:1b4::31)
 by BYAPR02MB4760.namprd02.prod.outlook.com (2603:10b6:a03:4e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2115.14; Wed, 31 Jul
 2019 09:36:43 +0000
Received: from SN1NAM02FT044.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::202) by DM6PR02CA0129.outlook.office365.com
 (2603:10b6:5:1b4::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2115.15 via Frontend
 Transport; Wed, 31 Jul 2019 09:36:43 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 SN1NAM02FT044.mail.protection.outlook.com (10.152.72.173) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2115.10
 via Frontend Transport; Wed, 31 Jul 2019 09:36:43 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1hsl2I-00073G-Ga; Wed, 31 Jul 2019 02:36:42 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1hsl2D-0003pQ-CF; Wed, 31 Jul 2019 02:36:37 -0700
Received: from xsj-pvapsmtp01 (mailhub.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x6V9aRde012651;
        Wed, 31 Jul 2019 02:36:27 -0700
Received: from [10.140.6.13] (helo=xhdharinik40.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1hsl22-0003my-NX; Wed, 31 Jul 2019 02:36:27 -0700
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net
Cc:     michal.simek@xilinx.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        harinikatakamlinux@gmail.com, harini.katakam@xilinx.com,
        radhey.shyam.pandey@xilinx.com
Subject: [PATCH 1/2] include: mdio: Add private field to mdio structure
Date:   Wed, 31 Jul 2019 15:06:18 +0530
Message-Id: <1564565779-29537-2-git-send-email-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564565779-29537-1-git-send-email-harini.katakam@xilinx.com>
References: <1564565779-29537-1-git-send-email-harini.katakam@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(396003)(376002)(346002)(2980300002)(199004)(189003)(2616005)(446003)(486006)(426003)(305945005)(11346002)(476003)(50466002)(2906002)(126002)(7696005)(44832011)(478600001)(50226002)(70206006)(106002)(51416003)(5660300002)(14444005)(9786002)(63266004)(76176011)(81166006)(36756003)(47776003)(316002)(16586007)(81156014)(8676002)(107886003)(36386004)(4326008)(26005)(186003)(8936002)(70586007)(336012)(48376002)(356004)(6666004);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR02MB4760;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a8c6300-63ab-412c-65d7-08d7159a9915
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:BYAPR02MB4760;
X-MS-TrafficTypeDiagnostic: BYAPR02MB4760:
X-Microsoft-Antispam-PRVS: <BYAPR02MB4760A69C9A53C4A1ACFC8C77C9DF0@BYAPR02MB4760.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 011579F31F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 8MMSIjCijJm9BQVtf0T1MDGMF/Fi0ynG/te5n96GUs6iTRqX+GrxFNHKYU9jzI7+3fArkQRkIHJhR7RvGNsL31duT1Um+gdG5w4v32KGwbetrYptxCBl9vCVjsSk7rOotSMESG6zcjG+5APQqvt4fV9UCwkYlzzTlT80ZMtODuJZsI8d71ZIi8EBAUGSbKG3pbkAzP6Gbvpl2A+/aZeE4aiKc4YjqqdLFapzp5r2/lW84pfsHFndxuWLNZ6BSUaf9OFJkKn4K7RD2WHmNqbcgJCnbIzBRGbWiZ4upx0FVZzZff2e0KA+pFWWXFIlJt/QpO7AJo3kZTRt96MKUbQqnLvAJb1DOs4MxGlfs/emkFHg4RUYOASAwhsNT6cEArN9vojnOI2cBpFTdWNW4ZZsxnkciNrn4pymSrsoV8tu63s=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2019 09:36:43.0440
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a8c6300-63ab-412c-65d7-08d7159a9915
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB4760
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a priv pointer to mdio structure to be used by mdio devices if
required.

This priv field will be used by gmii2rgmii driver. As this IP has
no capability to read status on the MDIO bus, the driver currently
snoops the same and needs the instance information is some private
field. Since phy device "priv" can be used by external phy drivers,
it is not appropriate. Hence this addition to mdio device. This is
a temporary solution before the IP can be improved. The need for
this priv field can be re-evaluated later based on other mdio devices.

Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
 include/linux/mdio.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index e8242ad8..3399de7 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -40,6 +40,9 @@ struct mdio_device {
 	struct reset_control *reset_ctrl;
 	unsigned int reset_assert_delay;
 	unsigned int reset_deassert_delay;
+
+	/* private data pointer for use by MDIO devices */
+	void *priv;
 };
 #define to_mdio_device(d) container_of(d, struct mdio_device, dev)
 
-- 
2.7.4

