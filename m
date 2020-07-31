Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEC9233F5D
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 08:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731494AbgGaGqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 02:46:55 -0400
Received: from mail-eopbgr80047.outbound.protection.outlook.com ([40.107.8.47]:50639
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731398AbgGaGqx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 02:46:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H+ixsT2KVs6j3cxaysa6PLqcgomPg+Lf3Ln3OsoMfBBnTODqu4ZzuNp/LJ6kBQdlCHODYbbOh6S07adgH2gCRKpShQAEpCOn8zopSbYlMjIjzjS98G75CivIObWGdhzNO7cltR3+ShdZ5l6l6m63w7NSMDbvgSQgherqcemZKJBzlvWPKss5BIle/CQbk2/ZwPSYINtTCTIzEE1iE2mPfbePPD6KWvHtzyES0OosBAnevfpmzQJn6KWnozziPJvbvKHB5Wo0S06ZHEKHZ1MWz6l3R8cJsEV+6DPPUxwBxYBSuPnD8NUsbL0h9otL6lVyl+nBlC4H3tbL80Zv841R6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R3CGbh8UdYFS22dNKgNlhERmZY+v06GM5lmF6PoDyno=;
 b=I44b2uE8ETrG+04ZxWdfGtgoA30mxFRsH7xB/97TLEPcjQGOVBZ9CiEnw7bEYLT7/7DAb6ORE4wD5Yw1/SiDc9DztL0aLjLLpa+RWfIbutv3/Wackrg/GOaTE0RnB0buSepSAvH4V79n2+ojGRMQIxiEOKy6kuuWlzSN6oemydArOBfcB416OiKmxETdCGwd+oAeOvmfURgp/P+cb63CFpNnW6jU3NoN2JbVn0R7IUS02I3plPF/mpLKJbiWU54IzycAvtibbA9l95M8gOjzXRt4+jbDl8gQgO5oGShRhosu+XLeqlEqHaSV1BeQDyUzansPVcwbJlx063L1kYqnDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R3CGbh8UdYFS22dNKgNlhERmZY+v06GM5lmF6PoDyno=;
 b=BYYBDaMNGYToOPmiIJcf8hhgi5q3WSFkjXgRmbXEBGDO+/HBAB6Kk5UUlF6USt0N2MfmoHjcrxXHSZINfD+iM7GU8YMQqeUGK/qUO/ThkuBClK2VdBsv5RzQBpaFJqkPeaJTc7fEY05nwDJhO4Yzc8d7ZiAXxfkThj5f39W6B58=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR04MB5447.eurprd04.prod.outlook.com (2603:10a6:20b:94::20)
 by AM6PR0402MB3527.eurprd04.prod.outlook.com (2603:10a6:209:6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Fri, 31 Jul
 2020 06:46:47 +0000
Received: from AM6PR04MB5447.eurprd04.prod.outlook.com
 ([fe80::e115:af36:613c:5a99]) by AM6PR04MB5447.eurprd04.prod.outlook.com
 ([fe80::e115:af36:613c:5a99%5]) with mapi id 15.20.3239.019; Fri, 31 Jul 2020
 06:46:47 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     madalin.bucur@nxp.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net 1/5] fsl/fman: use 32-bit unsigned integer
Date:   Fri, 31 Jul 2020 09:46:05 +0300
Message-Id: <1596177969-27645-2-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1596177969-27645-1-git-send-email-florinel.iordache@nxp.com>
References: <1596177969-27645-1-git-send-email-florinel.iordache@nxp.com>
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0112.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::17) To AM6PR04MB5447.eurprd04.prod.outlook.com
 (2603:10a6:20b:94::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (83.217.231.2) by AM0PR06CA0112.eurprd06.prod.outlook.com (2603:10a6:208:ab::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3239.16 via Frontend Transport; Fri, 31 Jul 2020 06:46:46 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9fa35e88-1e41-43af-b5a3-08d8351d7ee7
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3527:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0402MB352707A84FE4AAA2E425A743FB4E0@AM6PR0402MB3527.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cJJ40wbgOjZsZPb+9/81oMuDDptmB9mixuydi/OxCRvUuj4OGC448tZFiIpykVprAytALW/ycBaY8gGml8L8cS/viMizcwO5Uch8v5410N+27IetFjXxGPNtqspOn5cUDz764tGaRKf7EBwLIUOi2g2UCkO6m9hYiyLaPTrtRlmeiXTT/l3KT1N1/OEEFdgZNjy0PFJkJn0ibXWz+6txAwON+imzc5QjM6How1t7W2a2jG8WCs0VZBftEu7jFtn1wLY0cpewbNasYsiHig2HSEtQq4Md2uydsPjMrs7RgUDGzEQDLkW12LweLpVfkNkyWDSacgW/Tp8UGjR9Uq9WlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB5447.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(376002)(39860400002)(346002)(366004)(316002)(83380400001)(36756003)(44832011)(66946007)(5660300002)(2906002)(66476007)(6506007)(66556008)(8676002)(6486002)(26005)(6666004)(2616005)(956004)(8936002)(4326008)(3450700001)(16526019)(6512007)(86362001)(478600001)(186003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: AKQ1aHdjYr7UdIFGI17IdINX3VOgAqhciC8awnlAluHoEGN5EIwr+Gj2y5qXUszBiMj+Msabyr7PdACjE2oyVXNZtPO+R0n2x84p9iU8OhHZ66nTWVsBPujafYtAEE6xQxHJdfY+rxzMjgwfMh5u4rrntLfSdTCVxbHk3WvXBjzVxOSBTxOYi7I2gEWZHvIQE1sWliqrqv8XCz61zvNeoOW/YwOrBMcwFQjlXpl2gEy1loobGxhNizHYschFI32XgY4TJVh+qikhu0mZJlT4GU4VlSdnKSv7n1DSh2GiZfmNaO/tHLpyGJeflpZxJe/jsCnkdYk0LjvqOvAsUV35Eh9x5Yh/q/FD+ngbOE8FbBiHX0PLX91KR5zEKULheiewMQDQ0PJyT/jX6gDtl6tnyYzH6OzxDAO5oYxxJyCX2k4CZN1RNskxM4BnmJYxzTm5SoxSrFYrFhV8NesmOo3oSecangOnUi4tHaan/YR4dXM=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fa35e88-1e41-43af-b5a3-08d8351d7ee7
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB5447.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2020 06:46:47.4991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tGkWg16PHLunv5PeI5hXs68XRwqBmXG78916Pdd5QljVF1M+E+h1jBXVELhdb28PMrTJfnHTkHDFlRa89mnyTwzNeIjsCFpXC0xV0aK/Gtg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3527
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

Fixes: 414fd46e ("fsl/fman: Add FMan support")

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

