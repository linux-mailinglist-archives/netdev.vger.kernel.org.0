Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D488234442
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 12:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732638AbgGaKuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 06:50:01 -0400
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:53202
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732603AbgGaKuA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 06:50:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JQhv+EGDbVFfm0Dv5glEzEDuorBzHdiQZYwJnNRoE3dT/P3cHZpHxdhc+PsExlFcY7wghLzN3RpS0hLL42ox5UFDto6DcqGgtBy6dlgL/iZX4BqgbDfltykZQ6XvFRNUZVH6EDk4cvrwPYdYp4FFTZRnz31GXOD5muaZoCR+WClJIl+ZKmDDKHw7W3QZ9egcfCbrAfOu7ZIn6cFr7AAoU9ktqh/rSMKpFIZO+YSLXwEnA526UBYDMf7SmONHIsCnDv7RnTRVuZbwgoFzOex30hgXvNJDsWTrb7Kn06DjPJs4t4D1vTYwIY9DT4qFNKnrmiW4HS8rT1DnAhfrWsYQzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oOGDrzulmvnKGN8hdODRkozbekDRrPzUqJw6EPSdwDc=;
 b=E12nSuYqZOhTA5GZdiJ/tGvNdCIKv6cbL1eX3SmFnhoOMn/6kLOwyXKHWZZhv8kjXZ3FWuRRR1vrVU+A8uxuUj7SaTgvYxvYYxVjgJvkOgCamfnh/e5XY2RhvVVS44Gq6WHubndbtlQ1+J452LpN0PQfDdB/55lhDhSm+wdtYYPRLqIIvKm3t2uSIcL4irKTA734k6sBaoas4luVSOUTXqmRRu4n+vQ3EeRfDt5zq5Sbtmenp0a6RYDZuMvVk3p1vgyEoxrhasoAR9JbA82ClwH1ldlWHING/LYmg5Vjoai9q5NVLYyb0rQNU/O4WYsbKpyzyIBqLWkT23magC/rTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oOGDrzulmvnKGN8hdODRkozbekDRrPzUqJw6EPSdwDc=;
 b=XzpZkur3cs6xNHgTw3yQODdOBHahuAHKwvjnNo0IHoBVbMA2x4+kB8dJwIvzNMs8p9TJwAPTtJQIEz39bIoRSu5OAzzo/orIPgQD+ZzqaHT+NsCqRRR5nnVAE+UB4jO0F13VnXdGTr+IngNwtU0PkwlC4QVCZxTFOL4ooeCGibU=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR04MB5447.eurprd04.prod.outlook.com (2603:10a6:20b:94::20)
 by AM6PR04MB5943.eurprd04.prod.outlook.com (2603:10a6:20b:99::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Fri, 31 Jul
 2020 10:49:54 +0000
Received: from AM6PR04MB5447.eurprd04.prod.outlook.com
 ([fe80::e115:af36:613c:5a99]) by AM6PR04MB5447.eurprd04.prod.outlook.com
 ([fe80::e115:af36:613c:5a99%5]) with mapi id 15.20.3239.019; Fri, 31 Jul 2020
 10:49:54 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     madalin.bucur@nxp.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Markus.Elfring@web.de
Cc:     linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net v2 1/5] fsl/fman: use 32-bit unsigned integer
Date:   Fri, 31 Jul 2020 13:49:18 +0300
Message-Id: <1596192562-7629-2-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1596192562-7629-1-git-send-email-florinel.iordache@nxp.com>
References: <1596192562-7629-1-git-send-email-florinel.iordache@nxp.com>
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0103.eurprd04.prod.outlook.com
 (2603:10a6:208:be::44) To AM6PR04MB5447.eurprd04.prod.outlook.com
 (2603:10a6:20b:94::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (83.217.231.2) by AM0PR04CA0103.eurprd04.prod.outlook.com (2603:10a6:208:be::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3239.16 via Frontend Transport; Fri, 31 Jul 2020 10:49:53 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2e63d8d3-56fd-4845-2086-08d8353f7546
X-MS-TrafficTypeDiagnostic: AM6PR04MB5943:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR04MB594300BDE209EDE740432E93FB4E0@AM6PR04MB5943.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X4AsY/lp/aEM3DqP5ajNFGzYgTjfj3MFVsW+Hecz7XZDoWGhNgxtQABPFIe/NJxvvQ90jQzdOVteJ3uS0lPZtr5yWpeFpz9VAkKu9bRVH/EjB6yV1vtfO1RsUFZuv/wwt7a18cHmb2vZXlOxzC8n0EBfpQqnTaTJMci2kECJ0anv6WPdD/JDuR1e+uR/mg6u9tKgrkVTBOIZTQ9hjZnbXK4Eba6AibxZ4h2G7UkjB6CEP0SEoIEclMpn8fi8SMjtYGzWQS3y2llSzYXrHrcZkExTmUXg5BmxqvosR4L1E7o3GLhPDmc8AhDE5o2viR4mjflN2gXbn7JaVXTYW7y8Qw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB5447.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(366004)(376002)(346002)(39860400002)(3450700001)(6666004)(478600001)(83380400001)(36756003)(52116002)(2906002)(4326008)(6486002)(316002)(66946007)(66556008)(6512007)(5660300002)(8676002)(86362001)(8936002)(956004)(2616005)(186003)(16526019)(26005)(44832011)(6506007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: VHOysgUjux84JeJHrOO2ni0jRWNoVWXQn1tHSYciin46/K5vteZExta5iGun4MW5cbIhiIXr/+J1chBHBjRB7CyL+gjRWd9jj2rrQ8hkaHFpIkfFaRKL8Sks0Smbrx2wwO+Jdg6HK3Ar8wVgS+KhgJ+HeE2xZWvh2hhdAHuyknF32HWsA3eoi1eewQN634MSh9u1ApGL8G384I977ANZtWy8EafYBMAJnmpTt2JglY12ILOgW+n+9mqz1aiFOsqDmLSZRJqMJmfEVw7yCV+ZWGoAImg0p1NAL2/Y3yrJXcUVVXjdjqN6Z0epg7+CiCWzKneGXmMXuULJbDhKbVkPEMnGgJCoHacIuDSeRYMtVEhr31whlD30LZgObXOGUlIpXOceCgQG6ZUYMuswsKub190Ezl1oU4QFKT+FGj8XIUEu0QB64XZIx4BuZ7S0jXvMv0BYg9LjKaTj8n2qT61olvJTGDOxHJMbqZaZWJZEHMU594l6G9UMo85lo/Qy3yMmIzWx3EuR7ILOJuaK8zRg4Ymw/iwZOw3MKwsM3IvDoYaMQxXxQdN7rCDE1ZuL67oZwx3q3iIwPTZTRLWDeos98vR3Sfy3D/Ws3a3n7ZvDilagZyITrEAnO+tMGVCHvmW6WGgh379A71LBhgHeDEAJDw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e63d8d3-56fd-4845-2086-08d8353f7546
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB5447.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2020 10:49:54.1056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C0REAXgKmkT5SeFXe5c9Qmt2q0pSeeKqogHIaj/vs7k9TdFJ9jqM/9cn4kbwdPvyE7Ly32+yBvkT4gGfgljFnFv2H2AxSvw+OCZScjQ4k/4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5943
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

