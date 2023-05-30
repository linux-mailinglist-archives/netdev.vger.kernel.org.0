Return-Path: <netdev+bounces-6544-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A7181716DE7
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 21:47:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 390D81C20CE1
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 19:47:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 963052D273;
	Tue, 30 May 2023 19:47:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83DA1200AD
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 19:47:21 +0000 (UTC)
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2081.outbound.protection.outlook.com [40.107.247.81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B8B10D;
	Tue, 30 May 2023 12:47:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OSJWPFbG5WcvngBpfsX9StvPe2UrLd/SXwSJwwvBBF7V4zogp6h/uxg+SUSSd8TlMB+7BbgSlwlB7YVCoyGd+9EbAFWXoB2WGhP+/dbvQ0vOevFk50cUfBnt/P39kmDEtrzCnsidfpN09l63mLOMlxH3gvqDV153VztJQeDiZvQdBe/DP4820K3fFQhMyCs+3zdORI9IWF0bHrIZl0v5DbRr+RYvMfzuL1R9s4vgdEo5rwOSVrfOGzpOVx9COIxHKIGwHgGKV+Tr+6TtK3KZKvhf8jtzLzKoXAe3s3VFiItbave8rPaiGBk3d+UAsYp5/U7KJe1bihbEj4ogW1iOEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=POx40CD82bCNmujTTvqTqO5xm/aUMZdqOWpdktKB6pc=;
 b=lXBAEeLG88Fi/xDzw9WQLHewTio1tIuqMYmLrKvyADUeqkI7FW9Mc4NcGv7jkx/uU3+dlXHRpvoiV1ywPGGRnPkzqHqlQGNuQkFh1oEc/PE2Y9TbIXcd3Q3DXBoaOdMThMg8TUaDT084zeMsWKqhQbeDeQgF27eJEgF/0u4WGd8pMXGM29Bt+yJtT/FewmNJ9IhdBLvbQfGQ9HjTkbnciew/u2Z5aRNfi3WgkTEnLlTiZUaaNzvsq08JvuYZOoBhwnrZPc/YsyL/ykz3EJ1dh+X8uZ3YyAxmd/xTpHKZZSIaAFmEnvFffZL6vO+1ZUuDOLplehMAt+gS8q+HnwwESQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=POx40CD82bCNmujTTvqTqO5xm/aUMZdqOWpdktKB6pc=;
 b=UaYJPb2e0NRjxr6Tt3G3btt90MDm30GgtpQ1KxNUUAcwIMHQ+Onn6vWgEDhtrCSLT9Jj1vN/PkFGx88R872Id258FbhYw9fdmtjrU3gphC1GxEIV2SpGV2EFGx+Da4lriShEVUukipSbV7rULnR6Upv6QU8uN3Qdhk0A/hgBjH4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM8PR04MB7379.eurprd04.prod.outlook.com (2603:10a6:20b:1c4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Tue, 30 May
 2023 19:47:12 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::b027:17aa:e5f5:4fea]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::b027:17aa:e5f5:4fea%6]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 19:47:12 +0000
Date: Tue, 30 May 2023 22:47:08 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Cc: netdev@vger.kernel.org, vinicius.gomes@intel.com, kuba@kernel.org,
	pabeni@redhat.com, linux-kernel@vger.kernel.org,
	tee.min.tan@linux.intel.com, edumazet@google.com
Subject: Re: [PATCH net v1] net/sched: taprio: fix cycle time extension logic
Message-ID: <20230530194708.zz6wnzaenau54hcv@skbuf>
References: <20230530082541.495-1-muhammad.husaini.zulkifli@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530082541.495-1-muhammad.husaini.zulkifli@intel.com>
X-ClientProxiedBy: FR2P281CA0086.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9b::14) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM8PR04MB7379:EE_
X-MS-Office365-Filtering-Correlation-Id: bd4fbadb-edee-44d8-027f-08db6146a98b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	1zum/j07VtYu8Nf/f9pSXqCN5etbs3sU+57E8lXNncS2x7WI0vrkxry7F/QfnoBErMiSl45SQU7FI7UMRg5VUW4AbI5etpZR742WONRb9sxIgqpSb84SkjRiyWx3arO3eUffjZBCkl+fpqrnW7rjL4wyUq1o7R75OsoCQfRi8lE/yI4TmKhfOpD7zN9fzSv6WImPNF/gxBR5PMSiEz3wtPYpqNBT0lNtdDPuki4UGecZXqsndISl+6Oe/StKNgDC/rst8X8Ip1bJWqxHa3k90esd1wIutA8VfGWSreui7Z8U/Nh08Aagsav8TOyATB+9h6cfc9qOXmK9sfoTor5fEP/8FaG00c4VghzOoZrkdVrct5Y4FqhllvYUBBxgBLKuUEdiOqHZJZaKxaLeyNCOQVTKGIE6LMWFhKYrDnz3CdfCzjn6Dst9QEtFlqugs1Vo9aVSpMa0GOF2XmJvOOD1LH/AOo1VYPl3l2wh+MC1DTe09lUlCc6cTK2Smy4+PKnggJDM8VdB2HUG1ihoQ3eBMPjiUhuwp1jhN+GjbSPr/FKT/EEyLFwYWzggiqXxsC5v
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(39860400002)(136003)(346002)(366004)(396003)(376002)(451199021)(5660300002)(8676002)(8936002)(41300700001)(316002)(478600001)(6512007)(1076003)(9686003)(26005)(6506007)(33716001)(38100700002)(186003)(66946007)(66476007)(4326008)(6916009)(66556008)(44832011)(2906002)(6486002)(6666004)(86362001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XWQGgOmrKue75eIsZruokxur/X1klsucqbUFSuj80JWckHwgYGuzWDe5+RDp?=
 =?us-ascii?Q?hmkbmul+COG7566KY/gao7vZmAkBr/NJkkRwTDWMJX5ZkWF3sZPHkWlHNNzu?=
 =?us-ascii?Q?GVT4GDsFMZK7/Z49mMs1/3UaO0Li2JmgH/+CvfRV8mx35x8xMFVZyfzRdMfB?=
 =?us-ascii?Q?uIFXVghUvj3no3/S3sL+79FchGyZHAsIUlWIXgkVRjiQUVViHrhrA+HbNEdB?=
 =?us-ascii?Q?qA7wYrlqTpomOxOkLVYsdQptFUTrpwvy5EI2I8skvBZ8R6DejhvhUqar8jqg?=
 =?us-ascii?Q?M7NF4noQCjiDjMmM3HXpSZ2CRuc/SsohF/6MiGn0AYZMRiSG5JVdiATKR+eD?=
 =?us-ascii?Q?oF6FVnn9NvBDVCz9oR5GLsw+rWmuL6/H1fosom3VBSsQyzd2QJGvCcUYJ1mV?=
 =?us-ascii?Q?WF4j4PMRhy3Zz9RW3bb8TxqhM4FMVK0QIUvEF2Qad2WZRH7WyLFIx7bGOR3z?=
 =?us-ascii?Q?1U09Q+mhaFWhVn07ApR3mISnU89ThltLHgUFK1Gj/u2X9ztEV9TFcx1VgfZl?=
 =?us-ascii?Q?9ZnumP/XdEB1YKOJYCDOnPD+Z5DaVjOE8Y6L0rPcJ3vxK/H9yUDtp9ICvzZF?=
 =?us-ascii?Q?dUTIiquvrRsiFhl84QKoo1hbRq+YS1JcmpGlVrthX8Ir7tENXq0RtY/pgsMN?=
 =?us-ascii?Q?pzr9Y4obgN2tqeype7O7YORc7vAqsGt9B3hSFmy8/QsO9Lx1iZeqGYNcgz7p?=
 =?us-ascii?Q?+ynWSNsnfXH4Tu4fTdvuVOdEyhuazM6lmk1vLnjCwzl1B4vWREINx1ImdLqz?=
 =?us-ascii?Q?+yLTdg1p8OrM4C1yeI8kpMG4U8a+F8kcRr6nGLWdqCxu9T6SLbWiaaa1X3MJ?=
 =?us-ascii?Q?+Fn5H8Q7LN6njLDhGki5JfZBfr9oq5Jfu2rXOgJvUmSTmtHe7YgUwTi6h7Ef?=
 =?us-ascii?Q?ilxXQq9CrTjCicNjiFc2GNxcBKJ0joF6aIWYBStOjfdHyPOr0qIYO1YnK7vc?=
 =?us-ascii?Q?JuC47tpaUBJRQsrhCfdy0Y/+x6UIFtb9VW6FVvWnBMtGyFOLkI74RZh8DKRO?=
 =?us-ascii?Q?nvu9o8n4i2mwqhSJ3CrkoaZTjS/DS1K3iDYIKEwRj+fFs3xqozRK/3PWQhpT?=
 =?us-ascii?Q?plsaOr8/IticifsRPHBkEu6K9dhk1IeMa00SE+9kN+YxtXhYQiJ7d7HOYKN9?=
 =?us-ascii?Q?KIOm1QlhKK0vHo9q2+dc6VbszPdV0kSxY/8p/tje6vZ1RF2eNHATT1DxesbD?=
 =?us-ascii?Q?M7+5/4tKCY54ZlrwFMTwmtkGURSN4KoodpNZrjKSMpDt86OPmkXfs4TptlvJ?=
 =?us-ascii?Q?MfPUrrMQuX3C5yoJVTFH4KPHA5f7h9sYFmGtfYPFJAhfhnTtewpTGxMfDonK?=
 =?us-ascii?Q?uM4u6RgL6ZD1pJ6SQ2I9M9AmeAl55/aF8ZBbvluv9r6hnmVrBsOps0XJma6I?=
 =?us-ascii?Q?l0fIi/mF/xdf1FmTu4kAC7f2jpa3/b+X1h+OcVzEL5/N9x2s+A4/SCR+mKM2?=
 =?us-ascii?Q?ScrSYHJphYjlTBLKcpnOodeC5uF3l/Dm1oUMAOhHwg5qs/SnP3JgiCekbyTn?=
 =?us-ascii?Q?YDrK2wsk6SPzu8CR6qOm38K4boYYoH4cEpQQ8SHhAH458jSu9yY0Nl/QdKP8?=
 =?us-ascii?Q?errjPE05AOdNozu4Q/FNC18aCuBJm9SIhx6ZWJBhVwKhD1P7Z4PiOtPra3Vb?=
 =?us-ascii?Q?Jw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd4fbadb-edee-44d8-027f-08db6146a98b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 19:47:12.5325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wJZejEFUQq6K3h5+L+XVqwLrAWAmbvY6eO7FUBs0vnoGK4MOxmBMN5uSiOjIAdmFf8lAG90nxbOrM/hwjJnyOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7379
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 04:25:41PM +0800, Muhammad Husaini Zulkifli wrote:
> From: Tan Tee Min <tee.min.tan@linux.intel.com>
> 
> According to IEEE Std. 802.1Q-2018 section Q.5 CycleTimeExtension,
> the Cycle Time Extension variable allows this extension of the last old
> cycle to be done in a defined way. If the last complete old cycle would
> normally end less than OperCycleTimeExtension nanoseconds before the new
> base time, then the last complete cycle before AdminBaseTime is reached
> is extended so that it ends at AdminBaseTime.
> 
> This patch extends the last entry of last complete cycle to AdminBaseTime.
> 
> Fixes: a3d43c0d56f1 ("taprio: Add support adding an admin schedule")
> Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
> Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
> ---

Thanks for the patch.

I think that the commit message insufficiently describes the problems
with the existing code. Also, the incorrect Fixes: tag suggests it may
even have been incompletely characterized.

Here are some additional thoughts of mine (also insufficient, since they
are based on static code analysis, done now) which may nuance things a
bit more, to change the Fixes tag and the shape of the proposed solution.

Of the problems is that after my commit a1e6ad30fa19 ("net/sched: taprio:
calculate guard band against actual TC gate close time"), the last entry
of the old admin schedule stops being valid from taprio_dequeue_from_txq()'s
perspective.

Before that patch, taprio_dequeue_from_txq() would look at entry->close_time
to decide whether packets are eligible to be sent or not. The old logic
would take a cycle length correction into account like this:

	if (should_change_schedules(admin, oper, close_time)) {
		/* Set things so the next time this runs, the new
		 * schedule runs.
		 */
		close_time = sched_base_time(admin);
		switch_schedules(q, &admin, &oper);
	}

	next->close_time = close_time; // contains the cycle length correction

After that patch, taprio_dequeue_from_txq() -> taprio_entry_allows_tx()
simply does not have logic to take a cycle time correction into consideration;
it just looks at entry->gate_close_time[tc] which is determined from the
previous entry->end_time plus the next->gate_duration[tc]. All
entry->gate_duration[tc] values are calculated only once, during
taprio_calculate_gate_durations(). Nowhere is a dynamic schedule change
taken into account.

Now, taprio_dequeue_from_txq() uses the following "entry" fields:
gate_close_time[tc] and budget[tc]. They are both recalculated
incorrectly by advance_sched(), which your change addresses. That is one
issue which should be described properly, and a patch limited to that.

Sure, you're modifying entry->gate_duration[] to account for the correction,
but now it no longer matches this kind of checks:

	/* Traffic classes which never close have infinite budget */
	if (entry->gate_duration[tc] == sched->cycle_time)
		budget = INT_MAX;

so this is why your choice is to also update the cycle_time. An unfortunate
consequence of that choice is that this might also become transiently visible
to taprio_dump(), which I'm not totally convinced is desirable - because
effectively, the cycle time shouldn't have changed. Although, true, the
old oper schedule is going away soon, we don't really know how soon. The
cycle times can be arbitrarily large. It would be great if we could save
the correction into a dedicated "s64 correction" variable (ranging from
-cycle_time+1 to +cycle_time_extension), and leave the cycle_time alone.

So my patch is partly to blame for today's mishaps, which is something
that this patch fails to identify properly.

But taprio_enqueue() is also a problem, and that isn't addressed. It can be,
that during a corrected cycle, frames which were oversized due to the
queueMaxSDU restriction are transiently not oversized anymore, and
should be allowed to pass - or the other way around (and this is worse):
a frame which would have passed through a full-size window will not pass
through a truncated last cycle (negative correction), and taprio_enqueue()
will not detect this and will not drop the skb.

taprio_update_queue_max_sdu() would need to be called, and that depends
on an up-to-date sched->max_open_gate_duration[tc] which isn't currently
recalculated.

So, one way or another, taprio_calculate_gate_durations() also needs to
be called again after a change to the schedule's correction.

>  net/sched/sch_taprio.c | 32 +++++++++++++++++++++-----------
>  1 file changed, 21 insertions(+), 11 deletions(-)
> 
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 76db9a10ef504..ef487fef83fce 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -99,6 +99,7 @@ struct taprio_sched {
>  	u32 max_sdu[TC_MAX_QUEUE]; /* save info from the user */
>  	u32 fp[TC_QOPT_MAX_QUEUE]; /* only for dump and offloading */
>  	u32 txtime_delay;
> +	bool sched_changed;

nitpick: sched_change_pending?

>  };
>  
>  struct __tc_taprio_qopt_offload {
> @@ -934,8 +935,10 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
>  	admin = rcu_dereference_protected(q->admin_sched,
>  					  lockdep_is_held(&q->current_entry_lock));
>  
> -	if (!oper)
> +	if (!oper || q->sched_changed) {
> +		q->sched_changed = false;
>  		switch_schedules(q, &admin, &oper);
> +	}
>  
>  	/* This can happen in two cases: 1. this is the very first run
>  	 * of this function (i.e. we weren't running any schedule
> @@ -962,20 +965,27 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
>  	end_time = ktime_add_ns(entry->end_time, next->interval);
>  	end_time = min_t(ktime_t, end_time, oper->cycle_end_time);
>  
> +	if (should_change_schedules(admin, oper, oper->cycle_end_time) &&
> +	    list_is_last(&next->list, &oper->entries)) {
> +		u32 ori_interval = next->interval;

The choice of operations seems unintuitive, when you could have simply
done:

	ktime_t correction = ktime_sub(sched_base_time(admin), end_time);

	next->interval += correction;
	oper->cycle_time += correction;

	(or possibly save the correction instead, see the feedback above)

> +
> +		next->interval += ktime_sub(sched_base_time(admin), end_time);
> +		oper->cycle_time += next->interval - ori_interval;
> +		end_time = sched_base_time(admin);
> +		oper->cycle_end_time = end_time;
> +		q->sched_changed = true;

I see an issue here: you need to set q->sched_changed = true whenever
should_change_schedules() returned true and not just for the last entry,
correct? Because there could be a schedule change which needs to happens
during entry 2 out of 4 of the current one (truncation case - negative
correction). In that case, I believe that should_change_schedules()
keeps shouting at you "change! change! change!" but you only call
switch_schedules() when you've reached entry 4 with the "next" pointer,
which is not what the standard suggests should be done.

IIUC, the standard says that when an admin and an oper sched meet, the
decision of what to do near the AdminBaseTime - whether to elongate the
next-to-last cycle of the oper sched or to let the last cycle run but to
cut it short - depends on the OperCycleTimeExtension. In a nutshell,
that variable says what is the maximum positive correction applicable to
the last sched entry and to the cycle time. If a positive correction
larger than that would be necessary (relative to the next-to-last cycle),
the decision is to just let the last cycle run for how long it can.

> +	}
> +
>  	for (tc = 0; tc < num_tc; tc++) {
> -		if (next->gate_duration[tc] == oper->cycle_time)
> +		if (next->gate_duration[tc] == oper->cycle_time) {
>  			next->gate_close_time[tc] = KTIME_MAX;
> -		else
> +		} else if (q->sched_changed && next->gate_duration[tc]) {
> +			next->gate_close_time[tc] = end_time;
> +			next->gate_duration[tc] = next->interval;

This deserves a comment because, although I understand what it intends
to do, I fail to understand if it will work or not :)

> +		} else {
>  			next->gate_close_time[tc] = ktime_add_ns(entry->end_time,
>  								 next->gate_duration[tc]);
> -	}
> -
> -	if (should_change_schedules(admin, oper, end_time)) {
> -		/* Set things so the next time this runs, the new
> -		 * schedule runs.
> -		 */
> -		end_time = sched_base_time(admin);
> -		switch_schedules(q, &admin, &oper);

I guess this is also a separate issue with the code. switch_schedules()
changes q->oper_sched too early, and taprio_skb_exceeds_queue_max_sdu()
looks at q->oper_sched.  So during an extension period, the queueMaxSDU
of the new schedule will be applied instead of the (extended) old one.

> +		}
>  	}
>  
>  	next->end_time = end_time;
> -- 
> 2.17.1
>

I guess at some point we should also fix up this comment?

	/* FIXME: the IEEE 802.1Q-2018 Specification isn't clear about
	 * how precisely the extension should be made. So after
	 * conformance testing, this logic may change.
	 */
	if (ktime_compare(next_base_time, extension_time) <= 0)
		return true;

