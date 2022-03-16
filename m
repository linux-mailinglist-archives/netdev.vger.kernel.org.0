Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D04754DADB2
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 10:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354953AbiCPJrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 05:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354951AbiCPJrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 05:47:15 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9AA863BC9
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 02:45:58 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 25so2325658ljv.10
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 02:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=5y2pdxZ7bC6EtywS/DmFt1BlAK6B4ynNC7TgewTvXeQ=;
        b=X9XrwjgNaOIIzebAqxnpZbT7DK0bnz/3x0LLPI/MYrKzZjqDubYUX3AViDUoIh0eCM
         5d/LI2oR6TsM/1Eis9wAOhYUdOvpZhfuvtwd9ULwCjv+4RMXb1ySAL/GZf2dZDvmdZe5
         TmUGGk2fj/ESuIPAID52GS6+ROJHqcCoYqXM5Tnj/gH2VOms3j/A38ONjjqBUHQafq4F
         Pg6saO8Di3/AkTwANeNeM1jL62CKeJ8NMkIZotFM4g/VUcy7NXoW1W4qlWk8HXVFsP+s
         p93yicEHSwUQwmdhKfAZBvVib1B6NMCB2IqFR5AetzLpmP7KfFuQ8/iuBSWWt1HOoJWo
         hpDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=5y2pdxZ7bC6EtywS/DmFt1BlAK6B4ynNC7TgewTvXeQ=;
        b=22i7iBAEKpGUjE1Tx+UZqZaB+zjjgkdDTo9Ljfb+Vrw7Y/+LNy/eF14k3RuutDlXC6
         WHjpxzH+N3LtOmGipE1q97XTwHr1LSZtQcntURXSSGi/xNKsWTrbEwfAug6Sye8BBjxf
         NlV3zjBuQtNyvQGJtiUVwGKCW7JyXhQMeWv/wwFgy1nZ61voWlQeEGeYAxGDODkKigh2
         0NsPqgu4bkCVwYDLBc2yOhadUrKdXaJocDXRiD0s1Gvtf3Uq+JfPDCgu9rpw2dqoghsA
         tOrS/oE1TY83CxHoQJkgah6vi9Y2wHByaTJ8rkQymBm4VZXBRrLiUPer8nLveW8LYJGt
         sIrg==
X-Gm-Message-State: AOAM53118nmYw06CIF81BYAKpM19Gn7DpwYEngPG4PKSzNV07oW7Nogr
        DFe4N2e9IbuhyYzV7DOmuCC++Q==
X-Google-Smtp-Source: ABdhPJwazBQDiDN7XvGW2FniIHKOv50xg2pqT+bVzr9TUR2+VQEsBwI/Jvf0bRMOoYMPa8yUOjjOPw==
X-Received: by 2002:a2e:3e17:0:b0:247:ed02:7ec4 with SMTP id l23-20020a2e3e17000000b00247ed027ec4mr19371077lja.76.1647423957127;
        Wed, 16 Mar 2022 02:45:57 -0700 (PDT)
Received: from wkz-x280 (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id h6-20020a2e5306000000b00247e893075asm139349ljb.37.2022.03.16.02.45.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 02:45:56 -0700 (PDT)
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
In-Reply-To: <20220315164249.sjgi6wbdpgehc6m6@skbuf>
References: <20220315002543.190587-1-tobias@waldekranz.com>
 <20220315002543.190587-13-tobias@waldekranz.com>
 <20220315164249.sjgi6wbdpgehc6m6@skbuf>
Date:   Wed, 16 Mar 2022 10:45:55 +0100
Message-ID: <87zglqjkmk.fsf@waldekranz.com>
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

On Tue, Mar 15, 2022 at 18:42, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Tue, Mar 15, 2022 at 01:25:40AM +0100, Tobias Waldekranz wrote:
>> Add the usual trampoline functionality from the generic DSA layer down
>> to the drivers for MST state changes.
>> 
>> When a state changes to disabled/blocking/listening, make sure to fast
>> age any dynamic entries in the affected VLANs (those controlled by the
>> MSTI in question).
>> 
>> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>> ---
>>  include/net/dsa.h  |  3 ++
>>  net/dsa/dsa_priv.h |  2 ++
>>  net/dsa/port.c     | 70 +++++++++++++++++++++++++++++++++++++++++++---
>>  net/dsa/slave.c    |  6 ++++
>>  4 files changed, 77 insertions(+), 4 deletions(-)
>> 
>> diff --git a/include/net/dsa.h b/include/net/dsa.h
>> index 1ddaa2cc5842..0f369f2e9a97 100644
>> --- a/include/net/dsa.h
>> +++ b/include/net/dsa.h
>> @@ -945,7 +945,10 @@ struct dsa_switch_ops {
>>  				     struct dsa_bridge bridge);
>>  	void	(*port_stp_state_set)(struct dsa_switch *ds, int port,
>>  				      u8 state);
>> +	int	(*port_mst_state_set)(struct dsa_switch *ds, int port,
>> +				      const struct switchdev_mst_state *state);
>>  	void	(*port_fast_age)(struct dsa_switch *ds, int port);
>> +	int	(*port_vlan_fast_age)(struct dsa_switch *ds, int port, u16 vid);
>>  	int	(*port_pre_bridge_flags)(struct dsa_switch *ds, int port,
>>  					 struct switchdev_brport_flags flags,
>>  					 struct netlink_ext_ack *extack);
>> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
>> index d90b4cf0c9d2..2ae8996cf7c8 100644
>> --- a/net/dsa/dsa_priv.h
>> +++ b/net/dsa/dsa_priv.h
>> @@ -215,6 +215,8 @@ static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
>>  void dsa_port_set_tag_protocol(struct dsa_port *cpu_dp,
>>  			       const struct dsa_device_ops *tag_ops);
>>  int dsa_port_set_state(struct dsa_port *dp, u8 state, bool do_fast_age);
>> +int dsa_port_set_mst_state(struct dsa_port *dp,
>> +			   const struct switchdev_mst_state *state);
>>  int dsa_port_enable_rt(struct dsa_port *dp, struct phy_device *phy);
>>  int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy);
>>  void dsa_port_disable_rt(struct dsa_port *dp);
>> diff --git a/net/dsa/port.c b/net/dsa/port.c
>> index 3ac114f6fc22..a2a817bb77b1 100644
>> --- a/net/dsa/port.c
>> +++ b/net/dsa/port.c
>> @@ -30,12 +30,11 @@ static int dsa_port_notify(const struct dsa_port *dp, unsigned long e, void *v)
>>  	return dsa_tree_notify(dp->ds->dst, e, v);
>>  }
>>  
>> -static void dsa_port_notify_bridge_fdb_flush(const struct dsa_port *dp)
>> +static void dsa_port_notify_bridge_fdb_flush(const struct dsa_port *dp, u16 vid)
>>  {
>>  	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
>>  	struct switchdev_notifier_fdb_info info = {
>> -		/* flush all VLANs */
>> -		.vid = 0,
>> +		.vid = vid,
>>  	};
>>  
>>  	/* When the port becomes standalone it has already left the bridge.
>> @@ -57,7 +56,42 @@ static void dsa_port_fast_age(const struct dsa_port *dp)
>>  
>>  	ds->ops->port_fast_age(ds, dp->index);
>>  
>> -	dsa_port_notify_bridge_fdb_flush(dp);
>> +	/* flush all VLANs */
>> +	dsa_port_notify_bridge_fdb_flush(dp, 0);
>> +}
>> +
>> +static int dsa_port_vlan_fast_age(const struct dsa_port *dp, u16 vid)
>> +{
>> +	struct dsa_switch *ds = dp->ds;
>> +	int err;
>> +
>> +	if (!ds->ops->port_vlan_fast_age)
>> +		return -EOPNOTSUPP;
>> +
>> +	err = ds->ops->port_vlan_fast_age(ds, dp->index, vid);
>> +
>> +	if (!err)
>> +		dsa_port_notify_bridge_fdb_flush(dp, vid);
>> +
>> +	return err;
>> +}
>> +
>> +static int dsa_port_msti_fast_age(const struct dsa_port *dp, u16 msti)
>> +{
>> +	DECLARE_BITMAP(vids, VLAN_N_VID) = { 0 };
>> +	int err, vid;
>> +
>> +	err = br_mst_get_info(dsa_port_bridge_dev_get(dp), msti, vids);
>> +	if (err)
>> +		return err;
>> +
>> +	for_each_set_bit(vid, vids, VLAN_N_VID) {
>> +		err = dsa_port_vlan_fast_age(dp, vid);
>> +		if (err)
>> +			return err;
>> +	}
>> +
>> +	return 0;
>>  }
>>  
>>  static bool dsa_port_can_configure_learning(struct dsa_port *dp)
>> @@ -118,6 +152,32 @@ static void dsa_port_set_state_now(struct dsa_port *dp, u8 state,
>>  		pr_err("DSA: failed to set STP state %u (%d)\n", state, err);
>>  }
>>  
>> +int dsa_port_set_mst_state(struct dsa_port *dp,
>> +			   const struct switchdev_mst_state *state)
>> +{
>> +	struct dsa_switch *ds = dp->ds;
>> +	int err;
>> +
>> +	if (!ds->ops->port_mst_state_set)
>> +		return -EOPNOTSUPP;
>> +
>> +	err = ds->ops->port_mst_state_set(ds, dp->index, state);
>> +	if (err)
>> +		return err;
>> +
>> +	if (dp->learning) {
>> +		switch (state->state) {
>> +		case BR_STATE_DISABLED:
>> +		case BR_STATE_BLOCKING:
>> +		case BR_STATE_LISTENING:
>
> Is there a requirement in br_mst_set_state() to put the switchdev
> notifier at the end instead of at the beginning?

Not that I can think of. Moving it.

> I'm tempted to ask you to introduce br_mst_get_state(), then assign
> old_state = br_mst_get_state(dsa_port_bridge_dev_get(dp), state->msti),
> then perform the VLAN fast age only on the appropriate state transitions,
> just like the regular fast age.

No time like the present!

Question though:

>> +			err = dsa_port_msti_fast_age(dp, state->msti);

If _msti_fast_age returns an error here, do we want that to bubble up to
the bridge? It seems more important to keep the bridge in sync with the
hardware. I.e. the hardware state has already been successfully synced,
we just weren't able to flush all VLANs for some reason. We could revert
the state I guess, but what if that fails?

Should we settle for a log message?

>> +			break;
>> +		}
>> +	}
>> +
>> +	return err;
>> +}
>> +
>>  int dsa_port_enable_rt(struct dsa_port *dp, struct phy_device *phy)
>>  {
>>  	struct dsa_switch *ds = dp->ds;
>> @@ -326,6 +386,8 @@ static bool dsa_port_supports_mst(struct dsa_port *dp)
>>  	struct dsa_switch *ds = dp->ds;
>>  
>>  	return ds->ops->vlan_msti_set &&
>> +		ds->ops->port_mst_state_set &&
>> +		ds->ops->port_vlan_fast_age &&
>>  		dsa_port_can_configure_learning(dp);
>>  }
>>  
>> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
>> index 5e986cdeaae5..4300fc76f3af 100644
>> --- a/net/dsa/slave.c
>> +++ b/net/dsa/slave.c
>> @@ -450,6 +450,12 @@ static int dsa_slave_port_attr_set(struct net_device *dev, const void *ctx,
>>  
>>  		ret = dsa_port_set_state(dp, attr->u.stp_state, true);
>>  		break;
>> +	case SWITCHDEV_ATTR_ID_PORT_MST_STATE:
>> +		if (!dsa_port_offloads_bridge_port(dp, attr->orig_dev))
>> +			return -EOPNOTSUPP;
>> +
>> +		ret = dsa_port_set_mst_state(dp, &attr->u.mst_state);
>> +		break;
>>  	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
>>  		if (!dsa_port_offloads_bridge_dev(dp, attr->orig_dev))
>>  			return -EOPNOTSUPP;
>> -- 
>> 2.25.1
>> 
