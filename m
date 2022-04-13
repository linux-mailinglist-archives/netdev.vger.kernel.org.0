Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABF6A4FF9DD
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 17:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236266AbiDMPVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 11:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236241AbiDMPVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 11:21:17 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2073.outbound.protection.outlook.com [40.107.220.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668012E9E3
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 08:18:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NwOfay1z1Sb+VKVAt3UF2F90cfjrKvsKZwyrPdSqLY91oAj5qLDHLvmNPTGTb0TVj0KDbAiIINF6JR1OmHM8QkjfUumKXWSDb4hwlx5JweIxKbeaOwhY1vBQOFRCuYEA2IXbD0RVQkK48DV9n7k20ICHH3xGG6i3QgMCf5g/AmwwDXR8VibdrwJcNY8FclarTVddy1X6ppsf/dI/M6ZDGqF8De1nZvD+gzQ0pf+I7viTtRlPD6Bkm/+g98hdY5Ox/pqOcpUhIawcgAa9oQI7IuwvZn+tMWKNOSTyRcnK3BzeU9Tvmb9zilaUZducDCdGo1JPQmE44XoOmiTfVXbvKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qSFm1+A0v57iVhq8p/599hsbHo8atLSb+JxgrqjJa50=;
 b=cVB/LgY9DZ0qxNpGhtedQ0SBDxZkqOj5Bv3kDLTvoEDpCZ14+HHigsZmjM6rdPYnw6tntg5BoFzC0GIIpIM5Mx/Z846pPlcV/l1pRh+vOBD81yvVwX/iDz5AHo3SpfD/jRJVkWDHd/Ggq7jxkywXpdex5gKsxksTWYx1Naa/wyl3RcNU4pwE2BFyYT6v1WSJfsZZuhEahz2KiSN4imAgqF+GqveZpv0uI8K4ZcdPJg23jzDZsa8zphBT4hr5gNpxDbYof4SKdTZLoAVd8WdVS99zP0oMEm+Z4iuDn5d+IBt6LWvGkKg3hKSN7NoymkRCeettCzZBu7g4EsZJlkpJIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qSFm1+A0v57iVhq8p/599hsbHo8atLSb+JxgrqjJa50=;
 b=bQDtHzavoKw3S5rDp+IPICoJ8lzPiKOU6sICV5bNpNtFIpPg694AlhV8m94PFMHH7S2oHORQBZt6mLr7CTJpTrNp46PszwF74pKqHkqAy5DBjBaxmNXwq+qs32xiezJkNbuk4IWl6JhVzx4KYO3JBtqJFoujiIUANPScNSYjdR70EYQSF3o2ivnEm5GaJamgHJQT4WTFFlPBQ3SuMHW9+5ghw/RNOkqWoG7KpjKgI3bq9rAyFZgmyl1MQf9Y2jPKMSAoUfeVT4ViP0TvNZz0hG3wLZIGaQ2ehs/dU7eMkHzG07oiWwJX2H88oq+QjbZZjGpiz7ElWzStp3bLV6FsfQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by MN2PR12MB3279.namprd12.prod.outlook.com (2603:10b6:208:105::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Wed, 13 Apr
 2022 15:18:35 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402%5]) with mapi id 15.20.5144.029; Wed, 13 Apr 2022
 15:18:35 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        petrm@nvidia.com, vadimp@nvidia.com, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/9] mlxsw: core_hwmon: Extend internal structures to support multi hwmon objects
Date:   Wed, 13 Apr 2022 18:17:28 +0300
Message-Id: <20220413151733.2738867-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220413151733.2738867-1-idosch@nvidia.com>
References: <20220413151733.2738867-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0185.eurprd09.prod.outlook.com
 (2603:10a6:800:120::39) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 048d4b88-c6c6-4e76-977f-08da1d60e0bc
X-MS-TrafficTypeDiagnostic: MN2PR12MB3279:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3279C9CD8C1FD0EF5EDEFA5BB2EC9@MN2PR12MB3279.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3JqSwR3iT2c++g/9L26rkWZGtFASNGYQe2Bw2MAkXBmREwePpPyX4YgOFtFAaK+tAXxJQvcks3NAMNRp3PefiCMXTOMr2La+2XPI8tK1POZEOubpvCB/FfwavAxLYJuidQSwXBHsHUHyDJSEEybnYFubvDpRdTf4V42G9aLQdXbCJdGjOap9XFbhogEUmdGpSiYAzbnRTrQj57ApyY04CZk0fnu6qDdC4WdKZq8lDdpmzUQb1YJKFbEdur3UdO1fH9cqJdMj1/ZLeIB3dDlKdWN3jjl4tRCHccrdNJKBntoPO+GJ717uu1ya8FM8ph262KNXu9bWgrevVAJG2dqoh44O31NkUbdLHUbue5NGAFADtyDdGMAp0dWGoarBv1UBfeUwvpNo+eHqbF+JhKxQXk11xIRqvlU2zj7jYgdGogzBmFr/EfEbdHmJa1F+s0s2a8jyRl1o9j4Nfpr2syC2rEFgP9P9qSMLfePNfZSFYWIZg99gOu0D3cRgRVdplGy8Sg36M9+YgpBpmJR66PQQ4Zs7llwIlKBs1tauoye4nAwXdObajP187Z4LM2nC3JAFtGRk3A3yt7t+ugCwkjA5CNWumXO0Bb7u2UHiSFSaHUJzaTcXSPHOXtuy0Mgl9HU/aHFnhkmmMhvurdvU+uHPEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(8936002)(508600001)(186003)(26005)(107886003)(1076003)(2906002)(38100700002)(83380400001)(86362001)(36756003)(6506007)(2616005)(66476007)(66556008)(6666004)(30864003)(4326008)(8676002)(6916009)(6512007)(316002)(6486002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IZ+qAPInvCalhjX8E82BADH015P6nre31RxY6eDuacTPlzdmfRuBTqwnQDrX?=
 =?us-ascii?Q?J+ouVGQfZfitpqR5Vqc/VaOOjIRwfOwxSpWvopSnmXAxBTKHtP1bk+WMpxOn?=
 =?us-ascii?Q?G77NbKGlej+Dq4AuvgRyTNhRp3NoXwqPSGAlKE2ljBkHVqryxdzIpATd954k?=
 =?us-ascii?Q?f92hDckSYli6b3xrhyJ1UHlvOqrVIVVaoJsfu5YGgyk1lC/KF0Dmyp2yZ79P?=
 =?us-ascii?Q?O2azFpgd25hBUsYPD1ALqzUPEm4xoUeWrQTChPEl3vuHTAYaD0gjcBh8PtbN?=
 =?us-ascii?Q?PR14UAYCSLsuy3BrqQl8e3Ix0NP0FVw1eReB3dThCyGP7Ktn9zAnto0HnDEf?=
 =?us-ascii?Q?PpUshbFntCh6IdORWtenCfOA0oYtglKSdDc/fywRmBMJZ28dEk0IlQhOEIgG?=
 =?us-ascii?Q?SdIKvp6Bt3rdqlFg95UemvMANIQT9Wdb2DCDYIEw0KznjetHG7EXQ9tLaxOT?=
 =?us-ascii?Q?7exTcmuWSJvnIMyIDhedtuBHvDWxQX7I30bsDca6JNGJ+uXa682GOMZ30cv9?=
 =?us-ascii?Q?gw7rQ4/OD9Kvcfja2kbcakYIzrAx2vmTGRIhLgsHiFgPku7LBtL1V2mBYw7f?=
 =?us-ascii?Q?aJmP6B4Ng9qW6rzuh919LuOHm3t84K7tBr6IYqVOsEr4hO/vQIQmh17qXkvn?=
 =?us-ascii?Q?Fi+C29kNsBVWS+OCZLvo7Jqo4qE85S7qrHccYpDi8jjbU71VhPI5n/YOhg0e?=
 =?us-ascii?Q?z+XSvanvdPBWOn5kHMaxkgvyhFKpeLxYipA0KITRYnb7Wv/0ociHvSvY6UG7?=
 =?us-ascii?Q?oDwQmi2GHyi/XnR9vYt2QA5LpjDN3zbFxPQOoDZpPXKJWrOTBM2/YbAwHUFE?=
 =?us-ascii?Q?ksM18FKcqvmgUTQkxXx1xS72aEA/g5Vk/7aobiy1P7u6TkbglLbuuEr8hqqN?=
 =?us-ascii?Q?9N8anaY2GdcA6KInqLeEa5K77HzMtOIPMLof7xcfhG9Hyn7oCny0rtwfJtrL?=
 =?us-ascii?Q?1w8YEWk+bhX821MYSJ0tPF5LenS+yB9M/Cm9vfyYSnmVj8MzhWodJmpgpQdp?=
 =?us-ascii?Q?MvZZaZ/dVl3hjE85s1TOrA8Mr0ZP6jFadKAMJLrvcTUxKwyNM6+evpWMiqQ0?=
 =?us-ascii?Q?kovE6c6g+3CucNjv6io8nKH1ue2u28HmdPgnE4m5hd7NkL9kggUbj2QSTp3A?=
 =?us-ascii?Q?J54K5rVODgXbQ0SHipx1yUk03rLxDHhVwyUrqHTWYOf7aT/3c419ndroZCxi?=
 =?us-ascii?Q?1zjIExyMv3tdxa/a1Ab8liD8XceKO3qjjJDKBlF1942bgpH+gZ56VZGBJEqf?=
 =?us-ascii?Q?bq6lGqjsrxbzBO9+viTGb890eHicaRsqyUGbm2ciUnShSgV4qWL2f4bMukzm?=
 =?us-ascii?Q?AL9SmMWwLedt5aWfTTj9DGBgwnMa9rBMcCxV7fl2UreRZL16XeaNvWUyiIi4?=
 =?us-ascii?Q?zY3q+l3AFmSiURABjnl5RWe1UVexjqpI/TNFetu8D/xxh8RrRljYHBQ79gn1?=
 =?us-ascii?Q?HEuizeeVybrgIIEFbSc/TBljzztVNWMcwphSSlR3jLOxGI/yjYfwpMGDnRhj?=
 =?us-ascii?Q?fQJ0+I3dn361hCNi0z40Mi0v7GWVU1FakTuHQticirV0NKz/pc1ohCmID4Nx?=
 =?us-ascii?Q?ESTucp2iaBkNFe5w75jRha+u7mGu/76fuH/9uHs5MCnEsJV2zptoaRF1Of1W?=
 =?us-ascii?Q?Puat9mFyL3WW4scTu9c7/C9Ai2lmVsNOMMiixpY6W3QMMWIWDRxvNIvm8i1G?=
 =?us-ascii?Q?kg1FA0+8wj1OcbIE5F0OvRSVNUX2XorGYTod70bAco0yf57JVnP2DyJ3LZ4C?=
 =?us-ascii?Q?kI0LNg4e8g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 048d4b88-c6c6-4e76-977f-08da1d60e0bc
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 15:18:35.3211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iJ5fZK1aGoOkGZUYbGuHUmuS+xhlLZWZQSfaG6abaUHEmp6Ha56mRXPQHtIkNZm6hMAothEY4O6mJcaOkZkX2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3279
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

Currently, mlxsw supports a single hwmon device and registers it with
attributes corresponding to the various objects found on the main
board such as fans and gearboxes.

Line cards can have the same objects, but unlike the main board they
can be added and removed while the system is running. The various
hwmon objects found on these line cards should be created when the
line card becomes available and destroyed when the line card becomes
unavailable.

The above can be achieved by representing each line card as a
different hwmon device and registering / unregistering it when the
line card becomes available / unavailable.

Prepare for multi hwmon device support by splitting
'struct mlxsw_hwmon' into 'struct mlxsw_hwmon' and
'struct mlxsw_hwmon_dev'. The first will hold information relevant to
all hwmon devices, whereas the second will hold per-hwmon device
information.

Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/core_hwmon.c  | 187 +++++++++++-------
 1 file changed, 111 insertions(+), 76 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
index 5df54a5bf292..d35aa135beed 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
@@ -27,7 +27,7 @@
 
 struct mlxsw_hwmon_attr {
 	struct device_attribute dev_attr;
-	struct mlxsw_hwmon *hwmon;
+	struct mlxsw_hwmon_dev *mlxsw_hwmon_dev;
 	unsigned int type_index;
 	char name[32];
 };
@@ -40,9 +40,8 @@ static int mlxsw_hwmon_get_attr_index(int index, int count)
 	return index;
 }
 
-struct mlxsw_hwmon {
-	struct mlxsw_core *core;
-	const struct mlxsw_bus_info *bus_info;
+struct mlxsw_hwmon_dev {
+	struct mlxsw_hwmon *hwmon;
 	struct device *hwmon_dev;
 	struct attribute_group group;
 	const struct attribute_group *groups[2];
@@ -53,19 +52,26 @@ struct mlxsw_hwmon {
 	u8 module_sensor_max;
 };
 
+struct mlxsw_hwmon {
+	struct mlxsw_core *core;
+	const struct mlxsw_bus_info *bus_info;
+	struct mlxsw_hwmon_dev line_cards[];
+};
+
 static ssize_t mlxsw_hwmon_temp_show(struct device *dev,
 				     struct device_attribute *attr,
 				     char *buf)
 {
 	struct mlxsw_hwmon_attr *mlxsw_hwmon_attr =
 			container_of(attr, struct mlxsw_hwmon_attr, dev_attr);
-	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_attr->hwmon;
+	struct mlxsw_hwmon_dev *mlxsw_hwmon_dev = mlxsw_hwmon_attr->mlxsw_hwmon_dev;
+	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_dev->hwmon;
 	char mtmp_pl[MLXSW_REG_MTMP_LEN];
 	int temp, index;
 	int err;
 
 	index = mlxsw_hwmon_get_attr_index(mlxsw_hwmon_attr->type_index,
-					   mlxsw_hwmon->module_sensor_max);
+					   mlxsw_hwmon_dev->module_sensor_max);
 	mlxsw_reg_mtmp_pack(mtmp_pl, 0, index, false, false);
 	err = mlxsw_reg_query(mlxsw_hwmon->core, MLXSW_REG(mtmp), mtmp_pl);
 	if (err) {
@@ -82,13 +88,14 @@ static ssize_t mlxsw_hwmon_temp_max_show(struct device *dev,
 {
 	struct mlxsw_hwmon_attr *mlxsw_hwmon_attr =
 			container_of(attr, struct mlxsw_hwmon_attr, dev_attr);
-	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_attr->hwmon;
+	struct mlxsw_hwmon_dev *mlxsw_hwmon_dev = mlxsw_hwmon_attr->mlxsw_hwmon_dev;
+	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_dev->hwmon;
 	char mtmp_pl[MLXSW_REG_MTMP_LEN];
 	int temp_max, index;
 	int err;
 
 	index = mlxsw_hwmon_get_attr_index(mlxsw_hwmon_attr->type_index,
-					   mlxsw_hwmon->module_sensor_max);
+					   mlxsw_hwmon_dev->module_sensor_max);
 	mlxsw_reg_mtmp_pack(mtmp_pl, 0, index, false, false);
 	err = mlxsw_reg_query(mlxsw_hwmon->core, MLXSW_REG(mtmp), mtmp_pl);
 	if (err) {
@@ -105,8 +112,9 @@ static ssize_t mlxsw_hwmon_temp_rst_store(struct device *dev,
 {
 	struct mlxsw_hwmon_attr *mlxsw_hwmon_attr =
 			container_of(attr, struct mlxsw_hwmon_attr, dev_attr);
-	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_attr->hwmon;
-	char mtmp_pl[MLXSW_REG_MTMP_LEN] = {0};
+	struct mlxsw_hwmon_dev *mlxsw_hwmon_dev = mlxsw_hwmon_attr->mlxsw_hwmon_dev;
+	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_dev->hwmon;
+	char mtmp_pl[MLXSW_REG_MTMP_LEN];
 	unsigned long val;
 	int index;
 	int err;
@@ -118,7 +126,7 @@ static ssize_t mlxsw_hwmon_temp_rst_store(struct device *dev,
 		return -EINVAL;
 
 	index = mlxsw_hwmon_get_attr_index(mlxsw_hwmon_attr->type_index,
-					   mlxsw_hwmon->module_sensor_max);
+					   mlxsw_hwmon_dev->module_sensor_max);
 
 	mlxsw_reg_mtmp_sensor_index_set(mtmp_pl, index);
 	err = mlxsw_reg_query(mlxsw_hwmon->core, MLXSW_REG(mtmp), mtmp_pl);
@@ -140,7 +148,8 @@ static ssize_t mlxsw_hwmon_fan_rpm_show(struct device *dev,
 {
 	struct mlxsw_hwmon_attr *mlxsw_hwmon_attr =
 			container_of(attr, struct mlxsw_hwmon_attr, dev_attr);
-	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_attr->hwmon;
+	struct mlxsw_hwmon_dev *mlxsw_hwmon_dev = mlxsw_hwmon_attr->mlxsw_hwmon_dev;
+	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_dev->hwmon;
 	char mfsm_pl[MLXSW_REG_MFSM_LEN];
 	int err;
 
@@ -159,7 +168,8 @@ static ssize_t mlxsw_hwmon_fan_fault_show(struct device *dev,
 {
 	struct mlxsw_hwmon_attr *mlxsw_hwmon_attr =
 			container_of(attr, struct mlxsw_hwmon_attr, dev_attr);
-	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_attr->hwmon;
+	struct mlxsw_hwmon_dev *mlxsw_hwmon_dev = mlxsw_hwmon_attr->mlxsw_hwmon_dev;
+	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_dev->hwmon;
 	char fore_pl[MLXSW_REG_FORE_LEN];
 	bool fault;
 	int err;
@@ -180,7 +190,8 @@ static ssize_t mlxsw_hwmon_pwm_show(struct device *dev,
 {
 	struct mlxsw_hwmon_attr *mlxsw_hwmon_attr =
 			container_of(attr, struct mlxsw_hwmon_attr, dev_attr);
-	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_attr->hwmon;
+	struct mlxsw_hwmon_dev *mlxsw_hwmon_dev = mlxsw_hwmon_attr->mlxsw_hwmon_dev;
+	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_dev->hwmon;
 	char mfsc_pl[MLXSW_REG_MFSC_LEN];
 	int err;
 
@@ -200,7 +211,8 @@ static ssize_t mlxsw_hwmon_pwm_store(struct device *dev,
 {
 	struct mlxsw_hwmon_attr *mlxsw_hwmon_attr =
 			container_of(attr, struct mlxsw_hwmon_attr, dev_attr);
-	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_attr->hwmon;
+	struct mlxsw_hwmon_dev *mlxsw_hwmon_dev = mlxsw_hwmon_attr->mlxsw_hwmon_dev;
+	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_dev->hwmon;
 	char mfsc_pl[MLXSW_REG_MFSC_LEN];
 	unsigned long val;
 	int err;
@@ -226,12 +238,13 @@ static int mlxsw_hwmon_module_temp_get(struct device *dev,
 {
 	struct mlxsw_hwmon_attr *mlxsw_hwmon_attr =
 			container_of(attr, struct mlxsw_hwmon_attr, dev_attr);
-	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_attr->hwmon;
+	struct mlxsw_hwmon_dev *mlxsw_hwmon_dev = mlxsw_hwmon_attr->mlxsw_hwmon_dev;
+	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_dev->hwmon;
 	char mtmp_pl[MLXSW_REG_MTMP_LEN];
 	u8 module;
 	int err;
 
-	module = mlxsw_hwmon_attr->type_index - mlxsw_hwmon->sensor_count;
+	module = mlxsw_hwmon_attr->type_index - mlxsw_hwmon_dev->sensor_count;
 	mlxsw_reg_mtmp_pack(mtmp_pl, 0,
 			    MLXSW_REG_MTMP_MODULE_INDEX_MIN + module, false,
 			    false);
@@ -264,15 +277,16 @@ static ssize_t mlxsw_hwmon_module_temp_fault_show(struct device *dev,
 {
 	struct mlxsw_hwmon_attr *mlxsw_hwmon_attr =
 			container_of(attr, struct mlxsw_hwmon_attr, dev_attr);
-	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_attr->hwmon;
+	struct mlxsw_hwmon_dev *mlxsw_hwmon_dev = mlxsw_hwmon_attr->mlxsw_hwmon_dev;
+	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_dev->hwmon;
 	char mtbr_pl[MLXSW_REG_MTBR_LEN] = {0};
 	u8 module, fault;
 	u16 temp;
 	int err;
 
-	module = mlxsw_hwmon_attr->type_index - mlxsw_hwmon->sensor_count;
-	mlxsw_reg_mtbr_pack(mtbr_pl, 0,
-			    MLXSW_REG_MTBR_BASE_MODULE_INDEX + module, 1);
+	module = mlxsw_hwmon_attr->type_index - mlxsw_hwmon_dev->sensor_count;
+	mlxsw_reg_mtbr_pack(mtbr_pl, 0, MLXSW_REG_MTBR_BASE_MODULE_INDEX + module,
+			    1);
 	err = mlxsw_reg_query(mlxsw_hwmon->core, MLXSW_REG(mtbr), mtbr_pl);
 	if (err) {
 		dev_err(dev, "Failed to query module temperature sensor\n");
@@ -306,11 +320,12 @@ static int mlxsw_hwmon_module_temp_critical_get(struct device *dev,
 {
 	struct mlxsw_hwmon_attr *mlxsw_hwmon_attr =
 			container_of(attr, struct mlxsw_hwmon_attr, dev_attr);
-	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_attr->hwmon;
+	struct mlxsw_hwmon_dev *mlxsw_hwmon_dev = mlxsw_hwmon_attr->mlxsw_hwmon_dev;
+	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_dev->hwmon;
 	u8 module;
 	int err;
 
-	module = mlxsw_hwmon_attr->type_index - mlxsw_hwmon->sensor_count;
+	module = mlxsw_hwmon_attr->type_index - mlxsw_hwmon_dev->sensor_count;
 	err = mlxsw_env_module_temp_thresholds_get(mlxsw_hwmon->core, 0,
 						   module, SFP_TEMP_HIGH_WARN,
 						   p_temp);
@@ -341,11 +356,12 @@ static int mlxsw_hwmon_module_temp_emergency_get(struct device *dev,
 {
 	struct mlxsw_hwmon_attr *mlxsw_hwmon_attr =
 			container_of(attr, struct mlxsw_hwmon_attr, dev_attr);
-	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_attr->hwmon;
+	struct mlxsw_hwmon_dev *mlxsw_hwmon_dev = mlxsw_hwmon_attr->mlxsw_hwmon_dev;
+	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_dev->hwmon;
 	u8 module;
 	int err;
 
-	module = mlxsw_hwmon_attr->type_index - mlxsw_hwmon->sensor_count;
+	module = mlxsw_hwmon_attr->type_index - mlxsw_hwmon_dev->sensor_count;
 	err = mlxsw_env_module_temp_thresholds_get(mlxsw_hwmon->core, 0,
 						   module, SFP_TEMP_HIGH_ALARM,
 						   p_temp);
@@ -390,9 +406,9 @@ mlxsw_hwmon_gbox_temp_label_show(struct device *dev,
 {
 	struct mlxsw_hwmon_attr *mlxsw_hwmon_attr =
 			container_of(attr, struct mlxsw_hwmon_attr, dev_attr);
-	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_attr->hwmon;
+	struct mlxsw_hwmon_dev *mlxsw_hwmon_dev = mlxsw_hwmon_attr->mlxsw_hwmon_dev;
 	int index = mlxsw_hwmon_attr->type_index -
-		    mlxsw_hwmon->module_sensor_max + 1;
+		    mlxsw_hwmon_dev->module_sensor_max + 1;
 
 	return sprintf(buf, "gearbox %03u\n", index);
 }
@@ -461,14 +477,15 @@ enum mlxsw_hwmon_attr_type {
 	MLXSW_HWMON_ATTR_TYPE_TEMP_EMERGENCY_ALARM,
 };
 
-static void mlxsw_hwmon_attr_add(struct mlxsw_hwmon *mlxsw_hwmon,
+static void mlxsw_hwmon_attr_add(struct mlxsw_hwmon_dev *mlxsw_hwmon_dev,
 				 enum mlxsw_hwmon_attr_type attr_type,
-				 unsigned int type_index, unsigned int num) {
+				 unsigned int type_index, unsigned int num)
+{
 	struct mlxsw_hwmon_attr *mlxsw_hwmon_attr;
 	unsigned int attr_index;
 
-	attr_index = mlxsw_hwmon->attrs_count;
-	mlxsw_hwmon_attr = &mlxsw_hwmon->hwmon_attrs[attr_index];
+	attr_index = mlxsw_hwmon_dev->attrs_count;
+	mlxsw_hwmon_attr = &mlxsw_hwmon_dev->hwmon_attrs[attr_index];
 
 	switch (attr_type) {
 	case MLXSW_HWMON_ATTR_TYPE_TEMP:
@@ -568,16 +585,17 @@ static void mlxsw_hwmon_attr_add(struct mlxsw_hwmon *mlxsw_hwmon,
 	}
 
 	mlxsw_hwmon_attr->type_index = type_index;
-	mlxsw_hwmon_attr->hwmon = mlxsw_hwmon;
+	mlxsw_hwmon_attr->mlxsw_hwmon_dev = mlxsw_hwmon_dev;
 	mlxsw_hwmon_attr->dev_attr.attr.name = mlxsw_hwmon_attr->name;
 	sysfs_attr_init(&mlxsw_hwmon_attr->dev_attr.attr);
 
-	mlxsw_hwmon->attrs[attr_index] = &mlxsw_hwmon_attr->dev_attr.attr;
-	mlxsw_hwmon->attrs_count++;
+	mlxsw_hwmon_dev->attrs[attr_index] = &mlxsw_hwmon_attr->dev_attr.attr;
+	mlxsw_hwmon_dev->attrs_count++;
 }
 
-static int mlxsw_hwmon_temp_init(struct mlxsw_hwmon *mlxsw_hwmon)
+static int mlxsw_hwmon_temp_init(struct mlxsw_hwmon_dev *mlxsw_hwmon_dev)
 {
+	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_dev->hwmon;
 	char mtcap_pl[MLXSW_REG_MTCAP_LEN] = {0};
 	int i;
 	int err;
@@ -587,8 +605,8 @@ static int mlxsw_hwmon_temp_init(struct mlxsw_hwmon *mlxsw_hwmon)
 		dev_err(mlxsw_hwmon->bus_info->dev, "Failed to get number of temp sensors\n");
 		return err;
 	}
-	mlxsw_hwmon->sensor_count = mlxsw_reg_mtcap_sensor_count_get(mtcap_pl);
-	for (i = 0; i < mlxsw_hwmon->sensor_count; i++) {
+	mlxsw_hwmon_dev->sensor_count = mlxsw_reg_mtcap_sensor_count_get(mtcap_pl);
+	for (i = 0; i < mlxsw_hwmon_dev->sensor_count; i++) {
 		char mtmp_pl[MLXSW_REG_MTMP_LEN] = {0};
 
 		mlxsw_reg_mtmp_sensor_index_set(mtmp_pl, i);
@@ -605,18 +623,19 @@ static int mlxsw_hwmon_temp_init(struct mlxsw_hwmon *mlxsw_hwmon)
 				i);
 			return err;
 		}
-		mlxsw_hwmon_attr_add(mlxsw_hwmon,
+		mlxsw_hwmon_attr_add(mlxsw_hwmon_dev,
 				     MLXSW_HWMON_ATTR_TYPE_TEMP, i, i);
-		mlxsw_hwmon_attr_add(mlxsw_hwmon,
+		mlxsw_hwmon_attr_add(mlxsw_hwmon_dev,
 				     MLXSW_HWMON_ATTR_TYPE_TEMP_MAX, i, i);
-		mlxsw_hwmon_attr_add(mlxsw_hwmon,
+		mlxsw_hwmon_attr_add(mlxsw_hwmon_dev,
 				     MLXSW_HWMON_ATTR_TYPE_TEMP_RST, i, i);
 	}
 	return 0;
 }
 
-static int mlxsw_hwmon_fans_init(struct mlxsw_hwmon *mlxsw_hwmon)
+static int mlxsw_hwmon_fans_init(struct mlxsw_hwmon_dev *mlxsw_hwmon_dev)
 {
+	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_dev->hwmon;
 	char mfcr_pl[MLXSW_REG_MFCR_LEN] = {0};
 	enum mlxsw_reg_mfcr_pwm_frequency freq;
 	unsigned int type_index;
@@ -634,10 +653,10 @@ static int mlxsw_hwmon_fans_init(struct mlxsw_hwmon *mlxsw_hwmon)
 	num = 0;
 	for (type_index = 0; type_index < MLXSW_MFCR_TACHOS_MAX; type_index++) {
 		if (tacho_active & BIT(type_index)) {
-			mlxsw_hwmon_attr_add(mlxsw_hwmon,
+			mlxsw_hwmon_attr_add(mlxsw_hwmon_dev,
 					     MLXSW_HWMON_ATTR_TYPE_FAN_RPM,
 					     type_index, num);
-			mlxsw_hwmon_attr_add(mlxsw_hwmon,
+			mlxsw_hwmon_attr_add(mlxsw_hwmon_dev,
 					     MLXSW_HWMON_ATTR_TYPE_FAN_FAULT,
 					     type_index, num++);
 		}
@@ -645,15 +664,16 @@ static int mlxsw_hwmon_fans_init(struct mlxsw_hwmon *mlxsw_hwmon)
 	num = 0;
 	for (type_index = 0; type_index < MLXSW_MFCR_PWMS_MAX; type_index++) {
 		if (pwm_active & BIT(type_index))
-			mlxsw_hwmon_attr_add(mlxsw_hwmon,
+			mlxsw_hwmon_attr_add(mlxsw_hwmon_dev,
 					     MLXSW_HWMON_ATTR_TYPE_PWM,
 					     type_index, num++);
 	}
 	return 0;
 }
 
-static int mlxsw_hwmon_module_init(struct mlxsw_hwmon *mlxsw_hwmon)
+static int mlxsw_hwmon_module_init(struct mlxsw_hwmon_dev *mlxsw_hwmon_dev)
 {
+	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_dev->hwmon;
 	char mgpir_pl[MLXSW_REG_MGPIR_LEN];
 	u8 module_sensor_max;
 	int i, err;
@@ -671,28 +691,28 @@ static int mlxsw_hwmon_module_init(struct mlxsw_hwmon *mlxsw_hwmon)
 	 * sensor_count are already utilized by the sensors connected through
 	 * mtmp register by mlxsw_hwmon_temp_init().
 	 */
-	mlxsw_hwmon->module_sensor_max = mlxsw_hwmon->sensor_count +
-					 module_sensor_max;
-	for (i = mlxsw_hwmon->sensor_count;
-	     i < mlxsw_hwmon->module_sensor_max; i++) {
-		mlxsw_hwmon_attr_add(mlxsw_hwmon,
+	mlxsw_hwmon_dev->module_sensor_max = mlxsw_hwmon_dev->sensor_count +
+					     module_sensor_max;
+	for (i = mlxsw_hwmon_dev->sensor_count;
+	     i < mlxsw_hwmon_dev->module_sensor_max; i++) {
+		mlxsw_hwmon_attr_add(mlxsw_hwmon_dev,
 				     MLXSW_HWMON_ATTR_TYPE_TEMP_MODULE, i, i);
-		mlxsw_hwmon_attr_add(mlxsw_hwmon,
+		mlxsw_hwmon_attr_add(mlxsw_hwmon_dev,
 				     MLXSW_HWMON_ATTR_TYPE_TEMP_MODULE_FAULT,
 				     i, i);
-		mlxsw_hwmon_attr_add(mlxsw_hwmon,
+		mlxsw_hwmon_attr_add(mlxsw_hwmon_dev,
 				     MLXSW_HWMON_ATTR_TYPE_TEMP_MODULE_CRIT, i,
 				     i);
-		mlxsw_hwmon_attr_add(mlxsw_hwmon,
+		mlxsw_hwmon_attr_add(mlxsw_hwmon_dev,
 				     MLXSW_HWMON_ATTR_TYPE_TEMP_MODULE_EMERG,
 				     i, i);
-		mlxsw_hwmon_attr_add(mlxsw_hwmon,
+		mlxsw_hwmon_attr_add(mlxsw_hwmon_dev,
 				     MLXSW_HWMON_ATTR_TYPE_TEMP_MODULE_LABEL,
 				     i, i);
-		mlxsw_hwmon_attr_add(mlxsw_hwmon,
+		mlxsw_hwmon_attr_add(mlxsw_hwmon_dev,
 				     MLXSW_HWMON_ATTR_TYPE_TEMP_CRIT_ALARM,
 				     i, i);
-		mlxsw_hwmon_attr_add(mlxsw_hwmon,
+		mlxsw_hwmon_attr_add(mlxsw_hwmon_dev,
 				     MLXSW_HWMON_ATTR_TYPE_TEMP_EMERGENCY_ALARM,
 				     i, i);
 	}
@@ -700,8 +720,9 @@ static int mlxsw_hwmon_module_init(struct mlxsw_hwmon *mlxsw_hwmon)
 	return 0;
 }
 
-static int mlxsw_hwmon_gearbox_init(struct mlxsw_hwmon *mlxsw_hwmon)
+static int mlxsw_hwmon_gearbox_init(struct mlxsw_hwmon_dev *mlxsw_hwmon_dev)
 {
+	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_dev->hwmon;
 	enum mlxsw_reg_mgpir_device_type device_type;
 	int index, max_index, sensor_index;
 	char mgpir_pl[MLXSW_REG_MGPIR_LEN];
@@ -720,10 +741,10 @@ static int mlxsw_hwmon_gearbox_init(struct mlxsw_hwmon *mlxsw_hwmon)
 	    !gbox_num)
 		return 0;
 
-	index = mlxsw_hwmon->module_sensor_max;
-	max_index = mlxsw_hwmon->module_sensor_max + gbox_num;
+	index = mlxsw_hwmon_dev->module_sensor_max;
+	max_index = mlxsw_hwmon_dev->module_sensor_max + gbox_num;
 	while (index < max_index) {
-		sensor_index = index % mlxsw_hwmon->module_sensor_max +
+		sensor_index = index % mlxsw_hwmon_dev->module_sensor_max +
 			       MLXSW_REG_MTMP_GBOX_INDEX_MIN;
 		mlxsw_reg_mtmp_pack(mtmp_pl, 0, sensor_index, true, true);
 		err = mlxsw_reg_write(mlxsw_hwmon->core,
@@ -733,15 +754,15 @@ static int mlxsw_hwmon_gearbox_init(struct mlxsw_hwmon *mlxsw_hwmon)
 				sensor_index);
 			return err;
 		}
-		mlxsw_hwmon_attr_add(mlxsw_hwmon, MLXSW_HWMON_ATTR_TYPE_TEMP,
-				     index, index);
-		mlxsw_hwmon_attr_add(mlxsw_hwmon,
+		mlxsw_hwmon_attr_add(mlxsw_hwmon_dev,
+				     MLXSW_HWMON_ATTR_TYPE_TEMP, index, index);
+		mlxsw_hwmon_attr_add(mlxsw_hwmon_dev,
 				     MLXSW_HWMON_ATTR_TYPE_TEMP_MAX, index,
 				     index);
-		mlxsw_hwmon_attr_add(mlxsw_hwmon,
+		mlxsw_hwmon_attr_add(mlxsw_hwmon_dev,
 				     MLXSW_HWMON_ATTR_TYPE_TEMP_RST, index,
 				     index);
-		mlxsw_hwmon_attr_add(mlxsw_hwmon,
+		mlxsw_hwmon_attr_add(mlxsw_hwmon_dev,
 				     MLXSW_HWMON_ATTR_TYPE_TEMP_GBOX_LABEL,
 				     index, index);
 		index++;
@@ -754,44 +775,58 @@ int mlxsw_hwmon_init(struct mlxsw_core *mlxsw_core,
 		     const struct mlxsw_bus_info *mlxsw_bus_info,
 		     struct mlxsw_hwmon **p_hwmon)
 {
+	char mgpir_pl[MLXSW_REG_MGPIR_LEN];
 	struct mlxsw_hwmon *mlxsw_hwmon;
 	struct device *hwmon_dev;
+	u8 num_of_slots;
 	int err;
 
-	mlxsw_hwmon = kzalloc(sizeof(*mlxsw_hwmon), GFP_KERNEL);
+	mlxsw_reg_mgpir_pack(mgpir_pl, 0);
+	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mgpir), mgpir_pl);
+	if (err)
+		return err;
+
+	mlxsw_reg_mgpir_unpack(mgpir_pl, NULL, NULL, NULL, NULL,
+			       &num_of_slots);
+
+	mlxsw_hwmon = kzalloc(struct_size(mlxsw_hwmon, line_cards,
+					  num_of_slots + 1), GFP_KERNEL);
 	if (!mlxsw_hwmon)
 		return -ENOMEM;
+
 	mlxsw_hwmon->core = mlxsw_core;
 	mlxsw_hwmon->bus_info = mlxsw_bus_info;
+	mlxsw_hwmon->line_cards[0].hwmon = mlxsw_hwmon;
 
-	err = mlxsw_hwmon_temp_init(mlxsw_hwmon);
+	err = mlxsw_hwmon_temp_init(&mlxsw_hwmon->line_cards[0]);
 	if (err)
 		goto err_temp_init;
 
-	err = mlxsw_hwmon_fans_init(mlxsw_hwmon);
+	err = mlxsw_hwmon_fans_init(&mlxsw_hwmon->line_cards[0]);
 	if (err)
 		goto err_fans_init;
 
-	err = mlxsw_hwmon_module_init(mlxsw_hwmon);
+	err = mlxsw_hwmon_module_init(&mlxsw_hwmon->line_cards[0]);
 	if (err)
 		goto err_temp_module_init;
 
-	err = mlxsw_hwmon_gearbox_init(mlxsw_hwmon);
+	err = mlxsw_hwmon_gearbox_init(&mlxsw_hwmon->line_cards[0]);
 	if (err)
 		goto err_temp_gearbox_init;
 
-	mlxsw_hwmon->groups[0] = &mlxsw_hwmon->group;
-	mlxsw_hwmon->group.attrs = mlxsw_hwmon->attrs;
+	mlxsw_hwmon->line_cards[0].groups[0] = &mlxsw_hwmon->line_cards[0].group;
+	mlxsw_hwmon->line_cards[0].group.attrs = mlxsw_hwmon->line_cards[0].attrs;
 
 	hwmon_dev = hwmon_device_register_with_groups(mlxsw_bus_info->dev,
-						      "mlxsw", mlxsw_hwmon,
-						      mlxsw_hwmon->groups);
+						      "mlxsw",
+						      &mlxsw_hwmon->line_cards[0],
+						      mlxsw_hwmon->line_cards[0].groups);
 	if (IS_ERR(hwmon_dev)) {
 		err = PTR_ERR(hwmon_dev);
 		goto err_hwmon_register;
 	}
 
-	mlxsw_hwmon->hwmon_dev = hwmon_dev;
+	mlxsw_hwmon->line_cards[0].hwmon_dev = hwmon_dev;
 	*p_hwmon = mlxsw_hwmon;
 	return 0;
 
@@ -806,6 +841,6 @@ int mlxsw_hwmon_init(struct mlxsw_core *mlxsw_core,
 
 void mlxsw_hwmon_fini(struct mlxsw_hwmon *mlxsw_hwmon)
 {
-	hwmon_device_unregister(mlxsw_hwmon->hwmon_dev);
+	hwmon_device_unregister(mlxsw_hwmon->line_cards[0].hwmon_dev);
 	kfree(mlxsw_hwmon);
 }
-- 
2.33.1

