Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6D265A2BFC
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 18:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbiHZQH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 12:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238990AbiHZQH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 12:07:27 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2072.outbound.protection.outlook.com [40.107.94.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345B9D4F4F
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 09:07:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=atCZB19kklpE/Eytlo43u/br88oVZaW5K4x7O7WlN8V0ToIDWr+6o0PjwB5o7C/5sJJepyMdvWAbPE7zcxLJhcy4D9pZTjbfkl3hvy6i/IZdDUF0WM/lDEc4C77bOL1eKFrjSD1Dkk/ee6HLakFimZv1Ai/M8T/S+BtXK6oVMM4JTUDCXWF3WWVs4G3AqaIN9ao+gOEOnB+P7kwDkcW9uQMitXQZ4phhClEzM4uTng6mH+wCmvgE/cItw2zxYmOTSnFYwCilcA2C58JssviVryAvQvIaUuM3HSe955VgbLNNrDakOmuL68Zi39KVMxfWS1oZEGnV+XNwIF2gJBEfrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UoRM4ElOm6xz102Vrghpn66OnPJgwXzUsQJ1oW7Rvxo=;
 b=TJ+MXzXZ5TNOicOQH0iTSyHJYGB4zS+5T9UMpfxTH0/2KlnOGC7f4+vz1ztXFadWE0nOSMAWvo2kG0Yf3f75DbX9Z5oSCJmK+Sr9x6SQIza2OdUiFH8KoL8JU7SUr2LuAVChW59i/5gcgQLDyrTWvJHALlVREWPDGraJNYnB+UhrXpr6Xk8j2hPj3cTC7U94Lpp20G2XMRWfhBxyi3CBHtqNiB6Ma9WkbJDITdNUKOvE138nv5N1BxiBmgM66cwbYr/j1ObuHe+eEleJibs1Tc02Tw3rsIWEtVZkPHFI4lliJt2U2lNMVX5bBFCRs7oKkk9WO63kziYNMI68HoLMYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UoRM4ElOm6xz102Vrghpn66OnPJgwXzUsQJ1oW7Rvxo=;
 b=mJlJrgmFqYyboDQmgbLGsaBjb35t//mDS16WW9Z0bdMOLVDk9sTkQcRDg2Xe264PNVmRe6ZKYoLkAvU2DWv/eSoeqq4A4bzZAOTtF3HUTI4u2TrwSuyhr2u+urnilxvwHvAmGwbystuUoos4Z51LbN4WyhAWjfH2rk+KiXRXvqalMTingjIs1bkyc05q1ziMFuHwid8Z+50RU3fg+NcD9s1sJNomwyMmAA5OViDF1UcVOCM8kk2oIta9/HdEB74Xc4bifd+re8XuOMO41UuEzXBHfYiN7jhbvefDOmC0Zb6BnaxwYVg4weNjvFGFOEsZvDtphjHqbHbIqD7LKzz4wA==
Received: from MW2PR2101CA0023.namprd21.prod.outlook.com (2603:10b6:302:1::36)
 by CH2PR12MB4103.namprd12.prod.outlook.com (2603:10b6:610:7e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Fri, 26 Aug
 2022 16:07:24 +0000
Received: from CO1NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:302:1:cafe::ba) by MW2PR2101CA0023.outlook.office365.com
 (2603:10b6:302:1::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.7 via Frontend
 Transport; Fri, 26 Aug 2022 16:07:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT057.mail.protection.outlook.com (10.13.174.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5566.15 via Frontend Transport; Fri, 26 Aug 2022 16:07:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Fri, 26 Aug
 2022 16:07:23 +0000
Received: from localhost.localdomain (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Fri, 26 Aug
 2022 09:07:20 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 2/4] mlxsw: Support configuring 'max_lag' via CONFIG_PROFILE
Date:   Fri, 26 Aug 2022 18:06:50 +0200
Message-ID: <afbd4c166daf1afb2618b729d011a12b5d96f8a6.1661527928.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: a7afa2c4-bd75-4f66-b65a-08da877d1063
X-MS-TrafficTypeDiagnostic: CH2PR12MB4103:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9zuv+8A9PIF8wu1xCjQE5FAiuOjCZWiTC8pQqnufS+hJzOgGoG3P72m9c0l5tbWH+FW9fM9ZM/ER97McE1qZa2B4ORh7mxIgN0TmO4JfkEze2l2NooZdPlPKDVGp1/gIq0qhOkW1N53C5MST8ENKisW0cEGRcTWmUbjTTUg3JotrnjlEHlTFKkfhcQrEx+iKe2gMUddxLD22Pp5yWurZJjydfqKkBPI7HQ6+VaA7cWZzmnp3TNhVBopzuI0lxXrVlYSsglxQp9jFKQaU3d+wTVQVSvbU9nAPuZ1a7QJXVqP4+otT/14pnxAJZonv4xwuCbQ5gT6Z4GoeNpULmVhLuwC8kG58sP6sF40s8hiXllqK9NsQNiGVuq0F/T6hSO5R7tPWprvTR5qWy4f8h1iNUF092fcFUl6knu9tFs067QuXztYlAibG5hMnS2e5XZM0DZzswLD/IZi0Xioo7Tj+RHB2vqk3dnJPLy6vGh1fQkFsudzyEP969XOoot6/ZHeGecIsf1IEk+JN4mwtoxotUljJvs5RGO5OxdgL0SSYTv+nahE2pJIeZPCi1OCRTOqShQHFt3t/Pptra8IxG3tsFrTZOPW/ozFRlEtPcd94l8w1Mx/a5MKP/mSZMeY1KXHHXDkhBDsgbKBtQTF5+28R62S09KZwJP/Hm3llu80Ah/EfmGZdaN1kSGYinY5u3DhRWWQDQSOv3T6jFuH8/hqCkm0OUXSQxAiLBXUMDpDjbmKnEUNWFnGtb+jtDCaedyWOcT+pufpK69GgtGSjZrXkMC72D6OcfdVHlpZ9nJ5FyWw=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(376002)(136003)(396003)(46966006)(40470700004)(36840700001)(107886003)(6666004)(47076005)(426003)(5660300002)(41300700001)(8936002)(86362001)(16526019)(336012)(186003)(2616005)(40460700003)(26005)(2906002)(82310400005)(356005)(81166007)(82740400003)(83380400001)(40480700001)(36860700001)(54906003)(36756003)(110136005)(478600001)(70586007)(316002)(8676002)(70206006)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 16:07:24.0884
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a7afa2c4-bd75-4f66-b65a-08da877d1063
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4103
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

In the device, LAG identifiers are stored in the port group table (PGT).
During initialization, firmware reserves a certain amount of entries at
the beginning of this table for LAG identifiers.

In Spectrum-4, the size of the PGT table did not increase, but the maximum
number of LAG identifiers was doubled, leaving less room for others entries
(e.g., flood entries) that also reside in the PGT.

Therefore, in order to avoid a regression and as long as there is no
explicit requirement to support 256 LAGs, mlxsw driver will configure the
firmware to allocate the same amount of LAG entries (128) as in
Spectrum-{2,3}. This configuration is done using 'max_lag' field in
CONFIG_PROFILE command. Extend 'struct mlxsw_config_profile' to support
'max_lag' field and configure firmware accordingly.

A next patch will adjust Spectrum-4 to configure 'max_lag' field.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.h | 2 ++
 drivers/net/ethernet/mellanox/mlxsw/pci.c  | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 9de9fa24f27c..383c423c3ef8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -295,6 +295,7 @@ struct mlxsw_swid_config {
 
 struct mlxsw_config_profile {
 	u16	used_max_vepa_channels:1,
+		used_max_lag:1,
 		used_max_mid:1,
 		used_max_pgt:1,
 		used_max_system_port:1,
@@ -310,6 +311,7 @@ struct mlxsw_config_profile {
 		used_kvd_sizes:1,
 		used_cqe_time_stamp_type:1;
 	u8	max_vepa_channels;
+	u16	max_lag;
 	u16	max_mid;
 	u16	max_pgt;
 	u16	max_system_port;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index 50527adc5b5a..c968309657dd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -1187,6 +1187,11 @@ static int mlxsw_pci_config_profile(struct mlxsw_pci *mlxsw_pci, char *mbox,
 		mlxsw_cmd_mbox_config_profile_max_vepa_channels_set(
 			mbox, profile->max_vepa_channels);
 	}
+	if (profile->used_max_lag) {
+		mlxsw_cmd_mbox_config_profile_set_max_lag_set(mbox, 1);
+		mlxsw_cmd_mbox_config_profile_max_lag_set(mbox,
+							  profile->max_lag);
+	}
 	if (profile->used_max_mid) {
 		mlxsw_cmd_mbox_config_profile_set_max_mid_set(
 			mbox, 1);
-- 
2.35.3

