Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E415D51B789
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 07:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243672AbiEEFrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 01:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241070AbiEEFrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 01:47:48 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2097.outbound.protection.outlook.com [40.107.236.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885BE34B97
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 22:44:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rs1gzJ+dAmbU3MDS07/jtt37hR+qe0ylxRSRARuT2wV21guxtSPkKYyQr01G9qQShH8Hbtf9KHPmSBAx11jBFKIa1k6JZ76rSfMLmZxReveEBjWeURyxbIYI6go7O+Qvi8rHRX1AFJKq4hRrjPtGjFuCKcS4/jPZ7Sgtb0FU8jnn6l+cwszW5i2Yziry/oVL5jyMWImDepIK54SAHpi+NYq1Rcy5wjV9Kueq2Yw2eSc1J1ChzX6Wd94J5jTpZEuEaiOgKdTJBhjlMwSkWs4tqMH5lB6XIeyUTQvTo+EAvF9oEJ2bHj7BlKzNc0Q2Qh3SeaQxpiWPD4ZY7Eg1FC9Mig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wWOm1NhYcUW3/S0DF2zhRwWgres9rcDs5+vSuGi2RmU=;
 b=QOYU1gQnUtUX1BYtQ31GkLNsYwouruDhZSH9cR1zlkyzZ1VyYpksbdl0+HsZKdZQ1vkXahXWfuUGV7mTEWnizvrWqSbSlwAe9ebd33APzo+9cpmy7IfbA88C3mSXk6w0Fw5dIXqWafp7478rUy9tWvpva4i4FqGpRJToCojqI0iH4A9QwAIHrumJ7uoP9OzxdKO6OXUvnH9xqXSSw7e9aG8mTEYTvKxuMRzpAeFxlmVDOqDSD+uvTonOqHXUjWCJ90OvHiuLTqzLkTV/0wXQq65CUWRyZSZBCJhBF2q5lzSmcr5Xg+jxnbWX67bpGq/VJj/KCjIwK9/ZT4HWOadEVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wWOm1NhYcUW3/S0DF2zhRwWgres9rcDs5+vSuGi2RmU=;
 b=hZ+50ErZNlZFJJyquljtosMNQ0OagA3HWRINXp3OZQIdnEIAaDC7yLDU+JdojuCtmCoEEzhM768eMAIJHuGFgid+70+94AbrLjti72YDufGyBvIJCd5RSK2uHI49l2LiTrDfEHxGbtS8ykNXxHPghbQUgC1fPPii7P1YKA6KObQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM5PR13MB1257.namprd13.prod.outlook.com (2603:10b6:3:27::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.16; Thu, 5 May
 2022 05:44:06 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94%3]) with mapi id 15.20.5227.006; Thu, 5 May 2022
 05:44:05 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 1/9] nfp: flower: add infrastructure for pre_tun rework
Date:   Thu,  5 May 2022 14:43:40 +0900
Message-Id: <20220505054348.269511-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220505054348.269511-1-simon.horman@corigine.com>
References: <20220505054348.269511-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0082.jpnprd01.prod.outlook.com
 (2603:1096:404:2c::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 164d5302-2a7e-47d6-00eb-08da2e5a444f
X-MS-TrafficTypeDiagnostic: DM5PR13MB1257:EE_
X-Microsoft-Antispam-PRVS: <DM5PR13MB1257C87EF3B702FC9EC2A08AE8C29@DM5PR13MB1257.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wP5Ebyh3gF8nUXBoyxLy7XPIj/ay/DW2yrfUQQorfSTuy+YdV4C9KMfEZS62+hW5WpsWFYCBp4Y37MX+kUibvDBSAFdScCnYUO3LDvv5DdaFdoVGi8GZeyqrZl4H7geWupEfuQz79jwx/hK+gVQYtbuxFzZZBsRORjs5hWk4JPT+NMguQbc2gRaOsKxZfW0QP48m0jEkpPZbC5YQKmV6M2iTVuU4dm3uZFKZmyM0xgjZg5RkazOvksZigPm7xC9M81Kgdy34vqEW712givPjndHtRGhMmnt+ac/vDjZWYB/mOtRw+XmtztD3ylj6DgLE/YIHM7z4NRA+v0qp5DlIH21qKELXyWInJ/ClmHnUa57yw69rv2Z/MZj+sJLDrZUopjzpdx4m9Ld5G3BQ1vVIn4sEJvDH6qjcS9GqVgfQIZvtIFonwzUpPFXmqa58mIDGNxdXCSca+NqRT04Nt+emxsAtTZD1fcGbMQyNotqth1wug2C7on/LjOJ/+UftuJRIuUTkjtAUkkhqkjCzqm+X87RVJq0eOuBIDo5yvlLCfPql7CyZujraYoALi41iOYFusWoFFN77uFw7JNwPJc9RconmpP1Qs2hvItfRnh10UTIg1LZv0VbfWw8muxXT51jHz2uXiGGR/i6BswQ6hgfupniyD7+ROnWt4JTy84Vw6I0yV3oWGK91tWjipNQbiP9BI2NqWdSulOimSSf3DwiZag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(346002)(376002)(136003)(396003)(39830400003)(66556008)(66946007)(6506007)(8676002)(4326008)(5660300002)(52116002)(1076003)(186003)(6486002)(36756003)(2616005)(316002)(110136005)(83380400001)(107886003)(66476007)(6512007)(8936002)(38100700002)(38350700002)(86362001)(508600001)(26005)(6666004)(44832011)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H83qCj5jg1j7u6afXPy3/ZBszqlZQilDF+cE7/sI99KwdPlzk6huivdAs1XY?=
 =?us-ascii?Q?vhFo+r0sQjgGlFDCW/7VL3px7G/iJJ5l37sT3pBal1ymptWUfI4Sk6NAYOa/?=
 =?us-ascii?Q?tqtFOJMz6Uj0lT4mn+2JTQ7xm9KxcAPrkvpZZetz1UxnoOns3lv4pv6mMtoU?=
 =?us-ascii?Q?JFYHwlnllN0w6Sd2LOc0GfjuNtbbPyJFC5YNvAywMNtpW+b/GIm21LRPRkOc?=
 =?us-ascii?Q?L7Lz/Dm74KnFU1i5eSu1+bCBAPbXYrnxsvPe5oaz7+m3VKei+Bj94XMc/8h+?=
 =?us-ascii?Q?x5MNW/VHFYABuE8wlh5aVHl86wHW3117MvjHcMzdnFpsNYVmKZeAio7FA8ZX?=
 =?us-ascii?Q?vWfzuch5kPcvKtUdMRHsOI7YUVCEG+1mUspu+N/mWJcW7r1wzbih1X2r4GQO?=
 =?us-ascii?Q?m/zRlcBgem5HXkxai5h2gNQyJgW48TYVl3QXLF0bXDB/hvVx2xr1TYQNgBp+?=
 =?us-ascii?Q?XqJgfvwmVBAqxaAwF5KMBCKLQH/HehbC3G20s464h2vY/Y1rZCjMUgdqOahH?=
 =?us-ascii?Q?p6JtXMwa6Gd5wWVmo1dRTVPkNzotgl+yZaSSlnlSYSXdGZaoceUWdY/bdtvX?=
 =?us-ascii?Q?MJrkCP4Ilm81Pb7EcmTzUDKEVvdqaeVWVCc+Fryrgst00oUgQDFwGSRcbiJO?=
 =?us-ascii?Q?KYDr8F/2QSkcwavfjG+BWB7Sbjy1vBMJMXIS6Ym/QJGZ59ioKmV8C3FwUXiH?=
 =?us-ascii?Q?Ycn+Q5CUpfbrS06FvkmwBr3wd2lxcE/F2QCK8GIXvXQArLzP2FNJ7I4Lz8uX?=
 =?us-ascii?Q?y/+PgSnHwnuy+coiP+0yndhGNl2sQRrIqNWWW74omcN0H6HQeFuoMPgwSddS?=
 =?us-ascii?Q?eibjgvEhBY+K3U1LcLsSxNMDWVjaLplO6metKPEhLMOw7G/T81Tm0sMkbCAO?=
 =?us-ascii?Q?F1zBA+9qU9YbFTt9/pAf65joo8ItGE0vyfsCa5kVvY98DaDtiOnXAE6yOOq5?=
 =?us-ascii?Q?CAbQsOPJHNtOF9d6vbFB1mE7JP1cchaOGAJJsg/DS+fydhdtNIQnXaFTEwHu?=
 =?us-ascii?Q?22F/zzAkhKYWSdGIOPZB89Om6weKYbpsQ/FY+R6NGjVvtvbJkdtKdOUulRTT?=
 =?us-ascii?Q?Chf1xERKQS3GGtAMTjE3fdvNnGGgfQMu9wuIlH4lkX49l1vNQ5XGnjTRy+VO?=
 =?us-ascii?Q?7q2eshxYh1FSiLk0/dEdwQ7C2LGealVjX5JM7/XZohJR2Vn7gi2lzz1Dpt6b?=
 =?us-ascii?Q?3pQq+qKx0GiCTDmeFyso6v9Q1VODRql5eD+eAoIxST1UXVrZPly46IBZzUW4?=
 =?us-ascii?Q?6JeQvikU5hOZcUbNTLEY2YOdoxWhN5c3oMimQ7W+nt92AZyM2e+YJzUjaHqN?=
 =?us-ascii?Q?kKL/rJIE+aYkpTEuDkoZsFRBZnXUuawgYXH+vLS1EnKhRfth95OIWKoFgqpc?=
 =?us-ascii?Q?56Kb9gxuf4iRXSbzJOCPqsJOM3W9CLomBaampRKqltBWiUqz7Pu7hHDMHyjE?=
 =?us-ascii?Q?rsmN50Z2y9CqZ21iuojEvDRFABHTBilT291bZv8w2TKOCoh5wVsMsf0qK84r?=
 =?us-ascii?Q?A33wXBfi3p+GDjIQezrCUfjfH01pCsmYuwl1oRROr1a20M0xVy/c/z5mYGT5?=
 =?us-ascii?Q?Gxx6YIr5HAfALK5QDuwqMzRIOuwBx29keckzWx5DWINEPzrzs6lgYH0rBmxL?=
 =?us-ascii?Q?YlA44yi7Ub/OoPEaR7lQ11jXTyAkthGeXp60zPLZd62QLeCG13BzkIYCM7AC?=
 =?us-ascii?Q?mSy+LvZ8BzzxWcTR4vMUbUoSzifcjEzigL+1hZuZes7BGO2O2raQAgeiM9TG?=
 =?us-ascii?Q?4q15OjZMt8X+OcLH1+ufnv8J27GX1gs=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 164d5302-2a7e-47d6-00eb-08da2e5a444f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 05:44:05.5871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NFNfJYANMbFEc7L0uRvmYxTc7sZOdUEm+UoAEp6RqucvFTDu2z/TKUkSRaUtUzXC8CsCF4DqTO6YMjCgzyFsGBAFBURm9hDfkuiYRL87m9w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR13MB1257
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

The previous implementation of using a pre_tun_table for decap has
some limitations, causing flows to end up unoffloaded when in fact
we are able to offload them. This is because the pre_tun_table does
not have enough matching resolution. The next step is to instead make
use of the neighbour table which already exists for the encap direction.
This patch prepares for this by:

- Moving nfp_tun_neigh/_v6 to main.h.
- Creating two new "wrapping" structures, one to keep track of neighbour
  entries (previously they were send-and-forget), and another to keep
  track of pre_tun flows.
- Create a new list in nfp_flower_priv to keep track of pre_tunnel flows
- Create a new table in nfp_flower_priv to keep track of next neighbour
  entries
- Initialising and destroying these new list/tables
- Extending nfp_fl_payload->pre_tun_rule to save more information for
  future use.

Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../net/ethernet/netronome/nfp/flower/main.h  | 87 +++++++++++++++++++
 .../ethernet/netronome/nfp/flower/metadata.c  | 19 +++-
 .../netronome/nfp/flower/tunnel_conf.c        | 32 -------
 3 files changed, 105 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index fa902ce2dd82..454fdb6ea4a5 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -51,6 +51,7 @@ struct nfp_app;
 #define NFP_FL_FEATS_VLAN_QINQ		BIT(8)
 #define NFP_FL_FEATS_QOS_PPS		BIT(9)
 #define NFP_FL_FEATS_QOS_METER		BIT(10)
+#define NFP_FL_FEATS_DECAP_V2		BIT(11)
 #define NFP_FL_FEATS_HOST_ACK		BIT(31)
 
 #define NFP_FL_ENABLE_FLOW_MERGE	BIT(0)
@@ -109,6 +110,80 @@ struct nfp_fl_tunnel_offloads {
 	struct notifier_block neigh_nb;
 };
 
+/**
+ * struct nfp_tun_neigh - neighbour/route entry on the NFP
+ * @dst_ipv4:	Destination IPv4 address
+ * @src_ipv4:	Source IPv4 address
+ * @dst_addr:	Destination MAC address
+ * @src_addr:	Source MAC address
+ * @port_id:	NFP port to output packet on - associated with source IPv4
+ * @vlan_tpid:	VLAN_TPID match field
+ * @vlan_tci:	VLAN_TCI match field
+ * @host_ctx:	Host context ID to be saved here
+ */
+struct nfp_tun_neigh {
+	__be32 dst_ipv4;
+	__be32 src_ipv4;
+	u8 dst_addr[ETH_ALEN];
+	u8 src_addr[ETH_ALEN];
+	__be32 port_id;
+	__be16 vlan_tpid;
+	__be16 vlan_tci;
+	__be32 host_ctx;
+};
+
+/**
+ * struct nfp_tun_neigh_v6 - neighbour/route entry on the NFP
+ * @dst_ipv6:	Destination IPv6 address
+ * @src_ipv6:	Source IPv6 address
+ * @dst_addr:	Destination MAC address
+ * @src_addr:	Source MAC address
+ * @port_id:	NFP port to output packet on - associated with source IPv6
+ * @vlan_tpid:	VLAN_TPID match field
+ * @vlan_tci:	VLAN_TCI match field
+ * @host_ctx:	Host context ID to be saved here
+ */
+struct nfp_tun_neigh_v6 {
+	struct in6_addr dst_ipv6;
+	struct in6_addr src_ipv6;
+	u8 dst_addr[ETH_ALEN];
+	u8 src_addr[ETH_ALEN];
+	__be32 port_id;
+	__be16 vlan_tpid;
+	__be16 vlan_tci;
+	__be32 host_ctx;
+};
+
+/**
+ * struct nfp_neigh_entry
+ * @neigh_cookie:	Cookie for hashtable lookup
+ * @ht_node:		rhash_head entry for hashtable
+ * @list_head:		Needed as member of linked_nn_entries list
+ * @payload:		The neighbour info payload
+ * @flow:		Linked flow rule
+ * @is_ipv6:		Flag to indicate if payload is ipv6 or ipv4
+ */
+struct nfp_neigh_entry {
+	unsigned long neigh_cookie;
+	struct rhash_head ht_node;
+	struct list_head list_head;
+	char *payload;
+	struct nfp_predt_entry *flow;
+	bool is_ipv6;
+};
+
+/**
+ * struct nfp_predt_entry
+ * @list_head:		List head to attach to predt_list
+ * @flow_pay:		Direct link to flow_payload
+ * @nn_list:		List of linked nfp_neigh_entries
+ */
+struct nfp_predt_entry {
+	struct list_head list_head;
+	struct nfp_fl_payload *flow_pay;
+	struct list_head nn_list;
+};
+
 /**
  * struct nfp_mtu_conf - manage MTU setting
  * @portnum:		NFP port number of repr with requested MTU change
@@ -202,6 +277,9 @@ struct nfp_fl_internal_ports {
  * @ct_zone_table:	Hash table used to store the different zones
  * @ct_zone_wc:		Special zone entry for wildcarded zone matches
  * @ct_map_table:	Hash table used to referennce ct flows
+ * @predt_list:		List to keep track of decap pretun flows
+ * @neigh_table:	Table to keep track of neighbor entries
+ * @predt_lock:		Lock to serialise predt/neigh table updates
  */
 struct nfp_flower_priv {
 	struct nfp_app *app;
@@ -241,6 +319,9 @@ struct nfp_flower_priv {
 	struct rhashtable ct_zone_table;
 	struct nfp_fl_ct_zone_entry *ct_zone_wc;
 	struct rhashtable ct_map_table;
+	struct list_head predt_list;
+	struct rhashtable neigh_table;
+	spinlock_t predt_lock; /* Lock to serialise predt/neigh table updates */
 };
 
 /**
@@ -344,9 +425,14 @@ struct nfp_fl_payload {
 	struct list_head linked_flows;
 	bool in_hw;
 	struct {
+		struct nfp_predt_entry *predt;
 		struct net_device *dev;
+		__be16 vlan_tpid;
 		__be16 vlan_tci;
 		__be16 port_idx;
+		u8 loc_mac[ETH_ALEN];
+		u8 rem_mac[ETH_ALEN];
+		bool is_ipv6;
 	} pre_tun_rule;
 };
 
@@ -369,6 +455,7 @@ struct nfp_fl_payload_link {
 
 extern const struct rhashtable_params nfp_flower_table_params;
 extern const struct rhashtable_params merge_table_params;
+extern const struct rhashtable_params neigh_table_params;
 
 struct nfp_merge_info {
 	u64 parent_ctx;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/metadata.c b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
index f448c5682594..74e1b279c13b 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/metadata.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
@@ -502,6 +502,12 @@ const struct rhashtable_params nfp_ct_map_params = {
 	.automatic_shrinking	= true,
 };
 
+const struct rhashtable_params neigh_table_params = {
+	.key_offset	= offsetof(struct nfp_neigh_entry, neigh_cookie),
+	.head_offset	= offsetof(struct nfp_neigh_entry, ht_node),
+	.key_len	= sizeof(unsigned long),
+};
+
 int nfp_flower_metadata_init(struct nfp_app *app, u64 host_ctx_count,
 			     unsigned int host_num_mems)
 {
@@ -530,6 +536,12 @@ int nfp_flower_metadata_init(struct nfp_app *app, u64 host_ctx_count,
 	if (err)
 		goto err_free_ct_zone_table;
 
+	err = rhashtable_init(&priv->neigh_table, &neigh_table_params);
+	if (err)
+		goto err_free_ct_map_table;
+
+	INIT_LIST_HEAD(&priv->predt_list);
+
 	get_random_bytes(&priv->mask_id_seed, sizeof(priv->mask_id_seed));
 
 	/* Init ring buffer and unallocated mask_ids. */
@@ -537,7 +549,7 @@ int nfp_flower_metadata_init(struct nfp_app *app, u64 host_ctx_count,
 		kmalloc_array(NFP_FLOWER_MASK_ENTRY_RS,
 			      NFP_FLOWER_MASK_ELEMENT_RS, GFP_KERNEL);
 	if (!priv->mask_ids.mask_id_free_list.buf)
-		goto err_free_ct_map_table;
+		goto err_free_neigh_table;
 
 	priv->mask_ids.init_unallocated = NFP_FLOWER_MASK_ENTRY_RS - 1;
 
@@ -565,6 +577,7 @@ int nfp_flower_metadata_init(struct nfp_app *app, u64 host_ctx_count,
 		goto err_free_ring_buf;
 
 	spin_lock_init(&priv->stats_lock);
+	spin_lock_init(&priv->predt_lock);
 
 	return 0;
 
@@ -574,6 +587,8 @@ int nfp_flower_metadata_init(struct nfp_app *app, u64 host_ctx_count,
 	kfree(priv->mask_ids.last_used);
 err_free_mask_id:
 	kfree(priv->mask_ids.mask_id_free_list.buf);
+err_free_neigh_table:
+	rhashtable_destroy(&priv->neigh_table);
 err_free_ct_map_table:
 	rhashtable_destroy(&priv->ct_map_table);
 err_free_ct_zone_table:
@@ -700,6 +715,8 @@ void nfp_flower_metadata_cleanup(struct nfp_app *app)
 
 	rhashtable_free_and_destroy(&priv->ct_map_table,
 				    nfp_free_map_table_entry, NULL);
+	rhashtable_free_and_destroy(&priv->neigh_table,
+				    nfp_check_rhashtable_empty, NULL);
 	kvfree(priv->stats);
 	kfree(priv->mask_ids.mask_id_free_list.buf);
 	kfree(priv->mask_ids.last_used);
diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index c71bd555f482..f5e8ed14e517 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -76,38 +76,6 @@ struct nfp_tun_active_tuns_v6 {
 	} tun_info[];
 };
 
-/**
- * struct nfp_tun_neigh - neighbour/route entry on the NFP
- * @dst_ipv4:	destination IPv4 address
- * @src_ipv4:	source IPv4 address
- * @dst_addr:	destination MAC address
- * @src_addr:	source MAC address
- * @port_id:	NFP port to output packet on - associated with source IPv4
- */
-struct nfp_tun_neigh {
-	__be32 dst_ipv4;
-	__be32 src_ipv4;
-	u8 dst_addr[ETH_ALEN];
-	u8 src_addr[ETH_ALEN];
-	__be32 port_id;
-};
-
-/**
- * struct nfp_tun_neigh_v6 - neighbour/route entry on the NFP
- * @dst_ipv6:	destination IPv6 address
- * @src_ipv6:	source IPv6 address
- * @dst_addr:	destination MAC address
- * @src_addr:	source MAC address
- * @port_id:	NFP port to output packet on - associated with source IPv6
- */
-struct nfp_tun_neigh_v6 {
-	struct in6_addr dst_ipv6;
-	struct in6_addr src_ipv6;
-	u8 dst_addr[ETH_ALEN];
-	u8 src_addr[ETH_ALEN];
-	__be32 port_id;
-};
-
 /**
  * struct nfp_tun_req_route_ipv4 - NFP requests a route/neighbour lookup
  * @ingress_port:	ingress port of packet that signalled request
-- 
2.30.2

