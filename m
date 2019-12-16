Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 285B21204FF
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 13:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbfLPMIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 07:08:44 -0500
Received: from mail-bn7nam10on2047.outbound.protection.outlook.com ([40.107.92.47]:6182
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727481AbfLPMIn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 07:08:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bR0srpkNKDAL8K6HIHLHzD+5NhMlP3dbfIxQZLMzA5XDtrk+iX/nvXJ8lZWKy+xYTuJxKn7OiKyoVMH5B/2+pIY7/6eEXtLkkKvACbb47SQ9liL0pA/YoAxXRLo1yDSXCALu2SrMW1F1mPBs1LPZZDK5j7k1gIlRwBgevqbL80hS6KqQivP106rG4dkMo6FyzFF9nCLtueSXvw027njYRrS0QsylbNCw52GosD3E6NUZf41k3rp4lGzDprYuLO7J2P4XVZK2GAzCWm9japQHat68BoGc9Kg4JEiOguY8XX8mJf0w1RVOwusphy8xZzCENhxboW5K3U1hqt1SkmjEIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bSl7E8xxECs4dyA+dTDWm/ZsppKl25xdERZ8frrwWdQ=;
 b=HbaPzkl1wLVIdkEPuC9SCl0qhReMFIH5WHT1EMezJv5TNBUAyVlWZDVZxH1hnujiWTSCfJ3MMR9yLi3WWjTuLnNXOR1vnQCzXYGjLstwkgPw5N7KxKuLfoOz688zpWS6e3oLX1f6PFP3Up/3xTOIp/M6oEL3BUE2ZvvMCws1/DVkI5jnRaNaczAotPDcwwFeZW/6kaR0pUqnfi1CCJhoOyys1Mfz5h7gFYf0o8DpVKzrdXolSS4loKZv2+dsD4YcDkyaJZL7wn2lIMrZZvLBk7Mn1zijOS8vWToboAIB7pm4U4Xik5OjHburiRp2RQ3D6oWAj54NihEx/jsL3tkm8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=xhdpunnaia40.localdomain; dmarc=none action=none
 header.from=xilinx.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bSl7E8xxECs4dyA+dTDWm/ZsppKl25xdERZ8frrwWdQ=;
 b=mEBlxcc7rfnDLbVPjGggj7opw2QrVyhaCo3nIMAMx+prVFpnuykFIwgtO3HTEYl2klIz/4NwXuObU9tlIPEhNk+Um7g1q2eZJyMbdWdvQq6t2aj3PoXR8iTJqGaDxdIPy1Sg93eYUd4ERb8EHc0BDQeoQGUWfq2F9ake6oxiPXw=
Received: from SN2PR01CA0023.prod.exchangelabs.com (2603:10b6:804:2::33) by
 MN2PR02MB6703.namprd02.prod.outlook.com (2603:10b6:208:1d2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2538.18; Mon, 16 Dec
 2019 12:08:39 +0000
Received: from SN1NAM02FT015.eop-nam02.prod.protection.outlook.com
 (2603:10b6:804:2:cafe::2) by SN2PR01CA0023.outlook.office365.com
 (2603:10b6:804:2::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2538.15 via Frontend
 Transport; Mon, 16 Dec 2019 12:08:39 +0000
Authentication-Results: spf=none (sender IP is 149.199.60.83)
 smtp.mailfrom=xhdpunnaia40.localdomain; vger.kernel.org; dkim=none (message
 not signed) header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=xilinx.com;
Received-SPF: None (protection.outlook.com: xhdpunnaia40.localdomain does not
 designate permitted sender hosts)
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 SN1NAM02FT015.mail.protection.outlook.com (10.152.72.109) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2538.14
 via Frontend Transport; Mon, 16 Dec 2019 12:08:38 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1igpAz-0001l9-CL; Mon, 16 Dec 2019 04:08:37 -0800
Received: from [127.0.0.1] (helo=xsj-smtp-dlp2.xlnx.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1igpAt-0000we-Md; Mon, 16 Dec 2019 04:08:31 -0800
Received: from xsj-pvapsmtp01 (xsj-mail.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id xBGC8U8i024878;
        Mon, 16 Dec 2019 04:08:30 -0800
Received: from [10.140.184.180] (helo=xhdpunnaia40.localdomain)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1igpAs-0000wN-Au; Mon, 16 Dec 2019 04:08:30 -0800
Received: by xhdpunnaia40.localdomain (Postfix, from userid 13245)
        id 88E541053CE; Mon, 16 Dec 2019 17:38:29 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     davem@davemloft.net, michal.simek@xilinx.com
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, git@xilinx.com,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH net-next 2/3] net: emaclite: In kconfig remove arch dependency
Date:   Mon, 16 Dec 2019 17:38:09 +0530
Message-Id: <1576498090-1277-3-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576498090-1277-1-git-send-email-radhey.shyam.pandey@xilinx.com>
References: <1576498090-1277-1-git-send-email-radhey.shyam.pandey@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-Result: No-0.229-7.0-31-1
X-imss-scan-details: No-0.229-7.0-31-1;No-0.229-5.0-31-1
X-TM-AS-User-Approved-Sender: No;No
X-TM-AS-Result-Xfilter: Match text exemption rules:No
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(346002)(136003)(39860400002)(428003)(249900001)(199004)(189003)(81166006)(107886003)(5660300002)(6266002)(450100002)(8676002)(2616005)(4744005)(26005)(36756003)(4326008)(42186006)(8936002)(2906002)(42882007)(70206006)(70586007)(336012)(316002)(498600001)(81156014)(356004)(6666004)(6636002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR02MB6703;H:xsj-pvapsmtpgw01;FPR:;SPF:None;LANG:en;PTR:unknown-60-83.xilinx.com;A:0;MX:0;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4355b4f3-80d4-4252-5268-08d78220af74
X-MS-TrafficTypeDiagnostic: MN2PR02MB6703:
X-Microsoft-Antispam-PRVS: <MN2PR02MB6703AB0745AB5C91F5AEFC0DD5510@MN2PR02MB6703.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 02530BD3AA
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Kz4Pfz+SLCTCwojs2/s/hS3qLpnqQuZAzipqaw2sNqc/K6+HJKgGYv1l8MrSH16T5D4inFi0rAjXJDUkpctX0N2NClKgSGqkhwAjsR19+G0oKcvQG6+az+weDxytR4tme3N4973KlMuVEImElARu7nVUl2/BS3mVa0u7QBugXRoy8bc08PgtViE3iOdE3tnLG7hUahedjZeXG0KfpRKHAlNnwzBGcIuaDtP5/8wmTUmaO/k1wPjz2eKxJiHzAT4y0+FCG+91g4OnSAR9l2fWEdBJ5shOCkyCcfxFlkgCVmkx00cKAIw/4Ayo9H7LVkiM6/MS7cXsuHqUvqFkC47D3F2v0ZfPnAbHoy1N6/mlT1Wf9/geOmrKyTKt45ZyP6X1OTrjVJXB8EyYUzTfgQMqHuRmVK/H1B9+7KsWfoEuyorAOrSojIxAefJ99jFBa3t
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2019 12:08:38.9300
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4355b4f3-80d4-4252-5268-08d78220af74
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB6703
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To enable xilinx_emaclite driver support on zynqmp ultrascale platform
(ARCH64) remove the obsolete ARCH dependency list. Also include HAS_IOMEM
dependency to avoid compilation failure on architectures without IOMEM.

Sanity build test done for microblaze, zynq and zynqmp ultrascale platform.

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
 drivers/net/ethernet/xilinx/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/Kconfig b/drivers/net/ethernet/xilinx/Kconfig
index 6304ebd..0692dd1 100644
--- a/drivers/net/ethernet/xilinx/Kconfig
+++ b/drivers/net/ethernet/xilinx/Kconfig
@@ -18,8 +18,8 @@ if NET_VENDOR_XILINX
 
 config XILINX_EMACLITE
 	tristate "Xilinx 10/100 Ethernet Lite support"
-	depends on PPC32 || MICROBLAZE || ARCH_ZYNQ || MIPS
 	select PHYLIB
+	depends on HAS_IOMEM
 	---help---
 	  This driver supports the 10/100 Ethernet Lite from Xilinx.
 
-- 
2.7.4

