Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D454446D79
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 11:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234007AbhKFKrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 06:47:20 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:64914 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230219AbhKFKrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 06:47:19 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1A6AiZRp022147;
        Sat, 6 Nov 2021 03:44:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version; s=PPS06212021;
 bh=FDzLOglzS/mqXmCHZRrfaQQjN+Z2GoNOo1aDtZaLflk=;
 b=VpchAELxOpmhypyB5wx9flyOXqMwvenc/eeDyJ/b41mKsXzbrAO7ORTbXWOE2jUH/I/O
 WsGwLN1Yuy1A+kkcPv+KMNw0QdCRWGNMp9Xbxrx77aKwklSsMMAJWJ3hmKwuhxfUlAnU
 CdSt1l2m9utx1PQDw3G+E5cypAg3adbEYajGons3z1EY/R+5rZhYcrWpGpiIVA8xgken
 XxaEH/6r/9jXp1rZcq3EcA53MlSkQ5WfbgvxuvDLDrmnDQNi9pKH8EU5ePXHHV/MIf/c
 oJqsijT4S+tn9P9VPI0QGTGeDQSJH9BUpu2fljpFyc4+QBRDU6dtKRoE7IutPP6yr/mL XA== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3c4t31s719-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 06 Nov 2021 03:44:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nb3+cRRtxjSs+SSSWaR3duAJtMXF39GMQyVmSecvWjy0heufdhepCI21Rf4zpB+/uLp1GV3wiY4YxX/t31rCxlTHiup3tudzgxSNPZLlt+T9TVzTDtsixNnHFwj5UKG3Nkxp1uGe9LL2AGUtb1oDNGlKz4ZkkoXJ15K6v7bcAOb5jjl4DnW+Frn31TwO/oB5YOoUyqQwnkKiDdhypHR62eEiBBsg3C8Am5NbGPaxW4hv3k6Jhz/eozEZD3ycHqF8OIoaKXey97+EP1qEo8dIWu7cgXAHm5M1USX0gZHH3Wz32pBx9hUKQw6foc6JmafQ1l2jLbFscmesPu7T70q4dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FDzLOglzS/mqXmCHZRrfaQQjN+Z2GoNOo1aDtZaLflk=;
 b=BFyM5HC7vLCsKBo+eOBFiJ2hAUR30hg9HJu7vwu5NOpubGeEEWeok4Hcacgnywi6nxzrIIzyyCYLm11C60ey4aqfL8irOlytpTTPKDfdcoWv6K7hGz3+3pKo7/1IKGWWrG89WqCLO/mEuI3W3qjBZN9oVU3ZEoEP3L+oNb5tTSrZdOh+XZgnRQs9QgC5GSBPEfen2dGH9qv0HIthiGWmMtIxUOZdRNQhXd7056Y42ZnXGRy2/NA1+R3zqav2fQvGRspLFkByO3Omj4O0zmRG1tAG3nAivM1OTiJR5gdx+l+OhezE41i/brBMLPRTcvBikd7si4NgqlgXh0/tRyjiuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from PH0PR11MB5191.namprd11.prod.outlook.com (2603:10b6:510:3e::24)
 by PH0PR11MB4950.namprd11.prod.outlook.com (2603:10b6:510:33::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Sat, 6 Nov
 2021 10:44:31 +0000
Received: from PH0PR11MB5191.namprd11.prod.outlook.com
 ([fe80::a090:40db:80ae:f06a]) by PH0PR11MB5191.namprd11.prod.outlook.com
 ([fe80::a090:40db:80ae:f06a%9]) with mapi id 15.20.4669.013; Sat, 6 Nov 2021
 10:44:31 +0000
From:   Meng Li <Meng.Li@windriver.com>
To:     stable@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        meng.li@windriver.com
Subject: [PATCH] driver: ethernet: stmmac: remove the redundant clock disable action
Date:   Sat,  6 Nov 2021 18:44:01 +0800
Message-Id: <20211106104401.10846-1-Meng.Li@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: HK2PR0401CA0007.apcprd04.prod.outlook.com
 (2603:1096:202:2::17) To PH0PR11MB5191.namprd11.prod.outlook.com
 (2603:10b6:510:3e::24)
MIME-Version: 1.0
Received: from pek-mli1-d2.wrs.com (60.247.85.82) by HK2PR0401CA0007.apcprd04.prod.outlook.com (2603:1096:202:2::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Sat, 6 Nov 2021 10:44:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4bb5ff10-638c-41f7-62f2-08d9a11269e9
X-MS-TrafficTypeDiagnostic: PH0PR11MB4950:
X-Microsoft-Antispam-PRVS: <PH0PR11MB495001FBCD3A713A7C06B8C6F18F9@PH0PR11MB4950.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bJ9TrNxK5oPWV+w58IyMTrcZRAQ5bqhZbkLd5p4Xk2uAa5zE7lGo8PP18bCWZV1DVc9Np29EIvS+5xHlRKIcmmqn/E1co/9epjpJrpvSPdrEZRKgB0Uls1IJeBvZch3sbIphKFJhgIMBFGJ2YNtOyfWGA09FGFdqlT06FAumnabdewHVmIulEoPh5Oypf5ixHl/j+ZRGss9yQwXy4uzvdXi1AdlHJU9nudVAOZO8IllrUsUL+GoEM+1M6trR667tyUgFz6GSiEmebaEAoKhtf1zvophuBjnlIJTl6Ps4S+CjlVmxUxx3ufCRG+GrfHTFCr5WCmpnvs48H+tdnQ4rJ1IpYg9RNJ4mHtOIQXvXyDlwVz+1CF73DAVF/BvaNN/5cQLpZDU8uooX8pNxMKFokh4QaaFv4atfj3TGO6+xBUDOH4qSMbJhb3RDi2NWUgeaM3e7nhbAncK15edpjyZc3z+PAelWStEQm3+1RJyW2pRJM9ujSd+cEIQkWJJIMBtkD57NhzgHisus5B49Ks+kiF6N9qWYYxHDGE4LRKNT9WY+hePu0/+jK9AvXlt2ouHO2lZoujWVmxKepkIKlbmmh6hUb7cxJ2/vio+SJ9mJKa5rsgFEf74dTdrJ4B4lOuUT/+c7dxr5eJHwmjnTjv5v29VDpOH4qDN/VPXVPkzRTIJDziw1/cEM0jn6HFOng0eS6ZP5ghl/jpZIgsfMkuXgiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5191.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(2616005)(66556008)(52116002)(2906002)(66476007)(316002)(86362001)(45080400002)(66946007)(5660300002)(83380400001)(956004)(38100700002)(38350700002)(1076003)(36756003)(6666004)(107886003)(6512007)(508600001)(186003)(8936002)(8676002)(6486002)(26005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zUo5ZBMowHN4oN5kDHpS/BbPL8yx0g3A5zFIi0/vdTBCQF0f2aOnVirZQozp?=
 =?us-ascii?Q?lVr6in3Rsv2Z96GytlpR4a8OuFSqTxtYgeGUSsJ0YkbuatFNVhS5Vhq6Oz4c?=
 =?us-ascii?Q?vybE6Z7cj7jcpTj6iaynux7XAiwOKMYeYFbkz8m/yxA1FFKMUUCfnLC1d39Z?=
 =?us-ascii?Q?wfoH9zL4B/9avmd/LFt1x4afGkEMuK3jfxZK2HID/jKjcSuMZNcGCurhhFWs?=
 =?us-ascii?Q?VG6Fy+lwVhTxGMP0SZDmSTCFRKO4tKpVkaqS64zCGdAbWhq8GxGwzZWv1vRq?=
 =?us-ascii?Q?P+8sM7JgOi3XZmNy9KjbVEl/2eOEQv5s2jvHaYuWuJGDURzvJZt+FZt5NkGh?=
 =?us-ascii?Q?tWeTc8/NdNE9kycHz+jBSOhvL4YWozIK9+npQnDCQBcC9hgbJFLaIN/w6O1z?=
 =?us-ascii?Q?hfX5dWd6vm15TbJO5bpOGzMqvLO+ecjXEEj0YRaMJQ6zQCXOKn2cb4H/KLeE?=
 =?us-ascii?Q?a7oVeKaUq6OPZJdwHJW7vTn92AEKza1sKYQWRC2mU0cXzgulVC5XU9DQzylp?=
 =?us-ascii?Q?pKHyfLcNciySQ/PgeCErriHsh5rIs4NoJvSCdu5c2oTf7aYHMC9wWvfpCRZo?=
 =?us-ascii?Q?oZqfbg6y84ZzXpcJUwTwlD1bbDNFL9CEjvXRcaaG0UXTqVONYQBT6+2QawgP?=
 =?us-ascii?Q?+ix4fZVDX6rH6NoaWkbDCKECOtist89JHpBTPgaJGv89AxmDIl+5PonDt/SI?=
 =?us-ascii?Q?2JypsSRUENMX/b9WP1AkTYb7wl9mjDXQmwQTS6RiVXj8He/j3m6oqbOUOEpL?=
 =?us-ascii?Q?YbrO+0UGN+NzSaj89AzB/m7/PObhbVFKHWD3UaAcd8RVQ1zaoszyDz5YTJ0p?=
 =?us-ascii?Q?qHuRcjjrEVemxF8EllvxKUYRz4vc0kdKDAnOtqmpy2meC6sDnFjV300M+a+Z?=
 =?us-ascii?Q?CIilZ8h91XslzyJInmnuAnO3spmoEpSj2AyKLGVbrvadTVpaKpdXeSJ5XmKR?=
 =?us-ascii?Q?WKuto+kygHxW0Sf/MR5BzQUzINYxl+7QLb6OY0drgYENGLOxtebqZVVDzAr+?=
 =?us-ascii?Q?nYumN0ByHgfhNjCvWRyh71OJN+B5GcDglyXpYgdlae+7qf4RldieZro0bJMU?=
 =?us-ascii?Q?1rQAUbkk//gcd+VLRqa1HwxF49DU5fiwoJ6vRISuvg4GLCJ4rsP29fVRYwQk?=
 =?us-ascii?Q?G0g6FWqGM5d6jlVzUNRuc0KZQ4oY2bjLwC5FlRMK+GaYN+QxLm6zJoiyFRSz?=
 =?us-ascii?Q?QWXVwcgDS8+uYvV9fF9yYZxeIMV4R4wPwIbnhcDBSmwxiwA4LprCTvgCX14Y?=
 =?us-ascii?Q?vY4oINFA49qpQvMP9n3vlrT4MfcXabqtuKeiG35VdOeo6wm/hbe1lJ0VG+hT?=
 =?us-ascii?Q?B8GQifAGJzVnN/KnqALeqXyACBc8vCLwpE1g8afIzdAJWt/ohW339eCopbM2?=
 =?us-ascii?Q?blNM5m4l/Rr2Xe9IcuyU2rd81u/X5cqmFawVKtJ1lHKa47tjfLzSN9vT+nKN?=
 =?us-ascii?Q?r1/x9p9bJ1T7pY+qe8tkwYpT6kx+38PumCOF3CY1HsjMF18SXjnc6DD4aRxg?=
 =?us-ascii?Q?cMfmvqPQL+vYq01tF0FLNRovGbkzEGbWUh3VrzElK8jTrJUZw3j1Kwi7jEId?=
 =?us-ascii?Q?er8jFba9ZjJ7kP2qf0TaeOsfaa1vNZO7v3hDtVN4/dUKDI6MgPVYMC39wRgf?=
 =?us-ascii?Q?sM6BDMOyWjywYna78HMKoxA=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bb5ff10-638c-41f7-62f2-08d9a11269e9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5191.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2021 10:44:31.0222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W0RC8CgZpdTtzQmrOxoLxhBVrFuNye4AXyzneP+13xQZbAcFOm4SZF6x4EwXzuJOOEePIqwsDxWNiXWbYxgsLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4950
X-Proofpoint-ORIG-GUID: cWDHNPRcimXpA2jnkMpGJRlFL3xQJqr_
X-Proofpoint-GUID: cWDHNPRcimXpA2jnkMpGJRlFL3xQJqr_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-06_02,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 spamscore=0 phishscore=0 clxscore=1011 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=953 bulkscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111060065
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When run below command to remove ethernet driver on
stratix10 platform, there will be warning trace as below:

$ cd /sys/class/net/etha01/device/driver
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
Because clock has been disabled in function stmmac_dvr_remove()
It not reasonable the remove clock disable action from function
stmmac_remove_config_dt(), because it is mainly used in probe failed,
and other platform drivers also use this common function. So, remove
stmmac_remove_config_dt() from stmmac_pltfr_remove(), only other
necessary code.

Fixes: 1af3a8e91f1a ("net: stmmac: disable clocks in stmmac_remove_config_dt()")
Signed-off-by: Meng Li <Meng.Li@windriver.com>

---

Some extra comments as below:

1. This patch is only for linux-stable kernel v5.10, so the fixed commit ID is the one
   in linux-stable kernel, not the one in mainline upsteam kernel.

2. I created a patch only to fix the linux-stable kernel v5.10, not submit it to upstream kernel.
   The reason as below:
   In fact, upstream kernel doesn't have this issue any more. Because it has a patch to improve
   the clock management and other 4 patches to fix the 1st patch. Detial patches as below:
   5ec55823438e("net: stmmac: add clocks management for gmac driver")
   30f347ae7cc1("net: stmmac: fix missing unlock on error in stmmac_suspend()")
   b3dcb3127786("net: stmmac: correct clocks enabled in stmmac_vlan_rx_kill_vid()")
   4691ffb18ac9("net: stmmac: fix system hang if change mac address after interface ifdown")
   ab00f3e051e8("net: stmmac: fix issue where clk is being unprepared twice")

   But I think it is a little complex to backport all the 5 patches. Moreover, it may be related
   with other patches and code context mofification.
   Therefore, I create a simple and clear patch to only this issue on linux-stable kernel, v 5.10

---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 53be8fc1d125..0fb702ce2408 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -706,7 +706,8 @@ int stmmac_pltfr_remove(struct platform_device *pdev)
 	if (plat->exit)
 		plat->exit(pdev, plat->bsp_priv);
 
-	stmmac_remove_config_dt(pdev, plat);
+	of_node_put(plat->phy_node);
+	of_node_put(plat->mdio_node);
 
 	return ret;
 }
-- 
2.17.1

