Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3BD94378EF
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 16:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbhJVOUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 10:20:42 -0400
Received: from mail-eopbgr60040.outbound.protection.outlook.com ([40.107.6.40]:37344
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233026AbhJVOU3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 10:20:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T4ezYwm6l96L1FJYKaWnAhOiH/YbXxW7knVqHF/+xhx/RkYzoV72KV0ckZWXj/NvXZQkUitBrhsognc8SwtsUzu5R+Emncex6LuawS55DTFcN7F2mu7VL/kbRuR+xghONKs9xNPYeIk33WsNpH3+BRdNXKd8RJehjnXFrBOoOmGNtkGuk+QQQS1XhK0oGSORO5A2rK6RAEkwWeGv09ub5QpWGm9Y3ApYTQXqjRQVd25JsMWM/O84n6m0nytosQiRJsa1dRPsvqrmkCi3AAnoBPMf7HoVNG1sGFMEz4jx/6NVDkY2fptaRaF0WuIuKiM3IgX3mlS0AidL68akLHmAVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3PWTbqITJPkSQdgm2xTfieSUveBWc5U1KkmzMOQDlEA=;
 b=jshhYtUhRDbtyNKSuZOCpjmSGi4SweZ7tXFfxEHmjQIFs3qT0nXELxs3rNlYeKY5Io9vGHez05Iraw9xhVyEXfBOOHgJupn+il/yMGLFnGewpivpylBumgYILOU1mMO4wW3gNipxjZZYqNMLgyMKuHkt/dlrZ4D39GHod7Tk36ZkY3c/H1+5o2Zoii9ctdg1xJBPVguYgMsQglpGuKFZcUsCTuORPeW3gV9yWiryOQEDM/aJwOCkf/9dq9SYMdIRgW/nbUnB/vCh9tiCootccZefDRi7k/68iyhncHAP/jxUJbrAIm0mqsrkrwbO81oCh+3RuoMDMAHKHNYmE7xJng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3PWTbqITJPkSQdgm2xTfieSUveBWc5U1KkmzMOQDlEA=;
 b=dzyD/84aVM5uOtzAV0mcpcq7gEQS/o484FyU8hJKPr/SGSe1uIBk3RtHmamHAAunGwjNue2hl0rDSmdQYawnPYlDMQywl8heaYxcP2VIY+YIkwEGK9AAVjbwD44NudhCiLVHb3Z0knmyPmgbO2RIpkddhk6fmTF/retuwSiRRCY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3406.eurprd04.prod.outlook.com (2603:10a6:803:c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 14:18:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 14:18:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
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
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH v2 net-next 9/9] selftests: net: dsa: add a stress test for unlocked FDB operations
Date:   Fri, 22 Oct 2021 17:16:16 +0300
Message-Id: <20211022141616.2088304-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022141616.2088304-1-vladimir.oltean@nxp.com>
References: <20211022141616.2088304-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0159.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR02CA0159.eurprd02.prod.outlook.com (2603:10a6:20b:28d::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Fri, 22 Oct 2021 14:18:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e36b1317-00c8-4e21-0955-08d99566c29c
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3406:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB34064BB6F80BCEA38B685CCCE0809@VI1PR0402MB3406.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UU7ZLxPfMKYn/Gecv+XMzTN0XBW2p1wLm3e0VmvfjK8lA/8UKAQ8hKsQv6V/zgmbuJjnr2U0kx24SiW6bMVVHFRp8pVFxzdaEogRdWufWeiW7BTgRzwxYrSvplzM3o0swRafbGsTDPhs6AWBRWvwDpXjsFe8Z1hFRvh/GB6p7Bl8TrnDlNUXXb0C66AEnTbxpagweuyh8UoPCgUszAhpSyMsUHdNumihlWKQE98EK11SF44s8d7b388uC+nMoHHsfOWX3RZVMOOCN9Qq+YIS7XqfouWl1P+PhVV/zpCVPWKY+kk28sY1bEghglLMx/9tXmaSjU9veXN9itHHzM83QqmoACw1icD4LK9Nj8v9CPV1AJahHixnZyb1WublIoUL731W2PROgyJXyYWIhocPlWeD+IZH0Q67+EvSUBcR8TIdLhLYnVn3xGYSXXCBoQxm5iN1c/GRTSHWzkcGFW6UAgyuN4Rv9Jcns/36fogwgOquiA+Na2/Fr1RErNBkpd9MQBxUHiffJiJQk7KZf/N1+RMlrquVnKmW0ZKQ36lvz+OlVMye93fpa9OXuLE9JWPzDIMEowx/6p3lgidT/zXGJKJFhwHxWPHxabnn37npaYAnOXMxFgUGkPhkTLy6g4sS//mRG4fNWYbd5Bg+zwFrQ1qQVI2fpN+x14tXQn3v8Dt86Z4zGxjpW5rZubQZnuHxUbLoLJG/ZUty/LcQUxkzkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(8936002)(44832011)(38350700002)(6916009)(956004)(83380400001)(54906003)(66556008)(508600001)(66476007)(66946007)(6512007)(86362001)(4326008)(6486002)(52116002)(5660300002)(2616005)(316002)(6506007)(1076003)(8676002)(36756003)(2906002)(186003)(38100700002)(26005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bajAzMrbAlE7ykddJc80HlaFzHAOf3c8gk//sxc/+JlnZ9Jgj1N9NIZydidU?=
 =?us-ascii?Q?v2lVOJhGf+U480gttZGqofGMAmv0BEdCYtx/SXDoNMxiI/DxWcx0VW/0r5Hl?=
 =?us-ascii?Q?B+kWK5Z4WC2EbX65yu8PIiJ9bfZLlRjWqPtcu/X9fmhK3ZLpZEACNNt0HAmc?=
 =?us-ascii?Q?zfsB9wZY1VZTRRoixJWnJUl8G5pi2yraolrnYY6+9tbLwZnf4NZEq1NuxDJ3?=
 =?us-ascii?Q?LG7bBWnQ0y7u24yhXJMBk/ZPn7H8ixMTp0uMnh6ogq/fjKdP/YwJP/Y/KWix?=
 =?us-ascii?Q?gqS/DdsHykT0i/j7AXndr819eC06iuJKelbU+QiD4HmWnfRLSQC+9xuie2YI?=
 =?us-ascii?Q?J0F/pTV1bg1AUD6tQ+nWd+Q0q6nYuvM9LPu85LeBqEGYxXcZpONwMtebnnpV?=
 =?us-ascii?Q?h3Wz87VPm6SC5nYRC4wAKhJ2Wlh7JwMFK+5pDoCU110W6U/n83yqEYckWHax?=
 =?us-ascii?Q?unC+OK7P1Tb2DL1iDQoDylRiMTzvElt/15T0iamRRRz9PszhAGls9teTPMgc?=
 =?us-ascii?Q?zqXM50URdKoUXkmhRcJAXR48jih3nXabj4K+x+rGcdBkpZB35laEhT1JAh7+?=
 =?us-ascii?Q?sgCINPxCtmkpKyZ0g2HuZUR4ydgD1qQMk0X9UmPF+Ayn+S238jOQbEJ/gtxi?=
 =?us-ascii?Q?R3ncxWetKBsSdDdrmx5Vc427Q6gsrTAKIAWL+IF0brI/AeEXrZmo6A6qfulZ?=
 =?us-ascii?Q?dcr6MkGznmlmHq9R8Zg0fq826Csf2a1TGOmCq6XIGR8S9REQxgkd7K1Vb5Gg?=
 =?us-ascii?Q?nMBaLaEMbj2SqyBFIOAz90Ez4ebdiRvJUCBUSy9e/D8Ic6q1vUApvezcNBkC?=
 =?us-ascii?Q?VEcOmCNMa98y2O+/kjHXTE63nUvy0q5CXJfz2p4bR9ty0EOtCYw+2L5LE/RJ?=
 =?us-ascii?Q?FtU1tFD3rgqqeE6tMoPHMEk9+pRyzpZ3bX/90sc5Entmh+wZP1oiXi3gXWxE?=
 =?us-ascii?Q?JhzriPb5lxxI8g+NjvyTRr1x/5k4wqk/YpiNdIa06/nzSJ97iZvqO079ReGy?=
 =?us-ascii?Q?weeWBxWlRKUhHdYWyZA8yQmAWvyCX2cgC0fvNZRW5pj+84P8oxDyZvxHgkIT?=
 =?us-ascii?Q?QKwEYKMVBsoGfAT9f7kj581HGCOQRUziLAHXOqRWimtfc0T/hwklJCehoWd1?=
 =?us-ascii?Q?3cxxuP46o6K4ahBNQ/QHnM1E5t4ACSHQO8aCuy/ljlxv4En0/dm68vpuOBqk?=
 =?us-ascii?Q?6xA+pJWEDjLUB+5jmRX3nDuA9PZK9Wyv4NVWZbT6MAt43P96H7Xnaacc8E8S?=
 =?us-ascii?Q?S89mtKRjoFNT/OWzX+x9EBi91VY1LTssaNi0Cx2uo7TcZtO6R+nXalE7fjKH?=
 =?us-ascii?Q?WQTn13cuBO3sK5Ygqrarsn0tLBviGvUMfDD4SEEDB4AfFirDs+0Vx7+HUnhL?=
 =?us-ascii?Q?fIAj6R/knSDd0lngjIV/utpnqPC8pzmb2/dOO2DGpgC/Iu/TMNcrOJgs+MnT?=
 =?us-ascii?Q?0NAX19Eu/XAwgAxag70YWbmQ29GurJn0?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e36b1317-00c8-4e21-0955-08d99566c29c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 14:18:03.5193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vladimir.oltean@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3406
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
---
 MAINTAINERS                                   |  1 +
 .../drivers/net/dsa/test_bridge_fdb_stress.sh | 48 +++++++++++++++++++
 2 files changed, 49 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/dsa/test_bridge_fdb_stress.sh

diff --git a/MAINTAINERS b/MAINTAINERS
index 20ea3338404f..997bdbf615f4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13054,6 +13054,7 @@ F:	include/linux/dsa/
 F:	include/linux/platform_data/dsa.h
 F:	include/net/dsa.h
 F:	net/dsa/
+F:	tools/testing/selftests/drivers/net/dsa/
 
 NETWORKING [GENERAL]
 M:	"David S. Miller" <davem@davemloft.net>
diff --git a/tools/testing/selftests/drivers/net/dsa/test_bridge_fdb_stress.sh b/tools/testing/selftests/drivers/net/dsa/test_bridge_fdb_stress.sh
new file mode 100755
index 000000000000..cdb7f9ca2251
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/dsa/test_bridge_fdb_stress.sh
@@ -0,0 +1,48 @@
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
+	ip link del br0
+	kill $pid
+	killall bash
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

