Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8861F504CC7
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 08:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236355AbiDRGqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 02:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236338AbiDRGqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 02:46:12 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2052.outbound.protection.outlook.com [40.107.101.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B309D13DF7
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 23:43:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FuGQmcg1PbmymE/DNnAdzuOc9GpUATaaXFBvAll89VdNHJkdaUWpTxHXDAowkXA6W3u1MeKOeO4RvgyeLfLYFdsnk3SBElZddJ7WnD6lQDemhmB5+dp5/VfmcCy9DfRi+3t1Y4VM2FU6Rq2oxbGcEEQ3Yu/omswSt5dRkHy5MvYg4dB0y9tjnGm2Jx5l2rkY8LCbEgjx4WLmnaiBShsLPorwZjk8fBadpftB7o9E9k0mkvp7Co60Q06Vy2FLlNdGx1VyqgjtdGSkpFXGUfMPtY1H1dM/5sVnFCLvQP9MaacqcARRxvYrf8lY8mMtMn12ZVSlTBXOyOS/Nm5G/85pMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a38DiklQh58Sxq360u+R6maR5aqkgbkzBdYRhr6Cyx0=;
 b=ZeHwtSsw225tfWC6XiFgNXK30CnrFmZ8gCLLIFKpEmMp00P8pwWHvqT8zpXwLu/dJcIB3oqpnTeQwYTCgucPDpSf0WavwRlgVLCeVsJJA7Mr8XwvltX4oTFD0IKO71kkkEKqOFHjaFYpxSMV0zQ3Jc1Dtc+GDMZdnHwi8kgSk3zvwlfdgKS/sN+I/md7LxQCDTPgH+tZCZbUoeWIjYUJrqQm2Hc8YCsewf93UzvZ4PpQIAZmmEQkOjtHmQH/+zgepUPj70Rv98AiKH58H9mr6nupZVpFj6u0BF+umHEqN9f93vyQCDtsEibezKt9fLtb+78nqshLyPNunAJmGUR6KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a38DiklQh58Sxq360u+R6maR5aqkgbkzBdYRhr6Cyx0=;
 b=Hn4DuUUpGM4G/kC81vAOh3PrjYJKilo0XsHIq41Pj7iSY6Unq69XL0ncpbHnPr9Q9a5QlXpx9fjP2dLAyoa/XyiJgDuuteYaQL0UrycJoa6jmcK3UBMQN2VSK6cOuddVpHDkQSwVBh6M7sWvPC73cHPbmITKTW74yxewxGotHyPXEwhGAJVTd8CUoh6eqhfiekdc9X/WGUyWWOD/3ihkGsF2v2/NvREpSgTtRNdiyakAyCFD/IHnr/BjubT/ChWlxdVMsp64jS06KuVbjA6U6EJP+dKRw1o7rtxZqFhRlbn+smlCVXMRLfS5iZeAzPyQm67bJlqlob+PaqMZiE6pTg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by PH0PR12MB5420.namprd12.prod.outlook.com (2603:10b6:510:e8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 06:43:32 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402%6]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 06:43:32 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jiri@nvidia.com, vadimp@nvidia.com, petrm@nvidia.com,
        andrew@lunn.ch, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 01/17] devlink: add support to create line card and expose to user
Date:   Mon, 18 Apr 2022 09:42:25 +0300
Message-Id: <20220418064241.2925668-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220418064241.2925668-1-idosch@nvidia.com>
References: <20220418064241.2925668-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0042.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:61::30) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3063185-52d8-4c4e-f86f-08da2106c10e
X-MS-TrafficTypeDiagnostic: PH0PR12MB5420:EE_
X-Microsoft-Antispam-PRVS: <PH0PR12MB5420682E9BCA009FA4454706B2F39@PH0PR12MB5420.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 803HPv7JGoFaK/WEncxXqCy+eS39fdmh8tjBRSakInwckJfoYZZgz8NvNvB+13+X+hZSUQFYD1VyJfaFfV+cyYrCV7TcYmjVEitZwgKfx4R2p/3Eo73GAwfRY8Myeplp8Q1ytyWYSPi+7+wHlf2paiw0kuXWXTJOD1QVWjpa2PNb+VJlGjoFU64Ty0iGCyuyB93l6L16nhYgvpPnnQO7PpsbekgKU9td9OpmmcXzJcDxVCauLmk5dQxEJURnl15z/b7Owdpqfn0F//ZsC70svZbQnHJgbbpv7nSNJkGXWnwL5LWIYDt+EJjJPcgiL7zyJmkMBAqI8yy6lJtpzle49VlJnoyHkwZyhTwpCp1ViOV0PweTraVKnpFfNPanlyRPnYeaDIAqxpqm2kA5qiDcVTA9bVwY2QKuH9Y1dcctSdil3Ex7yZSVBCuh0On6fhZuC7sthiN19iIfu6ZCscT89rkqawjcbRfCXDOrKOAPXMX0PV1HE0KeVmzEnzdm7mHG44JE8TgnFke6SJnReXuXzWddOjR3owT2lWPcRk8Rgys32yBQOUgbjZIjqvHTmW3Hs2I6aoFsC2V3K9uMmpm+zutwUNfI2BoIxb/khcM62EoeqmB7c8egBbiOXQGVI7eT8rgAZudA3tIkw3GOXM4DWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(6486002)(508600001)(1076003)(2906002)(6512007)(6506007)(86362001)(6666004)(36756003)(186003)(26005)(83380400001)(66946007)(38100700002)(5660300002)(66556008)(66476007)(107886003)(2616005)(30864003)(4326008)(8676002)(6916009)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VINQ7lRbxucBJQdNUuGNkwuUxmopjXVhOOBBVMZ+lrmlknJqDzIhODy52w0X?=
 =?us-ascii?Q?cRSXV6qBYxcCcZojtMMM/IAUsweynJSzFpzRSlT+hshVq+Q9vDpP3Xxfj2vv?=
 =?us-ascii?Q?5iGUlvMqoSxYX4jo0wt8fV36/nTq0TBnmwwMriL5xMqO7wwUe78hZlhguyP8?=
 =?us-ascii?Q?p6ivuMe4t01XGrsfekZeavhYeNGA+0KIOkuFPL8xcpoeDouSejuI00ggbQ5t?=
 =?us-ascii?Q?Kx9Z6epcIrBh157iSwKOBTk6t/ichGDrf+//W2jERrhiDLY16+wQIceODHWO?=
 =?us-ascii?Q?r12FkP92P8naI+qsD/yGgDVC72YnPuoofB3x5fvhDH9mNrmztIa7YxzUnAG2?=
 =?us-ascii?Q?BlptMWqURwHC0fVAmDs4wdJzG5pHzWKRLNxFV3sXTmyhSkwatpZUSrJYwOmi?=
 =?us-ascii?Q?vta0DcRfeyz51bOwSLiULsfihfqMj2+E9rY3RGjLqSaO6lJcih2H41RUM8/b?=
 =?us-ascii?Q?fs2jMUWfDRflw59+NtjDoCwehrQL395J/bjizvGc7uJcc3JGb3IadySIiNPO?=
 =?us-ascii?Q?uEH1BDfVE/rnIDWrV8UnRXeuuy/Yd1ztxJ09SgaVXdyYy+9JKEHkNVw51l8I?=
 =?us-ascii?Q?rR10iRxhIQz/LRWyBCYTHCqGap2QXsTNqUQ8FLRrCDazL6Vo3iekPSse1w33?=
 =?us-ascii?Q?etRz3pxT1saTolwXy2KFCFs1JDsSMy05TkiaF6NMGch2rU3zlkMgpa4s2Dl5?=
 =?us-ascii?Q?B6H2lZUwYQdAzMhK9BzaSDYWwyi7hPWdLSV42h7FwV+DLYWKmBdRGlAv6mVQ?=
 =?us-ascii?Q?8NOnVKolToezxuAnL4EHv69jcqQkY2+5MrTshx/OdwgzUfuKi141AjLRTynb?=
 =?us-ascii?Q?BdHWMiXK/R4LHozqIGVqtr11BFaeJUVKeZApo692sXMEZWRsJas4GbtiVBLC?=
 =?us-ascii?Q?UHV9FBphR7ofe6NCyoFRdtY9uNotYyPbuVY8pAVtXimC6o9tOWFHkyaCDEE8?=
 =?us-ascii?Q?mPhR5tUTf4LV4+gDFd/5OcGVAD69WJGAxv5DkzNCpb1woY7yDK4m+QX8lDFZ?=
 =?us-ascii?Q?tZV4djFvlR9ral5wd9QlAJiM7f1upYem+b26ZIfxEnDtAYFM7jau+t9c8JDv?=
 =?us-ascii?Q?6H45NqHhMul6ILrcLfJ9K3BeQ2ixkA/YMhGbC9YS0oSGK0EVnMh1YAuAeKTV?=
 =?us-ascii?Q?Et7wmAhw1nicxWn7CyfeyqoqqPEefdVxA/5ztwi78d6kPcGoThGyCXLCDhDM?=
 =?us-ascii?Q?sE32cyk4sc1x6lX532O5BtqjdaIy6po6JIh6h4grNZ8l6y6aG0qd2ah8IPi3?=
 =?us-ascii?Q?+RQAdUOOCuncU92YmG2Mxxqu9kC/5MkQbk6jvmXS2OaY/2gH92KL5CrNaKih?=
 =?us-ascii?Q?+myCTXMhXila+z5ThoZ2689jWSBwXYoQVAxT+d/3pgjmFWjFdqFmipohZk0q?=
 =?us-ascii?Q?n6VXlsj0p8/ZbhgHD5YkPE4MFLyu5iZCE0B9fKcHhe8HedEww3VsqdwuJrkn?=
 =?us-ascii?Q?w6AuuBUl3Bqhl00OIcDD79GSlj6ICxr1D+WAgb8OxrFjJ/e6dx/TT1iK6JcI?=
 =?us-ascii?Q?DZKAlHEX6zPa1Kt3QtIHPEX8qzOTbeK2RRIpDVpXinr53YFCI2V7id6RMNqe?=
 =?us-ascii?Q?++M/tpg7aINCVV1JvX0eByEPJyLJW0wjg5Ts/WrqCotIDKY4r6e+sHVecZFN?=
 =?us-ascii?Q?vGREAgdm57Y3l+eitvFDh2vsZkPT9JckzudzCZRPjLisjpTePBoOqcPNgA/g?=
 =?us-ascii?Q?kHyFyLQla6dXyyQuRt7fLlOS5k53XkkkbDix1SsXSVNd6QGyczpzhdnwrb0O?=
 =?us-ascii?Q?nRz8EQ4YJQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3063185-52d8-4c4e-f86f-08da2106c10e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2022 06:43:32.1182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dqHV5NSBFQoux5BUQij8ggqgvqHjcqfp8+0Jj+KhDhnTnG7ZtVe50XuMJ6lTdzbiZDxWk+eOwvqDbbSQHHI7sQ==
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

Extend the devlink API so the driver is going to be able to create and
destroy linecard instances. There can be multiple line cards per devlink
device. Expose this new type of object over devlink netlink API to the
userspace, with notifications.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 include/net/devlink.h        |   4 +
 include/uapi/linux/devlink.h |   7 +
 net/core/devlink.c           | 270 ++++++++++++++++++++++++++++++++++-
 3 files changed, 280 insertions(+), 1 deletion(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index a30180c0988a..7aabdfb3bc6a 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -22,6 +22,7 @@
 #include <linux/firmware.h>
 
 struct devlink;
+struct devlink_linecard;
 
 struct devlink_port_phys_attrs {
 	u32 port_number; /* Same value as "split group".
@@ -1536,6 +1537,9 @@ void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port,
 int devlink_rate_leaf_create(struct devlink_port *port, void *priv);
 void devlink_rate_leaf_destroy(struct devlink_port *devlink_port);
 void devlink_rate_nodes_destroy(struct devlink *devlink);
+struct devlink_linecard *devlink_linecard_create(struct devlink *devlink,
+						 unsigned int linecard_index);
+void devlink_linecard_destroy(struct devlink_linecard *linecard);
 int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u32 size, u16 ingress_pools_count,
 			u16 egress_pools_count, u16 ingress_tc_count,
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index b897b80770f6..59c33ed2d3e7 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -131,6 +131,11 @@ enum devlink_command {
 	DEVLINK_CMD_RATE_NEW,
 	DEVLINK_CMD_RATE_DEL,
 
+	DEVLINK_CMD_LINECARD_GET,		/* can dump */
+	DEVLINK_CMD_LINECARD_SET,
+	DEVLINK_CMD_LINECARD_NEW,
+	DEVLINK_CMD_LINECARD_DEL,
+
 	/* add new commands above here */
 	__DEVLINK_CMD_MAX,
 	DEVLINK_CMD_MAX = __DEVLINK_CMD_MAX - 1
@@ -553,6 +558,8 @@ enum devlink_attr {
 
 	DEVLINK_ATTR_REGION_MAX_SNAPSHOTS,	/* u32 */
 
+	DEVLINK_ATTR_LINECARD_INDEX,		/* u32 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index aeca13b6e57b..4cdacd74b82a 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -54,6 +54,8 @@ struct devlink {
 	struct list_head trap_list;
 	struct list_head trap_group_list;
 	struct list_head trap_policer_list;
+	struct list_head linecard_list;
+	struct mutex linecards_lock; /* protects linecard_list */
 	const struct devlink_ops *ops;
 	u64 features;
 	struct xarray snapshot_ids;
@@ -70,6 +72,13 @@ struct devlink {
 	char priv[] __aligned(NETDEV_ALIGN);
 };
 
+struct devlink_linecard {
+	struct list_head list;
+	struct devlink *devlink;
+	unsigned int index;
+	refcount_t refcount;
+};
+
 /**
  * struct devlink_resource - devlink resource
  * @name: name of the resource
@@ -397,6 +406,56 @@ devlink_rate_get_from_info(struct devlink *devlink, struct genl_info *info)
 		return ERR_PTR(-EINVAL);
 }
 
+static struct devlink_linecard *
+devlink_linecard_get_by_index(struct devlink *devlink,
+			      unsigned int linecard_index)
+{
+	struct devlink_linecard *devlink_linecard;
+
+	list_for_each_entry(devlink_linecard, &devlink->linecard_list, list) {
+		if (devlink_linecard->index == linecard_index)
+			return devlink_linecard;
+	}
+	return NULL;
+}
+
+static bool devlink_linecard_index_exists(struct devlink *devlink,
+					  unsigned int linecard_index)
+{
+	return devlink_linecard_get_by_index(devlink, linecard_index);
+}
+
+static struct devlink_linecard *
+devlink_linecard_get_from_attrs(struct devlink *devlink, struct nlattr **attrs)
+{
+	if (attrs[DEVLINK_ATTR_LINECARD_INDEX]) {
+		u32 linecard_index = nla_get_u32(attrs[DEVLINK_ATTR_LINECARD_INDEX]);
+		struct devlink_linecard *linecard;
+
+		mutex_lock(&devlink->linecards_lock);
+		linecard = devlink_linecard_get_by_index(devlink, linecard_index);
+		if (linecard)
+			refcount_inc(&linecard->refcount);
+		mutex_unlock(&devlink->linecards_lock);
+		if (!linecard)
+			return ERR_PTR(-ENODEV);
+		return linecard;
+	}
+	return ERR_PTR(-EINVAL);
+}
+
+static struct devlink_linecard *
+devlink_linecard_get_from_info(struct devlink *devlink, struct genl_info *info)
+{
+	return devlink_linecard_get_from_attrs(devlink, info->attrs);
+}
+
+static void devlink_linecard_put(struct devlink_linecard *linecard)
+{
+	if (refcount_dec_and_test(&linecard->refcount))
+		kfree(linecard);
+}
+
 struct devlink_sb {
 	struct list_head list;
 	unsigned int index;
@@ -617,16 +676,18 @@ devlink_region_snapshot_get_by_id(struct devlink_region *region, u32 id)
 #define DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT	BIT(1)
 #define DEVLINK_NL_FLAG_NEED_RATE		BIT(2)
 #define DEVLINK_NL_FLAG_NEED_RATE_NODE		BIT(3)
+#define DEVLINK_NL_FLAG_NEED_LINECARD		BIT(4)
 
 /* The per devlink instance lock is taken by default in the pre-doit
  * operation, yet several commands do not require this. The global
  * devlink lock is taken and protects from disruption by user-calls.
  */
-#define DEVLINK_NL_FLAG_NO_LOCK			BIT(4)
+#define DEVLINK_NL_FLAG_NO_LOCK			BIT(5)
 
 static int devlink_nl_pre_doit(const struct genl_ops *ops,
 			       struct sk_buff *skb, struct genl_info *info)
 {
+	struct devlink_linecard *linecard;
 	struct devlink_port *devlink_port;
 	struct devlink *devlink;
 	int err;
@@ -669,6 +730,13 @@ static int devlink_nl_pre_doit(const struct genl_ops *ops,
 			goto unlock;
 		}
 		info->user_ptr[1] = rate_node;
+	} else if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_LINECARD) {
+		linecard = devlink_linecard_get_from_info(devlink, info);
+		if (IS_ERR(linecard)) {
+			err = PTR_ERR(linecard);
+			goto unlock;
+		}
+		info->user_ptr[1] = linecard;
 	}
 	return 0;
 
@@ -683,9 +751,14 @@ static int devlink_nl_pre_doit(const struct genl_ops *ops,
 static void devlink_nl_post_doit(const struct genl_ops *ops,
 				 struct sk_buff *skb, struct genl_info *info)
 {
+	struct devlink_linecard *linecard;
 	struct devlink *devlink;
 
 	devlink = info->user_ptr[0];
+	if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_LINECARD) {
+		linecard = info->user_ptr[1];
+		devlink_linecard_put(linecard);
+	}
 	if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK)
 		mutex_unlock(&devlink->lock);
 	devlink_put(devlink);
@@ -1964,6 +2037,132 @@ static int devlink_nl_cmd_rate_del_doit(struct sk_buff *skb,
 	return err;
 }
 
+static int devlink_nl_linecard_fill(struct sk_buff *msg,
+				    struct devlink *devlink,
+				    struct devlink_linecard *linecard,
+				    enum devlink_command cmd, u32 portid,
+				    u32 seq, int flags,
+				    struct netlink_ext_ack *extack)
+{
+	void *hdr;
+
+	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	if (devlink_nl_put_handle(msg, devlink))
+		goto nla_put_failure;
+	if (nla_put_u32(msg, DEVLINK_ATTR_LINECARD_INDEX, linecard->index))
+		goto nla_put_failure;
+
+	genlmsg_end(msg, hdr);
+	return 0;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	return -EMSGSIZE;
+}
+
+static void devlink_linecard_notify(struct devlink_linecard *linecard,
+				    enum devlink_command cmd)
+{
+	struct devlink *devlink = linecard->devlink;
+	struct sk_buff *msg;
+	int err;
+
+	WARN_ON(cmd != DEVLINK_CMD_LINECARD_NEW &&
+		cmd != DEVLINK_CMD_LINECARD_DEL);
+
+	if (!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED))
+		return;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	err = devlink_nl_linecard_fill(msg, devlink, linecard, cmd, 0, 0, 0,
+				       NULL);
+	if (err) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast_netns(&devlink_nl_family, devlink_net(devlink),
+				msg, 0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
+}
+
+static int devlink_nl_cmd_linecard_get_doit(struct sk_buff *skb,
+					    struct genl_info *info)
+{
+	struct devlink_linecard *linecard = info->user_ptr[1];
+	struct devlink *devlink = linecard->devlink;
+	struct sk_buff *msg;
+	int err;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	err = devlink_nl_linecard_fill(msg, devlink, linecard,
+				       DEVLINK_CMD_LINECARD_NEW,
+				       info->snd_portid, info->snd_seq, 0,
+				       info->extack);
+	if (err) {
+		nlmsg_free(msg);
+		return err;
+	}
+
+	return genlmsg_reply(msg, info);
+}
+
+static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
+					      struct netlink_callback *cb)
+{
+	struct devlink_linecard *linecard;
+	struct devlink *devlink;
+	int start = cb->args[0];
+	unsigned long index;
+	int idx = 0;
+	int err;
+
+	mutex_lock(&devlink_mutex);
+	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
+		if (!devlink_try_get(devlink))
+			continue;
+
+		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
+			goto retry;
+
+		mutex_lock(&devlink->linecards_lock);
+		list_for_each_entry(linecard, &devlink->linecard_list, list) {
+			if (idx < start) {
+				idx++;
+				continue;
+			}
+			err = devlink_nl_linecard_fill(msg, devlink, linecard,
+						       DEVLINK_CMD_LINECARD_NEW,
+						       NETLINK_CB(cb->skb).portid,
+						       cb->nlh->nlmsg_seq,
+						       NLM_F_MULTI,
+						       cb->extack);
+			if (err) {
+				mutex_unlock(&devlink->linecards_lock);
+				devlink_put(devlink);
+				goto out;
+			}
+			idx++;
+		}
+		mutex_unlock(&devlink->linecards_lock);
+retry:
+		devlink_put(devlink);
+	}
+out:
+	mutex_unlock(&devlink_mutex);
+
+	cb->args[0] = idx;
+	return msg->len;
+}
+
 static int devlink_nl_sb_fill(struct sk_buff *msg, struct devlink *devlink,
 			      struct devlink_sb *devlink_sb,
 			      enum devlink_command cmd, u32 portid,
@@ -8589,6 +8788,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_RATE_TX_MAX] = { .type = NLA_U64 },
 	[DEVLINK_ATTR_RATE_NODE_NAME] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_RATE_PARENT_NODE_NAME] = { .type = NLA_NUL_STRING },
+	[DEVLINK_ATTR_LINECARD_INDEX] = { .type = NLA_U32 },
 };
 
 static const struct genl_small_ops devlink_nl_ops[] = {
@@ -8664,6 +8864,13 @@ static const struct genl_small_ops devlink_nl_ops[] = {
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = DEVLINK_NL_FLAG_NO_LOCK,
 	},
+	{
+		.cmd = DEVLINK_CMD_LINECARD_GET,
+		.doit = devlink_nl_cmd_linecard_get_doit,
+		.dumpit = devlink_nl_cmd_linecard_get_dumpit,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_LINECARD,
+		/* can be retrieved by unprivileged users */
+	},
 	{
 		.cmd = DEVLINK_CMD_SB_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
@@ -9043,6 +9250,7 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 	write_pnet(&devlink->_net, net);
 	INIT_LIST_HEAD(&devlink->port_list);
 	INIT_LIST_HEAD(&devlink->rate_list);
+	INIT_LIST_HEAD(&devlink->linecard_list);
 	INIT_LIST_HEAD(&devlink->sb_list);
 	INIT_LIST_HEAD_RCU(&devlink->dpipe_table_list);
 	INIT_LIST_HEAD(&devlink->resource_list);
@@ -9054,6 +9262,7 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 	INIT_LIST_HEAD(&devlink->trap_policer_list);
 	mutex_init(&devlink->lock);
 	mutex_init(&devlink->reporters_lock);
+	mutex_init(&devlink->linecards_lock);
 	refcount_set(&devlink->refcount, 1);
 	init_completion(&devlink->comp);
 
@@ -9080,10 +9289,14 @@ static void devlink_notify_register(struct devlink *devlink)
 	struct devlink_param_item *param_item;
 	struct devlink_trap_item *trap_item;
 	struct devlink_port *devlink_port;
+	struct devlink_linecard *linecard;
 	struct devlink_rate *rate_node;
 	struct devlink_region *region;
 
 	devlink_notify(devlink, DEVLINK_CMD_NEW);
+	list_for_each_entry(linecard, &devlink->linecard_list, list)
+		devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
+
 	list_for_each_entry(devlink_port, &devlink->port_list, list)
 		devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
 
@@ -9191,6 +9404,7 @@ void devlink_free(struct devlink *devlink)
 {
 	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
 
+	mutex_destroy(&devlink->linecards_lock);
 	mutex_destroy(&devlink->reporters_lock);
 	mutex_destroy(&devlink->lock);
 	WARN_ON(!list_empty(&devlink->trap_policer_list));
@@ -9203,6 +9417,7 @@ void devlink_free(struct devlink *devlink)
 	WARN_ON(!list_empty(&devlink->dpipe_table_list));
 	WARN_ON(!list_empty(&devlink->sb_list));
 	WARN_ON(!list_empty(&devlink->rate_list));
+	WARN_ON(!list_empty(&devlink->linecard_list));
 	WARN_ON(!list_empty(&devlink->port_list));
 
 	xa_destroy(&devlink->snapshot_ids);
@@ -9747,6 +9962,59 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 	return 0;
 }
 
+/**
+ *	devlink_linecard_create - Create devlink linecard
+ *
+ *	@devlink: devlink
+ *	@linecard_index: driver-specific numerical identifier of the linecard
+ *
+ *	Create devlink linecard instance with provided linecard index.
+ *	Caller can use any indexing, even hw-related one.
+ */
+struct devlink_linecard *devlink_linecard_create(struct devlink *devlink,
+						 unsigned int linecard_index)
+{
+	struct devlink_linecard *linecard;
+
+	mutex_lock(&devlink->linecards_lock);
+	if (devlink_linecard_index_exists(devlink, linecard_index)) {
+		mutex_unlock(&devlink->linecards_lock);
+		return ERR_PTR(-EEXIST);
+	}
+
+	linecard = kzalloc(sizeof(*linecard), GFP_KERNEL);
+	if (!linecard) {
+		mutex_unlock(&devlink->linecards_lock);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	linecard->devlink = devlink;
+	linecard->index = linecard_index;
+	list_add_tail(&linecard->list, &devlink->linecard_list);
+	refcount_set(&linecard->refcount, 1);
+	mutex_unlock(&devlink->linecards_lock);
+	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
+	return linecard;
+}
+EXPORT_SYMBOL_GPL(devlink_linecard_create);
+
+/**
+ *	devlink_linecard_destroy - Destroy devlink linecard
+ *
+ *	@linecard: devlink linecard
+ */
+void devlink_linecard_destroy(struct devlink_linecard *linecard)
+{
+	struct devlink *devlink = linecard->devlink;
+
+	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_DEL);
+	mutex_lock(&devlink->linecards_lock);
+	list_del(&linecard->list);
+	mutex_unlock(&devlink->linecards_lock);
+	devlink_linecard_put(linecard);
+}
+EXPORT_SYMBOL_GPL(devlink_linecard_destroy);
+
 int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u32 size, u16 ingress_pools_count,
 			u16 egress_pools_count, u16 ingress_tc_count,
-- 
2.33.1

