Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 357A54BF6F8
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 12:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbiBVLIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 06:08:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231587AbiBVLI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 06:08:26 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2083.outbound.protection.outlook.com [40.107.243.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B282B65D5;
        Tue, 22 Feb 2022 03:07:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JMu0pnK54CIcNqzkmawTqfqoT8mvCqixI+R7rVpGd0stywXXX4q+f/hZaaNb9CswzQSGfBAi3q6mNdJthqpEYaJElO6ASVBPs3GsCLTLDBumK72uRQdONujWeKBnCtRXgjBONtM6+Da1D6qc3m5g+FtSYC6dR0SbWTYqh3oLFS+CHz6bjie3OGJ1MVwr9o5gnKJUlKCgHGc3hAljR29r7axyXT9bpgpb4KoPpWhycHNzxGoEDrI60uvYV3NCdvNmmu628a8J40rpAIQoHm51L5XcjnEz6PFm52kSz4eK3x5iELqLrA6rujZ7wIcSlYJgTF+3o7jI8307zUXb/Cedbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=khi9uD4NmylJHeLz7sizAo+rR7j8g1Zgjuih7WzIKqc=;
 b=oXC/doBBXAnlwSBOseaukd91hyL1j5ZIW0fzSie1fiwvFIEp5I07c754DXNd9YrCiZDPA9jrUjTd54dW0PFMZ79m7nhadURs79dejANlWDnIVXJs3QQ1a7txJG5X8kEQEu174icejZ2+FwsZ6y1sphkhGZTUdWVmv8oiSadTNlwx7NHIgyeBK0Qay1AOJ2n+wPhajY2rFYqoAituP1fXOQm6e7w2sgAQm+wPGiALOYx5XC2ko3hKeIWHLaPXgx56c0YHm4jOGFuRwOaZLnMiyTd+ckV7uIqlaCs3RI9WgWMn01HbccUlPusCKWeo/GGcNvQiN1MEPBEC+N/P28hIrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=khi9uD4NmylJHeLz7sizAo+rR7j8g1Zgjuih7WzIKqc=;
 b=SZujbqBC9PP+UQMKEo6Z6239UX8cEmYN69Ac+NO94mMTvVqazjuI5FlEGxYCtzLfZ+9gUwGXU/j6F27u6UzSsLGy/If1cmW84H8AUc4OfK41uLe7b6drHqdD3JmtafEs5wMG8Ia2HSdweuNE73YMp0DkeNlAv61Sr3WD/ugvjnWkaiburW4y8/keparJChhrt/CJQb/Jj55qSvQVBZ52F66voJzBpMBpiyxlM52pmHcGcIEz5IZKFlUVx15BySlRLuAF2g0bI/JFH6DRR4pO3y52UeoSSz++9o8M5FWZyhUNl3VJfP/kVHuiMdeIrHHXzCcOwHEJHO18mFXnREdgKg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MWHPR12MB1310.namprd12.prod.outlook.com (2603:10b6:300:a::21)
 by DM6PR12MB5552.namprd12.prod.outlook.com (2603:10b6:5:1bd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Tue, 22 Feb
 2022 11:07:45 +0000
Received: from MWHPR12MB1310.namprd12.prod.outlook.com
 ([fe80::5165:db44:70d5:1c2a]) by MWHPR12MB1310.namprd12.prod.outlook.com
 ([fe80::5165:db44:70d5:1c2a%11]) with mapi id 15.20.4995.027; Tue, 22 Feb
 2022 11:07:45 +0000
From:   Shay Drory <shayd@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     jiri@nvidia.com, saeedm@nvidia.com, parav@nvidia.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shay Drory <shayd@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next 4/4] net/mlx5: Support cpu_affinity devlink dev param
Date:   Tue, 22 Feb 2022 12:58:12 +0200
Message-Id: <20220222105812.18668-5-shayd@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20220222105812.18668-1-shayd@nvidia.com>
References: <20220222105812.18668-1-shayd@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM5PR0201CA0002.eurprd02.prod.outlook.com
 (2603:10a6:203:3d::12) To MWHPR12MB1310.namprd12.prod.outlook.com
 (2603:10b6:300:a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 406bf253-cafc-4536-e701-08d9f5f38dd7
X-MS-TrafficTypeDiagnostic: DM6PR12MB5552:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB5552DAD3A3BA112E14A4FE42CF3B9@DM6PR12MB5552.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nGPVw8tKpN4VLjSYQR5U47LCiKZ/YAEUaLg/0od+fji+k/RBR5Wa8RXpQYlfZoVZE2tOUcfuHJHZ/dmOSoRKKoTtk7tdHlqRJkvn/4PevpMveTLjAOc/+Yi/zkwBJuhTb7/SLZg7fCvtW0BAtJRy+UeSTKtfiB/OlMotjul1GxezTG4NcSfII9l3B2EFqJMjAClGs4qWIcUki/jQgb9hE12eU9NGuOCrW55jJiHXOd9FkVVqQEL4tEopYvQPWdb9WVxAKXxX4iGr3nbjVKjQIgBJRY4BTry/WGKX2L4qNDoSKkciRqqQaEodtyB7a5opGccgfS1M8lojz3vxV/UbP5Q+JxK1F26zSegotkzrD/XnWU/6yaLmztCoKUFv7E+tDldOTGAMtFsa+GW3AYT/AEnn5CFcZuAdf+HqFwps35u68kUR+lvJN5VF3ShQiQSACZEaEfktwvyuHx2IdmVaxzfb5YaK5VckiFJpTbaCJfmI7Q3E8Gs60d21G5/bySsjyGU/ZFQv9jSxAVNyBcoCRLaetwRDMe+A5kZX5xRF+Dq3EnhMSbBStrE5BfJJuESxx2mUTIEj72m6yNhhkZEuvtGFT5YIQPSxE81LXhXQHAJYXb488cq9lCXscTd2L1Zkqvss0m0eZZ3TfSs1RzC3g6MEnmzFKiGEH8l7/UoIRQKzJuenZUUSIsuLFa/WkqiqOva9MEX9vwPJRoS3OlxhKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1310.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38350700002)(38100700002)(36756003)(508600001)(30864003)(5660300002)(6486002)(86362001)(8936002)(316002)(54906003)(8676002)(66476007)(66556008)(4326008)(66946007)(1076003)(2616005)(107886003)(83380400001)(186003)(6666004)(6512007)(6506007)(52116002)(2906002)(110136005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RnBZNnM5eGJkSk9VcnVCSXBGbkgvLzEwWDFySFg2YldlaDZaaFJ6NjUzMTQx?=
 =?utf-8?B?UVZ0b3dxbnNzME1KeXgyLy81K1F3S0ZrNlhSRXFUTkVkQXhaZ0lmNnBhMDRI?=
 =?utf-8?B?NGd2UlBsTWZoMXJ3ZURjMDZoYTFVSTByY3N4Z3lib1NtdWlxYnFrWlJSY1NZ?=
 =?utf-8?B?eDR5cyswWkczSTQzUWFwY1c4dHczMWlwL3NIdFlaVzhxTnhqM2tiM1lpZGd1?=
 =?utf-8?B?T3paUGIxVUNIR01QYlluZ0FXcTQ4ZXVSOXVZSytzT3o2L3NhMTU0Vk96MWxG?=
 =?utf-8?B?TThrTEZQdm12QmlvUGNySHZ1M2t1M2MxdGJtSDc4NmNnSVFDR1VNRTlFSzcr?=
 =?utf-8?B?eEJjc3JvMUhMY0xDUVpCSXk4aFBhcklpOWZSc1Q0WGlReno2UTVCOWFQVlRX?=
 =?utf-8?B?SFA5clp3Y0Z3SFltemp0ZjVqSlVQU3ROK0Q4WFhPRmJRTXV2SjhBZDZDTEhr?=
 =?utf-8?B?SW9yWjRZY3NOYU5ZUm45S3dQVENzMktxcFdUTnIwWlRKRkhVKzdPVVZLN2Iv?=
 =?utf-8?B?SnZodzQ5S3Y0aUw1alR6bVlOQ2FGOGpnZjNJaExIUHpSYmhiWUxxVW9aK0Z3?=
 =?utf-8?B?OU1SWUErUVVDSFBKOGFqeVhCR3gxQ2VYZHpYM0UrZG9SZnp4UldZTHU3R0Vz?=
 =?utf-8?B?QkNvVWtEVzVtY04yTzFpZERvUVE3QmlZZGh2MHFBUUIrVWV4ZFlETU5CTkZn?=
 =?utf-8?B?eWszTTUxWmFFc2J2a3VlZUVDeVg0MW4remZZaXJqMys4eFlnaDY2cnppZmJW?=
 =?utf-8?B?SG9lRXQrYyttd1RDL1pRZ1ZZSGkwLzV4RHd2c2NUaWxzZ3NvTjZNM2FQZk9K?=
 =?utf-8?B?RDNXMGY3bEg0VkdJTDhsVGJmTE5yZUJsb3lzTHFHMHlxVDJoOGR6MHVEWHl0?=
 =?utf-8?B?RDA1eWRhZFY5cjR0SXowNUZERjdaQk1XSHZ5SE15SFJzNFRaREdHMXBLaFdw?=
 =?utf-8?B?RTJRK2NtK2tMZjRXYUVwbURTNDhaQTRxV2pXMzdGa2k0RzVKUE1TRTdvUjVi?=
 =?utf-8?B?cHBvcHBsSGZ6ZkJFWm81Q2JqTm0yV1hUZmtlZWMyVDg5N1lZOTRkMmdzejdz?=
 =?utf-8?B?YlpTdVhjZm5CQktQTnlwc3VPSXVuTEZpbitTZ0k4ZjlyWFZGSGZRWndvZnFF?=
 =?utf-8?B?anZFYlpub1g0QlpFWEtzT3l0L1d1ak1SY3poUzBCTGZaR3hKMXRubGduc0U2?=
 =?utf-8?B?b2tQWTgzanB6OHl6dmd1eWVMZXNlaUFHVC85OUFoSFY0RFF6YXhMY21kWm83?=
 =?utf-8?B?ZXJKTjFZVUczU0QxTmpMdGswSTFlb0QvSW9Db2s4c01zdnpUZWxxNlluTXdD?=
 =?utf-8?B?eS9CSjRiUnJXaHdvYlRsTVJsUUFlc1VLSFovTXhrcDRPVW1Mc2VqMG5yN2s0?=
 =?utf-8?B?T1JKUTRlUVJIdXBxcldFU1JiWTh1VGEzNWNVSmxaVk5RU2M0VEpEM29OUFRy?=
 =?utf-8?B?SnI3T3Ftai8wamgyNEFJb0JMb2N5L1JwL1NFOGxtOWNveHFoclExaWVra3M1?=
 =?utf-8?B?N3Q5aitKMDhmV0h4eXp4czFobkI5NWRadVFIQzFOam9PZEVZdi96NUVoQ1VQ?=
 =?utf-8?B?QzNnd0R4cXV3NmFjckUyTEdYZDRwWUNObzkvTG9CQUtKczQ2Q202emo1b1M4?=
 =?utf-8?B?cWZ4L2p4bkZDQmpwWHdHUjFGRFpUNFk0bUR4UFJoVkFBYjcrdzI5bVljcWRo?=
 =?utf-8?B?ZXM5RlRMRmFIcVVtOWQ0K0Ywak9SWi9kODU2VFRHZXF0T1o0NWxVTUlwMm1N?=
 =?utf-8?B?NUxmK25zbGF0eGhNb05DUE96dWxqZncwc09tNkF4TjFydGJLT0E0WHNqTUE4?=
 =?utf-8?B?Tk5wazMwUndaZ3Y5bm9LSnF4a0d2ZU0zNWV1a0o1QnptVTlUL0lTY3dsL2lL?=
 =?utf-8?B?TllnMHR6SjNwN1VjaVBHakJ3V1A5enRwRFBWSVBYWmptbWlXNS9wTjZPNjll?=
 =?utf-8?B?a0l2b1RMV2JQalpVNC9rUjI4MksvZkR1alFwb2crOU5MWUg2SXk0cW1BS2x5?=
 =?utf-8?B?Wm1RY0hzV1ppVllNOEpSTzBBWEZpS3Y5NE5yRitVelBWZXhnTjMycG5Edm00?=
 =?utf-8?B?V1ZzMmJOUkhSdmpGa0VudHF4bkhjNXhqOWVOOUxkUVRaS3dtbldFdDYwVjZ4?=
 =?utf-8?B?NGJhSFhieTlxUHJTVjhPNjhHanhaYmNzMGtlYTU5Z3dxeXV1R3JIUmdCTG9C?=
 =?utf-8?Q?yAopYMGDw2aM3SIXznJXi+k=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 406bf253-cafc-4536-e701-08d9f5f38dd7
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1310.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 11:07:45.7574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S+FzQt2I8VHN0WBkI2Qb4vFFGfczKxSSQyPx/IKM3q4G6KtHdokmPNk+Lg9i052YkOw4zgD21H1vwUgVe4c4fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5552
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable users to control the affinity of PCI Function.
The default value is the affinity assigned by kernel for the
PCI Function.
The runtime value shows the current affinity, the driverinit value
is used in order to set a new affinity on the next driver reload.
Setting empty affinity means kernel default policy.

Example:
- Show the current affinity.
    $ devlink dev param show auxiliary/mlx5_core.sf.4 name cpu_affinity
       name cpu_affinity type driver-specific
        values:
          cmode runtime value ff
          cmode driverinit value 0

- Set affinity to 3 (cpu 0 and cpu 1).
    $ devlink dev param set auxiliary/mlx5_core.sf.4 name cpu_affinity \
      value 3 cmode driverinit

Then run devlink reload command to apply the new value.
$ devlink dev reload auxiliary/mlx5_core.sf.4

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 Documentation/networking/devlink/mlx5.rst     |   3 +
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 123 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/devlink.h |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |  39 ++++++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +
 .../ethernet/mellanox/mlx5/core/mlx5_irq.h    |   5 +-
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c |  85 +++++++++++-
 7 files changed, 256 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/devlink/mlx5.rst b/Documentation/networking/devlink/mlx5.rst
index 29ad304e6fba..a213e93e495b 100644
--- a/Documentation/networking/devlink/mlx5.rst
+++ b/Documentation/networking/devlink/mlx5.rst
@@ -27,6 +27,9 @@ Parameters
    * - ``max_macs``
      - driverinit
      - The range is between 1 and 2^31. Only power of 2 values are supported.
+   * - ``cpu_affinity``
+     - driverinit | runtime
+     - empty affinity (0) means kernel assign the affinity
 
 The ``mlx5`` driver also implements the following driver-specific
 parameters.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index d1093bb2d436..9e33e8f7fed0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -10,6 +10,7 @@
 #include "esw/qos.h"
 #include "sf/dev/dev.h"
 #include "sf/sf.h"
+#include "mlx5_irq.h"
 
 static int mlx5_devlink_flash_update(struct devlink *devlink,
 				     struct devlink_flash_update_params *params,
@@ -833,6 +834,121 @@ mlx5_devlink_max_uc_list_param_unregister(struct devlink *devlink)
 	devlink_param_unregister(devlink, &max_uc_list_param);
 }
 
+static int mlx5_devlink_cpu_affinity_validate(struct devlink *devlink, u32 id,
+					      union devlink_param_value val,
+					      struct netlink_ext_ack *extack)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	cpumask_var_t tmp;
+	int max_eqs;
+	int ret = 0;
+	int last;
+
+	/* Check whether the mask is valid cpu mask */
+	last = find_last_bit(val.vbitmap, MLX5_CPU_AFFINITY_MAX_LEN);
+	if (last == MLX5_CPU_AFFINITY_MAX_LEN)
+		/* Affinity is empty, will use default policy*/
+		return 0;
+	if (last >= num_present_cpus()) {
+		NL_SET_ERR_MSG_MOD(extack, "Some CPUs aren't present");
+		return -ERANGE;
+	}
+
+	if (!zalloc_cpumask_var(&tmp, GFP_KERNEL))
+		return -ENOMEM;
+
+	bitmap_copy(cpumask_bits(tmp), val.vbitmap, nr_cpu_ids);
+	if (!cpumask_subset(tmp, cpu_online_mask)) {
+		NL_SET_ERR_MSG_MOD(extack, "Some CPUs aren't online");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* Check whether the PF/VF/SFs have enough IRQs. SF will
+	 * perform IRQ->CPU check during load time.
+	 */
+	if (mlx5_core_is_sf(dev))
+		max_eqs = min_t(int, MLX5_COMP_EQS_PER_SF,
+				mlx5_irq_table_get_sfs_vec(mlx5_irq_table_get(dev)));
+	else
+		max_eqs = mlx5_irq_table_get_num_comp(mlx5_irq_table_get(dev));
+	if (cpumask_weight(tmp) > max_eqs) {
+		NL_SET_ERR_MSG_MOD(extack, "PCI Function doesn’t have enough IRQs");
+		ret = -EINVAL;
+	}
+
+out:
+	free_cpumask_var(tmp);
+	return ret;
+}
+
+static int mlx5_devlink_cpu_affinity_set(struct devlink *devlink, u32 id,
+					 struct devlink_param_gset_ctx *ctx)
+{
+	/* Runtime set of cpu_affinity is not supported */
+	return -EOPNOTSUPP;
+}
+
+static int mlx5_devlink_cpu_affinity_get(struct devlink *devlink, u32 id,
+					 struct devlink_param_gset_ctx *ctx)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	cpumask_var_t dev_mask;
+
+	if (!zalloc_cpumask_var(&dev_mask, GFP_KERNEL))
+		return -ENOMEM;
+	mlx5_core_affinity_get(dev, dev_mask);
+	bitmap_copy(ctx->val.vbitmap, cpumask_bits(dev_mask), nr_cpu_ids);
+	free_cpumask_var(dev_mask);
+	return 0;
+}
+
+static const struct devlink_param cpu_affinity_param =
+	DEVLINK_PARAM_DYNAMIC_GENERIC(CPU_AFFINITY, BIT(DEVLINK_PARAM_CMODE_RUNTIME) |
+				      BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
+				      mlx5_devlink_cpu_affinity_get,
+				      mlx5_devlink_cpu_affinity_set,
+				      mlx5_devlink_cpu_affinity_validate,
+				      MLX5_CPU_AFFINITY_MAX_LEN);
+
+static int mlx5_devlink_cpu_affinity_param_register(struct devlink *devlink)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	union devlink_param_value value;
+	cpumask_var_t dev_mask;
+	int ret = 0;
+
+	if (mlx5_core_is_sf(dev) &&
+	    !mlx5_irq_table_have_dedicated_sfs_irqs(mlx5_irq_table_get(dev)))
+		return 0;
+
+	if (!zalloc_cpumask_var(&dev_mask, GFP_KERNEL))
+		return -ENOMEM;
+
+	ret = devlink_param_register(devlink, &cpu_affinity_param);
+	if (ret)
+		goto out;
+
+	value.vbitmap = cpumask_bits(dev_mask);
+	devlink_param_driverinit_value_set(devlink,
+					   DEVLINK_PARAM_GENERIC_ID_CPU_AFFINITY,
+					   value);
+out:
+	free_cpumask_var(dev_mask);
+	return ret;
+}
+
+static void mlx5_devlink_cpu_affinity_param_unregister(struct devlink *devlink)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+
+	if (mlx5_core_is_sf(dev) &&
+	    !mlx5_irq_table_have_dedicated_sfs_irqs(mlx5_irq_table_get(dev)))
+		return;
+
+	devlink_param_unregister(devlink, &cpu_affinity_param);
+}
+
 #define MLX5_TRAP_DROP(_id, _group_id)					\
 	DEVLINK_TRAP_GENERIC(DROP, DROP, _id,				\
 			     DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id, \
@@ -896,6 +1012,10 @@ int mlx5_devlink_register(struct devlink *devlink)
 	if (err)
 		goto max_uc_list_err;
 
+	err = mlx5_devlink_cpu_affinity_param_register(devlink);
+	if (err)
+		goto cpu_affinity_err;
+
 	err = mlx5_devlink_traps_register(devlink);
 	if (err)
 		goto traps_reg_err;
@@ -906,6 +1026,8 @@ int mlx5_devlink_register(struct devlink *devlink)
 	return 0;
 
 traps_reg_err:
+	mlx5_devlink_cpu_affinity_param_unregister(devlink);
+cpu_affinity_err:
 	mlx5_devlink_max_uc_list_param_unregister(devlink);
 max_uc_list_err:
 	mlx5_devlink_auxdev_params_unregister(devlink);
@@ -918,6 +1040,7 @@ int mlx5_devlink_register(struct devlink *devlink)
 void mlx5_devlink_unregister(struct devlink *devlink)
 {
 	mlx5_devlink_traps_unregister(devlink);
+	mlx5_devlink_cpu_affinity_param_unregister(devlink);
 	mlx5_devlink_max_uc_list_param_unregister(devlink);
 	mlx5_devlink_auxdev_params_unregister(devlink);
 	devlink_params_unregister(devlink, mlx5_devlink_params,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h b/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
index 30bf4882779b..891d4df419fe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
@@ -6,6 +6,8 @@
 
 #include <net/devlink.h>
 
+#define MLX5_CPU_AFFINITY_MAX_LEN (NR_CPUS)
+
 enum mlx5_devlink_param_id {
 	MLX5_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
 	MLX5_DEVLINK_PARAM_ID_FLOW_STEERING_MODE,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 48a45aa54a3c..9572c9f85f70 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -794,6 +794,30 @@ void mlx5_eq_update_ci(struct mlx5_eq *eq, u32 cc, bool arm)
 }
 EXPORT_SYMBOL(mlx5_eq_update_ci);
 
+static int comp_irqs_request_by_cpu_affinity(struct mlx5_core_dev *dev)
+{
+	struct mlx5_eq_table *table = dev->priv.eq_table;
+	struct devlink *devlink = priv_to_devlink(dev);
+	union devlink_param_value val;
+	cpumask_var_t user_mask;
+	int ret;
+
+	if (!zalloc_cpumask_var(&user_mask, GFP_KERNEL))
+		return -ENOMEM;
+
+	val.vbitmap = cpumask_bits(user_mask);
+	ret = devlink_param_driverinit_value_get(devlink,
+						 DEVLINK_PARAM_GENERIC_ID_CPU_AFFINITY,
+						 &val);
+	if (ret)
+		goto out;
+
+	ret = mlx5_irqs_request_mask(dev, table->comp_irqs, user_mask);
+out:
+	free_cpumask_var(user_mask);
+	return ret;
+}
+
 static void comp_irqs_release(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *table = dev->priv.eq_table;
@@ -817,6 +841,11 @@ static int comp_irqs_request(struct mlx5_core_dev *dev)
 	table->comp_irqs = kcalloc(ncomp_eqs, sizeof(*table->comp_irqs), GFP_KERNEL);
 	if (!table->comp_irqs)
 		return -ENOMEM;
+
+	ret = comp_irqs_request_by_cpu_affinity(dev);
+	if (ret > 0)
+		return ret;
+	mlx5_core_dbg(dev, "failed to get param cpu_affinity. use default policy\n");
 	if (mlx5_core_is_sf(dev)) {
 		ret = mlx5_irq_affinity_irqs_request_auto(dev, ncomp_eqs, table->comp_irqs);
 		if (ret < 0)
@@ -987,6 +1016,16 @@ mlx5_comp_irq_get_affinity_mask(struct mlx5_core_dev *dev, int vector)
 }
 EXPORT_SYMBOL(mlx5_comp_irq_get_affinity_mask);
 
+void mlx5_core_affinity_get(struct mlx5_core_dev *dev, struct cpumask *dev_mask)
+{
+	struct mlx5_eq_table *table = dev->priv.eq_table;
+	struct mlx5_eq_comp *eq, *n;
+
+	list_for_each_entry_safe(eq, n, &table->comp_eqs_list, list)
+		cpumask_or(dev_mask, dev_mask,
+			   mlx5_irq_get_affinity_mask(eq->core.irq));
+}
+
 #ifdef CONFIG_RFS_ACCEL
 struct cpu_rmap *mlx5_eq_table_get_rmap(struct mlx5_core_dev *dev)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 6f8baa0f2a73..95d133aa3fcd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -307,4 +307,6 @@ bool mlx5_rdma_supported(struct mlx5_core_dev *dev);
 bool mlx5_vnet_supported(struct mlx5_core_dev *dev);
 bool mlx5_same_hw_devs(struct mlx5_core_dev *dev, struct mlx5_core_dev *peer_dev);
 
+void mlx5_core_affinity_get(struct mlx5_core_dev *dev, struct cpumask *dev_mask);
+
 #endif /* __MLX5_CORE_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
index 23cb63fa4588..a31dc3d900af 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
@@ -16,6 +16,7 @@ int mlx5_irq_table_create(struct mlx5_core_dev *dev);
 void mlx5_irq_table_destroy(struct mlx5_core_dev *dev);
 int mlx5_irq_table_get_num_comp(struct mlx5_irq_table *table);
 int mlx5_irq_table_get_sfs_vec(struct mlx5_irq_table *table);
+bool mlx5_irq_table_have_dedicated_sfs_irqs(struct mlx5_irq_table *table);
 struct mlx5_irq_table *mlx5_irq_table_get(struct mlx5_core_dev *dev);
 
 int mlx5_set_msix_vec_count(struct mlx5_core_dev *dev, int devfn,
@@ -25,10 +26,12 @@ int mlx5_get_default_msix_vec_count(struct mlx5_core_dev *dev, int num_vfs);
 struct mlx5_irq *mlx5_ctrl_irq_request(struct mlx5_core_dev *dev);
 void mlx5_ctrl_irq_release(struct mlx5_irq *ctrl_irq);
 struct mlx5_irq *mlx5_irq_request(struct mlx5_core_dev *dev, u16 vecidx,
-				  struct cpumask *affinity);
+				  const struct cpumask *affinity);
 int mlx5_irqs_request_vectors(struct mlx5_core_dev *dev, u16 *cpus, int nirqs,
 			      struct mlx5_irq **irqs);
 void mlx5_irqs_release_vectors(struct mlx5_irq **irqs, int nirqs);
+int mlx5_irqs_request_mask(struct mlx5_core_dev *dev, struct mlx5_irq **irqs,
+			   struct cpumask *irqs_req_mask);
 int mlx5_irq_attach_nb(struct mlx5_irq *irq, struct notifier_block *nb);
 int mlx5_irq_detach_nb(struct mlx5_irq *irq, struct notifier_block *nb);
 struct cpumask *mlx5_irq_get_affinity_mask(struct mlx5_irq *irq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 41807ef55201..ed4e491ec9c0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -300,7 +300,7 @@ int mlx5_irq_get_index(struct mlx5_irq *irq)
 /* requesting an irq from a given pool according to given index */
 static struct mlx5_irq *
 irq_pool_request_vector(struct mlx5_irq_pool *pool, int vecidx,
-			struct cpumask *affinity)
+			const struct cpumask *affinity)
 {
 	struct mlx5_irq *irq;
 
@@ -420,7 +420,7 @@ struct mlx5_irq *mlx5_ctrl_irq_request(struct mlx5_core_dev *dev)
  * This function returns a pointer to IRQ, or ERR_PTR in case of error.
  */
 struct mlx5_irq *mlx5_irq_request(struct mlx5_core_dev *dev, u16 vecidx,
-				  struct cpumask *affinity)
+				  const struct cpumask *affinity)
 {
 	struct mlx5_irq_table *irq_table = mlx5_irq_table_get(dev);
 	struct mlx5_irq_pool *pool;
@@ -481,6 +481,82 @@ int mlx5_irqs_request_vectors(struct mlx5_core_dev *dev, u16 *cpus, int nirqs,
 	return i ? i : PTR_ERR(irq);
 }
 
+static int req_mask_local_spread(unsigned int i, int node,
+				 const struct cpumask *irqs_req_mask)
+{
+	int cpu;
+
+	if (node == NUMA_NO_NODE) {
+		for_each_cpu_and(cpu, cpu_online_mask, irqs_req_mask)
+			if (i-- == 0)
+				return cpu;
+	} else {
+		/* NUMA first. */
+		for_each_cpu_and(cpu, cpumask_of_node(node), irqs_req_mask)
+			if (cpu_online(cpu))
+				if (i-- == 0)
+					return cpu;
+
+		for_each_online_cpu(cpu) {
+			/* Skip NUMA nodes, done above. */
+			if (cpumask_test_cpu(cpu, cpumask_of_node(node)))
+				continue;
+
+			if (i-- == 0)
+				return cpu;
+		}
+	}
+	WARN_ON(true);
+	return cpumask_first(cpu_online_mask);
+}
+
+/**
+ * mlx5_irqs_request_mask - request one or more IRQs for mlx5 device.
+ * @dev: mlx5 device that is requesting the IRQs.
+ * @irqs: an output array of IRQs pointers.
+ * @irqs_req_mask: cpumask requested for these IRQs.
+ *
+ * Each IRQ is bounded to at most 1 CPU.
+ * This function returns the number of IRQs requested, (which might be smaller than
+ * cpumask_weight(@irqs_req_mask)), if successful, or a negative error code in
+ * case of an error.
+ */
+int mlx5_irqs_request_mask(struct mlx5_core_dev *dev, struct mlx5_irq **irqs,
+			   struct cpumask *irqs_req_mask)
+{
+	struct mlx5_irq_pool *pool = mlx5_irq_pool_get(dev);
+	struct mlx5_irq *irq;
+	int nirqs;
+	int cpu;
+	int i;
+
+	/* Request an IRQ for each online CPU in the given mask */
+	cpumask_and(irqs_req_mask, irqs_req_mask, cpu_online_mask);
+	nirqs = cpumask_weight(irqs_req_mask);
+	for (i = 0; i < nirqs; i++) {
+		/* Iterate over the mask the caller provided in numa aware fashion.
+		 * Local CPUs are requested first, followed by non-local ones.
+		 */
+		cpu = req_mask_local_spread(i, dev->priv.numa_node, irqs_req_mask);
+
+		if (mlx5_irq_pool_is_sf_pool(pool))
+			irq = mlx5_irq_affinity_request(pool, cpumask_of(cpu));
+		else
+			irq = mlx5_irq_request(dev, i, cpumask_of(cpu));
+		if (IS_ERR(irq)) {
+			if (!i)
+				return PTR_ERR(irq);
+			return i;
+		}
+		irqs[i] = irq;
+		mlx5_core_dbg(pool->dev, "IRQ %u mapped to cpu %*pbl, %u EQs on this irq\n",
+			      pci_irq_vector(dev->pdev, mlx5_irq_get_index(irq)),
+			      cpumask_pr_args(mlx5_irq_get_affinity_mask(irq)),
+			      mlx5_irq_read_locked(irq) / MLX5_EQ_REFS_PER_IRQ);
+	}
+	return i;
+}
+
 static struct mlx5_irq_pool *
 irq_pool_alloc(struct mlx5_core_dev *dev, int start, int size, char *name,
 	       u32 min_threshold, u32 max_threshold)
@@ -670,6 +746,11 @@ void mlx5_irq_table_destroy(struct mlx5_core_dev *dev)
 	pci_free_irq_vectors(dev->pdev);
 }
 
+bool mlx5_irq_table_have_dedicated_sfs_irqs(struct mlx5_irq_table *table)
+{
+	return table->sf_comp_pool;
+}
+
 int mlx5_irq_table_get_sfs_vec(struct mlx5_irq_table *table)
 {
 	if (table->sf_comp_pool)
-- 
2.21.3

