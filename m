Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47DC7456855
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 03:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbhKSC6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 21:58:05 -0500
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:38994 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229521AbhKSC6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 21:58:05 -0500
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AJ2lXVf008578;
        Fri, 19 Nov 2021 02:54:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=PPS06212021;
 bh=2En9LV7kBnBovUE/kcxK5+sNfyETuvlA26cM9yOs3NI=;
 b=nYT12iZ1zUt5693yJNOeD8VNQ/LJkaWwFvsrqQ7I9CyFk57M7dOR2UD/wrMiyMcTNhzz
 rzrCxrwc3HblRGwad8jpJs6eIKvsFTmSUZgBCc3VfoMHopRXlXYpn94r20ZGZthPXIiR
 /7r5HU/XmqRkZZnov0kB6R+rH4GCq4mbJFoZGA0Ip/BFw1ZEL5/gqicZjBzZYQKL5Qy/
 Lkkw9/wMdJDKg5BkVZGQgPBn5IZ/vnvJqc/o4T1HGMcurs9usNn8g8ppCk24vjIiKCU4
 /0RAmnYUTeyiGbz6coaboR0zeVQ0rZmYL48qNd2n/4j/wTyzzxh7Z9OSMqf0RaRs3J4G Ww== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3cct5mhya4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 02:54:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WXDjNgLgDFeCEXwWyuHw5eNixQtlkGgR8kk4qDPIF8F9bt/4NSvK3doGsVTbEs8zi1BbAv8S7nzuIQEkczA6W4Geb2hFHQ5S8JI4KLxdrwx41jXl6/ocTxDn0EuVMEKnBAxkZnf67AAXw6jQc2es27CfltyCSX+wgCAjmrrBz5W95Cm/PXiPtLwqyiIyskY0MCiaN99tTP5E3uinJ8CNPPuz8yUUE4AcNKmCiG6E5/x4euNsdtobAVx//f1jA2VioyZKpvm0DDGEE/yVv7sg750HY07yWYp4cX+SF3ofa1B6AaksjY99YibYf6omHue7go4nfitG477uqmF7B9Q8Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2En9LV7kBnBovUE/kcxK5+sNfyETuvlA26cM9yOs3NI=;
 b=BaVJmklw0tIeL+BXCIrTykV0lArjj5QqNLSMn32xzPkCF0Ta2W8HwB6PFkkiJwdWsmqtOExZWbeDx0oe2gEzbN8X6+IAK6q9u41KuWAnBGfXRHNgWDq4UiMqkmUJAEzLardJgcReh+K+EdSYwul4yZQhH6k+akUAOnsk8Vnf+epcsKqgXHZZitSyyHVcltDi/hmtDMFQHmy+nSn45m134u6D7jBLBPqwwOPMxrNH0MNmpN2D6kzXor8S67hxw66eUhvORVH/JRN4sLTGW+T2a83Xokmg29ijScJcW9UjsZ9Rd7EvFBKqlLQ5PkaESIvkSdUUvc0rLNQ4IYuki/iSjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB5191.namprd11.prod.outlook.com (2603:10b6:510:3e::24)
 by PH0PR11MB4951.namprd11.prod.outlook.com (2603:10b6:510:43::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Fri, 19 Nov
 2021 02:54:38 +0000
Received: from PH0PR11MB5191.namprd11.prod.outlook.com
 ([fe80::a090:40db:80ae:f06a]) by PH0PR11MB5191.namprd11.prod.outlook.com
 ([fe80::a090:40db:80ae:f06a%9]) with mapi id 15.20.4690.029; Fri, 19 Nov 2021
 02:54:38 +0000
From:   Meng Li <Meng.Li@windriver.com>
To:     stable@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, linux@armlinux.org.uk, andrew@lunn.ch,
        qiangqing.zhang@nxp.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        meng.li@windriver.com
Subject: [PATCH 6/6] net: stmmac: dwmac-rk: fix unbalanced pm_runtime_enable warnings
Date:   Fri, 19 Nov 2021 10:53:59 +0800
Message-Id: <20211119025359.30815-7-Meng.Li@windriver.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211119025359.30815-1-Meng.Li@windriver.com>
References: <20211119025359.30815-1-Meng.Li@windriver.com>
Content-Type: text/plain
X-ClientProxiedBy: HK2PR0401CA0017.apcprd04.prod.outlook.com
 (2603:1096:202:2::27) To PH0PR11MB5191.namprd11.prod.outlook.com
 (2603:10b6:510:3e::24)
MIME-Version: 1.0
Received: from pek-mli1-d2.wrs.com (60.247.85.82) by HK2PR0401CA0017.apcprd04.prod.outlook.com (2603:1096:202:2::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Fri, 19 Nov 2021 02:54:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2985b9a4-99c2-4775-7826-08d9ab07ed2f
X-MS-TrafficTypeDiagnostic: PH0PR11MB4951:
X-Microsoft-Antispam-PRVS: <PH0PR11MB4951707E24708032DB09A9CDF19C9@PH0PR11MB4951.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SrIiwu5NbU7n3oGvUtZemn3hz0MqDwGDSMpSLtTD06ghfvsyv1dLUutk6iLXT8DvzVJiKTBtf7+vRVfip5Z3qCt03neMpGRP6Zlt5+ylHX+PlOQSoeSQQWn5ak0r+VZ6OM8XgLi2bY0vEHCG2TiSaL8B8tRdT2Wb74+Q/E1xBFSDZr+yFxfLtTC79lPyn0BvW1ZY2QBScq4c/eYpJMcu8SFgJPig2CQe6XgYNSN98jA6d/naRZJ4GrzJAaINlnfGuTXsHSh+1U4oMiClAUKDVOjHYOqzGRn+IUsOxmzWGlhtcIolZ1cma8LrMptBv+Ja1Hi0yFSbiiDj43enaq5bH6kwzvBztgqYnEdSd9dD92BCqlvP2sQo7Vd1nj2+iAa2SdVZKva58JBxKW6xQvdBinvXyEwDf8qiFVQIa6nODa4KGF1rXcyIvoYmpFqzc2HEzyRdV9NczV0dMCwYT9uA0VmqA8Jp1rCmt094FmwK1kERTlbQux2FI4bquWuppCO2mXipgHq7ybOpYY4VAQgweVDbYQgkzVPdT8TRuS+qTPYPPYNy+Qu96ZidEJ3sp3Bf6xMf/WEbrGe0sRaUgM6xAUnKPWEhmO/eA7j+NxXE3WjJmCaga2rKxTBLLvdKvKrJo5cO9I/OfQlDgIR1aJeOXWqRHxHeFCcIxbcASyyBvf7yZy9gbewUfz1IPWZ/aSydEp2cRN+uLbJIDgtRUG+oeA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5191.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(83380400001)(5660300002)(186003)(107886003)(6512007)(4326008)(38350700002)(38100700002)(2616005)(508600001)(8936002)(1076003)(36756003)(956004)(52116002)(66946007)(66476007)(6486002)(2906002)(316002)(26005)(86362001)(66556008)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?le1VY8BXvdJLokHbUQ3BtmUjIJclflHGDl558JPYJfGEGSKcSUvBeNFDUuY1?=
 =?us-ascii?Q?wUm6NkCzwqBdEmXQ/O89DDPCXrSrKhtaQS52uP58dMAGijvJGjlDNgwWaviT?=
 =?us-ascii?Q?EMd1adFETFcpYO/q4BhiqZKm4PruLeao66/pHJq7P9qDjFXbqGmA2l0zp5OE?=
 =?us-ascii?Q?pta4em4veDs5/2WWv+b+EQFBPmUKoRK4qS0RuzFcEKzmmK195Jg/M7tDcQUr?=
 =?us-ascii?Q?KBnnM9s2PrhdY+yHL5AMLeWId3c20cT2dkm7Fg6lI+/cNjBeFR/hwXfSxtry?=
 =?us-ascii?Q?vkCaO0EsHSGcVL2ma/TuzB4ABELtb2HcKsyhAQBbs19zLyLxaAT1njfpkmZj?=
 =?us-ascii?Q?+WiQYLW4P80MfD5C0P20ci4XELo7YyEfxQMf6OwSoSE0SvxmytJeOaqaSw+l?=
 =?us-ascii?Q?8jvBaZxoY4hIXN/5PRgg1OpJzSBZeH88EROQnTdkC5SJ02AN4X9wiXnP3FHC?=
 =?us-ascii?Q?cxjDEoAIjydFHAonBq7fdXnDMhsQx9ym02tvbEorg43OM/bivJ6XU38G3W+U?=
 =?us-ascii?Q?Syf1OQD6SsFE7TZS8NPjxDH1trTHv39GDQAFTgRFNbCCw9DwzedxU/JwIRjJ?=
 =?us-ascii?Q?z5iMji39hPVtsXabhnsvp5v+yJ6yynVJtItVcUPqWvVbmwlb2EHJTuD/JJlX?=
 =?us-ascii?Q?hgFwIlpALQBokSVx4g4RHIW09ONDq0TOtko/lGc8cWMIcehjtjFpvqoPMZsj?=
 =?us-ascii?Q?5qZv0SMVxK6GU8G45cT46Jsh0t9rzeUeoTijb9/esl0rxNHFTS1tZi09jfgV?=
 =?us-ascii?Q?71TkQeQ8/2vmT9+VS96jvcXGUcFOaejHNXvIhwlrXtwmmgKKUOz5FC32d0ZU?=
 =?us-ascii?Q?eHkqdYoSGfJlf3FbiBexiiIyK22jP2EjV0Sc05bgvsctPtx+4E7fcCSdwISR?=
 =?us-ascii?Q?g9gbDjxZYYRZWjXw1I40iSywuqOSg8A0lg1+6VZ5NR8VNw5zlYWOHmd+fCPu?=
 =?us-ascii?Q?hqdVCuulSXVGbanGKDTL7FHjqjCVB1+QLIk1bGdvipsgejSUfPBaVkW/TKxz?=
 =?us-ascii?Q?EWs2qalpvfodWlo04VwcI/yx6lMlvKB9z4NPeDBoUWnKs2CnH+el2QM/UyxO?=
 =?us-ascii?Q?OrPt4XkHu2GWrOM6p8SH0it/EJGNyO1sWLv3vUkk56XDVQTooLOIUZqNwRIz?=
 =?us-ascii?Q?zc5GJrH/L4lsG3i7D48ww+tDw8OIuCAfH77naoPH5v/HmLp+4V3ft+hGT41T?=
 =?us-ascii?Q?bHhAbO5u0HIHxXl77Gysa5pCQuZKWgMBDVxU0etjYs8FxzSrv5AvvAdFZEKU?=
 =?us-ascii?Q?VIQl+us6Pz4By237vGpACTzBB4Cbiaqcf5AOCXllnDEukwzIhVEiW605roMt?=
 =?us-ascii?Q?cTiHqeuhDstRTxCAcIEZA5Y3ZZN3/+UAyxH7h7bwvg/xehNZVwtSe7DINS+m?=
 =?us-ascii?Q?eCFIr69Zx/ca/8gMKmnQxFb2qCt1qfXWTdxWYWVVVatHzGJB9FkXPDU5qmTa?=
 =?us-ascii?Q?mcG3y6OE06TTHubRHOLE4IQ5x1/vq/XU4vheVfneIG+4QdHsl3iKyTO91lW1?=
 =?us-ascii?Q?1FT0jphZgoPoTEq/sbv2pSMbisucobEve0JVUecSKTSGGBhGPuQSuWJCaOLA?=
 =?us-ascii?Q?ew7nhBpSPnYH2vtpe0u/ZU6qTEybMqqcm5mLAo+VduSYegfekmW8UIy9+3jD?=
 =?us-ascii?Q?N/koFRJ637KIWWBAWsIAY20=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2985b9a4-99c2-4775-7826-08d9ab07ed2f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5191.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 02:54:38.3411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l2I7LlITJMjegXwO57DHh73duDT+ap9+NCqakh+4Qw0CZnzy0LMiDKRat4DPFV/VrH/sDHIw+veGsj6AsT9tKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4951
X-Proofpoint-GUID: xY83tTxrY-SYMjWiyr1pmcOVLKNvm-v-
X-Proofpoint-ORIG-GUID: xY83tTxrY-SYMjWiyr1pmcOVLKNvm-v-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-19_02,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 spamscore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 mlxscore=0 malwarescore=0 mlxlogscore=899 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111190012
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Riesch <michael.riesch@wolfvision.net>

commit 2d26f6e39afb88d32b8f39e76a51b542c3c51674 upstream.

This reverts commit 2c896fb02e7f65299646f295a007bda043e0f382
"net: stmmac: dwmac-rk: add pd_gmac support for rk3399" and fixes
unbalanced pm_runtime_enable warnings.

In the commit to be reverted, support for power management was
introduced to the Rockchip glue code. Later, power management support
was introduced to the stmmac core code, resulting in multiple
invocations of pm_runtime_{enable,disable,get_sync,put_sync}.

The multiple invocations happen in rk_gmac_powerup and
stmmac_{dvr_probe, resume} as well as in rk_gmac_powerdown and
stmmac_{dvr_remove, suspend}, respectively, which are always called
in conjunction.

Fixes: 5ec55823438e850c91c6b92aec93fb04ebde29e2 ("net: stmmac: add clocks management for gmac driver")
Signed-off-by: Michael Riesch <michael.riesch@wolfvision.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Meng Li <Meng.Li@windriver.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
index 6ef30252bfe0..143b2cb13bf9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -21,7 +21,6 @@
 #include <linux/delay.h>
 #include <linux/mfd/syscon.h>
 #include <linux/regmap.h>
-#include <linux/pm_runtime.h>
 
 #include "stmmac_platform.h"
 
@@ -1336,9 +1335,6 @@ static int rk_gmac_powerup(struct rk_priv_data *bsp_priv)
 		return ret;
 	}
 
-	pm_runtime_enable(dev);
-	pm_runtime_get_sync(dev);
-
 	if (bsp_priv->integrated_phy)
 		rk_gmac_integrated_phy_powerup(bsp_priv);
 
@@ -1347,14 +1343,9 @@ static int rk_gmac_powerup(struct rk_priv_data *bsp_priv)
 
 static void rk_gmac_powerdown(struct rk_priv_data *gmac)
 {
-	struct device *dev = &gmac->pdev->dev;
-
 	if (gmac->integrated_phy)
 		rk_gmac_integrated_phy_powerdown(gmac);
 
-	pm_runtime_put_sync(dev);
-	pm_runtime_disable(dev);
-
 	phy_power_on(gmac, false);
 	gmac_clk_enable(gmac, false);
 }
-- 
2.17.1

