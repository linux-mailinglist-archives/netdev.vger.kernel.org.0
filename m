Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0BE7602B4A
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 14:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbiJRMIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 08:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbiJRMI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 08:08:29 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2049.outbound.protection.outlook.com [40.107.95.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA5D9DDAF
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 05:08:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XuOG3VPrK3LfffxZ85aILZpV/HGFmqRzy7LfEAJg+oLkZv4ySn4hikxIJ5oRTFeBKMhjORUZUlldeuzpQcN7+1sOtFxZX2uT1QNOTjJ7O5B2eD73cBUdB3Zru2uC6QFvbPDCExEaFl85bUYytYVpL+bYX0TV/ViKLvqg1AWL9+r8otnUriMAkJwI67VKYQJBfqgrQONPYs+wVHGyLgvaf8MBwD1hQ4XdgFJvZe0aGLRAWjIgRxgpu3HODNR5teFSzxPHgZ6CV/UqjrKEDCO9DSwYP4SxRnTpZtrGj4Twsd70rtQMz80SrWQhoYvGYLQo95w2xiywn6nLnuWDsRjbUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N+0kRmhHrM1J6k63vIojFeJUG2oueNNbuC1r0sNFJx4=;
 b=WWgR/2T4I+thaPT7QkbFp9VGSFo0C07SNF667G1Pslve4/ctUH2v3tBSb4zTPQ2SGaVQgmr36Hxvq19VGyqXpDccTE7625OJQNRTSv9JJTbUBJPlnr635fuHvRNQrX9G+dwNTG8wviZlHIJix3J0EgUo4nSJ1N+Usl+O06sodN0g4LWabP+SwhpifJKui4y0+vLrddmIOozovA8w8GHpbEouK57VFc25tTVfNL4iLzsAHB4pUPboIP+GOwaibVJwMuDIVrJfp/xXIbnOOdK9HeCQcWSgceVWOQkMZ+PoQaJ+akXNxPr+QlHFHeDO0RliHMjGycPpKB2uu1tUiPfQnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N+0kRmhHrM1J6k63vIojFeJUG2oueNNbuC1r0sNFJx4=;
 b=e91SdAFIOzbH2Qaa5QW73kgBhZpcCuLZdifhrcHsedIejEp+8MPswlx/IK5XBdvFMYgn0qSfwsW40VeysRuFPXAM8dtCrklGMGuSANvWjENz1HHjP7aeozQX6P1l9zGhP8sp5q/2ZbO/8d2TBE+F8HYfr93hC2AnxVdqaEYvkRMUPd0q32kjURZ7HcswH7yKSxkS6IWBe4rZVH34gLmooPG04nNb03Isvhz4egbT6WUlDhulyUlduX/3ZG0QGck2D0x4UE4LkC6sPdQb6fuKz/anme6amq7j85KBymwgTbPH1uq5XSy0d6bhCIgh0inAAo0WLvCEQVYjUhPcCg31wQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH7PR12MB6696.namprd12.prod.outlook.com (2603:10b6:510:1b3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Tue, 18 Oct
 2022 12:07:08 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 12:07:08 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 17/19] bridge: mcast: Allow user space to add (*, G) with a source list and filter mode
Date:   Tue, 18 Oct 2022 15:04:18 +0300
Message-Id: <20221018120420.561846-18-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221018120420.561846-1-idosch@nvidia.com>
References: <20221018120420.561846-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0011.eurprd05.prod.outlook.com
 (2603:10a6:800:92::21) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH7PR12MB6696:EE_
X-MS-Office365-Filtering-Correlation-Id: 748f10ec-a1e3-4396-8b72-08dab10147b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ECm+M8DOKxBsq5J4evQp0yL/93GbvGJ+sKYYRlsv1hUrkzki6MQ768suh+DyMzpBEFExLzMFWjXQ2fE/yQQjASrdUm5N8OHIc/mhKEhw1t5Oq1TwuAMwvIusf33ET0gewc2E5SBl2Z/epxGYAR3vA7VmcHEQKhscSEa0IuSFaWhsTW2KlNAu/lrlK3GPsiPEBR0RtJCzIeHZpg1NK1XrnyKPXFS8Va+5QJYEASDqdww1UcgcbhSHVIib4MgecLFmw6BaD7wOcGGR2CxXGqLGxLlmM/yQBPzxUXpvntBN9HVxwkJDRQENbRTwbeXY5Lt/Ru6aO9o3CeUzkTqYEGasO+9bKnqJ6y+VtM6VJpzvkvy/Dl6y6K6YwPDirIW9FMAwDZ9do84pPNDRSsJBzJ8NpAv12fZad21VDseHW5dZHcgNthCfCIvONabEuqkoewkIFS+TcJBlKd+kW5eaYafOl+jU+pOp5F1iuxxI+PJ0H6U4b3qyJf4sG2aAJuLz+Vbbgb+2vlGmugC2BjCTiHzWyOTcgBDbURnvJuS9sCoeWCEJBa7UC0815NE95gz4Z1Xhc4WFKmhaszHFPkTdqpmv0RtPXkE3A+t2HQR5ohX0oJvMWtZR+6zDUIFZMWR3Fky9TOJIdMHWyDyoNuwAr5BnCFLGwFcR4cMCF1BgJhhhoifTECPrPzl6uyGjXVx4GGKLVfq+7EAjUZxXF8eevhJP3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(396003)(136003)(366004)(376002)(451199015)(6506007)(36756003)(2906002)(8936002)(86362001)(4326008)(5660300002)(107886003)(6512007)(6666004)(26005)(41300700001)(186003)(2616005)(1076003)(478600001)(8676002)(6486002)(66946007)(83380400001)(66476007)(66556008)(38100700002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tUOyX1EQhECkKEt6VTO3Rd+OZXAR9vGPRGf9MjkuErNdORtyR13ZLfItqZFy?=
 =?us-ascii?Q?6/jj88W8Fl7Nt5l1sjszTA57VHndHiVao0QW7C2wJyz9KYZZvRaZRUi8AIYV?=
 =?us-ascii?Q?4llyTvT0mb0ejrfCJTjwBEiOuDQVLmYRtMj8G9t2+aKKh6eUeJChG0l6vmPo?=
 =?us-ascii?Q?MXD8uCcJNQTjH3+nSLNNeu3E4+R2o1hkI0qef9b5piUn7ocZ6mOwafUnkYEz?=
 =?us-ascii?Q?RTvaeNL2wXfIrAPPZ5KbAljDgEcPteGSkjy5BH+lu7fCcnm86XjnXW4s27Mp?=
 =?us-ascii?Q?CvBCEfWtVBe9hdIT2M8tHB2fA0f4UIY+T2SUtSAG6HydOIDC5Bw/LNpzbL9q?=
 =?us-ascii?Q?kVQHO64/vgbgRMPs5KTz9EBOT3rNbc2GyfvxxM/4rUL+f6wdcFTgTQauNE6j?=
 =?us-ascii?Q?//pUfViUyM4OEnDdXcEy5LpYu3zCLEiRZyW/Ire9snsEXhGPz07Rz7fR02El?=
 =?us-ascii?Q?KBqO7CIdUwrxSvt5uiJxiaGv09Qiq2uIp2tVn8fD4R6wbGJSoCDpATi7oBpH?=
 =?us-ascii?Q?K8YZlbBSSWVt9Hnme1IgbvmSmeUiHP1/F5JYzbQDtcVcxxqgh1ZUEhMEcf2n?=
 =?us-ascii?Q?t3BQ5zrxYKgv5LZ/oWpP5vLNEHoSxsDBJokJiorEzDfg82DAzaVddi+60q5K?=
 =?us-ascii?Q?WJO7yV4ZxCRmKbuKUj2TNY9Q2xNmU0qDYjACDOXbsLlquwlUbjP5EuH9i2Za?=
 =?us-ascii?Q?6vwmhQke3iMxFNb20ltg8w59c/fy8W0qyYmWTUq+KE+FcaKYH/I/FOX8rGbQ?=
 =?us-ascii?Q?w5OKtt4WxaPcdx6t11KHd6gVp8blQrpvrRCwsAH4K+hpQYKv0UajljIhzzQq?=
 =?us-ascii?Q?AFCU7VEY6l9uv+hg9iS86PAS7FZ3Uiyvw4nQdVIzj4nHOmRRxTdEhSq5YA4m?=
 =?us-ascii?Q?nj/95Td4V47Qj4VZJFVSEJEj/W+KQ9qjGfxqjsl9WEntp9C842gDQabXum1m?=
 =?us-ascii?Q?I+KxxGbTDdrnNUCsS+cXAUVfjpnSf2dpCNE7vOeIBtKmHb5X6i93zaaU7pWH?=
 =?us-ascii?Q?Zv35OE5yX9lwR4qZQrHDUPYwo5RjnVlOXrzFJUE0KPv37SqPyOCU9b78imwg?=
 =?us-ascii?Q?D/aGMEkDs88yz83B69023QUtoKDN85mfulsfqwxdSiwy5QwE+IeQUdVsEcTm?=
 =?us-ascii?Q?PWk/t/xZ0pc+gbt/U6Nrm45zJdOa7C8TTnR1dyh/6mj48qnwXXyXlagUsJVy?=
 =?us-ascii?Q?sayWRBIVsAn+3t826QCAJkgeBFiMheTDA0C5B3m8Gn8qsq40W5OJTmCIw9YI?=
 =?us-ascii?Q?0Dthgqv1j8VMlAzABijt/NMFmtO2W+CBzPi0XOLSQIIarGXbDa292v1waC57?=
 =?us-ascii?Q?8nM30pvn9txloRaC2gwvHvzk4QQrLAjTgHti5EWjzKAfE8fx3VQhOnfY3vMt?=
 =?us-ascii?Q?sL/kg72QtplB4u1HrN61POFgMSMdhK1CS69j+ylPpqjL6J8lF4kSZ5VDjCwb?=
 =?us-ascii?Q?j1WLcSAxJKdF3nTJhfYsUJWiX93Sn7SY54z98RrygJXayzs/9pOkfRPMKMrC?=
 =?us-ascii?Q?RNlmDsDD4q8SxVfTUE6f4u1WmPR7RzkE8C5UV/qntjodaDzXIhjcp2srGrgw?=
 =?us-ascii?Q?ygrYf9EcQGiAHtlaykyTIlP4KK8fFlw/e4zKT1f7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 748f10ec-a1e3-4396-8b72-08dab10147b7
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 12:07:08.6859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kLwz96xw+b7DZ9iuUNY2wVtyG/EW3DPC+ewMTRc4MN8lYTGQCao59hUtC64QiSNoKlWRGAXRMKk46dfGqeGWDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6696
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new netlink attributes to the RTM_NEWMDB request that allow user
space to add (*, G) with a source list and filter mode.

The RTM_NEWMDB message can already dump such entries (created by the
kernel) so there is no need to add dump support. However, the message
contains a different set of attributes depending if it is a request or a
response. The naming and structure of the new attributes try to follow
the existing ones used in the response.

Request:

[ struct nlmsghdr ]
[ struct br_port_msg ]
[ MDBA_SET_ENTRY ]
	struct br_mdb_entry
[ MDBA_SET_ENTRY_ATTRS ]
	[ MDBE_ATTR_SOURCE ]
		struct in_addr / struct in6_addr
	[ MDBE_ATTR_SRC_LIST ]		// new
		[ MDBE_SRC_LIST_ENTRY ]
			[ MDBE_SRCATTR_ADDRESS ]
				struct in_addr / struct in6_addr
		[ ...]
	[ MDBE_ATTR_GROUP_MODE ]	// new
		u8

Response:

[ struct nlmsghdr ]
[ struct br_port_msg ]
[ MDBA_MDB ]
	[ MDBA_MDB_ENTRY ]
		[ MDBA_MDB_ENTRY_INFO ]
			struct br_mdb_entry
		[ MDBA_MDB_EATTR_TIMER ]
			u32
		[ MDBA_MDB_EATTR_SOURCE ]
			struct in_addr / struct in6_addr
		[ MDBA_MDB_EATTR_RTPROT ]
			u8
		[ MDBA_MDB_EATTR_SRC_LIST ]
			[ MDBA_MDB_SRCLIST_ENTRY ]
				[ MDBA_MDB_SRCATTR_ADDRESS ]
					struct in_addr / struct in6_addr
				[ MDBA_MDB_SRCATTR_TIMER ]
					u8
			[...]
		[ MDBA_MDB_EATTR_GROUP_MODE ]
			u8

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 include/uapi/linux/if_bridge.h |  20 +++++
 net/bridge/br_mdb.c            | 132 +++++++++++++++++++++++++++++++++
 2 files changed, 152 insertions(+)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index a86a7e7b811f..0d9fe73fc48c 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -723,10 +723,30 @@ enum {
 enum {
 	MDBE_ATTR_UNSPEC,
 	MDBE_ATTR_SOURCE,
+	MDBE_ATTR_SRC_LIST,
+	MDBE_ATTR_GROUP_MODE,
 	__MDBE_ATTR_MAX,
 };
 #define MDBE_ATTR_MAX (__MDBE_ATTR_MAX - 1)
 
+/* per mdb entry source */
+enum {
+	MDBE_SRC_LIST_UNSPEC,
+	MDBE_SRC_LIST_ENTRY,
+	__MDBE_SRC_LIST_MAX,
+};
+#define MDBE_SRC_LIST_MAX (__MDBE_SRC_LIST_MAX - 1)
+
+/* per mdb entry per source attributes
+ * these are embedded in MDBE_SRC_LIST_ENTRY
+ */
+enum {
+	MDBE_SRCATTR_UNSPEC,
+	MDBE_SRCATTR_ADDRESS,
+	__MDBE_SRCATTR_MAX,
+};
+#define MDBE_SRCATTR_MAX (__MDBE_SRCATTR_MAX - 1)
+
 /* Embedded inside LINK_XSTATS_TYPE_BRIDGE */
 enum {
 	BRIDGE_XSTATS_UNSPEC,
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 8fc8816a76bf..909b0fb49a0c 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -663,10 +663,25 @@ void br_rtr_notify(struct net_device *dev, struct net_bridge_mcast_port *pmctx,
 	rtnl_set_sk_err(net, RTNLGRP_MDB, err);
 }
 
+static const struct nla_policy
+br_mdbe_src_list_entry_pol[MDBE_SRCATTR_MAX + 1] = {
+	[MDBE_SRCATTR_ADDRESS] = NLA_POLICY_RANGE(NLA_BINARY,
+						  sizeof(struct in_addr),
+						  sizeof(struct in6_addr)),
+};
+
+static const struct nla_policy
+br_mdbe_src_list_pol[MDBE_SRC_LIST_MAX + 1] = {
+	[MDBE_SRC_LIST_ENTRY] = NLA_POLICY_NESTED(br_mdbe_src_list_entry_pol),
+};
+
 static const struct nla_policy br_mdbe_attrs_pol[MDBE_ATTR_MAX + 1] = {
 	[MDBE_ATTR_SOURCE] = NLA_POLICY_RANGE(NLA_BINARY,
 					      sizeof(struct in_addr),
 					      sizeof(struct in6_addr)),
+	[MDBE_ATTR_GROUP_MODE] = NLA_POLICY_RANGE(NLA_U8, MCAST_EXCLUDE,
+						  MCAST_INCLUDE),
+	[MDBE_ATTR_SRC_LIST] = NLA_POLICY_NESTED(br_mdbe_src_list_pol),
 };
 
 static bool is_valid_mdb_entry(struct br_mdb_entry *entry,
@@ -1052,6 +1067,73 @@ static int __br_mdb_add(struct br_mdb_config *cfg,
 	return ret;
 }
 
+static int br_mdb_config_src_entry_init(struct nlattr *src_entry,
+					struct br_mdb_config *cfg,
+					struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[MDBE_SRCATTR_MAX + 1];
+	struct br_mdb_src_entry *src;
+	int err;
+
+	err = nla_parse_nested(tb, MDBE_SRCATTR_MAX, src_entry,
+			       br_mdbe_src_list_entry_pol, extack);
+	if (err)
+		return err;
+
+	if (NL_REQ_ATTR_CHECK(extack, src_entry, tb, MDBE_SRCATTR_ADDRESS))
+		return -EINVAL;
+
+	if (!is_valid_mdb_source(tb[MDBE_SRCATTR_ADDRESS],
+				 cfg->entry->addr.proto, extack))
+		return -EINVAL;
+
+	src = kzalloc(sizeof(*src), GFP_KERNEL);
+	if (!src)
+		return -ENOMEM;
+	src->addr.proto = cfg->entry->addr.proto;
+	nla_memcpy(&src->addr.src, tb[MDBE_SRCATTR_ADDRESS],
+		   nla_len(tb[MDBE_SRCATTR_ADDRESS]));
+	list_add_tail(&src->list, &cfg->src_list);
+
+	return 0;
+}
+
+static void br_mdb_config_src_entry_fini(struct br_mdb_src_entry *src)
+{
+	list_del(&src->list);
+	kfree(src);
+}
+
+static int br_mdb_config_src_list_init(struct nlattr *src_list,
+				       struct br_mdb_config *cfg,
+				       struct netlink_ext_ack *extack)
+{
+	struct br_mdb_src_entry *src, *tmp;
+	struct nlattr *src_entry;
+	int rem, err;
+
+	nla_for_each_nested(src_entry, src_list, rem) {
+		err = br_mdb_config_src_entry_init(src_entry, cfg, extack);
+		if (err)
+			goto err_src_entry_init;
+	}
+
+	return 0;
+
+err_src_entry_init:
+	list_for_each_entry_safe(src, tmp, &cfg->src_list, list)
+		br_mdb_config_src_entry_fini(src);
+	return err;
+}
+
+static void br_mdb_config_src_list_fini(struct br_mdb_config *cfg)
+{
+	struct br_mdb_src_entry *src, *tmp;
+
+	list_for_each_entry_safe(src, tmp, &cfg->src_list, list)
+		br_mdb_config_src_entry_fini(src);
+}
+
 static int br_mdb_config_attrs_init(struct nlattr *set_attrs,
 				    struct br_mdb_config *cfg,
 				    struct netlink_ext_ack *extack)
@@ -1071,9 +1153,52 @@ static int br_mdb_config_attrs_init(struct nlattr *set_attrs,
 
 	__mdb_entry_to_br_ip(cfg->entry, &cfg->group, mdb_attrs);
 
+	if (mdb_attrs[MDBE_ATTR_GROUP_MODE]) {
+		if (!cfg->p) {
+			NL_SET_ERR_MSG_MOD(extack, "Filter mode cannot be set for host groups");
+			return -EINVAL;
+		}
+		if (!br_multicast_is_star_g(&cfg->group)) {
+			NL_SET_ERR_MSG_MOD(extack, "Filter mode can only be set for (*, G) entries");
+			return -EINVAL;
+		}
+		cfg->filter_mode = nla_get_u8(mdb_attrs[MDBE_ATTR_GROUP_MODE]);
+	} else {
+		cfg->filter_mode = MCAST_EXCLUDE;
+	}
+
+	if (mdb_attrs[MDBE_ATTR_SRC_LIST]) {
+		if (!cfg->p) {
+			NL_SET_ERR_MSG_MOD(extack, "Source list cannot be set for host groups");
+			return -EINVAL;
+		}
+		if (!br_multicast_is_star_g(&cfg->group)) {
+			NL_SET_ERR_MSG_MOD(extack, "Source list can only be set for (*, G) entries");
+			return -EINVAL;
+		}
+		if (!mdb_attrs[MDBE_ATTR_GROUP_MODE]) {
+			NL_SET_ERR_MSG_MOD(extack, "Source list cannot be set without filter mode");
+			return -EINVAL;
+		}
+		err = br_mdb_config_src_list_init(mdb_attrs[MDBE_ATTR_SRC_LIST],
+						  cfg, extack);
+		if (err)
+			return err;
+	}
+
+	if (list_empty(&cfg->src_list) && cfg->filter_mode == MCAST_INCLUDE) {
+		NL_SET_ERR_MSG_MOD(extack, "Cannot add (*, G) INCLUDE with an empty source list");
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
+static void br_mdb_config_attrs_fini(struct br_mdb_config *cfg)
+{
+	br_mdb_config_src_list_fini(cfg);
+}
+
 static int br_mdb_config_init(struct net *net, struct sk_buff *skb,
 			      struct nlmsghdr *nlh, struct br_mdb_config *cfg,
 			      struct netlink_ext_ack *extack)
@@ -1164,6 +1289,11 @@ static int br_mdb_config_init(struct net *net, struct sk_buff *skb,
 	return 0;
 }
 
+static void br_mdb_config_fini(struct br_mdb_config *cfg)
+{
+	br_mdb_config_attrs_fini(cfg);
+}
+
 static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 		      struct netlink_ext_ack *extack)
 {
@@ -1222,6 +1352,7 @@ static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 	}
 
 out:
+	br_mdb_config_fini(&cfg);
 	return err;
 }
 
@@ -1297,6 +1428,7 @@ static int br_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 		err = __br_mdb_del(&cfg);
 	}
 
+	br_mdb_config_fini(&cfg);
 	return err;
 }
 
-- 
2.37.3

