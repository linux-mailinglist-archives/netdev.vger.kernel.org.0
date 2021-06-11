Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C01D3A3CC9
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 09:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbhFKHSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 03:18:35 -0400
Received: from mail-mw2nam12on2060.outbound.protection.outlook.com ([40.107.244.60]:30741
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231621AbhFKHSV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 03:18:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gD+jup3az9WQAeK8T6rxo46XEihc1+qUpvCkfh9SFq/9YPKHMP2AljrP/YHMAME2U/arM8jG9CGpfZ8xj2qBuoLjY/gPLCJMF374zcef66+IXqe0qmj8XtCTE4TWyCfoFyOoEExFn53CMC71zX3RME7GYCnBvVC/+/MigHE6WDJVz74bRzTxnuhoRO0I3kkPiwIuRl239U2jEib5wcmHm7dlruGhOwXU7YeKlRBP9ZxSFIyhDS45/cBcwCjs8/B7nO1AdOxMSe0l0ioyaZbDv05Wy6z5ERlTr2b5ah1Oae6jqOsypWejckCBqhXV4QB1tg37POofiNk1dragVEm83g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iDL9tD5KJA6K9pxPzQbJPVHsl70gjBpibDW4fkMCnJY=;
 b=NtkQ4uetx6T11FMGxLvykh22GBEFo4bUaXNkHzFcX4Og+b+vl0wimj2jXiBWf5fZ5eiR7znYo5MbQJ9c2qZeS06ruu3NepPIeVSwxYxHebwfhBRbQAFx3lG3opC0Y7WVQzig9QS3VmgietevyhtpujvMdtBddl4uy6HYILS9gf2aZnaPncU7MS5RpH31kGwCqhkYJWynLy8jiCt6cK9TC3vp4AX+Y4Kor0G8lOmXBqN8dD5MYodb3JKvq61SetgPJv4OqTMe6NkSCrtq9bjKuNmhPPNaZVTJ8+SDnT4hf9rqx/9Ooz2JKM0L6SiVe9uxD9dXGIWQZMBufFDKPLWd8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iDL9tD5KJA6K9pxPzQbJPVHsl70gjBpibDW4fkMCnJY=;
 b=dFDN36c0Owt5E0jtHeXqeWFXCWmqBpQWP//y85HcWAmrFkhTJgrsZIBRkAneP8esl0UMXXWOz8PNg3cBruHhoVyp5Kqxo1L58Fmyg4poM+wOn/pEEDpKYjE+7OXN00MGqNzsWkq+uHTrAsWfeNDcj/jmOsm8aVuCkxu4wgswJIc=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=synaptics.com;
Received: from BN9PR03MB6058.namprd03.prod.outlook.com (2603:10b6:408:137::15)
 by BN6PR03MB3073.namprd03.prod.outlook.com (2603:10b6:405:3c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Fri, 11 Jun
 2021 07:16:21 +0000
Received: from BN9PR03MB6058.namprd03.prod.outlook.com
 ([fe80::502a:5487:b3ee:f61c]) by BN9PR03MB6058.namprd03.prod.outlook.com
 ([fe80::502a:5487:b3ee:f61c%4]) with mapi id 15.20.4219.021; Fri, 11 Jun 2021
 07:16:21 +0000
Date:   Fri, 11 Jun 2021 15:16:11 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: stmmac: dwmac1000: Fix extended MAC address
 registers definition
Message-ID: <20210611151611.7b6504ab@xhacker.debian>
In-Reply-To: <20210611144533.303a38a0@xhacker.debian>
References: <20210611144533.303a38a0@xhacker.debian>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.147.44.204]
X-ClientProxiedBy: BY5PR17CA0059.namprd17.prod.outlook.com
 (2603:10b6:a03:167::36) To BN9PR03MB6058.namprd03.prod.outlook.com
 (2603:10b6:408:137::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (192.147.44.204) by BY5PR17CA0059.namprd17.prod.outlook.com (2603:10b6:a03:167::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Fri, 11 Jun 2021 07:16:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb1e1f7f-d750-4342-f167-08d92ca8d08b
X-MS-TrafficTypeDiagnostic: BN6PR03MB3073:
X-Microsoft-Antispam-PRVS: <BN6PR03MB3073B1C494812F4DE5701CEAED349@BN6PR03MB3073.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W6SW1+2B2NyaTFm3a2WdRZyi6s1iN6fZLvuYOghnjnt/G/EZEopjsUf5BQxRFj1CQ2OX3SVDw9VqY4kb4Okbq/xY3b2YnsU7wsWiftf1xr7EggTN2H7GWJXWOWnK4bOeohbaKfoPLZfTdZsLsMmM9miwJkvaUAk+keg9j+HCFvl11bJbFVCbfPmcIeuji8UVyDPBFbqolnhBWPH+4utqc/9fMqWshKqmNcgVovyA16IxvoNGOSj6t9wbExQpcEQIBAXjgXj9dZ7CtP6rjZpQQw4x1GqULZ7gelpP0vUucCry+pjdu/USw/DNnQz9TmvkVOT6jEpYFqGuAwfRHQRbV8wz8TGmh5V3CgHsALx+6ENE0cbzhA65SB8pFMapaoXOStPLlMMfIuWBSg5QLaHfcVsvy4fcIU3o+I/JZQAiD+gqIP5G/fUrW3lCdXXdfWTAAU8u9h4SfRHu48U+qHYFjkDtAlIUTPwDkAHqbMBkFg7M8gmmM0jHeJNuIyMf9KN6vSxLpSj0SMRgFt1M3yGBJ7PdX/vcYfSe93UyWjJRUvV21xCh6FVse1l2TZV4MbihAS2clNEYHMOzQPa7KiWq+HP+IX99NqMJY8H+1EMwS/ZkxUx1suk4J75+WaSvm8f6EJ+hrwEvwp9cc1R0TyzyF4MfnXf4pxesyV5NOzAq3Iw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR03MB6058.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(136003)(39850400004)(396003)(346002)(4326008)(55016002)(86362001)(5660300002)(1076003)(6506007)(66556008)(316002)(38100700002)(6666004)(38350700002)(2906002)(478600001)(8936002)(16526019)(52116002)(66946007)(956004)(186003)(9686003)(8676002)(7696005)(110136005)(26005)(83380400001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lmdeaAq6zB7BlbPf0Ee7sAu/+FyyukQuTceDqKoCOYCMORSWCqzc4eN61rnS?=
 =?us-ascii?Q?OuRXAxq0Sh06dVO0UiGoFHfaQvWcHaC9gv6wXHB7dgXsP2NdQt2Xnb1J9CDc?=
 =?us-ascii?Q?SznSFFt2hZ549r8F67iNjXETbvmrZ4dIts798y40ie/36/YtR1fKfqeAbBNP?=
 =?us-ascii?Q?yCKOdLsVrzRqAFwV5wPHB8I9YVk+sGkSUdK0Et/7HvXit5MXiz9Z8VfvIvpF?=
 =?us-ascii?Q?0gLvyHy68xcAwzZJRCvqgt7//86CvDRh0GnejzwdPkIkq8pEP7H7G7gPSu4u?=
 =?us-ascii?Q?DY6PvGxaTqq53HaeOFcqHYyceSkNpiXhRM/RQFJKWY4bxBebf9QEu8T8gDYj?=
 =?us-ascii?Q?Z/pczyRC3o/okoQ+xf64+98RQ+uxRFiZ9IVXs3DyHxnPQU+DJCKXkUt648gP?=
 =?us-ascii?Q?EvKcwSKITxPmifkdGdNFWUaX2ezX4k/CxNRW/8xdUBF7sWeuusgBFI45s/B+?=
 =?us-ascii?Q?fXri7XYqUbR3x+CNla5zq8EmezwCigs2y1rzKzWCap5VTuW1XsH22cvzfEEW?=
 =?us-ascii?Q?d/itymJEWW3WvNssSWDS/q7ePhYqpnRE1pIonkLpLqhvd8K9lo5thdewIo6r?=
 =?us-ascii?Q?FUbcxT9ayZEwsEaN3lN1Alta8cr8hNjhwhNGiiVBD6yvcePWt2gnIHxRArJ7?=
 =?us-ascii?Q?nHUBAPNTkUWpZxuLYmiJLaNiyUxEZcRbq0CCKcFzRTcEqMf6Nlh1GUnkzNXk?=
 =?us-ascii?Q?sva53gw3yD9jXbdjy3yjSCXjdBZd2U/vcWUTrG6O4E+igIsy4bP8GjHPbqRJ?=
 =?us-ascii?Q?5vduCDsEYiyL7s6AA37zo/+tMOVy+7dybmHRE6FNLVRS2NHyG73e4+qO3nh0?=
 =?us-ascii?Q?36e1fCJ2TyJsvTqTUnI7XN0WIESYLFLGikJ0yrcTR4mm7GoxaaDDLbJpkhcB?=
 =?us-ascii?Q?ItpPpfEkiZW/TH00UMeJDKQIN5UCZnjHWzwOkzWjLdnwGNDpR65Hridw0oJq?=
 =?us-ascii?Q?K/LJuyrU2C2bSpXq7rjhFsW+OzR5yJ8AjjR18XZjPpPYrdKvOFP2YP7UDWg6?=
 =?us-ascii?Q?CGJ+oXM/xNTqjLAJeZ9d7HiadtsVyt6CHiq0GSBsTJrh8PophmHd/ID1oNCN?=
 =?us-ascii?Q?ADTKB37DPp4tXy69TnTexRyhY1xynbXrEHg0Fwn7PMxeIKsbiAyqIzAKkLeq?=
 =?us-ascii?Q?EDfuMRFAvjyPzcLsquOjy6NjBkzDmKRJ/pr7NQRQkJutiWxNfbkE1M2gTdrq?=
 =?us-ascii?Q?yh63oxGemq2iPA96CIgmL6DHMfSaaCv77AC+BB3Lltu+Zw3we4xu28ye/oUs?=
 =?us-ascii?Q?7vNyM8AcVNAvQEX7tuUqMxVSYVVQRX+SBZUs7GcODURDtOIdwXBRuDDVmIIV?=
 =?us-ascii?Q?h7UeHeic3TI5+MkQtxul4RCj?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb1e1f7f-d750-4342-f167-08d92ca8d08b
X-MS-Exchange-CrossTenant-AuthSource: BN9PR03MB6058.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2021 07:16:21.5253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hx88mjXxZZjUhyR9Aqt2RbRa9M1RTFayackdo/YQxbsbByYl0Q/YIdCdJqRO49679ZblWSsOuVTaM0lMLhFL5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR03MB3073
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The register starts from 0x800 is the 16th MAC address register rather
than the first one.

Fixes: cffb13f4d6fb ("stmmac: extend mac addr reg and fix perfect filering")
Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
---

Since v1:
 - update commit msg, I.E the 16th MAC address register

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

