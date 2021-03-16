Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C9F33D0CC
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 10:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236292AbhCPJ2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 05:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236251AbhCPJ15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 05:27:57 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C38DC06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 02:27:57 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id bx7so20620615edb.12
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 02:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=e6iAQE9zpoUlFnNWsr4KvH5Vx9sibXGZNmFCf1qqS+U=;
        b=N9/Ou22Gd8RXks6lvpuDoTtwRXoxun5iw46JABw1dm7Pe7d5WDhOeLRk0f6d23sFcp
         1C7/fhnDACpjysJjuVoMsWOOrQxZ99fbRMnIzSt+T+RWLjxJs5lbeOsM2e4nxXrnPPt+
         ashYqGnSbHozRnW+Uc94pg3XOZK9CQtYaswVgHagsCyVJMKiC+eSCnyk9ovKj2xXhlsv
         dsx4DlCEYiZuers7cMQcRaD+ptxhR8j2B0y+jMShpIDT+4uJ9ll9Ika2DJoo+VU+YdI9
         auLn5ZlaJqku7BjruwC/GU6dJOktfIfvM3CYaYLLGRWjTO7B3DCmQtBxj/gQoK2P1CBT
         VNzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=e6iAQE9zpoUlFnNWsr4KvH5Vx9sibXGZNmFCf1qqS+U=;
        b=MISLSCiCASIbj+mnEBL0PsQQnInrTUGVKgFM0seX6AaYZRPzsinTlGx9WUOoTlXnw5
         eDc7tjEvAMKVEVr9pULaMK+P1aa6OpmFCvB1ffO5t/Bp+S3/nphDzm799w+6vbozMf6d
         lrvvDiNouJqQoOQZdBejjOt6ZAL+V+CSYORWAT0a3ryQEj7xvv8XvyGqvSwA894dBL+i
         kD7eEqQWDTTJCpf4FqRWn5ncZZ/3V3ABxYalvyoE0KELX/WjX9MQoaFP25Ib2iyQ8KL5
         KHrQajYUwFeb68r4Yzl7sn7zbwL2TCqMIIHXuKJRw6kyaZBXODdRY49VVG+D4k3OuKOq
         RJ/w==
X-Gm-Message-State: AOAM533/zmEkdAm5FooCJC7Cwy9ritLnLGWmMOb/kRiHhsR1FqQPK7MQ
        7vyMoIB7iuF2EQdXnXRpGHg=
X-Google-Smtp-Source: ABdhPJyUO/HCfGJp59vke0CpDeHyEyawxMbG9Ko5Bv0f3nwn/vl1BvzLZ/1WWjvVP+EGk42zjs7OnA==
X-Received: by 2002:a50:ed96:: with SMTP id h22mr23700614edr.39.1615886876061;
        Tue, 16 Mar 2021 02:27:56 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id z9sm10398641edr.75.2021.03.16.02.27.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 02:27:55 -0700 (PDT)
Date:   Tue, 16 Mar 2021 11:27:54 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/5] net: dsa: mv88e6xxx: Offload bridge
 learning flag
Message-ID: <20210316092754.kmazxdqcefi2hlal@skbuf>
References: <20210315211400.2805330-1-tobias@waldekranz.com>
 <20210315211400.2805330-5-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315211400.2805330-5-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 15, 2021 at 10:13:59PM +0100, Tobias Waldekranz wrote:
> Allow a user to control automatic learning per port.
> 
> Many chips have an explicit "LearningDisable"-bit that can be used for
> this, but we opt for setting/clearing the PAV instead, as it works on
> all devices at least as far back as 6083.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 29 +++++++++++++++++++++--------
>  drivers/net/dsa/mv88e6xxx/port.c | 21 +++++++++++++++++++++
>  drivers/net/dsa/mv88e6xxx/port.h |  2 ++
>  3 files changed, 44 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 01e4ac32d1e5..48e65f22641e 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -2689,15 +2689,20 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
>  			return err;
>  	}
>  
> -	/* Port Association Vector: when learning source addresses
> -	 * of packets, add the address to the address database using
> -	 * a port bitmap that has only the bit for this port set and
> -	 * the other bits clear.
> +	/* Port Association Vector: disable automatic address learning
> +	 * on all user ports since they start out in standalone
> +	 * mode. When joining a bridge, learning will be configured to
> +	 * match the bridge port settings. Enable learning on all
> +	 * DSA/CPU ports. NOTE: FROM_CPU frames always bypass the
> +	 * learning process.
> +	 *
> +	 * Disable HoldAt1, IntOnAgeOut, LockedPort, IgnoreWrongData,
> +	 * and RefreshLocked. I.e. setup standard automatic learning.
>  	 */
> -	reg = 1 << port;
> -	/* Disable learning for CPU port */
> -	if (dsa_is_cpu_port(ds, port))
> +	if (dsa_is_user_port(ds, port))
>  		reg = 0;
> +	else
> +		reg = 1 << port;
>  
>  	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_ASSOC_VECTOR,
>  				   reg);

Can this be refactored to use mv88e6xxx_port_set_assoc_vector too?

> @@ -5426,7 +5431,7 @@ static int mv88e6xxx_port_pre_bridge_flags(struct dsa_switch *ds, int port,
>  	struct mv88e6xxx_chip *chip = ds->priv;
>  	const struct mv88e6xxx_ops *ops;
>  
> -	if (flags.mask & ~(BR_FLOOD | BR_MCAST_FLOOD))
> +	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD))
>  		return -EINVAL;
>  
>  	ops = chip->info->ops;
> @@ -5449,6 +5454,14 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
>  
>  	mv88e6xxx_reg_lock(chip);
>  
> +	if (flags.mask & BR_LEARNING) {
> +		u16 pav = (flags.val & BR_LEARNING) ? (1 << port) : 0;
> +
> +		err = mv88e6xxx_port_set_assoc_vector(chip, port, pav);
> +		if (err)
> +			goto out;
> +	}
> +
>  	if (flags.mask & BR_FLOOD) {
>  		bool unicast = !!(flags.val & BR_FLOOD);
>  
> diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
> index 4561f289ab76..d716cd61b6c6 100644
> --- a/drivers/net/dsa/mv88e6xxx/port.c
> +++ b/drivers/net/dsa/mv88e6xxx/port.c
> @@ -1171,6 +1171,27 @@ int mv88e6097_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port)
>  				    0x0001);
>  }
>  
> +/* Offset 0x0B: Port Association Vector */
> +
> +int mv88e6xxx_port_set_assoc_vector(struct mv88e6xxx_chip *chip, int port,
> +				    u16 pav)
> +{
> +	u16 reg, mask;
> +	int err;
> +
> +	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_ASSOC_VECTOR,
> +				  &reg);
> +	if (err)
> +		return err;
> +
> +	mask = GENMASK(mv88e6xxx_num_ports(chip), 0);

mv88e6xxx_num_ports(chip) - 1, maybe?

> +	reg &= ~mask;
> +	reg |= pav & mask;
> +
> +	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_ASSOC_VECTOR,
> +				    reg);
> +}
> +
>  /* Offset 0x0C: Port ATU Control */
>  
>  int mv88e6xxx_port_disable_learn_limit(struct mv88e6xxx_chip *chip, int port)
> diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
> index e6d0eaa6aa1d..635b6571a0e9 100644
> --- a/drivers/net/dsa/mv88e6xxx/port.h
> +++ b/drivers/net/dsa/mv88e6xxx/port.h
> @@ -361,6 +361,8 @@ int mv88e6165_port_set_jumbo_size(struct mv88e6xxx_chip *chip, int port,
>  				  size_t size);
>  int mv88e6095_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port);
>  int mv88e6097_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port);
> +int mv88e6xxx_port_set_assoc_vector(struct mv88e6xxx_chip *chip, int port,
> +				    u16 pav);
>  int mv88e6097_port_pause_limit(struct mv88e6xxx_chip *chip, int port, u8 in,
>  			       u8 out);
>  int mv88e6390_port_pause_limit(struct mv88e6xxx_chip *chip, int port, u8 in,
> -- 
> 2.25.1
> 
