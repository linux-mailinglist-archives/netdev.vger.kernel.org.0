Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8F04804FC
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 22:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbhL0VyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 16:54:01 -0500
Received: from mail-eopbgr80131.outbound.protection.outlook.com ([40.107.8.131]:62808
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233694AbhL0VyA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Dec 2021 16:54:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WIcDGLOV08rNKtnTrwBalJTGFQua6qQ0IyQUi7eE6y3/S3Ryuhjz9KFFGai9Vfzz4ZMaKzv3xft1N+W/CyKerWJYVQxF2FLV/tdT58u9GBuMXj1na0tw62K1SDCk8dcxW/EePSmTAJSG90CWjpYv+pNXTtPEo7aOjavwbWHsb7DjPqgrBTpF/1T7q8+XUo3r5DFP++molxbUFQ4LPXqTwPrX7g5NHgu7hPbqw4SI8gEoUFkQV+ye4IbCSYIG3aSVzm9/mWDuCdHP3m9bOFiXsIS+RdGusPW/4qMcQhg/Ze5eVrUwWQVAARrRIymL9K4jdAcztH6e9n9kP+ikJaq6ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bG9ZYnhVaiq8cLvF6UYhEe9aOn9ZU7lVWHN6FTKAKDc=;
 b=JcC85NzlRTkK2xbdrk2sZRUZqoD4LlA6dC48BG6R5Tn4+3XECpaCnAAJwK3N8/BiRnYomm0YQaAMYwO4Pyb1Jz4nGD/cFT2sHaQ8Hry/jSoTLlPebpbvWUtPFbT6gKOdsEfwMC6qZ9eIRZrwnYVoaEfUiT5oTCPlIEEkm8aFkBYxSlllpfBkFTrf4mNPmoqcVsc/+5TbKQD4HD8SFqGskWj8hkLGuRGP7eva9LILDvS0mZLmlAXU6dWr5q7ad9nnzdboeyMO80885er9/oKJLNjvSFAvi+vk/Z60o64czzkRDX3iOvG+vrFgJjkMwKTXRTzkVthSKanFPjVl5CchFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bG9ZYnhVaiq8cLvF6UYhEe9aOn9ZU7lVWHN6FTKAKDc=;
 b=CxPGV9+HaL0D1tov/7YWCtY56/cEOn6oxNvC1sO0EthHf0ezA573k2zSc8EFhCNfxZkLr8niiy4UnBOqS0NRa/2QcfdUoLqcQfIRrICKLhx6YBJZb06EH1Zd2HTX6qp9lQilCvjo7eX5/MnmjoxQQNMgIWqxK46h9O0IyN8t9aU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by AM4P190MB0145.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:62::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.21; Mon, 27 Dec
 2021 21:53:58 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256%5]) with mapi id 15.20.4823.023; Mon, 27 Dec 2021
 21:53:58 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org, stephen@networkplumber.org, andrew@lunn.ch
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 5/6] net: marvell: prestera: Register inetaddr stub notifiers
Date:   Mon, 27 Dec 2021 23:52:30 +0200
Message-Id: <20211227215233.31220-6-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211227215233.31220-1-yevhen.orlov@plvision.eu>
References: <20211227215233.31220-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0035.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::8) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9ca4952-1c64-407d-f4a7-08d9c98362da
X-MS-TrafficTypeDiagnostic: AM4P190MB0145:EE_
X-Microsoft-Antispam-PRVS: <AM4P190MB014571387C2387881427A37993429@AM4P190MB0145.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:153;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4nTLVbYoPWNEmN1l+ZN4jCng97HyN+p+wSJmHN00c/TRGkpdZ8dzt7NnZlUvJTZwtOHrwvqHFnhYtcXrqmt4lEngUUUj439ZX9ohFZ8+9JIwoxR8ByDhhCT0lbU2h4gh6r9tV2es7Yk0GANWRJ6EW85wYIjBh7FbxWl2btylIJFXmC62KmJV3RWXPm3xAvd7tFfwyN7SrmrdPLRX03KZpg8XQDcsRJ1610ldTUfep+ngCd88q1q1Bad5Nmn/NrRDZC/uhjXEhWDpKk14tsv1qMl+YmAa0R4ZbYJwla0iaYtLlhoapF5C0mLZD044J5s0jDgtxbiTeZ/KqC4TOS7WEOVL6pFowvopFSbeKAKdzP7Qfr13SCarefVn7HgoFhFl45Pk7pqLJj4l3NnQRQx4nHPwz7uGymTwt/M2BQ4J0yR1sVl7FnlQcyP6378biMkPgEJgLJyRUpKHTpfzsuLk0FlCCYqAfXXzGUul8FLl0Md+Cue0Be3x83EV9htfl3rYzG2uXPk7Rnl/Yb/YKKEtl3ftkIkuzdqsn5DBy7obZq9mBTRvAUotOjlqP5Jfsuo1QF53BN7OFau0EHsd/ctNonnIEtI2bXyVccWHqdZnpCw1yzGSTed44veN1MOCm1+Xve2ur6j3xXlKoy3b3vDwMGhKT+jIKKSwT9DT2n9ky2Lor+clB6NcbHG+PHP6HDfA2y20H4aAVrzdsY0C5TdB6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(346002)(376002)(39830400003)(5660300002)(83380400001)(26005)(1076003)(54906003)(316002)(186003)(2906002)(6506007)(8936002)(4326008)(8676002)(2616005)(508600001)(38350700002)(38100700002)(66574015)(36756003)(6666004)(52116002)(86362001)(6486002)(6512007)(66556008)(66476007)(44832011)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZpicXCGOUU64KFsldb8emSaO1dehvoex3npuFL6YqtyRSJT0ivDkJAxZU4M3?=
 =?us-ascii?Q?OXaQELQZq8AVxf2eGzOspGuRJkTqttu9B8flCFJ6Ee1vMAZsOyVpFmfonBvA?=
 =?us-ascii?Q?fdhskAU1YmkXLFN59WjorI/0aZ8QO1H0E45ERtdp6cIhPSfwQOvU75uTbTNu?=
 =?us-ascii?Q?pVFUM57OpditjyrnUF8Ui12E4rVYk51n1LggW5OFpZiqWWmtbphzMLumNlDu?=
 =?us-ascii?Q?dP7h4a+sVUlXBmfixZlZkfXpVvyK2U8ZSecOEKFhA8wHWbr/7ZKdFe1Wn/Im?=
 =?us-ascii?Q?B1BYvJY++UnRjazLDs26wcpIQ72MNAXF2D3KY5zep/BUhpKp8TprtwghN8gc?=
 =?us-ascii?Q?LlfXg++nwY/nO/TLtSkUjlJFM+/juPesVVTQxLLpdwi62Z4bwzOY19jx38ZK?=
 =?us-ascii?Q?Int5Dac4wNcD6t/VQ1XEBw6zeNFyvNHbuLycolbuKVwpWyRByxrIcYSt3wh8?=
 =?us-ascii?Q?jtRBasj5k5wbujknGErXvEoo0ZpdnYqO4SaQWFdeLBf4BnfNKVPph9RzVn/Y?=
 =?us-ascii?Q?HD4b/0i1q1wZy+ll/ZR0pRT6UbREVJ5iExfSVs+V//MDjA+n707KdyszNrbL?=
 =?us-ascii?Q?V8Klrb7+z2srUW145V2KbibE8XS2jfqmNDsWowXNbPvvEMFfYJ0CUY+o75fI?=
 =?us-ascii?Q?hVTI8gkWpDORzHik/s9NkF9xy5WewkPFZ6fnqCma+9n8iTTNbidmzfY64KLG?=
 =?us-ascii?Q?UNOMUbrrkdiBJoNIyosEMtEcpzNHhmynkeWjQuzqM/qAr1E+ks0UyWEoi/ni?=
 =?us-ascii?Q?D/vlzLcYg0VB14Drmdo4xOp+W0Si8XvIASixBAmODevmN4DyqM1LWdw1vutK?=
 =?us-ascii?Q?8Kv4W9n+L3vFyBur3oTJ6LCkx/irgD0icm+cMOVVfadQb1WqnsttVfhMH7tA?=
 =?us-ascii?Q?/lCDLpWYMBp5MtpvhVRaOpGPrw+UVFfQIJz/E7hEvU5bJSiIqI+xIe3X3sWl?=
 =?us-ascii?Q?IGREpvQkQP3AWyIqBWs23n1ae9YpKVpwKVpEI9afXzNcOT/+1jXV0BiuEYHs?=
 =?us-ascii?Q?p3ptY8hMhddhy+NzYufWY41p//Ht3ybtEgxZ0FeC0UywkLMnIIU+f3JFESeJ?=
 =?us-ascii?Q?x1hk141FcX9mgkFAaAwZefYdJKph/tF8aA0N2wdTdrND/u0ZZeyYjd2hZCJ+?=
 =?us-ascii?Q?Y1oHLtTIpU+zetEvgl1V4ejs4XPUyHlKV+bSZgpB0+chRxLgofPObiOWJ5Vy?=
 =?us-ascii?Q?gPIcE6bjlZfbMzLrParNlr8XuieVErkeFP4jX+DLy+qDQw9ZkynkSF36baNv?=
 =?us-ascii?Q?jO3e+CLH4GwYPY073jBAHxbDoQzNrEIhLLZkZy/u3crIjWn1B3uEAcNYwOzL?=
 =?us-ascii?Q?Flc8qfDeQ85XQW6nD9e4Nxlh0Pb8sQFFxsMj7nzVQIlIe6sscgY2GBL7OdiJ?=
 =?us-ascii?Q?W70o4kI/HDYcTuk8ZFo/IJyA33Gq4sVcOBg6Yvjz88fpcVys3QXQxlijSCNz?=
 =?us-ascii?Q?6+0Z9yflAnpeRtK7JQpUjnRUXvy248IP+PPEG/IvU1PvzxTbI3hW+ojSCSZH?=
 =?us-ascii?Q?cVDkU8WFQV9MYVNTAbjOP60mN35BQ/s7Y2IlHjvPvNko2+xgXJlsoLfK+bvN?=
 =?us-ascii?Q?tQ3h+fGHcUph952CTGKZzs/sIgIvDzILG0Z76VWo32EXnSBgT8TfnSeWz7gV?=
 =?us-ascii?Q?uTo8O2BGPyrpKZ5f9A5Y6IXv9Ik2W675eZVAnoresqTjF4yK6c0fQptE/OgS?=
 =?us-ascii?Q?3+R4oA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: a9ca4952-1c64-407d-f4a7-08d9c98362da
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2021 21:53:58.7301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PZnt5sR753p9m+BprCpRziwWUb315NhGOr7qIrW8iObhuhtHoOWoq1fJPfHtx5sm9lihMXomToALKcdzoIP+8RcPvkgsJ446JoRyY7nMsIw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4P190MB0145
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initial implementation of notification handlers. For now this is just
stub.
So that we can move forward and add prestera_router_hw's objects
manipulations.

We support several addresses on interface. We just have nothing to do for
second address, because rif is already enabled on this interface, after
first one.

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
v1-->v2
* Update commit message: explanation about addresses on rif
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
index 2a32831df40f..0eb5f5e00e4e 100644
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
+	    !netif_is_lag_port(dev) && !netif_is_ovs_port(dev))
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

