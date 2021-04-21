Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8309366F9B
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 18:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244113AbhDUQAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 12:00:14 -0400
Received: from mail-dm6nam11on2050.outbound.protection.outlook.com ([40.107.223.50]:31712
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243334AbhDUQAM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 12:00:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VTlMA4DUgNUR4SoZuUnlyNJbFRdhqAGsL0UYurCSohRKfUt29fYlLZF/bpiNh8rYmfs2LV4kMk3zil/T98c/+/XVl6v81lAOXwG8hwWcpP0x51y1eJ4753EQ6yREAvM/Jri9RrRu+0a+nhXtAYI73vTLcs4ltHT0KYhH9CWt9Ekj1hXr+oCdDqOjqqFr8UPQ8wF1I4uUAzkH+U9zn3t07vJG2nTOz0Kk4zN5lSm3MwMYJFiSfw4Tf0BB4xSg56YPLD9xx7M0PVZ8PYEeFtYgeZK0ZAmDd5bpjR03MiTJNA/krdLKpabNXbdh2mk/MLVswt/haY0Cn0QdicmabpL0tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yvPhlOg756QyDMka+F8ZmCG/lf9Ar3EhA5i9MtTxeBY=;
 b=Eh5UYKPDRCCveiSghIftgw0vxP3oyjnw4Eb3N2wVbX8qugqrcK2kzSBvkBuw5LKPkfALG3gXi/ypGRNxdvSb4QYxWqy6nMCoxCJzMKnLJxpqcvfas0hg0tjMAIcFb3guSgVh+8S1ETTa+f5gbU0Lrd/y1HgDaeSy6LJIvQSVdmTAuDDfQ8R2r8KfrFhjmBs/Imb/i/JdR/MzKig5Gk6Nm7B5WElWsG39bXnXhgNX88a8zwOWXbBaKZGTTe69CXdj5OSbLdUMyTpshELIjx4eXKZhP5SPSu1BaK8MGIYEW9KlDppoBm9wl1rrl19uPgOpeSLERDqWqOX/LrGQ1dZKpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yvPhlOg756QyDMka+F8ZmCG/lf9Ar3EhA5i9MtTxeBY=;
 b=GskmJpEy1qMDuFCyLhNsomm+PDJqYiT69fQFnYeaK4NKB5rfcL9931XnqKFI2WU4ObIpsvXiZlkBM8wvMK9E1qkhLXRoebVyEZ2R2HZ+7/MvZBRikLnCqLfoJ3A0vBbGYmuzCa2xDiHJ8EH3o8gciC/SXXl+VVGAxFtBZUzO9EqE3gcFmxUjOJGkaVAr5RlwKDeqMavE3rWc4O7i6w9rNp/AYT6xjJJgh5eK8m9d/Irr0TdD2hca9vrzZjK+WeP2BTFHUzOJEUzKZml39xXFTKqZfe5BCNjiRVzn0Csrba8iOe8FupUIIfkN2O9Vo8boy4DaBwVB1fCrMvlRZ9RDOw==
Received: from CO2PR04CA0169.namprd04.prod.outlook.com (2603:10b6:104:4::23)
 by MN2PR12MB3935.namprd12.prod.outlook.com (2603:10b6:208:168::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Wed, 21 Apr
 2021 15:59:37 +0000
Received: from CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:4:cafe::22) by CO2PR04CA0169.outlook.office365.com
 (2603:10b6:104:4::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend
 Transport; Wed, 21 Apr 2021 15:59:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT013.mail.protection.outlook.com (10.13.174.227) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Wed, 21 Apr 2021 15:59:36 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Apr
 2021 15:59:36 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Apr
 2021 15:59:35 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Apr 2021 15:59:33 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RESEND RFC iproute2 net-next 3/4] devlink: Add port func rate support
Date:   Wed, 21 Apr 2021 18:59:24 +0300
Message-ID: <1619020765-20823-4-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1619020765-20823-1-git-send-email-dlinkin@nvidia.com>
References: <1619020765-20823-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5408a051-eb2b-4d55-6c81-08d904de76aa
X-MS-TrafficTypeDiagnostic: MN2PR12MB3935:
X-Microsoft-Antispam-PRVS: <MN2PR12MB39351B1788C99C979B5F63E8CB479@MN2PR12MB3935.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bYBPmDszTce7tTddMnaLQV7bbzaT2TFOL9JNNOpIRTlTNsOKysau2UgBaG1hdHdfW37ga/nklxgHGPzhGt3LBZMn2PYGLdLsGtdRng7W0CiPARcxftb83x2q3SsvSoOpGcBBPz7RNW5p8u5a9s17lK6dWuD3CxfPos+5lex4OiknVlj1clW3m1Zj+PeH7GtVbUAspTF3HzpXOtkw8J65Y4pcyIziPjMCuzxJ929TH+CYz92E8AZmMwd/IOCNiLQd+kLFILeusuP96seGe2X4f7bKgbvqjK9IXeygIjiECOAaIQXflvCQ7TWnnZtgWANLzIM1PM9h4i85+T5L96S0oWnL58q1PcyVfJ0s7GEglzeS1K9IXgK/vZj2ZikjHwyY9V8sKv9Wz9dFPYc/speakfOqcjT8P+9HnaaAEuQVQLpfzQy2pIc+SdDGoSeHvVKcAvZNW54pjEnwxCkEb7pa4+dUzQ3OaHYOQRW1ybiHbxU3NgX9yjSqIbpxu56lTNsjrJKQhO9+3WcmeTwgxQ8PXFbmvIlJn6ktrXUqLHxCa2s1v04R0voB/90+qz9ZfGzbPVxicF2pa9ejdrNWYndts4pslo4lB9Dv2fxQow2bqLo00u2aTtIJJqA+o2ckdFVUstaZcuO32L/EZMB+1EU/auH/8x1+ZTFTWhVD3BRziF4=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(136003)(396003)(46966006)(36840700001)(2876002)(2906002)(6666004)(316002)(26005)(36906005)(478600001)(356005)(186003)(54906003)(6916009)(82310400003)(30864003)(8936002)(5660300002)(2616005)(107886003)(70586007)(4326008)(70206006)(7696005)(36860700001)(7636003)(86362001)(426003)(336012)(83380400001)(82740400003)(36756003)(47076005)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 15:59:36.7628
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5408a051-eb2b-4d55-6c81-08d904de76aa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3935
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

Change-Id: I254640bf3134a7f88b5fd2b9c0a20572ae70e80b
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 devlink/devlink.c       | 489 ++++++++++++++++++++++++++++++++++++++++++++++--
 man/man8/devlink-port.8 |   8 +
 man/man8/devlink-rate.8 | 256 +++++++++++++++++++++++++
 3 files changed, 738 insertions(+), 15 deletions(-)
 create mode 100644 man/man8/devlink-rate.8

diff --git a/devlink/devlink.c b/devlink/devlink.c
index f435fc8..202359e 100644
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
@@ -1054,38 +1064,103 @@ static int dl_argv_handle_both(struct dl *dl, char **p_bus_name,
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
@@ -1397,6 +1472,36 @@ static int port_fn_state_parse(const char *statestr, uint8_t *state)
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
@@ -1469,6 +1574,19 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
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
@@ -1487,6 +1605,13 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
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
@@ -1884,6 +2009,44 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
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
@@ -1956,6 +2119,11 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
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
@@ -2077,6 +2245,18 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
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
@@ -3790,6 +3970,7 @@ static void cmd_port_help(void)
 	pr_err("       devlink port split DEV/PORT_INDEX count COUNT\n");
 	pr_err("       devlink port unsplit DEV/PORT_INDEX\n");
 	pr_err("       devlink port function set DEV/PORT_INDEX [ hw_addr ADDR ] [ state STATE ]\n");
+	pr_err("       devlink port function rate { help | show | add | del | set }\n");
 	pr_err("       devlink port param set DEV/PORT_INDEX name PARAMETER value VALUE cmode { permanent | driverinit | runtime }\n");
 	pr_err("       devlink port param show [DEV/PORT_INDEX name PARAMETER]\n");
 	pr_err("       devlink port health show [ DEV/PORT_INDEX reporter REPORTER_NAME ]\n");
@@ -4083,6 +4264,7 @@ static int cmd_port_param_show(struct dl *dl)
 static void cmd_port_function_help(void)
 {
 	pr_err("Usage: devlink port function set DEV/PORT_INDEX [ hw_addr ADDR ] [ state STATE ]\n");
+	pr_err("       devlink port function rate { help | show | add | del | set }\n");
 }
 
 static int cmd_port_function_set(struct dl *dl)
@@ -4304,6 +4486,280 @@ static int cmd_port_param(struct dl *dl)
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
@@ -4312,6 +4768,9 @@ static int cmd_port_function(struct dl *dl)
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
index 0000000..a6e28ac
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
+the last occurence is used.
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
+parent. Rate limits of the parent node applied to all it's childs. Actual
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

