Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69ACE5509AE
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 12:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234078AbiFSKbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 06:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234804AbiFSKbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 06:31:10 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2079.outbound.protection.outlook.com [40.107.237.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29BE9101DF
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 03:31:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M0MOhRKJs0HDhi9cJ1PAh4YUEL4JmmILQWHjzyVNFPFI2zRElifqhwAGMfI8zUWkeAv5bCbvE0/xuLiwi3hUvxG/5d75ymijFIQToI/2ZoWmB1nwyrM4Ucj6c6zFunl/wlTfdDaSJUp8Sy58bgFvREuT73nvcLMTQgTMb2TRMkf5gu/RadgIIr+xGpcsvddYNpuC1kprr+Cdfp9Vku0lK6mh+3muEK/NItBOVtPtlb9UmSDov7jWQ6fPrP0I5eSld4B9kclx3y4BJOG5WLIaZXoNKzNUg10qihAFR1w0VMQUNWO8UEwrc+AJ0oIx2jaKuG8UymRe+0yBNvAegki1qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I2moIifz3dnDGCE88gp9kBRaBZUcdukGh7+SXsjLIqc=;
 b=K9qH4F3u6SblnoRtuIMtp1q3o7kCKjJ0aaPyqbO8cW1O7TbKCSZHByW7xULptfPUD9VO4q4LllDNFJ0mmMGAQ1ByCTFn1WsXc4uA1SO9agu4hxhoaMbEcb/f+clqDfx0nkdXSIC0UGHnkx6KSNyZUQ27hSqcCN4u1NPkFZz8ANMBOuQ7po7h/nxSI4bYFyjBaZkKBGS5uPCg8lR0vZR3EHuGwM6YTFjP3JegNPEO4K9/8I7h8aLLRHeoRevpNMMW5xbqVTijMeD3OzZ21ejJm9xcckLGCKWq5qBSjHa2AvDZIiyhadxxzc1Lf60GzNgOr7Px9m7UV17Y0Yj3VFnzig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I2moIifz3dnDGCE88gp9kBRaBZUcdukGh7+SXsjLIqc=;
 b=bG1xvgFqRRlYn+YKrmrLl2ApFUCmV+/BbUcedlmdJdBhzw+EuNBm/Hng0ivdOvSUj3lApbnXIQCrN5jUwpC0z5BXMKyS5wdq4RhMDkY4iXUXl/vWXl+tkLBTm2x5CIM6/g4zWz7zEQY3y0oipZvnuiKXo2ZjlTZIRZQOvNe/KHnBK0PdUjVjMm5nGtwCbvoJN2IrZGGhYfi0qd8fbjki5/h+80XwMtC1qJfFG5y0aUfgMcibXtGKSlxOZh8Vd87Hhe/yEGA1vuSo8nIxyAByB+Qf/P21LmbWg9Z1g25Qwhsxa1j7ZpvESp8cNqIHxn59sRnZZ0sfN33Y3r5T5DWGeQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM5PR12MB1193.namprd12.prod.outlook.com (2603:10b6:3:70::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.16; Sun, 19 Jun 2022 10:31:03 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Sun, 19 Jun 2022
 10:31:03 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 12/13] mlxsw: Add support for egress FID classification after decapsulation
Date:   Sun, 19 Jun 2022 13:29:20 +0300
Message-Id: <20220619102921.33158-13-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220619102921.33158-1-idosch@nvidia.com>
References: <20220619102921.33158-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MRXP264CA0048.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:14::36) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6731d7d7-5975-45c4-8dba-08da51decf98
X-MS-TrafficTypeDiagnostic: DM5PR12MB1193:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB11933621E438C2F066BF2480B2B19@DM5PR12MB1193.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IVGFESvwiLCD7QZWojP4Mfq4UKlMg07JWcNrr74Eu3CSx7gPzhPLhYaj6sDfNhFZTOboFOLiPG8yDk4ZGJVH/jeNoioiOtHaTlj7o2WW5cszFy14XV30zXqvoPtz/DwTeqqLEagF47H0QAswIaGXBU9WOQ2lEVfFZxN6cFmKIc9wUA18wY6x/2wDoyRDbk8oQ0by408/5jgXF4I8RtNQ+OtouuyyWxfRJtMelBj2lMSjiDDWUnL/sebxnBKstuqfG3wWHnMnndMmSdDOt+5lXH7/g88AO7P/TuLgp6pC58IewMqnV55ee7mEHuH2n3UyK0p0lzEqo3vvcvlLdpWZ6KDZfIsVlKDD8REPpcd9EOgCYW4pfyhZvpNieJXXDQPXfS4EXL0ph6FQrjRXGpqbDISjNo9kDbtj+ioAf/t3cVEfxsdm/Ys//wZjJr7XtMiG1UTWAEKh9TnbOvzq2/QDIH7ZRRo49kkK6J1/rh9p6A3k3SwPZE5nN/JhLb+gKstQZowW0abpRpaKUVjkyrYYzw87knmKvZMquDHRx5zYagDQ11oczMwpKHNI5SvGV/Q9zgYPrgx9Npcz6f+t2w/RxiPLDi4xn+A1XyGVY2vTQ5dXGMDq1wfgQi+40LSyQPRaimrwfpB38CXhD2gNlQDyOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(83380400001)(36756003)(26005)(107886003)(2906002)(1076003)(186003)(2616005)(4326008)(8676002)(6506007)(6666004)(66556008)(86362001)(66946007)(8936002)(66476007)(5660300002)(6916009)(6512007)(38100700002)(6486002)(498600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QQYFu+ndzagOVIj17QEFzNJePTTuY61wN7wFT1BxeEMxcbL6s83fnMOx1YlK?=
 =?us-ascii?Q?GHMOg/nCwfIU4TwLg7tJe9WBnES2VIEaLsueDF8OJMJqK1u2FYeMLqhLZ1Ns?=
 =?us-ascii?Q?DPksgtwr1aFCQsWkTTgr/Mb8F4dAOhIC5G/iOLSf6mtMA0H+D/c2W7WhulYX?=
 =?us-ascii?Q?BlXmF0jUQNQkSd8ewBybyFbZmIRXMlvqVS/UjdFHsdvwhJQdwhyC+iAU7V24?=
 =?us-ascii?Q?G0QH4R0/KnjdW0ZfyLRsrv9jG7cNDc++7VVwM7SXGIAJWZ3D5vMg/bs5dIB7?=
 =?us-ascii?Q?HZ+H+CALBgSxml5yEcaN1DvlTICsYI8kMARByqX8Nz8UBP47AQJwdIJXb41m?=
 =?us-ascii?Q?xOy/SjRKx/1smlFOvv1GMCFS+KGI+qd857ddaFuJNlFtqMJuoz74nsMb/I1U?=
 =?us-ascii?Q?4Mcj79qzUy7xKxBIXLej65dHglnZW+wSRbettsWlbNWrVbevA9npO/xy5gCT?=
 =?us-ascii?Q?JxKe/5ux8mKwljlFl7biISHVhR9VZuoyO4wO8zACV9suntqr/55g+Un4nEFl?=
 =?us-ascii?Q?IBfAIFEt+OhpidQVIc3yN+G0MnIX+vYpGgVQcHX5Dc5dr2LxiIRCJ+WRY07Q?=
 =?us-ascii?Q?T6l5p8CzMhtujPtfXfO6zxEyMY3q9uqzHRSThLlLvCo1esnN3HYI4tSEbwTE?=
 =?us-ascii?Q?D51qrDTNAa3B+eGWtH5AffjDv4NlCXZw/jUUWJn240zfZcqXPPa6fIfPBSFH?=
 =?us-ascii?Q?/hauCL9Tdzx22Oz4eoKgtit+KW/UGTwekIna5dMwKvFlHojh3lDzbnFOPwuw?=
 =?us-ascii?Q?9+NOCvm50WcV++muQNnzmLCaxXoPEk9MmKxdn5mvoVcY4UuRWtYeQKLF3Pm3?=
 =?us-ascii?Q?xJyn5U23K7HFEB/kmq9AoxiPsh0oX8BdiQxLt0Q1qfGgl++H5D86DwiNXz27?=
 =?us-ascii?Q?z5PA4oRWRG1yAZNzsbL7cuED1aS9SftzQdz0frg5zRSFdLH1Yfw3K9XJXpCW?=
 =?us-ascii?Q?DkIWGVDU9INAEtKqnxpp2xpPOQs22YheLoZbwRjkRwOSx+mebyVtEVBHWodJ?=
 =?us-ascii?Q?Zi+33N3fAiz8guCwVIPQZigTrLtVYqovWNmJCAaPAp8FDt2PrblfjFfW+iBb?=
 =?us-ascii?Q?EtYuSM04y6GfmYoHABdt4PgOO3hyD3TmdmaoMVoV9QIQi9BB8X22M60Xa1ed?=
 =?us-ascii?Q?aiia3r5eKnhZR9EHAnVNF26OYftmiYggG46A3mUe1MveaW4KOSXdkD3Ao69n?=
 =?us-ascii?Q?oHc41j2dZkVqMa1TH2s1mXhJlQsinkTscb5PgSUIIA6RMsJQNnus5iwdBlvA?=
 =?us-ascii?Q?zbggA05jsHYAO/p19XDVeT//ti6/KF28g7OMZbfbrvTSZArzEHjxmgn3fipw?=
 =?us-ascii?Q?Wcx34jYW08ZwTfHsoS6XWPu9mwEFTiMAklA1EQ+qFh+MTFgvhd+Lk9z2U/gj?=
 =?us-ascii?Q?Ob5u4hctBNSn7gXcPwbRVJvMT/R6lwqlbmbOQG4/H9XsdcnwaU6ohsSa1Pt4?=
 =?us-ascii?Q?3ZV6ZAdDubMkDx9tQ6xdMP05GphvGqIJ3+NDVAIeUy/LXLuLxIMc+jgD40pO?=
 =?us-ascii?Q?O8Sh1JxGaw5LDoFK6OFVJKq0N6vmFYWBW4u4RhXJIEDilKPlUOIQylo87wrO?=
 =?us-ascii?Q?3iNa5qSjxinOD/XC09je3sGH9gzYumcSMeqbjHHGwOMBX79z6K7slmtzy26t?=
 =?us-ascii?Q?X9c5eRWMnl+tjHfS3HaGcLN1VJIp+28ydXCZ7/dLv1gbYWucTnqJEoZrsoU2?=
 =?us-ascii?Q?PBm6+o1vXPXC7raniH416X0mTEfkBj0vskAVKr5Oi41sPz09fRfOMOsTRsGV?=
 =?us-ascii?Q?Z2mMgobmaw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6731d7d7-5975-45c4-8dba-08da51decf98
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2022 10:31:03.5067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t+y4wtr8GB4ROMzK9aIv3S1mvUtGAv6qfTO4nq8KMU58CiEW4hDMiqaoVFURV1pvT8Ljddk4g9h08F3idP2b6w==
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

As preparation for unified bridge model, add support for VNI->FID mapping
via SVFA register.

When performing VXLAN encapsulation, the VXLAN header needs to contain a
VNI. This VNI is derived from the FID classification performed on
ingress, through which the ingress RIF is also determined.

Similarly, when performing VXLAN decapsulation, the FID of the packet
needs to be determined. This FID is derived from VNI classification
performed during decapsulation.

In the old model, both entries (i.e., FID->VNI and VNI->FID) were
configured via SFMR.vni.

In the new model, where ingress is separated from egress, ingress
configuration (VNI->FID) is performed via SVFA, while SFMR only
configures egress (FID->VNI).

Add 'vni' field to SVFA, add new mapping table - VNI to FID, add new
pack() function for VNI mapping and edit the comment in SFMR.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 49 ++++++++++++++++---
 .../ethernet/mellanox/mlxsw/spectrum_fid.c    |  4 +-
 2 files changed, 44 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 9992b64d0415..33d460a60816 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -1573,6 +1573,7 @@ MLXSW_ITEM32_LP(reg, svfa, 0x00, 16, 0x00, 12);
 enum mlxsw_reg_svfa_mt {
 	MLXSW_REG_SVFA_MT_VID_TO_FID,
 	MLXSW_REG_SVFA_MT_PORT_VID_TO_FID,
+	MLXSW_REG_SVFA_MT_VNI_TO_FID,
 };
 
 /* reg_svfa_mapping_table
@@ -1622,6 +1623,14 @@ MLXSW_ITEM32(reg, svfa, counter_set_type, 0x08, 24, 8);
  */
 MLXSW_ITEM32(reg, svfa, counter_index, 0x08, 0, 24);
 
+/* reg_svfa_vni
+ * Virtual Network Identifier.
+ * Access: Index
+ *
+ * Note: Reserved when mapping_table is not 2 (VNI mapping table).
+ */
+MLXSW_ITEM32(reg, svfa, vni, 0x10, 0, 24);
+
 /* reg_svfa_irif_v
  * Ingress RIF valid.
  * 0 - Ingress RIF is not valid, no ingress RIF assigned.
@@ -1642,20 +1651,45 @@ MLXSW_ITEM32(reg, svfa, irif_v, 0x14, 24, 1);
  */
 MLXSW_ITEM32(reg, svfa, irif, 0x14, 0, 16);
 
-static inline void mlxsw_reg_svfa_pack(char *payload, u16 local_port,
-				       enum mlxsw_reg_svfa_mt mt, bool valid,
-				       u16 fid, u16 vid)
+static inline void __mlxsw_reg_svfa_pack(char *payload,
+					 enum mlxsw_reg_svfa_mt mt, bool valid,
+					 u16 fid)
 {
 	MLXSW_REG_ZERO(svfa, payload);
-	local_port = mt == MLXSW_REG_SVFA_MT_VID_TO_FID ? 0 : local_port;
 	mlxsw_reg_svfa_swid_set(payload, 0);
-	mlxsw_reg_svfa_local_port_set(payload, local_port);
 	mlxsw_reg_svfa_mapping_table_set(payload, mt);
 	mlxsw_reg_svfa_v_set(payload, valid);
 	mlxsw_reg_svfa_fid_set(payload, fid);
+}
+
+static inline void mlxsw_reg_svfa_port_vid_pack(char *payload, u16 local_port,
+						bool valid, u16 fid, u16 vid)
+{
+	enum mlxsw_reg_svfa_mt mt = MLXSW_REG_SVFA_MT_PORT_VID_TO_FID;
+
+	__mlxsw_reg_svfa_pack(payload, mt, valid, fid);
+	mlxsw_reg_svfa_local_port_set(payload, local_port);
 	mlxsw_reg_svfa_vid_set(payload, vid);
 }
 
+static inline void mlxsw_reg_svfa_vid_pack(char *payload, bool valid, u16 fid,
+					   u16 vid)
+{
+	enum mlxsw_reg_svfa_mt mt = MLXSW_REG_SVFA_MT_VID_TO_FID;
+
+	__mlxsw_reg_svfa_pack(payload, mt, valid, fid);
+	mlxsw_reg_svfa_vid_set(payload, vid);
+}
+
+static inline void mlxsw_reg_svfa_vni_pack(char *payload, bool valid, u16 fid,
+					   u32 vni)
+{
+	enum mlxsw_reg_svfa_mt mt = MLXSW_REG_SVFA_MT_VNI_TO_FID;
+
+	__mlxsw_reg_svfa_pack(payload, mt, valid, fid);
+	mlxsw_reg_svfa_vni_set(payload, vni);
+}
+
 /*  SPVTR - Switch Port VLAN Stacking Register
  *  ------------------------------------------
  *  The Switch Port VLAN Stacking register configures the VLAN mode of the port
@@ -1878,9 +1912,10 @@ MLXSW_ITEM32(reg, sfmr, vv, 0x10, 31, 1);
 
 /* reg_sfmr_vni
  * Virtual Network Identifier.
+ * When legacy bridge model is used, a given VNI can only be assigned to one
+ * FID. When unified bridge model is used, it configures only the FID->VNI,
+ * the VNI->FID is done by SVFA.
  * Access: RW
- *
- * Note: A given VNI can only be assigned to one FID.
  */
 MLXSW_ITEM32(reg, sfmr, vni, 0x10, 0, 24);
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index ce80931f0402..86b88e686fd3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -441,10 +441,10 @@ static int mlxsw_sp_fid_vni_op(struct mlxsw_sp *mlxsw_sp, u16 fid_index,
 static int __mlxsw_sp_fid_port_vid_map(struct mlxsw_sp *mlxsw_sp, u16 fid_index,
 				       u16 local_port, u16 vid, bool valid)
 {
-	enum mlxsw_reg_svfa_mt mt = MLXSW_REG_SVFA_MT_PORT_VID_TO_FID;
 	char svfa_pl[MLXSW_REG_SVFA_LEN];
 
-	mlxsw_reg_svfa_pack(svfa_pl, local_port, mt, valid, fid_index, vid);
+	mlxsw_reg_svfa_port_vid_pack(svfa_pl, local_port, valid, fid_index,
+				     vid);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(svfa), svfa_pl);
 }
 
-- 
2.36.1

