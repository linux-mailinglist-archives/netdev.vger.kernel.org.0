Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B89C381C0
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 01:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727714AbfFFXVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 19:21:39 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:33573 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfFFXVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 19:21:39 -0400
Received: by mail-qk1-f195.google.com with SMTP id r6so189346qkc.0
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 16:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=oNd8C3uLFR70L04RdJHbC0rFL10fD4aQ+t0BpAqCwJs=;
        b=FaRpV5wcxb2aCiL5Sto5DctZQrgyZrijTXhuq/7MCOVAY3kKP1BoaYm+EuKJlzvWXB
         JE8FBZzjMR0V5sUNM3AfpXRIveL9MuvT3dAjn3BQaIVZJQkq3sqTHk5O8feT6BkvVGje
         t7GAqx/mDqLj7POdGoY55GyXxyfBGGfhYV8hLZr2EyD073UHwzhhOSIdchW9PvOL7hP2
         GYdfq3luVQnp4BWIhn0B/rQcjiXPrY1Mv5EmWpwUTkuePF+5+iELV8UiFAzOTt2iTYKF
         gzeCgQWnh/rM4CBOecgaR+7tfp+4f2msYU02MGC7BDK6InRPQqP7y1S5xuqo6vJhssin
         iiZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=oNd8C3uLFR70L04RdJHbC0rFL10fD4aQ+t0BpAqCwJs=;
        b=p6wJefNEJZ9DWglahTk2qK5BtPVNeSXK0/DUZ67WuoMRi9xcp5S0n/EdIQFoLgtM6s
         WfjsHKPQJLuyJkhuPCCdeUvDVTV+rukCZTnmM8P+U3Qvyb5nImb2iqQgXzJBGhPO5M5T
         USr8odk4OBR97LZ+F0i4MizI0G591QSlXnnc0+OJT/XL48OMqyZI86osSv/31LJGfXEw
         pvhV9xkVHqZTSx8jm2n7lb8qVZaSUFLuIhMhSprvvVQG8MXHIOGloQhAWWxEUUr7wfET
         tGAED6IHjxIRDcqS28fkv12JSikB5JD2Ty+HKv/8wO/5o6g9zGTT7a7rIyPjMR7puTQ4
         4mBA==
X-Gm-Message-State: APjAAAXlTXFYtpGb0hsMAg1+XPxImqTSeqWTc2Byl5aeuJbp+MMrcfoN
        jXuAkJEvqwfxcsT3VevFSr7UvA==
X-Google-Smtp-Source: APXvYqxUN3M6K6kOiuGKQuA4FzGu2FyIVcObpjjiUxjk9CVVKSxY02ktl20Lzma3OVKWrWJ1rfj3eA==
X-Received: by 2002:a37:8847:: with SMTP id k68mr41343178qkd.278.1559863297587;
        Thu, 06 Jun 2019 16:21:37 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id a51sm195087qta.85.2019.06.06.16.21.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 16:21:37 -0700 (PDT)
Date:   Thu, 6 Jun 2019 16:21:32 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Vedang Patel <vedang.patel@intel.com>
Cc:     netdev@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        davem@davemloft.net, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, intel-wired-lan@lists.osuosl.org,
        vinicius.gomes@intel.com, l@dorileo.org, m-karicheri2@ti.com
Subject: Re: [PATCH net-next v2 4/6] taprio: Add support for txtime-assist
 mode.
Message-ID: <20190606162132.0591cc37@cakuba.netronome.com>
In-Reply-To: <1559843458-12517-5-git-send-email-vedang.patel@intel.com>
References: <1559843458-12517-1-git-send-email-vedang.patel@intel.com>
        <1559843458-12517-5-git-send-email-vedang.patel@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  6 Jun 2019 10:50:56 -0700, Vedang Patel wrote:
> Currently, we are seeing non-critical packets being transmitted outside of
> their timeslice. We can confirm that the packets are being dequeued at the
> right time. So, the delay is induced in the hardware side.  The most likely
> reason is the hardware queues are starving the lower priority queues.
> 
> In order to improve the performance of taprio, we will be making use of the
> txtime feature provided by the ETF qdisc. For all the packets which do not
> have the SO_TXTIME option set, taprio will set the transmit timestamp (set
> in skb->tstamp) in this mode. TAPrio Qdisc will ensure that the transmit
> time for the packet is set to when the gate is open. If SO_TXTIME is set,
> the TAPrio qdisc will validate whether the timestamp (in skb->tstamp)
> occurs when the gate corresponding to skb's traffic class is open.
> 
> Following two parameters added to support this mode:
> - flags: used to enable txtime-assist mode. Will also be used to enable
>   other modes (like hardware offloading) later.
> - txtime-delay: This indicates the minimum time it will take for the packet
>   to hit the wire after it reaches taprio_enqueue(). This is useful in
>   determining whether we can transmit the packet in the remaining time if
>   the gate corresponding to the packet is currently open.
> 
> An example configuration for enabling txtime-assist:
> 
> tc qdisc replace dev eth0 parent root handle 100 taprio \\
>       num_tc 3 \\
>       map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \\
>       queues 1@0 1@0 1@0 \\
>       base-time 1558653424279842568 \\
>       sched-entry S 01 300000 \\
>       sched-entry S 02 300000 \\
>       sched-entry S 04 400000 \\
>       flags 0x1 \\
>       txtime-delay 40000 \\
>       clockid CLOCK_TAI
> 
> tc qdisc replace dev $IFACE parent 100:1 etf skip_sock_check \\
>       offload delta 200000 clockid CLOCK_TAI
> 
> Note that all the traffic classes are mapped to the same queue.  This is
> only possible in taprio when txtime-assist is enabled. Also, note that the
> ETF Qdisc is enabled with offload mode set.
> 
> In this mode, if the packet's traffic class is open and the complete packet
> can be transmitted, taprio will try to transmit the packet immediately.
> This will be done by setting skb->tstamp to current_time + the time delta
> indicated in the txtime-delay parameter. This parameter indicates the time
> taken (in software) for packet to reach the network adapter.
> 
> If the packet cannot be transmitted in the current interval or if the
> packet's traffic is not currently transmitting, the skb->tstamp is set to
> the next available timestamp value. This is tracked in the next_launchtime
> parameter in the struct sched_entry.
> 
> The behaviour w.r.t admin and oper schedules is not changed from what is
> present in software mode.
> 
> The transmit time is already known in advance. So, we do not need the HR
> timers to advance the schedule and wakeup the dequeue side of taprio.  So,
> HR timer won't be run when this mode is enabled.
> 
> Signed-off-by: Vedang Patel <vedang.patel@intel.com>
> ---
>  include/uapi/linux/pkt_sched.h |   4 +
>  net/sched/sch_taprio.c         | 344 +++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 331 insertions(+), 17 deletions(-)
> 
> diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
> index 69fc52e4d6bd..c085860ff637 100644
> --- a/include/uapi/linux/pkt_sched.h
> +++ b/include/uapi/linux/pkt_sched.h
> @@ -1159,6 +1159,8 @@ enum {
>   *       [TCA_TAPRIO_ATTR_SCHED_ENTRY_INTERVAL]
>   */
>  
> +#define TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST 0x1
> +
>  enum {
>  	TCA_TAPRIO_ATTR_UNSPEC,
>  	TCA_TAPRIO_ATTR_PRIOMAP, /* struct tc_mqprio_qopt */
> @@ -1170,6 +1172,8 @@ enum {
>  	TCA_TAPRIO_ATTR_ADMIN_SCHED, /* The admin sched, only used in dump */
>  	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME, /* s64 */
>  	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION, /* s64 */
> +	TCA_TAPRIO_ATTR_FLAGS, /* u32 */
> +	TCA_TAPRIO_ATTR_TXTIME_DELAY, /* s32 */
>  	__TCA_TAPRIO_ATTR_MAX,
>  };
>  
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index a41d7d4434ee..a5676fb2b2dd 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -21,12 +21,17 @@
>  #include <net/pkt_sched.h>
>  #include <net/pkt_cls.h>
>  #include <net/sch_generic.h>
> +#include <net/sock.h>
>  
>  static LIST_HEAD(taprio_list);
>  static DEFINE_SPINLOCK(taprio_list_lock);
>  
>  #define TAPRIO_ALL_GATES_OPEN -1
>  
> +#define FLAGS_VALID(flags) (!((flags) & ~TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST))
> +#define TXTIME_ASSIST_IS_ENABLED(flags) (FLAGS_VALID((flags)) && \
> +				 ((flags) & TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST))

Thanks for the changes, since you now validate no unknown flags are
passed, perhaps there is no need to check if flags are == ~0?

IS_ENABLED() could just do: (flags) & TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST
No?

> @@ -708,6 +978,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>  	struct taprio_sched *q = qdisc_priv(sch);
>  	struct net_device *dev = qdisc_dev(sch);
>  	struct tc_mqprio_qopt *mqprio = NULL;
> +	u32 taprio_flags = U32_MAX;

Then this should default to 0, i.e. no flag set..

>  	int i, err, clockid;
>  	unsigned long flags;
>  	ktime_t start;
> @@ -720,7 +991,21 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>  	if (tb[TCA_TAPRIO_ATTR_PRIOMAP])
>  		mqprio = nla_data(tb[TCA_TAPRIO_ATTR_PRIOMAP]);
>  
> -	err = taprio_parse_mqprio_opt(dev, mqprio, extack);
> +	if (tb[TCA_TAPRIO_ATTR_FLAGS]) {
> +		taprio_flags = nla_get_u32(tb[TCA_TAPRIO_ATTR_FLAGS]);
> +
> +		if (q->flags != 0) {
> +			NL_SET_ERR_MSG(extack, "Changing 'flags' of a running schedule is not supported");

So the parameter must not be passed at all?  Perhaps it's fine if:

	q->flags == taprio_flags

?

also: NL_SET_ERR_MSG_MOD() is better here

> +			return -ENOTSUPP;

Probably EINVAL or EOPNOTSUPP, ENOTSUPP is a high error code which libc
doesn't understand, it's best avoided.

> +		} else if (!FLAGS_VALID(taprio_flags)) {
> +			NL_SET_ERR_MSG(extack, "Specified 'flags' are not valid.");

nit: you didn't have a period at the end of the previous extack

> +			return -ENOTSUPP;
> +		}
> +
> +		q->flags = taprio_flags;
> +	}
> +
> +	err = taprio_parse_mqprio_opt(dev, mqprio, extack, taprio_flags);
>  	if (err < 0)
>  		return err;
>  
> @@ -779,7 +1064,11 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>  	/* Protects against enqueue()/dequeue() */
>  	spin_lock_bh(qdisc_lock(sch));
>  
> -	if (!hrtimer_active(&q->advance_timer)) {
> +	if (tb[TCA_TAPRIO_ATTR_TXTIME_DELAY])
> +		q->txtime_delay = nla_get_s32(tb[TCA_TAPRIO_ATTR_TXTIME_DELAY]);

Perhaps this attribute should only be allowed if flags enabled
txtime-assist?

> +	if (!TXTIME_ASSIST_IS_ENABLED(taprio_flags) &&
> +	    !hrtimer_active(&q->advance_timer)) {
>  		hrtimer_init(&q->advance_timer, q->clockid, HRTIMER_MODE_ABS);
>  		q->advance_timer.function = advance_sched;
>  	}
