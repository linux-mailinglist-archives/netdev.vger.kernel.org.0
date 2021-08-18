Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F763F0331
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 14:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236365AbhHRMEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 08:04:30 -0400
Received: from mail-eopbgr00085.outbound.protection.outlook.com ([40.107.0.85]:55044
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236326AbhHRMEN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 08:04:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nwNi5LcE1dYSWeSmAZONNw+R3hgNlOADi0LrEOxXJEpSfyqVKtCbHXoA/ZwTjF3NVq6PoGpJkg5f5Al5uqGYMOl36vEL6ElSKBxgnZOAmp/HXojCMO1V0JihpvKOl5/TbSjatrSK+2hyzrs5Y8Oj2rBbFQr4rrShHO7hqS9AD4vcaElGKKiS+8Pzi3Hff0hpxWPRNO1Yaj9fROPay09GPW4Vq9bmqIh3TZgroAagrYIDk239u209cmAuSBmz7XGeqnon0Jh/Ka86YTqWeV1guk9vafwklrAmp7nLk81nD2JJHhqNsj+XaiQ9EN9oMVTBYWc9srtgGUScxhRzODDXYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PnGXCCI4DnYnFkfuZ/jHpuN7dP1j0nlyKwMmmtgKBmQ=;
 b=XiwlBslLrHsRJuPKQBUUqW8757BsXChphLs8O3O4PZ5f5Jcmj0N8QhBv58Y4GZCBimyE+BwB2o3RaFjRGBG5aGYWVontptUusJ3gMJ5oc4GhjNpUJIaRv1JG1dbFA91Yi8SHi2IruFl93Iyz5+K0cSC1/bfZ7mSA7BGzRc9TYhwlZ1DgxgvwB0nWOWcYaUTI6p8nREW3y0UNn1BYVmlsx3dqzstEL0mZdWY+9Gb6eFzg8NVy6/kW/Nxmno+eGvSwE6P5dlPhkUh7AISBwNWv3nTqXP2LXkTP2t75wEHDvOlpgbH+yWqjdQCz6+mtxZ0f8VFSk4IxO9EIMlXXX3J3Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PnGXCCI4DnYnFkfuZ/jHpuN7dP1j0nlyKwMmmtgKBmQ=;
 b=cQunoFazeRzYCOkqDAierPcTU6j+prPevGSDnWXzsfg78pl3IDFU+d0IbDhye6SGcioJy5sADN0p5Hb4+PuZHfSNuPo+4TEfYWm/VCU+DPFPmoXcC8unG3yW9zuTyGr25jGBoeW9xh2jNUUY4yMxqh3+Jdibf6QA2tf/xOfM+P4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3839.eurprd04.prod.outlook.com (2603:10a6:803:21::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Wed, 18 Aug
 2021 12:03:07 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 12:03:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [RFC PATCH net-next 12/20] net: dsa: tag_8021q: merge RX and TX VLANs
Date:   Wed, 18 Aug 2021 15:01:42 +0300
Message-Id: <20210818120150.892647-13-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210818120150.892647-1-vladimir.oltean@nxp.com>
References: <20210818120150.892647-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0134.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VI1PR08CA0134.eurprd08.prod.outlook.com (2603:10a6:800:d5::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 12:03:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b50aa3b6-2b7f-4d2b-f39e-08d9624023e7
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3839:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3839E6E0E8CD281774B2C797E0FF9@VI1PR0402MB3839.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dy5GGNKPeARXvt6pyTK44yoFYmr1sUv074dk706J4ypEv23hgT9sybpj/fHR4VKF0UDRKL+BTkx8b8S2vWmm58Y1d+TkzFcjfPC5U+unKg64rKtQjodReA4sc/lzNkvogX5I/EHf9V5ogU8fSHbWspEGLiLwikole0EM8tfan/7JqqSbbAcZlbnMPU8tgbyMcDqPWZF5kElPmYG/Wj9A+U18++CwoXrTvNiEQD1jzduJvS0TYDZajPIgXEHy1Lzh5kJZ9yMoPea96eAdm8uekivfl5AtSVFL90h8CFEcyrW90PXmIRh4s2Jz83B/TGgAOcKWcRGGTgNKO90NibLx6axwneb7HkYMFgJfbXlCAp2V2gPGlPzORxM15pgiqh9IfyNaqJ3woJ2kpH9FgbvkuIumVQ9TAXy6/cs1J5qY8w0uyHctdmhSVHGfR6wBczu9qOBWfpIGEkqpwNvI3phTqWL123PkYWpzicnnoWdvyUeaTpLIqztvXPu9hvAopbZCVy9Xg2jWZTD1mJ1xB4KzMLpXnxGhPXBEV4+NxFpxKuQ3AkEC06Y3pVJtZv90eXiGdvQhtocm+NQHmoXCFLL3O0sud97HTjbo/uZN5NsgilkZhshneTJeIHsXMkQDkd75gpnAw6aC3uGp9L/4XkOrSLn1UwUtHyufwsXWNEKxakLYKFn3xcjrkZ5z0ZwYcX06uF6EgRXyookCeOuc8iTFCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39850400004)(366004)(376002)(66476007)(2906002)(66556008)(8936002)(6506007)(186003)(7406005)(7416002)(52116002)(26005)(86362001)(66946007)(6486002)(44832011)(36756003)(30864003)(5660300002)(1076003)(110136005)(54906003)(6512007)(8676002)(316002)(6666004)(38350700002)(38100700002)(956004)(478600001)(83380400001)(2616005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?17+K6FyxsmA5EZVcyLU7cVzvoe69FUfzEz9KKK87cBZ0iLM/RLoZg/Fxc1r/?=
 =?us-ascii?Q?ydoKYMsJMAR+EJR0b1JEidN1aXc2dFuiRLksIAZvteoIy7fIthdCP3FGi7eV?=
 =?us-ascii?Q?NKztqXbfew7pKfhydGvAABWK5hlQe3V7IvdoWYySdceArC9G6RRwsQU4f+aB?=
 =?us-ascii?Q?ayZSrh2LOKxcKgyhFF+vP1rlT3SFc3o0JpkLC1C8f6Mh1U9mymqbv1xgxpzN?=
 =?us-ascii?Q?GuZ0ROEBqY7rI+2XmYUufsGQutCCzLKkRYH0lYGoBAF5FCkbfvV9Wn0jP18d?=
 =?us-ascii?Q?Cdy2eYK6V57jC+F6tSuqCxtT0htqPreWyWrOeLXudo2EgSaNtjxVuF2hqcXL?=
 =?us-ascii?Q?lAhz7XB/Hi2zafL1IDSTw3NxSKYf2VP4n4PsPRZ3biNl3Un1R5NfMidjkOWO?=
 =?us-ascii?Q?pfGSR2c/lur4J9f+ZyyhYu0wDt4L5WvwWfy7Ailwg7KSnQHX5EK0eLhQaWwt?=
 =?us-ascii?Q?tNgbXEgDHA05PvUNmf27F88yMRneAXDDHIce9bTF2ON1waXG35DABmRs1po1?=
 =?us-ascii?Q?S3ddGvi8L36nGPImc+PQys4gpNkBS0uPp1G7WN77FD9hGMvDVED/NzZb6y/L?=
 =?us-ascii?Q?j6Lqgma+t6tkxw2v9cYwEE1dSIYlh0+dMTTErq0OIbfkYfnqRjAFlnxgOX7Q?=
 =?us-ascii?Q?S07EEUitLroncg8C5Z9I5oEe+GxXaTYGHWFuHaTGeRMrastS8hOz71NNF7ov?=
 =?us-ascii?Q?P3W0PmhaP+Jzh/b6YQCwLYdc5x2kTs5esTL0telZf9OhF0Ei6KZ5Df0V/aFK?=
 =?us-ascii?Q?rsS3BNP0z8umhaUqqHVPVX6TBWwZmywDoArU9hQcvWlslgSWcFmkCxOJmkFX?=
 =?us-ascii?Q?VA96D8Fi5iYPuRSjkYoo9TPYFx8wjldh/FDNO+eKZTjAXFtfJzO+Z4GU5xGT?=
 =?us-ascii?Q?4tgDzZG9W+iekODhw0UHOQ4G+SKAsIBKkWBZeEodlrctHW2zRmelBTAiEEGb?=
 =?us-ascii?Q?QlfqiyNLXmbABjxQtndbd+cMxAoyZGgYuqRrxDDOQVD8EJxa/topYpv50GnL?=
 =?us-ascii?Q?LBYnAjgUACbONRahxEgzetkekQCUdoZe65dMP6nD/2OQXQ7ESmP3mZ0zNwQZ?=
 =?us-ascii?Q?SnbqxKey1nxkY1LXhySlM4om4kmbfLHLfo7NLOY9+3DBlsUFg2AZKVbAMbIF?=
 =?us-ascii?Q?qNnOCK7ExSus1Ew0kYqzz6WLQnI83dkl3Sg/c7MUAtTYh2D4m9Gx5NhcfbG1?=
 =?us-ascii?Q?GjoDEzkMPyFozx+DR9tBu8OF1kg2SQ+y/8HNhgWhh5aEAiiqSA6fWwS8SyAK?=
 =?us-ascii?Q?8B5OodZR5Yd0ny1yLz5UYlx2m3y1yg+zSMbcsGqKLf+D/wxrgyR6Fq3aN9Ms?=
 =?us-ascii?Q?OADcyONOaSrnuLQxwZJYZQXt?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b50aa3b6-2b7f-4d2b-f39e-08d9624023e7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 12:03:07.1627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 47VVng3lvV3wkzhkksoSveXgm2JSG5CNKwaZyHS2gE9YGpsxC+LVxuuUjQUrm5ge+iS21yrgtfDnukphUWmU+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3839
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the old Shared VLAN Learning mode of operation that tag_8021q
previously used for forwarding, we needed to have distinct concepts for
an RX and a TX VLAN.

An RX VLAN could be installed on all ports that were members of a given
bridge, so that autonomous forwarding could still work, while a TX VLAN
was dedicated for precise packet steering, so it just contained the CPU
port and one egress port.

Now that tag_8021q uses Independent VLAN Learning and imprecise RX/TX
all over, those lines have been blurred and we no longer have the need
to do precise TX towards a port that is in a bridge. As for standalone
ports, it is fine to use the same VLAN ID for both RX and TX.

This patch changes the tag_8021q format by shifting the VLAN range it
reserves, and halving it. Previously, our DIR bits were encoding the
VLAN direction (RX/TX) and were set to either 1 or 2. This meant that
tag_8021q reserved 2K VLANs, or 50% of the available range.

Change the DIR bits to a hardcoded value of 3 now, which makes tag_8021q
reserve only 1K VLANs, and a different range now (the last 1K). This is
done so that we leave the old format in place in case we need to return
to it.

In terms of code, the vid_is_dsa_8021q_rxvlan and vid_is_dsa_8021q_txvlan
functions go away. Any vid_is_dsa_8021q is both a TX and an RX VLAN, and
they are no longer distinct. For example, felix which did different
things for different VLAN types, now needs to handle the RX and the TX
logic for the same VLAN.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c         | 120 +++++++++++++------------
 drivers/net/dsa/sja1105/sja1105_main.c |   2 +-
 drivers/net/dsa/sja1105/sja1105_vl.c   |   4 +-
 include/linux/dsa/8021q.h              |   9 +-
 net/dsa/tag_8021q.c                    | 113 +++++++----------------
 net/dsa/tag_ocelot_8021q.c             |   2 +-
 net/dsa/tag_sja1105.c                  |   4 +-
 7 files changed, 103 insertions(+), 151 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index d86015c59c5f..747dd739f533 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -26,8 +26,10 @@
 #include <net/dsa.h>
 #include "felix.h"
 
-static int felix_tag_8021q_rxvlan_add(struct felix *felix, int port, u16 vid,
-				      bool pvid, bool untagged)
+/* Set up VCAP ES0 rules for pushing a tag_8021q VLAN towards the CPU such that
+ * the tagger can perform RX source port identification.
+ */
+static int felix_tag_8021q_vlan_add_rx(struct felix *felix, int port, u16 vid)
 {
 	struct ocelot_vcap_filter *outer_tagging_rule;
 	struct ocelot *ocelot = &felix->ocelot;
@@ -65,21 +67,32 @@ static int felix_tag_8021q_rxvlan_add(struct felix *felix, int port, u16 vid,
 	return err;
 }
 
-static int felix_tag_8021q_txvlan_add(struct felix *felix, int port, u16 vid,
-				      bool pvid, bool untagged)
+static int felix_tag_8021q_vlan_del_rx(struct felix *felix, int port, u16 vid)
+{
+	struct ocelot_vcap_filter *outer_tagging_rule;
+	struct ocelot_vcap_block *block_vcap_es0;
+	struct ocelot *ocelot = &felix->ocelot;
+
+	block_vcap_es0 = &ocelot->block[VCAP_ES0];
+
+	outer_tagging_rule = ocelot_vcap_block_find_filter_by_id(block_vcap_es0,
+								 port, false);
+	if (!outer_tagging_rule)
+		return -ENOENT;
+
+	return ocelot_vcap_filter_del(ocelot, outer_tagging_rule);
+}
+
+/* Set up VCAP IS1 rules for stripping the tag_8021q VLAN on TX and VCAP IS2
+ * rules for steering those tagged packets towards the correct destination port
+ */
+static int felix_tag_8021q_vlan_add_tx(struct felix *felix, int port, u16 vid)
 {
 	struct ocelot_vcap_filter *untagging_rule, *redirect_rule;
 	struct ocelot *ocelot = &felix->ocelot;
 	struct dsa_switch *ds = felix->ds;
 	int upstream, err;
 
-	/* tag_8021q.c assumes we are implementing this via port VLAN
-	 * membership, which we aren't. So we don't need to add any VCAP filter
-	 * for the CPU port.
-	 */
-	if (ocelot->ports[port]->is_dsa_8021q_cpu)
-		return 0;
-
 	untagging_rule = kzalloc(sizeof(struct ocelot_vcap_filter), GFP_KERNEL);
 	if (!untagging_rule)
 		return -ENOMEM;
@@ -136,41 +149,7 @@ static int felix_tag_8021q_txvlan_add(struct felix *felix, int port, u16 vid,
 	return 0;
 }
 
-static int felix_tag_8021q_vlan_add(struct dsa_switch *ds, int port, u16 vid,
-				    u16 flags)
-{
-	bool untagged = flags & BRIDGE_VLAN_INFO_UNTAGGED;
-	bool pvid = flags & BRIDGE_VLAN_INFO_PVID;
-	struct ocelot *ocelot = ds->priv;
-
-	if (vid_is_dsa_8021q_rxvlan(vid))
-		return felix_tag_8021q_rxvlan_add(ocelot_to_felix(ocelot),
-						  port, vid, pvid, untagged);
-
-	if (vid_is_dsa_8021q_txvlan(vid))
-		return felix_tag_8021q_txvlan_add(ocelot_to_felix(ocelot),
-						  port, vid, pvid, untagged);
-
-	return 0;
-}
-
-static int felix_tag_8021q_rxvlan_del(struct felix *felix, int port, u16 vid)
-{
-	struct ocelot_vcap_filter *outer_tagging_rule;
-	struct ocelot_vcap_block *block_vcap_es0;
-	struct ocelot *ocelot = &felix->ocelot;
-
-	block_vcap_es0 = &ocelot->block[VCAP_ES0];
-
-	outer_tagging_rule = ocelot_vcap_block_find_filter_by_id(block_vcap_es0,
-								 port, false);
-	if (!outer_tagging_rule)
-		return -ENOENT;
-
-	return ocelot_vcap_filter_del(ocelot, outer_tagging_rule);
-}
-
-static int felix_tag_8021q_txvlan_del(struct felix *felix, int port, u16 vid)
+static int felix_tag_8021q_vlan_del_tx(struct felix *felix, int port, u16 vid)
 {
 	struct ocelot_vcap_filter *untagging_rule, *redirect_rule;
 	struct ocelot_vcap_block *block_vcap_is1;
@@ -178,9 +157,6 @@ static int felix_tag_8021q_txvlan_del(struct felix *felix, int port, u16 vid)
 	struct ocelot *ocelot = &felix->ocelot;
 	int err;
 
-	if (ocelot->ports[port]->is_dsa_8021q_cpu)
-		return 0;
-
 	block_vcap_is1 = &ocelot->block[VCAP_IS1];
 	block_vcap_is2 = &ocelot->block[VCAP_IS2];
 
@@ -196,22 +172,54 @@ static int felix_tag_8021q_txvlan_del(struct felix *felix, int port, u16 vid)
 	redirect_rule = ocelot_vcap_block_find_filter_by_id(block_vcap_is2,
 							    port, false);
 	if (!redirect_rule)
-		return 0;
+		return -ENOENT;
 
 	return ocelot_vcap_filter_del(ocelot, redirect_rule);
 }
 
+static int felix_tag_8021q_vlan_add(struct dsa_switch *ds, int port, u16 vid,
+				    u16 flags)
+{
+	struct ocelot *ocelot = ds->priv;
+	int err;
+
+	/* tag_8021q.c assumes we are implementing this via port VLAN
+	 * membership, which we aren't. So we don't need to add any VCAP filter
+	 * for the CPU port.
+	 */
+	if (!dsa_is_user_port(ds, port))
+		return 0;
+
+	err = felix_tag_8021q_vlan_add_rx(ocelot_to_felix(ocelot), port, vid);
+	if (err)
+		return err;
+
+	err = felix_tag_8021q_vlan_add_tx(ocelot_to_felix(ocelot), port, vid);
+	if (err) {
+		felix_tag_8021q_vlan_del_rx(ocelot_to_felix(ocelot), port, vid);
+		return err;
+	}
+
+	return 0;
+}
+
 static int felix_tag_8021q_vlan_del(struct dsa_switch *ds, int port, u16 vid)
 {
 	struct ocelot *ocelot = ds->priv;
+	int err;
+
+	if (!dsa_is_user_port(ds, port))
+		return 0;
 
-	if (vid_is_dsa_8021q_rxvlan(vid))
-		return felix_tag_8021q_rxvlan_del(ocelot_to_felix(ocelot),
-						  port, vid);
+	err = felix_tag_8021q_vlan_del_rx(ocelot_to_felix(ocelot), port, vid);
+	if (err)
+		return err;
 
-	if (vid_is_dsa_8021q_txvlan(vid))
-		return felix_tag_8021q_txvlan_del(ocelot_to_felix(ocelot),
-						  port, vid);
+	err = felix_tag_8021q_vlan_del_tx(ocelot_to_felix(ocelot), port, vid);
+	if (err) {
+		felix_tag_8021q_vlan_add_rx(ocelot_to_felix(ocelot), port, vid);
+		return err;
+	}
 
 	return 0;
 }
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 1d05a6234a6d..3c319114e292 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2440,7 +2440,7 @@ static int sja1105_bridge_vlan_add(struct dsa_switch *ds, int port,
 	 */
 	if (vid_is_dsa_8021q(vlan->vid)) {
 		NL_SET_ERR_MSG_MOD(extack,
-				   "Range 1024-3071 reserved for dsa_8021q operation");
+				   "Range 3072-4095 reserved for dsa_8021q operation");
 		return -EBUSY;
 	}
 
diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c b/drivers/net/dsa/sja1105/sja1105_vl.c
index ec7b65daec20..5bc6df63137a 100644
--- a/drivers/net/dsa/sja1105/sja1105_vl.c
+++ b/drivers/net/dsa/sja1105/sja1105_vl.c
@@ -394,7 +394,9 @@ static int sja1105_init_virtual_links(struct sja1105_private *priv,
 				vl_lookup[k].vlanid = rule->key.vl.vid;
 				vl_lookup[k].vlanprior = rule->key.vl.pcp;
 			} else {
-				u16 vid = dsa_8021q_rx_vid(priv->ds, port);
+				/* FIXME */
+				struct dsa_port *dp = dsa_to_port(priv->ds, port);
+				u16 vid = dsa_tag_8021q_standalone_vid(dp);
 
 				vl_lookup[k].vlanid = vid;
 				vl_lookup[k].vlanprior = 0;
diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index ac537d983fee..5c67ac422282 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -9,6 +9,7 @@
 #include <linux/types.h>
 
 struct dsa_switch;
+struct dsa_port;
 struct sk_buff;
 struct net_device;
 
@@ -47,18 +48,12 @@ struct net_device *dsa_tag_8021q_find_port_by_vbid(struct net_device *master,
 
 u16 dsa_8021q_bridge_tx_fwd_offload_vid(int bridge_num);
 
-u16 dsa_8021q_tx_vid(struct dsa_switch *ds, int port);
-
-u16 dsa_8021q_rx_vid(struct dsa_switch *ds, int port);
+u16 dsa_tag_8021q_standalone_vid(struct dsa_port *dp);
 
 int dsa_8021q_rx_switch_id(u16 vid);
 
 int dsa_8021q_rx_source_port(u16 vid);
 
-bool vid_is_dsa_8021q_rxvlan(u16 vid);
-
-bool vid_is_dsa_8021q_txvlan(u16 vid);
-
 bool vid_is_dsa_8021q(u16 vid);
 
 #endif /* _NET_DSA_8021Q_H */
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index b47a4f7a67bb..76e4b99ecd89 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -17,15 +17,11 @@
  *
  * | 11  | 10  |  9  |  8  |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0  |
  * +-----------+-----+-----------------+-----------+-----------------------+
- * |    DIR    | VBID|    SWITCH_ID    |   VBID    |          PORT         |
+ * |    RSV    | VBID|    SWITCH_ID    |   VBID    |          PORT         |
  * +-----------+-----+-----------------+-----------+-----------------------+
  *
- * DIR - VID[11:10]:
- *	Direction flags.
- *	* 1 (0b01) for RX VLAN,
- *	* 2 (0b10) for TX VLAN.
- *	These values make the special VIDs of 0, 1 and 4095 to be left
- *	unused by this coding scheme.
+ * RSV - VID[11:10]:
+ *	Reserved. Must be set to 3 (0b11).
  *
  * SWITCH_ID - VID[8:6]:
  *	Index of switch within DSA tree. Must be between 0 and 7.
@@ -39,12 +35,11 @@
  *	Index of switch port. Must be between 0 and 15.
  */
 
-#define DSA_8021Q_DIR_SHIFT		10
-#define DSA_8021Q_DIR_MASK		GENMASK(11, 10)
-#define DSA_8021Q_DIR(x)		(((x) << DSA_8021Q_DIR_SHIFT) & \
-						 DSA_8021Q_DIR_MASK)
-#define DSA_8021Q_DIR_RX		DSA_8021Q_DIR(1)
-#define DSA_8021Q_DIR_TX		DSA_8021Q_DIR(2)
+#define DSA_8021Q_RSV_VAL		3
+#define DSA_8021Q_RSV_SHIFT		10
+#define DSA_8021Q_RSV_MASK		GENMASK(11, 10)
+#define DSA_8021Q_RSV			((DSA_8021Q_RSV_VAL << DSA_8021Q_RSV_SHIFT) & \
+							       DSA_8021Q_RSV_MASK)
 
 #define DSA_8021Q_SWITCH_ID_SHIFT	6
 #define DSA_8021Q_SWITCH_ID_MASK	GENMASK(8, 6)
@@ -71,29 +66,19 @@
 u16 dsa_8021q_bridge_tx_fwd_offload_vid(int bridge_num)
 {
 	/* The VBID value of 0 is reserved for precise TX */
-	return DSA_8021Q_DIR_TX | DSA_8021Q_VBID(bridge_num + 1);
+	return DSA_8021Q_RSV | DSA_8021Q_VBID(bridge_num + 1);
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_bridge_tx_fwd_offload_vid);
 
-/* Returns the VID to be inserted into the frame from xmit for switch steering
- * instructions on egress. Encodes switch ID and port ID.
- */
-u16 dsa_8021q_tx_vid(struct dsa_switch *ds, int port)
-{
-	return DSA_8021Q_DIR_TX | DSA_8021Q_SWITCH_ID(ds->index) |
-	       DSA_8021Q_PORT(port);
-}
-EXPORT_SYMBOL_GPL(dsa_8021q_tx_vid);
-
 /* Returns the VID that will be installed as pvid for this switch port, sent as
  * tagged egress towards the CPU port and decoded by the rcv function.
  */
-u16 dsa_8021q_rx_vid(struct dsa_switch *ds, int port)
+u16 dsa_tag_8021q_standalone_vid(struct dsa_port *dp)
 {
-	return DSA_8021Q_DIR_RX | DSA_8021Q_SWITCH_ID(ds->index) |
-	       DSA_8021Q_PORT(port);
+	return DSA_8021Q_RSV | DSA_8021Q_SWITCH_ID(dp->ds->index) |
+	       DSA_8021Q_PORT(dp->index);
 }
-EXPORT_SYMBOL_GPL(dsa_8021q_rx_vid);
+EXPORT_SYMBOL_GPL(dsa_tag_8021q_standalone_vid);
 
 /* Returns the decoded switch ID from the RX VID. */
 int dsa_8021q_rx_switch_id(u16 vid)
@@ -118,21 +103,11 @@ static int dsa_tag_8021q_rx_vbid(u16 vid)
 	return (vbid_hi << 2) | vbid_lo;
 }
 
-bool vid_is_dsa_8021q_rxvlan(u16 vid)
-{
-	return (vid & DSA_8021Q_DIR_MASK) == DSA_8021Q_DIR_RX;
-}
-EXPORT_SYMBOL_GPL(vid_is_dsa_8021q_rxvlan);
-
-bool vid_is_dsa_8021q_txvlan(u16 vid)
-{
-	return (vid & DSA_8021Q_DIR_MASK) == DSA_8021Q_DIR_TX;
-}
-EXPORT_SYMBOL_GPL(vid_is_dsa_8021q_txvlan);
-
 bool vid_is_dsa_8021q(u16 vid)
 {
-	return vid_is_dsa_8021q_rxvlan(vid) || vid_is_dsa_8021q_txvlan(vid);
+	u16 rsv = (vid & DSA_8021Q_RSV_MASK) >> DSA_8021Q_RSV_SHIFT;
+
+	return rsv == DSA_8021Q_RSV_VAL;
 }
 EXPORT_SYMBOL_GPL(vid_is_dsa_8021q);
 
@@ -246,18 +221,8 @@ int dsa_switch_tag_8021q_vlan_add(struct dsa_switch *ds,
 			u16 flags = 0;
 
 			if (dsa_is_user_port(ds, port))
-				flags |= BRIDGE_VLAN_INFO_UNTAGGED;
-
-			/* Standalone VLANs are PVIDs */
-			if (vid_is_dsa_8021q_rxvlan(info->vid) &&
-			    dsa_8021q_rx_switch_id(info->vid) == ds->index &&
-			    dsa_8021q_rx_source_port(info->vid) == port)
-				flags |= BRIDGE_VLAN_INFO_PVID;
-
-			/* And bridging VLANs are PVIDs too on user ports */
-			if (dsa_tag_8021q_rx_vbid(info->vid) &&
-			    dsa_is_user_port(ds, port))
-				flags |= BRIDGE_VLAN_INFO_PVID;
+				flags |= BRIDGE_VLAN_INFO_UNTAGGED |
+					 BRIDGE_VLAN_INFO_PVID;
 
 			err = dsa_switch_do_tag_8021q_vlan_add(ds, port,
 							       info->vid,
@@ -347,7 +312,7 @@ int dsa_tag_8021q_bridge_join(struct dsa_switch *ds, int port,
 	/* Delete the standalone VLAN of the port and replace it with a
 	 * bridging VLAN
 	 */
-	standalone_vid = dsa_8021q_rx_vid(ds, port);
+	standalone_vid = dsa_tag_8021q_standalone_vid(dp);
 	bridge_vid = dsa_8021q_bridge_tx_fwd_offload_vid(bridge_num);
 
 	dsa_port_tag_8021q_vlan_del(dp, standalone_vid, false);
@@ -372,7 +337,7 @@ void dsa_tag_8021q_bridge_leave(struct dsa_switch *ds, int port,
 	/* Delete the bridging VLAN of the port and replace it with a
 	 * standalone VLAN
 	 */
-	standalone_vid = dsa_8021q_rx_vid(ds, port);
+	standalone_vid = dsa_tag_8021q_standalone_vid(dp);
 	bridge_vid = dsa_8021q_bridge_tx_fwd_offload_vid(bridge_num);
 
 	dsa_port_tag_8021q_vlan_del(dp, bridge_vid, true);
@@ -387,13 +352,12 @@ void dsa_tag_8021q_bridge_leave(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL_GPL(dsa_tag_8021q_bridge_leave);
 
-/* Set up a port's tag_8021q RX and TX VLAN for standalone mode operation */
+/* Set up a port's standalone tag_8021q VLAN */
 static int dsa_tag_8021q_port_setup(struct dsa_switch *ds, int port)
 {
 	struct dsa_8021q_context *ctx = ds->tag_8021q_ctx;
 	struct dsa_port *dp = dsa_to_port(ds, port);
-	u16 rx_vid = dsa_8021q_rx_vid(ds, port);
-	u16 tx_vid = dsa_8021q_tx_vid(ds, port);
+	u16 vid = dsa_tag_8021q_standalone_vid(dp);
 	struct net_device *master;
 	int err;
 
@@ -405,30 +369,16 @@ static int dsa_tag_8021q_port_setup(struct dsa_switch *ds, int port)
 
 	master = dp->cpu_dp->master;
 
-	/* Add this user port's RX VID to the membership list of all others
-	 * (including itself). This is so that bridging will not be hindered.
-	 * L2 forwarding rules still take precedence when there are no VLAN
-	 * restrictions, so there are no concerns about leaking traffic.
-	 */
-	err = dsa_port_tag_8021q_vlan_add(dp, rx_vid, false);
+	err = dsa_port_tag_8021q_vlan_add(dp, vid, false);
 	if (err) {
 		dev_err(ds->dev,
-			"Failed to apply RX VID %d to port %d: %pe\n",
-			rx_vid, port, ERR_PTR(err));
+			"Failed to apply standalone VID %d to port %d: %pe\n",
+			vid, port, ERR_PTR(err));
 		return err;
 	}
 
-	/* Add @rx_vid to the master's RX filter. */
-	vlan_vid_add(master, ctx->proto, rx_vid);
-
-	/* Finally apply the TX VID on this port and on the CPU port */
-	err = dsa_port_tag_8021q_vlan_add(dp, tx_vid, false);
-	if (err) {
-		dev_err(ds->dev,
-			"Failed to apply TX VID %d on port %d: %pe\n",
-			tx_vid, port, ERR_PTR(err));
-		return err;
-	}
+	/* Add the VLAN to the master's RX filter. */
+	vlan_vid_add(master, ctx->proto, vid);
 
 	return err;
 }
@@ -437,8 +387,7 @@ static void dsa_tag_8021q_port_teardown(struct dsa_switch *ds, int port)
 {
 	struct dsa_8021q_context *ctx = ds->tag_8021q_ctx;
 	struct dsa_port *dp = dsa_to_port(ds, port);
-	u16 rx_vid = dsa_8021q_rx_vid(ds, port);
-	u16 tx_vid = dsa_8021q_tx_vid(ds, port);
+	u16 vid = dsa_tag_8021q_standalone_vid(dp);
 	struct net_device *master;
 
 	/* The CPU port is implicitly configured by
@@ -449,11 +398,9 @@ static void dsa_tag_8021q_port_teardown(struct dsa_switch *ds, int port)
 
 	master = dp->cpu_dp->master;
 
-	dsa_port_tag_8021q_vlan_del(dp, rx_vid, false);
-
-	vlan_vid_del(master, ctx->proto, rx_vid);
+	dsa_port_tag_8021q_vlan_del(dp, vid, false);
 
-	dsa_port_tag_8021q_vlan_del(dp, tx_vid, false);
+	vlan_vid_del(master, ctx->proto, vid);
 }
 
 static int dsa_tag_8021q_setup(struct dsa_switch *ds)
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index 5bf848446106..df0fae88ab7a 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -17,9 +17,9 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 				   struct net_device *netdev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(netdev);
-	u16 tx_vid = dsa_8021q_tx_vid(dp->ds, dp->index);
 	u16 queue_mapping = skb_get_queue_mapping(skb);
 	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
+	u16 tx_vid = dsa_tag_8021q_standalone_vid(dp);
 	struct ocelot *ocelot = dp->ds->priv;
 	int port = dp->index;
 	u32 rew_op = 0;
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 088709ef877a..52002aa2a045 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -172,9 +172,9 @@ static struct sk_buff *sja1105_xmit(struct sk_buff *skb,
 				    struct net_device *netdev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(netdev);
-	u16 tx_vid = dsa_8021q_tx_vid(dp->ds, dp->index);
 	u16 queue_mapping = skb_get_queue_mapping(skb);
 	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
+	u16 tx_vid = dsa_tag_8021q_standalone_vid(dp);
 
 	if (skb->offload_fwd_mark)
 		return sja1105_imprecise_xmit(skb, netdev);
@@ -195,9 +195,9 @@ static struct sk_buff *sja1110_xmit(struct sk_buff *skb,
 {
 	struct sk_buff *clone = SJA1105_SKB_CB(skb)->clone;
 	struct dsa_port *dp = dsa_slave_to_port(netdev);
-	u16 tx_vid = dsa_8021q_tx_vid(dp->ds, dp->index);
 	u16 queue_mapping = skb_get_queue_mapping(skb);
 	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
+	u16 tx_vid = dsa_tag_8021q_standalone_vid(dp);
 	__be32 *tx_trailer;
 	__be16 *tx_header;
 	int trailer_pos;
-- 
2.25.1

