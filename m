Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D8C2D086D
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 01:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728742AbgLGABT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 19:01:19 -0500
Received: from mail-eopbgr80054.outbound.protection.outlook.com ([40.107.8.54]:57805
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728715AbgLGABS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Dec 2020 19:01:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=btKyS58qJ2XJCirFJ8tDVk6FUDjbeFLjYE51LgZiSO2hrQWEM3gkLlJDjVWxD+RNYqBT6ppiZbUewaWBZfLVZMfmbJ/6Gf8jRGY91glgrJx9pjShqtJG5TYc+VozFXvnHhezPaWIkd4TJjXplc0Qcc4TQcG0UlWczwypSlN8/ePmnUo3zN51Ao4wkMcO1j7v+KiHQik5HirN+E6GslpdlOhLzluq9p1OIKxR8SYeKV9K+0S+xVGxJlAPY75oTdusISEh7H2P+CysYR/N0GljO0tvaFgeUYtpsvPa9ocauxlfXxYKN6P2olMSxAz1Wll10nwUrFds9glj1Hsh7RBq9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ztUyQXrpTPLs63n+922gBTletwutk/pvS5Hm/e4I8+4=;
 b=l66oXXSz6Hq5AHuxjyRZSEde6In6NURGkedb33sV2Mb2g/htICr7QRCNO4rwxR7KD/+5KRbQPJenOt2/ksKR77rXeH8DhumNB/do4vwnO26BOLXjT3X9Ds5ZPDFXdLohNABiSN0PlEmh0Hmwm5IVDjN2BlHDMYk6Yjy9uaq74eWl74UQsQTSJSRDzoDGICC9ZK/wCsPXSv/BFhOk11WXW/o89DhAR+oMa9T47gZcYA+c90g3yPmSkq9XYpsHq8G5oD9p0Gydjt02LDYeJpC5PUwtW3X1WMeb7+hB25Gxs3A8yVQW8VpD7vSeuAonI8eAxG27zQHbypYYiygly42K5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ztUyQXrpTPLs63n+922gBTletwutk/pvS5Hm/e4I8+4=;
 b=fJpBvV8+GL+DFya6Ypa769wLjb+KxVtrhMSJRrcpJ5Eac4KaKk8S5+rHciGfW2+J8M0B704EJrbD/KDTniICY6u4sYcwkf+f7or5Qw2lWk4zX73nkNf3dliRaBtxf0OLYMIceOSP2lL7K2Xeb0QP74k3OyF1cMZD4+1r9tgJMBg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6637.eurprd04.prod.outlook.com (2603:10a6:803:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Mon, 7 Dec
 2020 00:00:04 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Mon, 7 Dec 2020
 00:00:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jiri Benc <jbenc@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: [RFC PATCH net-next 05/13] net: bonding: hold the netdev lists lock when retrieving device statistics
Date:   Mon,  7 Dec 2020 01:59:11 +0200
Message-Id: <20201206235919.393158-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201206235919.393158-1-vladimir.oltean@nxp.com>
References: <20201206235919.393158-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1PR08CA0156.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::34) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0156.eurprd08.prod.outlook.com (2603:10a6:800:d5::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21 via Frontend Transport; Mon, 7 Dec 2020 00:00:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 850cc018-9e31-4564-d31e-08d89a430c14
X-MS-TrafficTypeDiagnostic: VE1PR04MB6637:
X-Microsoft-Antispam-PRVS: <VE1PR04MB66374B7B0930BDD119C34F4AE0CE0@VE1PR04MB6637.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qUNa3fvCSRvnflBGqTV9Z/cY40zow2iuGcCtMTNh8Fb/LeZ6e6d77A4z0zFKV18/p+a2MFcBhQr8cqQnztwwqAP7Zbw3ITKH1GlfQ0hd7ioY+s5w6gUFV9bIa/7Nhmy5nbAkNNNn7m7y38KHpeHs7hMEOgciab8eb03bsApR8pf0UYgiV1RyFTlGoXFeduWSPJ8KQNbxoLu9JQiFvqNIV4dqKfiJRBaGebERT/32NEa7SKs1SYZclMB1MxWBRh7Eshr5IVvrsTy3Y/2WfkE75EfUFjlIfuM/1WwY59p2OhgSup2dYJgJsdO4TlHxQAK/tA05GUevRyl71ircU7B8ue2YmrUFhssHyZ5QmNYXUB5/R6VWZZMGWFC2uSVI5BSt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(6506007)(52116002)(5660300002)(66946007)(66556008)(26005)(8676002)(2906002)(8936002)(1076003)(316002)(110136005)(54906003)(478600001)(44832011)(7416002)(6512007)(186003)(6486002)(16526019)(6666004)(36756003)(956004)(4326008)(86362001)(66476007)(69590400008)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?MSrM70IKUrCpYRy0VefAEiyr0q+fGg+ibLh0S/dH0XEvmzV2SHyu0E9FAbwd?=
 =?us-ascii?Q?RE6db3i7XUt0ui1Y64i8ZDonC7aPD7155xW3NtYj+zkFPNXGPO7n+b8Daj2O?=
 =?us-ascii?Q?j3sGXTdpFiT3GMPUy1T1a2le7SiQK/XkuEY65122I8+K/B9ziHGnmqz/Qo6/?=
 =?us-ascii?Q?G09XU13C+Jc4KNFGIlaWx4tgGCT5+mLXSwR3pA3O4847QppNrNs7pWqqjKkE?=
 =?us-ascii?Q?m/vQt8V/gI62Lad/n3JFUS/neyZev4bm4KzG3SKTU557xdbiHNm/rCETsic0?=
 =?us-ascii?Q?VMIWbRzbMGWSRCLVTreTYAiSoV4lWrbNoTVjYpshRi4GTsQKSgspSFN5c1xx?=
 =?us-ascii?Q?0ks1BpB7c10U0jma7oaRUhhVUOzMm5nx1tF+gMxVKI8pIIbywBgU6I6FwA2c?=
 =?us-ascii?Q?6DdKmYO4JxT0enyAvUr2k2YOuVR7XqYvm2Go0nltniZfEpSMNSS8WfdVc8vh?=
 =?us-ascii?Q?CVWOBOfmiTIjqor/utvKW1RRwhPCmc1EfqKDcZdR4xM9sSywuCUWg0MFN+j8?=
 =?us-ascii?Q?+IQ5xRIY12zjOWtQd6GDjCNxjA+9EXiIVd+Xyk+GAQlWE8jDyg8SxuhvMPu7?=
 =?us-ascii?Q?K2meayMc+MfN9bZukbgS10QihZow0OGMY/mWFpwwM15RTD4bLg8gzPsYS8ZY?=
 =?us-ascii?Q?SBnWKja2r8WlcXBoxR7EXo5/2UJdwFoNUClVhhY5L6tfRi3mjJSBXxU/fI2B?=
 =?us-ascii?Q?70JUk/eKCFeT89BGrPD3V/st8y0MjDNfPo2AqXXfE9PImogaGpejViNKgFG5?=
 =?us-ascii?Q?qKx2jtNCpq/aG5uEc++WIIB0lmZplmLtBsUdt08p/IsJbktTeSW99Ofm/V+z?=
 =?us-ascii?Q?cF3y11dzBQ1Ww+Dgiu9DcnDJGkKrrLTqSoFoVfnalv4MYSMYnCKax30x78P6?=
 =?us-ascii?Q?1/fSXOsva7YcFcIRR2txrVe7ZoJJYHrjvIkY+muWfFZE9d58YrVmAWaFFJZF?=
 =?us-ascii?Q?SQSp2+pLPlWjEtssqqTHLWU/6EDIbynKUZS80KlJgo8=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 850cc018-9e31-4564-d31e-08d89a430c14
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2020 00:00:03.0871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pyp7Hbeb9+x3syaL/B9nzlut2X9EbZ0V8+MxDakH0RNTQyDZb78/WjYbi1sYTiI9+JJPmCrJJoIL1KNvkcQPXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6637
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the effort of making .ndo_get_stats64 be able to sleep, we need to
ensure the callers of dev_get_stats do not use atomic context.

The bonding driver uses an RCU read-side critical section to ensure the
integrity of the list of network interfaces, because the driver iterates
through all net devices in the netns to find the ones which are its
configured slaves. We still need some protection against an interface
registering or deregistering, and the writer-side lock, the netns mutex,
is fine for that, because it offers sleepable context.

This mutex now serves double duty. It offers code serialization,
something which the stats_lock already did. So now that serves no
purpose, let's remove it.

Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/bonding/bond_main.c | 16 +++++-----------
 include/net/bonding.h           |  1 -
 2 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index e0880a3840d7..f788f9fa1858 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3738,21 +3738,16 @@ static void bond_get_stats(struct net_device *bond_dev,
 			   struct rtnl_link_stats64 *stats)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
+	struct net *net = dev_net(bond_dev);
 	struct rtnl_link_stats64 temp;
 	struct list_head *iter;
 	struct slave *slave;
-	int nest_level = 0;
 
+	mutex_lock(&net->netdev_lists_lock);
 
-	rcu_read_lock();
-#ifdef CONFIG_LOCKDEP
-	nest_level = bond_get_lowest_level_rcu(bond_dev);
-#endif
-
-	spin_lock_nested(&bond->stats_lock, nest_level);
 	memcpy(stats, &bond->bond_stats, sizeof(*stats));
 
-	bond_for_each_slave_rcu(bond, slave, iter) {
+	bond_for_each_slave(bond, slave, iter) {
 		const struct rtnl_link_stats64 *new =
 			dev_get_stats(slave->dev, &temp);
 
@@ -3763,8 +3758,8 @@ static void bond_get_stats(struct net_device *bond_dev,
 	}
 
 	memcpy(&bond->bond_stats, stats, sizeof(*stats));
-	spin_unlock(&bond->stats_lock);
-	rcu_read_unlock();
+
+	mutex_unlock(&net->netdev_lists_lock);
 }
 
 static int bond_do_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cmd)
@@ -5192,7 +5187,6 @@ static int bond_init(struct net_device *bond_dev)
 	if (!bond->wq)
 		return -ENOMEM;
 
-	spin_lock_init(&bond->stats_lock);
 	netdev_lockdep_set_classes(bond_dev);
 
 	list_add_tail(&bond->bond_list, &bn->dev_list);
diff --git a/include/net/bonding.h b/include/net/bonding.h
index d9d0ff3b0ad3..6fbde9713424 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -224,7 +224,6 @@ struct bonding {
 	 * ALB mode (6) - to sync the use and modifications of its hash table
 	 */
 	spinlock_t mode_lock;
-	spinlock_t stats_lock;
 	u8	 send_peer_notif;
 	u8       igmp_retrans;
 #ifdef CONFIG_PROC_FS
-- 
2.25.1

