Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE472437BF1
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233875AbhJVRcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:32:53 -0400
Received: from mail-eopbgr150044.outbound.protection.outlook.com ([40.107.15.44]:23297
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233742AbhJVRcr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 13:32:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UnSBimmOUsFqBiVCvd2nY2wgOB9g9mU+YttP3EtsoSphAYIXcjESMEg2IXrrBHQm6PN0gZKXa7SWkBvXlT8q5Wrvsk2E2H52XmrVkk73fiPOXi9PxcmjRXAYjXTuZCJq1c/vlEXF7RdtEqGrp9ah6T5o6qcxjxAAxojUtduPlXSjrMEZyeFOOgb3JOGso3b4OKNrT/kMrYOd5dlhytWVqhwCjk157LJwdOnFGlzhY1QGd22h7zXQIBJxcLCAH9JNhjdAa3Geokng/pyqkjivzoBr2ReQtJeB8BuO2ED0PPLVDOcWniiXl9ut9DJA4KoET1vJNZWCKHwK6GQ6Yh7vbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rLuIth79PIQF/9Op1hNy739uFecREjkd8CxOplQL+kM=;
 b=W67T0sAv6efSbntzr4uS39vyRbQpJ8/dT4SbH+bQB3tjCNXR+v0dCglXpEajZW/QGvsnJUaek4a4SQ9LEm/9ggNw/B/gNEIoc4OiATgUxvRmxmXepRxYTDoGl0fPiPeObX7JIeXlsIpscXXgtzMcYw1ZmCZymrSvPe8i0O+DW4tnQr2IKN91Zny60y6s5SbU+JByDqMO0BwW/7o1+aaKg9N9rdgmR7nFdc0igFuHiX43JXBVj8iRFVcbolwzj+KK2F2gMDe7XCG7+sdEg4vAT9A5R8KRGL7uwi9meZ4hMF5yLoQXjO311cusLcGzTgix4SZOeZ9rnd8DopXPKzbVQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rLuIth79PIQF/9Op1hNy739uFecREjkd8CxOplQL+kM=;
 b=c8T/7gTZOeCgY3/dRGvZ3ecEPXALA86GYg4lipx8h7DOoQVUh6nCMWri/wMMGCss2XLlZ7VywXi4h6ZfTsBCKIPyYueryeB+cD4ys9HQ2Ls7p9bOVjgAMudc5RvUKu5eJ11vbpuuLMSvqUr5BNCee4UFbMGmDQo8/F5yNuU/RxM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5504.eurprd04.prod.outlook.com (2603:10a6:803:d8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 17:30:24 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 17:30:24 +0000
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
Subject: [PATCH v3 net-next 9/9] selftests: net: dsa: add a stress test for unlocked FDB operations
Date:   Fri, 22 Oct 2021 20:27:28 +0300
Message-Id: <20211022172728.2379321-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022172728.2379321-1-vladimir.oltean@nxp.com>
References: <20211022172728.2379321-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0003.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR08CA0003.eurprd08.prod.outlook.com (2603:10a6:208:d2::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Fri, 22 Oct 2021 17:30:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64097d92-25ca-44b4-0882-08d99581a147
X-MS-TrafficTypeDiagnostic: VI1PR04MB5504:
X-Microsoft-Antispam-PRVS: <VI1PR04MB55046579D8D10B71BD6A87C7E0809@VI1PR04MB5504.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OPqIQZ4Vek6LRNUL3vaxDtkmcN4Ae4Rf4iYYT0Cowg7JFyaASEUdGZ+M836O3oAzKFAiV/xhw+tr+vdGaZnthqC1WVQcwBOaDBPuQAauqklQ9BYwbN06etfz9MRHH7ieBsJk/i/UYTHsbQIwDE8PIQwlwXseE+oshiqD33hZniWftg/TDjvitVzyaLG53X36mhjtst2APX66hLRY94HUbrXTISQoqyK1dTF/tQV68FwUYOO+1CyFnbOFVK8+iQVHuTUVYnBteSdNHRK68zjFw1wbUEuS+w5wEp6NmJo3OfzxWRaBq9m9Xt+FWwhgw3dOjQgyn7zfX8iVu6FWI1U5pwaVHre2DWyPMhIILzzkyJa5aP85ed/uqHh4U4++buDzbz2gfhjTGSm4DNJJsh1lxgULhoKwurnKy1j+auFu871U0SqEzY6RLfWrx0We1Ilw2z2w5+fjLO/zLKDwficrQKtrSy7ERIdOxFXMqRK2CHpHCliOhjZDJTX9R0YKN74O4r1MqSszDq+VsjY5NzjiphDjFcVAmKJdIVqYvE1n4clC7l6tgOWagWXxzyytKDiKn+bPkd6EkpCbhcOtfyO4JxPIcx3MYT4CPgH1WF8jc0Bh8ktF2a1ORCvFnNwHhnoa4xc+jTwJFkfDsHtd7k+V1U1jLTK3j6OQUVOf06OSgArEpFIoKNJ2JVR8NWF6UUhO7isNGPYnSEXk9Bmjvkx+Vg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(83380400001)(4326008)(6916009)(52116002)(66556008)(38350700002)(38100700002)(66946007)(44832011)(6486002)(956004)(8676002)(2616005)(86362001)(36756003)(8936002)(6512007)(26005)(2906002)(66476007)(5660300002)(186003)(7416002)(316002)(54906003)(508600001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XnYfgXvc/qjmDU1JmAZwhzqZCqcHGbPmMmfTVHeu7JelgICRUzfAt/KHFwSn?=
 =?us-ascii?Q?51s2MO635gKRYT/b4JaSztNPgYqZ9bN3ERhVhE9rPVGL20ng0nGc2cS5+JBR?=
 =?us-ascii?Q?b+h6Tb5CgQOQAb8sXy8JDD1Ay4ih2EAblZ2e96mtwDiYxjzOkqd1vHyFA/iq?=
 =?us-ascii?Q?pPixjIWWlSbs/8hlMR6jmfzhqJEQ2Btq8CwfQT4EXoTz6ZtgibUNwKAfZBW7?=
 =?us-ascii?Q?NLj0rwG/GE63Oeq8zHFw1qNeyLH+q6lCFcO7RmSxnBrxJSa4yVn6fIT1SKA0?=
 =?us-ascii?Q?kRfj5UaGJumRtV0qM00r+uBd4chLaGbJWa14lNCplbTCqbprpX3KTlExOmoq?=
 =?us-ascii?Q?FmpyLrSKx6Yi3LKpYDckB96C9dPdb8YlmFI0l/8vd7EyIHY8zNalTSAy4/AR?=
 =?us-ascii?Q?spxtaHRqXESFYcoPZK1uQwa9r1VNw8kPmfFRUX+FCUXqVeYlDys+g6xX1bV9?=
 =?us-ascii?Q?FMEKS0ClSxWJKIK9KgMWt2L3NqfdecsrwiQ9UR+ZYHLKzUGWkA8GgSkZOij8?=
 =?us-ascii?Q?zA/uP7W6CR1xi6pyYaaOhzlOPO58aAqopIzgYpDEpF3zYLtzYLS2I7jJfoAJ?=
 =?us-ascii?Q?THf7pGkjIXWXXHumKxrc/BgiIiUUzSnvJbuErLmh3ds1FormjX5C6n3ws+3I?=
 =?us-ascii?Q?wjuMy3sk9ximZ4N1xu2zRf8Xl3U6HEzv7sgJh0rAXBhn3XA8+krgfjpSdvJj?=
 =?us-ascii?Q?E5P3AZO1C7VrW0GNXBUcIsiNMGRZFH2PxMddqr9t1IHcmxj0Bl5zHLLA0GqH?=
 =?us-ascii?Q?XiLmE/NvsAk3LNDq/ZVvytekPMYtA7IQytXMLPojQAncGsZ4fMHOyRNJWXfz?=
 =?us-ascii?Q?lvqrgSx6Is5eysuYlnSkfUzEUrKJAUQb9zLQd3Cbtz35vmBG92SIUWI3KWHw?=
 =?us-ascii?Q?JFz3xjnoo4OSBLvyHPAOblQ6gIzALXjYa3QgC5Hl9nkLGOd1t3MxRh/emppE?=
 =?us-ascii?Q?K8hhcUhcDl4zOEKIOA7NCx4O5BB8GqLZ0d3mI0SFz2dHjKfI7K0b5aP80v5p?=
 =?us-ascii?Q?5Vksd1ocJfR8fkY6hCaA4vzQtYaFrPQ/fbeWVng6KBPoPDJsvOfYjfQDbPTu?=
 =?us-ascii?Q?yuyeS8D4bCYpYC0sqMmKICAeUX1A6ckUOU2MhJXRXOObQ36U694PPqPoSFDV?=
 =?us-ascii?Q?J8QIbXsmOQKHYpA2p1XwrwSLCHa51caM7z51UOzO82D8NqUeZ5uYfMnVl6Xc?=
 =?us-ascii?Q?OR8cdV+xsgKS2k2IAJ+7pe7DN8fJMp2z7vn0uc7LwMduYTiRW12cliFHe7LV?=
 =?us-ascii?Q?Nl4IUlvCxU6AtCoBkhRR2fmi2I5GNqz4fv34BdaCL+CjRMgV4cnf0T+F1ICe?=
 =?us-ascii?Q?rheomadeaVX3KHi+Ag3aTd4IZ0YszvcOn5rAgp8IhN565pPn34aE39BOEQlX?=
 =?us-ascii?Q?w888Z5Cy2o3mWnXW9J8TMhHfZM84s9HdQveiUhVioPyuQaQxPqnz5fktmYVI?=
 =?us-ascii?Q?Q6aWoKC98XKNixrPNoasorLBBboPppuN?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64097d92-25ca-44b4-0882-08d99581a147
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 17:30:24.0371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vladimir.oltean@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5504
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
index 4bd5819869ca..04ed09deb9ce 100644
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

