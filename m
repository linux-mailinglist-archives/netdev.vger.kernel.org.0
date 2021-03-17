Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B2533EDA7
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 10:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbhCQJ6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 05:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhCQJ5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 05:57:48 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33001C06174A
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 02:57:48 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id k9so2003726lfo.12
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 02:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=k1dJdweHULzPdtza4zBDHbvN7B8ZU/O8+5mQzzcligE=;
        b=cfm0tWNPfiGia4kLNHsv6hUlQ9Tvsy+Az0w33M4BfF2L6bAcZdpGapJ6/pmObxF6VE
         K+hWit7rJPp3A0w5GcKQIWyzhUCr1LZpPZ3jWZevQDpLKBy2I44Esg1IxW9BuT1PGx70
         DZIhL8nV0WBSzryx+p6m8YB0duypKiPf2wliDOWbPKwc5nh4R4GuR4IswlYq8iXimaJs
         jvrLO7aTaUc/IKyZvJso+VL+bPBH3k7XCaKMCPKIl+jqwckfV3ujna4UUfZ5XWVcwE7C
         3ziogeIWoBjvNQTB2KFExq7b6OEtdBKuambwlCdy8Ew0JJlqRm2RziCwfb6K3sWzXSB/
         j3IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=k1dJdweHULzPdtza4zBDHbvN7B8ZU/O8+5mQzzcligE=;
        b=O3SzYNSQ5th+0aGi7ja5k1gWOMjOEnZMkEG162lTXEAHKxLo17jWqDEwOpw3svxMr7
         HBe+Jt+8DIvvRqHR1BU1/wkR0bHhOii1EUKfZShLgI9LZdCXEwfDPDQCv6Y1Ar2BlKT7
         e3Sdw8qLJLDdCs961qlB6KmcDAFuW3toJFekaVYSd1gUedJe1FPcCBtmH2U/QI3luinD
         3sz0bgrFWHpQPeQVnxacIlE/K08lg86E8xugdz8KfbT8DZo43Hm5mJjmGEwc+0gQox5C
         kTOiLDOloq0ScQQ9sflwWoZdR14EiiCXyO4yDbI/DKmy0nz3jCnsEorPyLGeJc1cXXJB
         GFIA==
X-Gm-Message-State: AOAM531UUX2bxi43T+a/T0FKsnQVHvXxWuW6g6Xk37ItiAL+qA66Wve7
        /UhA2QqvETVWPfasmQFqIRKlW75tQ8MNNlNL
X-Google-Smtp-Source: ABdhPJzcaIaBinlabU72g0x7Dk8iovWQ8T2VlGQf+sXKkEheaepPggo8A9o3rifhxfR9NeVZw8LXag==
X-Received: by 2002:ac2:4d95:: with SMTP id g21mr2013776lfe.29.1615975066437;
        Wed, 17 Mar 2021 02:57:46 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id k18sm3336234lfg.167.2021.03.17.02.57.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:57:46 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/5] net: dsa: mv88e6xxx: Offload bridge learning flag
In-Reply-To: <20210316092754.kmazxdqcefi2hlal@skbuf>
References: <20210315211400.2805330-1-tobias@waldekranz.com> <20210315211400.2805330-5-tobias@waldekranz.com> <20210316092754.kmazxdqcefi2hlal@skbuf>
Date:   Wed, 17 Mar 2021 10:57:45 +0100
Message-ID: <87sg4unluu.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 11:27, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Mon, Mar 15, 2021 at 10:13:59PM +0100, Tobias Waldekranz wrote:
>> Allow a user to control automatic learning per port.
>> 
>> Many chips have an explicit "LearningDisable"-bit that can be used for
>> this, but we opt for setting/clearing the PAV instead, as it works on
>> all devices at least as far back as 6083.
>> 
>> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>> ---
>>  drivers/net/dsa/mv88e6xxx/chip.c | 29 +++++++++++++++++++++--------
>>  drivers/net/dsa/mv88e6xxx/port.c | 21 +++++++++++++++++++++
>>  drivers/net/dsa/mv88e6xxx/port.h |  2 ++
>>  3 files changed, 44 insertions(+), 8 deletions(-)
>> 
>> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
>> index 01e4ac32d1e5..48e65f22641e 100644
>> --- a/drivers/net/dsa/mv88e6xxx/chip.c
>> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
>> @@ -2689,15 +2689,20 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
>>  			return err;
>>  	}
>>  
>> -	/* Port Association Vector: when learning source addresses
>> -	 * of packets, add the address to the address database using
>> -	 * a port bitmap that has only the bit for this port set and
>> -	 * the other bits clear.
>> +	/* Port Association Vector: disable automatic address learning
>> +	 * on all user ports since they start out in standalone
>> +	 * mode. When joining a bridge, learning will be configured to
>> +	 * match the bridge port settings. Enable learning on all
>> +	 * DSA/CPU ports. NOTE: FROM_CPU frames always bypass the
>> +	 * learning process.
>> +	 *
>> +	 * Disable HoldAt1, IntOnAgeOut, LockedPort, IgnoreWrongData,
>> +	 * and RefreshLocked. I.e. setup standard automatic learning.
>>  	 */
>> -	reg = 1 << port;
>> -	/* Disable learning for CPU port */
>> -	if (dsa_is_cpu_port(ds, port))
>> +	if (dsa_is_user_port(ds, port))
>>  		reg = 0;
>> +	else
>> +		reg = 1 << port;
>>  
>>  	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_ASSOC_VECTOR,
>>  				   reg);
>
> Can this be refactored to use mv88e6xxx_port_set_assoc_vector too?

That was my initial thought as well. But this write also ensures that
the other learning related settings are in a known state. So I settled
for leaving the raw write, but I made sure to document that we depend on
the values of the other flags (second paragraph).

>> @@ -5426,7 +5431,7 @@ static int mv88e6xxx_port_pre_bridge_flags(struct dsa_switch *ds, int port,
>>  	struct mv88e6xxx_chip *chip = ds->priv;
>>  	const struct mv88e6xxx_ops *ops;
>>  
>> -	if (flags.mask & ~(BR_FLOOD | BR_MCAST_FLOOD))
>> +	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD))
>>  		return -EINVAL;
>>  
>>  	ops = chip->info->ops;
>> @@ -5449,6 +5454,14 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
>>  
>>  	mv88e6xxx_reg_lock(chip);
>>  
>> +	if (flags.mask & BR_LEARNING) {
>> +		u16 pav = (flags.val & BR_LEARNING) ? (1 << port) : 0;
>> +
>> +		err = mv88e6xxx_port_set_assoc_vector(chip, port, pav);
>> +		if (err)
>> +			goto out;
>> +	}
>> +
>>  	if (flags.mask & BR_FLOOD) {
>>  		bool unicast = !!(flags.val & BR_FLOOD);
>>  
>> diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
>> index 4561f289ab76..d716cd61b6c6 100644
>> --- a/drivers/net/dsa/mv88e6xxx/port.c
>> +++ b/drivers/net/dsa/mv88e6xxx/port.c
>> @@ -1171,6 +1171,27 @@ int mv88e6097_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port)
>>  				    0x0001);
>>  }
>>  
>> +/* Offset 0x0B: Port Association Vector */
>> +
>> +int mv88e6xxx_port_set_assoc_vector(struct mv88e6xxx_chip *chip, int port,
>> +				    u16 pav)
>> +{
>> +	u16 reg, mask;
>> +	int err;
>> +
>> +	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_ASSOC_VECTOR,
>> +				  &reg);
>> +	if (err)
>> +		return err;
>> +
>> +	mask = GENMASK(mv88e6xxx_num_ports(chip), 0);
>
> mv88e6xxx_num_ports(chip) - 1, maybe?

Ahh thanks. This made me think that there should be a helper for this;
turns out Vivien added mv88e6xxx_port_mask four years ago :)

>> +	reg &= ~mask;
>> +	reg |= pav & mask;
>> +
>> +	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_ASSOC_VECTOR,
>> +				    reg);
>> +}
>> +
>>  /* Offset 0x0C: Port ATU Control */
>>  
>>  int mv88e6xxx_port_disable_learn_limit(struct mv88e6xxx_chip *chip, int port)
>> diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
>> index e6d0eaa6aa1d..635b6571a0e9 100644
>> --- a/drivers/net/dsa/mv88e6xxx/port.h
>> +++ b/drivers/net/dsa/mv88e6xxx/port.h
>> @@ -361,6 +361,8 @@ int mv88e6165_port_set_jumbo_size(struct mv88e6xxx_chip *chip, int port,
>>  				  size_t size);
>>  int mv88e6095_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port);
>>  int mv88e6097_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port);
>> +int mv88e6xxx_port_set_assoc_vector(struct mv88e6xxx_chip *chip, int port,
>> +				    u16 pav);
>>  int mv88e6097_port_pause_limit(struct mv88e6xxx_chip *chip, int port, u8 in,
>>  			       u8 out);
>>  int mv88e6390_port_pause_limit(struct mv88e6xxx_chip *chip, int port, u8 in,
>> -- 
>> 2.25.1
>> 
