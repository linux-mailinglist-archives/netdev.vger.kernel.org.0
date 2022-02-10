Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 186704B112F
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 16:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243353AbiBJPFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 10:05:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243332AbiBJPFB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 10:05:01 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2127.outbound.protection.outlook.com [40.107.223.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54BD3BD2;
        Thu, 10 Feb 2022 07:05:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mc/Z3wknmSGOCelx0tepgEY9SKi5jYEcs9g91nV69lYrLjxs7mpB7FZMluM0Kj8V4rdFYYBH9nBFrsjOrbGC1fXa6FczYokXOUO6aSUOl0G3usUQdMpPtwameoJ6KGoiJfV5smTPbTgY1ccIRuiFOPYId35drgszOrqOd8z01oJkdh7JtntPNuy3Ki0W5hdjAxj9sY7G+m4WPpdjTD2ttOaYlvE5JNaWpKez+1q29/aYzyErzKysJtILYLqb8Ovt9FLAPeQH2bN+UTbQYuCsAgD5JSqNeOH8lyPZNE9ExiEEhophRjfuAw413R7F7C6wZLAxrySbsdDL6FyoGUzDiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ASc3zgnMq9X2Pk+LcocD5lIAwlmiNV8x7v/Sm4LEpdc=;
 b=NJDwiciI0gjMu5YXQZ/fLO2E0xJPjjBtCQG8qJJ5ngkZ3J2qxYW7M9DtWPNvKA/S0QvDnaq6Q44W9t/RU0Yb4aAWzeQsO6WKtvmLpthdmcjU50rQ17RYHiiZD7y/iOM1ZDixxALxhBWI2Qs+A9BhLlbTjcd5BZV+GvY8WAB/148D/HWBi17rTcS9/6cmZ8ipnAtAXqvafwPmkIYKn5OBI8/dTAczh9AN0ksbrh9O+OxoCUUkGh89U5a5CwcmI8W+z+GctNjqJadSGfpLJJJPCcKgpyOMDwf0mdjWmj4cXp2UIdysX7B6cTHSkvQfbgffaQ7u6AqH4CKYDU8h7RGJmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ASc3zgnMq9X2Pk+LcocD5lIAwlmiNV8x7v/Sm4LEpdc=;
 b=cBPs+MjP+xYHvkuM2NT7RZlEjouYLP5mqcrIYlfXgGshG7ZAlckGNzxQMv5p5zDz95b44GXzQeBYEBBHic22HpDjLaU1+wkjKORRlPAyQmUcPQy527v3+Z5bIxZDGJr8ZPKDBDBn5gTOp8S/AGFaOU+ftYBJ4GDPQ4Y++LoOSv8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM6PR10MB3420.namprd10.prod.outlook.com
 (2603:10b6:5:1b1::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 10 Feb
 2022 15:05:01 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5%6]) with mapi id 15.20.4975.012; Thu, 10 Feb 2022
 15:05:01 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v1 net 1/1] net: mscc: ocelot: fix mutex lock error during ethtool stats read
Date:   Thu, 10 Feb 2022 07:04:51 -0800
Message-Id: <20220210150451.416845-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220210150451.416845-1-colin.foster@in-advantage.com>
References: <20220210150451.416845-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR13CA0001.namprd13.prod.outlook.com
 (2603:10b6:300:16::11) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ad88271-abe5-45a8-2379-08d9eca6b5a5
X-MS-TrafficTypeDiagnostic: DM6PR10MB3420:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB342093827BA859836B553462A42F9@DM6PR10MB3420.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:983;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TNlimXYmI+HqjCE+6reZwu8OkbOyAfP5//Z3tl6Ymt+KkxDw50/kfp6MYXpg0M0ZzprNwGUPNWJHzBLc2Dx68okdI/NjhFXBEgiY1KxgXqllfmGSA7lvF2aX0Cf5nBEwWvYlmmBGzQ3DmmB6OdbcZZBXkKtf/bLpwJbU73g+PmuSbr6zr0eqsAW6qSFnM6bzdp7lnkAWoB7mDGZG4lgSN83xGZGgwY8+iQhOmB6Y9ZJvBB1iyOX0RAb4KIBexmEHqa+YBRPEgr90+437wcNCRyGDppqSBV2OfdXn/k/OwgfjAGHM5t0KeAKiDAxyQwoN6+7xBrmglFvjUOhjHu4AWVG0hqDEJDdIv+9xwh4as8bbFHsY5V8Hou1m3EwfzWpwtzAQb1v9LYsnZgJrGNgS37FooPgeE4ajP58VAU/YuHnXP8CIi7Diowr6IEx+ZacXC5lSl3ZuQKLksRiIKGSFOfza2D2cUD6myxVynW7Z6+6Eh4eXz6ja+SEOEBUCINqxtc5Ro1E5Ry25sP4jgUHMBwmPhF4RZ5aieWYGX6ZMLFsU2RVLEtOwz3w1aeHmzY2Kd4cNews9IpdbjABF2R8uuwInduc7YxUbTIY0yyuaVL6ba5I5RhPyRpS4yz7cVUpR3zHTdcvJnIe7n6poG37AjwFRc2hQaH+BeTexHCcabKVWzH4g2+wX4KgJwYGyv9CBt6tcZvHEZqRlREwomTeeYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(366004)(396003)(346002)(39830400003)(136003)(42606007)(8676002)(66946007)(316002)(508600001)(5660300002)(52116002)(6506007)(6666004)(66556008)(2616005)(4326008)(66476007)(6512007)(8936002)(54906003)(86362001)(1076003)(83380400001)(44832011)(6486002)(38100700002)(26005)(186003)(36756003)(38350700002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xyYlT/FQ467thr03C7sBkXXjBIXNL0Iq/D8ZTpqu+VBS+Sz/wjfyWwSUpTni?=
 =?us-ascii?Q?NoxNmNoO0RVcgvg3CQ3tqOSrk5xaesL77o1P6nl+Pc012lWoxYlLJbNmBKQl?=
 =?us-ascii?Q?4dYuA8ewHG4wkLdNR3h5eGO8VFvBxSsoqZSO9XNAuai0y35LC4u6VtEtBe/v?=
 =?us-ascii?Q?6K9iQluaWoT7RHofvcxKNpAlRwKxepFAYpqKyQd4MaAbVvwWH1LoveKLHNDh?=
 =?us-ascii?Q?cfbAJxiNUGpINIcE1aJIFPfg0jMFg8z9/oLK4RbU6gVFQEGEgF/thDq6CXXV?=
 =?us-ascii?Q?K6ywTqgpuEpNBc2r+gYiA3AwpIitx0yPexHPQCR2NGq8S5o/gFoMV5u5J/dd?=
 =?us-ascii?Q?zwhXQe6ac2N3WTqINzliUYaVq3zqRplK8LBZmbl4q11bDO/VFNpb2c25JeiJ?=
 =?us-ascii?Q?+f5WPu9WkegsfUtOXiCVfSM6kVQbH7L/dsq4mvpPzfxVhljjwwFLGODdtnuv?=
 =?us-ascii?Q?ja4mVvwiueLuTm/p1QyeDVVni6ec4dHj4bVIHH5bAGJMUsueYc0YvHzFRkq8?=
 =?us-ascii?Q?UJ2JzcThipGXB6gL2mZq804oi/v4M6fl/FZQT5s+TUtTl7OlWiebPx7MXUvD?=
 =?us-ascii?Q?HMRerdO80bICJR03cDPqAnpmRdKXYHHnHoRZIRKdkZPPvbY8TXBCVIzc5Rln?=
 =?us-ascii?Q?h1jYMVKbSNYkIuBNb806PcsownEj+OtE9fWatzDHffLpf0BKi5ojyMSjmaRk?=
 =?us-ascii?Q?Rx+Hjq9E+KyaO6yvQtFrQv2C6pqoyCruSLWMNigcWK2rRtGAiLP1QTE2xtjF?=
 =?us-ascii?Q?2VtiP3rOIRqavELvLghsLnk4eVbO4PXOcAwgE/8Um/v4kRLxuuv+5jRssvIX?=
 =?us-ascii?Q?whLr9MHgi1a8cj+cOH44S9Zt9fDE5Vjice9qQ99F1Qy+miOmSwnCp8LGuHY3?=
 =?us-ascii?Q?njugmZxzIAsPc959YyufyjntlgaRe+Yo48vXwynhQX5iflsBeMWL0pnFBoL6?=
 =?us-ascii?Q?R9fBOj0fRSFpC252KB1oKYpuPkfymigHacY16qyFXVU6SCP0ysgsSVbgDoy1?=
 =?us-ascii?Q?B7zpbKwSfD+OyekpEhLBF0+JPAgj08Xdfg6vR+fdzCd5BvXFX0D16ieBdhjm?=
 =?us-ascii?Q?5je1kp4m0IIvADBLmUtbazYS389Aib8mets7h6Fc6Cfm3byHy4dDvsH3S5UI?=
 =?us-ascii?Q?b+lMCP0bHnXShyhGiw8PWwvFTg582TDGTeyRW/K44QGU+2J19zpbuVTcPh8+?=
 =?us-ascii?Q?8ecs8OaxiuDAo50Z8uy9XHJtPWrQIO0M8M0ZVPTWWcvjXu70tAQdgDJSnQmU?=
 =?us-ascii?Q?QfGXE2qlMfo5kttEnmyeSGTGKWfcP7DwqZpXHEMtgzUMTRwSMd8twSciZNWe?=
 =?us-ascii?Q?Zj8+W//gAwuhHLAdl3ELLI2spYgNKqhXZg6gUmoV8G+m1vPJ4xAaZXl0bfVL?=
 =?us-ascii?Q?S26XcVimseDocGdELYKKPrQT0A6p9o7ee1LD6Ozz+OA48jRYiUQToSVFD7aK?=
 =?us-ascii?Q?jOkV0n+8Wp6FWqIlQ4UjhlWMWsOpYenNmwgTGgrvE1zwhfZ+/S333rFPNv+p?=
 =?us-ascii?Q?ZQFUrXsQYU17RttulfzD99nMJgbtJ49OGQGFya4lfmIII+GCpkGwj/GdH+FD?=
 =?us-ascii?Q?Lo5MXBhNwKCAZv/39IFtxxonIkZPoc3CfVPM9hivMDT3gkF9FDtKsjFhcK1u?=
 =?us-ascii?Q?zF6OrzNCTTCSUWJMX13pwPWOb23KBlufS5XlY0iCY8tEzCif37HMdMS4kgtK?=
 =?us-ascii?Q?0btc9Y2kqQwy3exGqjP+PAxqRvM=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ad88271-abe5-45a8-2379-08d9eca6b5a5
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 15:05:00.7423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J43FyFBUJSTKySyymChlEWGQ9CXg0BjG3LiKUvuIEC6RRpC50Vo5RxhSWU365PwDJDUbHNgZf3F15NEjIu5NKiPB42NY9CZOSVUHJ43fGbI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3420
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An ongoing workqueue populates the stats buffer. At the same time, a user
might query the statistics. While writing to the buffer is mutex-locked,
reading from the buffer wasn't. This could lead to buggy reads by ethtool.

This patch fixes the former blamed commit, but the bug was introduced in
the latter.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Fixes: 1e1caa9735f90 ("ocelot: Clean up stats update deferred work")
Fixes: a556c76adc052 ("net: mscc: Add initial Ocelot switch support")
Reported-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 354e4474bcc3..e6de86552df0 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1745,12 +1745,11 @@ void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data)
 }
 EXPORT_SYMBOL(ocelot_get_strings);
 
+/* Caller must hold &ocelot->stats_lock */
 static void ocelot_update_stats(struct ocelot *ocelot)
 {
 	int i, j;
 
-	mutex_lock(&ocelot->stats_lock);
-
 	for (i = 0; i < ocelot->num_phys_ports; i++) {
 		/* Configure the port to read the stats from */
 		ocelot_write(ocelot, SYS_STAT_CFG_STAT_VIEW(i), SYS_STAT_CFG);
@@ -1769,8 +1768,6 @@ static void ocelot_update_stats(struct ocelot *ocelot)
 					      ~(u64)U32_MAX) + val;
 		}
 	}
-
-	mutex_unlock(&ocelot->stats_lock);
 }
 
 static void ocelot_check_stats_work(struct work_struct *work)
@@ -1779,7 +1776,9 @@ static void ocelot_check_stats_work(struct work_struct *work)
 	struct ocelot *ocelot = container_of(del_work, struct ocelot,
 					     stats_work);
 
+	mutex_lock(&ocelot->stats_lock);
 	ocelot_update_stats(ocelot);
+	mutex_unlock(&ocelot->stats_lock);
 
 	queue_delayed_work(ocelot->stats_queue, &ocelot->stats_work,
 			   OCELOT_STATS_CHECK_DELAY);
@@ -1789,12 +1788,16 @@ void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data)
 {
 	int i;
 
+	mutex_lock(&ocelot->stats_lock);
+
 	/* check and update now */
 	ocelot_update_stats(ocelot);
 
 	/* Copy all counters */
 	for (i = 0; i < ocelot->num_stats; i++)
 		*data++ = ocelot->stats[port * ocelot->num_stats + i];
+
+	mutex_unlock(&ocelot->stats_lock);
 }
 EXPORT_SYMBOL(ocelot_get_ethtool_stats);
 
-- 
2.25.1

