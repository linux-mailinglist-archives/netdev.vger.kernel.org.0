Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03877A49A4
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 15:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729069AbfIANzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 09:55:32 -0400
Received: from mail-eopbgr730047.outbound.protection.outlook.com ([40.107.73.47]:29632
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728990AbfIANzb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Sep 2019 09:55:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C+WXvzvG+yRgzWo3vow8AFujrsFu38cEnKwlFpx8Cpr3J3ZI3knevSZvZKIBsfO65imXMR4ddgSny5FV9148bdkv4Ry6nF5w4FWl0DXmz+LAcT7tplifuJxUXV7Jv4rnGmznZ7qDQv/6Pi3q/TrMak13ceV0N2A3w5QHSKdNnlYkqzJFl2t9/6rTrHF6ZdmaQ8peD5ugHt1E0ffe5aHz24dOi0N1dQZspe9pO09Ztpv+/+KJiIUsPtYqG2lGfvS0+gV0mp5c/AimoWlBzFckc8Vmpb6ixYymVbYdZNej+WVhDgZ73n/YNYcfvmMPBjq5CGbmFYFBaJVoP6Rwj6GWkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H/BXhnfb6MIDK6FfyvvMGFmgsoF6/b5nzfNM4JTKcro=;
 b=BKYFivFPnra1kKRFnpal0IYg309aJOFAwhkg4rgJMlb4WkFiMQ7xl5geVgnX+WWbkXbuvbUXZtFjOhInvuL7qskeyar6NxA1NJW8L2V4ndbbFkblUzGXJSOKgRV8/+ophJg28kZAKGhSWKuzqXB4QX7VZQaX9l3k90j1VMrDJIEjeWwcBnLuVOh9D3AOK8WcjvP1C/x6t/dqZfYher99halK5e+HkfAChdyXZwdRt8dEseZ+wlBR+F8Jbv7FC5lj4JYG0xPXEKbSMKSUVaC4edKh0ehBB5NhqO5XW9EnUktVgs4DKEurWds+OSPndfrmtUFaySIaQCImXFxZ6ESaEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.100) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H/BXhnfb6MIDK6FfyvvMGFmgsoF6/b5nzfNM4JTKcro=;
 b=fgnJQCoTpC+TxXyvyzWwpP0UEhPHOA2rIf/g4tmFfg8LJw9fWJzTyAWdHJcInjssi6OP9Fqo9U/9JSrx9eCoda+XYKhDpuoRgClBWHp6s/ImHn3v1p8PPZQuyo/YN7fo38uSEGvJ6RuDKDGdZpNb77g84RBxCzi49y8Q+vHtQDs=
Received: from MWHPR02CA0004.namprd02.prod.outlook.com (2603:10b6:300:4b::14)
 by BN7PR02MB5332.namprd02.prod.outlook.com (2603:10b6:408:30::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2199.19; Sun, 1 Sep
 2019 13:55:27 +0000
Received: from CY1NAM02FT051.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::209) by MWHPR02CA0004.outlook.office365.com
 (2603:10b6:300:4b::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2220.19 via Frontend
 Transport; Sun, 1 Sep 2019 13:55:27 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.100)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.100 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.100; helo=xsj-pvapsmtpgw02;
Received: from xsj-pvapsmtpgw02 (149.199.60.100) by
 CY1NAM02FT051.mail.protection.outlook.com (10.152.74.148) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2220.16
 via Frontend Transport; Sun, 1 Sep 2019 13:55:26 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66]:50143 helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw02 with esmtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1i4QKD-00048z-St; Sun, 01 Sep 2019 06:55:25 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1i4QK8-0002cJ-PL; Sun, 01 Sep 2019 06:55:20 -0700
Received: from xsj-pvapsmtp01 (xsj-mail.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x81DtBHk010529;
        Sun, 1 Sep 2019 06:55:11 -0700
Received: from [172.23.155.44] (helo=xhdengvm155044.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <kalyania@xilinx.com>)
        id 1i4QJz-0002ao-Es; Sun, 01 Sep 2019 06:55:11 -0700
Received: by xhdengvm155044.xilinx.com (Postfix, from userid 23151)
        id C0AC18021A; Sun,  1 Sep 2019 19:25:10 +0530 (IST)
From:   Kalyani Akula <kalyani.akula@xilinx.com>
To:     herbert@gondor.apana.org.au, kstewart@linuxfoundation.org,
        gregkh@linuxfoundation.org, tglx@linutronix.de,
        pombredanne@nexb.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Kalyani Akula <kalyania@xilinx.com>,
        Kalyani Akula <kalyani.akula@xilinx.com>
Subject: [PATCH V2 2/4] ARM64: zynqmp: Add Xilinix AES node.
Date:   Sun,  1 Sep 2019 19:24:56 +0530
Message-Id: <1567346098-27927-3-git-send-email-kalyani.akula@xilinx.com>
X-Mailer: git-send-email 1.9.5
In-Reply-To: <1567346098-27927-1-git-send-email-kalyani.akula@xilinx.com>
References: <1567346098-27927-1-git-send-email-kalyani.akula@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.100;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(346002)(376002)(396003)(2980300002)(199004)(189003)(36756003)(81166006)(81156014)(47776003)(106002)(103686004)(44832011)(26005)(8936002)(478600001)(2616005)(52956003)(126002)(446003)(186003)(6266002)(426003)(476003)(70206006)(70586007)(42186006)(16586007)(4326008)(4744005)(50226002)(305945005)(48376002)(336012)(5660300002)(51416003)(486006)(76176011)(8676002)(6666004)(356004)(50466002)(2906002)(36386004)(316002)(11346002)(107886003)(54906003)(5001870100001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR02MB5332;H:xsj-pvapsmtpgw02;FPR:;SPF:Pass;LANG:en;PTR:xapps1.xilinx.com,unknown-60-100.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 765e572e-b644-4cb1-ebcb-08d72ee40b01
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(4709080)(1401327)(4618075)(2017052603328);SRVR:BN7PR02MB5332;
X-MS-TrafficTypeDiagnostic: BN7PR02MB5332:
X-Microsoft-Antispam-PRVS: <BN7PR02MB533215D50623341230D163F6AFBF0@BN7PR02MB5332.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-Forefront-PRVS: 0147E151B5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: bo8FJdmwSaQvs6bdiV6k9tTlwVMI8zhh4BD2/Fmh0MXAnKhkNPItzwrcrDyPCRpe9iJBs+44phUaA+Gd2SebZPeDIvPp6l8PcHw0K4IUOouv3lmxAEF8j80M0Xty48hcfvYLqhEed3RDUWvLiRnMozwrg+abHnLXubdTFOAL4Pe2+g2aQz+lekCYUjM4NB9UNF/ju5wwtWqrLBTmTbVzrMlEoB4ZqwQXBQ8WQSqSrCvt+kXWYKVp9qr5aDDYVkbzaJ9NrseltpdJ6UPVAyz2dMMjZdFhOa4hRGc9M5Br+j9JJ8iBsFQQwx1ofF7t5tnfXdKaYihxQPsN+1S5fvyuEWUIhi1XoyYFYld/VBB5FQimqmsMq41kWmI5jos9tfLTckqsHv1q4RcbydsQQSQmyLnbKncxSNSdFQibEp/skQs=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2019 13:55:26.3937
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 765e572e-b644-4cb1-ebcb-08d72ee40b01
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.100];Helo=[xsj-pvapsmtpgw02]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR02MB5332
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a AES DT node for Xilinx ZynqMP SoC.

Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
---
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
index 9aa6734..b41febc 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
+++ b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
@@ -124,6 +124,10 @@
 			     <1 10 0xf08>;
 	};
 
+	xlnx_aes: zynqmp_aes {
+		compatible = "xlnx,zynqmp-aes";
+	};
+
 	amba_apu: amba-apu@0 {
 		compatible = "simple-bus";
 		#address-cells = <2>;
-- 
1.8.3.1

