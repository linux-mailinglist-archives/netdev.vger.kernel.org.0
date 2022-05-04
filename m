Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC603519761
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 08:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344956AbiEDGeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 02:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345003AbiEDGeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 02:34:07 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6F4C1A
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 23:30:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bRRoxQjvYy8srmsANxQlmsT2Oys/AJv/4UR4OBy5eJ9n9df0hwnFa/aRHsDmVPxmpcMTbdkIuiRfqzIAyllGXRHAkN6fy+fFH1O80iGC7GXcX5r6gvEkOm2sts22+y6HXf66fQFHedNRVLq8oA2E/zlx9okoT9ksMwZQqZD9WSz/wUaeLX3aM2qQAUsmgnYRO8Wwr48L4sBByFUWqUxJFfoP7vp1XHU2NCLyriRBy9HOYt85b5KePDhINJh9jhslqlzdDIYHOCH4npJHtZxMlTDGxOD89ACWYwPqEP9ZzH9qvJOe0/yxl5fjYO+Y0nWxd+6I0hm3kMKDXpGw9o/plg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AhCh4mlcWBlOLVhsX4CSJTmxT9sKnIZ5ByFlJdPmEn8=;
 b=Mo1PVKzIqVtPjbcESu9b8zYJ/6EgVfEaqgx6Eecc2TMDVQ3iTRYUtnTA45lq9ecGB6IymwA6JI3MRtqGBUmDGFHYfBAI6dJS4GWpAHYH0fP85cseB5gmk6XCXzSZPlWnNP9mgp4xYWiLYyUIRmu5aNjiGFBlDrtGfPjP/Z/0ZxZh0QumWZaeY70kZgxH4kCiRBVpJt7bMYQQuPDngZK+G7aDcObnVFexUeTAErKPsSpvIjB7Itr5B/tfsckvMH5oe8s5csOENn7Dat9qTvjTRWx5joHdrIwvIyP+OeMj5ckh0M902eTzDj/2BgDJXusTXRr1RrkDKSMjT36faUYk7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AhCh4mlcWBlOLVhsX4CSJTmxT9sKnIZ5ByFlJdPmEn8=;
 b=XgEs7eQ8Ws7l29Kn8/pqUjTqXJ0/1Bp3OEkTgDn8GoEb2+fmMzAhxRrLM1ktcIaIGDa/CM24cf8aD5plreU3tL0njpnuigYaqvQbpOopXGFP7g1ia3pR2dEIgonlyhkYOLyB1nUU36gs7DOEDbwUgc48EAcOEUF7yeWqVQqLB0w3CrGZIZ58cTH/Q5QMXHM92tUjjziH4ZV4C8zUWbKKyGKktocRuIsNsquNYRbLH2Vw8LkY1cMWPqVdCdFL/eDGxO60VrtkX+0eKWsdp1wiUPHKy/ed8EM5xjGyR3elvPODSMfrLeeH8wTN6Q2bwuubphX17oE1BFhv3tx8YQMoPA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by BN6PR1201MB0129.namprd12.prod.outlook.com (2603:10b6:405:55::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Wed, 4 May
 2022 06:30:28 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%7]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 06:30:28 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 7/8] mlxsw: spectrum_switchdev: Only query FDB notifications when necessary
Date:   Wed,  4 May 2022 09:29:08 +0300
Message-Id: <20220504062909.536194-8-idosch@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504062909.536194-1-idosch@nvidia.com>
References: <20220504062909.536194-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0226.eurprd08.prod.outlook.com
 (2603:10a6:802:15::35) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 702b28b5-dba3-46f2-126c-08da2d979478
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0129:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB01292C175257EEDE10EFE918B2C39@BN6PR1201MB0129.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Pvjt6jjVD9a938IuL8RE+72gYDfL5+IYcBRshHsQyN+CX/DmhT61/ajoUMFkePvsL3lN8eHlIswUAhJ1Ja7HU6Ke5pSJrRSmWHSl4+tcQf4GR1uEcZpE6qgfL3GIDZ9Hf/Dj0Gfgqn5U1FUYowKVSON5exiErzYYeihBKKLNvGwTQklsL2KXaXLgYb+zobLiyW2ACPmxWp4hhWjWedCTa4dyqy6+Pb5f/aUooVWnDW6lKlzjRmlSj0tqqdfK/Ie0TeaX5Nd5pdejl94y5JfUIvd0vJJFzoHepO/E959MreYgvniTrLCdoXvdRoX9tfuac9hZzPxeFNwmqQOJKV02DuOOlSTY5GlkTVwt/QLAEXdvhk74s3TgD+d8aCsmL8rklFYZnWBJ3gGHxxk+Prt9JU65HhH9usbdtrVYm8kNUqAsf/TRPVcByn2Z8iocbXjTgEPREBDzL+uKblMckCeztWAf0GKNigTpQkvolsxeLH9f9qyPkoHXk0e5n9f+eA7TH2VmkYgtOLCvz89J0AnuwycWG4ZMoW5XRl5yBF8myGbDJEID3M8MClie1fSi31UVtjt787ADkI2SlXz/d6xw14tO0dPmEEioH2jvFHHUisn0mCNBjWEjME7kykeN3fwMKhfqgTzYRpw3WCUd5fTdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(6916009)(15650500001)(2616005)(316002)(86362001)(6506007)(6512007)(83380400001)(5660300002)(8936002)(186003)(1076003)(2906002)(107886003)(4326008)(66946007)(36756003)(8676002)(66476007)(66556008)(6486002)(38100700002)(508600001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3roAJQzcOAvRQioAXqof4kLPTesyBTtth9kdFrceKWS/ERxWBnR8bauSlzXf?=
 =?us-ascii?Q?fFMeF4zPvQ/HOtLStS/EqH+eHKNT1FkBIO120vQac/mOUc0rNAu06nMXGFTw?=
 =?us-ascii?Q?ad5BwNmK0NX0NJ3O4uO0M8rRawsnyqzHT3KpMydMnNOuYsps7f1CxfvZ6NLc?=
 =?us-ascii?Q?PiqVR4heIUJ5WaJa9XrnyPpXjyKrmq0u6niagZU/3E/EIObKRHozZ2SQAvQW?=
 =?us-ascii?Q?TVCMektf6eZGXcgaELSpkT9vS3Pf/O/uErQnbpFd2ot/ChzyxWbHbm2JM5iT?=
 =?us-ascii?Q?RHDEmaLxvCIfhz1AQ8TmZ7kqi7aVLA9CypjPFeO8dCSGZWLM9aJ1WhySP9ts?=
 =?us-ascii?Q?sx8JoX3HpupNm18VGDZOido1mKwQUFjUB1bEokcd4uHl3BxJzQkloiJ0ivnW?=
 =?us-ascii?Q?I4PvqVybRRAQSG/v8tayY4mWTVMPdbq6TF9xNeNUH5toCTGkT/YAanESy8GW?=
 =?us-ascii?Q?IQ4LAZH95hUGRXJsEEEZ13x+jrqy1gRZiJNi2Y3tC5AGEnUsucLB1HWTrObf?=
 =?us-ascii?Q?fE5N9W1Zi8QFYsgDmF6TzqYxVW6Mnd1sYkw0pOlAbAx/UGkHaa4sZp+ANNrY?=
 =?us-ascii?Q?o2rK6NsJDNoNHxY/vtiGHgJxgd/Va88UkxbYkvWU4VKiVdOWpO8zOlQ0ftQY?=
 =?us-ascii?Q?Vg0fBYB/HYrlKFjnqyXWhdgaNk7AozVQA2kuix7XWf+xVtR0Cg2TosP6uq8L?=
 =?us-ascii?Q?elAF2uu7TTIkRJUEXH8WHIdHWNyZP/N120xNlhpBkvwTdJdoY92EbEBpa18r?=
 =?us-ascii?Q?XO9+P0Mcj0XefwUjBmsFMV1RsxMFLYTKnSGrQHY8AFnCBGzkrTbxHn3HdBar?=
 =?us-ascii?Q?0l4cEkxF/iiRbCKghxizUKH4FYIPaja+7cxj9LfIKWVIQLVwx6e+KjoenaKw?=
 =?us-ascii?Q?mrQkUwYkGFDicKjWqoskviPPEKpwEaclCcukNF0v486E1blZAloh1JVGT0Wj?=
 =?us-ascii?Q?mbs7MMIdFqCZyXX0MtZBBCPMEohbiufGsDsRyWg9bVnWQSO5zuM9+54dAnZe?=
 =?us-ascii?Q?WeZUTe1a8rugrXvVJY/NRmdnZFlASfah3TLHJevSuMDpyPgKyhppqPdgSceQ?=
 =?us-ascii?Q?JYhTPmzpo7vlvmuYv/Sr7nDYsOkSMB1xEIm6HAn52tjAu8pTCD+5U8FthgPk?=
 =?us-ascii?Q?QcHahylHV0rRE1/K7m0FSEGgXcwuoutkeuKVU01AHkOpbmSEboRcKUjhQusR?=
 =?us-ascii?Q?pYoVw6PfKy4VcqSsWN0VCn9ktjvFb6ii/Hc0PN2nk0fdU45V7eQS1LPtq6W3?=
 =?us-ascii?Q?5Tvl/MB6FHx+vI9f3IX5mcg7DZzSxutmUHL4m5Z89w/EjE8jeM/nrvTbekGP?=
 =?us-ascii?Q?f/TedZ5BxqjmeDvwwCGvI/XD+zpJJBL8+9066cAVwtQAX2FxAoRyklnR8GNn?=
 =?us-ascii?Q?oPrUkFd0whNXN1b+wq5doAB5K54qpues3IvsvnctAyP2Yki1fMTshzXhfKgj?=
 =?us-ascii?Q?veF5WKBijAPc3zrO5HDXUJ1GzY3lKcsDUOFpXwJIGrB2Fvb7BPSVCYOAHNtg?=
 =?us-ascii?Q?uaI6V6RLUgH7CC/EY9L0vbx07uAxKrEwqGtA41eaVDPv6yHOAcVO2klEBrBc?=
 =?us-ascii?Q?osihOwo60ATVtcKbRKieH6eagbGt2+pLvOA5IwYr72Y17Jt4DW7/iiG8SvkJ?=
 =?us-ascii?Q?enBmPCpEtet9VfP/OTSfxzLrijtz+FwidIox0+Lt/QJVJW+vyf4kSsX+DhmY?=
 =?us-ascii?Q?+GaLL4xBoyr3IarJRXQFSpVwg8G1ejzbJUER4gQhSMaVR/7RyTEQjvd1VyZv?=
 =?us-ascii?Q?N+WyXUS3mg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 702b28b5-dba3-46f2-126c-08da2d979478
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 06:30:28.1492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MVIxhBghKF88AK6Mr4ogKmO7XLBfG/kvnCwQQHsmQ9SVKWcQx/9SQ1XcR/tdOm/j9oNmmwjz51pkP1dj5guqDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0129
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver periodically queries the device for FDB notifications (e.g.,
learned, aged-out) in order to update the bridge driver. These
notifications can only be generated when bridges are offloaded to the
device.

Avoid unnecessary queries by starting to query upon installation of the
first bridge and stop querying upon removal of the last bridge.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../mellanox/mlxsw/spectrum_switchdev.c       | 31 ++++++++++++-------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 3bf12092a8a2..a6d2e806cba9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -207,6 +207,16 @@ static void mlxsw_sp_bridge_device_vxlan_fini(struct mlxsw_sp_bridge *bridge,
 	}
 }
 
+static void mlxsw_sp_fdb_notify_work_schedule(struct mlxsw_sp *mlxsw_sp,
+					      bool no_delay)
+{
+	struct mlxsw_sp_bridge *bridge = mlxsw_sp->bridge;
+	unsigned int interval = no_delay ? 0 : bridge->fdb_notify.interval;
+
+	mlxsw_core_schedule_dw(&bridge->fdb_notify.dw,
+			       msecs_to_jiffies(interval));
+}
+
 static struct mlxsw_sp_bridge_device *
 mlxsw_sp_bridge_device_create(struct mlxsw_sp_bridge *bridge,
 			      struct net_device *br_dev,
@@ -245,6 +255,8 @@ mlxsw_sp_bridge_device_create(struct mlxsw_sp_bridge *bridge,
 		bridge_device->ops = bridge->bridge_8021d_ops;
 	}
 	INIT_LIST_HEAD(&bridge_device->mids_list);
+	if (list_empty(&bridge->bridges_list))
+		mlxsw_sp_fdb_notify_work_schedule(bridge->mlxsw_sp, false);
 	list_add(&bridge_device->list, &bridge->bridges_list);
 
 	/* It is possible we already have VXLAN devices enslaved to the bridge.
@@ -273,6 +285,8 @@ mlxsw_sp_bridge_device_destroy(struct mlxsw_sp_bridge *bridge,
 	mlxsw_sp_bridge_device_rifs_destroy(bridge->mlxsw_sp,
 					    bridge_device->dev);
 	list_del(&bridge_device->list);
+	if (list_empty(&bridge->bridges_list))
+		cancel_delayed_work(&bridge->fdb_notify.dw);
 	if (bridge_device->vlan_enabled)
 		bridge->vlan_enabled_exists = false;
 	WARN_ON(!list_empty(&bridge_device->ports_list));
@@ -2886,22 +2900,13 @@ static void mlxsw_sp_fdb_notify_rec_process(struct mlxsw_sp *mlxsw_sp,
 	}
 }
 
-static void mlxsw_sp_fdb_notify_work_schedule(struct mlxsw_sp *mlxsw_sp,
-					      bool no_delay)
-{
-	struct mlxsw_sp_bridge *bridge = mlxsw_sp->bridge;
-	unsigned int interval = no_delay ? 0 : bridge->fdb_notify.interval;
-
-	mlxsw_core_schedule_dw(&bridge->fdb_notify.dw,
-			       msecs_to_jiffies(interval));
-}
-
 #define MLXSW_SP_FDB_SFN_QUERIES_PER_SESSION 10
 
 static void mlxsw_sp_fdb_notify_work(struct work_struct *work)
 {
 	struct mlxsw_sp_bridge *bridge;
 	struct mlxsw_sp *mlxsw_sp;
+	bool reschedule = false;
 	char *sfn_pl;
 	int queries;
 	u8 num_rec;
@@ -2916,6 +2921,9 @@ static void mlxsw_sp_fdb_notify_work(struct work_struct *work)
 	mlxsw_sp = bridge->mlxsw_sp;
 
 	rtnl_lock();
+	if (list_empty(&bridge->bridges_list))
+		goto out;
+	reschedule = true;
 	queries = MLXSW_SP_FDB_SFN_QUERIES_PER_SESSION;
 	while (queries > 0) {
 		mlxsw_reg_sfn_pack(sfn_pl);
@@ -2935,6 +2943,8 @@ static void mlxsw_sp_fdb_notify_work(struct work_struct *work)
 out:
 	rtnl_unlock();
 	kfree(sfn_pl);
+	if (!reschedule)
+		return;
 	mlxsw_sp_fdb_notify_work_schedule(mlxsw_sp, !queries);
 }
 
@@ -3665,7 +3675,6 @@ static int mlxsw_sp_fdb_init(struct mlxsw_sp *mlxsw_sp)
 
 	INIT_DELAYED_WORK(&bridge->fdb_notify.dw, mlxsw_sp_fdb_notify_work);
 	bridge->fdb_notify.interval = MLXSW_SP_DEFAULT_LEARNING_INTERVAL;
-	mlxsw_sp_fdb_notify_work_schedule(mlxsw_sp, false);
 	return 0;
 
 err_register_switchdev_blocking_notifier:
-- 
2.35.1

