Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFB6350712E
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 16:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347213AbiDSO6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 10:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353717AbiDSO63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 10:58:29 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2087.outbound.protection.outlook.com [40.107.223.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E596828985
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 07:55:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nv/VbH7P9uule4oomVpDrv8+xKA24Xw2LXcWjUBBjD36QkRe9iuF3f1GEWl37Zj3WBsxdSs+ikognZQBdpeq5isM805KnOs+AwovGB5p0SpXdvqz/901VeUM/51y6zC1zlSQECP+G7q82VcGsJgHMWe2Tb2ud6XZkrpuyt4NBOs5C4em22z9zgfGCa6/Zq3SZvhc1ayEun2DCc8c2QcCDoyD7n31MTytFGRdfhDSnpN1lXtwOblgk4WeXyKVMoW1AkKEqPAuFIRW1bIPQofC//pAXZEnOAusEo01iVJBiakdaT3AjlJbt8EI98lFR+cohaWjiceR3y2OQZYCSoT2IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4JJXmPRgvsJh0n/ghYr4zzU3VnkBOtQIY9GOpbGVQCg=;
 b=mXeD9ubL930rxCf9uy7ZHK6l9iagEFx+1EgO/PoqFSBFSD3RWc3b7fC+ZxZ7sNacTyKbnU3+tQ6gvaXEm86YGBSDW7eZ+B0Rk+YbTYjEKzgWlBd11DDL/bzNtPuPowKyWbWIeeXM9vQ5fXUrFahoaC/cTC00NXr/BEQihCtBlVMaPUH/R7GETc74J4nq0Av9G4Bd1oe+c7T8bwIU7/JZvl4kHVE2CE2Mf4toPu6NhqD+LlaxfXYzZDzfcaHmaoyz2PIRSQDMkdFLSIaAAHqmroRIOWEztR7rjvxi9clrqD62lf73Qb0r1UVN1yqUGC0rYaCZEimMXLRvK4jMaHcHcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4JJXmPRgvsJh0n/ghYr4zzU3VnkBOtQIY9GOpbGVQCg=;
 b=hnf0RY6NKvOWKOkkmqXAdOAL+8mN5VbjQ2Xyu+tGNdk3kctl25AJbaSZ3XmHSlnZ81DFxlrgxM/zZul1Zc/zZJwaunHSqFl6MRbNrfzCcR2CDj8FEQBM+jj4TgS7J+eskg50mUKaYzM8i14pU6vAVq6OndqXGMV+42aOUCZvEq5k7JCQIqK4vPG5cD5LOfbYznmArP0EiX0OJi37l0WP73nWp5nsodi4843mZv47N+UGEVpREozQeQXS+5GyrApiDkO9mu+qE6S2Oky34o2uvVAB6EQ6whPX3Mu8L+VWjnieyPGctzE7Vg3wd3NaE5kMf03hTnhCWakV6tWLF2RVag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW3PR12MB4347.namprd12.prod.outlook.com (2603:10b6:303:2e::10)
 by BN6PR12MB1378.namprd12.prod.outlook.com (2603:10b6:404:1e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Tue, 19 Apr
 2022 14:55:45 +0000
Received: from MW3PR12MB4347.namprd12.prod.outlook.com
 ([fe80::9196:55b8:5355:f64d]) by MW3PR12MB4347.namprd12.prod.outlook.com
 ([fe80::9196:55b8:5355:f64d%2]) with mapi id 15.20.5186.013; Tue, 19 Apr 2022
 14:55:45 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        petrm@nvidia.com, jiri@nvidia.com, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 6/6] mlxsw: core_hwmon: Add interfaces for line card initialization and de-initialization
Date:   Tue, 19 Apr 2022 17:54:31 +0300
Message-Id: <20220419145431.2991382-7-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220419145431.2991382-1-idosch@nvidia.com>
References: <20220419145431.2991382-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR10CA0095.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::24) To MW3PR12MB4347.namprd12.prod.outlook.com
 (2603:10b6:303:2e::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7c278fd-fab2-4827-4840-08da2214ae51
X-MS-TrafficTypeDiagnostic: BN6PR12MB1378:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1378B9FD0D02613E1D81283AB2F29@BN6PR12MB1378.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: asTPGwtpE8fIGaA3onv2Fbgfy9p4a+rCGDyxgUYEy3AWDgH8JKiEjA3Jk47Foo3C4kDZXSWJTb8U5SsgGQ1kr2nQLPJF8bB4Ve1qO423fpZRgTj1m3WsRRT729F7ydahbAJ3LTkvFwvulovFmzQZhqk+H5pXEbXzB/dfQuTMblyHCWUt3nV+2Zua7rJnJ651PFOijM55x8uDyKNVR887RZ4wpGRVRG8kxvELALEYZWUkUj7AsG+nCwCxnuwhmVqVQA7vM2CgjTEGoTR7GSb3VodqA0etTTfY28WsxoQ5eXaWKuqsA6GWGRLVSxAgJLcsVMhtMPxwfGNZfWwTgwzQjn5T8JdKuFgXh/otj/98NBBjhJ5JPfPKIEuQs+ukaZOWL8mF8NMo8W4XI217ParH8Dnic2rMo048IyBhjSa4NwbsWktCRIOHzhx5o8bs4E98dDQ+GdANsB9h/273idG2oqwKn9X3Y0G8Ugu81dBybFhs30bGaYIsrurFM60QKAWLbjex/kO8uJARDagbIExwVI9ban+BhVjoZvEeNHR0IOD6uionRIzjd0MFjfwsrzwZNqirEiiwgZsdHQhKjIWZUJ1+NvrYNiZ0gH/cV0NHDNtHvEtg/Iu+vTE7THIZ9M31sGu7kp0nyhsLs2OxymJ1OA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4347.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(38100700002)(6486002)(508600001)(6666004)(8936002)(5660300002)(316002)(26005)(6512007)(8676002)(4326008)(66946007)(66556008)(186003)(66476007)(2906002)(6506007)(6916009)(2616005)(1076003)(107886003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lA+5wTcB5GFbgWUlK6Zj2JqpVNqYy8p5Ok6lhSH1hN9Uxcg1OdfR2aPDWnLn?=
 =?us-ascii?Q?Nx4/DIo3H2FgerMQIZDx8JypV8Nd4yo0FiAdD6WWb3TXudyNBawvvOJNdRdz?=
 =?us-ascii?Q?ip7a5Em6fvi1Loi09a4NlZRYvxhOSodjEzjJrj9Y1qgA9FQrYCo3BsBiS4As?=
 =?us-ascii?Q?E1i6uowbMbzvxJIzoH7dQ2JaS3Iap/jVFaPaS9PR085pBvONylt7zFsnmW5S?=
 =?us-ascii?Q?fFmDkfUNjP6oqN4Llldeyk8ip479pJ5t62pgLnGRwo4CPSZxioNtj4NsDFdM?=
 =?us-ascii?Q?FmPHIpJOLqPe2cVVoI7tuq6MWm6uOtbEfyuKzMFe39g+vY9WJ6kQGl0kMXF9?=
 =?us-ascii?Q?AQ3pECONIcNGzvlSQ38+Cq+lw1qDz5k3cxP+0l5bj8jSDJs5K5c0ZngwsS3G?=
 =?us-ascii?Q?k92RydGPCY6flUoz315v1/krFXlKHjuJeC+fJSmWE7VbLqZKlys2fxSo7uz8?=
 =?us-ascii?Q?m6uMb4dDb+VEUE27hhlBSkRkzU2KNdJu0cu/1RmXlOn9HNvtsmEg/H1S7vpG?=
 =?us-ascii?Q?XrIrZKV+rzBgkJ+IyL/VkvPhcJyqpbZmxJPj4jLxfOYS0AKzMRy2eGkLb/4v?=
 =?us-ascii?Q?nyGbxbRUfHCkx52ESXOjOeQeQqyJJZhkR+MivtVBvsYsGVhFnl60Q3q5nFm5?=
 =?us-ascii?Q?lVjIUYL1gVVoKCCdVuzr90CGMnLeNMOmIMRg88dS1iFPJqw39Fsrlm4ez7qy?=
 =?us-ascii?Q?dzdFkB7E9QN5JUQeGLNf92F11z96A8uHX0H3NctTxtDNnLa+cUeEYQZq/BsY?=
 =?us-ascii?Q?Dqk8Ne73hNL0E4n61gFBZ/uN2DgyGzxKHjHaIPmZ4O1O+nAL6eHUvxw3df5u?=
 =?us-ascii?Q?qO4pl9dH/T34BfvJxeOiBvkFTvbRwKSkCWkJzQ1uTY1Pcz2NOC6Wl78nDTQB?=
 =?us-ascii?Q?cNfKwGW4MlOW0pmtdjcYjtLyrMzF+MKSnMg0qGx9EQCmt65sFFArltpsU60c?=
 =?us-ascii?Q?KPZx5KvfQVB5zKGekmdOVUM9Vy+1Tvx4CEv3+XxNdlC2HZuxxXU4S6kRDm3R?=
 =?us-ascii?Q?lpU91rXxVL9YEKURzgrtvz9gKmgzbCqPMC1kI43R8vTpvg3F+h8HcHSxqGCg?=
 =?us-ascii?Q?Z0vytsW3JUSfnwwQL6bDPGFySXHJOtkg79XSqveHkhN+EC4e+knPZYTpslyb?=
 =?us-ascii?Q?CoKffeas0KsObXBTYcfemZ06shRDLAI3q12HRLOj5g4xYjq4sGTpQCIpbLbf?=
 =?us-ascii?Q?ScJnFqIMnGyNGsEyvV9s60V9kFT2FlwUXmGcZG8DLTDYvvsWAXi++pZgXjwu?=
 =?us-ascii?Q?lZkwL5Z98sSBPtYnpAmlPL7V46sTs3xiijRWa6MAldhUKO4i0IPZuDE6nFWr?=
 =?us-ascii?Q?vqgb9Okas/pgzlU2XtRO39+MJE5WE8fuRfb32ib3/igdbB0ZQYMFM1+6fifp?=
 =?us-ascii?Q?Ng6ooIy1z580zzD8kVw6P3yGthYWaL4K1et3d8HlCT+wgxz+geZMhWaPUTX5?=
 =?us-ascii?Q?sMuNzf8l0JC6eWobZBdfn+JxHxit5n5d/YUhol1PX0I1r+20fKbmo24/XqQf?=
 =?us-ascii?Q?yliDQOZTSJYLbTogo38znlCzY0HamzzBBgwXPQgqpImg09RxPNWRB90Twfu+?=
 =?us-ascii?Q?Ejb12PfeZlsU7j8TayzsveZpZdkqlETed9B9MTQG+vMQYWEedPgisqW0/ccf?=
 =?us-ascii?Q?yCCTNcttzzYH+Dq2qaX3+AgnL835iz6/fe1Y+tTkekKrBRvUMU+7X/FB2OfB?=
 =?us-ascii?Q?vCajG71Vo5a5N+mm0SGmoVKjtjySC7RHgYAzLvUvhfA8sSTDMGHK5oUYED7K?=
 =?us-ascii?Q?3O7XHpkW/w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7c278fd-fab2-4827-4840-08da2214ae51
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4347.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 14:55:44.8567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LE+JTBrEAJ7+cOK8JCCTzCGAAmn+Ri6ZaIjGA+CizneVgz5jMT8kLPtrTvcA+xVAbokLacJzvLhWugiMIijyng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1378
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

Add callback functions for line card 'hwmon' initialization and
de-initialization. Each line card is associated with the relevant
'hwmon' device, which may contain thermal attributes for the cages
and gearboxes found on this line card.

The line card 'hwmon' initialization / de-initialization APIs are to be
called when line card is set to active / inactive state by
got_active() / got_inactive() callbacks from line card state machine.

For example cage temperature for module #9 located at line card #7 will
be exposed by utility 'sensors' like:
linecard#07
front panel 009:	+32.0C  (crit = +70.0C, emerg = +80.0C)
And temperature for gearbox #3 located at line card #5 will be exposed
like:
linecard#05
gearbox 003:		+41.0C  (highest = +41.0C)

Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/core_hwmon.c  | 84 +++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
index fff6f248d6f7..70735068cf29 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
@@ -19,6 +19,7 @@
 #define MLXSW_HWMON_ATTR_PER_SENSOR 3
 #define MLXSW_HWMON_ATTR_PER_MODULE 7
 #define MLXSW_HWMON_ATTR_PER_GEARBOX 4
+#define MLXSW_HWMON_DEV_NAME_LEN_MAX 16
 
 #define MLXSW_HWMON_ATTR_COUNT (MLXSW_HWMON_SENSORS_MAX_COUNT * MLXSW_HWMON_ATTR_PER_SENSOR + \
 				MLXSW_HWMON_MODULES_MAX_COUNT * MLXSW_HWMON_ATTR_PER_MODULE + \
@@ -41,6 +42,7 @@ static int mlxsw_hwmon_get_attr_index(int index, int count)
 }
 
 struct mlxsw_hwmon_dev {
+	char name[MLXSW_HWMON_DEV_NAME_LEN_MAX];
 	struct mlxsw_hwmon *hwmon;
 	struct device *hwmon_dev;
 	struct attribute_group group;
@@ -51,6 +53,7 @@ struct mlxsw_hwmon_dev {
 	u8 sensor_count;
 	u8 module_sensor_max;
 	u8 slot_index;
+	bool active;
 };
 
 struct mlxsw_hwmon {
@@ -780,6 +783,75 @@ static int mlxsw_hwmon_gearbox_init(struct mlxsw_hwmon_dev *mlxsw_hwmon_dev)
 	return 0;
 }
 
+static void
+mlxsw_hwmon_got_active(struct mlxsw_core *mlxsw_core, u8 slot_index,
+		       void *priv)
+{
+	struct mlxsw_hwmon *hwmon = priv;
+	struct mlxsw_hwmon_dev *linecard;
+	struct device *dev;
+	int err;
+
+	dev = hwmon->bus_info->dev;
+	linecard = &hwmon->line_cards[slot_index];
+	if (linecard->active)
+		return;
+	/* For the main board, module sensor indexes start from 1, sensor index
+	 * 0 is used for the ASIC. Use the same numbering for line cards.
+	 */
+	linecard->sensor_count = 1;
+	linecard->slot_index = slot_index;
+	linecard->hwmon = hwmon;
+	err = mlxsw_hwmon_module_init(linecard);
+	if (err) {
+		dev_err(dev, "Failed to configure hwmon objects for line card modules in slot %d\n",
+			slot_index);
+		return;
+	}
+
+	err = mlxsw_hwmon_gearbox_init(linecard);
+	if (err) {
+		dev_err(dev, "Failed to configure hwmon objects for line card gearboxes in slot %d\n",
+			slot_index);
+		return;
+	}
+
+	linecard->groups[0] = &linecard->group;
+	linecard->group.attrs = linecard->attrs;
+	sprintf(linecard->name, "%s#%02u", "linecard", slot_index);
+	linecard->hwmon_dev =
+		hwmon_device_register_with_groups(dev, linecard->name,
+						  linecard, linecard->groups);
+	if (IS_ERR(linecard->hwmon_dev)) {
+		dev_err(dev, "Failed to register hwmon objects for line card in slot %d\n",
+			slot_index);
+		return;
+	}
+
+	linecard->active = true;
+}
+
+static void
+mlxsw_hwmon_got_inactive(struct mlxsw_core *mlxsw_core, u8 slot_index,
+			 void *priv)
+{
+	struct mlxsw_hwmon *hwmon = priv;
+	struct mlxsw_hwmon_dev *linecard;
+
+	linecard = &hwmon->line_cards[slot_index];
+	if (!linecard->active)
+		return;
+	linecard->active = false;
+	hwmon_device_unregister(linecard->hwmon_dev);
+	/* Reset attributes counter */
+	linecard->attrs_count = 0;
+}
+
+static struct mlxsw_linecards_event_ops mlxsw_hwmon_event_ops = {
+	.got_active = mlxsw_hwmon_got_active,
+	.got_inactive = mlxsw_hwmon_got_inactive,
+};
+
 int mlxsw_hwmon_init(struct mlxsw_core *mlxsw_core,
 		     const struct mlxsw_bus_info *mlxsw_bus_info,
 		     struct mlxsw_hwmon **p_hwmon)
@@ -836,10 +908,19 @@ int mlxsw_hwmon_init(struct mlxsw_core *mlxsw_core,
 		goto err_hwmon_register;
 	}
 
+	err = mlxsw_linecards_event_ops_register(mlxsw_hwmon->core,
+						 &mlxsw_hwmon_event_ops,
+						 mlxsw_hwmon);
+	if (err)
+		goto err_linecards_event_ops_register;
+
 	mlxsw_hwmon->line_cards[0].hwmon_dev = hwmon_dev;
+	mlxsw_hwmon->line_cards[0].active = true;
 	*p_hwmon = mlxsw_hwmon;
 	return 0;
 
+err_linecards_event_ops_register:
+	hwmon_device_unregister(mlxsw_hwmon->line_cards[0].hwmon_dev);
 err_hwmon_register:
 err_temp_gearbox_init:
 err_temp_module_init:
@@ -851,6 +932,9 @@ int mlxsw_hwmon_init(struct mlxsw_core *mlxsw_core,
 
 void mlxsw_hwmon_fini(struct mlxsw_hwmon *mlxsw_hwmon)
 {
+	mlxsw_hwmon->line_cards[0].active = false;
+	mlxsw_linecards_event_ops_unregister(mlxsw_hwmon->core,
+					     &mlxsw_hwmon_event_ops, mlxsw_hwmon);
 	hwmon_device_unregister(mlxsw_hwmon->line_cards[0].hwmon_dev);
 	kfree(mlxsw_hwmon);
 }
-- 
2.33.1

