Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 997BA5B29A6
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 00:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbiIHWzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 18:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiIHWy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 18:54:29 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2119.outbound.protection.outlook.com [40.107.20.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA77129534;
        Thu,  8 Sep 2022 15:53:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dlOjkxXxOoIktp8DmjLU3N0YTWuAEsrrsUAGsFcrPQOVXyl8HFS1ovmo18XYMjAqR2buTaeLigxSyrlCyWWpalcYCSEPVoQRkg5Z8HmDGJwzj9aB1bJHXn9WZ81TrRb+rzpG4Lf4u2HKxWXdUsYOXFsTsP4N9J5OxohmaiFbhydVQQQeA9YVDnibZ/Rb9Ak6wv7GmMzn5nH029eZ4/ic8MSlQCoFkYsi7q/YuOGSXEuTLp/+ETCQtfcVjSRbORFjV4OVwZuEkdH6G+YXryh4dk7fz3SbX/JtY8arUX66M+Ue1zbi534gJLiAYbJF7zC+VhCCkOfZVE8bBcq6Hh77uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1FRi4MKdVQKkjAvbSbI8Z4LVY0AcS5GJdL9hNfW93Dg=;
 b=mN/1GpQIm1BnpCZkjj87PdiG+rez09mbmyJ2jIThCvtaFJuYBCCrv6+7pgWcy6XGgHl9eUbEqpP8B9oFfSnQiaMR8DbnGtWFhQPcH6/Y2JmM5O5Sz7I4oKEyC8wiU6/tdu1hb0kcpE9l51r0X3lfB7tETN5kADexXf1lWlU0pthzE/gcBhea+fVbyCcajjL93R23igZuDznSFpMWBzI6NRofqlJZYIpvr4uRg05HeZcFkcWpHGK7D06azyXSQ76BPUvkQlfvnSE4k7XLbqiyjkrDfAZDphUdENS2y3TZQQ1CXznQdm42GpSm8xhB4QWGZwT2ZMt48XSzgaFgEJvGsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1FRi4MKdVQKkjAvbSbI8Z4LVY0AcS5GJdL9hNfW93Dg=;
 b=P/5Ask8K1DJ+Da0ru7TQ3rPPUf5DctRUmQmtaNzMJmWsExGTq3z5XvEo3MS5cV6UBNs37qS/xnTc/6nQfkpe4u/Fjl2H8OhgarSQ6Ol9iiH7Z2HMtWfJNN7tDofA07lScv2k2x/7T6O674wGZd7Sj4WzYcSxjjnU6jF7/HL6nYI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by AM0P190MB0737.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:195::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.16; Thu, 8 Sep
 2022 22:53:41 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::e8ee:18d2:8c59:8ae]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::e8ee:18d2:8c59:8ae%9]) with mapi id 15.20.5588.014; Thu, 8 Sep 2022
 22:53:41 +0000
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
Subject: [PATCH net-next v5 9/9] net: marvell: prestera: Propagate nh state from hw to kernel
Date:   Fri,  9 Sep 2022 01:52:11 +0300
Message-Id: <20220908225211.31482-10-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220908225211.31482-1-yevhen.orlov@plvision.eu>
References: <20220908225211.31482-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0028.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::19) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c7d925d-5423-4a60-dea6-08da91ecf9b1
X-MS-TrafficTypeDiagnostic: AM0P190MB0737:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8ObS+nxX7WLcRwRb643YmTEPlzVEbMcJG/HyNXr2gAuTnhlo2W3Eg53mdF7ef0UpQYUrLmKMBkZ/99qPa/F3g8vqyk+C3jkpz9me8Xy/MO9ALuJlfGvqojU9F/2Yjvwz1RzyOJiSBbFqa7Se9uDI6NuMyzFIhY+UfnH6mc1kPjvS15qnlZCv5/FXxWudMlporgptnmEFAVrnE+JPJEbNAWWDVyv+9NrOTsIJor1My1g+ATVtZTVaGf4d6wNymxJxP3ezU9yP4/HSzltsnx4lNhN4G4nYIQ1b/xfSYkWrFK01V1yGjVJwgC0kvMQIVbdqrlFRSyxaqCLVpvT8/HvotoE7w2AkhyUbAvmgti/isTBM2NYIjR6ti7SA+l3DC2WrcPAfCiusgrO/lMueYfuGb+VccfZap1nK9x2UYbUrcFMZApAiyiqzoZBM59tS9ZkqsTMQ95NBHKz+njD7TOd9SBFMDxR4Jftbg83defv7DSDP+ZaIAMnobT1Kb/07phIDMhY1rIJ6BRJE20/w5cG1Eu0o7Td3E7y6iOKIGsIxQrGzqowrDQwi5GevULTnw8oj7lZxUXakksZzYFS947TKZAfe8/jieQUvrrwpHZYBHGou9PKpQX/ikgHfH/5PV5mc3kNhuXbUDxfjFUM3lTsT0uNeQMxXf8Qfnrd9a87lsym7wAEjLfEX7YJZE3OgZZXVkaShtiRSn5Nj8VyLe9VWEMx+Xcw4rgLIKeb+uNCusGmEBlBNzBvCW+xVsGzeYdR6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39840400004)(346002)(34036004)(366004)(396003)(136003)(376002)(38100700002)(41320700001)(86362001)(38350700002)(66476007)(508600001)(66556008)(4326008)(8936002)(107886003)(5660300002)(6666004)(41300700001)(8676002)(66946007)(26005)(54906003)(6486002)(6916009)(316002)(66574015)(2616005)(186003)(1076003)(83380400001)(52116002)(2906002)(6512007)(7416002)(6506007)(44832011)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uvTe/qsOPosA0HnedMdoZfeHVnxPdNB3jl2wYdcqvnejuB34yzQ5fQD35Xap?=
 =?us-ascii?Q?UNIJl4Xqf//mJSj+tBxCU3njONQWSdZVHDt8BuPq8W8OyYS00g9sRTzGjL9m?=
 =?us-ascii?Q?HSuprzKEm6icyQWPZYdbZUSSzAFpgb30cYtDEkljOA60NSPUrf+Fh437t8/p?=
 =?us-ascii?Q?oARhQlQP4+2EUW/ZvwueiuPabwVQpLCZHqc+8Xz1SJXCKg/JZIvzwvNzqoZz?=
 =?us-ascii?Q?CiD+MPzH1lqcAo59PJW2Bh36H4Vr9Ko+BOUsjRKLuL2ZFu/+AMQaYUdO4oim?=
 =?us-ascii?Q?Dd6F4HxiohiCsiQZbbtpltGl2H3Ii42LLQ9sm6f8bwCPMp58c1+QDR4Mhtv2?=
 =?us-ascii?Q?FTufOVyegCWZJg3/U/uIKiVraKSLaKIkYh3g1NnMFNJUsbKP8d2/fV/BUNNU?=
 =?us-ascii?Q?IvegCFDzbztQTuqhKyK1aa8OdwqgBNcKPED8yBGk5HUx4t274rGeb7DwpKHM?=
 =?us-ascii?Q?TwejSwTFnkq30dYPgK2suZl7KUoNkZksCWVJonAkAjHB1UwM3jF/sglAzR8J?=
 =?us-ascii?Q?TYZqO//VbxW6CxEUtKuOffZS8PO6zU4dFBu4kX0ljrnHGcgD5tRT0K3ZP3Wr?=
 =?us-ascii?Q?v0ZCUgsMie9qzn3rWUI+MEIuPoG0JYDkmqItzpRisGK/aZreUwP94yzBygCx?=
 =?us-ascii?Q?G1P8R12/sNGRdZx49LfH/MjELw+03J6rut5umHx6LVacB0KiLrUvu6NOqMzQ?=
 =?us-ascii?Q?tZhcpOqpRIoBSRaMp59WsWBXbEeWAZ/jtfosqA6l2PAswFcJY76AUvsnk4AW?=
 =?us-ascii?Q?PJJkoyP2Pm8fg3n0glhqc7I1akvMSL5Xry2L+i8NUuT8Op8daar3FaMptB0u?=
 =?us-ascii?Q?/y6Ncd+GSPQtFgJiCPzyNofo1tExvr979v/Q0iJQKk42pMD9A6MdSzBfESVu?=
 =?us-ascii?Q?upjEDSx+NF6SCwX7uOzkePy0dcOmEPnTAB+GBd7+KtDxkGFaLKEG2gyvizQX?=
 =?us-ascii?Q?sg+6HKeD6UZMHJxyieBO7+VJO6Fezrv82C3YXfK/OQxcPRoN+1T9ui1xcUVH?=
 =?us-ascii?Q?BerFcD6cYxanS6ctZsJaO2Uo+S8Vqs76Fkj7rK1OP2htuKOVz9OxGv3oaeXn?=
 =?us-ascii?Q?nURtVTuhVaxlpnWveJaCf8LOvLwhuPviuX3HeWENSJWiHuYElKTXzoFpQ9u9?=
 =?us-ascii?Q?4lr4G7xidrIVMxxHftcWuyfG06wNApjfp4UHP3dwOgsTOd9wRT7JR/NcfndP?=
 =?us-ascii?Q?9nXQti5qfDaG2dD8lapj/GuDH+0VBToIDGskwDn+9qRAPv/oPgf5Km+42Cfj?=
 =?us-ascii?Q?arAQzzKzafbVWHh5DXcwhjhPGKghnugMCEIK41h36h4uH00CfxEfJJ8Kh/gb?=
 =?us-ascii?Q?2G/PyTXW5aGmwhUpfginVnl2m58rohsN1xomDK3pG+b5QQRMsU5OxWYUaevC?=
 =?us-ascii?Q?tkugYkKTLE2F3J6KtE5FN627E7UbldCKCa+X8jJPr3LvmiJeq/C/kkIILJT1?=
 =?us-ascii?Q?IFnJMnU2KnYNHwRPoRJJe8ex+/NgbsXe/LCx0ekrFQ/6t1vKqYmWLCqJaZaq?=
 =?us-ascii?Q?iTJqvXtLFN3aVFovegmJ57d9Eme+N5V3NZKLckzjp09S78jVHLG/FwsOwEeN?=
 =?us-ascii?Q?7Aatz9oQVq2xGQl0zyA8CvDx9mxK3tWRd67cd5IEZwnB6uKnhgm5GNgiFF3L?=
 =?us-ascii?Q?ug=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c7d925d-5423-4a60-dea6-08da91ecf9b1
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 22:53:41.5245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lwandHs6vSVkoB6x5RAn2ZWWIsF9Huv6cKyrvQwZx/coyoTVn/u2WStZRA8gds1IzEY6jgX3/SMQ11BaG/ayvZmW5P2pkzoiHZd8ISOBvqQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0P190MB0737
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We poll nexthops in HW and call for each active nexthop appropriate
neighbour.

Also we provide implicity neighbour resolving.
For example, user have added nexthop route:
  # ip route add 5.5.5.5 via 1.1.1.2
But neighbour 1.1.1.2 doesn't exist. In this case we will try to call
neigh_event_send, even if there is no traffic.
This is useful, when you have add route, which will be used after some
time but with a lot of traffic (burst). So, we has prepared, offloaded
route in advance.

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 .../net/ethernet/marvell/prestera/prestera.h  |   3 +
 .../marvell/prestera/prestera_router.c        | 111 ++++++++++++++++++
 2 files changed, 114 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index 540a36069b79..35554ee805cd 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -324,6 +324,9 @@ struct prestera_router {
 	struct notifier_block netevent_nb;
 	u8 *nhgrp_hw_state_cache; /* Bitmap cached hw state of nhs */
 	unsigned long nhgrp_hw_cache_kick; /* jiffies */
+	struct {
+		struct delayed_work dw;
+	} neighs_update;
 };
 
 struct prestera_rxtx_params {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index ff05e99501b6..0f9e28d60c86 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -16,6 +16,9 @@
 #include "prestera.h"
 #include "prestera_router_hw.h"
 
+#define PRESTERA_IMPLICITY_RESOLVE_DEAD_NEIGH
+#define PRESTERA_NH_PROBE_INTERVAL 5000 /* ms */
+
 struct prestera_kern_neigh_cache_key {
 	struct prestera_ip_addr addr;
 	struct net_device *dev;
@@ -32,6 +35,7 @@ struct prestera_kern_neigh_cache {
 	/* Lock cache if neigh is present in kernel */
 	bool in_kernel;
 };
+
 struct prestera_kern_fib_cache_key {
 	struct prestera_ip_addr addr;
 	u32 prefix_len;
@@ -1017,6 +1021,78 @@ __prestera_k_arb_util_fib_overlapped(struct prestera_switch *sw,
 	return rfc;
 }
 
+static void __prestera_k_arb_hw_state_upd(struct prestera_switch *sw,
+					  struct prestera_kern_neigh_cache *nc)
+{
+	struct prestera_nh_neigh_key nh_key;
+	struct prestera_nh_neigh *nh_neigh;
+	struct neighbour *n;
+	bool hw_active;
+
+	prestera_util_nc_key2nh_key(&nc->key, &nh_key);
+	nh_neigh = prestera_nh_neigh_find(sw, &nh_key);
+	if (!nh_neigh) {
+		pr_err("Cannot find nh_neigh for cached %pI4n",
+		       &nc->key.addr.u.ipv4);
+		return;
+	}
+
+	hw_active = prestera_nh_neigh_util_hw_state(sw, nh_neigh);
+
+#ifdef PRESTERA_IMPLICITY_RESOLVE_DEAD_NEIGH
+	if (!hw_active && nc->in_kernel)
+		goto out;
+#else /* PRESTERA_IMPLICITY_RESOLVE_DEAD_NEIGH */
+	if (!hw_active)
+		goto out;
+#endif /* PRESTERA_IMPLICITY_RESOLVE_DEAD_NEIGH */
+
+	if (nc->key.addr.v == PRESTERA_IPV4) {
+		n = neigh_lookup(&arp_tbl, &nc->key.addr.u.ipv4,
+				 nc->key.dev);
+		if (!n)
+			n = neigh_create(&arp_tbl, &nc->key.addr.u.ipv4,
+					 nc->key.dev);
+	} else {
+		n = NULL;
+	}
+
+	if (!IS_ERR(n) && n) {
+		neigh_event_send(n, NULL);
+		neigh_release(n);
+	} else {
+		pr_err("Cannot create neighbour %pI4n", &nc->key.addr.u.ipv4);
+	}
+
+out:
+	return;
+}
+
+/* Propagate hw state to kernel */
+static void prestera_k_arb_hw_evt(struct prestera_switch *sw)
+{
+	struct prestera_kern_neigh_cache *n_cache;
+	struct rhashtable_iter iter;
+
+	rhashtable_walk_enter(&sw->router->kern_neigh_cache_ht, &iter);
+	rhashtable_walk_start(&iter);
+	while (1) {
+		n_cache = rhashtable_walk_next(&iter);
+
+		if (!n_cache)
+			break;
+
+		if (IS_ERR(n_cache))
+			continue;
+
+		rhashtable_walk_stop(&iter);
+		__prestera_k_arb_hw_state_upd(sw, n_cache);
+		rhashtable_walk_start(&iter);
+	}
+	rhashtable_walk_stop(&iter);
+	rhashtable_walk_exit(&iter);
+}
+
 /* Propagate kernel event to hw */
 static void prestera_k_arb_n_evt(struct prestera_switch *sw,
 				 struct neighbour *n)
@@ -1463,6 +1539,34 @@ static int prestera_router_netevent_event(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
+static void prestera_router_update_neighs_work(struct work_struct *work)
+{
+	struct prestera_router *router;
+
+	router = container_of(work, struct prestera_router,
+			      neighs_update.dw.work);
+	rtnl_lock();
+
+	prestera_k_arb_hw_evt(router->sw);
+
+	rtnl_unlock();
+	prestera_queue_delayed_work(&router->neighs_update.dw,
+				    msecs_to_jiffies(PRESTERA_NH_PROBE_INTERVAL));
+}
+
+static int prestera_neigh_work_init(struct prestera_switch *sw)
+{
+	INIT_DELAYED_WORK(&sw->router->neighs_update.dw,
+			  prestera_router_update_neighs_work);
+	prestera_queue_delayed_work(&sw->router->neighs_update.dw, 0);
+	return 0;
+}
+
+static void prestera_neigh_work_fini(struct prestera_switch *sw)
+{
+	cancel_delayed_work_sync(&sw->router->neighs_update.dw);
+}
+
 int prestera_router_init(struct prestera_switch *sw)
 {
 	struct prestera_router *router;
@@ -1496,6 +1600,10 @@ int prestera_router_init(struct prestera_switch *sw)
 		goto err_nh_state_cache_alloc;
 	}
 
+	err = prestera_neigh_work_init(sw);
+	if (err)
+		goto err_neigh_work_init;
+
 	router->inetaddr_valid_nb.notifier_call = __prestera_inetaddr_valid_cb;
 	err = register_inetaddr_validator_notifier(&router->inetaddr_valid_nb);
 	if (err)
@@ -1526,6 +1634,8 @@ int prestera_router_init(struct prestera_switch *sw)
 err_register_inetaddr_notifier:
 	unregister_inetaddr_validator_notifier(&router->inetaddr_valid_nb);
 err_register_inetaddr_validator_notifier:
+	prestera_neigh_work_fini(sw);
+err_neigh_work_init:
 	kfree(router->nhgrp_hw_state_cache);
 err_nh_state_cache_alloc:
 	rhashtable_destroy(&router->kern_neigh_cache_ht);
@@ -1544,6 +1654,7 @@ void prestera_router_fini(struct prestera_switch *sw)
 	unregister_netevent_notifier(&sw->router->netevent_nb);
 	unregister_inetaddr_notifier(&sw->router->inetaddr_nb);
 	unregister_inetaddr_validator_notifier(&sw->router->inetaddr_valid_nb);
+	prestera_neigh_work_fini(sw);
 	prestera_queue_drain();
 
 	prestera_k_arb_abort(sw);
-- 
2.17.1

