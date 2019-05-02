Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49BF711752
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 12:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbfEBKfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 06:35:09 -0400
Received: from mail-eopbgr710041.outbound.protection.outlook.com ([40.107.71.41]:9683
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726289AbfEBKfI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 06:35:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f94YMxikbA1iu7DB/qLaywMCKnwwT1mUfUgS1qM7Hjw=;
 b=5BCi+hdHM4OUnHjE/RGJ5ohyIakpRFNCT2jPuOVqbGMfx6sIKlcfzo303H+L0IBNBNRW8A99G7ebRT6Mm39n4hLgW/TcPTQ0YlSSy6Q14Ec6zdIzG2oHcJ2fXIxLDX0iwgaXmVaItUCQMgqDev5UVF10JTPKFsCpsxVvW8J6/A0=
Received: from BN6PR02CA0074.namprd02.prod.outlook.com (2603:10b6:405:60::15)
 by BYAPR02MB5239.namprd02.prod.outlook.com (2603:10b6:a03:68::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1835.14; Thu, 2 May
 2019 10:35:04 +0000
Received: from CY1NAM02FT009.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::203) by BN6PR02CA0074.outlook.office365.com
 (2603:10b6:405:60::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1856.11 via Frontend
 Transport; Thu, 2 May 2019 10:35:03 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.100)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.100 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.100; helo=xsj-pvapsmtpgw02;
Received: from xsj-pvapsmtpgw02 (149.199.60.100) by
 CY1NAM02FT009.mail.protection.outlook.com (10.152.75.12) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1856.11
 via Frontend Transport; Thu, 2 May 2019 10:35:03 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66]:33460 helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw02 with esmtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1hM93O-0006ri-LO; Thu, 02 May 2019 03:35:02 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1hM93J-0007Vo-IW; Thu, 02 May 2019 03:34:57 -0700
Received: from xsj-pvapsmtp01 (mailhost.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x42AYtt9032631;
        Thu, 2 May 2019 03:34:55 -0700
Received: from [172.23.155.80] (helo=xhdengvm155080.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <kalyania@xilinx.com>)
        id 1hM93G-0007VE-Mo; Thu, 02 May 2019 03:34:54 -0700
Received: by xhdengvm155080.xilinx.com (Postfix, from userid 23151)
        id DFCA381417; Thu,  2 May 2019 16:04:53 +0530 (IST)
From:   Kalyani Akula <kalyani.akula@xilinx.com>
To:     <herbert@gondor.apana.org.au>, <kstewart@linuxfoundation.org>,
        <gregkh@linuxfoundation.org>, <tglx@linutronix.de>,
        <pombredanne@nexb.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <saratcha@xilinx.com>
CC:     Kalyani Akula <kalyania@xilinx.com>,
        Kalyani Akula <kalyani.akula@xilinx.com>
Subject: [RFC PATCH V3 2/4] firmware: xilinx: Add ZynqMP sha_hash API for SHA3 functionality
Date:   Thu, 2 May 2019 16:04:40 +0530
Message-ID: <1556793282-17346-3-git-send-email-kalyani.akula@xilinx.com>
X-Mailer: git-send-email 1.9.5
In-Reply-To: <1556793282-17346-1-git-send-email-kalyani.akula@xilinx.com>
References: <1556793282-17346-1-git-send-email-kalyani.akula@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.100;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(396003)(136003)(346002)(39860400002)(2980300002)(189003)(199004)(446003)(478600001)(11346002)(6266002)(336012)(426003)(90966002)(26005)(51416003)(305945005)(107886003)(4326008)(14444005)(110136005)(106002)(76176011)(54906003)(47776003)(186003)(63266004)(5660300002)(36756003)(103686004)(42186006)(316002)(16586007)(50466002)(52956003)(48376002)(70586007)(70206006)(476003)(126002)(356004)(6636002)(36386004)(6666004)(50226002)(486006)(8936002)(44832011)(2616005)(81156014)(81166006)(2906002)(8676002)(2201001)(5001870100001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR02MB5239;H:xsj-pvapsmtpgw02;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-100.xilinx.com,xapps1.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ded1e9d-6871-474f-790e-08d6cee9d633
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4709054)(2017052603328);SRVR:BYAPR02MB5239;
X-MS-TrafficTypeDiagnostic: BYAPR02MB5239:
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-Microsoft-Antispam-PRVS: <BYAPR02MB5239B59778B4D6803D95AD4AAF340@BYAPR02MB5239.namprd02.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 0025434D2D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: c0u5DmQJXZ5c19kN9MZEj9kVbiAZaudmv3JVMemSKy4qzzxfbkyIZBqlL9MBHKVH/GHslzYi2h259chsV6uHhnkXU/CQMcPALzbrpHmv82D9Du3o07yJa9VxtrzcUtoDBffOiXkcIMk02gxMCSokQoAazzYOcS6gIRdotke6F2ZDL+pWIhpCtRQ6LK9+v3k0QmJWI3txHD/stvaWbghxsDzujMh/P6IsveL0BV23JSAT0XHxFz1LmAvlNMIFKRlzW8Dat3FmPXKbl6hCb6cpYqC3qFj5kp4MIGF5+H512sp1bWeUmAuYte5vzZMpMvJEYJBXcnuWoYrDGJUt1IQwaULNmo7l/oOJBauhUbNMv0ULmlqmDZDdkcvZyIKqasbnSbIwlc3dwjFziqidipnWZufj3eoWHGf3uC32Vka1IwE=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2019 10:35:03.1279
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ded1e9d-6871-474f-790e-08d6cee9d633
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.100];Helo=[xsj-pvapsmtpgw02]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5239
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ZynqMP firmware SHA_HASH API to compute SHA3 hash of given data.

Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
---
 drivers/firmware/xilinx/zynqmp.c     | 27 +++++++++++++++++++++++++++
 include/linux/firmware/xlnx-zynqmp.h |  2 ++
 2 files changed, 29 insertions(+)

diff --git a/drivers/firmware/xilinx/zynqmp.c b/drivers/firmware/xilinx/zynqmp.c
index 98f9361..22a062a 100644
--- a/drivers/firmware/xilinx/zynqmp.c
+++ b/drivers/firmware/xilinx/zynqmp.c
@@ -619,9 +619,36 @@ static int zynqmp_pm_set_requirement(const u32 node, const u32 capabilities,
 				   qos, ack, NULL);
 }
 
+/**
+ * zynqmp_pm_sha_hash - Access the SHA engine to calculate the hash
+ * @address:	Address of the data/ Address of output buffer where
+ *		hash should be stored.
+ * @size:	Size of the data.
+ * @flags:
+ *	BIT(0) - for initializing csudma driver and SHA3(Here address
+ *		 and size inputs can be NULL).
+ *	BIT(1) - to call Sha3_Update API which can be called multiple
+ *		 times when data is not contiguous.
+ *	BIT(2) - to get final hash of the whole updated data.
+ *		 Hash will be overwritten at provided address with
+ *		 48 bytes.
+ *
+ * Return:	Returns status, either success or error code.
+ */
+static int zynqmp_pm_sha_hash(const u64 address, const u32 size,
+			      const u32 flags)
+{
+	u32 lower_32_bits = (u32)address;
+	u32 upper_32_bits = (u32)(address >> 32);
+
+	return zynqmp_pm_invoke_fn(PM_SECURE_SHA, upper_32_bits, lower_32_bits,
+				   size, flags, NULL);
+}
+
 static const struct zynqmp_eemi_ops eemi_ops = {
 	.get_api_version = zynqmp_pm_get_api_version,
 	.get_chipid = zynqmp_pm_get_chipid,
+	.sha_hash = zynqmp_pm_sha_hash,
 	.query_data = zynqmp_pm_query_data,
 	.clock_enable = zynqmp_pm_clock_enable,
 	.clock_disable = zynqmp_pm_clock_disable,
diff --git a/include/linux/firmware/xlnx-zynqmp.h b/include/linux/firmware/xlnx-zynqmp.h
index 642dab1..124e5f0 100644
--- a/include/linux/firmware/xlnx-zynqmp.h
+++ b/include/linux/firmware/xlnx-zynqmp.h
@@ -57,6 +57,7 @@ enum pm_api_id {
 	PM_RESET_GET_STATUS,
 	PM_PM_INIT_FINALIZE = 21,
 	PM_GET_CHIPID = 24,
+	PM_SECURE_SHA = 26,
 	PM_IOCTL = 34,
 	PM_QUERY_DATA,
 	PM_CLOCK_ENABLE,
@@ -283,6 +284,7 @@ struct zynqmp_eemi_ops {
 			       const u32 capabilities,
 			       const u32 qos,
 			       const enum zynqmp_pm_request_ack ack);
+	int (*sha_hash)(const u64 address, const u32 size, const u32 flags);
 };
 
 int zynqmp_pm_invoke_fn(u32 pm_api_id, u32 arg0, u32 arg1,
-- 
1.9.5

