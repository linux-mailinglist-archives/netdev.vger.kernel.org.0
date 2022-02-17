Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1047E4B9AEC
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 09:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237637AbiBQI3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 03:29:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237619AbiBQI3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 03:29:10 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2060.outbound.protection.outlook.com [40.107.101.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED071F6B87;
        Thu, 17 Feb 2022 00:28:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ivSIg79TIUUMzoOBoJ5nMMjKL0goPc+Hk8Z4xmdKYehugp7y+pyanNDUFdo1MRbrCKiH1dkSU/Ng2XjHap48+VKXC2MCUgwHxha7SG1PJKzcCx/2DjxyWMtj1jWojGAJ4mBDkGCL8ZpS9nUuVQoGbn7Gh4P6VV7zxuuO8C9HwRJHZEwhUd6ex8d5zqE0O4l+BYeFx0M4iKkr0eYtGcOdaDJMcNpJAlMjk6xtH0VBB42u25a8KnKkF5cuc13Mb5JEsIjEUsQkbLBx39F6ZN6SWf/exRzp4OWRgvKpIX5PBGhdf8fAVj9P7TiwDW5sKqj+a1MbnHR4cPYBbXMAVlbT9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ux2Ia79m26kFUYlgvVAqxiuSpqJEw4Qu3Iylh38fySg=;
 b=ExviPjBqId8XLfekR9SxXpTD/KmhjE6YQvWxJM/jqIbUwT77tm/1IAZSg66x+gc0T+HDK40Nvdm5g8lCvIklEzHAZ3i1+ngEZlb/E5vliS6JHMnUPZmHU/kiT+Nr9IoUxVtQ1qvuCGgik8RoXJ8labNL85i7mMcSbTYBRY27J4geJuuv3DQvnZF9UGOQI8X140dz+/Ng25LMuM0VpztoRvDGE/Tan5Trf0fqEZyAgh6ggsazfQ2ie7Zban2OW2B4049oPoLe5ebpptVxdk2lHPeoak7sFMITvicz6/kUqdoslVemgc1qKLNlabOdT9KSDB8+C08LT4EIqqkZjBCUNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=chelsio.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ux2Ia79m26kFUYlgvVAqxiuSpqJEw4Qu3Iylh38fySg=;
 b=FWSCCnUHiLNq+MCZm9r5NrV4MTkyFARq4STikzeR2wDGXjBQh5qIEFsfrAhcGwhbTMz6m3RhBrX8Srtj5TqK4LJeDzWofiAfyqBFf4qRJpv+qvyLpYF+/TswpqNFOU/Xmd1wqgczrT2gGmZCPXsH9QWMuBihJqosiftQLksQ8U6Ap2DG2t+ZeFmhFP2v+4h41ZprVyV7+ehMkd+ojs23mFi9KdWKxBuM9lJLWcv3XqUGpx0V5pAuLpk6jiDz72eUSeAn2kwHyEzdhJMmEpE45jLBBuQnhC7b0s3F2hyqeadVmOSWrfoWNNbvfIbBmp6MKw/d/5x3cVnLAmCgssxdRA==
Received: from BN8PR15CA0069.namprd15.prod.outlook.com (2603:10b6:408:80::46)
 by MW3PR12MB4459.namprd12.prod.outlook.com (2603:10b6:303:56::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Thu, 17 Feb
 2022 08:28:53 +0000
Received: from BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:80:cafe::b2) by BN8PR15CA0069.outlook.office365.com
 (2603:10b6:408:80::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19 via Frontend
 Transport; Thu, 17 Feb 2022 08:28:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT013.mail.protection.outlook.com (10.13.176.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Thu, 17 Feb 2022 08:28:52 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 17 Feb
 2022 08:28:40 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 17 Feb 2022
 00:28:39 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Thu, 17 Feb
 2022 00:28:32 -0800
From:   Jianbo Liu <jianbol@nvidia.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>
CC:     <olteanv@gmail.com>, <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <rajur@chelsio.com>, <claudiu.manoil@nxp.com>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <saeedm@nvidia.com>,
        <leon@kernel.org>, <idosch@nvidia.com>, <petrm@nvidia.com>,
        <alexandre.belloni@bootlin.com>, <UNGLinuxDriver@microchip.com>,
        <simon.horman@corigine.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <baowen.zheng@corigine.com>, <louis.peens@netronome.com>,
        <peng.zhang@corigine.com>, <oss-drivers@corigine.com>,
        <roid@nvidia.com>, Jianbo Liu <jianbol@nvidia.com>
Subject: [PATCH net-next v2 2/2] flow_offload: reject offload for all drivers with invalid police parameters
Date:   Thu, 17 Feb 2022 08:28:03 +0000
Message-ID: <20220217082803.3881-3-jianbol@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220217082803.3881-1-jianbol@nvidia.com>
References: <20220217082803.3881-1-jianbol@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bbf08d23-82d8-41e7-0189-08d9f1ef87ac
X-MS-TrafficTypeDiagnostic: MW3PR12MB4459:EE_
X-Microsoft-Antispam-PRVS: <MW3PR12MB4459E2EC3996CABF8E49D749C5369@MW3PR12MB4459.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7r2Y2OMe7CpBoKsW1xhxlnbGfWqKIzBL9KT16UfSy9uPRGgvrJ/RsCbB5bWb+Td46FCPfxITAFCPWt/2MUdzIjsHCzpfDLrBsfirO/p9HXE9pTJGg04CnsGmNyjqYwfT+MNi6kwIm0Wc+pQ9nIcZX5trOdGrJp81I+uGOCOf2f42qDUAkXCtPWulL9inoxCJ0snCF1HVCnVKerksbt1w4kY4Zv6CV0OJ2OuLNRO+m0vJgI7NCJhRA6/LneZxTxoJTUFkYj1REeVvuZdWkFnSdYVF2QTZZDrS1m5wOms2iRDFk8gU+4tp77Q4Jb6V1MbQLlDheuAlnqWQh34nTc1ibMooLjHOEbb/hWlBn0gPzF23gysPsuLYPoerGD3fvDogjRYJpU91yea0gahvgmp7e+RHJJcFoaR2q0EjAjbZwzWydcYG1fqjCdoyAC8Lo2EhKcfXmC1td9OT1yU1xOa3gZHd11ki+c4YdzhJ8czYnd2MyZjFhUW1YiTOrc6sN4wK1l+9e8GJCo/XkLDfB7GEPbSbwGAKJaO2w+cYqM9sQrpqr8exfKv/W38y9yS3iWXEmHr8YWZ46ocL2T4yuYjCErl0BG7/ZxGcsnzVOpCdcxxB1ClX7VcNVxOGe73CoZiUVfiWSFWd6dEX4oVlWmRG/HXtJcpCwX/G4FxbCTGGALCzfJIagHECwFSczfXoF1kfp8fyYa1Qo8yo/0NCiAaRBA==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(36860700001)(2906002)(70206006)(8936002)(2616005)(8676002)(70586007)(86362001)(81166007)(4326008)(30864003)(36756003)(426003)(508600001)(83380400001)(6666004)(40460700003)(356005)(47076005)(107886003)(5660300002)(7696005)(82310400004)(1076003)(54906003)(110136005)(26005)(336012)(7416002)(186003)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 08:28:52.3435
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bbf08d23-82d8-41e7-0189-08d9f1ef87ac
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4459
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
The conform-exceed control should be drop/pipe or drop/ok. Besides,
for drop/ok, the police should be the last action. As hardware can't
configure peakrate/avrate/overhead, offload should not be supported if
any of them is configured.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/dsa/sja1105/sja1105_flower.c      | 27 +++++++++
 .../chelsio/cxgb4/cxgb4_tc_matchall.c         | 55 +++++++++++++++++++
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 31 +++++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_tc.c  | 54 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 27 +++++++++
 .../ethernet/mellanox/mlxsw/spectrum_flower.c | 27 +++++++++
 drivers/net/ethernet/mscc/ocelot_flower.c     | 28 ++++++++++
 drivers/net/ethernet/mscc/ocelot_net.c        | 27 +++++++++
 .../ethernet/netronome/nfp/flower/qos_conf.c  | 28 ++++++++++
 include/net/flow_offload.h                    |  6 ++
 10 files changed, 310 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_flower.c b/drivers/net/dsa/sja1105/sja1105_flower.c
index 7dcdd784aea4..8a14df8cf91e 100644
--- a/drivers/net/dsa/sja1105/sja1105_flower.c
+++ b/drivers/net/dsa/sja1105/sja1105_flower.c
@@ -321,6 +321,33 @@ int sja1105_cls_flower_add(struct dsa_switch *ds, int port,
 	flow_action_for_each(i, act, &rule->action) {
 		switch (act->id) {
 		case FLOW_ACTION_POLICE:
+			if (act->police.exceed.act_id != FLOW_ACTION_DROP) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Police offload is not supported when the exceed action is not drop");
+				return -EOPNOTSUPP;
+			}
+
+			if (act->police.notexceed.act_id != FLOW_ACTION_PIPE &&
+			    act->police.notexceed.act_id != FLOW_ACTION_ACCEPT) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Police offload is not supported when the conform action is not pipe or ok");
+				return -EOPNOTSUPP;
+			}
+
+			if (act->police.notexceed.act_id == FLOW_ACTION_ACCEPT &&
+			    !flow_action_is_last_entry(&rule->action, act)) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Police offload is not supported when the conform action is ok, but police action is not last");
+				return -EOPNOTSUPP;
+			}
+
+			if (act->police.peakrate_bytes_ps ||
+			    act->police.avrate || act->police.overhead) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Police offload is not supported when peakrate/avrate/overhead is configured");
+				return -EOPNOTSUPP;
+			}
+
 			if (act->police.rate_pkt_ps) {
 				NL_SET_ERR_MSG_MOD(extack,
 						   "QoS offload not support packets per second");
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
index 28fd2de9e4cf..124e65116b2d 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
@@ -48,6 +48,33 @@ static int cxgb4_matchall_egress_validate(struct net_device *dev,
 	flow_action_for_each(i, entry, actions) {
 		switch (entry->id) {
 		case FLOW_ACTION_POLICE:
+			if (entry->police.exceed.act_id != FLOW_ACTION_DROP) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Police offload is not supported when the exceed action is not drop");
+				return -EOPNOTSUPP;
+			}
+
+			if (entry->police.notexceed.act_id != FLOW_ACTION_PIPE &&
+			    entry->police.notexceed.act_id != FLOW_ACTION_ACCEPT) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Police offload is not supported when the conform action is not pipe or ok");
+				return -EOPNOTSUPP;
+			}
+
+			if (entry->police.notexceed.act_id == FLOW_ACTION_ACCEPT &&
+			    !flow_action_is_last_entry(actions, entry)) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Police offload is not supported when the conform action is ok, but police action is not last");
+				return -EOPNOTSUPP;
+			}
+
+			if (entry->police.peakrate_bytes_ps ||
+			    entry->police.avrate || entry->police.overhead) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Police offload is not supported when peakrate/avrate/overhead is configured");
+				return -EOPNOTSUPP;
+			}
+
 			if (entry->police.rate_pkt_ps) {
 				NL_SET_ERR_MSG_MOD(extack,
 						   "QoS offload not support packets per second");
@@ -150,6 +177,34 @@ static int cxgb4_matchall_alloc_tc(struct net_device *dev,
 	flow_action_for_each(i, entry, &cls->rule->action)
 		if (entry->id == FLOW_ACTION_POLICE)
 			break;
+
+	if (entry->police.exceed.act_id != FLOW_ACTION_DROP) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Police offload is not supported when the exceed action is not drop");
+		return -EOPNOTSUPP;
+	}
+
+	if (entry->police.notexceed.act_id != FLOW_ACTION_PIPE &&
+	    entry->police.notexceed.act_id != FLOW_ACTION_ACCEPT) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Police offload is not supported when the conform action is not pipe or ok");
+		return -EOPNOTSUPP;
+	}
+
+	if (entry->police.notexceed.act_id == FLOW_ACTION_ACCEPT &&
+	    !flow_action_is_last_entry(&cls->rule->action, entry)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Police offload is not supported when the conform action is ok, but police action is not last");
+		return -EOPNOTSUPP;
+	}
+
+	if (entry->police.peakrate_bytes_ps ||
+	    entry->police.avrate || entry->police.overhead) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Police offload is not supported when peakrate/avrate/overhead is configured");
+		return -EOPNOTSUPP;
+	}
+
 	if (entry->police.rate_pkt_ps) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "QoS offload not support packets per second");
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 3555c12edb45..c992d9e86467 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -1230,6 +1230,37 @@ static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
 
 	/* Flow meter and max frame size */
 	if (entryp) {
+		if (entryp->police.exceed.act_id != FLOW_ACTION_DROP) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Police offload is not supported when the exceed action is not drop");
+			err = -EOPNOTSUPP;
+			goto free_sfi;
+		}
+
+		if (entryp->police.notexceed.act_id != FLOW_ACTION_PIPE &&
+		    entryp->police.notexceed.act_id != FLOW_ACTION_ACCEPT) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Police offload is not supported when the conform action is not pipe or ok");
+			err = -EOPNOTSUPP;
+			goto free_sfi;
+		}
+
+		if (entryp->police.notexceed.act_id == FLOW_ACTION_ACCEPT &&
+		    !flow_action_is_last_entry(&rule->action, entryp)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Police offload is not supported when the conform action is ok, but police action is not last");
+			err = -EOPNOTSUPP;
+			goto free_sfi;
+		}
+
+		if (entryp->police.peakrate_bytes_ps ||
+		    entryp->police.avrate || entryp->police.overhead) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Police offload is not supported when peakrate/avrate/overhead is configured");
+			err = -EOPNOTSUPP;
+			goto free_sfi;
+		}
+
 		if (entryp->police.rate_pkt_ps) {
 			NL_SET_ERR_MSG_MOD(extack, "QoS offload not support packets per second");
 			err = -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
index 626961a41089..4b6e17765b2f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -212,6 +212,33 @@ static int otx2_tc_egress_matchall_install(struct otx2_nic *nic,
 	entry = &cls->rule->action.entries[0];
 	switch (entry->id) {
 	case FLOW_ACTION_POLICE:
+		if (entry->police.exceed.act_id != FLOW_ACTION_DROP) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Police offload is not supported when the exceed action is not drop");
+			return -EOPNOTSUPP;
+		}
+
+		if (entry->police.notexceed.act_id != FLOW_ACTION_PIPE &&
+		    entry->police.notexceed.act_id != FLOW_ACTION_ACCEPT) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Police offload is not supported when the conform action is not pipe or ok");
+			return -EOPNOTSUPP;
+		}
+
+		if (entry->police.notexceed.act_id == FLOW_ACTION_ACCEPT &&
+		    !flow_action_is_last_entry(&cls->rule->action, entry)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Police offload is not supported when the conform action is ok, but police action is not last");
+			return -EOPNOTSUPP;
+		}
+
+		if (entry->police.peakrate_bytes_ps ||
+		    entry->police.avrate || entry->police.overhead) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Police offload is not supported when peakrate/avrate/overhead is configured");
+			return -EOPNOTSUPP;
+		}
+
 		if (entry->police.rate_pkt_ps) {
 			NL_SET_ERR_MSG_MOD(extack, "QoS offload not support packets per second");
 			return -EOPNOTSUPP;
@@ -355,6 +382,33 @@ static int otx2_tc_parse_actions(struct otx2_nic *nic,
 				return -EOPNOTSUPP;
 			}
 
+			if (act->police.exceed.act_id != FLOW_ACTION_DROP) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Police offload is not supported when the exceed action is not drop");
+				return -EOPNOTSUPP;
+			}
+
+			if (act->police.notexceed.act_id != FLOW_ACTION_PIPE &&
+			    act->police.notexceed.act_id != FLOW_ACTION_ACCEPT) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Police offload is not supported when the conform action is not pipe or ok");
+				return -EOPNOTSUPP;
+			}
+
+			if (act->police.notexceed.act_id == FLOW_ACTION_ACCEPT &&
+			    !flow_action_is_last_entry(flow_action, act)) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Police offload is not supported when the conform action is ok, but police action is not last");
+				return -EOPNOTSUPP;
+			}
+
+			if (act->police.peakrate_bytes_ps ||
+			    act->police.avrate || act->police.overhead) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Police offload is not supported when peakrate/avrate/overhead is configured");
+				return -EOPNOTSUPP;
+			}
+
 			if (act->police.rate_bytes_ps > 0) {
 				rate = act->police.rate_bytes_ps * 8;
 				burst = act->police.burst;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 1287193a019b..7c160961c92e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4197,6 +4197,33 @@ static int scan_tc_matchall_fdb_actions(struct mlx5e_priv *priv,
 	flow_action_for_each(i, act, flow_action) {
 		switch (act->id) {
 		case FLOW_ACTION_POLICE:
+			if (act->police.exceed.act_id != FLOW_ACTION_DROP) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Police offload is not supported when the exceed action is not drop");
+				return -EOPNOTSUPP;
+			}
+
+			if (act->police.notexceed.act_id != FLOW_ACTION_PIPE &&
+			    act->police.notexceed.act_id != FLOW_ACTION_ACCEPT) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Police offload is not supported when the conform action is not pipe or ok");
+				return -EOPNOTSUPP;
+			}
+
+			if (act->police.notexceed.act_id == FLOW_ACTION_ACCEPT &&
+			    !flow_action_is_last_entry(flow_action, act)) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Police offload is not supported when the conform action is ok, but police action is not last");
+				return -EOPNOTSUPP;
+			}
+
+			if (act->police.peakrate_bytes_ps ||
+			    act->police.avrate || act->police.overhead) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Police offload is not supported when peakrate/avrate/overhead is configured");
+				return -EOPNOTSUPP;
+			}
+
 			if (act->police.rate_pkt_ps) {
 				NL_SET_ERR_MSG_MOD(extack, "QoS offload not support packets per second");
 				return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index bb417db773b9..b33c3da4daf8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -191,6 +191,33 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 				return -EOPNOTSUPP;
 			}
 
+			if (act->police.exceed.act_id != FLOW_ACTION_DROP) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Police offload is not supported when the exceed action is not drop");
+				return -EOPNOTSUPP;
+			}
+
+			if (act->police.notexceed.act_id != FLOW_ACTION_PIPE &&
+			    act->police.notexceed.act_id != FLOW_ACTION_ACCEPT) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Police offload is not supported when the conform action is not pipe or ok");
+				return -EOPNOTSUPP;
+			}
+
+			if (act->police.notexceed.act_id == FLOW_ACTION_ACCEPT &&
+			    !flow_action_is_last_entry(flow_action, act)) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Police offload is not supported when the conform action is ok, but police action is not last");
+				return -EOPNOTSUPP;
+			}
+
+			if (act->police.peakrate_bytes_ps ||
+			    act->police.avrate || act->police.overhead) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Police offload is not supported when peakrate/avrate/overhead is configured");
+				return -EOPNOTSUPP;
+			}
+
 			if (act->police.rate_pkt_ps) {
 				NL_SET_ERR_MSG_MOD(extack, "QoS offload not support packets per second");
 				return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 949858891973..eb478ddb0f90 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -296,6 +296,34 @@ static int ocelot_flower_parse_action(struct ocelot *ocelot, int port,
 						   "Last action must be GOTO");
 				return -EOPNOTSUPP;
 			}
+
+			if (a->police.exceed.act_id != FLOW_ACTION_DROP) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Police offload is not supported when the exceed action is not drop");
+				return -EOPNOTSUPP;
+			}
+
+			if (a->police.notexceed.act_id != FLOW_ACTION_PIPE &&
+			    a->police.notexceed.act_id != FLOW_ACTION_ACCEPT) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Police offload is not supported when the conform action is not pipe or ok");
+				return -EOPNOTSUPP;
+			}
+
+			if (a->police.notexceed.act_id == FLOW_ACTION_ACCEPT &&
+			    !flow_action_is_last_entry(&f->rule->action, a)) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Police offload is not supported when the conform action is ok, but police action is not last");
+				return -EOPNOTSUPP;
+			}
+
+			if (a->police.peakrate_bytes_ps ||
+			    a->police.avrate || a->police.overhead) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Police offload is not supported when peakrate/avrate/overhead is configured");
+				return -EOPNOTSUPP;
+			}
+
 			if (a->police.rate_pkt_ps) {
 				NL_SET_ERR_MSG_MOD(extack,
 						   "QoS offload not support packets per second");
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index e271b6225b72..69afb560ab98 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -258,6 +258,33 @@ static int ocelot_setup_tc_cls_matchall(struct ocelot_port_private *priv,
 			return -EEXIST;
 		}
 
+		if (action->police.exceed.act_id != FLOW_ACTION_DROP) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Police offload is not supported when the exceed action is not drop");
+			return -EOPNOTSUPP;
+		}
+
+		if (action->police.notexceed.act_id != FLOW_ACTION_PIPE &&
+		    action->police.notexceed.act_id != FLOW_ACTION_ACCEPT) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Police offload is not supported when the conform action is not pipe or ok");
+			return -EOPNOTSUPP;
+		}
+
+		if (action->police.notexceed.act_id == FLOW_ACTION_ACCEPT &&
+		    !flow_action_is_last_entry(&f->rule->action, action)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Police offload is not supported when the conform action is ok, but police action is not last");
+			return -EOPNOTSUPP;
+		}
+
+		if (action->police.peakrate_bytes_ps ||
+		    action->police.avrate || action->police.overhead) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Police offload is not supported when peakrate/avrate/overhead is configured");
+			return -EOPNOTSUPP;
+		}
+
 		if (action->police.rate_pkt_ps) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "QoS offload not support packets per second");
diff --git a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
index 784c6dbf8bc4..247984d50b49 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
@@ -132,6 +132,34 @@ nfp_flower_install_rate_limiter(struct nfp_app *app, struct net_device *netdev,
 					   "unsupported offload: qos rate limit offload requires police action");
 			return -EOPNOTSUPP;
 		}
+
+		if (action->police.exceed.act_id != FLOW_ACTION_DROP) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Police offload is not supported when the exceed action is not drop");
+			return -EOPNOTSUPP;
+		}
+
+		if (action->police.notexceed.act_id != FLOW_ACTION_PIPE &&
+		    action->police.notexceed.act_id != FLOW_ACTION_ACCEPT) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Police offload is not supported when the conform action is not pipe or ok");
+			return -EOPNOTSUPP;
+		}
+
+		if (action->police.notexceed.act_id == FLOW_ACTION_ACCEPT &&
+		    !flow_action_is_last_entry(&flow->rule->action, action)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Police offload is not supported when the conform action is ok, but police action is not last");
+			return -EOPNOTSUPP;
+		}
+
+		if (action->police.peakrate_bytes_ps ||
+		    action->police.avrate || action->police.overhead) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Police offload is not supported when peakrate/avrate/overhead is configured");
+			return -EOPNOTSUPP;
+		}
+
 		if (action->police.rate_bytes_ps > 0) {
 			if (bps_num++) {
 				NL_SET_ERR_MSG_MOD(extack,
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 94cde6bbc8a5..2b9890177aa1 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -315,6 +315,12 @@ static inline bool flow_offload_has_one_action(const struct flow_action *action)
 	return action->num_entries == 1;
 }
 
+static inline bool flow_action_is_last_entry(const struct flow_action *action,
+					     const struct flow_action_entry *entry)
+{
+	return entry == &action->entries[action->num_entries - 1];
+}
+
 #define flow_action_for_each(__i, __act, __actions)			\
         for (__i = 0, __act = &(__actions)->entries[0];			\
 	     __i < (__actions)->num_entries;				\
-- 
2.26.2

