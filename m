Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D316C687D45
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 13:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbjBBM0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 07:26:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjBBM0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 07:26:40 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2058.outbound.protection.outlook.com [40.107.223.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7357DF74F;
        Thu,  2 Feb 2023 04:26:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AkOllQ7hckxpgZ9zHY6Rom52G62fCESDijE5xXM5of4/J85xuJPjMHJUk4Cs4V7E/aUpfJXeE83pAQurbS0zjWhxJaDU4ox/iyihDj0SDh+UFpaRWkL5AtMCHgJC4dtWzeGjw87tCKunUiA1SYKiX2pjzKSs8s3ZqAWaOnordsnB1gYDKzbi8MmwseMJfLgzORf/HeEfcldrbG5GBdo2alZD/9G5BRe086qeMe5Lw6She3Hz81wjny8czuvTm+6de5Y4vRcpBPmpJyMkYiCZRbBxb43s4hJHi98Z92A+dQI7mpp6eG6OwAGA05oJhzmLXPp9S0cVzcl7J0fhh/B6mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yTFJ57VJ1ka4KsAV3uh0+G+Ov9YHg1wOnlM5TiRYY3c=;
 b=DQF/YkLPvTKSM9xgV6A/Fz59sDVvY1RskbJQpFMIJC83p4OOg0UKw26DoJaNo7ZxZygInxS0wDJFxLOZgKl3IvJi7brkQ4e6FVra+P3pGLackWJvKWVVJNgAoK9g+zI4JIIpexkvc5GVHyguRxBoCbJhxAbvlbTYu6AsjE+db7XMFZTU5pzU05uD7fpRuevsJPlRHKai/vPJALtAD1Awqxx/kdceXmvpqVgCPKUEHA0DUmNMOTcxrUbFpJeLtJ2vUa5rt8C+oTj9y+Lw5Xoo6zRzcmKmr3WSCynrE/32aqhb1NfWu/hir0i1p3IZhIpTER61Nx/67LLac2Qp1fDdjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=amd.com smtp.mailfrom=xilinx.com;
 dmarc=fail (p=quarantine sp=quarantine pct=100) action=quarantine
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yTFJ57VJ1ka4KsAV3uh0+G+Ov9YHg1wOnlM5TiRYY3c=;
 b=mw1TsCTRsbriYDqaZ9kKz/J+9bRagjWoqJnJORDjQHL9wuIS7cdh2dLbzHlg2ZhNoeQqWkkPfX+MJ2ueyjVW9LAroZ4+09aeeqKLmlRgwgTKEvkNNVh9KzXm25xT2GI3fgNXA1Z9hrbcsfzg8lAFzivquu6BcTKLBJrBP/Trd8o=
Received: from DS7P222CA0022.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::25) by
 SA1PR02MB8494.namprd02.prod.outlook.com (2603:10b6:806:1f9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Thu, 2 Feb
 2023 12:26:37 +0000
Received: from DM3NAM02FT020.eop-nam02.prod.protection.outlook.com
 (2603:10b6:8:2e:cafe::25) by DS7P222CA0022.outlook.office365.com
 (2603:10b6:8:2e::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27 via Frontend
 Transport; Thu, 2 Feb 2023 12:26:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=quarantine header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT020.mail.protection.outlook.com (10.13.4.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.33 via Frontend Transport; Thu, 2 Feb 2023 12:26:37 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 04:26:35 -0800
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 2 Feb 2023 04:26:35 -0800
Envelope-to: git@amd.com,
 radhey.shyam.pandey@amd.com,
 davem@davemloft.net,
 edumazet@google.com,
 kuba@kernel.org,
 andrew@lunn.ch,
 claudiu.beznea@microchip.com,
 nicolas.ferre@microchip.com,
 pabeni@redhat.com,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.64.3] (port=38489 helo=xhdvnc103.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1pNYfj-0008IC-AG; Thu, 02 Feb 2023 04:26:35 -0800
Received: by xhdvnc103.xilinx.com (Postfix, from userid 13245)
        id 822FB1055BA; Thu,  2 Feb 2023 17:56:34 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
To:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <andrew@lunn.ch>
CC:     <git@amd.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Subject: [PATCH] net: macb: Perform zynqmp dynamic configuration only for SGMII interface
Date:   Thu, 2 Feb 2023 17:56:19 +0530
Message-ID: <1675340779-27499-1-git-send-email-radhey.shyam.pandey@amd.com>
X-Mailer: git-send-email 2.1.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3NAM02FT020:EE_|SA1PR02MB8494:EE_
X-MS-Office365-Filtering-Correlation-Id: b7554366-4873-42e9-ff2a-08db0518bae8
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FQRyq6fwZ4M3qnJRhXdfGZKdwrpiFoUnkqWRmgPycKWnS+eLcC04XZSJW9zu2fq/xnaFic0lfsZ+iYj//0d7o0VdDR0yONE07AfhRWDee0uXxKY8EJkMLXcn73/mLPzdeGZaNMT2cBmVJWVuTNE1wROIEjOmE75lBeu+LVchF1C11LS8uLKi3VLikqLv6Uhau15+Me+HES7PayoJsr2TaYHgmMDgdRfLJL2ZRJGJMmEXyWICVFGBAUEbCVX3raX+kir5oSKAPkEbsKpjHn8PZ1UAp9iVEbuw17q/OFPdvun0KWOTuMqICccdKGp7D0LiL8iMJttZwLjdspuOZIH7SbvS6mFGUGBOojOaChlxjusiPIhrms29aBuKRTfBwEme758BO/76X60IhyL7UmESvSWmLJzET+WuCNuaofP0O8XUZfAj44plq3bCr5javd1Mbl+gfcrIkJRnV/TuE98QXfxxXAhcPlEIExhm9f1r3489igVJ+BrmbTFVxC85nPU/sOtks7njIw8hqWSI0U+O8Alpv0Tl0WQUZpKCxnDpwWCPttSZQvcTQUuwo+zdFroCIhb37gOFSVBgA9Hff8TvcNQdljgJHhILz50inmxi4EgagOdeDx88KM5OTtrVZfliQqy0hiFfcW56pqtFVt5my0UwyTFvJ7VVUrhF9xesvq/oJWOD8G/DkutmGLjLmg3ZFjJ/0BsWJXSStrkcV06sjXYHfwUsGqKPWbLKTHvTpb0=
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230025)(39860400002)(346002)(396003)(136003)(376002)(451199018)(40470700004)(46966006)(36840700001)(5660300002)(7416002)(40480700001)(36756003)(36860700001)(2906002)(82740400003)(7636003)(40460700003)(47076005)(336012)(42882007)(6266002)(2616005)(26005)(186003)(356005)(82310400005)(83170400001)(83380400001)(54906003)(110136005)(42186006)(70206006)(70586007)(478600001)(6666004)(8676002)(316002)(41300700001)(4326008)(8936002)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 12:26:37.5461
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b7554366-4873-42e9-ff2a-08db0518bae8
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT020.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB8494
X-Spam-Status: No, score=1.1 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In zynqmp platforms where firmware supports dynamic SGMII configuration
but has other non-SGMII ethernet devices, it fails them with no packets
received at the RX interface.

To fix this behaviour perform SGMII dynamic configuration only
for the SGMII phy interface.

Fixes: 32cee7818111 ("net: macb: Add zynqmp SGMII dynamic configuration support")
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 31 ++++++++++++------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 72e42820713d..6cda31520c42 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4627,25 +4627,26 @@ static int init_reset_optional(struct platform_device *pdev)
 		if (ret)
 			return dev_err_probe(&pdev->dev, ret,
 					     "failed to init SGMII PHY\n");
-	}
 
-	ret = zynqmp_pm_is_function_supported(PM_IOCTL, IOCTL_SET_GEM_CONFIG);
-	if (!ret) {
-		u32 pm_info[2];
+		ret = zynqmp_pm_is_function_supported(PM_IOCTL, IOCTL_SET_GEM_CONFIG);
+		if (!ret) {
+			u32 pm_info[2];
+
+			ret = of_property_read_u32_array(pdev->dev.of_node, "power-domains",
+							 pm_info, ARRAY_SIZE(pm_info));
+			if (ret) {
+				dev_err(&pdev->dev, "Failed to read power management information\n");
+				goto err_out_phy_exit;
+			}
+			ret = zynqmp_pm_set_gem_config(pm_info[1], GEM_CONFIG_FIXED, 0);
+			if (ret)
+				goto err_out_phy_exit;
 
-		ret = of_property_read_u32_array(pdev->dev.of_node, "power-domains",
-						 pm_info, ARRAY_SIZE(pm_info));
-		if (ret) {
-			dev_err(&pdev->dev, "Failed to read power management information\n");
-			goto err_out_phy_exit;
+			ret = zynqmp_pm_set_gem_config(pm_info[1], GEM_CONFIG_SGMII_MODE, 1);
+			if (ret)
+				goto err_out_phy_exit;
 		}
-		ret = zynqmp_pm_set_gem_config(pm_info[1], GEM_CONFIG_FIXED, 0);
-		if (ret)
-			goto err_out_phy_exit;
 
-		ret = zynqmp_pm_set_gem_config(pm_info[1], GEM_CONFIG_SGMII_MODE, 1);
-		if (ret)
-			goto err_out_phy_exit;
 	}
 
 	/* Fully reset controller at hardware level if mapped in device tree */
-- 
2.25.1

