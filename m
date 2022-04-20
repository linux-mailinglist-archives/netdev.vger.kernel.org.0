Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B625350868E
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 13:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377885AbiDTLHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 07:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377874AbiDTLHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 07:07:20 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2089.outbound.protection.outlook.com [40.107.236.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8307403DE;
        Wed, 20 Apr 2022 04:04:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=crFtYffl8CNOvteJwqlTGLCwXN5i+hZ4JXzzLjpGois/lids9PcfhZsQ7BwnKMLEGRwo0l8eolByv0sa59BDdzlTcW8ldui72AVzi9GGSHKNxT9BTSIbuf+oE/B2K7Z6XjRboFz3pitMNj/Q3FQNpFFhXC3jGb45xnxxv0olOarDdb1/vblPaifawAQxffsKE2nJ1C75/610XQfjWC5cCPuFUEqaMGkSL9ehSkIedLbW2hT/fY9s+8Og6iEQGtTz9NvH/VUherpkZUKvGVL9qYck6H9FnFYdy8Mchs/5feH/NN1YmOTy4LgJHg9C2AKBq892wWK0wGhwPOd8Ka2c1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+TJf58eXb2CdK4xItIGwPbxv/Z2BN2/p0slBupV05MU=;
 b=i75sLTJbZLOWu5k1lKlywr4f16Q325Q2pjoOz+aje0Uo4dZ7jqhtXTGsj04KLBWwIgKD/DNPvHYhMhVRMZJrcfyetV2lAdbnwLbcMGqje+hFmCaOJ3yvXVAEEHlgi1utOzAVOvMsBzvXqZd+hO21ZkMJVZhLlW0SbbI0MMJ5+JCWctU81wphmJrcSycZALTjMSWE3Ma35m9LNlJPFythq45rGelJXKUVgur+M+/dysINwHV9/DiE4y768wftRWQmnAf+NiKU8OTUcUMeA+zPQ9A8JG/UO3X689RwptUr8OokqIGpaq930zxccIlcjjb2IDFw9lWafjRB4B88Gz0wTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=davemloft.net smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+TJf58eXb2CdK4xItIGwPbxv/Z2BN2/p0slBupV05MU=;
 b=hW0FzTS4yEvWwnlZIgFPwc7yYIyEDryta8vXHam4kh+QJWF9cV+eLcMQLMi9YbdmayyvXRdMJt0Oyyv3+Hsa4GZKcXHjU4EoReUtBzB9eQ3nCqWl82zKgVlycGz4lHtDHGAppjza5V/Z+1xVZmpm03Ng1vBmr2tBSkBXihzNnaY=
Received: from SN1PR12CA0097.namprd12.prod.outlook.com (2603:10b6:802:21::32)
 by BY5PR02MB6162.namprd02.prod.outlook.com (2603:10b6:a03:1fd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 20 Apr
 2022 11:04:31 +0000
Received: from SN1NAM02FT0032.eop-nam02.prod.protection.outlook.com
 (2603:10b6:802:21:cafe::bf) by SN1PR12CA0097.outlook.office365.com
 (2603:10b6:802:21::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14 via Frontend
 Transport; Wed, 20 Apr 2022 11:04:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 SN1NAM02FT0032.mail.protection.outlook.com (10.97.5.58) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5186.14 via Frontend Transport; Wed, 20 Apr 2022 11:04:31 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 20 Apr 2022 04:04:04 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 20 Apr 2022 04:04:04 -0700
Envelope-to: git@xilinx.com,
 davem@davemloft.net,
 krzk+dt@kernel.org,
 kuba@kernel.org,
 robh+dt@kernel.org,
 claudiu.beznea@microchip.com,
 nicolas.ferre@microchip.com,
 pabeni@redhat.com,
 devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.63.71] (port=45314 helo=xhdvnc211.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1nh87w-00063s-FP; Wed, 20 Apr 2022 04:04:04 -0700
Received: by xhdvnc211.xilinx.com (Postfix, from userid 13245)
        id 4F27D60D73; Wed, 20 Apr 2022 16:33:37 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <robh+dt@kernel.org>, <krzk+dt@kernel.org>,
        <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <michals@xilinx.com>,
        <harinik@xilinx.com>, <git@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH 2/2] net: macb: In ZynqMP initialization make SGMII phy configuration optional
Date:   Wed, 20 Apr 2022 16:33:10 +0530
Message-ID: <1650452590-32948-3-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1650452590-32948-1-git-send-email-radhey.shyam.pandey@xilinx.com>
References: <1650452590-32948-1-git-send-email-radhey.shyam.pandey@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c0a29ed-8f09-4dde-a4cb-08da22bd8b99
X-MS-TrafficTypeDiagnostic: BY5PR02MB6162:EE_
X-Microsoft-Antispam-PRVS: <BY5PR02MB6162CFED6634F1CC1971DA6FC7F59@BY5PR02MB6162.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZUHdGTx0sDOsVN/424QQfUahBQCFIhz+6CObN9k22Zf84unwqHATfy6BF6Q4slCea+jjZxEfA9j9HBXBNraIafTIQXTDNRCMo2KfC5Q0gmGi2rZ5QSpNC8gDquKw5scunvW0qZFtEOndLM0wfS3bNXgB8SLUScZK24hg6JZkJDyGpSSbnns1KPt/c1Lm7Q2bRu0tPQoTQE2T4QuJtTo7kaDfUoks0SAzwa4NYU4kYMJn7QNxqOtniA4u+jBcGMJelCVOfj6K/XaBa52QhENCblkE5H8I25NKZxVbEoT2Oei4W5Ot4uJjK7gnABoaGHuMxpTdoUDSNzdAICyaaV0UMqsXggqusXPoXnN+0xssuC8N1hXxPr/TSTJ4YECTS0rvV4+PFjOGiJt2UiqvbZLfflI+pSZASgBCNGOAx//y9mpfUBQX80aVJ5PN1X2SzZttdlkLMtBCxRraaZcl7jj6gTYo9Y3P3PQiZbzOsJ27CM7tThEBVPA1n0IOSgDwzRNb+B57boCossouK7x9ZtFI2CTNsMNKr76QvzvyjaWBKXSy5kkuMMprNeym2cjqGviweb63cP4zrWv4oGiUfH6PTqB6WguN45jIzVqvap5RO9Oj0uMFyft5/Z6inC+md5P+bh+GPLCcR5zF3Sg9hKKmp4KkGBySTbndH49W00I+YOM1zz9KnpqEmhktf1y04ZsZgxCjtC4O+n6bvwYU5ucNqQ==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(508600001)(6266002)(5660300002)(26005)(40460700003)(2906002)(7416002)(8936002)(107886003)(47076005)(6666004)(2616005)(426003)(336012)(186003)(110136005)(82310400005)(70206006)(36756003)(42186006)(54906003)(316002)(356005)(7636003)(70586007)(83380400001)(36860700001)(4326008)(8676002)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2022 11:04:31.1674
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c0a29ed-8f09-4dde-a4cb-08da22bd8b99
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1NAM02FT0032.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6162
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the macb binding documentation "phys" is an optional property. Make
implementation in line with it. This change allows the traditional flow
in which first stage bootloader does PS-GT configuration to work along
with newer use cases in which PS-GT configuration is managed by the
phy-zynqmp driver.

It fixes below macb probe failure when macb DT node doesn't have SGMII
phys handle.
"macb ff0b0000.ethernet: error -ENODEV: failed to get PS-GTR PHY"

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index a5140d4d3baf..6434e74c04f1 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4588,7 +4588,7 @@ static int zynqmp_init(struct platform_device *pdev)
 
 	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII) {
 		/* Ensure PS-GTR PHY device used in SGMII mode is ready */
-		bp->sgmii_phy = devm_phy_get(&pdev->dev, "sgmii-phy");
+		bp->sgmii_phy = devm_phy_optional_get(&pdev->dev, NULL);
 
 		if (IS_ERR(bp->sgmii_phy)) {
 			ret = PTR_ERR(bp->sgmii_phy);
-- 
2.7.4

