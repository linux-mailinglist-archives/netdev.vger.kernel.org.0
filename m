Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBDA6A49A6
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 15:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729014AbfIANzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 09:55:31 -0400
Received: from mail-eopbgr780079.outbound.protection.outlook.com ([40.107.78.79]:53408
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728989AbfIANzb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Sep 2019 09:55:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mWgM3ztUipKZCUY+FxQ+MYGWJUquLfOpKqxjxJyT7AKxQBWk1bjkC3/j6EAtNL27oa3wD5RL6BmOP8MupnQqUaVh4BQ3RqbHD/sF0riGaCpjrp3b2HEa1plFHqanoaYGiwJ5kLJ5wXKHTNx6U9/GXkg/Ing2U4sF7GX6WBBamoGUFgBkIMcM0N/nI6vY+758D6z2p9SFA/QYCkD3Ca4CIyQwoLk0THXiOpm8B+pKGd+ZWEA+e8+//att/dq9NSv14v8ZxvxvQ2nLCZge1H+1WHuYOe4lVQq1DflsqoZNb5PYMARXxQDSxWN9WrgdJjGUeG63r1p3ZB7yz2xnCT4i7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qDf/92HKKgfI/M1YnMnu+W+RUXpGDxOgnUNduvww2w8=;
 b=WtpWJi3ktEKfTOpuedRCAwa5+aS8PjhLcS+SU0GeYMalkrBs1PNVGzP3X21xE261Aw5YF4571WVsOD5K9U031PRLZ9RgVDBF+xWnHuZDxUTbzYFsWZKYfwAlwdhvWpl91EgJUIvItX1LFCd6oL3H+OnmAqrExqXL9w/I6gnlZuY4dUKocYi8Q0PN33VftmSB/KqzBQao1odKR6LI1q0OM7VdNEg46gUlEJ5vDks0scAZSpYgHfT4XkmggaRzmKViCQylrHAaP6KL2nLzBcxieTTdVxCyxDYNLLlk5MUxwJb7U26cZ1N8p9e9lqS37tYF/lDFQ+PsqBeqUarsbiEnxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qDf/92HKKgfI/M1YnMnu+W+RUXpGDxOgnUNduvww2w8=;
 b=Lyepn2Unz8eukV8h1KrcTYpEqjX+ewu6/xO7NtZWF4QJi5jUmI0oEQuEj9h6bMx1d9WzHFt6E+LYp8sPsP98cbLolbAVzfrNrR+VQC0zpx+/oC2qLiwFyu9WEzvL/FfS4u0YcCV//p0gpleqy2/U8grRH78Zgt/BeHNogNU8Ikc=
Received: from MWHPR02CA0028.namprd02.prod.outlook.com (2603:10b6:301:60::17)
 by BN7PR02MB5314.namprd02.prod.outlook.com (2603:10b6:408:2d::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2178.16; Sun, 1 Sep
 2019 13:55:28 +0000
Received: from BL2NAM02FT051.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::208) by MWHPR02CA0028.outlook.office365.com
 (2603:10b6:301:60::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2220.18 via Frontend
 Transport; Sun, 1 Sep 2019 13:55:27 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 BL2NAM02FT051.mail.protection.outlook.com (10.152.76.181) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2220.16
 via Frontend Transport; Sun, 1 Sep 2019 13:55:26 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1i4QKE-0003IW-3i; Sun, 01 Sep 2019 06:55:26 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1i4QK9-0002cJ-0T; Sun, 01 Sep 2019 06:55:21 -0700
Received: from xsj-pvapsmtp01 (xsj-smtp1.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x81DtB4H002111;
        Sun, 1 Sep 2019 06:55:11 -0700
Received: from [172.23.155.44] (helo=xhdengvm155044.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <kalyania@xilinx.com>)
        id 1i4QJz-0002ap-F0; Sun, 01 Sep 2019 06:55:11 -0700
Received: by xhdengvm155044.xilinx.com (Postfix, from userid 23151)
        id C161980368; Sun,  1 Sep 2019 19:25:10 +0530 (IST)
From:   Kalyani Akula <kalyani.akula@xilinx.com>
To:     herbert@gondor.apana.org.au, kstewart@linuxfoundation.org,
        gregkh@linuxfoundation.org, tglx@linutronix.de,
        pombredanne@nexb.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Kalyani Akula <kalyania@xilinx.com>,
        Kalyani Akula <kalyani.akula@xilinx.com>
Subject: [PATCH V2 1/4] dt-bindings: crypto: Add bindings for ZynqMP AES driver
Date:   Sun,  1 Sep 2019 19:24:55 +0530
Message-Id: <1567346098-27927-2-git-send-email-kalyani.akula@xilinx.com>
X-Mailer: git-send-email 1.9.5
In-Reply-To: <1567346098-27927-1-git-send-email-kalyani.akula@xilinx.com>
References: <1567346098-27927-1-git-send-email-kalyani.akula@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(396003)(136003)(376002)(346002)(2980300002)(189003)(199004)(6666004)(26005)(356004)(186003)(305945005)(50226002)(426003)(446003)(11346002)(478600001)(336012)(6266002)(44832011)(70586007)(2906002)(36756003)(486006)(52956003)(2616005)(476003)(126002)(4326008)(50466002)(16586007)(4744005)(5660300002)(51416003)(42186006)(36386004)(54906003)(106002)(316002)(70206006)(47776003)(76176011)(107886003)(103686004)(81166006)(8676002)(8936002)(48376002)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR02MB5314;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81a51c2f-b796-4073-f912-08d72ee40b0d
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(4709080)(1401327)(4618075)(2017052603328);SRVR:BN7PR02MB5314;
X-MS-TrafficTypeDiagnostic: BN7PR02MB5314:
X-Microsoft-Antispam-PRVS: <BN7PR02MB53148F6B1708E8BA20C7252EAFBF0@BN7PR02MB5314.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-Forefront-PRVS: 0147E151B5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: UqIntZGd7mc4S3rbqsocmIoT3CkvLXyJmEncbKQRo2FOuj3Q5Oquu+j2xRnkLRXGVQL2BBxASqV0pkv3guNjUHxkjSD5ihr0Ev/U+LSyffwFX6QcqxXIiY6Foqw0tWcfrd+9WUMXFTb1N1T88H2lsDJ4oK3GpzKgEIyX9chcW095EETaa0JdH6XZEDkbLYCByQYBFJD9L8lMQSlvuzTz3vnK0jt8w4cwmRHEER7waCldfCJAwmpdVWU4tdQhj0cnzkKUjcdohxrvaUbABvCRM7aUyVXeZzLc4AJSsByxDE25II0BpUgR+C/um0/seEF1RLcuLCL+nTygCkzB4zlU2fvE+dzxvtqGUyCQfRvEC1KqXlg/f2RqRHdIzuWuRZdrPfSTJAdICzXKUHVXcVmmWHiH0scqmCHOqRqW/c4zIfY=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2019 13:55:26.7359
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 81a51c2f-b796-4073-f912-08d72ee40b0d
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR02MB5314
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation to describe Xilinx ZynqMP AES driver
bindings.

Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
---
 Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.txt | 12 ++++++++++++
 1 file changed, 12 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.txt

diff --git a/Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.txt b/Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.txt
new file mode 100644
index 0000000..226bfb9
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.txt
@@ -0,0 +1,12 @@
+Xilinx ZynqMP AES hw acceleration support
+
+The ZynqMP PS-AES hw accelerator is used to encrypt/decrypt
+the given user data.
+
+Required properties:
+- compatible: should contain "xlnx,zynqmp-aes"
+
+Example:
+	zynqmp_aes {
+		compatible = "xlnx,zynqmp-aes";
+	};
-- 
1.8.3.1

