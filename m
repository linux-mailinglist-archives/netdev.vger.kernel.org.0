Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 535EC520D68
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 07:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236910AbiEJGCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 02:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236905AbiEJGCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 02:02:00 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C702266F34
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 22:58:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bM62gVDN+SMv4XIghaKupGEq/Pe8Tz1xsqA12mPJSH7l1SFLo2Hn6gpNhlKJmD/BMomoU3lmiv2TCqfcx6m37cFlfbHMNKnmv5Vj7RYaxfyh7mf5MhufooQJELwuKLOKuNUqrzOkhC4UcCn/MtBwN9rgA6JtJ8QpSXHIuMBEhuCKBz3l1Cc8XfNmQkXOsmloA4Cyzu/2zEux4kIe5XIEQPkZUyVIiLCajHhNoJqJvlv5jIhlVwW+0M7EiOyYQnFyxIkUOVZkscdVgkeyBG/1pAEhOW7RVzO3plM8Hnw1bQx/iHHMf5GGZpovfUqsxcohWecdkRGUjH5b3uB8LPPLgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=atqOzSB2ToMkzbnCWeR+bLtX2EsF0YrqdnfHZYJlkoQ=;
 b=IzrTE9TpX91jIooU96uLyi/MKBcoJX+MIm6q+0OwXPNue/IaMHFNlbKqo+ZVhSmuojxaM2QUi1uzmBwQL7kFF+6eEqCzZF/tlpSE3VAKXODqyjgx3IB2BXjKfrdY2KhwSuWOd93+JAwpCA4zKEKrwY4YQaX5cc28cdQUEYJnxFs8iN+t+Gosuv15ZbqIMCXkg70mHv4R8hxa4Ku6ho+Xcl6+buF+VQeGPsfi638DRw/qZ379WUw9m4UAF2k17j8ivMkPXMKD+RITmg79dftJPm7ZogdmCcifCZUSYJlgWfMymi/LKn0sYbSL7M2+j/+X6lw+y+o3FJ8/aTFvpYJgNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=atqOzSB2ToMkzbnCWeR+bLtX2EsF0YrqdnfHZYJlkoQ=;
 b=WXUmxzOjHYzMMwRGbQnsBmYF5itJA+gHjeR57MrDpM68K8+pm2Nu37pNKCCX2beFTinHGCy4WUsqxKCifaIENxUmlmfdcnRh/2S+0+ieadLWDO1+kCmCVzmfkwDSZt2HOMdw6hm2hP/nPev/1OcYHsWCSJHNNmk8o7X9KT8ImXICrOa6px7wLZpzKq4wY+G4D1lj/SZ3fU+swndeV9L0lHvF8iIHX9T3aOZP1VNpKX3OiRD9VUCtQE/NFBukLe/tY6a4+hWP8tuiQ2P7bXDzEJA+NLhJ1RA82fMzfyQOaNzesmIBMZRVYVk4TiqQV7NLYFRV5hajHdPLAGEnuiI4Hg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by CY5PR12MB6383.namprd12.prod.outlook.com (2603:10b6:930:3d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25; Tue, 10 May
 2022 05:58:02 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 05:58:02 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/15] net/mlx5: Lag, expose number of lag ports
Date:   Mon,  9 May 2022 22:57:31 -0700
Message-Id: <20220510055743.118828-4-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510055743.118828-1-saeedm@nvidia.com>
References: <20220510055743.118828-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0046.namprd02.prod.outlook.com
 (2603:10b6:a03:54::23) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0bd2c60a-db4d-4b93-0fa3-08da324a0b41
X-MS-TrafficTypeDiagnostic: CY5PR12MB6383:EE_
X-Microsoft-Antispam-PRVS: <CY5PR12MB6383D824B70A06E3B3BD51D0B3C99@CY5PR12MB6383.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ds+d6h6Q/25twWx03nOrU46hVeeJqhVLTQfeEgZ4d+xBEPR3HaX5txwuhN1AulkwzNnhW1bvNg7TMs1SRkyGgcgOFYPtQWwciVhTrCLju9eQ+jtagxLCoEKiPbaZfakUhkv+esky6KCubBzM0kiOhVB+4+GHBrPZ6w+IDemVUWm6c1SKcHTwMrrkm3ApVtTVctlDM03tWXnqB6qVLzHEMz6YVvHXnJcwEV61sOcIU489+2ikOJjD9zVzGgEm7EqalOHjTBb+Dcnge9/I+K9OvNVDFr6jgzrHQxiC+sXO85v3fi73gWoHGJPx1xeqqrsarWUNuGHnavRBywvCeK+qqUjDJ7WmCE5jOlEw4kTs2NbSY9DnOD6hbF9MZxM2fmue1MTf9PPKAAtLYOSe1AOGAV4CrnjCsAQYXa0DvREKcgtJdlTmNe/78+tiLcZ7/7E97wrbKRBuvu5fdTA9zqF26SAG6D6qeOS6H3Z2nqco7KPfuVE8bhCXwfU01/qvsDX9qJdBfsLCXzrKhdVX5s0ZHGX27CqD+vN0O+koXLfOqlZ0LgiUUiD3KlE2KbmktKxyfvV37lbDyv2m3UhzyObAGg/1n3pKenEWb6YSTR0wksMTnqmYn4PsJHp0YGaPL80w0XGpNlNDrZcwcy4VcNqA9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(110136005)(316002)(8676002)(36756003)(2906002)(6506007)(107886003)(2616005)(1076003)(83380400001)(38100700002)(186003)(4326008)(8936002)(6486002)(5660300002)(508600001)(6666004)(66556008)(66946007)(66476007)(86362001)(6512007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sZcrFMIroIOUiUrZ3MT3gaKBth8ACFiJoDp8WullSA17b7carhbr+K64b02E?=
 =?us-ascii?Q?vaR3QMQF/n9BfEzZye9ahhn31BP9VlafyaTYO07l+u96nV1S/cht64rZazyf?=
 =?us-ascii?Q?VWAuyJQ1QDcm2XMi7PcLYw7xIUgZWSJQOPXlF8tjxjGtvxW7SuFARqB6+I6m?=
 =?us-ascii?Q?Hei/KSNqy8gmt+OF1XgoxxnKxckD9yRsQGCrbUHw2ZN0dDGJPnA1d1eMkGVW?=
 =?us-ascii?Q?nloeNvZ075hzZ/uf5asilYIDIClT23sXFYXTLUFy8khkej7ir5sJlOqXQIqm?=
 =?us-ascii?Q?Y2luil7gZlnE8CnW/9b6IeRbyFnMXjqfOEHZazl+bTR42ywdP8TW9i4LbSw4?=
 =?us-ascii?Q?h8NKuT4oBghDrqLZxt8Bb/TeqRjlvQjF0q8HQ1+KjyjfGfwP96SEjAa6hA+7?=
 =?us-ascii?Q?q0Fw85dt3OW29byesThyJcRdvoYwAr3YihmiY4ERB0gWcsbTBRbrFo1zNBFY?=
 =?us-ascii?Q?fd2HMZcYB982uNj9emYzUJLDCKZsjJQMuPXf8969rjqI1MkYIc2f/D69PaI8?=
 =?us-ascii?Q?sk+AXUrfpkV1I03tHKANOVbJrYc7+nj74oMVEqXm5CfqpKU+hYeJLHlH9hsr?=
 =?us-ascii?Q?EogzLl2IiEEpEYoV5CLyNW1cx7btsdSecpv+f/2nbkc3utaFf11tLCBkp4+7?=
 =?us-ascii?Q?rPyNg+xyHsGipCsVQSkUeceX+x3BaIoZAK9+BmW02pNdJH2nhm31FNRTAZ4w?=
 =?us-ascii?Q?lSZ4xGARBRfn8v9h1xXrN4Gl0EmVG0lAfEb+7nJrhyX6i07K59K594zXBjm5?=
 =?us-ascii?Q?59nCqhNEWOxX1+5U4IRUIfOrSx6IdNU+D8SlxgvhT2m7wBYb3Rdvb7zDsgGB?=
 =?us-ascii?Q?8KrObQoTnQq7suvz4+FI9mdv56GspplOgPsMPBChh/PmJjBLcKt79B04zvvD?=
 =?us-ascii?Q?9aGRD8QgWwfeclcKgFSbb0RslFKRTf5bNPFdRFE+1rcEfeJO+saYb4qi4ubH?=
 =?us-ascii?Q?WHFSqDV6I+IwYV6hP3BineKdmvJF60QUm8+84mfGHFLQSJscS24kIenn4Y7y?=
 =?us-ascii?Q?IOjGHKpn2krlmiBZk8QfJFW11pMVjyVtcSoYjzdLBtMXDtPYwJzQbvgc6Ovl?=
 =?us-ascii?Q?IifY10i6I91tXApFKYIhSue/J6/zPY3d6aBPb2ZHPirXXMUj7JUOOqY8gcRs?=
 =?us-ascii?Q?UkOyag8WG0zzcA7p1nkhr1qXw5xdSHx+ZN1moh9MD8GmAjlu/JbP3Mg1SiiC?=
 =?us-ascii?Q?TbpnXRNlYTex0IQnvbOlYc07oTyQpitPhveQYAGOacWJWLz1Q6ku9tgMe6if?=
 =?us-ascii?Q?Yt2jI1kGISqjURXLefuvpbNh8JvxCCsJDrH72RyBlUbOlLkO4G+S8bmjnBF+?=
 =?us-ascii?Q?cOFgqM7VaD4uddlK1yZLdI2ZWefzv7EEGrSZkUP6TnWs8cxDJwkqA9AJbM4A?=
 =?us-ascii?Q?xWg39b47VQrF2limX8UM4TJFxDqc8Y1zlFkTTeSEtgEeIw3zn7GjEu0f3oV4?=
 =?us-ascii?Q?5mUOQmuxi4W4dsuxuOOGmqD5eGlEL6V2fdxlfVA+qrp/Gab81o8GqFCcd1lI?=
 =?us-ascii?Q?LHf5ZI/zoPQtunKiaMIhZpYpyV5x9M57lywlUInNW27JtHW6rCErlFFctcHy?=
 =?us-ascii?Q?28PxirqLWDfrHKOzyO/8P4QB8XDksQ5VlQpdULr5U96scBiKPNrprJdSF/1O?=
 =?us-ascii?Q?ST8yCB5kfvGZ1jM9kwP0NQDqXAhD/NLq/XyJ1xD9nwAwmNZahW3eHWv9eysO?=
 =?us-ascii?Q?Y/fPcyolrZyWC9PWBLgihJaAvromGzj5LIj5X8KKpvPH5exhW5Q4sYTN//ic?=
 =?us-ascii?Q?HciuGX6v87bxCKZs6SejqFLOJwqOjwbinG9QUCap6n7WG9S9YDGv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bd2c60a-db4d-4b93-0fa3-08da324a0b41
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 05:58:02.5846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5ZvqGZm3jfDm5+0gnWtadKgo37fM5OqmpJ0fPBHhM410tRiLfNYtUD8ZS4L+gN7GHEq3B83bblHOIdPRigGqng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6383
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

Downstream patches will add support for hardware lag with
more than 2 ports. Add a way for users to query the number of lag ports.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/infiniband/hw/mlx5/gsi.c                  | 2 +-
 drivers/infiniband/hw/mlx5/main.c                 | 1 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h              | 1 +
 drivers/infiniband/hw/mlx5/qp.c                   | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 6 ++++++
 include/linux/mlx5/driver.h                       | 1 +
 6 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/gsi.c b/drivers/infiniband/hw/mlx5/gsi.c
index 3ad8f637c589..b804f2dd5628 100644
--- a/drivers/infiniband/hw/mlx5/gsi.c
+++ b/drivers/infiniband/hw/mlx5/gsi.c
@@ -100,7 +100,7 @@ int mlx5_ib_create_gsi(struct ib_pd *pd, struct mlx5_ib_qp *mqp,
 				 port_type) == MLX5_CAP_PORT_TYPE_IB)
 			num_qps = pd->device->attrs.max_pkeys;
 		else if (dev->lag_active)
-			num_qps = MLX5_MAX_PORTS;
+			num_qps = dev->lag_ports;
 	}
 
 	gsi = &mqp->gsi;
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 61aa196d6484..61a3b767262f 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2991,6 +2991,7 @@ static int mlx5_eth_lag_init(struct mlx5_ib_dev *dev)
 	}
 
 	dev->flow_db->lag_demux_ft = ft;
+	dev->lag_ports = mlx5_lag_get_num_ports(mdev);
 	dev->lag_active = true;
 	return 0;
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 4f04bb55c4c6..8b3c83c0b70a 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1131,6 +1131,7 @@ struct mlx5_ib_dev {
 	struct xarray sig_mrs;
 	struct mlx5_port_caps port_caps[MLX5_MAX_PORTS];
 	u16 pkey_table_len;
+	u8 lag_ports;
 };
 
 static inline struct mlx5_ib_cq *to_mibcq(struct mlx5_core_cq *mcq)
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 3f467557d34e..fb8669c02546 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3907,7 +3907,7 @@ static unsigned int get_tx_affinity_rr(struct mlx5_ib_dev *dev,
 		tx_port_affinity = &dev->port[port_num].roce.tx_port_affinity;
 
 	return (unsigned int)atomic_add_return(1, tx_port_affinity) %
-		MLX5_MAX_PORTS + 1;
+		(dev->lag_active ? dev->lag_ports : MLX5_CAP_GEN(dev->mdev, num_lag_ports)) + 1;
 }
 
 static bool qp_supports_affinity(struct mlx5_ib_qp *qp)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 6cad3b72c133..fe34cce77d07 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1185,6 +1185,12 @@ u8 mlx5_lag_get_slave_port(struct mlx5_core_dev *dev,
 }
 EXPORT_SYMBOL(mlx5_lag_get_slave_port);
 
+u8 mlx5_lag_get_num_ports(struct mlx5_core_dev *dev)
+{
+	return MLX5_MAX_PORTS;
+}
+EXPORT_SYMBOL(mlx5_lag_get_num_ports);
+
 struct mlx5_core_dev *mlx5_lag_get_peer_mdev(struct mlx5_core_dev *dev)
 {
 	struct mlx5_core_dev *peer_dev = NULL;
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index f327d0544038..62ea1120de9c 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1142,6 +1142,7 @@ int mlx5_lag_query_cong_counters(struct mlx5_core_dev *dev,
 				 int num_counters,
 				 size_t *offsets);
 struct mlx5_core_dev *mlx5_lag_get_peer_mdev(struct mlx5_core_dev *dev);
+u8 mlx5_lag_get_num_ports(struct mlx5_core_dev *dev);
 struct mlx5_uars_page *mlx5_get_uars_page(struct mlx5_core_dev *mdev);
 void mlx5_put_uars_page(struct mlx5_core_dev *mdev, struct mlx5_uars_page *up);
 int mlx5_dm_sw_icm_alloc(struct mlx5_core_dev *dev, enum mlx5_sw_icm_type type,
-- 
2.35.1

