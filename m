Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5010D50B4C9
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 12:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446311AbiDVKSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 06:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376870AbiDVKSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 06:18:16 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2079.outbound.protection.outlook.com [40.107.104.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CCA826132
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 03:15:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q3n7oo3DE33mzYWYWlnYb7pNWSlDuTIwDBjALp5t/ia6yjz1gZNS/wJGZr2Rrrv+qWeFQSZDmAnjtiNBoC2xlGVIjJRwqFd4Qu2cVapeg2gwyzWovTSm6Skt2gAPueygpG/vGfSx7tbvyccsGXU7/mLeMmCT0NUxrDwGRCnXAvIFmKC+IUHAouzrCuBPmuOnrZ0/R1nexYisylxgkwoNCoyODW7rlLAXKgCSKi6pjcQz33vqLQVPn/hn3ngbU1uNYw6mv3GO6+IsWl3QB0sRG6t8GY/pWB4QmMEReHrBko7A6bdzbN3wJ7GHEVZwFRlJBgfYyKhX+50diyyEXxD6Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lrLpnNJb4Fa30yBDp2M77syvfN6pv8+dzYBoXZ1nFHg=;
 b=ndNUznxltPTQ2e/GOP6D1KO/Sp1BjIIvr9tUWs3gd3qd7TRaqxPncn3f/vxcOAda2x5o5Y9dY8Ik5k8YnqCAuI4/Kp/AJGTvPiZ9S0q8yty1K7mSKOWqRqa+DAby61eaTsjQEq0ZEHfV9XPtirLSWuXo25CqUxi73u18af+8dmtt9hG0Rm57qD0a6rJcSo6cgmF9Ph+iwHPm7Gp6HY4TMgzVwj9rFQOGSqiLGPouDn6nFnJtrpRny5ws1SX3AXRPA+Nx716p4PV01UbGGiZy27NW5h7N+YMWWxMaw8XeMHMVyCR/vBW2K/JJ5VFNowEA+zrvByOTJtXDDvt1xz1DFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lrLpnNJb4Fa30yBDp2M77syvfN6pv8+dzYBoXZ1nFHg=;
 b=ZoTyhjk4jZ7dpqyC5HWnNo9xnmGEygItyj4kYP9e9JDh2/dniPxFodMwIa5LcGQbCrZdAn+8k4SYa3O6ILw2wzpdOxrGdXmT9vLrpbUp1+8BFiV70bCDZ/z5iSjiV1WO7aX63X6dMc8dj6KhNeSj51eDltiVH+YgZKIE4chmUzw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB6836.eurprd04.prod.outlook.com (2603:10a6:208:187::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Fri, 22 Apr
 2022 10:15:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5164.025; Fri, 22 Apr 2022
 10:15:20 +0000
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
Subject: [PATCH net-next 1/8] selftests: forwarding: add option to run tests with stable MAC addresses
Date:   Fri, 22 Apr 2022 13:14:57 +0300
Message-Id: <20220422101504.3729309-2-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: ac71a5fc-774b-4f5c-707b-08da24490181
X-MS-TrafficTypeDiagnostic: AM0PR04MB6836:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB6836429FD830A6A251B2C56FE0F79@AM0PR04MB6836.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cAC1tZVhqXSCnFIsGFmQag+j0Uq1Jjw0Vw8rDCdbwYvqMQ2+pAFAswPuchZgCugHEYCYHLqxUyYBdEtfsSD+fTnAv4l1SDYQqmLd3utc8oW0R3r+okKX9OunsW45Gh3ntgvkK6Wk/7pdlQJu0yCdejUYmreepsLng3eXczarDcoQDMJIDWBExf1+XA22djgSyvK3FP4mBiWVdMhxA5Bjapbqz3BA8VXhfSbTtHLxPxk/nGUY1dSmzCV4Cy186Q5yxddLwNeiPcnW8tbjdQ1Z9cqC1J/zjKAb3ru3vkXV3eSmcf3Zu+Yc0ChhJ35cbMvQS09I2A81NcA6ePm2YE2kL924Epwjz+GwsThscYyweFIZchFcqoJ8uG2r9AXPldgUo/Oa4WOCtptefjSxfwPj/Gugd0J+YNcDMEb/HO+x0kqWTjfMbXuL8aZW93tk5aDMgI9PT2S4uwYuuS3PECZvC2Tu1KCNE6RajKpN+dcBOQZuKVWHUCs4pljqyb5QoxVL0fxH5rGigGsKtAXojTr9u5jHpXcsMG0ipba7M1tpPFJfNng07LrNnHBFfHOp11PLourZx5TM09LbYPr3HnMsklo5z0uDobn+/pg2AoH/ijRtmqN1cwdg+ooosWV8l2D241WpvFYsMbT1bW9ovPB2DN/g7AlenNALyCBA3gGCrQH1d8tphidtg5sTpOCtQllF80xzlLeV/tF8ZTmMhIvwnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(38100700002)(38350700002)(7416002)(5660300002)(2616005)(52116002)(83380400001)(44832011)(66946007)(66556008)(4326008)(6512007)(6486002)(2906002)(8936002)(6506007)(66476007)(6666004)(8676002)(86362001)(6916009)(54906003)(186003)(36756003)(26005)(1076003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fCzlKeFtCvGKvHBYlekWv+LfSSGkuXyEZwVE9CUpznxv/yb4WUHsDORecjJT?=
 =?us-ascii?Q?98sUFjW25dZ4VOMNXtHKJrm6KXszTvDpBGPCtzqGve1DmXKMXk5+ZQTcrFZ7?=
 =?us-ascii?Q?QJUuteHxXBgS36TdbVBMa0Q15vTHqWftVLmE6xoj1koVnGfOFr1ejHpGY/cr?=
 =?us-ascii?Q?6CuroEtSmlBsbpnfBqyURU3j+uFvOSC/OlsPxdCQSnOnd5uv9aMOiwgxgW3w?=
 =?us-ascii?Q?/t3V6P9F3wkijoRAnS9skfwuUEdSraT4NjbSOpM0BqSkI0Eop5ic59OHx1oj?=
 =?us-ascii?Q?lGdP/R35yJrxm9l8emO8eaVAXTfW4hSn3kGbuwA9pyjr8lVZMhf56BY0kqqu?=
 =?us-ascii?Q?Rqk1asUUimoYaconABDOPZquSyfO1vfrUwqqc+bn5q+89tpbtiIXvr8a3uxB?=
 =?us-ascii?Q?aNQjTtmQr9UoaArV3h+WRZfoGrHGTgtmGxyNBIaWrNIzMe9/wAfnNyU//MBx?=
 =?us-ascii?Q?EZlyl6ZajPif9EpRsSoDkiP2CsXim2gED8WAqfbqBq+w0deS07xl31QACGr3?=
 =?us-ascii?Q?JlXQ3mtGk/oyqULyoihO5iJqIle1eHzJHEiqU30rcuyqcvBARxwJ+lKPGVUn?=
 =?us-ascii?Q?lHplHciYICd7RsEq1fHH2HaP8rhr/KvuU/eAwhUJpCJ40fnfkXGeCycyndN6?=
 =?us-ascii?Q?Qrykcpf2eON5BmZvHhwjiLPOsn+UXOFfXDzaDrw4Fn7FPk8oLg0FrGPoCO0q?=
 =?us-ascii?Q?oghJzgNGOXuwoLyMA+2Bz7sKnJZRKNR2PA2MF+z7U4k3Gx5AQ17mSUmeCUoA?=
 =?us-ascii?Q?/AVs3+ZC6le+7kTmQH84JkI/TurVovljdkzbLNeNfh58LMo7fmBPiVfF3ZCe?=
 =?us-ascii?Q?vWGq11nKhnMlgT71mJ4aIGnrvEu0ZMLTrIrvH9WvUlP67seVomfVgOrSl5Bw?=
 =?us-ascii?Q?Cd/mT0ojKp0ePuhoCdPQgVN+LduxL0TIbZD7PpyS9lzozk8f2fbJGkrn2ZDs?=
 =?us-ascii?Q?ZSYCmDRvDoH7jRc2cMTIpOSvA4CvtwFUYdsfpojzAlmFi2//b23yTrYHTvbg?=
 =?us-ascii?Q?rQrQjRvmml/wmntg9YC826r17Kj7BgzxUTjrSvOA1m4iuUjm6yPTQJu6/RXJ?=
 =?us-ascii?Q?RTFc8Y8l3A2etbywTkWGp5HKarX04zivcp0OIFnMgrGOOF2LZqgL6bRdh4z4?=
 =?us-ascii?Q?CXMLXRSzuV72Xg8cux5ypsrif8X6R9HMmiFlJarsfpFtZbQNlPLURyGftsJy?=
 =?us-ascii?Q?sTA4nsVvYzxUBxOAWUy1eXnOpWDB7QRk4+1p8P8LFM6pyiac7680wH9vouOS?=
 =?us-ascii?Q?zNfDPu3+A6XUyVMrEBPLUzvkBxLWz2DqUqDcVjTcGzy5foS3RWF/KqB7fZAw?=
 =?us-ascii?Q?hWVCAu86JdfaS+o2U1N79pNXK+oZ7i+pToQ70GkjJwTgNBCsyScNjVBrgT/B?=
 =?us-ascii?Q?PXgUITrsRtXfXf7yPKXpbTUMtM0TKibY8oIJlqQwAR4ZEUxjV/hFtBgo1HhF?=
 =?us-ascii?Q?qHYNjcwq7O4CSKGxK21kICTnkPHwoeqA1abR3wHqUdM5TgApn1RqNGJtgqVt?=
 =?us-ascii?Q?NTZhU2khUzTAnIZSYzp4t3g2GDh2TVrZAX4ym3buTWyLbnfN2wi/ozOloDYB?=
 =?us-ascii?Q?oH03gbtta4n7fP/NZNwa0zICi7tZRU8iHdjHSP9ENoJ+sFJD7DC2bJkd1GvZ?=
 =?us-ascii?Q?my9JfizA84ipQBL9LYGPD7JQE1pPI1sZQyMGAioOByHajuZ6tmOqoW6+QXAh?=
 =?us-ascii?Q?99pvr+EXToTxBOAnPKjFqCtVZINJIn7yF1GfZbyvmNw8SCtaUc1ZKLiTJYPH?=
 =?us-ascii?Q?vmA3aXoVNZ2NptHQH4XwlHf4tBw6HLA=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac71a5fc-774b-4f5c-707b-08da24490181
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 10:15:20.5319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EeqPd1KvmV4LdNqfeT0UVRhRV8t+ZWYsG89qOQaNSKj8lK+OTgI5oDD1nF273LRAGSwuG1ZrxMgBEK7cuORb6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6836
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By default, DSA switch ports inherit their MAC address from the DSA
master.

This works well for practical situations, but some selftests like
bridge_vlan_unaware.sh loop back 2 standalone DSA ports with 2 bridged
DSA ports, and require the bridge to forward packets between the
standalone ports.

Due to the bridge seeing that the MAC DA it needs to forward is present
as a local FDB entry (it coincides with the MAC address of the bridge
ports), the test packets are not forwarded, but terminated locally on
br0. In turn, this makes the ping and ping6 tests fail.

Address this by introducing an option to have stable MAC addresses.
When mac_addr_prepare is called, the current addresses of the netifs are
saved and replaced with 00:01:02:03:04:${netif number}. Then when
mac_addr_restore is called at the end of the test, the original MAC
addresses are restored. This ensures that the MAC addresses are unique,
which makes the test pass even for DSA ports.

The usage model is for the behavior to be opt-in via STABLE_MAC_ADDRS,
which DSA should set to true, all others behave as before. By hooking
the calls to mac_addr_prepare and mac_addr_restore within the forwarding
lib itself, we do not need to patch each individual selftest, the only
requirement is that pre_cleanup is called.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 tools/testing/selftests/net/forwarding/lib.sh | 36 +++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 664b9ecaf228..e3b3cdef3170 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -27,6 +27,7 @@ INTERFACE_TIMEOUT=${INTERFACE_TIMEOUT:=600}
 LOW_AGEING_TIME=${LOW_AGEING_TIME:=1000}
 REQUIRE_JQ=${REQUIRE_JQ:=yes}
 REQUIRE_MZ=${REQUIRE_MZ:=yes}
+STABLE_MAC_ADDRS=${STABLE_MAC_ADDRS:=no}
 
 relative_path="${BASH_SOURCE%/*}"
 if [[ "$relative_path" == "${BASH_SOURCE}" ]]; then
@@ -214,10 +215,41 @@ create_netif()
 	esac
 }
 
+declare -A MAC_ADDR_ORIG
+mac_addr_prepare()
+{
+	local new_addr=
+	local dev=
+
+	for ((i = 1; i <= NUM_NETIFS; ++i)); do
+		dev=${NETIFS[p$i]}
+		new_addr=$(printf "00:01:02:03:04:%02x" $i)
+
+		MAC_ADDR_ORIG["$dev"]=$(ip -j link show dev $dev | jq -e '.[].address')
+		# Strip quotes
+		MAC_ADDR_ORIG["$dev"]=${MAC_ADDR_ORIG["$dev"]//\"/}
+		ip link set dev $dev address $new_addr
+	done
+}
+
+mac_addr_restore()
+{
+	local dev=
+
+	for ((i = 1; i <= NUM_NETIFS; ++i)); do
+		dev=${NETIFS[p$i]}
+		ip link set dev $dev address ${MAC_ADDR_ORIG["$dev"]}
+	done
+}
+
 if [[ "$NETIF_CREATE" = "yes" ]]; then
 	create_netif
 fi
 
+if [[ "$STABLE_MAC_ADDRS" = "yes" ]]; then
+	mac_addr_prepare
+fi
+
 for ((i = 1; i <= NUM_NETIFS; ++i)); do
 	ip link show dev ${NETIFS[p$i]} &> /dev/null
 	if [[ $? -ne 0 ]]; then
@@ -503,6 +535,10 @@ pre_cleanup()
 		echo "Pausing before cleanup, hit any key to continue"
 		read
 	fi
+
+	if [[ "$STABLE_MAC_ADDRS" = "yes" ]]; then
+		mac_addr_restore
+	fi
 }
 
 vrf_prepare()
-- 
2.25.1

