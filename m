Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D035479526
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 20:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240745AbhLQT4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 14:56:00 -0500
Received: from mail-db8eur05on2110.outbound.protection.outlook.com ([40.107.20.110]:21601
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240748AbhLQTz6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 14:55:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TgeHcE/oz6xEu/9Lxdmxztu18dH5yBdXrnVRKUyXOCVrD3D53KbP1806jbdvdp1R40bUAJ5t9EpgzR3a00w/oMSZN46V3oBS0V9P180EXiwqV4Ni5/muE0Cks22P+tk1jtGqMvfKXhlFVLsHsAd3TazZq5495DrF51Z76P1hvFc/50orB30iEJ61vqH8oVUx7ghjQdSqzqKvicAcev4O6Gv3I8eksggu/cO+6r+pcGGBcBXY6jTmE8KRYxtvwg1TVo8Y4FgkSZgqT7zcqA/zBOXpptrMRvhMapJHzvNmCl5ixmfZVX3jhMNnLK3cdwGFMaNxSWouHm2RO2z20gKKHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=izeGnaqn0Yi30yfIeyCB7XDifH37/BNG3POooc3tPhc=;
 b=cvrFeicBVkPy4M6nK1FcZbOvm5c21qrCKYxB29O9P/5IT3R007vGFz0ZJQ0RsQbjh/CV4fMsLNOKNhWPrRfsmJzNo9S6h2To2nnfTETrcORDjf3bmrox5bCm8FYHYR3S0ZC+Qu2qC3mAv9yEG8xyIrp54mCDx77lIua7s/B97m8RCudLqF1Md7FfaCVKx4NJqDE1UeoK7MjZ3vSPuiSWCwN2m/aPjYxvJL5wVoLyVCC0jYMe402pi3rpnzD7i+TOTsXpaSLjzXJtgl1V3YV67ela9Iklt7/4FGWgyxC8e1c4IAOGkk6hlRlkHq5hbkAVpjSP5Lm4aGvTB1L/zjqvHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=izeGnaqn0Yi30yfIeyCB7XDifH37/BNG3POooc3tPhc=;
 b=yvlJfeBHCR2BV6rI43JxJgSUdFCdAEQOGDIkhm0rLyfXfXtzbqfHoiQljVs4rhcmeM6gB/jTCdCc1z7sy3Ne+Eo3GpBxy0RXqmSqEhP4ci1mwjlwfssBQWnR8xHYdXo6LbkenAgXIewmSzMi8e7YO6cIvXMM0Xj7UYfW5Tl6Q+w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by AM9P190MB1058.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:265::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Fri, 17 Dec
 2021 19:55:56 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256%5]) with mapi id 15.20.4801.017; Fri, 17 Dec 2021
 19:55:56 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/6] net: marvell: prestera: Register inetaddr stub notifiers
Date:   Fri, 17 Dec 2021 21:54:37 +0200
Message-Id: <20211217195440.29838-6-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211217195440.29838-1-yevhen.orlov@plvision.eu>
References: <20211217195440.29838-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0070.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::20) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08d81aa2-8007-4337-20be-08d9c1973d5e
X-MS-TrafficTypeDiagnostic: AM9P190MB1058:EE_
X-Microsoft-Antispam-PRVS: <AM9P190MB1058FF9519AB6AE78640AB9B93789@AM9P190MB1058.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:747;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tWeK4oN6GjK6pvZhdnhHNqNh4O+sJUKWj0ydd56UdXNGqkFFthg8yxAvZwo7KVdoM9bHeWn7HXm0tn11exgQnjKNLfxssEgTYvuXUz0Zg9bMtTBha1IXdsCX8CJjfrWiTSXtDhDRTClNnHF141qr13SnpRsx487JeGIiMF2y0t3UatMI7GdFZsGs/GT+4taFbaXjR6XYBl+rv8KAFosgEHeBMebVSLQmw7bahzmXGOgffjvqmt2a7/pWr6R/3RHpK9nNhX8VkQBCl/7p9zEGKUjVbEYY9PN0U+FoAN/OJkCtHUhT/o4QEG3WRfAijWVZzcFVzrQpavw5fiSP1VhRVrrp8BLZVKf9AO5icWnHeHPk73E9X8lOAbhfKanoNJbQ5W8bmmtiHI5D/SUempE+LTHn5CZpITXoqrFJb+ga8+alE22mX5fJuuw6Dp4E7RZT7n1YW/pkoNdmka5RhPeCiItbjMdNlWxjbAlzu0WZp9bYycVEsqAo2vN+KFaH8X2puGdUev7443xc0HFYB3ebMdoZCYi7L31snzZt2aLtWWdT/pnCU+1LxcG36l3Kegk6tRWkXOZ1cvLcAuqoDy6Y+IcgkuO8eGWyegNxnkSWBiUzELPsqxFquQeXfzUXltlfBwL1zEZoiN1fszDi3P6U8W8jkQon7SFDvOliVVhng+uAaCPl9Q3G37WbioggZKmK8PopHn5x5VN4zUbKjoSikQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(39840400004)(136003)(376002)(366004)(396003)(6512007)(36756003)(6506007)(6486002)(6666004)(8936002)(26005)(52116002)(508600001)(5660300002)(4326008)(86362001)(186003)(2616005)(66574015)(44832011)(6916009)(2906002)(316002)(66556008)(66476007)(66946007)(1076003)(8676002)(83380400001)(38100700002)(38350700002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Rv9IVNdqmnwcWW0OWKuZmt8GpOq4MemPQoA/H46AE2vhwzW0DDxcli49XC5n?=
 =?us-ascii?Q?anQs1p3DDuJIdsTEEsFxUWX3Gph7mZpXCYWPFYQF/nWqLkzl6gqAhnvHBvHx?=
 =?us-ascii?Q?Ma0NvXShzqXLXCRXSKzM4HG7eJ7aGyDg8Cbi+21Q13hK/gQFxNNqyXgN4s2o?=
 =?us-ascii?Q?hH6FY44QSPPerLIj/WojEbb4O4Va4HfgEXf9irEUyPTWt+j7RDFmU8LgkU4p?=
 =?us-ascii?Q?EHLbyOdOmUNFtl0mHA/d4zTIgE+HdZP74B/g2l9oJIIgtTKBi3dfHCikKg3K?=
 =?us-ascii?Q?Jgr1teQONd7pao3N6nZxeicg7lpqVZxqz2jNku1RG6Kcnuk+r4qr0e+woaMk?=
 =?us-ascii?Q?TxIt/PLamQRvj7bXLjCmpEhvA/86ct5+5cmt98JCg0gGt+nyFQIzrXVHpIvR?=
 =?us-ascii?Q?3zs3zZ/BNeekHvw0v9JdJbQNsfF7b7gQyfFGL5OQNSxu+CdLW668W809/l5v?=
 =?us-ascii?Q?2KM5ZHugjFpwk0A7irwBhoerkt1AkcKaLnXa6dp8VMZEcMbjnM9r6/A6zFwO?=
 =?us-ascii?Q?UWPrB8abrJgH6UDRhQ4QoTrx/zGJ8NZNf3gPePlODI1aF3a2dkR22LJ4R6NH?=
 =?us-ascii?Q?7JR1HUfUKxK6It6XtOBiRJy2sDwwXISRH3vLEHbhkObJBxfL0BvYmxHKL/y4?=
 =?us-ascii?Q?vl7MpnAj9fKmQsHXCoDRUet7BIgcmcvc8GJqu5MsG/45RGCRSY7T/vVcIv55?=
 =?us-ascii?Q?SWp+nIF9sLOt7alPYCqlM1U5TDIcD5UareL1AATbfehq74ZV4NqxZaZ1SqpK?=
 =?us-ascii?Q?lwedTEvl/fy1BgYCMSZktyw8NHQg2pm7vNt/GQXaY+SG3hbjpB7WSFU5HGIq?=
 =?us-ascii?Q?zTfYhnpa97nxPM4tdOpwheGQL9vfiOWZaAoWpikfX7lB13nUQDf2vSvrV5mI?=
 =?us-ascii?Q?B+jNd+Iq4rG3v8Ji2zb5P1CczDzOxR/XG+AmG2OHyLDDoVee14GBT27vjhvg?=
 =?us-ascii?Q?p908OcHfarHvnGZyKBImuvMTYV1jG+cczXmzf64rYExKIVLvMr3GJbKzZa4o?=
 =?us-ascii?Q?M4LxNJ/qDx7v/L2GM78fjmw3Ly6bh92esfUL2/Bcz0pVy5DTVYEJX0yL25a5?=
 =?us-ascii?Q?O/k4YCTxt6fabTLzutWLiO/qYybDdJNBzeRYj7X0JeWfsdRgzEgdamhk1cdT?=
 =?us-ascii?Q?6/swXfmjcU3cFHCs2oKW1hgaYoAmivWht7YEcMH2g+EcVdVjZQz5iGmSYnEN?=
 =?us-ascii?Q?iC+kfLNiIXloTCScQIDnGb0U0v2hrtzcyyumvGhGEdq1pTHgJMffOVcMkLi1?=
 =?us-ascii?Q?9dyn7+QhhxnaxtMMsx3t09wHBZ9h3NzEjj2m++gnkwbGhSDFWg/3yhV6+trE?=
 =?us-ascii?Q?ffFHfm/ZaIVJeFhmqIVNK2cqSmxiKXVqnFkOyaqVidGRyqh5nnHCPJadJycF?=
 =?us-ascii?Q?fKhJPEI2hVyh6jveAstP6xEDHwS13gvWUPyNJFgW+SbC4KIc+1ggTIoQnkwN?=
 =?us-ascii?Q?NEXdtqXwVoD+BmO3zuwbEDR1Ez7UsBJLtGROpyATEFIXuYdbGunn/ZhziB7R?=
 =?us-ascii?Q?sIECFpV5d6VN0OnWnFKkWrbOH0eds3TXOgsdYHCufBAWcs+BAP4C3SW15W3S?=
 =?us-ascii?Q?y5vwL+gfL7y9VE3xE0Y8+RIWrZyn63tIjq6MgRtdf1zyBJXEa5XU3xfdmnwX?=
 =?us-ascii?Q?AbOqnku1wQ8721b4ZIF+gvdV9sKohbsX2Et15uZ5BhzjcbL0JFcjoNd5Ih3m?=
 =?us-ascii?Q?IweoTw=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 08d81aa2-8007-4337-20be-08d9c1973d5e
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 19:55:56.4530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qqoJ2B0v4d1Ydsg62w1WCxLWEriInNvI20BEm3aA3KysH61tmzwrFC3xf6OeNZgTpS1OVBTXGd05QJx0XMiwZCyYe1V2PcaAeQdvJrgAZlw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initial implementation of notification handlers. For now this is just
stub.
So that we can move forward and add prestera_router_hw's objects
manipulations.

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 .../net/ethernet/marvell/prestera/prestera.h  |   4 +
 .../ethernet/marvell/prestera/prestera_main.c |   2 +-
 .../marvell/prestera/prestera_router.c        | 105 ++++++++++++++++++
 3 files changed, 110 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index 7160da678457..a0a5a8e6bd8c 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -281,6 +281,8 @@ struct prestera_router {
 	struct prestera_switch *sw;
 	struct list_head vr_list;
 	struct list_head rif_entry_list;
+	struct notifier_block inetaddr_nb;
+	struct notifier_block inetaddr_valid_nb;
 	bool aborted;
 };
 
@@ -328,6 +330,8 @@ int prestera_port_pvid_set(struct prestera_port *port, u16 vid);
 
 bool prestera_netdev_check(const struct net_device *dev);
 
+int prestera_is_valid_mac_addr(struct prestera_port *port, const u8 *addr);
+
 bool prestera_port_is_lag_member(const struct prestera_port *port);
 
 struct prestera_lag *prestera_lag_by_id(struct prestera_switch *sw, u16 id);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 242904fcd866..5e45a4cda8cc 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -159,7 +159,7 @@ static netdev_tx_t prestera_port_xmit(struct sk_buff *skb,
 	return prestera_rxtx_xmit(netdev_priv(dev), skb);
 }
 
-static int prestera_is_valid_mac_addr(struct prestera_port *port, u8 *addr)
+int prestera_is_valid_mac_addr(struct prestera_port *port, const u8 *addr)
 {
 	if (!is_valid_ether_addr(addr))
 		return -EADDRNOTAVAIL;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index 2a32831df40f..33aba94efafd 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -3,10 +3,98 @@
 
 #include <linux/kernel.h>
 #include <linux/types.h>
+#include <linux/inetdevice.h>
 
 #include "prestera.h"
 #include "prestera_router_hw.h"
 
+static int __prestera_inetaddr_port_event(struct net_device *port_dev,
+					  unsigned long event,
+					  struct netlink_ext_ack *extack)
+{
+	struct prestera_port *port = netdev_priv(port_dev);
+	int err;
+
+	err = prestera_is_valid_mac_addr(port, port_dev->dev_addr);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "RIF MAC must have the same prefix");
+		return err;
+	}
+
+	switch (event) {
+	case NETDEV_UP:
+	case NETDEV_DOWN:
+		break;
+	}
+
+	return 0;
+}
+
+static int __prestera_inetaddr_event(struct prestera_switch *sw,
+				     struct net_device *dev,
+				     unsigned long event,
+				     struct netlink_ext_ack *extack)
+{
+	if (prestera_netdev_check(dev) && !netif_is_bridge_port(dev) &&
+	    !netif_is_lag_port(dev) && netif_is_ovs_port(dev))
+		return __prestera_inetaddr_port_event(dev, event, extack);
+
+	return 0;
+}
+
+static int __prestera_inetaddr_cb(struct notifier_block *nb,
+				  unsigned long event, void *ptr)
+{
+	struct in_ifaddr *ifa = (struct in_ifaddr *)ptr;
+	struct net_device *dev = ifa->ifa_dev->dev;
+	struct prestera_router *router = container_of(nb,
+						      struct prestera_router,
+						      inetaddr_nb);
+	struct in_device *idev;
+	int err = 0;
+
+	if (event != NETDEV_DOWN)
+		goto out;
+
+	/* Ignore if this is not latest address */
+	idev = __in_dev_get_rtnl(dev);
+	if (idev && idev->ifa_list)
+		goto out;
+
+	err = __prestera_inetaddr_event(router->sw, dev, event, NULL);
+out:
+	return notifier_from_errno(err);
+}
+
+static int __prestera_inetaddr_valid_cb(struct notifier_block *nb,
+					unsigned long event, void *ptr)
+{
+	struct in_validator_info *ivi = (struct in_validator_info *)ptr;
+	struct net_device *dev = ivi->ivi_dev->dev;
+	struct prestera_router *router = container_of(nb,
+						      struct prestera_router,
+						      inetaddr_valid_nb);
+	struct in_device *idev;
+	int err = 0;
+
+	if (event != NETDEV_UP)
+		goto out;
+
+	/* Ignore if this is not first address */
+	idev = __in_dev_get_rtnl(dev);
+	if (idev && idev->ifa_list)
+		goto out;
+
+	if (ipv4_is_multicast(ivi->ivi_addr)) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	err = __prestera_inetaddr_event(router->sw, dev, event, ivi->extack);
+out:
+	return notifier_from_errno(err);
+}
+
 int prestera_router_init(struct prestera_switch *sw)
 {
 	struct prestera_router *router;
@@ -23,8 +111,22 @@ int prestera_router_init(struct prestera_switch *sw)
 	if (err)
 		goto err_router_lib_init;
 
+	router->inetaddr_valid_nb.notifier_call = __prestera_inetaddr_valid_cb;
+	err = register_inetaddr_validator_notifier(&router->inetaddr_valid_nb);
+	if (err)
+		goto err_register_inetaddr_validator_notifier;
+
+	router->inetaddr_nb.notifier_call = __prestera_inetaddr_cb;
+	err = register_inetaddr_notifier(&router->inetaddr_nb);
+	if (err)
+		goto err_register_inetaddr_notifier;
+
 	return 0;
 
+err_register_inetaddr_notifier:
+	unregister_inetaddr_validator_notifier(&router->inetaddr_valid_nb);
+err_register_inetaddr_validator_notifier:
+	/* prestera_router_hw_fini */
 err_router_lib_init:
 	kfree(sw->router);
 	return err;
@@ -32,6 +134,9 @@ int prestera_router_init(struct prestera_switch *sw)
 
 void prestera_router_fini(struct prestera_switch *sw)
 {
+	unregister_inetaddr_notifier(&sw->router->inetaddr_nb);
+	unregister_inetaddr_validator_notifier(&sw->router->inetaddr_valid_nb);
+	/* router_hw_fini */
 	kfree(sw->router);
 	sw->router = NULL;
 }
-- 
2.17.1

