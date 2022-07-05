Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8F5E5675CE
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 19:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232710AbiGERcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 13:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232762AbiGERcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 13:32:08 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2042.outbound.protection.outlook.com [40.107.104.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20025186C1
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 10:32:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GJJ4nMxG18ON04MJkFQBgFJnfGFOpo1p0zafIKtr3lbd3U504NGaW0VcWKiYBmembmz4/ZGy/OSYtdBVC/wO5vpmJ1c5qPVmuDagxIg6LvRjQoEzKHq43sniZDk0PJSPnuPNwItxBCB15jFU6SgFmSAwIro5vmhKFmbyZBefuyv+DLMZgQiMuzbQhzH+84o/dQ2eK/bBw9Rn9w0u5WjXd3V8gCLe5pf7XJP4BpVrMpaLXMGVQc+DL1FGc/ZAplrQVo9loUXzi3Cn3/NWiPa1NflUghTH3fLcTzg0kQDLdYdUycB6KXbUZ0NajljNYib9MXzTcbYno9l4LvRhuiRZWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zKW1o96QgqFt+5OkdUuRn4ZVoGWnUo3uJHNh7lyHl6s=;
 b=cRSU4l0CDMDJEmQhWyHf2VDcws4lz9x/RCroU67b4m7w8NR09qFvpfwoTaqZYz9ns+v73ZkMstE4JTH3VbH8zqqNgabW65yaAkAS8Rd2GtSdryZX/EgR9qY7mHAX7hsG4c/puNasws5fy8XEnzOnSgxRfbQ+4VNMYDbJV/zYoZez+w4HTxNweDv3eOAm1S5A5H245q8anMcgti03PCB45745iUsIuSvtk7c+8VsTfqN2Nx8h9JJHJWOeZHJtNbsUC6rPeTAAJBNoQcnbzxjH1IQiGKwd9mw50W8YO8CA028IwSD4a9bxjqQfzwcN98N1D74MJU0DgrZ6QLwOTXaqdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zKW1o96QgqFt+5OkdUuRn4ZVoGWnUo3uJHNh7lyHl6s=;
 b=gKky5W9eyXGF8NBjqYLNp5ERszJcgrgpGt1n3Ga9gboDqaby5ic0RBw3d5B5c1PF0l8fGwRV+mVvMU5ISEvZLBqUDFO13o8gtnROS8mEsOvObLtbgtrpA7L1hJ578Bpy9zR37WkRPhIAAWPHR36m5a1pm2TiN78QGGI4nOoqn9Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB4251.eurprd04.prod.outlook.com (2603:10a6:5:28::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21; Tue, 5 Jul
 2022 17:32:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 17:32:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [RFC PATCH net-next 1/3] selftests: forwarding: add a vlan_deletion test to bridge_vlan_unaware
Date:   Tue,  5 Jul 2022 20:31:12 +0300
Message-Id: <20220705173114.2004386-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220705173114.2004386-1-vladimir.oltean@nxp.com>
References: <20220705173114.2004386-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0057.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::8) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c3cca22-ca79-4cfc-c883-08da5eac46b9
X-MS-TrafficTypeDiagnostic: DB7PR04MB4251:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jKMQO4UzMFc5JgRSJEppbidpYvY1Nz0SbblX2lKOHeq/zOg5SZXG6aeqcBqdp1bm7fgLdxY5/tbNQKv7XpYIfVsW0q5SBuw7//5p98prvfljhledXKPjjg+fq3C2d6Vq2RkoUQduHuwldR+rN7Gq8NKZBwYuuXykbpHluLq1ntTGn33b2E3weX3UVGGcvk7RBP8B6jApKryuQAdzbWll9+yv5kX9eHJqp49HvUrQUPNPycmeWLXPakCubpARDFB6zxxKjE2mEUry0lAQpJEnA+ph5hRLA3uTOb7OHpfF9fbIWNcUCxPqItiYEn6JazoNwokh5FxbHqIypORDFOZmEgNKSPOZS0njS3ssyZXtkAOBMuTBN5BydmE7ewHRkIO+SpqNsTciNawvv0hscjaYDSso2Zv4lIbF7p/uknMiqhqnZEmBp2WiGCh+9+s4PCMZkJH9oWqjCNNBcFUBT/yX9zdajXoF2anpgBndNGvlgD3u4b/wVP/IYHs8Q/4UyUFxEF5MjhvjoNPAEhPDFAh94OAlfYWkDCKHxQC9PRHsMTzM3kRDP0uyYpqZ58nBzlt/7ohixS/70aandWH40+BmAyTKZ42NInDvYOujBAaL1qdTHxanYghERAdjI5HjlTwA7h1D5bMp/cF41dVD0S93+bCHddJPws8pGSisNOvjzxzMVhpdmrU8tOedWM3O+uVHaHvxsyTeYvC50EG+P96gol2oPgQRc8S6z+pnjOrHVDVN1BtvMrjd+c7a82LeNimoYJ966Sfn+WcxPRMpX2JvXHFAt4wV21CDYZUKvJ0Lj8zVs0Nw6KoopwYtoKYCSyGLNCVZAVek9h47dYrfufg/LA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(8676002)(4326008)(66946007)(66556008)(1076003)(478600001)(66476007)(6486002)(186003)(6666004)(52116002)(6506007)(41300700001)(2616005)(54906003)(6916009)(83380400001)(316002)(26005)(966005)(86362001)(6512007)(2906002)(38100700002)(38350700002)(36756003)(8936002)(7416002)(5660300002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zM1X98wjyx+ibrl6yZ+rLO+7ncI3f4xv9kKdyPx74/v0zRugbtlMpZlb/RFV?=
 =?us-ascii?Q?V1NYo5H2tUGAczIvIXPToKcSueA4hEcZsfVANjJvaAhJAS4pZ8ACFar1c8EA?=
 =?us-ascii?Q?xz1f+QMLifwhi7NQrr9BQ0kkJCivpJ0roIjdBB2fYTz1WnXpA4qqChxJM8dZ?=
 =?us-ascii?Q?4n/Kbp6MjXL7IuFFbVq3Q9ZO7LOQW/3lG54GG5Fklz1Q/ECKYmmbC8/xXODO?=
 =?us-ascii?Q?5bJg9IauIwTd+XErJ+r0ASYA4yiS8MJaDzc85SLHOpZ69IEFLyywZ04BE4f6?=
 =?us-ascii?Q?WALXsWPOMuLuCJY5EL+plsUavDVDMnBoS/HWmZCSyrAwEek/WHHMeknj8EdY?=
 =?us-ascii?Q?GOpdR507DPhaw7Nm9ojhhb2WeUsM6ot5f3LPiNeMpWyyRjxLiuYqScutLZjI?=
 =?us-ascii?Q?L48Y/8Kp+Yhyjpe4fJqDX6orp3nRq7Z6c1ntMz8wVi+jsN+4fwp+fn26YJp2?=
 =?us-ascii?Q?ksVMQ2ZDeatn4z4RlEl5hf+/pQ0QEhnHp26ItnCr7r8DWkg3V2OJvrIHQuUv?=
 =?us-ascii?Q?b6zJwo/fAUVzPr7zKgoSrLAYyFtqz2OqvrlN4dJVA6XTkYjlnNOSXBezXRjC?=
 =?us-ascii?Q?RnMx6X9iJSZXltP8aQjyl8xZwogCkAXO5vLElh5MLh7wSUqex0Rmi1/MzCxr?=
 =?us-ascii?Q?9H2HTWn5IuDMLMKV3U0UHXwn0Iojq16FEno7fTpQE+BtxdZWPB1HH4fItynD?=
 =?us-ascii?Q?8et9bCPoszwu5yiSoXy82LsZG8qSnYQWA9l/6mDkL/JHwvbIQHnE3e83kSaw?=
 =?us-ascii?Q?T0OifseBF4m/xHpb2PAWi4A20xZbh6LNYuFf4yuJf51As5B6Uimn4PaAmHkC?=
 =?us-ascii?Q?E4l/HwQQbIUQ+0UcYm6j/5RFikCVIDl6G4wFXzKHJdglnBAfjAsKXM9jc+yf?=
 =?us-ascii?Q?r9y+htsCAS7Gl6hD1KDbauEFVem7ezkn8Lbnqb2FBCVOL+W24l343iBSl0nf?=
 =?us-ascii?Q?EDFj2XaQVCQoYlBPTs+MytbSeKQNGa1vquYYuhCX/DDn2kqbH0DCCYbbC3Iq?=
 =?us-ascii?Q?FL1RA5xrHRamO+wsoF3R1WQvNJ8E5QP+eVXnvR5vD/hgNT/c1zLCBqrBbzfo?=
 =?us-ascii?Q?QUwuRvFUkGcX9udEQLV61UHEVqgXxgbSm4Xee5sYB4tZT7XLFzlbZyUW0JKn?=
 =?us-ascii?Q?mHdLggUujmKWz4j3sjEvKCtrh2oTzG6iRb/3+09AJCY0EoosD6gHv9e8DLHW?=
 =?us-ascii?Q?XC/4aIu305ElciFrcQz+cxjLQXXsmTo2BCqWISGr3R3UVX/tz8YuYJMls5se?=
 =?us-ascii?Q?aDDICkJAIxh/C6cP7bC7lnm1v6iA36uNKfSbJYrM4KC1e+RarGcRnCjgF6l+?=
 =?us-ascii?Q?YNDk5RMDE+mLsvVlmASzVVB6efiPO3htVp6bBzA0gNBNUv3wXw+E7D7+Ovg9?=
 =?us-ascii?Q?w2I8J8lGzM69/yrMQkfIYWp4KNbDLhqG8SLVtQdF6FVQeTDRX1mKYblnlSKD?=
 =?us-ascii?Q?Lmmz78gyhrPdmJ8BoWR/HN1ASgpBbievnJR9Cj4d8HcTtuSrxNWJUIc0zo6d?=
 =?us-ascii?Q?B1xOvlSY6YJDb1qLH4eZeYl3/3S17uv4nXuhPHNL+Blfpm6bjqgXAM/9msdL?=
 =?us-ascii?Q?goWolROu6kDnnE7xKdR7g2U+717afJPMMOZ7ltyGARFdWDZTdgTqar5ypPa6?=
 =?us-ascii?Q?ZQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c3cca22-ca79-4cfc-c883-08da5eac46b9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 17:32:04.2031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l4RnyCGKwbvVZL6wMsMdtXCdqyS0o/1JJArSIRRcRjATPWNC1xM7q5qfoWYJcgpBU+Td+vsnAGf4n64v75nILQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4251
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Historically, DSA drivers have seen problems with the model in which
bridge VLANs work, particularly with them being offloaded to switchdev
asynchronously relative to when they become active (vlan_filtering=1).

This switchdev API peculiarity was papered over by commit 2ea7a679ca2a
("net: dsa: Don't add vlans when vlan filtering is disabled"), which
introduced other problems, fixed by commit 54a0ed0df496 ("net: dsa:
provide an option for drivers to always receive bridge VLANs") through
an opt-in ds->configure_vlan_while_not_filtering bool (which later
became an opt-out).

The point is that some DSA drivers still skip VLAN configuration while
VLAN-unaware, and there is a desire to get rid of that behavior.

It's hard to deduce from the wording "at least one corner case" what
Andrew saw, but my best guess is that there is a discrepancy of meaning
between bridge pvid and hardware port pvid which caused breakage.

On one side, the Linux bridge with vlan_filtering=0 is completely
VLAN-unaware, and will accept and process a packet the same way
irrespective of the VLAN groups on the ports or the bridge itself
(there may not even be a pvid, and this makes no difference).

On the other hand, DSA switches still do VLAN processing internally,
even with vlan_filtering disabled, but they are expected to classify all
packets to the port pvid. That pvid shouldn't be confused with the
bridge pvid, and there lies the problem.

When a switch port is under a VLAN-unaware bridge, the hardware pvid
must be explicitly managed by the driver to classify all received
packets to it, regardless of bridge VLAN groups. When under a VLAN-aware
bridge, the hardware pvid must be synchronized to the bridge port pvid.
To do this correctly, the pattern is unfortunately a bit complicated,
and involves hooking the pvid change logic into quite a few places
(the ones that change the input variables which determine the value to
use as hardware pvid for a port). See mv88e6xxx_port_commit_pvid(),
sja1105_commit_pvid(), ocelot_port_set_pvid() etc.

The point is that not all drivers used to do that, especially in older
kernels. If a driver is to blindly program a bridge pvid VLAN received
from switchdev while it's VLAN-unaware, this might in turn change the
hardware pvid used by a VLAN-unaware bridge port, which might result in
packet loss depending which other ports have that pvid too (in that same
note, it might also go unnoticed).

To capture that condition, it is sufficient to take a VLAN-unaware
bridge and change the [VLAN-aware] bridge pvid on a single port, to a
VID that isn't present on any other port. This shouldn't have absolutely
any effect on packet classification or forwarding. However, broken
drivers will take the bait, and change their PVID to 3, causing packet
loss.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
In case you see some apparently unrelated failures reported by
bridge_vlan_unaware.sh, it's good to be aware of some fixes sent earlier
this week to "net", which are hence absent from net-next currently:
https://patchwork.kernel.org/project/netdevbpf/cover/20220703073626.937785-1-vladimir.oltean@nxp.com/

 .../net/forwarding/bridge_vlan_unaware.sh     | 25 ++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_vlan_unaware.sh b/tools/testing/selftests/net/forwarding/bridge_vlan_unaware.sh
index 1c8a26046589..2b5700b61ffa 100755
--- a/tools/testing/selftests/net/forwarding/bridge_vlan_unaware.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_vlan_unaware.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
-ALL_TESTS="ping_ipv4 ping_ipv6 learning flooding"
+ALL_TESTS="ping_ipv4 ping_ipv6 learning flooding pvid_change"
 NUM_NETIFS=4
 source lib.sh
 
@@ -77,12 +77,16 @@ cleanup()
 
 ping_ipv4()
 {
-	ping_test $h1 192.0.2.2
+	local msg=$1
+
+	ping_test $h1 192.0.2.2 "$msg"
 }
 
 ping_ipv6()
 {
-	ping6_test $h1 2001:db8:1::2
+	local msg=$1
+
+	ping6_test $h1 2001:db8:1::2 "$msg"
 }
 
 learning()
@@ -95,6 +99,21 @@ flooding()
 	flood_test $swp2 $h1 $h2
 }
 
+pvid_change()
+{
+	# Test that the changing of the VLAN-aware PVID does not affect
+	# VLAN-unaware forwarding
+	bridge vlan add vid 3 dev $swp1 pvid untagged
+
+	ping_ipv4 " with bridge port $swp1 PVID changed"
+	ping_ipv6 " with bridge port $swp1 PVID changed"
+
+	bridge vlan del vid 3 dev $swp1
+
+	ping_ipv4 " with bridge port $swp1 PVID deleted"
+	ping_ipv6 " with bridge port $swp1 PVID deleted"
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.25.1

