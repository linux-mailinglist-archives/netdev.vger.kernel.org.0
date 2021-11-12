Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA5444E34E
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 09:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbhKLIiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 03:38:08 -0500
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:46212 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234078AbhKLIiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 03:38:06 -0500
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AC7ZLew018020;
        Fri, 12 Nov 2021 00:34:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version; s=PPS06212021;
 bh=p8rVCwZ0S0J7Kg4Qh/a9w7aTAIh3RhDOdzHaitv/auM=;
 b=VXZqmmFi1+U4aRt2j9RvGlThJMdBC8lkzoNygh1LILTFgSy/kT9NzqPx32RHdEhxtsjm
 wGr6Zz0hwNafc5sRuCAas0Ma9pbEMxxJ2X0ObA5WD70n8dGUu8JIWG6LIE6v9v4rxdn2
 Qmho3fNl2R//EYe1f0pVOURq07x4gsPqdlGg4/dGkQ5b8pFi0G4fHnSBExdSMsQ/eCGA
 NKTPzaBeS7qEKmSMiEFTbhTIrJTV5VspfnsqDsYgAEQzYzm1s06yL1p2r5IxScRTo0vP
 UywxUI6LeiThcDYiLCzqyn/dc45qZipyxfRwkN/UIDMxSSk1uTKlfEOhyoTsVsO0FXsP mQ== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3c97bfrj1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Nov 2021 00:34:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QCX6bE7wrevlSj0zL9TuhXTFgyR28/oG2nJECjSO4GeUGK/36QFTaTtGsJs2A+gCYLZiHMxuERTOp/xsVgVGupSdj1U+tcsBsq0/R0ifZGcHpQmS8bwUFPvpuktjO0LQgLfZaRWeDc/M0UfkoX1I37T0BieFHkZrdcQ5Iy32A+xkGlla5aA0379vO9ztVKZACB7TF8v+j+xhI4iNLqTvrXc+gH6i0ocrGoHN7lb5BS7v5eGH8NJv+Kfn/xcC9CSmwbfa+mqkYcfoDtXayidW2CjBYnTVJeBmFNNXmXzC+2JvGlUImkmc09Ns6rZXk5X9wj20PG1av1jQYYbRLMLT3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p8rVCwZ0S0J7Kg4Qh/a9w7aTAIh3RhDOdzHaitv/auM=;
 b=TYT+RZTYTvto46b4m+IrzUJiBKee06oFBQduKhbgsb2EP8MDhwRezxcqQIGXXdRTBj/1ZHmBHxZbGaT1J8B9GHcK0Xe+5Z1JaYBeR9ECnckv1UDJjUa17zpChpqsnGSzefzy2TTDWmgBp/Qe3jlplYoLJ5e0eZHWLd8IMJVt+Ffz7koPBYMN4NcI0a0akGz7unR7pzk2RCEglKqJMhI87NP8GMQh9QEIgzzDPQEqMFc+E7Z8vtN1kLwAU2VWEVVl2wiaU+07R8jyhYQQYBzCp7CICiYZbgo4+SBdPEbiglpc++TJNJ0ECL0I0xlzlGn66u/QlQR0y2ZtfaRkUs3AgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=windriver.com;
Received: from PH0PR11MB5191.namprd11.prod.outlook.com (2603:10b6:510:3e::24)
 by PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Fri, 12 Nov
 2021 08:34:54 +0000
Received: from PH0PR11MB5191.namprd11.prod.outlook.com
 ([fe80::a090:40db:80ae:f06a]) by PH0PR11MB5191.namprd11.prod.outlook.com
 ([fe80::a090:40db:80ae:f06a%9]) with mapi id 15.20.4669.019; Fri, 12 Nov 2021
 08:34:54 +0000
From:   Meng Li <Meng.Li@windriver.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, meng.li@windriver.com
Subject: [PATCH v2] net: stmmac: socfpga: add runtime suspend/resume callback for stratix10 platform
Date:   Fri, 12 Nov 2021 16:34:34 +0800
Message-Id: <20211112083434.6459-1-Meng.Li@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: HK2PR0401CA0003.apcprd04.prod.outlook.com
 (2603:1096:202:2::13) To PH0PR11MB5191.namprd11.prod.outlook.com
 (2603:10b6:510:3e::24)
MIME-Version: 1.0
Received: from pek-mli1-d2.wrs.com (60.247.85.82) by HK2PR0401CA0003.apcprd04.prod.outlook.com (2603:1096:202:2::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15 via Frontend Transport; Fri, 12 Nov 2021 08:34:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 087d1c8e-35d4-4afe-c6d8-08d9a5b74d22
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:
X-Microsoft-Antispam-PRVS: <PH0PR11MB49652D5C1EFD5B669FC5665AF1959@PH0PR11MB4965.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:419;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9N6pzh1wRscqqBRrkYIvYsV5Zn2t/+5sdqXbVqkoCsKn18jhy0ZKgOL2PutVSD+9/sYEzj/KCbfkg122OLgnQFosrpHsLgFZsD7+KFEOIzBbYWfZFvLDPdc6hqP2WjMMjWXFISz3z+Bf55iJp6N9QSodPBVQ9ZapD2TcXlvw2JMkzbB3KTTvwjzKtgSZSNYiygPCge+kwPxJLUL4x4DnVpmNR85dXqRhHjfQp8Il64x+IU/j1vr++1n/pArK8SRxCmda7NKmB1pacUhF5kpJyvy1lnH7dYWG0WnP5utBH2K1MeUnXXyLZ6ai9EPmW2C8hFmQQgH2H1k/m3KOriCrv4Ba0Puwz7F0bSguPhovz/mFGYe5KFOjHcobhKr6M0AUneI2IYbrqQfLgvHE7Ez5WbmoNigvPQAUSM6idXqNTCxzDEetnXH9iqSzJHPgr0OOVepT/7e+FSSrvpibm074hS5W8tqPGsbuwL9VLhzGaiFzRG+UB8Wt64MoHeDdUy3gbTdsHt9b0pHvY6wVdPVOWATvPcjaIyuYkLgdIwOxF4iQqk5pT+2cVnsVxhdj4CykGzjOMnx5DDlq4k7Cg7NW60JOP92CRXPiheAlB19m7zBb60/NraNPOobZcpgNJQNIluUmbEDN2sm1BZa59xft6AqqJgcUQFgXJn3hr05oIRfvPB7bccWYF+EyR7qqjqsMUIuaUEYEnhC4TRygKI2bYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5191.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6512007)(6486002)(4326008)(8936002)(6506007)(38100700002)(1076003)(38350700002)(316002)(107886003)(5660300002)(83380400001)(6666004)(26005)(86362001)(36756003)(2616005)(956004)(15650500001)(66556008)(508600001)(66476007)(2906002)(186003)(66946007)(52116002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7H45z6zt+sT3tcidHCE11fVqhVbwRLODEbN3uNONkPBJZQ4Z9YchsLa28U3O?=
 =?us-ascii?Q?30ismfoObGzDZtPxxYVj8jUqJRxHwrdOLIBsRB6Dl1yZGSx8nM7rMGAAbv/0?=
 =?us-ascii?Q?L4MzhVVcZ4dUaoaE5kuAMsz3SmOYUhjWI93DFFni5KkAjn5e63LoPhbVZsxm?=
 =?us-ascii?Q?+5VosXRbVPQyGRE6yrBOcbsb0ZcbzkxPZ5bg0dxPqJIuUQNQ6OlxZ8+cMULD?=
 =?us-ascii?Q?CzuRVVJ+eI+XCP6gvvRqxAuNE95f9MiH5KJfq/Ikq2I1+7wGwUkCA0SveB6v?=
 =?us-ascii?Q?RI/oHtjiksRSXS2l0gwmcUDxdhpYoBOYgBuzbgdoJkZw4UbyA/dNb2bGcKKy?=
 =?us-ascii?Q?u0dN009QvKyClTVwrGWrMfnA3aPgUV0Rpb4l2PabjEfWWy491zeQss6O4Ud/?=
 =?us-ascii?Q?cfejbLz/yzeDPpe7VrXr9nPS2X1daSNFDjDeXnH5pkyst5Hkd3QeFeWwC1s/?=
 =?us-ascii?Q?BG4liyLCDKoXAwyd3dqrhVHdhLt1g8NnOivGBWp0aY8/0DOtBXGhNVhJncDu?=
 =?us-ascii?Q?dGtFnrmFB+DpZW+gO52ydS+pfsRVplbhzYhtD42AH4uyDDrPhWpgXXBijB0i?=
 =?us-ascii?Q?10doEM/P/xSZo6o2DGuBgQ2f/avibFNH+eY/VsRTpx5BMGFaynAQVhLiJPx5?=
 =?us-ascii?Q?i/AX+qiaGHZkkX+4MRdgrJ6VjD3cfsD+uCURmCZc2fERQFLku9ASMLDactKD?=
 =?us-ascii?Q?2tFuICsJDsLeyUehdnLofhZPBmhW4BFbhVmL/u954+1wrnLd0GazcjQKFHx8?=
 =?us-ascii?Q?itizAFqG5sriKrPQLl0cD66WJvTQtJidb+oIyqA+/nWv9NpVCjmHHl7Wijp8?=
 =?us-ascii?Q?+SNYvRrDHET7y3Wxj6Rv5plBxKyUyuPUirzN+DC+ZUMe4q982QSYUKVK9fa+?=
 =?us-ascii?Q?43prsoArQwYzM8BAhWKuu4HsEX47052ZFVYrb4s19hTg5ciOhdYCDj84G4Jt?=
 =?us-ascii?Q?+H+hu7EsNkc+p2mR1acToDOE4GDzR06KJ2qOfgThA2RQN3r4cbkQGFik4cQJ?=
 =?us-ascii?Q?Awenz0N8jbaWWrQRLd54tqT1QkuGs3rem6QLc8ptLGPyQo59WLvrOH4sM18d?=
 =?us-ascii?Q?bLa8BVgLHOyMN7YeDuuQg2Ga858qN/tf5MADT97ckiq08Q6NJVa2a6sXD+kU?=
 =?us-ascii?Q?4eYeIe/xYy22m1F1bPKlQvEPOLX5FFyxHpnnZU92VBVsaT5dYQexpPFVB9zn?=
 =?us-ascii?Q?KBjQIq91p2oRBtuU8o2ANB1vVffePErlxooXFHJ7OaveJ74hr6kcQ2L3n0iD?=
 =?us-ascii?Q?NfzVp6Jjw2/m1sa4aZb/ew5JHxVAUZGwXWtnyPaPZH60+3WhxZNN7xk9WEpJ?=
 =?us-ascii?Q?0+2YhpnsxP00WB0nywcC3XIdm2/tB9eY/Yzds6/qObuFUCIV74baZbvlYzQL?=
 =?us-ascii?Q?3+fQIrFPgam9YQhUNJjWRcGXYmPatQN+F63yW7UwChnfpNqQQeYsosX3ZhHo?=
 =?us-ascii?Q?q6bFJxX8LwVsEFUAoZo9Btw+tdhHZkb5Hyg/Cofn12Zf4NqGjm+VaHFzvSbp?=
 =?us-ascii?Q?Mq6Ri1iZqPCTezBOOwK8xlGzb4D6wdkoPF3zCgCLsvszutW4brz4ie3bci5Q?=
 =?us-ascii?Q?ypNZvIYE2A6nzR31ICeK3ouHYOOEfIMMOakF/tG981U+OjKVKJY4tYA/FByX?=
 =?us-ascii?Q?FJ/B/FGANhZ/qPnz90bU0zA=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 087d1c8e-35d4-4afe-c6d8-08d9a5b74d22
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5191.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2021 08:34:54.3300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I0y9vwUvVZ0ijee7pLiHMONdSylRnAmtsNMQ2TBx7KyFDiPfUWeidvD/54AkQ+lFHSZ5TkevS/couxDE4rJ0lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4965
X-Proofpoint-GUID: AToL47A_6rqM--CBi2uaCzcITg2hIDEJ
X-Proofpoint-ORIG-GUID: AToL47A_6rqM--CBi2uaCzcITg2hIDEJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-12_03,2021-11-11_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 phishscore=0
 priorityscore=1501 spamscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111120046
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Meng Li <meng.li@windriver.com>

According to upstream commit 5ec55823438e("net: stmmac:
add clocks management for gmac driver"), it improve clocks
management for stmmac driver. So, it is necessary to implement
the runtime callback in dwmac-socfpga driver because it doesn't
use the common stmmac_pltfr_pm_ops instance. Otherwise, clocks
are not disabled when system enters suspend status.

Fixes: 5ec55823438e ("net: stmmac: add clocks management for gmac driver")
Cc: stable@vger.kernel.org
Signed-off-by: Meng Li <Meng.Li@windriver.com>
---

v2:
 - add static when define socfpga_dwmac_pm_ops
 - add fixed tag
 
---
 .../ethernet/stmicro/stmmac/dwmac-socfpga.c   | 24 +++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
index 85208128f135..e478a4017caa 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
@@ -485,8 +485,28 @@ static int socfpga_dwmac_resume(struct device *dev)
 }
 #endif /* CONFIG_PM_SLEEP */
 
-static SIMPLE_DEV_PM_OPS(socfpga_dwmac_pm_ops, stmmac_suspend,
-					       socfpga_dwmac_resume);
+static int __maybe_unused socfpga_dwmac_runtime_suspend(struct device *dev)
+{
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct stmmac_priv *priv = netdev_priv(ndev);
+
+	stmmac_bus_clks_config(priv, false);
+
+	return 0;
+}
+
+static int __maybe_unused socfpga_dwmac_runtime_resume(struct device *dev)
+{
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct stmmac_priv *priv = netdev_priv(ndev);
+
+	return stmmac_bus_clks_config(priv, true);
+}
+
+const static struct dev_pm_ops socfpga_dwmac_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(stmmac_suspend, socfpga_dwmac_resume)
+	SET_RUNTIME_PM_OPS(socfpga_dwmac_runtime_suspend, socfpga_dwmac_runtime_resume, NULL)
+};
 
 static const struct socfpga_dwmac_ops socfpga_gen5_ops = {
 	.set_phy_mode = socfpga_gen5_set_phy_mode,
-- 
2.17.1

