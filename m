Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E348C649409
	for <lists+netdev@lfdr.de>; Sun, 11 Dec 2022 12:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbiLKL7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 06:59:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbiLKL7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 06:59:13 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2046.outbound.protection.outlook.com [40.107.100.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26851F03D
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 03:59:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KRtrgorU4rljqLTt0XV3XiQV9DvEZrsQ2coK0a7xu7OA3LksdW5PInsHGV+hBdKVHfxj7VeOROSBaN4sP4WJwMgS2tE6Xw08+/z+0ovHlT9Ywzjh0q+jx/ogLRgabo6S03g4/3Frq8Y0+7dDcVpLWfF8be6tEY+15BfNeBAoyw3cMjjx63Gm6ubbwh784k63w2cAfAjSkrun4Imx3hgoSuG2GEp7hTZBNug2Gh1A5dKnuCHsITS87PPFjap79X0ghvBJneQjeLYSbCU4vIJWRTkYxZ/rcFigB5IsNlXz7Juat0LPpoUtIB6F48IGstAw2q02LZ491LDrJA8TxfN/kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aMMUV5kwNEcJeqQOz8Gb93xF9p50r8z4rKTfN2jopj8=;
 b=Imd+DqfmYVyV0Y0G8VPo3gGPzmEYjxSKM8PvJWASq9/gdpkesN0M9MKSxyQlvgrb5f9Bq/xovfJC3Ddu6+NZnov08WjgmtGEb1S6cfSSFdIqeGvn6V0488ro/vHxfqplwoL9ADpu2YEnvS5imKRNQHUtaPyi3BmnDwn6OVcLd4I4MzrFep4nKZ0gaKdevhS9hYI0VKJE4xCTND5MXO8P/yqY7N8qa79juL156X+QbYdcSwVuz5IcsFoJoBptmL+2mKr9UDMLlCgOkLYRzD4htB1vqECZoaKz2qC9wmHqo78E6TfbEDjdd8/hubRW4Oc8JiiMipBmHUZPxD4SpVyQMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aMMUV5kwNEcJeqQOz8Gb93xF9p50r8z4rKTfN2jopj8=;
 b=AD8W/81UGBmCTENOFW4zYg6YDXl3sS5hBn17OMRUx+p0AbQINn1MX/Hv1dIx77VQcNg2ZIRSD7dvxWTq82u1eDth/8b8dyM4Gp+S6eX1mrIKTmVJIfYi8gaw8IbX395u6jp6kh7Wfnf79Bo9r0BkVKvFArO8IMFnh8O+oj4Lwh/RTKY0xtewS16cf94BjLvN8SVCZzKqnbIQPRbSc58tMQAMYVkMZPo/drZEdjoDZZIjALnvaDHCaCmJbFYhBiKJ7YjYGOVUTfE2eYLU+wQI16vm9qHcN3JP3dn6QZXyGnWIHoTnB3PK8EzmXwAuFRE7l+sNDCXAx03jaXOedbOtkA==
Received: from DM6PR02CA0071.namprd02.prod.outlook.com (2603:10b6:5:177::48)
 by DM6PR12MB4316.namprd12.prod.outlook.com (2603:10b6:5:21a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Sun, 11 Dec
 2022 11:59:04 +0000
Received: from DM6NAM11FT086.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:177:cafe::f3) by DM6PR02CA0071.outlook.office365.com
 (2603:10b6:5:177::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19 via Frontend
 Transport; Sun, 11 Dec 2022 11:59:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT086.mail.protection.outlook.com (10.13.173.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5901.17 via Frontend Transport; Sun, 11 Dec 2022 11:59:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 11 Dec
 2022 03:59:03 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.230.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Sun, 11 Dec 2022 03:59:01 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>, <jiri@nvidia.com>
Subject: [PATCH iproute2-next 2/4] devlink: Support setting port function roce cap
Date:   Sun, 11 Dec 2022 13:58:47 +0200
Message-ID: <20221211115849.510284-3-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221211115849.510284-1-shayd@nvidia.com>
References: <20221211115849.510284-1-shayd@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT086:EE_|DM6PR12MB4316:EE_
X-MS-Office365-Filtering-Correlation-Id: 107a2e13-dc8c-46a6-d07d-08dadb6f1964
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2mvFyonTQtaVaMfW1+TT4HR5SdQmQU0hqHr/0wqGUoatH9nfAxBbEp0l/dHltg0eL2ym2CKzRg7Ika3PTNSiZLQi9bSrrMBlfZ+wdRZni3cBoV5r0LGF8cgAedHsEk/Q8jw5K+Ik1UYqma2h7bLfDMSQKK/MFD3U68abKonPnLdrAncX3k7YHgq09V0VnK/GYmY7DUmaliQGLVHeH9OeBQM9qA807zu1Q+UtiypGgVMCz5OTO3Cksws9Un73WUu0UILAsGfc20JzbAok8r18krcGX2wiiiUEWl+U3tVKQkfUVaTmkHvCpKPig7NTF+0MY9J6w5+Kz23QGodYJrw0EsEikiHhmRaT5AVsqSygEJU8y3DOFGLgLMW7LbjwrG7a7ARwgsBAwAHQgWiJ8xHJbrJsPD+qmwh6Yqq51YqxkqLH57uYlr9jf5qaF3yDZNTXsYxVNSwgYIvh2WDOeSjhGpW2nqgXmOZDVax5qDygeVS33J/oagqkZAah176ZuD8BqUpOctfsQZ2y8gI20Fk1l1rCwaDVoHALJdri3BInYhVCVgiB9ibd7ZGhY85VSelFeU/RxVV9K4D2CCnUnX24A6donX8UbnygZBwl9sUi1POLZSW3avl4IEMmondQfvECqSz85M1JI5uPRt0xtqGocUghNRSw1uh4R/4Cibm6ETShtc4q2salvXs+vWEhH22e+QkO2UQETuMsOrgZDShY/A==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(376002)(346002)(451199015)(40470700004)(36840700001)(46966006)(36756003)(86362001)(2906002)(2616005)(186003)(16526019)(1076003)(336012)(83380400001)(110136005)(6636002)(47076005)(40460700003)(426003)(478600001)(6666004)(26005)(82310400005)(356005)(41300700001)(82740400003)(7636003)(40480700001)(5660300002)(8936002)(70586007)(70206006)(8676002)(316002)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2022 11:59:03.8830
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 107a2e13-dc8c-46a6-d07d-08dadb6f1964
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT086.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4316
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support port function commands to enable / disable RoCE, this is used to
control the port RoCE device capabilities.

When RoCE is disabled for a function of the port, function cannot create
any RoCE specific resources (e.g GID table).
It also saves system memory utilization. For example disabling RoCE
enable a VF/SF to save 1 Mbytes of system memory per function.

Example of a PCI VF port which supports a port function:

$ devlink port show pci/0000:06:00.0/2
    pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum
    0 vfnum 1
      function:
        hw_addr 00:00:00:00:00:00 roce enabled

$ devlink port function set pci/0000:06:00.0/2 roce disable

$ devlink port show pci/0000:06:00.0/2
    pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum
    0 vfnum 1
      function:
        hw_addr 00:00:00:00:00:00 roce disabled

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 devlink/devlink.c | 35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 4a5eee7a..66cc0415 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -297,6 +297,7 @@ static void ifname_map_free(struct ifname_map *ifname_map)
 #define DL_OPT_SELFTESTS	BIT(54)
 #define DL_OPT_PORT_FN_RATE_TX_PRIORITY	BIT(55)
 #define DL_OPT_PORT_FN_RATE_TX_WEIGHT	BIT(56)
+#define DL_OPT_PORT_FN_CAPS	BIT(57)
 
 struct dl_opts {
 	uint64_t present; /* flags of present items */
@@ -362,6 +363,7 @@ struct dl_opts {
 	uint32_t linecard_index;
 	const char *linecard_type;
 	bool selftests_opt[DEVLINK_ATTR_SELFTEST_ID_MAX + 1];
+	struct nla_bitfield32 port_fn_caps;
 };
 
 struct dl {
@@ -2116,6 +2118,18 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 			dl_arg_inc(dl);
 			opts->linecard_type = "";
 			o_found |= DL_OPT_LINECARD_TYPE;
+		} else if (dl_argv_match(dl, "roce") &&
+			   (o_all & DL_OPT_PORT_FN_CAPS)) {
+			bool roce;
+
+			dl_arg_inc(dl);
+			err = dl_argv_bool(dl, &roce);
+			if (err)
+				return err;
+			opts->port_fn_caps.selector |= DEVLINK_PORT_FN_CAP_ROCE;
+			if (roce)
+				opts->port_fn_caps.value |= DEVLINK_PORT_FN_CAP_ROCE;
+			o_found |= DL_OPT_PORT_FN_CAPS;
 		} else {
 			pr_err("Unknown option \"%s\"\n", dl_argv(dl));
 			return -EINVAL;
@@ -2146,6 +2160,10 @@ dl_function_attr_put(struct nlmsghdr *nlh, const struct dl_opts *opts)
 	if (opts->present & DL_OPT_PORT_FUNCTION_STATE)
 		mnl_attr_put_u8(nlh, DEVLINK_PORT_FN_ATTR_STATE,
 				opts->port_fn_state);
+	if (opts->present & DL_OPT_PORT_FN_CAPS)
+		mnl_attr_put(nlh, DEVLINK_PORT_FN_ATTR_CAPS,
+			     sizeof(opts->port_fn_caps), &opts->port_fn_caps);
+
 	mnl_attr_nest_end(nlh, nest);
 }
 
@@ -2336,7 +2354,8 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 	if (opts->present & DL_OPT_TRAP_POLICER_BURST)
 		mnl_attr_put_u64(nlh, DEVLINK_ATTR_TRAP_POLICER_BURST,
 				 opts->trap_policer_burst);
-	if (opts->present & (DL_OPT_PORT_FUNCTION_HW_ADDR | DL_OPT_PORT_FUNCTION_STATE))
+	if (opts->present & (DL_OPT_PORT_FUNCTION_HW_ADDR | DL_OPT_PORT_FUNCTION_STATE |
+			     DL_OPT_PORT_FN_CAPS))
 		dl_function_attr_put(nlh, opts);
 	if (opts->present & DL_OPT_PORT_FLAVOUR)
 		mnl_attr_put_u16(nlh, DEVLINK_ATTR_PORT_FLAVOUR, opts->port_flavour);
@@ -4386,6 +4405,7 @@ static void cmd_port_help(void)
 	pr_err("       devlink port split DEV/PORT_INDEX count COUNT\n");
 	pr_err("       devlink port unsplit DEV/PORT_INDEX\n");
 	pr_err("       devlink port function set DEV/PORT_INDEX [ hw_addr ADDR ] [ state { active | inactive } ]\n");
+	pr_err("                      [ roce { enable | disable } ]\n");
 	pr_err("       devlink port function rate { help | show | add | del | set }\n");
 	pr_err("       devlink port param set DEV/PORT_INDEX name PARAMETER value VALUE cmode { permanent | driverinit | runtime }\n");
 	pr_err("       devlink port param show [DEV/PORT_INDEX name PARAMETER]\n");
@@ -4499,6 +4519,15 @@ static void pr_out_port_function(struct dl *dl, struct nlattr **tb_port)
 		print_string(PRINT_ANY, "opstate", " opstate %s",
 			     port_fn_opstate(state));
 	}
+	if (tb[DEVLINK_PORT_FN_ATTR_CAPS]) {
+		struct nla_bitfield32 *port_fn_caps =
+			mnl_attr_get_payload(tb[DEVLINK_PORT_FN_ATTR_CAPS]);
+
+		if (port_fn_caps->selector & DEVLINK_PORT_FN_CAP_ROCE)
+			print_string(PRINT_ANY, "roce", " roce %s",
+				     port_fn_caps->value & DEVLINK_PORT_FN_CAP_ROCE ?
+				     "enable" : "disable");
+	}
 
 	if (!dl->json_output)
 		__pr_out_indent_dec();
@@ -4693,6 +4722,7 @@ static int cmd_port_param_show(struct dl *dl)
 static void cmd_port_function_help(void)
 {
 	pr_err("Usage: devlink port function set DEV/PORT_INDEX [ hw_addr ADDR ] [ state STATE ]\n");
+	pr_err("                      [ roce { enable | disable } ]\n");
 	pr_err("       devlink port function rate { help | show | add | del | set }\n");
 }
 
@@ -4706,7 +4736,8 @@ static int cmd_port_function_set(struct dl *dl)
 		return 0;
 	}
 	err = dl_argv_parse(dl, DL_OPT_HANDLEP,
-			    DL_OPT_PORT_FUNCTION_HW_ADDR | DL_OPT_PORT_FUNCTION_STATE);
+			    DL_OPT_PORT_FUNCTION_HW_ADDR | DL_OPT_PORT_FUNCTION_STATE |
+			    DL_OPT_PORT_FN_CAPS);
 	if (err)
 		return err;
 
-- 
2.38.1

