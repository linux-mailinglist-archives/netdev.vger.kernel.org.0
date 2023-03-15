Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8123D6BB412
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 14:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbjCONNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 09:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjCONND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 09:13:03 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2066.outbound.protection.outlook.com [40.107.244.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4EE19B1
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 06:13:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Meax/zkHyGa846ltMoFrVJP/BREgWcrT08EcNzqqFJyUklq3LehezIU1LGMhEiy306cjNFqvyTpDkNn9EBXkKTUujblpgHQzPfJq3GKxZd1elc2HqetPb+r04nvQPGRomZ81kg2NPUPbn3SyMHjPwUd6ECIxQ+QtMJIiCjN8JZtDablMtXYYbklE7Jg3Ib94xTjkF+4uwOthprGk4EDqDYFb1dWY1Gn8Nj7x+wrlBGS+yAgZKgxKANsBeITnSSfQqFmj9oMAIxnlDEFN8FZ2ZEPZf1Yt9Ne25kWiuvgpbQziwhcqIzLlI19inQen7vG5EnbIVCOza2BZ+WyJew9mLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mfd0MVbqQIVlSUCe2YUBWdS04BOaHfasZyBdAOmw1jI=;
 b=XGz3tdQiIsYrfFjMOExF5jjsOYlU1UglWguKJxywKZmV20iT7MUtzk5P1XLdi3cqFZ3BLNiSH7DnM6ysRDjJ9teojtFxZ/LmsbD0VsbAZA5HhVK735PZ4tkRfB+mSI1MxzJWoV0yajPFigkgR18OOvf7uHM8zL9IvGUTtI+HTYPCNZci3MBbf5ATubX0Us7BtCSIr0An8GfpMBLYvZ9QLo8edbA7f6jlbfclRJoVoUiGy5+kT0Get69pkcvUKkbgWaE6mQey1uAp17jRRjNZSgk9+WC2HJK02o0/NBrLRiML81ue+x1/DqW1Yf1BSBWBa25o+zs7OS7dwL0us3tNaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mfd0MVbqQIVlSUCe2YUBWdS04BOaHfasZyBdAOmw1jI=;
 b=k0OSmAjAI/hQ6zftlXNNqRAx6VaSTXJ1+EfGWGoO6tx4zeMlekzeEHWCdI2i0bLAqhcUU+nMgamymBidYpzYZamyLd/NgA3KD+uzs7tNnRLkhh2RGwl1QJ3WvcF7h+gUOC5DPvUqb1LyhsSyT6EwwoZBDmZaFYyBdLlpbKD7o+sCoOkbRKuo8akXMoZCjlyAI8kF3bagdI1zRa3il3CXS8qMPgXT80K8/siwpiJ9ETfPnxhsliQa4m2omTt9ij3KvlkOW+Ul9uX1yiOYRbwKySzCMDgFey0sd9Yf9X3kCg0LOlAEDRbLvbmdArkBryqT/MJTeHeGbfmbZ1UtZK79fA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SA3PR12MB8802.namprd12.prod.outlook.com (2603:10b6:806:312::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 13:12:59 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 13:12:59 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 01/11] net: Add MDB net device operations
Date:   Wed, 15 Mar 2023 15:11:45 +0200
Message-Id: <20230315131155.4071175-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230315131155.4071175-1-idosch@nvidia.com>
References: <20230315131155.4071175-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0902CA0051.eurprd09.prod.outlook.com
 (2603:10a6:802:1::40) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SA3PR12MB8802:EE_
X-MS-Office365-Filtering-Correlation-Id: 26ad4939-13b3-4634-3758-08db2556fffb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JnZMntfWYXmWJ96P/IsM/crAPSZlttno2ZqZMwHwaVsGeWAA+zWQgN4pyCP5s6Mo2Hfk+TGER81VRPx3oj5Y5UAkzKZejhT2n+YX3bY1dwTJww5RnAfNp3+Ah7nXZG6yiLc+1LAu56QszgK5MxJ8Gq5uxJs10uTDsPNtEXix3VOX2z9i+VaSlPU6/HR0JsZPi0SDqc+qcR+qKEUBGFNV7EhIMUCYEFgTy0n36Cl0wzXhlERUjJANBV+mdCLMjCdBr8wSyn6ys+bqm6aPbyfdZTru77eJA4pvQBcjzVP5OU2G88LNlyeYkKJhnbTnLw1nsd6QXCjxBKYFJoItV+4LjaSG6Z+SfQXQHRcaav6KBoNQnghZeByTvmWLrx0IxZvxCfgZhBqZDHoeckFfE64sQ1SXO+jpOXPwA+uLFXQmOpQIdhH07Au83JYlvYUoGxsT+/3jE6DCb+gyyZht0EYwU4EBfCLL7Ov1oUVSWpTWfFFl1kiFNhOnxl7Wx+X7awJiOiaA0LIFsIcqMUaB1PRIu8NmRCo7neiDcCHqm6shyG/TLBaMYOw0bi1aXweipApIs/6wjeRBlsg2mGuHFkAP4vRBzUO4h7VLVhXBQiZ8ssri/39COuHb9ppdIFy10xlfhel27Yd7+R4/I48vR+mmzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(136003)(366004)(39860400002)(376002)(451199018)(86362001)(36756003)(41300700001)(5660300002)(8936002)(38100700002)(2906002)(478600001)(66476007)(8676002)(66946007)(6486002)(6666004)(66556008)(4326008)(83380400001)(107886003)(316002)(186003)(1076003)(26005)(6512007)(6506007)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dniAIkvYVtsRDGnwBCpkK20qfYxaVzOZcQFSSX6dzJOwrIiyH75HXYKhUDzo?=
 =?us-ascii?Q?lRd3Xoh+5oAYWut4vN6I0f6iWwNaKfHTGasozj9Yr8o9E/EYceyx+qHdDMIN?=
 =?us-ascii?Q?UQzZ/Gi70cIEzNTLvlRtEaZKOjxctaAPNEJutB+kfYy/rBHNlazGpcrsYX86?=
 =?us-ascii?Q?yvN0PVu4Y8HBuCnmy7kNB1zb/M/7Bn5JWx0XlMYXcXTnc2Hz8Ks8fj/uB0dN?=
 =?us-ascii?Q?0w4YRv77z3Lzo+iqMHulRkw8Y6sw6hcXugA/0Sggnlfm0NGbMBUPf3ELI7ek?=
 =?us-ascii?Q?UxPrFt/JSrWWJ7U6Vf9c8z8y9q1WApQeH9POshf0mp3no3cJmxSN7TEQgyWz?=
 =?us-ascii?Q?R9h+oIRjj+NdapIoPlhbp0S0C7TBxx8L+bBzfGbCHhAMm7cy7XFSiRlK5d/g?=
 =?us-ascii?Q?n0ACTlHPqD4298CVDG1klX26jIkapHm62p0z5oBBeRpYBVHLGLr0uNGGBjjM?=
 =?us-ascii?Q?oh8uLL4v77eltL3m8Dyeudjh9iH/ShaXhHcKCoVJT3K5U3umW1qdHIZwTEbY?=
 =?us-ascii?Q?LyxBBxEyaDAL4j/b1zImCQKZgj7V+a+ps0378yB1JLBci6ranquM3RkQKVOM?=
 =?us-ascii?Q?zRZTjZAJQqiN98f6lWJbH5oppZu3e2EJ0EUXZCI5SGZVTHOB/TDMKDzGmqPg?=
 =?us-ascii?Q?uqjLewqG3BzCMjZmGdLBopCVOjFcEAvVw1F3+Ja8T3Bkpyo3cG602kboqfcD?=
 =?us-ascii?Q?QLnArGd9qJnrXGp5+Ma3lab93qj4ynett7kXetqgCYzUSeOmKPceofNDXAdR?=
 =?us-ascii?Q?vvBW2PYOPDnMp5FR/J1lutOZ/dY6hMmmTUlLt3IT1UjL6kp67lEg+AmyzJEB?=
 =?us-ascii?Q?8gNQETgZP0GyaJgnYpvZcpVRxfAtlKMKhOGaPe6IIZA7C+c8qMZqMXsq5Hla?=
 =?us-ascii?Q?t+9gieQ1Q7yPYd7X3WHJ8x4FLT9FfpG1N7UyoP8NxeotZ5KK6JDdnrfZAeC9?=
 =?us-ascii?Q?Pm4RnWaaCZX3urJiqNaMO2n9F6WYHa85CeVx65fscBBqV3mvmfOr6VrEJDoE?=
 =?us-ascii?Q?RoFZjL1AKAZNYRld4ya0DpbExFeIy+XnGI3rVatVNwttu9fH9ptJUdWWQpR8?=
 =?us-ascii?Q?/jGwyUYcnmXGxT0AOmuwCT+EQhl5LfJ+5uLc/NyJ6weFb9MD5vxMO+qK/pvy?=
 =?us-ascii?Q?KmrtM0hu8rbOSnrPjI+pPdoUWjYN2JQEhnRz8Pcyi/rvLsH9IYbMcT/hzjcn?=
 =?us-ascii?Q?Szmpjn4IGjy7XjtVHQhxvXrC7hVC2sByzXaH5XJg8WbPQxV3mLAchlT81Zzb?=
 =?us-ascii?Q?rMrIYhik/8lem1+RxGtCF6jcsAtPcoRqcLuiPAcOT8Xee/9mGZXdmekhP1Ek?=
 =?us-ascii?Q?2msDl74F/zhvKsd5F+acgf33f4ymZvnu/xtIZeBQWHKEZ9Mj3mchaSKB+YUm?=
 =?us-ascii?Q?6xy91SrL8KWE2kodoQI+6nOfxAAJWSYCAlNnuZMFHM7Mtqy5Ez6YBzwhNC8M?=
 =?us-ascii?Q?8Mu+IE0aFI684LNNARTYh/0soZOO7zPfgcAh24oS5SOcSRAUht74Uq1cB5sz?=
 =?us-ascii?Q?ihcbSjiRpkB0b32gN/9wjNi8AI5sfm8ziLP8jg4SV+Fo5SWQgDClpZGkZma1?=
 =?us-ascii?Q?NiF1AHVDwZ9ObqZsUUH6pcRWqEm40nEWKDyFm+0S?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26ad4939-13b3-4634-3758-08db2556fffb
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 13:12:59.6844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0rJov82xefckfocIvzBRIrJOj1Vh3l42qHquobZ7xAgHjmuiLfC/V6VG5/26wd+JPaKnjsKWuFoHStDH9Ze7sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8802
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add MDB net device operations that will be invoked by rtnetlink code in
response to received RTM_{NEW,DEL,GET}MDB messages. Subsequent patches
will implement these operations in the bridge and VXLAN drivers.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 include/linux/netdevice.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index ee483071cf59..23b0d7eaaadd 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1307,6 +1307,17 @@ struct netdev_net_notifier {
  *	Used to add FDB entries to dump requests. Implementers should add
  *	entries to skb and update idx with the number of entries.
  *
+ * int (*ndo_mdb_add)(struct net_device *dev, struct nlattr *tb[],
+ *		      u16 nlmsg_flags, struct netlink_ext_ack *extack);
+ *	Adds an MDB entry to dev.
+ * int (*ndo_mdb_del)(struct net_device *dev, struct nlattr *tb[],
+ *		      struct netlink_ext_ack *extack);
+ *	Deletes the MDB entry from dev.
+ * int (*ndo_mdb_dump)(struct net_device *dev, struct sk_buff *skb,
+ *		       struct netlink_callback *cb);
+ *	Dumps MDB entries from dev. The first argument (marker) in the netlink
+ *	callback is used by core rtnetlink code.
+ *
  * int (*ndo_bridge_setlink)(struct net_device *dev, struct nlmsghdr *nlh,
  *			     u16 flags, struct netlink_ext_ack *extack)
  * int (*ndo_bridge_getlink)(struct sk_buff *skb, u32 pid, u32 seq,
@@ -1569,6 +1580,16 @@ struct net_device_ops {
 					       const unsigned char *addr,
 					       u16 vid, u32 portid, u32 seq,
 					       struct netlink_ext_ack *extack);
+	int			(*ndo_mdb_add)(struct net_device *dev,
+					       struct nlattr *tb[],
+					       u16 nlmsg_flags,
+					       struct netlink_ext_ack *extack);
+	int			(*ndo_mdb_del)(struct net_device *dev,
+					       struct nlattr *tb[],
+					       struct netlink_ext_ack *extack);
+	int			(*ndo_mdb_dump)(struct net_device *dev,
+						struct sk_buff *skb,
+						struct netlink_callback *cb);
 	int			(*ndo_bridge_setlink)(struct net_device *dev,
 						      struct nlmsghdr *nlh,
 						      u16 flags,
-- 
2.37.3

