Return-Path: <netdev+bounces-10172-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DE3E72CA3E
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 17:34:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD42928115C
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 15:34:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67DA821CCA;
	Mon, 12 Jun 2023 15:32:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C061DDC6
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 15:32:05 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2074.outbound.protection.outlook.com [40.107.243.74])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535D019B
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:32:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=joXqk5QlL1WCBL9+RnSjYivC4ff3UM4QlA5cY509TdWpyhfu3hydpjiB16CKbkCWHA5IcsHlQ6uRUZX7Jgtw3dg8j2qmC5UCg2kZD8hnML/Fll8SxFJznAu84IkmiEgVB2GeKBmJK2BmCDcQJ++bq3lapKmmIK5ziX/IWGBYiSWZY3P12Z6+7/9jr2zBLGvEZygwBuvC7a2Aws9CTins8Mo1uR2kfjresy7TXOx2faw2oRDia5odfFe5hV1Zi36C3OerPmOOqMl13S2tDbDYExar8aEY3Hw0grCNyjZ1k+7tjtDzVKEjDBpm3+nKpudvQZoFckq18B0b+BZ/HXyMzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mNG0HY43wUlUvKtXjrAAfAqooJ5uQbW5Xa68Y+zsvt8=;
 b=hLEIDWXBgJhHIumFG003rAZqiHSIOSS5r1XuX2VxV97P3L3vywtkaZxeATM2KwSNFaLxvFuj3t0747wjxob0Omrkt6uUNrG7+700VRcU4alKZOs7hxQgJ3uyEryrx5wRpChjSauvE8GM87GnEVUDYyUR4L2u0FMeptbZobtquwaHh9R5rN8cSzSYvos3j/d3NzynbE8/nEk+SO+k9riryxl71Y9i+hmzmK/m0Uyuih6c4FlM3IZ8Rd7CvrafT3kLCOgHx3P3b/vRKVkZ45ygIA2UV08ka3/Z9TrkJ1EliEH1eavEpybKyXTECpMwqN24imndkTSHD0jTseo9jdOQ7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mNG0HY43wUlUvKtXjrAAfAqooJ5uQbW5Xa68Y+zsvt8=;
 b=I+ggUKwYYdnLY7EuN3YbZr5P/sqXsneGCAzQ8qHAdd8xegzbXTZ9Ftvq5q9K5xpReq/y+wXuPeXXjKShdiN9v913vR7yihL2PTCFiRryByRgDr6vEbZ6i/dP3N6T4m21kaJm5+fBJ0hqCL2R4rIhgnMAlYZU3dpJW4oZEW93H/L0jS62S6hNSk/NmXDvOk6tD6W0kh3D0BbwoPzzNiWDeKcdPFP2Rz+D7NqWFw60N51A0pKTzQNHs6FaGThpXshbziEFV/UlaUt8pZ1nrbTpUNWEB7fS2Fy1lI8SwYnRXTxYCwUVVOwvKt5WbEKxix4VAWq2Bc4U4aEZkHcgeU1LwQ==
Received: from BN9PR03CA0365.namprd03.prod.outlook.com (2603:10b6:408:f7::10)
 by MW6PR12MB9000.namprd12.prod.outlook.com (2603:10b6:303:24b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.46; Mon, 12 Jun
 2023 15:32:01 +0000
Received: from BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f7:cafe::16) by BN9PR03CA0365.outlook.office365.com
 (2603:10b6:408:f7::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.33 via Frontend
 Transport; Mon, 12 Jun 2023 15:32:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT045.mail.protection.outlook.com (10.13.177.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.21 via Frontend Transport; Mon, 12 Jun 2023 15:32:00 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 12 Jun 2023
 08:31:41 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Mon, 12 Jun 2023 08:31:38 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, "Amit
 Cohen" <amcohen@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 07/10] mlxsw: spectrum_router: Extract a helper to free a RIF
Date: Mon, 12 Jun 2023 17:31:06 +0200
Message-ID: <a6694562a0a4e6dc76ec553763b5e82691de127d.1686581444.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1686581444.git.petrm@nvidia.com>
References: <cover.1686581444.git.petrm@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT045:EE_|MW6PR12MB9000:EE_
X-MS-Office365-Filtering-Correlation-Id: f15e1d34-1c8b-44a0-5624-08db6b5a2a62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	QQANvJIOHbKhr1x7aSRtbXViLoF/14knSeIic8Of8nL/+p/4lPBZjaE7q9p+Iu/nK5vRxLGutC+M1ZevnZWVQYn3BOGKd/kmhg1TtKOnD47ivK1LghXrvptgirg/L6lq8MIDImOP9AsuzjmocI1SMY1WAV76Z97rFbDZiznNjHcbU4QYJSQG4y3t1csb/jXOXTMPE1CHVltRdozIW1LDmwgJmySqYXhFby3KaEeIdJBk7UWefog1oEhuGroGTrwUg2yups/yDtMtMk+P5ceL5vuLlHx1G+MIgXHDyfK1kAitXgPWUz0R7h3t6JRb3WKbybEDfOqmZyID29ZPFmiVe9iBvkkv1X5sgnUUh0eNhpTLPeimbBnKcyroWG9GRqhsxD04th1OnpUzz+RABdV+ebk0cza9UmWvqlnebstjd22WUsHg62QGdFvcN9EKO3jO6lYn2qCtAhXGESuLIYqXgebgt1w1v1e+zRMVxN9QALoR68+Ks+fIlafTxTMjW+pYx2+IwZm0Ieos2QhjekJQw41LlGpuodIrH4WV8wIPbUPeHz0AwFQXdN7Hpdu8eKA6x5bfSwWo9RBsRG+4OOebEulZnJE0WUUEnWBj/8Ew149MhCZ8ybFnMii7wVp5IgVrRaLUWj2zX+G3D9IBrM4UJmeUf60VA6kOJ913CYJIhaftYYTiOuFWODKiYVW/kr1jk47Jfw+4mHYCltbChd7QbYyay87Q5tbEeU9+xIaoLMwtMsb82u1jyFrajAWGFIzg
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39860400002)(396003)(376002)(451199021)(36840700001)(40470700004)(46966006)(40460700003)(6666004)(7696005)(478600001)(36860700001)(47076005)(66574015)(16526019)(26005)(107886003)(426003)(336012)(83380400001)(186003)(36756003)(2616005)(82310400005)(86362001)(82740400003)(356005)(7636003)(40480700001)(4326008)(70586007)(70206006)(316002)(8936002)(8676002)(5660300002)(41300700001)(2906002)(110136005)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 15:32:00.3342
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f15e1d34-1c8b-44a0-5624-08db6b5a2a62
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB9000
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Right now freeing the object that mlxsw uses to keep track of a RIF is as
simple as calling a kfree. But later on as CRIF abstraction is brought in,
it will involve severing the link between CRIF and its RIF as well. Better
to have the logic encapsulated in a helper.

Since a helper is being introduced, make it a full-fledged destructor and
have it validate that the objects tracked at the RIF have been released.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index e05c47568ece..1e05ecd29c8d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -7903,6 +7903,13 @@ static struct mlxsw_sp_rif *mlxsw_sp_rif_alloc(size_t rif_size, u16 rif_index,
 	return rif;
 }
 
+static void mlxsw_sp_rif_free(struct mlxsw_sp_rif *rif)
+{
+	WARN_ON(!list_empty(&rif->neigh_list));
+	WARN_ON(!list_empty(&rif->nexthop_list));
+	kfree(rif);
+}
+
 struct mlxsw_sp_rif *mlxsw_sp_rif_by_index(const struct mlxsw_sp *mlxsw_sp,
 					   u16 rif_index)
 {
@@ -8209,7 +8216,7 @@ mlxsw_sp_rif_create(struct mlxsw_sp *mlxsw_sp,
 err_fid_get:
 	mlxsw_sp->router->rifs[rif_index] = NULL;
 	dev_put(params->dev);
-	kfree(rif);
+	mlxsw_sp_rif_free(rif);
 err_rif_alloc:
 	mlxsw_sp_rif_index_free(mlxsw_sp, rif_index, rif_entries);
 err_rif_index_alloc:
@@ -8249,7 +8256,7 @@ static void mlxsw_sp_rif_destroy(struct mlxsw_sp_rif *rif)
 		mlxsw_sp_fid_put(fid);
 	mlxsw_sp->router->rifs[rif->rif_index] = NULL;
 	dev_put(dev);
-	kfree(rif);
+	mlxsw_sp_rif_free(rif);
 	mlxsw_sp_rif_index_free(mlxsw_sp, rif_index, rif_entries);
 	vr->rif_count--;
 	mlxsw_sp_vr_put(mlxsw_sp, vr);
@@ -9902,7 +9909,7 @@ mlxsw_sp_ul_rif_create(struct mlxsw_sp *mlxsw_sp, struct mlxsw_sp_vr *vr,
 
 ul_rif_op_err:
 	mlxsw_sp->router->rifs[rif_index] = NULL;
-	kfree(ul_rif);
+	mlxsw_sp_rif_free(ul_rif);
 err_rif_alloc:
 	mlxsw_sp_rif_index_free(mlxsw_sp, rif_index, rif_entries);
 	return ERR_PTR(err);
@@ -9917,7 +9924,7 @@ static void mlxsw_sp_ul_rif_destroy(struct mlxsw_sp_rif *ul_rif)
 	atomic_sub(rif_entries, &mlxsw_sp->router->rifs_count);
 	mlxsw_sp_rif_ipip_lb_ul_rif_op(ul_rif, false);
 	mlxsw_sp->router->rifs[ul_rif->rif_index] = NULL;
-	kfree(ul_rif);
+	mlxsw_sp_rif_free(ul_rif);
 	mlxsw_sp_rif_index_free(mlxsw_sp, rif_index, rif_entries);
 }
 
-- 
2.40.1


