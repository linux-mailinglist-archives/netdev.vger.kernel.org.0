Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE5FB647305
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 16:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiLHPaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 10:30:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbiLHPaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 10:30:11 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2084.outbound.protection.outlook.com [40.107.101.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762EB786B5
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 07:30:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DBVvLtMRMUENAXWIvbn310TaAwGAivn5s+JOYk4jibFDyZ1P6/Wfn7nxYo7C02VOM8Gfhm9zcRv/myV04KpPmWh7YLnWpi8t3lny5Ng3dw/PLRi00r810vviRbzEbe+ndyooOVrLN6h5uov9fTJUm2zX6MKzYWwdtE6BdvlMeELPih7mvgEP+SOoY5xTugg+bBIB4P0iRBD12JKgMrUEtDjA/jZY7t7JwrHubiorkhLP0JzjBhzeD2JYGVmMlJmabNkpIUHwPilxIJ80yvgXcxDTACHkuKFEQ4mbN1XuwdueySmTpBy//NyK+IlXCYy+xvqhisnw1SaKpeHROxKuZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nm0nGdTIaY0iPhJEbacVPosa63k+O8ffNGAof5QYF6Q=;
 b=iy624Klyg6erjCs7r8jPbKnNQa1//rJ2a3HRQFTkuH0VRehHyUCc6lnsB1GVlX+TUXJA5jcJh9skvnHo6FZjFpX9cPO1rDlw+prHQHGnZy4CHpL/MUQlTbSbqvAko4WA3D+uZpCreGn2e/sdoHBoWsD2ZZvA7UmjY2Jh4mn0/FV20eQyB1lF/1TuETqwFXLOzn0unoLOAItMZdqYjXTqsXwtZStz8t/QJvjWWAIaM+gzc6Pv7CCmIgXbj98hVTn4dk20wzS9TGqqlSqJH316B2odaFpzDxN8wUDaWnw/HH9t6nNPNcFcS1oZpvUEEKZUqQUwZt+HQzcU903YuzGNfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nm0nGdTIaY0iPhJEbacVPosa63k+O8ffNGAof5QYF6Q=;
 b=oYqpBRIqbo1geD0UeETYjkYKX1oIt0Rb+XehdK3roHaqpauuPH2Gk4z6qbevxXn86TTMA5ipYzDflsggLKJEZ4n0Gvz/oh9o+LAZ3Wh37G+f1ijt0eZuA8iYZO50o4Rs2HraKWAGqLsmTJ8lEvb0GDmdFi+kS3af/fJ/mRf5bn5brTFIaXeV2VdpU8UBv6op09CAQRAGZG+f6Cbe3vpQo9k6TufCd19p92wpnhPNmCTnjXzNPewQN/0ZDRhR5/yq7QsPWkKLu9k4A6bsV5SXFItns34Etimh+34BSX33XjtjUt5jZOMT65XP+jEVdczuLmpPN4Sm/bWi41fLiwUjzQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH0PR12MB5370.namprd12.prod.outlook.com (2603:10b6:610:d5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 15:30:06 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 15:30:06 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 10/14] bridge: mcast: Allow user space to add (*, G) with a source list and filter mode
Date:   Thu,  8 Dec 2022 17:28:35 +0200
Message-Id: <20221208152839.1016350-11-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221208152839.1016350-1-idosch@nvidia.com>
References: <20221208152839.1016350-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR03CA0067.eurprd03.prod.outlook.com
 (2603:10a6:803:50::38) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CH0PR12MB5370:EE_
X-MS-Office365-Filtering-Correlation-Id: d444c916-c998-42c8-dc0d-08dad931153e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QRrRAp8+oeMRvsWM72qne+X7bLPqrY8LbRioQ9gyuZUmN4umACkC7FmsgRQfwiNuBUkVoeDZqrV/o6ThuG1TYgT+Ow6GqavnJzV99AIEewiPTBlfL8nco85YAv1vpmy4o4NXCMRjjppGb6vPgUj5bnaUIfI4d1flQbWjkDzRPTOGzEsUcED8WHu80g/ddxWDTWvDaZpfJAADfN1J4lK+iY5MkDb76xfFtamOC0P17Mw1UbO0Py7XjjcB9BzyYjfr/0Rp1oWCUh+Lm68TYc3N3RC7giEiGtY9aQkrzKCB0EhjhpIGDI5Flczu1/l/MBiW+BrWa2ysBgNpowCT5LLG7MvzqHaJQlCXLPldOHGybtYGJdLLTvIVXIHdm5ElPgq7f+/Y5oLBfj06mv+o94RU5cuD2elN/tGgSZYWKT42VRrg1kd+Fz5TmEz9O5rWhvRYkf/YJwT08TcaOAvaIOxi10Boy0PdIhx+4XLPMXry60u5IiaILugzmg1FoucI60eg4P0WGognQ7XsAUeS1Ub605OL8XFsSHkKaslN3ztwxsjKHU1uScEBqIrolrM4Ww7yuKvqJ+lYQww8W35FRqeo48GwveZ4hKpe7YjRAbZDauKHU4faH7S9btvT2Q4cLd1YvVVCB9/qD4Thr+dNFxoSyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(451199015)(36756003)(86362001)(41300700001)(8936002)(66476007)(66946007)(4326008)(2906002)(66556008)(8676002)(38100700002)(83380400001)(107886003)(2616005)(316002)(478600001)(6486002)(1076003)(6666004)(6512007)(5660300002)(6506007)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ur6jZOFt6tED7xVVH1USgmz1d0hFVQthXJOtGQ5QOgCJ5vGPVW9apXszXRUB?=
 =?us-ascii?Q?fCOMDf8bhPSne4VumftIRo5pOf9iHnrXV+cQZ4jmncYC4xosOF2qjGd5HqXP?=
 =?us-ascii?Q?nBbP0g+moYaxH/2cqPb4zP8zn4HI/EAP93gnsxekmcJgoSRUIxKjWgrvcLLb?=
 =?us-ascii?Q?nPzmdTOz3+/fw/t78552uFP61oivPOzUxrR5em2W2tcmHltad35vGYvJKooC?=
 =?us-ascii?Q?BWoqjh/LUP6qQiIpitcEx/NPXm7XHpSijTcRyCuuXFo5rEgnbT+wCg4yrgXm?=
 =?us-ascii?Q?aNPETWjlxhoZY4A3YhKbOE4wazz5m/X014dulz0YpSQcNw6GaxIA4FSfIf+f?=
 =?us-ascii?Q?Mo3AWTCPtEGbWfsa1L2EouYcmARCrLldN8U7JOL/uE75Z13TfocRzi7h5iSS?=
 =?us-ascii?Q?JYg94KpK8vYSJFzyfB/h/vlhDcdvosMR0FSp0jZeqa83Og/QT0UtN6De2KRD?=
 =?us-ascii?Q?a6jtwvXqTdYY2xeQETwV9SZCPp7GYCPIl45KMD57+8ISxUk9sOneWZvTwlsD?=
 =?us-ascii?Q?V/1ZYs8wLIVm66+6bGlStW+nNiZjtPwlKrHDSVx6cusSptYahF1RVmyWaoYA?=
 =?us-ascii?Q?0NenwYEXDJ3CGC0eHV/suZ6vlMDztszkHZTJ/Pr8jLQIYGm3Kzlcy9yRMMg5?=
 =?us-ascii?Q?UEPlRUteATIUVT1E+zWl/GmUd2/3WakQbH0SQjbzaXtsGbhNCMAhpR57QeWb?=
 =?us-ascii?Q?O+YceYYM8MLB9eLn3s3WwTeM828gSFVMHGeur0HCjFE9m3UVeHR5EqF23x6Q?=
 =?us-ascii?Q?GfF/T5OK/N91A7LwJBjQe+7/r2/9+jPjpmJKetyiLpy42v5ni5YlcwEbkqVf?=
 =?us-ascii?Q?b4yzu5mCXhnA3UXiFUTqK0S9B1yDzBuW0ArHrQt7qad61nMOwcj/TWOjZJpg?=
 =?us-ascii?Q?7FETWyFvFZP1HgxW7eaz+tmlF1mzJn8wBXCO+dc/SipPsiTIvOXUiaoHkqeQ?=
 =?us-ascii?Q?SKTsMzquc0NVW6Ov9MI0LkD963nCb318h/XaR9QFekBbdXaITP7UBH9rfO2f?=
 =?us-ascii?Q?LrxgMa15/HvXMOcPG9BK1P2MmIurFsJ1+8uPQZsIlBvEIl6/T9/bfKtJbeQW?=
 =?us-ascii?Q?wDt7kr0rB9UUMqpYK/e69oFR90M3SgMxWf5NhiaYzMVYC6g7zd+/EuzIqwrz?=
 =?us-ascii?Q?i1F7fljpO9MbpJcJoSQOH2V5vE32VBn6YyNne33Q9vniiz9c5SgcFrDpgHol?=
 =?us-ascii?Q?FtmoIsNDF9TpETTH9LYz8gsOYBBuv4BC2nUT245gll0Ay1JnnqfBoapIoJ1p?=
 =?us-ascii?Q?46se/zbv78zuW/iwTp2xkq+0XF03yN1qHSWcmtZRnD/Dr9im0mUq9S4remtQ?=
 =?us-ascii?Q?OQplIKnjNIruSHVqALL+fTylXvUpjRcruRSPpJx8lJW10EA/kkve4rMOM24t?=
 =?us-ascii?Q?8hDMRV56tNM44BgFeVqr5zPAKjFZDbIasUxaaPUAzX9rCib8GRZ+6UyrRsWV?=
 =?us-ascii?Q?lj0Jp/Jj2Mwk4l0W+jvf+t7U1R47+HgbBs+MPIVRYDuXs9CBuftwELgxM5ze?=
 =?us-ascii?Q?92YY9zDuJucUtEA+IO6o0ZqTxFGuLoGHGQX8Bw+NP+UMBTUDPFAioP+Yv6nY?=
 =?us-ascii?Q?3krh7Tc4SQdHry7koA33KdiJq+5Rxa2KZdtHG7sY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d444c916-c998-42c8-dc0d-08dad931153e
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 15:30:06.2549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: joX0+B8/G9cT/UCnjhDvFzwaeF9iQfMIYt5CnAiR7R2omOVzCGmNidr80RNhOmIT6rCgUKgQqz/+BIlXzyIpvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5370
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Notes:
    v1:
    * Use an array instead of list to store source entries.
    * Drop br_mdb_config_attrs_fini().

 include/uapi/linux/if_bridge.h |  20 +++++
 net/bridge/br_mdb.c            | 130 +++++++++++++++++++++++++++++++++
 2 files changed, 150 insertions(+)

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
index e9a4b7e247e7..61d46b0a31b6 100644
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
@@ -1051,6 +1066,76 @@ static int __br_mdb_add(const struct br_mdb_config *cfg,
 	return ret;
 }
 
+static int br_mdb_config_src_entry_init(struct nlattr *src_entry,
+					struct br_mdb_src_entry *src,
+					__be16 proto,
+					struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[MDBE_SRCATTR_MAX + 1];
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
+	if (!is_valid_mdb_source(tb[MDBE_SRCATTR_ADDRESS], proto, extack))
+		return -EINVAL;
+
+	src->addr.proto = proto;
+	nla_memcpy(&src->addr.src, tb[MDBE_SRCATTR_ADDRESS],
+		   nla_len(tb[MDBE_SRCATTR_ADDRESS]));
+
+	return 0;
+}
+
+static int br_mdb_config_src_list_init(struct nlattr *src_list,
+				       struct br_mdb_config *cfg,
+				       struct netlink_ext_ack *extack)
+{
+	struct nlattr *src_entry;
+	int rem, err;
+	int i = 0;
+
+	nla_for_each_nested(src_entry, src_list, rem)
+		cfg->num_src_entries++;
+
+	if (cfg->num_src_entries >= PG_SRC_ENT_LIMIT) {
+		NL_SET_ERR_MSG_FMT_MOD(extack, "Exceeded maximum number of source entries (%u)",
+				       PG_SRC_ENT_LIMIT - 1);
+		return -EINVAL;
+	}
+
+	cfg->src_entries = kcalloc(cfg->num_src_entries,
+				   sizeof(struct br_mdb_src_entry), GFP_KERNEL);
+	if (!cfg->src_entries)
+		return -ENOMEM;
+
+	nla_for_each_nested(src_entry, src_list, rem) {
+		err = br_mdb_config_src_entry_init(src_entry,
+						   &cfg->src_entries[i],
+						   cfg->entry->addr.proto,
+						   extack);
+		if (err)
+			goto err_src_entry_init;
+		i++;
+	}
+
+	return 0;
+
+err_src_entry_init:
+	kfree(cfg->src_entries);
+	return err;
+}
+
+static void br_mdb_config_src_list_fini(struct br_mdb_config *cfg)
+{
+	kfree(cfg->src_entries);
+}
+
 static int br_mdb_config_attrs_init(struct nlattr *set_attrs,
 				    struct br_mdb_config *cfg,
 				    struct netlink_ext_ack *extack)
@@ -1070,6 +1155,44 @@ static int br_mdb_config_attrs_init(struct nlattr *set_attrs,
 
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
+	if (!cfg->num_src_entries && cfg->filter_mode == MCAST_INCLUDE) {
+		NL_SET_ERR_MSG_MOD(extack, "Cannot add (*, G) INCLUDE with an empty source list");
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
@@ -1162,6 +1285,11 @@ static int br_mdb_config_init(struct net *net, const struct nlmsghdr *nlh,
 	return 0;
 }
 
+static void br_mdb_config_fini(struct br_mdb_config *cfg)
+{
+	br_mdb_config_src_list_fini(cfg);
+}
+
 static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 		      struct netlink_ext_ack *extack)
 {
@@ -1220,6 +1348,7 @@ static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 	}
 
 out:
+	br_mdb_config_fini(&cfg);
 	return err;
 }
 
@@ -1295,6 +1424,7 @@ static int br_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 		err = __br_mdb_del(&cfg);
 	}
 
+	br_mdb_config_fini(&cfg);
 	return err;
 }
 
-- 
2.37.3

