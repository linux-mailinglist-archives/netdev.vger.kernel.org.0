Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877AC438AF1
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 19:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbhJXRVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 13:21:54 -0400
Received: from mail-am6eur05on2071.outbound.protection.outlook.com ([40.107.22.71]:35552
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231851AbhJXRVd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 13:21:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YcV4cvmlqbUqQ5yxAItCdacDiJPRKf9OEKnl4cHfQ1pvWTcas8QDHvOyJVFKgytg5J3QoSzX712KEiLj7fgmyRZbW91usUFpKzFrNdgUFhOeWDSsi5WHSXvbQn9z4crBp+uGBFgBl+Ba64LVD3iWN3WD2LzHCo/4DMaiaHihc/v/yqHJNu1XauVR8X7MFzezxUxEptRMyg7xc2jqD1hy4ZCpqcK3L7IahjIBXCdjHo6m5CjGHp9Jadmk/YIpgCllPIdTPmy8vJSZVCGdwOzKCN8MJaA+uJ92OYoQlPb4vK8ftGtrzneiaxd/rG/ZEz8lLfqtAgM86eBV/rguRZk9KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/mc+KQ3MF36WZzSjX7TRpMA6EqZGroNvko7gBXDlt/Q=;
 b=cVgDuf+y6QnVwtVfS+QvCRyBresXQSdJ8mHcpsaHcnQQb1fqlb8wpG+eq+4WDvSNGNJn0+IEf/4K94h5IgRwH/2qEmVbvtiOd4dpISqlH11qkB5dd+2r9fRwY6GASwmEZ4M6OUKsfG63urTazTYza02h3ujVUNAaspg87p2MocFuAYLi5CqC9eLFtfBpT56FCEf/k9Kc1SfaBn7J72tCnsgUfc5xWzskd+WzPLSnR9wTUrQXA4gKtedncbgs+mOtrab+t9lV2cNnkrokUN2Sd70lh9j/EeMB2cXSRji5gu/wdpbudQ00yTbvRVW4+LZcsbw6T+Hr/Pbyw4Gz0p6WPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/mc+KQ3MF36WZzSjX7TRpMA6EqZGroNvko7gBXDlt/Q=;
 b=eP0Vuw9L9x7jPDVxM00j6V7n+jRh2EgQTNW6ui46IzrfZczuhV9Ys2KeRphAtnLxZkcqodGky4fxzJottMjH3f96rNLJWhSMgYj6i01GU/3WfVpyfd6AF/Dy575UapwG+tijukihSnvEGrWu5HbgPLtaRkvby5ZYVhvqmAtuZvg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2510.eurprd04.prod.outlook.com (2603:10a6:800:54::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Sun, 24 Oct
 2021 17:18:44 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Sun, 24 Oct 2021
 17:18:44 +0000
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
Subject: [PATCH v5 net-next 10/10] selftests: net: dsa: add a stress test for unlocked FDB operations
Date:   Sun, 24 Oct 2021 20:17:57 +0300
Message-Id: <20211024171757.3753288-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211024171757.3753288-1-vladimir.oltean@nxp.com>
References: <20211024171757.3753288-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P193CA0123.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:85::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM6P193CA0123.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:85::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Sun, 24 Oct 2021 17:18:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6abb1788-de7a-4ca1-48e7-08d997125500
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2510:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB25103AD8C6995D85F71F6148E0829@VI1PR0401MB2510.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f2F9y0J1+XLBV5QRZPGgUN5aWT0DyVCGZEBSzY8ozY02qAGKTyHg0GR7krzNBkA52szw7x9ZkWbGdGGbklx4wmA5cKktzo52HRXAMirCLOq/O65L12dcDNBa1ea1hLmQTXF7Hnu5UUzSUubs/81w0Rgy+pP30fWv6A3GzCdU5Ie+6hN/43ddQvllqygktqoSwgmTRGsT2IOLCwPDLZ81THN0PvqcunasUOIlI26Vkm60IPptzifMWDGUEUyEjHKWRbZb0qJwfAmZdHBVffdqiRyEkaI0D4XblWMUmmXXp7upwwkcNgct862CRDrXov9bt3yNWUB41YQDfBFV38Hd/8a4z30MQwjAAdIwRqRWIp1j4eatcGX6wyAXBqx7R889M90gM+paLvkXb98iSthzdmx+Y6oAXmfobU9mxkOROESa6WeOukz0bHL0P7WQiKNRKRiecrlflx2u7q/EpT9vfsFJ/jsPKi9VGOmO/GJby2HUI9oi5cROd1ounn4P1DaD421klxXrFcmhgzxE3FUAZg1FvXV9PUsK/ehCZjx9EVBcQXn/mHjwbGEfGcUctlYqaPywMc6XTVD63j+o7f23oBiYHolUohO+Fr+S07WtSndCtXqpPwX2mXa20Jakp4VgtM2d+YMr+34WOZw08rudJigwgWisYgrPgRAkJ32k5rK4JuYtzh/2poFxKwpH9ClmEjIv+bPdrH9IpUc1BURFWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(66946007)(66476007)(8936002)(7416002)(316002)(54906003)(4326008)(956004)(1076003)(66556008)(5660300002)(6512007)(6666004)(6506007)(83380400001)(44832011)(38350700002)(38100700002)(8676002)(6486002)(6916009)(86362001)(508600001)(52116002)(186003)(26005)(2906002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jNyabPm10jTPe//NBn5lCHOvkYODf//r65tv8L0unE+UWSwvH/HVs4yF2oAm?=
 =?us-ascii?Q?qiPzQnBUg1c0k7fdGUzSU+RkyX3YNHBQOMHyXeRkCxzbQCM80AFULOt409iH?=
 =?us-ascii?Q?K3Gsor1x2wMbkXyUujO/gFlQhP0bgcL105SRvJXAcUWTZTS2DVD6e8uJ2+dl?=
 =?us-ascii?Q?beefIBAqLPtaP8vOY1xm+lnneTTWyTUygb/mE2ZtnW4brGzYSJYFx5yAmbvG?=
 =?us-ascii?Q?rA3TItNiZ1+/fEZJFZ397mLWKNA0dqsd0Dim8vEoVuezOG5QGof3vB2goOav?=
 =?us-ascii?Q?48dTsOTnmiP07Lu8tauWxPgrULwln07pH3oztnkKhQsNrTDOuRE9YCa/77X6?=
 =?us-ascii?Q?0R0xtHf93c1JpiEgUXGV1aQ13FOFbMgewsDeUKrWZ3Qx6PmVZJVVcQXZ4f5/?=
 =?us-ascii?Q?SqYkpYauM4fdUH0dkVuOOTUCRHJuf7OHKFrjYAfLEly8Ch+1y/FMpbku8IPi?=
 =?us-ascii?Q?RdocgkJAFQjjg0hGimOszMexvwg9OBI95/cMvr9e0gTrB8FIg9dcZmoIPsAo?=
 =?us-ascii?Q?zaAR9F3b0QGNozFGaYiofI4p8N7kQG7YBicp43Vv0Ts+4uePRMj51hRHFFb5?=
 =?us-ascii?Q?NSmYCns8Y7shUCHn9QNX5yWLvaDmJ54xsxX0uL3bhOzCsdImn3rbl9gy0dH2?=
 =?us-ascii?Q?6jwQP7DFm4UaPP10Kv4T9WCA9fxCJVlA5a6Jy71DqSjBAhL8VeoP2JpMY2pX?=
 =?us-ascii?Q?JjzZAvZgnbwaiMVTEpDPQxm+h88KHbdFG2D5SK9CLQJrt0uQaQkHzNJvIpEj?=
 =?us-ascii?Q?VDVdpKzGMbeP9kwT2MS0RmIWR/Z79BC3or//W61qo5gV45KuYbRPYtEAry7s?=
 =?us-ascii?Q?xDK81PMNSpzwE4Ipi6rFGAGm4/MHk8YwJz536Hc/0qFVz73WRSky4ft5dJif?=
 =?us-ascii?Q?oFP03KULnHJAH0Nd64ZTVWNSPqNEykPeip/UmlyONGW/k/PpAWUGh1QZHGSI?=
 =?us-ascii?Q?1r+37br7HnRyreOt/5R5Pm+6RFPEBQDNSZc70WtQZizmV+bSb3YBQ1BRRrkC?=
 =?us-ascii?Q?gvolt1sjSWWk2B3y6L6S6wkJQB/1R1TA2A+wzUp3w1NkIOf4T3epwcjaJfYA?=
 =?us-ascii?Q?MEnydpPqqOzAjKxmdWpLoCzS/GTEfErWpMf7PqgOOxALX1EhUTIOjPfeonb1?=
 =?us-ascii?Q?SI8TcIuajxwtwDSMWWTF/0FicT2cTcIghDhiHprpu21d0bhE6t3cJ2wgM6RF?=
 =?us-ascii?Q?Yx2dDBUaYfwQhpcasvn+gEhuB+lrOWBBFtpJsjhPwvQbvWcE5bf62+0XdEHg?=
 =?us-ascii?Q?vV3kIZsGiWaevrh92tJGjvmZ7eDodDFjJoq/E4HcpHkyWawfeMiduHKQPCEC?=
 =?us-ascii?Q?tlZMMWaLSrIZxsiG26kRutPT7m/ruIasHLmXNu/L48PJa6ghzY348o48CuTN?=
 =?us-ascii?Q?+c7Pj2uNaqoRNUfFTi8jRUy9w0s/Wzj5wmEX4XQbq1cExEOm0duQqSLm4Ndb?=
 =?us-ascii?Q?wd7NoVmLLEazTvfIGg7lQuqVaPX+eq2HSfjyD8TdA6it54AOjyN53QRhA5E+?=
 =?us-ascii?Q?LMDEF4lUsY9s5utPZIrOUbRND7kUvTgH6ie01WK6Rzbyr8OlrPNtRWTFaALm?=
 =?us-ascii?Q?QJK46KGh3FjKG0dxulckCmVTdmRQRApR1rNeVfOz8HrQsOM+tkCEvXc27nJl?=
 =?us-ascii?Q?/zCiZRgU4LVOboox100837Q=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6abb1788-de7a-4ca1-48e7-08d997125500
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2021 17:18:44.2372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XzxB8sJSppid/lNCh1zz13ijWMvJKuG3St6mLXkODwiQBzThTCZELGMT7xW0u7+hKMsOhYf75x0xboslNS5qjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2510
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
v4->v5: none

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

