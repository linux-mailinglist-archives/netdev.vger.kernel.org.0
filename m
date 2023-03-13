Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D55EC6B7B36
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 15:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbjCMO4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 10:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbjCMOzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 10:55:49 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2064.outbound.protection.outlook.com [40.107.96.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F8C31BC6
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 07:55:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HA4vXd/g2dvtyo098uHvjtMXX2B3k2nCUpkx1GnNfNKmuP4SXElTo96bvpk9q0oX1FkJmKIuB4Szg8Px8II0Z3lqrQ0A48Wt5keEQZal2tLUrGmUgBpzA4/sUl/nqIvKsybCCucOxBW/sKlLQbJeBRpZWYoCWHomeC/4KfhJkXWDdYIY+vxjXcBa/94iqmmrpYup7IKtJmUOPhL6XwkAe8s6aApJ5mQPdLdN5Lkyo/FrlyTO8Be9MGZvk+6As5+B7Lcs5ncZyMVJ0rUUbhRyxthEvMfgNsD0UvA1AaTJtiDcBz9F8RYgrAwL7dU91XiCC8IylF3vA/9PQ3phqT2Ssw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3nQgq7nyhKCU3RT3Uf1rsPppJDA6hA5KYdFN4CWOnvM=;
 b=URrTkjaojPyIH7EEApDZg3L3BXre/zpyuXdWZxnaAKFIOvO+pI0BMlXAOyLTkZyVTXOgLb9PkzkU3IgUdOgkSqiTeXPLDaoMJfjVUeDuBC9tz8QidYoEGNGIWGHjiBQYyG8niUOcDg1Kq66wv901K8iUdnMO2Z5tTqiMPevJRjUUgaTtMMlsfT/a/CHsnwJ6bSHFBbokF9zuwLBYwkjcZVTzV6TjwlOE5De00VvWLjGZnvCgzYurW4IE9vZ2VVhB9mF4txCW3dlJJStRK+cL3Ydh/WdWwkgJ2xauxkJDItz9qNwD5DEK4QbqcahBO61fX1Oa1oxcSuUN2zxsaOddTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3nQgq7nyhKCU3RT3Uf1rsPppJDA6hA5KYdFN4CWOnvM=;
 b=o2xiAYPeqz82lOK/BpqJ+P3aK+cvOFBw88scZDkkRFNxIjlvpw7Ig3E2QlAW7LoXAvEpuvsDU7RlbjmgPPP3tPeZgUeVuwv8RHPeJAvX063Hwo610H/MIrYJumnhrkS4w9AF8TBktLmSsJWgyxKMF/5xyAdrBmkSTZNNjX/5pAj5NshcOBHjNtxL0fXgdksK84ky1EUxTHR+NgEO1PD8PYM60iVywlv3ifYjVm4AW1Dlr73lNgt5B6F1Qc5S0qIiM+l7HBf1wsdiQS0GhYsQX6qHVxofDCNeev8C112PypRPc5yFl61J3iIJuBcDi/ZamuicVlwwHOk3E3xns4RF0Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MN2PR12MB4550.namprd12.prod.outlook.com (2603:10b6:208:24e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 14:55:12 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%6]) with mapi id 15.20.6178.022; Mon, 13 Mar 2023
 14:55:12 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 01/11] net: Add MDB net device operations
Date:   Mon, 13 Mar 2023 16:53:39 +0200
Message-Id: <20230313145349.3557231-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230313145349.3557231-1-idosch@nvidia.com>
References: <20230313145349.3557231-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0005.eurprd05.prod.outlook.com
 (2603:10a6:800:92::15) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|MN2PR12MB4550:EE_
X-MS-Office365-Filtering-Correlation-Id: 16840e7d-709d-4d64-575a-08db23d2f255
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7kxswCnzTT3v5vAiR3kyIaSbaPNCpBOkIrkd8SzwOjNbBTbqm8UWuet900JfU9ykL7f6TlesdAa9iHXMm+aI/fCsXRuBc8HsW7V5iHa8VvPgLXcxaN0opBNnQWDrKbs9r+/A97XNJeqPGiTKdLaJS+bjKBXLCWWKyo6+jTaqMbTu+AY1/kuOoPnnwNkM3Y7zUmbIYidBs5ZVC5glg7wJOx87tyhYeugsDlc1fX4M/cdwIshrG6AA2mrP3GdKUU83Lm6l1tMNBezAerCBm4rmbeuHRhFD4ltSR/Yw3M40e1i5dgyl4CuWZXr2nJzU9ytmDmSEk26RlAnnbhA7DUO4JXTNdJR05it/iN1IXr3Ngco57BlD58Om/gdjFaJ9qnatFEEQEYJ4TYBvZBLqdXTZtkyYJKIsuLoxoygtHO0EOcFnOOCxw/+qMDAfvk68mhmMvYscbMGnBi9RdSt+iD+rF2ONH6PliydeKDzgQyjHYoMOW812lTtLKCZoyriaz30txt88t+W54JTQHFcjTg4NCjPNPHPXVG7aO5M1NWl5q2RaOHwQJki7r89+CEUqMco5Ld3ILdTvMTrO38uVBTzE10OXvQEyy7IIrHbfZYldEKVTmrtUA8oIPJ7WixqV3yBK+wLQwtLQKcM0KVMLIsMOlg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(136003)(346002)(396003)(39860400002)(451199018)(38100700002)(2906002)(66946007)(41300700001)(66476007)(66556008)(8676002)(4326008)(316002)(478600001)(86362001)(36756003)(6486002)(5660300002)(1076003)(6512007)(6506007)(26005)(2616005)(186003)(107886003)(6666004)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y1jvdP5DLo9gvD/itlW2OPxxhIY+n2Mua0pQRSxHl2cZU14lDU6SZBh29tUS?=
 =?us-ascii?Q?pTi+xnrwHM+NQhIletKpUnAznXKZGkjinQLbid05egec/ITKaf+QdQcb2pAM?=
 =?us-ascii?Q?kEcCvT4wd16+Sb8tgGT5yt1VAUDTFBZm5G0pMQlUv5VMrs+fSnetQ7YaR5su?=
 =?us-ascii?Q?0YVrbkWMgnq6PX+zQb0CAG9W+WTRwQYSA9GQjanud9SN1+VZoiLV3y79TglM?=
 =?us-ascii?Q?Vy7SSzRzjPk8+P8nkM6A4XjmSY3s5i9G6AgjdCbyG5kd5sFdjzR6I5L+6/z3?=
 =?us-ascii?Q?guf8eZ399s03HBLCzqhAHH9CcD/1OGs90OGDmIQCXaLGbCs3EHPQURYsUuRa?=
 =?us-ascii?Q?bNrZGyzTzJh6CIpOGjaRAg9TPBTYaCIZfHGEyCCItusEmrPIY2T9MjplKs6v?=
 =?us-ascii?Q?fxKbC0M9ylBJFRoLoEMr3J1IG2f8jVWTsyf0I7g+GhOFgHDBWmg4dLjmqTKo?=
 =?us-ascii?Q?LeBtwa/Id+bqb86YEXOCDU4oq45f8Y1l9HdDmydZ8+ljd+PTm8xF+3lOyGot?=
 =?us-ascii?Q?lfydQ7BbZREPAKatHmUAUfBF6EsdwfPh/75nf+x8XoPj+QvDnaFFFiyOGlCx?=
 =?us-ascii?Q?fmrdFAjI3ySRrHai9qFW32hUfsSab3YoBLw/Y7diR7imqUSuUq7FkWBNYwyz?=
 =?us-ascii?Q?XlK34s47QZaRTTxVjrA5XkZVBr+oNmRk9fvcCVm/R5UG8knNRFopIozha3im?=
 =?us-ascii?Q?6R7B6NVfWFC3XTcZArTjxlkJxUREjT54oT1k0f95Qzw9MjoWbzYNXys9q8mD?=
 =?us-ascii?Q?rIIYaggUx+Vgy0MpO+TbPGjoDzV3C29uFn61Mze1Pa1f/2avY1hlvp1lvDQG?=
 =?us-ascii?Q?fqO4rWBTZT3YWzRGNTTqP6RPjEfUu480xN08YITxoaDfn9MTJarZYf4cnOhd?=
 =?us-ascii?Q?heXhwjSSr5TGgLGawXshwRmusq5hjmyHLdGw3sey0/aurKyp1bAJ/QuIoCIC?=
 =?us-ascii?Q?99pOQRJAsTG8l7chueBdAki1uUw/UpgrDW5Y25FfzkSkqxkPGEuTCT1V51Fa?=
 =?us-ascii?Q?NxO4ZdoqCka7Ii5F4ozvltiqcEvmqMcYJKdte5h484+D8dmDUgcR9loCvECZ?=
 =?us-ascii?Q?oELJZCp1VAuT7uYGA7Uj/jghOgC6U8pekE+aYlOr1VbIvjaHX0d+aF0XNE1v?=
 =?us-ascii?Q?vm7kOauUsWgGHEK6L/EUj9aYysP8n2mKyLEpW4kfsvrNRV3rOGt56DRrn/OB?=
 =?us-ascii?Q?FaY8roqbUlNIdJO49oISQdE/Fl6KRQKrTX6fv1sMXHJlyVTam3ip2cYZhEM9?=
 =?us-ascii?Q?Ls0iN9TTeiD59WKl+PHihbhZAW/UorqwBUou2I89rn/OgOlJ9dhteh9f+hx0?=
 =?us-ascii?Q?vcD7yd6DCAp/9H1pF6l5WaTPYIXozdux6BkrUjBeQcfolPfA+aTQfBj88ODv?=
 =?us-ascii?Q?/ZEVi2cZdCzdqLgAgD72J78PsOuF4Mv9Y4zGok/s5HjPD0lYoEo0/KS5mXwq?=
 =?us-ascii?Q?479f1yO5+uN6VGNXUNqs8MRvMMcrSlcQ1JAshQ/zIpelAk8pSgxzmFRrEjuQ?=
 =?us-ascii?Q?7qhGjxdULV32bV/AH769+o9M4kG9+nrgysNeepusUDVmch7MnrNjKpV01901?=
 =?us-ascii?Q?0BmIxiWXd2AAbkbN8gd7+h8D5hXDegQHKI5cqoNS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16840e7d-709d-4d64-575a-08db23d2f255
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 14:55:12.1495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GjBZREBqPao/1y8brCZFlKvMXTyEiunUi2C+xsgSmwFcmx2VXLLX9LWR/hLiCAuOyGzXD+wiKB0gRYhfGuYkWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4550
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add MDB net device operations that will be invoked by rtnetlink code in
response to received RTM_{NEW,DEL,GET}MDB messages. Subsequent patches
will implement these operations in the bridge and VXLAN drivers.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
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

