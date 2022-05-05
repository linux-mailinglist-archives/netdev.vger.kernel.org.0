Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5F7D51C511
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 18:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380845AbiEEQ05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 12:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234298AbiEEQ04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 12:26:56 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2067.outbound.protection.outlook.com [40.107.220.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC575BE4D
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 09:23:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CEtTov1+i3aoz/9QqDY4Mn5p5/Q+vHLHPOKvSAqmGJ+0NOic8zmmM0xgntARVgTXXN124oEzA/PJ5ADEun2YtNRXnuJLQw28KzNCTogTLc4awZEKHi1GLCJzFDraznkbqnOZ1hvPfwygYGLCBYm4iZiBZEx4KM7WgP8oBHbwSx8GWoKDCHgRNM2OMW9g8tjD9fdjwz3x+/xA6tBOMt2QECdyCFWJadbyulgG2UVCLlgzDy3fjZF7tcKDumGc5uL40XS5rGrPvEYEPjdmpeGCNAmc+24t10pLajkZFuPO462hfqP+JCXo0aU9BGMbhzxa2EOWUOvOG3ekgPC7wuyYNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qLRc4lgraVUPMUYS+6cjVyJ0slsumxx3OTDOIHJPOsw=;
 b=UGT5b77ORFzqkPlb+wjHe0z/0yfdAjreBTS/g3ngv+zhjAxmFJ7mPExBmF5GtIyQTagL0mlKSGylvoBBF3IBG7wlIon1gwG7MYuNWde7Lj42aTmBLwlaCviSzyG8WXdoOi4zLTZ8Bb7QDb+YL4a6RhQ4u4J43DvXetoG+eE79At/r8eQCrQrJghnMU2Lnzbk6yvzzFlt+OSUxQEQINmI6l9krdM6nrdVa7egzxLODoS6n/D22KGwsuHP+9Zq0YrR+aB4HFDmtTl6KDE22068ZuqN0Upx2cgbKFwd/Mb730aZuk+YtRVseiKvhQvFghkXXfGXLaTLRbiRyfpvUVNLkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qLRc4lgraVUPMUYS+6cjVyJ0slsumxx3OTDOIHJPOsw=;
 b=DixLpfBkTStZzGfd11kvdSQ45PEYgs3/m/0uEMkez4QdHfDx6hF1mwF6M8S+TFAXeLt4NP34GWq9VIlM3HIM9iot2ktdpA1b/vlE4B/TM2xAvhG9bnHL1y2F7fJRjPfHxiT5NZ0Po81KVtd8cu94kgv+NmpnPQYtUl3U2AwNsm6b3E0wTtIaRnGQk979fNzX8o8VmejGlRW5B5npnVkLaeorAmOGrWusICHQMnlz8xz52Es03KDvMZDzljI0tKUTbnjLiu/8QSn96jDnAE04hQN7W0kbl1eqYY2FAdw6hG7mfFvN5s8Gqm/tKx9mtCI5QrLuC58jEdjz07TmjTFJTw==
Received: from MW4PR04CA0344.namprd04.prod.outlook.com (2603:10b6:303:8a::19)
 by CH2PR12MB5516.namprd12.prod.outlook.com (2603:10b6:610:6b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Thu, 5 May
 2022 16:23:15 +0000
Received: from CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8a:cafe::aa) by MW4PR04CA0344.outlook.office365.com
 (2603:10b6:303:8a::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.14 via Frontend
 Transport; Thu, 5 May 2022 16:23:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT018.mail.protection.outlook.com (10.13.175.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Thu, 5 May 2022 16:23:14 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 5 May
 2022 16:23:13 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 5 May 2022
 09:23:13 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Thu, 5 May
 2022 09:23:12 -0700
From:   David Thompson <davthompson@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, David Thompson <davthompson@nvidia.com>,
        "Asmaa Mnebhi" <asmaa@nvidia.com>
Subject: [PATCH net-next v1] mlxbf_gige: increase MDIO polling rate to 5us
Date:   Thu, 5 May 2022 12:23:09 -0400
Message-ID: <20220505162309.20050-1-davthompson@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf5d4a3b-7768-4656-c592-08da2eb38e27
X-MS-TrafficTypeDiagnostic: CH2PR12MB5516:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB5516D4F2F902F2878B556308C7C29@CH2PR12MB5516.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dwFogij1GbuIHNm185Ak1NHJY2baPnSkeGKUhxRTffWAh3W7+R/aksTSEu2lSgABc4+p4sWIBrxCxvGURsJ8X4Kl8wsId6RP+Pjtytnb6zN2U3OCqsfVuBiGrorSSzQETwhOx9gYFxNs8qRhStPXF7z/Jg3QVM0rrNfDI2GGRkrZC2t1KRUG6PWixRTFRGTjsQo0eN+X/JGcUvF01fHg+zP+r7ARAkipLsRob2KGWsdsphMfHlI/HueQTJNiNzFzfBAEmzpVVwzB9x7agiFJZn0qQlWm6pTJ4niuT1nqf4b2tUkHz8OhY1xrsEKoPQZ7XO/ImUVRo8NkecuQE4EqMC3KijEv/vIFx+jo9O7GDQ4shmAeNG/dwKaaajd06M3k2DeCR/Vt4SldIJYa+Itl+ALkBPuMG/JJ2c/haE0kB2IkTsnzN1TI1fJb7HVvUykUDVQkAK/WSNkYjXE/cWB596RYCzu+mwMe6CgVn1A3DO+0jrw+Dll158dk/dazgmxVKNErBHgfPt3AalLI6g9N/dC4iWW8Gxb1hSEmJLKTwtGo+Z8XLFxJ9kgjtV7dQT1SFl3TM7bcjw7kOlJ1D6PtyycIdZTt190rBAQ8sgfV28UlT60oK4T28IOBKX2vaIYxsuXnYVmecy8HYyzLWMwX/Pkg7N1m0RuyzHW6KBlZ49uetQow3G1QIvTa1XezeuY5MZrWZe3+S0ZvqxKP+BkKng==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(508600001)(2906002)(83380400001)(70586007)(8676002)(70206006)(186003)(356005)(336012)(4326008)(5660300002)(426003)(47076005)(1076003)(36860700001)(7696005)(82310400005)(81166007)(36756003)(316002)(107886003)(2616005)(86362001)(8936002)(26005)(6666004)(110136005)(40460700003)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 16:23:14.4247
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf5d4a3b-7768-4656-c592-08da2eb38e27
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5516
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch increases the polling rate used by the
mlxbf_gige driver on the MDIO bus.  The previous
polling rate was every 100us, and the new rate is
every 5us.  With this change the amount of time
spent waiting for the MDIO BUSY signal to de-assert
drops from ~100us to ~27us for each operation.

Signed-off-by: David Thompson <davthompson@nvidia.com>
Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
index 7905179a9575..2e6c1b7af096 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
@@ -105,7 +105,8 @@ static int mlxbf_gige_mdio_read(struct mii_bus *bus, int phy_add, int phy_reg)
 	writel(cmd, priv->mdio_io + MLXBF_GIGE_MDIO_GW_OFFSET);
 
 	ret = readl_poll_timeout_atomic(priv->mdio_io + MLXBF_GIGE_MDIO_GW_OFFSET,
-					val, !(val & MLXBF_GIGE_MDIO_GW_BUSY_MASK), 100, 1000000);
+					val, !(val & MLXBF_GIGE_MDIO_GW_BUSY_MASK),
+					5, 1000000);
 
 	if (ret) {
 		writel(0, priv->mdio_io + MLXBF_GIGE_MDIO_GW_OFFSET);
@@ -137,7 +138,8 @@ static int mlxbf_gige_mdio_write(struct mii_bus *bus, int phy_add,
 
 	/* If the poll timed out, drop the request */
 	ret = readl_poll_timeout_atomic(priv->mdio_io + MLXBF_GIGE_MDIO_GW_OFFSET,
-					temp, !(temp & MLXBF_GIGE_MDIO_GW_BUSY_MASK), 100, 1000000);
+					temp, !(temp & MLXBF_GIGE_MDIO_GW_BUSY_MASK),
+					5, 1000000);
 
 	return ret;
 }
-- 
2.30.1

