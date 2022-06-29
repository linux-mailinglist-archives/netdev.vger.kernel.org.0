Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1F8455FC4B
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 11:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbiF2Jkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 05:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232991AbiF2Jks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 05:40:48 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2043.outbound.protection.outlook.com [40.107.244.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D2E38787
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 02:40:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j4rF+/HWagaFqVliT7t7RvFPz1UlLvsuOEHLsKW2/A/Y6bxfTdQbeP66Bj5r/gD1Hktx+gR0HD8I1Oz1iBWC/P0P4zcPHizdiZYb2W8CuQr50eXtOtSEZV9UOlnIUo7cn2y0GGBrscet+tIYUN6U/w66KC3GL0uX4/dcmYazW8/mBYoUQA0DV33zcWNpXDTboRFAdy8kH9lSjPzgRj41m9eZgmMOWmYM9jpOxY27rRw1JjWwXGAVyiISYArqQUg28lHQKDgmxU1PCwVnBy2L7afOJ6LnyAhAs+5OlrGBfumj+GYVv6QeowdGVQnctTN+uLEVxCqhweJ4RBrmM6rnGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2PIc69c6gnfpaxe8jH72K5gsKFJtJgmnaUMajPi5nys=;
 b=gqCR4GNH8uQbVkJ58GzSGo0q8uoa3OgIYJZ7Lux/psFOYYop7K6GiidD2PrfwHN7FY0X9yckPFftIgQ0csCawxF78ewo8zWexGmkZSRa8ZxcncrqThDJkF44WODsUhcplifaQShsnqef7XiqSIF9f4zGT7C/VvOCAwAFfycl5epDk7L+aFezLMP/L/yoS/DzlV5WcwHWZVi0Z+e5EwEjerLVOZX/V22B6PBmFrVrcllihKy8nJMJux0WoIl063rSPOF01gRogETm1ggU2FLko2AwuiGCZyOc1uqkd3XvdsqWNXGt8T8EzBY+Jxf+sFV0XTqYQMzDR3XPZAXjzpR/aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2PIc69c6gnfpaxe8jH72K5gsKFJtJgmnaUMajPi5nys=;
 b=GWBZd0PWMB10kZ98yf4qTaPjpA1Gj+fKeDTwJBCPS09slpMwTcItUsY3VeDTLT+DGVE6J8/DopcTyTqyKq7d+bXfXG4iEa7tS2/sReXRSSU3ttMPStLQTH/gjG04eiBWFNwNd8xxJUgs2w6be1ZHUXM+v8UP1/Mt1wUdhbXVjPcmJ4NHMftqylMavgDV2DgbM4nIwunXURqOjaRFbIiWQZgbSHFgPlIov2iMQYL99d3H06q/+F5iZtmG/dCQvH6/kGL7nMbh71+G4rVowU27c5GB5JBfU8HvPQYnMADgLebWKoDksQTR07jBmZg7zyrm14Zw3JKDZH631hllyf/4Lg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM6PR12MB3850.namprd12.prod.outlook.com (2603:10b6:5:1c3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Wed, 29 Jun
 2022 09:40:46 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5395.014; Wed, 29 Jun 2022
 09:40:46 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 03/10] mlxsw: spectrum_switchdev: Rename MIDs list
Date:   Wed, 29 Jun 2022 12:40:00 +0300
Message-Id: <20220629094007.827621-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220629094007.827621-1-idosch@nvidia.com>
References: <20220629094007.827621-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0802CA0031.eurprd08.prod.outlook.com
 (2603:10a6:800:a9::17) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a8ef5de-b764-4e09-2783-08da59b37159
X-MS-TrafficTypeDiagnostic: DM6PR12MB3850:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6me94LPBgNMJ1VjzdXv2jmxz/VYsWFq9kvdDrww0gDBU0XV2Rf4oyoPOXvR2Gmxv4E67sLayG6h2owRvkUDFwILfOy79JqtUhbpjjtoRfyLINyaxOdv1lFj98PXjImAie4QbTYYNGtMspLEA9wG2YFLdJ2vbXN9ybFj+KpjH4JSMP1MFwKwAu/0+Wq1jOC2P7Ko/K64RwOvNi6hdZGhwj60DIJkEtLqMQwqExttxBTwFYg+rlOhUiekljPuEvbqHEqIxho1HQX1AQMMhLl3gfljlpjvCZhi+Sv18Ik1dkzvwvfw041IcSlbhG6wIJ7UvOY0mlTBYuWMROcXt1TD5RPXTxJ6GfsbjBLpQd4LZKFxr8CmdVmMiP68Q6yykdKmQKCXCoNegF1+evJg2yVB1ekXu673yU7/eBW9PbK88fHxtadot2FlStFMuvzyNzSONNtPLFbk9DGl4HnyfdzBQKIkJQawL9Z7H4Q/HQkukPKQTwt9cOk8MJU0g3I4HS1fouTgkKOvtc0XYdMhoGdXcLVlOjiEojb1Sm3tMBlV6iZ8XG6rYF6n606+UXq3no/1x2mL4wgn1LWKkccB58jZXU8xOl8XOX8QgptGzCA4xtFu2d5BzuJWecprgnKolqc/sPB75U02o42wSu5Jk8YbIGMMNnLhwFkkdl+JeJ032bpusXF7hmgD7Vroj9BxmheBiZLgEFbR9Zw6YIIGLvLeWYED5ev/7rzfrmk4L5iXNL9f6K3v+KRnVM/BS6TBeB+EV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(366004)(396003)(346002)(136003)(6506007)(2906002)(6512007)(26005)(38100700002)(6666004)(66574015)(186003)(1076003)(107886003)(6916009)(83380400001)(41300700001)(2616005)(66556008)(66476007)(8936002)(4326008)(8676002)(36756003)(6486002)(478600001)(66946007)(86362001)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NAO7HyGs3EOnMeh2eZ4gdP7WtXjCsCzLea8O44BaIWRXsQIeOqHqOUBFdjcV?=
 =?us-ascii?Q?uEHtDABnJLrZvoQT0c9IRQZtT57lq0Yri0lsUitrxR473HWWXDUeJO1Bh2j1?=
 =?us-ascii?Q?pZRh0XjGDLHtbq0PoB7i6aIH1O2t/OKSmhsjMUpOzaaJXZT87NBOjmekSoEk?=
 =?us-ascii?Q?5gzJUBnL76rkATO2c0IUIIh5ESmxLQwQd6M5CJFzvY6Z9nPLYUInzG08/YUO?=
 =?us-ascii?Q?6hlQnUDSpfhgHPE7bz3g526Yc+57GRXzyrJFqJSxvp2JbbXCcfCv08ZxRWaf?=
 =?us-ascii?Q?RXtQNmQsF13cF/n69whlRMpvMfw+7vmBblwEh2p8ON9el0wzGSjqkX8CTZAL?=
 =?us-ascii?Q?o9Tdqgkb7/ZOVOjXUuT8C3CilUV7S98v/P4qn/M6VLTShWFIZK2qPdosGwzx?=
 =?us-ascii?Q?RZnweEOqpTo24l4aXuWd6C8RAy9NI8RsjD0TbjR8EY9fuYnh/bbUf3E+1LYG?=
 =?us-ascii?Q?6vInVgmzFWf1gi/Ks5ByE6j69MWTwy0Bf7svjmQjCrZEAHsZwtkIof7Gz4jw?=
 =?us-ascii?Q?3cBxZFpdrvioYKB1JqP0Cw197RsFtPfT86pL4+eFif8+u73r4TVUQqrqGcx3?=
 =?us-ascii?Q?iM9sbm04Oa/CNeDMUQSSvPNBPduogIhNGvstG5Z8VODjHmtjX9eFtLTIdSdg?=
 =?us-ascii?Q?iBqmn1+nGrLo54PGlHhvGG8/uphZOzcNFhZjR6ZBob3kHtLIwpsQCugqQc4n?=
 =?us-ascii?Q?BjC8rqAKK0D4ZMeqaez8+2p9hzNmWNkI649MG4+HAA+WfkTHIWDrS9L3oArM?=
 =?us-ascii?Q?5DvHwvLcR2mH/E/AEIhH8x85VL3OVSfwGn7AtcEKO5DEyLpSnjKxssmXlpaB?=
 =?us-ascii?Q?CLVKsNwyD1fFUl2Ei6mhw3BZngZXob34rw7KH4oqI2w4WfXaiFsre7fEvRyh?=
 =?us-ascii?Q?rKe6PA+D25ybJnk3A0Wox9w5Dw+RtIm9GVxBSX5Arqc69bK8OFyYotAMsZzF?=
 =?us-ascii?Q?QGN75sOFnjs3lWs3QZWuseFvsaTRfywgEIzGAN8jBGz6XJeMdjgJBx41T4FE?=
 =?us-ascii?Q?v7zidGfkn3ubdb40l0Eilgxv7VoG5gMl6YZG8gyBVODfaXXsJHb7qKmzfsud?=
 =?us-ascii?Q?GJ2q1/7G4gplNNDlSWa3OsVXZcaTf61NHGZMej4SuptXYNbaIo24yegTyHsQ?=
 =?us-ascii?Q?1rlPFZc6lumJEAZWMuzHlG+CsQyyBYuSGkraEOqGyolnWQwxFl01R/k1pi8V?=
 =?us-ascii?Q?EXvhYvjfReTFwZTWVFQ5m6I7s2GHn6q3/eITQ2RDRfdhjS7XAFA/rEO67mJX?=
 =?us-ascii?Q?x2hFaC/wWqRqNhzIlJw9yCPNv770pSRrnu2i/+NsJZGs6evTde/26P57FfML?=
 =?us-ascii?Q?oC/67xTyI1Jr7nFY7uUuQifSkNb/m3LKEQnwAW8bP6roLBmz85z1josLmjT6?=
 =?us-ascii?Q?eoYQ7FTU6t81Gz9Wi2RKiUxnHARb44P7Iqj/1qL/rHPIo3T+Bf33+viyMYGo?=
 =?us-ascii?Q?OFtqKxd1dP5symTDkH36E79aFDplrFMWEDj0NMN4nrbtsj90o6V8kbLHjBNs?=
 =?us-ascii?Q?yoaMu/F7PLDHrJrSzNVQGIP5gh5+eAFBEXI3mOMnkWToFncQVO2slMEuwvTY?=
 =?us-ascii?Q?T4T+O/8eN0bsjnx294zTTrAHVutqUf1AXCyZK49E?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a8ef5de-b764-4e09-2783-08da59b37159
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2022 09:40:46.2813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ij3dVSRLffpS0k7cpiKN2Y976wqOiyDE+GCkeOM4CWOT4UczYrPEANkphQQ3j9zQdC86WCQ5YYBSNGgLr3yX1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3850
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Currently, the list which stores the MDB entries for a given bridge
instance is called 'mids_list'.

This name is not accurate as a MID entry stores a bitmap of ports to
which a packet needs to be replicated and a MDB entry stores the mapping
from {MAC, FID} to PGT index (MID)

Rename it to 'mdb_list'.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../mellanox/mlxsw/spectrum_switchdev.c       | 21 ++++++++++---------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 70b48b922520..bd182736f44d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -48,7 +48,7 @@ struct mlxsw_sp_bridge_device {
 	struct net_device *dev;
 	struct list_head list;
 	struct list_head ports_list;
-	struct list_head mids_list;
+	struct list_head mdb_list;
 	u8 vlan_enabled:1,
 	   multicast_enabled:1,
 	   mrouter:1;
@@ -263,7 +263,8 @@ mlxsw_sp_bridge_device_create(struct mlxsw_sp_bridge *bridge,
 	} else {
 		bridge_device->ops = bridge->bridge_8021d_ops;
 	}
-	INIT_LIST_HEAD(&bridge_device->mids_list);
+	INIT_LIST_HEAD(&bridge_device->mdb_list);
+
 	if (list_empty(&bridge->bridges_list))
 		mlxsw_sp_fdb_notify_work_schedule(bridge->mlxsw_sp, false);
 	list_add(&bridge_device->list, &bridge->bridges_list);
@@ -299,7 +300,7 @@ mlxsw_sp_bridge_device_destroy(struct mlxsw_sp_bridge *bridge,
 	if (bridge_device->vlan_enabled)
 		bridge->vlan_enabled_exists = false;
 	WARN_ON(!list_empty(&bridge_device->ports_list));
-	WARN_ON(!list_empty(&bridge_device->mids_list));
+	WARN_ON(!list_empty(&bridge_device->mdb_list));
 	kfree(bridge_device);
 }
 
@@ -982,7 +983,7 @@ mlxsw_sp_bridge_mrouter_update_mdb(struct mlxsw_sp *mlxsw_sp,
 {
 	struct mlxsw_sp_mdb_entry *mdb_entry;
 
-	list_for_each_entry(mdb_entry, &bridge_device->mids_list, list)
+	list_for_each_entry(mdb_entry, &bridge_device->mdb_list, list)
 		mlxsw_sp_smid_router_port_set(mlxsw_sp, mdb_entry->mid, add);
 }
 
@@ -1711,7 +1712,7 @@ __mlxsw_sp_mc_get(struct mlxsw_sp_bridge_device *bridge_device,
 {
 	struct mlxsw_sp_mdb_entry *mdb_entry;
 
-	list_for_each_entry(mdb_entry, &bridge_device->mids_list, list) {
+	list_for_each_entry(mdb_entry, &bridge_device->mdb_list, list) {
 		if (ether_addr_equal(mdb_entry->addr, addr) &&
 		    mdb_entry->fid == fid)
 			return mdb_entry;
@@ -1840,7 +1841,7 @@ __mlxsw_sp_mc_alloc(struct mlxsw_sp *mlxsw_sp,
 		goto err_write_mdb_entry;
 
 out:
-	list_add_tail(&mdb_entry->list, &bridge_device->mids_list);
+	list_add_tail(&mdb_entry->list, &bridge_device->mdb_list);
 	return mdb_entry;
 
 err_write_mdb_entry:
@@ -1931,7 +1932,7 @@ mlxsw_sp_bridge_mdb_mc_enable_sync(struct mlxsw_sp *mlxsw_sp,
 	struct mlxsw_sp_mdb_entry *mdb_entry;
 	int err;
 
-	list_for_each_entry(mdb_entry, &bridge_device->mids_list, list) {
+	list_for_each_entry(mdb_entry, &bridge_device->mdb_list, list) {
 		if (mc_enabled)
 			err = mlxsw_sp_mc_write_mdb_entry(mlxsw_sp, mdb_entry,
 							  bridge_device);
@@ -1946,7 +1947,7 @@ mlxsw_sp_bridge_mdb_mc_enable_sync(struct mlxsw_sp *mlxsw_sp,
 
 err_mdb_entry_update:
 	list_for_each_entry_continue_reverse(mdb_entry,
-					     &bridge_device->mids_list, list) {
+					     &bridge_device->mdb_list, list) {
 		if (mc_enabled)
 			mlxsw_sp_mc_remove_mdb_entry(mlxsw_sp, mdb_entry);
 		else
@@ -1966,7 +1967,7 @@ mlxsw_sp_port_mrouter_update_mdb(struct mlxsw_sp_port *mlxsw_sp_port,
 
 	bridge_device = bridge_port->bridge_device;
 
-	list_for_each_entry(mdb_entry, &bridge_device->mids_list, list) {
+	list_for_each_entry(mdb_entry, &bridge_device->mdb_list, list) {
 		if (!test_bit(mlxsw_sp_port->local_port,
 			      mdb_entry->ports_in_mid))
 			mlxsw_sp_port_smid_set(mlxsw_sp_port, mdb_entry->mid,
@@ -2115,7 +2116,7 @@ mlxsw_sp_bridge_port_mdb_flush(struct mlxsw_sp_port *mlxsw_sp_port,
 
 	bridge_device = bridge_port->bridge_device;
 
-	list_for_each_entry_safe(mdb_entry, tmp, &bridge_device->mids_list,
+	list_for_each_entry_safe(mdb_entry, tmp, &bridge_device->mdb_list,
 				 list) {
 		if (test_bit(local_port, mdb_entry->ports_in_mid)) {
 			__mlxsw_sp_port_mdb_del(mlxsw_sp_port, bridge_port,
-- 
2.36.1

