Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B52E242A37D
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 13:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236292AbhJLLnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 07:43:18 -0400
Received: from mail-eopbgr60075.outbound.protection.outlook.com ([40.107.6.75]:6350
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236177AbhJLLnM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 07:43:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H4J+Jxkn4C+S5ezz/AgLhSld65KuxvCXCOJfsf4q1EdRjD/M8tbsxGX0C6Ac+yH4Ww1juwMOP40WGq7xfcEJCyeDzC6YLzGVg9O67iyIjx0lcaJH+o/zVD53Uw0ZMWEC/H3ih2NnKrg8o1H4G6nJUQQpb7LLSmgkn2GB2/r5DR4QOWnnN7mi8MzkgeX9QT9W/9wd2Wnp4oi2aJBf8fTRnbF3j4xXclEImr9FE3FDc0AFulIDwJS4S0lUq7CegYT6L8LKqoZCr+FdfYNuwmqEiMyKsmjyJMWg3hTRd+HUxVqrlk3vw+YF4JDYW1Zng+DGRdfAcM6s2ZMbcqBx9YLRWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V7CzHZoyR0j7B76SslBhEDYT6rdHPH8S3xhEgbRpEwY=;
 b=VRzB3SpjNNkQ5GKPWnaqZVSeWGaoq6jbjpRVLGOhxoJCVJywaUI87evS197pwUdBKIjMaldvCE+Cl4jocZF12/i2FCZjQxOdGK3Yeebem9YltFxO50ASnHtCeKdn+a2vzKvkUnEt+dKd+sjK9K0p/mtmWn9ewv+krDyueekhYsjonZlnSoAkJXeYWLmm1aVuRRhRunHyj1n8fM/AJ3213RAaX6K/1SR6GmHy3TLZkqCTuZKp8RzyUyHMwLXqhp5snX/XfsQUpL+22bgvvaUdquW1LlC4U6Ei/U27sWPgF3nXqlQsw0OYPWKGjiz3ayyRVgcrHXPhFqgP9HDb17nVsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V7CzHZoyR0j7B76SslBhEDYT6rdHPH8S3xhEgbRpEwY=;
 b=QeP1jqW1BRa5gHF1MS3tfiiUJM8P2UIGmjilJmDQ2xrk+2odmymlDFhT30CKvGki0N9XP6dMW0T2ku6B7DwSZp7WEDaBwzY2o7+TCPnDcfBCqbEof8NbhHXzZ4rceVLIldbLYth4DYx/r0ldwhHTLrHSks2bvMNuu4VdTAp/FLQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6941.eurprd04.prod.outlook.com (2603:10a6:803:12e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Tue, 12 Oct
 2021 11:41:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 11:41:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Po Liu <po.liu@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Rui Sousa <rui.sousa@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net 10/10] net: dsa: felix: break at first CPU port during init and teardown
Date:   Tue, 12 Oct 2021 14:40:44 +0300
Message-Id: <20211012114044.2526146-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211012114044.2526146-1-vladimir.oltean@nxp.com>
References: <20211012114044.2526146-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0150.eurprd07.prod.outlook.com
 (2603:10a6:802:16::37) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by VI1PR07CA0150.eurprd07.prod.outlook.com (2603:10a6:802:16::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend Transport; Tue, 12 Oct 2021 11:41:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33a18a15-d607-4566-5671-08d98d752ccf
X-MS-TrafficTypeDiagnostic: VI1PR04MB6941:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB694101F33FB7F4DD948F8ED8E0B69@VI1PR04MB6941.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 13wIM+WMBnB/2qX0FGySxcGt3ee4mBMWzBXVDOMUYAfk+ozH+x7tXHMX0TticJwtzSNgmuN7HtEIduUsdVEwgQbodhyWxTxq+G5ghJoUw79QwYp1D0ECWBXhOMugTFgEZBuC+u7eXTibZT8LsJOnNvH+9w1epJeFuwHkhjnWqF9geZ3ZAhRIQIjMdpk84g5l8cA22Y/on2P5BqyBboTXIQhNhKsTYxIxwWPfZdJxIBvJyNxW1tIq4I0bjurEWd1UyFlpApuBf9WlFWATpgr5hFxq5/7ak5rFUELboZGMExWArwNZWOiDYymiiXjuFZ6aYwMtSHBYysi4pdEoy0B6Ese7OfDpFKJ+5K9RFPQI9x0LWloUMnasFeHdvONN9lmR3LiPnNn+rIvvna6gOc+nkI0LKEQFMDpLaQf+/0MxDtddbqxTj0n3AzQzH6UHtGuH0uQr+kS0S/Ao0WaYsWVpvANqtTRTMCOVIgs+S9xs/M6gqNuBR1ea6rmEV3xhtoln4U33Q0MIXJNrFxyP3hB6tHWaK/uh/ujBSQTaDfW9ifGNly08KJsZIdZn98OsEECLaev4r5XleXdKl8KUblcQem48O8kFij2yPKlrf7p79Wv59NUjnNN4KZ8AUBh85QbHGFAat3kA4G4XDQId13O/TVa1XEhc0WbcTnZg0axSZscOERQxrlANaA4gUUMkeO7kw1BHwdFu9BkbYGaGYsUvjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(44832011)(508600001)(110136005)(6636002)(2906002)(66556008)(66476007)(54906003)(52116002)(6512007)(4326008)(316002)(2616005)(956004)(26005)(186003)(38350700002)(6506007)(7416002)(66946007)(8936002)(6666004)(83380400001)(6486002)(86362001)(36756003)(1076003)(8676002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hVO0NhhqhqsQEUo/nw6igOuzjOrXT62Y2KUNbA8Ud4QNhv5eJNpNbtDX/9IS?=
 =?us-ascii?Q?bnmPLJZ5vMsXKQqRFY4mY8064PR4wsL2VtKT6bFHXrkEs/sRb9Lh4IkuGPfP?=
 =?us-ascii?Q?onAf4KMcuGw3G57G9hAv38Ck86ninWeIRziNhtrMl3CR8dHgyCQxM8Wg709A?=
 =?us-ascii?Q?BOSuv0tyftkW4vorZmeneqjRWZvh2FlvwqNItAiUDN5lmbJuttlM4/IuupK7?=
 =?us-ascii?Q?2Tny4HJnATxqpf1k66L4PnIoblpMZ9MwkUx5PW9GRZ6lD0Cp5fUy5tfdVtSk?=
 =?us-ascii?Q?dJeAnCqX6mU/0NWE4gcMpBQPfAmru4FnEWsRym2o1ao928hs4fAN6i5GGbvi?=
 =?us-ascii?Q?honlN9UaXgWE4tQzW7hN9TUr10QHYnoZD8TtrLoY0WMi7DkPribb7CUck/we?=
 =?us-ascii?Q?YdRyx5SGYG4GmvvXTblZZaYXCjbq9030EewE8woRqAg7uwtUzuoTvUATi3zz?=
 =?us-ascii?Q?f5EYWqQj1e2nzBLNSaLL+dSYISAtYrRJSBROpGthIDFMxFPGYfuluOCTfRe1?=
 =?us-ascii?Q?utIiUXLf+o+3A3Dug6I2rb+Yu/70F1SXgpYoFZawQWtA9IofIT9wc+SZUwBG?=
 =?us-ascii?Q?onqoG+ws003srI05Zo8HSD71BaAFf1/h6XGRWR+kYNnOx4y7ug+OBEQqWZ3s?=
 =?us-ascii?Q?/jfmcfEcyn1R+l4ekjAACZ8f5E3kJwMltg5+u6qITxfEbkyJSaBkswcjbyNj?=
 =?us-ascii?Q?gEOLU7JreNhoHvdBR4A0IKVWWuWH89o/WeWMh5giOstpilv/vBRs1S7RIJzZ?=
 =?us-ascii?Q?ExhPtuPZfzkR47O9TtkhfW6XZwY++Uq8OtybFot88nuW8fXUDdxn6nsa5OTL?=
 =?us-ascii?Q?BMvIKEBueqZy6OxYwfwn3P+4Aun3kgEbKQcsq05kZ+QjOxiVDY+qfmOOfShw?=
 =?us-ascii?Q?zx9ztC/4W0wPV7CXJlvVXQt40X3JLCwpTUagk6Nia0JELmMemP/X5kpwfs+A?=
 =?us-ascii?Q?BziosqPjZwrWu1Qc01n4JZzn36IsyJ2ZEnLPGhTDoCkuLH+nmXYTPwfWR/D9?=
 =?us-ascii?Q?c7o8U6lrpD4HZQoRtis4ZTlZi+YVfsLIn4XKwBWcG21vlO3TKYmkCyzZb3FQ?=
 =?us-ascii?Q?mTE1a/lp8y3XnxjEt/d9TJKITB4ZR2t321qxLLZi5utQ5qgFrCFNgWG96FPM?=
 =?us-ascii?Q?+rdF2WZq5vfWdEi7aX/0IwKt5CSq7LR9S1EddT3Kxo+msFB4/AHrNRzMKLjW?=
 =?us-ascii?Q?PQvDjDaheIsqARL9SSYXvt2ybPL6OUWsJwAZ8BQ3JDXcRBHK1BIJB05snEip?=
 =?us-ascii?Q?whM9ZnA/SJaH+1iuwDBlV6DH76aHx5Lxl7Cs4YWXtlbU8L7Tf/9Z27QxZpgX?=
 =?us-ascii?Q?82jyLwKtwhIP/tRsX7yz+U/i?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33a18a15-d607-4566-5671-08d98d752ccf
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 11:41:05.3930
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: py+m1hZW2ZkT0GQkGOu3PnYbTjo2LMvFvRI41j5pAArUacrG9CUoFJwcqqGP6ld9QfO+BMftoo7CQgDpimH6Bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6941
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The NXP LS1028A switch has two Ethernet ports towards the CPU, but only
one of them is capable of acting as an NPI port at a time (inject and
extract packets using DSA tags).

However, using the alternative ocelot-8021q tagging protocol, it should
be possible to use both CPU ports symmetrically, but for that we need to
mark both ports in the device tree as DSA masters.

In the process of doing that, it can be seen that traffic to/from the
network stack gets broken, and this is because the Felix driver iterates
through all DSA CPU ports and configures them as NPI ports. But since
there can only be a single NPI port, we effectively end up in a
situation where DSA thinks the default CPU port is the first one, but
the hardware port configured to be an NPI is the last one.

I would like to treat this as a bug, because if the updated device trees
are going to start circulating, it would be really good for existing
kernels to support them, too.

Fixes: adb3dccf090b ("net: dsa: felix: convert to the new .change_tag_protocol DSA API")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/dsa/ocelot/felix.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 9af8f900aa56..341236dcbdb4 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -266,12 +266,12 @@ static void felix_8021q_cpu_port_deinit(struct ocelot *ocelot, int port)
  */
 static int felix_setup_mmio_filtering(struct felix *felix)
 {
-	unsigned long user_ports = 0, cpu_ports = 0;
+	unsigned long user_ports = dsa_user_ports(felix->ds);
 	struct ocelot_vcap_filter *redirect_rule;
 	struct ocelot_vcap_filter *tagging_rule;
 	struct ocelot *ocelot = &felix->ocelot;
 	struct dsa_switch *ds = felix->ds;
-	int port, ret;
+	int cpu = -1, port, ret;
 
 	tagging_rule = kzalloc(sizeof(struct ocelot_vcap_filter), GFP_KERNEL);
 	if (!tagging_rule)
@@ -284,12 +284,15 @@ static int felix_setup_mmio_filtering(struct felix *felix)
 	}
 
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		if (dsa_is_user_port(ds, port))
-			user_ports |= BIT(port);
-		if (dsa_is_cpu_port(ds, port))
-			cpu_ports |= BIT(port);
+		if (dsa_is_cpu_port(ds, port)) {
+			cpu = port;
+			break;
+		}
 	}
 
+	if (cpu < 0)
+		return -EINVAL;
+
 	tagging_rule->key_type = OCELOT_VCAP_KEY_ETYPE;
 	*(__be16 *)tagging_rule->key.etype.etype.value = htons(ETH_P_1588);
 	*(__be16 *)tagging_rule->key.etype.etype.mask = htons(0xffff);
@@ -325,7 +328,7 @@ static int felix_setup_mmio_filtering(struct felix *felix)
 		 * the CPU port module
 		 */
 		redirect_rule->action.mask_mode = OCELOT_MASK_MODE_REDIRECT;
-		redirect_rule->action.port_mask = cpu_ports;
+		redirect_rule->action.port_mask = BIT(cpu);
 	} else {
 		/* Trap PTP packets only to the CPU port module (which is
 		 * redirected to the NPI port)
@@ -1235,6 +1238,7 @@ static int felix_setup(struct dsa_switch *ds)
 		 * there's no real point in checking for errors.
 		 */
 		felix_set_tag_protocol(ds, port, felix->tag_proto);
+		break;
 	}
 
 	ds->mtu_enforcement_ingress = true;
@@ -1275,6 +1279,7 @@ static void felix_teardown(struct dsa_switch *ds)
 			continue;
 
 		felix_del_tag_protocol(ds, port, felix->tag_proto);
+		break;
 	}
 
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
-- 
2.25.1

