Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44ADD3E7D46
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 18:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235444AbhHJQSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 12:18:16 -0400
Received: from mail-am6eur05on2080.outbound.protection.outlook.com ([40.107.22.80]:16133
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234357AbhHJQPg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 12:15:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j+eCHAmrVB32c3xYUV4GsK/l/2AXoKRoP0i07JbSsAipXRrCkRG+6XEm7IB+gqkCUJJoGIoskemqpeUm6iqxGRZnqBAdD7WH1qGAJ74CWoymSIPw/TfEFmTGAIX51ifrvm71ru1+tbTSrJHSH1/Ipf/MHn2W31Ppkrh9JIGPVpPjh4m39hZB1r786y41ilAoWHhqpr0dZJBUwDXq48BHgbHw4BtGalsqHfvgDKM8elsjxZhNAdseoHio3JExBOCW2hByCNlBGaeehrBXiGqMhR2zI3Hfld8xUjoEm6FPb811/lT22tokyWXw17US69HvJRy/gbU3urHRkUnvNP0S8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n7hIcM1zb4kIqmxDdt2MEnsnW/l+OovM5uRiOjpYUlw=;
 b=AxvgEiyhmGGmwWVQy6Sk0M4n4//lY+ETSXw2tle9PqNBRyHheQWTLT4OkWZeXsErkXTw/4J4jRO6nhpCxpXzHbR12j3Gmx/rb55BKY+dJEknIdSkM4UEr96ku76K5BmnZs+rZbgAwkvVYDNI+N4U3qJOHFK2lCk3SvqtHBidEfS8daoeLsnwQ+xsGa3OJbz5jqPicG4RodCPC6nhiNM2s7NP4rt18FSftTrzUaq0XbYZBJgbPN2/GSMo5Js4Rrtw2/jq+TaU2ZI6YfOgaBHS3vvDI/eQsimEnPdESFPGMHjLX0eTt+BQ/5bHS+jfiZosMWBhSUOGurE68t0l4t8vZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n7hIcM1zb4kIqmxDdt2MEnsnW/l+OovM5uRiOjpYUlw=;
 b=Wrm1cPINb5R2qQkvYwPFajsa0O1PO3egfhVZ0WdrxJhJ7U54Rm1PdEefd9cy235B2TlNdOGIsE8XGjxSsvg4vhYDxJxQO/l9f19BTK+4mTVoJroNbTTGNGEIpurmtgptt2h7Dp6XTS4ytsw6ulX2wmWG5r2C1iCAwjRcoG6fB5c=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2800.eurprd04.prod.outlook.com (2603:10a6:800:b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.19; Tue, 10 Aug
 2021 16:15:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 16:15:02 +0000
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
Subject: [RFC PATCH v2 net-next 0/8] Remove the "dsa_to_port in a loop" antipattern
Date:   Tue, 10 Aug 2021 19:14:40 +0300
Message-Id: <20210810161448.1879192-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR05CA0031.eurprd05.prod.outlook.com (2603:10a6:205::44)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM4PR05CA0031.eurprd05.prod.outlook.com (2603:10a6:205::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Tue, 10 Aug 2021 16:15:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f4395d4-66c5-4767-d931-08d95c1a022a
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2800:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB28000BAE5709A813D76A3ECAE0F79@VI1PR0402MB2800.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ziJ0gx0qKHaFI6Y219fJkg3YVJboZQC4GGqj4DXnj7eJErg8H8TMHRu7S34LqiKX3mqrwdZOztF++MHvSxFmaX2iIsaVnVD4THT8YXjry7TLPCGxgQHhRoDYwrWbjLNuTbn7p6AoauG9HsoA6vW0wFs+F1ZCbjGX2Jg1x9BpzB92478WSU5Akqd11VwiOOl2LHeBwAuYrWC4NHJvn1iEkpqIMOMBho/Ik7Wut0UaM1SEXiq0wtP8vnHVbtLvz2h+l9c0FvTX94yGmdB9a/rtMF8QBkITZm9uFPwkJ7Yysn0c/oZZC+2ZQckv6sLphSvi9KLKw5M8Fo3qUiv9PD5FgJOc3BhQOZN7gt5brdF/iWX4lkIgFLWfkM1IECivHbM+YUGRsmhkuzI64/Uz4KcGm9LeOzNgRins53KBSvipGbW+W8ZNz9eOepcmd2zrspp0ZalgIMQfhdJlh18aQWt3jANrWVegdjktDwOd/cvTaS99vhxn1dTN5scBhBZf4QQvr/S7sK/wzmZ332XddHuHoUQ+isRG48qCDYZWy8SLwhUcugnU+9z5fOa9QFcXNTLzuLPgOrYUy/kfT8ni/Z7nyA5eW+JmSLfP3Xmq688Mb7+JspnMGAqd2HSMKwLaZFKbwY20TJDdjIFHgLXs4zldXmEL9eOD6TdxXj4Z0Tj3hQuF/yxE2FiuZr97dea7gOg6Oq775pbsT3vTsWsmwe/+DrF3qMLToP+fp72cC57n137BAujxcVMRfo7dfkBBbZVpBxlqQfnI1FwErJ+tP2GetA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39850400004)(366004)(6506007)(52116002)(6512007)(86362001)(110136005)(478600001)(8676002)(2906002)(956004)(83380400001)(54906003)(26005)(1076003)(8936002)(6486002)(316002)(36756003)(966005)(7416002)(186003)(66946007)(5660300002)(66556008)(66476007)(44832011)(2616005)(6666004)(4326008)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5JOYXPLMSCPWQEEU4OE4bPo3zVA4U4uHIuKlcLtXXu2gA6oehs/7DmAYzak2?=
 =?us-ascii?Q?0XOgxy8ZvaRBZnUptJB8C+5z6n5pBlx+HMhiWtUxFhu6lqkaScHOPuIRIt3b?=
 =?us-ascii?Q?m9ke2gGw4pBZ1tk6g2v/3mkMEbMRbQT9iMZwqym7BOYu5dUfrURVUelPpQhb?=
 =?us-ascii?Q?HObVu2427hIjnSQk1mhMcVVu29vtgwgSci2AtBH2EW8cwSABp6Rlw/QsaVf3?=
 =?us-ascii?Q?S9elN6fH40KA0zcg4pSQCJgRMx+gt0jrq+yso0IYe+sZU8uJ72G0C/tt9hjV?=
 =?us-ascii?Q?+f75TZHAUJksaRKD0vZv67MSU2h6Wj+fEoNJzOpEfGdN9ph+6rLWhUfImKt6?=
 =?us-ascii?Q?jo5XgG7sdShXsVRTneIBx1VBEt+AbDN05ZV96F7ugf03kQ2OLr6Av2wm/r4u?=
 =?us-ascii?Q?mGS+/VqdFTSRPqBdlS6wpjzAmlvkdeWqQBOpNKjNK4BnKjMvR98/g+GSQ3o4?=
 =?us-ascii?Q?1/hEo8OSPJY+lqItX83V1PoEGsBJN+r6tNMJOtYuQRxcvkgLYNSJtFzwDxoC?=
 =?us-ascii?Q?WbRKzEVXARLlkRuWzrOPxz9DvKF254u0z+B8M7brVQ7Xv3yT3gRCt8lC2zBY?=
 =?us-ascii?Q?jP3ks1aYz9OU/GSAZcfrPhudRoKlyhlp6wbYGY+n31yl8Eah3Vxymux+yL4V?=
 =?us-ascii?Q?OeNT9v6ALXTkudLsVjJv8ho7LeAARSogsyLoxOD8PTRDQp2GIo8k5XDslqv9?=
 =?us-ascii?Q?1J8+6CTAbqH5FauyGBxRXixkcYLtYkjqKXJS4oFaBr1vl2if7G0Cdr2N0AwC?=
 =?us-ascii?Q?3b7GsSY/95AA69c5Qx9eaLYxLC7s1uLgTEqUvaWiKak4o2E3Cdp9Wq6RJbqk?=
 =?us-ascii?Q?H7JPzpD48kLtTNfIXGmLjXl2ps4zeP96EHZWsjbcwdlNksqSm5u3V7STjo1J?=
 =?us-ascii?Q?BVRkWFfIeZwR5zBQbClCMuxaKHD9tV0r6qpR4/HuDN9DqgtLljQdQFwUmzhf?=
 =?us-ascii?Q?r6W4XYhtMzj+LIPZeKTC8VHvez9Gtk+e8s2w+ecxj7z/isfVIXuiOZHm3zrl?=
 =?us-ascii?Q?1UbEwnJlO2HVLneSLyKEDd/cI2InU2SVYUP7+cSQU5GyerNWtOVFyKGkBkwx?=
 =?us-ascii?Q?I4aLH+jTQLEpzjm1dkieMIwYPRrwH1AroT8YHrCPDemyT1X5VvRBx14LNqhQ?=
 =?us-ascii?Q?ODCBLXeT4Qn6YbbOeRV9WZ4BoAe5lX72r8ET2zgad9xGRCKR9BvUkHZvVr3t?=
 =?us-ascii?Q?ALAyu0RqdR7OamI9dy6hGD+yLLyZw1H+LAnHrBCA5vcfsYD3yTzzVAO1h1w4?=
 =?us-ascii?Q?FL4c/VgeWhg5KP4ESM5HoGTG/n/n6JhoING6OC6ZPwLvfSL3cnczYwy9TDmv?=
 =?us-ascii?Q?zaczGdR6HGPbR33IjKO/MM/5?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f4395d4-66c5-4767-d931-08d95c1a022a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 16:15:02.7801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wGoQkrEX5wq2YpTJ6O9qGUgfTAutY86LT81XwPACVp8pW0YsnAEL3Qlu7Ce37dxIZrWMGMk8TBMOzopXwpIjXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2800
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v1->v2: more patches

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

Vladimir Oltean (8):
  net: dsa: introduce a dsa_port_is_unused helper
  net: dsa: remove the "dsa_to_port in a loop" antipattern from the core
  net: dsa: remove the "dsa_to_port in a loop" antipattern from drivers
  net: dsa: b53: express b53_for_each_port in terms of
    dsa_switch_for_each_port
  net: dsa: finish conversion to dsa_switch_for_each_port
  net: dsa: remove gratuitous use of dsa_is_{user,dsa,cpu}_port
  net: dsa: convert cross-chip notifiers to iterate using dp
  net: dsa: tag_8021q: finish conversion to dsa_switch_for_each_port

 drivers/net/dsa/b53/b53_common.c              |  26 ++-
 drivers/net/dsa/b53/b53_priv.h                |   6 +-
 drivers/net/dsa/bcm_sf2.c                     |   8 +-
 drivers/net/dsa/hirschmann/hellcreek.c        |  27 +--
 .../net/dsa/hirschmann/hellcreek_hwtstamp.c   |  19 +-
 drivers/net/dsa/microchip/ksz9477.c           |  19 +-
 drivers/net/dsa/microchip/ksz_common.c        |  19 +-
 drivers/net/dsa/mt7530.c                      |  58 +++---
 drivers/net/dsa/mv88e6xxx/chip.c              |  48 ++---
 drivers/net/dsa/mv88e6xxx/hwtstamp.c          |  10 +-
 drivers/net/dsa/mv88e6xxx/port.c              |  12 +-
 drivers/net/dsa/ocelot/felix.c                |  79 +++-----
 drivers/net/dsa/ocelot/felix_vsc9959.c        |  11 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c      |  14 +-
 drivers/net/dsa/qca8k.c                       |  32 ++--
 drivers/net/dsa/sja1105/sja1105_main.c        | 176 ++++++++----------
 drivers/net/dsa/sja1105/sja1105_mdio.c        |  12 +-
 drivers/net/dsa/xrs700x/xrs700x.c             |  37 ++--
 include/net/dsa.h                             |  47 ++++-
 net/dsa/dsa.c                                 |  22 +--
 net/dsa/dsa2.c                                |  38 ++--
 net/dsa/port.c                                |  11 +-
 net/dsa/slave.c                               |   2 +-
 net/dsa/switch.c                              | 170 ++++++++---------
 net/dsa/tag_8021q.c                           | 121 ++++++------
 25 files changed, 501 insertions(+), 523 deletions(-)

-- 
2.25.1

