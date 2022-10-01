Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A95C5F1B6E
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 11:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiJAJgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 05:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiJAJfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 05:35:25 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60119.outbound.protection.outlook.com [40.107.6.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55A3023BE3;
        Sat,  1 Oct 2022 02:34:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WEHyBsaNp2K1yj20heiXWqPN8RjETSRzwxxL6YVTH/KVt8cS0WFotj8cLGH40U4eZ8GsccKofguahe/z5lG9s+w55d3hJxMR+1XZAjnTG+n7/vx7xC57BtD7HOCLUD3fRk2MPRI8mYt13tugLZS6Q6SynDunbCc4hsNjTh5ElmCrwzCxNs9bCeD1C0xl90GlyPiqe7yX1OTcq+54SADwPMOAtVk+BBRon8Te4TEdjfM8C7lcUbPems11vHAzXWBRovbC8jZI4dkDI+hdmPv1JHj3t/G24zFE/5ek8Cxg89pFNcd3r6EPsvogcE9Hx27J/sFHLB/0KWQNs+8C414lOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T6e3u6Zub7g0vTlYYzSVaEq2IzHKnUwArZ87fFn4lFw=;
 b=KGYgFdJ8GOgZ/z8RRo9h7g2VmoMg75LHvL4fBMox4yByyEL0zfV8k83P+pPVwIfGFP/lUbSIoKFL94Lrs9226J0jlZmerPLJoXxBS8IxMPxZCy6Rz3ZNNhUufxHh67mxVQiaaOZHfPeAOsi5l8We4BgHwoV1Wdv1uBzMe9z5S5ijz2SfpSEaig4Va0uuWmc1ph2HiAyHH6MIPbnnVLJR9FM4a11g53NW3j/rXJ4OlZwVJmQFuczEdgn5GquNyBuXKvOXwx7Lk00qJremLCAjosBmS+4b7aX2Q49EGGn7oF+OPL9Wzv3unLdCHH9w00f+yI0R9cX92Rbpi+EAOXRIwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T6e3u6Zub7g0vTlYYzSVaEq2IzHKnUwArZ87fFn4lFw=;
 b=T9jXgnDH+dM/Ig5fmYLTaANFzeiLgTR2LKAohIFV5S0pDBRn2eS5CYerDpg+rIJDPf8LG9hjH4/oLskTiM3TGzdug6RmGArLUMuE9YUOTTd5c8P2YVegxu4V6d3zpOX4PTgIOpS9zKvcjdzzzyxCJQhKZa2zlcmlfm0U0u4NAeQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by VI1P190MB0733.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:121::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Sat, 1 Oct
 2022 09:34:35 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::8ee:1a5c:9187:3bc0]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::8ee:1a5c:9187:3bc0%2]) with mapi id 15.20.5676.024; Sat, 1 Oct 2022
 09:34:35 +0000
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
Subject: [PATCH net-next v7 7/9] net: marvell: prestera: add stub handler neighbour events
Date:   Sat,  1 Oct 2022 12:34:15 +0300
Message-Id: <20221001093417.22388-8-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221001093417.22388-1-yevhen.orlov@plvision.eu>
References: <20221001093417.22388-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0696.eurprd06.prod.outlook.com
 (2603:10a6:20b:49f::13) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXP190MB1789:EE_|VI1P190MB0733:EE_
X-MS-Office365-Filtering-Correlation-Id: 65c4dfcf-80a0-4469-6372-08daa390273f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zMXVdqzx9+lJR7+9qiFTsDwpigLmhVIyuz0yN9yaTSmr6kHKF/OaToXA91WIwR4F2nmtXizymaNWgEM3DYPDACeWXJAVLejGi9/Duxnv7rsDpQbIYwwrN8PBORlDILAqBVOSZE+pj5Fc7o/TXGC2J3R9A3G3W5APsxOwyUhEg1zQjqbDPMyAM5vUjoOZqhYG2WBH1kGQTC7mx7PqMozvW8XM+aL0m/Yw4hNtdDjl6QXrFAjr8ElyTKsRCnSldJ0wvOlMKqRT8x5lRFIccZOWPcLTb9678tqwS2+UzGHnRnfcfylUyLgRIJLJfrxTnqpJYDSx9IFM5q1MFTpROjdmk1YtpihBvr989MOpBFgH6o9IH+smh+GBOo/OY3sKQPPHBVgSHLejzCdGimk1IjN7SvZyFtBFFpBg6BS7s8aeDQ6KF4pA+jUx9qhsJFx0u5ld80/UjfupYKNYg4YVEKNiDdwwWlj8uiKfqggwNRtvSMIhNdMR/U00K3wAQ+1rmXSX9AVwYOdjU+ujRY4NZ6AdwF0ja5m9K6LGlMLCXgLyY/ZXNpAfZI1308bd1eLKnl+OZPFsFC2ujRD0/crSEH+fjP6fOVWFumyUmjM/EZ3ZObHa7DQb3Ntp0h7ZlhSEGqJEIkwOwe9kn3cCAWLtAwwkFt4PLevjuiA6+RX4DTcnaPKjsmDbwQIO9Khfj5RxLECLh9oKilJnhLBqLIzdS5O+qXNgsrT3cOfqfp0CMEnRzrVkf0/7EHJV6VzELbWb3JlG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39830400003)(366004)(346002)(136003)(451199015)(66574015)(38350700002)(38100700002)(5660300002)(86362001)(26005)(7416002)(8936002)(6506007)(6512007)(36756003)(8676002)(52116002)(4326008)(66946007)(66476007)(66556008)(6666004)(83380400001)(107886003)(41300700001)(44832011)(1076003)(186003)(6916009)(2616005)(2906002)(478600001)(316002)(6486002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cZf+DVBrwhK8QPIMYfKq0DmJaJTjiO6qCUHyHUf24w2MM17hTLTspN2AG1aS?=
 =?us-ascii?Q?O25eTrg45bEEjssa4U3i9Z/XSh17s2bJx6P6Ba8ZrqnUEP0Rd/iDmua1w5Gf?=
 =?us-ascii?Q?e0Kwx2yzoqvwgkC124ZgJ643xKEvS07MtohFY6cdlVvWA9NhFTObvxeqQvAp?=
 =?us-ascii?Q?ClGdlHHpjXdMsJODJlzWksfo1LI/UAjucfNldal77lPNUrR/vGiGTIECFFIr?=
 =?us-ascii?Q?wUt/njVBPU5zxMhNNZBHk1fFL7b8DT7pFY28ZVQMkZxSkWzc/b03uyncAfrG?=
 =?us-ascii?Q?M4/aFLi4ULG0fqMRLUe3rhhQBX87OZgdua4Bq1WzEVU2+0Y2+IRevW3QMvRF?=
 =?us-ascii?Q?rD6diYkPIHw0DBa7WAxBMPP04F0lkvNoppk/WHubV3HKT8CD3uvvEC85b7ds?=
 =?us-ascii?Q?JSYqOvRkqXoAzAPa0wE+SapvCc+u55VN/LlxKk2VXKNtNdSbHFFoJOAAKAZ9?=
 =?us-ascii?Q?OPyi4UXjZBIhkt07+uQE1CrhemftibEkYGZW7Cjly8GMPMU3rwzCQ2Hdcqf6?=
 =?us-ascii?Q?d2Bfm4/4XEk5NkznJGmIk8m1nCQ/9dLelROttLs48r+14x+CpOl2LUChWZ0g?=
 =?us-ascii?Q?K//kArDnkyXu0ecfdUZFM4gEDnRfE0NIBUwIcM/nYNdAKnKFSRqqsWbl81Sz?=
 =?us-ascii?Q?VEfHiXYOMJlo24GLRXCjrMO9vRDHNKgPFo8w6Rm1fAwFu6ywCLHXRJ5WesY0?=
 =?us-ascii?Q?X7gxhs/GXnCzw473SO94uTZbt1NKg/NnTx29Z8MlAnqm1cG9acy/X7UPJDaR?=
 =?us-ascii?Q?ITlKLaFDlt05cMZ28wS7bDsHhCWoYP/yn4h19dQcAxvY0AKuaLd5Ue64RzmI?=
 =?us-ascii?Q?lr+7vEOhX3oJqVgVJIFSYqOrRTOAg0QhzgNkZGCwTo3knOxSQsPAtdh5Ww+Y?=
 =?us-ascii?Q?Ek13fujOarf+moglSgzcf152/WLUYgQklKWJ9tEl/qlBj+JsGe7/9Is5r1n+?=
 =?us-ascii?Q?PQ+mXzYLYhULppZt2YbXOaZW8QYQCE95Nko0gDoJsf8ag+6aUQS8k2J5FtuI?=
 =?us-ascii?Q?RN5CuwfFZhL77MRAveaKF4a8qJWJV/R070cmqgW7eFEdJmwEQQQX70Bh/3pV?=
 =?us-ascii?Q?1GRH11WXFYpmZDKsOgIr5C/hMJcLvy1o0Ov7aMJzGbBRI9Ha8KJMYMi9Qqp8?=
 =?us-ascii?Q?UeWXzFNgoiKu39QXzGI8XyAMs4RRfJei1VDpUmRzihBOPvHKBOxS3Z45ra4f?=
 =?us-ascii?Q?Dr0FcqbZZfa7mdwXpy//gzyIFtdBWMWdihxo6OHJbRlgV13QppKCOflOh2+/?=
 =?us-ascii?Q?1AnQdcLebmVFBMLsIMoR4WuVUt+DIHfsQhn/RGkd4+xdriL++QR/dfkAkLDn?=
 =?us-ascii?Q?cwQB4bW6PGEtx9tl4mxVpxFHJSX/I+2jWzNS2esHnVOzAaVhK6NYXw60lYO+?=
 =?us-ascii?Q?tZxDughr4gcTuhqnjz97ecadF4WB4mqu63kVu6vDy5y+w7YdGE+vlpMqL8xb?=
 =?us-ascii?Q?L31OI1odh/uyBWL4w/KSYU++fOtX39wt43Qgjcb53KQRvqQ70iDuWKYLNUPM?=
 =?us-ascii?Q?cuaRp8wBkmrYKhK2EtnJmrziJLzxs32Nfs+sWmJg8+a83P4XZdgayxyWrlD9?=
 =?us-ascii?Q?z4dlgUp2629W/BX18+4lTYD1Fq2OEj7cIkYrPt0mFhqqioDBBsFTBUM6FcsM?=
 =?us-ascii?Q?EA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 65c4dfcf-80a0-4469-6372-08daa390273f
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2022 09:34:35.6523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rsrDJiu2ahbJqHkOdx2pQVWRVm1EK5vsD+KimxWixUW6ocEoYOC6Bz9VPlOFZrt0vBJYOxPlpvjeYjcLGPFf+NJo1oIDTO9EvP1qZyyaIoc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0733
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
index 607efd481782..d31dd1fe6633 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -8,6 +8,7 @@
 #include <net/switchdev.h>
 #include <linux/rhashtable.h>
 #include <net/nexthop.h>
+#include <net/netevent.h>
 
 #include "prestera.h"
 #include "prestera_router_hw.h"
@@ -604,6 +605,56 @@ static int __prestera_router_fib_event(struct notifier_block *nb,
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
@@ -642,6 +693,11 @@ int prestera_router_init(struct prestera_switch *sw)
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
@@ -651,6 +707,8 @@ int prestera_router_init(struct prestera_switch *sw)
 	return 0;
 
 err_register_fib_notifier:
+	unregister_netevent_notifier(&router->netevent_nb);
+err_register_netevent_notifier:
 	unregister_inetaddr_notifier(&router->inetaddr_nb);
 err_register_inetaddr_notifier:
 	unregister_inetaddr_validator_notifier(&router->inetaddr_valid_nb);
@@ -668,6 +726,7 @@ int prestera_router_init(struct prestera_switch *sw)
 void prestera_router_fini(struct prestera_switch *sw)
 {
 	unregister_fib_notifier(&init_net, &sw->router->fib_nb);
+	unregister_netevent_notifier(&sw->router->netevent_nb);
 	unregister_inetaddr_notifier(&sw->router->inetaddr_nb);
 	unregister_inetaddr_validator_notifier(&sw->router->inetaddr_valid_nb);
 	prestera_queue_drain();
-- 
2.17.1

