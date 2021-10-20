Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD7DE435232
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 19:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhJTSBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 14:01:46 -0400
Received: from mail-eopbgr130070.outbound.protection.outlook.com ([40.107.13.70]:56736
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230134AbhJTSBj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 14:01:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MEKF991MWiNe0SCe0cHPscAdpDYqEzxoIAIfDRgqS0WV5+2BTFvwZvdiCLwADihxEH0y13d7o/RWFmzBtbtvBr1ugFIoqN4/SpdolAM7iAz77dD5ahKnjKBUsF3KA9ZBOI3rDToc8Nadp3kCgo/NRbonJnkFIGsns1vrAHa3opTZ+bu58RY9vsd5ERcY5wA3NINjPA6rsaVJBVA6c5PZPT4LQRklkQ1Hu48CvADGbKCcFD0vtK55PFtkn50j7egE2WVn67xhXK1b7DURm6ROluvt0vFbpILu5R2fWE7uBZegqCxWP3N2MzgMY5d92PpAhIYC5OxwZCDuSHqX0xJJ9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w75AoZLpTi1VtcUxU8ms66ptHME7itFTn7IHhQhAwh8=;
 b=JrIpBdEi8xbxrVLMZ/gKpIYvm2orY4EnfP1pc7Pfa4zj7gvNpObm73PO0F79wAaOR1YRB+vU/Z++XbhsCptN66VbMkcEpN7TY7yUodAW5iC2i0jauT9tF4dJFykNO0aL+mf4xGgf9GqmrifO7D62T+pJExOrZxBm9Jz3odE6c98lLVs4Ghq251M4dp1SFTSAES4JCYf2OWTAFESBfRZHH8GbByjCUZ0v0tyxTIO/oGso0XxEPLJO4EyrhObw9lTphYnm0s5to7akZUsFo/AREzhuCzGwcU4ROpYL8+DFKO/RlKK0t463q+AQUzSsWV9MhAr6hKRuXylufGMQXK/Yfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w75AoZLpTi1VtcUxU8ms66ptHME7itFTn7IHhQhAwh8=;
 b=PFcx1jhAmIFQCq9LnvgWhxOr3rZ6R68N4a0/QC7nxtPqRZFDQI9kuCs05IkUaYBdR+BVZ3U24PgQ6BkVB/Re9qADurBdCJO2aMOpZqqCBMaQOg8+zVTYd0MpATkUYPpmMdBuPLDh9QkAF/1OU41pgg2ZQ07GnDSioBCtDHFdlGs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4685.eurprd04.prod.outlook.com (2603:10a6:803:70::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Wed, 20 Oct
 2021 17:59:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 17:59:17 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Po Liu <po.liu@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net-next 4/5] net: mscc: ocelot: add the local station MAC addresses in VID 0
Date:   Wed, 20 Oct 2021 20:58:51 +0300
Message-Id: <20211020175852.1127042-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211020175852.1127042-1-vladimir.oltean@nxp.com>
References: <20211020175852.1127042-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0019.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::32) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR08CA0019.eurprd08.prod.outlook.com (2603:10a6:208:d2::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Wed, 20 Oct 2021 17:59:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 430077b0-b6c6-4e25-a6e8-08d993f355c6
X-MS-TrafficTypeDiagnostic: VI1PR04MB4685:
X-Microsoft-Antispam-PRVS: <VI1PR04MB46851AF02E2F521474CEA403E0BE9@VI1PR04MB4685.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G6YmDrSn1io5woGnUxEKbmzIq9uT/7iLPhJ9k4TL5ZPP42wkXmTMR1rNHrKaUK7jMyn2/qnL9JjpXi/k+xZX2YtdtIQsHrsYJHnXK+Sq7J+NiMJUKYXyK09ueyq0ry+m0akvki7Whhrj/t5WCMCu0v5i+uR85Ukz0u6sDu1hQboFNP1MNT8zQMikGS8A+Sqjm43BBMqSE3Nu+hXI9/PVP+gYP0MryKs0wOosrzbiOLVNmuIC6kR38EehvzMFDH5cR0xWjCuE7ynWLPbLxRvvMx9Yr8toiTlrv5Hvtj/OR9DT6jM2FU97EdxV4BCKEHU67V+D3Ryd5Kr54wbRDw5UAfFlIbdGNQ6yu3hX34bKK/RDZcTMsO2/K9OupQ2y+mbR2H0BH6jqjCp4mx7aWjV9Ms3+Ut1jEtM4QuFjEzOvTXGyYUFWUgGX8ZcEcHkOqov8oYVJTliDpI+0lSPQfpd7iJxEIfI27yW430Jx698Ec/cIh2NIpUpJnvYD5yfGTpAYI8+dqRwN89fNHaqhEQisgD18lpJi9b0/zh0VlQLkgXGD13KgxO2t5Up2bzE5LtHgixFWfrjY3p6XoeqlQ54YBeSOYCUVO/KPFW1Lhh01MxuHIACrjxn/uhGEroeDfhhKrne1lNqvAsGqZpyh/LaX7Mimed6W/rZBYgECvUCydfFuud6omU4GafSk5PAYgmbkmnXWj4W9Woql9GXAXmt8ag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(110136005)(316002)(5660300002)(186003)(6506007)(52116002)(38350700002)(66476007)(66556008)(6666004)(38100700002)(54906003)(1076003)(26005)(6486002)(86362001)(6512007)(956004)(66946007)(83380400001)(8676002)(36756003)(6636002)(2906002)(8936002)(2616005)(44832011)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TMCEWn3265zyRWYm5pApRYZFseT585ZLtJxF2s1G720cxRYKA8/rIwXwuR/2?=
 =?us-ascii?Q?Mq5rQ2SmMXqU1iMyAeqniJNGUBw0MzFqED8pxnYOhpGB6pCGNsRjHzEHgKis?=
 =?us-ascii?Q?AkYStc32qDcpalirOfXUTGwAMte8pQ3huoZDBiEBdqwEgP/Q0URAQEIgOsSl?=
 =?us-ascii?Q?Rd/EDJiVOdFMqC4qurn70Jr9xTPpn8MPs736GiiT0XZJ7ch8J3bNCEgTRHZR?=
 =?us-ascii?Q?uhjDStMfisqnzl+nJdSrefwH34VjOQVZLUrhlo7P7BRJ5fkSAWz1U56BfHz2?=
 =?us-ascii?Q?/XV0DW9zZ0Fok6Q5q2WL6Yxw4rI9/fyrd17Y962Q/C/Y0G/y72gooxU059LB?=
 =?us-ascii?Q?RBAr0ElMY6hW2Nv57va1j7d7fLkLJmaD1eulIwBTuhPGcKN/5UQQNGLaPE9p?=
 =?us-ascii?Q?H6r2g2e6CU/S7p7E1UAI5GNCq9tWosmVjQmK+FA5Akr3Mfkpz5WtBRbiECuf?=
 =?us-ascii?Q?V0bnvoIRCZi1ODHlW6sMVrixrquTIkkN6obSZBWN6toR+ofCyzjDL0SRCvzW?=
 =?us-ascii?Q?9SkSjs2h7c+J3bmJpmrZUCVPESlT7kv+8Iu7jXkATWyAexQZh4SYEftaouin?=
 =?us-ascii?Q?giEzbSRpyQ92HWyKOZtDhhvwaeeU8Z1UvXh1MFoPQH6fUeWeRTaIMp3mr4GC?=
 =?us-ascii?Q?hvnn4jxuLp99BUBhKsyoRYYgwhU8c0KlMK113M0Q8CTOwP4KXUMlN2utC/dM?=
 =?us-ascii?Q?N/U4bPBxu2xfMiOtyY8+kgpV3OzuYictaNiVw72E3JUtqWI8Y1iqpDNVAXaH?=
 =?us-ascii?Q?ojvx8jnVBejAsHNlW2f+thqIGAgMQkuYM/dyWN/kmFgqmKJf9f2otozfjUGZ?=
 =?us-ascii?Q?g1kRlQHhu+OdI/mMq68N9I/mHPgzcWY1sUGKjaTeX4hXf3DEQlbttiEEzVx8?=
 =?us-ascii?Q?NbPgVCDYuQWydEK+EuFqZnWiW+90HXkh7FG7dTBR0XE0Gfkmvy/O6samiqzw?=
 =?us-ascii?Q?iy12Kgtrb6NKvnvLvx2pEM9obQtWnyXIx3hwDcvxyo1yTjnkbGaqCjpHmHwe?=
 =?us-ascii?Q?bsaDy0pGwgIgcwSiP23XICGocni5Ghpybrh5aiuBeWxTCiD/wd+N/1smrw36?=
 =?us-ascii?Q?Fl8XuF9zTOPnndciv+OzETl9xNWTJhhexlwne5e3tIXRncXcZSsr3M6U11uS?=
 =?us-ascii?Q?5KtqERBquGX0LzIRZy5vCDpaA/IEB1bzbEo7AbZFHoyQJTHTPmFcpyk0jMBs?=
 =?us-ascii?Q?omuzf4p/JEPnXN6IoDqGRbzPQ/R2U8R3roXyfoB/xIjWmA9FkFf1GmtRyQhh?=
 =?us-ascii?Q?/rzyahUtIWA8qRvXTtrjVnpzlfBKH/sFa6ETOFwXANumji4ZUjK49eyxsR//?=
 =?us-ascii?Q?yR5Vb74Cn7g3Kr0bpj7zGxQqdWHAOJVftC2NsnCNSK9mXIkSo4gxcetMHwjY?=
 =?us-ascii?Q?EnEpMbHQGPXnDumB8F/Xb9UOz6M7jqKE19+BgSG8OyrMcikb6C7ExCUlgLw2?=
 =?us-ascii?Q?KXL99dyLV+zm4SfhhXaD+vmKw35EN6trg2PQX+x4Wb2p7m8iEBR+YYb8JPud?=
 =?us-ascii?Q?07YQl6dxgDYSJ/5SJFF4ewVOmhYM4bnUDaGYveG0BqcnhycrMsLDKlto/4Vb?=
 =?us-ascii?Q?YFu2YxepLStKLNHmAyfMQ1t3FQZI6D6hSaqif+o56DAbs40Oi3yUiiXoyLDp?=
 =?us-ascii?Q?KI+mhycVAdhalHJg/C8Lusg=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 430077b0-b6c6-4e25-a6e8-08d993f355c6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 17:59:17.7702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tFRg6pl1W/nvL+YvRfyUus+P2mm/JgTSDN3v7JqXeqM6mt+gsAF8CUzY2pDjO4G4iJ3lomfvjnEJAXeRZ5KOuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4685
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ocelot switchdev driver does not include the CPU port in the list of
flooding destinations for unknown traffic, instead that traffic is
supposed to match FDB entries to reach the CPU.

The addresses it installs are:
(a) the station MAC address, in ocelot_probe_port() and later during
    runtime in ocelot_port_set_mac_address(). These are the VLAN-unaware
    addresses. The VLAN-aware addresses are in ocelot_vlan_vid_add().
(b) multicast addresses added with dev_mc_add() (not bridge host MDB
    entries) in ocelot_mc_sync()
(c) multicast destination MAC addresses for MRP in ocelot_mrp_save_mac(),
    to make sure those are dropped (not forwarded) by the bridging
    service, just trapped to the CPU

So we can see that the logic is slightly buggy ever since the initial
commit a556c76adc05 ("net: mscc: Add initial Ocelot switch support").
This is because, when ocelot_probe_port() runs, the port pvid is 0.
Then we join a VLAN-aware bridge, the pvid becomes 1, we call
ocelot_port_set_mac_address(), this learns the new MAC address in VID 1
(also fails to forget the old one, since it thinks it's in VID 1, but
that's not so important). Then when we leave the VLAN-aware bridge,
outside world is unable to ping our new MAC address because it isn't
learned in VID 0, the VLAN-unaware pvid.

[ note: this is strictly based on static analysis, I don't have hardware
  to test. But there are also many more corner cases ]

The basic idea is that we should have a separation of concerns, and the
FDB entries used for standalone operation should be managed by the
driver, and the FDB entries used by the bridging service should be
managed by the bridge. So the standalone and VLAN-unaware bridge FDB
entries should not follow the bridge PVID, because that will only be
active when the bridge is VLAN-aware. So since the port pvid is
coincidentally zero during probe time, just make those entries
statically go to VID 0.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: make the MRP addresses use OCELOT_VLAN_UNAWARE_PVID too

 drivers/net/ethernet/mscc/ocelot.c     | 11 ++++++-----
 drivers/net/ethernet/mscc/ocelot.h     |  1 +
 drivers/net/ethernet/mscc/ocelot_mrp.c |  8 ++++----
 drivers/net/ethernet/mscc/ocelot_net.c | 12 ++++++------
 4 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index bc033e62be97..30aa99a95005 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -268,7 +268,7 @@ static void ocelot_port_set_pvid(struct ocelot *ocelot, int port,
 	ocelot_port->pvid_vlan = pvid_vlan;
 
 	if (!ocelot_port->vlan_aware)
-		pvid_vlan.vid = 0;
+		pvid_vlan.vid = OCELOT_VLAN_UNAWARE_PVID;
 
 	ocelot_rmw_gix(ocelot,
 		       ANA_PORT_VLAN_CFG_VLAN_VID(pvid_vlan.vid),
@@ -501,7 +501,7 @@ static void ocelot_vlan_init(struct ocelot *ocelot)
 	 * traffic.  It is added automatically if 8021q module is loaded, but
 	 * we can't rely on it since module may be not loaded.
 	 */
-	ocelot_vlant_set_mask(ocelot, 0, all_ports);
+	ocelot_vlant_set_mask(ocelot, OCELOT_VLAN_UNAWARE_PVID, all_ports);
 
 	/* Set vlan ingress filter mask to all ports but the CPU port by
 	 * default.
@@ -2194,9 +2194,10 @@ static void ocelot_cpu_port_init(struct ocelot *ocelot)
 			    OCELOT_TAG_PREFIX_NONE);
 
 	/* Configure the CPU port to be VLAN aware */
-	ocelot_write_gix(ocelot, ANA_PORT_VLAN_CFG_VLAN_VID(0) |
-				 ANA_PORT_VLAN_CFG_VLAN_AWARE_ENA |
-				 ANA_PORT_VLAN_CFG_VLAN_POP_CNT(1),
+	ocelot_write_gix(ocelot,
+			 ANA_PORT_VLAN_CFG_VLAN_VID(OCELOT_VLAN_UNAWARE_PVID) |
+			 ANA_PORT_VLAN_CFG_VLAN_AWARE_ENA |
+			 ANA_PORT_VLAN_CFG_VLAN_POP_CNT(1),
 			 ANA_PORT_VLAN_CFG, cpu);
 }
 
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 1952d6a1b98a..e43da09b8f91 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -25,6 +25,7 @@
 #include "ocelot_rew.h"
 #include "ocelot_qs.h"
 
+#define OCELOT_VLAN_UNAWARE_PVID 0
 #define OCELOT_BUFFER_CELL_SZ 60
 
 #define OCELOT_STATS_CHECK_DELAY (2 * HZ)
diff --git a/drivers/net/ethernet/mscc/ocelot_mrp.c b/drivers/net/ethernet/mscc/ocelot_mrp.c
index 4b0941f09f71..1fa58546abdc 100644
--- a/drivers/net/ethernet/mscc/ocelot_mrp.c
+++ b/drivers/net/ethernet/mscc/ocelot_mrp.c
@@ -116,16 +116,16 @@ static void ocelot_mrp_save_mac(struct ocelot *ocelot,
 				struct ocelot_port *port)
 {
 	ocelot_mact_learn(ocelot, PGID_BLACKHOLE, mrp_test_dmac,
-			  port->pvid_vlan.vid, ENTRYTYPE_LOCKED);
+			  OCELOT_VLAN_UNAWARE_PVID, ENTRYTYPE_LOCKED);
 	ocelot_mact_learn(ocelot, PGID_BLACKHOLE, mrp_control_dmac,
-			  port->pvid_vlan.vid, ENTRYTYPE_LOCKED);
+			  OCELOT_VLAN_UNAWARE_PVID, ENTRYTYPE_LOCKED);
 }
 
 static void ocelot_mrp_del_mac(struct ocelot *ocelot,
 			       struct ocelot_port *port)
 {
-	ocelot_mact_forget(ocelot, mrp_test_dmac, port->pvid_vlan.vid);
-	ocelot_mact_forget(ocelot, mrp_control_dmac, port->pvid_vlan.vid);
+	ocelot_mact_forget(ocelot, mrp_test_dmac, OCELOT_VLAN_UNAWARE_PVID);
+	ocelot_mact_forget(ocelot, mrp_control_dmac, OCELOT_VLAN_UNAWARE_PVID);
 }
 
 int ocelot_mrp_add(struct ocelot *ocelot, int port,
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index affa9649f490..e3fc4548f642 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -418,7 +418,7 @@ static int ocelot_vlan_vid_del(struct net_device *dev, u16 vid)
 	 * with VLAN filtering feature. We need to keep it to receive
 	 * untagged traffic.
 	 */
-	if (vid == 0)
+	if (vid == OCELOT_VLAN_UNAWARE_PVID)
 		return 0;
 
 	ret = ocelot_vlan_del(ocelot, port, vid);
@@ -553,7 +553,7 @@ static int ocelot_mc_unsync(struct net_device *dev, const unsigned char *addr)
 	struct ocelot_mact_work_ctx w;
 
 	ether_addr_copy(w.forget.addr, addr);
-	w.forget.vid = ocelot_port->pvid_vlan.vid;
+	w.forget.vid = OCELOT_VLAN_UNAWARE_PVID;
 	w.type = OCELOT_MACT_FORGET;
 
 	return ocelot_enqueue_mact_action(ocelot, &w);
@@ -567,7 +567,7 @@ static int ocelot_mc_sync(struct net_device *dev, const unsigned char *addr)
 	struct ocelot_mact_work_ctx w;
 
 	ether_addr_copy(w.learn.addr, addr);
-	w.learn.vid = ocelot_port->pvid_vlan.vid;
+	w.learn.vid = OCELOT_VLAN_UNAWARE_PVID;
 	w.learn.pgid = PGID_CPU;
 	w.learn.entry_type = ENTRYTYPE_LOCKED;
 	w.type = OCELOT_MACT_LEARN;
@@ -602,9 +602,9 @@ static int ocelot_port_set_mac_address(struct net_device *dev, void *p)
 
 	/* Learn the new net device MAC address in the mac table. */
 	ocelot_mact_learn(ocelot, PGID_CPU, addr->sa_data,
-			  ocelot_port->pvid_vlan.vid, ENTRYTYPE_LOCKED);
+			  OCELOT_VLAN_UNAWARE_PVID, ENTRYTYPE_LOCKED);
 	/* Then forget the previous one. */
-	ocelot_mact_forget(ocelot, dev->dev_addr, ocelot_port->pvid_vlan.vid);
+	ocelot_mact_forget(ocelot, dev->dev_addr, OCELOT_VLAN_UNAWARE_PVID);
 
 	eth_hw_addr_set(dev, addr->sa_data);
 	return 0;
@@ -1707,7 +1707,7 @@ int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
 
 	eth_hw_addr_gen(dev, ocelot->base_mac, port);
 	ocelot_mact_learn(ocelot, PGID_CPU, dev->dev_addr,
-			  ocelot_port->pvid_vlan.vid, ENTRYTYPE_LOCKED);
+			  OCELOT_VLAN_UNAWARE_PVID, ENTRYTYPE_LOCKED);
 
 	ocelot_init_port(ocelot, port);
 
-- 
2.25.1

