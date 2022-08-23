Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 825C559CD04
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 02:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239009AbiHWAMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 20:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238934AbiHWALw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 20:11:52 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80134.outbound.protection.outlook.com [40.107.8.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37FA34DF28;
        Mon, 22 Aug 2022 17:11:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b6Hg2S8Kyu6y10wXr4Pvu6Dkyo1LiP5l1tnFdp0j3MBMw822G9Wz+XjGDgD6rcVlodPm26VuolsXaSNHsWBIZBUtZH3VXazzHFTxXgtPCcGU58zY+jo4NI0Ztu4sdbZgU9HlfV9A8iwSgGbh5IjjOMpwY3nBFk8Sp05MLfaVpxu9pn8Eng66QTvHm/DQxBNaeIAwkeAF+JhjU5d8E9zj2kJsbHDx+cLik2vvhnAGzmex/tIH8O2dSx7UdMVoo4S8xwtAih/Xbk92S6oZLt4N6WfYnKHH3l42PSlucV1pT1pPKlMk/kt+fpezqxV0oUkLJjhTAMFjqtJvGYZ8O9VTgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+etz4aJkM02ShsJOGgDfk/D/cDfGNxm6J2mVfsrPPWY=;
 b=hOSw2ORuBqBqy5nvrcC0xinKUJdqCIxZGSblBWnu6H9MzkFc0gZfvk7W5Olr93UOoNBV1RdaecN3atQaoLplBgHwjXjcyMz3iiy1smJlui9+2PrqgJHZVnMXuf/0hWf+juuaWxQ/NiQI5kI2ZvDOoH6vy0pU2jJyaVJmgzd3Z0j84sKx2Y9AVpJj6rZ8SHg5ca3hZ+a+AKFKj8o2I4JX6M6XPEWxWKtGUCOWgcmNNPYo9MXrUS44Y59iFfjXmpI//4juC/NGWi7bI0TXiAgtANgAL6PMjseAXrPsw321Efhxc0lkm1DkhnUaQpXPosZ3GutexsJ+UVYHJhY8TvJvvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+etz4aJkM02ShsJOGgDfk/D/cDfGNxm6J2mVfsrPPWY=;
 b=W1ZCsYe0Ba4r9XYkP1HlYmFzbvFnoRntxq5ylZVoAzmXXL7kOXKpALEKttev+4TchWUUJSI86mLKgJnbly+85u26kgu8rfqdw4pFu14krCuqqpFPsvRZGwrXGiySGwxqlppO9odTDgmY7xLacrRGE7OvK03tiaPMYH7mAdfnvEc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by PA4P190MB1072.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:109::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Tue, 23 Aug
 2022 00:11:34 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::6557:8bc5:e347:55d5]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::6557:8bc5:e347:55d5%4]) with mapi id 15.20.5546.021; Tue, 23 Aug 2022
 00:11:34 +0000
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
Subject: [PATCH net-next v3 7/9] net: marvell: prestera: add stub handler neighbour events
Date:   Tue, 23 Aug 2022 03:10:45 +0300
Message-Id: <20220823001047.24784-8-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220823001047.24784-1-yevhen.orlov@plvision.eu>
References: <20220823001047.24784-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0022.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::10) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a77fdc79-240a-4f0b-83dd-08da849c09ce
X-MS-TrafficTypeDiagnostic: PA4P190MB1072:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y7LfYXF+FYvczpCeH0VGqeIJoarkyRY2CKdYV7crGhl3buIUTjd12Qcvdm46uCQM0JnDILrSp6FOWBCOcwiGwvd95Rb7BsRdqBvHpD9/Zliw3G4JD5wIB8sEXwzojfw+NR4o/vO2GkJGaaUCIxGUlCgQF92xke3WKq2KR4WgI0k11ujpIwbTmUjUl1pJeLoHqBU7cF31RYIKpNSvXGOKzuGu7ocVsbbkcgzA4MJY5Z7A/EdNVH1NZM6yipiunHP9Kf0Y8a8lhXYyfwZ1K79mIlQQEyF6ZK1sKkKojpdZTyNchmhXjNahjqDeUBcKSb6BLp+s3PUAVPjACZglxdC+L/yfQXTHfHTVtHp8r9L+ZAN1AtysRQAJXY/SsOPPis4zoSy3Uk8hq+RXADphD2Ws22BKIXLZLq6HfRMmVcemxs1+YVh+DseCpoSnIKmiV9vZmGXALYY8dtQ+oohZOjNz9OFWZy/saBrQliQLtDX+pKSiyf5wH6as8QfgZNoB07R0kNr7fqOEh/GM7BcIuhousKBl5BrqgIMBu6FdYZtHXXRiYZppS2n9tGSebo13+ks7Fk/gq4nXS7KqEEqih0w1wcfQxgFtl4rJxDt2dJ0vC9nZtlHu+/sbTHNmrmoFYSp7up0qPnn/iZnlgBweYZNzUigieWAqhrCW/O+Jwt+VJArv0ScYTo1aUsqXNUplCvKCZ1o3E6g7wO4ARDsw2dx/3rrt3GRdPHXLDwByFW34E4BJqiAAEHZXxmd5QF5mI+4Q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(136003)(34036004)(39830400003)(346002)(376002)(83380400001)(38350700002)(38100700002)(66946007)(66556008)(66476007)(8676002)(4326008)(54906003)(6916009)(316002)(2906002)(8936002)(7416002)(44832011)(5660300002)(107886003)(6506007)(26005)(6512007)(52116002)(66574015)(1076003)(186003)(2616005)(6666004)(41300700001)(41320700001)(6486002)(508600001)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dT59AGoj6qFYwYzzcqCMFy02IBgsN0nKhTldmKBOAwgLzd2ckwOeOVvqMqtL?=
 =?us-ascii?Q?P/BDcJDyhCYLSLiQNpRIJ9ED/Egum9rvCbaF4TL/1kyAEF5x9GRYbd1moJtI?=
 =?us-ascii?Q?mErwO9H5c5ovR8vT5dJgJYMrGp3V/xMzSdZAIaqlaEI9px2YPCmRu6Rlfqin?=
 =?us-ascii?Q?aHvHlGfy1h1K4Sw2E/1+Ji8zKFtwXBqjb+u1qmaJQhz7EgLWIPOW7aeDeNmm?=
 =?us-ascii?Q?zVnFM1EbwgoXdzN4aKCFODoYwG9gaNc+BHByVw1qebNRHRQuA8VQbKHaSkpP?=
 =?us-ascii?Q?WYsjRoPixo7sSjoOmqJUFAqiS/Rw3GTCPFE6M/fBkDorzCd9XmKya6LZU2MH?=
 =?us-ascii?Q?r5Fc+8f9JCwh/O+Xu6jYrnQ6FL6A7aYoowkqAY0rHXHqER6fEyFvniLKsAvo?=
 =?us-ascii?Q?yv5Yl5VIiUk+lKxzL2NW5mB3bZNCYJlN/GIK3PEhPVkTX5DxhikbE9Mx2bx6?=
 =?us-ascii?Q?4AOJWDw1C1Mco6rLXef6+2SnOWajC982goSZyMv9ksvXpXneRPsnyV1iuc3P?=
 =?us-ascii?Q?qSryWLovkwRMlETSGtN1MN+dAR7hKrwOiKzmWltAlcLtrhA9KzBPj5He1Zsq?=
 =?us-ascii?Q?Pkisgz2S8DXWWDBNnUXrfdgy4NorblUVItexOB+4Xv/XQVhLIWO+WCuGXM09?=
 =?us-ascii?Q?Jqr/VTIKBK4jea+YDqYqK15jL5DzD03dysHN8ruy5CeBJxAiGJlA1mkcS9O2?=
 =?us-ascii?Q?1iFE63+evHnPZumRqHs7n2vmWQy0KWaybsAVLJTEuIcKlDUX1UXRUBkCg5+I?=
 =?us-ascii?Q?waFkAZyJxRyYH21ivY9lbNKig82ZyZqq6QqeG08naB0/MA9DIr26zmq+GjQM?=
 =?us-ascii?Q?qteqzC7kL+KgB8lPBjDVi4muKJmmBaUAbPUEtJJiX0rRUcZsDDdCXaG++EYA?=
 =?us-ascii?Q?cf/BuRkBdKwfo9GqJJxSlMP/C2UqV8lFcMqbGQj+RisnHpkNfSjDlOXXQKYL?=
 =?us-ascii?Q?Hk/l0qfZ9EgPt1mt6v/uqfgSYTLS1L5SzZbM8a4uKg6eftG8sRO6BgP7EnGl?=
 =?us-ascii?Q?afvDHrtG/l0To/x2fRYs7gKzwCFgSxhYrErjcUhezuKTj4m9Pn4coBIeyQjy?=
 =?us-ascii?Q?O9AcwB5pEte92CN+wpRoWUJjYdPsZTuch/5D95jPoQzIU6NWZuFfH3Y6inXH?=
 =?us-ascii?Q?pIYWRtwzPvrrmoI/n0yaXORqkMLE3/mt4292y42/pEubma+c5Xkz8LGNN+i0?=
 =?us-ascii?Q?rHoeMxm9l47sQarGvaik+47d/ryE9+vUyz1kcqjVevhphD+uyNof2gFZOn1Z?=
 =?us-ascii?Q?V4eboxXT21/g+pgwwCK/aI3eiPEeWMmIa58lNW/C/Kx3WQGtc4T7KiQ3FF0f?=
 =?us-ascii?Q?48bZ1Nt2UagOSbplPTKf6qL6aoT2pFHXkeSV1JvRnrOBxD3/nFf2ODet1pdI?=
 =?us-ascii?Q?Ctwx4scuC/ANU/bbpKxyeipRpWyWKVl7MvRkVEdcncEC8+wTkRbnmaM6MhLM?=
 =?us-ascii?Q?Cres8pNzLu1QEymvrw/LzIP9fylpMDu8aJmMOQP/KmGi8/9+eo7NlTbVnVrL?=
 =?us-ascii?Q?o8M7ibVdY9l3CufKp1oAz6tR3pBweiG1a/OFmoY+g+V+eieky/FYJcRQMvIg?=
 =?us-ascii?Q?E9754FdJiquZC8OYuvXAcRf8faonJLWy7jevgO/vjWphZC4hBQts7zkSXMNs?=
 =?us-ascii?Q?6Q=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: a77fdc79-240a-4f0b-83dd-08da849c09ce
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2022 00:11:34.2046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LZYEyeeT+uTTtpCR8zepopHSNdjkEkzphIxNAdLejMk+OBT8awWzUXZJnJ1QVllaBTNm72VZzY8QnDIdTdMnkI6mp6N0PQ/+7Vy0wLoBjdE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4P190MB1072
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
 .../marvell/prestera/prestera_router.c        | 60 +++++++++++++++++++
 2 files changed, 61 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index a3a112f5c09e..33a0add529ba 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -310,6 +310,7 @@ struct prestera_router {
 	struct notifier_block inetaddr_nb;
 	struct notifier_block inetaddr_valid_nb;
 	struct notifier_block fib_nb;
+	struct notifier_block netevent_nb;
 	u8 *nhgrp_hw_state_cache; /* Bitmap cached hw state of nhs */
 	unsigned long nhgrp_hw_cache_kick; /* jiffies */
 };
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index 89c72b9ede55..3e003b991a04 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -8,6 +8,7 @@
 #include <net/switchdev.h>
 #include <linux/rhashtable.h>
 #include <net/nexthop.h>
+#include <net/netevent.h>
 
 #include "prestera.h"
 #include "prestera_router_hw.h"
@@ -610,6 +611,57 @@ static int __prestera_router_fib_event(struct notifier_block *nb,
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
+	struct prestera_switch *sw = net_work->sw;
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
@@ -648,6 +700,11 @@ int prestera_router_init(struct prestera_switch *sw)
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
@@ -657,6 +714,8 @@ int prestera_router_init(struct prestera_switch *sw)
 	return 0;
 
 err_register_fib_notifier:
+	unregister_netevent_notifier(&router->netevent_nb);
+err_register_netevent_notifier:
 	unregister_inetaddr_notifier(&router->inetaddr_nb);
 err_register_inetaddr_notifier:
 	unregister_inetaddr_validator_notifier(&router->inetaddr_valid_nb);
@@ -674,6 +733,7 @@ int prestera_router_init(struct prestera_switch *sw)
 void prestera_router_fini(struct prestera_switch *sw)
 {
 	unregister_fib_notifier(&init_net, &sw->router->fib_nb);
+	unregister_netevent_notifier(&sw->router->netevent_nb);
 	unregister_inetaddr_notifier(&sw->router->inetaddr_nb);
 	unregister_inetaddr_validator_notifier(&sw->router->inetaddr_valid_nb);
 	prestera_queue_drain();
-- 
2.17.1

