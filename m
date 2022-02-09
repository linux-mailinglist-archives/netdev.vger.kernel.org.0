Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4024AECD6
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 09:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240571AbiBIIlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 03:41:10 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:53672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242839AbiBIIlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 03:41:06 -0500
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2097.outbound.protection.outlook.com [40.107.215.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FCB2C050CE2;
        Wed,  9 Feb 2022 00:41:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BBhN+eYM/sPmQBfZ+qdOpeJXPLmSClT+FCOUKa3XEnhxFIWbS4HQK7IvBsl1Ors1TMhRiXubKQVa8a4Z+DP//8+zj7LAUWl2J7iYZ7xTW1P+XCzWZ7BltEisCq8W0bTugjkgW4wT9hToNoPnKx8qOvE4Kdg5r36Q7Mq1ImPZ3XEIk9+gdHlZBlAkW0TdDU/26MU3tWGcIsxC73qwmJMt4KOhZjisILBxbjBmCJMqKl/hLqfWrSeQL8HQgn3BI9qC/fPlPaoWY3VH0frGbGhVy0YPgZfcqXEeyYdD7np+hdn9qKhDjI/da9gwWVdnjgyNyIRNRthJDp4BN6Nq7G0QDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RF/yFm8/wIfhf9AXst4/NVUlywAWaOttd8W/Ai1iq0g=;
 b=EwggglyJ63nWHH37jgigqwwukjyzR6rDbS7Kx5/eqGcMPVR3Wb0ZTabbhzZsZuPcer1G72jVw5GfOxPTle9grSA+R/NtvRUQp6wELWujlrBaiOvTjW7lnrBczRbR1zO86qXgPLiq0Bi4naA4GcwrcJX7iX72If2q8lhzfPG31U3iBj6uoCzuRmQlINKMbqeDDqJEelN1u6pVO9TrlkT1BpALNQQhkOPsPakArInGt9Zzw0YmeRASNh/RUhsa+q0ve7Q+XiYefEba6xYfhHUL3ZQwkHhORsgmFnKCt2gMWnBiA1gWP0EW0ka5x90/7TnZ6MyBP4WlPPbTR9iK8QgWkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RF/yFm8/wIfhf9AXst4/NVUlywAWaOttd8W/Ai1iq0g=;
 b=kUX6UZx3wCLgdF4cL6eNs7Dvd5KtZfd0DJ57WTEwUkNrcG0e48dUwBM7ouuy9IUQQOFK5mDblPSWiv95cdOrt01oAkA1E4LAf1GJY74SDI6S1HcGEWRr6WtmVWxk4BpHNQLwtAVGsRgqa++0l+bxuMp0AtgiTt4f+1tTwRE0oRM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
 by KL1PR0601MB4387.apcprd06.prod.outlook.com (2603:1096:820:7a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.14; Wed, 9 Feb
 2022 08:39:14 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::80b4:e787:47a9:41bb]) by SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::80b4:e787:47a9:41bb%4]) with mapi id 15.20.4975.011; Wed, 9 Feb 2022
 08:39:14 +0000
From:   Qing Wang <wangqing@vivo.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Subject: [PATCH] net: dsa: ocelot: use div64_u64() instead of do_div()
Date:   Wed,  9 Feb 2022 00:39:02 -0800
Message-Id: <1644395942-4186-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0131.apcprd03.prod.outlook.com
 (2603:1096:4:91::35) To SL2PR06MB3082.apcprd06.prod.outlook.com
 (2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e35d08a2-4d84-412b-d559-08d9eba7a6c9
X-MS-TrafficTypeDiagnostic: KL1PR0601MB4387:EE_
X-Microsoft-Antispam-PRVS: <KL1PR0601MB438718181865D6F94406FC26BD2E9@KL1PR0601MB4387.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VPXy1phgYocD6waGKQ1hTviwbHw6ZnP/sUwqDlQpIZTsdY9Ij4S3BJHNRTzOq/GIHsUKUQE6qdqG/rqNtiZDHFvLka/5lESXKqdKVUu6M08W2zsrXMvQC+2Fk9Ang+8v0KoFcwOlAp+3MkgHDfwg40y+cgDWBW+MLJZS/uShCQF5hRK/xeBY8IjiFJAbigEkFM0rkohJ5VgpvWXKaGrgYbzh7Kcinp18jWTRJGrPlYu+VrOLFEvL97gJN23hMuvdQEQz+WUP7AblobnzRVBLuMJH/gRu9qbEdPvvMcFi9b2E1XHJmhziS6AIpfmXzSVZMYW9tKD2jYjzUdzDRCnyFn6lVMHq3jRZk99UTabBjGgv1OcRFPuPgSzpHzGVLtYnX8ht8knE4T1KU7sHRioVs5ETtdNDVh0GK7D+ECMi0Z4wQoaTiGT8xfXUQAXYxbiR4B4kj9hrfXlPsxDTEtsm+LbsTJQrCbLE/wMouvejn1Dp5Dlx2vz04gV6yI0aFmFeXJjoQAQ0vJkFYJMG6gIS1Y4NK3jL4iGB46Sh7M6wkbVTrve0OqThByzgKAiRBdP7BMo5HPmIvNV02uA9VE3KtYCmHTj6iXa3ahu0xit399/2WRytcKqcnaaMX/E/D583CIXOL50dPpODpfKn4R0A8mOJXRh4ur9QAgdxDjG2E9/D9DVPv5JzpI6vPN6cxE6NbEssvhqd465cBK63gPZqTY+HPwmfn1oeampbpkOOBuc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3082.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(4326008)(110136005)(6486002)(66946007)(66476007)(66556008)(8676002)(86362001)(921005)(38100700002)(38350700002)(8936002)(2616005)(2906002)(107886003)(36756003)(6506007)(52116002)(5660300002)(7416002)(6512007)(83380400001)(26005)(4744005)(508600001)(186003)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u4WZkgJjyGK5YyCuhLU4HOQ82ZrqFdddzU/eKytzT6iH1lGnYFE7DPedJsRi?=
 =?us-ascii?Q?+UnbfHNrTHDCiSk2VpHUjcG1ceo/2er0p91Zv86jlXO113KHs9MWgTr2AZzh?=
 =?us-ascii?Q?bgjGlG4NnLLHxhZ8Tt/K3yVLkYtVqOlVvzbRXd6bsVw95opmCFlhYqs527D+?=
 =?us-ascii?Q?yQetg2pspWQFA5bImgNGu5eMy625ORQhzs83QM1uZagcCbwMM7bujH7EzwDr?=
 =?us-ascii?Q?/ZPxxon4MmBC9v07sHkkh+sYuqqVibfwBUPPf0zmlIaQJiBUGXk5UhqLDHFU?=
 =?us-ascii?Q?99/Wto+/YiZPdGGpD4dgonsXZljES51HvHTamWCQq+YaH5v7QsV6p3h42LLN?=
 =?us-ascii?Q?MtMk3F2zpO/mCPyq5rnTV9TPf3lWLq99vYb3agW8t5JdYoVH2ki9ql9ny8Zf?=
 =?us-ascii?Q?26IT7lR+q9gGkUWPwhcvn1vdwvgYoKz8yi3cr0BGbImXnjluekjMv5KcUDH4?=
 =?us-ascii?Q?WEGoxvYSYWUzR//xClYf/MVcoTh8sQKjxlUOPlJ3Tgn/3voMl5cWwskBkwPz?=
 =?us-ascii?Q?G+6jjhAWeVylLHSBtAOjVOBBPSrU6YpkSFsguSzGqJZ1hXgLbjtNm6UpW5jm?=
 =?us-ascii?Q?SmZS/bohenorFgIpzkm2Pv4Vljj4wGXKxUlIn1IT+jovb/Qs68Q8SSw+ICEP?=
 =?us-ascii?Q?eKXR3bqe+2Qc2mA27IFM9NBxUgRvltUO3hEnF/P1pQ/F8xMirhFjbTJxepLg?=
 =?us-ascii?Q?y84mEOj+0HjS3lC7oo9egIscSqQs7TWvBw5MQ0ZT4w3bsx5NzIEQLjj8ytrp?=
 =?us-ascii?Q?uDmoJ+MbitlIoRgblwEcuMv6A8eIq79PCTCd1SuW0g+WCicrhm6rAvrkEZ2B?=
 =?us-ascii?Q?TWbyUF46/k3XCLartCWHTifExMbVq/Y/5iwv6nob/+/nKxCtm2RYsohq88iF?=
 =?us-ascii?Q?ijOYZt9kloJd6NcydQP/lPNdUuZpDY7uhItCYRBGKbh5JFKrC9kC5nUMAtud?=
 =?us-ascii?Q?k27FNC+n7RFSBTkvdl7hhXEF0R779jBrHWHfED3O5A2wLzHBSPobcJ8kYBxv?=
 =?us-ascii?Q?t5XfiMfLkpyVwHh5vQ53QPrWcfPVz6Gfr1UYr/6sFnxjRG2tm7omTc8qc880?=
 =?us-ascii?Q?tpxpws/CmCQeNqgPE+IC8F4C4QVRQK1rQboht5ZnJm/OwBT6shVhFOaOpEpI?=
 =?us-ascii?Q?OwrRIR91UMhgjD7Fb/c6lmoFvfiX7NfagnV0rxv7z3pUlOjW1J2/hT8lB2rm?=
 =?us-ascii?Q?4XeLEgRO1QvbvYdKaUi989iYN4hTAnyaRpxFFUu9Ad+8XIuPppk9RqJfI6rP?=
 =?us-ascii?Q?3tyqSF0QGGYKUGpEN0XFBuJNAC6ZJnnarfS7iBh/4YbmTTRKoebENTfLsQjm?=
 =?us-ascii?Q?rvH+4iJERkkftCqH6ubwTlpVVTativoZmX73O0SJ2KScm6whgxftTVzQc1h7?=
 =?us-ascii?Q?VRGHGCO5VSCXcp3veCpxzGZDCnA+4DwFZW2Z4fIjanboHVk2SutuYw+Dapmu?=
 =?us-ascii?Q?KNxAxxUWcpyVwS0jjVgyQ5tbQ3rX8wi8+ZfPPxY7YNLhvR+7WYi2sfwCwWYF?=
 =?us-ascii?Q?VKWcbNkbs0OrLzjaDRuKkloRBVCCQRu4RLZEb6lapquJC+Izoq1yk3lW3V9C?=
 =?us-ascii?Q?LhrIjNw7lvsRdN0Xibp+gJ/7VajP5+Jld3svftnMr4UMcd14SVoyiowl4gX8?=
 =?us-ascii?Q?giHLdNzwfu+EmbLbOG1FdiY=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e35d08a2-4d84-412b-d559-08d9eba7a6c9
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 08:39:14.2134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qo/BcVnpWNHtfitTUs+zPo8hJfk28Sqg7mX/L8DHG0/cSkOC0x+/3sdFX5nl2J47bZAA9miMHJdHSAxBuWUPzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR0601MB4387
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/net/dsa/ocelot/felix_vsc9959.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index bf8d382..5c2482f
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1178,7 +1178,7 @@ static void vsc9959_new_base_time(struct ocelot *ocelot, ktime_t base_time,
 	if (base_time < current_time) {
 		u64 nr_of_cycles = current_time - base_time;
 
-		do_div(nr_of_cycles, cycle_time);
+		div64_u64(nr_of_cycles, cycle_time);
 		new_base_time += cycle_time * (nr_of_cycles + 1);
 	}
 
-- 
2.7.4

