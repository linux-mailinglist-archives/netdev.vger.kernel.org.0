Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8504045685B
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 03:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234273AbhKSC6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 21:58:12 -0500
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:39934 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232456AbhKSC6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 21:58:05 -0500
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AJ2l62g008471;
        Fri, 19 Nov 2021 02:54:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=PPS06212021;
 bh=x5CECifakkgNPuaQXYfAOMgLNH9OMdw6+RD6GpLtnxM=;
 b=dVUj4+gd5QzefNgix6BGsxZ8sxSiNjMPZNkaCZ6gAiscfqlvBdAjK+GW/tENVWMAHFiK
 Mnu06AZHaLYpADnVxzSuWd9ZXupGl4oerZLlnN/A5oCP2JAMzPNls/KwIVMTwV6NMUPK
 qKudONROIRZBaAYIRftN88xP1NxoXImZD94M8f3sr5yJ/5RUAR4KI/LGCk82F/6zg3G6
 l1XXxT4zx5keaFwy45PBpzSgf7TG0kbXESvosZqZxg608KHHwjdlOBM+BUHkrQmw4QRK
 DnruTKRyN6s6QEXwqzJYdVBJwvB1+uia41WlVgCQU29ynBAhgfe5p+2NsREoq+udU2IT pA== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3cct5mhy9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 02:54:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Afgje+0D3Y94pk+qSz+4vRuNERjmgqU8uKorsW2Nes4L3jDFlNf+vfNpdAHuFr31FCjFUWVUkZMNhHzRyTKR/jlrU2AYAPDzHC3w+KlgATu1CZwZbmAiWBPWj6aDATTkUFM4PVnaY8doZXwfz61mS/CeVYaINbw57QZexX9OywQB2w+HJ3OV+3IbqbvMXyQVmtNthoXFkAlUt89g5ddxj37hkADxSMeQLwUBziX5QDQnZzROT26S5lxOP0TmVE7VO+jqj2Rn011Y+y4SnFuP9JGoKjYbHHlKGYD+9bWJZtDZDwwEOislAGVckeuUXRfitzjz0fKVwWJiJ18RaKBH/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x5CECifakkgNPuaQXYfAOMgLNH9OMdw6+RD6GpLtnxM=;
 b=NEpumUaASXuQqM8xeVJ4nbdVNOgXI6Y3OFxZ/RhL4RpB8MRT0nBFapVLYhO4kYwS+aM2QY+RMO1aohv2jefgehYzHhnjsdQh2qD4tLSxydrz6U96+L5WwzAHwCNrBevlUYLQIpV+Z/4TZhTSWvT7k0BaW5M3TfNXyO53A60jbW1pNOqoPtxh8vat90J8DZ5KmCbu5/cqCzaEbJrQFH6c4fWO/GB7OKgjaVByy5ZYzDKvpXEIjFX2m83gspVNFluiyoNa8osVshf7kpfs1tQDBJYGo4J4ZWFtg2/mHLVFjs35kZY5SEqTv7AQnrS+RtGkjB685/18bUl++7QK/vENFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB5191.namprd11.prod.outlook.com (2603:10b6:510:3e::24)
 by PH0PR11MB4951.namprd11.prod.outlook.com (2603:10b6:510:43::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Fri, 19 Nov
 2021 02:54:27 +0000
Received: from PH0PR11MB5191.namprd11.prod.outlook.com
 ([fe80::a090:40db:80ae:f06a]) by PH0PR11MB5191.namprd11.prod.outlook.com
 ([fe80::a090:40db:80ae:f06a%9]) with mapi id 15.20.4690.029; Fri, 19 Nov 2021
 02:54:26 +0000
From:   Meng Li <Meng.Li@windriver.com>
To:     stable@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, linux@armlinux.org.uk, andrew@lunn.ch,
        qiangqing.zhang@nxp.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        meng.li@windriver.com
Subject: [PATCH 2/6] net: stmmac: platform: fix build error with !CONFIG_PM_SLEEP
Date:   Fri, 19 Nov 2021 10:53:55 +0800
Message-Id: <20211119025359.30815-3-Meng.Li@windriver.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211119025359.30815-1-Meng.Li@windriver.com>
References: <20211119025359.30815-1-Meng.Li@windriver.com>
Content-Type: text/plain
X-ClientProxiedBy: HK2PR0401CA0017.apcprd04.prod.outlook.com
 (2603:1096:202:2::27) To PH0PR11MB5191.namprd11.prod.outlook.com
 (2603:10b6:510:3e::24)
MIME-Version: 1.0
Received: from pek-mli1-d2.wrs.com (60.247.85.82) by HK2PR0401CA0017.apcprd04.prod.outlook.com (2603:1096:202:2::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Fri, 19 Nov 2021 02:54:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05056d73-8b98-444e-6966-08d9ab07e655
X-MS-TrafficTypeDiagnostic: PH0PR11MB4951:
X-Microsoft-Antispam-PRVS: <PH0PR11MB49514CA8D5AC1B895130372EF19C9@PH0PR11MB4951.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:289;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kITfmrNH7sDsutV84Ajfu7x5mpIxes1NLbV3/e3Uy4VVyR/cTbbkFZafZ4+P5RzOiiKA5X46hoiVoa+3jPt0Lvxy2kGmuTQdfd1YtnfVtFOEd/QWYYtK88rVQac478jU0DW0UkqeyqCmPSDjT1bkV/sP/hrv8Bi0i/BAHk6chal2c9spSfivGn1imrw1vv4Y5Yb8PVhQ8e9ngaeOWb8sk3okdg/vDW/4pplPmk+exajtlNhtpLQc4jvKsmT+VcLYitYXGjlJAIrwGI+GVITdHcd2AgTodGKgMMR9q26jMJ7dnkkiXENVoSFTvO3ZxbnTGldBNFR833sojFOmDiG7gPSC8EnCDteKQYfm4y2KWCNtpSXIrh9n6OV/QK5k5JdtwZx/GQaEQALCIVtLJ0a1uWL63+j4RZXeP5AhkyrnDzF0WFHefZr9xPpE5mojXU10hocOFiXYOX4e9GqQcP1fw2J3b4f24XSBvVVKsEkfbo1HAWQGeKPU/+9CoekhuHQeSCUmGu78FD5NiRRPa0GtsgXyX9CVMF26zIaFi3uIeFdVXEj7RUWcx86EdzRonHEkQcvsiSSOdXRuxvuTOM7X4germJih1pJj+YqYXLM38kbfZmDD1grk9iWmdXKO0VVAy+lfdyyOGueAjiDLrQN5/G50qhAI4bxsB8s+NMwHfC7QkSoTTVdbAURLecoFxrRizi41Emur/KSeqOJT1+dHQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5191.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(83380400001)(5660300002)(186003)(107886003)(6512007)(4326008)(38350700002)(38100700002)(2616005)(508600001)(8936002)(1076003)(36756003)(956004)(52116002)(66946007)(66476007)(6486002)(2906002)(316002)(26005)(86362001)(66556008)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DIhkEtJ5MrdHNK1NQVOqOS/eZGTDhMFQkwssE1/714GK4w8vvyeFwdxgXMu9?=
 =?us-ascii?Q?EZrR/e8FuTjcpx88vlT4qgjGfY0+s9d1F+o6HaJSuezbitdkNrgG07G5/gTV?=
 =?us-ascii?Q?uNMWKTJb2BypJT08bIyAIOdn0WnHvNjUqlLeOOInE9xFHXOXUOp7m8VA0Nrk?=
 =?us-ascii?Q?PjhviFMHX8GAZCp5RIv/q6IYldg4XT07ReZwtUAcECCIkTeAxgpv4UeGKgjW?=
 =?us-ascii?Q?7F1GJKRbrUJxWzB9czOxvaMnAz5uC4MMFIWGSEXNXNoyP//qNGLW1gaMJV6U?=
 =?us-ascii?Q?qD/q6F45KCzVzszF+kYwn3lI8ZbYiXD3nrdJc/nW7piaitxlC3FWyaDl7rRm?=
 =?us-ascii?Q?LX8Hv17dfW9IQxqnPPYQV/NHEUHHBU4drb5mMYBExTTw+PKOjjlErQym7cPY?=
 =?us-ascii?Q?5SBIDKv8km3FM7rMAOixXakpCc1ar3jdNbfPJ+rdr63dhzz5c+bx+Hf2Iles?=
 =?us-ascii?Q?EJxS9N3z93wM53KoDLCjBOkmTmr8rR2GtoGJ3B5JQf/PwftYDIl5xaBN6Haf?=
 =?us-ascii?Q?//ObqrVW7DJl+WPBZP0bixp3uSzNI+0ynsdl+E+WveS5TbY8XK1MGqX7VYFj?=
 =?us-ascii?Q?6xSsL+x4Fl3fHPU9QzbZYoAz+Ru2jvw9PRyauR8fVwG1OKhWddGJmY1Sv0/C?=
 =?us-ascii?Q?KzBHgwbJldP3HX5CRK0lQawlwLS7A/mEG3b9nMxswNC5ZHrsWgx4rc3XUUgH?=
 =?us-ascii?Q?3AVjcvMuwjBsTksVqiHV92KbqkBJFWsBTLYrBMZ5gLeSZ6nkxvjRuPZHDirf?=
 =?us-ascii?Q?AoCjzRS75SYFmLBEDACtdSeMOqyEXZ4gByaEl/fRRbe3ijM68pgQdA9Dv7f5?=
 =?us-ascii?Q?6qn5RROgpk80sX/+3TYUssPQWv0igxV12wZcgVpVN5J0m8+haobQadwEBkqa?=
 =?us-ascii?Q?XOviMntqRWEX3ZoqBoBJLk6qFpFENZXK84EuFlRiYJ1Y8Ta9HjhgxNuMjar8?=
 =?us-ascii?Q?CQ23t4MoSYkROPYX6D51ubBp9+VsiyqHWTyaM2ii+upX+cWiGsgHg0hKO2LO?=
 =?us-ascii?Q?D/PctUBBWyn3NsrUxxQYM4U5gYlj9jPAm/6bjRKB44xwZZZDOu6VndJyu59F?=
 =?us-ascii?Q?lV3ALMESmmTYA7c7B6uhGh7XBO7+YLfFkZPfqXMs2ExCOTrCEzjwlvAW4RGV?=
 =?us-ascii?Q?gT5svrC1vLJHyana/LwcA1XqgBr9fLT7Wcl6VXKlMyjjLDWnatweAydKev7D?=
 =?us-ascii?Q?488oUE9OIdzQGfnzuSziY9SiG7KTSuDzkyP6pVf5l/Ysm7v5/kql/6kxXqao?=
 =?us-ascii?Q?3uoIPvJR6MchUCXtoZhAy5/seaarXkpKmu9TV8RHv8lh3QkX+Gn3C+kg+DyW?=
 =?us-ascii?Q?l4G5r/0Uvxj1hFTbOn3bnnLh21lp184mkovwDAvWOH4VIaHIEksnYRMfLbkD?=
 =?us-ascii?Q?H4snDjjLmcmrw+shfjIJ7frJK/pFt6izOtsLQHF1/915W4DTZ4LkvgnwVKaF?=
 =?us-ascii?Q?mM9dm4xUubMjoT7OKI0ZHAQnxrXiZ9N8vQpJ13T2rNB3UP2OX95LyxMi0hgG?=
 =?us-ascii?Q?yALIB1NnkYH7KTl/NfKaysxLo/m5JYtgHDyFNc3SVdgqAYFVLkjs32gqJIof?=
 =?us-ascii?Q?KvzfG0CYABEFuCgLzgjBjU6LWEWXGin3+DaXNzdOse5mhGhHosNIhV5iApjJ?=
 =?us-ascii?Q?sgQwrfSvhHhupWz0AKTAbIY=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05056d73-8b98-444e-6966-08d9ab07e655
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5191.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 02:54:26.8477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v3gGO25lOwCW3rWtL6hT7H8uehrYcKSIfy9UK6YBLRftnR6kgWNaWBFPGfyC1JRwahN0KPTaL6CEYFOhv+UWMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4951
X-Proofpoint-GUID: AuoiQcD_AgojlDxR3dFSwA2GpFcReEMw
X-Proofpoint-ORIG-GUID: AuoiQcD_AgojlDxR3dFSwA2GpFcReEMw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-19_02,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 spamscore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111190012
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

commit 7ec05a6035480f3a5934b2b31222620b2e906163 upstream

Get rid of the CONFIG_PM_SLEEP ifdefery to fix the build error
and use __maybe_unused for the suspend()/resume() hooks to avoid
build warning:

drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c:769:21:
 error: 'stmmac_runtime_suspend' undeclared here (not in a function); did you mean 'stmmac_suspend'?
  769 |  SET_RUNTIME_PM_OPS(stmmac_runtime_suspend, stmmac_runtime_resume, NULL)
      |                     ^~~~~~~~~~~~~~~~~~~~~~
./include/linux/pm.h:342:21: note: in definition of macro 'SET_RUNTIME_PM_OPS'
  342 |  .runtime_suspend = suspend_fn, \
      |                     ^~~~~~~~~~
drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c:769:45:
 error: 'stmmac_runtime_resume' undeclared here (not in a function)
  769 |  SET_RUNTIME_PM_OPS(stmmac_runtime_suspend, stmmac_runtime_resume, NULL)
      |                                             ^~~~~~~~~~~~~~~~~~~~~
./include/linux/pm.h:343:20: note: in definition of macro 'SET_RUNTIME_PM_OPS'
  343 |  .runtime_resume = resume_fn, \
      |                    ^~~~~~~~~

Fixes: 5ec55823438e ("net: stmmac: add clocks management for gmac driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Meng Li <Meng.Li@windriver.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 332afe8519f4..035f9aef4308 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -720,7 +720,6 @@ int stmmac_pltfr_remove(struct platform_device *pdev)
 }
 EXPORT_SYMBOL_GPL(stmmac_pltfr_remove);
 
-#ifdef CONFIG_PM_SLEEP
 /**
  * stmmac_pltfr_suspend
  * @dev: device pointer
@@ -728,7 +727,7 @@ EXPORT_SYMBOL_GPL(stmmac_pltfr_remove);
  * call the main suspend function and then, if required, on some platform, it
  * can call an exit helper.
  */
-static int stmmac_pltfr_suspend(struct device *dev)
+static int __maybe_unused stmmac_pltfr_suspend(struct device *dev)
 {
 	int ret;
 	struct net_device *ndev = dev_get_drvdata(dev);
@@ -749,7 +748,7 @@ static int stmmac_pltfr_suspend(struct device *dev)
  * the main resume function, on some platforms, it can call own init helper
  * if required.
  */
-static int stmmac_pltfr_resume(struct device *dev)
+static int __maybe_unused stmmac_pltfr_resume(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
@@ -761,7 +760,7 @@ static int stmmac_pltfr_resume(struct device *dev)
 	return stmmac_resume(dev);
 }
 
-static int stmmac_runtime_suspend(struct device *dev)
+static int __maybe_unused stmmac_runtime_suspend(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
@@ -771,14 +770,13 @@ static int stmmac_runtime_suspend(struct device *dev)
 	return 0;
 }
 
-static int stmmac_runtime_resume(struct device *dev)
+static int __maybe_unused stmmac_runtime_resume(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
 
 	return stmmac_bus_clks_config(priv, true);
 }
-#endif /* CONFIG_PM_SLEEP */
 
 const struct dev_pm_ops stmmac_pltfr_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(stmmac_pltfr_suspend, stmmac_pltfr_resume)
-- 
2.17.1

