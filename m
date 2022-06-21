Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCB16552D22
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 10:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347518AbiFUIfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 04:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346491AbiFUIfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 04:35:34 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2075.outbound.protection.outlook.com [40.107.237.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29E225285
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 01:35:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ep2AHNxgUCMxRFAXpSTk2QvZXp+yRI3WVS0d2vMx+0rxymTg/y/H40kxPXw1A6LGZSyYkMOV/zAOYitrnW7wDrR2AY2ntLkBVF53PbGCw82c9AGP2IR/48bedPqK21G1R+eS1NtMHMX6u6MFfSKUrI2EBayZB/1UwNMCDR1ykTym/hub/cpptAw6yALZ+pYpGUtb43kVfTiVLBGldGeOYDabxBuvVPrRbfX+CFB8QMMr5makfgyr4q4wr3MMCGqRu5gSy3XE4NTPmiGUfLOqddm9ju2phUtqyxJiUr4e8YP0X5bnTaSQfbea4NcJTHyt4HfiyfRgxJ4Ix0DvG7uCKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v60BUQ5GkYa+N05Ubk2/2MEPxsJx4bE3FHoYVgS268w=;
 b=HNZjAxn3va9q5EGC4VX2esHrgYOfup5aliEwMWwyBwUw29oSFiFJ3XIktGkvmSHWIyJIr5qAdJuDxz7+5mxgz0IxooqyGYqFS+7kS6u1izwFnUjEk3l1o6XXr39qo82x6swt/aDdmysJmsVuw6FxuKO4OnKa1uzvLkzXBeAqVMtewnVYJ0y4pFMO9ImtRtdrEVCC6ayrPMNisBIX67sYpU7JRFoc23Bq6GwnQKTObe0d2Kxbedqt58NoOjc9va1Hf9Y7FYy4DexyqmY/Udkvav8owlnk+K9APay0bXyuhiSLVjCi6uiAr/ciIuYpmWE2G39kb8c6mtHiT+PpPWDs3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v60BUQ5GkYa+N05Ubk2/2MEPxsJx4bE3FHoYVgS268w=;
 b=ApRBpgywo1YTF6nfR5DdA9XQBonI1f/2PU5g7Z1d9iL7oXbh8InQfij5njpYV0ByaEvxKT0NA8p03tIKH2YRUNUFKrSEkJ3e3tuiCECQzwDMEMMy2VRtXHOQ0aeil21T+8wX7ywm065vCKG2WiAESHMhKzIX7DV5xxO9yvyTMoFz+fU+gp0Dp3Vj3aNSunSgecTpYx1tnQepBsyq2ZNuoUbAlOHlgdchK6MEeBLXktZx6bVdWCMBXl1s3oeMGizdv5FRCbfH55NndCTqJ1NtTYmKQZt4/uJyr2CR51cKLfZNvQ4Rny2L6uTyzJrSRsE0GHsQy0T0uLMfrYcndemwzg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH2PR12MB3832.namprd12.prod.outlook.com (2603:10b6:610:24::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Tue, 21 Jun
 2022 08:35:29 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Tue, 21 Jun 2022
 08:35:29 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 08/13] mlxsw: Add enumerator for 'config_profile.flood_mode'
Date:   Tue, 21 Jun 2022 11:33:40 +0300
Message-Id: <20220621083345.157664-9-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220621083345.157664-1-idosch@nvidia.com>
References: <20220621083345.157664-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0187.eurprd08.prod.outlook.com
 (2603:10a6:800:d2::17) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b00d4a09-233a-4e9f-4571-08da5360ff1a
X-MS-TrafficTypeDiagnostic: CH2PR12MB3832:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB38321FDD12EF88F44F6F20F1B2B39@CH2PR12MB3832.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g4W6L1EKA+lFMdp27sl8w8HQVhuyL7aV6uuNcR/xxXkAJpATT4P26O2XqQIrBCCwEVq/T8aw/2Zecr7Z4h0qbUrH2gQ8Cy+aI0DLMioGRGpJfAG2yLSfjROAIlEYKFoOrzQY/XJ9ABkHo/l5FS+xafyTz5AZo3f8pGVlR+DDU2m14TiIClOwd/Kc1Ix7hHpu7gQr4Y1rCrRqs7k6k037PocBaxJrlEvyhUd5WZ+ryP2x2GOAsPlWPO4L/iYw5Ahel5phjT6RE6ZSFC9VqPqyNsKhT88oLbJisembqVxOw3oFFYiyh7u3Og+qJ7c4gpfcWGXNv5SFFeLpXwPpkygdyMSlaahPgD9s2JyQ3AZ4RLVEw+WkqNi6AJH3JKos97G1q1+C3MZxFwp4qCUTkn9yCgmGJ0GQ6mIOqh8w5WhdNliEf/DbVisUsEAsCnrrBz1McPp3fMy2C0vzeOZR/TYahgZ6K98D+5nq3/nu8Se0FUWTWaPcO1JjB3FFY8vl13FtWToZp1n7EqH6diUvVP0XXuHZHu30JpQJx0WG8XIPXS5o0bgn9uuaHcssE/drEkGrDzF7Yc/QcQUM18Ts2jVzLpPdfFcPeyWzDXqm+3KNKw1jwqLR9zk1WaCo4/8QGLYohXRI5Peg2oNU2PvanvlaQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(396003)(366004)(136003)(2616005)(1076003)(38100700002)(186003)(107886003)(41300700001)(36756003)(66946007)(316002)(8676002)(6916009)(66556008)(83380400001)(66476007)(4326008)(8936002)(478600001)(6512007)(86362001)(26005)(6506007)(6486002)(5660300002)(2906002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q4vu7PYUC/RtjlNFufVERbLu5Aa4c9Z5nbe1v/fYFHU4+xRVi1LxGpJbqS9S?=
 =?us-ascii?Q?aVsTI3dKwygSGW5OPJp+vpsMW6fP1CiECBeBdlKbLUIKRQ3KcoHu6Fgg/fU5?=
 =?us-ascii?Q?zRS/a1OzYTv8Fj0Jnk52naRtLoR7KITsgfqrjSK7XAJY0K2MjT95BMTtPmtJ?=
 =?us-ascii?Q?+0xVgblmM8f7R+2AVmk43YVlI0j+UorghfXendHv2JmFe0bzv+MJlVHQ/Jqx?=
 =?us-ascii?Q?HJ/pTJ8keISpFSzmWWG4kUjMCltI9m0gO4iSXsIHJ6WqTl3q8lI8mKN2ABfw?=
 =?us-ascii?Q?EIbQzLQU5KGYRM5soDZslvPuENXFP7eYd64hu3peK2gYNjOEClwZvev58Y7R?=
 =?us-ascii?Q?QxDWjC+fWdzzaTZbJq754hY+XCCVpuAqS9kjUwfWKIcnk58+Xag73XgV1jfK?=
 =?us-ascii?Q?sAPinT2hj7AZSLyYlny6gTGAAeW1ltw8tqMV839fMsKKDHQt7QeUdO5Ndxjb?=
 =?us-ascii?Q?NxfS/We0+1xnrUmOOrUhA50C3TBFck6vCVYMvyyb/LvvFyXW4tDVwZ9pY/6t?=
 =?us-ascii?Q?DVuKN2Ekii/zQPRoCBBf8b6X0H24uv9vLfvDv3gNkl64hHPrlyKKkVGk4fTD?=
 =?us-ascii?Q?zl0WhKm3jioljZbSVX74x9DOOF4gmna4w6i3CdTtaI0xR4z21VTVGgPRw7dS?=
 =?us-ascii?Q?4tQVv/Zk+/SoUb+D+Nq+iqMX7IUdZ411l2lWjvHlMleL7efYhK+/47C0fUdj?=
 =?us-ascii?Q?7dSTn2FUdcWLpExZFSo5yH8FS8cVSER1Zvu1bxXVhWoLuSBGrLSj/VPIn0e1?=
 =?us-ascii?Q?ticWqpK/D8Qu5JsIPY8a0aDZ4EcRniL0SEqJI/ICUWX+bhXSYeH7Uipaxj7D?=
 =?us-ascii?Q?edtz+CxXRZ4S97ZcoMPXWdx3sNyQs+ptJqxaI+d8a4rNhaNYxDZPf0PRfO0K?=
 =?us-ascii?Q?8DqBYerIOOao9GcHzRL5EfAyBpicrhO5wVnUtuuuoFSXLKGQe/dmX9yMe0mZ?=
 =?us-ascii?Q?uSX5rv8Im25W9t7tKWbK/ppeppzU3Sj30awjbl9plZKN9pgQVqpXl7cYbp9n?=
 =?us-ascii?Q?TjTMShCgVAYIfW3CyEIDjCksi79HEh0b/Id+j1NWIE0Aq5DuO5JSE23vW0u9?=
 =?us-ascii?Q?1jiBoNjI38fT7FTQPVdkMVw2P3/6rISU33avftQ8nwPzROrvxM0Gscc4s3ou?=
 =?us-ascii?Q?jhFhdAPVGo0Q9PIAYNTUWqFY3jiu0YiCtp2ThcdEkeN6VqvhljW9gyRm3Bzi?=
 =?us-ascii?Q?SxTEnNanc2YsPI6HrhhAwuFsg79F2L3mrXBLC8RFKV4JbwNT5Ddkjm8aZM6U?=
 =?us-ascii?Q?CvqTioNikAhP3KMBvWx4YTWkh6FYAyxnHj5EmVzj4rJWLzIc/VwWj9MoAil2?=
 =?us-ascii?Q?Cn6ZhX/V9CNgqTimHAqhPJzqAhl7FpUP0Gd/ijgYjbD4WHKwdB7qZrEksS4T?=
 =?us-ascii?Q?AiWLgIunHEoIX0+SewGTMMAYwrP9NVSunqHrmr3O0idhO5dFgIS58y6o4P33?=
 =?us-ascii?Q?rEjWr6Uf/VmeAOklWGm9EXMPuB/oy6Dkh2ZiSjokIDfFglXDYdedt74N5rJG?=
 =?us-ascii?Q?E2zIblpLtDjQdJrIZoG2gkZuPz3gfX/fxZn8FDsqiNZD7EUyM97Jgcrv4M3v?=
 =?us-ascii?Q?XvJyBKYTdY4+j7pWIwbbCvp1RUFZE9GUoZ2hVaO50KLFFDx5HzdhS887yIxa?=
 =?us-ascii?Q?QSIhK/pvc7VwR+LpOcTSnvvp+NGmISu0DXh4AXU7ZU4JBs1zqlQBapw+0MFh?=
 =?us-ascii?Q?R3FclFULdiqkkpRS2ZKK77AtT1R/xe5t+fBMUij3trtkgod3GeKFTE8ccDWf?=
 =?us-ascii?Q?5vZ0Qikdww=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b00d4a09-233a-4e9f-4571-08da5360ff1a
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2022 08:35:29.0723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FPFPFBN4CdXSZSQ6vE+A6ARphvxXNr9lIz3igfJNJgIPvNvsh3PkOwOnvTlIDP82ybe6PkUxnQtUD/VWDvwFcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3832
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Currently magic constant is used for setting 'flood_mode' as part of
config profile.

As preparation for unified bridge model, which will require different
'flood_mode', add a dedicated enumerator for this field and use it as
part of 'struct mlxsw_config_profile'.

Add the relevant value for unified bridge model.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/cmd.h     | 21 +++++++++++++------
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  4 ++--
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/cmd.h b/drivers/net/ethernet/mellanox/mlxsw/cmd.h
index 91f68fb0b420..150dda58d988 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/cmd.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/cmd.h
@@ -713,14 +713,23 @@ MLXSW_ITEM32(cmd_mbox, config_profile, max_flood_tables, 0x30, 16, 4);
  */
 MLXSW_ITEM32(cmd_mbox, config_profile, max_vid_flood_tables, 0x30, 8, 4);
 
+enum mlxsw_cmd_mbox_config_profile_flood_mode {
+	/* Mixed mode, where:
+	 * max_flood_tables indicates the number of single-entry tables.
+	 * max_vid_flood_tables indicates the number of per-VID tables.
+	 * max_fid_offset_flood_tables indicates the number of FID-offset
+	 * tables. max_fid_flood_tables indicates the number of per-FID tables.
+	 * Reserved when unified bridge model is used.
+	 */
+	MLXSW_CMD_MBOX_CONFIG_PROFILE_FLOOD_MODE_MIXED = 3,
+	/* Controlled flood tables. Reserved when legacy bridge model is
+	 * used.
+	 */
+	MLXSW_CMD_MBOX_CONFIG_PROFILE_FLOOD_MODE_CONTROLLED = 4,
+};
+
 /* cmd_mbox_config_profile_flood_mode
  * Flooding mode to use.
- * 0-2 - Backward compatible modes for SwitchX devices.
- * 3 - Mixed mode, where:
- * max_flood_tables indicates the number of single-entry tables.
- * max_vid_flood_tables indicates the number of per-VID tables.
- * max_fid_offset_flood_tables indicates the number of FID-offset tables.
- * max_fid_flood_tables indicates the number of per-FID tables.
  */
 MLXSW_ITEM32(cmd_mbox, config_profile, flood_mode, 0x30, 0, 2);
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index a62887b8d98e..f21c28123ad1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3376,7 +3376,7 @@ static const struct mlxsw_config_profile mlxsw_sp1_config_profile = {
 	.max_mid			= MLXSW_SP_MID_MAX,
 	.used_flood_tables		= 1,
 	.used_flood_mode		= 1,
-	.flood_mode			= 3,
+	.flood_mode			= MLXSW_CMD_MBOX_CONFIG_PROFILE_FLOOD_MODE_MIXED,
 	.max_fid_flood_tables		= 3,
 	.fid_flood_table_size		= MLXSW_SP_FID_FLOOD_TABLE_SIZE,
 	.used_max_ib_mc			= 1,
@@ -3400,7 +3400,7 @@ static const struct mlxsw_config_profile mlxsw_sp2_config_profile = {
 	.max_mid			= MLXSW_SP_MID_MAX,
 	.used_flood_tables		= 1,
 	.used_flood_mode		= 1,
-	.flood_mode			= 3,
+	.flood_mode			= MLXSW_CMD_MBOX_CONFIG_PROFILE_FLOOD_MODE_MIXED,
 	.max_fid_flood_tables		= 3,
 	.fid_flood_table_size		= MLXSW_SP_FID_FLOOD_TABLE_SIZE,
 	.used_max_ib_mc			= 1,
-- 
2.36.1

