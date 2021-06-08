Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB88D39F4DB
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 13:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbhFHLYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 07:24:48 -0400
Received: from mail-dm6nam10on2057.outbound.protection.outlook.com ([40.107.93.57]:45952
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231460AbhFHLYr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 07:24:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lnq/xjAcBLSq9W0db02TjfvgOkVjIpm0PcxrEXI9acPHKu6uwINnWpaPTwpzD8piYB622cc+cTUePrzvem/jlMqt2uO7kFZARCwKo8hpvAgE+br13V5n5riXK9fQUjuQkT1oiEo2NWmDHDUKP9gxmKElODWiY5AVcneJTEwblVp17q5kVFzyUM0Av5Q+c6eQNw3+NGOXQiQn0UrFxzLeGUts6VfNHYH5NCwJrbCS8dTw5dTDYLKQf+rrUDNEeL8Crz0bkTiF9P++NZm0Nukj1eYn1SSK8QGpKO84Hdty8C4jm2HnHRXzr6tvpwuTb25u/3gvZDCkBF0X+uQOAHUjaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NxtWDpRNfCFTf/LQrQNV/gVVQg7wchz5R7UKQ4HYqYQ=;
 b=c0PxEfFDRw+07ZlzdK0ktVQW2JcMTX66AZrPzflwz1eJ004NddzYNTudx5+MY16jPrIc2uicY5NirYHeQy69Qdl1wosAMV0aV2Gf5/RfVHOEjSfy5FKwvDb5ly8jFVLO7vkHuXYHq3/9LJ9Pvam1gtXzfHWRqCltgrqieIZCp9g98UrsCVjtgJHQdR9XGpCo0N1Tu6NUSH8T//FBGFVdqJkFDqjJShpy8eh4fBZ5KYg77DhA8y/StPQTrqge8+Edgmcj3EpMi/QQl+EEzE3sqU+UgaYgiDLSCRoKKPTlOJSOw2i20N3NBhEcRoETnqPgq9Tt//ndc+5PzfeI7auIhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NxtWDpRNfCFTf/LQrQNV/gVVQg7wchz5R7UKQ4HYqYQ=;
 b=HYgfYirQ5q2sRz/lhA6gLZA1JBrcZ1NCVKReMmmT3FxWag3jNcHzjcNsB69skL3Wc61UCfVRWYJHJoA91I8DtH1n6QSVbziMuRFoBSpJ1900b1fVI3HcG9VpTQFnniG0hCcigBPum7X5LeEoQzTrjWhCRvbRisr2FwFyon5HgJ9b/jXPiIcnrWixvacnbcV+uF6Q+3cYr9CM9wniTyobwDcN3QFJpibLIJyngqEnLneHpvuRrj1Udv4hcGBR/FZqyZBAHIPWHBxiYktLVS7PTeCa9TIwqCnia6bG/VVwkaDtkfEgTFcid1LxkE3umKdL2mstYmoF0Rafwd025hsjKg==
Received: from DM5PR04CA0058.namprd04.prod.outlook.com (2603:10b6:3:ef::20) by
 BY5PR12MB5509.namprd12.prod.outlook.com (2603:10b6:a03:1d7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Tue, 8 Jun
 2021 11:22:53 +0000
Received: from DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ef:cafe::e7) by DM5PR04CA0058.outlook.office365.com
 (2603:10b6:3:ef::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend
 Transport; Tue, 8 Jun 2021 11:22:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT035.mail.protection.outlook.com (10.13.172.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Tue, 8 Jun 2021 11:22:53 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 8 Jun
 2021 11:22:51 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 8 Jun 2021 11:22:49 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <dsahern@gmail.com>, <stephen@networkplumber.org>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        <dlinkin@nvidia.com>
Subject: [PATCH RESEND iproute2 net-next 3/4] devlink: Add port func rate support
Date:   Tue, 8 Jun 2021 14:22:33 +0300
Message-ID: <1623151354-30930-4-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1623151354-30930-1-git-send-email-dlinkin@nvidia.com>
References: <1623151354-30930-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 255f72c7-0240-46e3-e7ca-08d92a6fc1d3
X-MS-TrafficTypeDiagnostic: BY5PR12MB5509:
X-Microsoft-Antispam-PRVS: <BY5PR12MB55092392C799051D45765754CB379@BY5PR12MB5509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Grg2ONbGjCx3tTAySFaYn+31r+eslYQQ/6SrOJjY914CdHpvaScNPOERtSacYUd5EMMjSyxOG6UtCL6o/OKm7FXLvNmkYneOV4QiUWN1MpfRnB4uH4svw8A9SAp4+7mnqo70EN90l1KsRBNyLF3ZLeBgmUCI6VMaThCVlZhTJmBEMLkHD5gDyUBSQ1+lhihWkZATsISp8RNU68ciRL4tFFp2yRKkSwo7DoV3bSarlrhOoPkTSfMsZrWtAfPgDr/4H39ieZEpkTnQJ2q4HcK4CkBvn16Egizuyz/TTWLId7W7w+PoMkP28HQhj/b0mQhvx8njN7QpohJPX52pA6nG59ZyyItXPeR+NpvPYYf0ynBqiXgRUPA1Gv1djD9y0lvRtLbqVzl5YAe1dmnNTG2atlJt5xrKdodLsDyO2Nkq/5oyBZSy/Ewr/B8/I6ApjOQyitXhx8HNhgdXGQz04wCgBjYaunS58QhlJLRQG5xOckRRB9lwgr1E+FHW8Ccd8Jfv/Yo1DjcGW3Q9X6vADM9QtqlsLS9LeBK0wgIXkObrTN3IuxTIRCFNBZja+XWHY//phmCT7/AkA6kcrHO7/E3HzSCOZMegd0vnR5BOGcI1MbgsEfM1OC1sZKll0V9HuPIZh74K2BEOoroVROXK0ik0T9JJXkrUiXsa/Yjd7fRpUjw=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(39860400002)(396003)(36840700001)(46966006)(36860700001)(26005)(6916009)(36906005)(186003)(7696005)(36756003)(2876002)(70586007)(47076005)(478600001)(8676002)(82740400003)(426003)(2616005)(107886003)(82310400003)(54906003)(5660300002)(356005)(7636003)(2906002)(4326008)(316002)(30864003)(8936002)(70206006)(6666004)(86362001)(336012)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 11:22:53.0153
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 255f72c7-0240-46e3-e7ca-08d92a6fc1d3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB5509
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Implement user commands to manage devlink port func rate objects.
List all rate commands:

    $ devlink port func rate help

or just

    $ devlink port func rate

To list all OR particular rate object:

    $ devlink port func rate show
    pci/0000:03:00.0/some_group: type node
    pci/0000:03:00.0/0: type leaf
    pci/0000:03:00.0/1: type leaf

    $ devlink prot func rate show pci/0000:03:00.0/1
    pci/0000:03:00.0/0: type leaf

    $ devlink prot func rate show pci/0000:03:00.0/some_group
    pci/0000:03:00.0/some_group: type node

Rate object of type "leaf" created by it's driver where name is the name
of corresponding devlink port. Rate object of type "node" represents
rate group created by the user using commands:

    $ devlink port func rate add pci/0000:03:00.0/some_group

or with defining tx rate limits

    $ devlink port func rate add pci/0000:03:00.0/some_group \
        tx_shara 10kbit tx_max 100mbit

NOTE: node name cannot be a decimal value because it conflicts with
devlink port indexes.

To delete node object:

    $ devlink port func rate del pci/0000:03:00.0/some_group

Set rate limits of existing rate object:

    $ devlink prot func rate set pci/0000:03:00.0/0 \
        tx_share 5MBps tx_max 25GBps

    $ devlink prot func rate set pci/0000:03:00.0/some_group \
        tx_share 0

Both SET and ADD commands accept any units of rates defined in IEC
60027-2 standard.

NOTE: rate value 0 means that rate is unlimited. Such value is also
ommited in show command output.

NOTE: In SHOW command output rate values will be printed with suffixes
as well, but in JSON output they are always units of Bps.

Set or unset parent of existing rate object:

    $ devlink prot func rate set pci/0000:03:00.0/0 parent some_group

    $ devlink port func rate set pci/0000:03:00.0/0 noparent

NOTE: Setting parent to empty ("") name due to kernel logic means unset
parent and shouldn't be used to avoid unexpected parent unsets.

Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 devlink/devlink.c       | 489 ++++++++++++++++++++++++++++++++++++++++++++++--
 man/man8/devlink-port.8 |   8 +
 man/man8/devlink-rate.8 | 256 +++++++++++++++++++++++++
 3 files changed, 738 insertions(+), 15 deletions(-)
 create mode 100644 man/man8/devlink-rate.8

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 5b6f059..f75a707 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -286,6 +286,11 @@ static void ifname_map_free(struct ifname_map *ifname_map)
 #define DL_OPT_PORT_PFNUMBER BIT(43)
 #define DL_OPT_PORT_SFNUMBER BIT(44)
 #define DL_OPT_PORT_FUNCTION_STATE BIT(45)
+#define DL_OPT_PORT_FN_RATE_TYPE	BIT(46)
+#define DL_OPT_PORT_FN_RATE_TX_SHARE	BIT(47)
+#define DL_OPT_PORT_FN_RATE_TX_MAX	BIT(48)
+#define DL_OPT_PORT_FN_RATE_NODE_NAME	BIT(49)
+#define DL_OPT_PORT_FN_RATE_PARENT	BIT(50)
 
 struct dl_opts {
 	uint64_t present; /* flags of present items */
@@ -340,6 +345,11 @@ struct dl_opts {
 	uint16_t port_flavour;
 	uint16_t port_pfnumber;
 	uint8_t port_fn_state;
+	uint16_t rate_type;
+	uint64_t rate_tx_share;
+	uint64_t rate_tx_max;
+	char *rate_node_name;
+	const char *rate_parent_node;
 };
 
 struct dl {
@@ -1060,38 +1070,103 @@ static int dl_argv_handle_both(struct dl *dl, char **p_bus_name,
 	return 0;
 }
 
-static int __dl_argv_handle_region(char *str, char **p_bus_name,
-				   char **p_dev_name, char **p_region)
+static int __dl_argv_handle_name(char *str, char **p_bus_name,
+				 char **p_dev_name, char **p_name)
 {
 	char *handlestr;
 	int err;
 
-	err = str_split_by_char(str, &handlestr, p_region, '/');
-	if (err) {
-		pr_err("Region identification \"%s\" is invalid\n", str);
+	err = str_split_by_char(str, &handlestr, p_name, '/');
+	if (err)
 		return err;
-	}
-	err = str_split_by_char(handlestr, p_bus_name, p_dev_name, '/');
-	if (err) {
-		pr_err("Region identification \"%s\" is invalid\n", str);
-		return err;
-	}
-	return 0;
+
+	return str_split_by_char(handlestr, p_bus_name, p_dev_name, '/');
 }
 
 static int dl_argv_handle_region(struct dl *dl, char **p_bus_name,
-					char **p_dev_name, char **p_region)
+				 char **p_dev_name, char **p_region)
 {
 	char *str = dl_argv_next(dl);
 	int err;
 
 	err = ident_str_validate(str, 2);
 	if (err) {
-		pr_err("Expected \"bus_name/dev_name/region\" identification.\n"".\n");
+		pr_err("Expected \"bus_name/dev_name/region\" identification.\n");
 		return err;
 	}
 
-	return __dl_argv_handle_region(str, p_bus_name, p_dev_name, p_region);
+	err = __dl_argv_handle_name(str, p_bus_name, p_dev_name, p_region);
+	if (err)
+		pr_err("Region identification \"%s\" is invalid\n", str);
+	return err;
+}
+
+
+static int dl_argv_handle_rate_node(struct dl *dl, char **p_bus_name,
+				    char **p_dev_name, char **p_node)
+{
+	char *str = dl_argv_next(dl);
+	int err;
+
+	err = ident_str_validate(str, 2);
+	if (err) {
+		pr_err("Expected \"bus_name/dev_name/node\" identification.\n");
+		return err;
+	}
+
+	err = __dl_argv_handle_name(str, p_bus_name, p_dev_name, p_node);
+	if (err) {
+		pr_err("Node identification \"%s\" is invalid\n", str);
+		return err;
+	}
+
+	if (!**p_node || strspn(*p_node, "0123456789") == strlen(*p_node)) {
+		err = -EINVAL;
+		pr_err("Node name cannot be a devlink port index or empty.\n");
+	}
+
+	return err;
+}
+
+static int dl_argv_handle_rate(struct dl *dl, char **p_bus_name,
+			       char **p_dev_name, uint32_t *p_port_index,
+			       char **p_node_name, uint64_t *p_handle_bit)
+{
+	char *str = dl_argv_next(dl);
+	char *identifier;
+	int err;
+
+	err = ident_str_validate(str, 2);
+	if (err) {
+		pr_err("Expected \"bus_name/dev_name/node\" or "
+		       "\"bus_name/dev_name/port_index\" identification.\n");
+		return err;
+	}
+
+	err = __dl_argv_handle_name(str, p_bus_name, p_dev_name, &identifier);
+	if (err) {
+		pr_err("Identification \"%s\" is invalid\n", str);
+		return err;
+	}
+
+	if (!*identifier) {
+		pr_err("Identifier cannot be empty");
+		return -EINVAL;
+	}
+
+	if (strspn(identifier, "0123456789") == strlen(identifier)) {
+		err = strtouint32_t(identifier, p_port_index);
+		if (err) {
+			pr_err("Port index \"%s\" is not a number"
+			       " or not within range\n", identifier);
+			return err;
+		}
+		*p_handle_bit = DL_OPT_HANDLEP;
+	} else {
+		*p_handle_bit = DL_OPT_PORT_FN_RATE_NODE_NAME;
+		*p_node_name = identifier;
+	}
+	return 0;
 }
 
 static int dl_argv_uint64_t(struct dl *dl, uint64_t *p_val)
@@ -1403,6 +1478,36 @@ static int port_fn_state_parse(const char *statestr, uint8_t *state)
 	return 0;
 }
 
+static int port_fn_rate_type_get(const char *typestr, uint16_t *type)
+{
+	if (!strcmp(typestr, "leaf"))
+		*type = DEVLINK_RATE_TYPE_LEAF;
+	else if (!strcmp(typestr, "node"))
+		*type = DEVLINK_RATE_TYPE_NODE;
+	else
+		return -EINVAL;
+	return 0;
+}
+
+static int port_fn_rate_value_get(struct dl *dl, uint64_t *rate)
+{
+	const char *ratestr;
+	__u64 rate64;
+	int err;
+
+	err = dl_argv_str(dl, &ratestr);
+	if (err)
+		return err;
+	err = get_rate64(&rate64, ratestr);
+	if (err) {
+		pr_err("Invalid rate value: \"%s\"\n", ratestr);
+		return -EINVAL;
+	}
+
+	*rate = rate64;
+	return 0;
+}
+
 struct dl_args_metadata {
 	uint64_t o_flag;
 	char err_msg[DL_ARGS_REQUIRED_MAX_ERR_LEN];
@@ -1475,6 +1580,19 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 			return err;
 		o_required &= ~(DL_OPT_HANDLE | DL_OPT_HANDLEP) | handle_bit;
 		o_found |= handle_bit;
+	} else if (o_required & DL_OPT_HANDLEP &&
+		   o_required & DL_OPT_PORT_FN_RATE_NODE_NAME) {
+		uint64_t handle_bit;
+
+		err = dl_argv_handle_rate(dl, &opts->bus_name, &opts->dev_name,
+					  &opts->port_index,
+					  &opts->rate_node_name,
+					  &handle_bit);
+		if (err)
+			return err;
+		o_required &= ~(DL_OPT_HANDLEP | DL_OPT_PORT_FN_RATE_NODE_NAME) |
+			handle_bit;
+		o_found |= handle_bit;
 	} else if (o_required & DL_OPT_HANDLE) {
 		err = dl_argv_handle(dl, &opts->bus_name, &opts->dev_name);
 		if (err)
@@ -1493,6 +1611,13 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 		if (err)
 			return err;
 		o_found |= DL_OPT_HANDLE_REGION;
+	} else if (o_required & DL_OPT_PORT_FN_RATE_NODE_NAME) {
+		err = dl_argv_handle_rate_node(dl, &opts->bus_name,
+					       &opts->dev_name,
+					       &opts->rate_node_name);
+		if (err)
+			return err;
+		o_found |= DL_OPT_PORT_FN_RATE_NODE_NAME;
 	}
 
 	while (dl_argc(dl)) {
@@ -1890,6 +2015,44 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 			if (err)
 				return err;
 			o_found |= DL_OPT_PORT_SFNUMBER;
+		} else if (dl_argv_match(dl, "type") &&
+			   (o_all & DL_OPT_PORT_FN_RATE_TYPE)) {
+			const char *typestr;
+
+			dl_arg_inc(dl);
+			err = dl_argv_str(dl, &typestr);
+			if (err)
+				return err;
+			err = port_fn_rate_type_get(typestr, &opts->rate_type);
+			if (err)
+				return err;
+			o_found |= DL_OPT_PORT_FN_RATE_TYPE;
+		} else if (dl_argv_match(dl, "tx_share") &&
+			   (o_all & DL_OPT_PORT_FN_RATE_TX_SHARE)) {
+			dl_arg_inc(dl);
+			err = port_fn_rate_value_get(dl, &opts->rate_tx_share);
+			if (err)
+				return err;
+			o_found |= DL_OPT_PORT_FN_RATE_TX_SHARE;
+		} else if (dl_argv_match(dl, "tx_max") &&
+			   (o_all & DL_OPT_PORT_FN_RATE_TX_MAX)) {
+			dl_arg_inc(dl);
+			err = port_fn_rate_value_get(dl, &opts->rate_tx_max);
+			if (err)
+				return err;
+			o_found |= DL_OPT_PORT_FN_RATE_TX_MAX;
+		} else if (dl_argv_match(dl, "parent") &&
+			   (o_all & DL_OPT_PORT_FN_RATE_PARENT)) {
+			dl_arg_inc(dl);
+			err = dl_argv_str(dl, &opts->rate_parent_node);
+			if (err)
+				return err;
+			o_found |= DL_OPT_PORT_FN_RATE_PARENT;
+		} else if (dl_argv_match(dl, "noparent") &&
+			   (o_all & DL_OPT_PORT_FN_RATE_PARENT)) {
+			dl_arg_inc(dl);
+			opts->rate_parent_node = "";
+			o_found |= DL_OPT_PORT_FN_RATE_PARENT;
 		} else {
 			pr_err("Unknown option \"%s\"\n", dl_argv(dl));
 			return -EINVAL;
@@ -1962,6 +2125,11 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 		mnl_attr_put_strz(nlh, DEVLINK_ATTR_DEV_NAME, opts->dev_name);
 		mnl_attr_put_strz(nlh, DEVLINK_ATTR_REGION_NAME,
 				  opts->region_name);
+	} else if (opts->present & DL_OPT_PORT_FN_RATE_NODE_NAME) {
+		mnl_attr_put_strz(nlh, DEVLINK_ATTR_BUS_NAME, opts->bus_name);
+		mnl_attr_put_strz(nlh, DEVLINK_ATTR_DEV_NAME, opts->dev_name);
+		mnl_attr_put_strz(nlh, DEVLINK_ATTR_RATE_NODE_NAME,
+				  opts->rate_node_name);
 	}
 	if (opts->present & DL_OPT_PORT_TYPE)
 		mnl_attr_put_u16(nlh, DEVLINK_ATTR_PORT_TYPE,
@@ -2083,6 +2251,18 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 		mnl_attr_put_u16(nlh, DEVLINK_ATTR_PORT_PCI_PF_NUMBER, opts->port_pfnumber);
 	if (opts->present & DL_OPT_PORT_SFNUMBER)
 		mnl_attr_put_u32(nlh, DEVLINK_ATTR_PORT_PCI_SF_NUMBER, opts->port_sfnumber);
+	if (opts->present & DL_OPT_PORT_FN_RATE_TYPE)
+		mnl_attr_put_u16(nlh, DEVLINK_ATTR_RATE_TYPE,
+				 opts->rate_type);
+	if (opts->present & DL_OPT_PORT_FN_RATE_TX_SHARE)
+		mnl_attr_put_u64(nlh, DEVLINK_ATTR_RATE_TX_SHARE,
+				 opts->rate_tx_share);
+	if (opts->present & DL_OPT_PORT_FN_RATE_TX_MAX)
+		mnl_attr_put_u64(nlh, DEVLINK_ATTR_RATE_TX_MAX,
+				 opts->rate_tx_max);
+	if (opts->present & DL_OPT_PORT_FN_RATE_PARENT)
+		mnl_attr_put_strz(nlh, DEVLINK_ATTR_RATE_PARENT_NODE_NAME,
+				  opts->rate_parent_node);
 }
 
 static int dl_argv_parse_put(struct nlmsghdr *nlh, struct dl *dl,
@@ -3796,6 +3976,7 @@ static void cmd_port_help(void)
 	pr_err("       devlink port split DEV/PORT_INDEX count COUNT\n");
 	pr_err("       devlink port unsplit DEV/PORT_INDEX\n");
 	pr_err("       devlink port function set DEV/PORT_INDEX [ hw_addr ADDR ] [ state STATE ]\n");
+	pr_err("       devlink port function rate { help | show | add | del | set }\n");
 	pr_err("       devlink port param set DEV/PORT_INDEX name PARAMETER value VALUE cmode { permanent | driverinit | runtime }\n");
 	pr_err("       devlink port param show [DEV/PORT_INDEX name PARAMETER]\n");
 	pr_err("       devlink port health show [ DEV/PORT_INDEX reporter REPORTER_NAME ]\n");
@@ -4089,6 +4270,7 @@ static int cmd_port_param_show(struct dl *dl)
 static void cmd_port_function_help(void)
 {
 	pr_err("Usage: devlink port function set DEV/PORT_INDEX [ hw_addr ADDR ] [ state STATE ]\n");
+	pr_err("       devlink port function rate { help | show | add | del | set }\n");
 }
 
 static int cmd_port_function_set(struct dl *dl)
@@ -4310,6 +4492,280 @@ static int cmd_port_param(struct dl *dl)
 	return -ENOENT;
 }
 
+static void
+pr_out_port_rate_handle_start(struct dl *dl, struct nlattr **tb, bool try_nice)
+{
+	const char *bus_name;
+	const char *dev_name;
+	const char *node_name;
+	static char buf[64];
+
+	bus_name = mnl_attr_get_str(tb[DEVLINK_ATTR_BUS_NAME]);
+	dev_name = mnl_attr_get_str(tb[DEVLINK_ATTR_DEV_NAME]);
+	node_name = mnl_attr_get_str(tb[DEVLINK_ATTR_RATE_NODE_NAME]);
+	sprintf(buf, "%s/%s/%s", bus_name, dev_name, node_name);
+	if (dl->json_output)
+		open_json_object(buf);
+	else
+		pr_out("%s:", buf);
+}
+
+static char *port_rate_type_name(uint16_t type)
+{
+	switch (type) {
+	case DEVLINK_RATE_TYPE_LEAF:
+		return "leaf";
+	case DEVLINK_RATE_TYPE_NODE:
+		return "node";
+	default:
+		return "<unknown type>";
+	}
+}
+
+static void pr_out_port_fn_rate(struct dl *dl, struct nlattr **tb)
+{
+
+	if (!tb[DEVLINK_ATTR_RATE_NODE_NAME])
+		pr_out_port_handle_start(dl, tb, false);
+	else
+		pr_out_port_rate_handle_start(dl, tb, false);
+	check_indent_newline(dl);
+
+	if (tb[DEVLINK_ATTR_RATE_TYPE]) {
+		uint16_t type =
+			mnl_attr_get_u16(tb[DEVLINK_ATTR_RATE_TYPE]);
+
+		print_string(PRINT_ANY, "type", "type %s",
+				port_rate_type_name(type));
+	}
+	if (tb[DEVLINK_ATTR_RATE_TX_SHARE]) {
+		uint64_t rate =
+			mnl_attr_get_u64(tb[DEVLINK_ATTR_RATE_TX_SHARE]);
+
+		if (rate)
+			print_rate(false, PRINT_ANY, "tx_share",
+				   " tx_share %s", rate);
+	}
+	if (tb[DEVLINK_ATTR_RATE_TX_MAX]) {
+		uint64_t rate =
+			mnl_attr_get_u64(tb[DEVLINK_ATTR_RATE_TX_MAX]);
+
+		if (rate)
+			print_rate(false, PRINT_ANY, "tx_max",
+				   " tx_max %s", rate);
+	}
+	if (tb[DEVLINK_ATTR_RATE_PARENT_NODE_NAME]) {
+		const char *parent =
+			mnl_attr_get_str(tb[DEVLINK_ATTR_RATE_PARENT_NODE_NAME]);
+
+		print_string(PRINT_ANY, "parent", " parent %s", parent);
+	}
+
+	pr_out_port_handle_end(dl);
+}
+
+static int cmd_port_fn_rate_show_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct dl *dl = data;
+	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
+	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
+
+	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
+	if ((!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
+	     !tb[DEVLINK_ATTR_PORT_INDEX]) &&
+	    !tb[DEVLINK_ATTR_RATE_NODE_NAME]) {
+		return MNL_CB_ERROR;
+	}
+	pr_out_port_fn_rate(dl, tb);
+	return MNL_CB_OK;
+}
+
+static void cmd_port_fn_rate_help(void)
+{
+	pr_err("Usage: devlink port function rate help\n");
+	pr_err("       devlink port function rate show [ DEV/{ PORT_INDEX | NODE_NAME } ]\n");
+	pr_err("       devlink port function rate add DEV/NODE_NAME\n");
+	pr_err("               [ tx_share VAL ][ tx_max VAL ][ { parent NODE_NAME | noparent } ]\n");
+	pr_err("       devlink port function rate del DEV/NODE_NAME\n");
+	pr_err("       devlink port function rate set DEV/{ PORT_INDEX | NODE_NAME }\n");
+	pr_err("               [ tx_share VAL ][ tx_max VAL ][ { parent NODE_NAME | noparent } ]\n\n");
+	pr_err("       VAL - float or integer value in units of bits or bytes per second (bit|bps)\n");
+	pr_err("       and SI (k-, m-, g-, t-) or IEC (ki-, mi-, gi-, ti-) case-insensitive prefix.\n");
+	pr_err("       Bare number, means bits per second, is possible.\n\n");
+	pr_err("       For details refer to devlink-rate(8) man page.\n");
+}
+
+static int cmd_port_fn_rate_show(struct dl *dl)
+{
+	struct nlmsghdr *nlh;
+	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
+	int err;
+
+	if (dl_argc(dl) == 0)
+		flags |= NLM_F_DUMP;
+
+	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_RATE_GET, flags);
+
+	if (dl_argc(dl) > 0) {
+		err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLEP |
+					DL_OPT_PORT_FN_RATE_NODE_NAME, 0);
+		if (err)
+			return err;
+	}
+
+	pr_out_section_start(dl, "rate");
+	err = mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_port_fn_rate_show_cb, dl);
+	pr_out_section_end(dl);
+	return err;
+}
+
+static int port_fn_check_tx_rates(uint64_t min_rate, uint64_t max_rate)
+{
+	if (max_rate && min_rate > max_rate) {
+		pr_err("Invalid. Expected tx_share <= tx_max or tx_share == 0.\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int port_fn_get_and_check_tx_rates(struct dl_opts *reply,
+					  struct dl_opts *request)
+{
+	uint64_t min = reply->rate_tx_share;
+	uint64_t max = reply->rate_tx_max;
+
+	if (request->present & DL_OPT_PORT_FN_RATE_TX_SHARE)
+		return port_fn_check_tx_rates(request->rate_tx_share, max);
+	return port_fn_check_tx_rates(min, request->rate_tx_max);
+}
+
+static int cmd_port_fn_rate_add(struct dl *dl)
+{
+	struct nlmsghdr *nlh;
+	int err;
+
+	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_RATE_NEW,
+					  NLM_F_REQUEST | NLM_F_ACK);
+	err = dl_argv_parse_put(nlh, dl, DL_OPT_PORT_FN_RATE_NODE_NAME,
+				DL_OPT_PORT_FN_RATE_TX_SHARE |
+				DL_OPT_PORT_FN_RATE_TX_MAX);
+	if (err)
+		return err;
+
+	if ((dl->opts.present & DL_OPT_PORT_FN_RATE_TX_SHARE) &&
+	    (dl->opts.present & DL_OPT_PORT_FN_RATE_TX_MAX)) {
+		err = port_fn_check_tx_rates(dl->opts.rate_tx_share,
+					     dl->opts.rate_tx_max);
+		if (err)
+			return err;
+	}
+
+	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
+}
+
+static int cmd_port_fn_rate_del(struct dl *dl)
+{
+	struct nlmsghdr *nlh;
+	int err;
+
+	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_RATE_DEL,
+					  NLM_F_REQUEST | NLM_F_ACK);
+	err = dl_argv_parse_put(nlh, dl, DL_OPT_PORT_FN_RATE_NODE_NAME, 0);
+	if (err)
+		return err;
+
+	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
+}
+
+static int port_fn_get_rates_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct dl_opts *opts = data;
+	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
+	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
+
+	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
+	if ((!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
+	     !tb[DEVLINK_ATTR_PORT_INDEX]) &&
+	    !tb[DEVLINK_ATTR_RATE_NODE_NAME]) {
+		return MNL_CB_ERROR;
+	}
+
+	if (tb[DEVLINK_ATTR_RATE_TX_SHARE])
+		opts->rate_tx_share =
+			mnl_attr_get_u64(tb[DEVLINK_ATTR_RATE_TX_SHARE]);
+	if (tb[DEVLINK_ATTR_RATE_TX_MAX])
+		opts->rate_tx_max =
+			mnl_attr_get_u64(tb[DEVLINK_ATTR_RATE_TX_MAX]);
+	return MNL_CB_OK;
+}
+
+static int cmd_port_fn_rate_set(struct dl *dl)
+{
+	struct dl_opts tmp_opts = {0};
+	struct nlmsghdr *nlh;
+	int err;
+
+	err = dl_argv_parse(dl, DL_OPT_HANDLEP |
+				DL_OPT_PORT_FN_RATE_NODE_NAME,
+				DL_OPT_PORT_FN_RATE_TX_SHARE |
+				DL_OPT_PORT_FN_RATE_TX_MAX |
+				DL_OPT_PORT_FN_RATE_PARENT);
+	if (err)
+		return err;
+
+	if ((dl->opts.present & DL_OPT_PORT_FN_RATE_TX_SHARE) &&
+	    (dl->opts.present & DL_OPT_PORT_FN_RATE_TX_MAX)) {
+		err = port_fn_check_tx_rates(dl->opts.rate_tx_share,
+					     dl->opts.rate_tx_max);
+		if (err)
+			return err;
+	} else if (dl->opts.present &
+		   (DL_OPT_PORT_FN_RATE_TX_SHARE | DL_OPT_PORT_FN_RATE_TX_MAX)) {
+		nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_RATE_GET,
+						  NLM_F_REQUEST | NLM_F_ACK);
+		tmp_opts = dl->opts;
+		dl->opts.present &= ~(DL_OPT_PORT_FN_RATE_TX_SHARE |
+				      DL_OPT_PORT_FN_RATE_TX_MAX |
+				      DL_OPT_PORT_FN_RATE_PARENT);
+		dl_opts_put(nlh, dl);
+		err = mnlu_gen_socket_sndrcv(&dl->nlg, nlh, port_fn_get_rates_cb,
+					     &dl->opts);
+		if (err)
+			return err;
+		err = port_fn_get_and_check_tx_rates(&dl->opts, &tmp_opts);
+		if (err)
+			return err;
+		dl->opts = tmp_opts;
+	}
+
+	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_RATE_SET,
+					  NLM_F_REQUEST | NLM_F_ACK);
+	dl_opts_put(nlh, dl);
+	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
+}
+
+static int cmd_port_function_rate(struct dl *dl)
+{
+	if (dl_argv_match(dl, "help")) {
+		cmd_port_fn_rate_help();
+		return 0;
+	} else if (dl_argv_match(dl, "show") || dl_no_arg(dl)) {
+		dl_arg_inc(dl);
+		return cmd_port_fn_rate_show(dl);
+	} else if (dl_argv_match(dl, "add")) {
+		dl_arg_inc(dl);
+		return cmd_port_fn_rate_add(dl);
+	} else if (dl_argv_match(dl, "del")) {
+		dl_arg_inc(dl);
+		return cmd_port_fn_rate_del(dl);
+	} else if (dl_argv_match(dl, "set")) {
+		dl_arg_inc(dl);
+		return cmd_port_fn_rate_set(dl);
+	}
+	pr_err("Command \"%s\" not found\n", dl_argv(dl));
+	return -ENOENT;
+}
+
 static int cmd_port_function(struct dl *dl)
 {
 	if (dl_argv_match(dl, "help") || dl_no_arg(dl)) {
@@ -4318,6 +4774,9 @@ static int cmd_port_function(struct dl *dl)
 	} else if (dl_argv_match(dl, "set")) {
 		dl_arg_inc(dl);
 		return cmd_port_function_set(dl);
+	} else if (dl_argv_match(dl, "rate")) {
+		dl_arg_inc(dl);
+		return cmd_port_function_rate(dl);
 	}
 	pr_err("Command \"%s\" not found\n", dl_argv(dl));
 	return -ENOENT;
diff --git a/man/man8/devlink-port.8 b/man/man8/devlink-port.8
index 563c583..616f094 100644
--- a/man/man8/devlink-port.8
+++ b/man/man8/devlink-port.8
@@ -71,6 +71,10 @@ devlink-port \- devlink port configuration
 .RI "STATE }"
 
 .ti -8
+.BR "devlink port function rate "
+.RI "{ " show " | " set " | " add " | " del " | " help " }"
+
+.ti -8
 .B devlink dev param set
 .I DEV/PORT_INDEX
 .B name
@@ -240,6 +244,10 @@ Configuration mode in which the new value is set.
 Specify parameter name to show.
 If this argument, as well as port index, are omitted - all parameters supported by devlink device ports are listed.
 
+.SS devlink port function rate - manage devlink rate objects
+Is an alias for
+.BR devlink-rate (8).
+
 .SH "EXAMPLES"
 .PP
 devlink port show
diff --git a/man/man8/devlink-rate.8 b/man/man8/devlink-rate.8
new file mode 100644
index 0000000..60244dd
--- /dev/null
+++ b/man/man8/devlink-rate.8
@@ -0,0 +1,256 @@
+.TH DEVLINK\-RATE 8 "12 Mar 2021" "iproute2" "Linux"
+.SH NAME
+devlink-rate \- devlink rate management
+.SH SYNOPSIS
+.sp
+.ad l
+.in +8
+.ti -8
+.B devlink
+.RI "[ " OPTIONS " ]"
+.B port function rate
+.RI  " { " COMMAND " | "
+.BR help " }"
+.sp
+
+.ti -8
+.IR OPTIONS " := { "
+.BR -j [ \fIson "] | " -p [ \fIretty "] }"
+
+.ti -8
+.B devlink port function rate show
+.RI "[ { " DEV/PORT_INDEX " | " DEV/NODE_NAME " } ]"
+
+.ti -8
+.B devlink port function rate set
+.RI "{ " DEV/PORT_INDEX " | " DEV/NODE_NAME " } "
+.RB [ " tx_share \fIVALUE " ]
+.RB [ " tx_max \fIVALUE " ]
+.RB "[ {" " parent \fINODE_NAME " | " noparent " "} ]"
+
+.ti -8
+.BI "devlink port function rate add " DEV/NODE_NAME
+.RB [ " tx_share \fIVALUE " ]
+.RB [ " tx_max \fIVALUE " ]
+.RB "[ {" " parent \fINODE_NAME " | " noparent " "} ]"
+
+.ti -8
+.BI "devlink port function rate del " DEV/NODE_NAME
+
+.ti -8
+.B devlink port function rate help
+
+.SH "DESCRIPTION"
+
+.SS devlink port function rate show - display rate objects.
+Displays specified rate object or, if not specified, all rate objects. Rate
+object can be presented by one of the two types:
+.TP 8
+.B leaf
+Represents a single devlink port; created/destroyed by the driver and bound to
+the devlink port. As example, some driver may create leaf rate object for every
+devlink port associated with VF. Since leaf have 1to1 mapping to it's devlink
+port, in user space it is referred as corresponding devlink port
+\fIDEV/PORT_INDEX\fR;
+.TP 8
+.B node
+Represents a group of rate objects; created/deleted by the user (see command
+below) and bound to the devlink device rather then to the devlink port. In
+userspace it is referred as \fIDEV/NODE_NAME\fR, where node name can be any,
+except decimal number, to avoid collisions with leafs.
+.PP
+Command output show rate object identifier, it's type and rate values along with
+parent node name. Rate values printed in SI units which are more suitable to
+represent specific value. JSON (\fB-j\fR) output always print rate values in
+bytes per second. Zero rate values means "unlimited" rates and ommited in
+output, as well as parent node name.
+
+.SS devlink port function rate set - set rate object parameters.
+Allows set rate object's parameters. If any parameter specified multiple times
+the last occurrence is used.
+.PP
+.I DEV/PORT_INDEX
+- specifies devlink leaf rate object.
+.br
+.I DEV/NODE_NAME
+- specifies devlink node rate object.
+.PP
+.BI tx_share " VALUE"
+- specifies minimal tx rate value shared among all rate objects. If rate object
+is a part of some rate group, then this value shared with rate objects of this
+rate group.
+.PP
+.BI tx_max " VALUE"
+- specifies maximum tx rate value.
+.TP 8
+.I VALUE
+These parameter accept a floating point number, possibly followed by either a
+unit.
+.RS
+.TP
+bit or a bare number
+Bits per second
+.TP
+kbit
+Kilobits per second
+.TP
+mbit
+Megabits per second
+.TP
+gbit
+Gigabits per second
+.TP
+tbit
+Terabits per second
+.TP
+bps
+Bytes per second
+.TP
+kbps
+Kilobytes per second
+.TP
+mbps
+Megabytes per second
+.TP
+gbps
+Gigabytes per second
+.TP
+tbps
+Terabytes per second
+.RE
+.PP
+.BI parent " NODE_NAME \fR| " noparent
+- set rate object parent to existing node with name \fINODE_NAME\fR or unset
+parent. Rate limits of the parent node applied to all it's children. Actual
+behaviour is details of driver's implementation. Setting parent to empty ("")
+name due to the kernel logic threated as parent unset.
+
+.SS devlink port function rate add - create node rate object with specified parameters.
+Creates rate object of type node and sets parameters. Parameters same as for the
+"set" command.
+.PP
+.I DEV/NODE_NAME
+- specifies the devlink node rate object to create.
+
+.SS devlink port function rate del - delete node rate object
+Delete specified devlink node rate object. Node can't be deleted if there is any
+child, user must explicitly unset the parent.
+.PP
+.I DEV/NODE_NAME
+- specifies devlink node rate object to delete.
+
+.SS devlink port function rate help - display usage information
+Display devlink rate usage information
+
+.SH "EXAMPLES"
+
+.PP
+\fB*\fR Display all rate objects:
+.RS 4
+.PP
+# devlink port function rate show
+.br
+pci/0000:03:00.0/1 type leaf parent some_group
+.br
+pci/0000:03:00.0/2 type leaf tx_share 12Mbit
+.br
+pci/0000:03:00.0/some_group type node tx_share 1Gbps tx_max 5Gbps
+.RE
+
+.PP
+\fB*\fR Display leaf rate object bound to the 1st devlink port of the
+pci/0000:03:00.0 device:
+.RS 4
+.PP
+# devlink port function rate show pci/0000:03:00.0/1
+.br
+pci/0000:03:00.0/1 type leaf
+.br
+.RE
+
+.PP
+\fB*\fR Display node rate object with name some_group of the pci/0000:03:00.0 device:
+.RS 4
+.PP
+# devlink port function rate show pci/0000:03:00.0/some_group
+.br
+pci/0000:03:00.0/some_group type node
+.br
+.RE
+
+.PP
+\fB*\fR Display pci/0000:03:00.0/2 leaf rate object as pretty JSON output:
+.RS 4
+.PP
+# devlink -jp port function rate show pci/0000:03:00.0/2
+.br
+{
+.br
+    "rate": {
+.br
+        "pci/0000:03:00.0/2": {
+.br
+            "type": "leaf",
+.br
+            "tx_share": 1500000
+.br
+        }
+.br
+    }
+.br
+}
+.RE
+
+.PP
+\fB*\fR Create node rate object with name "1st_group" on pci/0000:03:00.0 device:
+.RS 4
+.PP
+# devlink port function rate add pci/0000:03:00.0/1st_group
+.RE
+
+.PP
+\fB*\fR Create node rate object with specified parameters:
+.RS 4
+.PP
+# devlink port function rate add pci/0000:03:00.0/2nd_group \\
+.br
+	tx_share 10Mbit tx_max 30Mbit parent 1st_group
+.RE
+
+.PP
+\fB*\fR Set parameters to the specified leaf rate object:
+.RS 4
+.PP
+# devlink port function rate set pci/0000:03:00.0/1 \\
+.br
+	tx_share 2Mbit tx_max 10Mbit
+.RE
+
+.PP
+\fB*\fR Set leaf's parent to "1st_group":
+.RS 4
+.PP
+# devlink port function rate set pci/0000:03:00.0/1 parent 1st_group
+.RE
+
+.PP
+\fB*\fR Unset leaf's parent:
+.RS 4
+.PP
+# devlink port function rate set pci/0000:03:00.0/1 noparent
+.RE
+
+.PP
+\fB*\fR Delete node rate object:
+.RS 4
+.PP
+# devlink port function rate del pci/0000:03:00.0/2nd_group
+.RE
+
+.SH SEE ALSO
+.BR devlink (8),
+.BR devlink-port (8)
+.br
+
+.SH AUTHOR
+Dmytro Linkin <dlinkin@nvidia.com>
-- 
1.8.3.1

