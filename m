Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3500F55212B
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 17:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239007AbiFTPgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 11:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240165AbiFTPgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 11:36:33 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2086.outbound.protection.outlook.com [40.107.237.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA02140B5
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 08:36:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aE84Dd+gI5+0Zax06SW8Jm05ytgx2/BArjuQSpv6+kpCbNQGOf55bdFBiQjyh6AEnqtdnXW7L7b6XXbwU//YVF8oDPiXz0jYOZzF3ThPrix7NEKTneyITyHORcKCQBJRXgHCVyhrye0YB1dZdNfibUzZmgHiciJsvYrHjxpK0mbrF4q3SsM4oJyUOXrslkeSIHmJrWQ0BU2uUjKj0VK7EJx+qP3mXWxUquZG9CilXUBhFRXc4Kfq8Yn7Hwaq2ZUUyeX4R7cdjK7XluV0tUsL19lKw4pjY/IXHBay9MZAnvMxUSFAzyxnnFEm9kU3bUM3gUwFlWxxfHQD7voceQKv2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lepuaZQNKewEOGPdPLMnjDjN860eeK0xXq7xnFWfFrE=;
 b=ZGHwZBPDjijkAM0s8sXfmjm2v8naBjldvWItKR+9mHClg+rqMtO3oKjpqEY2HAMvhn/JmwKZ3SatiV+YT3fb58B8hSigkF2r6YYEVHLSyotbnEulwqiV/r38CThydc3cT3qknSSUMzEUghxzoNyxDD/08kByUbah4s/HsueNRfEJ+h+Pt6qvG8pCgaOpfelPorGFOWFSM0DhqbDiGwfwDkREHu9+1auRWoYSawBvPyNAEkPXewoWbFTLdHE9DG/FQygPiIMQX2F9h1N/2JqdlPgiCGz1CUYs72MHH5Mvy4CN/UEz2+praw8a2abMlAdSwsnwP+Op52P4B0ntFkjSTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lepuaZQNKewEOGPdPLMnjDjN860eeK0xXq7xnFWfFrE=;
 b=jKfJEa+FJlx4dMyoir88L9ZfFTk0LiXdfi5uoqtClx7MBREq2L/7Dhyxsr+ypcULJkx9mTLcOzj789yJ2TM264Un4G8gFys77sRa0ag6+dPeq01ftqBb0bUl5+2U11T6lMKtSL4MONRZdYbEUwANn/XY/v6fM2dz2YryVMsZ7UdsivUKaXXklrMPceJhmiF5X44oygNaRk5xFt7LKy8aciIwrp3p+P1h++hm0irEkOFcaSXb2dhBfrZMQfKabrIcZ6UyqM5J1kIgsNSFl2rN6uFNnewKXHChaEOXsftx2NeJi5SxJTU8NSXJnz1AdqNBu2zipA7EDJZD6892Irm6sA==
Received: from DM6PR12CA0001.namprd12.prod.outlook.com (2603:10b6:5:1c0::14)
 by MN2PR12MB4176.namprd12.prod.outlook.com (2603:10b6:208:1d5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.17; Mon, 20 Jun
 2022 15:36:26 +0000
Received: from DM6NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1c0:cafe::21) by DM6PR12CA0001.outlook.office365.com
 (2603:10b6:5:1c0::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14 via Frontend
 Transport; Mon, 20 Jun 2022 15:36:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT018.mail.protection.outlook.com (10.13.172.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 15:36:26 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Mon, 20 Jun 2022 15:36:25 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 20 Jun 2022 08:36:24 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Mon, 20 Jun 2022 08:36:22 -0700
From:   Dima Chumak <dchumak@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Paolo Abeni" <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Dima Chumak <dchumak@nvidia.com>
Subject: [PATCH iproute2-next 5/5] devlink: Introduce port rate limit_type police
Date:   Mon, 20 Jun 2022 18:35:55 +0300
Message-ID: <20220620153555.2504178-5-dchumak@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220620152647.2498927-1-dchumak@nvidia.com>
References: <20220620152647.2498927-1-dchumak@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 245c0bd5-5ae8-4f88-8196-08da52d2a357
X-MS-TrafficTypeDiagnostic: MN2PR12MB4176:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4176E571CCD07E29763F2308D5B09@MN2PR12MB4176.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tby9cEj2Pwr9Q6ImSjW5IIn1r3VQK9O4ksFlm5iJboeqVc074/lmcoSscwvZhjssmlOyKx670WmpnIVz08O1ngc2qO+jKmA1CmqrFBkjJgxsprfaBdV592uJ3aue0bWn68GucJ9Wc50c9wpGV9YU1PHnEC/RsyWmuR29uNh0I63hwa/vUvMPTPeBZzNJBeT452hkWukZI9JT0mDPB6WRNyRkXfDG6+MOTcll4E48jpEi9Q3NEBRo1OuIvWbdur5FSckE8giPXjeIZhvzyWkX17V8NcW68/7/bUaXP7d02LQLJxzqkwqRR0oMMtwiP97Kc1VFtgncgtgRY75mBDxBMEPbLu7S2KJfQPNeBZTfpuo1RJejIN/JatLT8tL4c1CgxpebIO6Gd0+JRdlQlAOhxi1Ra/cyq9TcvSUezYv3SJJ5JredinflfvZZdGtDRO42GvYwnsaCfE3nCCn5IpLKMZWcTBb1oQbmt2vnRWbq+P/WFAdBZAhAqJJObl7N+eZNECgAW4rn07bIUKmIgC8RLZUYZJjCHcPMqN9I3KbTX3Skxuj9lvIR4m7MsPyuJ8e6nZiQTA5iYYUKi6LZS2ukaI4Q9hWWhHtgm4o7nqdKmXfE8pngsm6+2z4LQDDhd6l6SUjqjHVTVGG455uoa41GXyZShH9SZqfA4I24mfgOLominxvGlZwB2eXB3yP3UacWuzcztDqvoefV7IrUKWITC/RijXrnVrWKxsX1xkH23K8SVWIPD289pHEkr7LSo4yw
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(396003)(346002)(376002)(46966006)(40470700004)(36840700001)(2616005)(316002)(36756003)(26005)(110136005)(7696005)(54906003)(336012)(70206006)(40460700003)(4326008)(70586007)(83380400001)(8676002)(107886003)(41300700001)(40480700001)(6666004)(186003)(478600001)(426003)(36860700001)(1076003)(82310400005)(86362001)(8936002)(47076005)(5660300002)(30864003)(81166007)(2906002)(82740400003)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 15:36:26.1658
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 245c0bd5-5ae8-4f88-8196-08da52d2a357
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4176
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new set of `devlink port func rate {set|add}` CLI parameters that
are supported with DEVLINK_RATE_LIMIT_TYPE_POLICE kernel API. They
require explicit use of 'limit_type police', for example:

  $ devlink port func rate add pci/0000:03:00.0/g1 \
      limit_type police tx_max 10GBps tx_burst 1gb \
                        rx_max 25GBps rx_burst 2gb \
                        tx_pkts 10000 tx_pkts_burst 1gb \
                        rx_pkts 20000 rx_pkts_burst 2gb

  $ devlink port func rate set pci/0000:03:00.0/1 \
      limit_type police tx_max 2GBps rx_burst 256mb \
                        rx_max 8GBps rx_burst 512mb \
                        parent g1

  $ devlink port func rate set pci/0000:03:00.0/2 parent g1

Signed-off-by: Dima Chumak <dchumak@nvidia.com>
---
 devlink/devlink.c       | 315 +++++++++++++++++++++++++++++++++++++++-
 man/man8/devlink-rate.8 |  92 +++++++++++-
 2 files changed, 401 insertions(+), 6 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 9b234f2a6825..8eea45dad285 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -295,6 +295,13 @@ static void ifname_map_free(struct ifname_map *ifname_map)
 #define DL_OPT_PORT_FN_RATE_NODE_NAME	BIT(50)
 #define DL_OPT_PORT_FN_RATE_PARENT	BIT(51)
 #define DL_OPT_PORT_FN_RATE_LIMIT_TYPE	BIT(52)
+#define DL_OPT_PORT_FN_RATE_TX_BURST	BIT(53)
+#define DL_OPT_PORT_FN_RATE_RX_MAX	BIT(54)
+#define DL_OPT_PORT_FN_RATE_RX_BURST	BIT(55)
+#define DL_OPT_PORT_FN_RATE_TX_PKTS	BIT(56)
+#define DL_OPT_PORT_FN_RATE_TX_PKTS_BURST	BIT(57)
+#define DL_OPT_PORT_FN_RATE_RX_PKTS	BIT(58)
+#define DL_OPT_PORT_FN_RATE_RX_PKTS_BURST	BIT(59)
 
 struct dl_opts {
 	uint64_t present; /* flags of present items */
@@ -356,6 +363,13 @@ struct dl_opts {
 	char *rate_node_name;
 	const char *rate_parent_node;
 	uint16_t rate_limit_type;
+	uint64_t rate_tx_burst;
+	uint64_t rate_rx_max;
+	uint64_t rate_rx_burst;
+	uint64_t rate_tx_pkts;
+	uint64_t rate_tx_pkts_burst;
+	uint64_t rate_rx_pkts;
+	uint64_t rate_rx_pkts_burst;
 };
 
 struct dl {
@@ -1446,6 +1460,8 @@ static int port_fn_rate_limit_type_get(const char *ltypestr, uint16_t *ltype)
 		*ltype = DEVLINK_RATE_LIMIT_TYPE_UNSET;
 	else if (!strcmp(ltypestr, "shaping"))
 		*ltype = DEVLINK_RATE_LIMIT_TYPE_SHAPING;
+	else if (!strcmp(ltypestr, "police"))
+		*ltype = DEVLINK_RATE_LIMIT_TYPE_POLICE;
 	else
 		return -EINVAL;
 	return 0;
@@ -1470,6 +1486,44 @@ static int port_fn_rate_value_get(struct dl *dl, uint64_t *rate)
 	return 0;
 }
 
+static int port_fn_rate_size_get(struct dl *dl, uint64_t *size)
+{
+	const char *sizestr;
+	__u64 size64;
+	int err;
+
+	err = dl_argv_str(dl, &sizestr);
+	if (err)
+		return err;
+	err = get_size64(&size64, sizestr);
+	if (err) {
+		pr_err("Invalid burst buffer size value: \"%s\"\n", sizestr);
+		return -EINVAL;
+	}
+
+	*size = size64;
+	return 0;
+}
+
+static int port_fn_rate_pkts_get(struct dl *dl, uint64_t *pkts)
+{
+	const char *pktsstr;
+	__u64 pkts64;
+	int err;
+
+	err = dl_argv_str(dl, &pktsstr);
+	if (err)
+		return err;
+	err = get_size64(&pkts64, pktsstr);
+	if (err) {
+		pr_err("Invalid pkts value: \"%s\"\n", pktsstr);
+		return -EINVAL;
+	}
+
+	*pkts = pkts64;
+	return 0;
+}
+
 struct dl_args_metadata {
 	uint64_t o_flag;
 	char err_msg[DL_ARGS_REQUIRED_MAX_ERR_LEN];
@@ -2021,6 +2075,55 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 			if (err)
 				return err;
 			o_found |= DL_OPT_PORT_FN_RATE_TX_MAX;
+		} else if (dl_argv_match(dl, "tx_burst") &&
+			   (o_all & DL_OPT_PORT_FN_RATE_TX_BURST)) {
+			dl_arg_inc(dl);
+			err = port_fn_rate_size_get(dl, &opts->rate_tx_burst);
+			if (err)
+				return err;
+			o_found |= DL_OPT_PORT_FN_RATE_TX_BURST;
+		} else if (dl_argv_match(dl, "rx_max") &&
+			   (o_all & DL_OPT_PORT_FN_RATE_RX_MAX)) {
+			dl_arg_inc(dl);
+			err = port_fn_rate_value_get(dl, &opts->rate_rx_max);
+			if (err)
+				return err;
+			o_found |= DL_OPT_PORT_FN_RATE_RX_MAX;
+		} else if (dl_argv_match(dl, "rx_burst") &&
+			   (o_all & DL_OPT_PORT_FN_RATE_RX_BURST)) {
+			dl_arg_inc(dl);
+			err = port_fn_rate_size_get(dl, &opts->rate_rx_burst);
+			if (err)
+				return err;
+			o_found |= DL_OPT_PORT_FN_RATE_RX_BURST;
+		} else if (dl_argv_match(dl, "tx_pkts") &&
+			   (o_all & DL_OPT_PORT_FN_RATE_TX_PKTS)) {
+			dl_arg_inc(dl);
+			err = port_fn_rate_pkts_get(dl, &opts->rate_tx_pkts);
+			if (err)
+				return err;
+			o_found |= DL_OPT_PORT_FN_RATE_TX_PKTS;
+		} else if (dl_argv_match(dl, "tx_pkts_burst") &&
+			   (o_all & DL_OPT_PORT_FN_RATE_TX_PKTS_BURST)) {
+			dl_arg_inc(dl);
+			err = port_fn_rate_size_get(dl, &opts->rate_tx_pkts_burst);
+			if (err)
+				return err;
+			o_found |= DL_OPT_PORT_FN_RATE_TX_PKTS_BURST;
+		} else if (dl_argv_match(dl, "rx_pkts") &&
+			   (o_all & DL_OPT_PORT_FN_RATE_RX_PKTS)) {
+			dl_arg_inc(dl);
+			err = port_fn_rate_pkts_get(dl, &opts->rate_rx_pkts);
+			if (err)
+				return err;
+			o_found |= DL_OPT_PORT_FN_RATE_RX_PKTS;
+		} else if (dl_argv_match(dl, "rx_pkts_burst") &&
+			   (o_all & DL_OPT_PORT_FN_RATE_RX_PKTS_BURST)) {
+			dl_arg_inc(dl);
+			err = port_fn_rate_size_get(dl, &opts->rate_rx_pkts_burst);
+			if (err)
+				return err;
+			o_found |= DL_OPT_PORT_FN_RATE_RX_PKTS_BURST;
 		} else if (dl_argv_match(dl, "parent") &&
 			   (o_all & DL_OPT_PORT_FN_RATE_PARENT)) {
 			dl_arg_inc(dl);
@@ -2246,6 +2349,27 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 	if (opts->present & DL_OPT_PORT_FN_RATE_TX_MAX)
 		mnl_attr_put_u64(nlh, DEVLINK_ATTR_RATE_TX_MAX,
 				 opts->rate_tx_max);
+	if (opts->present & DL_OPT_PORT_FN_RATE_TX_BURST)
+		mnl_attr_put_u64(nlh, DEVLINK_ATTR_RATE_TX_BURST,
+				 opts->rate_tx_burst);
+	if (opts->present & DL_OPT_PORT_FN_RATE_RX_MAX)
+		mnl_attr_put_u64(nlh, DEVLINK_ATTR_RATE_RX_MAX,
+				 opts->rate_rx_max);
+	if (opts->present & DL_OPT_PORT_FN_RATE_RX_BURST)
+		mnl_attr_put_u64(nlh, DEVLINK_ATTR_RATE_RX_BURST,
+				 opts->rate_rx_burst);
+	if (opts->present & DL_OPT_PORT_FN_RATE_TX_PKTS)
+		mnl_attr_put_u64(nlh, DEVLINK_ATTR_RATE_TX_PKTS,
+				 opts->rate_tx_pkts);
+	if (opts->present & DL_OPT_PORT_FN_RATE_TX_PKTS_BURST)
+		mnl_attr_put_u64(nlh, DEVLINK_ATTR_RATE_TX_PKTS_BURST,
+				 opts->rate_tx_pkts_burst);
+	if (opts->present & DL_OPT_PORT_FN_RATE_RX_PKTS)
+		mnl_attr_put_u64(nlh, DEVLINK_ATTR_RATE_RX_PKTS,
+				 opts->rate_rx_pkts);
+	if (opts->present & DL_OPT_PORT_FN_RATE_RX_PKTS_BURST)
+		mnl_attr_put_u64(nlh, DEVLINK_ATTR_RATE_RX_PKTS_BURST,
+				 opts->rate_rx_pkts_burst);
 	if (opts->present & DL_OPT_PORT_FN_RATE_PARENT)
 		mnl_attr_put_strz(nlh, DEVLINK_ATTR_RATE_PARENT_NODE_NAME,
 				  opts->rate_parent_node);
@@ -4522,11 +4646,43 @@ static char *port_rate_limit_type_name(uint16_t ltype)
 		return "unset";
 	case DEVLINK_RATE_LIMIT_TYPE_SHAPING:
 		return "shaping";
+	case DEVLINK_RATE_LIMIT_TYPE_POLICE:
+		return "police";
 	default:
 		return "<unknown type>";
 	}
 }
 
+static char *port_rate_opt_name(enum devlink_rate_limit_type ltype, uint64_t present)
+{
+	switch (ltype) {
+	case DEVLINK_RATE_LIMIT_TYPE_SHAPING:
+		if (present & DL_OPT_PORT_FN_RATE_TX_SHARE)
+			return "tx_share";
+		if (present & DL_OPT_PORT_FN_RATE_TX_MAX)
+			return "tx_max";
+	case DEVLINK_RATE_LIMIT_TYPE_POLICE:
+		if (present & DL_OPT_PORT_FN_RATE_TX_MAX)
+			return "tx_max";
+		if (present & DL_OPT_PORT_FN_RATE_TX_BURST)
+			return "tx_burst";
+		if (present & DL_OPT_PORT_FN_RATE_RX_MAX)
+			return "rx_max";
+		if (present & DL_OPT_PORT_FN_RATE_RX_BURST)
+			return "rx_burst";
+		if (present & DL_OPT_PORT_FN_RATE_TX_PKTS)
+			return "tx_pkts";
+		if (present & DL_OPT_PORT_FN_RATE_TX_PKTS_BURST)
+			return "tx_pkts_burst";
+		if (present & DL_OPT_PORT_FN_RATE_RX_PKTS)
+			return "rx_pkts";
+		if (present & DL_OPT_PORT_FN_RATE_RX_PKTS_BURST)
+			return "rx_pkts_burst";
+	default:
+		return "";
+	}
+}
+
 static void pr_out_port_fn_rate(struct dl *dl, struct nlattr **tb)
 {
 	uint16_t ltype = DEVLINK_RATE_LIMIT_TYPE_UNSET;
@@ -4567,6 +4723,69 @@ static void pr_out_port_fn_rate(struct dl *dl, struct nlattr **tb)
 			print_rate(use_iec, PRINT_ANY, "tx_max",
 				   " tx_max %s", rate);
 	}
+	if (tb[DEVLINK_ATTR_RATE_TX_BURST] &&
+	    ltype == DEVLINK_RATE_LIMIT_TYPE_POLICE) {
+		uint64_t size =
+			mnl_attr_get_u64(tb[DEVLINK_ATTR_RATE_TX_BURST]);
+
+		if (size)
+			print_rate(use_iec, PRINT_ANY, "tx_burst",
+				   " tx_burst %s", size);
+	}
+	if (tb[DEVLINK_ATTR_RATE_RX_MAX] &&
+	    ltype == DEVLINK_RATE_LIMIT_TYPE_POLICE) {
+		uint64_t rate =
+			mnl_attr_get_u64(tb[DEVLINK_ATTR_RATE_RX_MAX]);
+
+		if (rate)
+			print_rate(use_iec, PRINT_ANY, "rx_max",
+				   " rx_max %s", rate);
+	}
+	if (tb[DEVLINK_ATTR_RATE_RX_BURST] &&
+	    ltype == DEVLINK_RATE_LIMIT_TYPE_POLICE) {
+		uint64_t size =
+			mnl_attr_get_u64(tb[DEVLINK_ATTR_RATE_RX_BURST]);
+
+		if (size)
+			print_rate(use_iec, PRINT_ANY, "rx_burst",
+				   " rx_burst %s", size);
+	}
+	if (tb[DEVLINK_ATTR_RATE_TX_PKTS] &&
+	    ltype == DEVLINK_RATE_LIMIT_TYPE_POLICE) {
+		uint64_t rate =
+			mnl_attr_get_u64(tb[DEVLINK_ATTR_RATE_TX_PKTS]);
+
+		if (rate)
+			print_rate(use_iec, PRINT_ANY, "tx_pkts",
+				   " tx_pkts %s", rate);
+	}
+	if (tb[DEVLINK_ATTR_RATE_TX_PKTS_BURST] &&
+	    ltype == DEVLINK_RATE_LIMIT_TYPE_POLICE) {
+		uint64_t size =
+			mnl_attr_get_u64(tb[DEVLINK_ATTR_RATE_TX_PKTS_BURST]);
+
+		if (size)
+			print_rate(use_iec, PRINT_ANY, "tx_pkts_burst",
+				   " tx_pkts_burst %s", size);
+	}
+	if (tb[DEVLINK_ATTR_RATE_RX_PKTS] &&
+	    ltype == DEVLINK_RATE_LIMIT_TYPE_POLICE) {
+		uint64_t rate =
+			mnl_attr_get_u64(tb[DEVLINK_ATTR_RATE_RX_PKTS]);
+
+		if (rate)
+			print_rate(use_iec, PRINT_ANY, "rx_pkts",
+				   " rx_pkts %s", rate);
+	}
+	if (tb[DEVLINK_ATTR_RATE_RX_PKTS_BURST] &&
+	    ltype == DEVLINK_RATE_LIMIT_TYPE_POLICE) {
+		uint64_t size =
+			mnl_attr_get_u64(tb[DEVLINK_ATTR_RATE_RX_PKTS_BURST]);
+
+		if (size)
+			print_rate(use_iec, PRINT_ANY, "rx_pkts_burst",
+				   " rx_pkts_burst %s", size);
+	}
 	if (tb[DEVLINK_ATTR_RATE_PARENT_NODE_NAME]) {
 		const char *parent =
 			mnl_attr_get_str(tb[DEVLINK_ATTR_RATE_PARENT_NODE_NAME]);
@@ -4599,9 +4818,17 @@ static void cmd_port_fn_rate_help(void)
 	pr_err("       devlink port function rate show [ DEV/{ PORT_INDEX | NODE_NAME } ]\n");
 	pr_err("       devlink port function rate add DEV/NODE_NAME\n");
 	pr_err("               [ limit_type shaping ][ tx_share VAL ][ tx_max VAL ][ { parent NODE_NAME | noparent } ]\n");
+	pr_err("       devlink port function rate add DEV/NODE_NAME\n");
+	pr_err("               limit_type police [ tx_max VAL [ tx_burst VAL ]][ rx_max VAL [ rx_burst VAL ]]\n");
+	pr_err("                                 [ tx_pkts VAL [ tx_pkts_burst VAL ]][ rx_pkts VAL [ rx_pkts_burst VAL ]]\n");
+	pr_err("                                 [ { parent NODE_NAME | noparent } ]\n");
 	pr_err("       devlink port function rate del DEV/NODE_NAME\n");
 	pr_err("       devlink port function rate set DEV/{ PORT_INDEX | NODE_NAME }\n");
-	pr_err("               [ limit_type shaping ][ tx_share VAL ][ tx_max VAL ][ { parent NODE_NAME | noparent } ]\n\n");
+	pr_err("               [ limit_type shaping ][ tx_share VAL ][ tx_max VAL ][ { parent NODE_NAME | noparent } ]\n");
+	pr_err("       devlink port function rate set DEV/{ PORT_INDEX | NODE_NAME }\n");
+	pr_err("               limit_type police [ tx_max VAL [ tx_burst VAL ]][ rx_max VAL [ rx_burst VAL ]]\n");
+	pr_err("                                 [ tx_pkts VAL [ tx_pkts_burst VAL ]][ rx_pkts VAL [ rx_pkts_burst VAL ]]\n");
+	pr_err("                                 [ { parent NODE_NAME | noparent } ]\n\n");
 	pr_err("       VAL - float or integer value in units of bits or bytes per second (bit|bps)\n");
 	pr_err("       and SI (k-, m-, g-, t-) or IEC (ki-, mi-, gi-, ti-) case-insensitive prefix.\n");
 	pr_err("       Bare number, means bits per second, is possible.\n\n");
@@ -4680,7 +4907,24 @@ static int port_rate_shaping_add(struct dl *dl)
 	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
 
+static int port_rate_police_add(struct dl *dl)
+{
+	struct nlmsghdr *nlh;
+
+	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_RATE_NEW,
+					  NLM_F_REQUEST | NLM_F_ACK);
+	dl_opts_put(nlh, dl);
+	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
+}
+
 #define RATE_SHAPING_OPTS	(DL_OPT_PORT_FN_RATE_TX_SHARE)
+#define RATE_POLICE_OPTS	(DL_OPT_PORT_FN_RATE_TX_BURST \
+				 | DL_OPT_PORT_FN_RATE_RX_MAX \
+				 | DL_OPT_PORT_FN_RATE_RX_BURST \
+				 | DL_OPT_PORT_FN_RATE_TX_PKTS \
+				 | DL_OPT_PORT_FN_RATE_TX_PKTS_BURST \
+				 | DL_OPT_PORT_FN_RATE_RX_PKTS \
+				 | DL_OPT_PORT_FN_RATE_RX_PKTS_BURST)
 
 static int cmd_port_fn_rate_add(struct dl *dl)
 {
@@ -4688,15 +4932,32 @@ static int cmd_port_fn_rate_add(struct dl *dl)
 
 	err = dl_argv_parse(dl, DL_OPT_PORT_FN_RATE_NODE_NAME,
 			    DL_OPT_PORT_FN_RATE_LIMIT_TYPE | DL_OPT_PORT_FN_RATE_TX_MAX |
-			    RATE_SHAPING_OPTS);
+			    RATE_SHAPING_OPTS | RATE_POLICE_OPTS);
 	if (err)
 		return err;
 
+	if ((dl->opts.present & DL_OPT_PORT_FN_RATE_LIMIT_TYPE) &&
+	    dl->opts.rate_limit_type == DEVLINK_RATE_LIMIT_TYPE_POLICE) {
+		if (dl->opts.present & RATE_SHAPING_OPTS) {
+			pr_err("Unsupported option \"%s\" for limit_type \"%s\"\n",
+			       port_rate_opt_name(dl->opts.rate_limit_type, dl->opts.present),
+			       port_rate_limit_type_name(dl->opts.rate_limit_type));
+			return -EINVAL;
+		}
+		return port_rate_police_add(dl);
+	}
+
 	if (!(dl->opts.present & DL_OPT_PORT_FN_RATE_LIMIT_TYPE)) {
 		dl->opts.rate_limit_type = DEVLINK_RATE_LIMIT_TYPE_SHAPING;
 		dl->opts.present |= DL_OPT_PORT_FN_RATE_LIMIT_TYPE;
 	}
 
+	if (dl->opts.present & RATE_POLICE_OPTS) {
+		pr_err("Unsupported option \"%s\" for limit_type \"%s\"\n",
+			port_rate_opt_name(dl->opts.rate_limit_type, dl->opts.present),
+			port_rate_limit_type_name(dl->opts.rate_limit_type));
+		return -EINVAL;
+	}
 
 	return port_rate_shaping_add(dl);
 }
@@ -4734,6 +4995,27 @@ static int port_fn_get_rates_cb(const struct nlmsghdr *nlh, void *data)
 	if (tb[DEVLINK_ATTR_RATE_TX_MAX])
 		opts->rate_tx_max =
 			mnl_attr_get_u64(tb[DEVLINK_ATTR_RATE_TX_MAX]);
+	if (tb[DEVLINK_ATTR_RATE_TX_BURST])
+		opts->rate_tx_burst =
+			mnl_attr_get_u64(tb[DEVLINK_ATTR_RATE_TX_BURST]);
+	if (tb[DEVLINK_ATTR_RATE_RX_MAX])
+		opts->rate_rx_max =
+			mnl_attr_get_u64(tb[DEVLINK_ATTR_RATE_RX_MAX]);
+	if (tb[DEVLINK_ATTR_RATE_RX_BURST])
+		opts->rate_rx_burst =
+			mnl_attr_get_u64(tb[DEVLINK_ATTR_RATE_RX_BURST]);
+	if (tb[DEVLINK_ATTR_RATE_TX_PKTS])
+		opts->rate_tx_pkts =
+			mnl_attr_get_u64(tb[DEVLINK_ATTR_RATE_TX_PKTS]);
+	if (tb[DEVLINK_ATTR_RATE_TX_PKTS_BURST])
+		opts->rate_tx_pkts_burst =
+			mnl_attr_get_u64(tb[DEVLINK_ATTR_RATE_TX_PKTS_BURST]);
+	if (tb[DEVLINK_ATTR_RATE_RX_PKTS])
+		opts->rate_rx_pkts =
+			mnl_attr_get_u64(tb[DEVLINK_ATTR_RATE_RX_PKTS]);
+	if (tb[DEVLINK_ATTR_RATE_RX_PKTS_BURST])
+		opts->rate_rx_pkts_burst =
+			mnl_attr_get_u64(tb[DEVLINK_ATTR_RATE_RX_PKTS_BURST]);
 	return MNL_CB_OK;
 }
 
@@ -4774,22 +5056,49 @@ static int port_rate_shaping_set(struct dl *dl)
 	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
 
+static int port_rate_police_set(struct dl *dl)
+{
+	struct nlmsghdr *nlh;
+
+	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_RATE_SET,
+					  NLM_F_REQUEST | NLM_F_ACK);
+	dl_opts_put(nlh, dl);
+	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
+}
+
 static int cmd_port_fn_rate_set(struct dl *dl)
 {
 	int err;
 
 	err = dl_argv_parse(dl, DL_OPT_HANDLEP | DL_OPT_PORT_FN_RATE_NODE_NAME,
 			    DL_OPT_PORT_FN_RATE_LIMIT_TYPE | DL_OPT_PORT_FN_RATE_TX_MAX |
-			    RATE_SHAPING_OPTS | DL_OPT_PORT_FN_RATE_PARENT);
+			    RATE_SHAPING_OPTS | RATE_POLICE_OPTS | DL_OPT_PORT_FN_RATE_PARENT);
 	if (err)
 		return err;
 
+	if ((dl->opts.present & DL_OPT_PORT_FN_RATE_LIMIT_TYPE) &&
+	    dl->opts.rate_limit_type == DEVLINK_RATE_LIMIT_TYPE_POLICE) {
+		if (dl->opts.present & RATE_SHAPING_OPTS) {
+			pr_err("Unsupported option \"%s\" for limit_type \"%s\"\n",
+			       port_rate_opt_name(dl->opts.rate_limit_type, dl->opts.present),
+			       port_rate_limit_type_name(dl->opts.rate_limit_type));
+			return -EINVAL;
+		}
+		return port_rate_police_set(dl);
+	}
+
 	if (!(dl->opts.present & DL_OPT_PORT_FN_RATE_LIMIT_TYPE) &&
 	    !(dl->opts.present & DL_OPT_PORT_FN_RATE_PARENT)) {
 		dl->opts.rate_limit_type = DEVLINK_RATE_LIMIT_TYPE_SHAPING;
 		dl->opts.present |= DL_OPT_PORT_FN_RATE_LIMIT_TYPE;
 	}
 
+	if (dl->opts.present & RATE_POLICE_OPTS) {
+		pr_err("Unsupported option \"%s\" for limit_type \"%s\"\n",
+			port_rate_opt_name(dl->opts.rate_limit_type, dl->opts.present),
+			port_rate_limit_type_name(dl->opts.rate_limit_type));
+		return -EINVAL;
+	}
 
 	return port_rate_shaping_set(dl);
 }
diff --git a/man/man8/devlink-rate.8 b/man/man8/devlink-rate.8
index 6b7b179a8696..56907590cd9a 100644
--- a/man/man8/devlink-rate.8
+++ b/man/man8/devlink-rate.8
@@ -28,6 +28,12 @@ devlink-rate \- devlink rate management
 .RB [ " limit_type \fIshaping " ]
 .RB [ " tx_share \fIVALUE " ]
 .RB [ " tx_max \fIVALUE " ]
+.RB | " limit_type \fIpolice "
+.RB [ " tx_max \fIVALUE " [ " tx_burst \fIVALUE " ] " " ]
+.RB [ " rx_max \fIVALUE " [ " rx_burst \fIVALUE " ] " " ]
+.RB [ " tx_pkts \fIVALUE " [ " tx_pkts_burst \fIVALUE " ] " " ]
+.RB [ " rx_pkts \fIVALUE " [ " rx_pkts_burst \fIVALUE " ] " " ]
+.RB "}"
 .RB "[ {" " parent \fINODE_NAME " | " noparent " "} ]"
 
 .ti -8
@@ -36,6 +42,12 @@ devlink-rate \- devlink rate management
 .RB [ " limit_type \fIshaping " ]
 .RB [ " tx_share \fIVALUE " ]
 .RB [ " tx_max \fIVALUE " ]
+.RB | " limit_type \fIpolice "
+.RB [ " tx_max \fIVALUE " [ " tx_burst \fIVALUE " ] " " ]
+.RB [ " rx_max \fIVALUE " [ " rx_burst \fIVALUE " ] " " ]
+.RB [ " tx_pkts \fIVALUE " [ " tx_pkts_burst \fIVALUE " ] " " ]
+.RB [ " rx_pkts \fIVALUE " [ " rx_pkts_burst \fIVALUE " ] " " ]
+.RB "}"
 .RB "[ {" " parent \fINODE_NAME " | " noparent " "} ]"
 
 .ti -8
@@ -80,7 +92,7 @@ the last occurrence is used.
 .I DEV/NODE_NAME
 - specifies devlink node rate object.
 .PP
-.BR limit_type " \fIshaping "
+.BR limit_type " {" " \fIshaping " | " \fIpolice " }
 - specifies a kind of rate limiting. The parameter is optional and, if omitted,
 \fIshaping\fR limit type is assumed by default. Each limit type has its own set
 of supported attributes. Some limit types may not be supported by a particular
@@ -93,10 +105,17 @@ This type of rate limiting doesn't require packets to be dropped in order to
 ensure the requested rate, on the other hand it may suffer from excessive delays
 and it cannot be applied to inbound traffic.
 .PP
+.I police
+- limiting traffic rate by dropping excessive packets. This type of rate
+limiting can be applied to both outbound and inbound traffic, and it doesn't
+suffer from delays that might occur with \fIshaping\fR limit type. On the other
+hand, by definition this type of rate limiting may be unacceptable for certain
+applications and workloads that are sensitive to packet loss.
+.PP
 .BI tx_share " VALUE"
 - specifies minimal tx rate value shared among all rate objects. If rate object
 is a part of some rate group, then this value shared with rate objects of this
-rate group.
+rate group. This parameter is specific to \fBlimit_type\fR \fIshaping\fR only.
 .PP
 .BI tx_max " VALUE"
 - specifies maximum tx rate value.
@@ -140,11 +159,72 @@ To specify in IEC units, replace the SI prefix (k-, m-, g-, t-) with IEC prefix
 (ki-, mi-, gi- and ti-) respectively. Input is case-insensitive.
 .RE
 .PP
+.BI tx_burst " VALUE"
+- specifies size of a bucket that's used to buffer spikes when traffic exceeds
+\fBtx_max\fR limit. This parameter is specific to \fBlimit_type\fR \fIpolice\fR
+only.
+.TP 8
+.I VALUE
+This parameter accept a floating point number, possibly followed by a unit.
+.RS
+.TP
+b or a bare number
+Bytes
+.TP
+k | kb
+Kilobytes
+.TP
+m | mb
+Megabytes
+.TP
+g | gb
+Gigabytes
+.TP
+kbit
+Kilobits
+.TP
+mbit
+Megabits
+.TP
+gbit
+Gigabits
+.RE
+.PP
+.BI rx_max " VALUE"
+- specifies maximum rx rate value. It accepts same values as \fBtx_max\fR. This
+parameter is specific to \fBlimit_type\fR \fIpolice\fR only.
+.PP
+.BI rx_burst " VALUE"
+- specifies size of a bucket that's used to buffer spikes when traffic exceeds
+\fBrx_max\fR limit. It accepts the same values as \fBtx_burst\fR. This parameter
+is specific to \fBlimit_type\fR \fIpolice\fR only.
+.PP
+.BI tx_pkts " VALUE"
+- specifies maximum tx packets per second value. This parameter is specific to
+\fBlimit_type\fR \fIpolice\fR only.
+.PP
+.BI tx_pkts_burst " VALUE"
+- specifies size of a bucket that's used to buffer spikes when traffic exceeds
+\fBtx_pkts\fR limit. It accepts the same values as \fBtx_burst\fR. This
+parameter is specific to \fBlimit_type\fR \fIpolice\fR only.
+.PP
+.BI rx_pkts " VALUE"
+- specifies maximum tx packets per second value. This parameter is specific to
+\fBlimit_type\fR \fIpolice\fR only.
+.PP
+.BI rx_pkts_burst " VALUE"
+- specifies size of a bucket that's used to buffer spikes when traffic exceeds
+\fBtx_pkts\fR limit. It accepts the same values as \fBtx_burst\fR. This
+parameter is specific to \fBlimit_type\fR \fIpolice\fR only.
+.PP
 .BI parent " NODE_NAME \fR| " noparent
 - set rate object parent to existing node with name \fINODE_NAME\fR or unset
 parent. Rate limits of the parent node applied to all it's children. Actual
 behaviour is details of driver's implementation. Setting parent to empty ("")
-name due to the kernel logic threated as parent unset.
+name due to the kernel logic treated as parent unset. It's important that
+\fBlimit_type\fR of the rate object and the parent node should match,
+otherwise setting parent will fail. In other words, it's only possible to group
+rate objects of the same \fBlimit_type\fR.
 
 .SS devlink port function rate add - create node rate object with specified parameters.
 Creates rate object of type node and sets parameters. Parameters same as for the
@@ -222,6 +302,8 @@ pci/0000:03:00.0/some_group type node
         "pci/0000:03:00.0/2": {
 .br
             "type": "leaf",
+.br
+            "limit_type": "shaping",
 .br
             "tx_share": 1500000
 .br
@@ -255,6 +337,10 @@ pci/0000:03:00.0/some_group type node
 # devlink port function rate set pci/0000:03:00.0/1 \\
 .br
 	tx_share 2Mbit tx_max 10Mbit
+.PP
+# devlink port function rate set pci/0000:03:00.0/2 \\
+.br
+	limit_type police rx_max 10Mbit rx_burst 4mb
 .RE
 
 .PP
-- 
2.36.1

