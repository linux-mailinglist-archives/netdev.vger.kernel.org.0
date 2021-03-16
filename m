Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE1333D0F2
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 10:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbhCPJkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 05:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232168AbhCPJjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 05:39:51 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09447C06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 02:39:51 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id ox4so55362585ejb.11
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 02:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Tna6kLybFtR5yNA0H0XTS6aV3qDTK7Fs4EjFLfj6BIc=;
        b=RgIbgHWX0Y1oZrpq5L1bHwRyf9AcZaPyFqxseO59MJr1A25AnO2whzg2nwpmZ+VIjf
         vYCMt308W9Qc4ZBErEeNmiTJlicdGtXFZjWvY4wG6QWdkMwhTq0ttkwAIZw1yUKFveUe
         TQi3ewhWn+u8lFanhYDj2eyr212+a1TfMaO8q7/EM4mRgx6alzfsul9aObVdujzCNnGq
         rBFbDaTKPe6PxFA/nMEStKLCNCv6u14WmrsDdY/hScLHYUcJ8SHeCPDKeAw57LZCuJdt
         mbzdJt1GginCE8AhE+VjxdwgSj0b4k1jjuIjM61eoCDeW30RZC/UhcGSMPFos3Zj5szm
         JwqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Tna6kLybFtR5yNA0H0XTS6aV3qDTK7Fs4EjFLfj6BIc=;
        b=P6puyK3czNctfsQZBhrhMUW2IhgYeZYaqRDao5e7VQasoXsm36IAYEJtVbogHVAogm
         XNN2qwdikoUOzqFaXWb1b758UCN1cY8FFGR3gwfO7mZSUqVwGQAnDZ9bK0M9uI7JdYAb
         JvLuLtkV4/r1qmFshs53nEE3v4EiZLnEgklozMvKp8K1g8lJlSbR5u9irfi0EZZz3QBL
         DthvEY4YUZGmKVzOfsLLLF9Ayf7J+Wmm48bD5xIAI72wD7elQ+e4Oczl3bBg28lN4AAJ
         1nXfIZNiiOGA559oI7NYw0L+Gbnn1cdGhSZviW7DDe+PH50DYYOSP4O8qnNRZyVYHJZi
         5AAA==
X-Gm-Message-State: AOAM5304nj8kPg2FczoHFCAskghNQP4iYJakbiKpIpe4XK8T5fN/BfqU
        epnSlrxTtDi0sycBMDtfZgU=
X-Google-Smtp-Source: ABdhPJw+uDyZpBrlN/vg9mH8su+kEcS7IGXRBXqz0dbF0P1dOFk1w8T7JYaQAY2y6IPkFZVDjI9Frg==
X-Received: by 2002:a17:906:5a8f:: with SMTP id l15mr28767495ejq.462.1615887589793;
        Tue, 16 Mar 2021 02:39:49 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id z17sm9143691eju.27.2021.03.16.02.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 02:39:49 -0700 (PDT)
Date:   Tue, 16 Mar 2021 11:39:48 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 5/5] net: dsa: mv88e6xxx: Offload bridge
 broadcast flooding flag
Message-ID: <20210316093948.zbhouadshgedktcb@skbuf>
References: <20210315211400.2805330-1-tobias@waldekranz.com>
 <20210315211400.2805330-6-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315211400.2805330-6-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 15, 2021 at 10:14:00PM +0100, Tobias Waldekranz wrote:
> These switches have two modes of classifying broadcast:
> 
> 1. Broadcast is multicast.
> 2. Broadcast is its own unique thing that is always flooded
>    everywhere.
> 
> This driver uses the first option, making sure to load the broadcast
> address into all active databases. Because of this, we can support
> per-port broadcast flooding by (1) making sure to only set the subset
> of ports that have it enabled whenever joining a new bridge or VLAN,
> and (2) by updating all active databases whenever the setting is
> changed on a port.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 68 +++++++++++++++++++++++++++++++-
>  1 file changed, 67 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 48e65f22641e..e6987c501fb7 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -1950,6 +1950,18 @@ static int mv88e6xxx_broadcast_setup(struct mv88e6xxx_chip *chip, u16 vid)
>  	int err;
>  
>  	for (port = 0; port < mv88e6xxx_num_ports(chip); port++) {
> +		struct dsa_port *dp = dsa_to_port(chip->ds, port);
> +
> +		if (dsa_is_unused_port(chip->ds, port))
> +			continue;
> +
> +		if (dsa_is_user_port(chip->ds, port) && dp->bridge_dev &&
> +		    !br_port_flag_is_set(dp->slave, BR_BCAST_FLOOD))

What if dp->slave is not the bridge port, but a LAG? br_port_flag_is_set
will return false.

Speaking of, shouldn't mv88e6xxx_port_vlan_join also be called from
mv88e6xxx_port_bridge_join somehow, or are we waiting for the bridge
facility to replay VLANs added to the LAG when we emit the offload
notification for it?

> +			/* Skip bridged user ports where broadcast
> +			 * flooding is disabled.
> +			 */
> +			continue;
> +
>  		err = mv88e6xxx_port_add_broadcast(chip, port, vid);
>  		if (err)
>  			return err;
> @@ -1958,6 +1970,51 @@ static int mv88e6xxx_broadcast_setup(struct mv88e6xxx_chip *chip, u16 vid)
>  	return 0;
>  }
>  
> +struct mv88e6xxx_port_broadcast_sync_ctx {
> +	int port;
> +	bool flood;
> +};
> +
> +static int
> +mv88e6xxx_port_broadcast_sync_vlan(struct mv88e6xxx_chip *chip,
> +				   const struct mv88e6xxx_vtu_entry *vlan,
> +				   void *_ctx)
> +{
> +	const char broadcast[6] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };

MAC addresses are usually defined as unsigned char[ETH_ALEN]. You can
also use eth_broadcast_addr(broadcast) for initialization.

> +	struct mv88e6xxx_port_broadcast_sync_ctx *ctx = _ctx;
> +	u8 state;
> +
> +	if (ctx->flood)
> +		state = MV88E6XXX_G1_ATU_DATA_STATE_MC_STATIC;
> +	else
> +		state = MV88E6XXX_G1_ATU_DATA_STATE_MC_UNUSED;
> +
> +	return mv88e6xxx_port_db_load_purge(chip, ctx->port, broadcast,
> +					    vlan->vid, state);
> +}
> +
> +static int mv88e6xxx_port_broadcast_sync(struct mv88e6xxx_chip *chip, int port,
> +					 bool flood)
> +{
> +	struct mv88e6xxx_port_broadcast_sync_ctx ctx = {
> +		.port = port,
> +		.flood = flood,
> +	};
> +	struct mv88e6xxx_vtu_entry vid0 = {
> +		.vid = 0,
> +	};
> +	int err;
> +
> +	/* Update the port's private database... */
> +	err = mv88e6xxx_port_broadcast_sync_vlan(chip, &vid0, &ctx);
> +	if (err)
> +		return err;
> +
> +	/* ...and the database for all VLANs. */
> +	return mv88e6xxx_vtu_walk(chip, mv88e6xxx_port_broadcast_sync_vlan,
> +				  &ctx);
> +}
> +
>  static int mv88e6xxx_port_vlan_join(struct mv88e6xxx_chip *chip, int port,
>  				    u16 vid, u8 member, bool warn)
>  {
> @@ -5431,7 +5488,8 @@ static int mv88e6xxx_port_pre_bridge_flags(struct dsa_switch *ds, int port,
>  	struct mv88e6xxx_chip *chip = ds->priv;
>  	const struct mv88e6xxx_ops *ops;
>  
> -	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD))
> +	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
> +			   BR_BCAST_FLOOD))
>  		return -EINVAL;
>  
>  	ops = chip->info->ops;
> @@ -5480,6 +5538,14 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
>  			goto out;
>  	}
>  
> +	if (flags.mask & BR_BCAST_FLOOD) {
> +		bool broadcast = !!(flags.val & BR_BCAST_FLOOD);
> +
> +		err = mv88e6xxx_port_broadcast_sync(chip, port, broadcast);
> +		if (err)
> +			goto out;
> +	}
> +
>  out:
>  	mv88e6xxx_reg_unlock(chip);
>  
> -- 
> 2.25.1
> 
