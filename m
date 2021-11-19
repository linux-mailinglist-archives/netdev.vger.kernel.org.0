Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E33456863
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 03:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234337AbhKSC6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 21:58:18 -0500
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:60246 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234212AbhKSC6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 21:58:07 -0500
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AJ2lSMl000941;
        Thu, 18 Nov 2021 18:54:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=PPS06212021;
 bh=wG0GoXuChn5zq49O8dreENLPYyBfGWZSkDCQ31Mh1vg=;
 b=jEkuMsEW8dRzGlJ6fsZ76tWboYPM7P11tcVdRGLHvIYeXPbkHnSK++nMhwUFiEnGbla/
 HDTrM+t5RFJOzqObD2jKjIHoZEM1GMy/TL1mDtT1jiutWRcxHA9xXGQ9WkZRKH9bAIML
 ap+GDjCzX3JS7cfjQPRmERdhwnl4E2qcalY3cEfBOSyNJxfafotrMVZuxnM+GiZ8FTs+
 /pagVGYDymG6FK1zxS8vzJEQ84updAHYBtw4pcTGQDvUbEDGUupoXc0EGqwCwqGi9c8E
 w8GFlB/bVBZl2fm88Ejsx+0qjxCYDxMjNwCh0s1aJESF4Cl5wncgXV2sCErn3Dh+p0rp SA== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3ce02h84eg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Nov 2021 18:54:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HT2iXPh7j9TIZnBMUM0fyDo3B1nP7rnK8MeguKnWghbai3UNToZyi/rgta84U+54PVT5aJh08jg5X1x7RRNdkeIEqGGQubBVzDXno2vh0rYvtp6hYslHFhFR6gdKaxEmBB6aDgFYuPzqkAGsaiqbrQBldCiplzbD7Ranojo6FaW70v41z6QUQo7GjzMoi/SVjFVQonZ+Zauc4Fp9DLIMoqjdZjlYWdoFamnXDeyVJ0UfozOTYg80F3oZ7vhHf4DE4VuXpWyvd7EqkUCyFLxUTxm8ndvBFzYb2JHuF/+Ri/VNTnbgf0jpa06mlthGwlPZJ102l7chS2LRu7XYBHukUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wG0GoXuChn5zq49O8dreENLPYyBfGWZSkDCQ31Mh1vg=;
 b=DPY1IVa25I9k3pGiqwbRaw7rdPBaMlAIaLIk2vyUMf6gWH59Oy8BezwkOf1y6Zn57HEaqxpDov970qY/5RMDtfpq72oYo0bmqA/waV3lu+XAyZWgppMjItANs9jfeEWz+GcXiVfJm8PoRsK2QJ5Y6qqcjo2zqxrU31uqKcqCLFUww0XVOAe1Mnd233u3vK+oLst0oW0/rQH4KyUT7gxssFGEz55wm82zvNOFSeTG5y3eYUCaot93THGpxf/GUSZFw8aRqL4/jeOYQNntC9PlbIOHwYt2Yj+/maHTaYwj7H2kF/JHz+oPQIYk+iT4XZPUQVR4MAZaWm7dHHhixhlhAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB5191.namprd11.prod.outlook.com (2603:10b6:510:3e::24)
 by PH0PR11MB4951.namprd11.prod.outlook.com (2603:10b6:510:43::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Fri, 19 Nov
 2021 02:54:24 +0000
Received: from PH0PR11MB5191.namprd11.prod.outlook.com
 ([fe80::a090:40db:80ae:f06a]) by PH0PR11MB5191.namprd11.prod.outlook.com
 ([fe80::a090:40db:80ae:f06a%9]) with mapi id 15.20.4690.029; Fri, 19 Nov 2021
 02:54:24 +0000
From:   Meng Li <Meng.Li@windriver.com>
To:     stable@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, linux@armlinux.org.uk, andrew@lunn.ch,
        qiangqing.zhang@nxp.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        meng.li@windriver.com
Subject: [PATCH 1/6] net: stmmac: add clocks management for gmac driver
Date:   Fri, 19 Nov 2021 10:53:54 +0800
Message-Id: <20211119025359.30815-2-Meng.Li@windriver.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211119025359.30815-1-Meng.Li@windriver.com>
References: <20211119025359.30815-1-Meng.Li@windriver.com>
Content-Type: text/plain
X-ClientProxiedBy: HK2PR0401CA0017.apcprd04.prod.outlook.com
 (2603:1096:202:2::27) To PH0PR11MB5191.namprd11.prod.outlook.com
 (2603:10b6:510:3e::24)
MIME-Version: 1.0
Received: from pek-mli1-d2.wrs.com (60.247.85.82) by HK2PR0401CA0017.apcprd04.prod.outlook.com (2603:1096:202:2::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Fri, 19 Nov 2021 02:54:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a96bba0-376b-4b2e-97ae-08d9ab07e498
X-MS-TrafficTypeDiagnostic: PH0PR11MB4951:
X-Microsoft-Antispam-PRVS: <PH0PR11MB49514F1B14BFC7080D278609F19C9@PH0PR11MB4951.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:431;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OiU+4CxWiw71XTdvIiMpi/Hg8XycDczJf4BawCNPidZagDCLOXVmHGc3nkwYOzPnTm/AgbiVEcFqB7GLSjjIdW0wSPXz/6x++vQI9xUoPNqe02P/HAV7xTE3T7ZHE+kc8R1tPKJDXSaL1F6W2aN4Ep2XEIdmxg4twvdGwHdMEDsWhS9+F0JT4De7dMeV4T32PTuNeMIu42nV3VBlACDRmWOdd5EWmZ/OIjNMxy6+Jtclm4n21DQyUWpPHOdE55anukeCjPQXqLCEvTqoE49O28M+loABKq/zqb85FoNhw2QNCArtaXnuKe6fQYOpNirhpQr+bBRBBZds8T2maWoiI7cydk7LBYOKy4GKg9Rtu1iVAKyRwsSb23SbBNrt/XkdtRE9q9IjVaPH3mSYzXLJmRySkTA3fe3bVqfkggoPf4FCPu64hvppVe4qcFVnXZTdSq4gmg97ZI02veTJcxndvNsQxx+bjBXv2i7//6mXjWKfdnOjoGX4OsJP2z67VvYoEYXNIChVqU1mYNy6NA0mV8mGwV0QDSkCU279w4S2Azc3haoDFRuyJtzacRk5/Z90cn9wogd3BHzdozqEWIufeTmrnwk8OL8p1vwa7V9F9qX7EowNBnDR1tEzYfegVtl3lwGrAa2lsHerfS++KlE1TaJHVr/Lk/Oyb1cM/6JafbfsndjE3aDaFz3zi3DiZ2/XyMoJ0ipPCx05JRN1zXfgXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5191.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(83380400001)(5660300002)(186003)(107886003)(6512007)(4326008)(38350700002)(38100700002)(2616005)(508600001)(30864003)(8936002)(45080400002)(1076003)(36756003)(956004)(52116002)(66946007)(66476007)(6486002)(2906002)(316002)(26005)(86362001)(66556008)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?37VfsI51zlc59hrVPEfTIkOA5PUp/DSPiV6e7LzME/gHvi/7x0oJzHiBcZP+?=
 =?us-ascii?Q?1cB4tY3EbSVsY9f6Ufuy42wLItwbGLrE7beXA6pcn8D9ZihKdNIBjwPakPUc?=
 =?us-ascii?Q?eZXhFMU5P7rkWupglvb2xeV2M0atueaRpUIKkT2UkOw1Eq8E9uiV+XNnlA2E?=
 =?us-ascii?Q?IB91CKcZfrKSLUB0noBHALbjQJZL3PIwe1ZviVt3xuYWVwQ5Ik08r//vuI2z?=
 =?us-ascii?Q?fGlCLZZdfbgshEVS8Kd3tt9hsh2IUUPsFjsBIvkZk/Bb+YhQMe6Z5pfobG+v?=
 =?us-ascii?Q?kOExtipkBzYf+jO/LW+Ixkrb2iqvExgzuJAPFIK2laMe6EKLMitOfXbl+JfF?=
 =?us-ascii?Q?0ixOQ03hbpVSn4EfRJgAMGOcQTrqbx1iIeA1E2UJYcDkUQraaaOLHN97pc5B?=
 =?us-ascii?Q?/5wyUBmrJb8uiiNkYMvm7VmRmA5iGkQzXnSI4dFq/1QzcInulBEDFGks7cdE?=
 =?us-ascii?Q?pSKgXbBwoce/dAZhz01ZFmxAuJPMh74a4IjZQdMkaK40Sa9cUopyR35bZcaL?=
 =?us-ascii?Q?XY9IWad6pDse43W+yAqvc+C3RQG0NjljkMibtuxeno71nm2/l7eJVgHUN+jM?=
 =?us-ascii?Q?f83/44gOZoMBqWRTKoVp8vIlffLLZeqPoaxsE9vlXfa6fZ9sDMkdj41rcb7M?=
 =?us-ascii?Q?Aar1O+KC7HLYakn0O6DyeY/jwtCa975a47mqseq54lrQrw5OWZUI1ZxO2kpA?=
 =?us-ascii?Q?bUMVAmGsJjdDWeN5kVDOptiF/HI21ZGH6QoEeTq+/QucISeKA+tpQh5Q0AGL?=
 =?us-ascii?Q?JcHuiTcHR9Cj/F7mnliZdiY2pj/mm2nc4qxF7t5v39Aqy3xhUVy7FbWzRLqS?=
 =?us-ascii?Q?QY/RAdXQlNM+K+SKkTMCM3HQPOE4KZ67+CgAhFqx1U8vWTaLLbLUDRXJwKMb?=
 =?us-ascii?Q?MBxbaaF/ZnyNsWkpzHJAa9ltje8xuCUCE4DKGuac4q1TSTCcKFOfNnoD4kB/?=
 =?us-ascii?Q?JbqUFhfm6fB6WSIlFc7dlCgwp4hMRS+OsX70Z+LIqQh2LqV8V6Nin3F2gvfs?=
 =?us-ascii?Q?4O2dE1b49fRUwzi8CihAzlS+qxHkol6WAaXbClhLFjoXXINcSkOEyLdzoPUM?=
 =?us-ascii?Q?P3tR+44Dk0cdfwXFppxwhNDA9oSSVS0vCE1WagCjmcQTa8EJp5H/HqrxwJyo?=
 =?us-ascii?Q?tbPSDb2rENTcEI+4DO44BNx/0oXiynoobdjMn1dyapn34KnDj/SFvJYr2xbm?=
 =?us-ascii?Q?981Nelj8yThsMrhgZ/mMqXEEuACCYEM26zQqw2ONTS7U+UfCzsO34JqrV7ta?=
 =?us-ascii?Q?kdiBihu7hCkBV/aWa4/LtuHptSsiAf/kWUi9DVef3Wiz1iBebP7dfnYCwIHL?=
 =?us-ascii?Q?Wrb88OtrS23LEcnjiWupmx5IjTvkLS0OynuhI4T8XEI6nGDbdK6C2GlBWOYS?=
 =?us-ascii?Q?W0VbjRDhDFhAeWIfXDqAQv1P+LjSQyX7a5OZ2vANxCbFiMspzy7S0u4UgIT5?=
 =?us-ascii?Q?Zq0OD9VbSKR5iXd3c9IYaD/ukyCHC6AzQ8XSeObvBky7ABl/gEXx2U+BSFcL?=
 =?us-ascii?Q?3cSeOmcMADWDPgqIgs0mJS6uC5q2gqQqj3mFpALSXnnYvG+fyYyg9CwKSemz?=
 =?us-ascii?Q?Kg4crg12X/gF8SgDNNbwnWkLJZC5iomVLHhRC677MGw78SSkxw0ZJrVAdBOE?=
 =?us-ascii?Q?5EyB+b3wev6cOMFaxrujXUQ=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a96bba0-376b-4b2e-97ae-08d9ab07e498
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5191.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 02:54:23.9375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NkcsbVljJCSlnEM2/Jlil8evX9OkNaCcbdH1MtLfPCOV6OSD4jD5p54wn1ozhXgVVHyiwW8dnCBEAu0ZWHZx1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4951
X-Proofpoint-GUID: 0w29HvWc-idBlG00Ye6pZB2AiE3J7KCu
X-Proofpoint-ORIG-GUID: 0w29HvWc-idBlG00Ye6pZB2AiE3J7KCu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-19_02,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 phishscore=0 priorityscore=1501 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111190012
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joakim Zhang <qiangqing.zhang@nxp.com>

commit 5ec55823438e850c91c6b92aec93fb04ebde29e2 upstream.

This patch intends to add clocks management for stmmac driver:

If CONFIG_PM enabled:
1. Keep clocks disabled after driver probed.
2. Enable clocks when up the net device, and disable clocks when down
the net device.

If CONFIG_PM disabled:
Keep clocks always enabled after driver probed.

Note:
1. It is fine for ethtool, since the way of implementing ethtool_ops::begin
in stmmac is only can be accessed when interface is enabled, so the clocks
are ticked.
2. The MDIO bus has a different life cycle to the MAC, need ensure
clocks are enabled when _mdio_read/write() need clocks, because these
functions can be called while the interface it not opened.

Stable backport notes:
When run below command to remove ethernet driver on
stratix10 platform, there will be warning trace as below:

$ cd /sys/class/net/eth0/device/driver/
$ echo ff800000.ethernet > unbind

WARNING: CPU: 3 PID: 386 at drivers/clk/clk.c:810 clk_core_unprepare+0x114/0x274
Modules linked in: sch_fq_codel
CPU: 3 PID: 386 Comm: sh Tainted: G        W         5.10.74-yocto-standard #1
Hardware name: SoCFPGA Stratix 10 SoCDK (DT)
pstate: 00000005 (nzcv daif -PAN -UAO -TCO BTYPE=--)
pc : clk_core_unprepare+0x114/0x274
lr : clk_core_unprepare+0x114/0x274
sp : ffff800011bdbb10
clk_core_unprepare+0x114/0x274
 clk_unprepare+0x38/0x50
 stmmac_remove_config_dt+0x40/0x80
 stmmac_pltfr_remove+0x64/0x80
 platform_drv_remove+0x38/0x60
 ... ..
 el0_sync_handler+0x1a4/0x1b0
 el0_sync+0x180/0x1c0
This issue is introduced by introducing upstream commit 8f269102baf7
("net: stmmac: disable clocks in stmmac_remove_config_dt()")

But in latest mainline kernel, there is no this issue. Because this
patch improved clocks management for stmmac driver.
Therefore, backport it and its fixing patches to stable kernel v5.10.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: stable@vger.kernel.org
Signed-off-by: Meng Li <Meng.Li@windriver.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |   1 +
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  75 ++++++++++--
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c | 111 ++++++++++++++----
 .../ethernet/stmicro/stmmac/stmmac_platform.c |  24 +++-
 4 files changed, 174 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 727e68dfaf1c..a4ca283e0228 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -270,6 +270,7 @@ void stmmac_disable_eee_mode(struct stmmac_priv *priv);
 bool stmmac_eee_init(struct stmmac_priv *priv);
 int stmmac_reinit_queues(struct net_device *dev, u32 rx_cnt, u32 tx_cnt);
 int stmmac_reinit_ringparam(struct net_device *dev, u32 rx_size, u32 tx_size);
+int stmmac_bus_clks_config(struct stmmac_priv *priv, bool enabled);
 
 #if IS_ENABLED(CONFIG_STMMAC_SELFTESTS)
 void stmmac_selftest_run(struct net_device *dev,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 0ac61e7ab43c..498962c4b59e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -28,6 +28,7 @@
 #include <linux/if_vlan.h>
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
+#include <linux/pm_runtime.h>
 #include <linux/prefetch.h>
 #include <linux/pinctrl/consumer.h>
 #ifdef CONFIG_DEBUG_FS
@@ -113,6 +114,28 @@ static void stmmac_exit_fs(struct net_device *dev);
 
 #define STMMAC_COAL_TIMER(x) (jiffies + usecs_to_jiffies(x))
 
+int stmmac_bus_clks_config(struct stmmac_priv *priv, bool enabled)
+{
+	int ret = 0;
+
+	if (enabled) {
+		ret = clk_prepare_enable(priv->plat->stmmac_clk);
+		if (ret)
+			return ret;
+		ret = clk_prepare_enable(priv->plat->pclk);
+		if (ret) {
+			clk_disable_unprepare(priv->plat->stmmac_clk);
+			return ret;
+		}
+	} else {
+		clk_disable_unprepare(priv->plat->stmmac_clk);
+		clk_disable_unprepare(priv->plat->pclk);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(stmmac_bus_clks_config);
+
 /**
  * stmmac_verify_args - verify the driver parameters.
  * Description: it checks the driver parameters and set a default in case of
@@ -2792,6 +2815,12 @@ static int stmmac_open(struct net_device *dev)
 	u32 chan;
 	int ret;
 
+	ret = pm_runtime_get_sync(priv->device);
+	if (ret < 0) {
+		pm_runtime_put_noidle(priv->device);
+		return ret;
+	}
+
 	if (priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI &&
 	    priv->hw->xpcs == NULL) {
@@ -2800,7 +2829,7 @@ static int stmmac_open(struct net_device *dev)
 			netdev_err(priv->dev,
 				   "%s: Cannot attach to PHY (error: %d)\n",
 				   __func__, ret);
-			return ret;
+			goto init_phy_error;
 		}
 	}
 
@@ -2915,6 +2944,8 @@ static int stmmac_open(struct net_device *dev)
 	free_dma_desc_resources(priv);
 dma_desc_error:
 	phylink_disconnect_phy(priv->phylink);
+init_phy_error:
+	pm_runtime_put(priv->device);
 	return ret;
 }
 
@@ -2965,6 +2996,8 @@ static int stmmac_release(struct net_device *dev)
 
 	stmmac_release_ptp(priv);
 
+	pm_runtime_put(priv->device);
+
 	return 0;
 }
 
@@ -4616,6 +4649,12 @@ static int stmmac_vlan_rx_kill_vid(struct net_device *ndev, __be16 proto, u16 vi
 	bool is_double = false;
 	int ret;
 
+	ret = pm_runtime_get_sync(priv->device);
+	if (ret < 0) {
+		pm_runtime_put_noidle(priv->device);
+		return ret;
+	}
+
 	if (be16_to_cpu(proto) == ETH_P_8021AD)
 		is_double = true;
 
@@ -4624,10 +4663,15 @@ static int stmmac_vlan_rx_kill_vid(struct net_device *ndev, __be16 proto, u16 vi
 	if (priv->hw->num_vlan) {
 		ret = stmmac_del_hw_vlan_rx_fltr(priv, ndev, priv->hw, proto, vid);
 		if (ret)
-			return ret;
+			goto del_vlan_error;
 	}
 
-	return stmmac_vlan_update(priv, is_double);
+	ret = stmmac_vlan_update(priv, is_double);
+
+del_vlan_error:
+	pm_runtime_put(priv->device);
+
+	return ret;
 }
 
 static const struct net_device_ops stmmac_netdev_ops = {
@@ -5066,6 +5110,10 @@ int stmmac_dvr_probe(struct device *device,
 
 	stmmac_check_pcs_mode(priv);
 
+	pm_runtime_get_noresume(device);
+	pm_runtime_set_active(device);
+	pm_runtime_enable(device);
+
 	if (priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI) {
 		/* MDIO bus Registration */
@@ -5103,6 +5151,11 @@ int stmmac_dvr_probe(struct device *device,
 	stmmac_init_fs(ndev);
 #endif
 
+	/* Let pm_runtime_put() disable the clocks.
+	 * If CONFIG_PM is not enabled, the clocks will stay powered.
+	 */
+	pm_runtime_put(device);
+
 	return ret;
 
 error_serdes_powerup:
@@ -5117,6 +5170,7 @@ int stmmac_dvr_probe(struct device *device,
 	stmmac_napi_del(ndev);
 error_hw_init:
 	destroy_workqueue(priv->wq);
+	stmmac_bus_clks_config(priv, false);
 
 	return ret;
 }
@@ -5152,8 +5206,8 @@ int stmmac_dvr_remove(struct device *dev)
 	phylink_destroy(priv->phylink);
 	if (priv->plat->stmmac_rst)
 		reset_control_assert(priv->plat->stmmac_rst);
-	clk_disable_unprepare(priv->plat->pclk);
-	clk_disable_unprepare(priv->plat->stmmac_clk);
+	pm_runtime_put(dev);
+	pm_runtime_disable(dev);
 	if (priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI)
 		stmmac_mdio_unregister(ndev);
@@ -5176,6 +5230,7 @@ int stmmac_suspend(struct device *dev)
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
 	u32 chan;
+	int ret;
 
 	if (!ndev || !netif_running(ndev))
 		return 0;
@@ -5219,8 +5274,9 @@ int stmmac_suspend(struct device *dev)
 		pinctrl_pm_select_sleep_state(priv->device);
 		/* Disable clock in case of PWM is off */
 		clk_disable_unprepare(priv->plat->clk_ptp_ref);
-		clk_disable_unprepare(priv->plat->pclk);
-		clk_disable_unprepare(priv->plat->stmmac_clk);
+		ret = pm_runtime_force_suspend(dev);
+		if (ret)
+			return ret;
 	}
 	mutex_unlock(&priv->lock);
 
@@ -5286,8 +5342,9 @@ int stmmac_resume(struct device *dev)
 	} else {
 		pinctrl_pm_select_default_state(priv->device);
 		/* enable the clk previously disabled */
-		clk_prepare_enable(priv->plat->stmmac_clk);
-		clk_prepare_enable(priv->plat->pclk);
+		ret = pm_runtime_force_resume(dev);
+		if (ret)
+			return ret;
 		if (priv->plat->clk_ptp_ref)
 			clk_prepare_enable(priv->plat->clk_ptp_ref);
 		/* reset the phy so that it's ready */
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index 678726c62a8a..7c1a14b256da 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -15,6 +15,7 @@
 #include <linux/iopoll.h>
 #include <linux/mii.h>
 #include <linux/of_mdio.h>
+#include <linux/pm_runtime.h>
 #include <linux/phy.h>
 #include <linux/property.h>
 #include <linux/slab.h>
@@ -87,21 +88,29 @@ static int stmmac_xgmac2_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
 	u32 tmp, addr, value = MII_XGMAC_BUSY;
 	int ret;
 
+	ret = pm_runtime_get_sync(priv->device);
+	if (ret < 0) {
+		pm_runtime_put_noidle(priv->device);
+		return ret;
+	}
+
 	/* Wait until any existing MII operation is complete */
 	if (readl_poll_timeout(priv->ioaddr + mii_data, tmp,
-			       !(tmp & MII_XGMAC_BUSY), 100, 10000))
-		return -EBUSY;
+			       !(tmp & MII_XGMAC_BUSY), 100, 10000)) {
+		ret = -EBUSY;
+		goto err_disable_clks;
+	}
 
 	if (phyreg & MII_ADDR_C45) {
 		phyreg &= ~MII_ADDR_C45;
 
 		ret = stmmac_xgmac2_c45_format(priv, phyaddr, phyreg, &addr);
 		if (ret)
-			return ret;
+			goto err_disable_clks;
 	} else {
 		ret = stmmac_xgmac2_c22_format(priv, phyaddr, phyreg, &addr);
 		if (ret)
-			return ret;
+			goto err_disable_clks;
 
 		value |= MII_XGMAC_SADDR;
 	}
@@ -112,8 +121,10 @@ static int stmmac_xgmac2_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
 
 	/* Wait until any existing MII operation is complete */
 	if (readl_poll_timeout(priv->ioaddr + mii_data, tmp,
-			       !(tmp & MII_XGMAC_BUSY), 100, 10000))
-		return -EBUSY;
+			       !(tmp & MII_XGMAC_BUSY), 100, 10000)) {
+		ret = -EBUSY;
+		goto err_disable_clks;
+	}
 
 	/* Set the MII address register to read */
 	writel(addr, priv->ioaddr + mii_address);
@@ -121,11 +132,18 @@ static int stmmac_xgmac2_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
 
 	/* Wait until any existing MII operation is complete */
 	if (readl_poll_timeout(priv->ioaddr + mii_data, tmp,
-			       !(tmp & MII_XGMAC_BUSY), 100, 10000))
-		return -EBUSY;
+			       !(tmp & MII_XGMAC_BUSY), 100, 10000)) {
+		ret = -EBUSY;
+		goto err_disable_clks;
+	}
 
 	/* Read the data from the MII data register */
-	return readl(priv->ioaddr + mii_data) & GENMASK(15, 0);
+	ret = (int)readl(priv->ioaddr + mii_data) & GENMASK(15, 0);
+
+err_disable_clks:
+	pm_runtime_put(priv->device);
+
+	return ret;
 }
 
 static int stmmac_xgmac2_mdio_write(struct mii_bus *bus, int phyaddr,
@@ -138,21 +156,29 @@ static int stmmac_xgmac2_mdio_write(struct mii_bus *bus, int phyaddr,
 	u32 addr, tmp, value = MII_XGMAC_BUSY;
 	int ret;
 
+	ret = pm_runtime_get_sync(priv->device);
+	if (ret < 0) {
+		pm_runtime_put_noidle(priv->device);
+		return ret;
+	}
+
 	/* Wait until any existing MII operation is complete */
 	if (readl_poll_timeout(priv->ioaddr + mii_data, tmp,
-			       !(tmp & MII_XGMAC_BUSY), 100, 10000))
-		return -EBUSY;
+			       !(tmp & MII_XGMAC_BUSY), 100, 10000)) {
+		ret = -EBUSY;
+		goto err_disable_clks;
+	}
 
 	if (phyreg & MII_ADDR_C45) {
 		phyreg &= ~MII_ADDR_C45;
 
 		ret = stmmac_xgmac2_c45_format(priv, phyaddr, phyreg, &addr);
 		if (ret)
-			return ret;
+			goto err_disable_clks;
 	} else {
 		ret = stmmac_xgmac2_c22_format(priv, phyaddr, phyreg, &addr);
 		if (ret)
-			return ret;
+			goto err_disable_clks;
 
 		value |= MII_XGMAC_SADDR;
 	}
@@ -164,16 +190,23 @@ static int stmmac_xgmac2_mdio_write(struct mii_bus *bus, int phyaddr,
 
 	/* Wait until any existing MII operation is complete */
 	if (readl_poll_timeout(priv->ioaddr + mii_data, tmp,
-			       !(tmp & MII_XGMAC_BUSY), 100, 10000))
-		return -EBUSY;
+			       !(tmp & MII_XGMAC_BUSY), 100, 10000)) {
+		ret = -EBUSY;
+		goto err_disable_clks;
+	}
 
 	/* Set the MII address register to write */
 	writel(addr, priv->ioaddr + mii_address);
 	writel(value, priv->ioaddr + mii_data);
 
 	/* Wait until any existing MII operation is complete */
-	return readl_poll_timeout(priv->ioaddr + mii_data, tmp,
-				  !(tmp & MII_XGMAC_BUSY), 100, 10000);
+	ret = readl_poll_timeout(priv->ioaddr + mii_data, tmp,
+				 !(tmp & MII_XGMAC_BUSY), 100, 10000);
+
+err_disable_clks:
+	pm_runtime_put(priv->device);
+
+	return ret;
 }
 
 /**
@@ -196,6 +229,12 @@ static int stmmac_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
 	int data = 0;
 	u32 v;
 
+	data = pm_runtime_get_sync(priv->device);
+	if (data < 0) {
+		pm_runtime_put_noidle(priv->device);
+		return data;
+	}
+
 	value |= (phyaddr << priv->hw->mii.addr_shift)
 		& priv->hw->mii.addr_mask;
 	value |= (phyreg << priv->hw->mii.reg_shift) & priv->hw->mii.reg_mask;
@@ -216,19 +255,26 @@ static int stmmac_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
 	}
 
 	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
-			       100, 10000))
-		return -EBUSY;
+			       100, 10000)) {
+		data = -EBUSY;
+		goto err_disable_clks;
+	}
 
 	writel(data, priv->ioaddr + mii_data);
 	writel(value, priv->ioaddr + mii_address);
 
 	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
-			       100, 10000))
-		return -EBUSY;
+			       100, 10000)) {
+		data = -EBUSY;
+		goto err_disable_clks;
+	}
 
 	/* Read the data from the MII data register */
 	data = (int)readl(priv->ioaddr + mii_data) & MII_DATA_MASK;
 
+err_disable_clks:
+	pm_runtime_put(priv->device);
+
 	return data;
 }
 
@@ -247,10 +293,16 @@ static int stmmac_mdio_write(struct mii_bus *bus, int phyaddr, int phyreg,
 	struct stmmac_priv *priv = netdev_priv(ndev);
 	unsigned int mii_address = priv->hw->mii.addr;
 	unsigned int mii_data = priv->hw->mii.data;
+	int ret, data = phydata;
 	u32 value = MII_BUSY;
-	int data = phydata;
 	u32 v;
 
+	ret = pm_runtime_get_sync(priv->device);
+	if (ret < 0) {
+		pm_runtime_put_noidle(priv->device);
+		return ret;
+	}
+
 	value |= (phyaddr << priv->hw->mii.addr_shift)
 		& priv->hw->mii.addr_mask;
 	value |= (phyreg << priv->hw->mii.reg_shift) & priv->hw->mii.reg_mask;
@@ -275,16 +327,23 @@ static int stmmac_mdio_write(struct mii_bus *bus, int phyaddr, int phyreg,
 
 	/* Wait until any existing MII operation is complete */
 	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
-			       100, 10000))
-		return -EBUSY;
+			       100, 10000)) {
+		ret = -EBUSY;
+		goto err_disable_clks;
+	}
 
 	/* Set the MII address register to write */
 	writel(data, priv->ioaddr + mii_data);
 	writel(value, priv->ioaddr + mii_address);
 
 	/* Wait until any existing MII operation is complete */
-	return readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
-				  100, 10000);
+	ret = readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
+				 100, 10000);
+
+err_disable_clks:
+	pm_runtime_put(priv->device);
+
+	return ret;
 }
 
 /**
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 48186cd32ce1..332afe8519f4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -760,10 +760,30 @@ static int stmmac_pltfr_resume(struct device *dev)
 
 	return stmmac_resume(dev);
 }
+
+static int stmmac_runtime_suspend(struct device *dev)
+{
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct stmmac_priv *priv = netdev_priv(ndev);
+
+	stmmac_bus_clks_config(priv, false);
+
+	return 0;
+}
+
+static int stmmac_runtime_resume(struct device *dev)
+{
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct stmmac_priv *priv = netdev_priv(ndev);
+
+	return stmmac_bus_clks_config(priv, true);
+}
 #endif /* CONFIG_PM_SLEEP */
 
-SIMPLE_DEV_PM_OPS(stmmac_pltfr_pm_ops, stmmac_pltfr_suspend,
-				       stmmac_pltfr_resume);
+const struct dev_pm_ops stmmac_pltfr_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(stmmac_pltfr_suspend, stmmac_pltfr_resume)
+	SET_RUNTIME_PM_OPS(stmmac_runtime_suspend, stmmac_runtime_resume, NULL)
+};
 EXPORT_SYMBOL_GPL(stmmac_pltfr_pm_ops);
 
 MODULE_DESCRIPTION("STMMAC 10/100/1000 Ethernet platform support");
-- 
2.17.1

