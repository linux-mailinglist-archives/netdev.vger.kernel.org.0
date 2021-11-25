Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9CA45D81A
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 11:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354377AbhKYKWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 05:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354584AbhKYKUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 05:20:20 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2BAC0613E1
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 02:16:56 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id g14so23307243edb.8
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 02:16:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RSvv0uce5ZnYlzZ9a67Zuig6imqKecb+t62ChCBsSNg=;
        b=UQmXRvPkPCZlQc2l228gc212vD11uL6zs6e4diMFmiKzEK+T/zK8LrCil7bT/tZJR0
         L+rd/rgHbqHSk+J/TnHqZECaZMpogQwSx1O4PgjKaNZs7XOjJCwEKVZ8kIyAtFknIgLn
         k3UQ5Jfd4NncoQMuIeMNrx1c611ZSfSzkrDd+cNwhOMDGyAJ0T5hGSvkK+pP0+0wV+nL
         CyBxAnxsgn1LpwiJzc4z0YRXYpehLoKei39MHilCE2Jq8hYAXlhZIRmwkSiq8AeDw9Ek
         pIsmC7N8R00XPpEXlV4UvOnvstRpoF0yEV9MgSKva91vsPnt+nyZ+rh+BPLcV7cpVNe7
         +kBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RSvv0uce5ZnYlzZ9a67Zuig6imqKecb+t62ChCBsSNg=;
        b=IHVQ0yDgbI+DvCOB/wkNApJESabLS5Kgje7KFAVKCLsdPU0sgkEWErok6OP359fw9v
         qSr/EglwyV41ATMWF4k4UW165OiFhkO+5Hf2HGbAMucbqZuSs8XiVijIjbXLBPRZyfU4
         B9Ic0+WPFTrxelgSOYRsTyrI7t9p09K2Hl058Bhi+BpG0eX/Hp9VBybYqDpOD0fhu4zm
         f1MKM67x1bkwgFIL/WYGPLi/pN98nypMKpx5M+4lCOsr67gZC0h5KRXOdoRE+hUYXkiz
         18yMZuRt14U4cZLZHmNzl5zPIrbNSMopnMkj78OUHP0+Tth+zXoaGgUe6hfp9iXZdyIP
         2Edw==
X-Gm-Message-State: AOAM532cs0HOV7V/+T48+1vbsmnZYWyT1iZS7IZATcBZryOcaCG5lWlU
        DcyjeiAUdya5/f8xLJ7/Go991Zfr0kw=
X-Google-Smtp-Source: ABdhPJx55AIpr89r3/7pjfae3ySp4RpPKqzG1l3fjzvqF5IF1ZumOVq+e75tIhY90o6xMFdapV0DXw==
X-Received: by 2002:a17:906:2e97:: with SMTP id o23mr28347948eji.541.1637835415226;
        Thu, 25 Nov 2021 02:16:55 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id e4sm1355941ejs.13.2021.11.25.02.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 02:16:54 -0800 (PST)
Date:   Thu, 25 Nov 2021 12:16:52 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v2 net-next] net: dsa: felix: enable cut-through
 forwarding between ports by default
Message-ID: <20211125101652.ansuiha5hlwe3ner@skbuf>
References: <20211123132116.913520-1-olteanv@gmail.com>
 <20211124183900.7fb192f4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124183900.7fb192f4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 06:39:00PM -0800, Jakub Kicinski wrote:
> On Tue, 23 Nov 2021 15:21:16 +0200 Vladimir Oltean wrote:
> > +static void vsc9959_cut_through_fwd(struct ocelot *ocelot)
> > +{
> > +	struct felix *felix = ocelot_to_felix(ocelot);
> > +	struct dsa_switch *ds = felix->ds;
> > +	int port, other_port;
> > +
> > +	for (port = 0; port < ocelot->num_phys_ports; port++) {
> > +		struct ocelot_port *ocelot_port = ocelot->ports[port];
> > +		unsigned long mask;
> > +		int min_speed;
> > +		u32 val = 0;
> > +
> > +		if (ocelot_port->speed <= 0)
> > +			continue;
> 
> Would it not be safer to disable cut-thru for ports which are down?
> 
> 	goto set;

I don't know, I suppose we can do that.

> > +		min_speed = ocelot_port->speed;
> > +		if (port == ocelot->npi) {
> > +			/* Ocelot switches forward from the NPI port towards
> > +			 * any port, regardless of it being in the NPI port's
> > +			 * forwarding domain or not.
> > +			 */
> > +			mask = dsa_user_ports(ds);
> > +		} else {
> > +			mask = ocelot_read_rix(ocelot, ANA_PGID_PGID,
> > +					       PGID_SRC + port);
> > +			/* Ocelot switches forward to the NPI port despite it
> > +			 * not being in the source ports' forwarding domain.
> > +			 */
> > +			if (ocelot->npi >= 0)
> > +				mask |= BIT(ocelot->npi);
> > +		}
> > +
> > +		for_each_set_bit(other_port, &mask, ocelot->num_phys_ports) {
> > +			struct ocelot_port *other_ocelot_port;
> > +
> > +			other_ocelot_port = ocelot->ports[other_port];
> > +			if (other_ocelot_port->speed <= 0)
> > +				continue;
> > +
> > +			if (min_speed > other_ocelot_port->speed)
> > +				min_speed = other_ocelot_port->speed;
> 
> break; ?

Break where and why?
Breaking in the "if" block means "stop at the first @other_port in
@port's forwarding domain which has a lower speed than @port". But that
isn't necessarily the minimum...
And breaking below the "if" block means stopping at the first
@other_port in @port's forwarding domain, which doesn't make sense.
This is the simple calculation of the minimum value of an array, no
special sauce here.

> > +		}
> > +
> > +		/* Enable cut-through forwarding for all traffic classes. */
> > +		if (ocelot_port->speed == min_speed)
> 
> Any particular reason this is not <= ?

So min_speed is by construction always a valid speed: SPEED_10,
SPEED_100 etc (never SPEED_UNKNOWN). What this statement is saying is
that cut-through forwarding can be enabled only for the ports operating
at the lowest link speed within a forwarding domain. If I change "=="
into "<=", I would also be enabling cut-through for the ports with
SPEED_UNKNOWN (were it not for this condition right at the beginning):

		if (ocelot_port->speed <= 0)
			continue;

So practically speaking, since there is never any port with a speed
smaller than the min_speed, it doesn't make sense to check for <= min_speed.

> > +			val = GENMASK(7, 0);
> 
> set: ?

This I can do.

> > +		ocelot_write_rix(ocelot, val, ANA_CUT_THRU_CFG, port);
> > +	}
> > +}
> 
> >  static const struct felix_info felix_info_vsc9959 = {
> > diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> > index 95920668feb0..30c790f401be 100644
> > --- a/drivers/net/ethernet/mscc/ocelot.c
> > +++ b/drivers/net/ethernet/mscc/ocelot.c
> 
> > @@ -697,6 +702,8 @@ void ocelot_phylink_mac_link_up(struct ocelot *ocelot, int port,
> >  	int mac_speed, mode = 0;
> >  	u32 mac_fc_cfg;
> >  
> > +	ocelot_port->speed = speed;
> > +
> >  	/* The MAC might be integrated in systems where the MAC speed is fixed
> >  	 * and it's the PCS who is performing the rate adaptation, so we have
> >  	 * to write "1000Mbps" into the LINK_SPEED field of DEV_CLOCK_CFG
> > @@ -772,6 +779,9 @@ void ocelot_phylink_mac_link_up(struct ocelot *ocelot, int port,
> >  	/* Core: Enable port for frame transfer */
> >  	ocelot_fields_write(ocelot, port,
> >  			    QSYS_SWITCH_PORT_MODE_PORT_ENA, 1);
> 
> Does this enable forwarding? Is there a window here with forwarding
> enabled and old cut-thru masks if we don't clear cut-thru when port
> goes down?

Correct, I should be updating the cut-through masks before this, thanks.

> > +	if (ocelot->ops->cut_through_fwd)
> > +		ocelot->ops->cut_through_fwd(ocelot);
> >  }
> >  EXPORT_SYMBOL_GPL(ocelot_phylink_mac_link_up);
> >  
> > @@ -1637,6 +1647,9 @@ void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
> >  
> >  		ocelot_write_rix(ocelot, mask, ANA_PGID_PGID, PGID_SRC + port);
> >  	}
> 
> Obviously shooting from the hip here, but I was expecting the cut-thru
> update to be before the bridge reconfig if port is joining, and after
> if port is leaving. Do you know what I'm getting at?

Yes, I know what you're getting at. But it's a bit complicated to do,
given the layering constraints and that cut-through forwarding is an
optional feature which isn't present on all devices, so I am trying to
keep its footprint minimal on the ocelot library.

What I can do is I can disable cut-through forwarding for ports that are
standalone (not in a bridge). I don't have a use case for that anyway:
the store-and-forward latency is indistinguishable from network stack
latency. This will guarantee that when a port joins a bridge, it has
cut-through forwarding disabled. So there are no issues if it happens to
join a bridge and its link speed is higher than anybody else: there will
be no packet underruns.

> > +	if (ocelot->ops->cut_through_fwd)
> > +		ocelot->ops->cut_through_fwd(ocelot);
> >  }
> >  EXPORT_SYMBOL(ocelot_apply_bridge_fwd_mask);

Thanks for taking a look at the patch!
