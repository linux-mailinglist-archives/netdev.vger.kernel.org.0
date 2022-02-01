Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 195334A6537
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 20:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234222AbiBAT4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 14:56:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233836AbiBAT4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 14:56:37 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F8FC061714
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 11:56:36 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id a25so25650563lji.9
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 11:56:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=yxEYjQmTKXmtFqokuPdsyGGu7zMm2jstPwkFDglxHNs=;
        b=xXYrpSOMzCfR2eRAYTSd2LabmMF3zt5/ypRknIfAdtvamxh9v7NfVkA9l4EQ7JZ4kD
         5chu2JvY2pk3abjjoKA0Ef/7t05vv71vPPl+bekaXcR15OAf0YdTaWVRJMaxoqMe8a9h
         WSFV6AwZne4IlKKXjASz/0fHJtqL97q8TRfhmFLA3VPRYQTHEtB8f/wV/sjCwhEyeRs1
         ykOFwbXT+FSkmGyxa8a98S3jsnLaM7MdjtvRZuwaVqLrb+3HTcLTjc5qRhOzFpayetnl
         ONFsKZ/b7mkWG5qCE/QgO7/zbFOfYyxlaTzF+RLC7AM08Rd6aQo2swGR8b8P0vfi4wC9
         NYwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=yxEYjQmTKXmtFqokuPdsyGGu7zMm2jstPwkFDglxHNs=;
        b=7sKcslTJmT9sMHdHqTDiILNsN6/7YLVAdqhGhw/nb+XTjAviLXrtIq8H3zA9hm54HW
         rT0P1qvTxQqmFzQj6PKx/c7p7i7+NQyqbuuEfn9c2mEPq1GM8LA9l7eTHIEmtpKzMLZ8
         RJtZpZwn3ZBRhlC+28O3+0A+whqU78peT3/y1cFuwuNZpLoWRRKlGKza/uuYeO6g1lxH
         hlhDYWYPLnGiw/ljSSHxAeUh+yVh2Cwc5X6qmI2NQPjJUTwIVx4uTdkfHblyFoJpgiZR
         QhTYAmffEy1ejxKUK88dfPMcCGhZRNkktWYX7SJgXrIscCUWcZWt+6r7mrvYbcyPmGTu
         pAug==
X-Gm-Message-State: AOAM5313DqnBmHr6zV5hJsPNeaGWfIgEOzCLx57bfg3o58cmv/f+peKx
        QghimbIiKglJfJBZu42qLdLzpu4uCuB1kw==
X-Google-Smtp-Source: ABdhPJw8321bC9gFZBTyhX+uwXzYkSZj4xZR+lnIVqqrGMi7FEMDxHIpKHMxLOn7QD3WSYvTnILLlw==
X-Received: by 2002:a05:651c:105a:: with SMTP id x26mr17431569ljm.371.1643745394727;
        Tue, 01 Feb 2022 11:56:34 -0800 (PST)
Received: from wkz-x280 (h-212-85-90-115.A259.priv.bahnhof.se. [212.85.90.115])
        by smtp.gmail.com with ESMTPSA id u21sm2160109ljo.81.2022.02.01.11.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 11:56:33 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/5] net: dsa: mv88e6xxx: Improve isolation of
 standalone ports
In-Reply-To: <20220201170634.wnxy3s7f6jnmt737@skbuf>
References: <20220131154655.1614770-1-tobias@waldekranz.com>
 <20220131154655.1614770-2-tobias@waldekranz.com>
 <20220201170634.wnxy3s7f6jnmt737@skbuf>
Date:   Tue, 01 Feb 2022 20:56:32 +0100
Message-ID: <87a6fabbtb.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01, 2022 at 19:06, Vladimir Oltean <olteanv@gmail.com> wrote:
> Hi Tobias,
>
> On Mon, Jan 31, 2022 at 04:46:51PM +0100, Tobias Waldekranz wrote:
>> Clear MapDA on standalone ports to bypass any ATU lookup that might
>> point the packet in the wrong direction. This means that all packets
>> are flooded using the PVT config. So make sure that standalone ports
>> are only allowed to communicate with the CPU port.
>
> Actually "CPU port" != "upstream port" (the latter can be an
> upstream-facing DSA port). The distinction is quite important.

Yes that was sloppy of me, I'll rephrase.

>> 
>> Here is a scenario in which this is needed:
>> 
>>    CPU
>>     |     .----.
>> .---0---. | .--0--.
>> |  sw0  | | | sw1 |
>> '-1-2-3-' | '-1-2-'
>>       '---'
>> 
>> - sw0p1 and sw1p1 are bridged
>
> Do sw0p1 and sw1p1 even matter?

Strictly speaking, no - it was just to illustrate...

>> - sw0p2 and sw1p2 are in standalone mode
>> - Learning must be enabled on sw0p3 in order for hardware forwarding
>>   to work properly between bridged ports

... this point, i.e. a clear example of why learning can't be disabled
on DSA ports.

>> 1. A packet with SA :aa comes in on sw1p2
>>    1a. Egresses sw1p0
>>    1b. Ingresses sw0p3, ATU adds an entry for :aa towards port 3
>>    1c. Egresses sw0p0
>> 
>> 2. A packet with DA :aa comes in on sw0p2
>>    2a. If an ATU lookup is done at this point, the packet will be
>>        incorrectly forwarded towards sw0p3. With this change in place,
>>        the ATU is pypassed and the packet is forwarded in accordance
>
> s/pypassed/bypassed/
>
>>        whith the PVT, which only contains the CPU port.
>
> s/whith/with/
>
> What you describe is a bit convoluted, so let me try to rephrase it.
> The mv88e6xxx driver configures all standalone ports to use the same
> DefaultVID(0)/FID(0), and configures standalone user ports with no
> learning via the Port Association Vector. Shared (cascade + CPU) ports
> have learning enabled so that cross-chip bridging works without floods.
> But since learning is per port and not per FID, it means that we enable
> learning in FID 0, the one where the ATU was supposed to be always empty.
> So we may end up taking wrong forwarding decisions for standalone ports,
> notably when we should do software forwarding between ports of different
> switches. By clearing MapDA, we force standalone ports to bypass any ATU
> entries that might exist.

Are you saying you want me to replace the initial paragraph with your
version, or are you saying the the example is convoluted and should be
replaced by this text? Or is it only for the benefit of other readers?

> Question: can we disable learning per FID? I searched for this in the
> limited documentation that I have, but I didn't see such option.
> Doing this would be advantageous because we'd end up with a bit more
> space in the ATU. With your solution we're just doing damage control.

As you discovered, and as I tried to lay out in the cover, this is only
one part of the whole solution.

>> 
>> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>> ---
>>  drivers/net/dsa/mv88e6xxx/chip.c | 32 +++++++++++++++++++++++++-------
>>  drivers/net/dsa/mv88e6xxx/port.c |  7 +++++--
>>  drivers/net/dsa/mv88e6xxx/port.h |  2 +-
>>  include/net/dsa.h                | 12 ++++++++++++
>>  4 files changed, 43 insertions(+), 10 deletions(-)
>> 
>> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
>> index 1023e4549359..dde6a8d0ca36 100644
>> --- a/drivers/net/dsa/mv88e6xxx/chip.c
>> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
>> @@ -1290,8 +1290,15 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
>>  
>>  	pvlan = 0;
>>  
>> -	/* Frames from user ports can egress any local DSA links and CPU ports,
>> -	 * as well as any local member of their bridge group.
>> +	/* Frames from standalone user ports can only egress on the
>> +	 * CPU port.
>> +	 */
>> +	if (!dsa_port_bridge_dev_get(dp))
>> +		return BIT(dsa_switch_upstream_port(ds));
>> +
>> +	/* Frames from bridged user ports can egress any local DSA
>> +	 * links and CPU ports, as well as any local member of their
>> +	 * bridge group.
>>  	 */
>>  	dsa_switch_for_each_port(other_dp, ds)
>>  		if (other_dp->type == DSA_PORT_TYPE_CPU ||
>> @@ -2487,6 +2494,10 @@ static int mv88e6xxx_port_bridge_join(struct dsa_switch *ds, int port,
>>  	if (err)
>>  		goto unlock;
>>  
>> +	err = mv88e6xxx_port_set_map_da(chip, port, true);
>> +	if (err)
>> +		return err;
>> +
>>  	err = mv88e6xxx_port_commit_pvid(chip, port);
>>  	if (err)
>>  		goto unlock;
>> @@ -2521,6 +2532,12 @@ static void mv88e6xxx_port_bridge_leave(struct dsa_switch *ds, int port,
>>  	    mv88e6xxx_port_vlan_map(chip, port))
>>  		dev_err(ds->dev, "failed to remap in-chip Port VLAN\n");
>>  
>> +	err = mv88e6xxx_port_set_map_da(chip, port, false);
>> +	if (err)
>> +		dev_err(ds->dev,
>> +			"port %d failed to restore map-DA: %pe\n",
>> +			port, ERR_PTR(err));
>> +
>>  	err = mv88e6xxx_port_commit_pvid(chip, port);
>>  	if (err)
>>  		dev_err(ds->dev,
>> @@ -2918,12 +2935,13 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
>>  		return err;
>>  
>>  	/* Port Control 2: don't force a good FCS, set the MTU size to
>> -	 * 10222 bytes, disable 802.1q tags checking, don't discard tagged or
>> -	 * untagged frames on this port, do a destination address lookup on all
>> -	 * received packets as usual, disable ARP mirroring and don't send a
>> -	 * copy of all transmitted/received frames on this port to the CPU.
>> +	 * 10222 bytes, disable 802.1q tags checking, don't discard
>> +	 * tagged or untagged frames on this port, skip destination
>> +	 * address lookup on user ports, disable ARP mirroring and don't
>> +	 * send a copy of all transmitted/received frames on this port
>> +	 * to the CPU.
>>  	 */
>> -	err = mv88e6xxx_port_set_map_da(chip, port);
>> +	err = mv88e6xxx_port_set_map_da(chip, port, !dsa_is_user_port(ds, port));
>>  	if (err)
>>  		return err;
>>  
>> diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
>> index ab41619a809b..ceb450113f88 100644
>> --- a/drivers/net/dsa/mv88e6xxx/port.c
>> +++ b/drivers/net/dsa/mv88e6xxx/port.c
>> @@ -1278,7 +1278,7 @@ int mv88e6xxx_port_drop_untagged(struct mv88e6xxx_chip *chip, int port,
>>  	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL2, new);
>>  }
>>  
>> -int mv88e6xxx_port_set_map_da(struct mv88e6xxx_chip *chip, int port)
>> +int mv88e6xxx_port_set_map_da(struct mv88e6xxx_chip *chip, int port, bool map)
>>  {
>>  	u16 reg;
>>  	int err;
>> @@ -1287,7 +1287,10 @@ int mv88e6xxx_port_set_map_da(struct mv88e6xxx_chip *chip, int port)
>>  	if (err)
>>  		return err;
>>  
>> -	reg |= MV88E6XXX_PORT_CTL2_MAP_DA;
>> +	if (map)
>> +		reg |= MV88E6XXX_PORT_CTL2_MAP_DA;
>> +	else
>> +		reg &= ~MV88E6XXX_PORT_CTL2_MAP_DA;
>>  
>>  	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL2, reg);
>>  }
>> diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
>> index 03382b66f800..5c347cc58baf 100644
>> --- a/drivers/net/dsa/mv88e6xxx/port.h
>> +++ b/drivers/net/dsa/mv88e6xxx/port.h
>> @@ -425,7 +425,7 @@ int mv88e6185_port_get_cmode(struct mv88e6xxx_chip *chip, int port, u8 *cmode);
>>  int mv88e6352_port_get_cmode(struct mv88e6xxx_chip *chip, int port, u8 *cmode);
>>  int mv88e6xxx_port_drop_untagged(struct mv88e6xxx_chip *chip, int port,
>>  				 bool drop_untagged);
>> -int mv88e6xxx_port_set_map_da(struct mv88e6xxx_chip *chip, int port);
>> +int mv88e6xxx_port_set_map_da(struct mv88e6xxx_chip *chip, int port, bool map);
>>  int mv88e6095_port_set_upstream_port(struct mv88e6xxx_chip *chip, int port,
>>  				     int upstream_port);
>>  int mv88e6xxx_port_set_mirror(struct mv88e6xxx_chip *chip, int port,
>> diff --git a/include/net/dsa.h b/include/net/dsa.h
>> index 57b3e4e7413b..30f3192616e5 100644
>> --- a/include/net/dsa.h
>> +++ b/include/net/dsa.h
>> @@ -581,6 +581,18 @@ static inline bool dsa_is_upstream_port(struct dsa_switch *ds, int port)
>>  	return port == dsa_upstream_port(ds, port);
>>  }
>>  
>> +/* Return the local port used to reach the CPU port */
>> +static inline unsigned int dsa_switch_upstream_port(struct dsa_switch *ds)
>> +{
>> +	int p;
>> +
>> +	for (p = 0; p < ds->num_ports; p++)
>> +		if (!dsa_is_unused_port(ds, p))
>> +			return dsa_upstream_port(ds, p);
>
> dsa_switch_for_each_available_port
>
> Although to be honest, the caller already has a dp, I wonder why you
> need to complicate things and don't just call dsa_upstream_port(ds,
> dp->index) directly.

Because dp refers to the port we are determining the permissions _for_,
and ds refers to the chip we are configuring the PVT _on_.

I think other_dp and dp should swap names with each other. Because it is
very easy to get confused. Or maybe s/dp/remote_dp/ and s/other_dp/dp/?

>> +
>> +	return ds->num_ports;
>> +}
>> +
>>  /* Return true if @upstream_ds is an upstream switch of @downstream_ds, meaning
>>   * that the routing port from @downstream_ds to @upstream_ds is also the port
>>   * which @downstream_ds uses to reach its dedicated CPU.
>> -- 
>> 2.25.1
>> 
