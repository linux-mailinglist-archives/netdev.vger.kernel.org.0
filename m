Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14E894DADC5
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 10:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354987AbiCPJwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 05:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354949AbiCPJwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 05:52:35 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F62363BFE
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 02:51:21 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id y17so2320716ljd.12
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 02:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=aQmdouwyZt64K3CHs4I/+fPCcZUQHf00pgfAtsBjS/8=;
        b=k2GCmScofpSG6NncS2vSq7Gz2rQSQuSlz4FW/k8lM75O5pptJSmJraWXBqj7Rf4ZN2
         px/hrXkJqbbTUhxF4mJ2UUzdQMxDJPdAx6ZdU0lwERbSPW6IAAQz3Nx7vely8pKPQANW
         YtFVs/azDd+BtrsKIydPHpuk5YpycnKWV4diYrTTd/bcbJckPrFdtFPAQWAuPnzyN2GY
         H/d3dXfvnaFk9yc7iKTBqwte6yPS4dQ7jyxhtFuQK1UvLO9VGp8mzrLCB++QFd+Mzqk+
         /GQ196IVjhEVEPxWJFiNlvceJdUYFr1CV4A0DJ27rJlvhbQm5jcdj9i965TUIHigDQ6l
         8FNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=aQmdouwyZt64K3CHs4I/+fPCcZUQHf00pgfAtsBjS/8=;
        b=iQY0X9q/ClophEMsmuL/pn5fqHQolKGyMgF3MuapU3QV2i+nEKi9QRR2/US0mtm7eb
         fLyd2BNYhNKlq4L2QSfurLf/rd+r4AfAGYZVKId9mm91ppItUyiDftpx1bgIx+QZex2T
         m9Pq6QWmMQPbMKaErBKY7fG6dypZ9ds1KC4o3elWKbS24qrUp7PvZ7QS1fI9xF91rlZw
         oqvEsEEn7Xl3HMKJs8YxHDg4XeVkJcTWinhNhUfE5kJG2lH4et7uKs1KHJDgSnQ9TNpq
         KvzZxqLr0e2BP/a2Uh0QtAghi5D9lk57k8xtsGVzAM08YxMSNxy2amow6oy3w0j1c2Uc
         PuuQ==
X-Gm-Message-State: AOAM532GSg+zN/uVwATeXjCzIeIGkYCUzebCqQfzjHiNZ7ZS5q847NZY
        Zni8LZzZVCgkdOZpZLDGvF1tfw==
X-Google-Smtp-Source: ABdhPJw68bIiy9XYVz386CSHTor0T8RWyy2YgN4fqBlK1vE4L6wdUvGOnNdVXMEJZFsqHpW1UYzuvg==
X-Received: by 2002:a05:651c:4d4:b0:249:1768:81eb with SMTP id e20-20020a05651c04d400b00249176881ebmr17374006lji.329.1647424279292;
        Wed, 16 Mar 2022 02:51:19 -0700 (PDT)
Received: from wkz-x280 (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id m5-20020a2eb6c5000000b002480545ebfesm135372ljo.138.2022.03.16.02.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 02:51:18 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Cooper Lees <me@cooperlees.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [PATCH v4 net-next 12/15] net: dsa: Handle MST state changes
In-Reply-To: <87zglqjkmk.fsf@waldekranz.com>
References: <20220315002543.190587-1-tobias@waldekranz.com>
 <20220315002543.190587-13-tobias@waldekranz.com>
 <20220315164249.sjgi6wbdpgehc6m6@skbuf> <87zglqjkmk.fsf@waldekranz.com>
Date:   Wed, 16 Mar 2022 10:51:17 +0100
Message-ID: <87wngujkdm.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 16, 2022 at 10:45, Tobias Waldekranz <tobias@waldekranz.com> wrote:
> On Tue, Mar 15, 2022 at 18:42, Vladimir Oltean <olteanv@gmail.com> wrote:
>> On Tue, Mar 15, 2022 at 01:25:40AM +0100, Tobias Waldekranz wrote:
>>> Add the usual trampoline functionality from the generic DSA layer down
>>> to the drivers for MST state changes.
>>> 
>>> When a state changes to disabled/blocking/listening, make sure to fast
>>> age any dynamic entries in the affected VLANs (those controlled by the
>>> MSTI in question).
>>> 
>>> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>>> ---
>>>  include/net/dsa.h  |  3 ++
>>>  net/dsa/dsa_priv.h |  2 ++
>>>  net/dsa/port.c     | 70 +++++++++++++++++++++++++++++++++++++++++++---
>>>  net/dsa/slave.c    |  6 ++++
>>>  4 files changed, 77 insertions(+), 4 deletions(-)
>>> 
>>> diff --git a/include/net/dsa.h b/include/net/dsa.h
>>> index 1ddaa2cc5842..0f369f2e9a97 100644
>>> --- a/include/net/dsa.h
>>> +++ b/include/net/dsa.h
>>> @@ -945,7 +945,10 @@ struct dsa_switch_ops {
>>>  				     struct dsa_bridge bridge);
>>>  	void	(*port_stp_state_set)(struct dsa_switch *ds, int port,
>>>  				      u8 state);
>>> +	int	(*port_mst_state_set)(struct dsa_switch *ds, int port,
>>> +				      const struct switchdev_mst_state *state);
>>>  	void	(*port_fast_age)(struct dsa_switch *ds, int port);
>>> +	int	(*port_vlan_fast_age)(struct dsa_switch *ds, int port, u16 vid);
>>>  	int	(*port_pre_bridge_flags)(struct dsa_switch *ds, int port,
>>>  					 struct switchdev_brport_flags flags,
>>>  					 struct netlink_ext_ack *extack);
>>> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
>>> index d90b4cf0c9d2..2ae8996cf7c8 100644
>>> --- a/net/dsa/dsa_priv.h
>>> +++ b/net/dsa/dsa_priv.h
>>> @@ -215,6 +215,8 @@ static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
>>>  void dsa_port_set_tag_protocol(struct dsa_port *cpu_dp,
>>>  			       const struct dsa_device_ops *tag_ops);
>>>  int dsa_port_set_state(struct dsa_port *dp, u8 state, bool do_fast_age);
>>> +int dsa_port_set_mst_state(struct dsa_port *dp,
>>> +			   const struct switchdev_mst_state *state);
>>>  int dsa_port_enable_rt(struct dsa_port *dp, struct phy_device *phy);
>>>  int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy);
>>>  void dsa_port_disable_rt(struct dsa_port *dp);
>>> diff --git a/net/dsa/port.c b/net/dsa/port.c
>>> index 3ac114f6fc22..a2a817bb77b1 100644
>>> --- a/net/dsa/port.c
>>> +++ b/net/dsa/port.c
>>> @@ -30,12 +30,11 @@ static int dsa_port_notify(const struct dsa_port *dp, unsigned long e, void *v)
>>>  	return dsa_tree_notify(dp->ds->dst, e, v);
>>>  }
>>>  
>>> -static void dsa_port_notify_bridge_fdb_flush(const struct dsa_port *dp)
>>> +static void dsa_port_notify_bridge_fdb_flush(const struct dsa_port *dp, u16 vid)
>>>  {
>>>  	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
>>>  	struct switchdev_notifier_fdb_info info = {
>>> -		/* flush all VLANs */
>>> -		.vid = 0,
>>> +		.vid = vid,
>>>  	};
>>>  
>>>  	/* When the port becomes standalone it has already left the bridge.
>>> @@ -57,7 +56,42 @@ static void dsa_port_fast_age(const struct dsa_port *dp)
>>>  
>>>  	ds->ops->port_fast_age(ds, dp->index);
>>>  
>>> -	dsa_port_notify_bridge_fdb_flush(dp);
>>> +	/* flush all VLANs */
>>> +	dsa_port_notify_bridge_fdb_flush(dp, 0);
>>> +}
>>> +
>>> +static int dsa_port_vlan_fast_age(const struct dsa_port *dp, u16 vid)
>>> +{
>>> +	struct dsa_switch *ds = dp->ds;
>>> +	int err;
>>> +
>>> +	if (!ds->ops->port_vlan_fast_age)
>>> +		return -EOPNOTSUPP;
>>> +
>>> +	err = ds->ops->port_vlan_fast_age(ds, dp->index, vid);
>>> +
>>> +	if (!err)
>>> +		dsa_port_notify_bridge_fdb_flush(dp, vid);
>>> +
>>> +	return err;
>>> +}
>>> +
>>> +static int dsa_port_msti_fast_age(const struct dsa_port *dp, u16 msti)
>>> +{
>>> +	DECLARE_BITMAP(vids, VLAN_N_VID) = { 0 };
>>> +	int err, vid;
>>> +
>>> +	err = br_mst_get_info(dsa_port_bridge_dev_get(dp), msti, vids);
>>> +	if (err)
>>> +		return err;
>>> +
>>> +	for_each_set_bit(vid, vids, VLAN_N_VID) {
>>> +		err = dsa_port_vlan_fast_age(dp, vid);
>>> +		if (err)
>>> +			return err;
>>> +	}
>>> +
>>> +	return 0;
>>>  }
>>>  
>>>  static bool dsa_port_can_configure_learning(struct dsa_port *dp)
>>> @@ -118,6 +152,32 @@ static void dsa_port_set_state_now(struct dsa_port *dp, u8 state,
>>>  		pr_err("DSA: failed to set STP state %u (%d)\n", state, err);
>>>  }
>>>  
>>> +int dsa_port_set_mst_state(struct dsa_port *dp,
>>> +			   const struct switchdev_mst_state *state)
>>> +{
>>> +	struct dsa_switch *ds = dp->ds;
>>> +	int err;
>>> +
>>> +	if (!ds->ops->port_mst_state_set)
>>> +		return -EOPNOTSUPP;
>>> +
>>> +	err = ds->ops->port_mst_state_set(ds, dp->index, state);
>>> +	if (err)
>>> +		return err;
>>> +
>>> +	if (dp->learning) {
>>> +		switch (state->state) {
>>> +		case BR_STATE_DISABLED:
>>> +		case BR_STATE_BLOCKING:
>>> +		case BR_STATE_LISTENING:
>>
>> Is there a requirement in br_mst_set_state() to put the switchdev
>> notifier at the end instead of at the beginning?
>
> Not that I can think of. Moving it.
>
>> I'm tempted to ask you to introduce br_mst_get_state(), then assign
>> old_state = br_mst_get_state(dsa_port_bridge_dev_get(dp), state->msti),
>> then perform the VLAN fast age only on the appropriate state transitions,
>> just like the regular fast age.
>
> No time like the present!
>
> Question though:
>
>>> +			err = dsa_port_msti_fast_age(dp, state->msti);
>
> If _msti_fast_age returns an error here, do we want that to bubble up to
> the bridge? It seems more important to keep the bridge in sync with the
> hardware. I.e. the hardware state has already been successfully synced,
> we just weren't able to flush all VLANs for some reason. We could revert
> the state I guess, but what if that fails?
>
> Should we settle for a log message?

Or should we set the extack message? Similar to how we report software
fallback of bridging/LAGs?

>>> +			break;
>>> +		}
>>> +	}
>>> +
>>> +	return err;
>>> +}
>>> +
>>>  int dsa_port_enable_rt(struct dsa_port *dp, struct phy_device *phy)
>>>  {
>>>  	struct dsa_switch *ds = dp->ds;
>>> @@ -326,6 +386,8 @@ static bool dsa_port_supports_mst(struct dsa_port *dp)
>>>  	struct dsa_switch *ds = dp->ds;
>>>  
>>>  	return ds->ops->vlan_msti_set &&
>>> +		ds->ops->port_mst_state_set &&
>>> +		ds->ops->port_vlan_fast_age &&
>>>  		dsa_port_can_configure_learning(dp);
>>>  }
>>>  
>>> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
>>> index 5e986cdeaae5..4300fc76f3af 100644
>>> --- a/net/dsa/slave.c
>>> +++ b/net/dsa/slave.c
>>> @@ -450,6 +450,12 @@ static int dsa_slave_port_attr_set(struct net_device *dev, const void *ctx,
>>>  
>>>  		ret = dsa_port_set_state(dp, attr->u.stp_state, true);
>>>  		break;
>>> +	case SWITCHDEV_ATTR_ID_PORT_MST_STATE:
>>> +		if (!dsa_port_offloads_bridge_port(dp, attr->orig_dev))
>>> +			return -EOPNOTSUPP;
>>> +
>>> +		ret = dsa_port_set_mst_state(dp, &attr->u.mst_state);
>>> +		break;
>>>  	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
>>>  		if (!dsa_port_offloads_bridge_dev(dp, attr->orig_dev))
>>>  			return -EOPNOTSUPP;
>>> -- 
>>> 2.25.1
>>> 
