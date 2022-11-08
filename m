Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22D47620DA8
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 11:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbiKHKst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 05:48:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233916AbiKHKsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 05:48:15 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2056.outbound.protection.outlook.com [40.107.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDA8040909
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 02:48:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XYeuy8pykpAJhAaHdwaB1Pknpz0lmtco/72jqNPiXNvudhllZrlOfNYbJf4QTLCkTaXiRJ8fqPRJaN13Y0g504VK1kzBXY4GuhZ48ovQfIPs/NFLrbB5zoQ/IB4jLPorWFWp+MgxYIPBsLdw2/yB7j+FUxjjICzezXMiuKgABjLIFI/XdGxiUNQpZDac+5eAancoyI73G7ZH8WxY06p9Ve+R5pILdha9vxDDqtMVb9OxFIb+/dQm1AqEvYu0I0tIaw/eofFcly4WqRjAAZi7zppIfgP5BO6nyR7U6VWbzxCVCClBbZ9G4aMhfstR8uspt7Z2vtk3rtcZzLDfobvJlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+vXV0EscbKjPvtQz+Z5GoGH51yAqxSK2mKdAlmDf4A8=;
 b=ZKcJ/RjQz4f9AqTAK4y0XmKLi8N2Hhm+xYB5lC3gATeUMakFOWPehUr0lG58O6054BtUOEdCNjBxNP/omSDFKkpANp2i4ugKxX/pIkL6LtMGzfhSVB6f5bxHmyL6K4UyN/MvAP/4GXtOJVoP0tpm11esbgfDQQVIttH+M97U+k7V9V8P885WuHwyrVWoDc8FC/RMTSRrJ40D8LmgmHrdJ3LLm2ZitaFDpaJBaLxDOkGbWllpj1WKUSYEXNPwm8rpwRq0M4El9hDzQWllY/AiHTKJlLMxPwRVPpSpYR+2CMYQeEw/c25FZIqwcGLm/qWBWZMkBIbH2Hsd5wqG1GlMwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+vXV0EscbKjPvtQz+Z5GoGH51yAqxSK2mKdAlmDf4A8=;
 b=g6wOCHPSRf4d10ZXr87/oRqmGIKx6lclk59YbYBq29xW5crEqk09VYGOdaWlMlRud1owY4fFuGvlEzpTlp8OJEBe6SjpH8ACwJAGm1ZntunIDnvqLd4cwvzI1LroqrXGRsVcRrepOvdyW8nI/Ef0f2yB2ytB+9VHPB7ighsTDgtlqO66VsKAGdTGHPHfG2XAHMlBK0cI5l54q+IomFScXTMaBghrTS0ssxnXMJpnI5f5q7674N5y+stir9wk/jFnQneQBg7k73SsosBq1ih42gttU0bTWxzGeonaKGxco5TPwZStg+UPDFcIlC2hsjCTOmWtdq+uGp2zp5lX54WimQ==
Received: from DS7PR05CA0049.namprd05.prod.outlook.com (2603:10b6:8:2f::27) by
 SJ0PR12MB6784.namprd12.prod.outlook.com (2603:10b6:a03:44f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Tue, 8 Nov
 2022 10:48:12 +0000
Received: from DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2f:cafe::ff) by DS7PR05CA0049.outlook.office365.com
 (2603:10b6:8:2f::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.9 via Frontend
 Transport; Tue, 8 Nov 2022 10:48:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT057.mail.protection.outlook.com (10.13.172.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20 via Frontend Transport; Tue, 8 Nov 2022 10:48:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 8 Nov 2022
 02:48:03 -0800
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Tue, 8 Nov 2022 02:48:00 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>, <netdev@vger.kernel.org>
CC:     Nikolay Aleksandrov <razor@blackwall.org>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        <bridge@lists.linux-foundation.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Hans J . Schultz" <netdev@kapio-technology.com>,
        <mlxsw@nvidia.com>
Subject: [PATCH net-next 07/15] mlxsw: spectrum: Add an API to configure security checks
Date:   Tue, 8 Nov 2022 11:47:13 +0100
Message-ID: <69d965463badfb2f1d714869cb4a86fd252e2114.1667902754.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1667902754.git.petrm@nvidia.com>
References: <cover.1667902754.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT057:EE_|SJ0PR12MB6784:EE_
X-MS-Office365-Filtering-Correlation-Id: 770847e0-de07-47a3-f73e-08dac176bba7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m+iEGVNB7xWo9WLkIF2N8GDr8nP1OBZqczsV1bXZRYM+Ar4hPLhj97a6+ff7qpit9Difnv7dqYXvvM0XhkCm7FD6CU5SR7BdstmJ1tGE6NUCzkfF3b5vPJFH/5W0+e4yYenso2Otjr1FqalZ8ev/+I42cc2/f4kMKVT9R1l7o6euT5uaWFoVBuGFa8fEcnf2kxc9TwavyuUd9rCF6NbXFMF5jEdv8bV1yTqzRgXC/Lt1IsRQtKg0o2MSu5sWp4IhgUV2yg43g7jbPNE79jYAFBV9DJOoR3eWXl6dx/FaPWhy9Eo5S1nwShW38e5jWwOEBX1Ym/nsGvcuwkccnu5xzlBxsb5omHvn/HlrHO0mTXuLMIaF7gmJo0GjD2de3YlMkngscKcM5MpbMUedffDBi8NzNviJc9PsClw13Qddqw8jCAOsiS9uIDWPrAI2x7s5xaLs8HIwEUxOByEZtUHs2AVAKW4G1OOevF0oRenBC3B7afym0h5gr6N47EdJAbPTGLZAFpsBQjBDOhgY7J1JubvV6iCHSBOGwCnXYR/gx/8xqKlF9NqXntWpNnpv1g+svtBo6xW6AY2wS4o09Bqd8SWLK+Rb5xhMPeRPiAEpnMRwI+6bZhyyiZHLTZFqi9WMJ9uYkJNy3TaTuy5Y3Rr++6ax5M1EhfCvEbxoHSXiD0RhUzXtW5b2DzlWWjiPw8SVBrC6es8CdFwYgMDy+RQnGS7QpwSgdsDyKFubqf+myBXoFNgOPuOwzRfolC/lVNuTyo/HFHxjIXn2dVwPQX/mFw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(39860400002)(396003)(451199015)(36840700001)(40470700004)(46966006)(36756003)(82740400003)(86362001)(7636003)(356005)(107886003)(40460700003)(40480700001)(15650500001)(47076005)(186003)(426003)(336012)(16526019)(2906002)(26005)(6666004)(83380400001)(36860700001)(7696005)(2616005)(8676002)(4326008)(478600001)(54906003)(82310400005)(110136005)(70586007)(316002)(70206006)(8936002)(41300700001)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 10:48:12.3432
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 770847e0-de07-47a3-f73e-08dac176bba7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6784
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

Add an API to enable or disable security checks on a local port. It will
be used by subsequent patches when the 'BR_PORT_LOCKED' flag is toggled.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 18 ++++++++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h |  5 ++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 04dc79da6024..b34366521914 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -466,6 +466,24 @@ int mlxsw_sp_port_vid_learning_set(struct mlxsw_sp_port *mlxsw_sp_port, u16 vid,
 	return err;
 }
 
+int mlxsw_sp_port_security_set(struct mlxsw_sp_port *mlxsw_sp_port, bool enable)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	char spfsr_pl[MLXSW_REG_SPFSR_LEN];
+	int err;
+
+	if (mlxsw_sp_port->security == enable)
+		return 0;
+
+	mlxsw_reg_spfsr_pack(spfsr_pl, mlxsw_sp_port->local_port, enable);
+	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(spfsr), spfsr_pl);
+	if (err)
+		return err;
+
+	mlxsw_sp_port->security = enable;
+	return 0;
+}
+
 int mlxsw_sp_ethtype_to_sver_type(u16 ethtype, u8 *p_sver_type)
 {
 	switch (ethtype) {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index c8ff2a6d7e90..bbc73324451d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -321,7 +321,8 @@ struct mlxsw_sp_port {
 	struct mlxsw_sp *mlxsw_sp;
 	u16 local_port;
 	u8 lagged:1,
-	   split:1;
+	   split:1,
+	   security:1;
 	u16 pvid;
 	u16 lag_id;
 	struct {
@@ -687,6 +688,8 @@ int mlxsw_sp_port_vid_stp_set(struct mlxsw_sp_port *mlxsw_sp_port, u16 vid,
 int mlxsw_sp_port_vp_mode_set(struct mlxsw_sp_port *mlxsw_sp_port, bool enable);
 int mlxsw_sp_port_vid_learning_set(struct mlxsw_sp_port *mlxsw_sp_port, u16 vid,
 				   bool learn_enable);
+int mlxsw_sp_port_security_set(struct mlxsw_sp_port *mlxsw_sp_port,
+			       bool enable);
 int mlxsw_sp_ethtype_to_sver_type(u16 ethtype, u8 *p_sver_type);
 int mlxsw_sp_port_egress_ethtype_set(struct mlxsw_sp_port *mlxsw_sp_port,
 				     u16 ethtype);
-- 
2.35.3

