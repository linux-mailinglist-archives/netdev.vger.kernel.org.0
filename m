Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7AE471C26
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 19:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbhLLSTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 13:19:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbhLLSTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 13:19:22 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D28CC0617A2;
        Sun, 12 Dec 2021 10:19:21 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id g14so44607812edb.8;
        Sun, 12 Dec 2021 10:19:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=D3ea7AtwEUpboPZpqowyk7eylVGz2vQ0ymsFmDWozv8=;
        b=TjKfIchTIkAzVUJqogDsBiNI2aAV2TUTds1l+ju77fICocgKBXW0kYkHldD57jkO4v
         R4ABTY2EmljkaTMKPv1Nzbrpg92c7U2+PKvj6qc3zR5Cdym8oZyMwWXrqhdujN27m/ub
         T2XE+nH0RmMMwOFSIBRokbfSRclTviCFOqmSxFlZt+HsQruTIWnNeVEl+W4h+bRP0EuI
         mQRlOPEw1IUJTSzvW5VHL5KqvnNIU5WuJphPg56PagXBV+PPRkJc37aUmNTcsnI6ps2g
         IX5j16KdK4B5KRCdsr19/MQmpU+KnhlrCMcjQbZvj5r5y8hjRBDbuxXoW/Rxqk2bPmGC
         9ZvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=D3ea7AtwEUpboPZpqowyk7eylVGz2vQ0ymsFmDWozv8=;
        b=s4f+eVVchHUb2lmmM5DWhbJ8LHdGgviD3PxeAExeEWaCrAJCtRs28LZrVho2XuSyDS
         g0M5SVl0CU+qyB8paP5zHKMxT2pmMbeIHADJ520gkrYFsUbt8+VxG3o4PQdLHKZJZSHW
         Y2AlhTXT8ZwSjiNNMf4HgGRvZ0jxoUUZT+VQuN9OsCbwiGaNtx1SjQ1M+tMm7YU78LcB
         LKdBW3NP1HuFHYtVJUCWx9ZpePGJTfSuaXWzHfkDli/54nMIQffVQlfYuzf2JP/TE63p
         vukC1gSY8PqQTvzFMN9tAHwwL3bHWc0sAcK+bpid1yOjPBc+61WRbtLMO2vtzqShScae
         L++Q==
X-Gm-Message-State: AOAM530mLRrHn1aYSsVk4bPXQoBd6WLjmO3idEZ6hV67H9I/gP5VTwU7
        fYLkTPOyrOtETAx4S9v6Lzo=
X-Google-Smtp-Source: ABdhPJz1pRj8KvNXjSjmG1zGMjVM2OBtzV+v5D9M21c6FszWFCpKcvEhYAMS1Q9heNpY/wrQ+BZqzg==
X-Received: by 2002:aa7:d541:: with SMTP id u1mr46721414edr.205.1639333159455;
        Sun, 12 Dec 2021 10:19:19 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id u10sm4918648edo.16.2021.12.12.10.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Dec 2021 10:19:19 -0800 (PST)
Message-ID: <61b63d27.1c69fb81.d9ec3.3a9e@mx.google.com>
X-Google-Original-Message-ID: <YbY9JC9WszQUJ0Aa@Ansuel-xps.>
Date:   Sun, 12 Dec 2021 19:19:16 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [net-next RFC PATCH v4 01/15] net: dsa: provide switch
 operations for tracking the master state
References: <20211211195758.28962-1-ansuelsmth@gmail.com>
 <20211211195758.28962-2-ansuelsmth@gmail.com>
 <723bd735-5edc-88ee-4870-e91c98c7dd22@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <723bd735-5edc-88ee-4870-e91c98c7dd22@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 11, 2021 at 08:22:39PM -0800, Florian Fainelli wrote:
> 
> 
> On 12/11/2021 11:57 AM, Ansuel Smith wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > 
> > Certain drivers may need to send management traffic to the switch for
> > things like register access, FDB dump, etc, to accelerate what their
> > slow bus (SPI, I2C, MDIO) can already do.
> > 
> > Ethernet is faster (especially in bulk transactions) but is also more
> > unreliable, since the user may decide to bring the DSA master down (or
> > not bring it up), therefore severing the link between the host and the
> > attached switch.
> > 
> > Drivers needing Ethernet-based register access already should have
> > fallback logic to the slow bus if the Ethernet method fails, but that
> > fallback may be based on a timeout, and the I/O to the switch may slow
> > down to a halt if the master is down, because every Ethernet packet will
> > have to time out. The driver also doesn't have the option to turn off
> > Ethernet-based I/O momentarily, because it wouldn't know when to turn it
> > back on.
> > 
> > Which is where this change comes in. By tracking NETDEV_CHANGE,
> > NETDEV_UP and NETDEV_GOING_DOWN events on the DSA master, we should know
> > the exact interval of time during which this interface is reliably
> > available for traffic. Provide this information to switches so they can
> > use it as they wish.
> > 
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> >   include/net/dsa.h  | 11 +++++++++++
> >   net/dsa/dsa2.c     | 46 ++++++++++++++++++++++++++++++++++++++++++++++
> >   net/dsa/dsa_priv.h | 13 +++++++++++++
> >   net/dsa/slave.c    | 32 ++++++++++++++++++++++++++++++++
> >   net/dsa/switch.c   | 15 +++++++++++++++
> >   5 files changed, 117 insertions(+)
> > 
> > diff --git a/include/net/dsa.h b/include/net/dsa.h
> > index 8b496c7e62ef..12352aafe1cf 100644
> > --- a/include/net/dsa.h
> > +++ b/include/net/dsa.h
> > @@ -299,6 +299,10 @@ struct dsa_port {
> >   	struct list_head	fdbs;
> >   	struct list_head	mdbs;
> > +	/* Master state bits, valid only on CPU ports */
> > +	u8 master_admin_up:1,
> > +	   master_oper_up:1;
> > +
> >   	bool setup;
> >   };
> > @@ -1023,6 +1027,13 @@ struct dsa_switch_ops {
> >   	int	(*tag_8021q_vlan_add)(struct dsa_switch *ds, int port, u16 vid,
> >   				      u16 flags);
> >   	int	(*tag_8021q_vlan_del)(struct dsa_switch *ds, int port, u16 vid);
> > +
> > +	/*
> > +	 * DSA master tracking operations
> > +	 */
> > +	void	(*master_state_change)(struct dsa_switch *ds,
> > +				       const struct net_device *master,
> > +				       bool operational);
> >   };
> >   #define DSA_DEVLINK_PARAM_DRIVER(_id, _name, _type, _cmodes)		\
> > diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
> > index cf6566168620..86b1e2f11469 100644
> > --- a/net/dsa/dsa2.c
> > +++ b/net/dsa/dsa2.c
> > @@ -1245,6 +1245,52 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
> >   	return err;
> >   }
> > +static void dsa_tree_master_state_change(struct dsa_switch_tree *dst,
> > +					 struct net_device *master)
> > +{
> > +	struct dsa_notifier_master_state_info info;
> > +	struct dsa_port *cpu_dp = master->dsa_ptr;
> > +
> > +	info.master = master;
> > +	info.operational = cpu_dp->master_admin_up && cpu_dp->master_oper_up;
> 
> Since this gets tested a few times below, I would be tempted to add a:
> 
> dsa_master_is_operational() helper and use it throughout.
>

Isn't that a bit overkill for a check of 2 bit? Will send a patch with
the helper in v5.

> > +
> > +	dsa_tree_notify(dst, DSA_NOTIFIER_MASTER_STATE_CHANGE, &info);
> > +}
> > +
> > +void dsa_tree_master_admin_state_change(struct dsa_switch_tree *dst,
> > +					struct net_device *master,
> > +					bool up)
> > +{
> > +	struct dsa_port *cpu_dp = master->dsa_ptr;
> > +	bool notify = false;
> > +
> > +	if ((cpu_dp->master_admin_up && cpu_dp->master_oper_up) !=
> 
> Here
> 
> > +	    (up && cpu_dp->master_oper_up))
> > +		notify = true;
> > +
> > +	cpu_dp->master_admin_up = up;
> > +
> > +	if (notify)
> > +		dsa_tree_master_state_change(dst, master);
> > +}
> > +
> > +void dsa_tree_master_oper_state_change(struct dsa_switch_tree *dst,
> > +				       struct net_device *master,
> > +				       bool up)
> > +{
> > +	struct dsa_port *cpu_dp = master->dsa_ptr;
> > +	bool notify = false;
> > +
> > +	if ((cpu_dp->master_admin_up && cpu_dp->master_oper_up) !=
> 
> And here as well
> 
> > +	    (cpu_dp->master_admin_up && up))
> > +		notify = true;
> > +
> > +	cpu_dp->master_oper_up = up;
> > +
> > +	if (notify)
> > +		dsa_tree_master_state_change(dst, master);
> > +}
> > +
> >   static struct dsa_port *dsa_port_touch(struct dsa_switch *ds, int index)
> >   {
> >   	struct dsa_switch_tree *dst = ds->dst;
> > diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> > index 0db2b26b0c83..d2f2bce2391b 100644
> > --- a/net/dsa/dsa_priv.h
> > +++ b/net/dsa/dsa_priv.h
> > @@ -44,6 +44,7 @@ enum {
> >   	DSA_NOTIFIER_MRP_DEL_RING_ROLE,
> >   	DSA_NOTIFIER_TAG_8021Q_VLAN_ADD,
> >   	DSA_NOTIFIER_TAG_8021Q_VLAN_DEL,
> > +	DSA_NOTIFIER_MASTER_STATE_CHANGE,
> >   };
> >   /* DSA_NOTIFIER_AGEING_TIME */
> > @@ -127,6 +128,12 @@ struct dsa_notifier_tag_8021q_vlan_info {
> >   	u16 vid;
> >   };
> > +/* DSA_NOTIFIER_MASTER_STATE_CHANGE */
> > +struct dsa_notifier_master_state_info {
> > +	const struct net_device *master;
> > +	bool operational;
> > +};
> > +
> >   struct dsa_switchdev_event_work {
> >   	struct dsa_switch *ds;
> >   	int port;
> > @@ -507,6 +514,12 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
> >   			      struct net_device *master,
> >   			      const struct dsa_device_ops *tag_ops,
> >   			      const struct dsa_device_ops *old_tag_ops);
> > +void dsa_tree_master_admin_state_change(struct dsa_switch_tree *dst,
> > +					struct net_device *master,
> > +					bool up);
> > +void dsa_tree_master_oper_state_change(struct dsa_switch_tree *dst,
> > +				       struct net_device *master,
> > +				       bool up);
> >   unsigned int dsa_bridge_num_get(const struct net_device *bridge_dev, int max);
> >   void dsa_bridge_num_put(const struct net_device *bridge_dev,
> >   			unsigned int bridge_num);
> > diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> > index 88f7b8686dac..5ccb0616022d 100644
> > --- a/net/dsa/slave.c
> > +++ b/net/dsa/slave.c
> > @@ -2348,6 +2348,36 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
> >   		err = dsa_port_lag_change(dp, info->lower_state_info);
> >   		return notifier_from_errno(err);
> >   	}
> > +	case NETDEV_CHANGE:
> > +	case NETDEV_UP: {
> > +		/* Track state of master port.
> > +		 * DSA driver may require the master port (and indirectly
> > +		 * the tagger) to be available for some special operation.
> > +		 */
> > +		if (netdev_uses_dsa(dev)) {
> > +			struct dsa_port *cpu_dp = dev->dsa_ptr;
> > +			struct dsa_switch_tree *dst = cpu_dp->ds->dst;
> > +
> > +			/* Track when the master port is UP */
> > +			dsa_tree_master_oper_state_change(dst, dev,
> > +							  netif_oper_up(dev));
> > +
> > +			/* Track when the master port is ready and can accept
> > +			 * packet.
> > +			 * NETDEV_UP event is not enough to flag a port as ready.
> > +			 * We also have to wait for linkwatch_do_dev to dev_activate
> > +			 * and emit a NETDEV_CHANGE event.
> > +			 * We check if a master port is ready by checking if the dev
> > +			 * have a qdisc assigned and is not noop.
> > +			 */
> > +			dsa_tree_master_admin_state_change(dst, dev,
> > +							   qdisc_tx_is_noop(dev));
> 
> If my kernel is built with no packet scheduler, is not the interface going
> to be configured with noop all of the time?
> 
> Other than that LGTM!

Ok I just notice, tracking attach_default_qdiscs fail is a nightmare...
Refcount is not set with noop so we can't use that.
dev->qdisc is set to noop by default.

Starting to think we need a way to add more info to the notifier or dev
activate... Unless there is a way to also check when noop is actually
activated.

(or just add a priv_flag with for dev_activated)

> -- 
> Florian

-- 
	Ansuel
