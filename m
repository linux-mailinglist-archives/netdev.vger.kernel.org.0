Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB4023A009
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 09:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725806AbgHCHIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 03:08:23 -0400
Received: from mail-db8eur05on2079.outbound.protection.outlook.com ([40.107.20.79]:36160
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725831AbgHCHIH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 03:08:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E1P6vsWgtg6wiEf88Ol9Bu/jFWGddkxaodt78oDJYrTa9KdO0/NvY0fILAGmbybbIify874BB2uIeDD5W0j6suQTRXSoVQ+BhiLPHM9PdxCjlKjRIoQYJHKxJc864rcXFHOCWQbh72nfSnFYf7P1i0QHT78I20fCoXnpsEf0lkBIgvpvmCYEUYCBV6EaBxMY0z9RlMJo5639QdsKo+lEHhXQBXirwV488TOCHhzljslWyvqnm3/rU7zUp0KBBIDoNIWGRPsLfLRhTFwZ/hTwB7VzSCz3fkSEsRZD1VSIt6yWK7buaYs6Sihe/PQiQ03OeEUpyhXvCusISaJZceqnXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D5EXPTd8jsItq9NYZoNS03BSXePTOwvGcM8pXbUG6zg=;
 b=E0J/H2ekjzHGQ7rmU7C/pI0kJafyNgiruJ/2mO1hz+yWvF9dexMB4QyWkDZD15fqGjEdbzGyvY21UdchtpDUTRHESqxx5Ua6KyrSCek/Nls3Lx4gL+9rL3ecIvm26nhLVirmgFhijQwwCEJ3IbCfQSr+HPjzpRRpg7GeRPtTJvEKBUTyMBs0iyG4zB52W8XgGG+1fRmex7zZbpcWSNIG7Vg4WzCb2hCDldnnSkcT34cGfIqmkuj3z4R6tLfANurrfa7EAvt/qjB6XQKiAA87RX22HGPeOCr5Vkj6nMuyXk7Dv/rxGWKoVDHNa4lv6ACN6mYwKHMH8REa/vQJm1OT1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D5EXPTd8jsItq9NYZoNS03BSXePTOwvGcM8pXbUG6zg=;
 b=i2HU2cEI89cst8Nm2xwFox9nXndaIUBdaR6k8cINvR12zZKLBfXHLEpfQM+u+u/vlbE9WqSZSEoI+aSerJHQIYB6f92kSSQKN85FCLLmIWn1+kP4iQ+LoiyIManG+1LAno5zcHf0D1qtU8OY7cdtIU2Yi6wuoXVdGQ+ovi+NxRQ=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com (2603:10a6:208:119::33)
 by AM0PR04MB5233.eurprd04.prod.outlook.com (2603:10a6:208:c9::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Mon, 3 Aug
 2020 07:08:02 +0000
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::f0b7:8439:3b5a:61bd]) by AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::f0b7:8439:3b5a:61bd%7]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 07:08:02 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     madalin.bucur@nxp.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net v3 1/5] fsl/fman: use 32-bit unsigned integer
Date:   Mon,  3 Aug 2020 10:07:30 +0300
Message-Id: <1596438454-4895-2-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1596438454-4895-1-git-send-email-florinel.iordache@nxp.com>
References: <1596438454-4895-1-git-send-email-florinel.iordache@nxp.com>
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM0PR07CA0007.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::20) To AM0PR04MB5443.eurprd04.prod.outlook.com
 (2603:10a6:208:119::33)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (83.217.231.2) by AM0PR07CA0007.eurprd07.prod.outlook.com (2603:10a6:208:ac::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3261.13 via Frontend Transport; Mon, 3 Aug 2020 07:08:02 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9373fc1e-5a4b-4439-1981-08d8377bf64d
X-MS-TrafficTypeDiagnostic: AM0PR04MB5233:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB5233C70C56B672E975FC911BFB4D0@AM0PR04MB5233.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +anoBJC7a4FaSn5ix/lMYptTEtGH8t1QdanNfHO+F0IVoKPP3UMO/MNeJragPjBpgNl7dv7EcTiKsMwPk1s8GdAulxMlGXcPiXlyeTfgxFmE+7ajPTI4PErs7DvQq+oQk3M7v7M0TvGTh63p3olaeB+MWBf8wYZZpr0uhYEo60nahfFp3XC57Hs8bkLlyppb5S+4z5018Cy2DDPgannHpCO5ttpycv7W1XhEIwiu8K3Iegy9+PVi2y3DrU5Lpzj0zN0E38Am+O7y3nVudjGM5g07BC7tnNhXfAKVxg5paa4YWnHi5jlHjxahJNNghmWud55gtgk0YQRYkfsGZNoFgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5443.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(376002)(346002)(366004)(136003)(316002)(6486002)(52116002)(16526019)(2906002)(8676002)(26005)(4326008)(6506007)(3450700001)(186003)(8936002)(478600001)(44832011)(6512007)(6666004)(83380400001)(66946007)(956004)(5660300002)(2616005)(66476007)(36756003)(86362001)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 47ccfNCe6yHA0EER7pCb1GRkJTYpM1HI/WFP2kM5fJB7leyoKdnoy3U4KxpI7NVcbcQ/WbbpI8UtilcHIEgdxzgjAcPgTxa3DFdTG8cvrioAtfKyz2yIOO+pS/nL+pWVDv8BIQbnTo64fAE2tBRQVTKKyycQiMieC5SUzuU7yjZ86VrAQwOOKJO6YirSP2fXIioewbcr+SfDR7ZOoA0Bhf8ms/u9FrteINE4Q6nmqf4n/RwG8B9/HQUqxAClo/mmTX+8nG8+lDxhq8N0iidLHZJLe+1AIwwKX/P1ZcWtjyVqO2Ih6ANccpEpeeuk3LRYRUfAI6NA6WiUDHWOLmRGM/8WMqKTwIRP+FD4sklnIBqAxCM85PKEL1PNEyQMNTLCWJ+LhsAzyOV1wacseIkEskl2Si61Xh4Vhlv4ukgBle5xZhi1aD3rirmpo8KPa18aREVsRbR/CE9hHkzUCPbkGhF0I9utBN9anTGHvd585S2kyCzivNaWGfYiEJ6T6OzyrJhmG9BSLrfdyRG6/lW4GzTdFt+ZBJ692xklV5XRgF4CAqyktBmVY+fiyIZ12oB/vFEdrjXY5zvJkMRkwdFTY1gl8wXjm5trnuitEq/HiGCep+y/eXHmfXO1DvuDO8k0KOr2Cp3PxzwnopvnJpdZfQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9373fc1e-5a4b-4439-1981-08d8377bf64d
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5443.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2020 07:08:02.7267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jW1DRvjhhmEImCQDlvdhjlRKiJehzL2Ry9OTvHRWF+unToAj3I7eVJaizteX3rn0pBox9I8S9+Qfls88SMAJm/1CFMzWl70LPls25+ocfGE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5233
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Potentially overflowing expression (ts_freq << 16 and intgr << 16)
declared as type u32 (32-bit unsigned) is evaluated using 32-bit
arithmetic and then used in a context that expects an expression of
type u64 (64-bit unsigned) which ultimately is used as 16-bit
unsigned by typecasting to u16. Fixed by using an unsigned 32-bit
integer since the value is truncated anyway in the end.

Fixes: 414fd46e7762 ("fsl/fman: Add FMan support")
Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
---
 drivers/net/ethernet/freescale/fman/fman.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman.c b/drivers/net/ethernet/freescale/fman/fman.c
index f151d6e..ef67e85 100644
--- a/drivers/net/ethernet/freescale/fman/fman.c
+++ b/drivers/net/ethernet/freescale/fman/fman.c
@@ -1398,8 +1398,7 @@ static void enable_time_stamp(struct fman *fman)
 {
 	struct fman_fpm_regs __iomem *fpm_rg = fman->fpm_regs;
 	u16 fm_clk_freq = fman->state->fm_clk_freq;
-	u32 tmp, intgr, ts_freq;
-	u64 frac;
+	u32 tmp, intgr, ts_freq, frac;
 
 	ts_freq = (u32)(1 << fman->state->count1_micro_bit);
 	/* configure timestamp so that bit 8 will count 1 microsecond
-- 
1.9.1

