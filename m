Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDFDB11753
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 12:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbfEBKfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 06:35:43 -0400
Received: from mail-eopbgr820048.outbound.protection.outlook.com ([40.107.82.48]:12682
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726283AbfEBKfJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 06:35:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jR/LNIOTd2fCWb9/fg0Ro3npe1DDyBRNXisE4JEmh3k=;
 b=S3TulYjZet+4oeW0WZld4KTpgjLJHVC946BBg0Rtt8EVNI/75T8ikL1JQ649YI3TiT0+UdwDUu0UP/99beykam1Q2U7cb1PXlw54hYzax3vRkm4ot7FAcJEXRNjoTyYCR80mLlrDblFBahVI3KG/lAGeNCTwdJtBrgqJEc55qIs=
Received: from MWHPR02CA0001.namprd02.prod.outlook.com (2603:10b6:300:4b::11)
 by MWHPR0201MB3404.namprd02.prod.outlook.com (2603:10b6:301:76::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1856.10; Thu, 2 May
 2019 10:35:03 +0000
Received: from SN1NAM02FT011.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::208) by MWHPR02CA0001.outlook.office365.com
 (2603:10b6:300:4b::11) with Microsoft SMTP Server (version=TLS1_2,
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
 SN1NAM02FT011.mail.protection.outlook.com (10.152.72.82) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1856.11
 via Frontend Transport; Thu, 2 May 2019 10:35:02 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1hM93O-0004iV-EL; Thu, 02 May 2019 03:35:02 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1hM93J-0007Vo-B1; Thu, 02 May 2019 03:34:57 -0700
Received: from xsj-pvapsmtp01 (maildrop.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x42AYtm8031033;
        Thu, 2 May 2019 03:34:55 -0700
Received: from [172.23.155.80] (helo=xhdengvm155080.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <kalyania@xilinx.com>)
        id 1hM93G-0007VG-Nz; Thu, 02 May 2019 03:34:54 -0700
Received: by xhdengvm155080.xilinx.com (Postfix, from userid 23151)
        id E81F28141F; Thu,  2 May 2019 16:04:53 +0530 (IST)
From:   Kalyani Akula <kalyani.akula@xilinx.com>
To:     <herbert@gondor.apana.org.au>, <kstewart@linuxfoundation.org>,
        <gregkh@linuxfoundation.org>, <tglx@linutronix.de>,
        <pombredanne@nexb.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <saratcha@xilinx.com>
CC:     Kalyani Akula <kalyania@xilinx.com>,
        Kalyani Akula <kalyani.akula@xilinx.com>
Subject: [RFC PATCH V3 4/4] ARM64: zynqmp: Add Xilinix SHA-384 node.
Date:   Thu, 2 May 2019 16:04:42 +0530
Message-ID: <1556793282-17346-5-git-send-email-kalyani.akula@xilinx.com>
X-Mailer: git-send-email 1.9.5
In-Reply-To: <1556793282-17346-1-git-send-email-kalyani.akula@xilinx.com>
References: <1556793282-17346-1-git-send-email-kalyani.akula@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(346002)(136003)(39860400002)(396003)(2980300002)(199004)(189003)(16586007)(316002)(305945005)(90966002)(70206006)(478600001)(186003)(47776003)(36756003)(4326008)(52956003)(51416003)(5660300002)(6266002)(2906002)(8936002)(42186006)(110136005)(107886003)(8676002)(63266004)(106002)(48376002)(103686004)(356004)(4744005)(54906003)(6666004)(50226002)(81156014)(76176011)(81166006)(486006)(44832011)(336012)(426003)(2201001)(446003)(26005)(476003)(70586007)(50466002)(11346002)(2616005)(36386004)(126002)(6636002);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR0201MB3404;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3b1bfd8-d9a9-40c3-24d4-08d6cee9d5fb
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4709054)(2017052603328);SRVR:MWHPR0201MB3404;
X-MS-TrafficTypeDiagnostic: MWHPR0201MB3404:
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-Microsoft-Antispam-PRVS: <MWHPR0201MB3404CD11589C72C5C2B1C1BBAF340@MWHPR0201MB3404.namprd02.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-Forefront-PRVS: 0025434D2D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: p1zcu/vSpgKTZRadwi/nHVp1Rv0OJh61/awokMIxKB3DK9tv7A8sj+uXsvtGNyLR3dVUMjM0cTvEz7V+SlrS2RGiiuO4T7A31LyFsV/sfkP+1z0E8odDQN+xS2gQrVLYjCwtcJw3PbqbWJuu5UARa3UMfX0NbobU1TRDXp5hz16x7KJIwRU71J3Cei1LTMyqOkWCRRp2EiiQU968TWlvyKbIzJo78UpbDPPv+2OuCVMj6cCx2JvF13nG92vnxZTM7uW/bkHK9RgNgUx3T55ojEadnGQ9fcIc/dnnSsMSgrMLL/qnYUSYlupsis5xZE9+i40FrndoBaA8JX8/JYZ5JRLr/4eSXNHtIQ8BIRSNOC9FRREHdIXQ51jgpN60yulnyi9kGuXUgXuAMErH+0+J11OqMDoD1arVo9lCPukqgao=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2019 10:35:02.8268
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b3b1bfd8-d9a9-40c3-24d4-08d6cee9d5fb
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0201MB3404
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a SHA3 DT node for Xilinx ZynqMP SoC.

Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
---
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
index 9aa6734..0532de7 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
+++ b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
@@ -124,6 +124,10 @@
 			     <1 10 0xf08>;
 	};
 
+	xlnx_sha3_384: sha384 {
+		compatible = "xlnx,zynqmp-sha3-384";
+	};
+
 	amba_apu: amba-apu@0 {
 		compatible = "simple-bus";
 		#address-cells = <2>;
-- 
1.9.5

