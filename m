Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF8D519724
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 08:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344801AbiEDGGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 02:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344791AbiEDGGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 02:06:39 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2063.outbound.protection.outlook.com [40.107.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384A41B7B6
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 23:03:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dZ7s8+XbMRjOizQq1tHGOXdYn97BPplN1EazYKgVyiSIzlGKIpPLwfYm7R40soO12CpGP2zG8Hu8p5q5uCJXmFRuVGI+W9TJge6BQ1TGODVAhYXoNgQQD+qBSL6FoWLsIA5VVBXQDWUO4DVd7+UJMx5H66AjGGYF9ZgCQPJU1+QLDQAshAwJOIEf3im4MT9NbfTjkwvaXliYpXLSOwNI32G07G88+lm0Jmw6EpISmMKqxXa5ZBJgJqT6tDKvZ87XY6xa5sNl8dVfhtLk8gFpThzIBdhxKZ5WbBA+UDbeuiJ2/09B1Buaefni8vmL6oKdcMF9hecmJSGcGuiNy61+6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bXfFPGwbT+reZARtd4UweGtRVTdUrojiSdxJmADXK9A=;
 b=VigQlGg0xL7szC2qo0fULC14dJ23mKcSJUqpowGDYlwcO0dEVHe6fnofkIWG+GzDpMCPUfOv7CcVhdANyijHEUc/AzRmnlDoFp4Rw/MNKWupQF9DIyTq2KRIuBQtG3S9wDWP+oItVNkfBfUVLNXRCgFBNfzWAqRuB9xHdl+6y44I9EWkgXtRU+kWCG7DeOteEDSXIGlbxENUa+wb+Fb1D2kQOiwe3fG4RVS73QP/CgLzYeyt2fZjUxoVkHD8V0zATRxhiwES3B9KgC/pn0MGG8nslam4DIWAbBhQ3+gVQdW5AUhGAMNYnINRm1ejbe8JvrFzR6O7qcI5HRyAaaDkhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bXfFPGwbT+reZARtd4UweGtRVTdUrojiSdxJmADXK9A=;
 b=GR7X8emJqrnVDU/C8p2mJDTK9LkUTqwR1zXH7aLR3SeC2rZqz+S4QSt81EwHkiOpXxVKWex2D0/pXpPS+m3bS2ZkWtg889i5pAdpWPKhqGXEePwH2cFgNBz1SeUP+pqbs6DQqPOaMMRsR1olUlYQ7gW3LLwiJxvM0+ns55wRQrBgE4QZbAWgr68ZCgJv21zoon0GDLhiJ0OTQ7sUVe71z5wWbSL6TYvlwTyYlsGNDVIfL0d3mHsPSd7/IByLYeq1pE+k6/Dc52vmi1gWDRtC8jBuhGJgGAoGYJn468CRee0S0VXdfQI+epA8UShR1NPhsOR2VWfWBRF19OgSfaV9Mw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by CY4PR1201MB0006.namprd12.prod.outlook.com (2603:10b6:903:d3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20; Wed, 4 May
 2022 06:03:02 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 06:03:02 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/17] net/mlx5: Store IPsec ESN update work in XFRM state
Date:   Tue,  3 May 2022 23:02:19 -0700
Message-Id: <20220504060231.668674-6-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504060231.668674-1-saeedm@nvidia.com>
References: <20220504060231.668674-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0055.prod.exchangelabs.com (2603:10b6:a03:94::32)
 To BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 799f03ee-e2d8-41d2-ba66-08da2d93bf82
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0006:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0006EC4C87B6D34F2131F051B3C39@CY4PR1201MB0006.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7JZRcprPWrYyZO0e4TeFDP82bkUiAT5aiyFN2E2DWjbbMwP5yHVuy0S0fnjShfa2B6LKoIZEQc9UMx2El97llxw/nLidpnt54mFDERIUAKqNg6MYmWa5wJwGDpCPyIje6+wN9ZcnVGtjRdqwPT8ii4eCNsg5cFvm6lzq9sNa9esRAmVn9fMDb/rnow+QHeo6gTlRdreBnX3mllF/M0cplzljqZA1/R8RDreMy6nEJySL0bO+XNZDd4FrY6zqUjmTVLW11WHkyYOs5EobMF4oVXLcHXcdH/KlH7CzHIK6r54pemjS2Xs5PYJd+/sxdox69aT3scpSoqAbO+wmvciKXMEejlWz0zbOaGeOPiiFjXQaBRZj9hwHkdNxq4I0EV8oeBNH5QdUzg6YSLEsMtJTA6/1dTvXifl8KBcBzzMjvEFhhl02+izdXtR5QHEp9P0mnR9rgwlUxl8Cp2w+ztO3/jE8DiWHorZjXEa6dj9WMBG4AE28QvSJhtBIWt4CFF3jRXFlgnBUf4fkEJHg/nsyNTaomAUo+EopYCO0MQdapdLlhaK9ofCCkHAxRZ2KA2xISFvSw3xYWwP1p4sTcllnGWRnxiZN5lqBgQO8JC250E0z08iKGbMY1EW8YHdvt3S18nS/8GXhE/KD3VJgLIZ1IQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(107886003)(2906002)(54906003)(8936002)(110136005)(86362001)(15650500001)(316002)(30864003)(83380400001)(66946007)(6512007)(6506007)(8676002)(66556008)(66476007)(6666004)(508600001)(4326008)(186003)(1076003)(2616005)(5660300002)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Os/9n0wg48KygrfdLDoY0csKIEaQzyWfjRM/TT9zmSfvdL4ouIHVLSZJBXwk?=
 =?us-ascii?Q?qe+3U+FJ49u5TCoQHTV/+IPvQgGPgi7lMRLt54qBfWXd6qf3C3XZmuylM1a7?=
 =?us-ascii?Q?1jSB3Lgbg6Fuq710pQ72GyQbZXGmpDL9Pl4rRCUUuBNVSe6H2PT+w6BBO+ZI?=
 =?us-ascii?Q?/xDBNiVsSXUVqj7nh6hgKIiPqifa2lk0DcbImvd/EHWdirsxaIg/GHtJk9/S?=
 =?us-ascii?Q?c/Ql8k72lsmwEDTBUbrELxgoHd8Kk/bb0FgAoI+o07lTe7wWhnMOq0EauCnQ?=
 =?us-ascii?Q?kW1mjqrPrWO1oPcezYadJ+J2aKBg4rMgCOpEMy9q2SkABtoNAmwm+9ZKFLdS?=
 =?us-ascii?Q?TTSk3NB7jQJaFUNVkOs+Pw0z6zc+J+2eRYGqkmhnlpZ2zk9IgKGJb4ut/3MV?=
 =?us-ascii?Q?SeYbU4h1NlYxKwy6rNVvS1L0QSVT2Zm2MAJaRm26pipo7wD/PUcwwYfRin26?=
 =?us-ascii?Q?aWeGSbV2XzXmxfGa0dEEU4Ik1AcA7DwqExkA2BIwbfyfCGkuIP17iCgs5K+c?=
 =?us-ascii?Q?i1FxvvEDYZUF74+FXE/U9NqJMLIfzEF1jv4eBZxaEU5oN9CdpOLv40cmqcJk?=
 =?us-ascii?Q?t+enAw1Y2gEusmHdSl/TCJXYi0Kqtn9yHPRdS0g8bTEPHUz0aD26+WrfSU1T?=
 =?us-ascii?Q?zGzXEmsYucsnd2Kd6+YNbGXpQ0z9ENzlr6qdZAX+OqFv8TlakdQ9vUWiZleb?=
 =?us-ascii?Q?8MH33tZMHmOz+lTMvYgEJLpygPkjwkm9hxMNgZGBGCZhDu+pGXIXIAD0O4ou?=
 =?us-ascii?Q?xxSF3nbUWYVIiqLWLbfCCK8njiTMfChyb3DMSNr1y833LVFO0/ihM3iPkctA?=
 =?us-ascii?Q?O3yu3CPMsLUMpPxdaXu4HnJksOTuGaWUdr2rY40gu6Edf7351Gr+uPSdvw+F?=
 =?us-ascii?Q?1d5auB15CIxUM0AZT4xn2r9/AJOPW5fLyNRjP/4MuolM3UYZ0EIjMJy0ONCP?=
 =?us-ascii?Q?k2lT3Fl4HabIO5v31PdvhXn6IIYV0YvvorqAXlI5PM8qHXYrdJaUZ/TQStTi?=
 =?us-ascii?Q?mmoc5EARL2Zxdz9aQTPspKk7tYdEg615MkrZFleAiraYe385/s0kt+wRkeZm?=
 =?us-ascii?Q?V5o5/1TKT9D1aALwA6vL1B14gmQkRoSEfmTUpcTN9u6gd5kS51cX4PmcnP0f?=
 =?us-ascii?Q?0qYp9EnZu++dVpjhQLCIOXwVrNGLSNxf5FCV97RCB1uJCaLLPwecEc2A6iCL?=
 =?us-ascii?Q?9fOxzjEWWgKrWXBx6bCinYPs3EaKiprv8134RbyHv7usEhBUMxn+F2Ic0ebp?=
 =?us-ascii?Q?tIKK+YOu7mm9jp045QU+OANyBohflgMejlAdL25GEz1t5woy+TTE06xDPrem?=
 =?us-ascii?Q?4P8WGPVb/VnjKM7ABdPZkAAgLIOIkhPYwUT9nqpj6t5/6LMvBPWvCa7q2L1P?=
 =?us-ascii?Q?7eEgaFtGjyQC+WDX7oADlUdN1mIaIbKgGSffEqRmIUu0nwxgZ77S9IebvAif?=
 =?us-ascii?Q?chIM3qvESl91IxxLSRfAv+9MX6K5h2YWNnUks1PFcpSHdbL/9BhXJc+DYXmG?=
 =?us-ascii?Q?9HaQd+PdVwLwL2XBeqoRCZQ1jacfHbhSC5B73Vw4ddDThcm1p5DEnA/WYdaA?=
 =?us-ascii?Q?3rN0cZ0HhywSaS6XtfGQaw3erZhUk46kKpbkSI8DOr0X9vE80MAxqxfo97TY?=
 =?us-ascii?Q?E+9cFVxioVFJBluzgdG26EmOVQ+sVCLYgzRIqR1w3RHmi2B3s2ht9rnqQUZe?=
 =?us-ascii?Q?K696Tw765lrVoQqWlZE3EysdFw43jStCmvEpdWgny+hiRF+NfgX+CiNHpuSw?=
 =?us-ascii?Q?k9Mr2NVqwuyMG1YeGgN2yB2Tc6MOniI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 799f03ee-e2d8-41d2-ba66-08da2d93bf82
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 06:03:02.4679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qYl5aM7pvtpSfZtUNpWF9oxhCV92Ln0W/Y8TH8CtPqc7g0Okf1+ymVlp/ll9OJQhZlHXlItNNAsk2bYQQRXIIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0006
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

mlx5 IPsec code updated ESN through workqueue with allocation calls
in the data path, which can be saved easily if the work is created
during XFRM state initialization routine.

The locking used later in the work didn't protect from anything because
change of HW context is possible during XFRM state add or delete only,
which can cancel work and make sure that it is not running.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 49 ++++++-------------
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  7 ++-
 .../mlx5/core/en_accel/ipsec_offload.c        | 39 +++------------
 include/linux/mlx5/accel.h                    | 10 ++--
 4 files changed, 33 insertions(+), 72 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 251178e6e82b..8283cf273a63 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -271,6 +271,16 @@ static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
 	return 0;
 }
 
+static void _update_xfrm_state(struct work_struct *work)
+{
+	struct mlx5e_ipsec_modify_state_work *modify_work =
+		container_of(work, struct mlx5e_ipsec_modify_state_work, work);
+	struct mlx5e_ipsec_sa_entry *sa_entry = container_of(
+		modify_work, struct mlx5e_ipsec_sa_entry, modify_work);
+
+	mlx5_accel_esp_modify_xfrm(sa_entry->xfrm, &modify_work->attrs);
+}
+
 static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 {
 	struct mlx5e_ipsec_sa_entry *sa_entry = NULL;
@@ -334,6 +344,7 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 				mlx5e_ipsec_set_iv_esn : mlx5e_ipsec_set_iv;
 	}
 
+	INIT_WORK(&sa_entry->modify_work.work, _update_xfrm_state);
 	x->xso.offload_handle = (unsigned long)sa_entry;
 	goto out;
 
@@ -365,7 +376,7 @@ static void mlx5e_xfrm_free_state(struct xfrm_state *x)
 	struct mlx5e_priv *priv = netdev_priv(x->xso.dev);
 
 	if (sa_entry->hw_context) {
-		flush_workqueue(sa_entry->ipsec->wq);
+		cancel_work_sync(&sa_entry->modify_work.work);
 		mlx5e_accel_ipsec_fs_del_rule(priv, &sa_entry->xfrm->attrs,
 					      &sa_entry->ipsec_rule);
 		mlx5_accel_esp_free_hw_context(sa_entry->xfrm->mdev, sa_entry->hw_context);
@@ -392,7 +403,6 @@ int mlx5e_ipsec_init(struct mlx5e_priv *priv)
 	hash_init(ipsec->sadb_rx);
 	spin_lock_init(&ipsec->sadb_rx_lock);
 	ipsec->mdev = priv->mdev;
-	ipsec->en_priv = priv;
 	ipsec->wq = alloc_ordered_workqueue("mlx5e_ipsec: %s", 0,
 					    priv->netdev->name);
 	if (!ipsec->wq) {
@@ -424,7 +434,6 @@ void mlx5e_ipsec_cleanup(struct mlx5e_priv *priv)
 
 	mlx5e_accel_ipsec_fs_cleanup(ipsec);
 	destroy_workqueue(ipsec->wq);
-
 	kfree(ipsec);
 	priv->ipsec = NULL;
 }
@@ -444,47 +453,19 @@ static bool mlx5e_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
 	return true;
 }
 
-struct mlx5e_ipsec_modify_state_work {
-	struct work_struct		work;
-	struct mlx5_accel_esp_xfrm_attrs attrs;
-	struct mlx5e_ipsec_sa_entry	*sa_entry;
-};
-
-static void _update_xfrm_state(struct work_struct *work)
-{
-	int ret;
-	struct mlx5e_ipsec_modify_state_work *modify_work =
-		container_of(work, struct mlx5e_ipsec_modify_state_work, work);
-	struct mlx5e_ipsec_sa_entry *sa_entry = modify_work->sa_entry;
-
-	ret = mlx5_accel_esp_modify_xfrm(sa_entry->xfrm,
-					 &modify_work->attrs);
-	if (ret)
-		netdev_warn(sa_entry->ipsec->en_priv->netdev,
-			    "Not an IPSec offload device\n");
-
-	kfree(modify_work);
-}
-
 static void mlx5e_xfrm_advance_esn_state(struct xfrm_state *x)
 {
 	struct mlx5e_ipsec_sa_entry *sa_entry = to_ipsec_sa_entry(x);
-	struct mlx5e_ipsec_modify_state_work *modify_work;
+	struct mlx5e_ipsec_modify_state_work *modify_work =
+		&sa_entry->modify_work;
 	bool need_update;
 
 	need_update = mlx5e_ipsec_update_esn_state(sa_entry);
 	if (!need_update)
 		return;
 
-	modify_work = kzalloc(sizeof(*modify_work), GFP_ATOMIC);
-	if (!modify_work)
-		return;
-
 	mlx5e_ipsec_build_accel_xfrm_attrs(sa_entry, &modify_work->attrs);
-	modify_work->sa_entry = sa_entry;
-
-	INIT_WORK(&modify_work->work, _update_xfrm_state);
-	WARN_ON(!queue_work(sa_entry->ipsec->wq, &modify_work->work));
+	queue_work(sa_entry->ipsec->wq, &modify_work->work);
 }
 
 static const struct xfrmdev_ops mlx5e_ipsec_xfrmdev_ops = {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index bbf48d4616f9..35a751faeb33 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -62,7 +62,6 @@ struct mlx5e_ipsec_tx;
 
 struct mlx5e_ipsec {
 	struct mlx5_core_dev *mdev;
-	struct mlx5e_priv *en_priv;
 	DECLARE_HASHTABLE(sadb_rx, MLX5E_IPSEC_SADB_RX_BITS);
 	spinlock_t sadb_rx_lock; /* Protects sadb_rx */
 	struct mlx5e_ipsec_sw_stats sw_stats;
@@ -82,6 +81,11 @@ struct mlx5e_ipsec_rule {
 	struct mlx5_modify_hdr *set_modify_hdr;
 };
 
+struct mlx5e_ipsec_modify_state_work {
+	struct work_struct		work;
+	struct mlx5_accel_esp_xfrm_attrs attrs;
+};
+
 struct mlx5e_ipsec_sa_entry {
 	struct hlist_node hlist; /* Item in SADB_RX hashtable */
 	struct mlx5e_ipsec_esn_state esn_state;
@@ -94,6 +98,7 @@ struct mlx5e_ipsec_sa_entry {
 			  struct xfrm_offload *xo);
 	u32 ipsec_obj_id;
 	struct mlx5e_ipsec_rule ipsec_rule;
+	struct mlx5e_ipsec_modify_state_work modify_work;
 };
 
 int mlx5e_ipsec_init(struct mlx5e_priv *priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 37c9880719cf..bbfb6643ed80 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -18,7 +18,6 @@ struct mlx5_ipsec_sa_ctx {
 struct mlx5_ipsec_esp_xfrm {
 	/* reference counter of SA ctx */
 	struct mlx5_ipsec_sa_ctx *sa_ctx;
-	struct mutex lock; /* protects mlx5_ipsec_esp_xfrm */
 	struct mlx5_accel_esp_xfrm accel_xfrm;
 };
 
@@ -117,7 +116,6 @@ mlx5_ipsec_offload_esp_create_xfrm(struct mlx5_core_dev *mdev,
 	if (!mxfrm)
 		return ERR_PTR(-ENOMEM);
 
-	mutex_init(&mxfrm->lock);
 	memcpy(&mxfrm->accel_xfrm.attrs, attrs,
 	       sizeof(mxfrm->accel_xfrm.attrs));
 
@@ -129,8 +127,6 @@ static void mlx5_ipsec_offload_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm
 	struct mlx5_ipsec_esp_xfrm *mxfrm = container_of(xfrm, struct mlx5_ipsec_esp_xfrm,
 							 accel_xfrm);
 
-	/* assuming no sa_ctx are connected to this xfrm_ctx */
-	WARN_ON(mxfrm->sa_ctx);
 	kfree(mxfrm);
 }
 
@@ -232,7 +228,6 @@ static void *mlx5_ipsec_offload_create_sa_ctx(struct mlx5_core_dev *mdev,
 	sa_ctx->dev = mdev;
 
 	mxfrm = container_of(accel_xfrm, struct mlx5_ipsec_esp_xfrm, accel_xfrm);
-	mutex_lock(&mxfrm->lock);
 	sa_ctx->mxfrm = mxfrm;
 
 	/* key */
@@ -258,14 +253,12 @@ static void *mlx5_ipsec_offload_create_sa_ctx(struct mlx5_core_dev *mdev,
 
 	*hw_handle = sa_ctx->ipsec_obj_id;
 	mxfrm->sa_ctx = sa_ctx;
-	mutex_unlock(&mxfrm->lock);
 
 	return sa_ctx;
 
 err_enc_key:
 	mlx5_destroy_encryption_key(mdev, sa_ctx->enc_key_id);
 err_sa_ctx:
-	mutex_unlock(&mxfrm->lock);
 	kfree(sa_ctx);
 	return ERR_PTR(err);
 }
@@ -273,14 +266,10 @@ static void *mlx5_ipsec_offload_create_sa_ctx(struct mlx5_core_dev *mdev,
 static void mlx5_ipsec_offload_delete_sa_ctx(void *context)
 {
 	struct mlx5_ipsec_sa_ctx *sa_ctx = (struct mlx5_ipsec_sa_ctx *)context;
-	struct mlx5_ipsec_esp_xfrm *mxfrm = sa_ctx->mxfrm;
 
-	mutex_lock(&mxfrm->lock);
 	mlx5_destroy_ipsec_obj(sa_ctx->dev, sa_ctx->ipsec_obj_id);
 	mlx5_destroy_encryption_key(sa_ctx->dev, sa_ctx->enc_key_id);
 	kfree(sa_ctx);
-	mxfrm->sa_ctx = NULL;
-	mutex_unlock(&mxfrm->lock);
 }
 
 static int mlx5_modify_ipsec_obj(struct mlx5_core_dev *mdev,
@@ -331,29 +320,17 @@ static int mlx5_modify_ipsec_obj(struct mlx5_core_dev *mdev,
 	return mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
 }
 
-static int mlx5_ipsec_offload_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
-					      const struct mlx5_accel_esp_xfrm_attrs *attrs)
+static void mlx5_ipsec_offload_esp_modify_xfrm(
+	struct mlx5_accel_esp_xfrm *xfrm,
+	const struct mlx5_accel_esp_xfrm_attrs *attrs)
 {
 	struct mlx5_ipsec_obj_attrs ipsec_attrs = {};
 	struct mlx5_core_dev *mdev = xfrm->mdev;
 	struct mlx5_ipsec_esp_xfrm *mxfrm;
-
 	int err = 0;
 
-	if (!memcmp(&xfrm->attrs, attrs, sizeof(xfrm->attrs)))
-		return 0;
-
-	if (mlx5_ipsec_offload_esp_validate_xfrm_attrs(mdev, attrs))
-		return -EOPNOTSUPP;
-
 	mxfrm = container_of(xfrm, struct mlx5_ipsec_esp_xfrm, accel_xfrm);
 
-	mutex_lock(&mxfrm->lock);
-
-	if (!mxfrm->sa_ctx)
-		/* Not bound xfrm, change only sw attrs */
-		goto change_sw_xfrm_attrs;
-
 	/* need to add find and replace in ipsec_rhash_sa the sa_ctx */
 	/* modify device with new hw_sa */
 	ipsec_attrs.accel_flags = attrs->flags;
@@ -362,12 +339,8 @@ static int mlx5_ipsec_offload_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
 				    &ipsec_attrs,
 				    mxfrm->sa_ctx->ipsec_obj_id);
 
-change_sw_xfrm_attrs:
 	if (!err)
 		memcpy(&xfrm->attrs, attrs, sizeof(xfrm->attrs));
-
-	mutex_unlock(&mxfrm->lock);
-	return err;
 }
 
 void *mlx5_accel_esp_create_hw_context(struct mlx5_core_dev *mdev,
@@ -413,8 +386,8 @@ void mlx5_accel_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm)
 	mlx5_ipsec_offload_esp_destroy_xfrm(xfrm);
 }
 
-int mlx5_accel_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
-			       const struct mlx5_accel_esp_xfrm_attrs *attrs)
+void mlx5_accel_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
+				const struct mlx5_accel_esp_xfrm_attrs *attrs)
 {
-	return mlx5_ipsec_offload_esp_modify_xfrm(xfrm, attrs);
+	mlx5_ipsec_offload_esp_modify_xfrm(xfrm, attrs);
 }
diff --git a/include/linux/mlx5/accel.h b/include/linux/mlx5/accel.h
index 0f2596297f6a..a2720ebbb9fd 100644
--- a/include/linux/mlx5/accel.h
+++ b/include/linux/mlx5/accel.h
@@ -127,8 +127,8 @@ struct mlx5_accel_esp_xfrm *
 mlx5_accel_esp_create_xfrm(struct mlx5_core_dev *mdev,
 			   const struct mlx5_accel_esp_xfrm_attrs *attrs);
 void mlx5_accel_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm);
-int mlx5_accel_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
-			       const struct mlx5_accel_esp_xfrm_attrs *attrs);
+void mlx5_accel_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
+				const struct mlx5_accel_esp_xfrm_attrs *attrs);
 
 #else
 
@@ -145,9 +145,11 @@ mlx5_accel_esp_create_xfrm(struct mlx5_core_dev *mdev,
 }
 static inline void
 mlx5_accel_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm) {}
-static inline int
+static inline void
 mlx5_accel_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
-			   const struct mlx5_accel_esp_xfrm_attrs *attrs) { return -EOPNOTSUPP; }
+			   const struct mlx5_accel_esp_xfrm_attrs *attrs)
+{
+}
 
 #endif /* CONFIG_MLX5_EN_IPSEC */
 #endif /* __MLX5_ACCEL_H__ */
-- 
2.35.1

