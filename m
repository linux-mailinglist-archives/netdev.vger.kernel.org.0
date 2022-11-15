Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 326A362AE2C
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 23:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbiKOWXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 17:23:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiKOWXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 17:23:18 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307A912AC4;
        Tue, 15 Nov 2022 14:23:17 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id i21so24006078edj.10;
        Tue, 15 Nov 2022 14:23:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JURBertVP27Eg4CVxm/vsn/duQxrB9XpxVgNVwAYkyw=;
        b=gcGRJyjWy0oLA0mrbhngAAzsBfZvIJgljI2iFPO1A5Ak27AtWjkUAvx+5a2S4aoT1m
         r07ZyOp+cwpN5YQGSN5b6d1NfYzBpKlGEX2LFjQWzrQvnYsyShbau+T2EL2i0Fd3FPCo
         XibSCaoX0f5Z5nvTl8HQJpNBmmCwLSKEqPHAUk84L/AIrU1Nr2vD+wK4R1HkJUilRdD3
         pPUVU9hW1adr6VQ6l3eJMmIiVxExWrzkQbUmLzsCiohnoilUVjbkVVC/xbyFzIe3xfEw
         9P7acMSE4/vOFsDGAOjDB9Qomtf8bh4wyWnxQY6fsgV3zVTkWrvAdqBVuoSxXiCPvtJ3
         31WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JURBertVP27Eg4CVxm/vsn/duQxrB9XpxVgNVwAYkyw=;
        b=dYzTYiqRzqKGw5IZqIBDojF3g41MyFeg2Fi0yYOKrfoYtN1vqXwhb+dKhZ0C9l7+gc
         U0dVaO/YjRgGz1XbQyuYMjpqNxFDWaR50Q6VdZiTQxDQ/A7RZZsBUag1C8vdhZ+wvwT/
         UX6rKxIQ/3TcbG8fSjgzq+mkaakN5EpMCZXyrkADtIYc7XTZbSvz+qvAitLFpT+GLcwp
         1s+Nq7PMBd6qoRs62G3MhN65Lw+t2cSaBmnHKgh+yU2uKHUjDXIdJkq58VjH+cHh/YxF
         Vk0n90LFHt6yCnCm8aBdd36l6/tl0WLb3tBzw32IGnXkHcpABK1blUpE1SW/LFS214ws
         Jg3w==
X-Gm-Message-State: ANoB5pliWrHnZXTAU5bznDji9GVRp0RY336wB42b2UcXTQbrfbqUSZsn
        9yopIgYJzfeH6a5HAyjNjGw=
X-Google-Smtp-Source: AA0mqf5vdSTAKyCUfHAGfAhhPtxw7OvinfGZyG9d9uJwh37d2v/elgqgFepGStnooFznGGijmF+Fpg==
X-Received: by 2002:a50:fb03:0:b0:467:621f:879e with SMTP id d3-20020a50fb03000000b00467621f879emr16711420edq.380.1668550995513;
        Tue, 15 Nov 2022 14:23:15 -0800 (PST)
Received: from skbuf ([188.26.57.19])
        by smtp.gmail.com with ESMTPSA id kw26-20020a170907771a00b00781d411a63csm6010415ejc.151.2022.11.15.14.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 14:23:15 -0800 (PST)
Date:   Wed, 16 Nov 2022 00:23:12 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Hans J. Schultz" <netdev@kapio-technology.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 net-next 2/2] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
Message-ID: <20221115222312.lix6xpvddjbsmoac@skbuf>
References: <20221112203748.68995-1-netdev@kapio-technology.com>
 <20221112203748.68995-1-netdev@kapio-technology.com>
 <20221112203748.68995-3-netdev@kapio-technology.com>
 <20221112203748.68995-3-netdev@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221112203748.68995-3-netdev@kapio-technology.com>
 <20221112203748.68995-3-netdev@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 12, 2022 at 09:37:48PM +0100, Hans J. Schultz wrote:
> This implementation for the Marvell mv88e6xxx chip series, is based on
> handling ATU miss violations occurring when packets ingress on a port
> that is locked with learning on. This will trigger a
> SWITCHDEV_FDB_ADD_TO_BRIDGE event, that wil incurr the bridge module,

"wil incurr" wants to be what?

> to add a locked FDB entry. This bridge FDB entry will not age out as
> it has the extern_learn flag set.
> 
> Userspace daemons can listen to these events and either accept or deny
> access for the host, by either replacing the locked FDB entry with a
> simple entry or leave the locked entry.
> 
> If the host MAC address is already present on another port, a ATU
> member violation will occur, but to no real effect. Statistics on these
> violations can be shown with the command and example output of interest:
> 
> NIC statistics:
> ...
>      atu_member_violation: 36
>      atu_miss_violation: 23
> ...
> 
> Where ethX is the interface of the MAB enabled port.
> 
> Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
> ---
>  drivers/net/dsa/mv88e6xxx/Makefile      |  1 +
>  drivers/net/dsa/mv88e6xxx/chip.c        | 19 ++++--
>  drivers/net/dsa/mv88e6xxx/chip.h        | 10 ++++
>  drivers/net/dsa/mv88e6xxx/global1_atu.c | 10 +++-
>  drivers/net/dsa/mv88e6xxx/port.h        |  6 ++
>  drivers/net/dsa/mv88e6xxx/switchdev.c   | 77 +++++++++++++++++++++++++
>  drivers/net/dsa/mv88e6xxx/switchdev.h   | 19 ++++++

How much (and what) do you plan to add to switchdev.{c,h} in the future?
It's a bit arbitrary to put only mv88e6xxx_handle_violation() in a file
called switchdev.c.

port_fdb_add(), port_mdb_add(), port_vlan_add(), port_vlan_filtering(),
etc etc, are all switchdev things. Anyway.

>  7 files changed, 135 insertions(+), 7 deletions(-)
>  create mode 100644 drivers/net/dsa/mv88e6xxx/switchdev.c
>  create mode 100644 drivers/net/dsa/mv88e6xxx/switchdev.h
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/Makefile b/drivers/net/dsa/mv88e6xxx/Makefile
> index c8eca2b6f959..be903a983780 100644
> --- a/drivers/net/dsa/mv88e6xxx/Makefile
> +++ b/drivers/net/dsa/mv88e6xxx/Makefile
> @@ -15,3 +15,4 @@ mv88e6xxx-objs += port_hidden.o
>  mv88e6xxx-$(CONFIG_NET_DSA_MV88E6XXX_PTP) += ptp.o
>  mv88e6xxx-objs += serdes.o
>  mv88e6xxx-objs += smi.o
> +mv88e6xxx-objs += switchdev.o
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index ccfa4751d3b7..efc0085a5616 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -1726,11 +1726,11 @@ static int mv88e6xxx_vtu_get(struct mv88e6xxx_chip *chip, u16 vid,
>  	return err;
>  }
>  
> -static int mv88e6xxx_vtu_walk(struct mv88e6xxx_chip *chip,
> -			      int (*cb)(struct mv88e6xxx_chip *chip,
> -					const struct mv88e6xxx_vtu_entry *entry,
> -					void *priv),
> -			      void *priv)
> +int mv88e6xxx_vtu_walk(struct mv88e6xxx_chip *chip,
> +		       int (*cb)(struct mv88e6xxx_chip *chip,
> +				 const struct mv88e6xxx_vtu_entry *entry,
> +				 void *priv),
> +		       void *priv)
>  {
>  	struct mv88e6xxx_vtu_entry entry = {
>  		.vid = mv88e6xxx_max_vid(chip),
> @@ -6524,7 +6524,7 @@ static int mv88e6xxx_port_pre_bridge_flags(struct dsa_switch *ds, int port,
>  	const struct mv88e6xxx_ops *ops;
>  
>  	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
> -			   BR_BCAST_FLOOD | BR_PORT_LOCKED))
> +			   BR_BCAST_FLOOD | BR_PORT_LOCKED | BR_PORT_MAB))
>  		return -EINVAL;
>  
>  	ops = chip->info->ops;
> @@ -6582,12 +6582,19 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
>  			goto out;
>  	}
>  
> +	if (flags.mask & BR_PORT_MAB) {
> +		chip->ports[port].mab = !!(flags.val & BR_PORT_MAB);
> +		err = 0;

Please make a separate patch which replaces "int err = -EOPNOTSUPP;" as the beginning
of mv88e6xxx_port_bridge_flags() with "err = 0". Please explain that the
-EOPNOTSUPP dates since commit 4f85901f0063 ("net: dsa: mv88e6xxx: add
support for bridge flags") as a return code for the "port_egress_floods()"
DSA method, but the DSA API changed in commit a8b659e7ff75 ("net: dsa:
act as passthrough for bridge port flags"). With the API change,
returning -EOPNOTSUPP from port_bridge_flags() is ignored; what's
important is to return -EINVAL for unsupported operations from the
port_pre_bridge_flags() method. Since the mv88e6xxx driver does that,
there will never appear a situation where it must reject making a change
to an unsupported flag in port_bridge_flags().

After you make that change, please create a superficial wrapper function
called "mv88e6xxx_port_set_mab()", similar to the rest of this function's
structure.

> +	}
> +
>  	if (flags.mask & BR_PORT_LOCKED) {
>  		bool locked = !!(flags.val & BR_PORT_LOCKED);
>  
>  		err = mv88e6xxx_port_set_lock(chip, port, locked);
>  		if (err)
>  			goto out;
> +
> +		chip->ports[port].locked = locked;

The driver is not using this flag.

>  	}
>  out:
>  	mv88e6xxx_reg_unlock(chip);
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
> index e693154cf803..3b951cd0e6f8 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.h
> +++ b/drivers/net/dsa/mv88e6xxx/chip.h
> @@ -280,6 +280,10 @@ struct mv88e6xxx_port {
>  	unsigned int serdes_irq;
>  	char serdes_irq_name[64];
>  	struct devlink_region *region;
> +
> +	/* Locked port and MacAuth control flags */

Can you please be consistent and call MAB MAC Authentication Bypass?
I mean, "bypass" is the most important part of what goes on, and you
just omit it.

> +	bool locked;
> +	bool mab;
>  };
>  
>  enum mv88e6xxx_region_id {
> @@ -802,6 +806,12 @@ static inline void mv88e6xxx_reg_unlock(struct mv88e6xxx_chip *chip)
>  	mutex_unlock(&chip->reg_lock);
>  }
>  
> +int mv88e6xxx_vtu_walk(struct mv88e6xxx_chip *chip,
> +		       int (*cb)(struct mv88e6xxx_chip *chip,
> +				 const struct mv88e6xxx_vtu_entry *entry,
> +				 void *priv),
> +		       void *priv);
> +
>  int mv88e6xxx_fid_map(struct mv88e6xxx_chip *chip, unsigned long *bitmap);
>  
>  #endif /* _MV88E6XXX_CHIP_H */
> diff --git a/drivers/net/dsa/mv88e6xxx/global1_atu.c b/drivers/net/dsa/mv88e6xxx/global1_atu.c
> index 8a874b6fc8e1..0a57f4e7dd46 100644
> --- a/drivers/net/dsa/mv88e6xxx/global1_atu.c
> +++ b/drivers/net/dsa/mv88e6xxx/global1_atu.c
> @@ -12,6 +12,7 @@
>  
>  #include "chip.h"
>  #include "global1.h"
> +#include "switchdev.h"
>  
>  /* Offset 0x01: ATU FID Register */
>  
> @@ -426,6 +427,8 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
>  	if (err)
>  		goto out;
>  
> +	mv88e6xxx_reg_unlock(chip);
> +

I concur with Ido's suggestion to split up changes which are only
tangentially related as preparatory patches, with the motivation which
you explained over email as the commit message. Also, the current "out"
label needs to become something like "out_unlock", and a new "out"
created, for the error path jumps below, that don't have the register
lock held.

>  	spid = entry.state;
>  
>  	if (val & MV88E6XXX_G1_ATU_OP_AGE_OUT_VIOLATION) {
> @@ -446,6 +449,12 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
>  				    "ATU miss violation for %pM portvec %x spid %d\n",
>  				    entry.mac, entry.portvec, spid);
>  		chip->ports[spid].atu_miss_violation++;
> +
> +		if (fid && chip->ports[spid].mab)
> +			err = mv88e6xxx_handle_violation(chip, spid, &entry,
> +							 fid, MV88E6XXX_G1_ATU_OP_MISS_VIOLATION);

The check for non-zero FID looks strange until one considers that FID 0
is MV88E6XXX_FID_STANDALONE. But then again, since only standalone ports
use FID 0 and standalone ports cannot have the MAB/locked feature enabled,
I consider the check to be redundant. We should know for sure that the
FID is non-zero.

> +		if (err)
> +			goto out;

Did the "if (err)" test belong to the same code block as the
mv88e6xxx_handle_violation() call above it?

>  	}
>  
>  	if (val & MV88E6XXX_G1_ATU_OP_FULL_VIOLATION) {
> @@ -454,7 +463,6 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
>  				    entry.mac, entry.portvec, spid);
>  		chip->ports[spid].atu_full_violation++;
>  	}
> -	mv88e6xxx_reg_unlock(chip);
>  
>  	return IRQ_HANDLED;
>  
> diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
> index aec9d4fd20e3..bd90a02865a0 100644
> --- a/drivers/net/dsa/mv88e6xxx/port.h
> +++ b/drivers/net/dsa/mv88e6xxx/port.h
> @@ -377,6 +377,12 @@ int mv88e6xxx_port_set_pvid(struct mv88e6xxx_chip *chip, int port, u16 pvid);
>  int mv88e6xxx_port_set_lock(struct mv88e6xxx_chip *chip, int port,
>  			    bool locked);
>  
> +static inline bool mv88e6xxx_port_is_locked(struct mv88e6xxx_chip *chip,
> +					    int port)

As commented above, it looks like you can delete this and the "locked"
field in the port structure.

> +{
> +	return chip->ports[port].locked;
> +}
> +
>  int mv88e6xxx_port_set_8021q_mode(struct mv88e6xxx_chip *chip, int port,
>  				  u16 mode);
>  int mv88e6095_port_tag_remap(struct mv88e6xxx_chip *chip, int port);
> diff --git a/drivers/net/dsa/mv88e6xxx/switchdev.c b/drivers/net/dsa/mv88e6xxx/switchdev.c
> new file mode 100644
> index 000000000000..000778550532
> --- /dev/null
> +++ b/drivers/net/dsa/mv88e6xxx/switchdev.c
> @@ -0,0 +1,77 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * switchdev.c
> + *
> + *	Authors:
> + *	Hans J. Schultz		<hans.schultz@westermo.com>
> + *
> + */
> +
> +#include <net/switchdev.h>
> +#include "chip.h"
> +#include "global1.h"
> +
> +struct mv88e6xxx_fid_search_ctx {
> +	u16 fid_search;
> +	u16 vid_found;
> +};
> +
> +static int mv88e6xxx_find_vid(struct mv88e6xxx_chip *chip,
> +			      const struct mv88e6xxx_vtu_entry *entry,
> +			      void *priv)
> +{
> +	struct mv88e6xxx_fid_search_ctx *ctx = priv;
> +
> +	if (ctx->fid_search == entry->fid) {
> +		ctx->vid_found = entry->vid;
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +int mv88e6xxx_handle_violation(struct mv88e6xxx_chip *chip, int port,
> +			       struct mv88e6xxx_atu_entry *entry,
> +			       u16 fid, u16 type)
> +{
> +	struct switchdev_notifier_fdb_info info = {
> +		.addr = entry->mac,
> +		.locked = true,
> +	};
> +	struct mv88e6xxx_fid_search_ctx ctx;
> +	struct net_device *brport;
> +	struct dsa_port *dp;
> +	int err;
> +
> +	if (mv88e6xxx_is_invalid_port(chip, port))

Can it ever happen that the switch reports a violation for an invalid
port, or is it absurdly defensive programming? According to struct
mv88e6xxx_info, invalid_port_mask "is required for example for the
MV88E6220 (which is in general a MV88E6250 with 7 ports) but the ports
2-4 are not routet [sic] to pins." So my understanding is that the
driver does not probe at all if invalid ports are being declared in the
device tree.

> +		return -ENODEV;
> +
> +	ctx.fid_search = fid;
> +	mv88e6xxx_reg_lock(chip);
> +	err = mv88e6xxx_vtu_walk(chip, mv88e6xxx_find_vid, &ctx);
> +	mv88e6xxx_reg_unlock(chip);
> +	if (err < 0)
> +		return err;
> +	if (err == 1)
> +		info.vid = ctx.vid_found;
> +	else
> +		return -ENODATA;

ENOENT maybe?

> +
> +	switch (type) {
> +	case MV88E6XXX_G1_ATU_OP_MISS_VIOLATION:

Is it beneficial in any way to pass the violation type to
mv88e6xxx_handle_violation(), considering that we only call it from the
"miss" code path, and if we were to call it with something else ("member"),
it would return a strange error code (1)?

I don't necessarily see any way in which we'll need to handle the
"member" (migration, right?) violation any different in the future,
except ignore it, either.

> +		dp = dsa_to_port(chip->ds, port);
> +
> +		rtnl_lock();
> +		brport = dsa_port_to_bridge_port(dp);
> +		if (!brport) {
> +			rtnl_unlock();
> +			return -ENODEV;
> +		}
> +		err = call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_BRIDGE,
> +					       brport, &info.info, NULL);
> +		rtnl_unlock();
> +		break;
> +	}
> +
> +	return err;
> +}
> diff --git a/drivers/net/dsa/mv88e6xxx/switchdev.h b/drivers/net/dsa/mv88e6xxx/switchdev.h
> new file mode 100644
> index 000000000000..ccc10a9d4072
> --- /dev/null
> +++ b/drivers/net/dsa/mv88e6xxx/switchdev.h
> @@ -0,0 +1,19 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later
> + *
> + * switchdev.h
> + *
> + *	Authors:
> + *	Hans J. Schultz		<hans.schultz@westermo.com>
> + *
> + */
> +
> +#ifndef DRIVERS_NET_DSA_MV88E6XXX_SWITCHDEV_H_
> +#define DRIVERS_NET_DSA_MV88E6XXX_SWITCHDEV_H_

If it's going to turn out that keeping switchdev.{c,h} is worth it,
can you please at least integrate with the coding conventions in the
rest of the driver?

The other header pragmas in the mv88e6xxx are:

#ifndef _MV88E6XXX_CHIP_H
#define _MV88E6XXX_CHIP_H

#ifndef _MV88E6XXX_DEVLINK_H
#define _MV88E6XXX_DEVLINK_H

#ifndef _MV88E6XXX_GLOBAL1_H
#define _MV88E6XXX_GLOBAL1_H

#ifndef _MV88E6XXX_GLOBAL2_H
#define _MV88E6XXX_GLOBAL2_H

#ifndef _MV88E6XXX_HWTSTAMP_H
#define _MV88E6XXX_HWTSTAMP_H

#ifndef _MV88E6XXX_PHY_H
#define _MV88E6XXX_PHY_H

#ifndef _MV88E6XXX_PORT_H
#define _MV88E6XXX_PORT_H

#ifndef _MV88E6XXX_PTP_H
#define _MV88E6XXX_PTP_H

#ifndef _MV88E6XXX_SERDES_H
#define _MV88E6XXX_SERDES_H

#ifndef _MV88E6XXX_SMI_H
#define _MV88E6XXX_SMI_H

Notice a pattern?

> +
> +#include "chip.h"
> +
> +int mv88e6xxx_handle_violation(struct mv88e6xxx_chip *chip, int port,
> +			       struct mv88e6xxx_atu_entry *entry,
> +			       u16 fid, u16 type);
> +
> +#endif /* DRIVERS_NET_DSA_MV88E6XXX_SWITCHDEV_H_ */
> -- 
> 2.34.1
> 

