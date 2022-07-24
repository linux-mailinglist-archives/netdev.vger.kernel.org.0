Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A74757F3E2
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 10:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239386AbiGXIFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 04:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239679AbiGXIE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 04:04:59 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F951A040
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 01:04:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TBNIkh9Qv1Y0ppGgtekl64xVW4YSm0sWbpe1alcbCMBV/BvBB92Hrj6PQ3G726zVAlNQaVa6HQdSN1hG3FTOvU0zyabTYdgotVq9o8IdJzWaRmzpPdo3UAA6sNXHLHZBbTvGNqvsz3Y9WfJbKkzdKrLtd676yRrQeQQeIDycfgzT6LFylpZv9/cCxn7Mau30LXR9/6EhF9EPPdoi54bEQsb3BybH5xfiuwXltCIe1mPOrdqxmSFewoDViKpD0UfIefdm5cDtZXwxqfBD0isbHj9iHEAjyJ5d37y36i1FmPQ+UlAVVPLs8F9+8zpuRerLDAdRaUV/ol5wUyKzgaZ0yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=niAgdHxCYBKwsDUIe9EtXCWjLfvpAwP4Wp+8XKCB2I8=;
 b=Q3LRa9Mv+vZllR0AgUalhP2zCspJy5C3H6i2NGNZVeymSOs0YWj+AjxYYn+h7c3fK+9PHskKX9veaXSMU0Isrh8o4+mDxYHjFH/dReA7EAwYctNDk3+QTiBPAXyHAN6EOwhqTaXboDK0nl+Q9D6GkGJPVcm8GpyTdNOF++5dRcg77p1oIVmYRGLGYHVa/MoQGl6ze4LriNf+cbt/q3JxIZGBpc/4tYtmEEMf8bu0z3KAbtV22Clbf7ja2ndalFkNzAGmogFBBRv7bEl74Rmn4P2uk6QyLegJi0FCLFHCv7I/3T1d3uQtVgEDfXqbws5RTvCAk9dVRUxwYN58lUzoaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=niAgdHxCYBKwsDUIe9EtXCWjLfvpAwP4Wp+8XKCB2I8=;
 b=LlhGinpWNqy0Q4VSTlW2PqamWffYydjqttbLr+QdO1mDQAGozCuAM2BoCLCI/qICMdzIk2VwcXvVpKE8Q71sg7mlw0bK5EY/8kGGLw3WhrArR3dfVzlVU1/D1Jf18HsrXr/pqvvE9NlChvn3+lCLtxLzHeLcSdSkujhFLfoJRtAZ4LFIYlyURMvCP2JxG3BY97YCnQTQL46O/byeZi0i25EzqmUrcRWJcpQu3Cv0gE2dLL6HUM5lJXD/k2kZbFDj8kj193Ji67Bq1PhM7IH47zyRfDS5jSX+/HIdA/tlqj5aWUVdPiN3SX504Y/TpeBnCdNJUh237LdruKZ/7bs52g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH2PR12MB3877.namprd12.prod.outlook.com (2603:10b6:610:27::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Sun, 24 Jul
 2022 08:04:54 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5458.020; Sun, 24 Jul 2022
 08:04:53 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        danieller@nvidia.com, richardcochran@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 06/15] mlxsw: Set time stamp type as part of config profile
Date:   Sun, 24 Jul 2022 11:03:20 +0300
Message-Id: <20220724080329.2613617-7-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220724080329.2613617-1-idosch@nvidia.com>
References: <20220724080329.2613617-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0681.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:351::15) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a02df86f-7e12-420d-8cef-08da6d4b30ec
X-MS-TrafficTypeDiagnostic: CH2PR12MB3877:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v9fmWUEseEYoqaIW0NUS4bXP6I0d4o8yZnQZV01C0KeUC2AV+wVFC8bJmzge+iDeKJeDob2YCsEmAMKd1P90868AH3Q3vkyX5mZskilPP2Q2nfJ2m250qKPUVy2jgfxJSuzKqaNJJzyh4nM3VOHu+xCp4QfADdTKFaidHiNa4O51UX2Z7cwMSTBaZP2LWI9aa4ZTtW2jxuR5J2Vaf9pVxUh0Mw5c134evIw8Ih+EdqftY3dxk1aGjEaDbZbxfmMCxNqOXgtM1cdMY2Z11fNrkNPDph13GVw4j6EXFEd+hX8sGTKMPsEeqim6BcyN3Bxccx32IoGIoa9OHph2zaVA1khyrNTTZUB2izXFEyE3EbU1ViZPlWU2JLRSMfaPX3FRxFH0l3plkDaCIl/AvofHzXtDJScisA5K8MpZVfNBDmsEwJyNFaBwEY7uQvzsgZKVAeuGonF1RNmttPxDklHcLlXVBnNZosKtydHCKbcomsapEpLN5aMk1ymrpcbW3XV22bB4vNDV1SkE/STBKbOYyT9jCatCeHcfgj7tBfE+DmaJDesbDn+IQRV2P/ySGsEsNsbesfkDN7bKGwNU2X0D+r9PHmRqFxqSSif90FDPAlqAc8SbpKarzz0w0mwq6SdN1WS6w2ImDZMgGtXgVDbsEiKwRHiPy4ezUnnjDb/n9hZHzla3qNpaPpZwbXPBeDLMjUQagxw0hw6JUqidWaX0iWnsDZvEd/hopJFPPpncVLUmkoR5zJ4IXk6cL3uAQpA7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(366004)(396003)(136003)(376002)(186003)(1076003)(2616005)(107886003)(83380400001)(4326008)(66946007)(66476007)(6916009)(8676002)(66556008)(36756003)(6512007)(41300700001)(6666004)(6506007)(26005)(2906002)(86362001)(38100700002)(5660300002)(316002)(8936002)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a01vmTCMskASX/n6CkWtWFoD2M2ngB9m8jFP5yZCKtHKiVJ1oI2MkXAkceXh?=
 =?us-ascii?Q?gtH6l1hTaYXeUFJhF7tALfyRgOr+9p5EERcXRGmUiyBjyER5qYOqT7wz5v35?=
 =?us-ascii?Q?Bi9aiD1G+c7PgsTBHZyW/UneM5LUDkkzQDTkMmrwxsdjQ9iEDVKlSzpp/ON/?=
 =?us-ascii?Q?+4cpPUvGUJxOlEdCAtOIb42cdXJH8BegPO1KLLrglOZo335pyrkubDKfVLfz?=
 =?us-ascii?Q?FCVaK8DOKEGE1jt6RJg952QbYI31aiC7uE7D8q0wg9BwzicfIa4Y+RSEzcI0?=
 =?us-ascii?Q?TvyA7fPwaBOKZZZqsonCndvOyOtQX5N9ZknMLweRIL3gASdoWT8lqYPqV+51?=
 =?us-ascii?Q?rqS8Xs62YnpJRt9b1aW6kgj4GvjGxyEMd7TyXt8Wjk3suoSUQJiILRmtxDjC?=
 =?us-ascii?Q?EjDiRAEz4c7msG7uU7zmRrBZZFsL4lqRo8iA4IaDJbuukBlXfufBiOc4qpmL?=
 =?us-ascii?Q?K2njg7JA47w/MV25OWBJ4txTJrEZlEEIuRGqLKsJ6mMhNnZkHkMBOUJq44uB?=
 =?us-ascii?Q?4gyWkPh0UgwApGqegYlYpNTeUNrXy1Dd/Aq3x9V84w7aNTVpI3/XUy99O+CD?=
 =?us-ascii?Q?Xr9QRaOhs075Q4IyvthIqKgftVjOMnag8X6JALzOH+/hD6srgyn2MZzCicr9?=
 =?us-ascii?Q?2aZS1JXVxaietAi+PD9tW/RaCOzaJIV6ahBVv4gAzPvzezZZb+UEOVsGR/OL?=
 =?us-ascii?Q?QxwfaFOcNXe+A+2dUSLqa0jHGhWbKntk/CXWSqGIJQn2b8QniTK5Jj6RV+T7?=
 =?us-ascii?Q?vqkr40WDqMdZUMbndhme5C9hylXH+9XH1m2cbaTCr1SQOraIVqkYnYRT4Aiz?=
 =?us-ascii?Q?ogTQ9fekrgL4snL7D/F5HkYQuWcWzl6k0HlYDOkaMaEYSQ2h9g1Zg/zIr4Nc?=
 =?us-ascii?Q?FPST/FRrIHEcqu62838xvOhg0d21UuaV5NlgId9dO8i6SnCFHzqlkmaXZ+kS?=
 =?us-ascii?Q?L21zT3aF0iq+XalqkVHeQ9pjYCQSJP945OEd6+WNTEcxRD1bmsNkAQgNQ8bm?=
 =?us-ascii?Q?JHrtF+qqipLLoWkLObm6JJI7WtiOjzpmSLOfXULVF7XnJzjs6qFzD5J2x9Lp?=
 =?us-ascii?Q?iC42ryUYAprPmsI8qnZkKVJeZB+Cx8ShEPyYFsSHvlTDNSZLZfzrM12eP8nM?=
 =?us-ascii?Q?nR07k9JVAewJV4Q+Srz3wGBhhJBOn4xQUuufZv3CQlH7DAFTmAakr7XT2urB?=
 =?us-ascii?Q?fCaNBMT6J3ideZImWg7IG/AcuIKqY6SzxumrAfAm9XL7fFux6kgKg+s6p9Dg?=
 =?us-ascii?Q?Dck38chcCxxSoaKtmNWZpc4Nnn5EjkRs4Ks/6RjvSXly1hVzuGV70wxl/ios?=
 =?us-ascii?Q?Heh7aLPbb+brUZWVsxw7ncyMvet+nhTcWiwHXnnhU/cyeAdrtmSVWqydupaA?=
 =?us-ascii?Q?5ZhBV6DsQj0WQ84qQgcbRJXjuV1bdBE9Quxn5TDr7q4v7tTTOMPDxYf1PT9J?=
 =?us-ascii?Q?L28On/29YMtlwl9FHiUZZFiFU8p4QJA8WYNsXCeuDkQzKbDjDuUwmeHFiyEg?=
 =?us-ascii?Q?XAGOC4rwBtxBDYHURqOSsaf+IqvNDyRf/D3tLqnBqYmu5FM+MLYzcPkrtQs1?=
 =?us-ascii?Q?WlXkWWJH+0XuKMZeke7x2VEzJYSTO/jSVEABiNGB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a02df86f-7e12-420d-8cef-08da6d4b30ec
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2022 08:04:53.9004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sez0nG8cy53uNF0Ts4t21W+cB1E02DCwiHMXLKneMguUWTDG0ul/z+GjVdLr6puM8A5sBnMebYOfQlZHOloiuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3877
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

The type of time stamp field in the CQE is configured via the
CONFIG_PROFILE command during driver initialization. Add the definition
of the relevant fields to the command's payload and set the type to UTC
for Spectrum-2 and above. This configuration can be done as part of the
preparations to PTP support, as the type of the time stamp will not break
any existing behavior.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/cmd.h     | 26 +++++++++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  4 ++-
 drivers/net/ethernet/mellanox/mlxsw/pci.c     |  7 +++++
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  2 ++
 4 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/cmd.h b/drivers/net/ethernet/mellanox/mlxsw/cmd.h
index e5ac5d267348..60232fb8ccd7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/cmd.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/cmd.h
@@ -689,6 +689,12 @@ MLXSW_ITEM32(cmd_mbox, config_profile, set_kvd_hash_double_size, 0x0C, 26, 1);
  */
 MLXSW_ITEM32(cmd_mbox, config_profile, set_cqe_version, 0x08, 0, 1);
 
+/* cmd_mbox_config_set_cqe_time_stamp_type
+ * Capability bit. Setting a bit to 1 configures the profile
+ * according to the mailbox contents.
+ */
+MLXSW_ITEM32(cmd_mbox, config_profile, set_cqe_time_stamp_type, 0x08, 2, 1);
+
 /* cmd_mbox_config_profile_max_vepa_channels
  * Maximum number of VEPA channels per port (0 through 16)
  * 0 - multi-channel VEPA is disabled
@@ -884,6 +890,26 @@ MLXSW_ITEM32_INDEXED(cmd_mbox, config_profile, swid_config_type,
 MLXSW_ITEM32_INDEXED(cmd_mbox, config_profile, swid_config_properties,
 		     0x60, 0, 8, 0x08, 0x00, false);
 
+enum mlxsw_cmd_mbox_config_profile_cqe_time_stamp_type {
+	/* uSec - 1.024uSec (default). Only bits 15:0 are valid. */
+	MLXSW_CMD_MBOX_CONFIG_PROFILE_CQE_TIME_STAMP_TYPE_USEC,
+	/* FRC - Free Running Clock, units of 1nSec.
+	 * Reserved when SwitchX/-2, Switch-IB/2 and Spectrum-1.
+	 */
+	MLXSW_CMD_MBOX_CONFIG_PROFILE_CQE_TIME_STAMP_TYPE_FRC,
+	/* UTC. time_stamp[37:30] = Sec, time_stamp[29:0] = nSec.
+	 * Reserved when SwitchX/2, Switch-IB/2 and Spectrum-1.
+	 */
+	MLXSW_CMD_MBOX_CONFIG_PROFILE_CQE_TIME_STAMP_TYPE_UTC,
+};
+
+/* cmd_mbox_config_profile_cqe_time_stamp_type
+ * CQE time_stamp_type for non-mirror-packets.
+ * Configured if set_cqe_time_stamp_type is set.
+ * Reserved when SwitchX/-2, Switch-IB/2 and Spectrum-1.
+ */
+MLXSW_ITEM32(cmd_mbox, config_profile, cqe_time_stamp_type, 0xB0, 8, 2);
+
 /* cmd_mbox_config_profile_cqe_version
  * CQE version:
  * 0: CQE version is 0
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index a3491ef2aa7e..6b05586052dd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -296,7 +296,8 @@ struct mlxsw_config_profile {
 		used_ar_sec:1,
 		used_adaptive_routing_group_cap:1,
 		used_ubridge:1,
-		used_kvd_sizes:1;
+		used_kvd_sizes:1,
+		used_cqe_time_stamp_type:1;
 	u8	max_vepa_channels;
 	u16	max_mid;
 	u16	max_pgt;
@@ -319,6 +320,7 @@ struct mlxsw_config_profile {
 	u32	kvd_linear_size;
 	u8	kvd_hash_single_parts;
 	u8	kvd_hash_double_parts;
+	u8	cqe_time_stamp_type;
 	struct mlxsw_swid_config swid_config[MLXSW_CONFIG_PROFILE_SWID_COUNT];
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index 41f0f68bc911..57792e87dee2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -1267,6 +1267,13 @@ static int mlxsw_pci_config_profile(struct mlxsw_pci *mlxsw_pci, char *mbox,
 		mlxsw_cmd_mbox_config_profile_cqe_version_set(mbox, 1);
 	}
 
+	if (profile->used_cqe_time_stamp_type) {
+		mlxsw_cmd_mbox_config_profile_set_cqe_time_stamp_type_set(mbox,
+									  1);
+		mlxsw_cmd_mbox_config_profile_cqe_time_stamp_type_set(mbox,
+					profile->cqe_time_stamp_type);
+	}
+
 	return mlxsw_cmd_config_profile_set(mlxsw_pci->core, mbox);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 209587cf7529..fa48b2631ea8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3411,6 +3411,8 @@ static const struct mlxsw_config_profile mlxsw_sp2_config_profile = {
 			.type		= MLXSW_PORT_SWID_TYPE_ETH,
 		}
 	},
+	.used_cqe_time_stamp_type	= 1,
+	.cqe_time_stamp_type		= MLXSW_CMD_MBOX_CONFIG_PROFILE_CQE_TIME_STAMP_TYPE_UTC,
 };
 
 static void
-- 
2.36.1

