Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74718250BF1
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 00:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbgHXW4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 18:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbgHXW4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 18:56:20 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B92C061574;
        Mon, 24 Aug 2020 15:56:20 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id l63so6505521edl.9;
        Mon, 24 Aug 2020 15:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XZ2DOgpP9mD3XLt5jCH5/95E1sljieId7f2qRFNNZkM=;
        b=W/CIgk6L0TFpguaQ97RmBT3AFBFiYI0LI40cGF85wCwoCxgHUN5c+jttOZYsybccXV
         elBilFADc1+k/6/8IveYhx0scNF6IPXlvvZTou5EXucocUmAhoLTmYySwEW3I6+sMSJv
         +i3QLbmgtjbUNC/SVNKB1DrmKiIOd1c6BucTD599HzEIiOoCwavBv2rm0TBsJmvxVKl+
         gUBiK58MWoJUTvT6h2seTxbwezc0A9nRJKfwx3pp4IFxTCJwLsgcJdNanTlq9H3hEZpP
         s/M+Lb8JD0848RpDr3cQ1Ogtjys8pzZtrhTDNrylenmtJehjr7lhakPIauVx2ylo79wb
         4R1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XZ2DOgpP9mD3XLt5jCH5/95E1sljieId7f2qRFNNZkM=;
        b=tqLJdCt9jxePfki8TJQzSTkRTc2YS4/modWGjPHO+T/j/AzudMKsKbJVqx/fNduV7/
         vva2/HV31rW1Q3CT22GysKdxePiJkAodUIPgqVdV7rTBPG79sa9F5S4rLx8qN63T84Vp
         kQpaEgIL4xS7WkVW6Jzrl9XxmJ3ftNzku5GPaIg0bT3BJZfbansa60cbVveUKJoF7B+T
         ghIWNRkazYbuZzpd7CMyhHOZE2THTgojq20nv4Fy+3mem3u7pG3gp63dw/VxXPqj+liU
         kS1spym0EMCSRRU0CwDvmKzQzaEm2dZlfGTULtO8s+ovrjjLa6OfSBzueA1XCRG+67mE
         2O9Q==
X-Gm-Message-State: AOAM530iOFBI7EW4+ygt/dENrgPteoifkj/TgqGadSjJYzUOBHDG9/6j
        3uZeifAY+wtYi+1CzAbUTdQ=
X-Google-Smtp-Source: ABdhPJy2CfDOn4xZnSLCHXqf0MHg9zsdOkYC6dcHrR/ZIZcXKoX+MU70MyvHSof/g710w9XyO8g3zA==
X-Received: by 2002:aa7:ce90:: with SMTP id y16mr7765364edv.325.1598309778504;
        Mon, 24 Aug 2020 15:56:18 -0700 (PDT)
Received: from skbuf ([86.126.22.216])
        by smtp.gmail.com with ESMTPSA id p13sm10926098edq.81.2020.08.24.15.56.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2020 15:56:18 -0700 (PDT)
Date:   Tue, 25 Aug 2020 01:56:15 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v3 5/8] net: dsa: hellcreek: Add TAPRIO offloading support
Message-ID: <20200824225615.jtikfwyrxa7vxiq2@skbuf>
References: <20200820081118.10105-1-kurt@linutronix.de>
 <20200820081118.10105-6-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820081118.10105-6-kurt@linutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 10:11:15AM +0200, Kurt Kanzenbach wrote:
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
>  * Setup hrtimer for starting the schedule
> 
> The hardware supports starting a schedule up to eight seconds in the future. The
> TAPRIO interface provides an absolute base time. Therefore, hrtimers are
> leveraged.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
>  drivers/net/dsa/hirschmann/hellcreek.c | 294 +++++++++++++++++++++++++
>  drivers/net/dsa/hirschmann/hellcreek.h |  21 ++
>  2 files changed, 315 insertions(+)
> 
> diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
> index 745ca60342b4..e5b54f42c635 100644
> --- a/drivers/net/dsa/hirschmann/hellcreek.c
> +++ b/drivers/net/dsa/hirschmann/hellcreek.c
> @@ -22,7 +22,9 @@
>  #include <linux/spinlock.h>
>  #include <linux/delay.h>
>  #include <linux/ktime.h>
> +#include <linux/time.h>
>  #include <net/dsa.h>
> +#include <net/pkt_sched.h>
>  
>  #include "hellcreek.h"
>  #include "hellcreek_ptp.h"
> @@ -153,6 +155,15 @@ static void hellcreek_select_vlan(struct hellcreek *hellcreek, int vid,
>  	hellcreek_write(hellcreek, val, HR_VIDCFG);
>  }
>  
> +static void hellcreek_select_tgd(struct hellcreek *hellcreek, int port)
> +{
> +	u16 val = 0;
> +
> +	val |= port << TR_TGDSEL_TDGSEL_SHIFT;
> +
> +	hellcreek_write(hellcreek, val, TR_TGDSEL);
> +}
> +
>  static int hellcreek_wait_until_ready(struct hellcreek *hellcreek)
>  {
>  	u16 val;
> @@ -958,6 +969,24 @@ static void __hellcreek_setup_tc_identity_mapping(struct hellcreek *hellcreek)
>  	}
>  }
>  
> +static void hellcreek_setup_tc_mapping(struct hellcreek *hellcreek,
> +				       struct net_device *netdev)
> +{
> +	int i, j;
> +
> +	/* Setup mapping between traffic classes and port queues. */
> +	for (i = 0; i < netdev_get_num_tc(netdev); ++i) {
> +		for (j = 0; j < netdev->tc_to_txq[i].count; ++j) {
> +			const int queue = j + netdev->tc_to_txq[i].offset;
> +
> +			hellcreek_select_prio(hellcreek, i);
> +			hellcreek_write(hellcreek,
> +					queue << HR_PRTCCFG_PCP_TC_MAP_SHIFT,
> +					HR_PRTCCFG);
> +		}
> +	}
> +}
> +
>  static void hellcreek_setup_tc_identity_mapping(struct hellcreek *hellcreek)
>  {
>  	unsigned long flags;
> @@ -1081,6 +1110,267 @@ static void hellcreek_phylink_validate(struct dsa_switch *ds, int port,
>  		   __ETHTOOL_LINK_MODE_MASK_NBITS);
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
> +		cur	= &schedule->entries[i - 1];
> +		initial = &schedule->entries[0];
> +		next	= &schedule->entries[i];
> +
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
> +}
> +
> +static void hellcreek_start_schedule(struct hellcreek *hellcreek,
> +				     ktime_t start_time)
> +{
> +	struct timespec64 ts = ktime_to_timespec64(start_time);
> +
> +	/* Start can be only 8 seconds in the future */
> +	ts.tv_sec %= 8;
> +
> +	/* Start schedule at this point of time */
> +	hellcreek_write(hellcreek, ts.tv_nsec & 0x0000ffff, TR_ESTWRL);
> +	hellcreek_write(hellcreek, (ts.tv_nsec & 0xffff0000) >> 16, TR_ESTWRH);
> +
> +	/* Arm timer, set seconds and switch schedule */
> +	hellcreek_write(hellcreek, TR_ESTCMD_ESTARM | TR_ESTCMD_ESTSWCFG |
> +		     ((ts.tv_sec & TR_ESTCMD_ESTSEC_MASK) <<
> +		      TR_ESTCMD_ESTSEC_SHIFT), TR_ESTCMD);
> +}
> +
> +static struct hellcreek_schedule *hellcreek_taprio_to_schedule(
> +	const struct tc_taprio_qopt_offload *taprio)

Personal indentation preference:

static struct hellcreek_schedule
*hellcreek_taprio_to_schedule(const struct tc_taprio_qopt_offload *taprio)

> +{
> +	struct hellcreek_schedule *schedule;
> +	size_t i;
> +
> +	/* Allocate some memory first */
> +	schedule = kzalloc(sizeof(*schedule), GFP_KERNEL);
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

Tab to align with gate_states and interval?
What does overrun_ignore do, anyway?

> +
> +		/* Update complete cycle time */
> +		schedule->cycle_time += t->interval;
> +	}
> +
> +	return schedule;
> +}
> +
> +static enum hrtimer_restart hellcreek_set_schedule(struct hrtimer *timer)
> +{
> +	struct hellcreek_port *hellcreek_port =
> +		hrtimer_to_hellcreek_port(timer);

That moment when not even the helper macro fits in 80 characters..
I think you should let this line have 81 characters.

> +	struct hellcreek *hellcreek = hellcreek_port->hellcreek;
> +	struct hellcreek_schedule *schedule;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&hellcreek->reg_lock, flags);
> +
> +	/* First select port */
> +	hellcreek_select_tgd(hellcreek, hellcreek_port->port);
> +
> +	/* Set admin base time and switch schedule */
> +	hellcreek_start_schedule(hellcreek,
> +				 hellcreek_port->current_schedule->base_time);
> +
> +	schedule = hellcreek_port->current_schedule;
> +	hellcreek_port->current_schedule = NULL;
> +
> +	spin_unlock_irqrestore(&hellcreek->reg_lock, flags);
> +
> +	dev_dbg(hellcreek->dev, "ARMed EST timer for port %d\n",
> +		hellcreek_port->port);
> +
> +	/* Free resources */
> +	kfree(schedule->entries);
> +	kfree(schedule);
> +
> +	return HRTIMER_NORESTART;
> +}
> +
> +static int hellcreek_port_set_schedule(struct dsa_switch *ds, int port,
> +				       const struct tc_taprio_qopt_offload *taprio)
> +{
> +	struct net_device *netdev = dsa_to_port(ds, port)->slave;
> +	struct hellcreek *hellcreek = ds->priv;
> +	struct hellcreek_port *hellcreek_port;
> +	struct hellcreek_schedule *schedule;
> +	unsigned long flags;
> +	ktime_t start;
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
> +	/* Cancel an in flight timer */
> +	hrtimer_cancel(&hellcreek_port->cycle_start_timer);
> +
> +	spin_lock_irqsave(&hellcreek->reg_lock, flags);
> +
> +	if (hellcreek_port->current_schedule) {
> +		kfree(hellcreek_port->current_schedule->entries);
> +		kfree(hellcreek_port->current_schedule);
> +	}
> +
> +	hellcreek_port->current_schedule = schedule;
> +
> +	/* First select port */
> +	hellcreek_select_tgd(hellcreek, port);
> +
> +	/* Setup traffic class <-> queue mapping */
> +	hellcreek_setup_tc_mapping(hellcreek, netdev);
> +
> +	/* Enable gating and set the admin state to forward everything in the
> +	 * mean time
> +	 */
> +	ctrl = (0xff << TR_TGDCTRL_ADMINGATESTATES_SHIFT) | TR_TGDCTRL_GATE_EN;
> +	hellcreek_write(hellcreek, ctrl, TR_TGDCTRL);
> +
> +	/* Cancel pending schedule */
> +	hellcreek_write(hellcreek, 0x00, TR_ESTCMD);
> +
> +	/* Setup a new schedule */
> +	hellcreek_setup_gcl(hellcreek, port, schedule);
> +
> +	/* Configure cycle time */
> +	hellcreek_set_cycle_time(hellcreek, schedule);
> +
> +	/* Setup timer for schedule switch: The IP core only allows to set a
> +	 * cycle start timer 8 seconds in the future. This is why we setup the
> +	 * hritmer to base_time - 5 seconds. Then, we have enough time to
> +	 * activate IP core's EST timer.
> +	 */
> +	start = ktime_sub_ns(schedule->base_time, (u64)5 * NSEC_PER_SEC);
> +	hrtimer_start_range_ns(&hellcreek_port->cycle_start_timer, start,
> +			       NSEC_PER_SEC, HRTIMER_MODE_ABS);

Explain again how this works, please? The hrtimer measures the CLOCK_TAI
of the CPU, but you are offloading the CLOCK_TAI domain of the NIC? So
you are assuming that the CPU and the NIC PHC are synchronized? What if
they aren't?

And what if the base-time is in the past, do you deal with that (how
does the hardware deal with a base-time in the past)?
A base-time in the past (example: 0) should work: you should advance the
base-time into the nearest future multiple of the cycle-time, to at
least preserve phase correctness of the schedule.

Just trying to understand if this whole hrtimer thing is worth it. It
complicates the driver by quite a significant amount.

> +
> +	spin_unlock_irqrestore(&hellcreek->reg_lock, flags);
> +
> +	return 0;
> +}
> +
> +static int hellcreek_port_del_schedule(struct dsa_switch *ds, int port)
> +{
> +	struct hellcreek *hellcreek = ds->priv;
> +	struct hellcreek_port *hellcreek_port;
> +	unsigned long flags;
> +
> +	hellcreek_port = &hellcreek->ports[port];
> +
> +	dev_dbg(hellcreek->dev, "Remove traffic schedule on port %d\n", port);
> +
> +	/* First cancel timer */
> +	hrtimer_cancel(&hellcreek_port->cycle_start_timer);
> +
> +	spin_lock_irqsave(&hellcreek->reg_lock, flags);
> +
> +	if (hellcreek_port->current_schedule) {
> +		kfree(hellcreek_port->current_schedule->entries);
> +		kfree(hellcreek_port->current_schedule);
> +		hellcreek_port->current_schedule = NULL;
> +	}
> +
> +	/* Then select port */
> +	hellcreek_select_tgd(hellcreek, port);
> +
> +	/* Revert tc mapping */
> +	__hellcreek_setup_tc_identity_mapping(hellcreek);
> +
> +	/* Disable gating and return to regular switching flow */
> +	hellcreek_write(hellcreek, 0xff << TR_TGDCTRL_ADMINGATESTATES_SHIFT,
> +			TR_TGDCTRL);
> +
> +	spin_unlock_irqrestore(&hellcreek->reg_lock, flags);
> +
> +	return 0;
> +}
> +
> +static int hellcreek_port_setup_tc(struct dsa_switch *ds, int port,
> +				   enum tc_setup_type type, void *type_data)
> +{
> +	const struct tc_taprio_qopt_offload *taprio = type_data;
> +
> +	if (type != TC_SETUP_QDISC_TAPRIO)
> +		return -EOPNOTSUPP;
> +
> +	if (taprio->enable)
> +		return hellcreek_port_set_schedule(ds, port, taprio);
> +
> +	return hellcreek_port_del_schedule(ds, port);
> +}
> +
>  static const struct dsa_switch_ops hellcreek_ds_ops = {
>  	.get_tag_protocol    = hellcreek_get_tag_protocol,
>  	.setup		     = hellcreek_setup,
> @@ -1104,6 +1394,7 @@ static const struct dsa_switch_ops hellcreek_ds_ops = {
>  	.port_hwtstamp_get   = hellcreek_port_hwtstamp_get,
>  	.port_txtstamp	     = hellcreek_port_txtstamp,
>  	.port_rxtstamp	     = hellcreek_port_rxtstamp,
> +	.port_setup_tc	     = hellcreek_port_setup_tc,
>  	.get_ts_info	     = hellcreek_get_ts_info,
>  };
>  
> @@ -1135,6 +1426,9 @@ static int hellcreek_probe(struct platform_device *pdev)
>  		if (!port->counter_values)
>  			return -ENOMEM;
>  
> +		hrtimer_init(&port->cycle_start_timer, CLOCK_TAI,
> +			     HRTIMER_MODE_ABS);
> +		port->cycle_start_timer.function = hellcreek_set_schedule;
>  		port->hellcreek = hellcreek;
>  		port->port	= i;
>  	}
> diff --git a/drivers/net/dsa/hirschmann/hellcreek.h b/drivers/net/dsa/hirschmann/hellcreek.h
> index 1d3de72a48a5..d3d1a1144857 100644
> --- a/drivers/net/dsa/hirschmann/hellcreek.h
> +++ b/drivers/net/dsa/hirschmann/hellcreek.h
> @@ -16,6 +16,7 @@
>  #include <linux/ptp_clock_kernel.h>
>  #include <linux/timecounter.h>
>  #include <linux/spinlock.h>
> +#include <linux/hrtimer.h>
>  #include <net/dsa.h>
>  
>  /* Ports:
> @@ -210,6 +211,20 @@ struct hellcreek_counter {
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
> +};
> +
>  struct hellcreek;
>  
>  /* State flags for hellcreek_port_hwtstamp::state */
> @@ -236,6 +251,8 @@ struct hellcreek_port_hwtstamp {
>  
>  struct hellcreek_port {
>  	struct hellcreek *hellcreek;
> +	struct hellcreek_schedule *current_schedule;
> +	struct hrtimer cycle_start_timer;
>  	int port;
>  	u16 ptcfg;		/* ptcfg shadow */
>  	u64 *counter_values;
> @@ -273,4 +290,8 @@ struct hellcreek {
>  	size_t fdb_entries;
>  };
>  
> +#define hrtimer_to_hellcreek_port(timer)		\
> +	container_of(timer, struct hellcreek_port,	\
> +		     cycle_start_timer)
> +
>  #endif /* _HELLCREEK_H_ */
> -- 
> 2.20.1
> 

Thanks,
-Vladimir
