Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0B144FEFA
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 08:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhKOHII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 02:08:08 -0500
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:22892 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229780AbhKOHIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 02:08:04 -0500
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AF6wuc3021157;
        Mon, 15 Nov 2021 07:04:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version; s=PPS06212021;
 bh=SMMJ6I2xKwpW9ucyu2HeQXwSMFCnAuPrToLR550oqCM=;
 b=K8NvO+Km7dJvmpjgA8oCVJjcj0fcEYDRr1Cv+vTxe67BTTOUFLSapPSWC8fVlaHz37Yu
 2ClSL73sGmxPXZX6JzCBXvlSVRVKg5AkjWwkWTo9kbT6K3v563DCqdZyuFE6Y78THB4Y
 OH3SUFkYtYc7mjvcxmnVmhKdkOrrpMg7e/GIsvFtyXN63X1sToUthScmQU7Jk2mSM+tp
 eQpd45V+pNqxdoLItBvVKZjycpsfljnShk0Db/8OhA0CD6eiwTjG+L1RUzuh84YZRgSS
 vWLyBwajgG4ZFunlIgr5WARIc/ofC944SDMtcl5IIlsY6TR05N7hn9nwZI/O6v2RzXBN IQ== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3cbg66831s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 07:04:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MM5kDSQPC3ZGXUJTBZLwgaSo8EZbBVsTPt/7ZkWGJSROlhCXCgia8AjpTDRAlDxwWaNLtzxzvwC8ZnejX0AB18UmGz3NUcDqv4qmTgOfaXfrCGxcHZPiwUZWNu2CrAAh1hgZ05q3Aip7R10UygjWQjRBy26y036MSPNtTAw4vEaYMxW0kwu+I6tJrd4/jRIPyPyAEZKejw2fxAN9EuzCe8/x2rsoc/80yr8iwrtJCPUE+tvrIqaXRkaewHIWOedeApcmAU9Wb6dqXF7ZRIGQ0oymGUs1GGDoXCmq67scRcA3MkzC8GGZmn/1dNM0Vob2dqfymwMYGr8/oXT99kn8yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SMMJ6I2xKwpW9ucyu2HeQXwSMFCnAuPrToLR550oqCM=;
 b=Jo1wIXEmI+z4OYQVN+4d3LEqlFwSo3dRP/g9XuF9ecjcN8gcM9VvIwm32PuqOwghEpbLR/yaEeIo7BWxhKbjQfyxOgsiJPLrTmRVa7xgjGVvVdTttKUY37MoKAmOgrMwi8/vDZd11w+33SKMJ9B/mnKBYGr6BMnqx6H7C61xYCVewl1Vprgb+tKjTQ74ybJVQ2doE6tJVzI3aS5oU67aix3uvx5kuEnjh17C3X3JIwwhH8et9Omc6WYjS11uFpfnO1Me1zJxwJEiL3TYgd93ZjJENj+D9Bb0j6R5ExaZUBau8wy47gDtXBIdp1pN1RAQB3iucEtOEouRYfOVny9Qgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB5191.namprd11.prod.outlook.com (2603:10b6:510:3e::24)
 by PH0PR11MB4981.namprd11.prod.outlook.com (2603:10b6:510:39::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15; Mon, 15 Nov
 2021 07:04:40 +0000
Received: from PH0PR11MB5191.namprd11.prod.outlook.com
 ([fe80::a090:40db:80ae:f06a]) by PH0PR11MB5191.namprd11.prod.outlook.com
 ([fe80::a090:40db:80ae:f06a%9]) with mapi id 15.20.4690.027; Mon, 15 Nov 2021
 07:04:40 +0000
From:   Meng Li <Meng.Li@windriver.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, meng.li@windriver.com
Subject: [PATCH v3] net: stmmac: socfpga: add runtime suspend/resume callback for stratix10 platform
Date:   Mon, 15 Nov 2021 15:04:23 +0800
Message-Id: <20211115070423.6845-1-Meng.Li@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: HK0PR03CA0108.apcprd03.prod.outlook.com
 (2603:1096:203:b0::24) To PH0PR11MB5191.namprd11.prod.outlook.com
 (2603:10b6:510:3e::24)
MIME-Version: 1.0
Received: from pek-mli1-d2.wrs.com (60.247.85.82) by HK0PR03CA0108.apcprd03.prod.outlook.com (2603:1096:203:b0::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.19 via Frontend Transport; Mon, 15 Nov 2021 07:04:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c10b091-fd33-4bcb-40fb-08d9a806314e
X-MS-TrafficTypeDiagnostic: PH0PR11MB4981:
X-Microsoft-Antispam-PRVS: <PH0PR11MB4981AF0A7179C065B7E17D36F1989@PH0PR11MB4981.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:419;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BuqAupyPcnzOTguILoB3ZeFIWwlkFPqqYNqEPqg6H1/KkKmylOU+buzQs67dXOUXv1BAq0593sqtIgKjro1qWfI3EzCJorA+Xafdq7lwUHgBU9yA7BhFBT8wTB6RaTQKhBa2SMKSA3GWI7luu/qRxo8BE1qR4eeIb2YI68l8HuxPMHKU8L8Yh5j03hXb+b5SUOsTYTRMx4v8Z2s+99Uurj694td1KL3L9X1jLapyNQPH1Oun6X2KoxsGgDWB4rS5li3NAp2bA0fBr3W2izKaojAVSEkBFTkMwL47nRkwJRrAYuwgba7rnspLBRcQTJXQlfMrtEXshtjsBZDoo0sh7uIB6THAtpYDk59KBtJcDN/3oaprKHNRwbAJHqtTstkpB2A9y6r2e/dU8zbv1Q9h3fPZSs2UH3xoonBetPATsMKy9l0VxqEL94ajC+5vJc/Jkl7ETA4Sd16aRZHh7imAajlpvg7LhuELcWgxpz1uOLUCGOxpLxvfUCe9JrL4SKsUdejSRUUqEXI52Ze5t8CBPUf84LJhGUAHtOL9qDAsk8bK/bLLQ7Lio6T2qU/wiKWgG6vmAUSVgpXqW9YfGlGwRe0VfWPEn/yzPr0BeECnhfWy4sQZXfH+wNw64mS3IUBkLT9DlCltoCq93mzJJob0dWsePA0PRw2Y5dBccTAOVPa2jqYM8Q6Qnsid6PCfmdA362gqwFfbT23wssfFJzvSdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5191.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(956004)(1076003)(66946007)(66556008)(6486002)(66476007)(38100700002)(36756003)(107886003)(2616005)(6512007)(83380400001)(8676002)(26005)(6506007)(38350700002)(186003)(6666004)(2906002)(86362001)(5660300002)(508600001)(15650500001)(4326008)(52116002)(316002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?37mFAozxmzqYcXcZzC5Qr3lgf/h/4mLHOMHj+KRBAmp+27sLXVYwsyj2AKN8?=
 =?us-ascii?Q?Seh2MLn5feYZhBvEtub6YknR0hWV3Wc4B+aOzoRFeL6bzXnckCfpJCntzNhr?=
 =?us-ascii?Q?aKoMXFAWDEyW8Jls2M+JrPunrHLodwnItIwoP4MaiO+cV3O6HGNnJEExY9T8?=
 =?us-ascii?Q?jybQrrTVyfQtfPyKxk+XL2Z1q2wsGkdcaxrllAetFN7rnBhuJEhWNqfyEQlt?=
 =?us-ascii?Q?SG+DCF41fuWZuga74KCIkx0X36oS4/mRxwgdtdaN8ty84qfpwsoBdOXtf8sf?=
 =?us-ascii?Q?y7MseLUfQk3aeIN/URFTvQxu0XiCvOcLSnc4mqX7OApQGGKoGhe8OC4fA+EK?=
 =?us-ascii?Q?JxJGb1uZ+soFlS0CsVJetZepphQ839ACZvL1n1o64v4Pz2hTrypVQObIR5HN?=
 =?us-ascii?Q?x/LjYbUHghOKx2gIxEa8CrA1sbQZ3sbG1BvmSRAUcKiK7FE7kibMz/0S5Ndd?=
 =?us-ascii?Q?is8g2j2JlPmqGW2NUnWCLeO0C1+O6uFaTpOBTB4Jx4/m/1Gx3MUIcwDu8iOG?=
 =?us-ascii?Q?Ga0H1ww1/ZkCwBZQU/z6hzra/Al2nrgwdBAwb0eXMPqT7VYzWJnkwu+GuY7q?=
 =?us-ascii?Q?9S2qHHQTkSKEkIVM+Bp4XUeZW9Btvvr22fhFc2nkSDvznKYUIqCkMqb4IJ6n?=
 =?us-ascii?Q?AmOqBpIg2ipzAEHWJSLF/hR28cKT7SIReE/NmYWV2JUSrbDg7CgwxaXivK4n?=
 =?us-ascii?Q?eMy6qmF/oUnBLaZO4iV3Wk1Rsh+FTeAjYdkbCGh0ozpgX1IblJtAQRWu8XLr?=
 =?us-ascii?Q?cjqMOW5Mq9EmFnCq1d+hVJRTQqAdTvlhdfWF6bVEBWwGfNYPgBvwhPrTQgq0?=
 =?us-ascii?Q?wLGvSFj84ReIhGSpebQRsDwIOOed0wVDOXbxZgOM39UKDIgphUTGdVl0802F?=
 =?us-ascii?Q?l/XxTPmT3erXZVeR44RQ1v41A+HgEpIjRVcnDO14/o7PMRP9VaX24SH8322F?=
 =?us-ascii?Q?OVY+y5KmAV0pAzjtKhV8nPNAG6NBFUZ1DdIHRvqQdXdLXCujiEG8AAVak/ns?=
 =?us-ascii?Q?MVyUqI+Zupi1ugTwNHWPg2eB4NX0+f/Mpe+82cOroc63ZkUtYYRX4hyLpRr3?=
 =?us-ascii?Q?9GKY67niHTxstyrCsCCezl6LwMYTAYGQP457ogvnou0IR6pee2LthdHPBLTH?=
 =?us-ascii?Q?JJ0ibCkfoEXmqGFG79DnSpNexv7zf5Ht9IaofEjpvIU9Qo7XLM9gNZ0sR2NM?=
 =?us-ascii?Q?SXADHz7Z7/zzgK3hOz7Vt2PitiOhbpKQvx6Ot79EL33Eq2GcmPeO+hib0SKx?=
 =?us-ascii?Q?VsK0CsbfBk/rk9u5hcd8yXGc29dd9fdjjvocESNKblp4+AsZtTS3XCqEtr71?=
 =?us-ascii?Q?psJzSrjr3+b2nGmZdCiyCM4+Qj5pfVC2atFiFyx+cDC6RgwXi9BbqRg6/C1L?=
 =?us-ascii?Q?Yvqn3fZFX4h0lQKC2rU27x9hGVH89jfqLvfqU8fwRShcZpjtApnnf40/CRh4?=
 =?us-ascii?Q?0Ry6LcYk77e0qW+pdQYUBWFsJOFExRwNb65ZLcGRvkr1kQg27dszUSNLBVrv?=
 =?us-ascii?Q?ZXlSk3gVEOPwWuZtE8P7YMAfZrzvcY63bKBzNqv/3IKHHTj7xsjfp0ULAiS9?=
 =?us-ascii?Q?iTJpBYPte6Tv8xVPMnUjyNFKbHGuYKFoNYeSUsCIc5ECaCQBGsLhCmLtP6DZ?=
 =?us-ascii?Q?aCFsIg1bO56a9o7C1786ZCE=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c10b091-fd33-4bcb-40fb-08d9a806314e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5191.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2021 07:04:40.2079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZIQArLNgkTykwhem+VBHwTlJZr3EVp7sxsN7Ayu+zxpEoWqp95gOpcyzdXf3etFVFKBgB1DbOHZPiRcg+IGAdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4981
X-Proofpoint-ORIG-GUID: rxQUH702JIPAJpOx7dSjkwPvzr-MbVUP
X-Proofpoint-GUID: rxQUH702JIPAJpOx7dSjkwPvzr-MbVUP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-15_04,2021-11-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 bulkscore=0 spamscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111150039
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

v3:
 - adjust the static position to fix a building warning

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
+static const struct dev_pm_ops socfpga_dwmac_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(stmmac_suspend, socfpga_dwmac_resume)
+	SET_RUNTIME_PM_OPS(socfpga_dwmac_runtime_suspend, socfpga_dwmac_runtime_resume, NULL)
+};
 
 static const struct socfpga_dwmac_ops socfpga_gen5_ops = {
 	.set_phy_mode = socfpga_gen5_set_phy_mode,
-- 
2.17.1

