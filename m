Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0FA5A6334
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 14:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbiH3MWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 08:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbiH3MV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 08:21:57 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20625.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::625])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76CA5153D31
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 05:21:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oVLhIuogyJ8Vn708GQUeJlOlLEzfRb7qsrUcVXdQFzwfhd2MJupn6dFNk/TwSndg1Sc//PGw0Ir0DM9T6ibiwxQfMvogkp+OcjdWfoHWrmiDU+FacyM9r46b3aXoPegLHrWS0IMq7Bhw9UDbkxlrpKiz2zXB/1WJtmf5KArg3phWDbrUOj50cmdxbiM+b9Ig0YIod0F2u9AcRC0GoxM0gjNn9saFe92yqwBMhvxVwWT1RmrGkhbO5r0g5Z/X7K+5o5sh1JEzeqhMm53pOsSgx0RDZfD6JJGVvi/Ui0SkAmBbr0Wad4lD3Yz/0WiBr+XDdK8iR1Ojrw3bM0/XmOrhkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ir5ujj1PO6bhcLwNC5iN6TitOIDW0qR9A4uUg7nENqM=;
 b=HFWckPZQYZyCpplA2DvcnXlo7vT1Lj6rzwy1dnn7ucsSgvJ3pB1ARU4/WfhxPGnMfRno8ZDOhZUmZVin0k9MxlWeQrwygLWv7a0l3fQamstzPpQegxoxSgCrlVOZEpduxJAI7PP/YSkNHYyv0AzANxlGNQtV0uNt4s+gaVtIhI0vTaCE3mhzlYOtG/PIosmduEdfWdl/F2p1BbOXqJlbopADjhFln2E6eZsBcO26jpeYbAS9lMgiUYthyR1jpnTgiR57SITADFA1Mpt1F2ZWTGLhywUuR35Cu0bufGZSz3zDk8Ic/t1bcmr6QN7u0j5tvoyhKuQ+E/gT3AyeSFPMaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ir5ujj1PO6bhcLwNC5iN6TitOIDW0qR9A4uUg7nENqM=;
 b=aKFIukUKrzsM+Q5FiaXJNWvhVX/Ufl0ejgofswVi4nEEpjZW6Dc3FsdNcmPWROgamfh2GjrwlgExGcjWEimIDzJLhS8sp/IwC9bWBttEblDWBT8YBvJnKm5AhgeTxq+jvdc9KrUTY+wCudBMQBZ4JBoo5Xl+SdJhiFmNKNRw4GnNegjmfTq9hd230Sj81bw9kCw7yPurA20kZRT7inUwC5naHBfcev4ag0NXpq7rCTJ0FiPN09ytc2jbANaROuoeJoiw8ZKQmYa2XzW21BmRvZJBe6nhqDfETy21oEIW8/4xJRGzIUrx44CTFcOTR9mfo66stqoqc/N44v3VTUxxMQ==
Received: from MW4PR04CA0152.namprd04.prod.outlook.com (2603:10b6:303:85::7)
 by BN8PR12MB3076.namprd12.prod.outlook.com (2603:10b6:408:61::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.19; Tue, 30 Aug
 2022 12:21:41 +0000
Received: from CO1NAM11FT104.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:85:cafe::9a) by MW4PR04CA0152.outlook.office365.com
 (2603:10b6:303:85::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10 via Frontend
 Transport; Tue, 30 Aug 2022 12:21:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT104.mail.protection.outlook.com (10.13.174.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5566.15 via Frontend Transport; Tue, 30 Aug 2022 12:21:40 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.38; Tue, 30 Aug 2022 12:21:40 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Tue, 30 Aug 2022 05:21:38 -0700
Received: from dev-r-vrt-138.mtr.labs.mlnx (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Tue, 30 Aug 2022 05:21:37 -0700
From:   Roi Dayan <roid@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Roi Dayan <roid@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Maor Dickman <maord@nvidia.com>, <alexandr.lobakin@intel.com>,
        <dan.carpenter@oracle.com>
Subject: [PATCH net-next 1/1] net/mlx5e: Fix returning uninitialized err
Date:   Tue, 30 Aug 2022 15:20:24 +0300
Message-ID: <20220830122024.2900197-1-roid@nvidia.com>
X-Mailer: git-send-email 2.34.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4107b768-3673-4911-fd74-08da8a8231ad
X-MS-TrafficTypeDiagnostic: BN8PR12MB3076:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TCl5sTAfnwBYEKBlf86n7KsPPOaIFfKl4TL7jyft+187khy0h9kaZ5oheBqoxf481JfNlcsLIa5fpBK9+GIW3SMRkUAyR+as7R1JpaHFSl+dokWlq6PD0WeLllc7kslXCU7TKdW2vICwHWeqxwXpABcfV7kH1uS/7NJeLIZde7fwBHz1YvLZaQEQxlG3Pzzwd38xRWPl95rUK1T47cLuzUZwvA2X0GmIAuSxCdq6GoFKys/jC9oJ30MQ6Yb2X4MaRpCspui7OTy4u7HDndw1AZYH3prgMflIif8Ah0rIwzxeozyFZ3HWJsahsAJDyt47CpE+8RG963KpZqlT2SBhj08ZETbgTpfBsIN56t04xMccAemdh6UJ46aKsKrCWkyLNtjpL9tVjQEELwzKl8UzhShoiFmanjoAKWTrsYG6otywcmC7vdO60Ifpkm9IkYU2docbGOgk+xXtajA/FFmvaT2krMELNV3MwueOZ8Whr9XHIv6blB46GEnwOebyDZotoVPysbtg+n1etS6N08TNxFz/d/5FTkfWi+K0fhIwf/Hyk7vnHfbbf1nJNSyTXe+7eNDKNfARsusQ16i/S8gcqHgbR71c+Hwv/1f35AOyYvX2DxTdBx99FisP/RNC8IteFYApbscAM1csk4IKuNbPj0bNKHfAcPBu62ppu/85ftUfZR52upXhJHqI3jE6TVxTUn7aSZe9gz+s6eUeEMlpUuJnv3S6h7ffLk+6S0zeVPkhB/0J3rbzT+d4aIw+old1oeNLTYo/vB0u6WWriBlKfTAjxHgKF/00qyG2Pq8d+KXESeJzIVGp7IRLNEo/xXfS
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(39860400002)(396003)(346002)(36840700001)(40470700004)(46966006)(1076003)(47076005)(186003)(2616005)(6916009)(316002)(36756003)(2906002)(426003)(6666004)(83380400001)(336012)(26005)(82740400003)(86362001)(356005)(40460700003)(82310400005)(40480700001)(36860700001)(8936002)(5660300002)(41300700001)(478600001)(54906003)(70206006)(81166007)(70586007)(8676002)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2022 12:21:40.9120
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4107b768-3673-4911-fd74-08da8a8231ad
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT104.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3076
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the cited commit the function mlx5e_rep_add_meta_tunnel_rule()
was added and in success flow, err was returned uninitialized.
Fix it.

Fixes: 430e2d5e2a98 ("net/mlx5: E-Switch, Move send to vport meta rule creation")
Reported-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 914bddbfc1d7..e09bca78df75 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -471,22 +471,18 @@ mlx5e_rep_add_meta_tunnel_rule(struct mlx5e_priv *priv)
 	struct mlx5_eswitch_rep *rep = rpriv->rep;
 	struct mlx5_flow_handle *flow_rule;
 	struct mlx5_flow_group *g;
-	int err;
 
 	g = esw->fdb_table.offloads.send_to_vport_meta_grp;
 	if (!g)
 		return 0;
 
 	flow_rule = mlx5_eswitch_add_send_to_vport_meta_rule(esw, rep->vport);
-	if (IS_ERR(flow_rule)) {
-		err = PTR_ERR(flow_rule);
-		goto out;
-	}
+	if (IS_ERR(flow_rule))
+		return PTR_ERR(flow_rule);
 
 	rpriv->send_to_vport_meta_rule = flow_rule;
 
-out:
-	return err;
+	return 0;
 }
 
 static void
-- 
2.34.3

