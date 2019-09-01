Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65133A49A9
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 15:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729133AbfIANzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 09:55:53 -0400
Received: from mail-eopbgr730047.outbound.protection.outlook.com ([40.107.73.47]:29632
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728989AbfIANzt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Sep 2019 09:55:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F59MrM2+jFvYch4N3gLLa8tYPMVST0e/ZC/QOV6LvKHggh966Ygzlqc+4T5O+eVbJodSDRZjcO9JWNSqocFyPSN0Pg0KXilkWCN9iA+f9/gcQ0dViou4V9I4YUSXrzJsngCjyGPBo/2RL6TU5SfvxhGU4blzxthZYRoYlZKyWHKIxqttOWFxp5Nc7zqGwdfQb+ozKSgKM7xmAFuhhH12TQteEHkT3eJ5nZPW1QVZxwvnDvrbzqgP25r9vueIxoQMEAou/HBNhZRwqZDV4od4u7NWEMSMdSCOTLkzRoo/YHbjZ1PCrk9Ht08yemZ451OffeyF6erF64SBkqaYQHj49w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eg7QRrjQO74As3D2atFW1IMAo4XfzYvjuu1NjhUvieY=;
 b=k6tmFNIEKfVnm+3eR0ihS2u7xpq4LPEH6DiXrPaUlTV44N1YXxQSvHpYFbH99ml5wrW5x+hbJ9DJjsi/2X3PjmB16SJmdcY2wP2W9c1JylUKxoXSvSN0CnSbn5NaYEY83BKY0y7745X2mBu0d7bDuQ8jF3qz7MfFxSGVViV1f9DKHQfzrqLhLxiZqBQ1xrByHUH0c7EYPEnqsCquxZFpL0xh33zBIqd8yIXc6wFz6Cf7b5sFk9U26bIVGCSizJb2FQeY9JN3CkBwrwtXjAD+0YE9rEZu3ILq3NCoHXFKk42676oht7+HRYnuzSJxwHi1c6Pje3ZOFuLQNtgljwADvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eg7QRrjQO74As3D2atFW1IMAo4XfzYvjuu1NjhUvieY=;
 b=BrNLbeywhPwuUWZNyFgTEYDyRy5rX9THptJmXSV6+rUEdjkO0vrdel1PwO9EZqUt7tDQGwUuMr4NyCUEECIEexQKg5I1G/IgGqhkyAeztvHRD92ltxClMTJ+cqvzcAsBiatu7RCME2DjGNibjXhBgyDj8XtSaKO79OY1MFjma4E=
Received: from BN7PR02CA0019.namprd02.prod.outlook.com (2603:10b6:408:20::32)
 by BN7PR02MB5332.namprd02.prod.outlook.com (2603:10b6:408:30::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2199.19; Sun, 1 Sep
 2019 13:55:27 +0000
Received: from BL2NAM02FT062.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::206) by BN7PR02CA0019.outlook.office365.com
 (2603:10b6:408:20::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2220.18 via Frontend
 Transport; Sun, 1 Sep 2019 13:55:26 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 BL2NAM02FT062.mail.protection.outlook.com (10.152.77.57) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2220.16
 via Frontend Transport; Sun, 1 Sep 2019 13:55:26 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1i4QKD-0003IV-VR; Sun, 01 Sep 2019 06:55:25 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1i4QK8-0002cJ-SH; Sun, 01 Sep 2019 06:55:20 -0700
Received: from xsj-pvapsmtp01 (mailhost.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x81DtBUq002113;
        Sun, 1 Sep 2019 06:55:11 -0700
Received: from [172.23.155.44] (helo=xhdengvm155044.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <kalyania@xilinx.com>)
        id 1i4QJz-0002aq-FE; Sun, 01 Sep 2019 06:55:11 -0700
Received: by xhdengvm155044.xilinx.com (Postfix, from userid 23151)
        id C3F6286000; Sun,  1 Sep 2019 19:25:10 +0530 (IST)
From:   Kalyani Akula <kalyani.akula@xilinx.com>
To:     herbert@gondor.apana.org.au, kstewart@linuxfoundation.org,
        gregkh@linuxfoundation.org, tglx@linutronix.de,
        pombredanne@nexb.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Kalyani Akula <kalyania@xilinx.com>,
        Kalyani Akula <kalyani.akula@xilinx.com>
Subject: [PATCH V2 3/4] firmware: xilinx: Add ZynqMP aes API for AES functionality
Date:   Sun,  1 Sep 2019 19:24:57 +0530
Message-Id: <1567346098-27927-4-git-send-email-kalyani.akula@xilinx.com>
X-Mailer: git-send-email 1.9.5
In-Reply-To: <1567346098-27927-1-git-send-email-kalyani.akula@xilinx.com>
References: <1567346098-27927-1-git-send-email-kalyani.akula@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(346002)(376002)(396003)(2980300002)(199004)(189003)(36756003)(81166006)(81156014)(47776003)(106002)(14444005)(103686004)(44832011)(26005)(8936002)(478600001)(2616005)(52956003)(126002)(446003)(186003)(6266002)(426003)(476003)(70206006)(70586007)(42186006)(16586007)(4326008)(50226002)(305945005)(48376002)(336012)(5660300002)(51416003)(486006)(76176011)(8676002)(6666004)(356004)(50466002)(2906002)(36386004)(316002)(11346002)(107886003)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR02MB5332;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b8b0172-93d2-4103-0de6-08d72ee40afa
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(4709080)(1401327)(4618075)(2017052603328);SRVR:BN7PR02MB5332;
X-MS-TrafficTypeDiagnostic: BN7PR02MB5332:
X-Microsoft-Antispam-PRVS: <BN7PR02MB533216110A44965061976D74AFBF0@BN7PR02MB5332.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-Forefront-PRVS: 0147E151B5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: eFyyAhaOkPo4tJhD9LAghZOS/Q2YUg+w6h0KHz+0R0p9g1b73X3hb3XXRvIFtrOznF6vhymlP2BAyRVhXkEhUPMROZv5JZj+hnQE0/NljXUGSndq3wRXnmnZONIVj1I19Gsk5vWycMhiRZH3CPAELRf7F8OdEe3FparHQyI1IweC4IFCZmoptMEycOZwam1UaMr6qrSqRdpvhk2CFCcDYHjYdJqtsg5+J/3yzjpJy6ebdnETZQFaaiMbJZuFSQkmer7gmHJdqD1gPKv3BVG7j5XSGNzePwQml9/iBH5Pv/V9zmtBYmJt7e1i65zChspWnyVpmbf6mIUfh9JC2grub3ydXmMONSocyAMqrZhqy4ItrE0LXXTAPIHVK6JQ/82Sr7+AeYEacoXlvY6olaNqbvI/XxzGAHTIB00Y3x7J3Ug=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2019 13:55:26.6034
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b8b0172-93d2-4103-0de6-08d72ee40afa
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR02MB5332
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ZynqMP firmware AES API to perform encryption/decryption
of given data.

Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
---
 drivers/firmware/xilinx/zynqmp.c     | 23 +++++++++++++++++++++++
 include/linux/firmware/xlnx-zynqmp.h |  2 ++
 2 files changed, 25 insertions(+)

diff --git a/drivers/firmware/xilinx/zynqmp.c b/drivers/firmware/xilinx/zynqmp.c
index fd3d837..74f3354 100644
--- a/drivers/firmware/xilinx/zynqmp.c
+++ b/drivers/firmware/xilinx/zynqmp.c
@@ -663,6 +663,28 @@ static int zynqmp_pm_set_requirement(const u32 node, const u32 capabilities,
 	return zynqmp_pm_invoke_fn(PM_SET_REQUIREMENT, node, capabilities,
 				   qos, ack, NULL);
 }
+/**
+ * zynqmp_pm_aes - Access AES hardware to encrypt/decrypt the data using
+ * AES-GCM core.
+ * @address:	Address of the AesParams structure.
+ * @out:	Returned output value
+ *
+ * Return:	Returns status, either success or error code.
+ */
+static int zynqmp_pm_aes_engine(const u64 address, u32 *out)
+{
+	u32 ret_payload[PAYLOAD_ARG_CNT];
+	int ret;
+
+	if (!out)
+		return -EINVAL;
+
+	ret = zynqmp_pm_invoke_fn(PM_SECURE_AES, upper_32_bits(address),
+				  lower_32_bits(address),
+				  0, 0, ret_payload);
+	*out = ret_payload[1];
+	return ret;
+}
 
 static const struct zynqmp_eemi_ops eemi_ops = {
 	.get_api_version = zynqmp_pm_get_api_version,
@@ -687,6 +709,7 @@ static int zynqmp_pm_set_requirement(const u32 node, const u32 capabilities,
 	.set_requirement = zynqmp_pm_set_requirement,
 	.fpga_load = zynqmp_pm_fpga_load,
 	.fpga_get_status = zynqmp_pm_fpga_get_status,
+	.aes = zynqmp_pm_aes_engine,
 };
 
 /**
diff --git a/include/linux/firmware/xlnx-zynqmp.h b/include/linux/firmware/xlnx-zynqmp.h
index 778abbb..508edd7 100644
--- a/include/linux/firmware/xlnx-zynqmp.h
+++ b/include/linux/firmware/xlnx-zynqmp.h
@@ -77,6 +77,7 @@ enum pm_api_id {
 	PM_CLOCK_GETRATE,
 	PM_CLOCK_SETPARENT,
 	PM_CLOCK_GETPARENT,
+	PM_SECURE_AES = 47,
 };
 
 /* PMU-FW return status codes */
@@ -294,6 +295,7 @@ struct zynqmp_eemi_ops {
 			       const u32 capabilities,
 			       const u32 qos,
 			       const enum zynqmp_pm_request_ack ack);
+	int (*aes)(const u64 address, u32 *out);
 };
 
 int zynqmp_pm_invoke_fn(u32 pm_api_id, u32 arg0, u32 arg1,
-- 
1.8.3.1

