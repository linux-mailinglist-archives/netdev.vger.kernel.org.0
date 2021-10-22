Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA0E7437CBC
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 20:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbhJVSqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 14:46:55 -0400
Received: from mail-vi1eur05on2058.outbound.protection.outlook.com ([40.107.21.58]:9427
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232302AbhJVSqy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 14:46:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P8pHrqe3G3YBKn+h/eQO1QIJlTY4UwFqUJtjbAzAeSbtjnLytZrVLIdypq+8Zfs24XXkHiuF1nXxNnmjM7AJGcB7IaTpq7PufsznfQAoopGCn9wgpjuh+glqnHZEIGNY62rSDmUoqSHU5Ul7SfFqbyTGdl+nHiyR0DAavZoi4cp2xCzyKinAd2oOxKfALFy9iJ3IBIMGlkIH6hPAmZ40noKuUGQWe99ttFCV1tfSnf6x3Qffkt4JnS1lVsl/dglmN/MLA/C2epe/jtsuKAL0hOqQHv+WbfZ3ggYgyj1/bxl+fxa+aIn8Yu5SwSksoN+CVoSkuTEF7O2LSSJlOnKgtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xj466KuG5T7X7KQTgQup3XKhIUO3HLf9Dof32FoLlXE=;
 b=F5s4t1pYwi+MAM7PcEK9D7dB89JC2RBCe4UEXxfqYy6jZsP/Ti58ADGgS+j2Q8Dn39O9xaG/dvxTRx1pOl+Mu3rCkxBXm2ejXfHNbPzjKaLMGC69u+7d1Jf0Na+eXoPlBTHyRyO1JWYTSsdaIAfKWBCL2Ln4NOe643zVZS8rSyMvX1wrIQPEuB2WoOzPFHV02QDqMC0k7oMVojWMBKPpgtNPYJOggkYyEGcq4vcxws8pBQe3zK5CkCFbj51m38rMigR6xojNekneckljWD+13DjKV3YUEneXpS1cr6n6ASZzy61oxffa61Yp4tITqFWiByBwCc807Asdpvg2eYZJBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xj466KuG5T7X7KQTgQup3XKhIUO3HLf9Dof32FoLlXE=;
 b=S6fNg9NDCslNhnSqRIAWBGFcdP4Jk+or4yIKzvU9FGFE9CF26gKru+y4ym6rEZbL3y5M+6X9U80eHLlS9DUZ1lv+yIEk/kmtDMRjIC1EizktroUGrfvQV4s4VEcara9Gds347xVqirJyyANCNUpszDuTWz+R5+dOp4Epf9jp+xg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2862.eurprd04.prod.outlook.com (2603:10a6:800:b6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 18:44:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 18:44:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
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
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH v4 net-next 7/9] net: dsa: drop rtnl_lock from dsa_slave_switchdev_event_work
Date:   Fri, 22 Oct 2021 21:43:10 +0300
Message-Id: <20211022184312.2454746-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022184312.2454746-1-vladimir.oltean@nxp.com>
References: <20211022184312.2454746-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0103.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::44) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR01CA0103.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Fri, 22 Oct 2021 18:44:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5f9f85f-f8d0-4bbe-9c10-08d9958bfd8e
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2862:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2862B3C2023A22B1F14D14E1E0809@VI1PR0402MB2862.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Iuovtv7FAEJv8TFS6cPyqw7vZZPhx+otRceY8KnliGGok8x766hfSxUW0UKcwYMjdHC13YdtuCm1XQ3h8eAaUzfm0V27L43xN5RPTu5gIAz72HKkLRBeZUrrYpY4xRqTSBiZtGZS0PnDviEkV3SYsNU6jyizrVplb791zkAL5mD45sUWrEqTIUNBZM2LayONvCjYq8zINMCDHPoak+oH3ui6Loejs49FgBRxofO02miuGh2q95zqeV6WLCh7F2+dIHBZEPjl8RgSK2vTwZQu9H9xdzT8wRg5ZzFOmbxVeA0fE/wxYQqG3U1RI/PZduyqEEYjKJsmQVXZx0eZyNXMrJjVvsIV86KVl8pMZUsH5kKQP17+0jID0jM2xxUw+eE6vjKefpER6kVB0uE3cqDsWR5F3S2Q2irrXBo/oN/TbP7ZovERI3gQthouWhZqD/7O9CDrWp4JIl74RvlgKf5PU1szHvFv7uJjzINjCO7iRLTrbXtPZT5AM6uaeyCkgG7klL+XUY1xz6HvnZE5cAV43koNVKkf53fqsfGnGLqm5cQTK+4QbOrv+Rehpt/6FHpSw/TUdtujuQ+T6XL0ia94nRZdS4GLi9aY5wqzSX4XCvBDjl4Nd1ys2uHQILcE/xdQaUYM8xnukziaqIEv42XJ5xZ2+UdnboaahOa2MJACqXpDA0CEMnq7rCvD05h5JnMQvKNL/bOMj87zh7ono1CF1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38350700002)(2906002)(38100700002)(83380400001)(52116002)(508600001)(1076003)(36756003)(6512007)(6666004)(54906003)(6916009)(86362001)(6486002)(316002)(956004)(66946007)(2616005)(44832011)(4326008)(186003)(7416002)(6506007)(8676002)(8936002)(26005)(5660300002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7osNvG0iAqm7FII8sqGOxz03djcqXeJLXeQOk299HCkQNBuJl8GlKvH9nGVm?=
 =?us-ascii?Q?3kMO2/xE5nxnhLP89WiXsqvq9G2PeiCNYloGcY28nldOKf4+x2LU0ff1Dfbs?=
 =?us-ascii?Q?gDPiqB6fu8iJ6sRZ/cKz6tFCwUBHK2T227uKMgv9VAEiXyHgCBy4DEbos2rB?=
 =?us-ascii?Q?4LWq1oFZ/QRUNZ2waEGptVg0OvtlniZ4WO7U8TmWT4/X/4i0KDiNeZoe2bbX?=
 =?us-ascii?Q?ttjCipztQ1xBNzHRVGgxHzvA+gXKZi13f7DbaqBTXOBXXrZ9yrY9uAMNYb6B?=
 =?us-ascii?Q?jNv3ChegdTE1zL6I5WpnaQUWCkiD+hQ2/uur5BbcIqK1PyjwlgYBzducSmNU?=
 =?us-ascii?Q?jRL4jyBsa+XUF3BPM/v1XKU04IAnTHpKroLWOga3U7EaOL94MCNIk39AV9Hd?=
 =?us-ascii?Q?qSwdTIi/qJechAxwkWchDfzZ4Uw9fgIrta3AynpC7Q9YPHViXMqb+ihIJNQy?=
 =?us-ascii?Q?sH5t8Nxh73oZ6D1xxAZwGZ7APoN1OlLUowozFVZF4C95cktUhKw59oSjmqAX?=
 =?us-ascii?Q?JJnouKHHyKSE9EBk6PlXMs6JurjpRMb9m5OBpMKy96WOJx7sl4RQdxi7IVBo?=
 =?us-ascii?Q?83daxBj6UYPw0lXQvr+2SxPuJFGi+9u559f7yPxnAefAbvvzAI64xrdKi3U/?=
 =?us-ascii?Q?MWjl/wQqRot0wiWIUrzi/fnMjAbQh32N/IhLVPToKOEm4RhS7AWLTiBXwET4?=
 =?us-ascii?Q?ZoKhej2XWPmHW+y+SGjufNYc6xqC1V2DLDAMMJuEeZ1yFWgLr+fNT9Eaa6CU?=
 =?us-ascii?Q?13wHZ5USIY7tSzHpQPy1Bs79brAzIXqyx0zS/dObB8EwkPYrK9eI8Ul8VPDH?=
 =?us-ascii?Q?qZJ50lvQCMEo5X69Tx8f8yPWESP3W8YH6byEPwuAoYisd5HNaCOmbkUgvVpq?=
 =?us-ascii?Q?/lQ7W0sB+/nGauNgWVRGbE+JIHkm+QcWRRTxfISuqqss10E95K6+qsazjVvL?=
 =?us-ascii?Q?63swN7j3Kpm4C1vbg5dO8EH8QvBE36M+INUGX7p8Q0Dr5BMwFni52k+6YwMz?=
 =?us-ascii?Q?16ohyuDZc0CEDSmBVBu3AswkVSPIx5FzE/qM6qUSNkOtO1207GXWZ3/cZPQH?=
 =?us-ascii?Q?X7JIUgAGVlzR9f3fJWBLmgBUtZUqWALeIRrZn5Fvw1S8UknJMein7iCf9EGq?=
 =?us-ascii?Q?67OZ0Xnx097WUvyCbdgn6R+kigMeaI6wUxPEnqfeMMsC9WHU9pIDpoOlutkI?=
 =?us-ascii?Q?kCxPTs0uPvjhmZiFWtJq5u0vcYNgYZbh/q+cnYbtLX4DYoH8eQJq54lOLcZT?=
 =?us-ascii?Q?JgMAhT4AnQk/8XTVj7EtEluLYpE4MU2TXH8wMqjI6m2ZSGxFU7k2JaFpsYwB?=
 =?us-ascii?Q?ZSX3x3cj7bLVUKwyehVVDPwKjimpqq9LGTr5sv+noO9BUqWc7vJ9C/fZW9KM?=
 =?us-ascii?Q?zGrgxcKDWLN6MAs+nfStjLmTGdrfC9Y60HEWjUx9uxnp5nz+RvIP4aWs1tt8?=
 =?us-ascii?Q?1eNATeZjfWvXuQzU9A76gtxOs1Z0Y6EL?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5f9f85f-f8d0-4bbe-9c10-08d9958bfd8e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 18:44:33.8739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vladimir.oltean@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2862
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After talking with Ido Schimmel, it became clear that rtnl_lock is not
actually required for anything that is done inside the
SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE deferred work handlers.

The reason why it was probably added by Arkadi Sharshevsky in commit
c9eb3e0f8701 ("net: dsa: Add support for learning FDB through
notification") was to offer the same locking/serialization guarantees as
.ndo_fdb_{add,del} and avoid reworking any drivers.

DSA has implemented .ndo_fdb_add and .ndo_fdb_del until commit
b117e1e8a86d ("net: dsa: delete dsa_legacy_fdb_add and
dsa_legacy_fdb_del") - that is to say, until fairly recently.

But those methods have been deleted, so now we are free to drop the
rtnl_lock as well.

Note that exposing DSA switch drivers to an unlocked method which was
previously serialized by the rtnl_mutex is a potentially dangerous
affair. Driver writers couldn't ensure that their internal locking
scheme does the right thing even if they wanted.

We could err on the side of paranoia and introduce a switch-wide lock
inside the DSA framework, but that seems way overreaching. Instead, we
could check as many drivers for regressions as we can, fix those first,
then let this change go in once it is assumed to be fairly safe.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v4: none

 net/dsa/slave.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 9d9fef668eba..adcfb2cb4e61 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2413,7 +2413,6 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 
 	dp = dsa_to_port(ds, switchdev_work->port);
 
-	rtnl_lock();
 	switch (switchdev_work->event) {
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
 		if (switchdev_work->host_addr)
@@ -2448,7 +2447,6 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 
 		break;
 	}
-	rtnl_unlock();
 
 	dev_put(switchdev_work->dev);
 	kfree(switchdev_work);
-- 
2.25.1

