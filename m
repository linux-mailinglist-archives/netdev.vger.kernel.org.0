Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2121C3E4C9E
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 21:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235863AbhHITEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 15:04:01 -0400
Received: from mail-am6eur05on2046.outbound.protection.outlook.com ([40.107.22.46]:48992
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235246AbhHITEA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 15:04:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SKSDjLV3+6yNyWlq2za0F6RJDr+vCXP97phxQ2HqnE4fDM9WkdirRAzw0VdwNoUgIa/R6bJD08uKDp/2G1Vvlr6PWVmMercezVMlIMYIbQ7QyF0wc9JQLZiXuhtIvFr0eg7lkUfy6DD/s+YeFRZEYPgTXYVfIaYjXHYiDTjffgzVUR66EBhKo3/neiy+HlDYGWN2Aqfv0zL2cXbxhh1tKAgHAyWmmhsGz5tQWSPypCB3ek2VLOT6X0Jt3fGUqerIRMI0nI7Yg3oZM49QKOqO8fcn/bi98L0WS4LYtiQjFZtnVNAj8WRW47vdIFyJqZW5PgTLMoEkH6z7+4MdfoNxxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qxDwQRavZUUTSo0XWYOE1/81fjoNc3qZdQ3nWAIeHBc=;
 b=BMxcg3hJuMxiNz2+onsuBOGlbNJAvDN/MazmTsYdSm+B7cdG3w6I7BZDFUwC3UywxeWYAOGexOXfsNji4NjF1yNM9bgfTipgJsShNc4cXX/T44RT+qTRoxYj9KYioXJBKniCfeIPUd6daRXN0aB1NQvswli5gatUAS1rKQK7PAjbELFuOCfakJTBG49OBR1VGHbLDkPzssGFndCg3jN1eLKEWmlK+kgHIkRB8cZ75nceei/z9Phsn9hdEXdpE6oVB8++OgHPhRDp1E2TOtFyw4wHVsDsc2LATeS59frkEWLYdUIKdoyIplu2IhwK2mHfGvw2l7JKv/75++zaRM7g/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qxDwQRavZUUTSo0XWYOE1/81fjoNc3qZdQ3nWAIeHBc=;
 b=clwm7ELnjqRIwi+Ombo6/YAoSXbWW6NB6I6ducke6KxYeCc8vm0ra3mYEzTH1tjPrzJmUbfQIF8NICTeORliA0SupsKIpJM7uUqHKT7wD/h43rfrykClfVttHagzUQz6P15DLcSZOGTTYy+VIBJq1rlPI4mzCtTDJVcTsjVtj4M=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5501.eurprd04.prod.outlook.com (2603:10a6:803:d3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16; Mon, 9 Aug
 2021 19:03:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.023; Mon, 9 Aug 2021
 19:03:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>
Subject: [RFC PATCH net-next 0/4] Remove the "dsa_to_port in a loop" antipattern
Date:   Mon,  9 Aug 2021 22:03:16 +0300
Message-Id: <20210809190320.1058373-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0057.eurprd04.prod.outlook.com
 (2603:10a6:208:1::34) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR04CA0057.eurprd04.prod.outlook.com (2603:10a6:208:1::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Mon, 9 Aug 2021 19:03:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 83a447c1-09eb-454a-d499-08d95b68648c
X-MS-TrafficTypeDiagnostic: VI1PR04MB5501:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB55013FA54591F5FC7CED5C6CE0F69@VI1PR04MB5501.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O7OAr5j6C4qMrZ9dp6jgODmu3YLMhIS+W4jmEKDG+mel5eCvOgz8OrzRzrQMcDiMKZY4u6Xn36nc3iPlra5hoaaTiUzWIjx1akR7jKzucPbmYVZdnL1fGzMCyCq7HjOihUpb0BQ5+Jy2gUgv3q3oeXfbDoCsbRBYFRz9rHW920DJFFJ48Ath+3M93jMAMjOU9nkvzqNlMu4SnJIEcvjLJl5ze1ijBEoWtIZ4YojFmweIK9kOgluotNB7aeRDltskzp4eKU6sJu8v44F0qPIqfHSP7mWobEjwmzi7iDEPuXy7+w+qmX5OBAnnKD0eH0BrmMukqBKaCRSPlGUZF20I9/ILRaKq26IY0Q/oWMskuPW2p8/NMGcWzFOHonAnJkM1MzX3Snu244Yuc93FG42ulJdb01baHkdO/Z7tsT4LpuSltZcQsiytt9fhB+rE5M/qRxxZNeKx8zGqZMTXspKK8hp+9g2eGzI/SMoWBWscR+8p0GAJTSg0NKDCZhSexEh6hGN4q8STLhCy9tfAN47f+WxiHI6WocOQgMmUQcEfKp7d6Hq9C5PdyLG+G44aE3H+tyvSr8DpJIY6Z5bbjGz389RPenAudf/jFct149V0F5eCBNEPwQm9cYxfR0OHeKZtkdSEatOelVrhqLN6EA89A45RFBFZSnCTUmyzP6/9NUyZEounMnMmgbAOoqRJ2vHMqPdAxKXEa5QN2hs28GnV4iRo4VOeUl9G/PGJtGWlfS+ayAnOcYFt6J9bVpe9emaq4J2PgbKdIxxip8NaVqi4Ow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39850400004)(136003)(366004)(396003)(376002)(5660300002)(66946007)(66476007)(66556008)(7416002)(4326008)(6506007)(44832011)(54906003)(52116002)(6512007)(6486002)(38100700002)(2616005)(1076003)(956004)(110136005)(6666004)(38350700002)(86362001)(186003)(36756003)(8676002)(83380400001)(8936002)(478600001)(26005)(2906002)(966005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vT+S7qgyTTJx+AXkBEHOW6WwmYc0ckPvq+fmrZZBNrfeaNiX40437HlVNNOP?=
 =?us-ascii?Q?YMgCSkMMixA7iO30waVKm2E3PQszLJZGcUR/1/KbCe0COTSEijK86rMwZ9Ha?=
 =?us-ascii?Q?wDLnRLP8BWPh8aLjZTq9GwyqQLoRnt9dfoNkKm1Fiwbi25oAO9NjdE2RVlhN?=
 =?us-ascii?Q?FPS6SK7sNXDA/BvVzgiw8sGYftZKsDQqfjvL22YVukHfH4Wkl7WFHB3luDfW?=
 =?us-ascii?Q?/1h8ahO8h06E7K8/4CZ02zKtfmtIwJ3L7q53X6cWXGQvdNCug474hS4LiWh+?=
 =?us-ascii?Q?ImsPiLkWETtH0JZircPD6XRWyzHhWKi7lmG7WGaRMYuPAzc3hJSfxfYfcfab?=
 =?us-ascii?Q?Qg0CB1qhn3ABTstm5rUDIsU6+efRnSus3S5i1HSssEFJjLlbmWNT+Qogk28F?=
 =?us-ascii?Q?8S0jIJZCvL2wtnuZPJA4e7qmWA3r+lagNCZ37frW1DSdyZxHpoLLaIPLx7wq?=
 =?us-ascii?Q?ZQ7affb57QmQ45hoxjbV30p2r/5cX7gpUT3Xlsb+EK7YkM/DSwB7vYXryZ5V?=
 =?us-ascii?Q?kBkT0ve02cMJzwgDdSgUnJT4zCxJlpkXFos9fh1+Ccmx9Vupo9MFSvEOlgug?=
 =?us-ascii?Q?QPnVyUb5w2mKguxcDWGubwAYw8JYaPZrhZtazGhFVPRUm9jzfHUgqk910eQG?=
 =?us-ascii?Q?ymXwIjqqySdqYJlK0EgP+NYK40u8NT6AldSS6ACF+h7kOd1ELYyG5BhaWelB?=
 =?us-ascii?Q?u2EMK/MWuu8btcfMuBprtn4VYzxXHvyzJj6YcWAhRuPXvKE6iYO3dY2GqqA7?=
 =?us-ascii?Q?NQhSjMpFH3mt+B2HgPYoeYasgsUpuguvbhnQFOzc8rIHPTvtpiIvp+483j8k?=
 =?us-ascii?Q?CUawwb/hszDPG8zICqcV4+/+gzMPkErmGNTm/gCQi8auxG8VA7OZP6Uleb19?=
 =?us-ascii?Q?rix3K++F+cZPr9S7a/kzhvsu8o26fRCxR7VHlNZAdVzbYtUl/6EzsgkvxkWF?=
 =?us-ascii?Q?nSZsG2rfoRG6o8KLMq3hvk7ZUlDYBLgydkcJI8qMZNMV0XR8xHYpIAcMcR+u?=
 =?us-ascii?Q?nCeVv3dY4g9JgEgNQ9Qv3haKwpOh/CnqkqplwBnsg2lBjEXsZaVkZpbRKxLf?=
 =?us-ascii?Q?ptFjB5/pl5x6BEAA1IIuPU4WcK+zFSk+vdFft8+0q5I/w4y16PdmfYfDMpaU?=
 =?us-ascii?Q?ZEXJt7H/0SH0+fa81hZT3Dji1j9FwyuE2B2PxdjQOGh0eWcaWloIR3NkRUuT?=
 =?us-ascii?Q?bSb0H9plcBRN1Z7nlUQQh9YD/4RwlbNFYUnNKkE4Hv4nUdczuU7//pineF8f?=
 =?us-ascii?Q?uZ/TghC1FWiqStbRF0VboeML0jy3dxflSToj4/Hl7jq7L8aTfd+5IXq51wVK?=
 =?us-ascii?Q?nXDydDjlLnAWYqnLaZVz0n97?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83a447c1-09eb-454a-d499-08d95b68648c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2021 19:03:37.3262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hDz5An4FLdeIP0AeY5zGrYgOC4pEqnb37d4xKWclycgAwIai4Cgt63EiIOWevjozzwLBw1T8ve/TIqooQkWKKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5501
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DSA core and drivers currently iterate too much through the port
list of a switch. For example, this snippet:

	for (port = 0; port < ds->num_ports; port++) {
		if (!dsa_is_cpu_port(ds, port))
			continue;

		ds->ops->change_tag_protocol(ds, port, tag_ops->proto);
	}

iterates through ds->num_ports once, and then calls dsa_is_cpu_port to
filter out the other types of ports. But that function has a hidden call
to dsa_to_port() in it, which contains:

	list_for_each_entry(dp, &dst->ports, list)
		if (dp->ds == ds && dp->index == p)
			return dp;

where the only thing we wanted to know in the first place was whether
dp->type == DSA_PORT_TYPE_CPU or not.

So it seems that the problem is that we are not iterating with the right
variable. We have an "int port" but in fact need a "struct dsa_port *dp".

This has started being an issue since this patch series:
https://patchwork.ozlabs.org/project/netdev/cover/20191020031941.3805884-1-vivien.didelot@gmail.com/

The currently proposed set of changes iterates like this:

	dsa_switch_for_each_cpu_port(cpu_dp, ds)
		err = ds->ops->change_tag_protocol(ds, cpu_dp->index,
						   tag_ops->proto);

which iterates directly over ds->dst->ports, which is a list of struct
dsa_port *dp. This makes it much easier and more efficient to check
dp->type.

As a nice side effect, with the proposed driver API, driver writers are
now encouraged to use more efficient patterns, and not only due to less
iterations through the port list. For example, something like this:

	for (port = 0; port < ds->num_ports; port++)
		do_something();

probably does not need to do_something() for the ports that are disabled
in the device tree. But adding extra code for that would look like this:

	for (port = 0; port < ds->num_ports; port++) {
		if (!dsa_is_unused_port(ds, port))
			continue;

		do_something();
	}

and therefore, it is understandable that some driver writers may decide
to not bother. This patch series introduces a "dsa_switch_for_each_available_port"
macro which comes at no extra cost in terms of lines of code / number of
braces to the driver writer, but it has the "dsa_is_unused_port" check
embedded within it.

I changed as much code as I could, probably not all, but a start anyway.

Vladimir Oltean (4):
  net: dsa: introduce a dsa_port_is_unused helper
  net: dsa: remove the "dsa_to_port in a loop" antipattern from the core
  net: dsa: remove the "dsa_to_port in a loop" antipattern from drivers
  net: dsa: b53: express b53_for_each_port in terms of
    dsa_switch_for_each_port

 drivers/net/dsa/b53/b53_common.c              |  26 ++-
 drivers/net/dsa/b53/b53_priv.h                |   6 +-
 drivers/net/dsa/bcm_sf2.c                     |   8 +-
 drivers/net/dsa/hirschmann/hellcreek.c        |  27 +--
 .../net/dsa/hirschmann/hellcreek_hwtstamp.c   |  19 +-
 drivers/net/dsa/microchip/ksz9477.c           |  19 +-
 drivers/net/dsa/microchip/ksz_common.c        |  19 +-
 drivers/net/dsa/mt7530.c                      |  58 +++---
 drivers/net/dsa/mv88e6xxx/chip.c              |  37 ++--
 drivers/net/dsa/mv88e6xxx/hwtstamp.c          |  10 +-
 drivers/net/dsa/mv88e6xxx/port.c              |  12 +-
 drivers/net/dsa/ocelot/felix.c                |  79 +++-----
 drivers/net/dsa/ocelot/felix_vsc9959.c        |  10 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c      |  14 +-
 drivers/net/dsa/qca8k.c                       |  32 ++--
 drivers/net/dsa/sja1105/sja1105_main.c        | 176 ++++++++----------
 drivers/net/dsa/sja1105/sja1105_mdio.c        |  12 +-
 drivers/net/dsa/xrs700x/xrs700x.c             |  37 ++--
 include/net/dsa.h                             |  43 ++++-
 net/dsa/dsa.c                                 |  22 +--
 net/dsa/dsa2.c                                |  11 +-
 net/dsa/port.c                                |   7 +-
 net/dsa/switch.c                              |  41 ++--
 net/dsa/tag_8021q.c                           |  29 ++-
 24 files changed, 360 insertions(+), 394 deletions(-)

-- 
2.25.1

