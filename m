Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D02850B4D0
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 12:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446469AbiDVKSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 06:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446464AbiDVKSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 06:18:34 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70049.outbound.protection.outlook.com [40.107.7.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB06329A9
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 03:15:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SNm4lNRgvp2GEChB0yvqAh5/4KZ7m3Xemc8q+sa0bisCQOzFa8uy13ahrZV3KQb74w7hfKIiS2PoqlRYmeZQSK5wWX3FdmkmtiWuOlFIcnkU+rDbmVK0CBMfay+s1hrn8nRsvL1RQnE2HOdEwKyhWHMIz7QPUdTQu822qPOzQ2/75aCbDQ6mlVqi2II058z6W5ZB0hXQb4h5fHSDQpf4NAqrjLZG9jvtOoCklVN4TA0VG7PH2YVpGHyTXd6KSOMDAOuTTjOvjNODZh4aT+Fjm792pzHhaN4wn9uhylH4zsVOsqkwCJVDfAd/kudLzhViWXuRx/DNgqD4RLs5cEH6vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rglzcloAro3lBMip8aZQ6Ic+gAjm48vqecjyiEHeSnw=;
 b=YMxn2vKKScHm1HPt2DqLzXZ9ocyGZrwABmyiP08vY93++MMxeoi34tUQlYYv8oicmBd39mg1STU5edxkiKUXcK08NudIQe4PSgdRxYP7+aFRYSI3rBVMXc8XeXXo41Rk48ogh4VtZVruEDP1pJNe/foFXhU1+1vZ2QzY7JRJL95WINCI4cPaABseIRoqQy6sTfXLa4VcMy3BKXujiUco904QrgH8Lk0ih0NNRpD1G0KKdjubtrSB+MJq8zTR7rQylRpEGlrkIIeZ+ZxLjJPJy4JPADCaa9HduAE4CZR8pfmO4hNU3B+2NQztrxIH/Z4R0SxRiu4HIv+qxHC2yLNARQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rglzcloAro3lBMip8aZQ6Ic+gAjm48vqecjyiEHeSnw=;
 b=br6+jrnQbelSWXXO09OvoULJh6Vdpj9saxf7Qu55JxaW/V6aPoGXNlyFt7D8Gi098HpIrPeIU+qnRmE2Fum21G9YuWnnzbBfZi4S/SWRCgpA5ZqlvZDliC8FuZ6kJtDQbZsJYvQ/gqUOUU2WgzpNzG1QWcyR7S9G3cUnDCd9SYE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3856.eurprd04.prod.outlook.com (2603:10a6:803:21::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 22 Apr
 2022 10:15:26 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5164.025; Fri, 22 Apr 2022
 10:15:26 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next 7/8] selftests: forwarding: add a test for local_termination.sh
Date:   Fri, 22 Apr 2022 13:15:03 +0300
Message-Id: <20220422101504.3729309-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220422101504.3729309-1-vladimir.oltean@nxp.com>
References: <20220422101504.3729309-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0057.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:5a::46) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5aa93866-58b9-4a6f-4f20-08da244904ba
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3856:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB385657F84AE7370BC43FF708E0F79@VI1PR0402MB3856.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DzRpZntMCm1fdMK6zqDtdOrI27hdqhlBlHZtOwq6zYEdXwYa7cw5HnYU1bkaB23OyrYt667bExWLTP6/qNPt5F84zunpUr0PGH1Za2xDHRB/AtxGYX0xJ35gJ4KwmDvKXjyIQew+dIDeLAxU3SmYENxO7gkrs7+z1pr2ui/yAXUApHigqZaR7PVDAMsD6bWbDG39JQ5m7c0ds37kAU+Fd2eHnxf71nw8VUNv/ly9GLF6nWb8LM6pVIDilZUNN5ssKdP5EWEakFM3GgyfMd0q7/gmW9iEvFzGbodjUO8JcpVt5AjIDm+QgrU3yFQBXULdGd1bq4quKhjCrbJY1YUuYJJ1a+FA3h+f7eo9lETniF+07o8suhJRGV7OE+FEDE1e2GVz29560dxnn63IkDJru7+jFyWv2udjTEvQAx86rCx/0in+/h8iKW7XKaHpX7r8GN6Ngxrkfd1XCTO3wLoWtek40dXKS1tR3Cp4sh2zLh/79hfoGsZzmfdiAIeNPLNY+Op+YPSo0TTrz9Y5mF4lWn9KSz0sdcP/2qO7RXTvtlTfoNNO7UPe+xLL2KmOXg72bmiGAdscv4wgToxK1Y+o+/6rcWOZb6XMCCzF7G/T3YkwZczwcsmWhhFWvpBcX1ogjknxiYhG4md3oavZcCLN6JOBXKeI0Fa06z6cKbjQ6yd62MYCWqGC7Yg1rselIPJwbcwDr8co6+X9ZTUlOUeueA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(5660300002)(36756003)(86362001)(52116002)(8936002)(2616005)(6666004)(6486002)(508600001)(1076003)(186003)(44832011)(26005)(38100700002)(6512007)(83380400001)(2906002)(316002)(38350700002)(6916009)(66556008)(66476007)(54906003)(66946007)(7416002)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rrbmZfI/SrdjeTSpkC4brIMux3LzHjb7AnDF8HGI4YB0GsxCOvkqXealZ6Gf?=
 =?us-ascii?Q?S77tv0oxDKwiyK3x2bKIf7Cg7nY3aAtnyOU+OBvVMvTiP1Wa73Wv9K8re51T?=
 =?us-ascii?Q?aUDCQghzz+EYGkQJ6SW/3OvIwzchgJfQtoouBywI0StfxXLnBDgla4h3dnNY?=
 =?us-ascii?Q?yaix8R9ALYD19JpQ0AzMuauCaCM/jzjUW8RrCqEltYFakTXWns/kJ6i1ARjL?=
 =?us-ascii?Q?8+eFds2LPaAlzy3mxjgTSgq7o6xIFikjOgqaSXVlxYtMkJoVGXx6p69e8Jck?=
 =?us-ascii?Q?BPV9oEsXL9duDmz6rnaxg4swgczNTx/RmLE2lLoh5gFJptfp2XxHPYI5zVDa?=
 =?us-ascii?Q?g+VNNFa1+TyBialTXxk4YS0trfngpYB+2peRCLDUwZ7A1JUQr0p70H3sCOcW?=
 =?us-ascii?Q?yTSIL9rg20RgkV0hzLMhJSDU+fFis5WkUhuDyDahJq2ls9mSdnG0qLBCWfRj?=
 =?us-ascii?Q?kjweze6d5L/SOyQiv6wfg9HejEZko/L5FnlMe95+pNN4RK2nRAB1uE3MuZQ8?=
 =?us-ascii?Q?9s0IoCJ7FYgdMA4WSDV+3M2dPmX4Eua8DBGr008rtCH4qfz35ITe/sKfS7z4?=
 =?us-ascii?Q?XHq0fOY7XSy5B1pIFwnHvjn+VL6yOvlgtn4hYdCuPYsnwigV51A973oL0XaU?=
 =?us-ascii?Q?pfnMmILYdpMsrINU++YAOalAX0qfFjHAMB8xRfWixjuT0NBdUC/3z0Vv00Tl?=
 =?us-ascii?Q?pJIwB4S882tsf+WNKIVKJFkrF+BYYUFABi6q7RHxyrl4UGr5Fd+UPhXVme3+?=
 =?us-ascii?Q?j/fllNDme4O+fdlA03iIpes+3LSofX2HwpGVB/+PwhL05gY2ZsCdmpNozP/R?=
 =?us-ascii?Q?YPMEcTlfg8L/JxZwp/CBS9irxvfn52W/52pKLEYmRDW53g8LhO0IxeadojfO?=
 =?us-ascii?Q?+j+0zAD0BFPyGqfmRlPcDiE1xhfeBnhcuYcuxltYKIhi9w/jJ2F5H8RmkciL?=
 =?us-ascii?Q?fUwTG5cEchOU1t6Y5A7pNAbCou6FKtpzHqo2n3c1Yk/XiraPQBhl4H7xr2m8?=
 =?us-ascii?Q?caoPir7KnD4Qf7kYBL+xvNd/5LBjnbqAqiHbl0E+LCNOlCT3rbAEDVMqslrc?=
 =?us-ascii?Q?Lzd59wUuj7qnoyTnTGXHTIN16Xf2cpxayEc+XXF+HLTY5svHZrIEelKI+wo0?=
 =?us-ascii?Q?r5H0kISb+EIovZH/dpz0qpJQ1DcXkNv9G2fd6GGYZXMQyTwEw76fr1tRum7v?=
 =?us-ascii?Q?qlLqrf3XrXGGFhD/7VaVQa/77Lli33Buh8YCzNBW40SKhhJhSvfcymW+QUNz?=
 =?us-ascii?Q?Qe1PHJvMim/zvv6tib4ZRGeW3SpjaY0mg4oabmmID9oGzP/P7f4RqAYknAbI?=
 =?us-ascii?Q?VSsMA0ENRG+fWsyWUaJF1rCzimMcm2WIAhCoG395VHbuiLwEPk/0hJIDKSzs?=
 =?us-ascii?Q?YYukZRjtCdNtrkxfx3D4cr3PJUIAh/1gCa7v4amfGSPGkNqTbADJcz1Gizsz?=
 =?us-ascii?Q?POZ5vCIe2uoqACQhfCSvubfA18FJDBaUmkb76BRzBQHkrJBdXc7uJDZEJhmd?=
 =?us-ascii?Q?r3hILHVm7a2qrb5MIFSsZ+XEg3Cii5dafqHZgdtiZVdgf3U0XBJNBorzopKb?=
 =?us-ascii?Q?OgPyFjX2o3+fuJlQ4aSyjEdUquroKaS+68gOL/okGYu4flfvGJF9Q64xA/ZW?=
 =?us-ascii?Q?l42UfNhbIFmVXsrU8XO3tq1FZt1sWxsiuHB6QWnegV76tcDiKlZTje8eP5sK?=
 =?us-ascii?Q?Ri0Xx0DBbHEECwb7icTu7hAiYHMxenvsiuWAhNXojEc9usFCB2CLnB5bu7FJ?=
 =?us-ascii?Q?W1toKfw/efAi+UpAMc27qjABHj48WQA=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5aa93866-58b9-4a6f-4f20-08da244904ba
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 10:15:26.1252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y4BSB82PGjTNPoSubT3ttcismbwDYsrtEzaReQVqfUWwQwd6/e6Q/1lbJjADT0DeT59wFZH47XHZ8qf3KG4vdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3856
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This tests the capability of switch ports to filter out undesired
traffic. Different drivers are expected to have different capabilities
here (so some may fail and some may pass), yet the test still has some
value, for example to check for regressions.

There are 2 kinds of failures, one is when a packet which should have
been accepted isn't (and that should be fixed), and the other "failure"
(as reported by the test) is when a packet could have been filtered out
(for being unnecessary) yet it was received.

The bridge driver fares particularly badly at this test:

TEST: br0: Unicast IPv4 to primary MAC address                      [ OK ]
TEST: br0: Unicast IPv4 to macvlan MAC address                      [ OK ]
TEST: br0: Unicast IPv4 to unknown MAC address                      [FAIL]
        reception succeeded, but should have failed
TEST: br0: Unicast IPv4 to unknown MAC address, promisc             [ OK ]
TEST: br0: Unicast IPv4 to unknown MAC address, allmulti            [FAIL]
        reception succeeded, but should have failed
TEST: br0: Multicast IPv4 to joined group                           [ OK ]
TEST: br0: Multicast IPv4 to unknown group                          [FAIL]
        reception succeeded, but should have failed
TEST: br0: Multicast IPv4 to unknown group, promisc                 [ OK ]
TEST: br0: Multicast IPv4 to unknown group, allmulti                [ OK ]
TEST: br0: Multicast IPv6 to joined group                           [ OK ]
TEST: br0: Multicast IPv6 to unknown group                          [FAIL]
        reception succeeded, but should have failed
TEST: br0: Multicast IPv6 to unknown group, promisc                 [ OK ]
TEST: br0: Multicast IPv6 to unknown group, allmulti                [ OK ]

mainly because it does not implement IFF_UNICAST_FLT. Yet I still think
having the test (with the failures) is useful in case somebody wants to
tackle that problem in the future, to make an easy before-and-after
comparison.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../net/forwarding/local_termination.sh       | 299 ++++++++++++++++++
 1 file changed, 299 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/local_termination.sh

diff --git a/tools/testing/selftests/net/forwarding/local_termination.sh b/tools/testing/selftests/net/forwarding/local_termination.sh
new file mode 100755
index 000000000000..c5b0cbc85b3e
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/local_termination.sh
@@ -0,0 +1,299 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+ALL_TESTS="standalone bridge"
+NUM_NETIFS=2
+PING_COUNT=1
+REQUIRE_MTOOLS=yes
+REQUIRE_MZ=no
+
+source lib.sh
+
+H1_IPV4="192.0.2.1"
+H2_IPV4="192.0.2.2"
+H1_IPV6="2001:db8:1::1"
+H2_IPV6="2001:db8:1::2"
+
+BRIDGE_ADDR="00:00:de:ad:be:ee"
+MACVLAN_ADDR="00:00:de:ad:be:ef"
+UNKNOWN_UC_ADDR1="de:ad:be:ef:ee:03"
+UNKNOWN_UC_ADDR2="de:ad:be:ef:ee:04"
+UNKNOWN_UC_ADDR3="de:ad:be:ef:ee:05"
+JOINED_IPV4_MC_ADDR="225.1.2.3"
+UNKNOWN_IPV4_MC_ADDR1="225.1.2.4"
+UNKNOWN_IPV4_MC_ADDR2="225.1.2.5"
+UNKNOWN_IPV4_MC_ADDR3="225.1.2.6"
+JOINED_IPV6_MC_ADDR="ff2e::0102:0304"
+UNKNOWN_IPV6_MC_ADDR1="ff2e::0102:0305"
+UNKNOWN_IPV6_MC_ADDR2="ff2e::0102:0306"
+UNKNOWN_IPV6_MC_ADDR3="ff2e::0102:0307"
+
+JOINED_MACV4_MC_ADDR="01:00:5e:01:02:03"
+UNKNOWN_MACV4_MC_ADDR1="01:00:5e:01:02:04"
+UNKNOWN_MACV4_MC_ADDR2="01:00:5e:01:02:05"
+UNKNOWN_MACV4_MC_ADDR3="01:00:5e:01:02:06"
+JOINED_MACV6_MC_ADDR="33:33:01:02:03:04"
+UNKNOWN_MACV6_MC_ADDR1="33:33:01:02:03:05"
+UNKNOWN_MACV6_MC_ADDR2="33:33:01:02:03:06"
+UNKNOWN_MACV6_MC_ADDR3="33:33:01:02:03:07"
+
+NON_IP_MC="01:02:03:04:05:06"
+NON_IP_PKT="00:04 48:45:4c:4f"
+BC="ff:ff:ff:ff:ff:ff"
+
+# Disable promisc to ensure we don't receive unknown MAC DA packets
+export TCPDUMP_EXTRA_FLAGS="-pl"
+
+h1=${NETIFS[p1]}
+h2=${NETIFS[p2]}
+
+send_non_ip()
+{
+	local if_name=$1
+	local smac=$2
+	local dmac=$3
+
+	$MZ -q $if_name "$dmac $smac $NON_IP_PKT"
+}
+
+send_uc_ipv4()
+{
+	local if_name=$1
+	local dmac=$2
+
+	ip neigh add $H2_IPV4 lladdr $dmac dev $if_name
+	ping_do $if_name $H2_IPV4
+	ip neigh del $H2_IPV4 dev $if_name
+}
+
+check_rcv()
+{
+	local if_name=$1
+	local type=$2
+	local pattern=$3
+	local should_receive=$4
+	local should_fail=
+
+	[ $should_receive = true ] && should_fail=0 || should_fail=1
+	RET=0
+
+	tcpdump_show $if_name | grep -q "$pattern"
+
+	check_err_fail "$should_fail" "$?" "reception"
+
+	log_test "$if_name: $type"
+}
+
+mc_route_prepare()
+{
+	local if_name=$1
+	local vrf_name=$(master_name_get $if_name)
+
+	ip route add 225.100.1.0/24 dev $if_name vrf $vrf_name
+	ip -6 route add ff2e::/64 dev $if_name vrf $vrf_name
+}
+
+mc_route_destroy()
+{
+	local if_name=$1
+	local vrf_name=$(master_name_get $if_name)
+
+	ip route del 225.100.1.0/24 dev $if_name vrf $vrf_name
+	ip -6 route del ff2e::/64 dev $if_name vrf $vrf_name
+}
+
+run_test()
+{
+	local rcv_if_name=$1
+	local smac=$(mac_get $h1)
+	local rcv_dmac=$(mac_get $rcv_if_name)
+
+	tcpdump_start $rcv_if_name
+
+	mc_route_prepare $h1
+	mc_route_prepare $rcv_if_name
+
+	send_uc_ipv4 $h1 $rcv_dmac
+	send_uc_ipv4 $h1 $MACVLAN_ADDR
+	send_uc_ipv4 $h1 $UNKNOWN_UC_ADDR1
+
+	ip link set dev $rcv_if_name promisc on
+	send_uc_ipv4 $h1 $UNKNOWN_UC_ADDR2
+	mc_send $h1 $UNKNOWN_IPV4_MC_ADDR2
+	mc_send $h1 $UNKNOWN_IPV6_MC_ADDR2
+	ip link set dev $rcv_if_name promisc off
+
+	mc_join $rcv_if_name $JOINED_IPV4_MC_ADDR
+	mc_send $h1 $JOINED_IPV4_MC_ADDR
+	mc_leave
+
+	mc_join $rcv_if_name $JOINED_IPV6_MC_ADDR
+	mc_send $h1 $JOINED_IPV6_MC_ADDR
+	mc_leave
+
+	mc_send $h1 $UNKNOWN_IPV4_MC_ADDR1
+	mc_send $h1 $UNKNOWN_IPV6_MC_ADDR1
+
+	ip link set dev $rcv_if_name allmulticast on
+	send_uc_ipv4 $h1 $UNKNOWN_UC_ADDR3
+	mc_send $h1 $UNKNOWN_IPV4_MC_ADDR3
+	mc_send $h1 $UNKNOWN_IPV6_MC_ADDR3
+	ip link set dev $rcv_if_name allmulticast off
+
+	mc_route_destroy $rcv_if_name
+	mc_route_destroy $h1
+
+	sleep 1
+
+	tcpdump_stop $rcv_if_name
+
+	check_rcv $rcv_if_name "Unicast IPv4 to primary MAC address" \
+		"$smac > $rcv_dmac, ethertype IPv4 (0x0800)" \
+		true
+
+	check_rcv $rcv_if_name "Unicast IPv4 to macvlan MAC address" \
+		"$smac > $MACVLAN_ADDR, ethertype IPv4 (0x0800)" \
+		true
+
+	check_rcv $rcv_if_name "Unicast IPv4 to unknown MAC address" \
+		"$smac > $UNKNOWN_UC_ADDR1, ethertype IPv4 (0x0800)" \
+		false
+
+	check_rcv $rcv_if_name "Unicast IPv4 to unknown MAC address, promisc" \
+		"$smac > $UNKNOWN_UC_ADDR2, ethertype IPv4 (0x0800)" \
+		true
+
+	check_rcv $rcv_if_name "Unicast IPv4 to unknown MAC address, allmulti" \
+		"$smac > $UNKNOWN_UC_ADDR3, ethertype IPv4 (0x0800)" \
+		false
+
+	check_rcv $rcv_if_name "Multicast IPv4 to joined group" \
+		"$smac > $JOINED_MACV4_MC_ADDR, ethertype IPv4 (0x0800)" \
+		true
+
+	check_rcv $rcv_if_name "Multicast IPv4 to unknown group" \
+		"$smac > $UNKNOWN_MACV4_MC_ADDR1, ethertype IPv4 (0x0800)" \
+		false
+
+	check_rcv $rcv_if_name "Multicast IPv4 to unknown group, promisc" \
+		"$smac > $UNKNOWN_MACV4_MC_ADDR2, ethertype IPv4 (0x0800)" \
+		true
+
+	check_rcv $rcv_if_name "Multicast IPv4 to unknown group, allmulti" \
+		"$smac > $UNKNOWN_MACV4_MC_ADDR3, ethertype IPv4 (0x0800)" \
+		true
+
+	check_rcv $rcv_if_name "Multicast IPv6 to joined group" \
+		"$smac > $JOINED_MACV6_MC_ADDR, ethertype IPv6 (0x86dd)" \
+		true
+
+	check_rcv $rcv_if_name "Multicast IPv6 to unknown group" \
+		"$smac > $UNKNOWN_MACV6_MC_ADDR1, ethertype IPv6 (0x86dd)" \
+		false
+
+	check_rcv $rcv_if_name "Multicast IPv6 to unknown group, promisc" \
+		"$smac > $UNKNOWN_MACV6_MC_ADDR2, ethertype IPv6 (0x86dd)" \
+		true
+
+	check_rcv $rcv_if_name "Multicast IPv6 to unknown group, allmulti" \
+		"$smac > $UNKNOWN_MACV6_MC_ADDR3, ethertype IPv6 (0x86dd)" \
+		true
+
+	tcpdump_cleanup $rcv_if_name
+}
+
+h1_create()
+{
+	simple_if_init $h1 $H1_IPV4/24 $H1_IPV6/64
+}
+
+h1_destroy()
+{
+	simple_if_fini $h1 $H1_IPV4/24 $H1_IPV6/64
+}
+
+h2_create()
+{
+	simple_if_init $h2 $H2_IPV4/24 $H2_IPV6/64
+}
+
+h2_destroy()
+{
+	simple_if_fini $h2 $H2_IPV4/24 $H2_IPV6/64
+}
+
+bridge_create()
+{
+	ip link add br0 type bridge
+	ip link set br0 address $BRIDGE_ADDR
+	ip link set br0 up
+
+	ip link set $h2 master br0
+	ip link set $h2 up
+
+	simple_if_init br0 $H2_IPV4/24 $H2_IPV6/64
+}
+
+bridge_destroy()
+{
+	simple_if_fini br0 $H2_IPV4/24 $H2_IPV6/64
+
+	ip link del br0
+}
+
+standalone()
+{
+	h1_create
+	h2_create
+
+	ip link add link $h2 name macvlan0 type macvlan mode private
+	ip link set macvlan0 address $MACVLAN_ADDR
+	ip link set macvlan0 up
+
+	run_test $h2
+
+	ip link del macvlan0
+
+	h2_destroy
+	h1_destroy
+}
+
+bridge()
+{
+	h1_create
+	bridge_create
+
+	ip link add link br0 name macvlan0 type macvlan mode private
+	ip link set macvlan0 address $MACVLAN_ADDR
+	ip link set macvlan0 up
+
+	run_test br0
+
+	ip link del macvlan0
+
+	bridge_destroy
+	h1_destroy
+}
+
+cleanup()
+{
+	pre_cleanup
+	vrf_cleanup
+}
+
+setup_prepare()
+{
+	vrf_prepare
+	# setup_wait() needs this
+	ip link set $h1 up
+	ip link set $h2 up
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+
+tests_run
+
+exit $EXIT_STATUS
-- 
2.25.1

