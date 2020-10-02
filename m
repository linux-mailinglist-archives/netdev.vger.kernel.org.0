Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA369280BB1
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 02:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387450AbgJBAdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 20:33:09 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:39360 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727053AbgJBAdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 20:33:08 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601598786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ToFPZC5R052RWCcQF5hx9E1/n42Xsp/juzEFhQsvn/o=;
        b=ydRiITxOsP6uCeFfr9tuE6Y8SJbLrh7UMWa1fxWRHQXa5ywKPwKJQMEF9RToTfJrldpia6
        ncjZd2Vjm7994KuIyYdTD351jb4or0aKNnCYioJ7DVpjloQi9NNAHfNhFfR2aPcq72Piqk
        g5V2NlHJpifFx4r11q9vS8V1qBAqVmTII5AJOpX9qMjh9pc9xAbnnWSO+yh5wR7Rom3Bup
        GRvx8FPmRfyAEKOk14+7UnmjBIdWzoIE7c1FMv12M2ZMOYE+8gXnaP/UDF5A4MyQdY8np0
        bCjHfghhfYL0/hfsGWyY/9EKU/+fSUcJCcep6bV7PZtul2SC0APd4XnjUGebqg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601598786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ToFPZC5R052RWCcQF5hx9E1/n42Xsp/juzEFhQsvn/o=;
        b=q5AWawBlll32dWXXTHGWLeTsjGOquGQI9CVFpgOS2NvTgsFiK8D2FULcPNjhzb/18XsMXx
        cijsbhNj8M26KrAg==
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
Subject: Re: [PATCH 7/7] TC-ETF support PTP clocks
In-Reply-To: <20201001205141.8885-8-erez.geva.ext@siemens.com>
References: <20201001205141.8885-1-erez.geva.ext@siemens.com> <20201001205141.8885-8-erez.geva.ext@siemens.com>
Date:   Fri, 02 Oct 2020 02:33:05 +0200
Message-ID: <87a6x5eabi.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 01 2020 at 22:51, Erez Geva wrote:

>   - Add support for using a POSIX dynamic clock with
>     Traffic control Earliest TxTime First (ETF) Qdisc.

....

> --- a/include/uapi/linux/net_tstamp.h
> +++ b/include/uapi/linux/net_tstamp.h
> @@ -167,6 +167,11 @@ enum txtime_flags {
>  	SOF_TXTIME_FLAGS_MASK = (SOF_TXTIME_FLAGS_LAST - 1) |
>  				 SOF_TXTIME_FLAGS_LAST
>  };
> +/*
> + * Clock ID to use with POSIX clocks
> + * The ID must be u8 to fit in (struct sock)->sk_clockid
> + */
> +#define SOF_TXTIME_POSIX_CLOCK_ID (0x77)

Random number with a random name. 
  
>  struct sock_txtime {
>  	__kernel_clockid_t	clockid;/* reference clockid */
> diff --git a/net/sched/sch_etf.c b/net/sched/sch_etf.c
> index c0de4c6f9299..8e3e0a61fa58 100644
> --- a/net/sched/sch_etf.c
> +++ b/net/sched/sch_etf.c
> @@ -15,6 +15,7 @@
>  #include <linux/rbtree.h>
>  #include <linux/skbuff.h>
>  #include <linux/posix-timers.h>
> +#include <linux/posix-clock.h>
>  #include <net/netlink.h>
>  #include <net/sch_generic.h>
>  #include <net/pkt_sched.h>
> @@ -40,19 +41,40 @@ struct etf_sched_data {
>  	struct rb_root_cached head;
>  	struct qdisc_watchdog watchdog;
>  	ktime_t (*get_time)(void);
> +#ifdef CONFIG_POSIX_TIMERS
> +	struct posix_clock *pclock; /* pointer to a posix clock */

Tail comments suck because they disturb the reading flow and this
comment has absolute zero value.

Comments are required to explain things which are not obvious...

> +#endif /* CONFIG_POSIX_TIMERS */

Also this #ifdeffery is bonkers. How is TSN supposed to work without
POSIX_TIMERS in the first place?

>  static const struct nla_policy etf_policy[TCA_ETF_MAX + 1] = {
>  	[TCA_ETF_PARMS]	= { .len = sizeof(struct tc_etf_qopt) },
>  };
>  
> +static inline ktime_t get_now(struct Qdisc *sch, struct etf_sched_data *q)
> +{
> +#ifdef CONFIG_POSIX_TIMERS
> +	if (IS_ERR_OR_NULL(q->get_time)) {
> +		struct timespec64 ts;
> +		int err = posix_clock_gettime(q->pclock, &ts);
> +
> +		if (err) {
> +			pr_warn("Clock is disabled (%d) for queue %d\n",
> +				err, q->queue);
> +			return 0;

That's really useful error handling.

> +		}
> +		return timespec64_to_ktime(ts);
> +	}
> +#endif /* CONFIG_POSIX_TIMERS */
> +	return q->get_time();
> +}
> +
>  static inline int validate_input_params(struct tc_etf_qopt *qopt,
>  					struct netlink_ext_ack *extack)
>  {
>  	/* Check if params comply to the following rules:
>  	 *	* Clockid and delta must be valid.
>  	 *
> -	 *	* Dynamic clockids are not supported.
> +	 *	* Dynamic CPU clockids are not supported.
>  	 *
>  	 *	* Delta must be a positive or zero integer.
>  	 *
> @@ -60,11 +82,22 @@ static inline int validate_input_params(struct tc_etf_qopt *qopt,
>  	 * expect that system clocks have been synchronized to PHC.
>  	 */
>  	if (qopt->clockid < 0) {
> +#ifdef CONFIG_POSIX_TIMERS
> +		/**
> +		 * Use of PTP clock through a posix clock.
> +		 * The TC application must open the posix clock device file
> +		 * and use the dynamic clockid from the file description.

What? How is the code which calls into this guaranteed to have a valid
file descriptor open for a particular dynamic posix clock?

> +		 */
> +		if (!is_clockid_fd_clock(qopt->clockid)) {
> +			NL_SET_ERR_MSG(extack,
> +				       "Dynamic CPU clockids are not supported");
> +			return -EOPNOTSUPP;
> +		}
> +#else /* CONFIG_POSIX_TIMERS */
>  		NL_SET_ERR_MSG(extack, "Dynamic clockids are not supported");
>  		return -ENOTSUPP;
> -	}
> -
> -	if (qopt->clockid != CLOCK_TAI) {
> +#endif /* CONFIG_POSIX_TIMERS */
> +	} else if (qopt->clockid != CLOCK_TAI) {
>  		NL_SET_ERR_MSG(extack, "Invalid clockid. CLOCK_TAI must be used");
>  		return -EINVAL;
>  	}
> @@ -103,7 +136,7 @@ static bool is_packet_valid(struct Qdisc *sch, struct etf_sched_data *q,
>  		return false;
>  
>  skip:
> -	now = q->get_time();
> +	now = get_now(sch, q);

Yuck.

is_packet_valid() is invoked via:

    __dev_queue_xmit()
      __dev_xmit_skb()
         etf_enqueue_timesortedlist()
           is_packet_valid()

__dev_queue_xmit() does

       rcu_read_lock_bh();

and your get_now() does

    posix_clock_gettime()
       	down_read(&clk->rwsem);

 ----> FAIL

down_read() might sleep and cannot be called from a BH disabled
region. This clearly has never been tested with any mandatory debug
option enabled. Why am I not surprised?

Aside of accessing PCH clock being slow at hell this cannot ever work
and there is no way to make it work in any consistent form.

If you have several NICs on several PCH domains then all of these
domains should have one thing in common: CLOCK_TAI and the frequency.

If that's not the case then the overall system design is just broken,
but yes I'm aware of the fact that some industries decided to have their
own definition of time and frequency just because they can.

Handling different starting points of the domains interpretation of
"TAI" is doable because that's just an offset, but having different
frequencies is a nightmare.

So if such a trainwreck is a valid use case which needs to be supported
then just duct taping it into the code is not going to fly.

The only way to make this work is to sit down and actually design a
mechanism which allows to correlate the various notions of PCH time with
the systems CLOCK_TAI, i.e. providing offset and frequency correction.

Also you want to explain how user space applications should deal with
these different time domains in a sane way.

Thanks,

        tglx
