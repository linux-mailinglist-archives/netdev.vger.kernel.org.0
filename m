Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19FDF24E7F1
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 16:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbgHVOjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 10:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727948AbgHVOj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 10:39:28 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 812E5C061573;
        Sat, 22 Aug 2020 07:39:27 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id si26so5895426ejb.12;
        Sat, 22 Aug 2020 07:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RsJOdUB12H+imGQDMH3EwnL7YeNn3WG53HuHaBdE1w4=;
        b=sp8VEBZes0w1WFvOzFrvNXlDIvyKvRLB9PFNxAbVvMJcsRJUQEH69pbtsZCb3kW7DM
         1nY1l+esZJiuYDJCCbqgxlv2+07tnFWQM1kSdqjEl7W6GLNEbUrbSx8KMVAfy+SQDZWd
         Pw9WkygEd58QHhXeN6kFFwmuP15omj2wz5OADX10j2KTq5PscgtebObrHcuULGwPY60g
         EL3xynTuamnm0Gi7KOBPvMU+cAkdz6eZg3qEFfZv6RQeHv08WuT5Geo0D2K+t+KfteBr
         nG+3Kj5D79fLj4f4PG8oORLGPkVw9wTel9qDT5kudmCBB3k6zgI3cFEKGFoLerp6LvY8
         DjDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RsJOdUB12H+imGQDMH3EwnL7YeNn3WG53HuHaBdE1w4=;
        b=gT02kAvLqENu6ObQrmltwa4/BL2pphsDLUoFWdVSWUOLVDcRQpxKyiQYCr4XOJPJvp
         5U1Dms+ouHW3ZgwP2Vxu57U2hYmKEeK7pj2IUw1TkwQq/jAAje4ndUHE0DRXW15t5r+t
         KOLCYin1NnAoY4gz8cuKyOgaWqd0KDdEfusyLi/peVAabow/0gj4RyH6skvsiLMf+lDM
         yyVwnzESXcyUvApcyU+4vBrz/DRctCY76s79E/jQlKHxEAbgP5N+Lh96Y3H0/StabExG
         j3pWijqcsAaVcIS+1E4UPmdMjbJIxQIf2KO19Z/RQin8uT/tDrjcGVbgGK6U2tMhvwWh
         CYrg==
X-Gm-Message-State: AOAM533gZT5TP5+GuMZ316Owl0f+OLs+WrE/gXKxKgUDleI4g+OD0/qs
        YIYsU8vDvhhRmPtFhFjUC8/4k3sb30I=
X-Google-Smtp-Source: ABdhPJw7jRYNJ+Mhj0dOq5fJOrfMQxLZbJ3RtvctowzkmrtrQOYNGpQ8a2mLMxhauHKHoIVzHR9Kaw==
X-Received: by 2002:a17:906:d18c:: with SMTP id c12mr7305939ejz.151.1598107165596;
        Sat, 22 Aug 2020 07:39:25 -0700 (PDT)
Received: from skbuf ([86.126.22.216])
        by smtp.gmail.com with ESMTPSA id y14sm3399829ejr.35.2020.08.22.07.39.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Aug 2020 07:39:25 -0700 (PDT)
Date:   Sat, 22 Aug 2020 17:39:22 +0300
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
Message-ID: <20200822143922.frjtog4mcyaegtyg@skbuf>
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

Hi Kurt,

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

What other driver have you seen that does this?

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
> +
> +	spin_unlock_irqrestore(&hellcreek->reg_lock, flags);
> +
> +	return 0;
> +}

Thanks,
-Vladimir
