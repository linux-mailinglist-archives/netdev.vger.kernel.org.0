Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8995A2BFD
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 18:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244406AbiHZQHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 12:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244755AbiHZQHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 12:07:37 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2054.outbound.protection.outlook.com [40.107.212.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFBD3D5DD5
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 09:07:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cGtqRh3LOAAwSYELD2DEGPiXo0w2lcD1Xub5Y6C+Vb4gLhrDECRyZ+NZ0x8HAQPqNDfRD5I4O5dpjAq57uHWHOjW/SjcZR5CpOrXItX7L3LXphQKdDGeqQWcw0iYD46kUuX5RwGi+5gknLxDclbOl4xG0eWdDAdjjMRUMimzmr/K8O0LdepVc2Vkk0kvRX0nD6tHySA5is7yg84iBmExKf2Mv1Y3RvVgL8k6USaXVWaUtMhqjpryhvX2OZu3Td7ROqabEdqHu8Ie3jq8CuMzrJQfvYdxKooU4OvYuTNCLlgBIBJmZeoCpGM01E9BHDnqn0EPSZvkp03X99J/+6SzXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MpBZrGXvsjxar+fGZySFiUQXiJ/4SIBcfLraLfm7g8o=;
 b=fGivAyUBYR1wdUnD7iglszN6GpR63su/vRt0SMIWMM0l5RtoFBNNNEuQp4f3yiDUOiOaUHEeEb0MnSJMEkD6J9I5bCeUQVbQGrUVe3GQm8715zLmcqHWybrhk1xdaCiRh1KDPIgaN2UVIxIyJKGMVJCXHrYKfaSlZFacjILg/SrFql/bG+m4PoL6h4wXkLLDdiBEZg8PbcmyFGTf/PltfMdJej6NeoKY3Wxul6uANmbOy2xGvWzQfGuRwIUnOYIpd7Ac5uncGZJr/FcdNskfFltS+58X6riINZ5lQ0GzzG5pGDDLEVrZEJJAIHwmPGC5FoPXpjzC0uKO5uVHAAYjXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MpBZrGXvsjxar+fGZySFiUQXiJ/4SIBcfLraLfm7g8o=;
 b=Te3XiM2UZct7v065nfGrm/BjWKltkF5/hMEt3eC+O6LcT+gYtZ2P9buFc4g4nt9+yVQFsoK70dFV3MJorSwPshnre8PdGv3Rd0/mN0JtB8MCiOTLQSkqpW1jlkCO9IJGcJpdXgFbVM1C0uF6ucDCaWhzpICBnZiy3DEZ/SmEHr2r/S/pHDW7TsxfhLjahsMAnx7w9JRUS2rcyZZsmKxDqoEY3965HgOhHAOEVDF1e2odn2gjEeQ6Kpvrw+1EYWwWbZgPP5ZU72wHIJQNdTYFh/JY5PKaUil62db9ilyuZx5iy5RYa0tSdXUeAByasLnGUelCJyNnrLXBfdzq7ceUiQ==
Received: from BN8PR07CA0035.namprd07.prod.outlook.com (2603:10b6:408:ac::48)
 by IA1PR12MB6580.namprd12.prod.outlook.com (2603:10b6:208:3a0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Fri, 26 Aug
 2022 16:07:32 +0000
Received: from BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ac:cafe::f0) by BN8PR07CA0035.outlook.office365.com
 (2603:10b6:408:ac::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15 via Frontend
 Transport; Fri, 26 Aug 2022 16:07:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT057.mail.protection.outlook.com (10.13.177.49) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5566.15 via Frontend Transport; Fri, 26 Aug 2022 16:07:32 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Fri, 26 Aug
 2022 16:07:28 +0000
Received: from localhost.localdomain (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Fri, 26 Aug
 2022 09:07:26 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 4/4] mlxsw: spectrum: Add a copy of 'struct mlxsw_config_profile' for Spectrum-4
Date:   Fri, 26 Aug 2022 18:06:52 +0200
Message-ID: <b8712bdbfbcc6d1d66e492f613f37a165119e6fa.1661527928.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1661527928.git.petrm@nvidia.com>
References: <cover.1661527928.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be3e9f9f-caea-40f8-b834-08da877d156b
X-MS-TrafficTypeDiagnostic: IA1PR12MB6580:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YpNzYXqeFA/O7Kcli5sIGi6bMC+AkFgM19l0XLRXdpRbHKxukjTohCvqQRe8zAczIXSUfB8DnBUJlMT9rGr6lMCSF5+MoQiu+u2odL0vAfwvdKPhKe+VguMbWDBfrgaxUHn0fKBiIbTG4jCMS0w3g8z0se38t0MRy9EmGLQ5XPS4GsOE7fN8d8XYauasHourTK5iRaD2v5/os2X4x4APT+28OqC900FvoJuM6+bS4r3ptjputKjAXocdC6nUjAKouHGMmS44cz51u2FdZ/CP7zTVTjv6k0kL2DdNV64Q9SgkC9ka7hOu3mjkCeP3wjSpvsa5qzoXvd3KRXwTuh3w6iiBvxDNVZxv+TmrJyPKXdqCv3YVeOkSKb8EO6svOg5hcgpqyrRAWjmrKEZrKu3uMwZuQW1yMVXw3FkozJhPcfTtWgJ+Ja5LuZW7dWNAiHJPcCth9EHWPoOWLX7mphF2BnVqdShmHCcAGgxDOs/zvXfUQ1hrW+lYt81hMkTYGFGyuM7YlxIL0tpfBeHkxbl/FLdUzTdTRR50uXA9PdVzHgG2oAVOLsg9h30CRarjT+uE0EP2wI1r9jtomyP8sRuxZV5kkuzqlUcOQRcR/QnuhLhjJuZjxhwI3IAsKSPWVg4DH7cUqS0fmIiSjjIDioLGhXWst/uuoXApuJIUQkQg8t/5yAor4N71wqijitvzR/NV/p4Luq58+/B/ISmW25cGZRxWmVN5W7HCLxV/vV44BJ8AzLu7YS1iE5htaNlkA/KH0i4vnYoMjB3jDsWrB7XSs+pVotmpNP1pMntmbNPxEgrWvy7MnpmmDV5WPMweVPsR
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(396003)(376002)(346002)(36840700001)(46966006)(40470700004)(107886003)(110136005)(82740400003)(356005)(54906003)(316002)(82310400005)(70586007)(36860700001)(4326008)(40480700001)(70206006)(81166007)(8676002)(36756003)(47076005)(2906002)(26005)(40460700003)(6666004)(83380400001)(426003)(86362001)(478600001)(41300700001)(336012)(8936002)(5660300002)(186003)(16526019)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 16:07:32.4514
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be3e9f9f-caea-40f8-b834-08da877d156b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6580
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Starting from Spectrum-4, the maximum number of LAG IDs can be configured
by software via CONFIG_PROFILE command during driver initialization.

Add a dedicated instance of 'struct mlxsw_config_profile' for Spectrum-4
and set the 'max_lag' field to 128, which is the same amount of LAG entries
as in Spectrum-{2,3}. Without this configuration, firmware reserves 256
(the value of 'cap_max_lag' resource) entries at beginning of PGT table for
LAG identifiers, which means that less entries in PGT will be available.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 29 ++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index c71a04050279..5bcf5bceff71 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3512,6 +3512,33 @@ static const struct mlxsw_config_profile mlxsw_sp2_config_profile = {
 	.cqe_time_stamp_type		= MLXSW_CMD_MBOX_CONFIG_PROFILE_CQE_TIME_STAMP_TYPE_UTC,
 };
 
+/* Reduce number of LAGs from full capacity (256) to the maximum supported LAGs
+ * in Spectrum-2/3, to avoid regression in number of free entries in the PGT
+ * table.
+ */
+#define MLXSW_SP4_CONFIG_PROFILE_MAX_LAG 128
+
+static const struct mlxsw_config_profile mlxsw_sp4_config_profile = {
+	.used_max_lag			= 1,
+	.max_lag			= MLXSW_SP4_CONFIG_PROFILE_MAX_LAG,
+	.used_flood_mode                = 1,
+	.flood_mode                     = MLXSW_CMD_MBOX_CONFIG_PROFILE_FLOOD_MODE_CONTROLLED,
+	.used_max_ib_mc			= 1,
+	.max_ib_mc			= 0,
+	.used_max_pkey			= 1,
+	.max_pkey			= 0,
+	.used_ubridge			= 1,
+	.ubridge			= 1,
+	.swid_config			= {
+		{
+			.used_type	= 1,
+			.type		= MLXSW_PORT_SWID_TYPE_ETH,
+		}
+	},
+	.used_cqe_time_stamp_type	= 1,
+	.cqe_time_stamp_type		= MLXSW_CMD_MBOX_CONFIG_PROFILE_CQE_TIME_STAMP_TYPE_UTC,
+};
+
 static void
 mlxsw_sp_resource_size_params_prepare(struct mlxsw_core *mlxsw_core,
 				      struct devlink_resource_size_params *kvd_size_params,
@@ -4042,7 +4069,7 @@ static struct mlxsw_driver mlxsw_sp4_driver = {
 	.params_unregister		= mlxsw_sp2_params_unregister,
 	.ptp_transmitted		= mlxsw_sp_ptp_transmitted,
 	.txhdr_len			= MLXSW_TXHDR_LEN,
-	.profile			= &mlxsw_sp2_config_profile,
+	.profile			= &mlxsw_sp4_config_profile,
 	.sdq_supports_cqe_v2		= true,
 };
 
-- 
2.35.3

