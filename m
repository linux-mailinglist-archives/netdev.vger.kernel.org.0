Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12842552126
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 17:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234290AbiFTPgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 11:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234214AbiFTPgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 11:36:20 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2066.outbound.protection.outlook.com [40.107.96.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AFB513F43
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 08:36:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZMOhHFfJuCwIDdQh03g5lqVXfOYpccoXnWVwtgWfakmjuf3+2WMOVQ+zqeIroLEHHUVR/4SKIgSZpzz4N5IOErafHAFM6Svc9Tnc4rna8Z96XFn8gxsK2etIghieLaTk/dz/xabLryG/pal+CsyJSAlPv8TcgkHZUdT1PQdmGQhnxbrBfDduH0SwaZr1xiaW8dmUAXBZFJwAgPeonxxqGdNigYGUOfXTT6AcMwq3KgzSksv8u5+YShCI7WkRW5d7sWGdEoOXXMC4mla03RlPV5A3A/wEGBPZz3nDBspiLZTibjGXKmhsDbG368/+lTO6zezMH3IrAZUYFa3YJHymUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1WB9MNBRakqtJg3ee9T+zOJzE0z6QQcjQhFgwK6deJ8=;
 b=L7hR24rxEMm5Mu/9vofhYDuzmdvOTMu/OLpSHs9WZWgcCxpI/ik6cbCf4U7gnMnFzzlkRn3MR3kM76Suud1zxHJffD7yYwLnSIgClpk+tUNclct/Rgo6eKKxgzQNCSMWnwxQQJBbCFXZDJimGxZ1I59HhZLF/iDy+ifktIr8qMxxeRG1BbJd/NKe+PEk6kTwxc7t9RuKuIudg3pAtKPzlhJrGF5e53MhwH6y3ttrD2c76urzHbPFHrbj9SHa8hajCZIGV5fTc7Ayhq+WCvduCTg+/w6qZGD8ZEK71k4t/RGfgxvg8WujZhKJm3DJEzkEI/HqJWKauTJNcDtPTKDLSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1WB9MNBRakqtJg3ee9T+zOJzE0z6QQcjQhFgwK6deJ8=;
 b=Rbk48jwXGbW+4EcoYBrUYligdyHlbZiN0zPuC70t0fwfOjb2eV7m702cRUXhMsEVvb1V2JTWwXj+L4up8iI1VbiAlXOkCkhQ0J1L5Z7+K/pFwynZrLe3jpFhQVR1wP8YTfb8nxVeqPyWq/lD8C5M49bl4qLdoX265OJ2Gy4LQie+7ME2eAJogXW7hddms93FT4A0PABTYRXJjTznNY5+RFrmXyXZyiuXRikeD1BbIFZ7FzDUkPtwDbDKophI4f54VS9oy41dwiBYid/Xvx5LK7397kgWev7DyujDP+YiCogZfvyTYJknqzhVIpmSClUu639eTzJJXefTISH6q3tkCw==
Received: from DM5PR15CA0031.namprd15.prod.outlook.com (2603:10b6:4:4b::17) by
 CY5PR12MB6430.namprd12.prod.outlook.com (2603:10b6:930:3a::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.15; Mon, 20 Jun 2022 15:36:17 +0000
Received: from DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:4b:cafe::92) by DM5PR15CA0031.outlook.office365.com
 (2603:10b6:4:4b::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.22 via Frontend
 Transport; Mon, 20 Jun 2022 15:36:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT052.mail.protection.outlook.com (10.13.172.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 15:36:17 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Mon, 20 Jun 2022 15:36:17 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 20 Jun 2022 08:36:16 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Mon, 20 Jun 2022 08:36:14 -0700
From:   Dima Chumak <dchumak@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Paolo Abeni" <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Dima Chumak <dchumak@nvidia.com>
Subject: [PATCH iproute2-next 2/5] devlink: Add port rate limit_type support
Date:   Mon, 20 Jun 2022 18:35:52 +0300
Message-ID: <20220620153555.2504178-2-dchumak@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220620152647.2498927-1-dchumak@nvidia.com>
References: <20220620152647.2498927-1-dchumak@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a63eb24d-9fb4-45c7-dd07-08da52d29e45
X-MS-TrafficTypeDiagnostic: CY5PR12MB6430:EE_
X-Microsoft-Antispam-PRVS: <CY5PR12MB64305ABF267CE6B43418D3BFD5B09@CY5PR12MB6430.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lxcXcrpouk6U4ycc9Ehs1/qgdth9hoGE+UMRskNg0SSclAN21FUJLQiIxAwccTowcusc1jx7bTgL93S5gRRHXAoGXdnAc8H01+HA3JoVcWkh5/GILgmiF76+QgjL1C3NcldnPwRulgmKeRDBsD9NPp1rHUXp+PzHjN0XPY7DYcQbrxw1aSLtS7PhSpEbYQXYpptizvngno57nWqjl9GbrDwZ51ks5Eb0zNI5SWBI9wmdU3JcVpYzgb85LXGoGqxpa70cM59P+7lNNvaGf55T/Dyl3ge4anRKIfASBBzmerc2KObz4yRVAWVFhNBbsgOdkwNrdsZnhqzWaas+wqy8nfYi0bXa+olp/MegvXh5IDkWVIqo2W5RX9QecHjDfNzn0Ophkp15IIvAi1ytocJKdQyE5rmXlXTfsyQQZEVnKx53J0CGhynz5UIAqPzwxI4L6lpwNebMICOgBNiCmywq9VSeBn5ak23ltWOjgKGoiAnZytEP0hR6+5AypK++CTRvsZAnRckAPSapjentJCEHTkU0cZLSzm/+I+wDp4LDbvDSQmUElxAx11jjtb9TUmIL3+4oqvPCRm6cRcabuzHUuY6uRo064z7Emtej2OaM6GwOiE6niBYX5O4sBfEOjFNCxXjpvckHYntf4bbCmI0Y52bhKse/iBKPpz38ala2Y7jW4UEGEgb4T3Nc5XTO31c6kuH+7uhT1ZimRAsYzxTC3w==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(36840700001)(46966006)(40470700004)(8936002)(6666004)(70206006)(1076003)(26005)(54906003)(36860700001)(86362001)(336012)(8676002)(70586007)(36756003)(2616005)(5660300002)(83380400001)(426003)(2906002)(40460700003)(498600001)(81166007)(186003)(82310400005)(356005)(4326008)(107886003)(47076005)(7696005)(110136005)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 15:36:17.6772
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a63eb24d-9fb4-45c7-dd07-08da52d29e45
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6430
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend existing `devlink port func rate {set|add}` CLI with a new
parameter 'limit_type'. It specifies differnt kinds of rate limiting
that may be supported by a driver.

The parameter is optional and the only value it can take as of now is
'shaping', which is just a name for the existing rate limiting
mechanism.

It lays a foundation to adding other limit types. Following patches in
the series introduce new limit_type 'police'.

Signed-off-by: Dima Chumak <dchumak@nvidia.com>
---
 devlink/devlink.c       | 121 ++++++++++++++++++++++++++++++++++------
 man/man8/devlink-rate.8 |  17 ++++++
 2 files changed, 120 insertions(+), 18 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index ddf430bbb02a..9b234f2a6825 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -294,6 +294,7 @@ static void ifname_map_free(struct ifname_map *ifname_map)
 #define DL_OPT_PORT_FN_RATE_TX_MAX	BIT(49)
 #define DL_OPT_PORT_FN_RATE_NODE_NAME	BIT(50)
 #define DL_OPT_PORT_FN_RATE_PARENT	BIT(51)
+#define DL_OPT_PORT_FN_RATE_LIMIT_TYPE	BIT(52)
 
 struct dl_opts {
 	uint64_t present; /* flags of present items */
@@ -354,6 +355,7 @@ struct dl_opts {
 	uint64_t rate_tx_max;
 	char *rate_node_name;
 	const char *rate_parent_node;
+	uint16_t rate_limit_type;
 };
 
 struct dl {
@@ -1438,6 +1440,17 @@ static int port_fn_rate_type_get(const char *typestr, uint16_t *type)
 	return 0;
 }
 
+static int port_fn_rate_limit_type_get(const char *ltypestr, uint16_t *ltype)
+{
+	if (!strcmp(ltypestr, "unset"))
+		*ltype = DEVLINK_RATE_LIMIT_TYPE_UNSET;
+	else if (!strcmp(ltypestr, "shaping"))
+		*ltype = DEVLINK_RATE_LIMIT_TYPE_SHAPING;
+	else
+		return -EINVAL;
+	return 0;
+}
+
 static int port_fn_rate_value_get(struct dl *dl, uint64_t *rate)
 {
 	const char *ratestr;
@@ -1982,6 +1995,18 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 			if (err)
 				return err;
 			o_found |= DL_OPT_PORT_FN_RATE_TYPE;
+		} else if (dl_argv_match(dl, "limit_type") &&
+			   (o_all & DL_OPT_PORT_FN_RATE_LIMIT_TYPE)) {
+			const char *ltypestr;
+
+			dl_arg_inc(dl);
+			err = dl_argv_str(dl, &ltypestr);
+			if (err)
+				return err;
+			err = port_fn_rate_limit_type_get(ltypestr, &opts->rate_limit_type);
+			if (err)
+				return err;
+			o_found |= DL_OPT_PORT_FN_RATE_LIMIT_TYPE;
 		} else if (dl_argv_match(dl, "tx_share") &&
 			   (o_all & DL_OPT_PORT_FN_RATE_TX_SHARE)) {
 			dl_arg_inc(dl);
@@ -2212,6 +2237,9 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 	if (opts->present & DL_OPT_PORT_FN_RATE_TYPE)
 		mnl_attr_put_u16(nlh, DEVLINK_ATTR_RATE_TYPE,
 				 opts->rate_type);
+	if (opts->present & DL_OPT_PORT_FN_RATE_LIMIT_TYPE)
+		mnl_attr_put_u16(nlh, DEVLINK_ATTR_RATE_LIMIT_TYPE,
+				 opts->rate_limit_type);
 	if (opts->present & DL_OPT_PORT_FN_RATE_TX_SHARE)
 		mnl_attr_put_u64(nlh, DEVLINK_ATTR_RATE_TX_SHARE,
 				 opts->rate_tx_share);
@@ -4487,8 +4515,21 @@ static char *port_rate_type_name(uint16_t type)
 	}
 }
 
+static char *port_rate_limit_type_name(uint16_t ltype)
+{
+	switch (ltype) {
+	case DEVLINK_RATE_LIMIT_TYPE_UNSET:
+		return "unset";
+	case DEVLINK_RATE_LIMIT_TYPE_SHAPING:
+		return "shaping";
+	default:
+		return "<unknown type>";
+	}
+}
+
 static void pr_out_port_fn_rate(struct dl *dl, struct nlattr **tb)
 {
+	uint16_t ltype = DEVLINK_RATE_LIMIT_TYPE_UNSET;
 
 	if (!tb[DEVLINK_ATTR_RATE_NODE_NAME])
 		pr_out_port_handle_start(dl, tb, false);
@@ -4503,7 +4544,14 @@ static void pr_out_port_fn_rate(struct dl *dl, struct nlattr **tb)
 		print_string(PRINT_ANY, "type", "type %s",
 				port_rate_type_name(type));
 	}
-	if (tb[DEVLINK_ATTR_RATE_TX_SHARE]) {
+	if (tb[DEVLINK_ATTR_RATE_LIMIT_TYPE]) {
+		ltype = mnl_attr_get_u16(tb[DEVLINK_ATTR_RATE_LIMIT_TYPE]);
+
+		print_string(PRINT_ANY, "limit_type", " limit_type %s",
+				port_rate_limit_type_name(ltype));
+	}
+	if (tb[DEVLINK_ATTR_RATE_TX_SHARE] &&
+	    ltype == DEVLINK_RATE_LIMIT_TYPE_SHAPING) {
 		uint64_t rate =
 			mnl_attr_get_u64(tb[DEVLINK_ATTR_RATE_TX_SHARE]);
 
@@ -4550,10 +4598,10 @@ static void cmd_port_fn_rate_help(void)
 	pr_err("Usage: devlink port function rate help\n");
 	pr_err("       devlink port function rate show [ DEV/{ PORT_INDEX | NODE_NAME } ]\n");
 	pr_err("       devlink port function rate add DEV/NODE_NAME\n");
-	pr_err("               [ tx_share VAL ][ tx_max VAL ][ { parent NODE_NAME | noparent } ]\n");
+	pr_err("               [ limit_type shaping ][ tx_share VAL ][ tx_max VAL ][ { parent NODE_NAME | noparent } ]\n");
 	pr_err("       devlink port function rate del DEV/NODE_NAME\n");
 	pr_err("       devlink port function rate set DEV/{ PORT_INDEX | NODE_NAME }\n");
-	pr_err("               [ tx_share VAL ][ tx_max VAL ][ { parent NODE_NAME | noparent } ]\n\n");
+	pr_err("               [ limit_type shaping ][ tx_share VAL ][ tx_max VAL ][ { parent NODE_NAME | noparent } ]\n\n");
 	pr_err("       VAL - float or integer value in units of bits or bytes per second (bit|bps)\n");
 	pr_err("       and SI (k-, m-, g-, t-) or IEC (ki-, mi-, gi-, ti-) case-insensitive prefix.\n");
 	pr_err("       Bare number, means bits per second, is possible.\n\n");
@@ -4604,18 +4652,22 @@ static int port_fn_get_and_check_tx_rates(struct dl_opts *reply,
 	return port_fn_check_tx_rates(min, request->rate_tx_max);
 }
 
-static int cmd_port_fn_rate_add(struct dl *dl)
+static int port_rate_shaping_add(struct dl *dl)
 {
 	struct nlmsghdr *nlh;
 	int err;
 
+	if ((dl->opts.present & DL_OPT_PORT_FN_RATE_TX_SHARE) &&
+	    (dl->opts.present & DL_OPT_PORT_FN_RATE_TX_MAX)) {
+		err = port_fn_check_tx_rates(dl->opts.rate_tx_share,
+					     dl->opts.rate_tx_max);
+		if (err)
+			return err;
+	}
+
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_RATE_NEW,
 					  NLM_F_REQUEST | NLM_F_ACK);
-	err = dl_argv_parse_put(nlh, dl, DL_OPT_PORT_FN_RATE_NODE_NAME,
-				DL_OPT_PORT_FN_RATE_TX_SHARE |
-				DL_OPT_PORT_FN_RATE_TX_MAX);
-	if (err)
-		return err;
+	dl_opts_put(nlh, dl);
 
 	if ((dl->opts.present & DL_OPT_PORT_FN_RATE_TX_SHARE) &&
 	    (dl->opts.present & DL_OPT_PORT_FN_RATE_TX_MAX)) {
@@ -4628,6 +4680,27 @@ static int cmd_port_fn_rate_add(struct dl *dl)
 	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
 
+#define RATE_SHAPING_OPTS	(DL_OPT_PORT_FN_RATE_TX_SHARE)
+
+static int cmd_port_fn_rate_add(struct dl *dl)
+{
+	int err;
+
+	err = dl_argv_parse(dl, DL_OPT_PORT_FN_RATE_NODE_NAME,
+			    DL_OPT_PORT_FN_RATE_LIMIT_TYPE | DL_OPT_PORT_FN_RATE_TX_MAX |
+			    RATE_SHAPING_OPTS);
+	if (err)
+		return err;
+
+	if (!(dl->opts.present & DL_OPT_PORT_FN_RATE_LIMIT_TYPE)) {
+		dl->opts.rate_limit_type = DEVLINK_RATE_LIMIT_TYPE_SHAPING;
+		dl->opts.present |= DL_OPT_PORT_FN_RATE_LIMIT_TYPE;
+	}
+
+
+	return port_rate_shaping_add(dl);
+}
+
 static int cmd_port_fn_rate_del(struct dl *dl)
 {
 	struct nlmsghdr *nlh;
@@ -4664,20 +4737,12 @@ static int port_fn_get_rates_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 }
 
-static int cmd_port_fn_rate_set(struct dl *dl)
+static int port_rate_shaping_set(struct dl *dl)
 {
 	struct dl_opts tmp_opts = {0};
 	struct nlmsghdr *nlh;
 	int err;
 
-	err = dl_argv_parse(dl, DL_OPT_HANDLEP |
-				DL_OPT_PORT_FN_RATE_NODE_NAME,
-				DL_OPT_PORT_FN_RATE_TX_SHARE |
-				DL_OPT_PORT_FN_RATE_TX_MAX |
-				DL_OPT_PORT_FN_RATE_PARENT);
-	if (err)
-		return err;
-
 	if ((dl->opts.present & DL_OPT_PORT_FN_RATE_TX_SHARE) &&
 	    (dl->opts.present & DL_OPT_PORT_FN_RATE_TX_MAX)) {
 		err = port_fn_check_tx_rates(dl->opts.rate_tx_share,
@@ -4709,6 +4774,26 @@ static int cmd_port_fn_rate_set(struct dl *dl)
 	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
 }
 
+static int cmd_port_fn_rate_set(struct dl *dl)
+{
+	int err;
+
+	err = dl_argv_parse(dl, DL_OPT_HANDLEP | DL_OPT_PORT_FN_RATE_NODE_NAME,
+			    DL_OPT_PORT_FN_RATE_LIMIT_TYPE | DL_OPT_PORT_FN_RATE_TX_MAX |
+			    RATE_SHAPING_OPTS | DL_OPT_PORT_FN_RATE_PARENT);
+	if (err)
+		return err;
+
+	if (!(dl->opts.present & DL_OPT_PORT_FN_RATE_LIMIT_TYPE) &&
+	    !(dl->opts.present & DL_OPT_PORT_FN_RATE_PARENT)) {
+		dl->opts.rate_limit_type = DEVLINK_RATE_LIMIT_TYPE_SHAPING;
+		dl->opts.present |= DL_OPT_PORT_FN_RATE_LIMIT_TYPE;
+	}
+
+
+	return port_rate_shaping_set(dl);
+}
+
 static int cmd_port_function_rate(struct dl *dl)
 {
 	if (dl_argv_match(dl, "help")) {
diff --git a/man/man8/devlink-rate.8 b/man/man8/devlink-rate.8
index cc2f50c38619..6b7b179a8696 100644
--- a/man/man8/devlink-rate.8
+++ b/man/man8/devlink-rate.8
@@ -24,12 +24,16 @@ devlink-rate \- devlink rate management
 .ti -8
 .B devlink port function rate set
 .RI "{ " DEV/PORT_INDEX " | " DEV/NODE_NAME " } "
+.RB "{"
+.RB [ " limit_type \fIshaping " ]
 .RB [ " tx_share \fIVALUE " ]
 .RB [ " tx_max \fIVALUE " ]
 .RB "[ {" " parent \fINODE_NAME " | " noparent " "} ]"
 
 .ti -8
 .BI "devlink port function rate add " DEV/NODE_NAME
+.RB "{"
+.RB [ " limit_type \fIshaping " ]
 .RB [ " tx_share \fIVALUE " ]
 .RB [ " tx_max \fIVALUE " ]
 .RB "[ {" " parent \fINODE_NAME " | " noparent " "} ]"
@@ -76,6 +80,19 @@ the last occurrence is used.
 .I DEV/NODE_NAME
 - specifies devlink node rate object.
 .PP
+.BR limit_type " \fIshaping "
+- specifies a kind of rate limiting. The parameter is optional and, if omitted,
+\fIshaping\fR limit type is assumed by default. Each limit type has its own set
+of supported attributes. Some limit types may not be supported by a particular
+driver's implementation. At a high level, \fBlimit_type\fR definition is:
+.PP
+.I shaping
+- limiting traffic rate by using a back pressure mechanism, that can delay
+traffic until there is a capacity, available at the lower level, to process it.
+This type of rate limiting doesn't require packets to be dropped in order to
+ensure the requested rate, on the other hand it may suffer from excessive delays
+and it cannot be applied to inbound traffic.
+.PP
 .BI tx_share " VALUE"
 - specifies minimal tx rate value shared among all rate objects. If rate object
 is a part of some rate group, then this value shared with rate objects of this
-- 
2.36.1

