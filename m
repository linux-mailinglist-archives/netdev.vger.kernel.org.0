Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEC22000D0
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 05:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730977AbgFSDdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 23:33:39 -0400
Received: from mail-eopbgr80088.outbound.protection.outlook.com ([40.107.8.88]:57212
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730905AbgFSDdg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 23:33:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e2jFV75Sts7/dttiP7uifgyb7U+KDv5ZyYdKPW5aHRYyqRhyDwT8oJ5bCSQn82T7d5koRdIMKQgNJ2w6dljm41cMiISgBegu1YM6X90MPDKHLxKRChE4lIC/ZEhWAtkz1oBXm0mlUOHT78QGBDd3HOSnmAjGqXS1I8NkbcrFu0wsqnyTjbfbJSECAzYdTNLkWZVU1uXnB4N3ij8t9XGcZ1DPM+9f2Lyht+iRIyz7k5vJEb2dK3M3Mmj3Jbot635lTWnsOfqwd/usABKX47eSWW/rpuyxo52bC5+/Pxg0So6MLpuf21ZahOFLTvv+GRsdWH+BzjOS4tubbLx7KeDuPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SU5NEZvgc6KrBIBX5Yhf1hHZ5zMbLr/owTuWTy3Mypw=;
 b=IGLqphQxhA+S2yBBqNaNQ9YvrkOwh8+hXBkIA4e3Z06aXavgof3yI2VN7R8RIOPv1uoFDkj53Cr5ohZj2/Sq7298RJZQX6ErdqGoiGwub5HApTxRYY+ryYBanELSOetks51dvQ2F3lesyHgYJQQcnGZgrK03UAjllnjdVXlj62yX7ogjNyhzpl/c9/HH9Xaw/tu+TzflkCEp52bQpAS3EFid0vaF/QjWdIEj+O3uiP7oK/DKMWUL0D+jkhzQ3XzILyXNZ78yoQhIXKNSCwN2Vq/k/bAWp7vWrV2r1T32G4TCHAgmhUlOYRJnjMTTd31umaQsCW6tG3MKOLTLnmDKkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SU5NEZvgc6KrBIBX5Yhf1hHZ5zMbLr/owTuWTy3Mypw=;
 b=MFH/PTS66/9OBhF7jVYPbjCvKS0Y01FHKLRZLXT6dg75Y6lWf12ekeQ2Lb/CCfaA/kgcMW/eJGd8xC+pFnx6PgUYLMmvpcYh7COmlnOeIkmyT2YQJblHfkupSr8ijHiA3+5aGGim+LbaxKVzNuxXChCALILYYEuAcSXqYdudKVo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR05MB6804.eurprd05.prod.outlook.com (2603:10a6:20b:146::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Fri, 19 Jun
 2020 03:33:26 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7%2]) with mapi id 15.20.3109.021; Fri, 19 Jun 2020
 03:33:26 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     saeedm@mellanox.com, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next 4/9] net/mlx5: Constify mac address pointer
Date:   Fri, 19 Jun 2020 03:32:50 +0000
Message-Id: <20200619033255.163-5-parav@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200619033255.163-1-parav@mellanox.com>
References: <20200619033255.163-1-parav@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0401CA0019.namprd04.prod.outlook.com
 (2603:10b6:803:21::29) To AM0PR05MB4866.eurprd05.prod.outlook.com
 (2603:10a6:208:c0::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sw-mtx-036.mtx.labs.mlnx (208.176.44.194) by SN4PR0401CA0019.namprd04.prod.outlook.com (2603:10b6:803:21::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Fri, 19 Jun 2020 03:33:25 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [208.176.44.194]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 268e5374-3725-465e-cc23-08d8140186d7
X-MS-TrafficTypeDiagnostic: AM0PR05MB6804:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB6804A8C1CD3582C6FFC94214D1980@AM0PR05MB6804.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 0439571D1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: giqoK+38fzuqZRiaWsK70pgIQZSWNHwGnOKmaQti664CXaSFI1zAspLeK20zsLGvzORYB+ui2YAZ7pnsB/ugG8oJEYE6nt0Vx5WJJmQiTarqGX/jyYqCWVwkfVsGgwiREd01va+nDyutDB+2DYq1wRGYhi/IXbO8jxahbRyIpPvAhbfMb+aS7UfmX7aRiURcdVMyZwQWC8fLQ1CvA1qxUw/uTIC1K0jrd5ZQGBSkWwNEjlPMC8RZY9CC+j7cdGfCRqvYtoQhJO2BY9AU+3uWrgTqrJ4y5TL4OUQ4SKqwfB+eDjYj3gSR5Z255KZwKmsU4x5ghzDZEcD0rmnIG9cRcQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(8676002)(2616005)(2906002)(4326008)(107886003)(6486002)(478600001)(8936002)(6512007)(5660300002)(6916009)(956004)(6666004)(26005)(66476007)(16526019)(186003)(66556008)(66946007)(83380400001)(316002)(6506007)(54906003)(86362001)(52116002)(36756003)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: BkkWMAnln0T9yqYAbEglLEYEYUz/4TBKCeR8BGmi/Skwh+sRau+EwkaZVT6shfdRxSDX9CrIjbNTqgdvLYwELelPjIaZ0I1bGITsoWixWQp5Jv9yWih3WYaN4z9n8ZwDeIjfh3a9nZ+SlWT7g62sK8aiOz1Mifvs1FBtXWWbhk0qcHVPKr62A/61+JXQZbtsgaWwcryzYhZIcngO2SBvQjZklKD9cf5Of14Tphm05uq+csNELj50i4pfFhdKQ7wyb5ho84OwGox3f2rDPaQ09S02NCzO3KNPLv+H/6g3tz86Vs1wj+lTO5tJlAb2B9U+aR8R81pLzx2nCFA6OS/lS0CxFhlDFGb7tmtgKejMjVQETLmj+0Q7CwVCIn8S+kjcQIlgD/jMIR8a5gPh88Sk7bqWOtiR/aPcePnGeDeyST2brk1Ig6wjvaccXeBTyMtBZicj8hmTJugx6jlk/SK7dccb3QV2FpzviXK3RYiMeYfHJ4opvFsZNZGG2YuMlrnS
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 268e5374-3725-465e-cc23-08d8140186d7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2020 03:33:26.6445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xgY4L/HfIyE0NdjlzN/xKZCpZG5oHImBN/U+1HvBaSprDRjf7pEUH4snQPiZ1cWJImzRus45lN+NRHo5/nhpUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6804
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since none of the functions need to modify the input mac address,
constify them.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/vport.c   | 2 +-
 include/linux/mlx5/vport.h                        | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 1116ab9bea6c..d6a585a143dc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1127,7 +1127,7 @@ int mlx5_esw_modify_vport_rate(struct mlx5_eswitch *esw, u16 vport_num,
 						  MODIFY_SCHEDULING_ELEMENT_IN_MODIFY_BITMASK_MAX_AVERAGE_BW);
 }
 
-static void node_guid_gen_from_mac(u64 *node_guid, u8 mac[ETH_ALEN])
+static void node_guid_gen_from_mac(u64 *node_guid, const u8 *mac)
 {
 	((u8 *)node_guid)[7] = mac[0];
 	((u8 *)node_guid)[6] = mac[1];
@@ -1779,7 +1779,7 @@ void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw)
 
 /* Vport Administration */
 int mlx5_eswitch_set_vport_mac(struct mlx5_eswitch *esw,
-			       u16 vport, u8 mac[ETH_ALEN])
+			       u16 vport, const u8 *mac)
 {
 	struct mlx5_vport *evport = mlx5_eswitch_get_vport(esw, vport);
 	u64 node_guid;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index a5175e98c0b3..165a23efc608 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -311,7 +311,7 @@ int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int num_vfs);
 void mlx5_eswitch_disable_locked(struct mlx5_eswitch *esw, bool clear_vf);
 void mlx5_eswitch_disable(struct mlx5_eswitch *esw, bool clear_vf);
 int mlx5_eswitch_set_vport_mac(struct mlx5_eswitch *esw,
-			       u16 vport, u8 mac[ETH_ALEN]);
+			       u16 vport, const u8 *mac);
 int mlx5_eswitch_set_vport_state(struct mlx5_eswitch *esw,
 				 u16 vport, int link_state);
 int mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch *esw,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index c107d92dc118..88cdb9bb4c4a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -173,7 +173,7 @@ int mlx5_query_mac_address(struct mlx5_core_dev *mdev, u8 *addr)
 EXPORT_SYMBOL_GPL(mlx5_query_mac_address);
 
 int mlx5_modify_nic_vport_mac_address(struct mlx5_core_dev *mdev,
-				      u16 vport, u8 *addr)
+				      u16 vport, const u8 *addr)
 {
 	void *in;
 	int inlen = MLX5_ST_SZ_BYTES(modify_nic_vport_context_in);
diff --git a/include/linux/mlx5/vport.h b/include/linux/mlx5/vport.h
index 8170da1e9f70..4db87bcfce7b 100644
--- a/include/linux/mlx5/vport.h
+++ b/include/linux/mlx5/vport.h
@@ -75,7 +75,7 @@ void mlx5_query_min_inline(struct mlx5_core_dev *mdev, u8 *min_inline);
 int mlx5_modify_nic_vport_min_inline(struct mlx5_core_dev *mdev,
 				     u16 vport, u8 min_inline);
 int mlx5_modify_nic_vport_mac_address(struct mlx5_core_dev *dev,
-				      u16 vport, u8 *addr);
+				      u16 vport, const u8 *addr);
 int mlx5_query_nic_vport_mtu(struct mlx5_core_dev *mdev, u16 *mtu);
 int mlx5_modify_nic_vport_mtu(struct mlx5_core_dev *mdev, u16 mtu);
 int mlx5_query_nic_vport_system_image_guid(struct mlx5_core_dev *mdev,
-- 
2.19.2

