Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC1C44A61E6
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 18:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241420AbiBARGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 12:06:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbiBARGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 12:06:39 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A15CC061714;
        Tue,  1 Feb 2022 09:06:38 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id me13so56303977ejb.12;
        Tue, 01 Feb 2022 09:06:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8e+cxsOAoD4wNMf4OwhcmsqMgJkqG3wiGoLyD7fqu/g=;
        b=InNOyM08H7YL/I26IDo0bEZ6tgouuU9ALxGxDQzuD4qXtdUfY2pkwg5V8ZMPuCr5xD
         PATNvojFwuEcr9N/sdfAsKHqDk6c5NL9C+EMErHZ2QxepE+9C1v1fCrAg+2Hj2lXCBQR
         O+wvg5NI56u/QikA51uNhJnasmMuI+Se0dRrx3cX2RlRplC4Ct2ZqcmsUiO1bMRNv1C+
         hMeNBTCkg+bEX8wVlFFrpLB5XL4jTUZp+/R0lRS5H0eSbuNK17XVFwaW6Ei4I6juvvnk
         dAeIHFJqssmrGWDsP6TXtM/I/OJ7188kuml9qRAdAdIRDbYKW/pKOtPSVhNhwztCvnZq
         3FWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8e+cxsOAoD4wNMf4OwhcmsqMgJkqG3wiGoLyD7fqu/g=;
        b=W9spf5zxwkX9Sfy6q6jZ74Tx+77BYqIa4w8il+atCEXZIuvp+LX8OhvbciaW/giq2I
         7KbSZsSdG/DDZSio91Ijg1t1dxBvqBWzd8qy5y2yX9T3oh/NYrsTKOz6iLvpAnSxPEfV
         JWWZ1FGiXx8Kw1Og86QOOud6EwKWac8ouiQtbICuwZ5tlW2+OzpV1rO9G6iS0ZBUly/Q
         HbbNtfgsUQEat8j4CSfUTAL95h8o17AIgdFUVvz33X4R1fNWevLQo5YtHGdCwBD2tHpv
         Q6GGZ7+kSB4AbNayQmyiTU8Wo+tOjk5HLX9Hq++Ge0s0JAg3ICOS3Gasn7ToxWQxADLI
         R/fg==
X-Gm-Message-State: AOAM532+aLu6phx+WuPr6SuNJn0PULiS44TER+1xQH+S7k0egGvyMUaJ
        npPEm1OzeAsWdLufWiI0WZYPcsD9QzI=
X-Google-Smtp-Source: ABdhPJymqnXI4V9i32WmqWx4KQk5uxFdvNeXHzg6ysgfcqGCLOeyZe4YosHk7AnSKGnlo0qjefuOUg==
X-Received: by 2002:a17:907:629f:: with SMTP id nd31mr5838675ejc.693.1643735196655;
        Tue, 01 Feb 2022 09:06:36 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id r10sm14947171ejy.148.2022.02.01.09.06.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 09:06:36 -0800 (PST)
Date:   Tue, 1 Feb 2022 19:06:34 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/5] net: dsa: mv88e6xxx: Improve isolation of
 standalone ports
Message-ID: <20220201170634.wnxy3s7f6jnmt737@skbuf>
References: <20220131154655.1614770-1-tobias@waldekranz.com>
 <20220131154655.1614770-2-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220131154655.1614770-2-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tobias,

On Mon, Jan 31, 2022 at 04:46:51PM +0100, Tobias Waldekranz wrote:
> Clear MapDA on standalone ports to bypass any ATU lookup that might
> point the packet in the wrong direction. This means that all packets
> are flooded using the PVT config. So make sure that standalone ports
> are only allowed to communicate with the CPU port.

Actually "CPU port" != "upstream port" (the latter can be an
upstream-facing DSA port). The distinction is quite important.

> 
> Here is a scenario in which this is needed:
> 
>    CPU
>     |     .----.
> .---0---. | .--0--.
> |  sw0  | | | sw1 |
> '-1-2-3-' | '-1-2-'
>       '---'
> 
> - sw0p1 and sw1p1 are bridged

Do sw0p1 and sw1p1 even matter?

> - sw0p2 and sw1p2 are in standalone mode
> - Learning must be enabled on sw0p3 in order for hardware forwarding
>   to work properly between bridged ports
> 
> 1. A packet with SA :aa comes in on sw1p2
>    1a. Egresses sw1p0
>    1b. Ingresses sw0p3, ATU adds an entry for :aa towards port 3
>    1c. Egresses sw0p0
> 
> 2. A packet with DA :aa comes in on sw0p2
>    2a. If an ATU lookup is done at this point, the packet will be
>        incorrectly forwarded towards sw0p3. With this change in place,
>        the ATU is pypassed and the packet is forwarded in accordance

s/pypassed/bypassed/

>        whith the PVT, which only contains the CPU port.

s/whith/with/

What you describe is a bit convoluted, so let me try to rephrase it.
The mv88e6xxx driver configures all standalone ports to use the same
DefaultVID(0)/FID(0), and configures standalone user ports with no
learning via the Port Association Vector. Shared (cascade + CPU) ports
have learning enabled so that cross-chip bridging works without floods.
But since learning is per port and not per FID, it means that we enable
learning in FID 0, the one where the ATU was supposed to be always empty.
So we may end up taking wrong forwarding decisions for standalone ports,
notably when we should do software forwarding between ports of different
switches. By clearing MapDA, we force standalone ports to bypass any ATU
entries that might exist.

Question: can we disable learning per FID? I searched for this in the
limited documentation that I have, but I didn't see such option.
Doing this would be advantageous because we'd end up with a bit more
space in the ATU. With your solution we're just doing damage control.

> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 32 +++++++++++++++++++++++++-------
>  drivers/net/dsa/mv88e6xxx/port.c |  7 +++++--
>  drivers/net/dsa/mv88e6xxx/port.h |  2 +-
>  include/net/dsa.h                | 12 ++++++++++++
>  4 files changed, 43 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 1023e4549359..dde6a8d0ca36 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -1290,8 +1290,15 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
>  
>  	pvlan = 0;
>  
> -	/* Frames from user ports can egress any local DSA links and CPU ports,
> -	 * as well as any local member of their bridge group.
> +	/* Frames from standalone user ports can only egress on the
> +	 * CPU port.
> +	 */
> +	if (!dsa_port_bridge_dev_get(dp))
> +		return BIT(dsa_switch_upstream_port(ds));
> +
> +	/* Frames from bridged user ports can egress any local DSA
> +	 * links and CPU ports, as well as any local member of their
> +	 * bridge group.
>  	 */
>  	dsa_switch_for_each_port(other_dp, ds)
>  		if (other_dp->type == DSA_PORT_TYPE_CPU ||
> @@ -2487,6 +2494,10 @@ static int mv88e6xxx_port_bridge_join(struct dsa_switch *ds, int port,
>  	if (err)
>  		goto unlock;
>  
> +	err = mv88e6xxx_port_set_map_da(chip, port, true);
> +	if (err)
> +		return err;
> +
>  	err = mv88e6xxx_port_commit_pvid(chip, port);
>  	if (err)
>  		goto unlock;
> @@ -2521,6 +2532,12 @@ static void mv88e6xxx_port_bridge_leave(struct dsa_switch *ds, int port,
>  	    mv88e6xxx_port_vlan_map(chip, port))
>  		dev_err(ds->dev, "failed to remap in-chip Port VLAN\n");
>  
> +	err = mv88e6xxx_port_set_map_da(chip, port, false);
> +	if (err)
> +		dev_err(ds->dev,
> +			"port %d failed to restore map-DA: %pe\n",
> +			port, ERR_PTR(err));
> +
>  	err = mv88e6xxx_port_commit_pvid(chip, port);
>  	if (err)
>  		dev_err(ds->dev,
> @@ -2918,12 +2935,13 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
>  		return err;
>  
>  	/* Port Control 2: don't force a good FCS, set the MTU size to
> -	 * 10222 bytes, disable 802.1q tags checking, don't discard tagged or
> -	 * untagged frames on this port, do a destination address lookup on all
> -	 * received packets as usual, disable ARP mirroring and don't send a
> -	 * copy of all transmitted/received frames on this port to the CPU.
> +	 * 10222 bytes, disable 802.1q tags checking, don't discard
> +	 * tagged or untagged frames on this port, skip destination
> +	 * address lookup on user ports, disable ARP mirroring and don't
> +	 * send a copy of all transmitted/received frames on this port
> +	 * to the CPU.
>  	 */
> -	err = mv88e6xxx_port_set_map_da(chip, port);
> +	err = mv88e6xxx_port_set_map_da(chip, port, !dsa_is_user_port(ds, port));
>  	if (err)
>  		return err;
>  
> diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
> index ab41619a809b..ceb450113f88 100644
> --- a/drivers/net/dsa/mv88e6xxx/port.c
> +++ b/drivers/net/dsa/mv88e6xxx/port.c
> @@ -1278,7 +1278,7 @@ int mv88e6xxx_port_drop_untagged(struct mv88e6xxx_chip *chip, int port,
>  	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL2, new);
>  }
>  
> -int mv88e6xxx_port_set_map_da(struct mv88e6xxx_chip *chip, int port)
> +int mv88e6xxx_port_set_map_da(struct mv88e6xxx_chip *chip, int port, bool map)
>  {
>  	u16 reg;
>  	int err;
> @@ -1287,7 +1287,10 @@ int mv88e6xxx_port_set_map_da(struct mv88e6xxx_chip *chip, int port)
>  	if (err)
>  		return err;
>  
> -	reg |= MV88E6XXX_PORT_CTL2_MAP_DA;
> +	if (map)
> +		reg |= MV88E6XXX_PORT_CTL2_MAP_DA;
> +	else
> +		reg &= ~MV88E6XXX_PORT_CTL2_MAP_DA;
>  
>  	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL2, reg);
>  }
> diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
> index 03382b66f800..5c347cc58baf 100644
> --- a/drivers/net/dsa/mv88e6xxx/port.h
> +++ b/drivers/net/dsa/mv88e6xxx/port.h
> @@ -425,7 +425,7 @@ int mv88e6185_port_get_cmode(struct mv88e6xxx_chip *chip, int port, u8 *cmode);
>  int mv88e6352_port_get_cmode(struct mv88e6xxx_chip *chip, int port, u8 *cmode);
>  int mv88e6xxx_port_drop_untagged(struct mv88e6xxx_chip *chip, int port,
>  				 bool drop_untagged);
> -int mv88e6xxx_port_set_map_da(struct mv88e6xxx_chip *chip, int port);
> +int mv88e6xxx_port_set_map_da(struct mv88e6xxx_chip *chip, int port, bool map);
>  int mv88e6095_port_set_upstream_port(struct mv88e6xxx_chip *chip, int port,
>  				     int upstream_port);
>  int mv88e6xxx_port_set_mirror(struct mv88e6xxx_chip *chip, int port,
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 57b3e4e7413b..30f3192616e5 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -581,6 +581,18 @@ static inline bool dsa_is_upstream_port(struct dsa_switch *ds, int port)
>  	return port == dsa_upstream_port(ds, port);
>  }
>  
> +/* Return the local port used to reach the CPU port */
> +static inline unsigned int dsa_switch_upstream_port(struct dsa_switch *ds)
> +{
> +	int p;
> +
> +	for (p = 0; p < ds->num_ports; p++)
> +		if (!dsa_is_unused_port(ds, p))
> +			return dsa_upstream_port(ds, p);

dsa_switch_for_each_available_port

Although to be honest, the caller already has a dp, I wonder why you
need to complicate things and don't just call dsa_upstream_port(ds,
dp->index) directly.

> +
> +	return ds->num_ports;
> +}
> +
>  /* Return true if @upstream_ds is an upstream switch of @downstream_ds, meaning
>   * that the routing port from @downstream_ds to @upstream_ds is also the port
>   * which @downstream_ds uses to reach its dedicated CPU.
> -- 
> 2.25.1
> 

