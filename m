Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 891515520D5
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 17:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243391AbiFTP1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 11:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbiFTP1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 11:27:38 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2071.outbound.protection.outlook.com [40.107.236.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B210CD
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 08:27:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jpuw49YJ3ScMZlyo3FI9/W/55ZrWOMekkvmVmIpNmYNSvTqJhPEhzcZhVDG2XZGntSzVVva8yNm7+OR0+4WyzCO7OiOO1OeYWIQHMxe9l1rh4Lu81BCr1NkP5DYmXnH7LBeHEL8qeXwXiyr9NTndz+1SuOZmAFVUqdf8qRmJsoWS8gPFn4WvN/Q3f689FTYiKXtlDyEKqGvupZvZwTe+UxVTTQLcXrZ6Jzr4yzFmVDyHtVhvG9R1ebz4aLENZ0zdmPelAKDTKvM4SPH5Wmi3HN3rrO9Y639m79QPNLimXcliZtU+ybtf8f4KP4vmE6JyVjGp9A2jWsMQm1tt5lvJtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MxaMopFfJn+PW9v0NtqQrUp08dvJqPtzc91D3SpGAxs=;
 b=RYJM39d/zQkDF4DNrkLagrpzF+1oERRV2/t/4dpeB0tSHnY2iy192mfvyD4jvma0SUQw47qPJ4RAnSXcMF9nspr7gDPh7yT0NWHaPnIdg91XosCt96hr/nwYGbildTxZ4i3/9sgHtMazWO9DindaxGG5tApsBJ/9aoEpEPL/+UCoELZpg2ipc2diA+0e2IPfroOXESU4HIjAcXC5g9H3NxJlZFKQs8PlwFMYCVv6FnxlMQRzIvJctlffzaaDi5JZPsPZql9v6gEKMbp2xvKD0Hmms2tVCr8ap1FBeovO3YmTbhQHk7gVV1dmXcNiCqYfakDg1NT6wQ5r3wIBGeM75Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MxaMopFfJn+PW9v0NtqQrUp08dvJqPtzc91D3SpGAxs=;
 b=bAxeImz2JorPV1Uam8Y6JY8aDR3mkI4PhVRXl1i7m0c8hEJnpnr3Wdk/sjRb6YJWzz6IRqZUpCmq9BjQKvr++e5+3sIcds4+ijOwnyZH+FluQ5QzK7yRGZQ9JgsTqoHy64YMEHVViGltA3pvwwnqoiTuZZpWs3pUSmPgMn3G0HFIxUXDH9YyXanuc9cogGJWO1LxRJoe5mQH/SiATPWv1Lo65ygqtpCWJNGvGE6rbz6F5LQf1pNKCnxTjWWpjFM46k87Tbse36sND6Lm8A2VjESyOF/q+4J7fhHDj7XMZ0/KxGDLQK5jThfbgpCegpHeEF45zUBxgf0KtU/ZQ8PVnw==
Received: from MWHPR1701CA0005.namprd17.prod.outlook.com
 (2603:10b6:301:14::15) by SN1PR12MB2382.namprd12.prod.outlook.com
 (2603:10b6:802:2e::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.19; Mon, 20 Jun
 2022 15:27:34 +0000
Received: from CO1NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:14:cafe::31) by MWHPR1701CA0005.outlook.office365.com
 (2603:10b6:301:14::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.22 via Frontend
 Transport; Mon, 20 Jun 2022 15:27:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT022.mail.protection.outlook.com (10.13.175.199) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 15:27:33 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Mon, 20 Jun 2022 15:27:33 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 20 Jun 2022 08:27:32 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Mon, 20 Jun 2022 08:27:31 -0700
From:   Dima Chumak <dchumak@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Dima Chumak <dchumak@nvidia.com>
Subject: [PATCH net-next 2/5] devlink: Introduce police rate limit type
Date:   Mon, 20 Jun 2022 18:26:44 +0300
Message-ID: <20220620152647.2498927-3-dchumak@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220620152647.2498927-1-dchumak@nvidia.com>
References: <20220620152647.2498927-1-dchumak@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c17e0e5-8348-4e81-d429-08da52d165f9
X-MS-TrafficTypeDiagnostic: SN1PR12MB2382:EE_
X-Microsoft-Antispam-PRVS: <SN1PR12MB2382D2BA46E0A07680080F8FD5B09@SN1PR12MB2382.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DpSLOopqLMNT+A7itlUhYy1VUofaHFAyQdJIl8va36loHZpcOY4ZOOwCrkpGRpnQbh1YZFY2gO1Mdw0OYG3zu2L9z6h0CqZVtOCYWALf38gYVAlPQclTkRhdJmHDEhDhwMfeEgRQPASPcUqSoXJprQ72sUnNH31iFYuW6s24tQpr5/IIwPrVx4Hws4u9g8OuHlJ+LiGy5NwL71i5AFH3acqcXRH/3D3qQNNtsLgPX/xvdduU5T7vCThrhbQDC7mmfXQOfjCxyvAss/KxN9YcpZH4UBBVCVt9TwjsqRM8UhlLFm7gVbvAByqHJt4x0H/e/H1VstmixXqc4HzkXqdg0plfDKLgTdpopNeaeCZsh+7JynnJyRUbr5XkgWBn8kT4fR8eqtL2Gi5jwGGSSk+fD4tW+ixLUvCcIidMJwqCdO06la5Kr0LB0CnSY0XAbrDPfcHePdboehvVdGKzUAEAWu1IN/FVoTaLRGMxXZLni6R86iElDzC898law6ten90aE6z73VcrT4B6ydayYZT7b+EEChzJlmeFJsjovAk7R8xuRPUllI34bJH1WxgbWEVB6yFlaHpt03r5YCuoDeGpgmvlLw+xGMvJXebvCiyectBmF+1sr5LJlTORzqqXjzRfveV47sc5JMk+LUXmGFNDofTdLXyldntCV6gUaX5oCXmB2cf4YfCw6paOaGGt1jaV295A4dA525gK1uwqkhr+Pg==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(46966006)(36840700001)(40470700004)(54906003)(26005)(316002)(6916009)(36756003)(498600001)(82310400005)(4326008)(70206006)(70586007)(6666004)(107886003)(1076003)(2616005)(83380400001)(186003)(8936002)(47076005)(426003)(336012)(356005)(36860700001)(2906002)(81166007)(86362001)(8676002)(7696005)(5660300002)(40460700003)(30864003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 15:27:33.7454
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c17e0e5-8348-4e81-d429-08da52d165f9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2382
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define a new DEVLINK_RATE_LIMIT_TYPE_POLICE along with the related
devlink_rate object attributes and their devlink_ops.

The new attributes are optional and specific to 'limit_type police'
only. Driver implementations are allowed to support any or none of them.

Example of limiting inbound traffic with the new limit type:

$ devlink port function rate set netdevsim/netdevsim10/1 \
          limit_type police rx_max 10mbit rx_burst 1mb

Signed-off-by: Dima Chumak <dchumak@nvidia.com>
---
 include/net/devlink.h        |  40 +++++++
 include/uapi/linux/devlink.h |   8 ++
 net/core/devlink.c           | 223 ++++++++++++++++++++++++++++++++++-
 3 files changed, 268 insertions(+), 3 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 4fe8e657da44..3de1cc42b10c 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -103,6 +103,17 @@ struct devlink_rate_shaping_attrs {
 	u64 tx_share;
 };
 
+struct devlink_rate_police_attrs {
+	u64 tx_max;
+	u64 tx_burst;
+	u64 rx_max;
+	u64 rx_burst;
+	u64 tx_pkts;
+	u64 tx_pkts_burst;
+	u64 rx_pkts;
+	u64 rx_pkts_burst;
+};
+
 struct devlink_rate {
 	struct list_head list;
 	enum devlink_rate_limit_type limit_type;
@@ -112,6 +123,7 @@ struct devlink_rate {
 
 	union { /* on limit_type */
 		struct devlink_rate_shaping_attrs shaping_attrs;
+		struct devlink_rate_police_attrs police_attrs;
 	};
 
 	struct devlink_rate *parent;
@@ -1501,10 +1513,38 @@ struct devlink_ops {
 				      u64 tx_share, struct netlink_ext_ack *extack);
 	int (*rate_leaf_tx_max_set)(struct devlink_rate *devlink_rate, void *priv,
 				    u64 tx_max, struct netlink_ext_ack *extack);
+	int (*rate_leaf_tx_burst_set)(struct devlink_rate *devlink_rate, void *priv,
+				      u64 tx_burst, struct netlink_ext_ack *extack);
+	int (*rate_leaf_rx_max_set)(struct devlink_rate *devlink_rate, void *priv,
+				    u64 rx_max, struct netlink_ext_ack *extack);
+	int (*rate_leaf_rx_burst_set)(struct devlink_rate *devlink_rate, void *priv,
+				      u64 rx_burst, struct netlink_ext_ack *extack);
+	int (*rate_leaf_tx_pkts_set)(struct devlink_rate *devlink_rate, void *priv,
+				     u64 tx_pkts, struct netlink_ext_ack *extack);
+	int (*rate_leaf_tx_pkts_burst_set)(struct devlink_rate *devlink_rate, void *priv,
+					   u64 tx_pkts_burst, struct netlink_ext_ack *extack);
+	int (*rate_leaf_rx_pkts_set)(struct devlink_rate *devlink_rate, void *priv,
+				     u64 rx_pkts, struct netlink_ext_ack *extack);
+	int (*rate_leaf_rx_pkts_burst_set)(struct devlink_rate *devlink_rate, void *priv,
+					   u64 rx_pkts_burst, struct netlink_ext_ack *extack);
 	int (*rate_node_tx_share_set)(struct devlink_rate *devlink_rate, void *priv,
 				      u64 tx_share, struct netlink_ext_ack *extack);
 	int (*rate_node_tx_max_set)(struct devlink_rate *devlink_rate, void *priv,
 				    u64 tx_max, struct netlink_ext_ack *extack);
+	int (*rate_node_tx_burst_set)(struct devlink_rate *devlink_rate, void *priv,
+				      u64 tx_burst, struct netlink_ext_ack *extack);
+	int (*rate_node_rx_max_set)(struct devlink_rate *devlink_rate, void *priv,
+				    u64 rx_max, struct netlink_ext_ack *extack);
+	int (*rate_node_rx_burst_set)(struct devlink_rate *devlink_rate, void *priv,
+				      u64 rx_burst, struct netlink_ext_ack *extack);
+	int (*rate_node_tx_pkts_set)(struct devlink_rate *devlink_rate, void *priv,
+				     u64 tx_pkts, struct netlink_ext_ack *extack);
+	int (*rate_node_tx_pkts_burst_set)(struct devlink_rate *devlink_rate, void *priv,
+					   u64 tx_pkts_burst, struct netlink_ext_ack *extack);
+	int (*rate_node_rx_pkts_set)(struct devlink_rate *devlink_rate, void *priv,
+				     u64 rx_pkts, struct netlink_ext_ack *extack);
+	int (*rate_node_rx_pkts_burst_set)(struct devlink_rate *devlink_rate, void *priv,
+					   u64 rx_pkts_burst, struct netlink_ext_ack *extack);
 	int (*rate_node_new)(struct devlink_rate *rate_node, void **priv,
 			     struct netlink_ext_ack *extack);
 	int (*rate_node_del)(struct devlink_rate *rate_node, void *priv,
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 53aad0d09231..4903f7b6dc93 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -224,6 +224,7 @@ enum devlink_rate_type {
 enum devlink_rate_limit_type {
 	DEVLINK_RATE_LIMIT_TYPE_UNSET,
 	DEVLINK_RATE_LIMIT_TYPE_SHAPING,
+	DEVLINK_RATE_LIMIT_TYPE_POLICE,
 };
 
 enum devlink_param_cmode {
@@ -582,6 +583,13 @@ enum devlink_attr {
 	DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES,	/* nested */
 
 	DEVLINK_ATTR_RATE_LIMIT_TYPE,		/* u16 */
+	DEVLINK_ATTR_RATE_TX_BURST,		/* u64 */
+	DEVLINK_ATTR_RATE_RX_MAX,		/* u64 */
+	DEVLINK_ATTR_RATE_RX_BURST,		/* u64 */
+	DEVLINK_ATTR_RATE_TX_PKTS,		/* u64 */
+	DEVLINK_ATTR_RATE_TX_PKTS_BURST,	/* u64 */
+	DEVLINK_ATTR_RATE_RX_PKTS,		/* u64 */
+	DEVLINK_ATTR_RATE_RX_PKTS_BURST,	/* u64 */
 
 	/* add new attributes above here, update the policy in devlink.c */
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 756d95c72b4d..c74cdd0bd44d 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -366,6 +366,12 @@ devlink_rate_is_shaping(struct devlink_rate *devlink_rate)
 	return devlink_rate->limit_type == DEVLINK_RATE_LIMIT_TYPE_SHAPING;
 }
 
+static inline bool
+devlink_rate_is_police(struct devlink_rate *devlink_rate)
+{
+	return devlink_rate->limit_type == DEVLINK_RATE_LIMIT_TYPE_POLICE;
+}
+
 static struct devlink_rate *
 devlink_rate_leaf_get_from_info(struct devlink *devlink, struct genl_info *info)
 {
@@ -1125,6 +1131,31 @@ static int devlink_nl_rate_fill(struct sk_buff *msg,
 		if (nla_put_u64_64bit(msg, DEVLINK_ATTR_RATE_TX_SHARE,
 				      devlink_rate->shaping_attrs.tx_share, DEVLINK_ATTR_PAD))
 			goto nla_put_failure;
+	} else if (devlink_rate_is_police(devlink_rate)) {
+		if (nla_put_u64_64bit(msg, DEVLINK_ATTR_RATE_TX_MAX,
+				      devlink_rate->shaping_attrs.tx_max, DEVLINK_ATTR_PAD))
+			goto nla_put_failure;
+		if (nla_put_u64_64bit(msg, DEVLINK_ATTR_RATE_TX_BURST,
+				      devlink_rate->police_attrs.tx_burst, DEVLINK_ATTR_PAD))
+			goto nla_put_failure;
+		if (nla_put_u64_64bit(msg, DEVLINK_ATTR_RATE_RX_MAX,
+				      devlink_rate->police_attrs.rx_max, DEVLINK_ATTR_PAD))
+			goto nla_put_failure;
+		if (nla_put_u64_64bit(msg, DEVLINK_ATTR_RATE_RX_BURST,
+				      devlink_rate->police_attrs.rx_burst, DEVLINK_ATTR_PAD))
+			goto nla_put_failure;
+		if (nla_put_u64_64bit(msg, DEVLINK_ATTR_RATE_TX_PKTS,
+				      devlink_rate->police_attrs.tx_pkts, DEVLINK_ATTR_PAD))
+			goto nla_put_failure;
+		if (nla_put_u64_64bit(msg, DEVLINK_ATTR_RATE_TX_PKTS_BURST,
+				      devlink_rate->police_attrs.tx_pkts_burst, DEVLINK_ATTR_PAD))
+			goto nla_put_failure;
+		if (nla_put_u64_64bit(msg, DEVLINK_ATTR_RATE_RX_PKTS,
+				      devlink_rate->police_attrs.rx_pkts, DEVLINK_ATTR_PAD))
+			goto nla_put_failure;
+		if (nla_put_u64_64bit(msg, DEVLINK_ATTR_RATE_RX_PKTS_BURST,
+				      devlink_rate->police_attrs.rx_pkts_burst, DEVLINK_ATTR_PAD))
+			goto nla_put_failure;
 	}
 
 	if (devlink_rate->parent)
@@ -1966,7 +1997,110 @@ static int devlink_nl_rate_set(struct devlink_rate *devlink_rate,
 							new_val, info->extack);
 		if (err)
 			return err;
-		devlink_rate->shaping_attrs.tx_max = new_val;
+
+		if (devlink_rate_is_police(devlink_rate))
+			devlink_rate->police_attrs.tx_max = new_val;
+		else
+			devlink_rate->shaping_attrs.tx_max = new_val;
+	}
+
+	if (attrs[DEVLINK_ATTR_RATE_TX_BURST] && devlink_rate_is_police(devlink_rate)) {
+		new_val = nla_get_u64(attrs[DEVLINK_ATTR_RATE_TX_BURST]);
+
+		if (devlink_rate_is_leaf(devlink_rate))
+			err = ops->rate_leaf_tx_burst_set(devlink_rate, devlink_rate->priv,
+							  new_val, info->extack);
+		else if (devlink_rate_is_node(devlink_rate))
+			err = ops->rate_node_tx_burst_set(devlink_rate, devlink_rate->priv,
+							  new_val, info->extack);
+		if (err)
+			return err;
+		devlink_rate->police_attrs.tx_burst = new_val;
+	}
+
+	if (attrs[DEVLINK_ATTR_RATE_RX_MAX] && devlink_rate_is_police(devlink_rate)) {
+		new_val = nla_get_u64(attrs[DEVLINK_ATTR_RATE_RX_MAX]);
+
+		if (devlink_rate_is_leaf(devlink_rate)) {
+			err = ops->rate_leaf_rx_max_set(devlink_rate, devlink_rate->priv,
+							new_val, info->extack);
+		} else if (devlink_rate_is_node(devlink_rate)) {
+			err = ops->rate_node_rx_max_set(devlink_rate, devlink_rate->priv,
+							new_val, info->extack);
+		}
+		if (err)
+			return err;
+		devlink_rate->police_attrs.rx_max = new_val;
+	}
+
+	if (attrs[DEVLINK_ATTR_RATE_RX_BURST] && devlink_rate_is_police(devlink_rate)) {
+		new_val = nla_get_u64(attrs[DEVLINK_ATTR_RATE_RX_BURST]);
+
+		if (devlink_rate_is_leaf(devlink_rate))
+			err = ops->rate_leaf_rx_burst_set(devlink_rate, devlink_rate->priv,
+							new_val, info->extack);
+		else if (devlink_rate_is_node(devlink_rate))
+			err = ops->rate_node_rx_burst_set(devlink_rate, devlink_rate->priv,
+							new_val, info->extack);
+		if (err)
+			return err;
+		devlink_rate->police_attrs.rx_burst = new_val;
+	}
+
+	if (attrs[DEVLINK_ATTR_RATE_TX_PKTS] && devlink_rate_is_police(devlink_rate)) {
+		new_val = nla_get_u64(attrs[DEVLINK_ATTR_RATE_TX_PKTS]);
+
+		if (devlink_rate_is_leaf(devlink_rate))
+			err = ops->rate_leaf_tx_pkts_set(devlink_rate, devlink_rate->priv,
+							new_val, info->extack);
+		else if (devlink_rate_is_node(devlink_rate))
+			err = ops->rate_node_tx_pkts_set(devlink_rate, devlink_rate->priv,
+							new_val, info->extack);
+		if (err)
+			return err;
+		devlink_rate->police_attrs.tx_pkts = new_val;
+	}
+
+	if (attrs[DEVLINK_ATTR_RATE_TX_PKTS_BURST] && devlink_rate_is_police(devlink_rate)) {
+		new_val = nla_get_u64(attrs[DEVLINK_ATTR_RATE_TX_PKTS_BURST]);
+
+		if (devlink_rate_is_leaf(devlink_rate))
+			err = ops->rate_leaf_tx_pkts_burst_set(devlink_rate, devlink_rate->priv,
+							       new_val, info->extack);
+		else if (devlink_rate_is_node(devlink_rate))
+			err = ops->rate_node_tx_pkts_burst_set(devlink_rate, devlink_rate->priv,
+							       new_val, info->extack);
+		if (err)
+			return err;
+		devlink_rate->police_attrs.tx_pkts_burst = new_val;
+	}
+
+	if (attrs[DEVLINK_ATTR_RATE_RX_PKTS] && devlink_rate_is_police(devlink_rate)) {
+		new_val = nla_get_u64(attrs[DEVLINK_ATTR_RATE_RX_PKTS]);
+
+		if (devlink_rate_is_leaf(devlink_rate))
+			err = ops->rate_leaf_rx_pkts_set(devlink_rate, devlink_rate->priv,
+							 new_val, info->extack);
+		else if (devlink_rate_is_node(devlink_rate))
+			err = ops->rate_node_rx_pkts_set(devlink_rate, devlink_rate->priv,
+							 new_val, info->extack);
+		if (err)
+			return err;
+		devlink_rate->police_attrs.rx_pkts = new_val;
+	}
+
+	if (attrs[DEVLINK_ATTR_RATE_RX_PKTS_BURST] && devlink_rate_is_police(devlink_rate)) {
+		new_val = nla_get_u64(attrs[DEVLINK_ATTR_RATE_RX_PKTS_BURST]);
+
+		if (devlink_rate_is_leaf(devlink_rate))
+			err = ops->rate_leaf_rx_pkts_burst_set(devlink_rate, devlink_rate->priv,
+							       new_val, info->extack);
+		else if (devlink_rate_is_node(devlink_rate))
+			err = ops->rate_node_rx_pkts_burst_set(devlink_rate, devlink_rate->priv,
+							       new_val, info->extack);
+		if (err)
+			return err;
+		devlink_rate->police_attrs.rx_pkts_burst = new_val;
 	}
 
 	if (nla_parent)
@@ -1977,7 +2111,12 @@ static int devlink_nl_rate_set(struct devlink_rate *devlink_rate,
 	 */
 	if (devlink_rate_is_leaf(devlink_rate) && !devlink_rate->parent &&
 	    ((devlink_rate_is_shaping(devlink_rate) &&
-	      !devlink_rate->shaping_attrs.tx_max && !devlink_rate->shaping_attrs.tx_share)))
+	      !devlink_rate->shaping_attrs.tx_max && !devlink_rate->shaping_attrs.tx_share) ||
+	     (devlink_rate_is_police(devlink_rate) &&
+	      !devlink_rate->police_attrs.tx_max && !devlink_rate->police_attrs.tx_burst &&
+	      !devlink_rate->police_attrs.rx_max && !devlink_rate->police_attrs.rx_burst &&
+	      !devlink_rate->police_attrs.tx_pkts && !devlink_rate->police_attrs.tx_pkts_burst &&
+	      !devlink_rate->police_attrs.rx_pkts && !devlink_rate->police_attrs.rx_pkts_burst)))
 		devlink_rate->limit_type = DEVLINK_RATE_LIMIT_TYPE_UNSET;
 
 	return err;
@@ -1995,7 +2134,43 @@ static bool devlink_rate_set_ops_supported(const struct devlink_ops *ops,
 			return false;
 		}
 		if (attrs[DEVLINK_ATTR_RATE_TX_MAX] && !ops->rate_leaf_tx_max_set) {
-			NL_SET_ERR_MSG_MOD(info->extack, "TX max set isn't supported for the leafs");
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "TX max set isn't supported for the leafs");
+			return false;
+		}
+		if (attrs[DEVLINK_ATTR_RATE_TX_BURST] && !ops->rate_leaf_tx_burst_set) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "TX burst set isn't supported for the leafs");
+			return false;
+		}
+		if (attrs[DEVLINK_ATTR_RATE_RX_MAX] && !ops->rate_leaf_rx_max_set) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "RX max set isn't supported for the leafs");
+			return false;
+		}
+		if (attrs[DEVLINK_ATTR_RATE_RX_BURST] && !ops->rate_leaf_rx_burst_set) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "RX burst set isn't supported for the leafs");
+			return false;
+		}
+		if (attrs[DEVLINK_ATTR_RATE_TX_PKTS] && !ops->rate_leaf_tx_pkts_set) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "TX pkts set isn't supported for the leafs");
+			return false;
+		}
+		if (attrs[DEVLINK_ATTR_RATE_TX_PKTS_BURST] && !ops->rate_leaf_tx_pkts_burst_set) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "TX pkts burst set isn't supported for the leafs");
+			return false;
+		}
+		if (attrs[DEVLINK_ATTR_RATE_RX_PKTS] && !ops->rate_leaf_rx_pkts_set) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "RX pkts set isn't supported for the leafs");
+			return false;
+		}
+		if (attrs[DEVLINK_ATTR_RATE_RX_PKTS_BURST] && !ops->rate_leaf_rx_pkts_burst_set) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "RX pkts burst set isn't supported for the leafs");
 			return false;
 		}
 		if (attrs[DEVLINK_ATTR_RATE_PARENT_NODE_NAME] &&
@@ -2012,6 +2187,41 @@ static bool devlink_rate_set_ops_supported(const struct devlink_ops *ops,
 			NL_SET_ERR_MSG_MOD(info->extack, "TX max set isn't supported for the nodes");
 			return false;
 		}
+		if (attrs[DEVLINK_ATTR_RATE_TX_BURST] && !ops->rate_node_tx_burst_set) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "TX burst set isn't supported for the nodes");
+			return false;
+		}
+		if (attrs[DEVLINK_ATTR_RATE_RX_MAX] && !ops->rate_node_rx_max_set) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "RX max set isn't supported for the nodes");
+			return false;
+		}
+		if (attrs[DEVLINK_ATTR_RATE_RX_BURST] && !ops->rate_node_rx_burst_set) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "RX burst set isn't supported for the nodes");
+			return false;
+		}
+		if (attrs[DEVLINK_ATTR_RATE_TX_PKTS] && !ops->rate_node_tx_pkts_set) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "TX pkts set isn't supported for the nodes");
+			return false;
+		}
+		if (attrs[DEVLINK_ATTR_RATE_TX_PKTS_BURST] && !ops->rate_node_tx_pkts_burst_set) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "TX pkts burst set isn't supported for the nodes");
+			return false;
+		}
+		if (attrs[DEVLINK_ATTR_RATE_RX_PKTS] && !ops->rate_node_rx_pkts_set) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "RX pkts set isn't supported for the nodes");
+			return false;
+		}
+		if (attrs[DEVLINK_ATTR_RATE_RX_PKTS_BURST] && !ops->rate_node_rx_pkts_burst_set) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "RX pkts burst set isn't supported for the nodes");
+			return false;
+		}
 		if (attrs[DEVLINK_ATTR_RATE_PARENT_NODE_NAME] &&
 		    !ops->rate_node_parent_set) {
 			NL_SET_ERR_MSG_MOD(info->extack, "Parent set isn't supported for the nodes");
@@ -9075,6 +9285,13 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_LINECARD_INDEX] = { .type = NLA_U32 },
 	[DEVLINK_ATTR_LINECARD_TYPE] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_RATE_LIMIT_TYPE] = { .type = NLA_U16 },
+	[DEVLINK_ATTR_RATE_TX_BURST] = { .type = NLA_U64 },
+	[DEVLINK_ATTR_RATE_RX_MAX] = { .type = NLA_U64 },
+	[DEVLINK_ATTR_RATE_RX_BURST] = { .type = NLA_U64 },
+	[DEVLINK_ATTR_RATE_TX_PKTS] = { .type = NLA_U64 },
+	[DEVLINK_ATTR_RATE_TX_PKTS_BURST] = { .type = NLA_U64 },
+	[DEVLINK_ATTR_RATE_RX_PKTS] = { .type = NLA_U64 },
+	[DEVLINK_ATTR_RATE_RX_PKTS_BURST] = { .type = NLA_U64 },
 };
 
 static const struct genl_small_ops devlink_nl_ops[] = {
-- 
2.36.1

