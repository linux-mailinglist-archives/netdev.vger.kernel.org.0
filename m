Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 326D46459F0
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 13:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiLGMiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 07:38:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiLGMiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 07:38:11 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2074.outbound.protection.outlook.com [40.107.102.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0C52EF0E
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 04:38:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bJHMQRfkpKf1KrOHn2MksFvj4lRY7HmH8JhMS64qtOs9uG6pVExXlKKes7lSO05iKIuopFrs3SRQoJ2+WXndVnIfqb8LmXiajkmMmHzphMvAamavGFSLFllnKMIjzp2IksJKCgWxWf/X0NoMutsngebyMkQbkvYWya0zjQ7C5phjc90y/YI6d4nRKIO4MyP1OGG8D1QlvSS3nzC0wxG7MAXBOdz3tWJlREvJsjc9qc+0OzkJRcPyn7PlDF3RlmaCpWWak/EXbbNffgoM76nvP/1PiS1KUd5PiGcG2Fzm/QP2OkEkCz0852VdSuqxxB8bujUMYVN94+v/enpzQMl83Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B+csvY3pC6ivjzoOLbkjlxN+KxbWYNAq7Ef4QPCWBhw=;
 b=IR+hUWQkrJafJ1c4ZhdO+gxHIOuz8AbZAXPjBaUnNOLL/S/brJQF8rSSvTLT8xwXDsWNSJ+n6eOuzKq6D+QNaQxMxI56mViMNKGqzxG29Mjkc5tTEFIi6g3R6azFvgQcjc5+JhIb66SQP+jIdqwg9kP+IBKXHF+5atiBrsGyKviP7GVxoz5tWtZVTc5bdD5nlMhhOvXt40JQFAY2XsQVe7BghgGOQIxfndZlIfoyjgTfmhDLi6h0uK+xXQ7j3WK8URlBqZqCLgFz57kAASQHmKpX9wcc1eO7FMRxXk3hvScGaLoK2Aimp/+A9yc963xY0QAm8BN92o3Szrg6QxpoAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B+csvY3pC6ivjzoOLbkjlxN+KxbWYNAq7Ef4QPCWBhw=;
 b=YBOIhHIgP6i02WL1jWYF+ZAc3cJGobO2RqIS/z9zY25o6px6qg8bur29Jz+c3G4oQaNco5kyZjSBrUEhS7eY45Rw2sYRvL6oiYOApE5Sr45ny8dEUSyVaERQx1cN3u/hCSpARPvzwdE6lqiTsP55OjUsTiSsNntHeTZFBsDqyep9lTJtH0bk+YkBLXG+vrifvYSe2GmFda5Rtp8h2Z80+ncbcyjWv69DnQ8emLl7+ruCbAXc01xhgtkrTCCs5oVyRRFIi0yQ5Ejrzc5Ia7olMJWW0IQ2CqUeeH1Oh/K5H9/3fpuC85+UJWCCi2WpH937QWt6a3SLJ2RAk7u90TcjAQ==
Received: from DM6PR05CA0063.namprd05.prod.outlook.com (2603:10b6:5:335::32)
 by SJ1PR12MB6172.namprd12.prod.outlook.com (2603:10b6:a03:459::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 12:37:58 +0000
Received: from DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:335:cafe::6b) by DM6PR05CA0063.outlook.office365.com
 (2603:10b6:5:335::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5901.8 via Frontend
 Transport; Wed, 7 Dec 2022 12:37:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT058.mail.protection.outlook.com (10.13.172.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5901.14 via Frontend Transport; Wed, 7 Dec 2022 12:37:57 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 7 Dec 2022
 04:37:47 -0800
Received: from yaviefel.vdiclient.nvidia.com (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Wed, 7 Dec 2022 04:37:45 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "Amit Cohen" <amcohen@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net 3/6] mlxsw: spectrum_router: Add support for double entry RIFs
Date:   Wed, 7 Dec 2022 13:36:44 +0100
Message-ID: <14ac063f5a37f155f74308f877321f4ad2fc050d.1670414573.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1670414573.git.petrm@nvidia.com>
References: <cover.1670414573.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT058:EE_|SJ1PR12MB6172:EE_
X-MS-Office365-Filtering-Correlation-Id: e1592f7e-8c2e-4dec-1055-08dad84fde8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4nASvAxQg9t3zrtjXfI+rNhBAuaTfxF7+sS6zq2oauZztM3y85sD6L3IQ+oxrZxNMByPLaEstf5utgWuX0cXVQfWhN3pin6R+hZn9VZeMbK6GcAtFffGl56OpbQzds/Hex7Ge7vFVZcE6IrMY3gTMFhatKEonNnhZrmlyaeAmIH0BpTQhDvC3NlQv3ItSaPMhA65UKHhyTQDyVcINZ5+k4XkGI3O5TsRHdZn2vH+fT/aMGY3njhukamX05RWTdetJFTRuIDGUSR/kkRsDnMjtxQY3So1c9HmRxed6eixp8Zyi/uMskE+kkmxwFSsksYV7PCAFEoCgz4dw+tQ0UmAJOOBv/v8/w2/9w14dAM1U0WAVI32SYiyCRgrXP6k4v3z39qBLsphQZg2TM09bIt3nCpEGtoOY10RvuyAtbJGC5gjpJJ0zHnEL766CVKKBin7BrhB7VSDxQbeFEoPzVhev6LoVitx+9fWeF6Di7OafCpsxmB3vo0aGStbq300KyaYxABKxaWCmo24LIm7VOF2KomBJAjTYHI2TNTn0Yy8YoZdtnEa9jaALO3eR36+NODFA2J0+9MLvdFkmKZcoJkpoo3lBW4Hyr4t2fuHswj/Jvr7nQWPT7Q/7p01vnIJt7av53rPRLnfOQKcaKxoVWpySX40yPcqaLYiQLjxdJIUwCz88bORzpo4pE2mYeQ/iW4PdJVq54Qd9PFYc9KFGUj7Ew==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(39860400002)(396003)(136003)(451199015)(46966006)(40470700004)(36840700001)(47076005)(66574015)(426003)(478600001)(40460700003)(7696005)(82740400003)(36756003)(40480700001)(86362001)(83380400001)(36860700001)(336012)(26005)(2616005)(356005)(16526019)(186003)(7636003)(41300700001)(8936002)(107886003)(82310400005)(5660300002)(316002)(70206006)(8676002)(54906003)(70586007)(4326008)(110136005)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 12:37:57.2561
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e1592f7e-8c2e-4dec-1055-08dad84fde8f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6172
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

In Spectrum-1, loopback router interfaces (RIFs) used for IP-in-IP
encapsulation with an IPv6 underlay require two RIF entries and the RIF
index must be even.

Prepare for this change by extending the RIF parameters structure with a
'double_entry' field that indicates if the RIF being created requires
two RIF entries or not. Only set it for RIFs representing ip6gre tunnels
in Spectrum-1.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c   | 1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h   | 1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 4 +++-
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
index a2ee695a3f17..7ed4b64fecc7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
@@ -433,6 +433,7 @@ static const struct mlxsw_sp_ipip_ops mlxsw_sp1_ipip_gre6_ops = {
 	.dev_type = ARPHRD_IP6GRE,
 	.ul_proto = MLXSW_SP_L3_PROTO_IPV6,
 	.inc_parsing_depth = true,
+	.double_rif_entry = true,
 	.parms_init = mlxsw_sp1_ipip_netdev_parms_init_gre6,
 	.nexthop_update = mlxsw_sp1_ipip_nexthop_update_gre6,
 	.decap_config = mlxsw_sp1_ipip_decap_config_gre6,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
index 8cc259dcc8d0..a35f009da561 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
@@ -49,6 +49,7 @@ struct mlxsw_sp_ipip_ops {
 	int dev_type;
 	enum mlxsw_sp_l3proto ul_proto; /* Underlay. */
 	bool inc_parsing_depth;
+	bool double_rif_entry;
 
 	struct mlxsw_sp_ipip_parms
 	(*parms_init)(const struct net_device *ol_dev);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index f3ace20dca8b..c22c3ac4e2a1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -79,6 +79,7 @@ struct mlxsw_sp_rif_params {
 	};
 	u16 vid;
 	bool lag;
+	bool double_entry;
 };
 
 struct mlxsw_sp_rif_subport {
@@ -1070,6 +1071,7 @@ mlxsw_sp_ipip_ol_ipip_lb_create(struct mlxsw_sp *mlxsw_sp,
 	lb_params = (struct mlxsw_sp_rif_params_ipip_lb) {
 		.common.dev = ol_dev,
 		.common.lag = false,
+		.common.double_entry = ipip_ops->double_rif_entry,
 		.lb_config = ipip_ops->ol_loopback_config(mlxsw_sp, ol_dev),
 	};
 
@@ -8091,13 +8093,13 @@ mlxsw_sp_rif_create(struct mlxsw_sp *mlxsw_sp,
 		    const struct mlxsw_sp_rif_params *params,
 		    struct netlink_ext_ack *extack)
 {
+	u8 rif_entries = params->double_entry ? 2 : 1;
 	u32 tb_id = l3mdev_fib_table(params->dev);
 	const struct mlxsw_sp_rif_ops *ops;
 	struct mlxsw_sp_fid *fid = NULL;
 	enum mlxsw_sp_rif_type type;
 	struct mlxsw_sp_rif *rif;
 	struct mlxsw_sp_vr *vr;
-	u8 rif_entries = 1;
 	u16 rif_index;
 	int i, err;
 
-- 
2.35.3

