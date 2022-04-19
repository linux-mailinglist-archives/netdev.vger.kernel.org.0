Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD62050712B
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 16:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349148AbiDSO6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 10:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353674AbiDSO6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 10:58:06 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2046.outbound.protection.outlook.com [40.107.223.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1CAE28985
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 07:55:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nUtbFfEkOY6PiXkYLGT1iaKLOT1dSTH3TWCd4CStojhTnt4wIBxMTiMlMy5Siak13vJS87r+OEjc5Bhdu0zrRIl6PiqGM0dtlFkUtFxqgFVPyW8IOQeuTCO0Lnaj2Pdn3NxPhKaQ3ua2AtvPSDqNuZWrlfQhD174Uu4zqthmz/Es0pj/hgLvuNezUr48qxM4d6kCvwBRtBhLdR1uTZ6mV50QkfvwjPdKSYIPxc3OxlEduy7OEYHaj2Zkiq/lmed14JizA6D4EaIdKNlFn50DRp4h/jb/X86nQzax9f1gP70UwLnLaDm4C1WR7tAy1y+GRj4/3lGxo/Y7ftYYp+jgLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aK1jhz+plEhSunE7gzcEfLaHF6dJQu88NdaixHG+Ei4=;
 b=Qhb22Bdw4VdSFsyNNUCUljqqoiHHj3T4uGfZ9lZOd+Ng/2ltoC7Bg8RT+/KiKYf9+kyt+ZY3EWgTkizlD2aESVz3K5nshXFwSIMotk7ZjZdR7wl7AnXLOfu3vWh625W57PHjBrCeyLxWvt6W0QcnQrZbjykthhOMLECWdsMWfKL6AoLL3nYTJkszTLjgiTdnthBNNTp8oZZJi8Okwb4WLfnKZ+IV7qqgr48OCM7RcgtYKFFv1ldBv7q2LSvVJjP5+I0ijs/q8AYyRKFYMpZBPgiOaXB7stUgLD0iHciRL2BFAgu2giwVoCsv3T8VkaIUDJu35sBQVqvUD9rtvFH9bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aK1jhz+plEhSunE7gzcEfLaHF6dJQu88NdaixHG+Ei4=;
 b=eNIZaV367SxkejWPIlHIycHw+NUbelmwQ0n6x/e91DDF65eWysi378QDD2KLw4YzBNFJjUMfE8J9RBGFNDQs4n05E2WitKh+ZJBwQ/+vWcF6XtfOVWz/rpUySGW4jvtpBC8nBIooGu1JeyoWjtTisTXqz/2uPgq5hxtr88N11RR/rIoMGZ4SRQ2BVMN/+SqrRxFNs1Vg6btz0e6F58dexVSYfJtv4tMOwCh6tKjVXuqSNnhOXHTTzX5VnIF7RlwlXE4dhZEyfm+0x3d3g4/iRugSt0pTHAj8u5YF4HCHQxF8mKEDHwPRhHf+4MkPZ1++BWwZUkJ40vAdacH099MbHg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW3PR12MB4347.namprd12.prod.outlook.com (2603:10b6:303:2e::10)
 by BN6PR12MB1378.namprd12.prod.outlook.com (2603:10b6:404:1e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Tue, 19 Apr
 2022 14:55:21 +0000
Received: from MW3PR12MB4347.namprd12.prod.outlook.com
 ([fe80::9196:55b8:5355:f64d]) by MW3PR12MB4347.namprd12.prod.outlook.com
 ([fe80::9196:55b8:5355:f64d%2]) with mapi id 15.20.5186.013; Tue, 19 Apr 2022
 14:55:20 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        petrm@nvidia.com, jiri@nvidia.com, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/6] mlxsw: core: Add bus argument to environment init API
Date:   Tue, 19 Apr 2022 17:54:27 +0300
Message-Id: <20220419145431.2991382-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220419145431.2991382-1-idosch@nvidia.com>
References: <20220419145431.2991382-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0202CA0027.eurprd02.prod.outlook.com
 (2603:10a6:803:14::40) To MW3PR12MB4347.namprd12.prod.outlook.com
 (2603:10b6:303:2e::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 456dbfdf-27d8-4dbd-153c-08da2214a008
X-MS-TrafficTypeDiagnostic: BN6PR12MB1378:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1378A4192F1E21A2AB80F150B2F29@BN6PR12MB1378.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7fkht7Y1300pZJbjc5z1qEtuijsxGU5SafLvM8wV5Nn1V1NLqbff28OJLxRi4RiSlf6l8XOYyQfAUFknsfUgGB2sT3wVsDYnOtTmfTnPJpnJFzkuPgIH2YBc3m9Utd+SwRz8+KJBff03Y2rT7JNH3bTrtlNP8sj9QvuawAHBeUmsr98nK2Mpju7EOu30LsznmvKpLqtDMSzzOQefonnXC2bvvIc7GsU8w9ao/wu8yOWXDa/GDnBNCXUJOG6R5yttHEmU88LTZx+wskp3M2dAqAaGpFlLELAIsZPpcfGlNqcxuDdEZdSb6GMhMZPrSEq7BgHT19d1UQrqbXFvkobX0Go1WHS79gevvEYsF4ivH+OPq9HOeO0VEltOSIsQsqphPudyFqfWHbQDYCnATbSnbqsD5iLUncrdCwFUfW1eq5Pci4JC2Wh9xNnD1GL0LHY0gD5TFv5iC/fIaOeH9KyD7WExqErFLJ2Vq6StVtarO0GMY46HBY7EUF5dOaPvPop6ghXHKHBvYRXXOGsK7yeIwwGuFvIaTB5HPK2hz3BKdTOAXgvq8gjYIhWgyntPVE1bYFY1kgCOojxoMw5Z46RvPLvCqE7j/CP449fCsInGrlVkIP2uhFQDqkvNH9881WJycJEHnpDOf9lcMfxTXDTz/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4347.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(38100700002)(6486002)(508600001)(8936002)(5660300002)(316002)(26005)(6512007)(8676002)(4326008)(66946007)(66556008)(83380400001)(186003)(66476007)(2906002)(6506007)(6916009)(2616005)(1076003)(107886003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G67NqUmckoD9BPmTFrE/qvY0QeS6IfW4Is4TxWTOANyuWOE0v6250scCXVkV?=
 =?us-ascii?Q?CbAZ37E4BBmjZ3IY0eoZ4eLN2obGfmeja3Idn5u9u3RGTzxFJnRlEDDcNTDE?=
 =?us-ascii?Q?wKEW88O9tUyY3fXmrqu6rYn1OBtMsZoO8Fdqsb0y11jLB48iLcjISGynMjaF?=
 =?us-ascii?Q?2TiN0Z9HHdyZ3f3K2MYc5A//moVVj+jzM+1F8QvBLPz6N1H1+wnfAKGPLDf4?=
 =?us-ascii?Q?b3hytfle3NP9l7kaTcr32eMjt41fjjuO8HNDMzRik7ja5Ako/Wgs/lxKTypy?=
 =?us-ascii?Q?X0za+j5Hq4Fc/ohAE8chHuu/EhL/Nw1yKUsz6y5C8ksDjr5NwCrF0RgclOfk?=
 =?us-ascii?Q?HOHpHqVPQPbsEXP6hMfG2QQ48Ktg+zc8GyOdvvv+qCm4TFeKBg1dgh49RWS+?=
 =?us-ascii?Q?dvAz9gT05IuKFSbhaxxpDF7OCdpijcl8MMlcI2XvT3QHhOIffLJcml3o+GeN?=
 =?us-ascii?Q?fOd3kLmRjcpflWgRiwB9bh9iqs8vBSKrcp/L6h7vp9aJ5s2KA4vtmOT8uhtz?=
 =?us-ascii?Q?a1O539+DShzSfSCmzeZRatcDLd6n78tNz6VhujQBlIfug4EeSNEhhCTwPIjE?=
 =?us-ascii?Q?jSjs/169iDwboAv+wduCxoiB08q6sWLDt9EeLbXwWncKNb2g7+VfXduTIYYw?=
 =?us-ascii?Q?jhUDSu/51yyUJQ2cLb19IqJ0ganw53EbvpAG0WVLsoqRn8jS25pIwggJASVE?=
 =?us-ascii?Q?wv7Cx8JrqKs3jO830ZurOsoIGKawA5RSgq99Qz98QHPUCKs8+RWRX34lxk7m?=
 =?us-ascii?Q?pvQcNq/tZoZGeLJp9VOG/ywpLaktMqGfS3aqUWdTVkVHpw2t97YG/pyyujtK?=
 =?us-ascii?Q?q2K89+cimCoOmPq9SoBOwaQ7L2o5qNLcn1XgFdLE0nWhA57YVbCJtWXzBi5V?=
 =?us-ascii?Q?M4XM546QOuF8XNPblV8uCUi8NL70Zr++EE5xHEm3/Rt2HvaHE2jLGUXnTlht?=
 =?us-ascii?Q?vFMSMOGy+83V7rqoAS3R/YmOMhqGm+qL1vGhXBfT2Zibgelmg55N8OOxaIom?=
 =?us-ascii?Q?6F9nfzTNI0cqQhB5psSjxFRzcXv1Wri8E1tNSa0pdDWGVrZXOyK6QNMQ2l6Y?=
 =?us-ascii?Q?IrjILPY8363GiThW8BHKF4xY3CpFC2IiXAoybTIu0hll0NULdrEqtAcOY0CN?=
 =?us-ascii?Q?SzFf/z+DfPPjgWCbpyKeHBwtjDdrHnjFmJ3JnCxNUoj9zNfSoEG7egzq7hNd?=
 =?us-ascii?Q?vwIyrH9H1MZ3HnfpvIdthwPD6n5jtFq1tFu0EFELvZ0NUHMT5bOp0YQnhLb5?=
 =?us-ascii?Q?JOztBeCB+yER9u85I9F2B9aHUyBZBrKZb2w4rurrcMmnyKDlawVcafiZXff2?=
 =?us-ascii?Q?2p6cFm+YamjvCOVKDbExoxf+HeFrl3IikOR2NbSnH2mS7NVTWVVO1TUnQ8BR?=
 =?us-ascii?Q?MtiDqfY/vD2dcIwZJBx0SdYM43HSJFAzNwScqlZV2sv7hjeo0u4Mx7nwEA9y?=
 =?us-ascii?Q?DoVLq8ieY0oJsUhuBXChSadJkdMLSgxzkGaJerfFluG943Jrotu9K/4wvsoz?=
 =?us-ascii?Q?/EtlrxPqnXoWOzcaN/D5P0eQWqx3Bnee+A9sYLGJ0eaWcB8kKy9XCUv5AwUw?=
 =?us-ascii?Q?PFK2/uGbLiMWNtzPv/7HgiJu5EdSWTOqfm/AAT/8cAxrpqaL8tpntOnWv63C?=
 =?us-ascii?Q?knKJJms5LzZ8AH7ECXcwcrVVTKgbWXyNjTPcccVaklKCb9JezoKLJ3SnZl/q?=
 =?us-ascii?Q?MDo5Rv9l6gU4DCouYnXeSOG9ET46w1Un3YPm49RX/GwRbGYgVzSNoCTc1OGm?=
 =?us-ascii?Q?5i8Jze+oFg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 456dbfdf-27d8-4dbd-153c-08da2214a008
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4347.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 14:55:20.7795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sm9xKPcUu3daGyPVA7X2f4aC63f5G5l/NKObIJ960ItWvINcEGjiSxdfrZu02cSvHvRUnENKmm/O1wqUfsfudg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1378
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

Pass bus argument to mlxsw_env_init(). The purpose is to get access to
device handle, which is to be provided to error message in case of line
card activation failure.

Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c     | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/core_env.c | 6 +++++-
 drivers/net/ethernet/mellanox/mlxsw/core_env.h | 4 +++-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 0e92dd91eca4..fc52832241b3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -2175,7 +2175,7 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 	if (err)
 		goto err_thermal_init;
 
-	err = mlxsw_env_init(mlxsw_core, &mlxsw_core->env);
+	err = mlxsw_env_init(mlxsw_core, mlxsw_bus_info, &mlxsw_core->env);
 	if (err)
 		goto err_env_init;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index b3b8a9015cd6..abb54177485c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -28,6 +28,7 @@ struct mlxsw_env_line_card {
 
 struct mlxsw_env {
 	struct mlxsw_core *core;
+	const struct mlxsw_bus_info *bus_info;
 	u8 max_module_count; /* Maximum number of modules per-slot. */
 	u8 num_of_slots; /* Including the main board. */
 	struct mutex line_cards_lock; /* Protects line cards. */
@@ -1194,7 +1195,9 @@ mlxsw_env_module_type_set(struct mlxsw_core *mlxsw_core, u8 slot_index)
 	return 0;
 }
 
-int mlxsw_env_init(struct mlxsw_core *mlxsw_core, struct mlxsw_env **p_env)
+int mlxsw_env_init(struct mlxsw_core *mlxsw_core,
+		   const struct mlxsw_bus_info *bus_info,
+		   struct mlxsw_env **p_env)
 {
 	u8 module_count, num_of_slots, max_module_count;
 	char mgpir_pl[MLXSW_REG_MGPIR_LEN];
@@ -1221,6 +1224,7 @@ int mlxsw_env_init(struct mlxsw_core *mlxsw_core, struct mlxsw_env **p_env)
 		return -ENOMEM;
 
 	env->core = mlxsw_core;
+	env->bus_info = bus_info;
 	env->num_of_slots = num_of_slots + 1;
 	env->max_module_count = max_module_count;
 	err = mlxsw_env_line_cards_alloc(env);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.h b/drivers/net/ethernet/mellanox/mlxsw/core_env.h
index 6b494c64a4d7..a197e3ae069c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.h
@@ -60,7 +60,9 @@ int mlxsw_env_module_port_up(struct mlxsw_core *mlxsw_core, u8 slot_index,
 void mlxsw_env_module_port_down(struct mlxsw_core *mlxsw_core, u8 slot_index,
 				u8 module);
 
-int mlxsw_env_init(struct mlxsw_core *core, struct mlxsw_env **p_env);
+int mlxsw_env_init(struct mlxsw_core *core,
+		   const struct mlxsw_bus_info *bus_info,
+		   struct mlxsw_env **p_env);
 void mlxsw_env_fini(struct mlxsw_env *env);
 
 #endif
-- 
2.33.1

