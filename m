Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB9C0310C12
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 14:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbhBENoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 08:44:05 -0500
Received: from mail-db8eur05on2061.outbound.protection.outlook.com ([40.107.20.61]:2785
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229892AbhBENkV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 08:40:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JY8nLsnh49aIo6q64yIc0WneuY3zKNYofm6phagyzW60sWcmsLEnse4yDVcKiBYHu0yxJYAi84zej0NH4YYSOr1MeL0lsreWCSD6I0OaTAGXQndBdK6sr8jdqHU0L1QW70PeVS7M9X1yZ0dAwXn7lW1f3P3U1jl+TkA8KEhNq7KYoDtLL1+i40wFdijeu6D2rpn4QAeDzOofqpRryAr3i1t/3zWu7VPFQenP8fbj8d3015K5Zqzt61H9NFkQjSesyjglD+QYwY8eelt2CeOVGJM+C0V5C6X9QgtOHR+7LaDdR0g4hI0+aAz3Zjx1h3Yb9QGUEQnQdJE+i+1VmcSFuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SlbQ4uKZpdFvDeLUhlMtEaRQlEWxgFQbLum/8JeYsZs=;
 b=fj1SO7ku0EKq4maOLouNase2DplEDNIrnIGG9i0w/2uyKLtpewfp4mpbNpMtQ//yJdD9qyT7cjIsJ2CW8GlkqT7KUI1gKYcVUXv8YN5ESLP7jxySbFkR3oXD6vZp5zqpmH/7IxGWBDCs2S6PLGO4vSBniixcuWB7iShbCeizFAtHZWcyevXeKqhSPAprHT3943icPOn15fHFXdYri3PP9PMh80yE3weVMKnkxaxn1bmR5HPnq4VqKw/IJG6gzfuJ19xH0waiQ086JAnCGp9OWvN2JVoEwCbQIH8yZnHGn08u4irL1veEBP7qYDMa10TrD5ijU36Oi8rj2YXpDKfUHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SlbQ4uKZpdFvDeLUhlMtEaRQlEWxgFQbLum/8JeYsZs=;
 b=TlNX7zvRKrUzzMQsvMBwXS/clmfNZjKuqvN2vdSD+IqV4GHrf02DeXoIw1w2zlj3HubgndASXN+zhPhtnDHY8/ac9rh0/GkXR09EHXLMD31qMhM1AdJD4M8En7ZytQwx8br7+WcEpMUyshBaYld6nBKNAXYpnTmY7B7o6/9EcPo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4910.eurprd04.prod.outlook.com (2603:10a6:803:5c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.24; Fri, 5 Feb
 2021 13:37:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%7]) with mapi id 15.20.3825.020; Fri, 5 Feb 2021
 13:37:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: [PATCH v3 net-next 4/4] Revert "net: ipv4: handle DSA enabled master network devices"
Date:   Fri,  5 Feb 2021 15:37:13 +0200
Message-Id: <20210205133713.4172846-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210205133713.4172846-1-vladimir.oltean@nxp.com>
References: <20210205133713.4172846-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.12.227.87]
X-ClientProxiedBy: VI1PR09CA0138.eurprd09.prod.outlook.com
 (2603:10a6:803:12c::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (5.12.227.87) by VI1PR09CA0138.eurprd09.prod.outlook.com (2603:10a6:803:12c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20 via Frontend Transport; Fri, 5 Feb 2021 13:37:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a343179e-bb31-4860-3e6e-08d8c9db2f07
X-MS-TrafficTypeDiagnostic: VI1PR04MB4910:
X-Microsoft-Antispam-PRVS: <VI1PR04MB4910346FADE5027888D88F6FE0B29@VI1PR04MB4910.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:65;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8pyBwsfwxACo80XccOCYiNeJpWIvqkQShbfY+/DdRsVbwBlxGjXSBMLH5HoSSHM2lwf8wqmwSxEH500IEspycM3stX4waiUUFT9HITSUCs7TRWqmDkrZL7h+vCOJpilquO2WbEETpnx2GJgXbAhWREEADQQYePACcSEJ311+OwHhQLO9ASNbJKvbhl4PMBPIoudOsKq4oPu/8DWsJJfyliUW9U9YQ8kIuK77ISiIk6kiJ2Tpa2bpo7t0YOwg6W8JKASWJ0HjYwenaUZ7FIYzy+O5lzcvrLN7+kse4RDiibx0jqQoKPGqFQXvfJvzJbs6XsqpECKNdLzdWfQ5feXrZaXekKHvB5PJYaL2L9UrjmIk6AP+janohdqfDRhfaUo/EMyUBsqhI8Xde8MFjq+7fxFELEK5sRp8j3U58FNgrfYze2QcvicLgMSEtrJBTCmjS2FcCVMsYyh+L7ZfnXW/jM2lP+EmjoTFPFwxdBlRF3HK2xMoKgMZpt5EfKMPNuBl8NmgMxWFuV/pS7Yv+o+3EfajbN4K6PoO//P5q7Psxzr9CDZqTyoM+GnutfbkOh5r/UMz1eHNzf/D4QsnYdht5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(346002)(136003)(366004)(2906002)(16526019)(5660300002)(186003)(8936002)(69590400011)(8676002)(2616005)(1076003)(956004)(44832011)(6486002)(478600001)(4326008)(54906003)(6506007)(66946007)(83380400001)(86362001)(66556008)(66476007)(26005)(316002)(110136005)(6512007)(52116002)(36756003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?gOjx008ZudSWsqHGKB7by4gcg+ZsYT4bmoBCTsQ5sZjea+EYjhNVV0D2AIn2?=
 =?us-ascii?Q?SxbYm4/DFuMu0QZd4CFwBQ4qlFVmjF7IB8y1H/t2fU62MXOoJG3Rdo24nxbX?=
 =?us-ascii?Q?NLtbZ/Lz1rrY8HRIkrCMu+8lGttxoe8ZGN6MKKNB1GNlw4V2yYfTmTZbiV3J?=
 =?us-ascii?Q?uS7Aakw6Eo0MuqDS2fh9jpHcX/C0RzMq2TSzCzCfUyuuMMmaiyazfJsfhlrc?=
 =?us-ascii?Q?YoFH7ksr9koDL6ED71kzosIfgJ0zOcLXUc37Ahz8pa9fHkVJppdGGBEI8CqP?=
 =?us-ascii?Q?IkOxADO3VdGsdmymnNM+XklMmJ3pcIimUCIxE7Uh6kDRO/WC4X6mR3wMIo/n?=
 =?us-ascii?Q?YVQ06FAQDofesY1tM7uqUP+Lr9z29B15x3SLIE0Qixff3flXz95IyX+6vudn?=
 =?us-ascii?Q?AonE6QVe6arw6VebNX5lbzKNkGqe0Aymm4eRaMLDOm9Yba9QLJ0nOwrEgfx6?=
 =?us-ascii?Q?AEtuRhmVR3+WGGa5+dDoIYO5iSDJD3OXAcswETjPKP9NLdJq2IXcE8NFqqPi?=
 =?us-ascii?Q?Gkxh8w8rAZ+8V6yydaiLHU4UZMBv4fnL+QfzgRs520kekET9Q6Wuk3W3DY2B?=
 =?us-ascii?Q?Pd1WcmRXA/h+oUyYzNVcx4aqcV7XLUJ/pli22vqmcEQpzhgzX0A6rbGqVj2C?=
 =?us-ascii?Q?QYAWhn5g7gt9afHZgkmJ/P244tGLOaFxtpcqXpuwcXvD6EBs4NmxxNtHJWb7?=
 =?us-ascii?Q?CLePZ6clc/E7BPRllh4QwAqb841ZG6lAd260cR5ehPOOO0gTCysuz9+Pvkx6?=
 =?us-ascii?Q?Nu4ZFJ9TjXWMfDmSD60Ww5Dq5HRnfn6cHD5NbyhWYS6biOY52QqTut7E/dKN?=
 =?us-ascii?Q?ZyNPqjnmp070berdEd8pgoY6+//p8zPwSCECKBZWjE422q6yvcVjfiHeH39D?=
 =?us-ascii?Q?EmdZ2lNTDEWZn/U+qDd1XnbAvSWuaWJv61CMNwVgzJFDyOBZpA3X5EjZH4g9?=
 =?us-ascii?Q?Utv6vx3wUJSIkkkysqDBOpZsewvHFBSs4MoejHz8yFotbCCzx2JGxC9YEYoL?=
 =?us-ascii?Q?G6thY94PHUrnm9YolVTGXhY6K3nxfqu2vrW+naXwgs++yyyrXEnLmB+fjeK3?=
 =?us-ascii?Q?QO+mcivO8iSxCC0UjpYU2Oq5VxZGKdouoFsnpeUpBfaKWaLf+ptGcOM7zahK?=
 =?us-ascii?Q?ASL+ehHcWxcrn+fL7dfH8m5cYSvBeJN3AtvCCzpAfZda3rHldzvybcrpKiax?=
 =?us-ascii?Q?u+m5n2aHGnaIHcrjADWL8QyLxvMak3j5h31aGS57eMJfZMNSUQ7eWArmLMJy?=
 =?us-ascii?Q?V1KON1gqXkwXgQVJ7u7xiwVteIwtvZVhA9CjHZFL4wTPujyYhR8NcDvuTJDe?=
 =?us-ascii?Q?GpZrAC+Yq0V4TI+k9nv6Siqc?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a343179e-bb31-4860-3e6e-08d8c9db2f07
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 13:37:30.1907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HV3gT5JDvIYD1sP9fqqiAymil6S8NLjzC5z9Zmuxd+xoT+ezc9n/axBrt4mBpA/ahlJ7kOYN2duJ2KCyQYc8HQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4910
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 728c02089a0e3eefb02e9927bfae50490f40e72e.

Since 2015 DSA has gained more integration with the network stack, we
can now have the same functionality without explicitly open-coding for
it:
- It now opens the DSA master netdevice automatically whenever a user
  netdevice is opened.
- The master and switch interfaces are coupled in an upper/lower
  hierarchy using the netdev adjacency lists.

In the nfsroot example below, the interface chosen by autoconfig was
swp3, and every interface except that and the DSA master, eth1, was
brought down afterwards:

[    8.714215] mscc_felix 0000:00:00.5 swp0 (uninitialized): PHY [0000:00:00.3:10] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
[    8.978041] mscc_felix 0000:00:00.5 swp1 (uninitialized): PHY [0000:00:00.3:11] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
[    9.246134] mscc_felix 0000:00:00.5 swp2 (uninitialized): PHY [0000:00:00.3:12] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
[    9.486203] mscc_felix 0000:00:00.5 swp3 (uninitialized): PHY [0000:00:00.3:13] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
[    9.512827] mscc_felix 0000:00:00.5: configuring for fixed/internal link mode
[    9.521047] mscc_felix 0000:00:00.5: Link is Up - 2.5Gbps/Full - flow control off
[    9.530382] device eth1 entered promiscuous mode
[    9.535452] DSA: tree 0 setup
[    9.539777] printk: console [netcon0] enabled
[    9.544504] netconsole: network logging started
[    9.555047] fsl_enetc 0000:00:00.2 eth1: configuring for fixed/internal link mode
[    9.562790] fsl_enetc 0000:00:00.2 eth1: Link is Up - 1Gbps/Full - flow control off
[    9.564661] 8021q: adding VLAN 0 to HW filter on device bond0
[    9.637681] fsl_enetc 0000:00:00.0 eth0: PHY [0000:00:00.0:02] driver [Qualcomm Atheros AR8031/AR8033] (irq=POLL)
[    9.655679] fsl_enetc 0000:00:00.0 eth0: configuring for inband/sgmii link mode
[    9.666611] mscc_felix 0000:00:00.5 swp0: configuring for inband/qsgmii link mode
[    9.676216] 8021q: adding VLAN 0 to HW filter on device swp0
[    9.682086] mscc_felix 0000:00:00.5 swp1: configuring for inband/qsgmii link mode
[    9.690700] 8021q: adding VLAN 0 to HW filter on device swp1
[    9.696538] mscc_felix 0000:00:00.5 swp2: configuring for inband/qsgmii link mode
[    9.705131] 8021q: adding VLAN 0 to HW filter on device swp2
[    9.710964] mscc_felix 0000:00:00.5 swp3: configuring for inband/qsgmii link mode
[    9.719548] 8021q: adding VLAN 0 to HW filter on device swp3
[    9.747811] Sending DHCP requests ..
[   12.742899] mscc_felix 0000:00:00.5 swp1: Link is Up - 1Gbps/Full - flow control rx/tx
[   12.743828] mscc_felix 0000:00:00.5 swp0: Link is Up - 1Gbps/Full - flow control off
[   12.747062] IPv6: ADDRCONF(NETDEV_CHANGE): swp1: link becomes ready
[   12.755216] fsl_enetc 0000:00:00.0 eth0: Link is Up - 1Gbps/Full - flow control rx/tx
[   12.766603] IPv6: ADDRCONF(NETDEV_CHANGE): swp0: link becomes ready
[   12.783188] mscc_felix 0000:00:00.5 swp2: Link is Up - 1Gbps/Full - flow control rx/tx
[   12.785354] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   12.799535] IPv6: ADDRCONF(NETDEV_CHANGE): swp2: link becomes ready
[   13.803141] mscc_felix 0000:00:00.5 swp3: Link is Up - 1Gbps/Full - flow control rx/tx
[   13.811646] IPv6: ADDRCONF(NETDEV_CHANGE): swp3: link becomes ready
[   15.452018] ., OK
[   15.470336] IP-Config: Got DHCP answer from 10.0.0.1, my address is 10.0.0.39
[   15.477887] IP-Config: Complete:
[   15.481330]      device=swp3, hwaddr=00:04:9f:05:de:0a, ipaddr=10.0.0.39, mask=255.255.255.0, gw=10.0.0.1
[   15.491846]      host=10.0.0.39, domain=(none), nis-domain=(none)
[   15.498429]      bootserver=10.0.0.1, rootserver=10.0.0.1, rootpath=
[   15.498481]      nameserver0=8.8.8.8
[   15.627542] fsl_enetc 0000:00:00.0 eth0: Link is Down
[   15.690903] mscc_felix 0000:00:00.5 swp0: Link is Down
[   15.745216] mscc_felix 0000:00:00.5 swp1: Link is Down
[   15.800498] mscc_felix 0000:00:00.5 swp2: Link is Down

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v3:
None.

Changes in v2:
None.

 net/ipv4/ipconfig.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index 3cd13e1bc6a7..f9ab1fb219ec 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -61,7 +61,6 @@
 #include <linux/export.h>
 #include <net/net_namespace.h>
 #include <net/arp.h>
-#include <net/dsa.h>
 #include <net/ip.h>
 #include <net/ipconfig.h>
 #include <net/route.h>
@@ -218,9 +217,9 @@ static int __init ic_open_devs(void)
 	last = &ic_first_dev;
 	rtnl_lock();
 
-	/* bring loopback and DSA master network devices up first */
+	/* bring loopback device up first */
 	for_each_netdev(&init_net, dev) {
-		if (!(dev->flags & IFF_LOOPBACK) && !netdev_uses_dsa(dev))
+		if (!(dev->flags & IFF_LOOPBACK))
 			continue;
 		if (dev_change_flags(dev, dev->flags | IFF_UP, NULL) < 0)
 			pr_err("IP-Config: Failed to open %s\n", dev->name);
@@ -305,6 +304,9 @@ static int __init ic_open_devs(void)
 	return 0;
 }
 
+/* Close all network interfaces except the one we've autoconfigured, and its
+ * lowers, in case it's a stacked virtual interface.
+ */
 static void __init ic_close_devs(void)
 {
 	struct ic_device *d, *next;
@@ -313,9 +315,20 @@ static void __init ic_close_devs(void)
 	rtnl_lock();
 	next = ic_first_dev;
 	while ((d = next)) {
+		bool bring_down = (d != ic_dev);
+		struct net_device *lower_dev;
+		struct list_head *iter;
+
 		next = d->next;
 		dev = d->dev;
-		if (d != ic_dev && !netdev_uses_dsa(dev)) {
+
+		netdev_for_each_lower_dev(ic_dev->dev, lower_dev, iter) {
+			if (dev == lower_dev) {
+				bring_down = false;
+				break;
+			}
+		}
+		if (bring_down) {
 			pr_debug("IP-Config: Downing %s\n", dev->name);
 			dev_change_flags(dev, d->flags, NULL);
 		}
-- 
2.25.1

