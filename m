Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAE44BEA2A
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiBUSFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 13:05:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbiBUSDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 13:03:09 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140047.outbound.protection.outlook.com [40.107.14.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573F265B4
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 09:54:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SL4u2+YeIYwzOW5s2//1Cq6M5ft7TO5N1aYPRZzchRcPryEekLbzAWkNcf4VvpivYmCBZtjQZO0DNtCh2Cgr+HWygwJJ621UW+hKxfcvRkvOOg+i5QbBTGKBSVJ4DkFkR0wlejRFKn7IziXuAU09aZjGHNQ/aKtXf6MPMQ2mtqRHUcJ+j5UoRqqDTksNJ9tCavQ6oZMypw2wJe4IdWR2hxlVTCgBcCriY48sbCcmBoI2Ak+Rp/tAMbDbzbQq7mXy2eJIbRvC6R13iAx7xRV/ZHxCOZSOu3CmHWPEwrK5H7xokfqR2VE4103XKswL5GQ5U5ODqUEAPfiTMSIiwFYChQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gKkd5Tx9eoZfzd2mAEia8gb1l6aDHif9uVdYZDk0j3M=;
 b=Br4QxGfueQuWgs+/3Uco0BqKmSBXkpFIpVl+Yztrq5Z7+yZednT135gtSIbyDhq4yOIX3/GjL4t5bu47J6CLA3Q3mYIaJt/lhZn60Tjxe0bzpVSf2tNj2ha/I3dZgtc0ipoTHakRx4VDppDD11uSlmP2SmAqow3QGkd4OS1cVBbq4KjPUjefW+tCqtN2zjzbmG2Wxh/fv6qMKjlYPBCXK826RtndJIdNImbq78Rty5hLl34VGK/bM3U+MJkEMQ39FsBbEOr71x1oeLQhvi+VVZBZeZle4YXq3SipjzvlNSDzGT6ktFgaZGGaYJugRvl8Z41LSPlotrFWCzSadOLgjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gKkd5Tx9eoZfzd2mAEia8gb1l6aDHif9uVdYZDk0j3M=;
 b=P+NxIs3V9j+jpmk7eeWxTnh4js/n3UflRSnwftcJJhROIB/KM2kiZHE3VlAGkda0UB/iJPNmvENFV4X3U/PDcRCja/HFok7OBWa/SAb/Dd74HmbjDDw5iV+Jcnrr8c0FXpvm/daBcMofMLuRWkbq7XyTPQ93XRX5w7aRu6fOSfo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3693.eurprd04.prod.outlook.com (2603:10a6:803:18::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.27; Mon, 21 Feb
 2022 17:54:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 21 Feb 2022
 17:54:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v3 net-next 10/11] net: dsa: support FDB events on offloaded LAG interfaces
Date:   Mon, 21 Feb 2022 19:53:55 +0200
Message-Id: <20220221175356.1688982-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220221175356.1688982-1-vladimir.oltean@nxp.com>
References: <20220221175356.1688982-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR10CA0097.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 940438fd-b293-4407-cfb0-08d9f5632cc5
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3693:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3693C5815D6CCAE79E5D8F91E03A9@VI1PR0402MB3693.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s1/dHQLYaWT7O8VkKLw3qLDwH0Nn40pU/fIe3Be18qsfnyk4yMHr0KtSFnZaehttEZQGuwb9DpZAg9ERpVl5yiYkYB1PyalbE9U7dGUbyEKJbkZg8gAItsVLwZmTvcVPNbVdF959HDHtFow6BbOE5g0IxWuqpp8cNjLMCB7hmpJWP5iBm9lkfgJTJF7TqQsDe75UTk8Wa0pGUcW1UjKKh77eON7yz6YhsIcFY2eX5zQcIzKuSEmmPf9+0zmm927QyGy6NYTYFqZagja7vtbFRUb9rafy3FaK9Ekegh4q2ravmAGraJdU4qwgmj6ZZS3Neq+jrPQtSViF+8YlB2IyTU3ZuS5F3AJd9D6Oyh7UwJI1jynK5TqARThW55rYdNNpDaa/ehQ4OqIzjtTbWTwKjYmqOLOFQGPBQ8zy2KxejkbKU0mEteZPB5GiUEiU+IOUMk5E9bB8yrhyCJ9bItRj5yQ1gyQHJ5SX9OScjba+6QHiJ9lGe/cJ+hggZ0+w0Tol4PJIQJraycxxwPWyhM7eCCIe0GSCexQ/Yv1J15y/EJrGwRAlzoZxmOeNfJJ4+hT8MW1+8W1dqXrR7NP6q6DVwfAJpvMDfI6UgjolIQFCIgLzNqDmD0vpRMKu+InlCGe6xMpQbvQYf+koXcu9dmA/Fb5rFGR5mc2FLS1wxFlGh7ar1tpGXwATpbWrtJ2GQ/3qXkU7piPUObAoCfHIfLq9ig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(6916009)(66556008)(4326008)(8676002)(66476007)(8936002)(26005)(7416002)(54906003)(5660300002)(30864003)(83380400001)(66946007)(186003)(316002)(44832011)(86362001)(52116002)(6486002)(6506007)(6666004)(36756003)(2616005)(2906002)(38350700002)(38100700002)(508600001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y4ED2Vlj07OVp43lZo5y7zl3XtlFpjh7HM+eIQJwsWg4eQoMmctT+2WbCksE?=
 =?us-ascii?Q?OmqUO0JGDXRMFM7qbVvFwLbuNKJOJvpSzlUb64QH/9GX2ExpmNuWUUNotkeS?=
 =?us-ascii?Q?A6I5allbpOQX9cWLeDRwNkW7uWDOPOkeIU+T9L+9U4/oXxNmGZu3VFHmfl5z?=
 =?us-ascii?Q?n18gfVxy7hxwuiBfvsJd5VQ/b+m73aC0vtS5BK63dap3x3eJMaMUUH2UK4r1?=
 =?us-ascii?Q?BAkfCPUhMTeh48cclza+obfyXG5eixRAgr0p7c/m0defbFe4bg1BM1UHXyOk?=
 =?us-ascii?Q?hYnyClgjHQMWGw+UHx5QdjVkESlVoFwPOyzuWjtfZvKf8isxUjTVtfYP1ktw?=
 =?us-ascii?Q?XezdI2du+SCNAB3QTj5OkR8csqD2Wrc8/aBxW4xXiKMdp4Bglq+Jd++p7l1B?=
 =?us-ascii?Q?1Wlkw4MUx2LLO32zaKUlAgby91gRmG/lVxtoOv/VTOenppILMmRHtpqf2wEF?=
 =?us-ascii?Q?UlbIR6FRlEyfCTZ4zgdiEvpD9DCiIThFVMOf/g7/gFHAmDyqTO8jDeju5R+r?=
 =?us-ascii?Q?1Hwh57SXkyZ/q05glENBYNzBd1kKGgmMmoEqg1T0DVQ1b8TLniHahOnZx54c?=
 =?us-ascii?Q?+8XnPL7/ZAV+RZrsWCm2WAgkFoBhDzXv5fq0yRIOab/iy2wGbJUPaziGuTHe?=
 =?us-ascii?Q?qnuQyOtBLRfZpiltqGSL7NlR8X0ZkLs8/nu+csg/SB1l/el6z0JbJFtFPldA?=
 =?us-ascii?Q?paLlHkdm75yyfAMmPvxOn0O8SaF0PohDeq+SnvEHvSvrUGiC/tIsI902353u?=
 =?us-ascii?Q?odO68aNb8+yJcs9vKDw4rRaCHvW1x+BG9ruHQU4p08eA1W1yl94g9R1qANZI?=
 =?us-ascii?Q?QMLtF8nIgxXV3+aZPHB0DL38RXlXRmS3xkQqtx7mQDyZLpiQPQq6lgxWQtn/?=
 =?us-ascii?Q?WASJU1PUg7UVSM/3XPL9nKwVOZsJIuHFIRyft3M9ddR4cT6jbHcs9Q1XHI3s?=
 =?us-ascii?Q?L8N/QExKt/jRt479wF+a5ICvWq0JG/ODvl3BoHBb8d4BOFm5QUinC73L9oNk?=
 =?us-ascii?Q?Gp+fdZ1B32EOImb0TJAwggDFQ4q/2nKJknf6Sfcl+Jm9AnqoeFfuDgTka9/y?=
 =?us-ascii?Q?0DO27GGTOtO06lc8gJ4zaWK4LJyDvMwoxQmb9CG8BgHSoFFaaR10XZ/llx3Z?=
 =?us-ascii?Q?F4hFN2sOnJKWPOjEG4ORxJ9yvmzV4pLky9Gi7RdzOGAvoXRe8gpPV1KFjTIF?=
 =?us-ascii?Q?vp4GGcfLP6xscxwKLRKxg7OLMteYbrhqv5nTTEa2awWDE5pz5DJmmc4YrNUt?=
 =?us-ascii?Q?qGX7uiBAhEH8ARR5U2A3gmD7XOlURHRwEDHJn9AvwQfLnmVwY8zHjTjhsJJD?=
 =?us-ascii?Q?1VYamlDeAmqTCQ1N/HjvtFOIjhDC8FFuEClKpkbj7JRjXXPDOz+r8Bbz0wNL?=
 =?us-ascii?Q?EJx6RGKNZbgfCPAOULucvlKC+PqXlbXwVF7DB2+ObHex4qeA3bqpT+Ymkxk2?=
 =?us-ascii?Q?yJxs70GTY8Pd40Cte/8YR46DDhl9KMfUowMmg2WunFDGzAAG7/97Hxxl6udZ?=
 =?us-ascii?Q?R2U0OHGJtVFYSNAFtisPV4qpIui+WCUNVaO9Xj9yhQ96z/jXEN8Tkl+qJ7ZT?=
 =?us-ascii?Q?86G6RxFIfKFqmZ98RMknDHd4qtreXqcvH7a2UbLhrPWIY7Lkop4wWKA3Pjlm?=
 =?us-ascii?Q?YUV2WS/Ae2jIfH8jQA0kjMA=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 940438fd-b293-4407-cfb0-08d9f5632cc5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 17:54:15.3083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s9+jFwUWMKb8entbv0QthswIYcOHkfFUIr6baB9vBCzk8qPHOqF3PGahVZQNAbFA/YvtDwa2Sgz0M4zAy56bsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3693
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change introduces support for installing static FDB entries towards
a bridge port that is a LAG of multiple DSA switch ports, as well as
support for filtering towards the CPU local FDB entries emitted for LAG
interfaces that are bridge ports.

Conceptually, host addresses on LAG ports are identical to what we do
for plain bridge ports. Whereas FDB entries _towards_ a LAG can't simply
be replicated towards all member ports like we do for multicast, or VLAN.
Instead we need new driver API. Hardware usually considers a LAG to be a
"logical port", and sets the entire LAG as the forwarding destination.
The physical egress port selection within the LAG is made by hashing
policy, as usual.

To represent the logical port corresponding to the LAG, we pass by value
a copy of the dsa_lag structure to all switches in the tree that have at
least one port in that LAG.

To illustrate why a refcounted list of FDB entries is needed in struct
dsa_lag, it is enough to say that:
- a LAG may be a bridge port and may therefore receive FDB events even
  while it isn't yet offloaded by any DSA interface
- DSA interfaces may be removed from a LAG while that is a bridge port;
  we don't want FDB entries lingering around, but we don't want to
  remove entries that are still in use, either

For all the cases below to work, the idea is to always keep an FDB entry
on a LAG with a reference count equal to the DSA member ports. So:
- if a port joins a LAG, it requests the bridge to replay the FDB, and
  the FDB entries get created, or their refcount gets bumped by one
- if a port leaves a LAG, the FDB replay deletes or decrements refcount
  by one
- if an FDB is installed towards a LAG with ports already present, that
  entry is created (if it doesn't exist) and its refcount is bumped by
  the amount of ports already present in the LAG

echo "Adding FDB entry to bond with existing ports"
ip link del bond0
ip link add bond0 type bond mode 802.3ad
ip link set swp1 down && ip link set swp1 master bond0 && ip link set swp1 up
ip link set swp2 down && ip link set swp2 master bond0 && ip link set swp2 up
ip link del br0
ip link add br0 type bridge
ip link set bond0 master br0
bridge fdb add dev bond0 00:01:02:03:04:05 master static

ip link del br0
ip link del bond0

echo "Adding FDB entry to empty bond"
ip link del bond0
ip link add bond0 type bond mode 802.3ad
ip link del br0
ip link add br0 type bridge
ip link set bond0 master br0
bridge fdb add dev bond0 00:01:02:03:04:05 master static
ip link set swp1 down && ip link set swp1 master bond0 && ip link set swp1 up
ip link set swp2 down && ip link set swp2 master bond0 && ip link set swp2 up

ip link del br0
ip link del bond0

echo "Adding FDB entry to empty bond, then removing ports one by one"
ip link del bond0
ip link add bond0 type bond mode 802.3ad
ip link del br0
ip link add br0 type bridge
ip link set bond0 master br0
bridge fdb add dev bond0 00:01:02:03:04:05 master static
ip link set swp1 down && ip link set swp1 master bond0 && ip link set swp1 up
ip link set swp2 down && ip link set swp2 master bond0 && ip link set swp2 up

ip link set swp1 nomaster
ip link set swp2 nomaster
ip link del br0
ip link del bond0

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3:
- leave iteration among DSA slave interfaces that are members of
  the LAG bridge port to switchdev_handle_fdb_event_to_device()
- reorder some checks that previously resulted in the access of an
  uninitialized "ds" pointer

 include/net/dsa.h  |   6 +++
 net/dsa/dsa_priv.h |  14 ++++++
 net/dsa/port.c     |  27 +++++++++++
 net/dsa/slave.c    |  43 +++++++++++-------
 net/dsa/switch.c   | 109 +++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 184 insertions(+), 15 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 30ef064080b1..5c2890fa66db 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -119,6 +119,8 @@ struct dsa_netdevice_ops {
 struct dsa_lag {
 	struct net_device *dev;
 	unsigned int id;
+	struct mutex fdb_lock;
+	struct list_head fdbs;
 	refcount_t refcount;
 };
 
@@ -946,6 +948,10 @@ struct dsa_switch_ops {
 				const unsigned char *addr, u16 vid);
 	int	(*port_fdb_dump)(struct dsa_switch *ds, int port,
 				 dsa_fdb_dump_cb_t *cb, void *data);
+	int	(*lag_fdb_add)(struct dsa_switch *ds, struct dsa_lag lag,
+			       const unsigned char *addr, u16 vid);
+	int	(*lag_fdb_del)(struct dsa_switch *ds, struct dsa_lag lag,
+			       const unsigned char *addr, u16 vid);
 
 	/*
 	 * Multicast database
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index f2364c5adc04..322f816824b7 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -25,6 +25,8 @@ enum {
 	DSA_NOTIFIER_FDB_DEL,
 	DSA_NOTIFIER_HOST_FDB_ADD,
 	DSA_NOTIFIER_HOST_FDB_DEL,
+	DSA_NOTIFIER_LAG_FDB_ADD,
+	DSA_NOTIFIER_LAG_FDB_DEL,
 	DSA_NOTIFIER_LAG_CHANGE,
 	DSA_NOTIFIER_LAG_JOIN,
 	DSA_NOTIFIER_LAG_LEAVE,
@@ -67,6 +69,13 @@ struct dsa_notifier_fdb_info {
 	u16 vid;
 };
 
+/* DSA_NOTIFIER_LAG_FDB_* */
+struct dsa_notifier_lag_fdb_info {
+	struct dsa_lag *lag;
+	const unsigned char *addr;
+	u16 vid;
+};
+
 /* DSA_NOTIFIER_MDB_* */
 struct dsa_notifier_mdb_info {
 	const struct switchdev_obj_port_mdb *mdb;
@@ -129,6 +138,7 @@ struct dsa_switchdev_event_work {
 	unsigned char addr[ETH_ALEN];
 	u16 vid;
 	bool host_addr;
+	const void *ctx;
 };
 
 struct dsa_slave_priv {
@@ -214,6 +224,10 @@ int dsa_port_host_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 			  u16 vid);
 int dsa_port_host_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 			  u16 vid);
+int dsa_port_lag_fdb_add(struct dsa_port *dp, const unsigned char *addr,
+			 u16 vid);
+int dsa_port_lag_fdb_del(struct dsa_port *dp, const unsigned char *addr,
+			 u16 vid);
 int dsa_port_fdb_dump(struct dsa_port *dp, dsa_fdb_dump_cb_t *cb, void *data);
 int dsa_port_mdb_add(const struct dsa_port *dp,
 		     const struct switchdev_obj_port_mdb *mdb);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 2d174a1a0ac6..a99a61caf2c5 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -461,6 +461,8 @@ static int dsa_port_lag_create(struct dsa_port *dp,
 	lag->dev = lag_dev;
 	dsa_lag_map(ds->dst, lag);
 	dp->lag = lag;
+	mutex_init(&lag->fdb_lock);
+	INIT_LIST_HEAD(&lag->fdbs);
 
 	return 0;
 }
@@ -475,6 +477,7 @@ static void dsa_port_lag_destroy(struct dsa_port *dp)
 	if (!refcount_dec_and_test(&lag->refcount))
 		return;
 
+	WARN_ON(!list_empty(&lag->fdbs));
 	dsa_lag_unmap(dp->ds->dst, lag);
 	kfree(lag);
 }
@@ -852,6 +855,30 @@ int dsa_port_host_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_FDB_DEL, &info);
 }
 
+int dsa_port_lag_fdb_add(struct dsa_port *dp, const unsigned char *addr,
+			 u16 vid)
+{
+	struct dsa_notifier_lag_fdb_info info = {
+		.lag = dp->lag,
+		.addr = addr,
+		.vid = vid,
+	};
+
+	return dsa_port_notify(dp, DSA_NOTIFIER_LAG_FDB_ADD, &info);
+}
+
+int dsa_port_lag_fdb_del(struct dsa_port *dp, const unsigned char *addr,
+			 u16 vid)
+{
+	struct dsa_notifier_lag_fdb_info info = {
+		.lag = dp->lag,
+		.addr = addr,
+		.vid = vid,
+	};
+
+	return dsa_port_notify(dp, DSA_NOTIFIER_LAG_FDB_DEL, &info);
+}
+
 int dsa_port_fdb_dump(struct dsa_port *dp, dsa_fdb_dump_cb_t *cb, void *data)
 {
 	struct dsa_switch *ds = dp->ds;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 4aeb3e092dd6..089616206b11 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2398,6 +2398,9 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 		if (switchdev_work->host_addr)
 			err = dsa_port_host_fdb_add(dp, switchdev_work->addr,
 						    switchdev_work->vid);
+		else if (dp->lag)
+			err = dsa_port_lag_fdb_add(dp, switchdev_work->addr,
+						   switchdev_work->vid);
 		else
 			err = dsa_port_fdb_add(dp, switchdev_work->addr,
 					       switchdev_work->vid);
@@ -2415,6 +2418,9 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 		if (switchdev_work->host_addr)
 			err = dsa_port_host_fdb_del(dp, switchdev_work->addr,
 						    switchdev_work->vid);
+		else if (dp->lag)
+			err = dsa_port_lag_fdb_del(dp, switchdev_work->addr,
+						   switchdev_work->vid);
 		else
 			err = dsa_port_fdb_del(dp, switchdev_work->addr,
 					       switchdev_work->vid);
@@ -2457,25 +2463,20 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 	bool host_addr = fdb_info->is_local;
 	struct dsa_switch *ds = dp->ds;
 
-	if (dp->lag)
-		return -EOPNOTSUPP;
-
 	if (ctx && ctx != dp)
 		return 0;
 
-	if (!ds->ops->port_fdb_add || !ds->ops->port_fdb_del)
-		return -EOPNOTSUPP;
-
-	if (dsa_slave_dev_check(orig_dev) &&
-	    switchdev_fdb_is_dynamically_learned(fdb_info))
-		return 0;
+	if (switchdev_fdb_is_dynamically_learned(fdb_info)) {
+		if (dsa_port_offloads_bridge_port(dp, orig_dev))
+			return 0;
 
-	/* FDB entries learned by the software bridge should be installed as
-	 * host addresses only if the driver requests assisted learning.
-	 */
-	if (switchdev_fdb_is_dynamically_learned(fdb_info) &&
-	    !ds->assisted_learning_on_cpu_port)
-		return 0;
+		/* FDB entries learned by the software bridge or by foreign
+		 * bridge ports should be installed as host addresses only if
+		 * the driver requests assisted learning.
+		 */
+		if (!ds->assisted_learning_on_cpu_port)
+			return 0;
+	}
 
 	/* Also treat FDB entries on foreign interfaces bridged with us as host
 	 * addresses.
@@ -2483,6 +2484,18 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 	if (dsa_foreign_dev_check(dev, orig_dev))
 		host_addr = true;
 
+	/* Check early that we're not doing work in vain.
+	 * Host addresses on LAG ports still require regular FDB ops,
+	 * since the CPU port isn't in a LAG.
+	 */
+	if (dp->lag && !host_addr) {
+		if (!ds->ops->lag_fdb_add || !ds->ops->lag_fdb_del)
+			return -EOPNOTSUPP;
+	} else {
+		if (!ds->ops->port_fdb_add || !ds->ops->port_fdb_del)
+			return -EOPNOTSUPP;
+	}
+
 	switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
 	if (!switchdev_work)
 		return -ENOMEM;
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 0bb3987bd4e6..0c2961cbc105 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -385,6 +385,75 @@ static int dsa_port_do_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 	return err;
 }
 
+static int dsa_switch_do_lag_fdb_add(struct dsa_switch *ds, struct dsa_lag *lag,
+				     const unsigned char *addr, u16 vid)
+{
+	struct dsa_mac_addr *a;
+	int err = 0;
+
+	mutex_lock(&lag->fdb_lock);
+
+	a = dsa_mac_addr_find(&lag->fdbs, addr, vid);
+	if (a) {
+		refcount_inc(&a->refcount);
+		goto out;
+	}
+
+	a = kzalloc(sizeof(*a), GFP_KERNEL);
+	if (!a) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	err = ds->ops->lag_fdb_add(ds, *lag, addr, vid);
+	if (err) {
+		kfree(a);
+		goto out;
+	}
+
+	ether_addr_copy(a->addr, addr);
+	a->vid = vid;
+	refcount_set(&a->refcount, 1);
+	list_add_tail(&a->list, &lag->fdbs);
+
+out:
+	mutex_unlock(&lag->fdb_lock);
+
+	return err;
+}
+
+static int dsa_switch_do_lag_fdb_del(struct dsa_switch *ds, struct dsa_lag *lag,
+				     const unsigned char *addr, u16 vid)
+{
+	struct dsa_mac_addr *a;
+	int err = 0;
+
+	mutex_lock(&lag->fdb_lock);
+
+	a = dsa_mac_addr_find(&lag->fdbs, addr, vid);
+	if (!a) {
+		err = -ENOENT;
+		goto out;
+	}
+
+	if (!refcount_dec_and_test(&a->refcount))
+		goto out;
+
+	err = ds->ops->lag_fdb_del(ds, *lag, addr, vid);
+	if (err) {
+		refcount_set(&a->refcount, 1);
+		goto out;
+	}
+
+	list_del(&a->list);
+	kfree(a);
+
+out:
+	mutex_unlock(&lag->fdb_lock);
+
+	return err;
+}
+
 static int dsa_switch_host_fdb_add(struct dsa_switch *ds,
 				   struct dsa_notifier_fdb_info *info)
 {
@@ -451,6 +520,40 @@ static int dsa_switch_fdb_del(struct dsa_switch *ds,
 	return dsa_port_do_fdb_del(dp, info->addr, info->vid);
 }
 
+static int dsa_switch_lag_fdb_add(struct dsa_switch *ds,
+				  struct dsa_notifier_lag_fdb_info *info)
+{
+	struct dsa_port *dp;
+
+	if (!ds->ops->lag_fdb_add)
+		return -EOPNOTSUPP;
+
+	/* Notify switch only if it has a port in this LAG */
+	dsa_switch_for_each_port(dp, ds)
+		if (dsa_port_offloads_lag(dp, info->lag))
+			return dsa_switch_do_lag_fdb_add(ds, info->lag,
+							 info->addr, info->vid);
+
+	return 0;
+}
+
+static int dsa_switch_lag_fdb_del(struct dsa_switch *ds,
+				  struct dsa_notifier_lag_fdb_info *info)
+{
+	struct dsa_port *dp;
+
+	if (!ds->ops->lag_fdb_del)
+		return -EOPNOTSUPP;
+
+	/* Notify switch only if it has a port in this LAG */
+	dsa_switch_for_each_port(dp, ds)
+		if (dsa_port_offloads_lag(dp, info->lag))
+			return dsa_switch_do_lag_fdb_del(ds, info->lag,
+							 info->addr, info->vid);
+
+	return 0;
+}
+
 static int dsa_switch_lag_change(struct dsa_switch *ds,
 				 struct dsa_notifier_lag_info *info)
 {
@@ -904,6 +1007,12 @@ static int dsa_switch_event(struct notifier_block *nb,
 	case DSA_NOTIFIER_HOST_FDB_DEL:
 		err = dsa_switch_host_fdb_del(ds, info);
 		break;
+	case DSA_NOTIFIER_LAG_FDB_ADD:
+		err = dsa_switch_lag_fdb_add(ds, info);
+		break;
+	case DSA_NOTIFIER_LAG_FDB_DEL:
+		err = dsa_switch_lag_fdb_del(ds, info);
+		break;
 	case DSA_NOTIFIER_LAG_CHANGE:
 		err = dsa_switch_lag_change(ds, info);
 		break;
-- 
2.25.1

