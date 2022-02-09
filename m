Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECC74AECE4
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 09:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242349AbiBIIkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 03:40:47 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:52174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242343AbiBIIko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 03:40:44 -0500
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on20716.outbound.protection.outlook.com [IPv6:2a01:111:f400:feae::716])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14CB2C004386;
        Wed,  9 Feb 2022 00:40:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UyBu60HaEAvMMTIkW26gAvT7TRVNyew1VVXXRarEdhtxBWN0CQCLzMnAlScF88OdgGXpP+NHdidoVw54nFVpZ3M0TE4hCluiuwTi2q/XMDfWRXCcT+GQLfZ94okVCuqN4CWxFpT0gobVhChUFLJTBSlTZNX3pdJcu/3eCcWtsjt2bT8LWO5v5czlsDJMjRIxUIscaWbQmUqpAfsDUd6MoMGPbRaSV6vHr3dFX9efpUKzXhQU2EMXFJLuqO+/suapep9HETKLVPSxS64uwPDNmP6l5Ad4oCcnCFi8vLTwV/Kiu8bPO8RcNVopvhJ1Aw/CYLCmg7CHjmHCogDmAcEiXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GxsPlDhgobC6O+ovZ2hYF3olKIKu+FV/9XDiePKQvwI=;
 b=L2UkVSKXxPHKu/uIk9Q3crCEjghACWuIUGi5+7KyBm5bmRdABVooa1SzWtWtCXS4G5DiqjL+OPAezHPSnqZkGD8V7Dd+TJJ2k20sbDbRRjMRf6vFHDr8xZ+Ysmt4gZgHZG3T9LZpFJUBfiuE2YiAjiaMlG5vfBGFd3K0E+Bp4yt3MB6bvLgs0Mcd7JohsYYk5YKdy1Uaw2jjg6kow4FnDDjCoe0vIXFHq5bYSRouoexk+YCp0rc4nJcMRuRlDRrGu8I8IX0E0xPh7sGW5CxdyiWic8395uZE5a8F6XE+pQ5MOhKGYoyoOS2LQ5CzYcjVgTsT+rAN3+LgGkZ23Lrgpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GxsPlDhgobC6O+ovZ2hYF3olKIKu+FV/9XDiePKQvwI=;
 b=Mbo2yQiwjRsaI6lUViqviIQMzL56dUNxNL/Skn4vIMUrpslsJIryDkN0/tSHklJ2XOaTJmie8x7phQXQvcxf9VyCNeRsLDvOeWjjw3898I14p0ahNKaVsSaXGbmm7JqJhQfAU61NFLYDvfnwOVyor4DK5BMvCDEXc4N9460eBwQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
 by KL1PR0601MB4387.apcprd06.prod.outlook.com (2603:1096:820:7a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.14; Wed, 9 Feb
 2022 08:39:27 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::80b4:e787:47a9:41bb]) by SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::80b4:e787:47a9:41bb%4]) with mapi id 15.20.4975.011; Wed, 9 Feb 2022
 08:39:27 +0000
From:   Qing Wang <wangqing@vivo.com>
To:     Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Subject: [PATCH] net: ethernet: cavium: use div64_u64() instead of do_div()
Date:   Wed,  9 Feb 2022 00:39:19 -0800
Message-Id: <1644395960-4232-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: HKAPR04CA0016.apcprd04.prod.outlook.com
 (2603:1096:203:d0::26) To SL2PR06MB3082.apcprd06.prod.outlook.com
 (2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f9b2cfe-1903-46d4-2055-08d9eba7ae6f
X-MS-TrafficTypeDiagnostic: KL1PR0601MB4387:EE_
X-Microsoft-Antispam-PRVS: <KL1PR0601MB4387FB78AD9487B9C0FB056ABD2E9@KL1PR0601MB4387.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7oEBNKBplJ+n4J4hWxD74+/9/Pcbhi3WZsfr0U3QhrhJzUVYL2kluiY9MWDd9LbkYXq7myKY1838evQG0pVX0OXLiv+k1fKaEgNVqlJzBVvKOMGwJS4239hsQm23h0pdyXGkL02IyRbYiEWAd86lkwSUlVveQOXZtfmYDiyf97DwBhUYtciDdq4D3tmC52vqSVaMQliT03JmkFTCoYVVqB5W9wjpTuUSPNQn1ILFTvxFXIYgPaxCTbdDEe9fSu60V6rkz1ebmlamEIVuHeAdGUnMV6egs7yYgAYgK50NhpMZKv1ubDhWHhO4oHsdE+cE/WAu7F1G3M5vIeCl0v+dALnHObfOqbSM7YlDz6p9ZryW+6qYGArpkaJ1HNMpWirufPQRaQApnyCi9DGWGEjyw3Gh6AEHPmnbzL2zLSGgqhFMJ+Bd3tjP8vlxHe+UGSJz5Pa+HXQSzFKDr0RbzdVblB5okn/B+g4fCpKGNqBMZYLbKewrfCVv8/ka6+b7Ox27+Vlcsp3j1uYayZ5ipONh8/1FcZlWJ6yfrfkW0zrmPwiwVNRuQ6rTH4nA37nFavkFa7HGR0bK6H6kqNh2WJVXQAEUILSHRGvIHia0azJDh3KDOI/mCC61zFex6MEqIYBY4207oy3+SCAkqIJEjqQkhMcHrLXTh4j4PBHyu7wbXY4yC9cJCBPaPWqjQybQvoFZNIub0RiUKZ4CCHt3xdbxmw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3082.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(4326008)(110136005)(6486002)(66946007)(66476007)(66556008)(8676002)(86362001)(38100700002)(38350700002)(8936002)(2616005)(2906002)(107886003)(36756003)(6506007)(52116002)(5660300002)(6512007)(83380400001)(26005)(508600001)(186003)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wMVh4JQwstgbnv35ltCKyXd26BkU1waqT90WVovJJM8TfUHcsW7pHLRZsggV?=
 =?us-ascii?Q?csSfKcxQ65cJeCrxNgL9Qng48ZFJIKhboflysZQZicAiQ+bK46UnLBYulFQ+?=
 =?us-ascii?Q?d9hXTpiTiuFjE4Kai08RLizcPn5J/HHDohTzYbx7o2sO3bR467mJmuiBuawu?=
 =?us-ascii?Q?9egvns5seqRyAGsM/gZZSz/eD96bG13531Yx+eNoTSv26WAJV8TCPHOuFpDR?=
 =?us-ascii?Q?26pDbkAerWAdq9ZINl5t5uTuynLWckHyOU4G60DHUw5pqbVnBdAxk5LB8HLu?=
 =?us-ascii?Q?XFDURmlDImAYPFIHBWskAo8nYO+/O5nF1VOIP4MNx5mHW8LKZxuRhNFutm3F?=
 =?us-ascii?Q?BQ+RF0Jm1bjwIAZeF3TkvW13n/W/ZF8KTgYqaneUZE4MdOC1I/xTRkkdx5eN?=
 =?us-ascii?Q?nX3oobpYnc31utrBcQ2jRaiWBqTxzHsb6GlM1/VfLNiq1CDTzRzqe1UfFP5b?=
 =?us-ascii?Q?qzn5qfB8PxjZi5iuNF9H6m2BDLW4DlCBlAKTu8Q7rKln4r4lPTRKpW/xzSHu?=
 =?us-ascii?Q?SponLf6SgJrfopjnWncBu+QszSpqoV8O4re0tz9nJORQIFWz6ure+0ZLhGQ1?=
 =?us-ascii?Q?hB0/hvedhPtlKyDZaB8UO19h/Jj0+YTVVVPBm9l2eXdSXvdQUwTtb9Ga5Et6?=
 =?us-ascii?Q?Blx73HBzx/CDreDb4t5kgR/l7PAsLAiu7Xpu+g6eQ31NegdUTKv3T3esuPXZ?=
 =?us-ascii?Q?VV8t3C6mW9/ZF1LbIea5Pwz3LETckTdb0wnNrNHjLj0XJGlRrADR6iD4+mRT?=
 =?us-ascii?Q?cnpWh2ui0aYyhl9qBBJVeABFOaH8EZ8CbDIhnTiTzyGnUWOKl6I8Whd5eplN?=
 =?us-ascii?Q?4FHvUXUvloiy0+JBuLc2RyrUtcpSuX3lF2iWA32mEG43dUzZECr3BR6LS1Ot?=
 =?us-ascii?Q?gKyyLV8f/WCAqIQQNYEBk7UsxKC38+bsmhzgOGWn9sBovF0BJHo1FQlZg4gB?=
 =?us-ascii?Q?yuUErRQlX7l6TxUT6Z6h9+Q4AF8WI7ZZn6/4m0b7273KGAGrrErwEPf78Vhx?=
 =?us-ascii?Q?6XDrQfNVFkpKP3o6kRBeh1BM8lb8rw6pN/Rloy9K7Y3En7qzeRIEGxn8D6kL?=
 =?us-ascii?Q?2d5RBLkDOzKBlJJyHDdHRGgfDg4aqIGWPqfS8GqiJs21aV7Pk6UGuHMPDPgd?=
 =?us-ascii?Q?LsUw0efNg4Ii1A7QcOibnopZLj9iTI3tb5JAWw7DgsQliXBB107vx41GIVN0?=
 =?us-ascii?Q?aiqyC0qkfBD4Xvg6ATfshWUQiwNtCchZbapttJFBIyVW0S+BXne8gecxM+pt?=
 =?us-ascii?Q?SoFP0JXTEhwbWlmnofUoJqz2997ix4llfkA4RTf+R46I0Ng+Sl0tNC5457Do?=
 =?us-ascii?Q?FOJbagvkZpIwLXbCiGd16s7mht3eCcyAkxuQVsEu0UI3bB1rq+XYHocLfnQe?=
 =?us-ascii?Q?dFyrYwAh4g5GODkjONUmZpxPKbQfARqAH1jYKYen4kzaBbsnP894owQ7Nodw?=
 =?us-ascii?Q?KBSz46Kl72ckg0rCM3N0NM5Mc0OVKQgkn4A4T48iZMIlfEHcrHdFLVKO9R/8?=
 =?us-ascii?Q?WqGYilk8e96OGbQE+7mlC/67/22YF4iaT1UJIktpAGoQBNukTS18dsiRp+zw?=
 =?us-ascii?Q?LhJ9GxzIRqYZ/MiTgLR5trYAigmgvZcHLhpAMPwdbzHJ0tT+MSUEtqaip5kL?=
 =?us-ascii?Q?PdBzGXLIpSGy5fHMeHnYLCw=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f9b2cfe-1903-46d4-2055-08d9eba7ae6f
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 08:39:26.9626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CbjLUz/seISY4qlEl0ThQIvluqks7pLRfUIs1G/I5T4ixm1LF7FV2+2ZBkAgC9zvfoSI1S1wB4x9mPcZtwHyvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR0601MB4387
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Qing <wangqing@vivo.com>

do_div() does a 64-by-32 division.
When the divisor is u64, do_div() truncates it to 32 bits, this means it
can test non-zero and be truncated to zero for division.

fix do_div.cocci warning:
do_div() does a 64-by-32 division, please consider using div64_u64 instead.

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 drivers/net/ethernet/cavium/liquidio/lio_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index ba28aa4..8e07192
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -1539,7 +1539,7 @@ static int liquidio_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
 	 * compute the delta in terms of coprocessor clocks.
 	 */
 	delta = (u64)ppb << 32;
-	do_div(delta, oct->coproc_clock_rate);
+	div64_u64(delta, oct->coproc_clock_rate);
 
 	spin_lock_irqsave(&lio->ptp_lock, flags);
 	comp = lio_pci_readq(oct, CN6XXX_MIO_PTP_CLOCK_COMP);
@@ -1672,7 +1672,7 @@ static void liquidio_ptp_init(struct octeon_device *oct)
 	u64 clock_comp, cfg;
 
 	clock_comp = (u64)NSEC_PER_SEC << 32;
-	do_div(clock_comp, oct->coproc_clock_rate);
+	div64_u64(clock_comp, oct->coproc_clock_rate);
 	lio_pci_writeq(oct, clock_comp, CN6XXX_MIO_PTP_CLOCK_COMP);
 
 	/* Enable */
-- 
2.7.4

