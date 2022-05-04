Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC557519721
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 08:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344798AbiEDGGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 02:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344785AbiEDGGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 02:06:35 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2074.outbound.protection.outlook.com [40.107.223.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2BE51AF11
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 23:03:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OC+KmhJUj9FSSBT04DvokpZ869VCb6AbI6ua2cGuMrDgtVTOPgyyemzPIUok1/CrykC8A9rlPVzXEhbPnS0JNDnX4v/yMLrBKAYqLPK1TqQKRkbbcy5mVmgt+FecOOfzocE9ckO5EhPZiayqOgO7VaUDFK9KmJYLQWrt1BmAGQ2fxu/R7Rj1g9EB3ppCg7tpxTgNRlBdn2WuEjlWgrKBB0IA4vo9QUyUHlJKRxqwLOmtkcg3bgLnp45US/AneVwLdedI15crsUAQExH54C9rk8z8IUHNOvYlS2Sbb5PALEfXonnC5Mc9oABp18HwkKXY8BV6fIrgcjXIjlbwuU9i1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z7hlds8h23l+euk5ycWXuiA91HUlVGYh1qzATvRMGCY=;
 b=WBKenxWz0mlpsfyOalnm8Ww+Sg3vAd5dfBX8xZAlXJqcrET50+8kaO41bzE1QYpT9N6K+NWXHiYo8YkACbkCSJE5UYK6deYm8BRG9U0c8BbDVwruWK7zanEMTseZAh2CzLmgpp6EI+0TxShE38kAfF20YVSfLNFCjfyxlk3tQ7Bvsza1o2Qgh4G0Sqx0RBpL7TyxdnsPWu7KIQz6CMOjL3Z6LFtjHOUf34+tMbSeafl+8x2V+LqTQO+mtqNaNwUivsSLkxGzawACaxL8V56QRlsPIy2CJj+gOUFy5jtLnM2nIhX3ls25Hp6VcjCzk2zVXxuyPAJ6KEzR247riu0kkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z7hlds8h23l+euk5ycWXuiA91HUlVGYh1qzATvRMGCY=;
 b=qijcJgYmMnKUOFFtA7ILSOnUvz2UjaoJLfUQxKl4DxAoGc1wKeziIwJumIs8rse6gwI9N/5+2pJx1QSXQt8M4Ws72/JNx/qhg5EDv2vSxxK2o23Ym29U1Iya+1TeQqxn7GppOqiBkesh6599fag/Ewz02VmHpg89I+7bxvdMOcNf54PNgx3g66myKDphHsJ5N3XnaiadGJeCypx+INZZfRNxUeRzqO82Z1i+T3N23EIzp9r2GtdXOEe2o6YvU6lnY4J0+J+9BY3KjqsVumFKHAY2m8hGa+TCA+ZrwWnBuiSCMp8Tuv5h7qC1e/tsei0kdOuZqEF6mWjBCmnSGKhsmg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by CY4PR1201MB0006.namprd12.prod.outlook.com (2603:10b6:903:d3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20; Wed, 4 May
 2022 06:02:59 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 06:02:59 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/17] net/mlx5: Don't hide fallback to software IPsec in FS code
Date:   Tue,  3 May 2022 23:02:17 -0700
Message-Id: <20220504060231.668674-4-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504060231.668674-1-saeedm@nvidia.com>
References: <20220504060231.668674-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0045.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::20) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1c6bf88-5098-4c2a-2cb3-08da2d93bdda
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0006:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB00061A9BAF3ACEB806CDCC0FB3C39@CY4PR1201MB0006.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +K7islXRzRNwZ4VIQazJjaZDkMDgChlbb1oZhctpzHH16vvidj410N6jQIUQGhFdLuJzvl4Gsqgylo+GX2lQ7OVHiDH36HP/wBAkjY2bXDfSqK/7fvbLSwJuOIKJU/ff8bMsTU5EAowaERvqRMEO97Oj2ebisqc8doAxhCgtc+JcSYI+yW8ESre/768HxVZRH3v5Z1rxX4RcHlZszENGbn5Wflzb5M+MbGq/TPfAs+wFpH4RZOAk3+BsBeOVHh24abv+KPaQJp9jHQVVwCUnqe3/UMWo4LEO1sDqfLM9FfRxPU2qwu6lBj9srst6dtY+d/Mnb8NrdyyP3eCvfO4XjDCWn4zLqy5fFWfwR9W7lUrAR0xKWhbcvUU6EecuMo+3ocXkM4VgKczNjNHqeugVrIM2sTyF++R39FzuEgDBzgV86WspKsJgK8CuQZGkpCgn+M6olvA7k0x4aiUKOxOHDGEUO8XyS+O1prBveC/eepnu9i+aIkZq0u0XLK5iAXlb8BJQL1jbWvRGMkmDSuf9VbmMqD8WN84BK7yE7Y70TlYOYRck9NLBHpOr0TJLdPjigwrIhBHDSmU4o021cLoA8slvsRBQp9wK42DoDVQI+ygMzVfNr8hnLwHy/eI8fOvlnEnv3oGYw6P/IPdvxX9vrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(107886003)(2906002)(54906003)(8936002)(110136005)(86362001)(316002)(83380400001)(66946007)(6512007)(6506007)(8676002)(66556008)(66476007)(6666004)(508600001)(4326008)(186003)(1076003)(2616005)(5660300002)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vVUYx+KzKaffBROGKHR3a+H+t84EWWIasK2H1VWfpWK2C81lNAtTZHiedkMF?=
 =?us-ascii?Q?BDRVTS0XRB2X203Ek9clxoI9l5wBc26y6ogafaAYPikqWm8a0l1WvuTMyp58?=
 =?us-ascii?Q?2HBu9vkmcf/YGPtmYcLPTr8x2aJ0M2QlB8uC120BtoD0YLir+1Nzay2Px1Ly?=
 =?us-ascii?Q?6Iopbh4F3joEzfc4+Dz2GLW3ZsGdttPMWr+ZbiPyamxUZNGxk5Q/7QbmcJLo?=
 =?us-ascii?Q?c1rYD5SjqEnvpHwQSYkdx6qR34Md9fIWzv78eamP+Tz3YcDlJzkPZorWgsnz?=
 =?us-ascii?Q?Bd9nApcKtDVWu+7Jx1TnhKa9XFx3VsfeyiqyTotibAroQ8ZITv7CaSIBeOYF?=
 =?us-ascii?Q?bPze09y0UAc9x0IMq3dTupQNMf0FXAD9i8RQL3UTavcdZ0YfDjvkXiekmxUc?=
 =?us-ascii?Q?fOE4PbqgLwbfD5ND2CxqqGdIAXILZd4cXXQsX4bdXj1ZmtqjEYe+MIICU1ya?=
 =?us-ascii?Q?5lFIOzgxMQHCTd7bP686ZugGeUN881PiY+s9fl3IrX6i8MnxVO4LvbEzEKl5?=
 =?us-ascii?Q?T7t+YCYPNV1zqeuGn9iUTc12nCgD4MxVzr3RM4Zx0VN7ABwrCwB4HjCffnF/?=
 =?us-ascii?Q?9BMD1aEdYKIB8ImT7HFdPsqRG4fkNrqa+34fZoM42f0ByP6q0NwtC8SBwJWr?=
 =?us-ascii?Q?PkZkTny4Y//RQrUFvtnh3pdjIy1jkL0lqO8tnlQW532kCysQACToDj8MzZuF?=
 =?us-ascii?Q?VyUixN2SGKGffH8sxORqWiRti0nVWxoscJSxxUUheNfZLhAIWC+QqjFXOuQV?=
 =?us-ascii?Q?bnaIGPlhkvNpgjKGi2YqIuA4MwZi2aylXlB7BCC5/rtIQWBeaygETlp9K0AR?=
 =?us-ascii?Q?UJZNgXkBU7tNkLObsP9qPO472Gm8bACY0ltCBs0jThozKCcOF4ln3t3ZNSo5?=
 =?us-ascii?Q?+vuQzo6eOTpJyar/ERNw/bssYjBfBExnD+Leg14OHoPbpAQsh/VkS5PMChzx?=
 =?us-ascii?Q?4eFg7h0YlAqgPBErFXkoeMGe1FY0fm80id4J90agiw+XgPZVOC7VIakPjUl8?=
 =?us-ascii?Q?tDNSM/rtEofEc8KrMNO4gjTh75qQtBt2tiTHcnOPZZeLEowd+Dgu7sncNF8t?=
 =?us-ascii?Q?88SNy0Ne4+j5tKckEndaq9qxIc0u4cOpJaDd1cLrymaboZ24zJOBrwu7gOeW?=
 =?us-ascii?Q?j2YS4LogvUr7XEOner6a0TOYufQki5d1ZYL0x7KlfPm6t1ckAY6JHLkCC+th?=
 =?us-ascii?Q?VJb+0PT8bbafeW2nfsoxlzELcODSEmEulecJLAJzuYJswLkfddhf5Cq05E62?=
 =?us-ascii?Q?Nv7NDeFYo409MENf2sOvWE2zTk2D/B+xJXBWJZmfHJYWB42TNsFwxMEzCQTF?=
 =?us-ascii?Q?grBO9okWq+IQm+FK/do3XBU70hsrQd9RVnL/i/pBGSC4zbuuzeA88vlAepld?=
 =?us-ascii?Q?k9JVTdQmoeaCwubZveeL/IjmQrN00jLeaZZykZ1oHpfRGF0soeAorKX/5Zei?=
 =?us-ascii?Q?e+tB1VWujtbwKp1MLarkyt3jKfCv6zV4LdAyiR9KOnqzFw6gJH/uY7uHj22h?=
 =?us-ascii?Q?Kw67XrmcquujFEXFXEnhcEl8GVaaouQtm7i5RRcV+w8ffAzj2wCRyABAEe3T?=
 =?us-ascii?Q?pfAPe04C7MJHw3zF3f6urSTgVThsz2TKnJDtwAZbtatxa67pzdPd8uNCtLtq?=
 =?us-ascii?Q?MJ5ZztoxnRDOvDT1t6XB5arPxHfI+uqmwXIwudcKc/pifczP1H5KmZX+7q0v?=
 =?us-ascii?Q?L8DWqAAwy5YvhZSg5vqIOaCFvsBT0nHgSiSNxfyAmTqM2YXLJMogWcbWi5zV?=
 =?us-ascii?Q?Tb8UlhNevpljqUEhHSmPz8e+Sb9A44Q=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1c6bf88-5098-4c2a-2cb3-08da2d93bdda
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 06:02:59.6387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RevGb5fZidWYe1xyUeZ+6gPxmsk8ICcFiYWg5CX1adpehFAI/K7b95v83+92Iu6+1Q/6BLAj/0H9cViDUXop/g==
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

The XFRM code performs fallback to software IPsec if .xdo_dev_state_add()
returns -EOPNOTSUPP. This is what mlx5 did very deep in its stack trace,
despite have all the knowledge that IPsec is not going to work in very
early stage.

This is achieved by making sure that priv->ipsec pointer is valid for
fully working and supported hardware crypto IPsec engine.

In case, the hardware IPsec is not supported, the XFRM code will set NULL
to xso->dev and it will prevent from calls to various .xdo_dev_state_*()
callbacks.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 41 ++++++++-----------
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    |  6 ---
 2 files changed, 17 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 40700bf61924..b04d5de91d87 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -43,17 +43,7 @@
 
 static struct mlx5e_ipsec_sa_entry *to_ipsec_sa_entry(struct xfrm_state *x)
 {
-	struct mlx5e_ipsec_sa_entry *sa;
-
-	if (!x)
-		return NULL;
-
-	sa = (struct mlx5e_ipsec_sa_entry *)x->xso.offload_handle;
-	if (!sa)
-		return NULL;
-
-	WARN_ON(sa->x != x);
-	return sa;
+	return (struct mlx5e_ipsec_sa_entry *)x->xso.offload_handle;
 }
 
 struct xfrm_state *mlx5e_ipsec_sadb_rx_lookup(struct mlx5e_ipsec *ipsec,
@@ -306,6 +296,8 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 	int err;
 
 	priv = netdev_priv(netdev);
+	if (!priv->ipsec)
+		return -EOPNOTSUPP;
 
 	err = mlx5e_xfrm_validate_state(x);
 	if (err)
@@ -375,9 +367,6 @@ static void mlx5e_xfrm_del_state(struct xfrm_state *x)
 {
 	struct mlx5e_ipsec_sa_entry *sa_entry = to_ipsec_sa_entry(x);
 
-	if (!sa_entry)
-		return;
-
 	if (x->xso.flags & XFRM_OFFLOAD_INBOUND)
 		mlx5e_ipsec_sadb_rx_del(sa_entry);
 }
@@ -387,9 +376,6 @@ static void mlx5e_xfrm_free_state(struct xfrm_state *x)
 	struct mlx5e_ipsec_sa_entry *sa_entry = to_ipsec_sa_entry(x);
 	struct mlx5e_priv *priv = netdev_priv(x->xso.dev);
 
-	if (!sa_entry)
-		return;
-
 	if (sa_entry->hw_context) {
 		flush_workqueue(sa_entry->ipsec->wq);
 		mlx5e_xfrm_fs_del_rule(priv, sa_entry);
@@ -402,7 +388,8 @@ static void mlx5e_xfrm_free_state(struct xfrm_state *x)
 
 int mlx5e_ipsec_init(struct mlx5e_priv *priv)
 {
-	struct mlx5e_ipsec *ipsec = NULL;
+	struct mlx5e_ipsec *ipsec;
+	int ret;
 
 	if (!mlx5_ipsec_device_caps(priv->mdev)) {
 		netdev_dbg(priv->netdev, "Not an IPSec offload device\n");
@@ -420,14 +407,23 @@ int mlx5e_ipsec_init(struct mlx5e_priv *priv)
 	ipsec->wq = alloc_ordered_workqueue("mlx5e_ipsec: %s", 0,
 					    priv->netdev->name);
 	if (!ipsec->wq) {
-		kfree(ipsec);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err_wq;
 	}
 
+	ret = mlx5e_accel_ipsec_fs_init(ipsec);
+	if (ret)
+		goto err_fs_init;
+
 	priv->ipsec = ipsec;
-	mlx5e_accel_ipsec_fs_init(ipsec);
 	netdev_dbg(priv->netdev, "IPSec attached to netdevice\n");
 	return 0;
+
+err_fs_init:
+	destroy_workqueue(ipsec->wq);
+err_wq:
+	kfree(ipsec);
+	return (ret != -EOPNOTSUPP) ? ret : 0;
 }
 
 void mlx5e_ipsec_cleanup(struct mlx5e_priv *priv)
@@ -487,9 +483,6 @@ static void mlx5e_xfrm_advance_esn_state(struct xfrm_state *x)
 	struct mlx5e_ipsec_modify_state_work *modify_work;
 	bool need_update;
 
-	if (!sa_entry)
-		return;
-
 	need_update = mlx5e_ipsec_update_esn_state(sa_entry);
 	if (!need_update)
 		return;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 55fb6d4cf4ae..f733a6e61196 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -605,9 +605,6 @@ int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_priv *priv,
 				  u32 ipsec_obj_id,
 				  struct mlx5e_ipsec_rule *ipsec_rule)
 {
-	if (!priv->ipsec->rx_fs)
-		return -EOPNOTSUPP;
-
 	if (attrs->action == MLX5_ACCEL_ESP_ACTION_DECRYPT)
 		return rx_add_rule(priv, attrs, ipsec_obj_id, ipsec_rule);
 	else
@@ -618,9 +615,6 @@ void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_priv *priv,
 				   struct mlx5_accel_esp_xfrm_attrs *attrs,
 				   struct mlx5e_ipsec_rule *ipsec_rule)
 {
-	if (!priv->ipsec->rx_fs)
-		return;
-
 	if (attrs->action == MLX5_ACCEL_ESP_ACTION_DECRYPT)
 		rx_del_rule(priv, attrs, ipsec_rule);
 	else
-- 
2.35.1

