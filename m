Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3812D372FFB
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 20:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbhEDSvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 14:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbhEDSvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 14:51:40 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E83C061574;
        Tue,  4 May 2021 11:50:44 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id gx5so14750060ejb.11;
        Tue, 04 May 2021 11:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HD/mkMjodnRFmictHOrutu0YoPz+m1hT1YUAXAZ3Sh0=;
        b=JH7tiMQILg7kciiIT6pFlUB3Spg+A1ApjeFiaJuI6XOeGWZQ3SFEyY4cINMmcIn1Ey
         uk6lv0CGcShBEa9HKp/Yc2ZQ1SiB+5ISEkt2LDh180XIXrdT4vZhtU6AwwVEg5w57rzh
         F+FZWcrz0UgTyTzMe2cIFnsbcwup6CUXIJEvnFtnnBMu3WnddmJuMFQLyQOkDAWqht9n
         5FbqA0VpVHxxLxH1mg2FviDAoQUPv7QlFztXlVYgUGMiLOVFCup54kPES7sTKZDvGzrL
         5cB8l+k/xLOdGRRJaEzQSP0UEu447phdjDIDAve9tOnYD/Q4aIzvcqKyTinb78ow1sev
         vORQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HD/mkMjodnRFmictHOrutu0YoPz+m1hT1YUAXAZ3Sh0=;
        b=ihDVSICq6FWEUMLMeam25O2YBeBS7RN3uaTVek+C+bxtyvNHkaXKIB0XP19/hwNC+1
         Ukq+B+QOWUSUfRhxbY1wKYe4pHT5IpJKn4ykXCuu/ty2SJ1q14nM0Y9mS0b5wKc7Zn/J
         mgQ4DTtJUVjKgNLm3/stBBi9C+bmH9myxjpH6XpMY6jgoglGZymPzgRwqDejcTN2QaSv
         xdoiRX5Nf47EY/iA1ywm2Hw4nrbfT5zpQdVvcrKqO/CDr2AGfixsQaginxNSQrMElA1M
         kwPb0uZledD2pyysqRNKIvKSRMjQmoMCXB1jz/8Wij1nK9U1Dpq0I8xdmpCad2n9JpXs
         ASCw==
X-Gm-Message-State: AOAM532Mo+MJ2W8Zyh5AQG6J4MUeOtdubrMZ7JpBD9vAnbPjZH79ANWG
        RuAHhQTn0gkAS8Nz/WWXFgQ=
X-Google-Smtp-Source: ABdhPJzcjQHQMnF9WLF7sHEbN/vG8PkEE2XVu6knQWbKAYQhketZVsci2KxIERYXNVU2OPzwyLjJmA==
X-Received: by 2002:a17:907:1ca8:: with SMTP id nb40mr9639315ejc.181.1620154242974;
        Tue, 04 May 2021 11:50:42 -0700 (PDT)
Received: from skbuf ([86.127.41.210])
        by smtp.gmail.com with ESMTPSA id i8sm14656794edu.64.2021.05.04.11.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 11:50:42 -0700 (PDT)
Date:   Tue, 4 May 2021 21:50:40 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     xiaoliang.yang_1@nxp.com, Arvid.Brodin@xdin.com,
        UNGLinuxDriver@microchip.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, andre.guedes@linux.intel.com,
        claudiu.manoil@nxp.com, colin.king@canonical.com,
        davem@davemloft.net, idosch@mellanox.com,
        ivan.khoronzhuk@linaro.org, jiri@mellanox.com,
        joergen.andreasen@microchip.com, leoyang.li@nxp.com,
        linux-kernel@vger.kernel.org, m-karicheri2@ti.com,
        michael.chan@broadcom.com, mingkai.hu@nxp.com,
        netdev@vger.kernel.org, po.liu@nxp.com, saeedm@mellanox.com,
        vinicius.gomes@intel.com, vladimir.oltean@nxp.com,
        yuehaibing@huawei.com
Subject: Re: [net-next] net: dsa: felix: disable always guard band bit for
 TAS config
Message-ID: <20210504185040.ftkub3ropuacmyel@skbuf>
References: <20210419102530.20361-1-xiaoliang.yang_1@nxp.com>
 <20210504170514.10729-1-michael@walle.cc>
 <20210504181833.w2pecbp2qpuiactv@skbuf>
 <c7618025da6723418c56a54fe4683bd7@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7618025da6723418c56a54fe4683bd7@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 04, 2021 at 08:38:29PM +0200, Michael Walle wrote:
> Hi Vladimir,
> 
> Am 2021-05-04 20:18, schrieb Vladimir Oltean:
> > On Tue, May 04, 2021 at 07:05:14PM +0200, Michael Walle wrote:
> > > Hi,
> > > 
> > > > ALWAYS_GUARD_BAND_SCH_Q bit in TAS config register is descripted as
> > > > this:
> > > > 	0: Guard band is implemented for nonschedule queues to schedule
> > > > 	   queues transition.
> > > > 	1: Guard band is implemented for any queue to schedule queue
> > > > 	   transition.
> > > >
> > > > The driver set guard band be implemented for any queue to schedule queue
> > > > transition before, which will make each GCL time slot reserve a guard
> > > > band time that can pass the max SDU frame. Because guard band time could
> > > > not be set in tc-taprio now, it will use about 12000ns to pass 1500B max
> > > > SDU. This limits each GCL time interval to be more than 12000ns.
> > > >
> > > > This patch change the guard band to be only implemented for nonschedule
> > > > queues to schedule queues transition, so that there is no need to reserve
> > > > guard band on each GCL. Users can manually add guard band time for each
> > > > schedule queues in their configuration if they want.
> > > 
> > > 
> > > As explained in another mail in this thread, all queues are marked as
> > > scheduled. So this is actually a no-op, correct? It doesn't matter if
> > > it set or not set for now. Dunno why we even care for this bit then.
> > 
> > It matters because ALWAYS_GUARD_BAND_SCH_Q reduces the available
> > throughput when set.
> 
> Ahh, I see now. All queues are "scheduled" but the guard band only applies
> for "non-scheduled" -> "scheduled" transitions. So the guard band is never
> applied, right? Is that really what we want?

Xiaoliang explained that yes, this is what we want. If the end user
wants a guard band they can explicitly add a "sched-entry 00" in the
tc-taprio config.

> > > > Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> > > > ---
> > > >  drivers/net/dsa/ocelot/felix_vsc9959.c | 8 ++++++--
> > > >  1 file changed, 6 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
> > > > index 789fe08cae50..2473bebe48e6 100644
> > > > --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> > > > +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> > > > @@ -1227,8 +1227,12 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
> > > >  	if (taprio->num_entries > VSC9959_TAS_GCL_ENTRY_MAX)
> > > >  		return -ERANGE;
> > > >
> > > > -	ocelot_rmw(ocelot, QSYS_TAS_PARAM_CFG_CTRL_PORT_NUM(port) |
> > > > -		   QSYS_TAS_PARAM_CFG_CTRL_ALWAYS_GUARD_BAND_SCH_Q,
> > > > +	/* Set port num and disable ALWAYS_GUARD_BAND_SCH_Q, which means set
> > > > +	 * guard band to be implemented for nonschedule queues to schedule
> > > > +	 * queues transition.
> > > > +	 */
> > > > +	ocelot_rmw(ocelot,
> > > > +		   QSYS_TAS_PARAM_CFG_CTRL_PORT_NUM(port),
> > > >  		   QSYS_TAS_PARAM_CFG_CTRL_PORT_NUM_M |
> > > >  		   QSYS_TAS_PARAM_CFG_CTRL_ALWAYS_GUARD_BAND_SCH_Q,
> > > >  		   QSYS_TAS_PARAM_CFG_CTRL);
> > > 
> > > Anyway, I don't think this the correct place for this:
> > >  (1) it isn't per port, but a global bit, but here its done per port.
> > 
> > I don't understand. According to the documentation, selecting the port
> > whose time-aware shaper you are configuring is done through
> > QSYS::TAS_PARAM_CFG_CTRL.PORT_NUM.
> 
> According to the LS1028A RM:
> 
>   PORT_NUM
>   Specifies the port number to which the TAS_PARAMS register configurations
>   (CFG_REG_1 to CFG_REG_5, TIME_INTERVAL and GATE_STATE) need to be applied.
> 
> I guess this work together with CONFIG_CHANGE and applies the mentions
> registers
> in an atomic way (or at a given time). There is no mention of the
> ALWAYS_GUARD_BAND_SCH_Q bit nor the register TAS_PARAM_CFG_CTRL.
> 
> But the ALWAYS_GUARD_BAND_SCH_Q mention its "Global configuration". That
> together with the fact that it can't be read back (unless I'm missing
> something), led me to the conclusion that this bit is global for the whole
> switch. I may be wrong.

Sorry, I don't understand what you mean to say here.

> But in any case, (2) is more severe IMHO.
> 
> > >  (2) rmw, I presume is read-modify-write. and there is one bit CONFIG_CHAGE
> > >      which is set by software and cleared by hardware. What happens if it
> > > 	 will be cleared right after we read it. Then it will be set again, no?
> > > 
> > > So if we really care about this bit, shouldn't this be moved to switch
> > > initialization then?

Sorry, again, I don't understand. Let me copy here the procedure from
vsc9959_qos_port_tas_set():

	ocelot_rmw(ocelot, QSYS_TAS_PARAM_CFG_CTRL_CONFIG_CHANGE,
		   QSYS_TAS_PARAM_CFG_CTRL_CONFIG_CHANGE,
		   QSYS_TAS_PARAM_CFG_CTRL); <- set the CONFIG_CHANGE bit, keep everything else the same

	ret = readx_poll_timeout(vsc9959_tas_read_cfg_status, ocelot, val,
				 !(val & QSYS_TAS_PARAM_CFG_CTRL_CONFIG_CHANGE),
				 10, 100000); <- spin until CONFIG_CHANGE clears

Should there have been a mutex at the beginning of vsc9959_qos_port_tas_set,
ensuring that two independent user space processes configuring the TAS
of two ports cannot access the global config registers concurrently?
Probably, although my guess is that currently, the global rtnetlink
mutex prevents this from happening in practice.

> > May I know what drew your attention to this patch? Is there something
> > wrong?

^ question still remains
