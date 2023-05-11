Return-Path: <netdev+bounces-1709-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 625CD6FEF09
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 11:44:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 191342815D8
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 09:44:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B34F1C74E;
	Thu, 11 May 2023 09:44:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDE11C740
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 09:44:54 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA715BB4
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 02:44:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L3p79fV2r/hGFojp5dgExmpfcAZJdn0aeK5z+Jirm8cJm0/sg0jQHRUJi34qqMtn7c4p7dh8X+Oi165Fr+xGkpEeh96NfZjuuLmQJuLJGRCz0dGCZbFi7RvVzt565ATX7ZRvtwIh9msBYnsQCwNIR7Cc5x5yFAHNX37Sq3qTQw9sAfrqHA2KpjCe4G9WgwwDdyESHEsixO9SpJfWAF3uEb2+n3NxNlOXH+Xvy0pnzHyu8MQuR6Dw/JghYRr9qVS00fiLZUcpgH4K5z18cXA4wwOBBsUJLpI6XgR3AoacbSoWzIDA7IayUTLLV2MZ7K1GNjCocx5yTjpxaDSRnsp2iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HYKCsPH/Q8FWsZkM6//98thihSX31hyOanNBxHjXqZo=;
 b=WuLm2lwo0BHDAN9tsRzslD/nYa91qNV4loXxzvGZXcTUyZnEdBi0usZuvVAYobPNijy5KVXGLOZz/nh3Q4ApNPgZ4FFPAAarOOI+YI/MBdQJM4nGvhYMmiImeVYFezHut1vZUqu5h9Xwma+rPy0KZN/oMXlqj0f5pLs62DpcYjYHgFY64zvOmCa0l9ytDtVYX3uCf+G6HLzD6aKrz6B5j9hmzfRdmO4qo9ln4Sf6E9PfWPWai8nA+5Mu61u24QfOqfQ99U4Gh7zk3RVpxHgrFxraVQZjEWerwEO1wnAl9t1sdQKS33sjVDyT3/JV4lI0Ldr4u57OGRKq9WT9TBCYNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HYKCsPH/Q8FWsZkM6//98thihSX31hyOanNBxHjXqZo=;
 b=JDLMzxiJGckF7HyxlN35/enOfkc4jkGEQp3HgbdNK5fcB6gb24GyOsG/N5nEWfvQva0WRlnyZVwPNkxS5aS8EOOkQHbh3yZXMxJiN8EK8xun4f78EdLDcKzmIH966P1Hkad3nkjojHEQkW8z9bEhSpEpLqPoWQk28LhkYAXbYso=
Received: from BN0PR03CA0022.namprd03.prod.outlook.com (2603:10b6:408:e6::27)
 by SA1PR12MB8987.namprd12.prod.outlook.com (2603:10b6:806:386::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Thu, 11 May
 2023 09:44:44 +0000
Received: from BN8NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e6:cafe::ea) by BN0PR03CA0022.outlook.office365.com
 (2603:10b6:408:e6::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.22 via Frontend
 Transport; Thu, 11 May 2023 09:44:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT053.mail.protection.outlook.com (10.13.177.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6387.22 via Frontend Transport; Thu, 11 May 2023 09:44:44 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 11 May
 2023 04:44:44 -0500
Received: from xcbpieterj41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Thu, 11 May 2023 04:44:43 -0500
From: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
To: <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <ecree.xilinx@gmail.com>, <habetsm.xilinx@gmail.com>,
	Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Subject: [PATCH net] sfc: disable RXFCS and RXALL features by default
Date: Thu, 11 May 2023 10:43:33 +0100
Message-ID: <20230511094333.38645-1-pieter.jansen-van-vuuren@amd.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT053:EE_|SA1PR12MB8987:EE_
X-MS-Office365-Filtering-Correlation-Id: fbad3218-8b8f-4493-bcfe-08db52045a0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zv1OHdKIdhHFg/igu2Os5owa20jA/7QiOhYmiYO4xT1d13AKpts3JO4pqf01sduf+R/pnJ6/3Ieg9KtRVST7s/79kRXyrQrAqOFkDfQIWUzjI9PXhmWD6wLouvO1NAgNaCgu4uCMut+KlsBBE3+NkBZAc/XNE9AU9HZUE+iTGOgDJznlOhgMckMlRsvlP5cQPEZbr7380CKGdbip4WkQw0El7cw2wyoRt9eP31ZIHOBAyB43HjDhIbvJPKlVbs1VZTdmQlA4C2/8UVjNwr6WXbNSuaILADzsw8eN1Pri0zE999VBZVT/g3zU3XonPKdGLcAdNuYUgGz8jvYMdbqxCZfSpWtSDg4Zr/8FwnUbLYFQWigUAd/SZJ6B3Xr14iNzMnkCBngGjXcFy7h/0SYJQBKwTcpXgZCZ3nznFxt4Q5ZXfhge12H1/sYtlJn1d92EAChSxg8Lcgkvj8FYzBfd+H8+l8kY4B6Cc7DNFqaCHbH9Y0+ycA4IAluKQ8Tv5Uzrr3efi+kbY/IYCcZly46HV80WSJ05UGeSr+MoDlc4qZD1FdVw2fIkyvZyXIHmMy+V8mqeJSVLD+D71cHIUioZJ8xPZMLEjZvTd+xiN1G0Iv80Ox8EBV7Hc7Fp+GTr5nmnbR+geKKJyVw8m39HKcbINRiwopjXGQf+kWLTDZPzRpyxyqww4IKeJMGDETJwmzfLvFnKFdqc78BR9LgGXq3QeNeCBGN+2oC7oJDMoic37DiOxDCm3X016BHMcoPd0k/J6UnITLigLV9aJbbw3JGBFQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39860400002)(376002)(396003)(451199021)(36840700001)(40470700004)(46966006)(4326008)(54906003)(110136005)(316002)(6636002)(81166007)(83380400001)(82740400003)(5660300002)(36756003)(70206006)(2906002)(70586007)(47076005)(41300700001)(86362001)(356005)(6666004)(36860700001)(336012)(426003)(26005)(1076003)(40460700003)(82310400005)(2616005)(8676002)(8936002)(186003)(40480700001)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 09:44:44.6916
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fbad3218-8b8f-4493-bcfe-08db52045a0f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8987
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

By default we would not want RXFCS and RXALL features enabled as they are
mainly intended for debugging purposes. This does not stop users from
enabling them later on as needed.

Fixes: 8e57daf70671 ("sfc_ef100: RX path for EF100")
Signed-off-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Co-developed-by: Edward Cree <ecree.xilinx@gmail.com>
Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
Reviewed-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_netdev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index d916877b5a9a..be395cd8770b 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -378,7 +378,9 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
 	efx->net_dev = net_dev;
 	SET_NETDEV_DEV(net_dev, &efx->pci_dev->dev);
 
-	net_dev->features |= efx->type->offload_features;
+	/* enable all supported features except rx-fcs and rx-all */
+	net_dev->features |= efx->type->offload_features &
+			     ~(NETIF_F_RXFCS | NETIF_F_RXALL);
 	net_dev->hw_features |= efx->type->offload_features;
 	net_dev->hw_enc_features |= efx->type->offload_features;
 	net_dev->vlan_features |= NETIF_F_HW_CSUM | NETIF_F_SG |
-- 
2.17.1


