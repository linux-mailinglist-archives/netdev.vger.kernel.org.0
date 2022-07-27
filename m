Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72E53582004
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 08:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiG0GYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 02:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiG0GYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 02:24:14 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2083.outbound.protection.outlook.com [40.107.223.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C37402F5
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:24:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mUyvE4KrV0n0Vm1JnmbjmhYPgG9ztqUvLMaJhemJ1Q7FBv1BvJEdKuoKPHxZH+QEk0HofZYD+22t1zkxxFMZUS14nGlgmODMIzQnRYzxGkTU66ZTVa7c5mrA6ZcwZl/v1+s5DEdlVQPdWGAoPOscOQs3j291S0FnHFi9RhM9MwLVdR8YfaTyi83JkrnYlkWoViBXH88VdhSKzONDu36gO4/Q29f+i9OOCpPW7oHLbjxlHR6BF2zBtLH2trMMPN2DyacOsHQ3ZcdhD6zw6LkLXUAoeNgNpfnS71f2eKD6ChnjUezAOtMmEd462XPrSi+DB5A7xpAoS3jwPzQ9We0PTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wy8lPpJuJmxR1b89t8SPyFtjeBlz7XSnBnDbV8gCfPE=;
 b=CmA5almT4Dqbsxw1PXMnSLcZisw51RjLY2X4exKV5KsvUPR4xvG6UsiUTzGb/NYZb8EkX9fNTPr1v5/BYsAw8WXYjq3G+85vXwuthZjqr+pgn72cGVACELgzu3C7rLNsGSZIkNfPevxkDBp2y+5faf2A69z5UOvC0y9V3lTjs+EUHkAQ3E0kKfIwbDUxNZbxsYk0npG+ciQlE0bhFl6WkMmmdetKOZl6nzxOnsj0eV1AKnwGL0J7ulw/gSs+i1kUfwNI2K6fPpaw8F80elEfjEiQF1wGHQ8Z5GWiRd4mjcFi7ZVPivuseWJFhAaZVQTweC0nfp9BTMJbKH4UMIrxyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wy8lPpJuJmxR1b89t8SPyFtjeBlz7XSnBnDbV8gCfPE=;
 b=Y3MJ1RJbWi4AYS+Dw5Yz5ySr9qNDVD1D+qrzrRMtTQPid6sCtIC19mo3tpDjS1JLVDhQDVuxERd+xi5KPOfipRg6Ibaaj9n/DGikh3PqSkUmPElnY9Eao/aOOYc1MIz5tNB8ag6QWZ12jdn4zV9afRojV6ata6zRd4DuRhSEN0YAKBAwTU1smGXBNvKAXWIZIXEYX27CwLh4ddZJd/bSgfbV4AgfxsaaMOa9lm49FJPsvm7f/G3akW1kIRJMIDMMn9UCw7NeQ9Zf7Wry9PyehYx3l3AD7uvxvKgae631Kwo1br0Tg6VpRkLIJ/ZGG46E9X9NE1XxLzD66vfsd2UZzA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ1PR12MB6243.namprd12.prod.outlook.com (2603:10b6:a03:456::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Wed, 27 Jul
 2022 06:24:11 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5458.025; Wed, 27 Jul 2022
 06:24:11 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, richardcochran@gmail.com, petrm@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/9] mlxsw: Support CQEv2 for SDQ in Spectrum-2 and newer ASICs
Date:   Wed, 27 Jul 2022 09:23:21 +0300
Message-Id: <20220727062328.3134613-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220727062328.3134613-1-idosch@nvidia.com>
References: <20220727062328.3134613-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0902CA0049.eurprd09.prod.outlook.com
 (2603:10a6:802:1::38) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba31516a-b350-4ad8-91c7-08da6f989e7f
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6243:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nWMEotwrx4nHsZy5gQS/TAcH0p1LLgLpSrBCT/uikVw+za/5aJ8O2cLeQCTYDYUN4to/c4Uq7ogvpkZ1xDCrmchBdKIyJP3MA493vo9VDBvRQqvbfJJrnjvpwx/nfrpIvyrYS70aqINHlh8PFtjsY2ujA+SoOpXlQtHGSlofvBb34ecN9sanFDJZwZSU1naHV4gZKfMzr5Yjdm3jsTxvEbqej38Aa03iUTk3eRVmhPzg0T2MxnCSzOgzlbknPaRsNfhbywCUUbbrTcxe9oly3P+dasS5M3rmk4f5bGLz4vzklSuA2Yw+CkrgmeazlCaiwLAPUeYmy2OhdQZ6ogmd74xfSFOgIlSvcYF2hZU6fq1bYzY5yZ1ioramum5hv+wrNyw8yxXlpFGnpAxMusmY0ybPLoetk7V+3vtheHCMogFkcOqVJ9j224ACpkJKQ/xnemF8MZpC1ub+ZGoWXF4rKVGRvn/NeYaKLHSWc9roGsykif9iDh3TS0Co1hz+1qZ5dbqSX8bTW7m4Hjv3dmDtl2idD+2Trmq3tpHGwodArkT85rBlY/0UlDvrG5bsyDCwM64OwkSkhhis4pmyjEjLpP1V1fOqdP7JU2dR0kVZn6zMofLvXr80m0ST51v7VuyhuiNfKlYx3+s+QptBkLGBnriBzYzy7KB2Y1zBrGGlNIoY3U4nEWrSSScUesusKK42hrWItqobS/jdXZCgJIgM87jcSSvYCiR5d1vtp8p+j2k4uobIayJXfGt+gURJUee6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(376002)(136003)(346002)(39860400002)(41300700001)(66476007)(38100700002)(6486002)(2616005)(66946007)(1076003)(107886003)(478600001)(6506007)(186003)(6666004)(8676002)(83380400001)(26005)(6916009)(8936002)(2906002)(5660300002)(316002)(86362001)(4326008)(36756003)(6512007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xc5q94g4BN2UZmKXL8IRlSpnXI4ByNQJ078pHG+oXSXNsieXoXNsFBA58yEI?=
 =?us-ascii?Q?k6JYAOu//qXzX8MSyN5rvR1DMYdy6ly8P28hpst4Ptnwk/AGr7BZv9ifTyb+?=
 =?us-ascii?Q?H96k69PAj8aDjFnO7XDNVnoy9O3ynJmVCKjG2UdwfYApP9aO8TCKtQLkGQQJ?=
 =?us-ascii?Q?uuMy13te15w/35SKU6R/tHalvA3KHtOUghfIUSRoJEkiT2zz1Mq14Ea+mUWD?=
 =?us-ascii?Q?5OB71DAVTNGTEaoo25D1orulIOdq9MqoiVoXZR9dGxvi37ftbsIoBMSTG1nM?=
 =?us-ascii?Q?ASN0etsBJ2++Go2RYxQ/B09V9k61FuYGBrHNnfJuOJuhDhmV/jHkDhjNAWe9?=
 =?us-ascii?Q?1Gx+gHtU+o5wAksILC49fNVEyYz3NCnon11AI8UMThodUl55xPRKxJYv5neW?=
 =?us-ascii?Q?mrljZ4HLIrPqztbizZR7V+bsMK15+fXBiPzRCL+guYCKGD0Dgi5FYID4bZB5?=
 =?us-ascii?Q?I84Cn3vbRL7sW6CMiCDUGBZi18iibLP8cPGz8GaEYRDvUbrOR8+Tv07PiC0h?=
 =?us-ascii?Q?ES3OWNAvAV9HcKISmSJCCjKyahkGyz5xP0FRAFfxao5SBBbOCGMNHvID2bSI?=
 =?us-ascii?Q?XrJ8Y2XQHFLGPAvsgFkSzWIy1KrqU/cC19uFmFsG/p6W5l4BMi4F3yyfRgAz?=
 =?us-ascii?Q?2NnxUNi/veVFveWqpoWfspvi9LjpoL2iPQRvNMqRamI5YqJefWanxycxRE8p?=
 =?us-ascii?Q?qfJeanYvk29a1tUaxGNcic4b8w0DqByt+Cn8m4W9EuICRRgJqK76r7SYeNc4?=
 =?us-ascii?Q?LIfhHiPBzAY5vQUf8xdZL4oEWNdS9VK/rdV0DO1gh79+555uWZ/8ZRb8gh3b?=
 =?us-ascii?Q?7jqG8g60VEicDswjeTA/cQ6lEEf9ZdzF8VQ5Xa18/qcVmPZ91vdLtBUVYxCz?=
 =?us-ascii?Q?OOxvhu8x5qd+94E0E+e96ueG4hPrZuJTHFCh52USmNAPLYH0n17RABBtw2GM?=
 =?us-ascii?Q?VhxHD/wCZkMfkmDnfSdYeB/VWUbacf5YTFZYh3l4OrH7jAHYstYe8pMkfnsJ?=
 =?us-ascii?Q?jDiP1AJoxkCK0mSyCYeXFI/Uz6NQNpUgWIQZtSeZz7Ybu8sSGgCTa3MXFanQ?=
 =?us-ascii?Q?sFzUona+/KcZvG18XR4t7LUVrBzYpuJ80DFBKOqDtPweK+PsmC7r/jH07ZO7?=
 =?us-ascii?Q?WsUD5hRQ2Fh3upJe+rX+0sjYt+rmW5FkBd57muaqr+Ou22ljdRKr7vpPvP3F?=
 =?us-ascii?Q?bzILh5psX3G86ibvfKXQVy7rhWWKTnHjZgUN5WbstpzHpR9CyjlGByf1Mdm7?=
 =?us-ascii?Q?fg1sb0Rn/DQMpmxMm37allIvRarD8TkTLPXYHJ/FuzWHgOx2nhjJBSWnoDU0?=
 =?us-ascii?Q?Y3f1FFxfRKFgg0r5j/xIVTqfGNNzkWXq9xePUX7uHhyzMUgAwJonrfwOBDVW?=
 =?us-ascii?Q?Tb8MRvSvMpHY6EUPXar663LaPZcfdPqvDpEBd2OKe3eNUOhtuPUPHhhbbLOw?=
 =?us-ascii?Q?MPbIIdnOBBRms7q4hlvUewUYboQeE4y91z2Yz1+EoHUYu9Q2IFcalrN4JJ6g?=
 =?us-ascii?Q?PHQ5U6xX45zghzmNAdn/3xHZguVTVCUZKwE2Bvb5WYvM336+yoJ/y06PFV1Q?=
 =?us-ascii?Q?MeokJzG4URjHjPryeUDK6Z/afOpgrQS2o9R47NVJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba31516a-b350-4ad8-91c7-08da6f989e7f
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 06:24:11.2624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F9WfxcBBFQxZzX4IJwawNxQsjPd22qpmd5bnWMGDb/sVz7BQ9d5EAUs4T7wkhfM8fhO+b5qcOrzu8H1C3B8s7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6243
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Currently, Tx completions are reported using Completion Queue Element
version 1 (CQEv1). These elements do not contain the Tx time stamp,
which is fine as Spectrum-1 reads Tx time stamps via a dedicated FIFO
and Spectrum-2 does not currently support PTP.

In preparation for Spectrum-2 PTP support, use CQEv2 for Spectrum-2 and
newer ASICs, as this CQE format encodes the Tx time stamp.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c     | 6 ++++++
 drivers/net/ethernet/mellanox/mlxsw/core.h     | 3 +++
 drivers/net/ethernet/mellanox/mlxsw/pci.c      | 4 ++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 4 ++++
 4 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index a48f893cf7b0..aef396128b0f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -3335,6 +3335,12 @@ u32 mlxsw_core_read_frc_l(struct mlxsw_core *mlxsw_core)
 }
 EXPORT_SYMBOL(mlxsw_core_read_frc_l);
 
+bool mlxsw_core_sdq_supports_cqe_v2(struct mlxsw_core *mlxsw_core)
+{
+	return mlxsw_core->driver->sdq_supports_cqe_v2;
+}
+EXPORT_SYMBOL(mlxsw_core_sdq_supports_cqe_v2);
+
 void mlxsw_core_emad_string_tlv_enable(struct mlxsw_core *mlxsw_core)
 {
 	mlxsw_core->emad.enable_string_tlv = true;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 7213e4528298..6c332bb9b6eb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -427,6 +427,7 @@ struct mlxsw_driver {
 
 	u8 txhdr_len;
 	const struct mlxsw_config_profile *profile;
+	bool sdq_supports_cqe_v2;
 };
 
 int mlxsw_core_kvd_sizes_get(struct mlxsw_core *mlxsw_core,
@@ -437,6 +438,8 @@ int mlxsw_core_kvd_sizes_get(struct mlxsw_core *mlxsw_core,
 u32 mlxsw_core_read_frc_h(struct mlxsw_core *mlxsw_core);
 u32 mlxsw_core_read_frc_l(struct mlxsw_core *mlxsw_core);
 
+bool mlxsw_core_sdq_supports_cqe_v2(struct mlxsw_core *mlxsw_core);
+
 void mlxsw_core_emad_string_tlv_enable(struct mlxsw_core *mlxsw_core);
 
 bool mlxsw_core_res_valid(struct mlxsw_core *mlxsw_core,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index 83659fb0559a..f1cd56006e9c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -456,9 +456,9 @@ static void mlxsw_pci_cq_pre_init(struct mlxsw_pci *mlxsw_pci,
 {
 	q->u.cq.v = mlxsw_pci->max_cqe_ver;
 
-	/* For SDQ it is pointless to use CQEv2, so use CQEv1 instead */
 	if (q->u.cq.v == MLXSW_PCI_CQE_V2 &&
-	    q->num < mlxsw_pci->num_sdq_cqs)
+	    q->num < mlxsw_pci->num_sdq_cqs &&
+	    !mlxsw_core_sdq_supports_cqe_v2(mlxsw_pci->core))
 		q->u.cq.v = MLXSW_PCI_CQE_V1;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 641078060b02..896510c2d8d7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3831,6 +3831,7 @@ static struct mlxsw_driver mlxsw_sp1_driver = {
 	.ptp_transmitted		= mlxsw_sp_ptp_transmitted,
 	.txhdr_len			= MLXSW_TXHDR_LEN,
 	.profile			= &mlxsw_sp1_config_profile,
+	.sdq_supports_cqe_v2		= false,
 };
 
 static struct mlxsw_driver mlxsw_sp2_driver = {
@@ -3869,6 +3870,7 @@ static struct mlxsw_driver mlxsw_sp2_driver = {
 	.ptp_transmitted		= mlxsw_sp_ptp_transmitted,
 	.txhdr_len			= MLXSW_TXHDR_LEN,
 	.profile			= &mlxsw_sp2_config_profile,
+	.sdq_supports_cqe_v2		= true,
 };
 
 static struct mlxsw_driver mlxsw_sp3_driver = {
@@ -3907,6 +3909,7 @@ static struct mlxsw_driver mlxsw_sp3_driver = {
 	.ptp_transmitted		= mlxsw_sp_ptp_transmitted,
 	.txhdr_len			= MLXSW_TXHDR_LEN,
 	.profile			= &mlxsw_sp2_config_profile,
+	.sdq_supports_cqe_v2		= true,
 };
 
 static struct mlxsw_driver mlxsw_sp4_driver = {
@@ -3943,6 +3946,7 @@ static struct mlxsw_driver mlxsw_sp4_driver = {
 	.ptp_transmitted		= mlxsw_sp_ptp_transmitted,
 	.txhdr_len			= MLXSW_TXHDR_LEN,
 	.profile			= &mlxsw_sp2_config_profile,
+	.sdq_supports_cqe_v2		= true,
 };
 
 bool mlxsw_sp_port_dev_check(const struct net_device *dev)
-- 
2.36.1

