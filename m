Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55D095BBF9E
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 21:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiIRTsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 15:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiIRTrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 15:47:43 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2130.outbound.protection.outlook.com [40.107.21.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F4217E13;
        Sun, 18 Sep 2022 12:47:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bePL7bBWPEhxVaIcUECK//IPwsKZ8vfyMaKfU77zNeztvhOeOHp3wh7bl0DE7xTHO5T6OGgzcH8H8k7FcTfARBUYsiQkN05Z2BwFZi8sRpwFqHtL+2viaQNZD8OOA8m6MXC2kn6ctW4xVOZdXHc30GRaCbCwNeXRfcyAcgVZKbAsTTF6g0A7WsYS4bTJVfVemTJ06QNpfYDXPhIpZWgi0wkG9sW+3KVP0lYj63gvXBhwxTXlkJDwlKRn23FMMJOBf67ixDRkH5VlFEbUDLThO06cBUIhfd5tW16zQq9Eyae+UqfKXeBgND5QnmozqseyhuxpAIP4WAv0xtUC3SGPaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8iQ/Uz7E7sgmCaWO1HuIMCTx2xdKxTxx1S2zYKZ5ynw=;
 b=FO6BA8b5RLw2SfP1f4W1G9LxyzvuD/EOVTyY6rg8HfZt+IZY7pdYILeuGzVmuL38RpBQDOPq0g2j+WEIQo8Ef4ccyHfqQkJGC5ZR0smYKNHIVmoq6s0H8i86tKxNk4oF27hNuYlI8Juv6JtlKuVyicnlOUYNgRL+B7o3eCWPb+689oGCjZo6ZgoBcRVxWdQkCrS7QS43OcxRPjD9B9Ynu4+eIowIaxohNQ7xSU3pgSMZQLzXPXtFex+twL/iP1dwdw6uzHadz5ygHuDB6qr9sNgI2WdHWrHHZV0OtWLnpm40TdoqyHNCKz6z7h7oEjyC1Zik7jIhOLYzDmAwzw/iIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8iQ/Uz7E7sgmCaWO1HuIMCTx2xdKxTxx1S2zYKZ5ynw=;
 b=DiKCnJYA+tWHapuUoNuNDH3kAznsMe+hJskk0bLK3m7IEcsM0QLhopD2sR4upuyl3Wct2li/vTRflVbgadPp0zk6YCtZGtP1MqRpaQP0MPoIswH0+c6KTKe3mtvqFPDzpnSGMbnetGuYZKGTUfYrVJxQq4mJqYTyuN2qkQH/E2s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by DB9P190MB1817.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:33d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.16; Sun, 18 Sep
 2022 19:47:25 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::75d9:ce33:75f0:d49f]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::75d9:ce33:75f0:d49f%5]) with mapi id 15.20.5632.018; Sun, 18 Sep 2022
 19:47:25 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: [PATCH net-next v6 7/9] net: marvell: prestera: add stub handler neighbour events
Date:   Sun, 18 Sep 2022 22:46:58 +0300
Message-Id: <20220918194700.19905-8-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220918194700.19905-1-yevhen.orlov@plvision.eu>
References: <20220918194700.19905-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM6PR08CA0006.eurprd08.prod.outlook.com
 (2603:10a6:20b:b2::18) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXP190MB1789:EE_|DB9P190MB1817:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c1a2b34-c027-40ba-0cc8-08da99ae9c36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l6qMXccft1uDVns8Jr+HbfPuwi5IhZdrS4L/aULbq6/rARZbStzfspU0OeKo60b3bGT5Iub03QOQI+ibMgKt7wZ1znpACAm6UrYswT5OQU00KbED9jHU57tt34ytxS8WN4wNEI9o9o3AkRXRL9ytIs3seYuujan25gTyfWZ39o22dsVM+aPZtHu5wZuruBFIKWiCfUBi21pGAXhDpDU8lxli3nIzBso5JwXI7B9KBfSHGtXNr6r5zzdDlVXqR2hOScVc//qIh3+Un5Kc49WIt43jqS6OqBPVAmP6De/k3TGc2VAi0Xd6KAE/zQFv5d2He7WPuZZLcGFJ7HrTtzC0f73Nps9Kv+9Axy9ew7/RFyaAGqulLVKviK2JHj1xK3F5T77duJsoRbSQY8wRkJzY6/9a+WYx9rFUbME8kvk2sEdQAhtD4CxXGssG+1Gdn6Z/ByxzeYwRhj2/49gzthTN7SwZTbA/cf/XSHY1HF5QKyjwsN14WqvRWW/ckR+B8BDerv928VJo9vYrlrNd8biD2SKFn1vIT1ES+1iOhhCot49yxw7rVGk5qcaRxRnPCLBerDjPVVfyhtOIVf/36YO2vHpb2Z2yjA4TrT4x4GMbrrybyCo5730ngqo7Ld7RBe/jb1PQ0fXxgj8bp9h/oXJU8Do/HBlN8afc5PtN+h/7eoUv43iQ7WTsZIxErCOUY/oYnwgkSOyG62ZOXSNA7Enx2ALNiWQNC5y3QJRTDrsyn1yx9UQZilCqSmiZPWOFAIMn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(396003)(376002)(136003)(39830400003)(451199015)(36756003)(6506007)(26005)(52116002)(478600001)(41300700001)(54906003)(6916009)(316002)(6486002)(107886003)(38350700002)(38100700002)(6512007)(186003)(1076003)(66574015)(6666004)(86362001)(83380400001)(2616005)(8676002)(66476007)(66556008)(66946007)(5660300002)(2906002)(7416002)(8936002)(4326008)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3LI227pi6ag+nhrXsqQpoW3csRGXtk+AkRfwx6//bDCveL/1HU4XDq0x76YS?=
 =?us-ascii?Q?R/IJ7DaXvRaYZxmSBukl5Pt0lNSEpRQkhSOhlB6C+ie8z6ylJ3nQlVan5Bqo?=
 =?us-ascii?Q?0OeAMBLrfQFKbjze3cD2JNOzQyDFsEplZmb2vdaYFc0/BBcy8GK81CvM/AJQ?=
 =?us-ascii?Q?800yilJBKsnKHv0Ip7BnIdFB+yvnYKf7Qo/BAgbvebx6f9hb8C46m/5oRUAh?=
 =?us-ascii?Q?LiZx4vh50dZK9O7bsMlB7T49TXZySqnqxDctQLIJoStRc2qvZk2Cs3VrcZs8?=
 =?us-ascii?Q?cZYYfXlvnbs0tT5ZpXGFLOSwM6P/YF8Tpr5pH2evXorV4EWkkBmLvkH0R+Dr?=
 =?us-ascii?Q?BoK3cl7vr5GvA0PbmmqqiPQUYg97Y0CmO9DnDUgaiTajAQ21AJL7r0feVZV0?=
 =?us-ascii?Q?Xe34AdleVy0JTZrYYMEZvBdrGv8ID3gnG9BdP4Mgxnhra2j1+2zLUyqY2X7X?=
 =?us-ascii?Q?FIgXSiINcs3dgEVUtcao+qwJYyUoV6GZH0Et/U6/8/Hz1hRifXDkmsqgO+F+?=
 =?us-ascii?Q?/06T5QxZtdaKAMI2o9lnuNa3xy48S0Wxwp3uYGNWfQChtLyLbam1CvSnY8HK?=
 =?us-ascii?Q?+NWX4xYmt1kyZwu/QoKxf5YFdHstSXL4C+EmzzwWIKq8aabcRovycIAQHkc5?=
 =?us-ascii?Q?fn3Yk+Sf8DiNJRFPNi+oOhTchvRhIdeRJflP/J8kvlZj9t4fEU1+S2YTtWqY?=
 =?us-ascii?Q?ySLpAwIm+uF6VJ3aL5RqX3YFLqrckrlIPTP2bAv51CSjBBiBZafHnL5tpxId?=
 =?us-ascii?Q?AUi+Ln+LonF8q0wl5NRIqO5wClRI59C04oaLKoJDpBdjtWdZ53S/8gzadVWC?=
 =?us-ascii?Q?WBfBymSO1gOvQ3esfz4QMbLjJaV3l1DO5sywDfvZTwGy+OV5Xq4g8CyFZJMx?=
 =?us-ascii?Q?u5a1TMxs9F/0xp3s09vMILjvLr+J4asndodEAZrxKLi2BdxaFkswYWQ43z5j?=
 =?us-ascii?Q?znfGaZyrWlg+Tm84sBl56vCK5hTPZsENeRGkVOQPWe8dbiVbmk0jXJfUwEl4?=
 =?us-ascii?Q?lCiZzxDpgb9TI/lbwP84DpEowY0q0mZGk4hPNTPytx11ZawefXrV6bxDGIIh?=
 =?us-ascii?Q?AmRlFHL8i4dsy+Ge9fad6tGq8FJeLWr9Twq2BFgpti1V/H+1gjGWDO15iJoF?=
 =?us-ascii?Q?ymuos/hPnWvVSgPE7DMjqI/YSzW5c/2qWTn+dHMfPUrRVNAhJc8mEHWwYCys?=
 =?us-ascii?Q?6Mw8eccQiSVdTsRorxTc15QmMnjIvhwtRDbhiXkCZs8xbl9007JhHIIxKcsj?=
 =?us-ascii?Q?tcRjVdBqVWtYse45IFO74oyZhKgnJYaj2c5aX2QyxjRUiAosDTyqMBRIa1+7?=
 =?us-ascii?Q?VK1hydVUN8QEzyRl0tN/chPA/Zi8XNxHu55Z4IHvzz1GWU1l6fReuS+bo+hA?=
 =?us-ascii?Q?NSxckP6vM/BhKFsfQmgWa9ULUzTLKXGD8nJkVEfMuiKYwv3sz71eHP61VBRu?=
 =?us-ascii?Q?Do33cQ2HIS8fXotN0kd2AZTZoRjiBqLsSVO23PZ1NRgWaaTX/lacyRrvClRB?=
 =?us-ascii?Q?nym5ivuPOTMBzJ7BnAXWrNXKDdXlb9wGFaZ146TRL9p13zroLGEbOLZaCE6Z?=
 =?us-ascii?Q?iHvXH6SuwzDyekjFkJHxT/4WGwK4zShahsZfJuuEDeuW598on0i3osHPLqty?=
 =?us-ascii?Q?nw=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c1a2b34-c027-40ba-0cc8-08da99ae9c36
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2022 19:47:25.1899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GKgTxFME59UUmTbdqfNJavNlKzTZGWi2tl+iM9l6k1Vt3jky2D0MR1I1j9S6R1psX3YEeKly1XHewCBl3FgRyiRx87afY/ld4nhwH8/XlrE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9P190MB1817
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Actual handler will be added in next patches

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 .../net/ethernet/marvell/prestera/prestera.h  |  1 +
 .../marvell/prestera/prestera_router.c        | 59 +++++++++++++++++++
 2 files changed, 60 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index fe0d6001a6b6..2f2f80e7e358 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -320,6 +320,7 @@ struct prestera_router {
 	struct notifier_block inetaddr_nb;
 	struct notifier_block inetaddr_valid_nb;
 	struct notifier_block fib_nb;
+	struct notifier_block netevent_nb;
 	u8 *nhgrp_hw_state_cache; /* Bitmap cached hw state of nhs */
 	unsigned long nhgrp_hw_cache_kick; /* jiffies */
 };
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index 15958f83107e..a6af3b53838e 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -8,6 +8,7 @@
 #include <net/switchdev.h>
 #include <linux/rhashtable.h>
 #include <net/nexthop.h>
+#include <net/netevent.h>
 
 #include "prestera.h"
 #include "prestera_router_hw.h"
@@ -610,6 +611,56 @@ static int __prestera_router_fib_event(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
+struct prestera_netevent_work {
+	struct work_struct work;
+	struct prestera_switch *sw;
+	struct neighbour *n;
+};
+
+static void prestera_router_neigh_event_work(struct work_struct *work)
+{
+	struct prestera_netevent_work *net_work =
+		container_of(work, struct prestera_netevent_work, work);
+	struct neighbour *n = net_work->n;
+
+	/* neigh - its not hw related object. It stored only in kernel. So... */
+	rtnl_lock();
+
+	/* TODO: handler */
+
+	neigh_release(n);
+	rtnl_unlock();
+	kfree(net_work);
+}
+
+static int prestera_router_netevent_event(struct notifier_block *nb,
+					  unsigned long event, void *ptr)
+{
+	struct prestera_netevent_work *net_work;
+	struct prestera_router *router;
+	struct neighbour *n = ptr;
+
+	router = container_of(nb, struct prestera_router, netevent_nb);
+
+	switch (event) {
+	case NETEVENT_NEIGH_UPDATE:
+		if (n->tbl->family != AF_INET)
+			return NOTIFY_DONE;
+
+		net_work = kzalloc(sizeof(*net_work), GFP_ATOMIC);
+		if (WARN_ON(!net_work))
+			return NOTIFY_BAD;
+
+		neigh_clone(n);
+		net_work->n = n;
+		net_work->sw = router->sw;
+		INIT_WORK(&net_work->work, prestera_router_neigh_event_work);
+		prestera_queue_work(&net_work->work);
+	}
+
+	return NOTIFY_DONE;
+}
+
 int prestera_router_init(struct prestera_switch *sw)
 {
 	struct prestera_router *router;
@@ -648,6 +699,11 @@ int prestera_router_init(struct prestera_switch *sw)
 	if (err)
 		goto err_register_inetaddr_notifier;
 
+	router->netevent_nb.notifier_call = prestera_router_netevent_event;
+	err = register_netevent_notifier(&router->netevent_nb);
+	if (err)
+		goto err_register_netevent_notifier;
+
 	router->fib_nb.notifier_call = __prestera_router_fib_event;
 	err = register_fib_notifier(&init_net, &router->fib_nb,
 				    /* TODO: flush fib entries */ NULL, NULL);
@@ -657,6 +713,8 @@ int prestera_router_init(struct prestera_switch *sw)
 	return 0;
 
 err_register_fib_notifier:
+	unregister_netevent_notifier(&router->netevent_nb);
+err_register_netevent_notifier:
 	unregister_inetaddr_notifier(&router->inetaddr_nb);
 err_register_inetaddr_notifier:
 	unregister_inetaddr_validator_notifier(&router->inetaddr_valid_nb);
@@ -674,6 +732,7 @@ int prestera_router_init(struct prestera_switch *sw)
 void prestera_router_fini(struct prestera_switch *sw)
 {
 	unregister_fib_notifier(&init_net, &sw->router->fib_nb);
+	unregister_netevent_notifier(&sw->router->netevent_nb);
 	unregister_inetaddr_notifier(&sw->router->inetaddr_nb);
 	unregister_inetaddr_validator_notifier(&sw->router->inetaddr_valid_nb);
 	prestera_queue_drain();
-- 
2.17.1

