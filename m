Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CAE75509AC
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 12:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232252AbiFSKbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 06:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234540AbiFSKbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 06:31:09 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2048.outbound.protection.outlook.com [40.107.237.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2D3101C4
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 03:30:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RwrsFmNPNuvm4pBpt0FWQPLhcu87mIYCPr9VHsqO52a5CoYCvXcPA6GsjqKCDe7DptFIrTmXuUTtcSm3d7pA90l06bS0f5a1Lc5Dmzyrc8JcmTkC+JktfsHFRiTP8gaJgxLa8wkfXb9RuwOz8LIcbdgGAzzZRWsxfil/oho46REow4GaqcvjAqKqlacLlwP2NDCEX0W1GFpjShMxUSYj2nPCNnZUXgjcOM87/HCSnAyVmROZrVvYrTdOIBLRT/Ni5pSlNH34+WbLLrDeXmo2NWhuipAgjopcayphEwo30W6vtFPzLlx3qqSj3uetnBduiqxlmA+1gYyZzv0wZoislg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4l5oWJ01lIGlIyd7P8uB8pqZtYZiSFzXlSSYYS8fYWU=;
 b=RXdIjglRgfv8mrZamZeAUsyeuBrdoYiY/VAjC6IvSbuCO4yVmco1HyMho/IWpVmkIHO0kAY+auDIgZiyhqb8lCQ2zJ2vzfy0+fctjjiH1wQ37eDwoDkdQZmh6sHMku/vyU0X8FTAyLyjCtLwnUNA1qbp26ksM2pKKDqAOvuMgutV6WPjNvsM4q0U62uFWDXugFOQHcRFs8YWcmIpktK7vkh8KXxLELGFKsbAzLDcEAVSWEJWHlnI8vEqO7XkIhD2QOrP52IJCWVwLxGhuW0Mip7sRa20HDDw+AypXbUzbVF4+G/zJqHAV3TLbu8GTICWrFEgvsGVanIxmwQR0PTYew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4l5oWJ01lIGlIyd7P8uB8pqZtYZiSFzXlSSYYS8fYWU=;
 b=Oer2eT6fnT/Svi0XMesI9nrMiboYfD+23leKH0HrK5dpSBDLuWESmhxb6geGR8NKFXLuXFHDxOAiOK5NUykmsIaCCHI/CLCNQorc6L17oWptj3XsSJh2Ts4rP4/0e0JBG+IXYogAnUIBUNGueOJ3vXKk41AYu9e0gWFWEDIt0XhTQPzIpbH5tXSsiW3umWiuu6UlJwv60eaORZRpQNkx9hJIXwY26YrDB0fztTPkcDDZwa3Oe3te8pS/C9i0TxTbtaVMPkC4pnGlMfHTNXav0lhieSSxrdgLYSQbDk5DuLGtnt2ZmjX9Lpr56UFdAwHU8xPb+w2cyYtW64kAlU5Vmw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM5PR12MB1193.namprd12.prod.outlook.com (2603:10b6:3:70::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.16; Sun, 19 Jun 2022 10:30:58 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Sun, 19 Jun 2022
 10:30:58 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 11/13] mlxsw: reg: Add egress FID field to RITR register
Date:   Sun, 19 Jun 2022 13:29:19 +0300
Message-Id: <20220619102921.33158-12-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220619102921.33158-1-idosch@nvidia.com>
References: <20220619102921.33158-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0053.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:3e::13) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 04c93fb1-6db6-461b-54cd-08da51decc68
X-MS-TrafficTypeDiagnostic: DM5PR12MB1193:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB11933CE25F8DCC7FFB123BD1B2B19@DM5PR12MB1193.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 39QTqIi0Zg4DzeKaQLzVl54FOPg0qpxXRKsxcgaMaBjRJV94nfBchTlYEWFJuHg77YbuosuJpsSxweQiwXzM6H9ODM7ga+A73M3BOeBNBZz61bVIJCmFx20CWL/75JQhHF463v83Gf3kdt4d4Bty3097en9upm/I9ztIqa5AWWTRPjlDvVPakZBrOh7KyNZK6YoeP0BDz4uIVoZebMVayDTdY6aDGpkVHM7aropSea8v4TysDuinpRwLiYUau+C9P9IuBPI+kOMHzqYy8f69Ri4jHwgz/MQ9iYIGGoGPYR0gUuRu9iMuV1in+n1GUqrsOQdQax0682jhYQZs9RkVgbZJcQR/hsxQ4YcauNIOr+2TI858qnOMmCatqsbwz+7R5IqMTj54ZKxtufGY5XuP6ylpGMIyvdg9AIk7SV9DAnd586omgVqRhFkP7ZjQ6NWnFaiYR4Ce+qt026RlemISKUsjWnzMBHDRdTK8lpQY+9zWYtyG9vHgHX/jmM0MpTsLx8m8lTa8UKHYHseduVHjnTxG7708lSXmmYSEnIN8QaCtPtcxbjWPYSwh8sHGfeUxjZYyZqi2/JFsPwVPhkrrXG2Y7u/UbHiPz5EV7xxCo325hXr23dWia0KYfGCQzdnB7F2ucCavpJ5BUkaxMiFTqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(83380400001)(36756003)(26005)(66574015)(107886003)(2906002)(1076003)(186003)(2616005)(4326008)(8676002)(6506007)(6666004)(66556008)(86362001)(66946007)(8936002)(66476007)(5660300002)(6916009)(6512007)(38100700002)(6486002)(498600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aT/gvMlp2/M3cbpnfes+DtIzeWNxcHVKzosxfnCKGjEuQdgDo63NWrJEKZFW?=
 =?us-ascii?Q?Vc/mrTk5yma5PK8UfZuRfvmP/U6vNhyJgG2X4cANXxJv46MuFmwHOn+PBmBV?=
 =?us-ascii?Q?3A3bj7uswqZ0yyI8hxgHSzy/9FMDYu4+0CtpJG8dGWJ1fAQK7jauKZQWXL1q?=
 =?us-ascii?Q?BOkq5ACob0zM3GLhblYLKYiSPUaLsIuBWZ8rKsoQ4mWFzkeCruceF0ruyL97?=
 =?us-ascii?Q?xtMRJIv6T805OPD7WZzvllPs+43PDCv5esSZrO6zef96+2CuaHqPGKt/AmuB?=
 =?us-ascii?Q?2LS8jVE+V858JxozIu9FdHuzx+kFNoIvS8LgDxECBg/LtLTGhAQxToSEcs0V?=
 =?us-ascii?Q?NaABoSdct3KxOL3lIoqHt2UFUfYVg6yiWO0BNXJq7Nv1VIBsuiRT8YSF9CMM?=
 =?us-ascii?Q?pqvfx8mySxrsyNIwykfP6YxivcYIlVjg5KN6kbw0sHOIUX5wwh+JuLEi78PG?=
 =?us-ascii?Q?F2iqLVpGHbld5S1zKOVKkRRJ83hUAJ+gO3Yc0esDN/fgMLzL9hU8bYQc4QyS?=
 =?us-ascii?Q?c5dGU207Bl0nc1h3bZBSkAfQGvWVCw4biNuHnmcx1cbYWkWDM01+qHqi1uw7?=
 =?us-ascii?Q?P+8IlrndKnGyHFZIhDx086HNFTUl7JrTKVs+Duc7QSQF95rCowJPZv2krtrr?=
 =?us-ascii?Q?zuImHVQSjMvcE8OJQXE3HLhceUiamY/KuAZ6/4Az1j3ox8wNnn7BF0b1c4xp?=
 =?us-ascii?Q?5eM9Gb5MESfkXIdzu28BBONqziwQic1+VwEXDem7EZG2+e7uM9PeYilaFVvg?=
 =?us-ascii?Q?xiuC/CVO1+XnEyJ1uyrV29JjAflZnm4uquiN7gOe77aF1TbXj0lV30pSPaZb?=
 =?us-ascii?Q?DCLcI9T8SrZfaP88Z23YMk6DP8yUejs7J5VcnCEFhOWpcM+/OvDTBSHsyGLO?=
 =?us-ascii?Q?6JOZ16zN34Aj5WRrsVWIVNdOTgolM+sYqSsZfe7M6+P9NPNwhWPh9yFEyF1o?=
 =?us-ascii?Q?IaOg2h7eZZKV3vbOiCAcPWTj9AfBp/3T+emC5rnsjeMEFrbgVK1LLGZ9XvAQ?=
 =?us-ascii?Q?r6KawY/MgWh/1eyjvkqlV03B8r/kRIHmuRa0qPsUtoXzwvEm2hxCbxxrAAeV?=
 =?us-ascii?Q?nTyuxDsTObrw9puZ31ZnTAQDHI+CSDuIzMG9bVgfYOC3+s8Uxd1dm9KeuOXq?=
 =?us-ascii?Q?NBKF4Ca7ptaPPlFLOtXDbSClITxvrA7h/tQ310OOyYzYnJLeWtkETnSE9447?=
 =?us-ascii?Q?UC6qZmKBhaqSVdJGMXSWS1tUslvubeaHYMmVa7bP2m8/M4kprcMoPseyO0ew?=
 =?us-ascii?Q?uIEpCdrMY5VN+YqDK/eOCViICt/EKGeYkJXUjGcAwMK8a9Yj1ArxAiz+o8Sc?=
 =?us-ascii?Q?aDrrUejVZmRJEsdS5n8+ZKC44P6bBV/Nbdku8sulz3Z8oRpcKe1avWw5CGqi?=
 =?us-ascii?Q?Ync5ooj/v0/0fOkViCvSDNynviPNMDZYhGrPwiw0oZh9nq6s860wREpu3zxW?=
 =?us-ascii?Q?fU9UBmnjjlrH3zrt5fFuPS0D6FGfuNVnqKge7NdFVZK2xEyOhz5qI7xYVrzR?=
 =?us-ascii?Q?1zPoER0M7TqEIqx/LFz7P+OSwol7uQu0vcqld4xFm8SbdLaYB2PEb+gnQP7O?=
 =?us-ascii?Q?cz90JLXHTksDo9cseoVn9ObgxaB+MWX1yzLjXxqgZVqBw3EhGrSQTKPq67HX?=
 =?us-ascii?Q?Xvj6PKLvGfQo4nLQypx7XmGbnF85scYG/y2LX+ouoQis/7Udes9LKfeCVcUG?=
 =?us-ascii?Q?4RVPl9uToYJ3fnViAhi1H/IkTLMDo7zM3tY5jm8hqgiYicnmXZ82kzb4L+1T?=
 =?us-ascii?Q?f7lh316DMA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04c93fb1-6db6-461b-54cd-08da51decc68
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2022 10:30:58.1587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jBky1IxD7sFuhJKvD/bkA8cZRPse1hHd1jhDwjUaRnZtWqSK/32Jm6ADl4y/YzwllB3lG1kiCiwnxH48KQJ5FQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1193
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

RITR configures the router interface table. As preparation for unified
bridge model, add egress FID field to RITR.

After routing, a packet has to perform a layer-2 lookup using the
destination MAC it got from the routing and a FID.
In the new model, the egress FID is configured by RITR for both sub-port
and FID RIFs.

Add 'efid' field to sub-port router interface and update FID router
interface related comment.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index b9f91bef74ac..9992b64d0415 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -6885,8 +6885,10 @@ MLXSW_ITEM32(reg, ritr, vlan_if_vid, 0x08, 0, 12);
 /* FID Interface */
 
 /* reg_ritr_fid_if_fid
- * Filtering ID. Used to connect a bridge to the router. Only FIDs from
- * the vFID range are supported.
+ * Filtering ID. Used to connect a bridge to the router.
+ * When legacy bridge model is used, only FIDs from the vFID range are
+ * supported. When unified bridge model is used, this is the egress FID for
+ * router to bridge.
  * Access: RW
  */
 MLXSW_ITEM32(reg, ritr, fid_if_fid, 0x08, 0, 16);
@@ -6917,6 +6919,16 @@ MLXSW_ITEM32(reg, ritr, sp_if_lag, 0x08, 24, 1);
  */
 MLXSW_ITEM32(reg, ritr, sp_if_system_port, 0x08, 0, 16);
 
+/* reg_ritr_sp_if_efid
+ * Egress filtering ID.
+ * Used to connect the eRIF to a bridge if eRIF-ACL has modified the DMAC or
+ * the VID.
+ * Access: RW
+ *
+ * Note: Reserved when legacy bridge model is used.
+ */
+MLXSW_ITEM32(reg, ritr, sp_if_efid, 0x0C, 0, 16);
+
 /* reg_ritr_sp_if_vid
  * VLAN ID.
  * Access: RW
-- 
2.36.1

