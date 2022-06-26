Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8F8455B1C2
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 14:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234399AbiFZMFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 08:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234406AbiFZMFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 08:05:36 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2046.outbound.protection.outlook.com [40.107.104.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 385C115724;
        Sun, 26 Jun 2022 05:05:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VUuyi07sayeSslg/qrBEWFdB794Z9LqUHIE9rkIwDMkmIVsGsEEQP8pMAXNW0wkrBXmTYm03YJF+/5Z66rqaUSiIuVB9fXnsSW5pY0Fc0X9wvqx+TdZbzIPaULCbjUolHyEje/hhKC5BdTimP4ML3/X9a7hT/H5MXlK3ai2mqwhfx18A5A/dId/H00gPtMsHwg6FDTxUz7sc4YlabkJEMrmf6DrT5TZqnanTH5nxpAPpmKm5Yhi8OsYhqLqbFAL3Ft/uc3CdTYKzcN7cqSFpN+0slTc6v6sHHUfm5h0NG4NmleTfxqEw/LI1BsmJzOvFhZpLUtk/cRe7qxbsId34lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O6TRHU4MEiy4rvgEei2zJne20hsNSCP4MY/RaICSmNI=;
 b=dirwRuw319uMGiE4ByURwblRckeVkDn8MAPjcDAM80AnN/hBIoJmbyBPc4Mo4nQM2wFrnX2DinH28gp210MlhGd0NOPwI2ax84PelN14+rOg/s0aj3dDbIqoHtAa7Ak+Lt55o7gvwL7muzrBndyBvCfbX/JwijO/EWDMafHdXk15QIMmGMDB9tKENQ3fL8sKccB9D23SEuxJyvLzBQC25KWXGdW+1Z216VggIQXjmL08E3w3HM3qEfwq3j7GVbf7mF9WPgFSyheTrWLeHk3lChfS3fILK7cOq7ErKXfukuDfh2R6f9anSOqEGx7Rz3rarGNt9lt8ICGq222aGA3ypQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O6TRHU4MEiy4rvgEei2zJne20hsNSCP4MY/RaICSmNI=;
 b=lkue7MHeNYiJuGSYSzeIEOqmr93YZyXIO6RVqU4j2M7iUvoQuDTVTVSSdCiezMJSGhXVW7KQuOBzZNxTywyAjyuqBcRBH4AuR8k2LPE/gRotB2QuPmxTfPhVQlXeqq6ST2+Q36NiwcvQ3tvcPMZgbe4jttQyZuN77MDwgZ/VdwI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4273.eurprd04.prod.outlook.com (2603:10a6:208:67::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Sun, 26 Jun
 2022 12:05:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea%7]) with mapi id 15.20.5373.018; Sun, 26 Jun 2022
 12:05:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: [PATCH net-next 1/4] time64.h: define PSEC_PER_NSEC and use it in tc-taprio
Date:   Sun, 26 Jun 2022 15:05:02 +0300
Message-Id: <20220626120505.2369600-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220626120505.2369600-1-vladimir.oltean@nxp.com>
References: <20220626120505.2369600-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0401.eurprd06.prod.outlook.com
 (2603:10a6:20b:461::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e765b68-721f-4008-dcd9-08da576c2c25
X-MS-TrafficTypeDiagnostic: AM0PR04MB4273:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VXqaXzS0ssVAzcEf1O1nWdRCEC/ECNDORlsPT3QlsCS19KPvIxfgWzuqUaIulr5oMVi/1uwpJ34SXzADqKJeP9c3KvXCz77FOHXZRnLPme6cmsHV7X0eIjdE7KXfduxFf6cUSlbbYYWBhH4PtnnBHaStcL9tnSNdk5DThbC+wOYUj9DasdeLvTd8+x8Z2mQAkDO9YSUY9O3oB2WjUfuOW+RSXA3bqbe+l/Ym8773U0/JYE7IE7bPYAPRFIbnHwDyla16fEX/Ma/9xlm4/ElKH2wLdERIVqT118+QKvhKkkaAJrxhGQ8s8YLmpuLDjUeokOnhiEFXl1sSAf8L+5fMGb2qCKVHpxvYjn+3AHVizUVt7IZ/JWR0k6SNxGdcK2/Mz9sqLfxYbjMIF80H9YP3n4CVEEboCvALVyRBdjJQy51pm9yDPaXyd+EFrKTh+aiWUjdevXem0A4BqjUQmFI6e7KAV55GVDuQVgdaWuD/4AjtdzM9MeCDDspYrgojvXVR7mEoq2yNvj1ld4RaQd5PVz92+WlenefzsVZi9HKlLdIqulEXOPxpvFPKOw0gZK+c/Q+E7VN17d7OPqLQ2HkqvAVmhEDC3PGDiQRNYCuO2GSaHPtht2Qr1skisjCDeknSVUAFfHczt3xgORNmA4P3JeWatjP47RLkQmq/LnECeqcYXvfjcei2xn7wz5kfEASsmrSchtBL88xJjUumJmPOJx3QfZBC4zyJKozvHBOihOpDA7+UMYjIKd5AGF/vGCWPI19DtB9zZ/bK/nGHvmcEb+0AzOlXGbVSDiSl3AA4Dm0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(39860400002)(396003)(366004)(376002)(38100700002)(316002)(83380400001)(86362001)(52116002)(2616005)(36756003)(6506007)(38350700002)(66556008)(66476007)(66946007)(4326008)(8676002)(5660300002)(8936002)(7416002)(1076003)(186003)(41300700001)(54906003)(2906002)(26005)(478600001)(6512007)(6666004)(6486002)(6916009)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zPiqIxwd863HWG5ZQ3cPZ8IqtSw8MaEkdA+ntgzWWPjGTfilhGAqsLO6msSM?=
 =?us-ascii?Q?Q9simC9VZ95sDrc/kt25jQEbBMrQvAxdNM4BjacO6XLGJmMyMDvRCiOdzocY?=
 =?us-ascii?Q?HEQjUEu83VElQfhsrAICewCfPmspluQcZD1GRBGF+vwoAvJ1RhPDe9E9PTUX?=
 =?us-ascii?Q?L2l6HgOs6TusIhnRnmxQLPoZ7yosKXAYYzHtq/Onndq9u2S6aVKBgm9vYAur?=
 =?us-ascii?Q?s2pwQqOTOT+GxMzXFePQilO9fKUdjnn/oSTajQ/td3L1XPVeEP8PQuleVR1t?=
 =?us-ascii?Q?8zYL1kPumKKG8WH8od6TeqZotRvxr2eqECotsDgA/n5N6o1s88Ob3xkd6A/p?=
 =?us-ascii?Q?2UWKNkV2B6KcvPOMU1WJ/ltNYH3I5+q4dXIz8vPZQ75ERgMsO5Mul9rFgTyH?=
 =?us-ascii?Q?nfZlCT+CKDwBAPtXExpi/JK9z5Oz8Pb5lQzdl5Hk+jpI4cRkEDCF560rqb2V?=
 =?us-ascii?Q?O6rMX34/IIDd/nwv012GfEXD/H6227Ja5sQT5DzrikjfKrg8pxwfD7GP53pD?=
 =?us-ascii?Q?XXW8a/F/miqNs2rWTp7BDl8MBX/l0t3B6MRq/S9dAO1cMAS/OAMf4hK/5qn1?=
 =?us-ascii?Q?AGA9x/oGEoghOnzIrzCjrwYwLXqnQ5sP41lpNhIXxQrwqA31UcFIVjcUk6n2?=
 =?us-ascii?Q?gz200e3g7WR/lvCXOAJG6xBchL+TzYBH3TdUko5sMGYyl2JnUGfoqKMDvgfZ?=
 =?us-ascii?Q?Ho2JVSEJpqw6CmuWmj0bO7hu3uFalsKAWGPEnx5bGu6s57fJ74+XA8aJp8rZ?=
 =?us-ascii?Q?7XTPCMAQVpAPeykIaHOpUftOCwLhxCon/8Jdl1AU0WSFeZUvWlUafo1Up3Cx?=
 =?us-ascii?Q?CJAQBJGIUj08mnCWdd4FiW2NgINQMOWwgHGb/6vOtTTg7DcO5ugw+95oeYQR?=
 =?us-ascii?Q?dTdgScsfqEnltDzSsGNMVYTdbojPN6ZLtIMkTh+zZnGpJVSCaQBU4pBvmLFs?=
 =?us-ascii?Q?C/6T6sS78hTk/7YT4sld6/plv6JECrC0B93In6uRRPY84zU5d1Cz7KIO9fqj?=
 =?us-ascii?Q?C1YiL+PUWlvWg0kvLQIQLxGYwbO0aWR+vahsj8uCKe/ekqjo4cdpnG1Y5UEo?=
 =?us-ascii?Q?CR0ytwsk6x+TUHI57zNtL3Ik9Nf7rg+hPwot1gb+EcanRpq9FzxGIxP+hPJG?=
 =?us-ascii?Q?sCsp8vFRJ5x7vkS+jLHRfR6HtSb/WHI4pTAG7U3vJaT5rpFkoWG7oZGGVXgU?=
 =?us-ascii?Q?sH7wsaHEecVXMo+QSJrsVSOMZyrqhcwPF2bnGzBv8yy4tu+wVjTDafz0y/Wp?=
 =?us-ascii?Q?Bpn0S2ZbqsZ7i6eqOrsQ8C3+2mG3SRIUiWbf5Hy6DTTagbtekz0p9+pqgHTH?=
 =?us-ascii?Q?admi9ZRLNCIASWJeG8EqLS9TPCxVBNyhLSyO9ivL1IN7qoBzHMKZyjTjUAd/?=
 =?us-ascii?Q?T0EuqypvaasfXw82QA6YeH5kfrx2FCWj+QWiVw25e6Zxh8gpRI/arKMmhIqp?=
 =?us-ascii?Q?Jzngrl4I6SB5dVxyuwb3YMT9KMnLCAgJJVpEy2gIJSnIXj6q/O2j5c8cj0Ds?=
 =?us-ascii?Q?rLUZAg4j48yxnguB4XP/TyF2QyNrkm6DtqvNgKAqAWnWB+iJzuULlRbmQedM?=
 =?us-ascii?Q?+MzMUUHfPGLrYP9L86Z1wQg3ekgSG54I8vHZa1Q9bIjpaiiH43v28GMMC/iQ?=
 =?us-ascii?Q?+A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e765b68-721f-4008-dcd9-08da576c2c25
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2022 12:05:33.6828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jdYtpsgCUQs9+lUZ+7boaVWzweRfq65rgt4XdAOF/I0ATZ+sMGjo6T2OWhCAvLrz0ynPyHaRYhn5lNAQSvoxUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4273
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Time-sensitive networking code needs to work with PTP times expressed in
nanoseconds, and with packet transmission times expressed in
picoseconds, since those would be fractional at higher than gigabit
speed when expressed in nanoseconds.

Convert the existing uses in tc-taprio to a PSEC_PER_NSEC macro.

Cc: Andy Lutomirski <luto@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/vdso/time64.h  | 1 +
 net/sched/sch_taprio.c | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/vdso/time64.h b/include/vdso/time64.h
index b40cfa2aa33c..f1c2d02474ae 100644
--- a/include/vdso/time64.h
+++ b/include/vdso/time64.h
@@ -6,6 +6,7 @@
 #define MSEC_PER_SEC	1000L
 #define USEC_PER_MSEC	1000L
 #define NSEC_PER_USEC	1000L
+#define PSEC_PER_NSEC	1000L
 #define NSEC_PER_MSEC	1000000L
 #define USEC_PER_SEC	1000000L
 #define NSEC_PER_SEC	1000000000L
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index b9c71a304d39..55a9c5ad9954 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -176,7 +176,7 @@ static ktime_t get_interval_end_time(struct sched_gate_list *sched,
 
 static int length_to_duration(struct taprio_sched *q, int len)
 {
-	return div_u64(len * atomic64_read(&q->picos_per_byte), 1000);
+	return div_u64(len * atomic64_read(&q->picos_per_byte), PSEC_PER_NSEC);
 }
 
 /* Returns the entry corresponding to next available interval. If
@@ -551,7 +551,7 @@ static struct sk_buff *taprio_peek(struct Qdisc *sch)
 static void taprio_set_budget(struct taprio_sched *q, struct sched_entry *entry)
 {
 	atomic_set(&entry->budget,
-		   div64_u64((u64)entry->interval * 1000,
+		   div64_u64((u64)entry->interval * PSEC_PER_NSEC,
 			     atomic64_read(&q->picos_per_byte)));
 }
 
-- 
2.25.1

