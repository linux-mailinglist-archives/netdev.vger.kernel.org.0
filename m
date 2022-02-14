Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B69684B4D37
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 12:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348940AbiBNKrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 05:47:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348803AbiBNKqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 05:46:55 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2068.outbound.protection.outlook.com [40.107.95.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BAD85651
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 02:09:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fqmOEGCIs/C/Nzm9L4AZFKzbcQVL5NK7Cqhdt4gAqmjCK3zkxUnVbaMAXAxr7hcPsHOsNHHyRwqunE7VPzi1pAaZZ6RaaDxhrcJ7tZQcvWEi+/TqOToRXbFWjSmlympJs5PPlwKmceudRmbCfqlMwBbaT72VbQmmfMWBk3tvJTz02aJhOrOyW9D016j1/0mE5ntfNLfLtHlk2YbYRR2jlrRebpESkUtUkO8Xsp6ECwprv73eNXQbbBk5s/Y8GKJgzf7qIUUu5yBxRWOcqY6OS5fspfZ2B/7VUtD3lmgMmCAXxN4PSLEfR6WX/QntKiLnRV8pfrD0qSmRG4d7ocMk+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xOhiT2C0ikJhDxBC3TJarzE12Q7Os577Y5KqmTOgUA8=;
 b=ao8lmkCIMFWWc2d2iMTStRSRobxLn+Ky2ztivgqZM4fj8LbuZNK3CI1AUqLv/ypqknMI15p0+5phkg6eKo6P4t1MarwGN9xh2vaZT6DomKXvvJZv8jBARRI65IIbLvAu8Gvez4WSRMnbzpBdihtXA0rCXEEaCeh14sLa2KlpxberoSbU0YR/ebV3rzH1EIb0HbPeEzPmB6A+SYGJ+67vWUYNz8Tma9q7b5q30TBZ+AWvYButytVKfQpGfGHBA75sn4klMi/HhtoCfnDdAE2CfZXPLDzkEK0X7ThgQjzE+9r1MC2nKLbdAJWE2l437pkNZh4D0KYjFP55RpG+/wjVkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xOhiT2C0ikJhDxBC3TJarzE12Q7Os577Y5KqmTOgUA8=;
 b=bB/abEPSuQH9KraBA0SV3rQwyxDvWeX37WAnvXUPe/WhYrKrYuGw5NIEoxdRlU6FIlTxp8nkQ7ivpZ2YnI2UYuX/R/O4Dwo3JVCqrN5EIgYS9a/Hy1tkVPGCaedCdRvO10RGXbJFhcYRGmW1hcBHa9wRhrNYV5ycY5DU9Re12JLo7TSDmS+Wh2PWbPF0prOzD6gzDsDj2zBTd2oU8Of19xvzJWMXw8ENfB7eIcFIFR4PxgHS4pgYIAe8Z4zuCpH+DYrtgazpprOesPLvKMW0rkXl6oRkvY+KAMVQcj8G5iyBMaX8W/zasZosFxPH0/x0ek8aZ8L94aP6W+jRo7y5HA==
Received: from DM5PR08CA0036.namprd08.prod.outlook.com (2603:10b6:4:60::25) by
 LV2PR12MB5968.namprd12.prod.outlook.com (2603:10b6:408:14f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4951.18; Mon, 14 Feb 2022 10:09:39 +0000
Received: from DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:60:cafe::3a) by DM5PR08CA0036.outlook.office365.com
 (2603:10b6:4:60::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11 via Frontend
 Transport; Mon, 14 Feb 2022 10:09:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT052.mail.protection.outlook.com (10.13.172.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Mon, 14 Feb 2022 10:09:38 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 14 Feb
 2022 10:09:38 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 14 Feb 2022
 02:09:37 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Mon, 14 Feb
 2022 02:09:35 -0800
From:   Jianbo Liu <jianbol@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <jiri@nvidia.com>, <idosch@nvidia.com>,
        <ozsh@nvidia.com>, <roid@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>
Subject: [PATCH net-next 2/2] flow_offload: reject offload for all drivers with invalid police parameters
Date:   Mon, 14 Feb 2022 10:09:22 +0000
Message-ID: <20220214100922.13004-3-jianbol@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220214100922.13004-1-jianbol@nvidia.com>
References: <20220214100922.13004-1-jianbol@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: abe78919-5d06-4489-3b94-08d9efa21c47
X-MS-TrafficTypeDiagnostic: LV2PR12MB5968:EE_
X-Microsoft-Antispam-PRVS: <LV2PR12MB5968B92C9E8BE1F9D58A1350C5339@LV2PR12MB5968.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tpi1dSwZTmXHCQ5YJjnIly1k/pslaWfZj7G7EXnSnJ1ey789xwQpEEXCr5Q4+/8J3IjD65NGSS28UA+ctpG6CN0+bWnRGc22mF60nJX8nmxEysUMcgE3V5NziSFLl/uHqLgz/Mhl2m2VAPOgDn1DKMrszJBV33Bx7MFPaLu9swR6K6J6vUm+BpUsMZQoy5pe1ojSv02VGTKqhHbJJn/6H3HIQm3PkJo5yeqUWSuBnrwF0HPZwMqklE3YuHdUf20IUhz0sc2XwiS/v0cT1S6Bt7movEetkxlFXP/ojPNYLFtwv/ZmEgrMD5HfJ7sy6E5gv+Jcwe34mTkVJhLuSqN1q/LiivUFO+f/nlXnJGTnurzGDFQs7pWhh3RNiMtG0bs/jeenlTOigBXW1W3lHSk6MjupR6T5Y48js1FEB64EEpu3qKtC49cacLhk7GuJfGSG7NSgV+9HP+zPEHdJ17V7u0MSh1ihB5z1wd7IFUY2NmfbMSM2hTXwcgXjs/lokX2gbAedHCHy1XO6HGVuTOIYWD8fiHwXfSuvmJWGnnMtcp6MBEE2phniMzlBwAaz3ihD8+J995mbplfIcZSo0rnPTHIaZ02qzhiapblFPdC6YRHMsFTGip3pE6B+ZMmh0RdDnTAbVRQz/Lte4IdMuJjPOVy0s9D/7rgj0quhIJMi1c1p50UNQfdy1F2XyYMLBhhvx35iMnvuoKsi9GJUvrDal7HIuyl/QBMpfsBDls+8haGBhfQcsM5lP6xQE7CmXJq1a6yjdLPD35fwDu0L2w6cFA==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(7696005)(82310400004)(5660300002)(356005)(54906003)(86362001)(6916009)(316002)(6666004)(36860700001)(8936002)(508600001)(47076005)(81166007)(40460700003)(83380400001)(70586007)(70206006)(2616005)(186003)(1076003)(26005)(107886003)(8676002)(426003)(2906002)(336012)(36756003)(30864003)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 10:09:38.6556
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: abe78919-5d06-4489-3b94-08d9efa21c47
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5968
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As more police parameters are passed to flow_offload, driver can check
them to make sure hardware handles packets in the way indicated by tc.
The conform-exceed control should be drop/pipe or drop/ok. As hardware
can't configure peakrate/avrate/overhead, offload should not be
supported if any of them is configured.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/dsa/sja1105/sja1105_flower.c      | 15 +++++++++
 .../chelsio/cxgb4/cxgb4_tc_matchall.c         | 31 +++++++++++++++++++
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 17 ++++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_tc.c  | 30 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 15 +++++++++
 .../ethernet/mellanox/mlxsw/spectrum_flower.c | 15 +++++++++
 drivers/net/ethernet/mscc/ocelot_flower.c     | 16 ++++++++++
 drivers/net/ethernet/mscc/ocelot_net.c        | 15 +++++++++
 .../ethernet/netronome/nfp/flower/qos_conf.c  | 16 ++++++++++
 9 files changed, 170 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_flower.c b/drivers/net/dsa/sja1105/sja1105_flower.c
index 7dcdd784aea4..85f4e321a7a2 100644
--- a/drivers/net/dsa/sja1105/sja1105_flower.c
+++ b/drivers/net/dsa/sja1105/sja1105_flower.c
@@ -321,6 +321,21 @@ int sja1105_cls_flower_add(struct dsa_switch *ds, int port,
 	flow_action_for_each(i, act, &rule->action) {
 		switch (act->id) {
 		case FLOW_ACTION_POLICE:
+			if ((act->police.notexceed.act_id != FLOW_ACTION_ACCEPT &&
+			     act->police.notexceed.act_id != FLOW_ACTION_PIPE) ||
+			    act->police.exceed.act_id != FLOW_ACTION_DROP) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Police action is not supported when conform-exceed is not drop/pipe or drop/ok");
+				return -EOPNOTSUPP;
+			}
+
+			if (act->police.peakrate_bytes_ps ||
+			    act->police.avrate || act->police.overhead) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Police action is not supported when peakrate/avrate/overhead is configured");
+				return -EOPNOTSUPP;
+			}
+
 			if (act->police.rate_pkt_ps) {
 				NL_SET_ERR_MSG_MOD(extack,
 						   "QoS offload not support packets per second");
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
index 28fd2de9e4cf..84a785e7a68f 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
@@ -48,6 +48,21 @@ static int cxgb4_matchall_egress_validate(struct net_device *dev,
 	flow_action_for_each(i, entry, actions) {
 		switch (entry->id) {
 		case FLOW_ACTION_POLICE:
+			if ((entry->police.notexceed.act_id != FLOW_ACTION_ACCEPT &&
+			     entry->police.notexceed.act_id != FLOW_ACTION_PIPE) ||
+			    entry->police.exceed.act_id != FLOW_ACTION_DROP) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Police action is not supported when conform-exceed is not drop/pipe or drop/ok");
+				return -EOPNOTSUPP;
+			}
+
+			if (entry->police.peakrate_bytes_ps ||
+			    entry->police.avrate || entry->police.overhead) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Police action is not supported when peakrate/avrate/overhead is configured");
+				return -EOPNOTSUPP;
+			}
+
 			if (entry->police.rate_pkt_ps) {
 				NL_SET_ERR_MSG_MOD(extack,
 						   "QoS offload not support packets per second");
@@ -150,6 +165,22 @@ static int cxgb4_matchall_alloc_tc(struct net_device *dev,
 	flow_action_for_each(i, entry, &cls->rule->action)
 		if (entry->id == FLOW_ACTION_POLICE)
 			break;
+
+	if ((entry->police.notexceed.act_id != FLOW_ACTION_ACCEPT &&
+	     entry->police.notexceed.act_id != FLOW_ACTION_PIPE) ||
+	    entry->police.exceed.act_id != FLOW_ACTION_DROP) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Police action is not supported when conform-exceed is not drop/pipe or drop/ok");
+		return -EOPNOTSUPP;
+	}
+
+	if (entry->police.peakrate_bytes_ps ||
+	    entry->police.avrate || entry->police.overhead) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Police action is not supported when peakrate/avrate/overhead is configured");
+		return -EOPNOTSUPP;
+	}
+
 	if (entry->police.rate_pkt_ps) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "QoS offload not support packets per second");
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 3555c12edb45..183318e7255f 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -1230,6 +1230,23 @@ static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
 
 	/* Flow meter and max frame size */
 	if (entryp) {
+		if ((entryp->police.notexceed.act_id != FLOW_ACTION_ACCEPT &&
+		     entryp->police.notexceed.act_id != FLOW_ACTION_PIPE) ||
+		    entryp->police.exceed.act_id != FLOW_ACTION_DROP) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Police action is not supported when conform-exceed is not drop/pipe or drop/ok");
+			err = -EOPNOTSUPP;
+			goto free_sfi;
+		}
+
+		if (entryp->police.peakrate_bytes_ps ||
+		    entryp->police.avrate || entryp->police.overhead) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Police action is not supported when peakrate/avrate/overhead is configured");
+			err = -EOPNOTSUPP;
+			goto free_sfi;
+		}
+
 		if (entryp->police.rate_pkt_ps) {
 			NL_SET_ERR_MSG_MOD(extack, "QoS offload not support packets per second");
 			err = -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
index 626961a41089..15aa73cd0383 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -212,6 +212,21 @@ static int otx2_tc_egress_matchall_install(struct otx2_nic *nic,
 	entry = &cls->rule->action.entries[0];
 	switch (entry->id) {
 	case FLOW_ACTION_POLICE:
+		if ((entry->police.notexceed.act_id != FLOW_ACTION_ACCEPT &&
+		     entry->police.notexceed.act_id != FLOW_ACTION_PIPE) ||
+		    entry->police.exceed.act_id != FLOW_ACTION_DROP) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Police action is not supported when conform-exceed is not drop/pipe or drop/ok");
+			return -EOPNOTSUPP;
+		}
+
+		if (entry->police.peakrate_bytes_ps ||
+		    entry->police.avrate || entry->police.overhead) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Police action is not supported when peakrate/avrate/overhead is configured");
+			return -EOPNOTSUPP;
+		}
+
 		if (entry->police.rate_pkt_ps) {
 			NL_SET_ERR_MSG_MOD(extack, "QoS offload not support packets per second");
 			return -EOPNOTSUPP;
@@ -355,6 +370,21 @@ static int otx2_tc_parse_actions(struct otx2_nic *nic,
 				return -EOPNOTSUPP;
 			}
 
+			if ((act->police.notexceed.act_id != FLOW_ACTION_ACCEPT &&
+			     act->police.notexceed.act_id != FLOW_ACTION_PIPE) ||
+			    act->police.exceed.act_id != FLOW_ACTION_DROP) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Police action is not supported when conform-exceed is not drop/pipe or drop/ok");
+				return -EOPNOTSUPP;
+			}
+
+			if (act->police.peakrate_bytes_ps ||
+			    act->police.avrate || act->police.overhead) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Police action is not supported when peakrate/avrate/overhead is configured");
+				return -EOPNOTSUPP;
+			}
+
 			if (act->police.rate_bytes_ps > 0) {
 				rate = act->police.rate_bytes_ps * 8;
 				burst = act->police.burst;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 1287193a019b..829b09029cb0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4197,6 +4197,21 @@ static int scan_tc_matchall_fdb_actions(struct mlx5e_priv *priv,
 	flow_action_for_each(i, act, flow_action) {
 		switch (act->id) {
 		case FLOW_ACTION_POLICE:
+			if ((act->police.notexceed.act_id != FLOW_ACTION_ACCEPT &&
+			     act->police.notexceed.act_id != FLOW_ACTION_PIPE) ||
+			    act->police.exceed.act_id != FLOW_ACTION_DROP) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Police action is not supported when conform-exceed is not drop/pipe or drop/ok");
+				return -EOPNOTSUPP;
+			}
+
+			if (act->police.peakrate_bytes_ps ||
+			    act->police.avrate || act->police.overhead) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Police action is not supported when peakrate/avrate/overhead is configured");
+				return -EOPNOTSUPP;
+			}
+
 			if (act->police.rate_pkt_ps) {
 				NL_SET_ERR_MSG_MOD(extack, "QoS offload not support packets per second");
 				return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index bb417db773b9..2de3eed6c637 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -191,6 +191,21 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 				return -EOPNOTSUPP;
 			}
 
+			if ((act->police.notexceed.act_id != FLOW_ACTION_ACCEPT &&
+			     act->police.notexceed.act_id != FLOW_ACTION_PIPE) ||
+			    act->police.exceed.act_id != FLOW_ACTION_DROP) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Police action is not supported when conform-exceed is not drop/pipe or drop/ok");
+				return -EOPNOTSUPP;
+			}
+
+			if (act->police.peakrate_bytes_ps ||
+			    act->police.avrate || act->police.overhead) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Police action is not supported when peakrate/avrate/overhead is configured");
+				return -EOPNOTSUPP;
+			}
+
 			if (act->police.rate_pkt_ps) {
 				NL_SET_ERR_MSG_MOD(extack, "QoS offload not support packets per second");
 				return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 949858891973..e8c0c32b9050 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -296,6 +296,22 @@ static int ocelot_flower_parse_action(struct ocelot *ocelot, int port,
 						   "Last action must be GOTO");
 				return -EOPNOTSUPP;
 			}
+
+			if ((a->police.notexceed.act_id != FLOW_ACTION_ACCEPT &&
+			     a->police.notexceed.act_id != FLOW_ACTION_PIPE) ||
+			    a->police.exceed.act_id != FLOW_ACTION_DROP) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Police action is not supported when conform-exceed is not drop/pipe or drop/ok");
+				return -EOPNOTSUPP;
+			}
+
+			if (a->police.peakrate_bytes_ps ||
+			    a->police.avrate || a->police.overhead) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Police action is not supported when peakrate/avrate/overhead is configured");
+				return -EOPNOTSUPP;
+			}
+
 			if (a->police.rate_pkt_ps) {
 				NL_SET_ERR_MSG_MOD(extack,
 						   "QoS offload not support packets per second");
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index e271b6225b72..afef105b0c3b 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -258,6 +258,21 @@ static int ocelot_setup_tc_cls_matchall(struct ocelot_port_private *priv,
 			return -EEXIST;
 		}
 
+		if ((action->police.notexceed.act_id != FLOW_ACTION_ACCEPT &&
+		     action->police.notexceed.act_id != FLOW_ACTION_PIPE) ||
+		    action->police.exceed.act_id != FLOW_ACTION_DROP) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Police action is not supported when conform-exceed is not drop/pipe or drop/ok");
+			return -EOPNOTSUPP;
+		}
+
+		if (action->police.peakrate_bytes_ps ||
+		    action->police.avrate || action->police.overhead) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Police action is not supported when peakrate/avrate/overhead is configured");
+			return -EOPNOTSUPP;
+		}
+
 		if (action->police.rate_pkt_ps) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "QoS offload not support packets per second");
diff --git a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
index 784c6dbf8bc4..09cfbda6a9ba 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
@@ -132,6 +132,22 @@ nfp_flower_install_rate_limiter(struct nfp_app *app, struct net_device *netdev,
 					   "unsupported offload: qos rate limit offload requires police action");
 			return -EOPNOTSUPP;
 		}
+
+		if ((action->police.notexceed.act_id != FLOW_ACTION_ACCEPT &&
+		     action->police.notexceed.act_id != FLOW_ACTION_PIPE) ||
+		    action->police.exceed.act_id != FLOW_ACTION_DROP) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Police action is not supported when conform-exceed is not drop/pipe or drop/ok");
+			return -EOPNOTSUPP;
+		}
+
+		if (action->police.peakrate_bytes_ps ||
+		    action->police.avrate || action->police.overhead) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Police action is not supported when peakrate/avrate/overhead is configured");
+			return -EOPNOTSUPP;
+		}
+
 		if (action->police.rate_bytes_ps > 0) {
 			if (bps_num++) {
 				NL_SET_ERR_MSG_MOD(extack,
-- 
2.26.2

