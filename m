Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2713B3F032B
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 14:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235660AbhHRMD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 08:03:58 -0400
Received: from mail-vi1eur05on2074.outbound.protection.outlook.com ([40.107.21.74]:54881
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235729AbhHRMDl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 08:03:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b0twTGIlBtR0/uW8Ghzun00qGdeli17E7QVTXTXjGpZjqm0wF+QxdfCf69LTr1cwzInODLkfa94B0I7yhNS9Q9kRGg8Vd2G8t34OpReZepxdmi9DLL35W1Zdn+uJ4kuB8UGo9AjYpFhfsM1ZM4WKBwtEkIUcR8WutW3RJw0EKmixPF02Jz6V4b6VGDtad9uzwVzDRz4jAN5TkphBlS+/XEmGcb0sDFU86nvvFoQGZdv28l4ZhhoQpryZAD1xC8qfcMI3rRZSr7eFMayK2yboIjZYzdDtYh7Wxc4+Q3t+Fjfp9UJPp6tXyH4qI0sh2XGbJDlvPjezle2x918gwuwscg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dVQpy1oOJ+mMQy9S87HfuBemalvNB9Cw/G5QXKhHIFo=;
 b=IdMr/smtwuVuEXi460ITn08/pbyApzV2lwY6oLscvvz7Dl+r6IqJwrnDMUZrAjA2tLyDxnmL8swPZVAu+qqs9hvmxbJQxM6dMVZqKfMix9fgsGQGovvCAmuITPuKmCjHQfVTHCAXzsY+FPhnIh5teuzdF8VQdLWzqFBQAv0N3Vtmua4NRG3gL8MJNbSZcR+4J9pAu74xRmcJUqwmDmOVQ1p18Ciplqj0nIGrWlX8IdLC1H0jMVo/raFDVQA9Vf8Viv7u8NW5JLCIGvEm03loSO36oapza2mafYrmTMtgqmXqHfYILD4605JepCDP0Zd8mcpHVHgCxDmDGP2ioOrLpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dVQpy1oOJ+mMQy9S87HfuBemalvNB9Cw/G5QXKhHIFo=;
 b=rcWd1wZYRuXvjsepwObm39kltDQcnnBFs2w+JZ29AhK1ztf9Mwt8W7Q0mNHtFD8Ts+e7Ox8qNEfBvrymZeUfvkCV70JXRilUAqcUldu7/D3XWBRH9MZGp8qqi9Lji+KHBtUO+FhDpsmy6OIw8FN06yrlClQab/xqfr724EOEkkc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4222.eurprd04.prod.outlook.com (2603:10a6:803:46::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.18; Wed, 18 Aug
 2021 12:03:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 12:03:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [RFC PATCH net-next 07/20] net: switchdev: don't assume RCU context in switchdev_handle_fdb_{add,del}_to_device
Date:   Wed, 18 Aug 2021 15:01:37 +0300
Message-Id: <20210818120150.892647-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210818120150.892647-1-vladimir.oltean@nxp.com>
References: <20210818120150.892647-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0134.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VI1PR08CA0134.eurprd08.prod.outlook.com (2603:10a6:800:d5::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 12:02:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2af72954-871d-4e7e-1fb3-08d962401fa3
X-MS-TrafficTypeDiagnostic: VI1PR04MB4222:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4222F32CB466F3513257549DE0FF9@VI1PR04MB4222.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tt9tsZTo4JmOdqDmw2GANy/YrnO47pz/SDTsFVNDU7RHPKJ7BIdATBdcvtqMU0fiqOQYzN83xmyaZmSulooGouaBq3yPbaRbbsLhVeMkz5/GzNbs7rjUy8uJ5PfrmszQ+q4dlqr9n9NfgJNyyVyV4lWXKQccFOzG+lx0IuPfnILb2Dye8cktvzwBUNGSUTMj3Il8a7FY34WvFCYbgYxIp4P9Pou3AY0cNmJlAXtwRtZmvaLjQwCpDhYzv9DbLuwp21uQqUXC0FthXO+gsASK4M2jINbUgS3mb0CQykWojy554vVPexK9e1wqCYOePhJjTZdcnRuxOv6mOaj1ccX660sRBba1zPdh939RreqQerMuhpyDrj/Gg9hxhd19bwEbWaJzNr1q7R8genk7ym5Z84FGxUo9GZ5DVhmt8V3204E4HiThhVh3cvBYOhciZAzGHwszXLxXsU73ntH2VCE0cvr77uc3yTaPMR73ATnHMfhnj2gqrLX8vYq7w924HcMzC+rFCPItSXWxGV5YFJ4NLDCgJ2olg693xTj8t/RT7+qhmIghV72v0MDDtuHOAKG3ObAfLHZI5oyBiin7a8pj+1NA9KKv5JrJA+8ssr4Z4I/byC/+dgqGh0tw/avPdA+O0i2FQeU34LXdu9AiDp6XAn+n/mDaH12B2w499wBJXEQS2SIWpRYUdVjB04MPRg8bTp8OaM3NyZXfz6pjQxnUnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(39860400002)(366004)(376002)(6486002)(52116002)(2616005)(44832011)(4326008)(5660300002)(26005)(1076003)(6666004)(54906003)(956004)(6512007)(6506007)(186003)(38350700002)(38100700002)(86362001)(36756003)(110136005)(316002)(83380400001)(8936002)(478600001)(8676002)(66476007)(7416002)(7406005)(66946007)(66556008)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0W10RtLgWjHYkzWxp/g+x/g0DoRC31MPvPDQ7AJFwPl591oLjJcm8aT8vp6F?=
 =?us-ascii?Q?8/4IRwMfYeCLRp0ccg2y7FBJltHG+6fHx7xUa5jO/SW80CYyvKw2BAmvF3u9?=
 =?us-ascii?Q?wPkUxVluosP1DU7mRAgCvILnJJvoPDR+n2RR6c7QxcqXeEV4y1Ik7O4qR9x6?=
 =?us-ascii?Q?KB8WlxAWWJ62NbWz4xQGhJfH+gzc3I9y7zyofCQ3/4jQqpV3jIVuj2S9m4OE?=
 =?us-ascii?Q?hu0RhHvm8FEZ0Lh02nDGaJeo3ulHepjYLwqn353cQgx5BfpVbj1MVgOoO1bw?=
 =?us-ascii?Q?dcfu5Jh3i9l/yzH/pcK4t9wEekzG6M0vrdmrREiv2q5fpkHf7sl2UKXXYKsD?=
 =?us-ascii?Q?ZQ+xHx33ralqkGBSiHOxAJ03rV7FKS15GpMp2vxJHflw2OrTEIfoP5A8pXkQ?=
 =?us-ascii?Q?T6x9KtV2iNAfKmCKJFxLdK8CGD8/DuIUPLu7iNusR8PrYLUkxaN08rSU6Q20?=
 =?us-ascii?Q?ZLLMkEeb+Id2iVQcZiV2biUyBRg94LVi2QcU+PSG+bvK3bhmcNa2pbF6Ou59?=
 =?us-ascii?Q?sLpLNDpBkzBILSzsyx44PpcR9jFvQ21Y3V3DcOywy3aOd9U5Y9205i5z+eSQ?=
 =?us-ascii?Q?xOLD7qIuuPriZrIlqL4m7oE6NsTqtLtNLywlDGrXHTDLVTP0ozB99YgccPnD?=
 =?us-ascii?Q?TZ5klE/uBkR5dax5snzsHIYVoNZEz6GWr5gk+V6c3G2XXTE7vfkfHVsKjOva?=
 =?us-ascii?Q?Btrr33XYOkmzHpnfjbrkeFT3brSNwvepS+bwuC8uTZH3gRgiAy3YZOzOtZbj?=
 =?us-ascii?Q?bBg+FqqnISLGC/uKBOxXiug3qBc1l1qHyd+ne2H0QbNDdMgmQSjMj0qdkrgj?=
 =?us-ascii?Q?Ux7G3KTrmMIeLOtIPJ2WhGfDtp03UE4JrefRYKalGk4PHrkH/DDB+B5+bJjN?=
 =?us-ascii?Q?cf8UhLLltwf4dUsjpc1J2CjrxZlFIIpCULYCz3ryLnnlyDFrv1ezmZzuAtB3?=
 =?us-ascii?Q?NlIaBvQ2RAYSPcpW4m+T5TJedykOKcyJZ+B+2X6Idjz93Ugz7JYYF1qN7bF3?=
 =?us-ascii?Q?mOo4r9g2aC5ZgKZPhDPIRWeyN/mxlHqk+1vm+piAb/bVkF8jICEs7Cp5cQp/?=
 =?us-ascii?Q?T8jCy/+h59R+LWxyiDfl4W274y+xqRNXm+aBvgfSy0QyTsejc1uND280Mbud?=
 =?us-ascii?Q?8MBI7lpVK9fguAhe9q04Q7IKzbfs1uH8YLLcXtrgz/f9oox9Ikn9b26m8/pP?=
 =?us-ascii?Q?ZFjaQh1lK1Z5I04l179nVIEh7kviBRJZpLURAKFs2JRwmYAt31fdNf6ZHH1M?=
 =?us-ascii?Q?NNX/saWqYN6SbydutbzllqE7gCD4TKcNimWOBS8QTmYw/WmtUT3FUmqydKFJ?=
 =?us-ascii?Q?B27RD/Fs3DFdl3/vSpPEfETP?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2af72954-871d-4e7e-1fb3-08d962401fa3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 12:02:59.9967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4XCRzuVjWe4/c9QzM9WX67vR05B660pa4IViehc1CbyaytjhDHsgBIfEIEoeqzw6I7+UwP6nc24Kt2CIKT9fyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4222
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE events are blocking, it
would be nice if callers of the fan-out helper functions (i.e. DSA)
could benefit from that blocking context.

But at the moment, switchdev_handle_fdb_{add,del}_to_device use some
netdev adjacency list checking functions that assume RCU protection.
Switch over to their rtnl_mutex equivalents, since we are also running
with that taken, and drop the surrounding rcu_read_lock from the callers.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c           |  4 ----
 net/switchdev/switchdev.c | 10 +++++++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 249303ac3c3c..b6a94861cddd 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2484,22 +2484,18 @@ static int dsa_slave_switchdev_blocking_event(struct notifier_block *unused,
 						     dsa_slave_port_attr_set);
 		return notifier_from_errno(err);
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
-		rcu_read_lock();
 		err = switchdev_handle_fdb_add_to_device(dev, ptr,
 							 dsa_slave_dev_check,
 							 dsa_foreign_dev_check,
 							 dsa_slave_fdb_add_to_device,
 							 NULL);
-		rcu_read_unlock();
 		return notifier_from_errno(err);
 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
-		rcu_read_lock();
 		err = switchdev_handle_fdb_del_to_device(dev, ptr,
 							 dsa_slave_dev_check,
 							 dsa_foreign_dev_check,
 							 dsa_slave_fdb_del_to_device,
 							 NULL);
-		rcu_read_unlock();
 		return notifier_from_errno(err);
 	}
 
diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index d09e8e9df5b6..fdbb73439f37 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -470,7 +470,7 @@ switchdev_lower_dev_find(struct net_device *dev,
 		.data = &switchdev_priv,
 	};
 
-	netdev_walk_all_lower_dev_rcu(dev, switchdev_lower_dev_walk, &priv);
+	netdev_walk_all_lower_dev(dev, switchdev_lower_dev_walk, &priv);
 
 	return switchdev_priv.lower_dev;
 }
@@ -543,7 +543,7 @@ static int __switchdev_handle_fdb_add_to_device(struct net_device *dev,
 	/* Event is neither on a bridge nor a LAG. Check whether it is on an
 	 * interface that is in a bridge with us.
 	 */
-	br = netdev_master_upper_dev_get_rcu(dev);
+	br = netdev_master_upper_dev_get(dev);
 	if (!br || !netif_is_bridge_master(br))
 		return 0;
 
@@ -569,6 +569,8 @@ int switchdev_handle_fdb_add_to_device(struct net_device *dev,
 {
 	int err;
 
+	ASSERT_RTNL();
+
 	err = __switchdev_handle_fdb_add_to_device(dev, dev, fdb_info,
 						   check_cb,
 						   foreign_dev_check_cb,
@@ -648,7 +650,7 @@ static int __switchdev_handle_fdb_del_to_device(struct net_device *dev,
 	/* Event is neither on a bridge nor a LAG. Check whether it is on an
 	 * interface that is in a bridge with us.
 	 */
-	br = netdev_master_upper_dev_get_rcu(dev);
+	br = netdev_master_upper_dev_get(dev);
 	if (!br || !netif_is_bridge_master(br))
 		return 0;
 
@@ -674,6 +676,8 @@ int switchdev_handle_fdb_del_to_device(struct net_device *dev,
 {
 	int err;
 
+	ASSERT_RTNL();
+
 	err = __switchdev_handle_fdb_del_to_device(dev, dev, fdb_info,
 						   check_cb,
 						   foreign_dev_check_cb,
-- 
2.25.1

