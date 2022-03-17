Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC1C4DD0E5
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 23:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiCQWwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 18:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbiCQWwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 18:52:10 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60054.outbound.protection.outlook.com [40.107.6.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 952791B2C49
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 15:50:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kcu/NaBe0/gIlQGuVuKvEIkZgxdUaIKwc0RNWQNsEX4JfzJM+Sg06hm8STZv2QiPIAf1cde9lL8caIvW+xLCF8L0UKmIhd9oD3/zH7EzdjNnqQmLAGVSijtfzelrNtMTJjbzkIsmeSn5p+Dhu8rY+77XyYC90epw7uKwS09HJ8kB22kxo6FvwDv1fVP3CHD7NtiY8Y/BegiThJjUcoHAiJv8BrzwGGIzRy8PXxI5FlJ/knntYAMqKbIC/jUHnrhP/1ObGPOaIXAdj5Kn48QG36lm4kpAajEi5ONPB6xeSl7YgQz+2BMEubFx3QZCs2qOJ57Tno/p7LZIeIJUZqSaQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X7Tx0InyNMzzLhWaGQQ53ktB+W4lTcPvTNLZ1ji3IKA=;
 b=WJ4SNJKxu5pzeJea4y3gwIUN7CMC0plCsmszD6LN2Iofez4dagUBenwylpimiBbjvZYwEcF/+/0wkPdMI1Tgf98OIt9+eTC85q2/aosnzdWzrE8bHk/HYQUMIaenIXL0IGc+mrys0qi7d6GeQ0DrXOxOds/5VmKWqnGzQHMc4AU6hS5jl9RGJSOa+KJC9KwPyNaTmCmVs2orxUVK3VfvYyzl27DKdGC0lvxIsm16xcpQJ/UMgJHY17clRdnA+7OfqD0q6Z0JhjCusdd02AhmcWR3F0whzjF4F/LLDP+NY3FQPQB313iWcy1TU4rxszGs7RuYbzWrmXt7krBsptqmvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X7Tx0InyNMzzLhWaGQQ53ktB+W4lTcPvTNLZ1ji3IKA=;
 b=Ds457BFCcEIvx6WT1pxKhOpngfl/1XYWenC32GTVjAlpb9M1H+9RinEbc6Nzf8/idW100jiFledwFZcmXRz1kkSDi6rTAfSb75779RTXb1WfPJPyjQ7oLicyTGNd5ma2JTO6m/gbJ1OPxUM5v/Z/MEFLsFCuyDFllNs418XvFQ0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB4777.eurprd04.prod.outlook.com (2603:10a6:10:15::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Thu, 17 Mar
 2022 22:50:49 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::de5:11ee:c7ea:1d37]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::de5:11ee:c7ea:1d37%7]) with mapi id 15.20.5081.017; Thu, 17 Mar 2022
 22:50:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [RFC PATCH net-next] net: create a NETDEV_ETH_IOCTL notifier for DSA to reject PTP on DSA master
Date:   Fri, 18 Mar 2022 00:50:35 +0200
Message-Id: <20220317225035.3475538-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR08CA0040.eurprd08.prod.outlook.com
 (2603:10a6:20b:c0::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b492fdf-8789-4a83-2659-08da086894a7
X-MS-TrafficTypeDiagnostic: DB7PR04MB4777:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB4777D9941DB70D9D34296FDCE0129@DB7PR04MB4777.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sLcV5aNkppQlXBuWBVpx4hIsa4JsPSxpm22aAe2/4QAXf6Dw+6HwN5SI7B+AdQJN090dAsaM7H4oS3lZNE2hd78FL3HDeu5nOxru8VQOiCP4JJ2qLm89G+tFgQX8S9Yw+wR9JIBKQGT4XQvv8Dl7jioCgoqkaPXNWHSuaTW3JHG+u1Ds2cgwGGbArxlfFQtXxyP/JMXU68XxII2mEDi56MFkkkHSHtbO0N3pkeHEFT1qpg1hAhvmijorVeutv7KtoIEkALCNnJ5DLiA8GsgOGnDgAXsH8/wAv43qchU9YbTdiJKN3BszQR1isph1t40VEm4anoLEbo2iPHJHyc7ovVDejhyP23JdCdTEZkIJicgz2HlNGyVY6xwNLJf6hPdsMRKzFgNc5hhNEn8pWDjk1zZ969fjbrsfNf6EpgO0KxPHK4MAv0QIHUvk9L5PB0CBhV1MSKycx3i2kHxY9JIFW5SlN9CPUT+uHAPJ58CiSwDovYinsZo281hh/3PKeu4Hi74vKAIXPVidl+5YHgDbnxZg72cv/hK1K644DQOjKPVb03XVa6ohva+78TSiI6beW6B4gASGihTX7zC/M5MmzoRwsv3hx6RHcOJZYrwYq5WBgkdZMBRMmyMfpOU3MoY0lCL5YPr9A+wL08+Qe/ZgPh/1uNgm7MxKVwn3qiSvHyjyr2ZOfluLxWE9932VflZ8LSKp71cCm6n/81OamuXy/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(186003)(1076003)(26005)(36756003)(6666004)(6506007)(6512007)(38350700002)(38100700002)(52116002)(83380400001)(2616005)(30864003)(66946007)(2906002)(44832011)(54906003)(8936002)(66476007)(508600001)(66556008)(86362001)(6486002)(8676002)(316002)(6916009)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ltJ3+p7nEp3oB8vo4Ezll9b7vF8OBEdUe9EGjeSG3aohq50hET864Spj0Xs0?=
 =?us-ascii?Q?DtMZGRSFUq7sOdP9HMSMKkrTaZLyW0Qho/OF1ABagO5NOIdAlrmySSSAn1IF?=
 =?us-ascii?Q?atSsRrDCt3W49kPZ/fBpCeTNN+ZPzBUHbQhfG9UENYnjMa03FXxo9m0MAh7l?=
 =?us-ascii?Q?1ShatBXwCuNUcXksHXzCYP52ZH5ZvzjQpXYHspSR8husyRpQbFobrnEgQiQH?=
 =?us-ascii?Q?+0IhXb/6cr+syrA8jMf4+Lc1QRmOR8sz8GZmX/nJZdFtLsJoyaVaqTa/aNYR?=
 =?us-ascii?Q?8uPlCI/F4LENKc2krcwpCYaM9k2BTCCHe2+Cs0q+oNQyu5gq9N7D5ToyI4yi?=
 =?us-ascii?Q?MiOyIAUdxqUmL8WqLu1lBg5PqxBJrx8sh9Y+CsKb4iAhzgDzH5iCH51uUApa?=
 =?us-ascii?Q?TDGKNsjUN+kLtPY3MSAaevEDey9M62/wno2eXveu0/IfqZ0FE8m8VZjXqpgS?=
 =?us-ascii?Q?CLuK2go+gos0H/dtV62MtAGl+toUtDjrkebR5e+zzIcN8qyeta3g6RgmDcF1?=
 =?us-ascii?Q?ZlkOWxeiFXVZ93T0utYGUKd1B4JTkI40SPeDbQ82DZdYDfqqSUyiUyzEjgWN?=
 =?us-ascii?Q?r/mZf2cMGuKLrpHYat8OUK5FgQIAL0qcg9b46q1wi9a7vAYSyAdf2Szsbu5e?=
 =?us-ascii?Q?Krj8Y2UONIkMSFfW2CdIYbGjzLvc9fXh7suecTCHVreP/qfz/OtDrDnpdZHc?=
 =?us-ascii?Q?zkkHjDmk9JjXj+ZSgR5tH9O+01e2WbNX1o0KnI1thB8/Fv0qfHUap7+sHnfa?=
 =?us-ascii?Q?ZQQJFgu7CNZsLL9ZHuawrrNziA9DHexipl2akf8DP6Y9356aEYgGTiiggIeO?=
 =?us-ascii?Q?ZP95SpsANYi5EIrlhw1FdBcHkiThKMAkkl/LdqNW96PQNgyJA6V8VTnxJOiO?=
 =?us-ascii?Q?heqr1MPmJ92t/PjftaDXxK6iBfgNLtAzzPf1QCgL6gHEbYFQaqM5YgUpJCRx?=
 =?us-ascii?Q?jJnyBg1ubJc9Oht/rF9i7nrnZKOu7HDR+clc72Jqd4DSZ8TuZEkW0Js9GTPf?=
 =?us-ascii?Q?+5ncFpyjY0PSQClFC97DOEQe/RzUkI7VPfz56OW+kWywd9+VblaYTUNaildu?=
 =?us-ascii?Q?1mNEY1TPXPzz2fdCzmlQuV8upUKApqJxNSqMTgOBLZGiIq5Q71GozsY0eS2t?=
 =?us-ascii?Q?LqeCmXMkKw+eSUl/ki2i3/D0eqdI4Rig4fnKkNsGgSjN9x9GuqWq1hUAz3w4?=
 =?us-ascii?Q?7jiCd6ECEachH7mG46ibrifeTJRyTp+IjrOCZdAAGPgip03O3YvxjB0BP6Fo?=
 =?us-ascii?Q?jzqpb8g6UnWCc4ZfAMtHT35gUgrJFOi+NKUGOXVzvwTl/scX/csr4OMJjTzb?=
 =?us-ascii?Q?1cgoQq6wgh5nb9WFhFLdEB2eHB7LkF4Ag+MZ0MSvEZHQMVcDnwvQaumYbfjQ?=
 =?us-ascii?Q?B6rWGQYWMrn6yFar3NVxNq/p77o3FoepVz8rEc6ZNkgkr4/nQjw1NHj4/X1f?=
 =?us-ascii?Q?KP5Z/1b5SSvbLFavlxrNEaWRFo1W0gCvC+WNf3espcVZvU0Z+CncZQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b492fdf-8789-4a83-2659-08da086894a7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2022 22:50:49.4793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3DGwgC9yQI+/+qOh++lGTXUP/9eic9eHmLA/ajg35GpTF2uyl0mx0ljdKgGHU8dDYNm1qzw3Tz+aF55ecx96Lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4777
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The fact that PTP 2-step TX timestamping is deeply broken on DSA
switches if the master also timestamps the same packets is well
documented by commit f685e609a301 ("net: dsa: Deny PTP on master if
switch supports it"). We attempt to help the users avoid shooting
themselves in the foot by making DSA reject the timestamping ioctls on
an interface that is a DSA master, and the switch tree beneath it
contains switches which are aware of PTP.

The only problem is that there isn't an established way of intercepting
ndo_eth_ioctl calls, so DSA creates avoidable burden upon the network
stack by creating a struct dsa_netdevice_ops with overlaid function
pointers that are manually checked from the relevant call sites. There
used to be 2 such dsa_netdevice_ops, but now, ndo_eth_ioctl is the only
one left.

In fact, the underlying reason which is prompting me to make this change
is that I'd like to hide as many DSA data structures from public API as
I can. But struct net_device :: dsa_ptr is a struct dsa_port (which is a
huge structure), and I'd like to create a smaller structure. I'd like
struct dsa_netdevice_ops to not be a part of this, so this is how the
need to delete it arose.

The established way for unrelated modules to react on a net device event
is via netdevice notifiers. These have the advantage of loose coupling,
i.e. they work even when DSA is built as module, without resorting to
static inline functions (which cannot offer the desired data structure
encapsulation).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
I'd mostly like to take this opportunity to raise a discussion about how
to handle this. It's clear that calling the notifier chain is less
efficient than having some dev->dsa_ptr checks, but I'm not sure if the
ndo_eth_ioctl can tolerate the extra performance hit at the expense of
some code cleanliness.

Of course, what would be great is if we didn't have the limitation to
begin with, but the effort to add UAPI for multiple TX timestamps per
packet isn't proportional to the stated goal here, which is to hide some
DSA data structures.

 include/linux/netdevice.h | 10 +++++++-
 include/net/dsa.h         | 51 ---------------------------------------
 net/core/dev.c            |  7 +++---
 net/core/dev_ioctl.c      | 10 ++++++--
 net/dsa/dsa_priv.h        |  1 +
 net/dsa/master.c          | 26 +++-----------------
 net/dsa/slave.c           | 10 ++++++++
 7 files changed, 35 insertions(+), 80 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 8cbe96ce0a2c..4b3f22b87193 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2736,6 +2736,7 @@ enum netdev_cmd {
 	NETDEV_OFFLOAD_XSTATS_DISABLE,
 	NETDEV_OFFLOAD_XSTATS_REPORT_USED,
 	NETDEV_OFFLOAD_XSTATS_REPORT_DELTA,
+	NETDEV_ETH_IOCTL,
 };
 const char *netdev_cmd_to_name(enum netdev_cmd cmd);
 
@@ -2786,6 +2787,12 @@ struct netdev_notifier_pre_changeaddr_info {
 	const unsigned char *dev_addr;
 };
 
+struct netdev_notifier_eth_ioctl_info {
+	struct netdev_notifier_info info; /* must be first */
+	struct ifreq *ifr;
+	unsigned int cmd;
+};
+
 enum netdev_offload_xstats_type {
 	NETDEV_OFFLOAD_XSTATS_TYPE_L3 = 1,
 };
@@ -2842,7 +2849,8 @@ netdev_notifier_info_to_extack(const struct netdev_notifier_info *info)
 }
 
 int call_netdevice_notifiers(unsigned long val, struct net_device *dev);
-
+int call_netdevice_notifiers_info(unsigned long val,
+				  struct netdev_notifier_info *info);
 
 extern rwlock_t				dev_base_lock;		/* Device list lock */
 
diff --git a/include/net/dsa.h b/include/net/dsa.h
index a2a68f532f59..d80dd68ae5d8 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -103,16 +103,6 @@ struct dsa_device_ops {
 	bool promisc_on_master;
 };
 
-/* This structure defines the control interfaces that are overlayed by the
- * DSA layer on top of the DSA CPU/management net_device instance. This is
- * used by the core net_device layer while calling various net_device_ops
- * function pointers.
- */
-struct dsa_netdevice_ops {
-	int (*ndo_eth_ioctl)(struct net_device *dev, struct ifreq *ifr,
-			     int cmd);
-};
-
 #define DSA_TAG_DRIVER_ALIAS "dsa_tag-"
 #define MODULE_ALIAS_DSA_TAG_DRIVER(__proto)				\
 	MODULE_ALIAS(DSA_TAG_DRIVER_ALIAS __stringify(__proto##_VALUE))
@@ -314,11 +304,6 @@ struct dsa_port {
 	 */
 	const struct ethtool_ops *orig_ethtool_ops;
 
-	/*
-	 * Original copy of the master netdev net_device_ops
-	 */
-	const struct dsa_netdevice_ops *netdev_ops;
-
 	/* List of MAC addresses that must be forwarded on this port.
 	 * These are only valid on CPU ports and DSA links.
 	 */
@@ -1278,42 +1263,6 @@ static inline void dsa_tag_generic_flow_dissect(const struct sk_buff *skb,
 #endif
 }
 
-#if IS_ENABLED(CONFIG_NET_DSA)
-static inline int __dsa_netdevice_ops_check(struct net_device *dev)
-{
-	int err = -EOPNOTSUPP;
-
-	if (!dev->dsa_ptr)
-		return err;
-
-	if (!dev->dsa_ptr->netdev_ops)
-		return err;
-
-	return 0;
-}
-
-static inline int dsa_ndo_eth_ioctl(struct net_device *dev, struct ifreq *ifr,
-				    int cmd)
-{
-	const struct dsa_netdevice_ops *ops;
-	int err;
-
-	err = __dsa_netdevice_ops_check(dev);
-	if (err)
-		return err;
-
-	ops = dev->dsa_ptr->netdev_ops;
-
-	return ops->ndo_eth_ioctl(dev, ifr, cmd);
-}
-#else
-static inline int dsa_ndo_eth_ioctl(struct net_device *dev, struct ifreq *ifr,
-				    int cmd)
-{
-	return -EOPNOTSUPP;
-}
-#endif
-
 void dsa_unregister_switch(struct dsa_switch *ds);
 int dsa_register_switch(struct dsa_switch *ds);
 void dsa_switch_shutdown(struct dsa_switch *ds);
diff --git a/net/core/dev.c b/net/core/dev.c
index 75bab5b0dbae..49ab1895a319 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -159,8 +159,6 @@ struct list_head ptype_base[PTYPE_HASH_SIZE] __read_mostly;
 struct list_head ptype_all __read_mostly;	/* Taps */
 
 static int netif_rx_internal(struct sk_buff *skb);
-static int call_netdevice_notifiers_info(unsigned long val,
-					 struct netdev_notifier_info *info);
 static int call_netdevice_notifiers_extack(unsigned long val,
 					   struct net_device *dev,
 					   struct netlink_ext_ack *extack);
@@ -1622,6 +1620,7 @@ const char *netdev_cmd_to_name(enum netdev_cmd cmd)
 	N(SVLAN_FILTER_PUSH_INFO) N(SVLAN_FILTER_DROP_INFO)
 	N(PRE_CHANGEADDR) N(OFFLOAD_XSTATS_ENABLE) N(OFFLOAD_XSTATS_DISABLE)
 	N(OFFLOAD_XSTATS_REPORT_USED) N(OFFLOAD_XSTATS_REPORT_DELTA)
+	N(ETH_IOCTL)
 	}
 #undef N
 	return "UNKNOWN_NETDEV_EVENT";
@@ -1920,8 +1919,8 @@ static void move_netdevice_notifiers_dev_net(struct net_device *dev,
  *	are as for raw_notifier_call_chain().
  */
 
-static int call_netdevice_notifiers_info(unsigned long val,
-					 struct netdev_notifier_info *info)
+int call_netdevice_notifiers_info(unsigned long val,
+				  struct netdev_notifier_info *info)
 {
 	struct net *net = dev_net(info->dev);
 	int ret;
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 1b807d119da5..c6f3d5e22ee4 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -244,10 +244,16 @@ static int dev_eth_ioctl(struct net_device *dev,
 			 struct ifreq *ifr, unsigned int cmd)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
+	struct netdev_notifier_eth_ioctl_info info = {
+		.info.dev = dev,
+		.ifr = ifr,
+		.cmd = cmd,
+	};
 	int err;
 
-	err = dsa_ndo_eth_ioctl(dev, ifr, cmd);
-	if (err == 0 || err != -EOPNOTSUPP)
+	err = call_netdevice_notifiers_info(NETDEV_ETH_IOCTL, &info.info);
+	err = notifier_to_errno(err);
+	if (err)
 		return err;
 
 	if (ops->ndo_eth_ioctl) {
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index f20bdd8ea0a8..04b8723c23bb 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -195,6 +195,7 @@ static inline int dsa_tag_protocol_overhead(const struct dsa_device_ops *ops)
 /* master.c */
 int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp);
 void dsa_master_teardown(struct net_device *dev);
+int dsa_master_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd);
 
 static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
 						       int device, int port)
diff --git a/net/dsa/master.c b/net/dsa/master.c
index 991c2930d631..e84d5d35bbd8 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -187,12 +187,11 @@ static void dsa_master_get_strings(struct net_device *dev, uint32_t stringset,
 	}
 }
 
-static int dsa_master_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+int dsa_master_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
 	struct dsa_port *cpu_dp = dev->dsa_ptr;
 	struct dsa_switch *ds = cpu_dp->ds;
 	struct dsa_switch_tree *dst;
-	int err = -EOPNOTSUPP;
 	struct dsa_port *dp;
 
 	dst = ds->dst;
@@ -210,16 +209,9 @@ static int dsa_master_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		break;
 	}
 
-	if (dev->netdev_ops->ndo_eth_ioctl)
-		err = dev->netdev_ops->ndo_eth_ioctl(dev, ifr, cmd);
-
-	return err;
+	return 0;
 }
 
-static const struct dsa_netdevice_ops dsa_netdev_ops = {
-	.ndo_eth_ioctl = dsa_master_ioctl,
-};
-
 static int dsa_master_ethtool_setup(struct net_device *dev)
 {
 	struct dsa_port *cpu_dp = dev->dsa_ptr;
@@ -254,12 +246,6 @@ static void dsa_master_ethtool_teardown(struct net_device *dev)
 	cpu_dp->orig_ethtool_ops = NULL;
 }
 
-static void dsa_netdev_ops_set(struct net_device *dev,
-			       const struct dsa_netdevice_ops *ops)
-{
-	dev->dsa_ptr->netdev_ops = ops;
-}
-
 /* Keep the master always promiscuous if the tagging protocol requires that
  * (garbles MAC DA) or if it doesn't support unicast filtering, case in which
  * it would revert to promiscuous mode as soon as we call dev_uc_add() on it
@@ -363,16 +349,13 @@ int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 	if (ret)
 		goto out_err_reset_promisc;
 
-	dsa_netdev_ops_set(dev, &dsa_netdev_ops);
-
 	ret = sysfs_create_group(&dev->dev.kobj, &dsa_group);
 	if (ret)
-		goto out_err_ndo_teardown;
+		goto out_err_ethtool_teardown;
 
 	return ret;
 
-out_err_ndo_teardown:
-	dsa_netdev_ops_set(dev, NULL);
+out_err_ethtool_teardown:
 	dsa_master_ethtool_teardown(dev);
 out_err_reset_promisc:
 	dsa_master_set_promiscuity(dev, -1);
@@ -382,7 +365,6 @@ int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 void dsa_master_teardown(struct net_device *dev)
 {
 	sysfs_remove_group(&dev->dev.kobj, &dsa_group);
-	dsa_netdev_ops_set(dev, NULL);
 	dsa_master_ethtool_teardown(dev);
 	dsa_master_set_promiscuity(dev, -1);
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index d24b6bf845c1..7e4186f523c8 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2749,6 +2749,16 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 
 		return NOTIFY_OK;
 	}
+	case NETDEV_ETH_IOCTL: {
+		struct netdev_notifier_eth_ioctl_info *info = ptr;
+		int err;
+
+		if (!netdev_uses_dsa(dev))
+			return NOTIFY_DONE;
+
+		err = dsa_master_ioctl(dev, info->ifr, info->cmd);
+		return notifier_from_errno(err);
+	}
 	default:
 		break;
 	}
-- 
2.25.1

