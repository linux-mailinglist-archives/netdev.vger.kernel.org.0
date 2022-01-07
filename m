Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8A44870DE
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 04:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345684AbiAGDC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 22:02:57 -0500
Received: from mail-eopbgr80102.outbound.protection.outlook.com ([40.107.8.102]:24869
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345690AbiAGDCs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 22:02:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c1ZguSLrmHkw4tm57MzKFvxHtIn0GlYSq2Fxlk52M1fDKOY0R4Ep8wthM9A+teTczR8coe4uamUyAKLNqferdFFFNbU2u8Rco/2ko+fqMd6mpHXk+segkeBJYSugiG5Zr5UhIaJ1xIwPQZgsSoVsNy+T8FbouBDszdhK83TzYKdFvDQXMXPyhlQgN3oQm6d0/rHu+l2IF/BeFkBGLd8RD+3VaYP5XADAJP7pAIZ1OdeKKkWPH6EGIPfEnjBtlmJRsjhv2NX0IPPGpALTvWvdWGU83Ij9SQKEc5pACRqIvl2lXK7r3TOhFW3rBz3or6Jx1G1uunK88BkKbrty6NnhEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AlLUkX/mZz5E3tKzVXqKAMgueemBwQL9zGY0elGHi2A=;
 b=WPmSIPEz093gfjyaRwn6ac88nwxJfRVikrbwPicYZqHpkzP7KAF3CKTMqHC76HH5GwBUW1FNXTGLxwXPSlw85J0VqTLOIAVa5PAAWaGb2cptnZUW8B10QdcNNaoYqlX02sWqHkd/WhGekPeAbn5wwdHJ7d+7AqXdloF8cGD4TpFCqQqVW1t0uPlhcSKsfMP0eAZ64q77DeGk7waUhfpEOp2WOhx0y7mlI00zfuyB5QSX3tA1LDne7dlzdcjULcl+6LylzJ+xx3CBHB1JnQPUfccnzy1izmDTpZGpbXXA2Wi4RIlLSMcpg9Y7uKFFfsCAtiUKCDoCQsgjDy+SyEthfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AlLUkX/mZz5E3tKzVXqKAMgueemBwQL9zGY0elGHi2A=;
 b=VwRn+wLkeMhvXjRWv98wW6iuzOYaxe5BhNo/xO79g6fb19JYavBwNndnM4iN7PHkhq0v8LRmxhv0TkGUf1D8iigHfHDUQwjR6EqmwG2OFH6wKRWPPOSDgoHcH6qwNY9U6SMYgXIEswWt/aEoks2O9mWo3CFtZ6c/aRzZgEjEg7M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by AM8P190MB0834.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:1d8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Fri, 7 Jan
 2022 03:02:37 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256%8]) with mapi id 15.20.4867.011; Fri, 7 Jan 2022
 03:02:37 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org, stephen@networkplumber.org, andrew@lunn.ch,
        idosch@idosch.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 5/6] net: marvell: prestera: Register inetaddr stub notifiers
Date:   Fri,  7 Jan 2022 05:01:35 +0200
Message-Id: <20220107030139.8486-6-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220107030139.8486-1-yevhen.orlov@plvision.eu>
References: <20220107030139.8486-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0001.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::10) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ceccd70f-82a8-475e-716b-08d9d18a28c0
X-MS-TrafficTypeDiagnostic: AM8P190MB0834:EE_
X-Microsoft-Antispam-PRVS: <AM8P190MB08341A60D37F4C1E0281B267934D9@AM8P190MB0834.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:849;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4EqDU+gYH7QbwedtjtOKL44LxS+glIzYQDNqLzx+3o0cJgnaJNkT2vvkyc0iR0asLrjdeECLuC1iVECo4rWZB1FmOsmBEzbsZ+3eVh9zTrVNWb5GUdVFotBAAa528xwwx3Hh+D/y07cnPmSogDvQqT84RLft7SWoJI3qKSJKKu9/zgFGJo4q+hIB3jQuHAEdhIwMSeHKHZ8+ZQAoPvgKVRgpOXqgPuS9njU7YIa63zr+248zbL6y81cJqkQE7S3gEvo9KD6t+N20mDDOV0O7yVci6RJJOD2EXem5ZghW7NjHPEi4YEZcRQiTTeWIRd5auXEI9QiyTxGRKliPorF5t4b8fArR120gFSfWoqALPT3XRgOtrGonfpqLe7Jf8XTclf+Tspj9nxhud84Cx0FsjLfsuRm++a4fVgw9MoFDVJFyBoJru1m1gybyWXP3vOI5W2lnviJQ8iv+UPHzgh6lOpIOD7ma4v1hZ9KkJdIPpAsINxgQWLL67N/V2jUbVTC015zEW2F4369AYmYi0WSVfyF5lwoCpgr8kNoUnTklDmR5fpC9bJCvXO5eR2GLmhLfYigk+4DeXPANvdGgmePdy8rYhdxkO9y3HJph0L9XDjn4FqHO7CROvLYt54FOeOe1MoSkwDlJLBjTiR1Oku/9wEsWt+lsZMMHQRHr8Od+hhAwOuMN4k8GWuAt7WxOOPpnpMhi+M0/CN26RhzZ013KRw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(366004)(39830400003)(376002)(346002)(136003)(38350700002)(66946007)(316002)(6512007)(86362001)(38100700002)(1076003)(66574015)(8936002)(508600001)(186003)(54906003)(2906002)(8676002)(83380400001)(52116002)(6506007)(26005)(66556008)(66476007)(6486002)(2616005)(5660300002)(44832011)(36756003)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?baXMrtSGRATH2CT0sbTWNVp8BsHf665lUczxPbZ4aLq28f4uiYR8RlqETDmq?=
 =?us-ascii?Q?sf38qxTBU4Fermr5woUwrpl99Rl+4SQNMr3+Fv9tx4d1hs0ks9m/49NK15vH?=
 =?us-ascii?Q?fvJNszKKpr8ykkegjQz5NqZmELPIGkHrpdaouzzsnrN+BUqCfxQZM0aZ5nFO?=
 =?us-ascii?Q?0yyIPctJ4RVTotL7znIruNrpV8nWZzj1CUpWQ0C+MRB2NADNz3dPTIKvRi1Z?=
 =?us-ascii?Q?SXKxdforbwF/9yeEEa71v2/tOHCJHr6Z/bDy2Rk0Z8WeS67nrqEV6HOq2zSv?=
 =?us-ascii?Q?TOuZpaZJ5zY7aAV/o6ti0jw1wYfSK2SWsSuOYrsracOS6DRdYDFpkqsHkEzS?=
 =?us-ascii?Q?YcKiT0UeObmjRp+GZn8MUfuQNJueF2UtXHfzPmQdQbclEL7t+u062HDFOqb0?=
 =?us-ascii?Q?ClrUYAswuRvDa0zyMo77Q4AfLMAHkts3+nJUtskhRNEixgdC1HwpkrE+7x0/?=
 =?us-ascii?Q?38KIaqSxYtDOcEwUEjFeX9pN83XyvIOeG+M4jcsG1oi+CozpEIMPw0QrdgpK?=
 =?us-ascii?Q?7nFAbe6HK+IYOFF+cAknYBjMYW6eP58pCcFkyTSiV6LSuXZLF3T8ktZrTT7n?=
 =?us-ascii?Q?tyltFiA4aluKW0E0a9yJPbucVdIGEHEg0Gbx3he4FQ14FQnv7MaUQ/yGraPy?=
 =?us-ascii?Q?+km3gJGAksvkFZ/YjWbuLVmSzZ9iSauTYfgF4nLNh+1PSGypYLEEWTCXoRAO?=
 =?us-ascii?Q?yp3+hR7nFdRQbxynwJwkDMCIfUWiTVsACuhcYikH1jcZEqBKLrBaJ1ZfPPlX?=
 =?us-ascii?Q?Au2e486blbZd6uSbR8+UbSVKQkzu/rUc7CRrvlUhus9GIOU+wELgxQVeB85W?=
 =?us-ascii?Q?d5Tatz7nQu7IECIVui/CHdJA4EQwh4k5LGgs1Iqtv8jThtYrEAFwVN7VOlw4?=
 =?us-ascii?Q?o15ED1uLIdzQydgi+wJAbnvN18SoC8TVqLcdThmR7H3Z0XEaRiVRU+YHNxBe?=
 =?us-ascii?Q?6UQwea3RyB62HtDv0cuYy6RcTTKndsjeaKGuyCsbq+Q6dQiCgZmBLDOl2dCT?=
 =?us-ascii?Q?N7zH0+1oxaWK9+ytbcWEAbbuaK8IF7SJx3BdgJjLcGTxkGTwdDvgvVdmgndW?=
 =?us-ascii?Q?tY1w0MZVzprW1Ri3UQ6toPWPbxizVU4VGNARcJgBTjPekYujVHz5b0KbS4tu?=
 =?us-ascii?Q?7wVEQ60O41x6V6mTyggMZw3ArcdnpdQkhWFD6uiNSkHFrHtSEfdlsS0tWCtm?=
 =?us-ascii?Q?DjA2MrLKsNsHqz5HjGSdL6yXt1GvGHpJol1wgiXyP1eIsYd4CG8BdVO5WKlS?=
 =?us-ascii?Q?wyEhtHktrOYG92tIChN8MgCget242em1B0mj2xRXxokpOg18ln8/7488/M8w?=
 =?us-ascii?Q?ideMjFax9t/APKJJ36g2GKmjbQUEYhyEx5vju0EvuTsGG9Zz1+RAuxpncRRS?=
 =?us-ascii?Q?43gafHxf40dfRpjH0GjjpL/xsFASn1IvLYwPfdgSrO/bqLm4EuKK8WrOc7LV?=
 =?us-ascii?Q?FaeOaGdF80OZ3stvvtvzi3TVulhRY2VAoPSoRYUWvUrSRqahrjvbkPRrNnxK?=
 =?us-ascii?Q?ZeZG2R+eoTsej9aMgJYxCdl7fK813E0YdLBnKcOSRHK7HfFdWqZiWe/Hs0oG?=
 =?us-ascii?Q?GBJiffGqcKJphwJr2Er57pH/XfIhl4nOmiNLgG4CJ2CdFdVirkTPuFQnNFTL?=
 =?us-ascii?Q?Y3PhA6LGM6SIMQAMWU+4GsJ/44g6LiOZ9eTHHioisoZZBlYuTQFgvUpFjrcF?=
 =?us-ascii?Q?Ef0p/w=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: ceccd70f-82a8-475e-716b-08d9d18a28c0
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 03:02:37.0278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EDCLy+h+WNMwA4AaTPR15TNCFfThqoYq4h/KANIrKJHc548+Om6VtLxD+yEsgiFgFsvNKxrdmGQw09brC5nsZAbQbNbW+qd6otekDKiBABc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8P190MB0834
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

Change-Id: I213f5142448a25985034f4de0e8417c8022cf49a
---
 .../net/ethernet/marvell/prestera/prestera.h  |   4 +
 .../ethernet/marvell/prestera/prestera_main.c |   2 +-
 .../marvell/prestera/prestera_router.c        | 106 ++++++++++++++++++
 3 files changed, 111 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index a70ee6d2d446..2fd9ef2fe5d6 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -281,6 +281,8 @@ struct prestera_router {
 	struct prestera_switch *sw;
 	struct list_head vr_list;
 	struct list_head rif_entry_list;
+	struct notifier_block inetaddr_nb;
+	struct notifier_block inetaddr_valid_nb;
 };
 
 struct prestera_rxtx_params {
@@ -327,6 +329,8 @@ int prestera_port_pvid_set(struct prestera_port *port, u16 vid);
 
 bool prestera_netdev_check(const struct net_device *dev);
 
+int prestera_is_valid_mac_addr(struct prestera_port *port, const u8 *addr);
+
 bool prestera_port_is_lag_member(const struct prestera_port *port);
 
 struct prestera_lag *prestera_lag_by_id(struct prestera_switch *sw, u16 id);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 7acf920bfb62..bb99510e4654 100644
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
index b5bd853d4279..b25a26522b18 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -3,10 +3,100 @@
 
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
+	if (!prestera_netdev_check(dev) || netif_is_bridge_port(dev) ||
+	    netif_is_lag_port(dev) || netif_is_ovs_port(dev))
+		return 0;
+
+	return __prestera_inetaddr_port_event(dev, event, extack);
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
+		NL_SET_ERR_MSG_MOD(ivi->extack,
+				   "Multicast addr on RIF is not supported");
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
@@ -23,8 +113,22 @@ int prestera_router_init(struct prestera_switch *sw)
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
+	prestera_router_hw_fini(sw);
 err_router_lib_init:
 	kfree(sw->router);
 	return err;
@@ -32,6 +136,8 @@ int prestera_router_init(struct prestera_switch *sw)
 
 void prestera_router_fini(struct prestera_switch *sw)
 {
+	unregister_inetaddr_notifier(&sw->router->inetaddr_nb);
+	unregister_inetaddr_validator_notifier(&sw->router->inetaddr_valid_nb);
 	prestera_router_hw_fini(sw);
 	kfree(sw->router);
 	sw->router = NULL;
-- 
2.17.1

