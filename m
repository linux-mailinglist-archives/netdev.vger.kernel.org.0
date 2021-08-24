Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C80A3F5D3E
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 13:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236858AbhHXLmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 07:42:19 -0400
Received: from mail-eopbgr140059.outbound.protection.outlook.com ([40.107.14.59]:35148
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236781AbhHXLmL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 07:42:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GM6bGaEniJNC80CPdZm3xVhwteVHbs5RGv4v7y0cTeSw18wA5qSxFBDYTwqA1uEZ36S9Sl5gEace43LrUJxbhzKwaVFy3bEbwrOyN+y3RxQGCsc6W+TTbNv+zrVlgRL9HyHls4r9ogTgXX25Tg5lXWPaHtNdTKEiQgGKtsA6yh7SPb1U91+3i0ktWD7GB6qsqiJGHUXPMHJbE5CRQfm9zli1GTkP8r62krLGtxhv8K4bdOF3FCNX7sMQo1I5Q26ifeiBNry29St9j3oUc1HT++85jiYkTKFP/u6cS6S+Cs/uYtsODFlmICWm8xik2fWY5IDPVYLCuMJuP9L6nxaJhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6zYHwQs9eClKuTbenfncX6ggQq2V/kVMCgpGj+9AXqI=;
 b=HMcGvtk8wr7mT21G/AFr32CDOygcbm+ouRd6vKGnB0zfllt7ResQU81N8BJdVwYTPutEi/UBtG5UhrIuYetROEVvg811cHTBxtQykvTOPF152uXGNBImQf4y4ccLBCE8/o2A9lf8xJX8G9H4tC+bmnflurKZ4D2tJ9+XM5wUdCmWiiBLVXc6Q/TdxErFMwNYXFWUiJwbmM9/cOxbYCjujifWqmYR+DmUbtWoITOBzaAohS7feO+Dr4qQH+iwZ/GcVbGELNl+HV/lgzmWyOScXSOwE6cjq/W4d7CmCHUgzZ2N7o9E8kE8u2S9zHgLWlxAtTPu5IBa4E0Qkigp/+EkSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6zYHwQs9eClKuTbenfncX6ggQq2V/kVMCgpGj+9AXqI=;
 b=gxhkq3ux8ResW6VvTkkuiFpXvHDOFrJzMbb8bMIi2c6oTKjjQvSl2SZYqxCeagLOVPYjNxYSrhUQiZqHLp18Deljmd2fqlN5CSQFKOBQC2093fNESpn1wsi7E1Cou4NHuNv7f6uH7Ab3IeYcgC5dJdchAx6ARqlOL9IT/w9OgKg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3070.eurprd04.prod.outlook.com (2603:10a6:802:4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Tue, 24 Aug
 2021 11:41:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.025; Tue, 24 Aug 2021
 11:41:25 +0000
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
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [RFC PATCH net-next 8/8] selftests: net: dsa: add a stress test for unlocked FDB operations
Date:   Tue, 24 Aug 2021 14:40:49 +0300
Message-Id: <20210824114049.3814660-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210824114049.3814660-1-vladimir.oltean@nxp.com>
References: <20210824114049.3814660-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0083.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by FR0P281CA0083.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1e::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.6 via Frontend Transport; Tue, 24 Aug 2021 11:41:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 238e44d3-ff3e-40ee-ef72-08d966f41a90
X-MS-TrafficTypeDiagnostic: VI1PR04MB3070:
X-Microsoft-Antispam-PRVS: <VI1PR04MB3070B6D4D2287EA8FFF0D761E0C59@VI1PR04MB3070.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VQMz4I+ufN2EqdEavoGF84kxYXgmbJeLRdYpE2uuoHdw8vjcOKGF9X4nqre6XXbrKM0lMwEVrX6tc5WYM8Dv+SWAut2X6mwhi+cDDFBioGqzWtLufZL9Lip4M9W6d8ADE98LB9hJWik4R4javh3fP1dcq81A4zUPVJFLp2FXWthgoNwIXuDf3J57cShhsgrL6EAEseIX6zzncYF8X1uAmvKdYV9zlgWzPiYqN7CGiMC5AOXFq3d+UqPmx49rbv1/viYPKBZmjPBft8b9YnKMSDnwK+lmSbGMLWKOm5UTkjtlNfqCvtCgF6rrCwV95UZX1WODa/HhZFPFzcriiyBwb+qJUL2y11s9hpvSLihsmw76UVdeYbSwivJ7U1usdHhv8daafwzeXFhBxzrXqOvy1qeKetZnO7wXdFKtDjO9Dp/dq6xqESwUuoUwJ1ccVhAnWbPhWUJ4jIa4HR/9PkdmEv1bjwoTx0F7bqgdis8zgyyr/heFbDnVRdpfOtb4n8gaVJxYkE75CcclrbYs/zbDtUhwx8YYs+TJ7gsuc7Tn0+nIiDEY4iKYpSPy/f+RbZgJ5AzFvbD6IQf697stwyAfwz6OlKNm9mdANUt2iYUpnJXFvpl2eucN0sWURtjALbuTXEsnamPuEhKePQKPhnY4DwGnyONO9csqJtkXX6Xi/ZwT5/a1eEznESmmPdwezyZb/ejWGBgvbYa9JigJqgQPnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(396003)(39850400004)(136003)(6486002)(8676002)(66556008)(66946007)(186003)(5660300002)(66476007)(6512007)(4326008)(86362001)(1076003)(956004)(36756003)(26005)(2616005)(6916009)(316002)(6506007)(52116002)(44832011)(8936002)(478600001)(6666004)(38350700002)(38100700002)(83380400001)(54906003)(7416002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dvBR75Kp6m/qTlaiNBMFxeYf+XvbV9oo3x2yamF0Da4fx0NT5MlYhEWcX977?=
 =?us-ascii?Q?Ixur48kuG+e4uCdeJTBv/vQ2M0i8wenuu+3ILkoUVmwqUV3DRg6BGGcTNvdz?=
 =?us-ascii?Q?IWc/9nFHCOqNhsRsW9Q/IlYMnO3N4TYXO84etihp4WTwYzwi2xUY9EAMtShM?=
 =?us-ascii?Q?Pt9uWYBwAbCCmTYRZlsNbDzk2aVAm+3XT+AySFaOc/GQj7JSjX5rxe0Iuk9x?=
 =?us-ascii?Q?jE6ekwHLC3XsGw0KkH3yH9BTqDJhHIArDUzRJcHH5mvZ+Zz2TR+zm490fjvd?=
 =?us-ascii?Q?Orn/uPIEL6aRA+lgfasJSuBDiMHCn5sWwQO20uRqgNQw6XojK4nBKzTy4ND7?=
 =?us-ascii?Q?F0FZIt2FbQoVy2y8hCMDfO1hO81tvfYXxkkkKNnXstYE+4J6/JK9HHbkcaV+?=
 =?us-ascii?Q?fE/C9YQ5H5qol9/4ar7qBb46Cu+PjTikaAf+EkOtWL/wdLHWqV66J8fgtZdd?=
 =?us-ascii?Q?Fp8eNdtS1hqW1kFFDnBLZFQ6DgqqjHJd1ebrvTwD9qqXkVBvRQbXYoO+vue/?=
 =?us-ascii?Q?bFvgQ1IiPewWmA7m2584tTQlNusa6Ko16LAv9lw4NKBQVxqc4BHxgZgyK+39?=
 =?us-ascii?Q?RmyoiTVw/lsaQNLA60gCM/Xgyog78vCeLlVbAyIRaKPrQ2cE1uT/ll5T+/yD?=
 =?us-ascii?Q?O1z+TCCzBKQY3bwoFTELQRugCvydVdAdg5xqDrvBbbxrZOAASKeKDK5oPjL7?=
 =?us-ascii?Q?F6jEmiS1OxM1hXo5i2wVEbyG8WeS6urJqC08Hh5bWmW9MOmzsfNnCpUMB9VR?=
 =?us-ascii?Q?JNgGXJyyuGSf2MZnAtEp5+WEOey0IPvF0hkyLZPV54UI/xP16vNUEbjEelZb?=
 =?us-ascii?Q?x3kKjnlnxqr/2bv6G4EypendTyXIBnI/r9w/+BN5wi2bsr7q0OTrQ7HVWuzm?=
 =?us-ascii?Q?vfgODSjUYjdhbSuWXESnfligO/ZiSi8RpkO1SD2Mu/GpfHK1LoQAOuxd8GE1?=
 =?us-ascii?Q?AEUXOSSRIgRLx0+THAAcIBSypX51k/vBX6C1mR5lVkPKzeEnsLtPL5N2ISTZ?=
 =?us-ascii?Q?dBGw6eGqOZUDSKi2bWrhQ03TNZVHZE9ZRQ3d3JqMQfouOMQnWEbsLIhrD7qM?=
 =?us-ascii?Q?ql8NTLe4w9cV0cpB+h3m8DLoLw6dohD6i8oaY9dMDgDhuNPf3jv7mwirg+D7?=
 =?us-ascii?Q?j9VgFp2oPVu6+lRCgjjc3M1LgSWE9a/hw2gfS5MA2vIsWW/f4ibMUSc8YmR7?=
 =?us-ascii?Q?FvNcycjimtOORwHBEm+Euany9FQvLsMSjTEzLCjS2vQmYtWfM2Z9/SASNTvZ?=
 =?us-ascii?Q?6CkakhnFtg/n9t0fNYitb5bSGqafjYvXfU75EMq2vYMm7DVJK/VN0OSVwgxE?=
 =?us-ascii?Q?fZuSRaBfqyklz6j+Dmb9QPPr?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 238e44d3-ff3e-40ee-ef72-08d966f41a90
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 11:41:25.5074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UFAhKNqir5GbWvXaElLH0X7idTjRKegVLtptd8wzfXz8zqMfQpx9qQqYwPUmb5bqkbX5aaKBq3VsUKrgUbK4Qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3070
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
index 06e39d3eba93..23b65ef5f11a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12958,6 +12958,7 @@ F:	include/linux/dsa/
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

