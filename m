Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 882DE564D91
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 08:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbiGDGOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 02:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232741AbiGDGOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 02:14:03 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2044.outbound.protection.outlook.com [40.107.223.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27AD65FF
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 23:14:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sr0DNYZdZil9E0YcARM9CdXri7Phjn6wvfkBMQLUHQAOgJEUafvLmY07Iyi9SIj1brbEMnBwYJ5oNjg0I9j5fyiQN96eri7p6LSp7ugACB/ZiENA7P27ai2tZjhRaQFrf8vSkWGbM+hItQ9PYSwJtDhKV6KZridJWyAOVe8wdt7/5u4CwWOMqPFtYjA8OCD8Ifobdz+Mszh3mz0JX6LeA9SfCYpSaLTRKjKfTQUdsE4MwlCHViiRl72y3OvjvFCgh9rAR8bw442ODLlp71Uj2xxBoN+9yQEwFdzzPFuNBK/bDnKGA82AGTSM8+mpnCew1dbi8hq4VS5ipO6rg4rT3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O6p4rhxZ8XPwIUPZH+qIJ6kW/n4k8GT30F0cFSTN6kc=;
 b=K8ZZJ4zNX3GzfAlo7K0hxK/p0SxcFhmq6UwVivC2S6tfEgnIQKwTdd6WQChGiqpBLlLryExWHrNE24WZ4XfyT1eSzi1ntTN5zqsESVncH8WNeLwWrUggD8FfaNZOzQAJvSP5j7Bb95cZqCET9D6lsgy98ZIc6tC4ilYiFBZNgDx3Jusd4S1fUqkFy2u0PrxJ1aoJD6e+WkepNg1lWA7EvEu/xRbZAppeJrzcqTam7RDUNUNoVlbtM7ErNcFFpsEfDXvR2vwSxa5kro6RXzBb4wgEIjK6siiH8PjsQbzeigGA09iOvdaEox/o7No99W/7XXmlJHIN9xJkDORKNp/w0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O6p4rhxZ8XPwIUPZH+qIJ6kW/n4k8GT30F0cFSTN6kc=;
 b=B/FA6W3JpnsDpboQiFdq6LHSbzkyDYiuEQuPOwG3RIgNAww6dPDGqjrjwZsVwbK/cIL90l0P1YwJLfsPNDqvOlOWwop8lZS+7bojLZnClqH7PdGxEem51TgiED42axo8fQLlocyBgNGzzcrInyCVCN56wLJxLE5V2lRBUltl5lTOaP5pUFH7YCdWpx97fjWis+kh9Hz+jKHeJIQPjnn1KoXbRK6/lb/9Q3OGfV/bybVfRk8or4ti+BB7kgtSe03AePIBZWoSDzTKAhKhQlyMfyrt1Gw3JGd7DkyFnd/d5hDEQxSry/u1dh5xmVLSG743wmpa6uQgGKzdoIXfWq2dQw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CY4PR12MB1862.namprd12.prod.outlook.com (2603:10b6:903:121::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.19; Mon, 4 Jul
 2022 06:13:59 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%7]) with mapi id 15.20.5395.020; Mon, 4 Jul 2022
 06:13:59 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 11/13] mlxsw: Enable unified bridge model
Date:   Mon,  4 Jul 2022 09:11:37 +0300
Message-Id: <20220704061139.1208770-12-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220704061139.1208770-1-idosch@nvidia.com>
References: <20220704061139.1208770-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0901CA0107.eurprd09.prod.outlook.com
 (2603:10a6:800:7e::33) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c64d406-7e39-4077-6f4a-08da5d846252
X-MS-TrafficTypeDiagnostic: CY4PR12MB1862:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fs05ZrZKehiJHtNhVOlsDUeUMvBHx2/+R9ZfXEGe3ZuDYdOTaSNlbc1jL8i3nDO23Gs1i0iZAI2w0yRa7qbBpHztDMDd0aqCshYEU+ufqfZtm1NDfKWQ67rmyXLFpsRyWY1ATl2zbVvEfFM2xG9bKtY6lOx3Rh5D7R4n3fxemOQh5gGFBODMV2obWzSMHbGFakhEDdmzxYbMqfbmK5yAsbncGlSwfLDMTkMYNDECy/8umibWNcroQ/Rci4FR0ZLMea8TD7pdcTj+aL2iv1httflNhbXJZKs2SCFJuy93W/bY0yHHfNQXQlp2VuE+135d25NznhlOaGRek9RXW/W6LHuYlhEU5E+jeo0e2I+DgQimg07VQKZo9pMusNGDtskNoz4bestJouFHoKr1upkwhJTxHridrdpyoLhN74NfFbCp2PvoI38jovlCwhIWjXvpM58ue9mZW8MZb9AXsD2JRNoqm+KGKa+AQnnT+/U+CazA4pCgY7hU7BXMfDafEg3avyuJxi5LEUxXEyMKZ10piJ3t9B2MhrVKJMiUaNY6ep+jRdK6p3+LUdxJeH6cRYfIomxX8YrgSOn7pgw8CjDBiMZQBTyZ/Bb4nzhNSl/rM/M8HlcUJUh9yjA2FkEsGmJxipc2kS0Je6fNIxtJJeRePtDjE3RLncgpf2oDWTGobwMrTKn/YgOjd55pdChM5PIoc4SQ8nsMnXBxMQVfkNonG5fZ1mw+A8f+xaWhh7mCt245OS3YkADQHH/jcIQpJorl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(136003)(376002)(396003)(346002)(2616005)(38100700002)(66946007)(4326008)(8676002)(66476007)(66556008)(478600001)(6486002)(316002)(6916009)(26005)(6512007)(86362001)(41300700001)(6506007)(6666004)(8936002)(83380400001)(36756003)(66574015)(30864003)(2906002)(5660300002)(1076003)(107886003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g02Q15Aqg5c6Jo2FecVLzHX5eKl1Akt8KyT0YrmEUxt++7Iko4o5TssfJZjz?=
 =?us-ascii?Q?kwGMTBmRioAL6zIk+E1CORDfOm1TAi34tYGdGX70fujTdUnzFb0PN94pfZDO?=
 =?us-ascii?Q?Ppjco6S2SRmKrrK68Qs0UADeXzKMVgu/7q6kknzzvlLjwx2cbYLZ9YMaIAdu?=
 =?us-ascii?Q?3KFmYBdmcktzpH2OUGTxU3YgzRWIBwhEH/lA0WqpSKTIxvUAtwcKQlUM6ZTI?=
 =?us-ascii?Q?KHqzh3bBScFgDUNOLHb5QD+BLi2oKf3Ti1qxaCHQbFUDsJ0iQer0ngworkzA?=
 =?us-ascii?Q?EapHWNKUDJdNE5cvz8sA4fkqG41mBOVT67rplaQsDO7R7J1T1RebuS5g4ji1?=
 =?us-ascii?Q?sbVNgvAg78Nvh+TzFNdk6hf+Z7BaHq7vr0WLEUsIWaEPcUtxSJNkE6DUSqwx?=
 =?us-ascii?Q?dBQC4oSsLFaAny7JWkriCGm79R1hZ5an73hoVcWXbskleewwVJzGPLn5jsLN?=
 =?us-ascii?Q?wosalme69PlPFMWJXD8Yv4J8Pc9m+TIi8EYl0r2vfZTSdSw+MlEUYDtu21z4?=
 =?us-ascii?Q?xuYTfP/lmJ3YdDqg18Dbt3t6AfxVOrKTC1lYa7C+rh5qgcZ4bDcboe9H6gVp?=
 =?us-ascii?Q?HuGEep9t6FA4UT2HjLawccV9xxDRoUt5LS0YrTM+dAPVYvAkoUNLpuzz1gWD?=
 =?us-ascii?Q?BJfW7NXfpxx97bPTnHnutZ6z8MPNLk8BzZoUVrQvCpNwAuA6IHExRWdKQh+d?=
 =?us-ascii?Q?xI4wTXYfilWz7IC4+/as1BqS1JAOm450JSsdOABJBTzLTo1HCo8rY0fnToMH?=
 =?us-ascii?Q?vodn68K/zVMAJsyDvGK238T6i8uO+Roy3Fl5pUrNvHrsyiTR8EHin/krTRmA?=
 =?us-ascii?Q?ykQYqLUNStwuErTJzhxV22Mmcebo13umzHaZk2Ey/ImX7U9RplLMBTehe1cq?=
 =?us-ascii?Q?ysMhjpeD025XT48qdfMqID6vi1CyauJ3STeivPd/fmr4O2mP6EmxImktk7AR?=
 =?us-ascii?Q?zp4ogOhdu7Y/EzqXhG1G/GxJbFonaj5aPeRBRo5BMInV3UsnpsMWzNG8w6ol?=
 =?us-ascii?Q?WD+ekWfPv5hHNdutPlD1j1aK8SuS/zGxtNfg15AdHOiYXNL5daapqSAb+xfW?=
 =?us-ascii?Q?9xhheZt0NaBw0fmEPba3Wfw2+HiZBi4G4ejOIPJymqieqne4EJCbh7rTI4Qj?=
 =?us-ascii?Q?xdcv6tzLauH4PbExJ1i6C9RB/RT5lt3H824gbQyR/MplfFYcgNplSGP64ZoO?=
 =?us-ascii?Q?JGp8ldwrUesUfRct50MFhxofrBF6SqmsGTGAKH0/0MwRcChgU6lZnkiYflfa?=
 =?us-ascii?Q?zgJ0jqTVDXsqkofJQOtX9wUWtSJr5TDEmz/rdMVheV4bUblzj1lqJsSD5X3e?=
 =?us-ascii?Q?CJib2If7r7uli2o9dgc+rc4/wHWRXaesLoDotYMnrn0nK02jUDzpq+UEGXxI?=
 =?us-ascii?Q?qRAIZFisKBJqpHTeLbwr7VdL7nvG/is648NBdzFivOvli7hSLvBjzileu0NH?=
 =?us-ascii?Q?qcGcuGLiwL2Q/TLXlP/SQJYntDqQGV/lqkfZ4ZOxzXJABFQY22n8Vc1N0bIN?=
 =?us-ascii?Q?Kwk6UsdSU0KfQMtj4KjKe14iQskvVXazBrXyFe/Uq1mlAB8p4AdiOYML6WGz?=
 =?us-ascii?Q?lxZ6kCqiLVGSzxmK273y6UdP82i2+1EtEZt58AEc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c64d406-7e39-4077-6f4a-08da5d846252
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 06:13:59.5325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v8mltAXq9KRm5uVzbGov+h8OHlKS1q5TK86EExS9vIglFsEj5z9Bv+u5GfS8nlKywt0fm8eGZDg2eZK34cvv4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1862
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

After all the preparations for unified bridge model, finally flip mlxsw
driver to use the new model.

Change config profile, set 'ubridge' to true and remove the configurations
that are relevant only for the legacy model. Set 'flood_mode' to
'controlled' as the current mode is not supported with unified bridge
model.

Remove all the code which is dedicated to the legacy model. Remove
'struct mlxsw_sp.ubridge' variable which was temporarily added to separate
configurations between the models.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  29 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   7 -
 .../ethernet/mellanox/mlxsw/spectrum_fid.c    | 326 ++++--------------
 .../ethernet/mellanox/mlxsw/spectrum_pgt.c    |  21 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.c |  20 +-
 .../mellanox/mlxsw/spectrum_switchdev.c       |   4 +-
 6 files changed, 79 insertions(+), 328 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index ff94cd9d872f..a703ca257198 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3161,7 +3161,6 @@ static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
 		goto err_ports_create;
 	}
 
-	mlxsw_sp->ubridge = false;
 	return 0;
 
 err_ports_create:
@@ -3383,24 +3382,15 @@ static void mlxsw_sp_fini(struct mlxsw_core *mlxsw_core)
 	mlxsw_sp_parsing_fini(mlxsw_sp);
 }
 
-/* Per-FID flood tables are used for both "true" 802.1D FIDs and emulated
- * 802.1Q FIDs
- */
-#define MLXSW_SP_FID_FLOOD_TABLE_SIZE	(MLXSW_SP_FID_8021D_MAX + \
-					 VLAN_VID_MASK - 1)
-
 static const struct mlxsw_config_profile mlxsw_sp1_config_profile = {
-	.used_max_mid			= 1,
-	.max_mid			= MLXSW_SP_MID_MAX,
-	.used_flood_tables		= 1,
-	.used_flood_mode		= 1,
-	.flood_mode			= MLXSW_CMD_MBOX_CONFIG_PROFILE_FLOOD_MODE_MIXED,
-	.max_fid_flood_tables		= 3,
-	.fid_flood_table_size		= MLXSW_SP_FID_FLOOD_TABLE_SIZE,
+	.used_flood_mode                = 1,
+	.flood_mode                     = MLXSW_CMD_MBOX_CONFIG_PROFILE_FLOOD_MODE_CONTROLLED,
 	.used_max_ib_mc			= 1,
 	.max_ib_mc			= 0,
 	.used_max_pkey			= 1,
 	.max_pkey			= 0,
+	.used_ubridge			= 1,
+	.ubridge			= 1,
 	.used_kvd_sizes			= 1,
 	.kvd_hash_single_parts		= 59,
 	.kvd_hash_double_parts		= 41,
@@ -3414,17 +3404,14 @@ static const struct mlxsw_config_profile mlxsw_sp1_config_profile = {
 };
 
 static const struct mlxsw_config_profile mlxsw_sp2_config_profile = {
-	.used_max_mid			= 1,
-	.max_mid			= MLXSW_SP_MID_MAX,
-	.used_flood_tables		= 1,
-	.used_flood_mode		= 1,
-	.flood_mode			= MLXSW_CMD_MBOX_CONFIG_PROFILE_FLOOD_MODE_MIXED,
-	.max_fid_flood_tables		= 3,
-	.fid_flood_table_size		= MLXSW_SP_FID_FLOOD_TABLE_SIZE,
+	.used_flood_mode                = 1,
+	.flood_mode                     = MLXSW_CMD_MBOX_CONFIG_PROFILE_FLOOD_MODE_CONTROLLED,
 	.used_max_ib_mc			= 1,
 	.max_ib_mc			= 0,
 	.used_max_pkey			= 1,
 	.max_pkey			= 0,
+	.used_ubridge			= 1,
+	.ubridge			= 1,
 	.swid_config			= {
 		{
 			.used_type	= 1,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 701aea8f3872..50a9380b76e9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -84,7 +84,6 @@ struct mlxsw_sp_upper {
 
 enum mlxsw_sp_rif_type {
 	MLXSW_SP_RIF_TYPE_SUBPORT,
-	MLXSW_SP_RIF_TYPE_VLAN_EMU,
 	MLXSW_SP_RIF_TYPE_VLAN,
 	MLXSW_SP_RIF_TYPE_FID,
 	MLXSW_SP_RIF_TYPE_IPIP_LB, /* IP-in-IP loopback. */
@@ -106,10 +105,6 @@ enum mlxsw_sp_fid_type {
 	MLXSW_SP_FID_TYPE_8021D,
 	MLXSW_SP_FID_TYPE_RFID,
 	MLXSW_SP_FID_TYPE_DUMMY,
-	MLXSW_SP_FID_TYPE_8021Q_UB,
-	MLXSW_SP_FID_TYPE_8021D_UB,
-	MLXSW_SP_FID_TYPE_RFID_UB,
-	MLXSW_SP_FID_TYPE_DUMMY_UB,
 	MLXSW_SP_FID_TYPE_MAX,
 };
 
@@ -213,7 +208,6 @@ struct mlxsw_sp {
 	u32 lowest_shaper_bs;
 	struct rhashtable ipv6_addr_ht;
 	struct mutex ipv6_addr_ht_lock; /* Protects ipv6_addr_ht */
-	bool ubridge;
 	struct mlxsw_sp_pgt *pgt;
 	bool pgt_smpe_index_valid;
 };
@@ -1483,7 +1477,6 @@ void mlxsw_sp_pgt_mid_free_range(struct mlxsw_sp *mlxsw_sp, u16 mid_base,
 				 u16 count);
 int mlxsw_sp_pgt_entry_port_set(struct mlxsw_sp *mlxsw_sp, u16 mid,
 				u16 smpe, u16 local_port, bool member);
-u16 mlxsw_sp_pgt_index_to_mid(const struct mlxsw_sp *mlxsw_sp, u16 pgt_index);
 int mlxsw_sp_pgt_init(struct mlxsw_sp *mlxsw_sp);
 void mlxsw_sp_pgt_fini(struct mlxsw_sp *mlxsw_sp);
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index 385deef75eed..818e458eb3ad 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -114,7 +114,6 @@ struct mlxsw_sp_fid_family {
 	enum mlxsw_reg_bridge_type bridge_type;
 	u16 pgt_base;
 	bool smpe_index_valid;
-	bool ubridge;
 };
 
 static const int mlxsw_sp_sfgc_uc_packet_types[MLXSW_REG_SFGC_TYPE_MAX] = {
@@ -351,9 +350,7 @@ int mlxsw_sp_fid_flood_set(struct mlxsw_sp_fid *fid,
 	struct mlxsw_sp_fid_family *fid_family = fid->fid_family;
 	const struct mlxsw_sp_fid_ops *ops = fid_family->ops;
 	const struct mlxsw_sp_flood_table *flood_table;
-	char *sftr2_pl;
 	u16 mid_index;
-	int err;
 
 	if (WARN_ON(!fid_family->flood_tables || !ops->flood_index))
 		return -EINVAL;
@@ -362,26 +359,10 @@ int mlxsw_sp_fid_flood_set(struct mlxsw_sp_fid *fid,
 	if (!flood_table)
 		return -ESRCH;
 
-	if (fid_family->mlxsw_sp->ubridge) {
-		mid_index = mlxsw_sp_fid_flood_table_mid(fid_family,
-							 flood_table,
-							 fid->fid_offset);
-		return mlxsw_sp_pgt_entry_port_set(fid_family->mlxsw_sp,
-						   mid_index, fid->fid_index,
-						   local_port, member);
-	}
-
-	sftr2_pl = kmalloc(MLXSW_REG_SFTR2_LEN, GFP_KERNEL);
-	if (!sftr2_pl)
-		return -ENOMEM;
-
-	mlxsw_reg_sftr2_pack(sftr2_pl, flood_table->table_index,
-			     ops->flood_index(fid), flood_table->table_type, 1,
-			     local_port, member);
-	err = mlxsw_reg_write(fid_family->mlxsw_sp->core, MLXSW_REG(sftr2),
-			      sftr2_pl);
-	kfree(sftr2_pl);
-	return err;
+	mid_index = mlxsw_sp_fid_flood_table_mid(fid_family, flood_table,
+						 fid->fid_offset);
+	return mlxsw_sp_pgt_entry_port_set(fid_family->mlxsw_sp, mid_index,
+					   fid->fid_index, local_port, member);
 }
 
 int mlxsw_sp_fid_port_vid_map(struct mlxsw_sp_fid *fid,
@@ -435,15 +416,10 @@ u16 mlxsw_sp_fid_8021q_vid(const struct mlxsw_sp_fid *fid)
 
 static void mlxsw_sp_fid_8021q_setup(struct mlxsw_sp_fid *fid, const void *arg)
 {
-	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
 	u16 vid = *(u16 *) arg;
 
 	mlxsw_sp_fid_8021q_fid(fid)->vid = vid;
-
-	if (mlxsw_sp->ubridge)
-		fid->fid_offset = fid->fid_index - fid->fid_family->start_index;
-	else
-		fid->fid_offset = 0;
+	fid->fid_offset = fid->fid_index - fid->fid_family->start_index;
 }
 
 static enum mlxsw_reg_sfmr_op mlxsw_sp_sfmr_op(bool valid)
@@ -455,22 +431,15 @@ static enum mlxsw_reg_sfmr_op mlxsw_sp_sfmr_op(bool valid)
 static int mlxsw_sp_fid_op(const struct mlxsw_sp_fid *fid, bool valid)
 {
 	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
-	enum mlxsw_reg_bridge_type bridge_type = 0;
 	char sfmr_pl[MLXSW_REG_SFMR_LEN];
-	bool smpe_valid = false;
-	bool flood_rsp = false;
-	u16 smpe = 0;
-
-	if (mlxsw_sp->ubridge) {
-		flood_rsp = fid->fid_family->flood_rsp;
-		bridge_type = fid->fid_family->bridge_type;
-		smpe_valid = fid->fid_family->smpe_index_valid;
-		smpe = smpe_valid ? fid->fid_index : 0;
-	}
+	u16 smpe;
+
+	smpe = fid->fid_family->smpe_index_valid ? fid->fid_index : 0;
 
 	mlxsw_reg_sfmr_pack(sfmr_pl, mlxsw_sp_sfmr_op(valid), fid->fid_index,
-			    fid->fid_offset, flood_rsp, bridge_type, smpe_valid,
-			    smpe);
+			    fid->fid_offset, fid->fid_family->flood_rsp,
+			    fid->fid_family->bridge_type,
+			    fid->fid_family->smpe_index_valid, smpe);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sfmr), sfmr_pl);
 }
 
@@ -478,28 +447,22 @@ static int mlxsw_sp_fid_edit_op(const struct mlxsw_sp_fid *fid,
 				const struct mlxsw_sp_rif *rif)
 {
 	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
-	enum mlxsw_reg_bridge_type bridge_type = 0;
 	char sfmr_pl[MLXSW_REG_SFMR_LEN];
-	bool smpe_valid = false;
-	bool flood_rsp = false;
-	u16 smpe = 0;
-
-	if (mlxsw_sp->ubridge) {
-		flood_rsp = fid->fid_family->flood_rsp;
-		bridge_type = fid->fid_family->bridge_type;
-		smpe_valid = fid->fid_family->smpe_index_valid;
-		smpe = smpe_valid ? fid->fid_index : 0;
-	}
+	u16 smpe;
+
+	smpe = fid->fid_family->smpe_index_valid ? fid->fid_index : 0;
 
 	mlxsw_reg_sfmr_pack(sfmr_pl, MLXSW_REG_SFMR_OP_CREATE_FID,
-			    fid->fid_index, fid->fid_offset, flood_rsp,
-			    bridge_type, smpe_valid, smpe);
+			    fid->fid_index, fid->fid_offset,
+			    fid->fid_family->flood_rsp,
+			    fid->fid_family->bridge_type,
+			    fid->fid_family->smpe_index_valid, smpe);
 	mlxsw_reg_sfmr_vv_set(sfmr_pl, fid->vni_valid);
 	mlxsw_reg_sfmr_vni_set(sfmr_pl, be32_to_cpu(fid->vni));
 	mlxsw_reg_sfmr_vtfp_set(sfmr_pl, fid->nve_flood_index_valid);
 	mlxsw_reg_sfmr_nve_tunnel_flood_ptr_set(sfmr_pl, fid->nve_flood_index);
 
-	if (mlxsw_sp->ubridge && rif) {
+	if (rif) {
 		mlxsw_reg_sfmr_irif_v_set(sfmr_pl, true);
 		mlxsw_reg_sfmr_irif_set(sfmr_pl, mlxsw_sp_rif_index(rif));
 	}
@@ -722,11 +685,6 @@ int mlxsw_sp_fid_rif_set(struct mlxsw_sp_fid *fid, struct mlxsw_sp_rif *rif)
 	u16 rif_index = mlxsw_sp_rif_index(rif);
 	int err;
 
-	if (!fid->fid_family->mlxsw_sp->ubridge) {
-		fid->rif = rif;
-		return 0;
-	}
-
 	err = mlxsw_sp_fid_to_fid_rif_update(fid, rif);
 	if (err)
 		return err;
@@ -759,11 +717,6 @@ void mlxsw_sp_fid_rif_unset(struct mlxsw_sp_fid *fid)
 {
 	u16 rif_index;
 
-	if (!fid->fid_family->mlxsw_sp->ubridge) {
-		fid->rif = NULL;
-		return;
-	}
-
 	if (!fid->rif)
 		return;
 
@@ -778,15 +731,11 @@ void mlxsw_sp_fid_rif_unset(struct mlxsw_sp_fid *fid)
 
 static int mlxsw_sp_fid_vni_op(const struct mlxsw_sp_fid *fid)
 {
-	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
 	int err;
 
-	if (mlxsw_sp->ubridge) {
-		err = mlxsw_sp_fid_vni_to_fid_map(fid, fid->rif,
-						  fid->vni_valid);
-		if (err)
-			return err;
-	}
+	err = mlxsw_sp_fid_vni_to_fid_map(fid, fid->rif, fid->vni_valid);
+	if (err)
+		return err;
 
 	err = mlxsw_sp_fid_edit_op(fid, fid->rif);
 	if (err)
@@ -795,8 +744,7 @@ static int mlxsw_sp_fid_vni_op(const struct mlxsw_sp_fid *fid)
 	return 0;
 
 err_fid_edit_op:
-	if (mlxsw_sp->ubridge)
-		mlxsw_sp_fid_vni_to_fid_map(fid, fid->rif, !fid->vni_valid);
+	mlxsw_sp_fid_vni_to_fid_map(fid, fid->rif, !fid->vni_valid);
 	return err;
 }
 
@@ -808,7 +756,7 @@ static int __mlxsw_sp_fid_port_vid_map(const struct mlxsw_sp_fid *fid,
 	bool irif_valid = false;
 	u16 irif_index = 0;
 
-	if (mlxsw_sp->ubridge && fid->rif) {
+	if (fid->rif) {
 		irif_valid = true;
 		irif_index = mlxsw_sp_rif_index(fid->rif);
 	}
@@ -826,15 +774,10 @@ mlxsw_sp_fid_8021d_fid(const struct mlxsw_sp_fid *fid)
 
 static void mlxsw_sp_fid_8021d_setup(struct mlxsw_sp_fid *fid, const void *arg)
 {
-	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
 	int br_ifindex = *(int *) arg;
 
 	mlxsw_sp_fid_8021d_fid(fid)->br_ifindex = br_ifindex;
-
-	if (mlxsw_sp->ubridge)
-		fid->fid_offset = fid->fid_index - fid->fid_family->start_index;
-	else
-		fid->fid_offset = 0;
+	fid->fid_offset = fid->fid_index - fid->fid_family->start_index;
 }
 
 static int mlxsw_sp_fid_8021d_configure(struct mlxsw_sp_fid *fid)
@@ -1048,11 +991,9 @@ static int mlxsw_sp_fid_8021d_port_vid_map(struct mlxsw_sp_fid *fid,
 	if (err)
 		return err;
 
-	if (fid->fid_family->mlxsw_sp->ubridge) {
-		err = mlxsw_sp_fid_evid_map(fid, local_port, vid, true);
-		if (err)
-			goto err_fid_evid_map;
-	}
+	err = mlxsw_sp_fid_evid_map(fid, local_port, vid, true);
+	if (err)
+		goto err_fid_evid_map;
 
 	err = mlxsw_sp_fid_port_vid_list_add(fid, mlxsw_sp_port->local_port,
 					     vid);
@@ -1071,8 +1012,7 @@ static int mlxsw_sp_fid_8021d_port_vid_map(struct mlxsw_sp_fid *fid,
 	mlxsw_sp->fid_core->port_fid_mappings[local_port]--;
 	mlxsw_sp_fid_port_vid_list_del(fid, mlxsw_sp_port->local_port, vid);
 err_port_vid_list_add:
-	if (fid->fid_family->mlxsw_sp->ubridge)
-		mlxsw_sp_fid_evid_map(fid, local_port, vid, false);
+	mlxsw_sp_fid_evid_map(fid, local_port, vid, false);
 err_fid_evid_map:
 	__mlxsw_sp_fid_port_vid_map(fid, mlxsw_sp_port->local_port, vid, false);
 	return err;
@@ -1089,8 +1029,7 @@ mlxsw_sp_fid_8021d_port_vid_unmap(struct mlxsw_sp_fid *fid,
 		mlxsw_sp_port_vlan_mode_trans(mlxsw_sp_port);
 	mlxsw_sp->fid_core->port_fid_mappings[local_port]--;
 	mlxsw_sp_fid_port_vid_list_del(fid, mlxsw_sp_port->local_port, vid);
-	if (fid->fid_family->mlxsw_sp->ubridge)
-		mlxsw_sp_fid_evid_map(fid, local_port, vid, false);
+	mlxsw_sp_fid_evid_map(fid, local_port, vid, false);
 	__mlxsw_sp_fid_port_vid_map(fid, mlxsw_sp_port->local_port, vid, false);
 }
 
@@ -1150,24 +1089,6 @@ static const struct mlxsw_sp_fid_ops mlxsw_sp_fid_8021d_ops = {
 #define MLXSW_SP_FID_8021Q_PGT_BASE 0
 #define MLXSW_SP_FID_8021D_PGT_BASE (3 * MLXSW_SP_FID_8021Q_MAX)
 
-static const struct mlxsw_sp_flood_table mlxsw_sp_fid_8021d_flood_tables[] = {
-	{
-		.packet_type	= MLXSW_SP_FLOOD_TYPE_UC,
-		.table_type	= MLXSW_REG_SFGC_TABLE_TYPE_FID,
-		.table_index	= 0,
-	},
-	{
-		.packet_type	= MLXSW_SP_FLOOD_TYPE_MC,
-		.table_type	= MLXSW_REG_SFGC_TABLE_TYPE_FID,
-		.table_index	= 1,
-	},
-	{
-		.packet_type	= MLXSW_SP_FLOOD_TYPE_BC,
-		.table_type	= MLXSW_REG_SFGC_TABLE_TYPE_FID,
-		.table_index	= 2,
-	},
-};
-
 static const struct mlxsw_sp_flood_table mlxsw_sp_fid_8021d_ub_flood_tables[] = {
 	{
 		.packet_type	= MLXSW_SP_FLOOD_TYPE_UC,
@@ -1186,20 +1107,6 @@ static const struct mlxsw_sp_flood_table mlxsw_sp_fid_8021d_ub_flood_tables[] =
 	},
 };
 
-/* Range and flood configuration must match mlxsw_config_profile */
-static const struct mlxsw_sp_fid_family mlxsw_sp_fid_8021d_family = {
-	.type			= MLXSW_SP_FID_TYPE_8021D,
-	.fid_size		= sizeof(struct mlxsw_sp_fid_8021d),
-	.start_index		= VLAN_N_VID,
-	.end_index		= VLAN_N_VID + MLXSW_SP_FID_8021D_MAX - 1,
-	.flood_tables		= mlxsw_sp_fid_8021d_flood_tables,
-	.nr_flood_tables	= ARRAY_SIZE(mlxsw_sp_fid_8021d_flood_tables),
-	.rif_type		= MLXSW_SP_RIF_TYPE_FID,
-	.ops			= &mlxsw_sp_fid_8021d_ops,
-	.bridge_type		= MLXSW_REG_BRIDGE_TYPE_1,
-	.pgt_base		= MLXSW_SP_FID_8021D_PGT_BASE,
-};
-
 static bool
 mlxsw_sp_fid_8021q_compare(const struct mlxsw_sp_fid *fid, const void *arg)
 {
@@ -1215,41 +1122,6 @@ mlxsw_sp_fid_8021q_fdb_clear_offload(const struct mlxsw_sp_fid *fid,
 	br_fdb_clear_offload(nve_dev, mlxsw_sp_fid_8021q_vid(fid));
 }
 
-static const struct mlxsw_sp_fid_ops mlxsw_sp_fid_8021q_emu_ops = {
-	.setup			= mlxsw_sp_fid_8021q_setup,
-	.configure		= mlxsw_sp_fid_8021d_configure,
-	.deconfigure		= mlxsw_sp_fid_8021d_deconfigure,
-	.index_alloc		= mlxsw_sp_fid_8021d_index_alloc,
-	.compare		= mlxsw_sp_fid_8021q_compare,
-	.flood_index		= mlxsw_sp_fid_8021d_flood_index,
-	.port_vid_map		= mlxsw_sp_fid_8021d_port_vid_map,
-	.port_vid_unmap		= mlxsw_sp_fid_8021d_port_vid_unmap,
-	.vni_set		= mlxsw_sp_fid_8021d_vni_set,
-	.vni_clear		= mlxsw_sp_fid_8021d_vni_clear,
-	.nve_flood_index_set	= mlxsw_sp_fid_8021d_nve_flood_index_set,
-	.nve_flood_index_clear	= mlxsw_sp_fid_8021d_nve_flood_index_clear,
-	.fdb_clear_offload	= mlxsw_sp_fid_8021q_fdb_clear_offload,
-};
-
-/* There are 4K-2 emulated 802.1Q FIDs, starting right after the 802.1D FIDs */
-#define MLXSW_SP_FID_8021Q_EMU_START	(VLAN_N_VID + MLXSW_SP_FID_8021D_MAX)
-#define MLXSW_SP_FID_8021Q_EMU_END	(MLXSW_SP_FID_8021Q_EMU_START + \
-					 MLXSW_SP_FID_8021Q_MAX - 1)
-
-/* Range and flood configuration must match mlxsw_config_profile */
-static const struct mlxsw_sp_fid_family mlxsw_sp_fid_8021q_emu_family = {
-	.type			= MLXSW_SP_FID_TYPE_8021Q,
-	.fid_size		= sizeof(struct mlxsw_sp_fid_8021q),
-	.start_index		= MLXSW_SP_FID_8021Q_EMU_START,
-	.end_index		= MLXSW_SP_FID_8021Q_EMU_END,
-	.flood_tables		= mlxsw_sp_fid_8021d_flood_tables,
-	.nr_flood_tables	= ARRAY_SIZE(mlxsw_sp_fid_8021d_flood_tables),
-	.rif_type		= MLXSW_SP_RIF_TYPE_VLAN_EMU,
-	.ops			= &mlxsw_sp_fid_8021q_emu_ops,
-	.bridge_type            = MLXSW_REG_BRIDGE_TYPE_1,
-	.pgt_base		= MLXSW_SP_FID_8021Q_PGT_BASE,
-};
-
 static void mlxsw_sp_fid_rfid_setup(struct mlxsw_sp_fid *fid, const void *arg)
 {
 	fid->fid_offset = 0;
@@ -1257,23 +1129,12 @@ static void mlxsw_sp_fid_rfid_setup(struct mlxsw_sp_fid *fid, const void *arg)
 
 static int mlxsw_sp_fid_rfid_configure(struct mlxsw_sp_fid *fid)
 {
-	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
-
-	/* rFIDs are allocated by the device during init using legacy
-	 * bridge model.
-	 */
-	if (mlxsw_sp->ubridge)
-		return mlxsw_sp_fid_op(fid, true);
-
-	return 0;
+	return mlxsw_sp_fid_op(fid, true);
 }
 
 static void mlxsw_sp_fid_rfid_deconfigure(struct mlxsw_sp_fid *fid)
 {
-	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
-
-	if (mlxsw_sp->ubridge)
-		mlxsw_sp_fid_op(fid, false);
+	mlxsw_sp_fid_op(fid, false);
 }
 
 static int mlxsw_sp_fid_rfid_index_alloc(struct mlxsw_sp_fid *fid,
@@ -1312,20 +1173,16 @@ static int mlxsw_sp_fid_rfid_port_vid_map(struct mlxsw_sp_fid *fid,
 	 * RIF creation. Using unified bridge model, we need to map
 	 * {Port, VID} => FID and map egress VID.
 	 */
-	if (mlxsw_sp->ubridge) {
-		err = __mlxsw_sp_fid_port_vid_map(fid,
-						  mlxsw_sp_port->local_port,
-						  vid, true);
+	err = __mlxsw_sp_fid_port_vid_map(fid, mlxsw_sp_port->local_port, vid,
+					  true);
+	if (err)
+		goto err_port_vid_map;
+
+	if (fid->rif) {
+		err = mlxsw_sp_fid_erif_eport_to_vid_map_one(fid, local_port,
+							     vid, true);
 		if (err)
-			goto err_port_vid_map;
-
-		if (fid->rif) {
-			err = mlxsw_sp_fid_erif_eport_to_vid_map_one(fid,
-								     local_port,
-								     vid, true);
-			if (err)
-				goto err_erif_eport_to_vid_map_one;
-		}
+			goto err_erif_eport_to_vid_map_one;
 	}
 
 	if (mlxsw_sp->fid_core->port_fid_mappings[local_port]++ == 0) {
@@ -1338,13 +1195,11 @@ static int mlxsw_sp_fid_rfid_port_vid_map(struct mlxsw_sp_fid *fid,
 
 err_port_vp_mode_trans:
 	mlxsw_sp->fid_core->port_fid_mappings[local_port]--;
-	if (mlxsw_sp->ubridge && fid->rif)
+	if (fid->rif)
 		mlxsw_sp_fid_erif_eport_to_vid_map_one(fid, local_port, vid,
 						       false);
 err_erif_eport_to_vid_map_one:
-	if (mlxsw_sp->ubridge)
-		__mlxsw_sp_fid_port_vid_map(fid, mlxsw_sp_port->local_port, vid,
-					    false);
+	__mlxsw_sp_fid_port_vid_map(fid, mlxsw_sp_port->local_port, vid, false);
 err_port_vid_map:
 	mlxsw_sp_fid_port_vid_list_del(fid, mlxsw_sp_port->local_port, vid);
 	return err;
@@ -1361,14 +1216,10 @@ mlxsw_sp_fid_rfid_port_vid_unmap(struct mlxsw_sp_fid *fid,
 		mlxsw_sp_port_vlan_mode_trans(mlxsw_sp_port);
 	mlxsw_sp->fid_core->port_fid_mappings[local_port]--;
 
-	if (mlxsw_sp->ubridge) {
-		if (fid->rif)
-			mlxsw_sp_fid_erif_eport_to_vid_map_one(fid, local_port,
-							       vid, false);
-		__mlxsw_sp_fid_port_vid_map(fid, mlxsw_sp_port->local_port, vid,
-					    false);
-	}
-
+	if (fid->rif)
+		mlxsw_sp_fid_erif_eport_to_vid_map_one(fid, local_port, vid,
+						       false);
+	__mlxsw_sp_fid_port_vid_map(fid, mlxsw_sp_port->local_port, vid, false);
 	mlxsw_sp_fid_port_vid_list_del(fid, mlxsw_sp_port->local_port, vid);
 }
 
@@ -1414,19 +1265,6 @@ static const struct mlxsw_sp_fid_ops mlxsw_sp_fid_rfid_ops = {
 	.vid_to_fid_rif_update  = mlxsw_sp_fid_rfid_vid_to_fid_rif_update,
 };
 
-#define MLXSW_SP_RFID_BASE	(15 * 1024)
-#define MLXSW_SP_RFID_MAX	1024
-
-static const struct mlxsw_sp_fid_family mlxsw_sp_fid_rfid_family = {
-	.type			= MLXSW_SP_FID_TYPE_RFID,
-	.fid_size		= sizeof(struct mlxsw_sp_fid),
-	.start_index		= MLXSW_SP_RFID_BASE,
-	.end_index		= MLXSW_SP_RFID_BASE + MLXSW_SP_RFID_MAX - 1,
-	.rif_type		= MLXSW_SP_RIF_TYPE_SUBPORT,
-	.ops			= &mlxsw_sp_fid_rfid_ops,
-	.flood_rsp		= true,
-};
-
 static void mlxsw_sp_fid_dummy_setup(struct mlxsw_sp_fid *fid, const void *arg)
 {
 	fid->fid_offset = 0;
@@ -1488,14 +1326,6 @@ static const struct mlxsw_sp_fid_ops mlxsw_sp_fid_dummy_ops = {
 	.nve_flood_index_clear	= mlxsw_sp_fid_dummy_nve_flood_index_clear,
 };
 
-static const struct mlxsw_sp_fid_family mlxsw_sp_fid_dummy_family = {
-	.type			= MLXSW_SP_FID_TYPE_DUMMY,
-	.fid_size		= sizeof(struct mlxsw_sp_fid),
-	.start_index		= VLAN_N_VID - 1,
-	.end_index		= VLAN_N_VID - 1,
-	.ops			= &mlxsw_sp_fid_dummy_ops,
-};
-
 static int mlxsw_sp_fid_8021q_configure(struct mlxsw_sp_fid *fid)
 {
 	struct mlxsw_sp_fid_8021q *fid_8021q = mlxsw_sp_fid_8021q_fid(fid);
@@ -1612,7 +1442,7 @@ static const struct mlxsw_sp_fid_ops mlxsw_sp_fid_8021q_ops = {
 					 MLXSW_SP_FID_RFID_UB_MAX - 1)
 
 static const struct mlxsw_sp_fid_family mlxsw_sp1_fid_8021q_ub_family = {
-	.type			= MLXSW_SP_FID_TYPE_8021Q_UB,
+	.type			= MLXSW_SP_FID_TYPE_8021Q,
 	.fid_size		= sizeof(struct mlxsw_sp_fid_8021q),
 	.start_index		= MLXSW_SP_FID_8021Q_UB_START,
 	.end_index		= MLXSW_SP_FID_8021Q_UB_END,
@@ -1624,11 +1454,10 @@ static const struct mlxsw_sp_fid_family mlxsw_sp1_fid_8021q_ub_family = {
 	.bridge_type            = MLXSW_REG_BRIDGE_TYPE_0,
 	.pgt_base		= MLXSW_SP_FID_8021Q_PGT_BASE,
 	.smpe_index_valid	= false,
-	.ubridge                = true,
 };
 
 static const struct mlxsw_sp_fid_family mlxsw_sp1_fid_8021d_ub_family = {
-	.type			= MLXSW_SP_FID_TYPE_8021D_UB,
+	.type			= MLXSW_SP_FID_TYPE_8021D,
 	.fid_size		= sizeof(struct mlxsw_sp_fid_8021d),
 	.start_index		= MLXSW_SP_FID_8021D_UB_START,
 	.end_index		= MLXSW_SP_FID_8021D_UB_END,
@@ -1639,21 +1468,19 @@ static const struct mlxsw_sp_fid_family mlxsw_sp1_fid_8021d_ub_family = {
 	.bridge_type            = MLXSW_REG_BRIDGE_TYPE_1,
 	.pgt_base		= MLXSW_SP_FID_8021D_PGT_BASE,
 	.smpe_index_valid       = false,
-	.ubridge		= true,
 };
 
 static const struct mlxsw_sp_fid_family mlxsw_sp1_fid_dummy_ub_family = {
-	.type			= MLXSW_SP_FID_TYPE_DUMMY_UB,
+	.type			= MLXSW_SP_FID_TYPE_DUMMY,
 	.fid_size		= sizeof(struct mlxsw_sp_fid),
 	.start_index		= MLXSW_SP_FID_DUMMY_UB,
 	.end_index		= MLXSW_SP_FID_DUMMY_UB,
 	.ops			= &mlxsw_sp_fid_dummy_ops,
 	.smpe_index_valid       = false,
-	.ubridge		= true,
 };
 
 static const struct mlxsw_sp_fid_family mlxsw_sp_fid_rfid_ub_family = {
-	.type			= MLXSW_SP_FID_TYPE_RFID_UB,
+	.type			= MLXSW_SP_FID_TYPE_RFID,
 	.fid_size		= sizeof(struct mlxsw_sp_fid),
 	.start_index		= MLXSW_SP_RFID_UB_START,
 	.end_index		= MLXSW_SP_RFID_UB_END,
@@ -1661,23 +1488,17 @@ static const struct mlxsw_sp_fid_family mlxsw_sp_fid_rfid_ub_family = {
 	.ops			= &mlxsw_sp_fid_rfid_ops,
 	.flood_rsp              = true,
 	.smpe_index_valid       = false,
-	.ubridge		= true,
 };
 
 const struct mlxsw_sp_fid_family *mlxsw_sp1_fid_family_arr[] = {
-	[MLXSW_SP_FID_TYPE_8021Q]	= &mlxsw_sp_fid_8021q_emu_family,
-	[MLXSW_SP_FID_TYPE_8021D]	= &mlxsw_sp_fid_8021d_family,
-	[MLXSW_SP_FID_TYPE_RFID]	= &mlxsw_sp_fid_rfid_family,
-	[MLXSW_SP_FID_TYPE_DUMMY]	= &mlxsw_sp_fid_dummy_family,
-
-	[MLXSW_SP_FID_TYPE_8021Q_UB]	= &mlxsw_sp1_fid_8021q_ub_family,
-	[MLXSW_SP_FID_TYPE_8021D_UB]	= &mlxsw_sp1_fid_8021d_ub_family,
-	[MLXSW_SP_FID_TYPE_DUMMY_UB]	= &mlxsw_sp1_fid_dummy_ub_family,
-	[MLXSW_SP_FID_TYPE_RFID_UB]	= &mlxsw_sp_fid_rfid_ub_family,
+	[MLXSW_SP_FID_TYPE_8021Q]	= &mlxsw_sp1_fid_8021q_ub_family,
+	[MLXSW_SP_FID_TYPE_8021D]	= &mlxsw_sp1_fid_8021d_ub_family,
+	[MLXSW_SP_FID_TYPE_DUMMY]	= &mlxsw_sp1_fid_dummy_ub_family,
+	[MLXSW_SP_FID_TYPE_RFID]	= &mlxsw_sp_fid_rfid_ub_family,
 };
 
 static const struct mlxsw_sp_fid_family mlxsw_sp2_fid_8021q_ub_family = {
-	.type			= MLXSW_SP_FID_TYPE_8021Q_UB,
+	.type			= MLXSW_SP_FID_TYPE_8021Q,
 	.fid_size		= sizeof(struct mlxsw_sp_fid_8021q),
 	.start_index		= MLXSW_SP_FID_8021Q_UB_START,
 	.end_index		= MLXSW_SP_FID_8021Q_UB_END,
@@ -1689,11 +1510,10 @@ static const struct mlxsw_sp_fid_family mlxsw_sp2_fid_8021q_ub_family = {
 	.bridge_type            = MLXSW_REG_BRIDGE_TYPE_0,
 	.pgt_base		= MLXSW_SP_FID_8021Q_PGT_BASE,
 	.smpe_index_valid	= true,
-	.ubridge                = true,
 };
 
 static const struct mlxsw_sp_fid_family mlxsw_sp2_fid_8021d_ub_family = {
-	.type			= MLXSW_SP_FID_TYPE_8021D_UB,
+	.type			= MLXSW_SP_FID_TYPE_8021D,
 	.fid_size		= sizeof(struct mlxsw_sp_fid_8021d),
 	.start_index		= MLXSW_SP_FID_8021D_UB_START,
 	.end_index		= MLXSW_SP_FID_8021D_UB_END,
@@ -1704,29 +1524,22 @@ static const struct mlxsw_sp_fid_family mlxsw_sp2_fid_8021d_ub_family = {
 	.bridge_type            = MLXSW_REG_BRIDGE_TYPE_1,
 	.pgt_base		= MLXSW_SP_FID_8021D_PGT_BASE,
 	.smpe_index_valid       = true,
-	.ubridge		= true,
 };
 
 static const struct mlxsw_sp_fid_family mlxsw_sp2_fid_dummy_ub_family = {
-	.type			= MLXSW_SP_FID_TYPE_DUMMY_UB,
+	.type			= MLXSW_SP_FID_TYPE_DUMMY,
 	.fid_size		= sizeof(struct mlxsw_sp_fid),
 	.start_index		= MLXSW_SP_FID_DUMMY_UB,
 	.end_index		= MLXSW_SP_FID_DUMMY_UB,
 	.ops			= &mlxsw_sp_fid_dummy_ops,
 	.smpe_index_valid       = false,
-	.ubridge		= true,
 };
 
 const struct mlxsw_sp_fid_family *mlxsw_sp2_fid_family_arr[] = {
-	[MLXSW_SP_FID_TYPE_8021Q]	= &mlxsw_sp_fid_8021q_emu_family,
-	[MLXSW_SP_FID_TYPE_8021D]	= &mlxsw_sp_fid_8021d_family,
-	[MLXSW_SP_FID_TYPE_RFID]	= &mlxsw_sp_fid_rfid_family,
-	[MLXSW_SP_FID_TYPE_DUMMY]	= &mlxsw_sp_fid_dummy_family,
-
-	[MLXSW_SP_FID_TYPE_8021Q_UB]	= &mlxsw_sp2_fid_8021q_ub_family,
-	[MLXSW_SP_FID_TYPE_8021D_UB]	= &mlxsw_sp2_fid_8021d_ub_family,
-	[MLXSW_SP_FID_TYPE_DUMMY_UB]	= &mlxsw_sp2_fid_dummy_ub_family,
-	[MLXSW_SP_FID_TYPE_RFID_UB]	= &mlxsw_sp_fid_rfid_ub_family,
+	[MLXSW_SP_FID_TYPE_8021Q]	= &mlxsw_sp2_fid_8021q_ub_family,
+	[MLXSW_SP_FID_TYPE_8021D]	= &mlxsw_sp2_fid_8021d_ub_family,
+	[MLXSW_SP_FID_TYPE_DUMMY]	= &mlxsw_sp2_fid_dummy_ub_family,
+	[MLXSW_SP_FID_TYPE_RFID]	= &mlxsw_sp_fid_rfid_ub_family,
 };
 
 static struct mlxsw_sp_fid *mlxsw_sp_fid_lookup(struct mlxsw_sp *mlxsw_sp,
@@ -1858,8 +1671,8 @@ mlxsw_sp_fid_flood_table_init(struct mlxsw_sp_fid_family *fid_family,
 {
 	enum mlxsw_sp_flood_type packet_type = flood_table->packet_type;
 	struct mlxsw_sp *mlxsw_sp = fid_family->mlxsw_sp;
-	u16 mid_base, num_fids, table_index;
 	const int *sfgc_packet_types;
+	u16 num_fids, mid_base;
 	int err, i;
 
 	mid_base = mlxsw_sp_fid_flood_table_mid(fid_family, flood_table, 0);
@@ -1875,12 +1688,8 @@ mlxsw_sp_fid_flood_table_init(struct mlxsw_sp_fid_family *fid_family,
 		if (!sfgc_packet_types[i])
 			continue;
 
-		mid_base = mlxsw_sp->ubridge ? mid_base : 0;
-		table_index = mlxsw_sp->ubridge ? 0 : flood_table->table_index;
-
 		mlxsw_reg_sfgc_pack(sfgc_pl, i, fid_family->bridge_type,
-				    flood_table->table_type, table_index,
-				    mid_base);
+				    flood_table->table_type, 0, mid_base);
 
 		err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sfgc), sfgc_pl);
 		if (err)
@@ -1890,7 +1699,6 @@ mlxsw_sp_fid_flood_table_init(struct mlxsw_sp_fid_family *fid_family,
 	return 0;
 
 err_reg_write:
-	mid_base = mlxsw_sp_fid_flood_table_mid(fid_family, flood_table, 0);
 	mlxsw_sp_pgt_mid_free_range(mlxsw_sp, mid_base, num_fids);
 	return err;
 }
@@ -2035,9 +1843,6 @@ int mlxsw_sp_fids_init(struct mlxsw_sp *mlxsw_sp)
 	}
 
 	for (i = 0; i < MLXSW_SP_FID_TYPE_MAX; i++) {
-		if (mlxsw_sp->ubridge != mlxsw_sp->fid_family_arr[i]->ubridge)
-			continue;
-
 		err = mlxsw_sp_fid_family_register(mlxsw_sp,
 						   mlxsw_sp->fid_family_arr[i]);
 
@@ -2052,9 +1857,6 @@ int mlxsw_sp_fids_init(struct mlxsw_sp *mlxsw_sp)
 		struct mlxsw_sp_fid_family *fid_family;
 
 		fid_family = fid_core->fid_family_arr[i];
-		if (mlxsw_sp->ubridge != fid_family->ubridge)
-			continue;
-
 		mlxsw_sp_fid_family_unregister(mlxsw_sp, fid_family);
 	}
 	kfree(fid_core->port_fid_mappings);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_pgt.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_pgt.c
index e6bbe08ef379..7dd3dba0fa83 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_pgt.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_pgt.c
@@ -182,16 +182,6 @@ static void mlxsw_sp_pgt_entry_put(struct mlxsw_sp_pgt *pgt, u16 mid)
 		mlxsw_sp_pgt_entry_destroy(pgt, pgt_entry);
 }
 
-#define MLXSW_SP_FID_PGT_FLOOD_ENTRIES	15354 /* Reserved for flooding. */
-
-u16 mlxsw_sp_pgt_index_to_mid(const struct mlxsw_sp *mlxsw_sp, u16 pgt_index)
-{
-	if (mlxsw_sp->ubridge)
-		return pgt_index;
-
-	return pgt_index - MLXSW_SP_FID_PGT_FLOOD_ENTRIES;
-}
-
 static void mlxsw_sp_pgt_smid2_port_set(char *smid2_pl, u16 local_port,
 					bool member)
 {
@@ -204,21 +194,16 @@ mlxsw_sp_pgt_entry_port_write(struct mlxsw_sp *mlxsw_sp,
 			      const struct mlxsw_sp_pgt_entry *pgt_entry,
 			      u16 local_port, bool member)
 {
-	bool smpe_index_valid;
 	char *smid2_pl;
-	u16 smpe, mid;
 	int err;
 
 	smid2_pl = kmalloc(MLXSW_REG_SMID2_LEN, GFP_KERNEL);
 	if (!smid2_pl)
 		return -ENOMEM;
 
-	smpe_index_valid = mlxsw_sp->ubridge ? mlxsw_sp->pgt->smpe_index_valid :
-			   false;
-	smpe = mlxsw_sp->ubridge ? pgt_entry->smpe_index : 0;
-	mid = mlxsw_sp_pgt_index_to_mid(mlxsw_sp, pgt_entry->index);
-
-	mlxsw_reg_smid2_pack(smid2_pl, mid, 0, 0, smpe_index_valid, smpe);
+	mlxsw_reg_smid2_pack(smid2_pl, pgt_entry->index, 0, 0,
+			     mlxsw_sp->pgt->smpe_index_valid,
+			     pgt_entry->smpe_index);
 
 	mlxsw_sp_pgt_smid2_port_set(smid2_pl, local_port, member);
 	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(smid2), smid2_pl);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index aeaba07c17b0..09009e80cd71 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -7730,8 +7730,7 @@ u16 mlxsw_sp_rif_vid(struct mlxsw_sp *mlxsw_sp, const struct net_device *dev)
 	/* We only return the VID for VLAN RIFs. Otherwise we return an
 	 * invalid value (0).
 	 */
-	if (rif->ops->type != MLXSW_SP_RIF_TYPE_VLAN_EMU &&
-	    rif->ops->type != MLXSW_SP_RIF_TYPE_VLAN)
+	if (rif->ops->type != MLXSW_SP_RIF_TYPE_VLAN)
 		goto out;
 
 	vid = mlxsw_sp_fid_8021q_vid(rif->fid);
@@ -9324,13 +9323,11 @@ static int mlxsw_sp_rif_subport_op(struct mlxsw_sp_rif *rif, bool enable)
 			    rif->rif_index, rif->vr_id, rif->dev->mtu);
 	mlxsw_reg_ritr_mac_pack(ritr_pl, rif->dev->dev_addr);
 	mlxsw_reg_ritr_if_mac_profile_id_set(ritr_pl, rif->mac_profile_id);
-	efid = mlxsw_sp->ubridge ? mlxsw_sp_fid_index(rif->fid) : 0;
+	efid = mlxsw_sp_fid_index(rif->fid);
 	mlxsw_reg_ritr_sp_if_pack(ritr_pl, rif_subport->lag,
 				  rif_subport->lag ? rif_subport->lag_id :
 						     rif_subport->system_port,
-				  efid,
-				  mlxsw_sp->ubridge ? 0 : rif_subport->vid);
-
+				  efid, 0);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ritr), ritr_pl);
 }
 
@@ -9565,15 +9562,6 @@ static void mlxsw_sp_rif_vlan_fdb_del(struct mlxsw_sp_rif *rif, const char *mac)
 				 NULL);
 }
 
-static const struct mlxsw_sp_rif_ops mlxsw_sp_rif_vlan_emu_ops = {
-	.type			= MLXSW_SP_RIF_TYPE_VLAN_EMU,
-	.rif_size		= sizeof(struct mlxsw_sp_rif),
-	.configure		= mlxsw_sp_rif_fid_configure,
-	.deconfigure		= mlxsw_sp_rif_fid_deconfigure,
-	.fid_get		= mlxsw_sp_rif_vlan_fid_get,
-	.fdb_del		= mlxsw_sp_rif_vlan_fdb_del,
-};
-
 static int mlxsw_sp_rif_vlan_op(struct mlxsw_sp_rif *rif, u16 vid, u16 efid,
 				bool enable)
 {
@@ -9761,7 +9749,6 @@ static const struct mlxsw_sp_rif_ops mlxsw_sp1_rif_ipip_lb_ops = {
 
 static const struct mlxsw_sp_rif_ops *mlxsw_sp1_rif_ops_arr[] = {
 	[MLXSW_SP_RIF_TYPE_SUBPORT]	= &mlxsw_sp_rif_subport_ops,
-	[MLXSW_SP_RIF_TYPE_VLAN_EMU]	= &mlxsw_sp_rif_vlan_emu_ops,
 	[MLXSW_SP_RIF_TYPE_VLAN]	= &mlxsw_sp1_rif_vlan_ops,
 	[MLXSW_SP_RIF_TYPE_FID]		= &mlxsw_sp_rif_fid_ops,
 	[MLXSW_SP_RIF_TYPE_IPIP_LB]	= &mlxsw_sp1_rif_ipip_lb_ops,
@@ -9950,7 +9937,6 @@ static const struct mlxsw_sp_rif_ops mlxsw_sp2_rif_ipip_lb_ops = {
 
 static const struct mlxsw_sp_rif_ops *mlxsw_sp2_rif_ops_arr[] = {
 	[MLXSW_SP_RIF_TYPE_SUBPORT]	= &mlxsw_sp_rif_subport_ops,
-	[MLXSW_SP_RIF_TYPE_VLAN_EMU]	= &mlxsw_sp_rif_vlan_emu_ops,
 	[MLXSW_SP_RIF_TYPE_VLAN]	= &mlxsw_sp2_rif_vlan_ops,
 	[MLXSW_SP_RIF_TYPE_FID]		= &mlxsw_sp_rif_fid_ops,
 	[MLXSW_SP_RIF_TYPE_IPIP_LB]	= &mlxsw_sp2_rif_ipip_lb_ops,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index fd8f9be2d401..4efccd942fb8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -1798,7 +1798,6 @@ static int mlxsw_sp_mdb_entry_write(struct mlxsw_sp *mlxsw_sp,
 				    bool adding)
 {
 	char *sfd_pl;
-	u16 mid_idx;
 	u8 num_rec;
 	int err;
 
@@ -1806,11 +1805,10 @@ static int mlxsw_sp_mdb_entry_write(struct mlxsw_sp *mlxsw_sp,
 	if (!sfd_pl)
 		return -ENOMEM;
 
-	mid_idx = mlxsw_sp_pgt_index_to_mid(mlxsw_sp, mdb_entry->mid);
 	mlxsw_reg_sfd_pack(sfd_pl, mlxsw_sp_sfd_op(adding), 0);
 	mlxsw_reg_sfd_mc_pack(sfd_pl, 0, mdb_entry->key.addr,
 			      mdb_entry->key.fid, MLXSW_REG_SFD_REC_ACTION_NOP,
-			      mid_idx);
+			      mdb_entry->mid);
 	num_rec = mlxsw_reg_sfd_num_rec_get(sfd_pl);
 	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sfd), sfd_pl);
 	if (err)
-- 
2.36.1

