Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A607280AE4
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 01:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733221AbgJAXHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 19:07:10 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38932 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726855AbgJAXHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 19:07:10 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601593627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CeWasuH8uVghjhSktob8WCpWWRYI6xR+uAJ/UcMtjBg=;
        b=Rqxoph7dFgcG8krGiawE4Y6MUd7bF3VMca7BWA2pcwXnp6xwpF56klUV6/zJwCFJHMVNxS
        KKkdyzPybcW9U6yOy9q/IoO+AzkNlyBTi4RUnTzuQ5Rm9smWoQrHs1QdeHvaRxmR+c9Hqh
        hksVn5Wbk7JRy/HyfDZyF/tRlQT5AuXH7qtF3VuJzC3NG0N1Je/cmV2Rs44TfiUHuBGPsA
        Ua5+6Jc+SrlJxvOEwfmr96eWug+PhqwiRzVzSK+/GbOr6XqxlT7/gik7Zpl0XwmzXpw04L
        srOI9Wcud3XI6z0wilpEtj5LnaqZjFZeaNV2peOi/VBqd5xvtqSFEpMI+iUiVA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601593627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CeWasuH8uVghjhSktob8WCpWWRYI6xR+uAJ/UcMtjBg=;
        b=8LfLNkmBoxXBb7XMzFYBtii8a/+WQRSJLrcjTstIUQmuOkEuGwOGR1GjESZJFY3s4ewON2
        IeDdif8jprqmFpCQ==
To:     Erez Geva <erez.geva.ext@siemens.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrei Vagin <avagin@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Jesus Sanchez-Palencia <jesus.sanchez-palencia@intel.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vedang Patel <vedang.patel@intel.com>,
        Simon Sudler <simon.sudler@siemens.com>,
        Andreas Meisinger <andreas.meisinger@siemens.com>,
        Andreas Bucher <andreas.bucher@siemens.com>,
        Henning Schild <henning.schild@siemens.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Andreas Zirkler <andreas.zirkler@siemens.com>,
        Ermin Sakic <ermin.sakic@siemens.com>,
        An Ninh Nguyen <anninh.nguyen@siemens.com>,
        Michael Saenger <michael.saenger@siemens.com>,
        Bernd Maehringer <bernd.maehringer@siemens.com>,
        Gisela Greinert <gisela.greinert@siemens.com>,
        Erez Geva <erez.geva.ext@siemens.com>,
        Erez Geva <ErezGeva2@gmail.com>
Subject: Re: [PATCH 5/7] Traffic control using high-resolution timer issue
In-Reply-To: <20201001205141.8885-6-erez.geva.ext@siemens.com>
References: <20201001205141.8885-1-erez.geva.ext@siemens.com> <20201001205141.8885-6-erez.geva.ext@siemens.com>
Date:   Fri, 02 Oct 2020 01:07:07 +0200
Message-ID: <87lfgpeeas.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 01 2020 at 22:51, Erez Geva wrote:

Issue? You again fail to decribe the problem.

>   - Add new schedule function for Qdisc watchdog.
>     The function avoids reprogram if watchdog already expire
>     before new expire.

Why can't the existing function not be changed to do that?

>   - Use new schedule function in ETF.
>
>   - Add ETF range value to kernel configuration.
>     as the value is characteristic to Hardware.

No. That's completely wrong. Hardware properties need to be established
at boot/runtime otherwise you can't build a kernel which runs on
different platforms.

> +void qdisc_watchdog_schedule_soon_ns(struct qdisc_watchdog *wd, u64 expires,
> +				     u64 delta_ns)

schedule soon? That sounds like schedule it sooner than later, but I
don't care.

> +{
> +	if (test_bit(__QDISC_STATE_DEACTIVATED,
> +		     &qdisc_root_sleeping(wd->qdisc)->state))
> +		return;
> +
> +	if (wd->last_expires == expires)
> +		return;

How is this supposed to be valid without checking whether the timer is
queued in the first place?

Maybe the function name should be schedule_soon_or_not()

> +	/**

Can you please use proper comment style? This is neither network comment
style nor the regular sane kernel comment style. It's kerneldoc comment
style which is reserved for function and struct documentation.

> +	 * If expires is in [0, now + delta_ns],
> +	 * do not program it.

This range info is just confusing. Just use plain english.

> +	 */
> +	if (expires <= ktime_to_ns(hrtimer_cb_get_time(&wd->timer)) + delta_ns)
> +		return;

So if the watchdog is NOT queued and expiry < now + delta_ns then this
returns and nothing starts the timer ever.

That might all be correct, but without any useful explanation it looks
completely bogus.

> +	/**
> +	 * If timer is already set in [0, expires + delta_ns],
> +	 * do not reprogram it.
> +	 */
> +	if (hrtimer_is_queued(&wd->timer) &&
> +	    wd->last_expires <= expires + delta_ns)
> +		return;
> +
> +	wd->last_expires = expires;
> +	hrtimer_start_range_ns(&wd->timer,
> +			       ns_to_ktime(expires),
> +			       delta_ns,
> +			       HRTIMER_MODE_ABS_PINNED);
> +}
> +EXPORT_SYMBOL(qdisc_watchdog_schedule_soon_ns);
> +
>  void qdisc_watchdog_cancel(struct qdisc_watchdog *wd)
>  {
>  	hrtimer_cancel(&wd->timer);
> diff --git a/net/sched/sch_etf.c b/net/sched/sch_etf.c
> index c48f91075b5c..48b2868c4672 100644
> --- a/net/sched/sch_etf.c
> +++ b/net/sched/sch_etf.c
> @@ -20,6 +20,11 @@
>  #include <net/pkt_sched.h>
>  #include <net/sock.h>
>  
> +#ifdef CONFIG_NET_SCH_ETF_TIMER_RANGE
> +#define NET_SCH_ETF_TIMER_RANGE CONFIG_NET_SCH_ETF_TIMER_RANGE
> +#else
> +#define NET_SCH_ETF_TIMER_RANGE (5 * NSEC_PER_USEC)
> +#endif
>  #define DEADLINE_MODE_IS_ON(x) ((x)->flags & TC_ETF_DEADLINE_MODE_ON)
>  #define OFFLOAD_IS_ON(x) ((x)->flags & TC_ETF_OFFLOAD_ON)
>  #define SKIP_SOCK_CHECK_IS_SET(x) ((x)->flags & TC_ETF_SKIP_SOCK_CHECK)
> @@ -128,8 +133,9 @@ static void reset_watchdog(struct Qdisc *sch)
>  		return;
>  	}
>  
> -	next = ktime_sub_ns(skb->tstamp, q->delta);
> -	qdisc_watchdog_schedule_ns(&q->watchdog, ktime_to_ns(next));
> +	next = ktime_sub_ns(skb->tstamp, q->delta + NET_SCH_ETF_TIMER_RANGE);
> +	qdisc_watchdog_schedule_soon_ns(&q->watchdog, ktime_to_ns(next),
> +					NET_SCH_ETF_TIMER_RANGE);

This is changing 5 things at once. That's just wrong.

patch 1: Add the new function and explain why it's required

patch 2: Make reset_watchdog() use it

patch 3: Add a mechanism to retrieve the magic hardware range from the
         underlying hardware driver and add that value to q->delta or
         set q->delta to it. Whatever makes sense. The current solution
         makes no sense at all

Thanks,

        tglx
