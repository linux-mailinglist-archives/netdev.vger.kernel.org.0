Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02AC1552D13
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 10:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348240AbiFUIfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 04:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348226AbiFUIfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 04:35:04 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2045.outbound.protection.outlook.com [40.107.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40DA624BF7
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 01:35:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O1/aBeswiBeJlYuEfl8qyCaGRZnF+iepUMo3+VjVEHJeDpcfbDg4cgDV8pgGdqBd/eF2SS63s7l21nILauoeSrMFuOuVaKt/UsCYuYjvqCSmQkAIXWiURnuB7t2tHJMTdlN71jIJiAQjT/SN6nmgH0dkVsMIwQz5qTxnqVuWdwFiReKjCxMLOUUVY6ppZPiZ6trnNLv6/kRm7gLA7xCqqKvc83OT2OkXZFgziQdWLXJtPBLqn50EbKiWJ/QdIlufkSUu3aVmB+zVHW0NdIIPUdLyjvgtoMpnF2V08dF4Ce2qqoPvgC/JA+1p21NxUkvMgj1wWFuKYj+2eJacSy0kSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bEckZkBbmoMHU5uQWxCyGdNAlLRi9r47OC6lvQMM2/M=;
 b=did7Xn3KH8CMZpLztnSdgsgg1dWVUdRDM4iPwuRVjWRuKCezBdWI4j3C1DXiHriqZ7p7T8JoPBUnZZgLj4b0i9aKaAVqvnPTyVSL6kHPqieKZkdOEQhtbGVxedez/IKN9ULk35SVSdZQ+oEulc63HIT/VCw7l7Tgky+xvJWrl7ZuB9DlLD2HFU+JA8SQ2hk7KTRTzcc4chcUAR1kaoyehjBLSxJPEdMhhD7bMfWWCyUlJ0bkRhc/GKItTNoEkfl6I7dExUBiE3RdD/4BWCOyVBWTOtHXHUii4lB91mjqe9ndsW9wE5FfT+hGBz5qV7OLIKrflm5jU24+963BKUZ6xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bEckZkBbmoMHU5uQWxCyGdNAlLRi9r47OC6lvQMM2/M=;
 b=tXYQMRxnJfjmrC7ZQAMbcCgX1wVLgadoq3MtmKzIbmBZkcAWfCLl92r2k89cAF2Z1FusAQic5xOMuud0LYs0kb5h8MiLqwoWFRMIriQd9L9qdyyklEFzu7OSfDJtIaNkRbhEPCIw9qzy2MTStS8M8YEzCTzVqhWdigLlIPhjpGWLA9U8rA0W4aK6vIVmTxT7QjMg7O5C8hTOkfgD1+rnsiQz0XwIBfjLE33B4ZzUiceDUWEt53WvPF3IAun0W/eBjUwc8cdHYUJprQHv5JtoHhhJ4bju7Qjo+BC6AYXizdKXXhNswEMeB4SN2xplEYJS2iHrwra6BRvmWsG3f6oH5Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH2PR12MB3832.namprd12.prod.outlook.com (2603:10b6:610:24::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Tue, 21 Jun
 2022 08:35:01 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Tue, 21 Jun 2022
 08:35:01 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 04/13] mlxsw: spectrum_switchdev: Simplify mlxsw_sp_port_mc_disabled_set()
Date:   Tue, 21 Jun 2022 11:33:36 +0300
Message-Id: <20220621083345.157664-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220621083345.157664-1-idosch@nvidia.com>
References: <20220621083345.157664-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0034.eurprd05.prod.outlook.com
 (2603:10a6:800:60::20) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a6ff31a1-13d6-4763-2f36-08da5360eeb3
X-MS-TrafficTypeDiagnostic: CH2PR12MB3832:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB383272BCD13996C03575D5E5B2B39@CH2PR12MB3832.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gjb4odtufT5o+a9mYXBOhdvM5wtErTKXTgDVCsi6YSW6qQ6yudK9wSSBdQf+hNZOi+WQrMbcHgpkms2F+uOVaCOZv1l/ejoitOS+36y36flTUqal28kp2+7/s3dJJLTrSiAom7AnGJVXd5Cb7ZtOduwm46D/4ByCRBAUaH/vtxdJ1AOsXTZuaH1wcUqfbZCjZF1zdlzv6MTT7lNu0e2n9b0xinftLU6LtRj7+70/n2ehkEPBTYonK8j+sb7LOWsS/12drxfJIk7sKw4BqWFodGOlIx7RlrIYYwt9c+2DbbHCGO/Mn6nTfX9yL0DJvp63XxlhnV4/UDechArsP2s5VENgI9+wVrSbLKF2mqQtITqafO51WtvFhONhYxMsRgEFqgvHFD2BkPsGkju/6i+lYhGd/OaGOoLvpQRmf+7dJUcGRfVCys9oAj4gi1xtyN2jp8H42NEs4IAxSmYdAKwLWdQX4ZK0DkySihp5MIYrB+uTcpkXJqsAXXSNHv18dMhHXLS+szS53BTWSowW9p4CEYSdzWIEnozpxvdUaVBuZvhMITY2+5gOgo2Oeu9VjXzU5O/Q3RUuh9G28AhcBsztRFnqFnS9WK/MJAhfSsjqJMTW4BEP19qpMc7T0kxUgOXZqGxPMqyE+KgZpNbMbEGgLw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(396003)(366004)(136003)(2616005)(1076003)(38100700002)(186003)(107886003)(41300700001)(36756003)(66946007)(316002)(8676002)(6916009)(66556008)(83380400001)(66476007)(4326008)(8936002)(478600001)(6512007)(86362001)(26005)(6506007)(6486002)(5660300002)(2906002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NbSWQ8GNWgpLKymVQzc/g+J6uw+D4BzH/CYnmXgqGESm+ENwh/91wwoR/GU+?=
 =?us-ascii?Q?tqJk3hppSXd3G3zmjPB/UvjD3HMMqeAQCjFRp+9iW5HILMUO5vZbpLsB33yY?=
 =?us-ascii?Q?cLZ1f/NMpEXqZxxtdE8F9A9q/GlSkxS8i7IlaA6/ajD33JErbryExEbtb61C?=
 =?us-ascii?Q?URTyKZuJZeE56HrnkcGlLsh3PN6VLGA8A4mEI2feoEnuaklLHjRE6c8jBRkg?=
 =?us-ascii?Q?21VYb8tb/yiEtokHgdZCINV6MWbdQbeavCmxuz2S5so6QA1dhTbX96QNSGnp?=
 =?us-ascii?Q?4+29/AVbXGFbE2fZiQF5AL1t4MowekhB2fKl25pQDl22hcOMEv1lnE8hM3Mj?=
 =?us-ascii?Q?73KTq1OEI7y/+4QPjBEJF4bD++hABhK66EmpYH1ohgerxwxGR154N6jn2Kar?=
 =?us-ascii?Q?43Spm/Kn4M1kodg0ZOcc5C0+ruyIpCmmCFNY4eialiqOYpvPuETEdZc4CjLY?=
 =?us-ascii?Q?b1PNJEiuapbwaJNSrS292eYDDMIl/BQF58dKXMalnM4xFR313sUVfE2POGI0?=
 =?us-ascii?Q?M82uI3yCj+2LK+zKKDIkBRYfwUitSjB5K79zsFmfLHXEPm/ygxMMV64m6aNy?=
 =?us-ascii?Q?WpFzi2qYLfdWWTLVrNRtNoRo5x5+s6qUDQk7nuqumpxfSe0nnfNmLd2yjt12?=
 =?us-ascii?Q?W4vO4VMAJ6LagnlSUVP8+hxPFI7+E7gqO9OkbWFO5Py7v6+mx0Yf2LMX+Xnz?=
 =?us-ascii?Q?mRDw05oskpL79Y3ewV8rU1wnKBlGcUjKwWouONW1R/6+AYz/XGe3fdjcIYcG?=
 =?us-ascii?Q?WWA6TkmuieKnjJ0sAIQ9O2/p8ydj6KEjFTlW3PXRzil6rjIeAsnLyM1cROSO?=
 =?us-ascii?Q?vaHiS6OvPl3oWqem0mwwEZQFseI8AjuA792o8k35AGvXvTN3Wc1r1yXDoeHy?=
 =?us-ascii?Q?p7RXKGMoGTd3VdopY2Wup5Pt4PPGHzS8kR0CKSR93bEgHAKEMXAUEoSbHXxz?=
 =?us-ascii?Q?xiUdVi7IA1ZKQsS2LdMcmhhwy/vje46pfqZnFR6e3NL6rmrVxHVwc2tY3GnT?=
 =?us-ascii?Q?Tk3DfLTXv2nkJo06cOqTTTdCxVPOs0Yi4aL4Jp8hWLyTZARXIca3Z7Q6h6GC?=
 =?us-ascii?Q?DRR6njGnKproLkPsaw/ipiTxdnMKpdi4B1Er0ydRg7COEFAU6zny/xpMfDvY?=
 =?us-ascii?Q?4+vivGMKuyhQn9GuTET+Na5t+IqApEPSM2PNAM9kOVZxAGQ6jMlhaikgmZ4k?=
 =?us-ascii?Q?NNr7Bk7VcMqjGow+N4OJ3Nwdc+JWxG3Vhabre/Nwg1TSCzAWRCwVZG9c8fix?=
 =?us-ascii?Q?1zDm+GLkELcDQYgVPIA+3MlFO+9q+HQW9Hj2xjJrEvdCVvo05V9LC8p7QzU9?=
 =?us-ascii?Q?jfU3ocyjunir86jNUwG/q2JD6Jn3LpKwyttAPaDqljRTekhVaLtYxGnPFZmS?=
 =?us-ascii?Q?qDeG8Ke8Ezo0ZXg22Caxr8qfQKe+83pUrgBy8zryUVZZIW7DsukJD7AaQzIM?=
 =?us-ascii?Q?YzfNKoXkn9kr4Vt9rcks5j9Ae7EX0Bnwn/fPgpTqFQdK5LAsDKh4oJv1GE1j?=
 =?us-ascii?Q?fPdFOURNAEdgv2E8xXaaqRBMBLVWu1scNnrVDg86Cc7O3BM4P4SmGlTWLfRn?=
 =?us-ascii?Q?iBpngEfBPrL1R1f3LHFxlsIYfBGa9wOrbF47jytfhuR0mpK5acEZTDO7xFEC?=
 =?us-ascii?Q?orYGybOV+6qeaW4KZ2wrvL9HkyN5JAk2lG4XT3ZTX5DY6vnbNxJsagKO9OrA?=
 =?us-ascii?Q?z3fO6Y0HRCvbn3eo+sRhJf58Od8fFQYpobo6arv1a+Ah9ODOTjbtCH4xcfbJ?=
 =?us-ascii?Q?XHTtiUt3mA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6ff31a1-13d6-4763-2f36-08da5360eeb3
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2022 08:35:01.5376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Mk7gBIlOucELfyEx7W03yT24rMO6pVMlgmDsfMlaC6AZJbDm67Bi8aCuNHHwWBmGa3B6HkAIereCSzH6DbOXw==
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

The above mentioned function is called for each port in bridge when the
multicast behavior is changed. Currently, it updates all the relevant
MID entries only for the first call, but the update of flooding per port
is done only for the port that it was called for it.

To simplify this behavior, it is possible to handle flooding for all the
ports in the first call, then, the other calls will do nothing. For
that, new functions are required to set flooding for all ports, no
'struct mlxsw_sp_port' is required.

This issue was found while extending this function for unified bridge
model, the above mentioned change will ease the extending later.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../mellanox/mlxsw/spectrum_switchdev.c       | 73 +++++++++++++++++--
 1 file changed, 66 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 85757d79cb27..303909bc43c6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -642,6 +642,64 @@ mlxsw_sp_bridge_port_flood_table_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	return err;
 }
 
+static int
+mlxsw_sp_bridge_vlans_flood_set(struct mlxsw_sp_bridge_vlan *bridge_vlan,
+				enum mlxsw_sp_flood_type packet_type,
+				bool member)
+{
+	struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan;
+	int err;
+
+	list_for_each_entry(mlxsw_sp_port_vlan, &bridge_vlan->port_vlan_list,
+			    bridge_vlan_node) {
+		u16 local_port = mlxsw_sp_port_vlan->mlxsw_sp_port->local_port;
+
+		err = mlxsw_sp_fid_flood_set(mlxsw_sp_port_vlan->fid,
+					     packet_type, local_port, member);
+		if (err)
+			goto err_fid_flood_set;
+	}
+
+	return 0;
+
+err_fid_flood_set:
+	list_for_each_entry_continue_reverse(mlxsw_sp_port_vlan,
+					     &bridge_vlan->port_vlan_list,
+					     list) {
+		u16 local_port = mlxsw_sp_port_vlan->mlxsw_sp_port->local_port;
+
+		mlxsw_sp_fid_flood_set(mlxsw_sp_port_vlan->fid, packet_type,
+				       local_port, !member);
+	}
+
+	return err;
+}
+
+static int
+mlxsw_sp_bridge_ports_flood_table_set(struct mlxsw_sp_bridge_port *bridge_port,
+				      enum mlxsw_sp_flood_type packet_type,
+				      bool member)
+{
+	struct mlxsw_sp_bridge_vlan *bridge_vlan;
+	int err;
+
+	list_for_each_entry(bridge_vlan, &bridge_port->vlans_list, list) {
+		err = mlxsw_sp_bridge_vlans_flood_set(bridge_vlan, packet_type,
+						      member);
+		if (err)
+			goto err_bridge_vlans_flood_set;
+	}
+
+	return 0;
+
+err_bridge_vlans_flood_set:
+	list_for_each_entry_continue_reverse(bridge_vlan,
+					     &bridge_port->vlans_list, list)
+		mlxsw_sp_bridge_vlans_flood_set(bridge_vlan, packet_type,
+						!member);
+	return err;
+}
+
 static int
 mlxsw_sp_port_bridge_vlan_learning_set(struct mlxsw_sp_port *mlxsw_sp_port,
 				       struct mlxsw_sp_bridge_vlan *bridge_vlan,
@@ -854,18 +912,19 @@ static int mlxsw_sp_port_mc_disabled_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	if (!bridge_device)
 		return 0;
 
-	if (bridge_device->multicast_enabled != !mc_disabled) {
-		bridge_device->multicast_enabled = !mc_disabled;
-		mlxsw_sp_bridge_mdb_mc_enable_sync(mlxsw_sp, bridge_device);
-	}
+	if (bridge_device->multicast_enabled == !mc_disabled)
+		return 0;
+
+	bridge_device->multicast_enabled = !mc_disabled;
+	mlxsw_sp_bridge_mdb_mc_enable_sync(mlxsw_sp, bridge_device);
 
 	list_for_each_entry(bridge_port, &bridge_device->ports_list, list) {
 		enum mlxsw_sp_flood_type packet_type = MLXSW_SP_FLOOD_TYPE_MC;
 		bool member = mlxsw_sp_mc_flood(bridge_port);
 
-		err = mlxsw_sp_bridge_port_flood_table_set(mlxsw_sp_port,
-							   bridge_port,
-							   packet_type, member);
+		err = mlxsw_sp_bridge_ports_flood_table_set(bridge_port,
+							    packet_type,
+							    member);
 		if (err)
 			return err;
 	}
-- 
2.36.1

