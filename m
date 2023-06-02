Return-Path: <netdev+bounces-7490-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 150B2720768
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 18:22:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3D962819F5
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 16:22:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A29441C766;
	Fri,  2 Jun 2023 16:21:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9195C1C750
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 16:21:47 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2071.outbound.protection.outlook.com [40.107.92.71])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EEDC10D0;
	Fri,  2 Jun 2023 09:21:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i3kuCtepuZVpg7VFj6GZQfDDnHeGjrbAWRiylnU+iUSPaF8WXfwG6lZFX1B3Cv0K2ZBWmf+cxoosi4VS22Zzy6NsJPlhxKy9UU+RSmWXk4AWNqFy5MqLPKFsFNHrsDU0eIRpUF+nCNXjg2DYGvGFTNXU1Rq+OOppNfAyPa738RKLGqorto4thCtPzeyqaW3G44egDJUrvySlfe8WjHiAvFqtQYQjOD+sq/GuHprClKc66ng0Te7A7tYO+OZUfdkybm+o8iypf63ZgY3MaVrCsqtcz7HSfmdryyskHyLC89hTypJwFamC/rO1YgZY/Pc1Gxndj03DzYIjIoi0wHFQMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TkKqnBsEPH2ize/t4V+AGOtYtNeaOvzVueuMDSRGbyA=;
 b=Jwk3oq+83iYjMsvbj1gNK2uK66CgtDtLpzNhEbxsSWJNgSL0gVwiIKVCYhknR6OlbNxHcrkV4aWwmjwe6vRryxjhf93WJzZPyPW3KgMs2ECg5wCpmfp2NgbNJpTcWTh1Wq+X31n4zdsQIqkHOjvqsIx2WShOmIg2W58TiZs/nFOAbHz1Al7jMK0+L6aSxNrAiYzYPYTFZQZO7Xq8FuAjRRxW2jUNTSJFKW6flOhVrcZwj0I/BYKnSOsS5AOgABtYiFy3Ofp2eY+Al1JwGWg1yCDSR8HNgSBNeL1U85NZB+15mYf/GvPVCf5yNbW+8I0GrtkN7SKfFq+m4SZ8Y9AQgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TkKqnBsEPH2ize/t4V+AGOtYtNeaOvzVueuMDSRGbyA=;
 b=M/QHmYaNtMOvQREVrzRSG4DVC1ODlkitDJNsszO8hVhue76yG44S2gSwY5RG0b1f5uD7RRRvGQUIrBjlWy3/aFSoN2b3mrsZXqF7aVsnsZpoCek10eHqrj9JvKOTBwmi1s9SHZXcwoWMM9FihudqEeQzSXCrjv+RW/GpfYacNOuND4Yd425naz7TWtGbhJn7JV3KUZSY7G8g8MumK45RtdBVYpn2LjTxRN36HZ0GjLdKlbo0isDGHiAPj1QZQ7rZgAZx+KytgVzcT28oNdWLTcD/OlXDwUqMGeubNg+ZiGrZxj8RSTCo/xOPUEI78LLNUMcU3yhFg5mRH7YWqk0E+g==
Received: from BN9PR03CA0575.namprd03.prod.outlook.com (2603:10b6:408:10d::10)
 by PH0PR12MB5401.namprd12.prod.outlook.com (2603:10b6:510:d4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.26; Fri, 2 Jun
 2023 16:20:48 +0000
Received: from BN8NAM11FT115.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10d:cafe::e6) by BN9PR03CA0575.outlook.office365.com
 (2603:10b6:408:10d::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.26 via Frontend
 Transport; Fri, 2 Jun 2023 16:20:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT115.mail.protection.outlook.com (10.13.177.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.28 via Frontend Transport; Fri, 2 Jun 2023 16:20:47 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 2 Jun 2023
 09:20:32 -0700
Received: from localhost.localdomain (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Fri, 2 Jun 2023
 09:20:30 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, "Amit
 Cohen" <amcohen@nvidia.com>, Danielle Ratson <danieller@nvidia.com>,
	<linux-kselftest@vger.kernel.org>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 2/8] mlxsw: spectrum_router: Use extack in mlxsw_sp~_rif_ipip_lb_configure()
Date: Fri, 2 Jun 2023 18:20:06 +0200
Message-ID: <0bb637131dd9de208a4bf4fa9f7eeaa4d10027f4.1685720841.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1685720841.git.petrm@nvidia.com>
References: <cover.1685720841.git.petrm@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT115:EE_|PH0PR12MB5401:EE_
X-MS-Office365-Filtering-Correlation-Id: 60698974-7b1a-4722-d396-08db638552c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	uLOJI8QRA6FVDjIgjQ8vusZZts5/DT1PusmZK4PkAnNBfNajTAI1YF1ShqkkceV2kOs9cTluBUiZrvQ/EFDm2ubRp9AuMUkeZ+mi2yAUGMdUKCmbwTwCpOl6FC4zW+0KaS57a4UQpVgG4DRUJIPVhzBe/+APiJ6uXPJtzuUfquFqK8aTanmkuG+VdSAhyTCsKK+BN4YyLgRv5t0MYIYSlB9n0XRLNDW/KAtPqphzA1dCtK/Tals8O0gAIvpuZA2EM7l10IAwf6GSbbAP2YMKuKiArfuHQ5HzahtMNTPGvqO/XbwXFNCKkTtzO3xvP0h7c6H8avcSVTVTpkHNjGcCuSrzqVB+6FEkhrKpMdz0/NH2N/gFHAOsoIerR16vSLdy4b02eTDV9722oKUexTcQQPMCm979AgA/ZEWA64Wml59R2qXEydRGIeEsPguTkPCI7tSxmFbes+9kaD107ErirjW/nmDh7NsSkaptv/MGXJ7q1LTZpSa58Z2oVpmp5sdyusORSRo5TDmNGJ8VjivD0r5Qu1bpaaQpnwiUQg0JpIRXe1PsF79tpUi5ibieDlJwkaV9I/iTXXTAAjkkQ5H/urTzkKIQw/9Z54Prk40N64V6tToNVAZ3oUW6wm//grqNXc1nXD54TWgCYYGSp7k7wrZu5/8nsj1O45cOvYXy05SVtAMteXchZoQjK/flo0kA3G9fjjvUaY4NbvMVgEoPlH6F2NOD4kB+VGAu86opE+hLvOyZfJKiyMny0TptALEtbY5ACPs8bH36KGH2L6kCdQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(346002)(376002)(136003)(451199021)(40470700004)(36840700001)(46966006)(110136005)(5660300002)(8936002)(8676002)(478600001)(41300700001)(86362001)(6666004)(316002)(4326008)(54906003)(66899021)(16526019)(186003)(107886003)(82310400005)(70206006)(70586007)(26005)(336012)(426003)(2616005)(2906002)(40460700003)(66574015)(47076005)(83380400001)(36860700001)(36756003)(40480700001)(356005)(7636003)(82740400003)(81973001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 16:20:47.1326
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60698974-7b1a-4722-d396-08db638552c2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT115.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5401
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In commit 26029225d992 ("mlxsw: spectrum_router: Propagate extack
further"), the mlxsw_sp_rif_ops.configure callback got a new argument,
extack. However the callbacks that deal with tunnel configuration,
mlxsw_sp1_rif_ipip_lb_configure() and mlxsw_sp2_rif_ipip_lb_configure(),
were never updated to pass the parameter further. Do that now.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index c905c8f153b4..20ece1b49175 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -9724,7 +9724,7 @@ mlxsw_sp1_rif_ipip_lb_configure(struct mlxsw_sp_rif *rif,
 	struct mlxsw_sp_vr *ul_vr;
 	int err;
 
-	ul_vr = mlxsw_sp_vr_get(mlxsw_sp, ul_tb_id, NULL);
+	ul_vr = mlxsw_sp_vr_get(mlxsw_sp, ul_tb_id, extack);
 	if (IS_ERR(ul_vr))
 		return PTR_ERR(ul_vr);
 
@@ -9923,7 +9923,7 @@ mlxsw_sp2_rif_ipip_lb_configure(struct mlxsw_sp_rif *rif,
 	struct mlxsw_sp_rif *ul_rif;
 	int err;
 
-	ul_rif = mlxsw_sp_ul_rif_get(mlxsw_sp, ul_tb_id, NULL);
+	ul_rif = mlxsw_sp_ul_rif_get(mlxsw_sp, ul_tb_id, extack);
 	if (IS_ERR(ul_rif))
 		return PTR_ERR(ul_rif);
 
-- 
2.40.1


