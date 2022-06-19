Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 812DC5509A3
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 12:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233487AbiFSKaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 06:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233210AbiFSKaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 06:30:14 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2076.outbound.protection.outlook.com [40.107.237.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29707CE36
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 03:30:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bPvMyv47EzOF+6o2qKml7XKJ/opebfaFsomJNjTlnAryJ2QrNP1d9bWybl0X1cCUe7CqNPUIUlHtPKk7GN9lfz7pWNgXtrb+LAXp50r7UrBxxb7c00GlQ/UPQzaqfh4Cx/zytonxYKgcnwUCM6X0nBHiXklNxVzajX+6zg9Z4+er8WDY+gv4Ue6duLYw8HbIuF9tWOpfqHPJKqRgM71hWlLV4VabxHELpOFoOMlFQYKHLb38TBx2j9JZmOMuynyvqHZUlhS6a10Gdojc5rKSkDc8O59ZLo5GcxZW22Jxsy9enFPtOVdddDGB2taUpQWKoY/94vj+0hf8TwWYeR4hbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m1w6/43JG/HcmoVa6OtI+R7T/L3iPUPPfwiDs+P8L4E=;
 b=Vq2cLfpFSzXmcMjj/t3brHzQZVJl2iqaOEFHNxyC+8aOX1i3+bQrecH58TlMOJeVkYSMf6f0fcagvWFCTLK1KU3D0ESZNAms4vnCL1CYPzQhc38RTUem8mU0ykg6ajVHNIk9S1zCnIlKB7j3u0zFJRo6BzUbtqerY7IJ8+S4tZHVvcaLBFaxsPhUfvEVw/NBggu+x7Yya7zzCeqW/8yLpNKUx//rXltyWtBxvZukhiGrtHdGGZCw0GZGQBae2/w0OtrrgtAVhESZGM4biVBHzflMfYrIG/ZhAequCY+JEAzXIGvXezbsGx31yhI+TS8n7w0nSfbHVeq2DKb6B26jpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m1w6/43JG/HcmoVa6OtI+R7T/L3iPUPPfwiDs+P8L4E=;
 b=B9uH/9VmtHx//MZmhA0NXnp16Jbs+E0EkyBMYW01E0X8QU30kEWZdAexCAB4PvT4hR4u87Ql2fmyy+hlZDDXuPo/hXu3l1d29hKUpLPCfrGgQVXRzcKKCHjWvkk+FXoKeB7a3G2Xgvyg2KN5guEvOgV/xBP+wqTYXiSBSc7SM6HHZ8l6u+o0GLxKB9BTf2NKE4KRoD0ucM37wHEyRCZrITZy9SJ+oyJdMlyAUXLP7NXCGR2+ycyQTRxz3VuZTiogBML2e/yXHqhPG6OrrtL09iuwgCJyNOuokqT5dgYLbg4+CVeF8V4Bj+WAUhp5o15ngCzvkZTg9JVjwX6mrXvhKA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM5PR12MB1193.namprd12.prod.outlook.com (2603:10b6:3:70::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.16; Sun, 19 Jun 2022 10:30:11 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Sun, 19 Jun 2022
 10:30:11 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 03/13] mlxsw: reg: Add ingress RIF related fields to SVFA register
Date:   Sun, 19 Jun 2022 13:29:11 +0300
Message-Id: <20220619102921.33158-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220619102921.33158-1-idosch@nvidia.com>
References: <20220619102921.33158-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0168.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:55::16) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 653fdcb8-a066-4167-7097-08da51deb09d
X-MS-TrafficTypeDiagnostic: DM5PR12MB1193:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1193FF23E3BC4E08B53329D0B2B19@DM5PR12MB1193.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WL3eLyKzkPM4nJjSAd4AnrRkHJ/EBZpZ1gDry6+uGwasOIxlMBu8AZYH6bWnvLE9tju7Mes82sgwNGfoQ/E9cn3mgUoSRcY353UIRkBGpOB0k9Gd+/1hOCUdj99ms7BVne6LyQzGhWXgts2hyyIsIqrp9bywatreWipXzcw4PsmJU07QyBk5A/Cki661mx9L6sVVmBG/KXEmNN8utmVGl2WNpZaannaapQLWqjVYCCrpBli8S/+zlsZ0RzmeDrQpKPpD23ti4adcvWewviX3wBbATFTJZ57tTEvB85RyN94BH691x8uzNjDENA8tVXrLj9DyQ55/+2aW81cxFEUtcKHQD6lx/xeHrazobAJ/XgEdBeWDCA96SHwgMioG3C+z7ce13oNNcjL7NyTS86DtozGCY18quYMUBMWc2Syda8D+VxDMbX0bKdzPe5U5MKoulIuuL4x6k6/1nDo6CYYz3tsyefntwOnz/NLULk563RFk8WY4NjcmTsHoNeXr64+x48DbbKnnmmiwZbvTVQughyqQ8R1YtUfHaFE5jJUpFqDW0qrLxySJ3Y7QyqG0EjITODnJu4kq94dvijBQfmTV955YFC1T6AhyjhGLSb8Wd/vM5Xu1gTNxqjgH9ozPrQXGw9mT5UFMVfEJ7dbgIFcAoQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(83380400001)(36756003)(26005)(66574015)(107886003)(2906002)(1076003)(186003)(2616005)(4326008)(8676002)(6506007)(66556008)(86362001)(66946007)(8936002)(66476007)(5660300002)(6916009)(6512007)(38100700002)(6486002)(498600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xAY+ZIOX0xwlSLjRNiAUAkcWUovY0QGhe2SgpB2BK6cEUoyGLmhQsQUZCmo8?=
 =?us-ascii?Q?6KXF6SYy/GdF/R0FM6h48J/7LGJ80WL28OccpSqhh1CQOBLaUxkw1gg9iGuT?=
 =?us-ascii?Q?V+8z5JUq6BA9BnDJ/RVqHy+q/JFKf/qpQjCDl4zfSDGd7LXN0ac0Tgq/xR2b?=
 =?us-ascii?Q?0o+Jg72uka8MUIQBU++e3CMaVpeG1x1LkGpbL/tmj1kpyAdCa1S/YAfPyter?=
 =?us-ascii?Q?/kF3he9RwEUSoHhdhBrNSkbWrDgJl6k1yAxjEwvRXVFi5vzOFD+bv+N8fAme?=
 =?us-ascii?Q?JMQoGjanB5pSowBKiE5n6iUHaI+yFnwVqwNZ0K0fIkAPyoANncmmV1vu4mjs?=
 =?us-ascii?Q?uzuYoJngDQkuHFO0UUYZGbHa1qow2PUp0qeo/mLAvm1k/0t+tYsLQf+9D5IK?=
 =?us-ascii?Q?0nUzgTXq1lWZx+UtYQhe+7BDvwHVztwlJ7TZEzYRjnqCqT3/yVqc+ModCW8B?=
 =?us-ascii?Q?Hd3Y7hjNeag+QGr4ziB1PRcQFWTSPKjymjH7eR59C82XlyQsSsaBcAXmKZL1?=
 =?us-ascii?Q?9UiqoipaSjKwef499brQrKV+KSrLQldM26W8Y5robmWfoC5zvlq+YnPxlqBU?=
 =?us-ascii?Q?0ikJ8mkyKuZjs1YXB8fWG9frFxkMQk9LmKcgmIbQjcWxMiakg18CdQjnMXhf?=
 =?us-ascii?Q?tDA7eT2x+lFniI/kpANSCArXPE/7Elqnwp32KbteHYipIMxiFpB0FjVdvAQM?=
 =?us-ascii?Q?6Gz89XuXYnBMYVxVk1xaryEXL506VbOyztng6LOCG2l4aKU0fRHhsuYrlIRx?=
 =?us-ascii?Q?l4gZwyP+isJLEFZiWwV0RLlB/T1gfwRRz9g/JMTygWLUobgtaTMiTQNMeCCb?=
 =?us-ascii?Q?shHJ/WfTZd5rERbzXZSqKPq1xqk5KBrNjSEkIiApge4lJoUIaIBCknrQo3lj?=
 =?us-ascii?Q?4mjWn3bJHtK5hEbmQuKmh8Jz/hcdvaC3SDDWi2mMIHUy8Cz8fvCExOOwaI4F?=
 =?us-ascii?Q?nYim3yQb6lFxQ9yoX7O76gFd7XxlVxZDkgFa1PvvrtnCDmYqJ/zO3khYP/hG?=
 =?us-ascii?Q?CDsxYLNRve1maZ492LrC27YrDRIX5fXDcdfACoL07FeYw0mQ56D3jkSt7Pn8?=
 =?us-ascii?Q?V5M8Y/eyPdd1LPnxcPbX+B9sThrmqMO8y0Po3vvdHN2gngfYVKFimg8Vnp+M?=
 =?us-ascii?Q?u6DWv6yv2TRb5L1N2ONpRwh2a7JdWQxRTc1tngF/71IYlSjADKgggQLqqTat?=
 =?us-ascii?Q?8E8nUIchwRlIxK3uNiSxydrtJHn/osx14wC3aId628Qcnjqvbv/tv5OvaIxb?=
 =?us-ascii?Q?Y/pCpZse5MjHcFOCaAiVWriPHjKzbP7OhWAXdPQrRGibQCxU66c4XWVQ+DD1?=
 =?us-ascii?Q?rIFC6UW23IGuAKD7cM5NPOsRzvKLU527d2AO3yHjtLOpPRRVwSDm7DKuiTC3?=
 =?us-ascii?Q?4nh+2q7TCQ2JNnKUVbMnvSfEILrnnrJGlMIRCa20XApn3dSpqfDaRKwO82eN?=
 =?us-ascii?Q?TDQ2W3DSF+h36Zw/8BSUrgQUr35uNf3uey+WsHrZiS6a0A4ld6D5+H9ywmG6?=
 =?us-ascii?Q?rBy4Mj8EvTRC/3RkAc6YHKwpiL3zcJkTyxNVd3cdM4Yos0SJoclDgnRxL4Wo?=
 =?us-ascii?Q?/BcYsSVCbMwb9u8/fWrsKEkB3gZx0SgxcScmTU8BXaq1PjUzWtHac2253Lpw?=
 =?us-ascii?Q?y+Xw9/X0k99wbaNSBASKGA4nAOq6XPF2wiQHljkFy0IFQP7+d5Y7ZqY4Xnd9?=
 =?us-ascii?Q?CTIccBuCXjUel4T0dDALWwwSvg4rIQ4h1E+hI1EpSDEZpPHJhbqYL90fWL+x?=
 =?us-ascii?Q?NurlY5s5Zw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 653fdcb8-a066-4167-7097-08da51deb09d
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2022 10:30:11.5293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z5yLhnpUPxjFmmJNE1QX4eO6pHM7DK6Y1QYhl3mg22uG9QTgLpHG3vJqOcEwUw7J2vQCf1fSofzcxLhPBPgTeg==
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

SVFA register controls the VID to FID mapping and {Port, VID} to FID
mapping for virtualized ports. As preparation for unified bridge model,
add some required fields for future use.

On ingress, after ingress ACL, a packet needs to be classified to a FID.
The key for this lookup can be one of:
1. VID. When port is not in virtual mode.
2. {RQ, VID}. When port is in virtual mode.
3. FID. When FID was set by ingress ACL.

Since RITR no longer performs ingress configuration, the ingress RIF for
the first two entry types needs to be set via new fields in SVFA -
'irif_v' and 'irif'.

Add the two mentioned fields for future use and increase the length of
the register accordingly.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 26495b29e632..d237f889bdcc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -1516,7 +1516,7 @@ static inline void mlxsw_reg_spmlr_pack(char *payload, u16 local_port,
  * virtualized ports.
  */
 #define MLXSW_REG_SVFA_ID 0x201C
-#define MLXSW_REG_SVFA_LEN 0x10
+#define MLXSW_REG_SVFA_LEN 0x18
 
 MLXSW_REG_DEFINE(svfa, MLXSW_REG_SVFA_ID, MLXSW_REG_SVFA_LEN);
 
@@ -1586,6 +1586,26 @@ MLXSW_ITEM32(reg, svfa, counter_set_type, 0x08, 24, 8);
  */
 MLXSW_ITEM32(reg, svfa, counter_index, 0x08, 0, 24);
 
+/* reg_svfa_irif_v
+ * Ingress RIF valid.
+ * 0 - Ingress RIF is not valid, no ingress RIF assigned.
+ * 1 - Ingress RIF valid.
+ * Must not be set for a non enabled RIF.
+ * Access: RW
+ *
+ * Note: Reserved when legacy bridge model is used.
+ */
+MLXSW_ITEM32(reg, svfa, irif_v, 0x14, 24, 1);
+
+/* reg_svfa_irif
+ * Ingress RIF (Router Interface).
+ * Range is 0..cap_max_router_interfaces-1.
+ * Access: RW
+ *
+ * Note: Reserved when legacy bridge model is used and when irif_v=0.
+ */
+MLXSW_ITEM32(reg, svfa, irif, 0x14, 0, 16);
+
 static inline void mlxsw_reg_svfa_pack(char *payload, u16 local_port,
 				       enum mlxsw_reg_svfa_mt mt, bool valid,
 				       u16 fid, u16 vid)
-- 
2.36.1

