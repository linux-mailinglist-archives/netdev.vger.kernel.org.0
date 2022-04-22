Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9842850B4CA
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 12:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446473AbiDVKSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 06:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446458AbiDVKST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 06:18:19 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2079.outbound.protection.outlook.com [40.107.104.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21D52458F
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 03:15:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qd67/NkslE4sIU6IJ2Goxk3ksquQfi+yKMevXeGgr77z6ZJBo7fIS8HktvAG2DU0GB8pwCY9Ynh89MQ2ha37RuEcAuoy+KVNejYR0rwA4sw3JvxZVGvuUVfc75AX0WBZ9ol+3hF2lTvOkWDFDN55FJCGYGOWOm+BsALmDtXU8xFX33hPxaL/n/MCJ3qBFtwDYvBy8flKfK1dcr/Gjx5VY8vSFzwi7drdYYfAGIdCdk2OLP3uVc/9u8zpeJsW/vQEvHZK1BMuxK8H4jl7yJ1vyEoZfDtIPM1dKEerTmfu4jPFosRvbi3cNBB9EAh7/NgY2xYnS6XhJSK/CuyAUmoFlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JDyS52UAM41hUGk27RGq5hDHnf4WQzxsh1Yjz7hvQgU=;
 b=bX+4UZAJsYSXh/msLCKaSXWVvVT2NZlZIM16fiWi7r8Ba/O6SLL65wF+lZSqV1B0R4rfPgoNBsKj8NxhpCihBb7ueZENG6uOvRwU4yPxpDd4F/HCxxCQ/zYls+Py5Tfufz8ZgK6etSzc9PbVRHxhW9Tgl57TCvJDqGPB9pPdXu7wJPwq8gw+SzONwjnYPyU71CDq9xkhYYmwAQMgDntZHWFVYqPk0sFziqHVbSbg7+s1yia9wODXXlwSZxTSyjl8mpqj+/m7uIWqCbI973bDPZpOIIgGglVj/7gN1AVjWQWqHKwFqjpLXEQzQNJ1JVCST7flhcPfsXvuJkLC9a5ouQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JDyS52UAM41hUGk27RGq5hDHnf4WQzxsh1Yjz7hvQgU=;
 b=PfqRNayxPm2HXh06WHTR8oNKkEkK19RMTZ++MqDf2Zzg2luabGKHVwEidH03atxRMGdBSk1uIktc/z+F+FRiqmChlYoz9Je/pjbXyv/f4DtvieVVDqotLFMa+4o/i18EZc+LkDqXxFchadUEZ/rXiqYrsJQbBZq7DkzoDo26tmI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB6836.eurprd04.prod.outlook.com (2603:10a6:208:187::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Fri, 22 Apr
 2022 10:15:22 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5164.025; Fri, 22 Apr 2022
 10:15:22 +0000
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
Subject: [PATCH net-next 3/8] selftests: forwarding: multiple instances in tcpdump helper
Date:   Fri, 22 Apr 2022 13:14:59 +0300
Message-Id: <20220422101504.3729309-4-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: bd2cbff9-6965-4f33-d548-08da2449028e
X-MS-TrafficTypeDiagnostic: AM0PR04MB6836:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB683652A84EDC027F21AB69E9E0F79@AM0PR04MB6836.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BhjzqbUa8OcpCwc9yT0lDJS7CCXA++Wf4J32ytcCJZmifOOEzcwnjfsqjzM7kH5PZyZ+AujT0Jjnrpc+x4Q2PMQvKc3pBGejgCDqg08QxIJVhCrDC0vGEauLuV1LVui3rwwHKGRhlcpcmo2in02NaPLioJ0LKf851bea3zO9OrkPM/YD6zgDyWnM4SkEXYXQkKarTb5t9eJyNzhZ0V8diQUHWthRU23jcKsdiOp805eQmG9NKNDmImYXP6vr36mTgT6OinXxhD8oknNRcPWzgFEHYFC0DkXKlDyp9Pr3Wgda9t95Qb1xcH7g6uuW37tB3BjsFnGJHuM0mmZ2goToCSlQ57t5a9iks1f04/7jtpv4ZfcxsOMzicVfE6zCAmPeSKZ8BgjgaHHkPziaEl8G/YRzaku9fUTr0jSSv0jmY4RfuInSBsk2qPv8QqKZxHXYDuPXixEjnqAehlJBVe7LDHVqzegebGSwkWaEJMiPCm3zMEZVFbkgDCNVJv70LLxAnzAUwMaQS376I1qelgzO1hm2PuP/OmNNOp2FA73jcqSdhOf1n6dFPrYuA0w3L/2RjMgVJHz8BzHHmcYmg6cIR2L0cNfDTJA1JldRp38dfZolL14mpL8Xny57gLZp3zaxY/MXA8CDWgK9+7S1Ww/G0H6z6hYOH6bDoQ+B9Ni8EqEeDBm50jeixvJezJC90DpLjrD9jkOQ6A3DLJG5v2HCrg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(38100700002)(38350700002)(7416002)(5660300002)(2616005)(52116002)(83380400001)(44832011)(66946007)(66556008)(4326008)(6512007)(6486002)(2906002)(8936002)(6506007)(66476007)(6666004)(8676002)(86362001)(6916009)(54906003)(186003)(36756003)(26005)(1076003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/s2lnpJC3OeTXQr8IvVC4YkUOY2lyxpFMNZEk0Z4AoLL05eAg749jDwLAwu1?=
 =?us-ascii?Q?a8J0WGpcHrdVcQwqqL9mqTnURpFgQc5/5XmpeE7NQtxEbTQYPkOjg7d10rBr?=
 =?us-ascii?Q?9PKpY1bpsSHyVYt6tDnSZEWtF7p/HExipKngDVobApFGCcU0OcvbdSyCuptp?=
 =?us-ascii?Q?9PbAgQagUDVHzElV9ZO+Z1dpKhU9TeEgr7l7t+FEzUu5YH9vra9rm7Vu6DMY?=
 =?us-ascii?Q?H5pTF2wQY59BTGhSMxE6AsVjrS8IRA2eAfIDVYZTNmKdW4Xk1EJd+fZuwjKv?=
 =?us-ascii?Q?pNwPmG+tPhbHOm0WwZmP68c0YPbHly9uq1mISePLRN0NRgX8eSA6W62sJhD4?=
 =?us-ascii?Q?Fr5juuGC/65sOi6QielFbtd1GSBlwuc6m/vSO6llZ3tmlBcdJntkbvgu2Wr8?=
 =?us-ascii?Q?NYmIVJ6atUZkUR8jJ0um2KhZKpEVZrCcGF2ZD+2L0RUjBNzlQuAa7ejeiY5A?=
 =?us-ascii?Q?PyfYAJv6LloVLRnnG38F48mop/dJMOyYnhTQczbeQdMCEfybhkXq08rL7MLl?=
 =?us-ascii?Q?3FerT4iRGCVs8nKavk+eg3CahvNhGqC38CGetx6g3x/FNEpM0DkVRrZyYfjS?=
 =?us-ascii?Q?FJayj86eFCxW2o9oBIb6pj2DVCT90XJ7u7w5Cs6UPNxIW559MSBXPrW8rml6?=
 =?us-ascii?Q?ZvWIaQ7asbEn4ZJU996KBoEAZv1bARCDQsUrUtMWt3+oHWU1RIutlZxFO6Gc?=
 =?us-ascii?Q?XHv7G1BGKCol/6RP8kuPBqBVaxiXUongk/peg2F3EXxn6riIkOthtdCXOBjm?=
 =?us-ascii?Q?Qtnz0k4WGocRtJ3PlTsA1rUxEUpKV7BTDqaiIMcIDSZRVJjjxmRDVaGjw5TE?=
 =?us-ascii?Q?PVfhxwOi3/X60MLsHNsKuhyp/eaMsxbMmYzCQNjS86thc+3w+/gw+UOTMWdt?=
 =?us-ascii?Q?KpgydEg7dzIG4wi2bZKjMohRdC2BlWRO4JCz4IuTKh9buh083VU/CnAZzjGg?=
 =?us-ascii?Q?jtacjDqV28E1pwngKJ/3n9t1ChZBniR1lwaBCjr066VDM4VsziM8hKT2ZQVJ?=
 =?us-ascii?Q?cgqRLlCLilKtIV7M7IBahifCzlaUG99DAMe+bb8U+YwuoZA1Rc+94IxY8efn?=
 =?us-ascii?Q?uyDbM2nSIO9RJqQSoSle1jkJGszx96neYzkSa5WRfwa1QtROvP8646V7CMZF?=
 =?us-ascii?Q?qtlMddW9YnPxBhXq0eZ7bynt0dhHIDGF+kEGVSUw7RsYBYX2iWVGYuChdCTo?=
 =?us-ascii?Q?31tpVK01tGTcB3emFKspB8mAPGRo3/PO5lZKDlD0XQofWEe9VM/Ektl2SldU?=
 =?us-ascii?Q?lFgh+PdyvOvM4pneaDAm9FELzUERHKL/WRKTh92ht+SBOHLJTSO+Kh5mGz2J?=
 =?us-ascii?Q?0PHQpYlYVDVyYae0J+fgKESmtQ5IPaSxMRQhCNBN9lWKcKjy0Alafo/JcGQF?=
 =?us-ascii?Q?fDq7NM1sdreoLHmu6Y9pNOUuG7Y5im/d9+7kxSV2hJotiYp7BuBFw7nwTcDB?=
 =?us-ascii?Q?/0MDu7vrTYlzrZKsLdeRDaASyaFwk3bSk56Mkd3EU/1/Zz26P4ZPDQg9iud9?=
 =?us-ascii?Q?hX9ROLpqQd9CyDMhndSkfmWbT9N7XzgdrZ3mJdRb1KGjCRRDE7aSJ3QZqrek?=
 =?us-ascii?Q?wjNWjk/Gdpd73mTIPJJ4mtIgK04bxzlr0S6Q92FRby4lMwJSuFojgYiNipnm?=
 =?us-ascii?Q?ne4JGaUWTqm/u7vaRWDTMJVEFU0yYv63fAQdjChwfEtCdtdd4jxkYCSzAlTA?=
 =?us-ascii?Q?osocOzr+sWnC2ig2Bge1cvdlBqqIbrr2wilF2otc6457qOsgYly6esBBcb83?=
 =?us-ascii?Q?/OAKECAy2pvmC6bFSUnQx7qFXhWUK34=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd2cbff9-6965-4f33-d548-08da2449028e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 10:15:22.2192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dF0Elt26F/T15qsjM4jriOkE1/AvFqRF684x5TGLdmaI8yabU0KDRpA+RmMShY0yty53TO+Tb6needYbHSCfBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6836
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joachim Wiberg <troglobit@gmail.com>

Extend tcpdump_start() & C:o to handle multiple instances.  Useful when
observing bridge operation, e.g., unicast learning/flooding, and any
case of multicast distribution (to these ports but not that one ...).

This means the interface argument is now a mandatory argument to all
tcpdump_*() functions, hence the changes to the ocelot flower test.

Signed-off-by: Joachim Wiberg <troglobit@gmail.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../drivers/net/ocelot/tc_flower_chains.sh    | 24 ++++++++---------
 tools/testing/selftests/net/forwarding/lib.sh | 26 ++++++++++++++-----
 2 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh b/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
index eaf8a04a7ca5..7e684e27a682 100755
--- a/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
+++ b/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
@@ -215,15 +215,15 @@ test_vlan_pop()
 
 	sleep 1
 
-	tcpdump_stop
+	tcpdump_stop $eth2
 
-	if tcpdump_show | grep -q "$eth3_mac > $eth2_mac, ethertype IPv4"; then
+	if tcpdump_show $eth2 | grep -q "$eth3_mac > $eth2_mac, ethertype IPv4"; then
 		echo "OK"
 	else
 		echo "FAIL"
 	fi
 
-	tcpdump_cleanup
+	tcpdump_cleanup $eth2
 }
 
 test_vlan_push()
@@ -236,15 +236,15 @@ test_vlan_push()
 
 	sleep 1
 
-	tcpdump_stop
+	tcpdump_stop $eth3.100
 
-	if tcpdump_show | grep -q "$eth2_mac > $eth3_mac"; then
+	if tcpdump_show $eth3.100 | grep -q "$eth2_mac > $eth3_mac"; then
 		echo "OK"
 	else
 		echo "FAIL"
 	fi
 
-	tcpdump_cleanup
+	tcpdump_cleanup $eth3.100
 }
 
 test_vlan_ingress_modify()
@@ -267,15 +267,15 @@ test_vlan_ingress_modify()
 
 	sleep 1
 
-	tcpdump_stop
+	tcpdump_stop $eth2
 
-	if tcpdump_show | grep -q "$eth3_mac > $eth2_mac, .* vlan 300"; then
+	if tcpdump_show $eth2 | grep -q "$eth3_mac > $eth2_mac, .* vlan 300"; then
 		echo "OK"
 	else
 		echo "FAIL"
 	fi
 
-	tcpdump_cleanup
+	tcpdump_cleanup $eth2
 
 	tc filter del dev $eth0 ingress chain $(IS1 2) pref 3
 
@@ -305,15 +305,15 @@ test_vlan_egress_modify()
 
 	sleep 1
 
-	tcpdump_stop
+	tcpdump_stop $eth2
 
-	if tcpdump_show | grep -q "$eth3_mac > $eth2_mac, .* vlan 300"; then
+	if tcpdump_show $eth2 | grep -q "$eth3_mac > $eth2_mac, .* vlan 300"; then
 		echo "OK"
 	else
 		echo "FAIL"
 	fi
 
-	tcpdump_cleanup
+	tcpdump_cleanup $eth2
 
 	tc filter del dev $eth1 egress chain $(ES0) pref 3
 	tc qdisc del dev $eth1 clsact
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index de10451d7671..7eff5ecf7565 100755
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -1386,13 +1386,17 @@ stop_traffic()
 	{ kill %% && wait %%; } 2>/dev/null
 }
 
+declare -A cappid
+declare -A capfile
+declare -A capout
+
 tcpdump_start()
 {
 	local if_name=$1; shift
 	local ns=$1; shift
 
-	capfile=$(mktemp)
-	capout=$(mktemp)
+	capfile[$if_name]=$(mktemp)
+	capout[$if_name]=$(mktemp)
 
 	if [ -z $ns ]; then
 		ns_cmd=""
@@ -1407,26 +1411,34 @@ tcpdump_start()
 	fi
 
 	$ns_cmd tcpdump $TCPDUMP_EXTRA_FLAGS -e -n -Q in -i $if_name \
-		-s 65535 -B 32768 $capuser -w $capfile > "$capout" 2>&1 &
-	cappid=$!
+		-s 65535 -B 32768 $capuser -w ${capfile[$if_name]} \
+		> "${capout[$if_name]}" 2>&1 &
+	cappid[$if_name]=$!
 
 	sleep 1
 }
 
 tcpdump_stop()
 {
-	$ns_cmd kill $cappid
+	local if_name=$1
+	local pid=${cappid[$if_name]}
+
+	$ns_cmd kill "$pid" && wait "$pid"
 	sleep 1
 }
 
 tcpdump_cleanup()
 {
-	rm $capfile $capout
+	local if_name=$1
+
+	rm ${capfile[$if_name]} ${capout[$if_name]}
 }
 
 tcpdump_show()
 {
-	tcpdump -e -n -r $capfile 2>&1
+	local if_name=$1
+
+	tcpdump -e -n -r ${capfile[$if_name]} 2>&1
 }
 
 # return 0 if the packet wasn't seen on host2_if or 1 if it was
-- 
2.25.1

