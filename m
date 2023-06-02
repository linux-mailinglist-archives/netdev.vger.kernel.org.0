Return-Path: <netdev+bounces-7489-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 679EC720765
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 18:22:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C353281A03
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 16:21:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BA9C1C777;
	Fri,  2 Jun 2023 16:21:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E541C750
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 16:21:40 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2048.outbound.protection.outlook.com [40.107.244.48])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE99E78;
	Fri,  2 Jun 2023 09:21:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kVTr9NPC7t9MwMIaOIwMwjtgZa+tIJwQA+bwOI1NN5KZU8dLLL+iz5AGdNX2ZmSFkfvy0N2PF2KhEmL6bJtNtbrShOfYGmhGQgzjES6/ExZdVYdXdKyEE3OuCPkcYtkuVXr25t5ywf3hTjgM9Ji99QgO2JazYsMJZivDltTJ+B7ey+/7ZF66a5LVmAmWQgAobg+juDEiPjxO4F/sVS8YH9nb1Raff5kOYymOaMddglKa8lJ22torKDJCpzFKDWH+DPT9f+YFToDCHssfUlvIuF0QZ0goecSsdIny4kazbdcSdk8g7SQgmbKENzFVol2vfScqlKjoqgtlwoakK5KLUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qJ18S7DffD5gESrA7mkuqoxH+lJkl+MeliZ8T/l4yDw=;
 b=QCs/fGFlNrRE5JRU0sf0kjPZSkft3//n6hHPlwKBF24ww+rpAyzu65IhhPjsq2o7na5r8I4HGjpnHugV8SL1mg51vEKWYwYndHXxaKCEVzVGKTdU83/9R2BsCCl90TJT2OSFPMiSZBoyPNUhhfGDyPXk22WfLKzuF9xtf/tGbvbSqSZhdphfws7qct/8xCc9SjpKDZfJoxA/iONIts0rZyNSXrsBK6LvfX7pXNOyFdsg5qToTP68msHS+tTMy+HtaYC9YpZVDGrwc0Ca38I+d1e2PnDOmShv3C1hu9z8SCoIjyhTzRItPn0YapWNtWCYtR3jkcDkgZmPJrMIISPJfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qJ18S7DffD5gESrA7mkuqoxH+lJkl+MeliZ8T/l4yDw=;
 b=t+9ztc979exHoYLhh7EHlZumKGxIsTGO6Jl+QEp0K7kYG+ttwx+PRnde3hjtF6yMFoyuIzKxg4sm+gMIMXstYqb4cFQSZ6MO37it1pLNbuPWH02rBIU5c1IvemARVuenJnzc3XMoRxDnIHP/VrsDfrPiXKCyJIx4YD1UIWITlHLjKRjxnTPCwuwWY1po7NaAfF0q5Hs00Kw2nysKIv58JGz4upelu0vkZP/tlwTfhDnfGhVeTscDr8R1IInMjWKYJCbgEh4YKHRdju0zJSwFZMJQuKaMlvVvMSk2g7Hc6NZh16N1gvPRTUyLBEBr/9e+waCmPcoYd3EheS7C2LEFRg==
Received: from SJ0PR13CA0154.namprd13.prod.outlook.com (2603:10b6:a03:2c7::9)
 by BL0PR12MB4963.namprd12.prod.outlook.com (2603:10b6:208:17d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.24; Fri, 2 Jun
 2023 16:20:44 +0000
Received: from DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:a03:2c7:cafe::e6) by SJ0PR13CA0154.outlook.office365.com
 (2603:10b6:a03:2c7::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.9 via Frontend
 Transport; Fri, 2 Jun 2023 16:20:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT013.mail.protection.outlook.com (10.13.173.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.26 via Frontend Transport; Fri, 2 Jun 2023 16:20:43 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 2 Jun 2023
 09:20:29 -0700
Received: from localhost.localdomain (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Fri, 2 Jun 2023
 09:20:27 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, "Amit
 Cohen" <amcohen@nvidia.com>, Danielle Ratson <danieller@nvidia.com>,
	<linux-kselftest@vger.kernel.org>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 1/8] mlxsw: spectrum_router: Clarify a comment
Date: Fri, 2 Jun 2023 18:20:05 +0200
Message-ID: <bda037b3355616e62410530afa7dd21a5a22c8af.1685720841.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT013:EE_|BL0PR12MB4963:EE_
X-MS-Office365-Filtering-Correlation-Id: 778300c8-4ed2-474e-6999-08db6385504b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	W0CMo9F2Gg8PDUmjRm8rjMYGpG1yT1NbCsYSenijqbJRszFo/n6XRMa1tH0yV0/0VGGSCJ3ePlLr3qhTpF7xa6zkkbOyUUTCX6Ij3+sZ3oaGNwtqZ8rTLaV7ILQkpY4ShgWzZ0GqLknIMpVU40XS8Td6yG/vYcosYMBJfbh+CwSM2x9QEIw9hBG7X8RfCuAVIbWVSdZNGDsOVcWcRZYJC0uwg+2h/tciamBrC/RoktpSqaoZMVV37KAxAQ6cO52G66yt/r9AkLEeRO/zRKG787uM4sBeTuXxZYXLyWwpC2waNhYvrR9odyTJuEMSmTo76HrDlP4VkHYC70qSSoqRRK4WQyVV7tm+8Pb0YwZGUkAnD8cMA/WbOztf1Z1TaIWoE3t7dKmFqrZFw1I+Afhep0/Z5VOXCDeMKhDMrR2CNzvfSGle4qe0vPW/qRlxb9ASs1B/v6FgWPzpNuuGCDbQaGXvMh6E8z38MUgWFoolRFcFCusZ2yJzffLasXRYXmqc+Vv9csHEjxne81xWTJpYL9UKAwEezC20+BXd5uYS7wcT6Nnet2KOF6sLjx4/DXqYOb9Fv/u6uS9bUBDIZPho9EZpcLrQQs76MNKfg8YKkjLOshdLg6TsL9GSXbedXpt+uLRLVruJ0piK0eMPZveg9AGPVv6ZvDonzoCeymsddBRSHamuvHfJ6ty544n6hQ16SrwRJE7U+fJXaLR7m2Wc/LN8PePRbD6WBna0lBil/ukZCAqGECrXLqjF/JWSSiHB
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(136003)(39860400002)(451199021)(46966006)(36840700001)(40470700004)(40460700003)(186003)(107886003)(16526019)(26005)(478600001)(6666004)(47076005)(36860700001)(66574015)(2616005)(316002)(336012)(83380400001)(41300700001)(426003)(8936002)(5660300002)(2906002)(8676002)(54906003)(70206006)(70586007)(110136005)(40480700001)(86362001)(4326008)(36756003)(82740400003)(7636003)(82310400005)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 16:20:43.0570
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 778300c8-4ed2-474e-6999-08db6385504b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4963
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

"Reserved for X" usually means that only X is supposed to use a given
object. Here, it is used in the sense that X should consider the object
"reserved", as in "restricted".

Replace the comment simply by "X", with the implication that that's where
the field is used.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 4a73e2fe95ef..c905c8f153b4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -96,8 +96,8 @@ struct mlxsw_sp_rif_subport {
 struct mlxsw_sp_rif_ipip_lb {
 	struct mlxsw_sp_rif common;
 	struct mlxsw_sp_rif_ipip_lb_config lb_config;
-	u16 ul_vr_id; /* Reserved for Spectrum-2. */
-	u16 ul_rif_id; /* Reserved for Spectrum. */
+	u16 ul_vr_id;	/* Spectrum-1. */
+	u16 ul_rif_id;	/* Spectrum-2+. */
 };
 
 struct mlxsw_sp_rif_params_ipip_lb {
-- 
2.40.1


