Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6665681CB
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 10:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbiGFIjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 04:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232439AbiGFIjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 04:39:31 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2077.outbound.protection.outlook.com [40.107.93.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 618C524975;
        Wed,  6 Jul 2022 01:39:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fMe31QkWRy3Wq8bZH7KudABr15lw6i7L0XT0Gd+DI6wS1Q4B7lbPiDe2IG2rwpUuunc8HGH8aFXM7xjZExvQ3+1BFJeFkyo9+9M8oP9nZhXU/pDcj+7Dugs1n/32kDyKp/VpaEOuOSAJI3jOrOzYILqyGMYojaXfi8ZRQtTfNkst6MLNKk3fNtBQgkrOXREGmVr2BDlP6EtY6/FIMkXXHXumYqwlvWs9kUsirZW1Q4aBVSVLUhV7tTiWxvipBknbaFY3P5d1TTOSsGijv24qqy58HCjI9SoxlQT5zJf92wM4CndZWUgQO6bqUkAJynRexyn1DJ7ZYP1KcxfgZt6qRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sOgMGDFfhc2ZSrQ57p6nK3ZgOanQF84crkYrEDkckzk=;
 b=f44wS0jPZmlmTZt0ap1qQYfDFJYUBBIXnH2WkU44j2ewxjTFnxZMg9oNXEPTDQPZ4CJpyXil86xU3/svxTbNFGEyuamoZH3HVizog6q/eZte3vMjzN4NN7qO9jFIrVmstgZoQPtVso9SMuUdxoYADAV11bW1RVzV5PqMAGuUCvokDH7bOi1k7hVOqogCrP8VdEQD0SGIWfVoSkfj0lgNkOCAd3vI32pryNrnMxmJiGJ4Sfziu2fzNoSUWqtllBcZT8oqXwWrIe8oobmgDopw4g9eRZ94PAoT5I7g64324pSNxZxDcBrcqOts1tYm1B5WxpfY7ObgeexqZNE3/CKHpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sOgMGDFfhc2ZSrQ57p6nK3ZgOanQF84crkYrEDkckzk=;
 b=eMyvG+/9iUMBeDEC5v1c4AMCAaPhNbwdEmSahEfps4vKjT+67pXvyq7XK++UWDR8aOYBRhrJWhx+tTCDrM3zhihPUnoZVK5rEFhCL8zGacp5c1dKJEHGii9DxrI3ItSzF2g9MHA5nwNyQ3CpLlb/KvXbHnrNlY7zq1/7i9ccIRjYeIVGFfNMWARWv2UGH5P7vAiQ6UAeCuB7xmqzyuR2RpO5JcUC49PqD28W9jsH7w98hU7QfhIVwawmFLtyg39egepQyupN414ayejVMdKk1uNnTfU6ydDkMLxh32tJQcKnECgUNLTPz+k3mLj525y2S5PlJ16ky6qmh6XSa9BWuQ==
Received: from CO2PR18CA0048.namprd18.prod.outlook.com (2603:10b6:104:2::16)
 by SN1PR12MB2509.namprd12.prod.outlook.com (2603:10b6:802:29::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Wed, 6 Jul
 2022 08:39:28 +0000
Received: from CO1NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:2:cafe::2e) by CO2PR18CA0048.outlook.office365.com
 (2603:10b6:104:2::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21 via Frontend
 Transport; Wed, 6 Jul 2022 08:39:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT056.mail.protection.outlook.com (10.13.175.107) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5417.15 via Frontend Transport; Wed, 6 Jul 2022 08:39:27 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 6 Jul
 2022 08:39:26 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 6 Jul 2022
 01:39:26 -0700
Received: from moonraker.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Wed, 6 Jul 2022 01:39:23 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Jon Hunter <jonathanh@nvidia.com>
Subject: [PATCH] net: stmmac: dwc-qos: Disable split header for Tegra194
Date:   Wed, 6 Jul 2022 09:39:13 +0100
Message-ID: <20220706083913.13750-1-jonathanh@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e298eb69-0bec-4c99-5632-08da5f2b09a1
X-MS-TrafficTypeDiagnostic: SN1PR12MB2509:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 12Ayo5S5gZh98rklk8qWzJUtuRJ1xPMlw07VCIqRxJv0thmjA+CbQHa61r/pIseUkgpVUpV0UHalefoRW8CBw70aJtmDxUqr4KLu/8kBGCashNO8T7Irxk3yoBR9GJFvol4Tra9jfeMOSXM+6mhWNKgg/yrTWOthzRr2Y4u5/n6ekyudpRpoI6ZvteoSV2lQlfu7LJhbXmvO/gGwt+WI++kMIH5FFe/rksXwH90Z89kYNqZuVi6/bkqZqWvCvRD95PJDBZWy73BzBEiNh9pczUvTEDJYe3dqPOCd7X2pc9WfgBHaZrPU2PTy5MAYSdrlaKunP2wNq/jOPqgOTtLtLMfluUPS9OroXVXr4aJShd2EZkBxkpoy1qewW417CBEfkSojdCqeveZ56RaxZUXsAQPZdHG3tGR9/DxstVR/l2IzZEtfNhzeQmDtdFd9RQ5Om72cJFwtXzjB3x00aQg5cRoTQV2aU3LNagvgF+Rx7ku+bTgYKb/cg6TcSnCCTepUW3X/9Tr9sVtsB/fHyGc2MoFoyriekglfKo/sZPl49sHD7dr9bF9nabcpvkAjrDnpTO3VbWutwy/dvwCRJYkaKHImCZTnjJVYWv62GVVDtnPERn5yHnQY5z545wXvPRc87Xkz+BtSYD3qgnsFIUU9pWH/541fTgv+f1ApmbNEj0ucApCCL+VaCfViysquqX5pczi1e6osd6eLA7FPwImfkLtjA1+kBzq5OMoKVnFqUoQ5BuWIAkMB52aiYXi78vEiKNitrUjgRRhWEZ3d1ib2pDYoDrKsvLXjtK0YfuakDRgkjtU+UdbpAFVu+NEH4R2d6YASIdDxcxcaDk5hk1SWIifBzZb0Z+dDUOX6e0iM4IsQkaDZNXZT0b08BwEEnl4/1lZU6jRfYUNo+KscVydi4Fy1B1R3UxQSvoysXr5Yix4LwN1fx3B11rvb68/JxWX8
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(376002)(346002)(39860400002)(40470700004)(46966006)(36840700001)(336012)(426003)(47076005)(36756003)(2906002)(40460700003)(6666004)(8936002)(81166007)(70586007)(1076003)(186003)(7696005)(41300700001)(7416002)(36860700001)(5660300002)(107886003)(86362001)(40480700001)(478600001)(70206006)(966005)(4326008)(2616005)(8676002)(82310400005)(26005)(82740400003)(316002)(54906003)(110136005)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2022 08:39:27.5053
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e298eb69-0bec-4c99-5632-08da5f2b09a1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2509
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a long-standing issue with the Synopsys DWC Ethernet driver
for Tegra194 where random system crashes have been observed [0]. The
problem occurs when the split header feature is enabled in the stmmac
driver. In the bad case, a larger than expected buffer length is
received and causes the calculation of the total buffer length to
overflow. This results in a very large buffer length that causes the
kernel to crash. Why this larger buffer length is received is not clear,
however, the feedback from the NVIDIA design team is that the split
header feature is not supported for Tegra194. Therefore, disable split
header support for Tegra194 to prevent these random crashes from
occurring.

[0] https://lore.kernel.org/linux-tegra/b0b17697-f23e-8fa5-3757-604a86f3a095@nvidia.com/

Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
index bc91fd867dcd..358fc26f8d1f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
@@ -361,6 +361,7 @@ static int tegra_eqos_probe(struct platform_device *pdev,
 	data->fix_mac_speed = tegra_eqos_fix_speed;
 	data->init = tegra_eqos_init;
 	data->bsp_priv = eqos;
+	data->sph_disable = 1;
 
 	err = tegra_eqos_init(pdev, eqos);
 	if (err < 0)
-- 
2.25.1

