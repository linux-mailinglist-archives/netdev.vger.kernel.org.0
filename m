Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E68E768AB7C
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 18:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbjBDRMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 12:12:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbjBDRMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 12:12:05 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2075.outbound.protection.outlook.com [40.107.95.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBBC432E7A
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 09:12:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bpsipdVGqHf+XXz9cHRr5vIfdkPPhjQOVeuUWqSaGOzSIWFWBBpjzT9HijPdDbDX0uE8a54m88lZ+eNrfAgo75sY9F9OGHdPyMlTXRj0U8s22Z18Ax0LlSPL7kThDdWRiihHaLfKfxAvgvxGMYkr0icBobUtTRzRwcC+7gS7TGoJ6dd+XJDp8amDxidW7BWoExeThFXZJGzkWB2puGE+6gOSUvfujARn49BKZ9pE+oipOczopB1wtbGVM4HG5Sr209+fhk7iCBEa6K5q19NPmRDPBE7e73Vci+brBJoOZxCWqIXm8fT5t63xrshYEzLK5tEI4ip2JIjNXVY8r5aBiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pm2ovCickvnFXCstWja+Dw+7KeSdnFnGAV1e0dRnnTk=;
 b=jIsFPLiOUUhbL4ESKrMbY0tq20VDzr/+DR5v9uloKkihD6I2ivZ5u2+WHkHgPWt/UTthlRzNdLsvIDNMH02Wqk8BJZQ9ETu3YahJMKPTj7kqlgF7eMIMeaeIGUMgbRGomrQbmf45Byc2LW+pZfZrLPqELCQ3W4q2ic28RoBs4tuUprln8zgK15cv89Kg1ZzAGPZT6Imy0ziz3oxdMBhvN1IH4T7asF1vmmQDrrhQN4RaLUL+HaS+441ZnWUgwqoq0qIBcMkMavSL27/1hZLlfYfl6k7J8ctVwrkiPdVFiaCgH8l5/ORopcVvs+wVA9ibaktbG1wl3Kxqts4kOuL51A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pm2ovCickvnFXCstWja+Dw+7KeSdnFnGAV1e0dRnnTk=;
 b=POhQMAWiOh6k1lQLLYeFgL0CAMcU6BCIPZpAHdJDEj2qym2CC+3CRyl5r83IKnX0OE5PSBTM2eXqYBKcLY0LPJEtEavR3N/A35FEBmhq4wkdGq444AqvKoV0TCAYVGra88DCyy30k6jDh58VLl2WKTM+QhmAc9MSAP2VuJ+nbKQL/iDusCrUol+VY327Ed/dNjqoQ+x2JY2IUQR09/NDJPnTzdmyameXMUnxWFM5sWI+9tMD2J1123cd1/300/M2pDOOM/Lenx8n/ns/hJtbH79B/yOpHq6ZZwksH9O5DDAnYo0RfFFZc6qpJfK4a4BfibRedMGM98ZcXe4f4dg42g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SA3PR12MB7997.namprd12.prod.outlook.com (2603:10b6:806:307::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Sat, 4 Feb
 2023 17:12:00 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab%9]) with mapi id 15.20.6064.025; Sat, 4 Feb 2023
 17:12:00 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, razor@blackwall.org, roopa@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 03/13] bridge: mcast: Move validation to a policy
Date:   Sat,  4 Feb 2023 19:07:51 +0200
Message-Id: <20230204170801.3897900-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230204170801.3897900-1-idosch@nvidia.com>
References: <20230204170801.3897900-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0040.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:1bb::17) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SA3PR12MB7997:EE_
X-MS-Office365-Filtering-Correlation-Id: 80b9188f-7d72-44a4-9c04-08db06d2ed61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aT2Sl1tXJuOarMRCl3X+RFKBo72ur8gM6t7E97IjbqcGxFsrmwHO9aAf/7CzPJUSSIZMpepxiEzVOUZnIgDqEIEWksYeK9hdge0gb2jiXu7S2U4QZk+lr0GC7m3jDEGNyF0CZnkEgUsg2dU49iDGByY2591WCTyWpSUxt9IgBJ62QJOPIC8TtUzL0cWTuqGQRlYUZCmRbMOwpMaDUzkE5YlS43+zBm0+MkoHwKHQGeMFwvkYXuzSxB/i+uYrt3IQKEyonz4JNYVNQ0tTJjF8Z00iaXbygKSdG/EdsuPJFxpMZOfvAILr2nDFYwS/rIz7wCCVdcuhuvi7tXrmXANmWkN82iLecY7BgH4+yKM4A1grp20qik8qAPxprjrdYOg8G1chcnMPYA8Aq40Q5oWwW9yUs439Je4icbetK71oxJx360C5711Frah1ePxXlI+AUdMQ+lD/+UmqAOjh7fD2ArSisIqVB8COcA9soe4eqJRbzj4A9Cw8XhYsxD2AhxvpLA4p6Fe56pLf0ucdhwy3orJ8M1Us9Ea3mI8UotnrheZDRayWwM2s8PZaZK4UiJ4rMI1QuorJihyRiuXTE1oq3F4TDjrkIacDX+cMsaXPPLZldWC5vL+M+kN9i3nP0vazdukYVyKSOQgVNPeQGCzoKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(366004)(346002)(396003)(376002)(451199018)(8676002)(41300700001)(66556008)(316002)(66946007)(36756003)(66476007)(6486002)(1076003)(26005)(186003)(478600001)(6506007)(6512007)(4326008)(6666004)(107886003)(38100700002)(2906002)(86362001)(8936002)(5660300002)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KIfn6ywYNXohTO5HCdburuukCcij+ixf+wI1Xq4DyQCMvKZBMvNE/SfnKMbp?=
 =?us-ascii?Q?YsetTspkqkaEFaZMyVSIcIA2ApynvSudAT+A+DIlabeEZM1NFom3s6LGy5wZ?=
 =?us-ascii?Q?l98SWxT/ktlq0O6R4GrQWdUGYcqms97WbnAEyssAPMnj9KOMnfYgXx7pFzAQ?=
 =?us-ascii?Q?REeFzU82fOor5eaqyY8OqEsX/vUYooX5pPCOe/Gb0O4wO7cppoDwTp5ox2ri?=
 =?us-ascii?Q?8mbwOcjomSRjUPRg50coeX6MXN4YSOFGTbcwgkPpYkMnpY3VJD0Hzh1Z22lx?=
 =?us-ascii?Q?qE6xiooWkHwLnWu7roHrsqGodTg4NH68X4a2veRbaZlAUq2OYSTU+jJMtke9?=
 =?us-ascii?Q?jXkFCv1v+EUtXAZ4WoRrtyzLqyMTRUHfYe4uNqv2eLrmJYdyGGveck202yDf?=
 =?us-ascii?Q?ndxWjdGQSecjDb1OMz5asd5l7lqW/rJdbyHqbbyJPKXWHXhjyycx5Scqx2pv?=
 =?us-ascii?Q?5EYS404NavCJ7FNlJ4V0Y1iZ7yyGXtjw+EO69Pruw7peX/M6/xSpTKO7fHot?=
 =?us-ascii?Q?1W131EPWEnyZ81Ho4G7X1PWPPABTc/m8LOMy3ar3a3acpkDVF5SGlRTFvsHO?=
 =?us-ascii?Q?Z6VVg5XCQJ744GOKxReFas0oJOQvOJsGipH2XhyBYyQQOrtSZAQsBSPpdAZ6?=
 =?us-ascii?Q?AbmHO9BbdpwH96hfwan57/NYRpxjRpYgR8c712jmmivY/6sUexOXpuYicJHc?=
 =?us-ascii?Q?SwB0uN31xuvqgVavzQTuhZRw3gSnbNmjsC2kV0u25gOJVZZhvLg78y1RJbyV?=
 =?us-ascii?Q?9wBOTkKLhXAipQx5GwZRBi0TTcR5F26thTSn3ZhjS9Z3dVy4Mz4B9DiALfFU?=
 =?us-ascii?Q?a6WTg99fcdXDs1SMq7BAyomkui9Ig8OODqnKeGIqogX4ho/dspA2T2xN3FSm?=
 =?us-ascii?Q?5Ta206jpHma0VKL+BY2NyhInfvhit6RgJJiRUhE6BAk/SxzxS89DVxgG9R3M?=
 =?us-ascii?Q?63eB/uIX3ONaE4O5skHaPGf5rLN9HRfe2NRN4FHxRKnhfVVKLQSqaRE6hhqU?=
 =?us-ascii?Q?RH27VlazzQwmgeEkRac4vjyq2uGPnTxiOC2AIq1vRSlFgoMmTLZq0rkvbsGd?=
 =?us-ascii?Q?W5IuamRT/8Rh2zqIO0pJXro1k8AGL8do9RGZLMXwBE3XoQ0kYVqvjW60JQLm?=
 =?us-ascii?Q?JqdWIUQZKHmjL/kLpUi3ON/5yqWbkAIyf3JkB3XDFjHfXHI4/s2VZP+5FX7o?=
 =?us-ascii?Q?5P8LX3GY5sUyoM8K8fXVFwyIXt3XXUCbF5Rs/Pz/EfmG0McnflYxeiF5rAkM?=
 =?us-ascii?Q?izDUYbkxoKy9hlGQHHXieuVz+9RvUPiVdthjb//FbZp9FdZlxnBZ7yxkQGAp?=
 =?us-ascii?Q?+E8jzB+9NECOpZWUPDxvkRf8QUOhzMmhKu5ReG4M/ophOWm+rtrJwiNZnZVc?=
 =?us-ascii?Q?61Ni3DqGqnXU4VuHJWo5s3qkdUOiEBOlflA0qqoodwnuLFVYQG1L4SjiViFZ?=
 =?us-ascii?Q?AqPb07zLak0+vmpaT3dWZ/1mezUtNTV3PSNEZE080GqGA6my8W6Uv+Wkdh9R?=
 =?us-ascii?Q?90a5ypbGrMpsRYDcIaHCrTMftunfmn/cfgQsuhI9nrPjkkXZEgMN/tDo2s9U?=
 =?us-ascii?Q?8ZeWKqpfVF1Pdt7O8VM0AufiVEgEz1IzIU4K8Dqh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80b9188f-7d72-44a4-9c04-08db06d2ed61
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 17:12:00.0583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kddfsY2oBNob0dOVx47s1CVsY88rgu2Pw/PAwLp6JaNUC+a4UlBAUaRqrTAA/jw5SWjt2NUkXRxKg5PBLiapXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7997
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Subsequent patches are going to move parts of the bridge MDB code to the
common rtnetlink code in preparation for VXLAN MDB support. To
facilitate code sharing between both drivers, move the validation of the
top level attributes in RTM_{NEW,DEL}MDB messages to a policy that will
eventually be moved to the rtnetlink code.

Use 'NLA_NESTED' for 'MDBA_SET_ENTRY_ATTRS' instead of
NLA_POLICY_NESTED() as this attribute is going to be validated using
different policies in the underlying drivers.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_mdb.c | 45 +++++++++++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 18 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index e40a4c275d63..b1ece209cfca 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -683,51 +683,58 @@ static const struct nla_policy br_mdbe_attrs_pol[MDBE_ATTR_MAX + 1] = {
 	[MDBE_ATTR_RTPROT] = NLA_POLICY_MIN(NLA_U8, RTPROT_STATIC),
 };
 
-static bool is_valid_mdb_entry(struct br_mdb_entry *entry,
-			       struct netlink_ext_ack *extack)
+static int validate_mdb_entry(const struct nlattr *attr,
+			      struct netlink_ext_ack *extack)
 {
+	struct br_mdb_entry *entry = nla_data(attr);
+
+	if (nla_len(attr) != sizeof(struct br_mdb_entry)) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid MDBA_SET_ENTRY attribute length");
+		return -EINVAL;
+	}
+
 	if (entry->ifindex == 0) {
 		NL_SET_ERR_MSG_MOD(extack, "Zero entry ifindex is not allowed");
-		return false;
+		return -EINVAL;
 	}
 
 	if (entry->addr.proto == htons(ETH_P_IP)) {
 		if (!ipv4_is_multicast(entry->addr.u.ip4)) {
 			NL_SET_ERR_MSG_MOD(extack, "IPv4 entry group address is not multicast");
-			return false;
+			return -EINVAL;
 		}
 		if (ipv4_is_local_multicast(entry->addr.u.ip4)) {
 			NL_SET_ERR_MSG_MOD(extack, "IPv4 entry group address is local multicast");
-			return false;
+			return -EINVAL;
 		}
 #if IS_ENABLED(CONFIG_IPV6)
 	} else if (entry->addr.proto == htons(ETH_P_IPV6)) {
 		if (ipv6_addr_is_ll_all_nodes(&entry->addr.u.ip6)) {
 			NL_SET_ERR_MSG_MOD(extack, "IPv6 entry group address is link-local all nodes");
-			return false;
+			return -EINVAL;
 		}
 #endif
 	} else if (entry->addr.proto == 0) {
 		/* L2 mdb */
 		if (!is_multicast_ether_addr(entry->addr.u.mac_addr)) {
 			NL_SET_ERR_MSG_MOD(extack, "L2 entry group is not multicast");
-			return false;
+			return -EINVAL;
 		}
 	} else {
 		NL_SET_ERR_MSG_MOD(extack, "Unknown entry protocol");
-		return false;
+		return -EINVAL;
 	}
 
 	if (entry->state != MDB_PERMANENT && entry->state != MDB_TEMPORARY) {
 		NL_SET_ERR_MSG_MOD(extack, "Unknown entry state");
-		return false;
+		return -EINVAL;
 	}
 	if (entry->vid >= VLAN_VID_MASK) {
 		NL_SET_ERR_MSG_MOD(extack, "Invalid entry VLAN id");
-		return false;
+		return -EINVAL;
 	}
 
-	return true;
+	return 0;
 }
 
 static bool is_valid_mdb_source(struct nlattr *attr, __be16 proto,
@@ -1295,6 +1302,14 @@ static int br_mdb_config_attrs_init(struct nlattr *set_attrs,
 	return 0;
 }
 
+static const struct nla_policy mdba_policy[MDBA_SET_ENTRY_MAX + 1] = {
+	[MDBA_SET_ENTRY_UNSPEC] = { .strict_start_type = MDBA_SET_ENTRY_ATTRS + 1 },
+	[MDBA_SET_ENTRY] = NLA_POLICY_VALIDATE_FN(NLA_BINARY,
+						  validate_mdb_entry,
+						  sizeof(struct br_mdb_entry)),
+	[MDBA_SET_ENTRY_ATTRS] = { .type = NLA_NESTED },
+};
+
 static int br_mdb_config_init(struct net *net, const struct nlmsghdr *nlh,
 			      struct br_mdb_config *cfg,
 			      struct netlink_ext_ack *extack)
@@ -1305,7 +1320,7 @@ static int br_mdb_config_init(struct net *net, const struct nlmsghdr *nlh,
 	int err;
 
 	err = nlmsg_parse_deprecated(nlh, sizeof(*bpm), tb,
-				     MDBA_SET_ENTRY_MAX, NULL, extack);
+				     MDBA_SET_ENTRY_MAX, mdba_policy, extack);
 	if (err)
 		return err;
 
@@ -1347,14 +1362,8 @@ static int br_mdb_config_init(struct net *net, const struct nlmsghdr *nlh,
 		NL_SET_ERR_MSG_MOD(extack, "Missing MDBA_SET_ENTRY attribute");
 		return -EINVAL;
 	}
-	if (nla_len(tb[MDBA_SET_ENTRY]) != sizeof(struct br_mdb_entry)) {
-		NL_SET_ERR_MSG_MOD(extack, "Invalid MDBA_SET_ENTRY attribute length");
-		return -EINVAL;
-	}
 
 	cfg->entry = nla_data(tb[MDBA_SET_ENTRY]);
-	if (!is_valid_mdb_entry(cfg->entry, extack))
-		return -EINVAL;
 
 	if (cfg->entry->ifindex != cfg->br->dev->ifindex) {
 		struct net_device *pdev;
-- 
2.37.3

