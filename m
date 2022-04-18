Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29D28504CCB
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 08:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236827AbiDRGqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 02:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236822AbiDRGq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 02:46:28 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2089.outbound.protection.outlook.com [40.107.101.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE45B18E36
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 23:43:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MyzgDP8kY1jhUb4/R3ypyobjUYifj/mXq71JR7o3/Q0Ioi2kVhTsQcN34vaENwLpEsE5M5ze1OLPG5gPp5/ERXpn+oDz8K70MrP526hPy3R2RAj8rpupLxhhG3ZjjcD8z7Dhlo9I5IEztpZf04N5/3lVm6ROKLu48OxDbXljN96lzuLDfJXp0A/BXCrspVnvh34IIH+N68+LJtn8UpkoGpiFcSmlWO8OCuTS7MpPmffZhnvw+a57W/LKL75RXn2I7QA4p7TExFnSfWc3B6LDPyjcUbTgJPfLMy/S2TuVV8W81A/8v/E5r3PywXAD1pkxe5C3d8YJwZpHqfMS4X9fNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PThkrQAtxogrvzu0RubvsXrpSNZwp7JiaK0XxPPqVkA=;
 b=ZLoHYEVf93Ptr1vi6lPyQvNb3OeK1mr4ZXFeRPmnrnIpc20OQry0QzXwwBh+C37xdhXD0iGDEEXBCvzbm2Blcxo/O0Rmf3lXotTQ27vnsSg44ythdLz9tozREdaMx61LrZ3H6GKmbThKhpcGBpVaM/Il+DrEWZdfSUrUKkphRm11Eox14k0mD77wPXN6zBFyyIWOg5d5vJIDRSqL/MIqNhJEsMq7HPvx8z9AXnsOZvMuruYazJ/pWbHPhgV6Qdd0j4NvSZFMVgz4syg4YDBGRB4Xt5rhHkKrMRhsvgcdSPjC3xMfCMKvCyFID3JDxx4q1DNzwQ0NmVurd8pTAMWMzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PThkrQAtxogrvzu0RubvsXrpSNZwp7JiaK0XxPPqVkA=;
 b=CIJD5tLlALh96HzPuwSYOzn7sr8VIzfaF4VzF98Fbu+24cYGIkgWDRxbgy+fmbhxXmOA0gZTkRkg8W8zEiktNZSeguea6M2eFozUl+a1rcyUj7nR0k/XpWhtEZrmdZgkZwljYnuJO034uw67IXYfJpXMJKSOcJITDajqWMuRS5pkaPBd7y5dl1w/qkoGY6qIOHpP5xfXDNPF7TaXUiD73QOUh4+51fIwJtUZBmrX5AVcUJ9b4G9kKDW3GyAD/xsYji8jOFdKTD3Hgse93y5Bo7iR/6LXuz31SoX3A/Ig0y46oZ+r2YMCHgbA3/k3BRnbr3z3ZoQJyZZWIDjXxuYsKw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by PH0PR12MB5420.namprd12.prod.outlook.com (2603:10b6:510:e8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 06:43:49 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402%6]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 06:43:49 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jiri@nvidia.com, vadimp@nvidia.com, petrm@nvidia.com,
        andrew@lunn.ch, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 04/17] devlink: add port to line card relationship set
Date:   Mon, 18 Apr 2022 09:42:28 +0300
Message-Id: <20220418064241.2925668-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220418064241.2925668-1-idosch@nvidia.com>
References: <20220418064241.2925668-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0503.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13b::10) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d141b33-2800-4eb4-d0c4-08da2106cb74
X-MS-TrafficTypeDiagnostic: PH0PR12MB5420:EE_
X-Microsoft-Antispam-PRVS: <PH0PR12MB54205077F1005007422609CDB2F39@PH0PR12MB5420.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7wsvtkujDq533+X7fMVDuQzaVoXWjYcpB1x0pb8rOaKLt1v5u4jPDRugHWSRciH8l5pGMRi2LDUYE68K7LineQkqw575jJcdP5K56KmsAsCXqXqM7bBC1XqCu3mKXycWHa+zrtqM2b4zhFa+isA/MiXXaLkRGMcium2gNj/WmhFEBdGgW472vKL0DpCg6308M02gyTkIVIye8urjIuKNUEca7s5oFw4D9sNLT+RH0EAwOtmVhmj84vibX8tYdz/NOvDcw6h1lFpp5rPu3H3KEEYxy86Gu1HdfHM3gWGCwtRG27NeUL3PKtZ59T9IeOc9HbdV7Rwh2FW0f8R6Z8ot8Ipmegl9jnZelnxdaKC9twgPuVuvAAGyFbJ2jIDcmuwml+26LTCLcmG2eno2l8hxu+HMbCQVkCX4l9yup+d8ibCNcSvsWalODgt+ptPl1k7CFzJlFmGIN3UzZ3vk3XEogaz6/nwynxq2h3wACJnHFLhegI7lZFVHFWrsJvmHzD9kcoxRFj5nUBnGz7WTfREvwJFciw/kw7GH2GDNW8YuUovNRCVq4S8+IvoRFhl0UnoGZcztSGFx5K/cBLn0MwVCmdJeoc0SO9AMYcBNVZuQGNC7DWQEJKot+4Vzt+I610AIeUxPa2e84jQIcMvFzsDnGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(6486002)(508600001)(1076003)(2906002)(6512007)(6506007)(86362001)(6666004)(36756003)(186003)(26005)(83380400001)(66946007)(38100700002)(5660300002)(66556008)(66476007)(107886003)(2616005)(4326008)(8676002)(6916009)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xgx9HbdGaKd+zXNai79BETOHZY0kSDRpk5Jg6G2fTNGSc6kQriYegYeSTW5/?=
 =?us-ascii?Q?8g4MfQM8rYRSfzD52dndSlaF0wglrxz+1YFSm+lwsDejGIsFr6mU4ZbzEqqK?=
 =?us-ascii?Q?LfbTHwWkRjopj8hkjIRCaj0p91JqOWPV/EOXFfeppUjNGNNNjx9sgKZek/8F?=
 =?us-ascii?Q?PJdLsym35Of8AqS76sq9gSAUoN4cF/Z53VxG3Nslbqeys/pqrogzp1SVohFJ?=
 =?us-ascii?Q?YWciE2YXodNS36yS2SFApqGzMWPVRcM5WBsabYl5yWD0GiB9wfVoc67g6OW7?=
 =?us-ascii?Q?nuC3S5fh4bWGt8+ie8Kb3jGNobRvCGhO2d/dtA+ctnz+vwb6ID3BJP/vfvDV?=
 =?us-ascii?Q?fzzZA28HvSXUHCuJI4zZVF2CSFFv+iSMKS5aEXIEWp/8caUZ4aElUCwIpD0f?=
 =?us-ascii?Q?eTLFCoa8D/I3tTpW6hBw0bJ6HAJS/dYFTz1/muoa9KBDBTWpiMThHn7E8rPE?=
 =?us-ascii?Q?ArV7aw+SHTCIE0CTPKLW68kIUZcDInBFrxYPhWbFQgn6VSYLUPC/U0T5nQ39?=
 =?us-ascii?Q?fzE13CpTh3LhFfYXwbnUGMC8oiURMFOe4AF+QHTxP/DbtoxvW5lzjH5fEpn5?=
 =?us-ascii?Q?td3UPo2d/YZc9016wxm8VE8j1EY8qbc5I8AYH3P1y78E+E7uL0WILz0KBsUZ?=
 =?us-ascii?Q?R+4Ds0rdWFhJ/DyDPJSbzHZSFn4Jfq2FPwPzb7DiM7U7nvy7qFurBGcRg5rM?=
 =?us-ascii?Q?JPpHH5lRrefEHT2gido5PxjSlr/tRx5ZGK1zuqfDyD5FMRqMwAAfgcfvgXwR?=
 =?us-ascii?Q?nNiAqZK8NOhVa1eHcuhs6voswZrjyO83UQXAoTJLgUjeXpBOqTzf/FDlMhtx?=
 =?us-ascii?Q?LoAx08Rg+VmOP6B7Wc3OMaF3YKprRJMnLMfzCya3Oza4ORLzDxvOha3K9B6x?=
 =?us-ascii?Q?BlLrGq+125EWhkhdg5DRxqP3e+6If3j6mQBUOBMwq4ZiKmqz2RSKpEU4my1n?=
 =?us-ascii?Q?EB30Zt0wyf/KovHutKZvOZ4DUhbm6SaGI9ggeFz1vm7Wv/iJv1cPuCJ5l7op?=
 =?us-ascii?Q?kWnXaLHntd6rsYJ7jVhFLh70KKw67Id04J69W++y5YWRry2LVEuep+YyEvKy?=
 =?us-ascii?Q?3n1jdzRnxlhh/xr8ynsUI70ayLJ724VpIIis4n9kmpBTovE4CZloxef4OfU0?=
 =?us-ascii?Q?0h+NigdPfSnH8Q/LOPsBjiEz6It30gXiZJhz6nL0Z5qAkRZ1G9O7TSr8D80E?=
 =?us-ascii?Q?fx+NS1xxh45zaUcrMizcfVjz3n2uu43dryNFehMat7pUBK/T3mmJC3ujHNB6?=
 =?us-ascii?Q?ByuKNeIAFWwkO5nkgFv+Pvmnigc3dlawiwvdQTVZU8ZNSv9N4iIbtHMfG6AA?=
 =?us-ascii?Q?u8Ix1+++UOcyHmZJElCbXaDOQcbFJGXHOa47vd/rz9K6uCNf9LJUYimFl11e?=
 =?us-ascii?Q?5HHczFmnyv5lrM20GFMwHy27P+nahcQPBQERCNLx2SgE8FKLvPUgaFI9YLhl?=
 =?us-ascii?Q?YjkCb8QPTlTvJR6FtIQOcuo5fa7TS7UA+DcKUx6I/YTTheGdnKovy3C/b0sR?=
 =?us-ascii?Q?/jYMc2Lze8qx0kj1oclvTVfznPnUOO7hrvWEd4OZcTYuGxGdBTTtNj5h+PRL?=
 =?us-ascii?Q?iotZ4hbGsI6aw4K4xYjp4dYjRykgu7SWaoR3f43fwMb66vpeK5eOgZiqFPtN?=
 =?us-ascii?Q?02U3GO4fDBURKFwttgHcMPNofnlG24UDtHGAcXo94SDa9bTUg/DnJhJwZNDt?=
 =?us-ascii?Q?VPy+HnsFq1440qmorMyMA3YMdjVjyIGnvpG54zqyCJts7DKWUE3xA7vUq9vc?=
 =?us-ascii?Q?6sDSzGcHyw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d141b33-2800-4eb4-d0c4-08da2106cb74
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2022 06:43:49.4702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tMZPvKfaPAYy5ef8ALqW65EXsCbLxOCcr9PVoIh/F1IroryXM5ZJd+r6R+0Q4TXogfm41jCuwzCH6Z6zgRhc6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5420
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

In order to properly inform user about relationship between port and
line card, introduce a driver API to set line card for a port. Use this
information to extend port devlink netlink message by line card index
and also include the line card index into phys_port_name and by that
into a netdevice name.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 include/net/devlink.h |  3 +++
 net/core/devlink.c    | 26 +++++++++++++++++++++++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index d8061a11fee6..2a2a2a0c93f7 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -136,6 +136,7 @@ struct devlink_port {
 	struct mutex reporters_lock; /* Protects reporter_list */
 
 	struct devlink_rate *devlink_rate;
+	struct devlink_linecard *linecard;
 };
 
 struct devlink_port_new_attrs {
@@ -1571,6 +1572,8 @@ void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port,
 int devlink_rate_leaf_create(struct devlink_port *port, void *priv);
 void devlink_rate_leaf_destroy(struct devlink_port *devlink_port);
 void devlink_rate_nodes_destroy(struct devlink *devlink);
+void devlink_port_linecard_set(struct devlink_port *devlink_port,
+			       struct devlink_linecard *linecard);
 struct devlink_linecard *
 devlink_linecard_create(struct devlink *devlink, unsigned int linecard_index,
 			const struct devlink_linecard_ops *ops, void *priv);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index aec0a517282c..5cc88490f18f 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1243,6 +1243,10 @@ static int devlink_nl_port_fill(struct sk_buff *msg,
 		goto nla_put_failure;
 	if (devlink_nl_port_function_attrs_put(msg, devlink_port, extack))
 		goto nla_put_failure;
+	if (devlink_port->linecard &&
+	    nla_put_u32(msg, DEVLINK_ATTR_LINECARD_INDEX,
+			devlink_port->linecard->index))
+		goto nla_put_failure;
 
 	genlmsg_end(msg, hdr);
 	return 0;
@@ -10105,6 +10109,21 @@ void devlink_rate_nodes_destroy(struct devlink *devlink)
 }
 EXPORT_SYMBOL_GPL(devlink_rate_nodes_destroy);
 
+/**
+ *	devlink_port_linecard_set - Link port with a linecard
+ *
+ *	@devlink_port: devlink port
+ *	@linecard: devlink linecard
+ */
+void devlink_port_linecard_set(struct devlink_port *devlink_port,
+			       struct devlink_linecard *linecard)
+{
+	if (WARN_ON(devlink_port->devlink))
+		return;
+	devlink_port->linecard = linecard;
+}
+EXPORT_SYMBOL_GPL(devlink_port_linecard_set);
+
 static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 					     char *name, size_t len)
 {
@@ -10116,7 +10135,12 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 
 	switch (attrs->flavour) {
 	case DEVLINK_PORT_FLAVOUR_PHYSICAL:
-		n = snprintf(name, len, "p%u", attrs->phys.port_number);
+		if (devlink_port->linecard)
+			n = snprintf(name, len, "l%u",
+				     devlink_port->linecard->index);
+		if (n < len)
+			n += snprintf(name + n, len - n, "p%u",
+				      attrs->phys.port_number);
 		if (n < len && attrs->split)
 			n += snprintf(name + n, len - n, "s%u",
 				      attrs->phys.split_subport_number);
-- 
2.33.1

