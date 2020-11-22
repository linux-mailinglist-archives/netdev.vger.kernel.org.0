Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89CA22BFCE8
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 00:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgKVXIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 18:08:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgKVXI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 18:08:29 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B6B7C0613CF
        for <netdev@vger.kernel.org>; Sun, 22 Nov 2020 15:08:29 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id l5so15217603edq.11
        for <netdev@vger.kernel.org>; Sun, 22 Nov 2020 15:08:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Sh9NVgglnts3sSP0HVCYfj9O/NDR1+Zuh1U3Qlq6utg=;
        b=eo+rglxzGEAHa83QuK4Jhzjtt0W8RdkrzY2eIkYvEl76zRaCooJBeE4VICdZiM8uNW
         sRu/u3L9IUX+j/J7gpfPqJzI62SG8LAkKm5bf+kbig4T1pXD1HiR3Tj9a/jnqJg0sWkz
         KjQjFklc0uZZuDZYQ5aXL9o0YrKH6SA7cq96/KvB2CWKcoeERpl/4JFOX7ihci083FaE
         wCK20n2BLSBrq2ukA3G3QvvhRqn6w1pR5YWmBy4afkpdGAKHhv4sHXmzdYdGAZmf4HMH
         NaDaYmJN5L1sGmDD7gQE8LjtMHTni9tfnpU2Ca3mz+hMc6+5zGasYvq9+qQ+l6f2czvN
         YFzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Sh9NVgglnts3sSP0HVCYfj9O/NDR1+Zuh1U3Qlq6utg=;
        b=qmtFOKLcMWKB1bOAmDoaCd/PCXPcYFgbEYDYau3mJaSZxilGifJuZrWv3jeiAdZewg
         +rO23FWL16ZvzVHrDMwMQyBRi2hJKaDz6yNtWahqj/N3PZpuku3T2CRaLQARf+zTrsxY
         s8MNRXGXOt0CqYTX5AudTA0xNBVOlD+pV49sSEFYhATvbLrPYXhMb9vJyXGXc5ltw6VJ
         IPnxju9kngwZHCKtYNUTzkM1VsoqlJNYGlI2bM/jZtjbDZ/lLSKjDgt6I+V0A8GLmS9b
         eXVQioifpXbN5glYIOW6kn25nUYFmGSYSP5lLd7OQQ5GMMZ0OnG6Wmvcqo1x1Z0R/UqQ
         2nzg==
X-Gm-Message-State: AOAM533ij98rUXfttPBIxo4CdXwoZFgXxHWv4rhFxm/mppn9oDUmMo6A
        P1iT5n0VYYDUrFMYYWzxgJI=
X-Google-Smtp-Source: ABdhPJzNRZrgraB8xGXPnJMy3VLENsBLiaRIBNF3nULGBKT/MWzsQp7a0ZSNs7QPP7biI/7Phrknig==
X-Received: by 2002:a05:6402:10ce:: with SMTP id p14mr21299790edu.12.1606086507822;
        Sun, 22 Nov 2020 15:08:27 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id d1sm4040634edd.59.2020.11.22.15.08.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2020 15:08:27 -0800 (PST)
Date:   Mon, 23 Nov 2020 01:08:26 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/1] net: dsa: hellcreek: Add TAPRIO offloading
 support
Message-ID: <20201122230826.5l7yzdwcjzntpijm@skbuf>
References: <20201121115703.23221-1-kurt@linutronix.de>
 <20201121115703.23221-2-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201121115703.23221-2-kurt@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kurt,

On Sat, Nov 21, 2020 at 12:57:03PM +0100, Kurt Kanzenbach wrote:
> The switch has support for the 802.1Qbv Time Aware Shaper (TAS). Traffic
> schedules may be configured individually on each front port. Each port has eight
> egress queues. The traffic is mapped to a traffic class respectively via the PCP
> field of a VLAN tagged frame.
> 
> The TAPRIO Qdisc already implements that. Therefore, this interface can simply
> be reused. Add .port_setup_tc() accordingly.
> 
> The activation of a schedule on a port is split into two parts:
> 
>  * Programming the necessary gate control list (GCL)
>  * Setup delayed work for starting the schedule
> 
> The hardware supports starting a schedule up to eight seconds in the future. The
> TAPRIO interface provides an absolute base time. Therefore, periodic delayed
> work is leveraged to check whether a schedule may be started or not.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
>  drivers/net/dsa/hirschmann/hellcreek.c | 314 +++++++++++++++++++++++++
>  drivers/net/dsa/hirschmann/hellcreek.h |  22 ++
>  2 files changed, 336 insertions(+)
> 
> diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
> index 6420b76ea37c..35514af1922a 100644
> --- a/drivers/net/dsa/hirschmann/hellcreek.c
> +++ b/drivers/net/dsa/hirschmann/hellcreek.c
> @@ -23,6 +23,7 @@
>  #include <linux/mutex.h>
>  #include <linux/delay.h>
>  #include <net/dsa.h>
> +#include <net/pkt_sched.h>
>  
>  #include "hellcreek.h"
>  #include "hellcreek_ptp.h"
> @@ -153,6 +154,13 @@ static void hellcreek_select_vlan(struct hellcreek *hellcreek, int vid,
>  	hellcreek_write(hellcreek, val, HR_VIDCFG);
>  }
>  
> +static void hellcreek_select_tgd(struct hellcreek *hellcreek, int port)
> +{
> +	u16 val = port << TR_TGDSEL_TDGSEL_SHIFT;
> +
> +	hellcreek_write(hellcreek, val, TR_TGDSEL);
> +}
> +
>  static int hellcreek_wait_until_ready(struct hellcreek *hellcreek)
>  {
>  	u16 val;
> @@ -1135,6 +1143,308 @@ hellcreek_port_prechangeupper(struct dsa_switch *ds, int port,
>  	return ret;
>  }
>  
> +static void hellcreek_setup_gcl(struct hellcreek *hellcreek, int port,
> +				const struct hellcreek_schedule *schedule)
> +{
> +	size_t i;
> +
> +	for (i = 1; i <= schedule->num_entries; ++i) {
> +		const struct hellcreek_gcl_entry *cur, *initial, *next;
> +		u16 data;
> +		u8 gates;
> +
> +		cur = &schedule->entries[i - 1];
> +		initial = &schedule->entries[0];
> +		next = &schedule->entries[i];
> +

I would find it more intuitive to have the invariant assignment out of
the loop.

	const struct hellcreek_gcl_entry *cur, *initial, *next;

	cur = initial = &schedule->entries[0];
	next = cur + 1;

	for (i = 0; i < schedule->num_entries; i++) {
		u16 data;
		u8 gates;

		[...]

		cur++;
		next++;
	}

> +		if (i == schedule->num_entries)
> +			gates = initial->gate_states ^
> +				cur->gate_states;
> +		else
> +			gates = next->gate_states ^
> +				cur->gate_states;
> +
> +		data = gates;
> +		if (cur->overrun_ignore)
> +			data |= TR_GCLDAT_GCLOVRI;
> +
> +		if (i == schedule->num_entries)
> +			data |= TR_GCLDAT_GCLWRLAST;
> +
> +		/* Gates states */
> +		hellcreek_write(hellcreek, data, TR_GCLDAT);
> +
> +		/* Time intervall */

interval

> +		hellcreek_write(hellcreek,
> +				cur->interval & 0x0000ffff,
> +				TR_GCLTIL);
> +		hellcreek_write(hellcreek,
> +				(cur->interval & 0xffff0000) >> 16,
> +				TR_GCLTIH);
> +
> +		/* Commit entry */
> +		data = ((i - 1) << TR_GCLCMD_GCLWRADR_SHIFT) |
> +			(initial->gate_states <<
> +			 TR_GCLCMD_INIT_GATE_STATES_SHIFT);
> +		hellcreek_write(hellcreek, data, TR_GCLCMD);

So the command register holds the initial gate states. When the command
register is written, it samples the data register, populating GCL entry
number GCLWRADR with that information. Every GCL entry contains the
duration until it is executed, and the gates that need to change when
the schedule transitions towards the next GCL entry. Right?

Why are the initial gate states written each time into the command
register? Is it required by the hardware, or just easier in the
implementation?

> +	}
> +}
> +
> +static void hellcreek_set_cycle_time(struct hellcreek *hellcreek,
> +				     const struct hellcreek_schedule *schedule)
> +{
> +	u32 cycle_time = schedule->cycle_time;
> +
> +	hellcreek_write(hellcreek, cycle_time & 0x0000ffff, TR_CTWRL);
> +	hellcreek_write(hellcreek, (cycle_time & 0xffff0000) >> 16, TR_CTWRH);

The cycle_time in struct tc_taprio_qopt_offload is 64-bit, so you should
NACK a value that is too large and return an appropriate extack message.

> +}
> +
> +static void hellcreek_switch_schedule(struct hellcreek *hellcreek,
> +				      ktime_t start_time)
> +{
> +	struct timespec64 ts = ktime_to_timespec64(start_time);
> +
> +	/* Start can be up to eight seconds in the future */
> +	ts.tv_sec %= 8;

What happens if base_time is specified as zero, or a small number that
only encodes a phase?

I would expect that the base time is advanced by an integer number of
cycles until it becomes in the immediate future, so that it can be
applied.

I don't think that's what happens right now.
If the start_time is 0.000000000, the cycle_time is 0.333333333, and now
is 8.125000000.

I believe that what would happen is:
- hellcreek_schedule_startable() says "yes, it's startable right away",
  because base_time_ns - current_ns) is negative, and therefore also
  smaller than 8 * NSEC_PER_SEC.
- hellcreek_switch_schedule() gets called with the 0.000000000 time, and
  this start_time gets programmed right away into hardware.

What does the hardware do if it's given a schedule that begins at 0.000000000
when the current time is at 8.125000000?

I would expect that somebody (hardware or driver) advances the time
0.000000000 into the first time that is larger than 8.125000000, while
still remaining congruent to the original time in terms of phase offset.

I.e. advance the base time by 25 cycle times, to get
0.000000000 + 25 x 0.333333333 = 8.333333325 ns.

Then I would expect the schedule to start at 8.333333325 nanoseconds,
which is the first value immediately larger than "now" (8.125000000).

When you give the hardware the base_time of 0.000000000, is this what
happens? Is it equivalent to giving it 0.333333325?

> +
> +	/* Start schedule at this point of time */
> +	hellcreek_write(hellcreek, ts.tv_nsec & 0x0000ffff, TR_ESTWRL);
> +	hellcreek_write(hellcreek, (ts.tv_nsec & 0xffff0000) >> 16, TR_ESTWRH);
> +
> +	/* Arm timer, set seconds and switch schedule */
> +	hellcreek_write(hellcreek, TR_ESTCMD_ESTARM | TR_ESTCMD_ESTSWCFG |
> +			((ts.tv_sec & TR_ESTCMD_ESTSEC_MASK) <<
> +			 TR_ESTCMD_ESTSEC_SHIFT), TR_ESTCMD);
> +}
> +
> +static struct hellcreek_schedule *
> +hellcreek_taprio_to_schedule(struct tc_taprio_qopt_offload *taprio)
> +{
> +	struct hellcreek_schedule *schedule;
> +	size_t i;
> +
> +	/* Allocate some memory first */
> +	schedule = kzalloc(sizeof(*schedule), GFP_KERNEL);

struct hellcreek_schedule has no added value on top of struct
tc_taprio_qopt_offload (except for _maybe_ that overrun_ignore, which
currently you don't use and could therefore remove - arguably the
overrun_ignore flag should be user-visible if it ever was to be
configured, and therefore my argument still stands).

The reason why I'm making the point, though, is that you don't need to
allocate extra memory if you use the plain struct tc_taprio_qopt_offload.
You can use taprio_offload_get() to increase the reference count on the
structure that was passed to you, use it for as long as you need, and
just call taprio_offload_free() when you're done with it.

> +	if (!schedule)
> +		return ERR_PTR(-ENOMEM);
> +	schedule->entries = kcalloc(taprio->num_entries,
> +				    sizeof(*schedule->entries),
> +				    GFP_KERNEL);
> +	if (!schedule->entries) {
> +		kfree(schedule);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	/* Construct hellcreek schedule */
> +	schedule->num_entries = taprio->num_entries;
> +	schedule->base_time   = taprio->base_time;
> +
> +	for (i = 0; i < taprio->num_entries; ++i) {
> +		const struct tc_taprio_sched_entry *t = &taprio->entries[i];
> +		struct hellcreek_gcl_entry *k = &schedule->entries[i];
> +
> +		k->interval	  = t->interval;
> +		k->gate_states	  = t->gate_mask;
> +		k->overrun_ignore = 0;
> +
> +		/* Update complete cycle time */
> +		schedule->cycle_time += t->interval;

You shouldn't need to do this, the cycle_time from struct
tc_taprio_qopt_offload should come properly populated. If it doesn't
it's a bug.

> +	}
> +
> +	return schedule;
> +}
> +
> +static void hellcreek_free_schedule(struct hellcreek *hellcreek, int port)
> +{
> +	struct hellcreek_port *hellcreek_port = &hellcreek->ports[port];
> +
> +	kfree(hellcreek_port->current_schedule->entries);
> +	kfree(hellcreek_port->current_schedule);
> +	hellcreek_port->current_schedule = NULL;
> +}
> +
> +static bool hellcreek_schedule_startable(struct hellcreek *hellcreek, int port)
> +{
> +	struct hellcreek_port *hellcreek_port = &hellcreek->ports[port];
> +	s64 base_time_ns, current_ns;
> +
> +	/* The switch allows a schedule to be started only eight seconds within
> +	 * the future. Therefore, check the current PTP time if the schedule is
> +	 * startable or not.
> +	 */

The future of whom? I expect that TR_ESTWR is relative to the most
recent integer multiple of 8 seconds, and not relative to "now".
Otherwise you would never be able to phase-align taprio schedules with
other devices in the LAN.

Doesn't this mean that you need to be extra careful at modulo-8-seconds
wraparounds of the current PTP time?

> +
> +	/* Use the "cached" time. That should be alright, as it's updated quite
> +	 * frequently in the PTP code.
> +	 */
> +	mutex_lock(&hellcreek->ptp_lock);
> +	current_ns = hellcreek->seconds * NSEC_PER_SEC + hellcreek->last_ts;
> +	mutex_unlock(&hellcreek->ptp_lock);
> +
> +	/* Calculate difference to admin base time */
> +	base_time_ns = ktime_to_ns(hellcreek_port->current_schedule->base_time);
> +
> +	if (base_time_ns - current_ns < (s64)8 * NSEC_PER_SEC)
> +		return true;
> +
> +	return false;
> +}
> +
> +static void hellcreek_start_schedule(struct hellcreek *hellcreek, int port)
> +{
> +	struct hellcreek_port *hellcreek_port = &hellcreek->ports[port];
> +
> +	/* First select port */
> +	hellcreek_select_tgd(hellcreek, port);
> +
> +	/* Set admin base time and switch schedule */
> +	hellcreek_switch_schedule(hellcreek,
> +				  hellcreek_port->current_schedule->base_time);
> +
> +	hellcreek_free_schedule(hellcreek, port);
> +
> +	dev_dbg(hellcreek->dev, "ARMed EST timer for port %d\n",

Is ARM used as an acronym for something here? Why not Armed?

> +		hellcreek_port->port);
> +}
> +
> +static void hellcreek_check_schedule(struct work_struct *work)
> +{
> +	struct delayed_work *dw = to_delayed_work(work);
> +	struct hellcreek_port *hellcreek_port;
> +	struct hellcreek *hellcreek;
> +	bool startable;
> +
> +	hellcreek_port = dw_to_hellcreek_port(dw);
> +	hellcreek = hellcreek_port->hellcreek;
> +
> +	mutex_lock(&hellcreek->reg_lock);
> +
> +	/* Check starting time */
> +	startable = hellcreek_schedule_startable(hellcreek,
> +						 hellcreek_port->port);
> +	if (startable) {
> +		hellcreek_start_schedule(hellcreek, hellcreek_port->port);
> +		mutex_unlock(&hellcreek->reg_lock);
> +		return;
> +	}
> +
> +	mutex_unlock(&hellcreek->reg_lock);
> +
> +	/* Reschedule */
> +	schedule_delayed_work(&hellcreek_port->schedule_work,
> +			      HELLCREEK_SCHEDULE_PERIOD);
> +}
> +
> +static int hellcreek_port_set_schedule(struct dsa_switch *ds, int port,
> +				       struct tc_taprio_qopt_offload *taprio)
> +{
> +	struct hellcreek *hellcreek = ds->priv;
> +	struct hellcreek_port *hellcreek_port;
> +	struct hellcreek_schedule *schedule;
> +	bool startable;
> +	u16 ctrl;
> +
> +	hellcreek_port = &hellcreek->ports[port];
> +
> +	/* Convert taprio data to hellcreek schedule */
> +	schedule = hellcreek_taprio_to_schedule(taprio);
> +	if (IS_ERR(schedule))
> +		return PTR_ERR(schedule);
> +
> +	dev_dbg(hellcreek->dev, "Configure traffic schedule on port %d\n",
> +		port);
> +
> +	/* First cancel delayed work */
> +	cancel_delayed_work_sync(&hellcreek_port->schedule_work);
> +
> +	mutex_lock(&hellcreek->reg_lock);
> +
> +	if (hellcreek_port->current_schedule)
> +		hellcreek_free_schedule(hellcreek, port);
> +	hellcreek_port->current_schedule = schedule;
> +
> +	/* Then select port */
> +	hellcreek_select_tgd(hellcreek, port);
> +
> +	/* Enable gating and set the admin state to forward everything in the
> +	 * mean time
> +	 */
> +	ctrl = (0xff << TR_TGDCTRL_ADMINGATESTATES_SHIFT) | TR_TGDCTRL_GATE_EN;
> +	hellcreek_write(hellcreek, ctrl, TR_TGDCTRL);

Hmm, "in the meantime"? When do these admin gate states become effective?
If possible, I expect that the currently operational schedule remains
operational exactly until the base_time of the newly installed one,
minus a possible cycle_time_extension.

> +
> +	/* Cancel pending schedule */
> +	hellcreek_write(hellcreek, 0x00, TR_ESTCMD);
> +
> +	/* Setup a new schedule */
> +	hellcreek_setup_gcl(hellcreek, port, schedule);
> +
> +	/* Configure cycle time */
> +	hellcreek_set_cycle_time(hellcreek, schedule);

As a general comment, if the hardware doesn't support the cycle time
extension when switching schedules, then you should NACK a non-zero
passed argument there.

> +
> +	/* Check starting time */
> +	startable = hellcreek_schedule_startable(hellcreek, port);
> +	if (startable) {
> +		hellcreek_start_schedule(hellcreek, port);
> +		mutex_unlock(&hellcreek->reg_lock);
> +		return 0;
> +	}
> +
> +	mutex_unlock(&hellcreek->reg_lock);
> +
> +	/* Schedule periodic schedule check */
> +	schedule_delayed_work(&hellcreek_port->schedule_work,
> +			      HELLCREEK_SCHEDULE_PERIOD);
> +
> +	return 0;
> +}
> +
> +static int hellcreek_port_del_schedule(struct dsa_switch *ds, int port)
> +{
> +	struct hellcreek *hellcreek = ds->priv;
> +	struct hellcreek_port *hellcreek_port;
> +
> +	hellcreek_port = &hellcreek->ports[port];
> +
> +	dev_dbg(hellcreek->dev, "Remove traffic schedule on port %d\n", port);
> +
> +	/* First cancel delayed work */
> +	cancel_delayed_work_sync(&hellcreek_port->schedule_work);
> +
> +	mutex_lock(&hellcreek->reg_lock);
> +
> +	if (hellcreek_port->current_schedule)
> +		hellcreek_free_schedule(hellcreek, port);
> +
> +	/* Then select port */
> +	hellcreek_select_tgd(hellcreek, port);
> +
> +	/* Disable gating and return to regular switching flow */
> +	hellcreek_write(hellcreek, 0xff << TR_TGDCTRL_ADMINGATESTATES_SHIFT,
> +			TR_TGDCTRL);
> +
> +	mutex_unlock(&hellcreek->reg_lock);
> +
> +	return 0;
> +}
> +
> +static int hellcreek_port_setup_tc(struct dsa_switch *ds, int port,
> +				   enum tc_setup_type type, void *type_data)
> +{
> +	struct tc_taprio_qopt_offload *taprio = type_data;
> +	struct hellcreek *hellcreek = ds->priv;
> +
> +	if (type != TC_SETUP_QDISC_TAPRIO)
> +		return -EOPNOTSUPP;
> +
> +	/* Does this hellcreek version support Qbv in hardware? */
> +	if (!hellcreek->pdata->qbv_support)
> +		return -EOPNOTSUPP;
> +
> +	if (taprio->enable)
> +		return hellcreek_port_set_schedule(ds, port, taprio);
> +
> +	return hellcreek_port_del_schedule(ds, port);
> +}
> +
>  static const struct dsa_switch_ops hellcreek_ds_ops = {
>  	.get_ethtool_stats   = hellcreek_get_ethtool_stats,
>  	.get_sset_count	     = hellcreek_get_sset_count,
> @@ -1153,6 +1463,7 @@ static const struct dsa_switch_ops hellcreek_ds_ops = {
>  	.port_hwtstamp_get   = hellcreek_port_hwtstamp_get,
>  	.port_prechangeupper = hellcreek_port_prechangeupper,
>  	.port_rxtstamp	     = hellcreek_port_rxtstamp,
> +	.port_setup_tc	     = hellcreek_port_setup_tc,
>  	.port_stp_state_set  = hellcreek_port_stp_state_set,
>  	.port_txtstamp	     = hellcreek_port_txtstamp,
>  	.port_vlan_add	     = hellcreek_vlan_add,
> @@ -1208,6 +1519,9 @@ static int hellcreek_probe(struct platform_device *pdev)
>  
>  		port->hellcreek	= hellcreek;
>  		port->port	= i;
> +
> +		INIT_DELAYED_WORK(&port->schedule_work,
> +				  hellcreek_check_schedule);
>  	}
>  
>  	mutex_init(&hellcreek->reg_lock);
> diff --git a/drivers/net/dsa/hirschmann/hellcreek.h b/drivers/net/dsa/hirschmann/hellcreek.h
> index e81781ebc31c..7ffb1b33ff72 100644
> --- a/drivers/net/dsa/hirschmann/hellcreek.h
> +++ b/drivers/net/dsa/hirschmann/hellcreek.h
> @@ -213,6 +213,20 @@ struct hellcreek_counter {
>  	const char *name;
>  };
>  
> +struct hellcreek_gcl_entry {
> +	u32 interval;
> +	u8 gate_states;
> +	bool overrun_ignore;
> +};
> +
> +struct hellcreek_schedule {
> +	struct hellcreek_gcl_entry *entries;
> +	size_t num_entries;
> +	ktime_t base_time;
> +	u32 cycle_time;
> +	int port;

You don't need/use the "port" member.

> +};
> +
>  struct hellcreek;
>  
>  /* State flags for hellcreek_port_hwtstamp::state */
> @@ -246,6 +260,10 @@ struct hellcreek_port {
>  
>  	/* Per-port timestamping resources */
>  	struct hellcreek_port_hwtstamp port_hwtstamp;
> +
> +	/* Per-port Qbv schedule information */
> +	struct hellcreek_schedule *current_schedule;
> +	struct delayed_work schedule_work;
>  };
>  
>  struct hellcreek_fdb_entry {
> @@ -283,4 +301,8 @@ struct hellcreek {
>  	size_t fdb_entries;
>  };
>  
> +#define HELLCREEK_SCHEDULE_PERIOD	(2 * HZ)

Is there a risk if you schedule rarer than this? The hellcreek->seconds
value is no longer accurate enough?

> +#define dw_to_hellcreek_port(dw)				\
> +	container_of(dw, struct hellcreek_port, schedule_work)
> +
>  #endif /* _HELLCREEK_H_ */
> -- 
> 2.20.1
> 
