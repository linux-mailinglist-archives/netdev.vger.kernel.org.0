Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEBC591302
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 17:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234600AbiHLPcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 11:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232434AbiHLPcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 11:32:48 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2047.outbound.protection.outlook.com [40.107.93.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0351D7666
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 08:32:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qnr2MoHgjmCRgae0FDrDT0ETz+GFcMoIRK0T3uKmj2eGPtYfnMm5lc/TZMKClTGgCC72RnkhFRRHH590oUD9obVEeGVs8dmdPFnB9jfHNZ2BQ9K50XBWVdpMmiCdox1gtCngvQDcSCmk7w/AiwDrRSl5UJiEeiL5deHdwwu1XLF0EeDaXloCCno7j9rZ4r/xG6jmuYX5I1/S/qv9nl3pvzLHPUnPrUb2OiLsrizM3fNZXD0NSsKisQPjizZZVWtTXiRacr7pNZp2+10q+v1CeRk8ouCcBKfpo7nYRYU8+r237Zk8o1h9FJgzvEXSt8PpL+8JCK4CNUOS9YQUT02Khg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NuoK/uDnXaOmGgk15dDT/qx6wtPSp9Vz24stC7LjWoI=;
 b=ay2p3QPz8oKhHZ9Wn5pXBXoy50T4fUat0Bm8FBWOchwk2zJve4x3D9jWFnV3XVAi3aiYvzgtSFcLYUs2mc3GB3Kt/fqgxCS0GIsnAbuIFWRABhQsqYI2CDHA57vhq0h665KmNILlWvz/G1mn3CbZI1kkTnWzeDHFMqK+JttglQAZuSHL3UDLEnqLHXD1ZjJyAALivNyKqU16qC5Q+er3CjAevRQ5e4VSH9MFYQTme5XcWn6aAZC+HAmH7t5tLa4jB9B64ejW0fxYLDBGstQmszlHsNXSH+QjTXkOb6pfXNZ32rku9fkJ3p+KtwiNBG5OIuRW1ltIPiMbUyd/JAUrtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NuoK/uDnXaOmGgk15dDT/qx6wtPSp9Vz24stC7LjWoI=;
 b=PmQ/m5rohSQuPaL0GYxo2ZbJCxm6cbGWp9/6WwHQAzDehYYpP+SL0hwcHNeR+BcZEJmYZ2q9pTqPyUeChmuL8fGg0gJLid+HsEvAel6wUS7xogvd4TmwA+thJEYV3SL1pk/AGsldX1DQ0QM+wFdFKpWnG4YvPhuBHZFWEHb25ZgG30FAFNmHkEZqdS4JrIH48OWHn1Jkmzyv6Q1ZQoqcRBXt+Z2apVT6S6KqQRdmv2dPPcrP4c2P2EPp8DJlGtgoIHnPpyp5tmXUqRPsToXRkYC132dXpSi6WjmqXpiCNIfs78MBAfabfNEyEHE/EDlZNzVncWX2pwpbxi+8lsDVrQ==
Received: from BN9PR03CA0312.namprd03.prod.outlook.com (2603:10b6:408:112::17)
 by MN2PR12MB3327.namprd12.prod.outlook.com (2603:10b6:208:cd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Fri, 12 Aug
 2022 15:32:45 +0000
Received: from BN8NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:112:cafe::9e) by BN9PR03CA0312.outlook.office365.com
 (2603:10b6:408:112::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.15 via Frontend
 Transport; Fri, 12 Aug 2022 15:32:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT006.mail.protection.outlook.com (10.13.177.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5525.11 via Frontend Transport; Fri, 12 Aug 2022 15:32:44 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Fri, 12 Aug
 2022 15:32:44 +0000
Received: from yaviefel.vdiclient.nvidia.com (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Fri, 12 Aug 2022 08:32:40 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Petr Machata <petrm@nvidia.com>, <mlxsw@nvidia.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net 1/4] mlxsw: spectrum_ptp: Fix compilation warnings
Date:   Fri, 12 Aug 2022 17:32:00 +0200
Message-ID: <8ecc2b50b5ae0a4e6d2288a7807187c9c820870d.1660315448.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1660315448.git.petrm@nvidia.com>
References: <cover.1660315448.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3541f39-d0df-4cac-af55-08da7c77e747
X-MS-TrafficTypeDiagnostic: MN2PR12MB3327:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: caFJqba8JkFMfrwHe0zw/ZZJInEHt40vfM5RU8pUdtZJ5QIeBOiMPThqYQufEe+Gh6pKESW/6aD69VCvVdVDXIK+/4woOhOR+Bz7G0FhFD1YY+xsdCWxAe2eIjE1SMTzU+qnfcAJWe2QwFA3CMaszY0EbOZQFJZC5fH4Dtu0slItdk76Sa3kd/g2mDkkltbeJe1DNfWDbu2NKpX94mNO7xLBSmQQ3yYwvuiP+Q/VwPu/xobrqBqNU13srZtiRzL9TNeLGeJYU31Q45neMDSThWuwuNjGwsLl4G4VSNfuFammsQ+nq9kztVMDYVyE9b5UsZU2/e1khZ8iF4C4B+aiVPYilcux+1rKG7NoJodY0TNU/FFi/2VYT1sXoLoheLWbKT4vg80dNWa72B2R3r+FbvC6yAx3WW1hK7XBYxUW/29yueH2nj4oVQCqpyaR9/JIo8jRvd8BWMjkXdTqhx73/TRHzWRiKU422vcazQenh8FQKeqOF/ux7LmBIzFp7pPV3b3XMfNsLNWmRfIt6i4brExQ2SH3FFXGwbqdQhu3jA3SB84r/cUKC77Rc2kNc8MeEs8sPBI+AGv9LTjnahXPmV3kK1fGEwAYcXjan0j0QAjuaZ55twgpnQc+DQE6PJxEVCB6SdT+KObYpYkqUy+QA7rerK4vKraSWtrhn+EJYkvJzhwjIlJmIAoKm17K6SNNBh5mPnH+zacTJ7bSnuIddVNpv+gUKyk1K0RDo/11td0KpGIFJIbdPq+I4hB+atPy6G0Qc/LKYKgQfVRfInSYyNyPdvfEuLTNagroBb6BglKH6KQVZhq/npT9NZ50F53KZ1LiMIPeDX99zEDlZod94A==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(136003)(376002)(346002)(46966006)(40470700004)(36840700001)(8676002)(70586007)(54906003)(82310400005)(70206006)(110136005)(316002)(36756003)(4326008)(5660300002)(478600001)(41300700001)(40480700001)(2616005)(8936002)(2906002)(16526019)(83380400001)(336012)(186003)(426003)(7696005)(47076005)(40460700003)(82740400003)(6666004)(26005)(36860700001)(356005)(81166007)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2022 15:32:44.7815
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a3541f39-d0df-4cac-af55-08da7c77e747
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3327
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

In case that 'CONFIG_PTP_1588_CLOCK' is not enabled in the config file,
there are implementations for the functions
mlxsw_{sp,sp2}_ptp_txhdr_construct() as part of 'spectrum_ptp.h'. In this
case, they should be defined as 'static' as they are not supposed to be
used out of this file. Make the functions 'static', otherwise the following
warnings are returned:

"warning: no previous prototype for 'mlxsw_sp_ptp_txhdr_construct'"
"warning: no previous prototype for 'mlxsw_sp2_ptp_txhdr_construct'"

In addition, make the functions 'inline' for case that 'spectrum_ptp.h'
will be included anywhere else and the functions would probably not be
used, so compilation warnings about unused static will be returned.

Fixes: 24157bc69f45 ("mlxsw: Send PTP packets as data packets to overcome a limitation")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_ptp.h | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
index 2d1628fdefc1..a8b88230959a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
@@ -171,10 +171,11 @@ static inline void mlxsw_sp1_get_stats(struct mlxsw_sp_port *mlxsw_sp_port,
 {
 }
 
-int mlxsw_sp_ptp_txhdr_construct(struct mlxsw_core *mlxsw_core,
-				 struct mlxsw_sp_port *mlxsw_sp_port,
-				 struct sk_buff *skb,
-				 const struct mlxsw_tx_info *tx_info)
+static inline int
+mlxsw_sp_ptp_txhdr_construct(struct mlxsw_core *mlxsw_core,
+			     struct mlxsw_sp_port *mlxsw_sp_port,
+			     struct sk_buff *skb,
+			     const struct mlxsw_tx_info *tx_info)
 {
 	return -EOPNOTSUPP;
 }
@@ -231,10 +232,11 @@ static inline int mlxsw_sp2_ptp_get_ts_info(struct mlxsw_sp *mlxsw_sp,
 	return mlxsw_sp_ptp_get_ts_info_noptp(info);
 }
 
-int mlxsw_sp2_ptp_txhdr_construct(struct mlxsw_core *mlxsw_core,
-				  struct mlxsw_sp_port *mlxsw_sp_port,
-				  struct sk_buff *skb,
-				  const struct mlxsw_tx_info *tx_info)
+static inline int
+mlxsw_sp2_ptp_txhdr_construct(struct mlxsw_core *mlxsw_core,
+			      struct mlxsw_sp_port *mlxsw_sp_port,
+			      struct sk_buff *skb,
+			      const struct mlxsw_tx_info *tx_info)
 {
 	return -EOPNOTSUPP;
 }
-- 
2.35.3

