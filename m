Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E819833EF55
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 12:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbhCQLO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 07:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbhCQLOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 07:14:21 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55A58C06174A
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 04:14:21 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id u10so2612653lju.7
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 04:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=fV7e7fscCtsUU8u/HaCgXq56EuzYog7ioIbdmedSue0=;
        b=Oyk/q4hn3FXwvM1NPACEz5A0ayHqTe790YWA/KtifyHmwyq5gxFByw7ZTQvtROuCSs
         2457fQOcK4cEAZ/AM0VCl2BDWITapTkBw0wFKQ0nrMcokg29KNE2rkEKWovFjx/4TJH4
         Ah1XxCHK53Tuh28rcq3VfQwtgHgRITdcUgxbVAveU6SUmahKUt47K/+UsdT15iwhhPf6
         ++1tGbwsq/t0A9VqtqzwzOcc4Wd/370BOsoyAH3i+yv085zMYz1//h71SeXQNqbhXqN1
         vdF5OC0oHbmwmMF1UoOApdb8oeNws46qnu0iAKnPU1OsOOhrm69iCeC/d2nFsL5XwNc7
         PD/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=fV7e7fscCtsUU8u/HaCgXq56EuzYog7ioIbdmedSue0=;
        b=S0EUT8O50vpag9nuUa7SLvTzuoMY7ZZw6BYe8TU/oQFjtNV6LQYNUSwQt0ez+QbwI8
         jqnE3XHaQE4qQ6uspM0bhyYUU43jjUeD4kGk7ggxDbViYsKx1xKR7eHzm8qm073bsUyY
         4jQl6Lv8jWr37cbZvWatSsoB5CdYIZ2QRGZgilMKmwr77W+7qjGW0YF6yz1xaat5mVpI
         VmhElP5oP4bXAKkMHS+3YSIKKWm9VtC/57eB6VVlAhS7MKnDG//1kFghyKNTYqriVFsR
         O/3w2zNM0L2VPzW/yD9mvnucyH546ZFUDA5TIQxArB/Ih5q5BWbctl0tatC2JFdOjfW8
         D2DA==
X-Gm-Message-State: AOAM530WS84sX/k3O5IQKjV6L+i+nccU/k8ULn4UuczaOJF2LRWRNWIX
        pKwTya7q390JwTVhI9UWjkBF54hivoUX/s8X
X-Google-Smtp-Source: ABdhPJyIZjo3+2WAfIB8MUoGe4Pku0vlK4VerbCdw7lXsbVBL6G62/wdYp1xUXTm2zOXlUTtGXehgw==
X-Received: by 2002:a2e:8153:: with SMTP id t19mr2055515ljg.229.1615979659444;
        Wed, 17 Mar 2021 04:14:19 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id d13sm3354249lfi.247.2021.03.17.04.14.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 04:14:18 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 5/5] net: dsa: mv88e6xxx: Offload bridge broadcast flooding flag
In-Reply-To: <20210316093948.zbhouadshgedktcb@skbuf>
References: <20210315211400.2805330-1-tobias@waldekranz.com> <20210315211400.2805330-6-tobias@waldekranz.com> <20210316093948.zbhouadshgedktcb@skbuf>
Date:   Wed, 17 Mar 2021 12:14:18 +0100
Message-ID: <87pmzynib9.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 11:39, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Mon, Mar 15, 2021 at 10:14:00PM +0100, Tobias Waldekranz wrote:
>> These switches have two modes of classifying broadcast:
>> 
>> 1. Broadcast is multicast.
>> 2. Broadcast is its own unique thing that is always flooded
>>    everywhere.
>> 
>> This driver uses the first option, making sure to load the broadcast
>> address into all active databases. Because of this, we can support
>> per-port broadcast flooding by (1) making sure to only set the subset
>> of ports that have it enabled whenever joining a new bridge or VLAN,
>> and (2) by updating all active databases whenever the setting is
>> changed on a port.
>> 
>> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>> ---
>>  drivers/net/dsa/mv88e6xxx/chip.c | 68 +++++++++++++++++++++++++++++++-
>>  1 file changed, 67 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
>> index 48e65f22641e..e6987c501fb7 100644
>> --- a/drivers/net/dsa/mv88e6xxx/chip.c
>> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
>> @@ -1950,6 +1950,18 @@ static int mv88e6xxx_broadcast_setup(struct mv88e6xxx_chip *chip, u16 vid)
>>  	int err;
>>  
>>  	for (port = 0; port < mv88e6xxx_num_ports(chip); port++) {
>> +		struct dsa_port *dp = dsa_to_port(chip->ds, port);
>> +
>> +		if (dsa_is_unused_port(chip->ds, port))
>> +			continue;
>> +
>> +		if (dsa_is_user_port(chip->ds, port) && dp->bridge_dev &&
>> +		    !br_port_flag_is_set(dp->slave, BR_BCAST_FLOOD))
>
> What if dp->slave is not the bridge port, but a LAG? br_port_flag_is_set
> will return false.

Good point. I see two ways forward:

- My first idea was to cache a vector per switch that would act as the
  template when creating a new entry. This avoids having the driver
  layer knowing about stacked netdevs etc. But I think that Andrew is
  generally opposed to caching?

- Add a new helper at the dsa layer that takes a dp and returns the
  netdev that is attached to the bridge, if any:

  struct net_device *dsa_port_to_bridge_port(struct dsa_port *dp)

Any preference or other ideas?

> Speaking of, shouldn't mv88e6xxx_port_vlan_join also be called from
> mv88e6xxx_port_bridge_join somehow, or are we waiting for the bridge
> facility to replay VLANs added to the LAG when we emit the offload
> notification for it?

I do not think so. VLANs are always added via the .port_vlan_add
callback, no?

Potentially the bridge is of the non-filtering variety, so it could be
that no VLANs are ever added.

Or do you mean (the most confusingly named feature Marvell LinkStreet
devices) port-based VLANs? Those are setup on a bridge join via
mv88e6xxx_port_vlan_map and mv88e6xxx_pvt_map.

>> +			/* Skip bridged user ports where broadcast
>> +			 * flooding is disabled.
>> +			 */
>> +			continue;
>> +
>>  		err = mv88e6xxx_port_add_broadcast(chip, port, vid);
>>  		if (err)
>>  			return err;
>> @@ -1958,6 +1970,51 @@ static int mv88e6xxx_broadcast_setup(struct mv88e6xxx_chip *chip, u16 vid)
>>  	return 0;
>>  }
>>  
>> +struct mv88e6xxx_port_broadcast_sync_ctx {
>> +	int port;
>> +	bool flood;
>> +};
>> +
>> +static int
>> +mv88e6xxx_port_broadcast_sync_vlan(struct mv88e6xxx_chip *chip,
>> +				   const struct mv88e6xxx_vtu_entry *vlan,
>> +				   void *_ctx)
>> +{
>> +	const char broadcast[6] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
>
> MAC addresses are usually defined as unsigned char[ETH_ALEN]. You can
> also use eth_broadcast_addr(broadcast) for initialization.

I was going for uniformity with mv88e6xxx_port_add_broadcast. But I will
add a clean-up commit that fixes the existing code first, and then adds
this definition in the proper way.

>> +	struct mv88e6xxx_port_broadcast_sync_ctx *ctx = _ctx;
>> +	u8 state;
>> +
>> +	if (ctx->flood)
>> +		state = MV88E6XXX_G1_ATU_DATA_STATE_MC_STATIC;
>> +	else
>> +		state = MV88E6XXX_G1_ATU_DATA_STATE_MC_UNUSED;
>> +
>> +	return mv88e6xxx_port_db_load_purge(chip, ctx->port, broadcast,
>> +					    vlan->vid, state);
>> +}
>> +
>> +static int mv88e6xxx_port_broadcast_sync(struct mv88e6xxx_chip *chip, int port,
>> +					 bool flood)
>> +{
>> +	struct mv88e6xxx_port_broadcast_sync_ctx ctx = {
>> +		.port = port,
>> +		.flood = flood,
>> +	};
>> +	struct mv88e6xxx_vtu_entry vid0 = {
>> +		.vid = 0,
>> +	};
>> +	int err;
>> +
>> +	/* Update the port's private database... */
>> +	err = mv88e6xxx_port_broadcast_sync_vlan(chip, &vid0, &ctx);
>> +	if (err)
>> +		return err;
>> +
>> +	/* ...and the database for all VLANs. */
>> +	return mv88e6xxx_vtu_walk(chip, mv88e6xxx_port_broadcast_sync_vlan,
>> +				  &ctx);
>> +}
>> +
>>  static int mv88e6xxx_port_vlan_join(struct mv88e6xxx_chip *chip, int port,
>>  				    u16 vid, u8 member, bool warn)
>>  {
>> @@ -5431,7 +5488,8 @@ static int mv88e6xxx_port_pre_bridge_flags(struct dsa_switch *ds, int port,
>>  	struct mv88e6xxx_chip *chip = ds->priv;
>>  	const struct mv88e6xxx_ops *ops;
>>  
>> -	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD))
>> +	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
>> +			   BR_BCAST_FLOOD))
>>  		return -EINVAL;
>>  
>>  	ops = chip->info->ops;
>> @@ -5480,6 +5538,14 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
>>  			goto out;
>>  	}
>>  
>> +	if (flags.mask & BR_BCAST_FLOOD) {
>> +		bool broadcast = !!(flags.val & BR_BCAST_FLOOD);
>> +
>> +		err = mv88e6xxx_port_broadcast_sync(chip, port, broadcast);
>> +		if (err)
>> +			goto out;
>> +	}
>> +
>>  out:
>>  	mv88e6xxx_reg_unlock(chip);
>>  
>> -- 
>> 2.25.1
>> 
