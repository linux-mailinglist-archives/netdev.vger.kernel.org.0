Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88FBD552D18
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 10:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347387AbiFUIfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 04:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348229AbiFUIfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 04:35:11 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2070.outbound.protection.outlook.com [40.107.237.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4E421E3D
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 01:35:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y+ODt0PVS+RUz0RRAwzfp72178M4YPvi/3Uoho0eVGLqjuz3AMo1FS1PSsW/yCgA7cE244ko8aITn+RBziuUPH4QmDHQNewH8soImoI14JmUKntqz2frEyIyk49qLDAN/XXdi1ythsFHI8b/GAJuTTE0sIsIO1kFo4M58m5ysh/pZKvePQb5kOBl1JNyI6f8VyAQpFE36uvI/82fsl+9Qeb3JGHpZFDwhVT5OsU5JWpEHOpXLMKCGvqKcY16JMmte0cZfgSjGW9C4InySJ5+TWkr1P/Sqr4qiUD9befjfTp4P15gu7flF/epuJ80Z74/4KzlkN+448Sl2IcmmZqkgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yKyGQjxGFxizDduEHg+D8Vgpdu/paVdWaQBElwXvfdQ=;
 b=cFh/M5J7v1pEepcv7sONUkeE9+ET74imeDrNX3P0fo8Pqch9+gFSCzZD9n9WjSDPgY+xz6qyYCC4umau/GYU0qY/MxxkbiJf0da/IuJIqIe/s4ghHMptSgCJcIT5HuFq2HWqjy5C6EqpCv5ILOo+ZthypmBBMNBUHIMkRaQ56tYVNphg6r2krVOSbGrVRAlkYjYKT2JaCjprcFMbcku7KFKW/FnwzV+z3uO0CnUaJ4iMGnB5+eQOdoGo44mA3l7scrtfSpXB5mEjq7q3NbVWa4zWLV54R1BQaqvigsW9LosjaNzxbGtrolAx7xnA6rDqsyk75g3Q9WUPrWzsE5TIHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yKyGQjxGFxizDduEHg+D8Vgpdu/paVdWaQBElwXvfdQ=;
 b=bg/oxvT4yoHx4r3s2N9r4y9NceR47KQEs/zfBtkLR31i7uRdBU3Wpz5KEtzAWwluw//Mzsuaj1qmaFHzfC5ICEcs6ujevTXYmlgDM4nAuabi+C5yEmTRFctPqDG7mQAyOrWfzIFiauUJU8K+Kuz+3l11tUEAm0ohS7s2U/YDRzxDbPZaNdYB7ZqPXxK9b+x5v/UsmPumvpJZ8dfvMcGmKq+xkA42Gd0M8qHf+GHTWx5XP2df8/TFvpKGEaEeodr9WfFImWDVePQUklpDPC2NttkJzfqxNQ3hcLBXyZlYSbTxA41SHFDB5kWzLR1AsP76KetI1cfQufC93+7krToLwA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH2PR12MB3832.namprd12.prod.outlook.com (2603:10b6:610:24::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Tue, 21 Jun
 2022 08:35:08 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Tue, 21 Jun 2022
 08:35:08 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 05/13] mlxsw: spectrum_switchdev: Add error path in mlxsw_sp_port_mc_disabled_set()
Date:   Tue, 21 Jun 2022 11:33:37 +0300
Message-Id: <20220621083345.157664-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220621083345.157664-1-idosch@nvidia.com>
References: <20220621083345.157664-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0022.eurprd05.prod.outlook.com
 (2603:10a6:800:92::32) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4606b550-a94f-4713-61a6-08da5360f2a3
X-MS-TrafficTypeDiagnostic: CH2PR12MB3832:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB38320F5E4BD3A755614D4F09B2B39@CH2PR12MB3832.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gqg9XRlzITRs6IKdIJS9mmq1lCEsaulwC2eT3rL3LEH7fBzfiaD5GCNYDtgWTRGVvJxe953EofmlFR8Wweuy4QihFVFIslWAOZeFTgEUXI6bpKRc7p9QojXKQlqoEbSLnbIq2GEAmHdh7JUeqhtb6WWQwWZzHgR/3kapDy1HQbj9ADk50Dy9bMjIhd0D+flgCCYKQcpmpXicQxiDG/mTvi9YiXdxOOr3XMcvU8F7R+gznmc86WhfBNTN9rkZRw9FicZXOGLTuK3DwHT4R3trLkhMhAmJtn/UQ+kiULCLGdSYBy5Mounrhut/YDvezjkIBhcVmbdYZg3FftFjUFi7xuK9SPXv2oJFeAkz3WycRw3vTv71u2t6CdKF0EMqY0rkm8XB82NYaYODykMzcSfmHgBUs5Qbd9IuTSS6os4PfisQWXqYt9g2Z0ku6BXPI4FRxoFmDfvlRItRig3az8PT+yI8TuKgg9Y1ekFzKQA4k6Kpi2kxwVevH7wTvI+XTgktl0qP5+rHSGu/vmTXKYAIjd5sKNSm12OTEQ4l9RHnW6Tmfm6f+DIuveHn68jR7j6PFkTdiOf9jMcBrZWigR09T4f2oP5Jlu3V3QC9wA8bSrUyH/lSINxp2kHGGHZ2PlRyUBtRd19O+GBoHZtYy4YcMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(396003)(366004)(136003)(2616005)(1076003)(38100700002)(186003)(66574015)(107886003)(41300700001)(36756003)(66946007)(316002)(8676002)(6916009)(66556008)(83380400001)(66476007)(4326008)(8936002)(478600001)(6512007)(86362001)(26005)(6506007)(6486002)(5660300002)(2906002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zQKkESleiGcFUndp7cW7NE/g3iPEvLxb8uegJr7eoVa/i8QC4oTtve+T93ul?=
 =?us-ascii?Q?g0ryReNHmYlvpsJNkFiYegkn4EhMHu4ulXarqHf01YyrtPIdEhsV92TPy81B?=
 =?us-ascii?Q?Ua1BRgLedneWUMZrjQMaTcQU81bjspFgSRwJ9J5cnbC9av2gjxMLbtqzG9CS?=
 =?us-ascii?Q?phLTDiJYY/aqwaFxohsFdAncTR/V0/jj2s0m/84JuCOFwBo3/BjSXsntQLzA?=
 =?us-ascii?Q?svU/um4txNU/2tpj4qpp7RrNMsVP6wBcXtPFH5N7+5BsN9g28SbDdl4OpVgk?=
 =?us-ascii?Q?vimlAhvpbBGq5ZStQOUkmXflngsSFhv0pBbGdxtd5QProIB8st9/U4e1M5Gl?=
 =?us-ascii?Q?k8XySVsTCsSKKpHBO4E2yWd3MqS9AaNF5EzguNt2AVZ0chvM7L3/a1U5KGhg?=
 =?us-ascii?Q?7MNUgRQ1jdYGynFfjrGAc+glbXD9s+pQfzZpgk+3MWuPocwsNoGZFLnCQP6B?=
 =?us-ascii?Q?a5Eo2RpVapbsKkaBrgym3M5s7oyV/w+fcwdMFf3MM7Driff7DR7ERIJ/K7e5?=
 =?us-ascii?Q?XfXzadGqGSori8K1N3S2Q2DHNVtFkU05QWFMlggEHXXlP7mbhgUKbkksdnnE?=
 =?us-ascii?Q?SIqqhYAXjLsQ81bVJDx0gMkngjMe6S5T5csaP3hLHwd/P9+yVLnnIBxQuzOl?=
 =?us-ascii?Q?MQUjltRv3HuB0CZb0tQRxcuRL9MfdApV1pLj0yni5cFBN4EgO/a8fbwj+/gk?=
 =?us-ascii?Q?kcHorX0XUy9YgsiejEelThTslBv+X1qWMNPF/hxh6/J1pLnKjKoj+qFrAaEy?=
 =?us-ascii?Q?DFGDttKx4JoQNlDUr/0KOLTNf7Rx2FmjugQGHLtbu9MXJhdczCo+wb/rCN5b?=
 =?us-ascii?Q?Y6zL1hNI/V7fwQjsn7s5qq2BbP07xVVQJWOkt1fB11azBBot2+37ZkaS49jD?=
 =?us-ascii?Q?L13k8S6rT9yxACh/Ia6JaMV7WGsLrPxZN2FVHT4u4m5tKpVJq9GFyiNGkLdG?=
 =?us-ascii?Q?bsh7j3Viszm3jBvPRjfwOLRamjNJoVXtslZa7znCJ/Y3iNdX9Jx2KdwTYV2q?=
 =?us-ascii?Q?m42sltWtoi0dO88pTonuscO65dIPxaSbRJMdHm6IdTKVRzsHjoNUjVhzgrIV?=
 =?us-ascii?Q?Ddw7xonSCteHQcBGfhy58VGHwfOaNEKCEy6iO4gkUBOjt+Z4mxfyNeyZdaXr?=
 =?us-ascii?Q?uKz/IBUzlMzbq0IShoms3VCOnW/SlrlgTw8v0o+4UF3Wb0EqaLfGHdXflwTf?=
 =?us-ascii?Q?3/iytql97SyUlHOmTn2VemIp+5xJCNicjYCMrlzDXUlkPTz+fawj7ZWch0C6?=
 =?us-ascii?Q?e+4veE5BO6tf0HIYJyp/7zJcEJCAiW47AB+Z8ikpKjuh8xZ58BncJAcN+qhf?=
 =?us-ascii?Q?ZyjTOJcCJC5RFDZYD2xtnDa2i45/tafFaaxGNAolmOf6qa8IlDGHJ3Wqf/Cp?=
 =?us-ascii?Q?3fBySuwMu4+v+3z2+6ZdSoxvl/jDqesd5WlP7tF99DZGsgH7fKFYR4yhLoyE?=
 =?us-ascii?Q?wcQoxhKkIZ4KM5qZRheD8Zl01hOUSWSbEpCkWbaWkxTLINDnDPExBhCO2S6S?=
 =?us-ascii?Q?70iUsoklHXQivmQ/dYEwfQz2vJYNEiuYvePInYaVVvRI9/P9F5X1fG32QSRI?=
 =?us-ascii?Q?C8SkMvJLLp1KdNd/bNVc+gZzzw7Egt2034oSAFo4STtmiSlFNiucelq70X7v?=
 =?us-ascii?Q?0uHsYAFlenEZv2qVVuwb8LPhHgLYJ/TRbKzVkKAkyYD2yvykUOMg6ZRVwQaT?=
 =?us-ascii?Q?iEy9vfeth5PGIwIMojVgw1L+ADVzepUbsbAgqd11riEqoIi3YNSooy1z8Cep?=
 =?us-ascii?Q?7hhOJHJYag=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4606b550-a94f-4713-61a6-08da5360f2a3
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2022 08:35:08.1761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8OdGTkFQkiXMJWEVY5nHDlvEfyvvEmujirzYoXtu9gO25QIP0FDVpeuMCs/byOWTQPbnaF/H06DgC7tfsPuk4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3832
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

The above mentioned function just returns an error in case that
mlxsw_sp_bridge_ports_flood_table_set() fails. That means that the previous
configurations are not cleaned.

Fix it by adding error path to clean the configurations in case of error.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../mellanox/mlxsw/spectrum_switchdev.c         | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 303909bc43c6..127ebd10c16e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -900,6 +900,7 @@ static int mlxsw_sp_port_mc_disabled_set(struct mlxsw_sp_port *mlxsw_sp_port,
 					 struct net_device *orig_dev,
 					 bool mc_disabled)
 {
+	enum mlxsw_sp_flood_type packet_type = MLXSW_SP_FLOOD_TYPE_MC;
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	struct mlxsw_sp_bridge_device *bridge_device;
 	struct mlxsw_sp_bridge_port *bridge_port;
@@ -919,17 +920,29 @@ static int mlxsw_sp_port_mc_disabled_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	mlxsw_sp_bridge_mdb_mc_enable_sync(mlxsw_sp, bridge_device);
 
 	list_for_each_entry(bridge_port, &bridge_device->ports_list, list) {
-		enum mlxsw_sp_flood_type packet_type = MLXSW_SP_FLOOD_TYPE_MC;
 		bool member = mlxsw_sp_mc_flood(bridge_port);
 
 		err = mlxsw_sp_bridge_ports_flood_table_set(bridge_port,
 							    packet_type,
 							    member);
 		if (err)
-			return err;
+			goto err_flood_table_set;
 	}
 
 	return 0;
+
+err_flood_table_set:
+	list_for_each_entry_continue_reverse(bridge_port,
+					     &bridge_device->ports_list, list) {
+		bool member = mlxsw_sp_mc_flood(bridge_port);
+
+		mlxsw_sp_bridge_ports_flood_table_set(bridge_port, packet_type,
+						      !member);
+	}
+
+	bridge_device->multicast_enabled = mc_disabled;
+	mlxsw_sp_bridge_mdb_mc_enable_sync(mlxsw_sp, bridge_device);
+	return err;
 }
 
 static int mlxsw_sp_smid_router_port_set(struct mlxsw_sp *mlxsw_sp,
-- 
2.36.1

