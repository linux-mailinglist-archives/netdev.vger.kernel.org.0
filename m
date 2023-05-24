Return-Path: <netdev+bounces-4923-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5990170F311
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 11:37:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2087B1C202F2
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 09:37:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 605AAC8CB;
	Wed, 24 May 2023 09:37:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAFEC8CA
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 09:37:28 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2044.outbound.protection.outlook.com [40.107.237.44])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF94E5F
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 02:37:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fLPz6buhNkr2E1S3Faw/rFPzi8J6vBeKQoxrnaHSu0oCEX9aA0JYK4KfrXnKgEr7UM3IDSI6pidIL+pDyLp+eg5jt8QIkJRb8maJsFVnvKcA4j6MB1AyHgos6SzLxbpZhjts23ATrVQDSt83KOYhlIiS3AkZ1f1rJ/0YjeHGCuq3v+4j21zNZkRG3tdrtCL7RcC9Qa/OIYRJCWO6zqxHoOZVM6Bi/AJoT7QUTtF5Dm6S9XQP8un7nB6F1hc7xocdwxrb7dvQJ0w+GuVE3BF17Cw8ovh4RhiqmbbY/AFaT49Wi6sDMeOSgFb3Is7d2eY237atBO35dbKeUF/cdJiCYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vAF5GMl7wXwcILyicdtCrN3BrjkaLAKQHY8AYG4Ns6Y=;
 b=LgvivqeKzMCfSX5MQDNOGxsa5vOp7+KzuhSPCOqoP7VFOOg8x/tVqFuOrb80r3LZkJSYHxOMYp/BGI3hYV5+Lhk7GuOAGNZ9MWnrMolczkWFxoEVWtwVtlYHl7FgqFixCgc2Xo9gAw2c/1dAsMZAJLRRxCzWZTLt5Vz4ZTIUYJc4NV4Y+1grt6FpcDGge01pTOAiw4p8uoUh2O1fPLBzLK9+NmDArHXJyIK501K+u1dOieq8ygYvDqlAXRFyPp5vAJdZ18p7/IqbAjFJv0/TqPiNVqrG6pAT3z2Zu7e5SnHBfY6/4bgXC3c0LZ4NQeND9UtUZXCNz1vozZ/dNFh8uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vAF5GMl7wXwcILyicdtCrN3BrjkaLAKQHY8AYG4Ns6Y=;
 b=xCWz7Adn/VGxq+Kb0bbYq16pUQqekKZJcdUnCMJncG67czAQ3eI3NtrHSQN5tCnfDGX6etkaOsOUsIgPQ9YwJO8wNDBETrmYkRjkDAYT4LczuxILXdsvYIdmV/gvTDnXVe9JbIeM0LErFK+NUJwTT1IVjIw7dRb6hK5pnmktA54=
Received: from DS7PR06CA0009.namprd06.prod.outlook.com (2603:10b6:8:2a::28) by
 BL1PR12MB5804.namprd12.prod.outlook.com (2603:10b6:208:394::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.29; Wed, 24 May 2023 09:37:18 +0000
Received: from DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2a:cafe::69) by DS7PR06CA0009.outlook.office365.com
 (2603:10b6:8:2a::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15 via Frontend
 Transport; Wed, 24 May 2023 09:37:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT042.mail.protection.outlook.com (10.13.173.165) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6411.30 via Frontend Transport; Wed, 24 May 2023 09:37:18 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 24 May
 2023 04:37:13 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 24 May
 2023 02:37:03 -0700
Received: from xcbpieterj41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Wed, 24 May 2023 04:37:02 -0500
From: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
To: <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <ecree.xilinx@gmail.com>, <habetsm.xilinx@gmail.com>,
	Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Subject: [PATCH net-next] sfc: handle VI shortage on ef100 by readjusting the channels
Date: Wed, 24 May 2023 10:36:38 +0100
Message-ID: <20230524093638.8676-1-pieter.jansen-van-vuuren@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT042:EE_|BL1PR12MB5804:EE_
X-MS-Office365-Filtering-Correlation-Id: 847c9105-a660-40c6-34d5-08db5c3a778a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	cT/XrJpGJfvD6qRRl/uNExMR7iC2fbVzlLPbFklwzFrxPZLgbdZp+ykdU5yTWGy5SSOJHgyXw+aXqHKYDgwbSYqEjFupVkpRcq5QDqfP3jkCz5lS+HkBxJI9Cz8qwH0+zH9pG4rKY8LvWyUlioV7Zm8Wfw2+y08jxlDywEHgqQLisHdQV1cGqu8fuJf4um0uIrl0soH9VDcTGNlFwxWTm2G2ipgDi8zdCIGQOoLDzdKTh+pGHd61RqfsVWSr81eAS8fVQMkiLEh5mpLmJ3kswSzogrfw1yPKl3nfCXCsi0g0743SeRcaWE/e/T2/6VavmY8U9rcoaVFi48bxxZcu2sKHNoh/fB28Z461Moz9bYKvQM9c9s1tUKXhyMjU5kUln9XMq5C+LREHEklXP7cMWnX+GDw6eH3z9edEIzIJGUd/DCd/5ktkE3PqTPWq2KpNo+VOq5T8zmshQaG4xMpkqHUYW2LUJMD8+Vmi9Rc/diPR7w7xkJDWfek2JiEyXoMxA2wYs/AN2G2YsaeoI+VGVJgYaPUlb1iQPVDwBbxFxHb3b4oGOfEkUktvNclnPFsZgQYTvo/XkG18qN//Eb0lIn7rMdAV+CeJc0IJF8Y2UShyR23go8qvqs1iZ59KC8oj1lL+9V1NLUu7U02EXHiS2JoBrji4/CCQbqrDrw0WYaFFvwH80EopC4LxxrQJLAcwlR2ZweEm6FT3VKuL81uOGchjZnjIfN0TD9N0FXHaUHh2WxD1xwJ24Q33MBzkv1hI+A5SJc37+9/atK8/w0kVKQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(136003)(39860400002)(376002)(451199021)(36840700001)(40470700004)(46966006)(186003)(81166007)(356005)(82740400003)(40460700003)(26005)(1076003)(2616005)(36860700001)(47076005)(36756003)(336012)(83380400001)(2906002)(40480700001)(316002)(6666004)(70206006)(4326008)(6636002)(70586007)(41300700001)(426003)(54906003)(82310400005)(110136005)(86362001)(478600001)(8676002)(8936002)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 09:37:18.5524
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 847c9105-a660-40c6-34d5-08db5c3a778a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5804
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When fewer VIs are allocated than what is allowed we can readjust
the channels by calling efx_mcdi_alloc_vis() again.

Signed-off-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Reviewed-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_netdev.c | 51 ++++++++++++++++++++++---
 1 file changed, 45 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index d916877b5a9a..c201e001f3b8 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -40,19 +40,26 @@ static int ef100_alloc_vis(struct efx_nic *efx, unsigned int *allocated_vis)
 	unsigned int tx_vis = efx->n_tx_channels + efx->n_extra_tx_channels;
 	unsigned int rx_vis = efx->n_rx_channels;
 	unsigned int min_vis, max_vis;
+	int rc;
 
 	EFX_WARN_ON_PARANOID(efx->tx_queues_per_channel != 1);
 
 	tx_vis += efx->n_xdp_channels * efx->xdp_tx_per_channel;
 
 	max_vis = max(rx_vis, tx_vis);
-	/* Currently don't handle resource starvation and only accept
-	 * our maximum needs and no less.
+	/* We require at least a single complete TX channel worth of queues. */
+	min_vis = efx->tx_queues_per_channel;
+
+	rc = efx_mcdi_alloc_vis(efx, min_vis, max_vis,
+				NULL, allocated_vis);
+
+	/* We retry allocating VIs by reallocating channels when we have not
+	 * been able to allocate the maximum VIs.
 	 */
-	min_vis = max_vis;
+	if (!rc && *allocated_vis < max_vis)
+		rc = -EAGAIN;
 
-	return efx_mcdi_alloc_vis(efx, min_vis, max_vis,
-				  NULL, allocated_vis);
+	return rc;
 }
 
 static int ef100_remap_bar(struct efx_nic *efx, int max_vis)
@@ -133,9 +140,41 @@ static int ef100_net_open(struct net_device *net_dev)
 		goto fail;
 
 	rc = ef100_alloc_vis(efx, &allocated_vis);
-	if (rc)
+	if (rc && rc != -EAGAIN)
 		goto fail;
 
+	/* Try one more time but with the maximum number of channels
+	 * equal to the allocated VIs, which would more likely succeed.
+	 */
+	if (rc == -EAGAIN) {
+		rc = efx_mcdi_free_vis(efx);
+		if (rc)
+			goto fail;
+
+		efx_remove_interrupts(efx);
+		efx->max_channels = allocated_vis;
+
+		rc = efx_probe_interrupts(efx);
+		if (rc)
+			goto fail;
+
+		rc = efx_set_channels(efx);
+		if (rc)
+			goto fail;
+
+		rc = ef100_alloc_vis(efx, &allocated_vis);
+		if (rc && rc != -EAGAIN)
+			goto fail;
+
+		/* It should be very unlikely that we failed here again, but in
+		 * such a case we return ENOSPC.
+		 */
+		if (rc == -EAGAIN) {
+			rc = -ENOSPC;
+			goto fail;
+		}
+	}
+
 	rc = efx_probe_channels(efx);
 	if (rc)
 		return rc;
-- 
2.25.1


