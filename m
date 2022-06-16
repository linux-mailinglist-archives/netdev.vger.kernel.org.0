Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4AF54DF5C
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 12:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376276AbiFPKoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 06:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbiFPKno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 06:43:44 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2083.outbound.protection.outlook.com [40.107.95.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 945CC2DD4F
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 03:43:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RkJ0yrwtlvMl4dHQXlS84Mv9W8LsfPM+kfR2ZLCiVIE+ZsWaEk25U8GpEuXQp2X6iKDp9uHISlaJNjHJDD+pApqxQUecsW+rM55YfWNc2DCRgrtUw9Hd4CiDVnP5OnkUJdwDXP5zgmwiSiUAc4E755h7Hby8qJffIqCICLZj/plgdFqOwyiNZfDUvezwp4fHIMJWWf68VdsR1DhlWKlDwv/wMZv1L+GJg7szrE8MzpBNv5w2ZpD3LghuU3+IGXIAjxrM0duc0OHlNU5FiFwmAJdRWBY/PvpwfnIXitdWETs6BA9yLqOqkwmf6ISbSmCCSzXWvXBHeJ0PSNPgszTZXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WuvvcT8uxIhjA79p0FTtZ/svEFBTRGF6BRlVQVCizGc=;
 b=aX82dOAuPD5rhgZIUfTMb2HFGQfnlb8ol1rDKszq+Ymb9pDIqhFVA1fChou8yo+rL+fSFrpYZ3Gu3p4otG0PYFMCXyMxLqLMNwgOVyNUPuXBH68SZl1vepuPGXFMleghPUC5bl1W0uh37G/uWXBuZHDmcVOb/rObKO8JNHYurQ3AZzrj2SDBxT1+cxz0toQmrfuspbGApbIrtfRly1hCBO2FHpUnnN4Ms0p4IjebnuO/YWpYLtmGRYchBJPGlZ1Zt51GyJ891d9BAfbvVj+xEv4vK8Fuxm7AEWguCMcjnCc2tzKBVxt1DtlmFW9R+30p/zH1yUJspTfoUHTvvASpjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WuvvcT8uxIhjA79p0FTtZ/svEFBTRGF6BRlVQVCizGc=;
 b=BIhPenTMQ94a9O2tTB59rguvzMLIov6uWFAlIWSuOazABLra7lNIxoZhc6GjZmn0cwpH2WHyF9s2RLnGGiqru3KUBdpNaRS1AUy3PeitxCEUCdc0WSNbyEr2PKd8zpIV70hO17IWUcIloo5TWNSANtws+UGTd/28+/tWRQJa8mwPW2913+P/vgXm/0/09dUaOM7WqgOrMZ3jSJ8SCCFFhkOgm3/38xWIS2uFc1o5dcjlwGi4lGalhOpyAM7mhpz3xgx8zheRI9M5QoGXLBAPccBH0VpuBjkdc0vK0omSgdRKLNd+7nbQasqe4p5y1SZJ/X/8UVZAQ/Q1h8pL6IW8Hg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SN6PR12MB2670.namprd12.prod.outlook.com (2603:10b6:805:6b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Thu, 16 Jun
 2022 10:43:42 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Thu, 16 Jun 2022
 10:43:42 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 03/11] mlxsw: Add a resource describing number of RIFs
Date:   Thu, 16 Jun 2022 13:42:37 +0300
Message-Id: <20220616104245.2254936-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220616104245.2254936-1-idosch@nvidia.com>
References: <20220616104245.2254936-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0047.eurprd09.prod.outlook.com
 (2603:10a6:802:28::15) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8040ca3-a2bb-404b-971c-08da4f85146d
X-MS-TrafficTypeDiagnostic: SN6PR12MB2670:EE_
X-Microsoft-Antispam-PRVS: <SN6PR12MB26709CB3AD90DF5B50359AF4B2AC9@SN6PR12MB2670.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qnh+/RTsErhwlasveXUmaqef2IEYs/g1amMRD6BX2tAs32jKfJhqjbY0UC/Uu7/MD7ulsUGV69XzaiBnWEN48YmTbdKpqXJUnY45tZyDleaYL3I858GQiLrbmvUK86aMJQrI1v0TZ+NbAC0aHD9sBbc/yZ/jpokITvBVzInAY1aYVDGtBbYJIykiC2/1Y+hYBlOPoVHQO8gDC5uRzh2e3MfXQ/zChzN67xmft9qNMlam64+5ujOIE4LS+A6usF9hoKPuDAyUO89XaWfEtTseaKaHsawRtUk9kLDhzA6xf5BfoAnfBv0mVFSDNfJk4t+6qU6HdnlyBKGDc1+9ELWuJD687c2TQ+z3QW7hs7scwKAp2BsHYPb6cNCjsUQBEo7rdI2LnZ88ztkyCd21dmVygKG2u9vkzm6fLbEpzKPPgvxzZiD4mJxmc1EcgOo7qe17FsO/CazrR2KGiv81NlN+TJKGJ6x9MySfqveRZbCkRpr6xsNnDkVoQHrZUwc7EeTNM2+4MJN4ZnCPF/cyaufkyrIuaJZ7mkMc/3bik9osP1HNFpeNk1nyx7yiip4YfbcNTOn+j9CAsqvRlufj8lJ2Nbl8J5drJ/76aX4F0NDd8dn1vs1fbSaOgAWYfE/v8o0ZjV32oo7TMjhE50And00cIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(4326008)(508600001)(8676002)(66556008)(86362001)(66476007)(66946007)(316002)(6916009)(83380400001)(6486002)(186003)(6506007)(1076003)(6666004)(38100700002)(66574015)(26005)(6512007)(2906002)(36756003)(8936002)(5660300002)(107886003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LQL/ZAVHKwYq+BHLz8zPi9OHiDGJviaB+RF35XBAyK1rqRwfl7hhs4Qhkb0H?=
 =?us-ascii?Q?QJR7nvdqttTF8NURjGTDevLi+Eq5v80hstgB5ePgS1SsXTN9615CnjFwkF8w?=
 =?us-ascii?Q?fxl6AF3hlKZl4FJA0Gdg5Xxh4o2l876o+Q3qqGo891Tul8yfwCvvcaJWrGuL?=
 =?us-ascii?Q?VoTPrpA+OVkohusLXj92TDo6npCEv0/7RzwkLoi77Sfj/1AYzjnTw1PfLzdk?=
 =?us-ascii?Q?qbirX5vQFVIt0XTsyDeKLiSj8+g+neJVSLVjD9weLhbP6wiJiqys/jSc60GQ?=
 =?us-ascii?Q?OY2JW/ZlKwxJAae9SrdYykhCRNUfeimUB1W09y8ZihxPVdzwu+bZhM3XS32R?=
 =?us-ascii?Q?GpvQSTh1Vyu8S8s9emBTK2JT//1xZKbNa/AKQconMRwIBHjwfcg3x8AlREEu?=
 =?us-ascii?Q?HzqEZ4K6onfanmrJAgR3Nf0c/e/wnfDHqmRkvOWQr4IJEnzSusI2AidcxlLu?=
 =?us-ascii?Q?Or4GjDN30hhEINKgb51r6iOeuoMsTUK1tPIPtKqaljXNNR4To+uJxFSwAjlR?=
 =?us-ascii?Q?pWQ1FCrBDQcShEuoL2j89DnGrV6sDRnWPtiUJH0HcdjUm73bNSLRqiTu7LUw?=
 =?us-ascii?Q?cLet9e3Efl8AkARGF0qm+rYuxt0mIX+Wvt2ZBcTU0XElcRaroDEfXjYHVOFH?=
 =?us-ascii?Q?Bf8RGktmOZkJjLS47IJnBajZ3eg8bEDTwpIRAewtzDKNC2nVVz35+kz2PKjM?=
 =?us-ascii?Q?sXbxlLwGBaIlTFTgcNk71w7SpdGT7MKf53LghrQsMx3gWQ+doUrQxEnlCrzq?=
 =?us-ascii?Q?J91BfsC2j0wOXxZVWd7KBm12+whvFekC0KrtArKKl4v26SwyZo3LK78GC2Jo?=
 =?us-ascii?Q?H4xqlU3MU7eMUi+RSQymn/JIA2L7VABJn+XNpqsZOSf/KefMqnYNRI9oPMi7?=
 =?us-ascii?Q?119d72T0IgGcQJGRFuBGdmjwcG1EztXgEx1iy78nGgyfFvBOunscPdLNVU1e?=
 =?us-ascii?Q?At1VpJJG32jKl+UHX+CoaGC3dFTRZ1Za0byoljkKBVvMj6cPggWruc+kxdi3?=
 =?us-ascii?Q?1By9yagzA4up4Iv7lApzMs1gvzmeq1acYStyPtZZEOVZ5t0tX4WcPIi4jW3p?=
 =?us-ascii?Q?O0OCjO1xmPW/83SiWQEYVAInhHLZItHMp4r5UyRMiQraPLxCSr3DLSU+3RYs?=
 =?us-ascii?Q?WCYFVmnj+aB8TJpVpfy64ytgXto2Z4AT2OoUfFg1eN5ew1IIupmXpL4+Ykd/?=
 =?us-ascii?Q?sgcCzkv3iss4Xi8rHysuCLwX6Oy6rYlMfTq9SihGkoU8Xo/WzMIa9Rh3Pr2U?=
 =?us-ascii?Q?h+UXNyABMXHZbZiM+JvZgj3QwJnHPNzLWnmHhr8ZuvWIrd0L9YkScED43yaq?=
 =?us-ascii?Q?YJBe4nepNhonMFUZ/8rYZBJI/ZRndNqPVyapL8oyF/XQ5ODmbUnQ0wjYMqzU?=
 =?us-ascii?Q?jQgLN0MI8uYTTBO6PVmdtpoH1UklECOPOv8ZTYR7Xi2OC+AyM/egmclTpJ0s?=
 =?us-ascii?Q?pJCEikdfP9tvli9h4sEeT0/9xPnSXLQb6qaQGHBxXyMf3XAIci5V5DlLBK1Q?=
 =?us-ascii?Q?y65EeXqsTBBVzph+Uz9eKQRIPV+CKX7LC16e5y6qX89NKxcpGvoEPP46l4ly?=
 =?us-ascii?Q?EejqUmBxTYZahAIMZb4gakxyRcLIVIfCugTB9af6mjs2Mdm/r09/79iSen9a?=
 =?us-ascii?Q?5sh1vrDI0W77dnJY0rgvazUkuWF77rIQEe5Y3wNjEV258W4siNDHV7p5kIJ+?=
 =?us-ascii?Q?U+B/Iwlb6ELPWB5mN1PRz2znfCc5PxaAMpVkUeCo5QBubNlZFES4EhgZ8kVX?=
 =?us-ascii?Q?Ar4HqJFXOw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8040ca3-a2bb-404b-971c-08da4f85146d
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 10:43:41.9723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wPnpo8/U+yQxwFWv1zWRpmQvOBHK+wZEcFHGyodRHlIEE04RMVDvFslkJ2E7UPc2IseHe5zcOGtK1KFEtM91CQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2670
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

The Spectrum ASIC has a limit on how many L3 devices (called RIFs) can be
created. The limit depends on the ASIC and FW revision, and mlxsw reads it
from the FW. In order to communicate both the number of RIFs that there can
be, and how many are taken now (i.e. occupancy), introduce a corresponding
devlink resource.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 29 +++++++++++++++++++
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  1 +
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 12 ++++++++
 3 files changed, 42 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index c949005f56dc..a62887b8d98e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3580,6 +3580,25 @@ mlxsw_sp_resources_rif_mac_profile_register(struct mlxsw_core *mlxsw_core)
 					 &size_params);
 }
 
+static int mlxsw_sp_resources_rifs_register(struct mlxsw_core *mlxsw_core)
+{
+	struct devlink *devlink = priv_to_devlink(mlxsw_core);
+	struct devlink_resource_size_params size_params;
+	u64 max_rifs;
+
+	if (!MLXSW_CORE_RES_VALID(mlxsw_core, MAX_RIFS))
+		return -EIO;
+
+	max_rifs = MLXSW_CORE_RES_GET(mlxsw_core, MAX_RIFS);
+	devlink_resource_size_params_init(&size_params, max_rifs, max_rifs,
+					  1, DEVLINK_RESOURCE_UNIT_ENTRY);
+
+	return devlink_resource_register(devlink, "rifs", max_rifs,
+					 MLXSW_SP_RESOURCE_RIFS,
+					 DEVLINK_RESOURCE_ID_PARENT_TOP,
+					 &size_params);
+}
+
 static int mlxsw_sp1_resources_register(struct mlxsw_core *mlxsw_core)
 {
 	int err;
@@ -3604,8 +3623,13 @@ static int mlxsw_sp1_resources_register(struct mlxsw_core *mlxsw_core)
 	if (err)
 		goto err_resources_rif_mac_profile_register;
 
+	err = mlxsw_sp_resources_rifs_register(mlxsw_core);
+	if (err)
+		goto err_resources_rifs_register;
+
 	return 0;
 
+err_resources_rifs_register:
 err_resources_rif_mac_profile_register:
 err_policer_resources_register:
 err_resources_counter_register:
@@ -3638,8 +3662,13 @@ static int mlxsw_sp2_resources_register(struct mlxsw_core *mlxsw_core)
 	if (err)
 		goto err_resources_rif_mac_profile_register;
 
+	err = mlxsw_sp_resources_rifs_register(mlxsw_core);
+	if (err)
+		goto err_resources_rifs_register;
+
 	return 0;
 
+err_resources_rifs_register:
 err_resources_rif_mac_profile_register:
 err_policer_resources_register:
 err_resources_counter_register:
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index a60d2bbd3aa6..36c6f5b89c71 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -68,6 +68,7 @@ enum mlxsw_sp_resource_id {
 	MLXSW_SP_RESOURCE_GLOBAL_POLICERS,
 	MLXSW_SP_RESOURCE_SINGLE_RATE_POLICERS,
 	MLXSW_SP_RESOURCE_RIF_MAC_PROFILES,
+	MLXSW_SP_RESOURCE_RIFS,
 };
 
 struct mlxsw_sp_port;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 07d7e244dfbd..4c7721506603 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -8323,6 +8323,13 @@ static u64 mlxsw_sp_rif_mac_profiles_occ_get(void *priv)
 	return atomic_read(&mlxsw_sp->router->rif_mac_profiles_count);
 }
 
+static u64 mlxsw_sp_rifs_occ_get(void *priv)
+{
+	const struct mlxsw_sp *mlxsw_sp = priv;
+
+	return atomic_read(&mlxsw_sp->router->rifs_count);
+}
+
 static struct mlxsw_sp_rif_mac_profile *
 mlxsw_sp_rif_mac_profile_create(struct mlxsw_sp *mlxsw_sp, const char *mac,
 				struct netlink_ext_ack *extack)
@@ -9828,6 +9835,10 @@ static int mlxsw_sp_rifs_init(struct mlxsw_sp *mlxsw_sp)
 					  MLXSW_SP_RESOURCE_RIF_MAC_PROFILES,
 					  mlxsw_sp_rif_mac_profiles_occ_get,
 					  mlxsw_sp);
+	devlink_resource_occ_get_register(devlink,
+					  MLXSW_SP_RESOURCE_RIFS,
+					  mlxsw_sp_rifs_occ_get,
+					  mlxsw_sp);
 
 	return 0;
 }
@@ -9841,6 +9852,7 @@ static void mlxsw_sp_rifs_fini(struct mlxsw_sp *mlxsw_sp)
 	for (i = 0; i < MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_RIFS); i++)
 		WARN_ON_ONCE(mlxsw_sp->router->rifs[i]);
 
+	devlink_resource_occ_get_unregister(devlink, MLXSW_SP_RESOURCE_RIFS);
 	devlink_resource_occ_get_unregister(devlink,
 					    MLXSW_SP_RESOURCE_RIF_MAC_PROFILES);
 	WARN_ON(!idr_is_empty(&mlxsw_sp->router->rif_mac_profiles_idr));
-- 
2.36.1

