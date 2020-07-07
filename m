Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5713217538
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 19:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbgGGRdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 13:33:22 -0400
Received: from mail-bn7nam10on2048.outbound.protection.outlook.com ([40.107.92.48]:6255
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727777AbgGGRdV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 13:33:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ACCYQ2cRLsZkQqIa84es0Pqmk4xADOxHBMeuuRNnAELgm0DwFxXkFkWmRxzvu/zSLhtTMZh6rJbHiOhORzMTkKX2wa7i6quSMz2POl3w24TgWsVkW+X2scSRe9ZbDH/3qhtQNm6i8OMjw9ORNU9sYOISb70qt3c+7/fXURZ+8/50hP4czUT5/gkKz943ZhzObqE0PlZhADKmOPZpBb27duEkpDAYXm27E0K2hS7T0ftn3b5jHJpYEtvG9xmlLhfRgUPOeVCz7wPBEm9fpf2IHEKQJuW8X8i6rznc5zWF9c8quM2vpc718NMCBt7V9T/jcYWtyF704aQVTz0RJVL5hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sLLZJM99apXMzjyVBPAOhmM/Qr/UncsriKB8ah4iluo=;
 b=IHeLp/IBpQqjGPoHYZxp13AIq4cCG7nxtSAiYEZJQBnBduE9iahUCG9QmXL8G9I1Sk5WEzL191OohRpc0P5SPuVi9T4hqWwBTAc+5zUwWKKKRVzf9J4fmYPKfMokbWpsAasbBDclnGO8kSv3EYn3aAPAk+JxxnX/fJs8oE3CmiuNza2H0z+pch8Vn/ssl9HKqIF/5u35YIxkSe2qkkBnvxsVKcg2Dznxsi1J+Ab7S7f3xj/j1BPryXkXC7LOpFR48mxGMblpFxNKxY4TZQbD/UL0P8WZvrqCdfQHWbCJwrdJmlTfD2GiCMbUK3trXfBBOtwgo8lSY58opwkIJ7ybiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sLLZJM99apXMzjyVBPAOhmM/Qr/UncsriKB8ah4iluo=;
 b=Tdfd1INubvJdT0HSvfz1qIwk/HAyMbfGVirqMxZVcqVUfhiuQQKhnrDeJElfxpoTXoQuO49ye52DRb1HdciTd/TgYUInPcrg6jj7sdbb+xHrrXrKtp63D0ltCnNwZdYi/Yn7/6WQVON2BYb4lU1OptGIXjZ12G2DkJGLpjINvBU=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from BN6PR1201MB0258.namprd12.prod.outlook.com
 (2603:10b6:405:57::13) by BN6PR12MB1443.namprd12.prod.outlook.com
 (2603:10b6:405:e::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.28; Tue, 7 Jul
 2020 17:33:17 +0000
Received: from BN6PR1201MB0258.namprd12.prod.outlook.com
 ([fe80::ac9a:b1f:fa1a:403b]) by BN6PR1201MB0258.namprd12.prod.outlook.com
 ([fe80::ac9a:b1f:fa1a:403b%3]) with mapi id 15.20.3153.020; Tue, 7 Jul 2020
 17:33:17 +0000
From:   Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Subject: [PATCH] amd-xgbe: add module param for auto negotiation
Date:   Tue,  7 Jul 2020 17:32:54 +0000
Message-Id: <20200707173254.1564625-1-Shyam-sundar.S-k@amd.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0003.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:c::13) To BN6PR1201MB0258.namprd12.prod.outlook.com
 (2603:10b6:405:57::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from jatayu.amd.com (165.204.156.251) by MAXPR0101CA0003.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:c::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22 via Frontend Transport; Tue, 7 Jul 2020 17:33:15 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [165.204.156.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 94a21f91-14f3-4cf7-0ace-08d8229bd568
X-MS-TrafficTypeDiagnostic: BN6PR12MB1443:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN6PR12MB14436E29F2E08CA6622850E09A660@BN6PR12MB1443.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-Forefront-PRVS: 0457F11EAF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZAlDHegceRRyPKw+WUc4nIMdhZ2+Qpk4vuJ06JvVYsN7o1r6cw3K0pGLz9kkRJUHSqZCl0jXabmFS3ZGgcTV2ZI+cXRtzDKfb0Zivd/ZQS7/FzaJUQhW8R9OtoTNZh2BSUCKfZJmHbrTCzItXOPSIGQk+7VrFhKgcSIveLEfw+0/bZ5X8FkdoCn269sFfHJixCJTaAemyotP7/18l22SgMYfEpVXFt9aK+BE9i15x7xVx2Ryh6lGBldVcj/x52ZqSGjQBfskW0BN4qsviedwJ7RTbJTU7cJcqPHiLbq5bWTXiCv07O9+6RLn5Jbvbep1zTvNd6vRWWAInK0RrJOcQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1201MB0258.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(396003)(39860400002)(366004)(136003)(110136005)(1076003)(316002)(8676002)(6486002)(36756003)(6666004)(83380400001)(5660300002)(2906002)(16526019)(52116002)(7696005)(66476007)(66946007)(66556008)(26005)(4326008)(8936002)(478600001)(186003)(2616005)(956004)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 2ODf4TuGIDlEmvkz7gLkk70one2JNlJdh68SXCP3vKnWtTtuc6j+F8yqDh6Bw+83GfYL7O9K6XP1jE90YnwtO0QYmtpZkevZOKU7kv/fxsTRE1eTxS/X5HXe59XufC8K5ZilxjhoMq+/PeIykgDo8UBjDuoClii2VDN7HPOOaLD4oqvZWweNJEdV6/smlqlZxenP08Vq/WNVHCzzlSK0CDnVoOwjtr2VfVRAl7LvLFArRQJiPwHGS6MWtp7ZshbnRXbLVj1fAv4SuNU4wyPRNesTL4gwVVRL5SaoKD+lLUoxhiSY6BlMfyLhXko4299V3AB538jGwW55SxEz0JKZcUG3HDA7WzB+C4Vi1sTRQZ3RNs3mFOk3RdPS8LjPGj74VQY7qB4K79c3kPS3sm1s/v+Ge0+1Wx9PejbHraDH13kuijoV9kPrBDwW4v31xbZL7YtT7ZCOiODag6VYCqvo3j8aGgG59EpwYlsaZltT2WzU/8axFRGLYMB05Hjef09L
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94a21f91-14f3-4cf7-0ace-08d8229bd568
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1201MB0258.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2020 17:33:17.0824
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nRQIk8aMP6FBtt+pxaAN7NaeZkTglGhKfGcYwEFAxPj5N6eiBAP9bpgmrLtQ21GubIJCBbgUOkTmH8cQ2AD+NA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1443
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In embedded environments, ethtool may not be available to toggle between
auto negotiation on/off.

Add a module parameter to control auto negotiation for these situations.

Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 28 +++++++++++++++------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 5b14fc758c2f..2ad016ee36ad 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -124,6 +124,10 @@
 #include "xgbe.h"
 #include "xgbe-common.h"
 
+static int autoneg = 1;
+module_param(autoneg, int, 0644);
+MODULE_PARM_DESC(autoneg, " Enable/disable autonegotiation support (0=disable, 1=enable (or any non-zero value))");
+
 #define XGBE_PHY_PORT_SPEED_100		BIT(0)
 #define XGBE_PHY_PORT_SPEED_1000	BIT(1)
 #define XGBE_PHY_PORT_SPEED_2500	BIT(2)
@@ -1867,6 +1871,9 @@ static enum xgbe_an_mode xgbe_phy_an_mode(struct xgbe_prv_data *pdata)
 {
 	struct xgbe_phy_data *phy_data = pdata->phy_data;
 
+	if (!autoneg)
+		return XGBE_AN_MODE_NONE;
+
 	/* A KR re-driver will always require CL73 AN */
 	if (phy_data->redrv)
 		return XGBE_AN_MODE_CL73_REDRV;
@@ -3159,7 +3166,8 @@ static int xgbe_phy_init(struct xgbe_prv_data *pdata)
 	switch (phy_data->port_mode) {
 	/* Backplane support */
 	case XGBE_PORT_MODE_BACKPLANE:
-		XGBE_SET_SUP(lks, Autoneg);
+		if (autoneg)
+			XGBE_SET_SUP(lks, Autoneg);
 		XGBE_SET_SUP(lks, Pause);
 		XGBE_SET_SUP(lks, Asym_Pause);
 		XGBE_SET_SUP(lks, Backplane);
@@ -3188,7 +3196,8 @@ static int xgbe_phy_init(struct xgbe_prv_data *pdata)
 
 	/* MDIO 1GBase-T support */
 	case XGBE_PORT_MODE_1000BASE_T:
-		XGBE_SET_SUP(lks, Autoneg);
+		if (autoneg)
+			XGBE_SET_SUP(lks, Autoneg);
 		XGBE_SET_SUP(lks, Pause);
 		XGBE_SET_SUP(lks, Asym_Pause);
 		XGBE_SET_SUP(lks, TP);
@@ -3206,7 +3215,8 @@ static int xgbe_phy_init(struct xgbe_prv_data *pdata)
 
 	/* MDIO Base-X support */
 	case XGBE_PORT_MODE_1000BASE_X:
-		XGBE_SET_SUP(lks, Autoneg);
+		if (autoneg)
+			XGBE_SET_SUP(lks, Autoneg);
 		XGBE_SET_SUP(lks, Pause);
 		XGBE_SET_SUP(lks, Asym_Pause);
 		XGBE_SET_SUP(lks, FIBRE);
@@ -3218,7 +3228,8 @@ static int xgbe_phy_init(struct xgbe_prv_data *pdata)
 
 	/* MDIO NBase-T support */
 	case XGBE_PORT_MODE_NBASE_T:
-		XGBE_SET_SUP(lks, Autoneg);
+		if (autoneg)
+			XGBE_SET_SUP(lks, Autoneg);
 		XGBE_SET_SUP(lks, Pause);
 		XGBE_SET_SUP(lks, Asym_Pause);
 		XGBE_SET_SUP(lks, TP);
@@ -3240,7 +3251,8 @@ static int xgbe_phy_init(struct xgbe_prv_data *pdata)
 
 	/* 10GBase-T support */
 	case XGBE_PORT_MODE_10GBASE_T:
-		XGBE_SET_SUP(lks, Autoneg);
+		if (autoneg)
+			XGBE_SET_SUP(lks, Autoneg);
 		XGBE_SET_SUP(lks, Pause);
 		XGBE_SET_SUP(lks, Asym_Pause);
 		XGBE_SET_SUP(lks, TP);
@@ -3262,7 +3274,8 @@ static int xgbe_phy_init(struct xgbe_prv_data *pdata)
 
 	/* 10GBase-R support */
 	case XGBE_PORT_MODE_10GBASE_R:
-		XGBE_SET_SUP(lks, Autoneg);
+		if (autoneg)
+			XGBE_SET_SUP(lks, Autoneg);
 		XGBE_SET_SUP(lks, Pause);
 		XGBE_SET_SUP(lks, Asym_Pause);
 		XGBE_SET_SUP(lks, FIBRE);
@@ -3279,7 +3292,8 @@ static int xgbe_phy_init(struct xgbe_prv_data *pdata)
 
 	/* SFP support */
 	case XGBE_PORT_MODE_SFP:
-		XGBE_SET_SUP(lks, Autoneg);
+		if (autoneg)
+			XGBE_SET_SUP(lks, Autoneg);
 		XGBE_SET_SUP(lks, Pause);
 		XGBE_SET_SUP(lks, Asym_Pause);
 		XGBE_SET_SUP(lks, TP);
-- 
2.25.1

