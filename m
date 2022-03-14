Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E63B64D8A9C
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 18:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243253AbiCNRPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 13:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243216AbiCNRPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 13:15:21 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B75B036174;
        Mon, 14 Mar 2022 10:14:07 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id qt6so35502288ejb.11;
        Mon, 14 Mar 2022 10:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nomxyX/nf6tg6i6cYpzqiNmpO6v6wzTTCFLNxhUrHBg=;
        b=Rww5aDsJbQu6V9hwVMpUr3trbIjTtJH8jVP87FvM3n6pJUTwzDLArtmE6F+LdMlIVk
         2aDugPTYUySXjA1Vd5awPuQXx2DF03lDkXLud8TLGg0o5+I+I7MQxbVplsIeKLGqlaUR
         dwliUn3HXldHvX8mpiHgvBTcO1S3psyB6/dV009lDETEsLA4xr2XhrxnpVd0Efrc6e7z
         3Y2HU8KoJ+JzzzUtyELegUpHFduPiZarnd+UbEWGFghmq1nL0pC9XiZ3tkuYqvmr50KQ
         sFwQnpdZbI8UdeJ7SnjjhPPGPc8YI90Jfr5trivk1xCanYTF6YC0p5nN1HgRjyaC8IlS
         WxuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nomxyX/nf6tg6i6cYpzqiNmpO6v6wzTTCFLNxhUrHBg=;
        b=QgMdw98lMPMFlEXot+e+c36/uzv8JZMPyaGD2SKaxmV+z/JMkOoLRz0QMSPIk6YJsB
         l5TqGZ2mY1Lxv/oEojAZrvYKSJXL7L3pHZlpZD4f3G9rKIZaqlzs77hTkT/LGW7uzNMN
         X+Ij5OTzPvkBY9hdYLpeGOtaH7oKDYV4KHmQg5W4wYTMr6QaZohY2Cdq12JUxYgOXDcw
         Dk/joTqo2jJGqC6Zg2yCmUTS7m6iYdAHl8a29M/l8/sEBt37sW8cEiGzwiNLD8GVG5O/
         yMF6VSyrYH/t4HEFT6brLbp1c8Cf+3Gdcwlbm9+VTkezj0q2PeddLumxPQXdKLbStU7A
         7tpQ==
X-Gm-Message-State: AOAM5322YD62I1CqxoGpAdaNgebPbQ93H95Gp9djOzJLYPXNCF5dqb4B
        r4RhFcr5eNyogveqBv2WWNI=
X-Google-Smtp-Source: ABdhPJxxxFCiGTyKv9avS6wHvb750L41lutuQRDu+6yh9EYEXnn+E9i0WAMwevJPOxNJETlBe9CS0w==
X-Received: by 2002:a17:907:7d91:b0:6d7:a1e:a47a with SMTP id oz17-20020a1709077d9100b006d70a1ea47amr20518326ejc.116.1647278046188;
        Mon, 14 Mar 2022 10:14:06 -0700 (PDT)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id z15-20020a170906240f00b006d703ca573fsm6916685eja.85.2022.03.14.10.14.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 10:14:05 -0700 (PDT)
Date:   Mon, 14 Mar 2022 19:14:04 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Cooper Lees <me@cooperlees.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH v3 net-next 11/14] net: dsa: Handle MST state changes
Message-ID: <20220314171404.s2erbwcb36tsmy2o@skbuf>
References: <20220314095231.3486931-1-tobias@waldekranz.com>
 <20220314095231.3486931-12-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314095231.3486931-12-tobias@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 14, 2022 at 10:52:28AM +0100, Tobias Waldekranz wrote:
> Add the usual trampoline functionality from the generic DSA layer down
> to the drivers for MST state changes.
> 
> When a state changes to disabled/blocking/listening, make sure to fast
> age any dynamic entries in the affected VLANs (those controlled by the
> MSTI in question).
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  include/net/dsa.h  |  3 +++
>  net/dsa/dsa_priv.h |  2 ++
>  net/dsa/port.c     | 67 +++++++++++++++++++++++++++++++++++++++++++---
>  net/dsa/slave.c    |  6 +++++
>  4 files changed, 74 insertions(+), 4 deletions(-)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 1ddaa2cc5842..a171e7cdb3fe 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -945,7 +945,10 @@ struct dsa_switch_ops {
>  				     struct dsa_bridge bridge);
>  	void	(*port_stp_state_set)(struct dsa_switch *ds, int port,
>  				      u8 state);
> +	int	(*port_mst_state_set)(struct dsa_switch *ds, int port,
> +				      const struct switchdev_mst_state *state);
>  	void	(*port_fast_age)(struct dsa_switch *ds, int port);
> +	void	(*port_vlan_fast_age)(struct dsa_switch *ds, int port, u16 vid);
>  	int	(*port_pre_bridge_flags)(struct dsa_switch *ds, int port,
>  					 struct switchdev_brport_flags flags,
>  					 struct netlink_ext_ack *extack);
> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> index d90b4cf0c9d2..2ae8996cf7c8 100644
> --- a/net/dsa/dsa_priv.h
> +++ b/net/dsa/dsa_priv.h
> @@ -215,6 +215,8 @@ static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
>  void dsa_port_set_tag_protocol(struct dsa_port *cpu_dp,
>  			       const struct dsa_device_ops *tag_ops);
>  int dsa_port_set_state(struct dsa_port *dp, u8 state, bool do_fast_age);
> +int dsa_port_set_mst_state(struct dsa_port *dp,
> +			   const struct switchdev_mst_state *state);
>  int dsa_port_enable_rt(struct dsa_port *dp, struct phy_device *phy);
>  int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy);
>  void dsa_port_disable_rt(struct dsa_port *dp);
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index f6a822d854cc..223681e03321 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -30,12 +30,11 @@ static int dsa_port_notify(const struct dsa_port *dp, unsigned long e, void *v)
>  	return dsa_tree_notify(dp->ds->dst, e, v);
>  }
>  
> -static void dsa_port_notify_bridge_fdb_flush(const struct dsa_port *dp)
> +static void dsa_port_notify_bridge_fdb_flush(const struct dsa_port *dp, u16 vid)
>  {
>  	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
>  	struct switchdev_notifier_fdb_info info = {
> -		/* flush all VLANs */
> -		.vid = 0,
> +		.vid = vid,
>  	};
>  
>  	/* When the port becomes standalone it has already left the bridge.
> @@ -57,7 +56,39 @@ static void dsa_port_fast_age(const struct dsa_port *dp)
>  
>  	ds->ops->port_fast_age(ds, dp->index);
>  
> -	dsa_port_notify_bridge_fdb_flush(dp);

Could you please migrate the "flush all VLANs" comment here?

> +	dsa_port_notify_bridge_fdb_flush(dp, 0);
> +}
> +
> +static void dsa_port_vlan_fast_age(const struct dsa_port *dp, u16 vid)
> +{
> +	struct dsa_switch *ds = dp->ds;
> +
> +	if (!ds->ops->port_vlan_fast_age)
> +		return;
> +
> +	ds->ops->port_vlan_fast_age(ds, dp->index, vid);
> +
> +	dsa_port_notify_bridge_fdb_flush(dp, vid);
> +}
> +
> +static void dsa_port_msti_fast_age(const struct dsa_port *dp, u16 msti)
> +{
> +	unsigned long *vids;
> +	int vid;
> +
> +	vids = bitmap_zalloc(VLAN_N_VID, 0);
> +	if (!vids)
> +		return;

As discussed, I think you can/should use DECLARE_BITMAP().

> +
> +	if (br_mst_get_info(dsa_port_bridge_dev_get(dp), msti, vids))
> +		goto out_free;
> +
> +	for_each_set_bit(vid, vids, VLAN_N_VID) {
> +		dsa_port_vlan_fast_age(dp, vid);

This has an error propagation path to user space, since just user space
sets it via IFLA_BRIDGE_MST_ENTRY_STATE, does it not?
So could we actually propagate an error all the way from
ds->ops->port_vlan_fast_age to the mstpd daemon?

> +	}
> +
> +out_free:
> +	kfree(vids);
>  }
>  
>  static bool dsa_port_can_configure_learning(struct dsa_port *dp)
> @@ -118,6 +149,32 @@ static void dsa_port_set_state_now(struct dsa_port *dp, u8 state,
>  		pr_err("DSA: failed to set STP state %u (%d)\n", state, err);
>  }
>  
> +int dsa_port_set_mst_state(struct dsa_port *dp,
> +			   const struct switchdev_mst_state *state)
> +{
> +	struct dsa_switch *ds = dp->ds;
> +	int err;
> +
> +	if (!ds->ops->port_mst_state_set)
> +		return -EOPNOTSUPP;
> +
> +	err = ds->ops->port_mst_state_set(ds, dp->index, state);
> +	if (err)
> +		return err;
> +
> +	if (dp->learning) {
> +		switch (state->state) {
> +		case BR_STATE_DISABLED:
> +		case BR_STATE_BLOCKING:
> +		case BR_STATE_LISTENING:
> +			dsa_port_msti_fast_age(dp, state->msti);
> +			break;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  int dsa_port_enable_rt(struct dsa_port *dp, struct phy_device *phy)
>  {
>  	struct dsa_switch *ds = dp->ds;
> @@ -748,6 +805,8 @@ int dsa_port_mst_enable(struct dsa_port *dp, bool on,
>  		return 0;
>  
>  	if (!(ds->ops->vlan_msti_set &&
> +	      ds->ops->port_mst_state_set &&
> +	      ds->ops->port_vlan_fast_age &&
>  	      dsa_port_can_configure_learning(dp))) {
>  		NL_SET_ERR_MSG_MOD(extack, "Hardware does not support MST");
>  		return -EINVAL;
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index cd2c57de9592..106b177ad1eb 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -450,6 +450,12 @@ static int dsa_slave_port_attr_set(struct net_device *dev, const void *ctx,
>  
>  		ret = dsa_port_set_state(dp, attr->u.stp_state, true);
>  		break;
> +	case SWITCHDEV_ATTR_ID_PORT_MST_STATE:
> +		if (!dsa_port_offloads_bridge_port(dp, attr->orig_dev))
> +			return -EOPNOTSUPP;
> +
> +		ret = dsa_port_set_mst_state(dp, &attr->u.mst_state);
> +		break;
>  	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
>  		if (!dsa_port_offloads_bridge_dev(dp, attr->orig_dev))
>  			return -EOPNOTSUPP;
> -- 
> 2.25.1
> 

