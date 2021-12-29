Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51084480FC9
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 06:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238746AbhL2FDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 00:03:51 -0500
Received: from mail-dm6nam08on2097.outbound.protection.outlook.com ([40.107.102.97]:64800
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238747AbhL2FDs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Dec 2021 00:03:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aBR8F+M60Xdi4ZCNJIY2uGXnnbiP3zaK4R4aIWMU37sDPA9YHMpf92odjRz2h6ch+OYB9SNPFcmaRhqxcT83z06Cs0q71KQn+J2dyLPSsh6NaiX1oFcaqwzjMz/Ywy/zWOLf1o+535hHPkafQDvw7XM2dhuk+YHLDmcDWqgbwGKSzmM4wLoEsYiOTX9lWq7NhYjqrx/XGH7do658BzBvygHWGOExF4RIMko6AfY2X/3sSMaSkk2/OSCIwGoU/jcnNuN1ffltx/MniTQexYt5i8fE5ftQlNzVzL22+Dy/mUF+Bu/byTgPfxZjO64rXZOUJCRALUstC8C2zDIP3DGmUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=toz/kREwsP45vdGNTdO8e4m3bTuuZYfc/3+TCfHILJk=;
 b=b4/KvIwmZa9pMuSuGxgkoE09B6f1VOCA3wUFQCMHMatC01Nc52B4VCQ1a3CtCx/z+jIDGLU8NqwHCQ7sggh0ZYtobtzVVRKBi73XrG5c6E5AlwEtC4nCa+PAAIWu4YUuqOtkq5j89DdfA4sh0NGP3V90yhoJgMuZWE4Kd2EWQ+yQ4woBHFyoRBwphUanhBfe0nmJiGYd+1B2sZzhqryNz8gb4PmS3VQ+gRcK1QLbc5kcxmrX4/2Y3KZNJEfyxSmKLdSqWRljlwzmZQD5wNvALSGBXk7kcrKdmCgKgVGqSmhOVW7rgRyUPN5kgMM9it050j6PQsx92OlwjmQlY6R/Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=toz/kREwsP45vdGNTdO8e4m3bTuuZYfc/3+TCfHILJk=;
 b=IR9D5RR2kAE9Yf5YSaXzycVyB6Or6QdGQUnZ+0hvCuQprjszYSWCacSZHUPAURIKqGrBvm6s3WELsHtta13mwn8r3FjtPJfuDUK3Itli11pobnIZh+f0P+OkgPMoqutfCBKCJTtuaEcjgVXesyrqPP+Hy8+gcWlB4HBrpX94F+w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO6PR10MB5441.namprd10.prod.outlook.com
 (2603:10b6:5:35a::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Wed, 29 Dec
 2021 05:03:41 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4823.024; Wed, 29 Dec 2021
 05:03:41 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 5/5] net: pcs: lynx: use a common naming scheme for all lynx_pcs variables
Date:   Tue, 28 Dec 2021 21:03:10 -0800
Message-Id: <20211229050310.1153868-6-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211229050310.1153868-1-colin.foster@in-advantage.com>
References: <20211229050310.1153868-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4P221CA0026.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::31) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d6c74d9c-eeaa-4c52-6d55-08d9ca8894e8
X-MS-TrafficTypeDiagnostic: CO6PR10MB5441:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB544122B36588C3285EDF6C3CA4449@CO6PR10MB5441.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0evBRd9AfcggJ2fUyTZ6tSp5jtzTuAr6NHSXHP3ijk67g/5pAdb1cpukBc5hr6pyOoJLLtnUvgs7XbLMVLSt9H5zfTLJzxMVb8GhCX+FTmRGCVc+Iw0u5Sm9kOyv17V+kCaHyq3bJ3MbmgN37TqQOs9QaPZXwVSsmVIswBgmlPf8q3CprVLzTmSptkMfyV8q+JNzzKxSQHIrNC/iPFatkHPE94lZA+BNstdlFsJC5Rm9X7DG6/nG+rvfIbwdH8cCIyavhL4qZkZ6+gfLyK6zzobAs6OjgSM/bBRmc35za2k0Ik7EAxzo+NC8YYeNCyyVDCDA3bCOUxqBzR1wAaHoDbmdfrjruUkj62PE5lAGdaBKIS8y0A1yB350C55B8HtnRd81ptk8OnhrppEs4B/c2z5DqmwWateAxUGqX/fkQ38oVk+24xmqAvtf17r0OMDnQmyCpXWbKJ3xtRrjsCE4WO3lOWGeA0DM0F8fz5htrFcMpNTIIy0tITl6UQzf7Ch64L7IYdnST5jiLbVI/4GMnxAZcVsNeK2uLofPdyMbVOmkVwnXPwwp+UetPRqHJ9RHsLlKH5VP8b/yumuQgFrtEQxbBkVNIEfZ6D/66EAmr24h6krFaJ8108q4EhVjtFHCcQwitERMM4HEQ9yY70i1bqJsu5tOCd8/APH7Y4v+E4e09UMK36LUnTM0ibBjo7K9X6ODp2ZfFb6znl0UJgHLIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39830400003)(376002)(346002)(366004)(42606007)(38100700002)(316002)(1076003)(54906003)(6666004)(66556008)(66946007)(66476007)(2616005)(6506007)(6512007)(38350700002)(86362001)(52116002)(26005)(508600001)(36756003)(4326008)(8936002)(5660300002)(186003)(7416002)(6486002)(44832011)(8676002)(2906002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nnsebXso+TZI+4FtyKK8dfPVyERSXSeITBWGj/dWFBSwXgGLBbHJ1QPayHZR?=
 =?us-ascii?Q?8P99j5g46YLLkv7oGoZHfMiCwfv6XvXFIaJ40xyf2vLEIc5rAFDbGbSaP0b6?=
 =?us-ascii?Q?1HRzoHITYgVzfjrZLxDCegHP3sP1CnZ6z5KuPVvLHuumR0+BiNRzYUppNpci?=
 =?us-ascii?Q?5p8ytOmbX5BUiNWlbYf/ooEVFcNlo1NRPquH0YNDbPywFW7rHfrnzUe1evV0?=
 =?us-ascii?Q?VwhN5tfEmfzFWy24TJxL6EaG49NFnHf4mmcGG6tDNsTyNmTtc2RypeO2SRrh?=
 =?us-ascii?Q?d/+VKepHQiZd+tomY0nUG7NNYJ4hYaUlq588e42fKBiTwxDPhUq5GsU6rdh/?=
 =?us-ascii?Q?OGQ4jQ3jJAzBQybpH7cd2sDrVrc36WItvCyfqmtNGR4qxnZgFNi7jPqmdXb0?=
 =?us-ascii?Q?L8zwIrfAwvnpf2ddOpRmdCBXJEKcx4tTLfg1LDUTzkdwekj9IW1dYW1LFV2n?=
 =?us-ascii?Q?famIitCSbB4PjPJMEfw5wSOKnwxNL2kWVQRPG4oLaCJ4TeP33CyafWMG9KB2?=
 =?us-ascii?Q?/vJ4ii3dnC25KMXFyEEAxxpUxHtVB1KLO1/AoQrZSAmEH6pDIcsIapY4KDsa?=
 =?us-ascii?Q?wZZxmUMuiXtHcAYOVM4mBKBbOwUx03+mKKF8ZelTUNQozzr3OZhYUrwEhx1O?=
 =?us-ascii?Q?YxgfKXPdPzPlPE3zCadZ63PS7jlIv5hk4IxX56fCFTviNL20AovMRHgJ15uD?=
 =?us-ascii?Q?O4LW8wWcBoDTm7WrOaYO9ji+bJ8KRCCyM0iaH73amXuEhsxMGhBhvrwkcNgl?=
 =?us-ascii?Q?9FSCzoLtFK7waOtO0Q+kA0E/Afp7SXRORABsepafJ3Wiixs5qpfldbiJY2dl?=
 =?us-ascii?Q?oExUOzEgdsFDNWmP7OrYRJBSoaXpF7Ay5Nfhrrwx93iqCGSagEHmu+y46onO?=
 =?us-ascii?Q?ywjPhf2TUGd4HoBFklHMqU3c2E8amkZvT7jjPtRLSUMC/MH3K9gyvKhyrxDn?=
 =?us-ascii?Q?YcXHmTP8bC2sxeote8VcB6VEJl0vDBZGtvQAhJ7CjdYRoG1spKggxFrdTgUI?=
 =?us-ascii?Q?6n3fJBV6n/Ul5KBIoFMCmGGJ2Zi8/SEt6fkZqd05gE1BEQiLfK3tOD05CK8D?=
 =?us-ascii?Q?Ewn+XINbJwoVKCRyxJmxhDmUf9iOWJS5jdbQV+B8sB4ZGIwxAJi9k+OFJf+8?=
 =?us-ascii?Q?v3E4tXwYnzEoNHbb3GB8NoR1LB7JnSTvvd5+ryK56UQn3QNmZI6s04lzTMHP?=
 =?us-ascii?Q?bKYnkpLQZF2TvtBKB3zqEGVAqzfAF479yMbmpATt7iuZHP1NJvt2uxx85wp4?=
 =?us-ascii?Q?8NFAiTJef6QzddC9xFCmaNoR7oKpsDka98BL0j54ikDyHsgS1muW5GpBaPXW?=
 =?us-ascii?Q?rVx2cs4QuxdiO0/yozDmzE3y2LLqm1BRcarIv+nefKZaUZ+kd/BGpuYCcK5q?=
 =?us-ascii?Q?BFx7bnnnd/LfWLoGH4DmZtaPi1XsLoBCx0wU/5BIpLh+cVMS6mvVOqbfyqcg?=
 =?us-ascii?Q?VgHpCkjVsf0rmOMDkAP2sb5HVv8fz+myfJ7WTGNWaJ6ZoBDhSxPa9kFYDMJj?=
 =?us-ascii?Q?OI9IveoILVqifvRIZaFA+QH8PL8P0kiiIbYjgs1yTaiApxvtzULmTSKI6mwq?=
 =?us-ascii?Q?YF738qarskVSAzwM4shHxA4eCt4pY9SlVRfMg7d1BxSbVvy/B/30bzH5f8ts?=
 =?us-ascii?Q?jEsTaSsf0kIGibgYdpcsvpSCzmyljfJ8o9udA494pzZxiwiuwbEExnID+Xam?=
 =?us-ascii?Q?491LIOvmnEi2uETQWVTR6pY9HLo=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6c74d9c-eeaa-4c52-6d55-08d9ca8894e8
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2021 05:03:41.3509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bPkmx5Tomlk9s45CTm/gcnON+xGpD/moOzT7Ycq97Ma2BcMInIoP3ZxUp5sHSgszfbVazVe0hcOea2sigZ1a4Kco7ooylRdzz30aLeYxGcw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5441
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pcs-lynx.c used lynx_pcs and lynx as a variable name within the same file.
This standardizes all internal variables to just "lynx"

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/pcs/pcs-lynx.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/pcs/pcs-lynx.c b/drivers/net/pcs/pcs-lynx.c
index 7ff7f86ad430..fd3445374955 100644
--- a/drivers/net/pcs/pcs-lynx.c
+++ b/drivers/net/pcs/pcs-lynx.c
@@ -345,17 +345,17 @@ static const struct phylink_pcs_ops lynx_pcs_phylink_ops = {
 
 struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio)
 {
-	struct lynx_pcs *lynx_pcs;
+	struct lynx_pcs *lynx;
 
-	lynx_pcs = kzalloc(sizeof(*lynx_pcs), GFP_KERNEL);
-	if (!lynx_pcs)
+	lynx = kzalloc(sizeof(*lynx), GFP_KERNEL);
+	if (!lynx)
 		return NULL;
 
-	lynx_pcs->mdio = mdio;
-	lynx_pcs->pcs.ops = &lynx_pcs_phylink_ops;
-	lynx_pcs->pcs.poll = true;
+	lynx->mdio = mdio;
+	lynx->pcs.ops = &lynx_pcs_phylink_ops;
+	lynx->pcs.poll = true;
 
-	return lynx_to_phylink_pcs(lynx_pcs);
+	return lynx_to_phylink_pcs(lynx);
 }
 EXPORT_SYMBOL(lynx_pcs_create);
 
-- 
2.25.1

