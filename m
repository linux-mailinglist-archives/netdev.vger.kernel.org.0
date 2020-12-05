Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E53A2CFE32
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 20:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbgLETUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 14:20:51 -0500
Received: from mail-am6eur05on2101.outbound.protection.outlook.com ([40.107.22.101]:29825
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725923AbgLETUg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 14:20:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hB0jYpZThjDi2jonEa8g/kCVLkMCDwwcQVCx+5twz4us78WsuiihX1K94ZX2vFx8WdklrkK6PLvTEJ2nrpWBxtzgXGSvOKO6Z4b1TKkLBR/l6xcyeG71CQ4dgIfazjpmlvKDdsCJKrfBpUcJ7n8nqeealovJHJX/tZoHzMCAw52EHalT2fOPPCrnZbTrkP0/mb/UbawUkL+d9XIAN/UeMdqrK6sACTLkZSzjr178XJApHcAYntDRKNsmq3Z3fzqg3BYe7GVkrSRrPyn6RLWxJBFuMdwsaieDuRpetp09e6LrHkB0Oc25xRhPxPOd6EQCK9MiuvAFDxBfgBjMtbXoCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jkDQ5X09s+B2qH7fCsAIyqj+eG/eg9qMrfZw00etq8Q=;
 b=M8TQYo07y6T7LR7ngg36oGDUUa5jGxweOHPIbgwGgJ97raO+pA75IFV7up0Kq+w8MiIIdaU9B/fBCrY26WGdg8282/uHhfe5PqXYIIv4R+4Yga2bIKdcgoI21pRZMnLWUKxRnr5XyUaJlwPwHcNWlcT9aPbPpt+HsNyumeM0fV1Ti3b2aFWfIT2nVLYbm4uZMlhvBLvaS8ARcs7ixEcqSQe5fak8TMbsgqsNhxH9QopuKj7RXGWFRJMMSAnhoyP/08Tou2LL7WiNXJ3rs47giIV8Pr4kfnexBUnrgPQ2df2QEleMWN3mPOHO9WDk5RMg9wQOvJBsySOxIkrbnGbIZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jkDQ5X09s+B2qH7fCsAIyqj+eG/eg9qMrfZw00etq8Q=;
 b=PEGubjRwGw13j7ZqtjBU0R7WuhLd+98kwNJ0ss6OFG1kAJ0kJgODBv4WbfN3cNP5dyoUzKp57lLJwQdfUefRMkRKDqgyznw+prqRDThg94p/9ndzPCCCT5OHdDkS09KWHh2EtAsOSTs10rvDXohh9MbPzYd2/w4Dhktr28ShGQw=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM4PR1001MB1363.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:200:99::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.19; Sat, 5 Dec
 2020 19:18:30 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 19:18:29 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Li Yang <leoyang.li@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Zhao Qiang <qiang.zhao@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/20] ethernet: ucc_geth: use UCC_GETH_{RX,TX}_BD_RING_ALIGNMENT macros directly
Date:   Sat,  5 Dec 2020 20:17:38 +0100
Message-Id: <20201205191744.7847-16-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
References: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM5PR0701CA0063.eurprd07.prod.outlook.com
 (2603:10a6:203:2::25) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM5PR0701CA0063.eurprd07.prod.outlook.com (2603:10a6:203:2::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.5 via Frontend Transport; Sat, 5 Dec 2020 19:18:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fba62702-cacc-4c8a-32d2-08d899528c87
X-MS-TrafficTypeDiagnostic: AM4PR1001MB1363:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4PR1001MB1363ABE880878B868649D01293F00@AM4PR1001MB1363.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lYyAmP7CMOEEtYTEOFllZWHYGNplZintAMms4rTP1r5HFAx7lIjpbxa77T+M3B+mtgmLNgHyR+cimfvkRDB9YNVZ8LmbWT7neX/hnxCRa9ERXv2ezANomrGDEETd8chMO8Q+H/3NGEPEmHKKZu5nlBUNVj8I8BmMfNIAJu3dK1tfl2ue47hOhxTM9jfShT/BqjwpwWglwOwNAf6Vd0am/egdrfHWhIEbDQit7QhPSUNwQnJvJ7gQtWbPSw+DKvGy86ZnOd4Ni6VRcpSJzHwC2n2OwPQf4lzpJTCA9X4p5Mt4iSZ/ALXfZbj8DPeSyjTo7WDx1l9Sqtsg+47m7Y6WGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(39840400004)(346002)(136003)(366004)(376002)(2616005)(2906002)(8676002)(8936002)(83380400001)(52116002)(36756003)(66476007)(66946007)(66556008)(4326008)(8976002)(5660300002)(1076003)(6486002)(44832011)(6512007)(186003)(26005)(6666004)(110136005)(316002)(86362001)(478600001)(16526019)(54906003)(956004)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?QPbwrFyDUnf3nAYVrkOMpubxw97rJfn491BNO/sqfWWCQFXrOkx+RwDHNDsC?=
 =?us-ascii?Q?MXeW9BSXHSzBu6HsLMpy+GUSHEEkvTrPunpaPY956Lk3Jn4tcgnVOKxLW6FG?=
 =?us-ascii?Q?RtWUaUkWY/fIzJAsf0AIfzBXFztVKq6w8aMIx9QzSluuFwC9ZiTA+zTh+xBV?=
 =?us-ascii?Q?dB9wzI+5U1qqvHJ//opep5hvM38r8nxG16jFw2drYO8MRSrPLFiVCCgU29Mt?=
 =?us-ascii?Q?cch9QKkC1PKn+GpOBiw0a/Hc2/9SiCzlQ6+afgPWJDhJG31XI+8j2bZvgUAW?=
 =?us-ascii?Q?iQPej/BNZxIWlhLzH7wkiKJqQfokxwy5qGqFOhPYRQywchNFQXM/EQzHvU9l?=
 =?us-ascii?Q?gFbhBhSE/E9hnhRdMyl6+4ThOWpReEvTOyJTHdjhXhScVFxxg4uK22Jr5vy1?=
 =?us-ascii?Q?Yb7Gxtl9bTG33tPPdSoqUoobC3QChwHVt477aBktwo/6rHpTerU45BPOaUja?=
 =?us-ascii?Q?EX1wmnqDBfK3cY/4xq5KDfqT5GJOfxO9EwGFkW+q8B71o66bzfAJxyEoYC7w?=
 =?us-ascii?Q?ipRfN+ezizYE3ClzlcLjoM0t/gxqytA1SQiWABG+Y0aSRRSMIKC+gb+VXvbH?=
 =?us-ascii?Q?jp9RTjyzeF8Lnr5gGpHTY1agD2KQSclIHCfQE8iyO8K6dmp0+B+/w1IBjHvi?=
 =?us-ascii?Q?+Et2Mx7ZRY95mvvtCjAgOTwE+PRVn1rQ757Fvzg1R+ywCjEErW3R7Dv8V1eN?=
 =?us-ascii?Q?jmFXeNQRlqfd0OR4APrcarWkbg/8UBgwbOevNxesvS3zSgQrH7ezrGnzjlXy?=
 =?us-ascii?Q?Mjue/0SpMUeLxAIFGRXqt5g+iztVJE4MeRxw4Ooz48i2NvANbhIuTYGHK4Hj?=
 =?us-ascii?Q?MlwbURr4cpu3A+41Verwgc7mBmhB5qK9wYSpMaokRfV+H/MpYgI6UcuRnPjY?=
 =?us-ascii?Q?HMVT4FtSozv7+6objwwMXoc8G4uu6mms5KTr2k8TGLShZA4UEzUlS/9T8Jpz?=
 =?us-ascii?Q?lNHlynZcHNw/BaCbyIL/x3zID/ndniUVTZgcJsYx/voDhiwd1NJbVpaf7xzx?=
 =?us-ascii?Q?IqGT?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: fba62702-cacc-4c8a-32d2-08d899528c87
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2020 19:18:29.8323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GdHj0hxns1V/fLkc4cG/FjV/csj8iZZZfB1OngCp7Jz/7yEc91vJIudbc0rJFsEZR87KutUEv4S14TYOS1gFRk3GwRgFHI7RaQ1Xon33/iQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR1001MB1363
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These macros both have the value 32, there's no point first
initializing align to a lower value.

If anything, one could throw in a
BUILD_BUG_ON(UCC_GETH_TX_BD_RING_ALIGNMENT < 4), but it's not worth it
- lots of code depends on named constants having sensible values.

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 drivers/net/ethernet/freescale/ucc_geth.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index 273342233bba..ccde42f547b8 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -2196,9 +2196,7 @@ static int ucc_geth_alloc_tx(struct ucc_geth_private *ugeth)
 		    UCC_GETH_TX_BD_RING_SIZE_MEMORY_ALIGNMENT)
 			length += UCC_GETH_TX_BD_RING_SIZE_MEMORY_ALIGNMENT;
 		if (uf_info->bd_mem_part == MEM_PART_SYSTEM) {
-			u32 align = 4;
-			if (UCC_GETH_TX_BD_RING_ALIGNMENT > 4)
-				align = UCC_GETH_TX_BD_RING_ALIGNMENT;
+			u32 align = UCC_GETH_TX_BD_RING_ALIGNMENT;
 			ugeth->tx_bd_ring_offset[j] =
 				(u32) kmalloc((u32) (length + align), GFP_KERNEL);
 
@@ -2274,9 +2272,7 @@ static int ucc_geth_alloc_rx(struct ucc_geth_private *ugeth)
 	for (j = 0; j < ug_info->numQueuesRx; j++) {
 		length = ug_info->bdRingLenRx[j] * sizeof(struct qe_bd);
 		if (uf_info->bd_mem_part == MEM_PART_SYSTEM) {
-			u32 align = 4;
-			if (UCC_GETH_RX_BD_RING_ALIGNMENT > 4)
-				align = UCC_GETH_RX_BD_RING_ALIGNMENT;
+			u32 align = UCC_GETH_RX_BD_RING_ALIGNMENT;
 			ugeth->rx_bd_ring_offset[j] =
 				(u32) kmalloc((u32) (length + align), GFP_KERNEL);
 			if (ugeth->rx_bd_ring_offset[j] != 0)
-- 
2.23.0

