Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 303201174D
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 12:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbfEBKfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 06:35:09 -0400
Received: from mail-eopbgr790071.outbound.protection.outlook.com ([40.107.79.71]:29984
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726282AbfEBKfJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 06:35:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=na0fw0RKLD7Q3nbwjJ/FoVHMPLkF3WALiFdCzb7qRdw=;
 b=yJT+ifI2hJkLDFm7WOkSHBzvIQPmJewLyPnPui21r4s6oC7Xmo7LjhHZ3hU42em+GDC0I2Egc9LNjLIYCSAgQgXnCFDOL8FiftF3fItDcHCABFmoG6to5mUP3TzgurwUwQI6WzOj7oHriMZKVQslOakoxNAxIgGLeA1JRcBFAd4=
Received: from MWHPR0201CA0061.namprd02.prod.outlook.com
 (2603:10b6:301:73::38) by BY2PR02MB1653.namprd02.prod.outlook.com
 (2a01:111:e400:58f4::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1835.13; Thu, 2 May
 2019 10:35:04 +0000
Received: from CY1NAM02FT049.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::203) by MWHPR0201CA0061.outlook.office365.com
 (2603:10b6:301:73::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1856.10 via Frontend
 Transport; Thu, 2 May 2019 10:35:03 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 CY1NAM02FT049.mail.protection.outlook.com (10.152.75.83) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1856.11
 via Frontend Transport; Thu, 2 May 2019 10:35:03 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1hM93O-0004iX-NQ; Thu, 02 May 2019 03:35:02 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1hM93J-0007Vo-K1; Thu, 02 May 2019 03:34:57 -0700
Received: from xsj-pvapsmtp01 (xsj-smtp.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x42AYs6l031029;
        Thu, 2 May 2019 03:34:55 -0700
Received: from [172.23.155.80] (helo=xhdengvm155080.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <kalyania@xilinx.com>)
        id 1hM93G-0007VD-MR; Thu, 02 May 2019 03:34:54 -0700
Received: by xhdengvm155080.xilinx.com (Postfix, from userid 23151)
        id DC2B4800EA; Thu,  2 May 2019 16:04:53 +0530 (IST)
From:   Kalyani Akula <kalyani.akula@xilinx.com>
To:     <herbert@gondor.apana.org.au>, <kstewart@linuxfoundation.org>,
        <gregkh@linuxfoundation.org>, <tglx@linutronix.de>,
        <pombredanne@nexb.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <saratcha@xilinx.com>
CC:     Kalyani Akula <kalyania@xilinx.com>,
        Kalyani Akula <kalyani.akula@xilinx.com>
Subject: [RFC PATCH V3 1/4] dt-bindings: crypto: Add bindings for ZynqMP SHA3 driver
Date:   Thu, 2 May 2019 16:04:39 +0530
Message-ID: <1556793282-17346-2-git-send-email-kalyani.akula@xilinx.com>
X-Mailer: git-send-email 1.9.5
In-Reply-To: <1556793282-17346-1-git-send-email-kalyani.akula@xilinx.com>
References: <1556793282-17346-1-git-send-email-kalyani.akula@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(346002)(396003)(39860400002)(376002)(2980300002)(189003)(199004)(107886003)(4326008)(47776003)(6636002)(36386004)(316002)(16586007)(42186006)(110136005)(26005)(4744005)(70586007)(6266002)(2201001)(36756003)(5660300002)(70206006)(90966002)(6666004)(356004)(52956003)(305945005)(81166006)(81156014)(478600001)(63266004)(103686004)(50226002)(8676002)(8936002)(50466002)(48376002)(44832011)(106002)(76176011)(54906003)(51416003)(426003)(11346002)(446003)(2616005)(486006)(126002)(476003)(2906002)(336012)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR02MB1653;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87d04abb-eddf-4f30-0306-08d6cee9d635
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4709054)(2017052603328);SRVR:BY2PR02MB1653;
X-MS-TrafficTypeDiagnostic: BY2PR02MB1653:
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-Microsoft-Antispam-PRVS: <BY2PR02MB1653FE585B975B9159EDB92AAF340@BY2PR02MB1653.namprd02.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-Forefront-PRVS: 0025434D2D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: ssqjNx40M6mFrfQb3S3R8Qo63cQaTaF4T9xRb95XlTan4k/Xm6iZQd8QPEcPefYjoGZaWRv3wBPQGrEe+QPIVsgka64GVnrPiSbLUpglPqxaMZyWywBhop1v9Sp4OcSvMmq/BkLW8wLfDqgb5F/sDr7ngy6MGKaLwzqtOSNLrXjwCqmZtBn6a12QZQbyANsL+W9/CFYGkYfb88USGCnzKlttn3aJuxAXJUZwPU8bjJRdtRhc6Ji1QJeYcmRzSVztzoEGYRrjQZ9VKez6gzlniQHl9EByQjI+3EWTOYuMZ8qNhJQfQ4KRz+Cxx47TN0dJY12dktUXCGp69CvXwfwL7Ow67GjWLC0c8gQ+xmp9u6BNsvA2LK2jKtRvXiVbRc8JPuBH7F5h9gUe48wMv3z3K3khFoz0qdfxSAfpSPc/xSI=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2019 10:35:03.1750
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 87d04abb-eddf-4f30-0306-08d6cee9d635
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR02MB1653
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation to describe Xilinx ZynqMP SHA3 driver
bindings.

Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
---
 Documentation/devicetree/bindings/crypto/zynqmp-sha.txt | 12 ++++++++++++
 1 file changed, 12 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/zynqmp-sha.txt

diff --git a/Documentation/devicetree/bindings/crypto/zynqmp-sha.txt b/Documentation/devicetree/bindings/crypto/zynqmp-sha.txt
new file mode 100644
index 0000000..8b3cc55
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/zynqmp-sha.txt
@@ -0,0 +1,12 @@
+Xilinx ZynqMP SHA3(keccak-384) hw acceleration support.
+
+The ZynqMp PS-SHA hw accelerator is used to calculate the
+SHA3(keccak-384) hash value on the given user data.
+
+Required properties:
+- compatible:	should contain "xlnx,zynqmp-sha3-384"
+
+Example:
+	xlnx_sha3_384: sha384 {
+		compatible = "xlnx,zynqmp-sha3-384";
+	};
-- 
1.9.5

