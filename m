Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB9367F379
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 02:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233306AbjA1BIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 20:08:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233602AbjA1BIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 20:08:02 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2045.outbound.protection.outlook.com [40.107.8.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E36E443461
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 17:07:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IIt5Lhlgx1gFGXWQBWs/QJ7TY8yA2ETGPL8w3LHgGIbei215AyPYlT3oE/VDJYKmll/OmWberwHs7LG30OIVvRzipG4nDcGJZ4E3eEZfhC5urgrCHTRotAXMDOsLw4wemxqqimZJCylJOOJkVaou23LNICidgCpLV82rKQbNA4oZbtd1N9hQE52wxx9unigr3pg/zsDCUFUE+OHgOn7jPT+IU5JjChYCYPsG+030LkFSmui3p6kW0l73hHSUcHrbH1tR7puCaElxK7m50tp+hKJq0POlWZ8pcTmenjYzGfVR9wqJodULijvgyEPLRtcM33tatMPpLncVsvu9NaP3tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LjHenr29awFekdslInYr5BdHf0tzqpNTiLJICSzaUjQ=;
 b=ftu51/ONM36TnZOfewPStv/iNTTBoDeUwTByvyZpMWjBJejIukyb3xPwMIynD9eV0ciQvapJmR4NAIMkVYora136IznVYPgc2FGI1wLoxCsvfxLBYRxZq/GadIWOCuWf7/v4ebbs5uj2bNJEARea/L39WDGlQTaxwsHb4h9Ru8xYw8Mdy4rmo+mzEENgb4RIv5e8O0oNGlfJUwYFILafIJgkJvejsQFHkONdUkEHFygJ6ekNYYLOswmvg4AR8SFAIfOXV5QU0K0Afv2Z/V3Ep8cRpKzxL+UH5c7/j3FwMMM2sDqz6376TndPueCc68vqCeep/BOySt64pLoRK4HgAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LjHenr29awFekdslInYr5BdHf0tzqpNTiLJICSzaUjQ=;
 b=m4y8lIj3XtwYF/WwMBXZGebBp0jRD3uN4NJzJ7U1jksMThBvIST1fRn24MnVe2E21I4Mv5/rBMTOP6GeyLDuVZAh6wjHMs73eKU7VZqCyFgbFq7J2MWyd6Z27D1Bd4E3nqCvfgNdpSPrngSN8nm7x9oHP/wekxzYZzfzNGrxvdE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9203.eurprd04.prod.outlook.com (2603:10a6:102:222::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.25; Sat, 28 Jan
 2023 01:07:53 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6043.025; Sat, 28 Jan 2023
 01:07:53 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH net-next 07/15] net/sched: taprio: rename close_time to end_time
Date:   Sat, 28 Jan 2023 03:07:11 +0200
Message-Id: <20230128010719.2182346-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
References: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0128.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7a::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB9203:EE_
X-MS-Office365-Filtering-Correlation-Id: e05c38d8-bb4e-4c6e-a78a-08db00cc1504
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /vA0+Ks1lIn8sNtLebUy9nqvbRaXgERZ8wDAo356sOz9rQSMXKf+2sY8DkVzw36ru8NmAKFrrM+JH/Bh+8rDhpxMDIbEIx+Y3PZWZJvB2B+LryMbkCiWmNzLhV4KorDyYmDgl4EsYazg+6ie82EjEtSsauIhxSiYb7Uur0V1kmUlkmNs6kU0xD00DfyPSeydtevfrdlNsOyLVjAH2gCLoKd9wCby8Wue6YXp5XCO/J1WVV8qusEDM3ExgzuEBYh1Vo24XWCbVveoSniEpLwrw3WgE85UgjITLHYg2vV6wLtO6WsJ4EbXkGcqXv02teBWYZIx2iHGDfbvzXiiYDTAheZIt1VhBlviYexgjsEckBSo6q3oo4jXF/ZE2hWdHZ7Qw1uJWNkpUQiIFbRyO5yJP/9lYfLid/n9gnD2HCZdGD/7tVh0DNoMJeFVM66DHS93Vnn1uBhymjILd+EuCfdWtK2ZpbNBgFd95GhcrDbzvWdWV3ybWocgd9mK7yrAJBCtvLNd23N6QuWH8wwWDoX4AVCUuh6UnlA3Ov21MhpQ59DkJcfKo2kxpXm0hJOy59vtx/svmMRL4mGJhT85AGlmvirU0E1B72seZ5Rf16cPxFauZ+4KQQVG1N16j6cogSQ0HOuRfust6fT6ZuuBwPQxA9sa2o+SO7H1P6oKczoRyZeItB9T4IHsmWfHsEre8wGDGfYWzFstMJOUFbpMka4Xgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199018)(186003)(36756003)(6506007)(1076003)(6512007)(26005)(38350700002)(5660300002)(38100700002)(44832011)(2906002)(6486002)(6666004)(52116002)(2616005)(86362001)(83380400001)(6916009)(4326008)(66946007)(54906003)(478600001)(66476007)(66556008)(316002)(8676002)(8936002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?if+dwK8R2Sfmc2l+wlP3rMRP3/l2Jr+yfqSBWQgS18PdKGoir+nTMXz1r7u7?=
 =?us-ascii?Q?gLxsMg1AuB2KVlFVN7uoG9A2mymwxI4yxGLHyISeEgEHuTHAZqkQ6QWlLsgU?=
 =?us-ascii?Q?iW1BhcU77JGlu5xLnxt2PXpD3H9xnbpT7J6GQR/jh+4UC3qoYuoeq79RjS2Z?=
 =?us-ascii?Q?vDKXY+YUaBqW66RgFQ/AcWZWclkCiKaUgMvAZpji1jzRY4WKECHIFz/zy2mY?=
 =?us-ascii?Q?kXkcZjjgOE0irOyyKXFujBnxALcmGgDJt4oOIEg6FFkpoeyIXbRBhSHVaOtV?=
 =?us-ascii?Q?bphXuLZERfkdp1olsKEtdmuYWX3AZov/uCx1YvzFoZlzLpHfKpYTLDiHPaNF?=
 =?us-ascii?Q?CR59nBu90A9/vCtnAAoB3U8YJg4gzh1N9SCIRXypuj7rSTWoW+dK3ZuMOMjV?=
 =?us-ascii?Q?Xxlg+hxZvWNpWtqABwpg4plZFpCuP9qmOupRkXojVeRU/9EKCIHbHWzAGktT?=
 =?us-ascii?Q?DnQgZehFOTHzIVXvfysQD8N7VrHiR8A7R+ZJs37RpPJgNckywafxR1ICwDzz?=
 =?us-ascii?Q?p8QHk1H1RD4la8OrZEnhQQn+Fuf1rv0wA/cAIyUwbq8h9XxZFw5lhAiP993n?=
 =?us-ascii?Q?LYuHcUCatV7GlnWjeLHlu2cRuox8IW299cT7qxBoNkC3asaPjhxMGInUmW7p?=
 =?us-ascii?Q?s6yf/kK5OY7wSJRffUlhBKbIVAcNTZntRa1zxcZwk2Eog1rOKbRUOWfWXlzr?=
 =?us-ascii?Q?5EOqMCYMVtW0ripWGCxZ2TPWPpM/CirBahuAZOGTmrHR1Zim3raXX/dGXM7N?=
 =?us-ascii?Q?SHuE7oj5gs65Ryw3do8BgGKiMYQESyAL5CEZARYbQYGirzaC5ZBqqJ2oG/f/?=
 =?us-ascii?Q?o/hZyJsCKZNCCMx+yVABunGYT+GAEfIx3IGxsbW1e19hiyZfMj5dse/AsiFO?=
 =?us-ascii?Q?cUY+7N5Ec6WGGfUeQ121+/TvEp559QhoWr3Dc+X1/snsSMFyEZ2N7Hybhvis?=
 =?us-ascii?Q?o32sCevWYHCqub7ymGe+acqM13MpdSQ9NeOMEAMKVZHuAlTfVROZr0TR7WG4?=
 =?us-ascii?Q?jUVF/gOKOGwBQR0vAXyCTME7FiRMVuSOvGL8zTd977DmaSbuolnlpmJu6bLU?=
 =?us-ascii?Q?WNrB6vC5r0XvVvsTB7iqmLVRSsFvdkzCDTj18FxeImUdZNp5j/HBCeii3yk6?=
 =?us-ascii?Q?sr1RagQRDVcnM/cLkLbXFOapMp9H5Jm0Bek3kRoqmNSvO21zWUu2QdJAVklP?=
 =?us-ascii?Q?vXTCWvhQw+hbP8CibpPrhIEFS7xH8Ijxx4AAm/jnHvjMo1WF2xk7Wdv37znQ?=
 =?us-ascii?Q?6oRTFw4BZoUXCHNzeKjDXZ44A/ssFfJm2W0oEFJEiKzz8lj2bPcgf0R+QgwI?=
 =?us-ascii?Q?rKtoFSDcWWZs8I2PANK4fdBbXamrOgzQcoYdu3Kp20qpd9Q4xb5aIPgXPI81?=
 =?us-ascii?Q?RLTq/CRCW2aLNlSt4qxCr3niZOj70ugtdLDnjAwEzExVrF/leeHS+KTOcRd+?=
 =?us-ascii?Q?VJfPV/mElcUp2xumWBhY8YAjf13BrleMZGJvyC9sOoQMTRBivTbuH+xesAEf?=
 =?us-ascii?Q?A+hgewXVmMy8jEAUvluR9z2WgGQy4/EXZ0hS/Zr4SMuHmj1/TeuJA45ofwtv?=
 =?us-ascii?Q?YG2c4veV4y+b4Fza57ma5PQNKKzF9FSAyKearPAPMX815IDJVfZg/Vw9cC9v?=
 =?us-ascii?Q?HQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e05c38d8-bb4e-4c6e-a78a-08db00cc1504
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 01:07:53.0574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5XO0NMtwO3CKzD4JWpv9+1cMBJdDF9L9w4mLPjKAYcCSH/R7UFJT3mdiRS8af43fzeCSVLU0QptXPrut/Qlx+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9203
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a confusion in terms in taprio which makes what is called
"close_time" to be actually used for 2 things:

1. determining when an entry "closes" such that transmitted skbs are
   never allowed to overrun that time (?!)
2. an aid for determining when to advance and/or restart the schedule
   using the hrtimer

It makes more sense to call this so-called "close_time" "end_time",
because it's not clear at all to me what "closes". Future patches will
hopefully make better use of the term "to close".

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_taprio.c | 52 +++++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index fe92a75701bd..d5d284eaab66 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -41,11 +41,11 @@ struct sched_entry {
 	u64 tc_gate_duration[TC_MAX_QUEUE];
 	struct list_head list;
 
-	/* The instant that this entry "closes" and the next one
+	/* The instant that this entry ends and the next one
 	 * should open, the qdisc will make some effort so that no
 	 * packet leaves after this time.
 	 */
-	ktime_t close_time;
+	ktime_t end_time;
 	ktime_t next_txtime;
 	atomic_t budget;
 	int index;
@@ -62,7 +62,7 @@ struct sched_gate_list {
 	struct rcu_head rcu;
 	struct list_head entries;
 	size_t num_entries;
-	ktime_t cycle_close_time;
+	ktime_t cycle_end_time;
 	s64 cycle_time;
 	s64 cycle_time_extension;
 	s64 base_time;
@@ -591,7 +591,7 @@ static struct sk_buff *taprio_dequeue_from_txq(struct Qdisc *sch, int txq,
 	 * guard band ...
 	 */
 	if (gate_mask != TAPRIO_ALL_GATES_OPEN &&
-	    ktime_after(guard, entry->close_time))
+	    ktime_after(guard, entry->end_time))
 		return NULL;
 
 	/* ... and no budget. */
@@ -678,7 +678,7 @@ static bool should_restart_cycle(const struct sched_gate_list *oper,
 	if (list_is_last(&entry->list, &oper->entries))
 		return true;
 
-	if (ktime_compare(entry->close_time, oper->cycle_close_time) == 0)
+	if (ktime_compare(entry->end_time, oper->cycle_end_time) == 0)
 		return true;
 
 	return false;
@@ -686,7 +686,7 @@ static bool should_restart_cycle(const struct sched_gate_list *oper,
 
 static bool should_change_schedules(const struct sched_gate_list *admin,
 				    const struct sched_gate_list *oper,
-				    ktime_t close_time)
+				    ktime_t end_time)
 {
 	ktime_t next_base_time, extension_time;
 
@@ -695,18 +695,18 @@ static bool should_change_schedules(const struct sched_gate_list *admin,
 
 	next_base_time = sched_base_time(admin);
 
-	/* This is the simple case, the close_time would fall after
+	/* This is the simple case, the end_time would fall after
 	 * the next schedule base_time.
 	 */
-	if (ktime_compare(next_base_time, close_time) <= 0)
+	if (ktime_compare(next_base_time, end_time) <= 0)
 		return true;
 
-	/* This is the cycle_time_extension case, if the close_time
+	/* This is the cycle_time_extension case, if the end_time
 	 * plus the amount that can be extended would fall after the
 	 * next schedule base_time, we can extend the current schedule
 	 * for that amount.
 	 */
-	extension_time = ktime_add_ns(close_time, oper->cycle_time_extension);
+	extension_time = ktime_add_ns(end_time, oper->cycle_time_extension);
 
 	/* FIXME: the IEEE 802.1Q-2018 Specification isn't clear about
 	 * how precisely the extension should be made. So after
@@ -725,7 +725,7 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 	struct sched_gate_list *oper, *admin;
 	struct sched_entry *entry, *next;
 	struct Qdisc *sch = q->root;
-	ktime_t close_time;
+	ktime_t end_time;
 
 	spin_lock(&q->current_entry_lock);
 	entry = rcu_dereference_protected(q->current_entry,
@@ -744,41 +744,41 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 	 * entry of all schedules are pre-calculated during the
 	 * schedule initialization.
 	 */
-	if (unlikely(!entry || entry->close_time == oper->base_time)) {
+	if (unlikely(!entry || entry->end_time == oper->base_time)) {
 		next = list_first_entry(&oper->entries, struct sched_entry,
 					list);
-		close_time = next->close_time;
+		end_time = next->end_time;
 		goto first_run;
 	}
 
 	if (should_restart_cycle(oper, entry)) {
 		next = list_first_entry(&oper->entries, struct sched_entry,
 					list);
-		oper->cycle_close_time = ktime_add_ns(oper->cycle_close_time,
-						      oper->cycle_time);
+		oper->cycle_end_time = ktime_add_ns(oper->cycle_end_time,
+						    oper->cycle_time);
 	} else {
 		next = list_next_entry(entry, list);
 	}
 
-	close_time = ktime_add_ns(entry->close_time, next->interval);
-	close_time = min_t(ktime_t, close_time, oper->cycle_close_time);
+	end_time = ktime_add_ns(entry->end_time, next->interval);
+	end_time = min_t(ktime_t, end_time, oper->cycle_end_time);
 
-	if (should_change_schedules(admin, oper, close_time)) {
+	if (should_change_schedules(admin, oper, end_time)) {
 		/* Set things so the next time this runs, the new
 		 * schedule runs.
 		 */
-		close_time = sched_base_time(admin);
+		end_time = sched_base_time(admin);
 		switch_schedules(q, &admin, &oper);
 	}
 
-	next->close_time = close_time;
+	next->end_time = end_time;
 	taprio_set_budget(q, next);
 
 first_run:
 	rcu_assign_pointer(q->current_entry, next);
 	spin_unlock(&q->current_entry_lock);
 
-	hrtimer_set_expires(&q->advance_timer, close_time);
+	hrtimer_set_expires(&q->advance_timer, end_time);
 
 	rcu_read_lock();
 	__netif_schedule(sch);
@@ -1065,8 +1065,8 @@ static int taprio_get_start_time(struct Qdisc *sch,
 	return 0;
 }
 
-static void setup_first_close_time(struct taprio_sched *q,
-				   struct sched_gate_list *sched, ktime_t base)
+static void setup_first_end_time(struct taprio_sched *q,
+				 struct sched_gate_list *sched, ktime_t base)
 {
 	struct sched_entry *first;
 	ktime_t cycle;
@@ -1077,9 +1077,9 @@ static void setup_first_close_time(struct taprio_sched *q,
 	cycle = sched->cycle_time;
 
 	/* FIXME: find a better place to do this */
-	sched->cycle_close_time = ktime_add_ns(base, cycle);
+	sched->cycle_end_time = ktime_add_ns(base, cycle);
 
-	first->close_time = ktime_add_ns(base, first->interval);
+	first->end_time = ktime_add_ns(base, first->interval);
 	taprio_set_budget(q, first);
 	rcu_assign_pointer(q->current_entry, NULL);
 }
@@ -1736,7 +1736,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		if (admin)
 			call_rcu(&admin->rcu, taprio_free_sched_cb);
 	} else {
-		setup_first_close_time(q, new_admin, start);
+		setup_first_end_time(q, new_admin, start);
 
 		/* Protects against advance_sched() */
 		spin_lock_irqsave(&q->current_entry_lock, flags);
-- 
2.34.1

