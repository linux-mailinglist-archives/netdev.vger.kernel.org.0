Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A47413A3C2D
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 08:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbhFKGrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 02:47:47 -0400
Received: from mail-dm6nam12on2059.outbound.protection.outlook.com ([40.107.243.59]:41172
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229480AbhFKGrp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 02:47:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mDLHuuY2dQxEnAcwXqPisBYuwZguH3HZzjzAucHog/lhnMsfBXmFkRuSKUYxq8hY0cr9I0nHRshKI/Oyd2OEIDVnYNxXjUNSw5+GMxyVm38TeCRQsFaikyy4/chlZV77JK5lo843H9kpeF9M3w9c07+XWc6xi1Esee2j9GocfKWdayWKrKPc4QDq/lZ0XMfwYbAo9HGovmcy1sJBYwMMuDf/USwniD0a6hdWGLCxl7pE7FGMJPypu8MAw5aRSKvhxWbsvLpKd9yqLAwGhA0zuZz0O0F6FMhSdADeJdev4DfGHiyTMiDVCSMfSG6JSUSuTeMVsTjQ4cMPVD4mmtQWDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UccBwO5/tj5gbJlowdpZAxaI1LiVBn8ZRlrA3xIJtCs=;
 b=Lc+GjZrKmCPXiFe/n7Eu1+s3+hYFOBG3hVEbsOzXxvrxAvr+rmQ2NovxJY5sEAE7jr8hLEHiRION75b96Sb4GOLoe1sTkRlUoOk7OJI6YFR3gsbTAEyXlmAycGb0WuAiLQqz5TqAmWfgM3mMf62j0EGL11vB0uY3KyZGagdgebJUMFzuFioEkRpZqWU9aD5bPLQDQv9SiJiQUuyAgjb43AwArefspnM7yDb09BeZTSwX6/dQC2xSu5kO4kHrEmwRst1+z+ZwYfTF31SRk/BCoJr6DFVk4V/qebsr1gPvTfSEgKKsgWD5VBqnm2zk3mYwqlTV69R8/tgzNAb+KCrRPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UccBwO5/tj5gbJlowdpZAxaI1LiVBn8ZRlrA3xIJtCs=;
 b=IAP4k19xh1PH2lLB3XIK4ipJmGap+83EkNg7IJMUBrLOx7pQXOQ9XnaAutloUEH7nDXTAprvCACjIIiNItf1eAaO0aMkrpHTw9xVurgU9LyRBxmL+02SBaNjhbExkajKE1HvWyRQWxEtz10jskEE2k7uSp2rPEWe/iMMiDwcE+o=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=synaptics.com;
Received: from BN9PR03MB6058.namprd03.prod.outlook.com (2603:10b6:408:137::15)
 by BN3PR03MB2387.namprd03.prod.outlook.com (2a01:111:e400:7bb1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Fri, 11 Jun
 2021 06:45:46 +0000
Received: from BN9PR03MB6058.namprd03.prod.outlook.com
 ([fe80::502a:5487:b3ee:f61c]) by BN9PR03MB6058.namprd03.prod.outlook.com
 ([fe80::502a:5487:b3ee:f61c%4]) with mapi id 15.20.4219.021; Fri, 11 Jun 2021
 06:45:46 +0000
Date:   Fri, 11 Jun 2021 14:45:33 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: stmmac: dwmac1000: Fix extended MAC address registers
 definition
Message-ID: <20210611144533.303a38a0@xhacker.debian>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.147.44.204]
X-ClientProxiedBy: BYAPR07CA0011.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::24) To BN9PR03MB6058.namprd03.prod.outlook.com
 (2603:10b6:408:137::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (192.147.44.204) by BYAPR07CA0011.namprd07.prod.outlook.com (2603:10b6:a02:bc::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Fri, 11 Jun 2021 06:45:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d08b5ee-0dc5-473a-47e9-08d92ca48ae2
X-MS-TrafficTypeDiagnostic: BN3PR03MB2387:
X-Microsoft-Antispam-PRVS: <BN3PR03MB238790CAC8849C67AF7B6EB2ED349@BN3PR03MB2387.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1332;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1rv8lSbL5De8caiy6tAXdR6VvxGb15hvbkPYbz+W8uxv5uyQgqmSI+uXd1QRRT+9Q1z/ikgSbYP4dyUYqaTcp0wOKcm8CXOYczmzTKNmsZL7dSgpn483SZwJSuirhjoKlvDTXAvh2rJn67gM9pkm26sOY701NtL0zcWEL5dI3KBUXtAxBWMlcnUjGscXsDl05G9gXlcOmBjSq7Kbr3UIHaPxcFSiBCtbruBKhUJsGilUcxXO2EEZmtF5ZZUxSoABa7GKpKahFXkkjEn0TLKg9rV3lI1Nx4pP9Z3l3IgmN2nkak6/yj8uJV/7zP/pkmukEj/V3tPnK0rVmG1/KHIKcP7/Lb5prZqFceTlacs9CKXRHtCVn5vdF7u9j/nrpckYwAvWtwjp7U3rY6vWZbrxhB+w7scR5wEPuCtwLGOLLLjPKNWzC2yfA/D++7BkR+9CcFd7iso9WYMVslHpWnRmkVqk9cuLbmzk9CfONAxofcujYmi5rsqBc9qqhmMTX5H0PhOhEka7riHAVUMVmbzR0aISVxAs1S5bmbu7DfPfNt1xPts0/uNs+o9f4vMjpSYHMzbjyZEZq7xzFIGzFia07l1/y+h+zdQ9oMs2tJcntwqp3C520ZpGblgtAAbslJYawNK4gcrVU3KQ1AKFEA8iMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR03MB6058.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(346002)(366004)(136003)(376002)(396003)(6506007)(1076003)(6666004)(2906002)(478600001)(8936002)(55016002)(83380400001)(5660300002)(4326008)(52116002)(38350700002)(110136005)(8676002)(7696005)(38100700002)(86362001)(66556008)(186003)(66476007)(66946007)(9686003)(316002)(26005)(16526019)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?acy/RPNktnX/vPr4n/ZXv78gCOloSwtt4Wv224GRf6INFeD6DEWnZcKrRbv+?=
 =?us-ascii?Q?JhkaDzDk7PrC4a/2CwShNOli6y32KZbY9+9HqdmPunL7acvc9XXwfYcILWr1?=
 =?us-ascii?Q?oiunFN8oXr09FthoSOGjPy8SG+AkFKSoBu19P0X5ASV1/keVYTYtgwSL2fgn?=
 =?us-ascii?Q?mRJ65A8mgJJXNzdrSLCeTrZRpoxyUtkuzrBUj5Gd17ZZMfZ7Joz0XN3ioM3e?=
 =?us-ascii?Q?yTd/KFhUFnmskBc0MOyzCXssJR7aLJ0XknSB7rWZYsxQ8U7uWm1GAvllQsw8?=
 =?us-ascii?Q?I02/B3skfAvm8zUCFiTPy3D/gO7eNL2IoubgUo6Oniils4vZCTv4ZG40dR8/?=
 =?us-ascii?Q?WkWq50UOX1+80WUAzGSDL3CyRU3e9y2z0AD/kj3HC7L/dG1suXD3mNarARo1?=
 =?us-ascii?Q?905ZUCxIjrGhmY0p5gAqZyndMHeTUQamiXo88tybGNk4HyZPtbwwEl3+hBN1?=
 =?us-ascii?Q?j+nvRZl/HGsQ2TL5vfADxf1jIxoYr/PwjEeuZTijbuDv1lsHrOVeuYqQWRk+?=
 =?us-ascii?Q?UQpU9jK+LmFDsQN//DQiks2L66IKo4MPjOt/Ihs+cxUDbrYv7J8VQFs2W0pc?=
 =?us-ascii?Q?gEwTWHJL0c6XDBjWpxsS5qAQzqXiczI8kemt42jfiREBi8wpVmxUpjWe7trC?=
 =?us-ascii?Q?1pNQoHSUmZkYNMBrJablaKD3rgSiiEum0/6TbCN3CXdFM5BL/7hvrNFo2ZOI?=
 =?us-ascii?Q?gLCxT3EA724MVaXC1tgQSY4MCZtfutJUKCPcFjNOo4nzWFJHRvwul4VlpmNk?=
 =?us-ascii?Q?qjzCBXQ/iOh1XRg3ECkgxZeFdRvyf9NFFRXVLMkld49zmy2vcW8W93R7gvrk?=
 =?us-ascii?Q?d5AR6eTl3GJHSX2zpSDwuTHRf+Wgyq8/86oXPXFBq3VzuTQNMyVOQuoIbs0F?=
 =?us-ascii?Q?UeFDCwdwJPyS7+8u/K0ljobUt2SYiAgjjoFcJkoPD/RzlnQG0Z00coo+dTec?=
 =?us-ascii?Q?TVp2zPTJzfnX4AbMcIQKNObdjAyGlC02b/jcmuGsKXqYMBzSAJ9OdgOsVNY/?=
 =?us-ascii?Q?Xl6JPVoAa7P5wtQsziK5Cw5jJQGVS4eEqA6lsj08Sx8aagu0orx2A5YT2Nie?=
 =?us-ascii?Q?h/TdukjFITLIynEJmuw0AyWyb4/RD1kM8cRtRZyK+IPGJehGM5ETtqUhsH5L?=
 =?us-ascii?Q?gUmwwKxWResBc7dtLjZSb8dpP4GRRaxjE1J3EPpmNr7v5S8l4RRxfwtjPgkU?=
 =?us-ascii?Q?UwQRrZaRawIt9xp3ioFSSAF6Sl59aRlIe7bUv/9SOvCzP5SjUTL0RGfva6ZZ?=
 =?us-ascii?Q?eGIH0W669DjM09NrRjqEGlI8hWxwXDfzfcGWyP1ohOxh1l3cS1N+X2YJdmVT?=
 =?us-ascii?Q?ETYFvCTKPIv7I0gFoMJFBh6Q?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d08b5ee-0dc5-473a-47e9-08d92ca48ae2
X-MS-Exchange-CrossTenant-AuthSource: BN9PR03MB6058.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2021 06:45:46.6666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RSVxX4oW/6cFnp4LM3fuk8GYNjZ99qrPufC7DNZsUasMWNNxozodDvu/Pran1s1YO99UFPqb0iMi/CKjWWWGLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR03MB2387
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The register starts from 0x800 is the 16th MAC address rather than the
first one.

Fixes: cffb13f4d6fb ("stmmac: extend mac addr reg and fix perfect filering")
Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac1000.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h b/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
index b70d44ac0990..3c73453725f9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
@@ -76,10 +76,10 @@ enum power_event {
 #define LPI_CTRL_STATUS_TLPIEN	0x00000001	/* Transmit LPI Entry */
 
 /* GMAC HW ADDR regs */
-#define GMAC_ADDR_HIGH(reg)	(((reg > 15) ? 0x00000800 : 0x00000040) + \
-				(reg * 8))
-#define GMAC_ADDR_LOW(reg)	(((reg > 15) ? 0x00000804 : 0x00000044) + \
-				(reg * 8))
+#define GMAC_ADDR_HIGH(reg)	((reg > 15) ? 0x00000800 + (reg - 16) * 8 : \
+				 0x00000040 + (reg * 8))
+#define GMAC_ADDR_LOW(reg)	((reg > 15) ? 0x00000804 + (reg - 16) * 8 : \
+				 0x00000044 + (reg * 8))
 #define GMAC_MAX_PERFECT_ADDRESSES	1
 
 #define GMAC_PCS_BASE		0x000000c0	/* PCS register base */
-- 
2.31.0

