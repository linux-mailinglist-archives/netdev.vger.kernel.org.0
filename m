Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B05734875B
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 04:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbhCYDLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 23:11:04 -0400
Received: from mail-bn8nam11on2064.outbound.protection.outlook.com ([40.107.236.64]:1376
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229908AbhCYDKs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 23:10:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZaX1xur9twV5EXl6lSwi0/Ui5pfM9RBaR/ZpbPEVWPCOJEUz137Qy7egLFZwRY5ZEipbxvkFuaIP5cTv9KyKS4EB5js0yECjH9/OgkpgfOnGLLa9ntZ8q/HeWWj90SZp6Z185WTN80liZ/L0J5U+DFxosITN2HVf6CS586arl8MP3mdaPctombYqEYqp75CxTHcKAItrezFIXLJR/Fb4NlYHUf5ASkA88YwK2yydXh1tIgZgQ+T2M1FakYDTUkeWf0YE1QMZaiiEdw9XKfMnpkqDo7RCZNIl37lq67SYdAqbH1HgkVsxnJZYGTtV5V2DC6Nqp4idTaP8EMvw2hBHtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wllqje+r2pCzjDw+pVhl/aTifk3OgfA+2d2taf/LC5Q=;
 b=MufT36o/8hV2/kTAUmw1fBaO1V22PSDzMDIAcBubdm8qVV5gZZqCDv/TDF07NF2CPf1H78N7MZj3Cev2MdVBFJaSVAMRY1GeEl6Y+LxWbXKF2jvJWKUQcCvQA70p32TE0R6kxsIoxuuVaNiyelGDjWHFExX+rSzJVBBnKLIZhIvWMb9Ay8IHMifzHTbC50awX3tZVwxXPzXGdPJp7y2IocNfXh+0pPitAXKSoHZQFPGshZlfYrbW+jSy3Fw6HPPTLPTx4OPCxtikRhg1QP5GoBVGBFYEMSy1tnyF917sssnY1YDapZR8kpRXAHgxRZgXGC8DLhzkhpi4fRE3EmkFoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wllqje+r2pCzjDw+pVhl/aTifk3OgfA+2d2taf/LC5Q=;
 b=jZccKRjZVrH2Ng8XCY1U1SgVzLF+QB2lIK8zQWQXluX2Is+MDSCZ7yLTU6aGIbeONyfpKbAcEH9zsHMviKwpBBn/xVtu0NhveuyfSE5/SIVUSBy72axKvbzEgjmmoEzeWCMZC7916g+nft+1vt+BVQJN5ji3S57E9ruL3oewiJw=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from BL0PR12MB2484.namprd12.prod.outlook.com (2603:10b6:207:4e::19)
 by MN2PR12MB4222.namprd12.prod.outlook.com (2603:10b6:208:19a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Thu, 25 Mar
 2021 03:10:46 +0000
Received: from BL0PR12MB2484.namprd12.prod.outlook.com
 ([fe80::cdfb:3847:eeaf:5f86]) by BL0PR12MB2484.namprd12.prod.outlook.com
 ([fe80::cdfb:3847:eeaf:5f86%5]) with mapi id 15.20.3912.027; Thu, 25 Mar 2021
 03:10:46 +0000
From:   Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Subject: [PATCH net] amd-xgbe: Update DMA coherency values
Date:   Thu, 25 Mar 2021 08:39:12 +0530
Message-Id: <20210325030912.2541181-1-Shyam-sundar.S-k@amd.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [165.204.156.251]
X-ClientProxiedBy: MAXPR01CA0112.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:5d::30) To BL0PR12MB2484.namprd12.prod.outlook.com
 (2603:10b6:207:4e::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from jatayu.amd.com (165.204.156.251) by MAXPR01CA0112.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:5d::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Thu, 25 Mar 2021 03:10:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 27d9ce2a-8c3b-4961-8683-08d8ef3b9515
X-MS-TrafficTypeDiagnostic: MN2PR12MB4222:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR12MB4222CD15176C67EF207B8CD99A629@MN2PR12MB4222.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ajUZCeOfxi+Rcja2OqnBWu/0d+bdTpJHR6cwmeHwwieRh0PflsSIeqmwRiCLZOL6OVGGYMocvzf3OHW9dSkmWbTnn5RfKelgQG8t8WErKmRAM0D9QmlToSziyXmkRNxHr8KaMblebspN+CaCEhg2XrQ0uyWefY32s1yw9x1rKuZmORSe7wJ0VAP47SwTt982EHHmo3gPgfNwePVVb9+wfSrMSwnBnAtl67xFXeuJ/M/1VSG6fbRmBmid9nhMTJs6C4kHub67aS8Wt0XSR3ya3WvM7ZNoEZrUPrNdoiAsrIF1fn7dNwE6rlwbSuu6sHnAo1f1ByBrsVQLQEDytBqtOW73Q2iTDv3M2c77QKAyzJ0Eue6a6ePfgAwN5DBNh70voryVRr4N5IeI1wNFoa9KwL1hx/LwiQzo/EBbcY1uRTfl3zbfHN1/Bh5m/Mk/w1+55T2GIBcBa/gkSmLo+s/kMOB8juBrFpEiy9EeOdPMExe03wqowReghYuYgJAm/VzlqWt2sJ3nt1IHkxO5xQ4oPdN/AeOavejpiq5qowdWkX9rsEWvVbybhrnSdsF6b6pHej47fJVkvjwyVIhkU1nQSLXqNKVl3UE3DGsG5voHFgom3aMbqjmBlOrELoDl+zYkgL2lHs6P87+xZ8Uy1g26Xg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2484.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(396003)(366004)(136003)(1076003)(2906002)(478600001)(2616005)(38100700001)(86362001)(956004)(6486002)(16526019)(7696005)(6666004)(83380400001)(186003)(66946007)(8936002)(36756003)(66556008)(26005)(110136005)(316002)(52116002)(8676002)(5660300002)(66476007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?faGR5aRPYnrvXBHxep7TaABhtk/hDMWJZIhTQLDYa0h7IGk94ebvm6XhgeEt?=
 =?us-ascii?Q?kTL9TMN7Fj9MLzvhSSHtrevxm0e2wxG6+Tj11wsC2ZQK5CDuS9m2isrILFQg?=
 =?us-ascii?Q?j+dPMpCJ0lyloipn8kZEu5W8EzbpAOu5QNDCn8FB2PNVJQTbrHQSDO7wfBC1?=
 =?us-ascii?Q?cHMN5iaZGyRUn2JyDYWrIIEBGXsr4EfY1XeB5JrOv9/H8VP8FZKBu7fA4UnW?=
 =?us-ascii?Q?zLmmOJMocABrawDfCW51BLRQumCT8Pq/mq8lIdFq2Lf5A1eEaeCE6PnvQWL+?=
 =?us-ascii?Q?MjCQwc01qZhWyYHq/Hsr9NDhuvh+x7+JgU7jjXqYbvsV3ay0/BJ79t/F4qRq?=
 =?us-ascii?Q?JS89PK3HscyXeg79LkKr8tRTZFfy9EDsTBLT5Bt2T85tO8D9ZeiTsSGLf14r?=
 =?us-ascii?Q?6VvrM9J9/ef2LUIelMLXxqgX2wFu8yVd1CgVnpx553M5ne+vBcb+Hpb2qPn6?=
 =?us-ascii?Q?QT4n5Tdgqk7Nug3pmVnqHEtMAklLduoFyY/WYXvEhTWPTEttsPGx4mH0bGe9?=
 =?us-ascii?Q?vfZpZd08DouBUO/EPiSOwhCxUOHIJOMu9ew2AHObztEnE8z1z55C3iMLdPj0?=
 =?us-ascii?Q?sgz2lLMHQjMKdSobQkaaJiO3PCjgfptnl2udpXFR/IvBVZrPIUcKMLpOOiMn?=
 =?us-ascii?Q?tgT9YT3zgUFboxuvXRy0s3mxJuitCsKHg5oNOMC+ZpSxVj25bnVhev/kD/Gb?=
 =?us-ascii?Q?S00frKxfUJdN7DCw8/YMj8fwllRpJKNCSBvtMJUeCRQAQTJyvbR5gC5LoFIr?=
 =?us-ascii?Q?7zZaymBSPeGYBf/UHV5/VxCCtsbl+ef6+w9wLum566sIrRgZxNnLRkRgpDZt?=
 =?us-ascii?Q?iTkbBj1NqKu1hB6Af+rHXMtlb7bkHQwcfVG8aiJUpYkSxPLMs6BXLPDO7qTQ?=
 =?us-ascii?Q?ggCrNwOUv/NKSTev3fl00IdQvb9MLboJJ5K46cOkU5k28NPX5zAjHPk1aV1R?=
 =?us-ascii?Q?bgSpJvxVy8UtVQKZJPShATW046JwKmGMVbsIAT7BmaaF1r7vGXozil83TIAA?=
 =?us-ascii?Q?KrPJxtHum4c8qry9XcsBdCPXL6+bz5pDpR9C6HBADsh1ZkvBDy7M+D047BmW?=
 =?us-ascii?Q?hEQTo37atzaZanOgnGVAh5tw/DoKqyuNiubku7zh5phszw2jlaD0sLJQkV1N?=
 =?us-ascii?Q?iymeYgIZnizVsRk8KHUa/26tHhHGi4HIHpviuJX+qgdRHRUUJI7hN/CUuK+R?=
 =?us-ascii?Q?Us/DnRezO9ad/tN3UkNbJBJA6Nbaqh2KauiqKyGVwX109aEDXPJRszcAuvSl?=
 =?us-ascii?Q?G5aLy7Tm9uGBA0iBk9PsthOGZNLmlu8oRSrJq6breeKBmy/qWqLqCqv3OX/+?=
 =?us-ascii?Q?Njgu99UOoYomTTHgcz9qKTfQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27d9ce2a-8c3b-4961-8683-08d8ef3b9515
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2484.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 03:10:46.7933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bvo7ZFjuVlaTqxatWbwQMBg8AOiHakgD5Q8v6jVqbHRcOIZ780SWT7m8WE362/JO5F4hEyN8yvv+ObwNSoT2FA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4222
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on the IOMMU configuration, the current cache control settings can
result in possible coherency issues. The hardware team has recommended
new settings for the PCI device path to eliminate the issue.

Fixes: 6f595959c095 ("amd-xgbe: Adjust register settings to improve performance")
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
---

Please queue this patch up for stable, 4.14 and higher.

 drivers/net/ethernet/amd/xgbe/xgbe.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe.h b/drivers/net/ethernet/amd/xgbe/xgbe.h
index ba8321ec1ee7..3305979a9f7c 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe.h
+++ b/drivers/net/ethernet/amd/xgbe/xgbe.h
@@ -180,9 +180,9 @@
 #define XGBE_DMA_SYS_AWCR	0x30303030
 
 /* DMA cache settings - PCI device */
-#define XGBE_DMA_PCI_ARCR	0x00000003
-#define XGBE_DMA_PCI_AWCR	0x13131313
-#define XGBE_DMA_PCI_AWARCR	0x00000313
+#define XGBE_DMA_PCI_ARCR	0x000f0f0f
+#define XGBE_DMA_PCI_AWCR	0x0f0f0f0f
+#define XGBE_DMA_PCI_AWARCR	0x00000f0f
 
 /* DMA channel interrupt modes */
 #define XGBE_IRQ_MODE_EDGE	0
-- 
2.25.1

