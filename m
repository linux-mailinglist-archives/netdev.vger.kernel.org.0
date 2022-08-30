Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5CB95A6E05
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 22:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbiH3UBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 16:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbiH3UAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 16:00:54 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2054.outbound.protection.outlook.com [40.107.20.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E716F419A2;
        Tue, 30 Aug 2022 13:00:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=USHtRrzwBrYKjomCRfjF5QLsapn/4fGuX0BbeyRBhmB4OUXRJ8rZEkDhjUCBpW43cD3B9Q4TdFR7xtsANCAXUCBuL9hpFYaOYsafE3wKPS12tDbbFJbLXhfWHpr+z0T5ZahVXJczKFtmoya3LWbu8IDn0HcjO1Qr/MVLb2Ctt9tGiX0XPDz1SAkEWZi1TyyLXlRHOo2MZ4XQE6N1wjYNDyyZloDj8b7Lylfa+9z/cc5On2RPSJhfDHJTQepUgLclg/DiyTZ8OrlFOkpgRzTb4V3b3Miw/b2ydZ2FrXDaZlhSFRkF78n1ozWyCSDvcWFOK7jYauj4IGbz8atX0kUGHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dHaqs425Z+4EgFP4Z20fZXkhVwDWNtFw8OZJfJzvcmg=;
 b=CW6+Ft+hFtDe9dG7T3s8AorrGhH0TwkaidudumWTQqNvJfHLhpLjkWpkKFMFUJJNoZ2fgSFQnA+mkltIdhKrBt13nrYrCNRW7DrvTt7AVqsNprPaRPm84+3sqotzFxX+HV8zC4KvkdbjQw/0MbcEWIpf+6RuTNMB0XK4Q5jl6WOr/t5ZqE+xjVBPZM/q2c0COoBIKYnw3hoFvUwMHt6edkKXNmzL3h9IM1Vy8/HQYklaH7M4SWIYQHC3G8w980u5F/JmH10HmfbVL+z4WYx1M2pF35mZsfP0X9S38Zm+APaghUoJK7/xhucGr0cyg0K6PS0IUdLeS7JJIuTS8D+4xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dHaqs425Z+4EgFP4Z20fZXkhVwDWNtFw8OZJfJzvcmg=;
 b=DnI55HVdnWbhBNUEwskLeGaDD5GBEGtTfKhOIRW0sO2MHU3uEfUgA+UvZX7cm7teOK4rdWTL6T6VlJDod1nHSigWye0m1f86/QMhaEgdVELWzvkRqQPO1qdJlFbqBhdyCOsgiJE7URfKBj1rocxTMwoGS4XJo90cOe0MXIvV3QQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6270.eurprd04.prod.outlook.com (2603:10a6:803:fb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Tue, 30 Aug
 2022 20:00:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.010; Tue, 30 Aug 2022
 20:00:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH net-next 8/9] docs: net: dsa: update information about multiple CPU ports
Date:   Tue, 30 Aug 2022 22:59:31 +0300
Message-Id: <20220830195932.683432-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220830195932.683432-1-vladimir.oltean@nxp.com>
References: <20220830195932.683432-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE0P281CA0005.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c7bf1d8-608a-4d52-9cc0-08da8ac235b5
X-MS-TrafficTypeDiagnostic: VI1PR04MB6270:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2YklfE6vYO7q06/sDbL8Z9zNNftr7PxZtkebPAcAwyN7zsIlqdTScyjtQ0IV0gV/GbL3UMp59+sdw8O+cGrvP9y+vVWovTTSvTaS4ziLoUQk7op8H0xmpWdbo1u3dynO/O2soyKripY8c8yGwWkKwVVZ1DTJa1MS63rxc/6n8ZdKBJw9LyeSZDhM69n3BMb7GHN0oPHWa7/xF8y2GdDk960YgDxQgv3aqOuxwL7JTRddmRM4tCaMhU0xhGJFBeWQktlvqgk7ntwOOZq9ZAhzANXeWUxRkWwScCL7168HCW+BL4rfP016Qlcu4JMXbg5386T5SE3nmbzNRpNABFBVvr5IcuGgn3ML2iRVpplpBCZqU8VcI2umcxhBRzKcMP6DQ4yJjK08wXMFPJu0T+uXS4ko5XYe2EbK9CgN4M9CC37yttzqhHYxNdXmoEQ87pPlBv48XK6FTzyzwPHOyT1CXviOG6A5VbOE3dc7Q1vujxFQBWciajkFE30b89xaVcimD4psckixGXDrAm9rbyUlqCbS4zpDu0lHDTnqnQea7bIMo7Y8LQOC3jVr+rQrH/lbnNn3I0hDeUzyTWzjn1JycpBOAdpw28BR878wo1EAz2Y6iWVBmeg963V11wraIxr08Amj/vT+vCaMakq0L8KK9f5XIkqsLWt3NmGuwMc/SSC5vhBF5ay1fDj1Uv6qvdpfxEtUPYzKUa8sSHlqT2TWyzvuV2EySI5JjPVxzpgaNNHcWDtoyBp5mV4ItCbICbhn6VHkyonrBSO/x+xzHUlBLak0DJ/YIrEp3+lVV7RaL7Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(366004)(39860400002)(136003)(376002)(41300700001)(66476007)(6486002)(8676002)(4326008)(66946007)(478600001)(66556008)(52116002)(2906002)(83380400001)(966005)(44832011)(26005)(5660300002)(6506007)(6512007)(7416002)(6666004)(15650500001)(8936002)(2616005)(316002)(86362001)(6916009)(54906003)(36756003)(38350700002)(1076003)(38100700002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DJXwP6RGKs5sxwWARUItrsZUkun2X2SC5ZFzzdEYFH4DYW7l/Ih065w/QhaI?=
 =?us-ascii?Q?eSN7SedSVfG/Ni0EpYGuANDTlCoxFcU/uIVBpdBQOE4KaMXbrNYeCTchy0gQ?=
 =?us-ascii?Q?ri+czGbltFD4I9hbP31QJjoeF32EHRJ7xQIbImaQVV+58nhMj6+eE5joOTU0?=
 =?us-ascii?Q?GLCo3W0FFk7p4pY5qTJHeQfKT1QUi2ZM3Y6viZkJ/csYksQSYyMUdJP7/lCl?=
 =?us-ascii?Q?7p9tFPS3NA5zCprJ7UERYiVBI/bY1/ciUQmOQWpGO+XwMViqkme30XlKx2YJ?=
 =?us-ascii?Q?+WkOQLQxR6zPvzm32cz0EYUSlkHa38VFK/HucsNDXitXd+nCVY8JEzVNjYJk?=
 =?us-ascii?Q?GXC4jYOl/deV2nO0p1Qua6Xx5NZmls9UNlQmbhTXxGM85o6x0grt8Bc7k8l6?=
 =?us-ascii?Q?uCHUFSx785yl/YvfEsKk8fJ32rmJlApPNTG4Pw+zf9MTfsHKU/SvDUxg9V7S?=
 =?us-ascii?Q?Jn5TmRORdjed16HCdIXrfEb/UeaaNJR10v7ol8sAbj3YU75Bq5bxMsLlexew?=
 =?us-ascii?Q?upqPmWBTLydT4Y/MLkPG8GPOU3BoeHiqZz5pUqobv6SR2sZfvqcN0yvKNeW9?=
 =?us-ascii?Q?JfNz2m/fY0Feuh0PZRYvHeJOanG7GuEDSaRRHoDUJ2bQaBunW0XYoVhUUbnH?=
 =?us-ascii?Q?8Buf15WFYAgLZlr5peGkBQba2NgBPpgXzGYi/sLg8Oo5e3+/xdxgOh+HJUw8?=
 =?us-ascii?Q?o27Gzg5uZSgn36RFwF4Ul0F038o/+FWEpdxfOe8D6t+puaNPIRHCWobv/Ifh?=
 =?us-ascii?Q?A58rawBovA5MQMy/H45lG+ULvbDAMn1WSm08KlJdSgwAsBA8nw5+IkCcvIsM?=
 =?us-ascii?Q?+PgZlOFBQIJAxQtFweTPca+L+OD6NpOvGtvZ1ZaeUMvBEDHi2xCPxhknPLdO?=
 =?us-ascii?Q?IQZsf/VGsYLe3/pxA0DBewU/qBFU/Ok2VHRI7evDiWAG9SyCF6TmUPmyg8rE?=
 =?us-ascii?Q?n5zEUU/tHcZGnbknnfx3QxvUhh/JKn5fWJ8lLoqOsyD82zWZCFhQQ9jkGmoP?=
 =?us-ascii?Q?9JHYPrWdHySg3I6nb2BpSxIxBWbSh9Jj3g+kXh3Ua4TIYe6zQCYeU8Hrd7u6?=
 =?us-ascii?Q?sCudGtNbTVNmLrFGjiWfNarcvWGVGkvD1tX8l9TyUOvBVI3PdHMP12ogoxV1?=
 =?us-ascii?Q?jlFlHfodyrw7+b3TVLJc9uZYHUOct46XGNp1+oNqPRgh5MzzF5hbowO4u10u?=
 =?us-ascii?Q?j2pnyruDD92jHy0Wep4aySY968jHJBTt7s5MSE43gukCzAQX89dQQBZLZr9f?=
 =?us-ascii?Q?i80MOKnRBUa/GLrxV65k3KLVPOap72QSQjeLG+Zo/3LSX6fHfGoSZPJyQ512?=
 =?us-ascii?Q?KghghZXkgHNCgx8qCB9KZl2SfsvOdx5QU+wytepzfweUDWTqBP1Z84U2akOV?=
 =?us-ascii?Q?XVe076BZEpjHgLrJBf8wT1wsZ7sV/rMwNjmmR8AQmse6xcY0Ns/Xy9LR8n7i?=
 =?us-ascii?Q?492rT5sTqMRLRHjDFfm+VKDg8FYWbvUdnHDLFFP3wNf1dxS05+A6WedLPWBl?=
 =?us-ascii?Q?6UNvQh1BGzUAjY0dAtD8/t4oYt9qDrO2OSFZrHY1nMTHPgZPiqAB/1SOOTHH?=
 =?us-ascii?Q?b2HEdE5/SR9OLM9ySB7MhSUDXuKaUvCiwFHIpHuC7zmI+uxi47H7AsLQmWez?=
 =?us-ascii?Q?sw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c7bf1d8-608a-4d52-9cc0-08da8ac235b5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2022 19:59:55.7760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vjy8z+9DTMJKBEyy+982JutqXfOhiDDoxlIEa8+1u6klCXFJ+CA9WgiyoMpB0asqcC7ZDdtxUvrKIFIfIHBIkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6270
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA now supports multiple CPU ports, explain the use cases that are
covered, the new UAPI, the permitted degrees of freedom, the driver API,
and remove some old "hanging fruits".

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../networking/dsa/configuration.rst          | 84 +++++++++++++++++++
 Documentation/networking/dsa/dsa.rst          | 38 +++++++--
 2 files changed, 116 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/dsa/configuration.rst b/Documentation/networking/dsa/configuration.rst
index 2b08f1a772d3..5c49c1eef8bb 100644
--- a/Documentation/networking/dsa/configuration.rst
+++ b/Documentation/networking/dsa/configuration.rst
@@ -49,6 +49,9 @@ In this documentation the following Ethernet interfaces are used:
 *eth0*
   the master interface
 
+*eth1*
+  another master interface, by default unused
+
 *lan1*
   a slave interface
 
@@ -360,3 +363,84 @@ the ``self`` flag) has been removed. This results in the following changes:
 
 Script writers are therefore encouraged to use the ``master static`` set of
 flags when working with bridge FDB entries on DSA switch interfaces.
+
+Affinity of user ports to CPU ports
+-----------------------------------
+
+Typically, DSA switches are attached to the host via a single Ethernet
+interface, but in cases where the switch chip is discrete, the hardware design
+may permit the use of 2 or more ports connected to the host, for an increase in
+termination throughput.
+
+DSA can make use of multiple CPU ports in two ways. First, it is possible to
+statically assign the termination traffic associated with a certain user port
+to be processed by a certain CPU port. This way, user space can implement
+custom policies of static load balancing between user ports, by spreading the
+affinities according to the available CPU ports.
+
+Secondly, it is possible to perform load balancing between CPU ports on a per
+packet basis, rather than statically assigning user ports to CPU ports.
+This can be achieved by placing the DSA masters under a LAG interface (bonding
+or team). DSA monitors this operation and creates a mirror of this software LAG
+on the CPU ports facing the physical DSA masters that constitute the LAG slave
+devices.
+
+To make use of multiple CPU ports, the firmware (device tree) description of
+the switch must mark all the links between CPU ports and their DSA masters
+using the ``ethernet`` reference/phandle. At startup, only a single CPU port
+and DSA master will be used - the numerically first port from the firmware
+description which has an ``ethernet`` property. It is up to the user to
+configure the system for the switch to use other masters.
+
+DSA uses the ``rtnl_link_ops`` mechanism (with a "dsa" ``kind``) to allow
+changing the DSA master of a user port. The ``IFLA_DSA_MASTER`` u32 netlink
+attribute contains the ifindex of the master device that handles each slave
+device. The DSA master must be a valid candidate based on firmware node
+information, or a LAG interface which contains only slaves which are valid
+candidates.
+
+Using iproute2, the following manipulations are possible:
+
+  .. code-block:: sh
+
+    # See the DSA master in current use
+    ip -d link show dev swp0
+        (...)
+        dsa master eth0
+
+    # Static CPU port distribution
+    ip link set swp0 type dsa master eth1
+    ip link set swp1 type dsa master eth0
+    ip link set swp2 type dsa master eth1
+    ip link set swp3 type dsa master eth0
+
+    # CPU ports in LAG
+    ip link add bond0 type bond mode balance-xor && ip link set bond0 up
+    ip link set eth0 down && ip link set eth0 master bond0
+    ip link set eth1 down && ip link set eth1 master bond0
+    ip -d link show dev swp0
+        (...)
+        dsa master bond0
+
+Notice that in the case of CPU ports under a LAG, the use of the
+``IFLA_DSA_MASTER`` netlink attribute is not strictly needed, but rather, DSA
+reacts to the ``IFLA_MASTER`` attribute change of its present master (``eth0``)
+and migrates all user ports to the new upper of ``eth0``, ``bond0``. Similarly,
+when ``bond0`` is destroyed using ``RTM_DELLINK``, DSA migrates the user ports
+that were assigned to this interface to the first physical DSA master which is
+eligible, based on the firmware description (it effectively reverts to the
+startup configuration).
+
+In a setup with more than 2 physical CPU ports, it is therefore possible to mix
+static user to CPU port assignment with LAG between DSA masters. It is not
+possible to statically assign a user port towards a DSA master that has any
+upper interfaces (this includes LAG devices - the master must always be the LAG
+in this case).
+
+Live changing of the DSA master (and thus CPU port) affinity of a user port is
+permitted, in order to allow dynamic redistribution in response to traffic.
+
+Physical DSA masters are allowed to join and leave at any time a LAG interface
+used as a DSA master; however, DSA will reject a LAG interface as a valid
+candidate for being a DSA master unless it has at least one physical DSA master
+as a slave device.
diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index d742ba6bd211..a94ddf83348a 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -303,6 +303,20 @@ These frames are then queued for transmission using the master network device
 Ethernet switch will be able to process these incoming frames from the
 management interface and deliver them to the physical switch port.
 
+When using multiple CPU ports, it is possible to stack a LAG (bonding/team)
+device between the DSA slave devices and the physical DSA masters. The LAG
+device is thus also a DSA master, but the LAG slave devices continue to be DSA
+masters as well (just with no user port assigned to them; this is needed for
+recovery in case the LAG DSA master disappears). Thus, the data path of the LAG
+DSA master is used asymmetrically. On RX, the ``ETH_P_XDSA`` handler, which
+calls ``dsa_switch_rcv()``, is invoked early (on the physical DSA master;
+LAG slave). Therefore, the RX data path of the LAG DSA master is not used.
+On the other hand, TX takes place linearly: ``dsa_slave_xmit`` calls
+``dsa_enqueue_skb``, which calls ``dev_queue_xmit`` towards the LAG DSA master.
+The latter calls ``dev_queue_xmit`` towards one physical DSA master or the
+other, and in both cases, the packet exits the system through a hardware path
+towards the switch.
+
 Graphical representation
 ------------------------
 
@@ -629,6 +643,24 @@ Switch configuration
   PHY cannot be found. In this case, probing of the DSA switch continues
   without that particular port.
 
+- ``port_change_master``: method through which the affinity (association used
+  for traffic termination purposes) between a user port and a CPU port can be
+  changed. By default all user ports from a tree are assigned to the first
+  available CPU port that makes sense for them (most of the times this means
+  the user ports of a tree are all assigned to the same CPU port, except for H
+  topologies as described in commit 2c0b03258b8b). The ``port`` argument
+  represents the index of the user port, and the ``master`` argument represents
+  the new DSA master ``net_device``. The CPU port associated with the new
+  master can be retrieved by looking at ``struct dsa_port *cpu_dp =
+  master->dsa_ptr``. Additionally, the master can also be a LAG device where
+  all the slave devices are physical DSA masters. LAG DSA masters also have a
+  valid ``master->dsa_ptr`` pointer, however this is not unique, but rather a
+  duplicate of the first physical DSA master's (LAG slave) ``dsa_ptr``. In case
+  of a LAG DSA master, a further call to ``port_lag_join`` will be emitted
+  separately for the physical CPU ports associated with the physical DSA
+  masters, requesting them to create a hardware LAG associated with the LAG
+  interface.
+
 PHY devices and link management
 -------------------------------
 
@@ -1095,9 +1127,3 @@ capable hardware, but does not enforce a strict switch device driver model. On
 the other DSA enforces a fairly strict device driver model, and deals with most
 of the switch specific. At some point we should envision a merger between these
 two subsystems and get the best of both worlds.
-
-Other hanging fruits
---------------------
-
-- allowing more than one CPU/management interface:
-  http://comments.gmane.org/gmane.linux.network/365657
-- 
2.34.1

