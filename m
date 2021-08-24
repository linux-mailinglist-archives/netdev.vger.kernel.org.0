Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F398A3F5D3F
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 13:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236892AbhHXLmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 07:42:22 -0400
Received: from mail-eopbgr80078.outbound.protection.outlook.com ([40.107.8.78]:43248
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236774AbhHXLmL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 07:42:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hZaOj0x7xLP9dm7RD6shpQIblPwgB9VOXhCbgGPC/Map5KlDGSvvTkPYs9nekMGW8NxauXLJEDqyWtWvpF2USj82obO+xmiDaRLkcM2ylz3cSxaBuPGbTgoAMvaK4rZCKP8yshArTdWw+LNaivKxJ1yXY5cUPaN7FOD1CTfO018tCUt9GBy5Q0/srzAcqRbfFvaw6/M8o6scpIKiUGE5eWr2EuMLJNUVP9l+CWR5H96PlTVusahsvVgY3Y1Umc8pw0UU11OEfs/ylbRrmNiQgMAS44NcQVAVV3wO735A9DSuRDwIlCinOgIOQHKRnZFRgTs2YpmXCPgXdqUInZIBhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m4Ugnd81hKhHlTpRVY8Nb2stkXAxgneolJ9hOoPr6Xc=;
 b=GLdiiT6G7ZahyZ2uUPX56t9mCuZVTZSavms1m+9SOu1YScOWF1kuouQB7YuxcRUXXyPeXaJjXi1JAMctJX4Ihfcv2BHYAbUW7Yp4XV/RrXlmvDldCxzEt5EwZIbMH6YW/tcNjHTpvEco/MI8yS0Ks+rMxJOcOmSlqtFYhtjR8ccplPZ+0SA1mv3RzKkGnyYPBhvmXxkeeftNqc3iiF0VYN1yvmXNnCyEJS3E/wI3yKKByZbTeOHEDINL04Q/r+F17keVuitSZhreoo2aL+FjmdyJpgkAL8lXoMl2vGpjSkVz0Ez/H1F8vOyqVAmCTkGBWs+nRSxir6As46sHGgqWfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m4Ugnd81hKhHlTpRVY8Nb2stkXAxgneolJ9hOoPr6Xc=;
 b=is6QJ/FVLUBsyxUTBEufrdOzAtCJWr00sjwR18S2fbBjodp1qSOX2IreviWax92Nbl8MqxQv4O8eVIsNXFFZWos9+gdlUG7pseDO3E5qcVElr3/0LF2QQbSPMKsgI205f0MHkdimJYbR48LjWh419uIH0IKC/YbBrLnNnxzjERw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 11:41:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.025; Tue, 24 Aug 2021
 11:41:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        John Crispin <john@phrozen.org>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [RFC PATCH net-next 4/8] net: dsa: introduce locking for the address lists on CPU and DSA ports
Date:   Tue, 24 Aug 2021 14:40:45 +0300
Message-Id: <20210824114049.3814660-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210824114049.3814660-1-vladimir.oltean@nxp.com>
References: <20210824114049.3814660-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0083.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by FR0P281CA0083.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1e::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.6 via Frontend Transport; Tue, 24 Aug 2021 11:41:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34b58d73-2128-4661-b8a7-08d966f4175b
X-MS-TrafficTypeDiagnostic: VI1PR04MB5696:
X-Microsoft-Antispam-PRVS: <VI1PR04MB56969ABF5B6314DE143670E0E0C59@VI1PR04MB5696.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FZAC3pD5nHWW05vMGx3a53f7y+XErsNM+xphIhwus5+tKN0SWaGUD105RI6YMmnkEU42Wmapilld68+kBEt11Xws9lEKu9tZb8edYxxUpSYBmNxm0n9x9LQdi4sTyQYGA/al6dkDqI5Pw6iQYHqgsRBwJvlcvtnPnbia4GI/AWEQg9YKql1gUcMdAkTeupL8zC3HFQixPW8JF2XvMzJUmFaZgZMudVJgJEYuuINfYzzb7D4Dq2H2Z8dq2WHObc/t/0LjKZTI6RcjgUJf8mJr+I5gHNmzorvuJDGapsThplHRIWY5S/DvcszFuKDAM9CjCqagPHeJSZxdRSr6+nuL4Gr4gdtPrR3CwPAoiUAM6S0C2qBYunYT8CyD5n316j7ATkWq+03/8Me24DnPV72hJPWURpQRmI6Twu/HIhK2cKaBYHG+CPNwtNWefa24XIenXG2qiDAEYa1zbgv1CpBFGI1GoWC29RVSP1dHXMHsfp0XZZzhFFI1auaDC7kJzi+KmxkyRVZ1uuzgFq8GXjv4o3unGfsiLn7FMCTMqa9n0gWKp2TWyBriEKAkdPghzYXPemHovGMiTaEVTgASCTonfYNXsZiGJ+dfl1EVibB2UL0mrSzYjL0KxelYXFIzx9dP5dlo9O8dDN5B1SlkaNWGOEfDyF2KdPNys1/2V8H/huEmO18afxsbcBpeGx8MNbymRhQdekqEdKdutf18+CN5NA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(136003)(39850400004)(376002)(52116002)(4326008)(478600001)(5660300002)(6916009)(66476007)(66556008)(26005)(83380400001)(1076003)(36756003)(66946007)(6486002)(6666004)(6512007)(7416002)(6506007)(186003)(8676002)(8936002)(2616005)(86362001)(44832011)(38100700002)(38350700002)(956004)(2906002)(54906003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vrGTC4Ihhunp88mC6+4ktqtxnQfJf10M3B7QcYD3ZdatayTD6B0MYm2PUpGa?=
 =?us-ascii?Q?xNh1GykhzsRCB28W5wmPhcUcL9ujqz5+ADo+Rw6Pn4E9u9MPSWzy+2h/3uUl?=
 =?us-ascii?Q?ZEBVfFQuHF6nt/987/jlmxh6lW3OJVPHCF9kDKHsGo83CobbJDAfhi8RKXD4?=
 =?us-ascii?Q?JTBXxOh15pkorniqFN8H/6LE6NDbHNr5cf4q6ntoCsuU8Isw201Zx7QK6rD9?=
 =?us-ascii?Q?B2xVPA7fktaYSo92ohMc1rIrYZDu+4PIkLH/3JHQoSk+6ibw4w6f0bV8FxGO?=
 =?us-ascii?Q?8gDuV8RuhS7DrVi2Xhp1Qoi3VYxw93JRPd40lxNb40AXbjZ9lsGctrnDXAam?=
 =?us-ascii?Q?4LPigCRjqmft6x72lJQRd1TOBR9aZ3Vy6/7WyLPZBAV+tDEwjKKZ57YfyS5T?=
 =?us-ascii?Q?xuytHUq1SEOtqqL7x1hHlTUN4SvxcSXfOQ6KrgTFi6b2EzIywj+R7nwic68h?=
 =?us-ascii?Q?hh/Vk3SXe8iuvJ/RxPJPEQLJqpzSs2Xd1daNdystddTk+80mPshkwYeBmOOL?=
 =?us-ascii?Q?TpfC2E4MCQlHfrrl90h+2PXEFJF+mwwqeK78u4j8cz4ayIenaGbDTVPjuLn6?=
 =?us-ascii?Q?JMjdE2XnT7MYP0upXkCEZPSxpVhU4mq5n6i7t2XjvKnfKugoqqy6sL5Wu+wJ?=
 =?us-ascii?Q?NBShO5+LSU+EjQj0DOX4JaHrU2hgJ6F0lQGEzCJafbmRHk5HnSTE82ADSwxC?=
 =?us-ascii?Q?Yy32U982GfgZ/IqZSYOxtASRRKFNG/+fq4ZZbPBlSXIVTmW02OpySuom/mjQ?=
 =?us-ascii?Q?/NFhZ/kugK/15ZC2w1LLfQz/FMH8WG0l/4dJfdsokoice7LZAMCZ3lm9/t6m?=
 =?us-ascii?Q?++99zF17O1QKI43IE4mVIkIgTTcBlOJQeiqavmz+fYynhgq5mPm1+75N797y?=
 =?us-ascii?Q?w1bnGLX9tt6Xl2ehGb/osgqu8ZVIEWYZaehtsShpJNF16cXPM2gtPHUTJtcL?=
 =?us-ascii?Q?Ua1etIQUMDchzBkVkmeNDkzRglF4/E2Jj1D5WG12oA1Bw9Z+A1mE0nmEeTbj?=
 =?us-ascii?Q?MhwfwN05BXsD4p2aZaR1cwNlMYG+DIvsPsJb41dp007RRAz8kSzvveoPlq87?=
 =?us-ascii?Q?QVsbNhrqrV2CEGbGcUHRC+uxlzBOj2DuTuz7Enk88xaw6Z7bi2egP1AYDz10?=
 =?us-ascii?Q?MSEyv/hAzS7V4n9Yhf+b6YkiH/WZlZ78d7Esh1EiJNzFSGwlExgpDFdHGgRl?=
 =?us-ascii?Q?tpsFNiq66v8h8puKgG7eaYvVnr9K3AQmZRM2MMiK/e3Vzx2cA7IojZ48r9zS?=
 =?us-ascii?Q?Oxtjze02W6Vh3/KRTFCRimlHP1OyPOuBq989Bf+I+eztTSB12cHTAl3VM/ed?=
 =?us-ascii?Q?jRLHNOZTy5QgXoJHFzwtusNs?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34b58d73-2128-4661-b8a7-08d966f4175b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 11:41:20.1365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RfrQVEfVLA4HbbaoCeWCcvMifr+p5/Q6QspZVYA2pcTO+Z2SZTFAcBrNq8QbgkhxYXcjFqxfzOjkNa+n7pcqzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5696
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the rtnl_mutex is going away for dsa_port_{host_,}fdb_{add,del},
no one is serializing access to the address lists that DSA keeps for the
purpose of reference counting on shared ports (CPU and cascade ports).

It can happen for one dsa_switch_do_fdb_del to do list_del on a dp->fdbs
element while another dsa_switch_do_fdb_{add,del} is traversing dp->fdbs.
We need to avoid that.

Currently dp->mdbs is not at risk, because dsa_switch_do_mdb_{add,del}
still runs under the rtnl_mutex. But it would be nice if it would not
depend on that being the case. So let's introduce a mutex per port (the
address lists are per port too) and share it between dp->mdbs and
dp->fdbs.

The place where we put the locking is interesting. It could be tempting
to put a DSA-level lock which still serializes calls to
.port_fdb_{add,del}, but it would still not avoid concurrency with other
driver code paths that are currently under rtnl_mutex (.port_fdb_dump,
.port_fast_age). So it would add a very false sense of security (and
adding a global switch-wide lock in DSA to resynchronize with the
rtnl_lock is also counterproductive and hard).

So the locking is intentionally done only where the dp->fdbs and dp->mdbs
lists are traversed. That means, from a driver perspective, that
.port_fdb_add will be called with the dp->addr_lists_lock mutex held on
the CPU port, but not held on user ports. This is done so that driver
writers are not encouraged to rely on any guarantee offered by
dp->addr_lists_lock.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h |  1 +
 net/dsa/dsa2.c    |  1 +
 net/dsa/switch.c  | 76 ++++++++++++++++++++++++++++++++---------------
 3 files changed, 54 insertions(+), 24 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index f9a17145255a..bed1fbc0215c 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -285,6 +285,7 @@ struct dsa_port {
 	/* List of MAC addresses that must be forwarded on this port.
 	 * These are only valid on CPU ports and DSA links.
 	 */
+	struct mutex		addr_lists_lock;
 	struct list_head	fdbs;
 	struct list_head	mdbs;
 
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 1b2b25d7bd02..8ddf10e27d85 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -435,6 +435,7 @@ static int dsa_port_setup(struct dsa_port *dp)
 	if (dp->setup)
 		return 0;
 
+	mutex_init(&dp->addr_lists_lock);
 	INIT_LIST_HEAD(&dp->fdbs);
 	INIT_LIST_HEAD(&dp->mdbs);
 
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 1c797ec8e2c2..40e28eedac59 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -214,26 +214,30 @@ static int dsa_switch_do_mdb_add(struct dsa_switch *ds, int port,
 {
 	struct dsa_port *dp = dsa_to_port(ds, port);
 	struct dsa_mac_addr *a;
-	int err;
+	int err = 0;
 
 	/* No need to bother with refcounting for user ports */
 	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
 		return ds->ops->port_mdb_add(ds, port, mdb);
 
+	mutex_lock(&dp->addr_lists_lock);
+
 	a = dsa_mac_addr_find(&dp->mdbs, mdb->addr, mdb->vid);
 	if (a) {
 		refcount_inc(&a->refcount);
-		return 0;
+		goto out;
 	}
 
 	a = kzalloc(sizeof(*a), GFP_KERNEL);
-	if (!a)
-		return -ENOMEM;
+	if (!a) {
+		err = -ENOMEM;
+		goto out;
+	}
 
 	err = ds->ops->port_mdb_add(ds, port, mdb);
 	if (err) {
 		kfree(a);
-		return err;
+		goto out;
 	}
 
 	ether_addr_copy(a->addr, mdb->addr);
@@ -241,7 +245,10 @@ static int dsa_switch_do_mdb_add(struct dsa_switch *ds, int port,
 	refcount_set(&a->refcount, 1);
 	list_add_tail(&a->list, &dp->mdbs);
 
-	return 0;
+out:
+	mutex_unlock(&dp->addr_lists_lock);
+
+	return err;
 }
 
 static int dsa_switch_do_mdb_del(struct dsa_switch *ds, int port,
@@ -249,29 +256,36 @@ static int dsa_switch_do_mdb_del(struct dsa_switch *ds, int port,
 {
 	struct dsa_port *dp = dsa_to_port(ds, port);
 	struct dsa_mac_addr *a;
-	int err;
+	int err = 0;
 
 	/* No need to bother with refcounting for user ports */
 	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
 		return ds->ops->port_mdb_del(ds, port, mdb);
 
+	mutex_lock(&dp->addr_lists_lock);
+
 	a = dsa_mac_addr_find(&dp->mdbs, mdb->addr, mdb->vid);
-	if (!a)
-		return -ENOENT;
+	if (!a) {
+		err = -ENOENT;
+		goto out;
+	}
 
 	if (!refcount_dec_and_test(&a->refcount))
-		return 0;
+		goto out;
 
 	err = ds->ops->port_mdb_del(ds, port, mdb);
 	if (err) {
 		refcount_inc(&a->refcount);
-		return err;
+		goto out;
 	}
 
 	list_del(&a->list);
 	kfree(a);
 
-	return 0;
+out:
+	mutex_unlock(&dp->addr_lists_lock);
+
+	return err;
 }
 
 static int dsa_switch_do_fdb_add(struct dsa_switch *ds, int port,
@@ -279,26 +293,30 @@ static int dsa_switch_do_fdb_add(struct dsa_switch *ds, int port,
 {
 	struct dsa_port *dp = dsa_to_port(ds, port);
 	struct dsa_mac_addr *a;
-	int err;
+	int err = 0;
 
 	/* No need to bother with refcounting for user ports */
 	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
 		return ds->ops->port_fdb_add(ds, port, addr, vid);
 
+	mutex_lock(&dp->addr_lists_lock);
+
 	a = dsa_mac_addr_find(&dp->fdbs, addr, vid);
 	if (a) {
 		refcount_inc(&a->refcount);
-		return 0;
+		goto out;
 	}
 
 	a = kzalloc(sizeof(*a), GFP_KERNEL);
-	if (!a)
-		return -ENOMEM;
+	if (!a) {
+		err = -ENOMEM;
+		goto out;
+	}
 
 	err = ds->ops->port_fdb_add(ds, port, addr, vid);
 	if (err) {
 		kfree(a);
-		return err;
+		goto out;
 	}
 
 	ether_addr_copy(a->addr, addr);
@@ -306,7 +324,10 @@ static int dsa_switch_do_fdb_add(struct dsa_switch *ds, int port,
 	refcount_set(&a->refcount, 1);
 	list_add_tail(&a->list, &dp->fdbs);
 
-	return 0;
+out:
+	mutex_unlock(&dp->addr_lists_lock);
+
+	return err;
 }
 
 static int dsa_switch_do_fdb_del(struct dsa_switch *ds, int port,
@@ -314,29 +335,36 @@ static int dsa_switch_do_fdb_del(struct dsa_switch *ds, int port,
 {
 	struct dsa_port *dp = dsa_to_port(ds, port);
 	struct dsa_mac_addr *a;
-	int err;
+	int err = 0;
 
 	/* No need to bother with refcounting for user ports */
 	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
 		return ds->ops->port_fdb_del(ds, port, addr, vid);
 
+	mutex_lock(&dp->addr_lists_lock);
+
 	a = dsa_mac_addr_find(&dp->fdbs, addr, vid);
-	if (!a)
-		return -ENOENT;
+	if (!a) {
+		err = -ENOENT;
+		goto out;
+	}
 
 	if (!refcount_dec_and_test(&a->refcount))
-		return 0;
+		goto out;
 
 	err = ds->ops->port_fdb_del(ds, port, addr, vid);
 	if (err) {
 		refcount_inc(&a->refcount);
-		return err;
+		goto out;
 	}
 
 	list_del(&a->list);
 	kfree(a);
 
-	return 0;
+out:
+	mutex_unlock(&dp->addr_lists_lock);
+
+	return err;
 }
 
 static int dsa_switch_host_fdb_add(struct dsa_switch *ds,
-- 
2.25.1

