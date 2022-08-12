Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEE2F591303
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 17:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237460AbiHLPdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 11:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235144AbiHLPcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 11:32:54 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2049.outbound.protection.outlook.com [40.107.94.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0798284F
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 08:32:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YhDh7zxWtHYPIVSOLQIKIARS/iTh1AjqwVkkigg2VaZz1i6EjJOHQmX4vXrlbHXHR1aAcWN1KClsO2JY51Gu/tSzvDDWuaxrBgZMTJLhJVrFot0SKflzgbdXcQ/qAfdBJ8x7tUvW2FstQ/TfN8ET/SZFr2XZcY5bjYN1+5uwwcw6itaZvZwWmAvX8g7z2/0yNfepScPDDJjlIz/PK99D7fiicU5J3ZHT4JdDj5wZyx01prEB5GwjnSNv+XDj6ZBwN2n3oW+BGl3MPLEfEUsqc5YNv/2AfuYsFKzhXPX3EYPrhiwreiolcHNjPZqgjQj8EQx2z7pZ85nkV3OXbvrEJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h7N8tYJJIAKnbz1RxRQCRvRgEePpEG/s3Ih1NvIjaqM=;
 b=lEmiDOPffB1ZEgjE/+EQmd1KSu6q7ac+T/Kf/GPAwRiyKDmApl5/gWxGCJ0foevxRYHnc9Bky4VLVjZzIVedwU96ODwNe3F+FToFQZxaT3f8IUnD3oUuGEEclSZDAnpgkx2qkIsu2mx3OA34zgCDH7EKFqgErasMvKRmVDz++Q2yHxQqpUcYWEYCotpxJ6jCmnDbAxaI9zpqcP5XUAm8FMnVp04jnrzm6thGzg15IA2Ue1OlhUz2bzaNPbSri3xD8SvMlhPkjzHqCieb55/qN8l0H/fhh/cCBELHWLHwBr455wHVEWKPvGLb/IQcFWjPfxMw4rleTyyDPe6WAyOgKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h7N8tYJJIAKnbz1RxRQCRvRgEePpEG/s3Ih1NvIjaqM=;
 b=mbFY0pFF3N+rzdoJ6ftEso814AMGpNZ6xRZO0LdfQ3IMCFUSgPknbmmNV5kNPO2tb59fzrPPtwMjK37rwpUlOKy0SPBX55erBIPL9fReNihIfBOnMDq6DDYaZBScinrFzWYIoVjNa9A1+HA8ViJUlRr0hQSQV6UBT5wwOBKNwLuoKv6aZlj4XdoxeF1epuD8eCLr1lpEL5j7yjmV4CexsQFZi9XCxCOhdImsWfR63SVK9RUZpFEur2hFafCQcE/lFXCLD36G7lnfuwEYbZUS46Rc/36nmP1k/MuTlExT3lHGIJcOVUDB62I4bkq5xSYd4/rgc/vfrIcVYoVHgJs2Bw==
Received: from MW2PR16CA0035.namprd16.prod.outlook.com (2603:10b6:907::48) by
 PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Fri, 12 Aug
 2022 15:32:51 +0000
Received: from CO1NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:0:cafe::c6) by MW2PR16CA0035.outlook.office365.com
 (2603:10b6:907::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11 via Frontend
 Transport; Fri, 12 Aug 2022 15:32:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT047.mail.protection.outlook.com (10.13.174.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5525.11 via Frontend Transport; Fri, 12 Aug 2022 15:32:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Fri, 12 Aug
 2022 15:32:50 +0000
Received: from yaviefel.vdiclient.nvidia.com (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Fri, 12 Aug 2022 08:32:47 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Petr Machata <petrm@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net 3/4] mlxsw: spectrum_ptp: Protect PTP configuration with a mutex
Date:   Fri, 12 Aug 2022 17:32:02 +0200
Message-ID: <10cd264f32a37620c170c7b0543a09f65174a3a4.1660315448.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: c47c9326-9d9b-475d-ebef-08da7c77eae3
X-MS-TrafficTypeDiagnostic: PH7PR12MB6588:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mBEPm9S+lXJsAmDNJCb/0Zl2P8qbejavH6mHIeFYsiIrK5jSWUfHwhdbtpemrEIh+jvnEnQiaXPjoIayv6T9R/QL08G2wNY6DrvvtGVOyaLnzVzzwKvc5XjCf5z/5dhPZWyonBfdft3TJQfdG/a6r8GVgXbcPHwIf9xTImIMmx+8frEr5ONtobPn6O8stjFNQqYzXFZ2Cv5bHqpFAYqJp/fO5apYvA5HTMsqEEzalIb0eiyEgoq22UhKIni1ubfIwGzXlFPphxMFGtmQ8LaKBuqnqUczgSf45Al1a3OhkXUNiFcsq47SZdZdKQ07CfBLla7Po5L3g1gKyVLDw/GTOZx/YiwP2e3J2Y52nfJHUUMup+cJdNyt4DlNvrN9ZuuLNStox+/RKdyYqjRmtK5RyUXvKxIDRFN2+FJ4JxIMbHfxAiwr913J7r9mdQSPFJaWkWbB7iTrmnfl63Uw4VsGan3hIzxihxJ3jrHIVbs4V3DW1VEv5ZfQIs3gqTm8y9OPIk+dV/oiu/RP4DKMxTlOrZcVBTH4uffmyz+9pQtlOW4KKx7qf2yThVLrFddCuVsBlNb079hLq6E6r+eswbqwC4IVi8FvGA7qG13bDuJycd5qosCEVBmQwVkNXrq36u0gjLjwBF87dDA8di001EQPgw/eXAarz52sjjJ5/oEz3P8XJCdjMTtGV1ljcmmCfvEoIjoIOvnd7IKQW302byIh7QkLQQLQCfKKqr58vzuzLVaPIKA2w5+DXX+Lu97PTLHhfTmW8MuIHxJzIYFH3gvOT047lKb9LVwf6jpFpOuAZEzDcVB2vBerbkeEVEKvyLAUF5vhP5DJjM42jiBnNtj+XQ==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(39860400002)(136003)(346002)(46966006)(36840700001)(40470700004)(40460700003)(356005)(2906002)(8936002)(5660300002)(26005)(40480700001)(81166007)(86362001)(82310400005)(47076005)(2616005)(186003)(336012)(16526019)(426003)(6666004)(7696005)(41300700001)(36860700001)(107886003)(83380400001)(478600001)(316002)(4326008)(8676002)(82740400003)(70586007)(54906003)(70206006)(110136005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2022 15:32:50.8698
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c47c9326-9d9b-475d-ebef-08da7c77eae3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6588
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

Currently the functions mlxsw_sp2_ptp_{configure, deconfigure}_port()
assume that they are called when RTNL is locked and they warn otherwise.

The deconfigure function can be called when port is removed, for example
as part of device reload, then there is no locked RTNL and the function
warns [1].

To avoid such case, do not assume that RTNL protects this code, add a
dedicated mutex instead. The mutex protects 'ptp_state->config' which
stores the existing global configuration in hardware. Use this mutex also
to protect the code which configures the hardware. Then, there will be
only one configuration in any time, which will be updated in 'ptp_state'
and a race will be avoided.

[1]:
RTNL: assertion failed at drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c (1600)
WARNING: CPU: 1 PID: 1583493 at drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c:1600 mlxsw_sp2_ptp_hwtstamp_set+0x2d3/0x300 [mlxsw_spectrum]
[...]
CPU: 1 PID: 1583493 Comm: devlink Not tainted5.19.0-rc8-custom-127022-gb371dffda095 #789
Hardware name: Mellanox Technologies Ltd.MSN3420/VMOD0005, BIOS 5.11 01/06/2019
RIP: 0010:mlxsw_sp2_ptp_hwtstamp_set+0x2d3/0x300[mlxsw_spectrum]
[...]
Call Trace:
 <TASK>
 mlxsw_sp_port_remove+0x7e/0x190 [mlxsw_spectrum]
 mlxsw_sp_fini+0xd1/0x270 [mlxsw_spectrum]
 mlxsw_core_bus_device_unregister+0x55/0x280 [mlxsw_core]
 mlxsw_devlink_core_bus_device_reload_down+0x1c/0x30[mlxsw_core]
 devlink_reload+0x1ee/0x230
 devlink_nl_cmd_reload+0x4de/0x580
 genl_family_rcv_msg_doit+0xdc/0x140
 genl_rcv_msg+0xd7/0x1d0
 netlink_rcv_skb+0x49/0xf0
 genl_rcv+0x1f/0x30
 netlink_unicast+0x22f/0x350
 netlink_sendmsg+0x208/0x440
 __sys_sendto+0xf0/0x140
 __x64_sys_sendto+0x1b/0x20
 do_syscall_64+0x35/0x80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: 08ef8bc825d96 ("mlxsw: spectrum_ptp: Support SIOCGHWTSTAMP, SIOCSHWTSTAMP ioctls")
Reported-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    | 27 ++++++++++++++-----
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index 2e0b704b8a31..f32c83603b84 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -46,6 +46,7 @@ struct mlxsw_sp2_ptp_state {
 					  * enabled.
 					  */
 	struct hwtstamp_config config;
+	struct mutex lock; /* Protects 'config' and HW configuration. */
 };
 
 struct mlxsw_sp1_ptp_key {
@@ -1374,6 +1375,7 @@ struct mlxsw_sp_ptp_state *mlxsw_sp2_ptp_init(struct mlxsw_sp *mlxsw_sp)
 		goto err_ptp_traps_set;
 
 	refcount_set(&ptp_state->ptp_port_enabled_ref, 0);
+	mutex_init(&ptp_state->lock);
 	return &ptp_state->common;
 
 err_ptp_traps_set:
@@ -1388,6 +1390,7 @@ void mlxsw_sp2_ptp_fini(struct mlxsw_sp_ptp_state *ptp_state_common)
 
 	ptp_state = mlxsw_sp2_ptp_state(mlxsw_sp);
 
+	mutex_destroy(&ptp_state->lock);
 	mlxsw_sp_ptp_traps_unset(mlxsw_sp);
 	kfree(ptp_state);
 }
@@ -1461,7 +1464,10 @@ int mlxsw_sp2_ptp_hwtstamp_get(struct mlxsw_sp_port *mlxsw_sp_port,
 
 	ptp_state = mlxsw_sp2_ptp_state(mlxsw_sp_port->mlxsw_sp);
 
+	mutex_lock(&ptp_state->lock);
 	*config = ptp_state->config;
+	mutex_unlock(&ptp_state->lock);
+
 	return 0;
 }
 
@@ -1574,8 +1580,6 @@ static int mlxsw_sp2_ptp_configure_port(struct mlxsw_sp_port *mlxsw_sp_port,
 	struct mlxsw_sp2_ptp_state *ptp_state;
 	int err;
 
-	ASSERT_RTNL();
-
 	ptp_state = mlxsw_sp2_ptp_state(mlxsw_sp_port->mlxsw_sp);
 
 	if (refcount_inc_not_zero(&ptp_state->ptp_port_enabled_ref))
@@ -1597,8 +1601,6 @@ static int mlxsw_sp2_ptp_deconfigure_port(struct mlxsw_sp_port *mlxsw_sp_port,
 	struct mlxsw_sp2_ptp_state *ptp_state;
 	int err;
 
-	ASSERT_RTNL();
-
 	ptp_state = mlxsw_sp2_ptp_state(mlxsw_sp_port->mlxsw_sp);
 
 	if (!refcount_dec_and_test(&ptp_state->ptp_port_enabled_ref))
@@ -1618,16 +1620,20 @@ static int mlxsw_sp2_ptp_deconfigure_port(struct mlxsw_sp_port *mlxsw_sp_port,
 int mlxsw_sp2_ptp_hwtstamp_set(struct mlxsw_sp_port *mlxsw_sp_port,
 			       struct hwtstamp_config *config)
 {
+	struct mlxsw_sp2_ptp_state *ptp_state;
 	enum hwtstamp_rx_filters rx_filter;
 	struct hwtstamp_config new_config;
 	u16 new_ing_types, new_egr_types;
 	bool ptp_enabled;
 	int err;
 
+	ptp_state = mlxsw_sp2_ptp_state(mlxsw_sp_port->mlxsw_sp);
+	mutex_lock(&ptp_state->lock);
+
 	err = mlxsw_sp2_ptp_get_message_types(config, &new_ing_types,
 					      &new_egr_types, &rx_filter);
 	if (err)
-		return err;
+		goto err_get_message_types;
 
 	new_config.flags = config->flags;
 	new_config.tx_type = config->tx_type;
@@ -1640,11 +1646,11 @@ int mlxsw_sp2_ptp_hwtstamp_set(struct mlxsw_sp_port *mlxsw_sp_port,
 		err = mlxsw_sp2_ptp_configure_port(mlxsw_sp_port, new_ing_types,
 						   new_egr_types, new_config);
 		if (err)
-			return err;
+			goto err_configure_port;
 	} else if (!new_ing_types && !new_egr_types && ptp_enabled) {
 		err = mlxsw_sp2_ptp_deconfigure_port(mlxsw_sp_port, new_config);
 		if (err)
-			return err;
+			goto err_deconfigure_port;
 	}
 
 	mlxsw_sp_port->ptp.ing_types = new_ing_types;
@@ -1652,8 +1658,15 @@ int mlxsw_sp2_ptp_hwtstamp_set(struct mlxsw_sp_port *mlxsw_sp_port,
 
 	/* Notify the ioctl caller what we are actually timestamping. */
 	config->rx_filter = rx_filter;
+	mutex_unlock(&ptp_state->lock);
 
 	return 0;
+
+err_deconfigure_port:
+err_configure_port:
+err_get_message_types:
+	mutex_unlock(&ptp_state->lock);
+	return err;
 }
 
 int mlxsw_sp2_ptp_get_ts_info(struct mlxsw_sp *mlxsw_sp,
-- 
2.35.3

