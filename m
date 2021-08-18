Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCF13F033E
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 14:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235842AbhHRMGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 08:06:11 -0400
Received: from mail-eopbgr00079.outbound.protection.outlook.com ([40.107.0.79]:39586
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236306AbhHRMEM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 08:04:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c7N1af6VsnxG20YbC2QSz8i2hvkK/XWFfRl8bcZ+slBGsxUmsSIb8NElSwcIb4hxvzDZadzelTo9axXkx0MiquQgFuhhP9dkMYmSPw01UDvXDUo26y6jiuLGlJjGO3boIhZ0NFsw/Dnvo1r1XqXB53GC+QqtEuRUHcCLOS0jUCY1u6ppxyJlSOhWMdFk76jeQx3o7bdopeuNFu24rmwJPqqbkCo5QjEl6MAEgU72YanQWy/xIb/CLdHJji75bDWHZKWBTdvmjo6AC4lPEvdlQSEfmOR5l1FLgtF751ME+qR6e0Qk+WBPbgexffzhYPx0fJcCS4vtBPiWe0tz6tFgdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZ7Auj+q1GvxQeA1+Iku1NmwjvTWzxagiNBvPaQMEZA=;
 b=CzOYcfcShRgiSvG5npYrmP23I9jTfi9Vob4KoFGR1kxVDVBXwOECN9xqCH76FjkR8TwOF8cgnOShPuTYoEKmgdqthRNeXL6q8Qkf3ToiUBa8I2W/AFOR8RZ6f7HrrhHofexSp0flvn5Ck53H0VLhA+lvr/+Wrek/TNLgLOo0Kr7uGKorOIuhfB6dByWFZCstNUma0KFerkAZajP2+pzI4sWTu8qbgdNoJ6nF9/s5KAGAatVcDqabsnmRvqW/POcQNfVY8Q0kut6yYeTVbp7z/gvYWVCXm8cPSQPcmyFXkJ7Y6MrUN6rKWZga7/u2fZYDz70Aewou9zPfZbvHSk8ByA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZ7Auj+q1GvxQeA1+Iku1NmwjvTWzxagiNBvPaQMEZA=;
 b=UbezpKq31ufJ7bWnSUO50MujoyCKxVcOQToc0KeF9/L/WmvkmSHe7LCjOSpc/DROUvUIEAcnnPHuzavfpjnCQWVE3h5RXCez7VLA1mrQ4E7/p/oouEkyKOEojPCcdKuhiXsO7HaANKxkjRSB3I7AJxRIfyfXmLayexIi/1m2wuc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3839.eurprd04.prod.outlook.com (2603:10a6:803:21::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Wed, 18 Aug
 2021 12:03:06 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 12:03:05 +0000
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
Subject: [RFC PATCH net-next 11/20] net: dsa: felix: delete workarounds present due to SVL tag_8021q bridging
Date:   Wed, 18 Aug 2021 15:01:41 +0300
Message-Id: <20210818120150.892647-12-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.144.60) by VI1PR08CA0134.eurprd08.prod.outlook.com (2603:10a6:800:d5::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 12:03:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d219f2a1-0d54-48d4-e43d-08d96240230b
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3839:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3839AFCFCA4E544086323B38E0FF9@VI1PR0402MB3839.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6TnrEwF8lWgcvVzxEAYBMbbZGUc/F4C6dyp9qHgqnZufEu03SeNew6GiuZVzRbgOFSdOPonJVgQluvGIfURB5JZU5yk0E0cAgREPLVZhBKacuyKdEarU4+ZD+7GD3ebZKYloYEXuSO1ushUkhB/tWeHuSP0EqViNpBarmMN3ACPX7yuDsCGHCjpX5wn6S7cAXa09IsMssSUz5W7AnOaVyLRSDpxbe9mrHIGHrg/9Piz2dstqrpEHGAKujDramEUFkVn3PxGm1lyVhBN1RO4AeD7uORDijUM3+yx2qRhbwqr96yt6RrQpBC92MTuaKyR5bs8SjvfeQVrUZ0knq/1dfiQpwTgxcuuNoh2sTLSoosXa2P5nbcxqPcU8pld/UT/Rql67+NCWHMEhyGL0ssCKeBCbUDRub0+WMhw4pytiAHVAKp68ImJpopVbxLk2DYqjNvEiqb4clwSZcCtmjJYIWB/nCD1m1j3K0FGJpk53lSNrj/WYbcGCJvcgDvVnq094VnvFWP1smELm6vCrS39nN95BYFj0nkKFySSEJchb4JQ4ykvg4QloVja8SWBRotJ9IazGgto0x7dkwLqZSrZ4wHFVbzy29lyKtmvXFCALhzMfI9eyxN9EhYmTyCHn8Oz/a70ygULzeS10wgcnhVnlC943RjTdPADkDQ1hX3+yIU159ZaDxomBtNzbDvR9K1lnGy09/ztWGaQfAar9tF7Q/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39850400004)(366004)(376002)(66476007)(2906002)(66556008)(8936002)(6506007)(186003)(7406005)(7416002)(52116002)(26005)(86362001)(66946007)(6486002)(44832011)(36756003)(5660300002)(1076003)(110136005)(54906003)(6512007)(8676002)(316002)(6666004)(38350700002)(38100700002)(956004)(478600001)(83380400001)(2616005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RcyupGXC/nleNISZI5KfF3aboeGWaF7XTYvNu2wWonu+j38rjEPg1n38iSpy?=
 =?us-ascii?Q?tse8oWnqQM4cEZ3U18cms0ocO51I+PjfodXLHOq4j5cdJhyNrjavFn6zavRm?=
 =?us-ascii?Q?cHwPAgncmW0avDIGjNOGPtmdSsYeyK1YY9kGpcvPSwvI4NjDCnbSPC3oWp5h?=
 =?us-ascii?Q?Rj66NWLiEaxyAPCUF4W7WH3l7hAwXgJAXxGSeTLUyy2sBNRcsaKQysXf/ZjW?=
 =?us-ascii?Q?kZnLhN8SBGAZG1hprr004VZsxD0xa3IjPcofvyFT8Gn9YWwByoUFl0QmEqgO?=
 =?us-ascii?Q?YHVWXogfae9cmgipKVpDKGQK9V0tQdoBRxNO7c70B5U0jX+I8as0HrUap0xa?=
 =?us-ascii?Q?KHl3iUerHCu7b2oFeHOfqBtcBVI8agPlWvpRFs3NgxLvmvNVa5Svi93674W7?=
 =?us-ascii?Q?FbNC0XF5eUhaa1FF0N2nKd8wjn80KOELdDl+VK3LM3+eyqj6jpK7WARnu3FP?=
 =?us-ascii?Q?lkW6TW4BylKx+WMc/xBNUK+XQk34C8RRfz6GnhIru6s47MGVpFCOV/WYqLYU?=
 =?us-ascii?Q?etmZsdWmBxtaX6M90VOXyPZBH96oixRaQdcl2bi/iVTU+FNFvuUSKpV/06A5?=
 =?us-ascii?Q?Gy3uQzW6BxX8+GVdF8DpWZLl+rLRsxqVDc+m6utpNEoDhBim8+JaoRVoCGQ6?=
 =?us-ascii?Q?8ZsVK05VCvQeN9Z1M3z/afGHFynJduqiGLyuiAI/VzzKEfR4z3oeHRcmBJ6M?=
 =?us-ascii?Q?kjQi60rfdsh3DnmbBcndj0H73LDT8wAXLGAmnbTD8O/bZ1NytVO9IolktvV7?=
 =?us-ascii?Q?8n7shvemmzaTHtH64GDiKeDTR70ErY59AnzAAtHzSvokcUl0i/ICHgXd62yU?=
 =?us-ascii?Q?+XgP349SaArL3NRYpmOxJRJ3EoIP/XLA/OTuQJklVjlMFCGGWfme0oMUUmHh?=
 =?us-ascii?Q?PbRQERY5WaIyY+LL8Z3JroXA52KjoNKuI2VLhn06awVjc46gOHrgENvJqhIy?=
 =?us-ascii?Q?8hDJHTJcG/JtiaePn4W75CIxe4XDvVhnZg60qMyo7KZjzFAQN5H1oFC1S/mt?=
 =?us-ascii?Q?AsW5NI/P6CydcdcwX/PIOGOeF9iZfMOcvkDIPDaUKv/saxychS4DSAHApCvm?=
 =?us-ascii?Q?B8r2aVuW+NHNpIoGzMFyWvG4AT+94wQXPcJAdbIzpmWsfge5oI0AIQv75GqM?=
 =?us-ascii?Q?kE7nVxyJ6TkQYOFlbmbSnkl46Y3Vcwkp3HKSW5RDDobiJgN/ti7Rryb3TeCY?=
 =?us-ascii?Q?IyGNE1+BCL77eu6xw+i3eeqPxoOTxMalgz4uGdJO8PiSmrnnKqIhHXusghez?=
 =?us-ascii?Q?qNAQRIU0lStlg0vTo7IiCPhsWkmNDnIesEnh2YcLSZrhC4orWLo8idTP8SZl?=
 =?us-ascii?Q?MqA3apdoPzclqro2bZwUu5Vq?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d219f2a1-0d54-48d4-e43d-08d96240230b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 12:03:05.7555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZoHM52sd/ULhAO7cH363b4o8NvgNd2C2HtC6Kjq7KGsE70cBvwnsLgVINBeRb85b74GgDpSBkfOsDz7TrfdQIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3839
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The felix driver, which also has a tagging protocol implementation based
on tag_8021q, does not care about adding the RX VLAN that is pvid on one
port on the other ports that are in the same bridge with it. It simply
doesn't need that, because in its implementation, the RX VLAN that is
pvid of a port is only used to install a TCAM rule that pushes that VLAN
ID towards the CPU port.

Now that tag_8021q no longer performs Shared VLAN Learning based
forwarding, the RX VLANs are actually segregated into two types:
standalone VLANs and VLAN-unaware bridging VLANs. Since you actually
have to call dsa_tag_8021q_bridge_join() to get a bridging VLAN from
tag_8021q, and felix does not do that because it doesn't need it, it
means that it only gets standalone port VLANs from tag_8021q. Which is
perfect because this means it can drop its workarounds that avoid the
VLANs it does not need.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 3ab7cf2f0f50..d86015c59c5f 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -34,13 +34,6 @@ static int felix_tag_8021q_rxvlan_add(struct felix *felix, int port, u16 vid,
 	struct dsa_switch *ds = felix->ds;
 	int key_length, upstream, err;
 
-	/* We don't need to install the rxvlan into the other ports' filtering
-	 * tables, because we're just pushing the rxvlan when sending towards
-	 * the CPU
-	 */
-	if (!pvid)
-		return 0;
-
 	key_length = ocelot->vcap[VCAP_ES0].keys[VCAP_ES0_IGR_PORT].length;
 	upstream = dsa_upstream_port(ds, port);
 
@@ -171,16 +164,8 @@ static int felix_tag_8021q_rxvlan_del(struct felix *felix, int port, u16 vid)
 
 	outer_tagging_rule = ocelot_vcap_block_find_filter_by_id(block_vcap_es0,
 								 port, false);
-	/* In rxvlan_add, we had the "if (!pvid) return 0" logic to avoid
-	 * installing outer tagging ES0 rules where they weren't needed.
-	 * But in rxvlan_del, the API doesn't give us the "flags" anymore,
-	 * so that forces us to be slightly sloppy here, and just assume that
-	 * if we didn't find an outer_tagging_rule it means that there was
-	 * none in the first place, i.e. rxvlan_del is called on a non-pvid
-	 * port. This is most probably true though.
-	 */
 	if (!outer_tagging_rule)
-		return 0;
+		return -ENOENT;
 
 	return ocelot_vcap_filter_del(ocelot, outer_tagging_rule);
 }
@@ -202,7 +187,7 @@ static int felix_tag_8021q_txvlan_del(struct felix *felix, int port, u16 vid)
 	untagging_rule = ocelot_vcap_block_find_filter_by_id(block_vcap_is1,
 							     port, false);
 	if (!untagging_rule)
-		return 0;
+		return -ENOENT;
 
 	err = ocelot_vcap_filter_del(ocelot, untagging_rule);
 	if (err)
-- 
2.25.1

