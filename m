Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA496504CCE
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 08:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236845AbiDRGqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 02:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236822AbiDRGqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 02:46:39 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2042.outbound.protection.outlook.com [40.107.101.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18C018E3B
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 23:44:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oP6+SwCCY4o80M84Cq4nibX4d8+G/tO+JHFynsJJ8rLJhQ9SNLyfsXVH3/jnp3WepTH/yOUPuNa2EMF9AF64neJ4SHyBeCPo+4X7YfMMk46mInnp4boVaxP69aKl/XAsmnr6BOXmfAD4WZI2mXOMEIrOURl673sUrLwrLbrYi+KeSPNCxneui9LXFraJwDi2cUJqtTbEIZBc1L/edrNv4xXw3gNYP7boepivcdz+yCUrIrJXK/WC7rT4k22dIfB3ZsqChHmTgw7jctV4x0egK2m6vwdqHIzCU98JsM4WBem0BxxVQwjzI3A1YoQXXWgEfUyBPzzCnOJxdL3XrDQQLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SI+utdoAUEY1Q72DOJET3tiamn/+EP6TO4kXerbMMyE=;
 b=DVsuzBCaHsdp25Vi97LTX/+z9zG4KZzG4zAtFGcMf5pTPPd0bnAv8qUqXUtUKpTaxO+oBA7CY05fRkhWUR97pePnctMjnfHiq43QR1CMKJc51vXSPivOSTze/kSltCrkr4AAzsZDkSqRJxEym48cuoS1f6bZFvlqBbofV2CyWndNXTgR3neh8ls2z55xybbS+DauRR1uoKLUlRvZrdh+KbjGq376YwS1/6Y1Dx4FU+R9WJDRxJjj4EaDpKDfQ4ESlKGXldsnWbLUSbpq4THSTldk0pMmqZvtq+r92hc83RtZCfmzemQDNuLLjcPaPUx3Opbr4cN2c6cDlwkn1cAyNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SI+utdoAUEY1Q72DOJET3tiamn/+EP6TO4kXerbMMyE=;
 b=HY8ll6P/KRMUMQ9LoGAIvOU67auT9esMHptWTvKF5fgwXSPYKayhip8DHsEoy2mm3AfxEKkyEuAAVceVrzc2zFm62y9ZTrXHzQbREiqnqQqygFHlUo+AMl6kk5JQR36GLjftxGnXZHuCMxCfeMzGvqfR0VdIGsUPuXbyu6d3qlMzhXF3fYQdxpkmtX+ZwKP2oto5siu1I64toPhCNnexqb7HpKv+ZpvqQh9W6ZuIlLIAI4xpmf7taRnaxLI09Bmpq07+48XS/lNZPCCEytgNfnLUw+6beZmbyaYiN2WYtzbo2pJ7Px4DayTiR+UFvZbLxYnKNIRQEMmPa8MUzFYfjQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by PH0PR12MB5420.namprd12.prod.outlook.com (2603:10b6:510:e8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 06:44:00 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402%6]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 06:44:00 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jiri@nvidia.com, vadimp@nvidia.com, petrm@nvidia.com,
        andrew@lunn.ch, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 06/17] mlxsw: spectrum: Allocate port mapping array of structs instead of pointers
Date:   Mon, 18 Apr 2022 09:42:30 +0300
Message-Id: <20220418064241.2925668-7-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220418064241.2925668-1-idosch@nvidia.com>
References: <20220418064241.2925668-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0520.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:272::16) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8dec435f-190d-4757-943e-08da2106d1f5
X-MS-TrafficTypeDiagnostic: PH0PR12MB5420:EE_
X-Microsoft-Antispam-PRVS: <PH0PR12MB5420F374229E809E55A2314AB2F39@PH0PR12MB5420.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R8iSXjLdAwBj6VN3QIvTffFNUpifWfBJK6nBpt9QTIaNa4MBtq3Iryq2eU3Krk0TIhm6QvhMGjfznoum2lYODZc82921UQre4DkKUfeiRPBcQ3+1Xa1LkoEXm/ju2M2shZR7IyY6X53Bwqz2S7U+dWPGS9FGZargg8tZu28elAolOMq3eotmXesbHunxikqiTASNn2XALktiZyrPyFGbShwRjHpub6/MKN9B8+FwImujEK1rXgZVmg3miedILBilDpO8OsYZVV/OvUAZw0HNMtsOvWadVxJUzRCmsOqC7YXRSzwUx4Pv5tTD3zBOSHTT5GxbSuYZ/zgq1d68dedhtpMiffg+QFvXY7Q8vuY2W5OksWsMNS3PnRP8cJhFARR+uqQfnCp0Ow8p5jFXXrH4us1drjDboRE5QMspMfub3neFwyZj/ZFqAR1rSvhK4cCbnJWsCmCwnHxqPO5glaBgRzMuOhzzymizespUTis7XKngxIi8dqWqIM0oQVcgn4H9qcNCz7vdcJl4fnbmTs9c1JvjATN4LnLekVtt1yN/IsTjX7f44i2XJgeE78IHOi7VjdDvA5VR9WwHVMKyVJCI/+RlAiyW6udMKQ9lZrd5OvWmFsF01WuErrS9/Oez/q6BKwFrWCbyyna7FV2zIXOqLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(6486002)(508600001)(1076003)(2906002)(6512007)(6506007)(86362001)(6666004)(36756003)(186003)(26005)(83380400001)(66946007)(38100700002)(5660300002)(66556008)(66476007)(107886003)(2616005)(4326008)(8676002)(6916009)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uW9Z3x8Sdkg5Iz5+uh3mIM6ts6j5HSkWSbJxzUHzsKVxTUUVXF9EN/w5tt2J?=
 =?us-ascii?Q?n3eUyhjLJfGcfh6PqgZD/PDeiQORrOooQeulbxLBiQLp1gk9zkGtj4F3Cn+2?=
 =?us-ascii?Q?7gnaCe+bx3Ru3F6yY0Q2VCwPDj8BVCmZ+nvB5q7Nf7nRI1ZdQAsLLP8hqf/f?=
 =?us-ascii?Q?qEcPQQeyNfcegQr+UKamPaKpd8AfU+DmTkJR+OoKoojl8k5DTBXal2IjOYGr?=
 =?us-ascii?Q?KrjmuUp8L5YnnUnfvMrKfBxWKFtJtr+SEajo2tpRxIVYQ5ejRxNm9TmQlmBF?=
 =?us-ascii?Q?8gdANcGBV+LrMUOBvls2n4LVlH1Kh6JcapQI1Paj9w9N1FIL2DPoPEjznbwe?=
 =?us-ascii?Q?73mhdLQ6eta7YWYykPlt5BhLNXZEAiV3F0QLGEo864LGPqvtncyYnZBkzpri?=
 =?us-ascii?Q?0ESXXQCoMukpo370JH+LPDKx1Lcbfh78HdtI+kh8Sy2cFvxEGalrjCcl4UjA?=
 =?us-ascii?Q?CnQmxKZu2GP4GCxYghpaTj7jnH5Cpz6vDao6LFMK180OdGQM1BGqnzqIKmpg?=
 =?us-ascii?Q?YMRaQaiQKKy7lxgTErmDFmAccxSxWFicu3tBdrL9jIF1qtwr79pR/9Lds5Fv?=
 =?us-ascii?Q?SyqDBWYCmmJBjh38AAbTymTlxNyZRUE/OAYjkObKMD2kkA8VzkkqBRs+LJoO?=
 =?us-ascii?Q?/Rvm6VKGbblBZEMTuRWyc/yrAKbrZL/xIgl/eYVnFMF41rYpjlDDIX77hpT0?=
 =?us-ascii?Q?NVexiEqiX0sy3yZbuP5BVD/dBCVr+nKFnZ3LVIXltnhBuTHVFQLNIewAYU+q?=
 =?us-ascii?Q?dr2Wym9FqfG8pq9l0iHP8rxfOe6kMDj9D00AclsckrcnTD3duaAhMBrLTYxD?=
 =?us-ascii?Q?jsf+aMvrB4EZxgPvzorjd0g2GbOA56IYdpRktkajvhT0MB78Owkkt0Mpty91?=
 =?us-ascii?Q?uWg5bg7KQi2KgpcKM9jo3W2E6NVm481QTqSuS1A8m+y5N59CSGqPDYcs6VSm?=
 =?us-ascii?Q?BH57wfdxIX0kdXm0/A1OeypzzEylLLBkBXrXC8QRaquCiRqB/wnfG3061Wuh?=
 =?us-ascii?Q?4QQ4bhiS/x0prwZj0y3ny5LLkxJUbG8/3vAPOE6ADH66UxJb7acKOQbw8h30?=
 =?us-ascii?Q?2Yd9CTwOEI/mmEr31dvW5xRM4+tgQQoHcxlc+z/OLjFNvlM8i9wteVSURtd6?=
 =?us-ascii?Q?1FtC1BBNxX5ERdEbkzchEHJ6mPC7GhmNq4KMEDZRh2O6eO8w/owVLjV1oDFa?=
 =?us-ascii?Q?kI6A8v2W3onmk+v5n0zibrNBPPGSyjoqmF3uVGal3n2XWLbIkQqyFY1J9dJp?=
 =?us-ascii?Q?km23HVYS6xVouMnr/B3EK8KK2nQ2n/bVlmOLmPupum1+dNbFJQXgE8jV3jys?=
 =?us-ascii?Q?phUyRCJb11QWuQAADuzUaYIQQbsrJyhPFjtpP3DSLqSEBulwxylpSsFWJ+NN?=
 =?us-ascii?Q?BvZtF4/lxDI0qw6B0POX9jIIyyjhu3YOisChJUxSUFldaeMTKRmE8DVqjNNz?=
 =?us-ascii?Q?hmoNdnbtg3pRn8CcuFRsLPUEMcea0v4duE6QE3/mkEpIMiGFHdyHBR3Z5w2z?=
 =?us-ascii?Q?ukt81tggbwmcuNlmG9Ka7HWqIswYVCIRoBHIT0uzOR77q5bh52huYj4q576m?=
 =?us-ascii?Q?6fNqLuq3lAkwZmTeetGIPVBB+VkcZjC0m1JSRpCaaiYC+KEBnVEW9DoNib4s?=
 =?us-ascii?Q?Dj0S0KPTucJhdkWx3+WFLhvjcqU8wWw7hMl9FhD7aqlMqniKjfHw/KEUzyjR?=
 =?us-ascii?Q?8vLI8zsUxyjJSvBgSSJAtfaUDHBkMoUI0WVB+3GTema2wksukNtDxWBzDYTr?=
 =?us-ascii?Q?StzK29jpOg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dec435f-190d-4757-943e-08da2106d1f5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2022 06:44:00.3805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2CSSrFcZiAvmUSxCIQ7ef5OxOlsEqhKzeflb4mRLlKePt8ZV/pcoinoy7xSmzCjFoNlCMT3fNhnTJhc4z1Btqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5420
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Instead of array of pointers to port mapping structures, allocate the
array of structures directly.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 32 +++++--------------
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  2 +-
 2 files changed, 9 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 120880fad7f8..55b97ccafd45 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1891,8 +1891,8 @@ static int mlxsw_sp_ports_create(struct mlxsw_sp *mlxsw_sp)
 		goto err_cpu_port_create;
 
 	for (i = 1; i < max_ports; i++) {
-		port_mapping = mlxsw_sp->port_mapping[i];
-		if (!port_mapping)
+		port_mapping = &mlxsw_sp->port_mapping[i];
+		if (!port_mapping->width)
 			continue;
 		err = mlxsw_sp_port_create(mlxsw_sp, i, false, port_mapping);
 		if (err)
@@ -1914,12 +1914,12 @@ static int mlxsw_sp_ports_create(struct mlxsw_sp *mlxsw_sp)
 static int mlxsw_sp_port_module_info_init(struct mlxsw_sp *mlxsw_sp)
 {
 	unsigned int max_ports = mlxsw_core_max_ports(mlxsw_sp->core);
-	struct mlxsw_sp_port_mapping port_mapping;
+	struct mlxsw_sp_port_mapping *port_mapping;
 	int i;
 	int err;
 
 	mlxsw_sp->port_mapping = kcalloc(max_ports,
-					 sizeof(struct mlxsw_sp_port_mapping *),
+					 sizeof(struct mlxsw_sp_port_mapping),
 					 GFP_KERNEL);
 	if (!mlxsw_sp->port_mapping)
 		return -ENOMEM;
@@ -1928,36 +1928,20 @@ static int mlxsw_sp_port_module_info_init(struct mlxsw_sp *mlxsw_sp)
 		if (mlxsw_core_port_is_xm(mlxsw_sp->core, i))
 			continue;
 
-		err = mlxsw_sp_port_module_info_get(mlxsw_sp, i, &port_mapping);
+		port_mapping = &mlxsw_sp->port_mapping[i];
+		err = mlxsw_sp_port_module_info_get(mlxsw_sp, i, port_mapping);
 		if (err)
 			goto err_port_module_info_get;
-		if (!port_mapping.width)
-			continue;
-
-		mlxsw_sp->port_mapping[i] = kmemdup(&port_mapping,
-						    sizeof(port_mapping),
-						    GFP_KERNEL);
-		if (!mlxsw_sp->port_mapping[i]) {
-			err = -ENOMEM;
-			goto err_port_module_info_dup;
-		}
 	}
 	return 0;
 
 err_port_module_info_get:
-err_port_module_info_dup:
-	for (i--; i >= 1; i--)
-		kfree(mlxsw_sp->port_mapping[i]);
 	kfree(mlxsw_sp->port_mapping);
 	return err;
 }
 
 static void mlxsw_sp_port_module_info_fini(struct mlxsw_sp *mlxsw_sp)
 {
-	int i;
-
-	for (i = 1; i < mlxsw_core_max_ports(mlxsw_sp->core); i++)
-		kfree(mlxsw_sp->port_mapping[i]);
 	kfree(mlxsw_sp->port_mapping);
 }
 
@@ -2007,8 +1991,8 @@ static void mlxsw_sp_port_unsplit_create(struct mlxsw_sp *mlxsw_sp,
 	for (i = 0; i < count; i++) {
 		u16 local_port = mlxsw_reg_pmtdb_port_num_get(pmtdb_pl, i);
 
-		port_mapping = mlxsw_sp->port_mapping[local_port];
-		if (!port_mapping || !mlxsw_sp_local_port_valid(local_port))
+		port_mapping = &mlxsw_sp->port_mapping[local_port];
+		if (!port_mapping->width || !mlxsw_sp_local_port_valid(local_port))
 			continue;
 		mlxsw_sp_port_create(mlxsw_sp, local_port,
 				     false, port_mapping);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 20588e699588..68f71e77b5c7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -164,7 +164,7 @@ struct mlxsw_sp {
 	unsigned char base_mac[ETH_ALEN];
 	const unsigned char *mac_mask;
 	struct mlxsw_sp_upper *lags;
-	struct mlxsw_sp_port_mapping **port_mapping;
+	struct mlxsw_sp_port_mapping *port_mapping;
 	struct rhashtable sample_trigger_ht;
 	struct mlxsw_sp_sb *sb;
 	struct mlxsw_sp_bridge *bridge;
-- 
2.33.1

