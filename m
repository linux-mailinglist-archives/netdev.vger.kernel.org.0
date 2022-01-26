Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68CB649C7A0
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 11:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240019AbiAZKcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 05:32:21 -0500
Received: from mail-mw2nam12on2053.outbound.protection.outlook.com ([40.107.244.53]:38710
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240022AbiAZKcM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 05:32:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PYajfYgWF5sWmWD0IxjUzgB4VmIsUTzIssT9toTCuboexap9o9Pyi8hLqzXHjq8m/wqZq5PwWrB2eIiJpNXXtWZ+fY34o1estLlnc0TeAnUg1n0dnPoNrSBUJdMvJFovREO+LJOs9uqG75+5bm9sKTUAw/ApBcENtTvuVPo1L05n+TJFKZ93+cFduxaVa1NxdtmvBSHFVoUjlfSDmgNOF2SogtHekEnrTQygWoOUpRLI/YioW21b4Kar5fQW5NHHlYua/eyprxw6P9lrC61Brfilyt8GOXUaLKofEqj9k8p4LhGxF7lPh0ArsIuykoEvymW9UuXo4nNvBEhLd2cNxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=632JOpyC55vp2OTBfszsoyIcEJc3fg9fjY/74GTAuJ8=;
 b=GF51rrVXdrauGYLbxD1JhRpF8jM8UQ7gsSu3ENA6jIkxRtv2Hpvdj2AtVYFbgusyiAffadAMsJD5isCHl4ooAP3ZJKYo+SxZbwHT5C5Almw3FwTuqzcqMjQmN36CW9jEvXYfSg6nOHsivEybwJoUn5OB1xaS5CdKMvMLBVKPfZ6ztRfHna96eLz4kylVRFcvXKPZZW/6jNfzD9C5+k7Ss+s3fMzGmC1s87wkqA4wi3JSFMxoSPH5I1XX7e7CNbtn4ZZkkPouMh31a0JBO13IcAbW6CdWyNOdUvccVPFAjBoBaBv6sVFlZiDU8o2czb4Xhj/A21du0Eo/rNQp6HRsyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=632JOpyC55vp2OTBfszsoyIcEJc3fg9fjY/74GTAuJ8=;
 b=S4Hj6FbGqdPm4+J0jsJNoAfUJHbsoj/08k/XdKQSsD9ij/SHy5i8P5epYuBCq49BuqK1db5nacqIqN0fv2+n7ZwAb88cqmvd1YrlEtSd5MKwT2g/UUTGGoKRax5Vt2Y4BEfde0rBWTrbTzwbQsfQBgtR3Xh793E3NpT3fo+k0rs7+gO/JfVzxNWQ2a3XVha599c4bcslmSLEoRCpBDPmtxla+X+5YoeJOTiSnXjCRkJlDidK6Pcjp7dAsPDhM7s/VwWW554jwwynt8g3MW1RdVkwBqXTfPndpSRLCUj4D5OnkAbgqHFimyhhqRAd6yQTfEUsjitY7iRfqCQun0LS7w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3527.namprd12.prod.outlook.com (2603:10b6:a03:13c::12)
 by BN8PR12MB3620.namprd12.prod.outlook.com (2603:10b6:408:49::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.12; Wed, 26 Jan
 2022 10:32:10 +0000
Received: from BYAPR12MB3527.namprd12.prod.outlook.com
 ([fe80::3dfb:4df1:dcf1:4561]) by BYAPR12MB3527.namprd12.prod.outlook.com
 ([fe80::3dfb:4df1:dcf1:4561%5]) with mapi id 15.20.4909.017; Wed, 26 Jan 2022
 10:32:10 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        danieller@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 8/9] mlxsw: core_env: Forbid power mode set and get on RJ45 ports
Date:   Wed, 26 Jan 2022 12:30:36 +0200
Message-Id: <20220126103037.234986-9-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220126103037.234986-1-idosch@nvidia.com>
References: <20220126103037.234986-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0071.eurprd07.prod.outlook.com
 (2603:10a6:800:5f::33) To BYAPR12MB3527.namprd12.prod.outlook.com
 (2603:10b6:a03:13c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 96a3e71a-7f46-4584-f29b-08d9e0b71c3e
X-MS-TrafficTypeDiagnostic: BN8PR12MB3620:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB3620D47BD18C1E1185FEB0AAB2209@BN8PR12MB3620.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LIoIZEaV1f8nhx3m9cnU5uEz6fkT7SUXdAUtOn3IUvDPNy8jTUZP4kFF9X6dVij9ZpXbcBKVOz73NXLNqk6MMExtJU1PnetktB1hQLGZbZVPA8iv6hKh6yCLmnpHdaaiAllWxIanEflafLtJJ68kXOYBPxHue87jJole246nGMzG/2qbZs9GIABSh3Dry1G0HnTb/CFhL6bcpflCsxf/fcOe01xVUvhnIhWau4HXbIidXJiZwtNAhlDXZSO41I7tbUqgC1RiZRKKE7vuPN9jDD/g0jhkuAbHAeSnLui+W8U2HV2Bh51vDFYh/GIk4MI66jWqUgZOfLY5UWcdR6HFEskn5MknMp3PZNM5tHfCEWcaifLfabh/oZiVRcmpS5+TcwvsF6l932Bc7KINU1MDVTQfo50+lBrprX0Njkj/SEgxvaLS1UIydQbTxKWpQH/F1JG0P/WbxRh0rUn3C8nMnSRCEh1gBl+hFQiMoqxh3AkTwBVef3v/dnngBNhEgeUIuukKEEt4EmxTMp+lgWTeum1OHDmUx1q7m6h8sx72cHpacShlS0XdGGOP0F1ENYDo5Ok+e5MZEwZdEvU0sk1iwfIaMk/uQcexUjQ4XbLBOSvD++OebAXCXQTuDdPJmWJYgaTLs+PntT6blO3VhtWbxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3527.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(26005)(6512007)(8936002)(316002)(2616005)(508600001)(36756003)(186003)(66476007)(38100700002)(6486002)(107886003)(6506007)(4326008)(6916009)(86362001)(1076003)(66556008)(2906002)(6666004)(66946007)(83380400001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zor5jJSvQOYepoclcR8GjKstubmJaWo0wSiM3bfZK6XE+n5noIyqQ2VAwdKd?=
 =?us-ascii?Q?rA2IEOQwS2NmN8yf3aKmcPIRMq3OPElMj36A4XTblUom6viAo5DI8cZniQfC?=
 =?us-ascii?Q?WwvGCqZZZUdNIcxLXTt+sUgYlNDfJjWPm/8auB7PRFvSR8+6ewa8Kgo6fWjc?=
 =?us-ascii?Q?Gki7TGzA44W9Y6ENS1xxX3hv8rmOQyqqu5LESrdY6i1WV4ILHBkCJ4/EZYtW?=
 =?us-ascii?Q?oWUiDfvOk8FBI8N80Go6D5/I9VnWAkS+N4vx7W8iAdsStvTaeDBQXKdoxjiU?=
 =?us-ascii?Q?91KrPTy2FW4Z2wcOIogGutjbMOcUqe9EuuSVYb1o91JTgtzfLunLLU/m5qcx?=
 =?us-ascii?Q?dj5rKrtoLjwI7znRahizojEMsDueBDaGfP2Gb/9yAE5oSIWnRy1B6Y60UoFD?=
 =?us-ascii?Q?jmIl1NW+JdRB5iVn4rQU0Jg/14btBET8XKKt7DQYcXNt7PUMjU/+qb7Zb+0v?=
 =?us-ascii?Q?BEbQVyjl5wVsC6mbdsnHUdMi0qhUVzXLIOkZlI5JDQKGaSPaFmHvlWmpJhPa?=
 =?us-ascii?Q?ykicxqnKwHvojqP5nws8s2DQqEa14NGRAn18yVRW3zWmGZ66W1QW73hgAiux?=
 =?us-ascii?Q?ZyHyqqH896UYP591TB7+C4nzB1WloQMeVIkgp2hLVqRHZLWp8r5E+9yFPs3a?=
 =?us-ascii?Q?k4+Cu28eY7RhdFMn7KOvzp5OftFB0165FqkmEg2Ngpi9j1ZUx1Bk1UEeYe0F?=
 =?us-ascii?Q?nASOn8BX7s36t7tw3VUDS4xrREuy3TFJQ0Os5uiMtKsG3tIPB6SwOGwmdEQh?=
 =?us-ascii?Q?oYDtFnfDKPUvjn1DZvoic9AmFExZiZNq7mvvd+I0u/9OfueMTqKuuHh4/4kc?=
 =?us-ascii?Q?WKoz+3Uidbt6P6nr/YxyynTDrVGCbjENklykav8gOC/hI13G/kCt+W7mZB2q?=
 =?us-ascii?Q?sQtHajp22QzE5aGG5bSR/9iaR3i4te78cKXcYB5ZMB11+mLU+NucQNJFvb9y?=
 =?us-ascii?Q?TGp4RQjv6sXv21CsWzhNpZIwPvBpiMRxVhtkeRJ/i14Fsyxj11ac9kUbEJN9?=
 =?us-ascii?Q?nEjl1YUdc3MRKhy7zTxSbVihzMb4Ifoo6J0JJr3B4rx8SxmhO/I58HlM+30q?=
 =?us-ascii?Q?HB2aMO1Hqb7aEQErLAXCd06q42dyGgTXDkO6gk3ZIthHjEMPab93HQzSejB2?=
 =?us-ascii?Q?3alY+DJGe13ds9lM5g8JppLOTyyUQAcsRq9620urdYORX7964zO6Y2GS7ZOg?=
 =?us-ascii?Q?FrFMIeGclafSBYWBD/5VfSYBdjA3aMPVNBBUL7ZUYQp26uh+/XHsIqB6adxg?=
 =?us-ascii?Q?ShvtMPfAC5CE4jYi/wOYy7W6NoBpJpVzlVO1ztz5aYpdO1m1wqHaDm9GtQ6z?=
 =?us-ascii?Q?uuGRJDS5VCjITcyjxGLDEzcXgNXRgwo/JCTtv9JQ1JM9+aNRMbg8Deio/dDx?=
 =?us-ascii?Q?x820b1mPCI58w2fP8fdVTJLHwvDlRRF+tiDVdGRW19CUmucm5nWttpXiP1H+?=
 =?us-ascii?Q?bsMXpe+pponChJPnTVmZj8g2zidvqF3mB0nHGIcSEOB6bQyAm8HbEz6wfEZ6?=
 =?us-ascii?Q?+6K3zAZhrqClLmG83tskUsai7riJEQHD7eQyb2+JpGfNzS9QAsOW2RwH+r3v?=
 =?us-ascii?Q?uZzAq//7XU6MwbYOEEiRK5iP6hHDhnldTpwCL9H/I/6pkchNj+4IK1aN7m7I?=
 =?us-ascii?Q?ZM4c7+Vzx6FyhbS0xJOEgo4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96a3e71a-7f46-4584-f29b-08d9e0b71c3e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3527.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 10:32:10.8410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FoSCz8qe1LIkZUD2YSsL8zzdovu97CaqleXnB34vlZN8G+qePDbfF5nqDnBT02APzc6bJw2rhlLhrl6FVlLkRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3620
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

PMMP (Port Module Memory Map Properties) and MCION (Management Cable IO
and Notifications) registers are not supported on RJ45 ports, so setting
and getting power mode should be rejected.

Therefore, before trying to access those registers, validate the port
module type that was queried during initialization and return an error
to user space in case the port module type is RJ45 (twisted pair).

Set output example:

 # ethtool --set-module swp1 power-mode-policy auto
 netlink error: mlxsw_core: Power mode is not supported on port module type
 netlink error: Invalid argument

Get output example:

 $ ethtool --show-module swp11
 netlink error: mlxsw_core: Power mode is not supported on port module type
 netlink error: Invalid argument

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core_env.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index b63e66b7e2b1..b34de64a4082 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -509,6 +509,12 @@ mlxsw_env_get_module_power_mode(struct mlxsw_core *mlxsw_core, u8 module,
 
 	mutex_lock(&mlxsw_env->module_info_lock);
 
+	err = __mlxsw_env_validate_module_type(mlxsw_core, module);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Power mode is not supported on port module type");
+		goto out;
+	}
+
 	params->policy = mlxsw_env->module_info[module].power_mode_policy;
 
 	mlxsw_reg_mcion_pack(mcion_pl, module);
@@ -619,6 +625,13 @@ mlxsw_env_set_module_power_mode(struct mlxsw_core *mlxsw_core, u8 module,
 
 	mutex_lock(&mlxsw_env->module_info_lock);
 
+	err = __mlxsw_env_validate_module_type(mlxsw_core, module);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Power mode set is not supported on port module type");
+		goto out;
+	}
+
 	if (mlxsw_env->module_info[module].power_mode_policy == policy)
 		goto out;
 
-- 
2.33.1

