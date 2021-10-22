Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9888437CBE
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 20:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbhJVSrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 14:47:01 -0400
Received: from mail-vi1eur05on2058.outbound.protection.outlook.com ([40.107.21.58]:9427
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232448AbhJVSrA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 14:47:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DMUacMc1PsTZxZsbxOBhc8jgRe73qF5PtHEBWrEkOpiTt+B3e/HbEoSLQH82WP98mMT6KeuWJQAzsBLjDnCqOBLQ4oAZjsH8kZWX8ToKNo16VOi92si8IRjkh4OBW9VFvcrOKIuIXueIHszqVuO74U+7wNIOn1isRIi3Tbec7f9uDXuBN0fscGm+x5SIIZ3q9L45T0EJY2rjpDMX/0tVZzkrPLqkJ8/fkicmdovbuGCAldzA4Ovjo6DPhIphzIEPikjU8Jad8dWpG6nj6IfsxUJnIaCKIvIrgLFCMGgve0J3iMxPqmmQouCAMtQ14i0UjH51Su28x7+GH+BwXZKqZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ISpI6kJNdgoPoWNvP0jNmdTdcOdcEiaNp1OdXShxUpk=;
 b=ZR9yRpgC5AEsbBUTwYr2VVYfkoFzYLVfvrVwR/XNCw27aQBQtrVmRR0rU9rQzbac1oil3zblj7w9ayVEW15ibZ9OyNUXY0EnbXPkKKf79ncG/fnnsJqqGdjlh9Qq+ZyhODb6foYr3FtDqQRh1Y49YTIXlYvLH0oiFact9ks2Ck55itdqSCA2HeP9ltOKVUNZeh7n4B7yjF0c0G4HyCUjw4QWUSKMFxcaI/t6CZPi8h/sNhfwDe80Uz6Y5Y8gd60kQv5+yWzhzugVwAvJTbDP4lIhdxke9O9wqSd+MWVrMbeItbMCM+yWE+hd6l1WIDZ8qfnqGOowe5dNySneAsRlaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ISpI6kJNdgoPoWNvP0jNmdTdcOdcEiaNp1OdXShxUpk=;
 b=OxZwqgzgW/eBvDAGXCNrU1wZYp9ZNGD9gQVCfDJtBMKT505+QSz3wOK6BhmUBH7SKEx5ooPaWZKhyGLCZOoJrCzL5fXfdywrxU8hGa0gN7+vayapXKf09NB1UQ5jAyI9q9/0Ysyk65RVXJewBmK5lNM1PgatuZfemU8K4upSuHI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2862.eurprd04.prod.outlook.com (2603:10a6:800:b6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 18:44:38 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 18:44:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        John Crispin <john@phrozen.org>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH v4 net-next 9/9] selftests: net: dsa: add a stress test for unlocked FDB operations
Date:   Fri, 22 Oct 2021 21:43:12 +0300
Message-Id: <20211022184312.2454746-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022184312.2454746-1-vladimir.oltean@nxp.com>
References: <20211022184312.2454746-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0103.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::44) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR01CA0103.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Fri, 22 Oct 2021 18:44:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0aebb1a4-b792-448c-20ba-08d9958c000d
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2862:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2862F0D0F001FD210E885E55E0809@VI1PR0402MB2862.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4+9cWdAUXioboHBVfuufbYnmbHZLxzRjF1V1Gb7I3617UVt52FuaQUYG4Z4E439iPbEGP8gwnEF6uq8Y9LM5GYVaQQqdYi70c4u88jn2sRTiY5gW1lj4/txP1igVC+y7gi4iIllbl7yHMh8NJ0pUvYES5EWa5QoEk63p6se+mjfwhVGgnBm+LcFYIlRGLEnFfo84KAJAWiIoxdluCnbtdjI4UqT1SKuHkVzJX0IGGeHn5T9AB34fxPa40qcNbnEJVB2S9RT6jsq9gbz13ALX59vFscIDqwAVd7i9N1CjT188HXPMZH6lG2Rb0KECDGji7Ydi/q4kuJ/rcZmkrj49LuooR4g+5vRzbEbZyFzLI24gvhindm82BXxg3mAaWU4dZY25XUmH0UFjdwcS/RBwhfBAcotXjJvc2lZgC7I6z7t2lUtiyVwl7lSvnS1OD5xceIPoFeztw71AKlv+9aZZbEi8Uct73bIL3M9wocqF6Lz9f+tqrwIFMcxeeoXV0O5UvsTu1VmEJyeqDedO/Sc6ou4260XaRGfX+y3sY2FKxg34j6B+I/+JoAIusQdJG2DoxTfL7AeTDkL1JHDqA0Jk/kMK8/uH7KxKPsOuL/ANvcetV8rkmjMWs9t5WrX9rngGAJOLtCF6+1CHjA+z5QdPBpybJ/uniD+3CpcJsaQof4dEUM86oYqUFRNK/6RrWEnbr9Oj3cmt6yP03tG/HfBzDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38350700002)(2906002)(38100700002)(83380400001)(52116002)(508600001)(1076003)(36756003)(6512007)(6666004)(54906003)(6916009)(86362001)(6486002)(316002)(956004)(66946007)(2616005)(44832011)(4326008)(186003)(7416002)(6506007)(8676002)(8936002)(26005)(5660300002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DQDkUlRoARq9KGle59iv8vQZuLyOD63bU9LNVgZZ81VnjJGiWTEg6V35sOnW?=
 =?us-ascii?Q?uCQr2asmXRyb+a0RhFbiMfJ0y+LYNdXvTy1isMNiR7b6mryZaPo8FRbNHW0l?=
 =?us-ascii?Q?6zNzWeN/keVRkLSU6dyeQ1MPvREbF4X0yqTYA4b3TxF+3wPQlKBXiRa9jr3v?=
 =?us-ascii?Q?ysOqtpy3kB4FIU/ZT7Vh13HyjqzyZkz3YFmc1lVm3J7E0una2ft6aw7maHdl?=
 =?us-ascii?Q?EZ0AzjRNWIlqGr65edJGaR5WMoEHEppW3u4sFMhQgrAehPP285S0pEkquL7g?=
 =?us-ascii?Q?mcaTOTp7No96zSAopt2F8V1LmDuFsTalPAtfhqiuwXP2FpI7oH25Ro1dnSGx?=
 =?us-ascii?Q?IFuFZSkfCUHsulxGQD3nl7oP8cz7EuK1YAjNroCDCMLjz3b41U2ltqgedEvh?=
 =?us-ascii?Q?mRq98iJPBxAr/598TEiQm5jzXov+WKeMCTHSxJZT8VfYxTbk/G7gEdHCvErA?=
 =?us-ascii?Q?5ysGOfBIHT+QK4LjTAISH0BWjwQujb0dU42fcqUjpG2jmE6gce2fJmdsa8wr?=
 =?us-ascii?Q?Id5kSFhVaghO/5G03wD0gnUbZxIvdhit4DAUz7hzJeidRNCBLXJJ13dsDBz7?=
 =?us-ascii?Q?urkBXAs4txpxJk3VdqzY3NWNPJiEID0caNnav4JFKA6Ma0cexN4jGa85zSQy?=
 =?us-ascii?Q?ahrs/KGyLz11smFkosE3v5fPoIxHehLUxGa45ode/fyWSJP/0TRuSCDxtd69?=
 =?us-ascii?Q?9oVte3AhZGkilThqhd1CPTBwzXMWGc3zwusPwZkNAQySDjkTVQtPx5luv7x5?=
 =?us-ascii?Q?gtGWIi22a57edhBOV57TTQrERAZZjoMMHevOpf2uS52HF03+RJv5TFMdf57j?=
 =?us-ascii?Q?eNembF03rv/Tt9Veda5I0DaW1sx04H6/ok+te+N3I/SAC30Jw0Bi8oIwMhta?=
 =?us-ascii?Q?ahAE2alMlXGVIUNlirP0qXFMGMZT2Wxt0TuGHNsTjjkDAjC7xhgyE9C5uVmx?=
 =?us-ascii?Q?13isXeKjSREVhjq3oiU6VqhV8G75lnh90YyYQ22WQyTWNHxkMogY1+Bczfam?=
 =?us-ascii?Q?PtZGpYx8pEl3TCX1fQQDHB1fn/k9/Tp0wQ2Wkh3fEvOGPJcKuPXwk65/j9U5?=
 =?us-ascii?Q?i/UVvHqbeFnPFa5SQ/CYPjhfEcJrCiddpA1EiM8PZqQcCX3tDljXHeW2g0AR?=
 =?us-ascii?Q?6eWxRFvTvxJcd1BFQyWObbh4noD5V4Hg0lENhmYHPwTCaaVzyqMhOX07JxIf?=
 =?us-ascii?Q?Jp0Wev+axj0mK8YX+PBfDfs7sn5BuzWE3iTs5/PU/wdJen+IJFmL/I94Ij8r?=
 =?us-ascii?Q?6/pXemuI2mXonKc3x5S/aurzEyWXOdDZOX8+9t4j2xel15b53QAsnuspjrHA?=
 =?us-ascii?Q?D+ZMaidXke7aozZMjVofdYRcE/LCl0RtobIHU9VLtguJMTANJikkBSIaoUcu?=
 =?us-ascii?Q?hF3JuzPsbIHXxslEfMSUxi9g/Sk0//C7mZgKccklk/ZqBxRwVCkqjio4gJHG?=
 =?us-ascii?Q?3nqLtw7d4uSZUgKqNdCHPAsTHdAvM9Rh?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0aebb1a4-b792-448c-20ba-08d9958c000d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 18:44:38.0585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vladimir.oltean@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2862
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This test is a bit strange in that it is perhaps more manual than
others: it does not transmit a clear OK/FAIL verdict, because user space
does not have synchronous feedback from the kernel. If a hardware access
fails, it is in deferred context.

Nonetheless, on sja1105 I have used it successfully to find and solve a
concurrency issue, so it can be used as a starting point for other
driver maintainers too.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v3->v4:
- use "wait $pid" instead of "killall bash" :-/
- reorder "ip link del br0" and waiting for the background task on cleanup

 MAINTAINERS                                   |  1 +
 .../drivers/net/dsa/test_bridge_fdb_stress.sh | 47 +++++++++++++++++++
 2 files changed, 48 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/dsa/test_bridge_fdb_stress.sh

diff --git a/MAINTAINERS b/MAINTAINERS
index c5aa142d4b3a..975086c5345d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13056,6 +13056,7 @@ F:	include/linux/dsa/
 F:	include/linux/platform_data/dsa.h
 F:	include/net/dsa.h
 F:	net/dsa/
+F:	tools/testing/selftests/drivers/net/dsa/
 
 NETWORKING [GENERAL]
 M:	"David S. Miller" <davem@davemloft.net>
diff --git a/tools/testing/selftests/drivers/net/dsa/test_bridge_fdb_stress.sh b/tools/testing/selftests/drivers/net/dsa/test_bridge_fdb_stress.sh
new file mode 100755
index 000000000000..dca8be6092b9
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/dsa/test_bridge_fdb_stress.sh
@@ -0,0 +1,47 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Bridge FDB entries can be offloaded to DSA switches without holding the
+# rtnl_mutex. Traditionally this mutex has conferred drivers implicit
+# serialization, which means their code paths are not well tested in the
+# presence of concurrency.
+# This test creates a background task that stresses the FDB by adding and
+# deleting an entry many times in a row without the rtnl_mutex held.
+# It then tests the driver resistance to concurrency by calling .ndo_fdb_dump
+# (with rtnl_mutex held) from a foreground task.
+# Since either the FDB dump or the additions/removals can fail, but the
+# additions and removals are performed in deferred as opposed to process
+# context, we cannot simply check for user space error codes.
+
+WAIT_TIME=1
+NUM_NETIFS=1
+REQUIRE_JQ="no"
+REQUIRE_MZ="no"
+NETIF_CREATE="no"
+lib_dir=$(dirname $0)/../../../net/forwarding
+source $lib_dir/lib.sh
+
+cleanup() {
+	echo "Cleaning up"
+	kill $pid && wait $pid &> /dev/null
+	ip link del br0
+	echo "Please check kernel log for errors"
+}
+trap 'cleanup' EXIT
+
+eth=${NETIFS[p1]}
+
+ip link del br0 2&>1 >/dev/null || :
+ip link add br0 type bridge && ip link set $eth master br0
+
+(while :; do
+	bridge fdb add 00:01:02:03:04:05 dev $eth master static
+	bridge fdb del 00:01:02:03:04:05 dev $eth master static
+done) &
+pid=$!
+
+for i in $(seq 1 50); do
+	bridge fdb show > /dev/null
+	sleep 3
+	echo "$((${i} * 2))% complete..."
+done
-- 
2.25.1

