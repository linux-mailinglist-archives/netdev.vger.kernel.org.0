Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7377464BF5F
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 23:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236653AbiLMWdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 17:33:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236287AbiLMWdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 17:33:40 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC46E0D2;
        Tue, 13 Dec 2022 14:33:39 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id x2so89312plb.13;
        Tue, 13 Dec 2022 14:33:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PP9ucYsaEoZ+pvDx1OGBMJFbmIqIAA2BGr8ZTcAHZL4=;
        b=BB61ozcIEsLC7IVg8BbzGtg0rnjlfvWJwR/oU+KOxvw0heW02/vUoqPZtDi+SGK/fJ
         s8iqYp/2i0WPAI6/vAvPtA1mrWR6J9p4PqfkCkHOXe4H1o8HGMgEeKwr6TQECIN9NsNq
         2fC3w35CbKRY9eLsOhggnHQU/S8kuwKCkZFbqwMEuV/AeJ982QQTeHr2vBnQg22Mmtps
         ynXexnSB0SFTLqgMhWfE9I8l4EPWTNDim7mzujUPoF5nJ8wGXvhbeyjw9o94KmeXBJy4
         jSkQni3KQZYGzqQeX8DRXCzM4+uxTAEiPFZlLvh6+4Bbt+uStmFvdMzdjZVC9WdwVymy
         Q/Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PP9ucYsaEoZ+pvDx1OGBMJFbmIqIAA2BGr8ZTcAHZL4=;
        b=yQFSh3J1F1g48A1/sLQo3KNPsstlT7kRpj8lzN60hjU9j+Y+j6+dy3TVOsBBnkLgt7
         b/XClDzmOfUm6jc8avsPpBGC3Pjv6BXbIiQk0DRU2Hs11o4UBeHta783XVUtnNPpSPq8
         kMwzdu6xz/CK4f+2KLTFIuVX2d81E5Rcg5VuVTh9IEgxsYJy76ukqrOUhwfO8wDeFJVx
         qnpCG82MHv++wwbDQUJoHiR3nqVPRf38zRBNdEak7OZ07tLnaogRzUo9l8eoM/QsBQg9
         RpJHkgDj6ti723ja09WDLZY4lhljixN+et4UK3eCEBh0ZStM8JcRFKOnOxP6E60awg6s
         l2Cw==
X-Gm-Message-State: AFqh2krm+huYlLfGhPXdZ1KauiiIVl3wWeJao1C3FW7Pjn3Oe46bw7eN
        wKFCaSdyk2b3Jrd85h7b3Co=
X-Google-Smtp-Source: AMrXdXtECKG4z+Ncdzfy9t6nbY3MzI7S4kj8fT35auMsx4QfrSPOTdx3z8Xf5eyhf2gXtSNk2CLbWw==
X-Received: by 2002:a17:902:eb91:b0:190:e424:f4f2 with SMTP id q17-20020a170902eb9100b00190e424f4f2mr767662plg.40.1670970819146;
        Tue, 13 Dec 2022 14:33:39 -0800 (PST)
Received: from [192.168.0.128] ([98.97.42.38])
        by smtp.googlemail.com with ESMTPSA id l7-20020a170903244700b001894198d0ebsm419294pls.24.2022.12.13.14.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 14:33:38 -0800 (PST)
Message-ID: <1c170e455b884bf41f3360b17b1e5e4f7c83c5a4.camel@gmail.com>
Subject: Re: [PATCH v2 net-next 3/3] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     "Hans J. Schultz" <netdev@kapio-technology.com>,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Date:   Tue, 13 Dec 2022 14:33:37 -0800
In-Reply-To: <20221213174650.670767-4-netdev@kapio-technology.com>
References: <20221213174650.670767-1-netdev@kapio-technology.com>
         <20221213174650.670767-4-netdev@kapio-technology.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-12-13 at 18:46 +0100, Hans J. Schultz wrote:
> This implementation for the Marvell mv88e6xxx chip series, is based on
> handling ATU miss violations occurring when packets ingress on a port
> that is locked with learning on. This will trigger a
> SWITCHDEV_FDB_ADD_TO_BRIDGE event, which will result in the bridge module
> adding a locked FDB entry. This bridge FDB entry will not age out as
> it has the extern_learn flag set.
>=20
> Userspace daemons can listen to these events and either accept or deny
> access for the host, by either replacing the locked FDB entry with a
> simple entry or leave the locked entry.
>=20
> If the host MAC address is already present on another port, a ATU
> member violation will occur, but to no real effect, and the packet will
> be dropped in hardware. Statistics on these violations can be shown with
> the command and example output of interest:
>=20
> ethtool -S ethX
> NIC statistics:
> ...
>      atu_member_violation: 5
>      atu_miss_violation: 23
> ...
>=20
> Where ethX is the interface of the MAB enabled port.
>=20
> Furthermore, as added vlan interfaces where the vid is not added to the
> VTU will cause ATU miss violations reporting the FID as
> MV88E6XXX_FID_STANDALONE, we need to check and skip the miss violations
> handling in this case.
>=20
> Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
> ---
>  drivers/net/dsa/mv88e6xxx/Makefile      |  1 +
>  drivers/net/dsa/mv88e6xxx/chip.c        | 18 ++++--
>  drivers/net/dsa/mv88e6xxx/chip.h        | 15 +++++
>  drivers/net/dsa/mv88e6xxx/global1_atu.c |  8 +++
>  drivers/net/dsa/mv88e6xxx/switchdev.c   | 83 +++++++++++++++++++++++++
>  drivers/net/dsa/mv88e6xxx/switchdev.h   | 19 ++++++
>  6 files changed, 138 insertions(+), 6 deletions(-)
>  create mode 100644 drivers/net/dsa/mv88e6xxx/switchdev.c
>  create mode 100644 drivers/net/dsa/mv88e6xxx/switchdev.h
>=20
> diff --git a/drivers/net/dsa/mv88e6xxx/Makefile b/drivers/net/dsa/mv88e6x=
xx/Makefile
> index 49bf358b9c4f..1409e691ab77 100644
> --- a/drivers/net/dsa/mv88e6xxx/Makefile
> +++ b/drivers/net/dsa/mv88e6xxx/Makefile
> @@ -15,6 +15,7 @@ mv88e6xxx-objs +=3D port_hidden.o
>  mv88e6xxx-$(CONFIG_NET_DSA_MV88E6XXX_PTP) +=3D ptp.o
>  mv88e6xxx-objs +=3D serdes.o
>  mv88e6xxx-objs +=3D smi.o
> +mv88e6xxx-objs +=3D switchdev.o
>  mv88e6xxx-objs +=3D trace.o
> =20
>  # for tracing framework to find trace.h
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx=
/chip.c
> index d5930b287db4..2682c2b29346 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -1729,11 +1729,11 @@ static int mv88e6xxx_vtu_get(struct mv88e6xxx_chi=
p *chip, u16 vid,
>  	return err;
>  }
> =20
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
>  	struct mv88e6xxx_vtu_entry entry =3D {
>  		.vid =3D mv88e6xxx_max_vid(chip),
> @@ -6527,7 +6527,7 @@ static int mv88e6xxx_port_pre_bridge_flags(struct d=
sa_switch *ds, int port,
>  	const struct mv88e6xxx_ops *ops;
> =20
>  	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
> -			   BR_BCAST_FLOOD | BR_PORT_LOCKED))
> +			   BR_BCAST_FLOOD | BR_PORT_LOCKED | BR_PORT_MAB))
>  		return -EINVAL;
> =20
>  	ops =3D chip->info->ops;
> @@ -6585,6 +6585,12 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_=
switch *ds, int port,
>  			goto out;
>  	}
> =20
> +	if (flags.mask & BR_PORT_MAB) {
> +		bool mab =3D !!(flags.val & BR_PORT_MAB);
> +
> +		mv88e6xxx_port_set_mab(chip, port, mab);
> +	}
> +
>  	if (flags.mask & BR_PORT_LOCKED) {
>  		bool locked =3D !!(flags.val & BR_PORT_LOCKED);
> =20
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx=
/chip.h
> index e693154cf803..f635a5bb47ce 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.h
> +++ b/drivers/net/dsa/mv88e6xxx/chip.h
> @@ -280,6 +280,9 @@ struct mv88e6xxx_port {
>  	unsigned int serdes_irq;
>  	char serdes_irq_name[64];
>  	struct devlink_region *region;
> +
> +	/* MacAuth Bypass control flag */
> +	bool mab;
>  };
> =20
>  enum mv88e6xxx_region_id {
> @@ -784,6 +787,12 @@ static inline bool mv88e6xxx_is_invalid_port(struct =
mv88e6xxx_chip *chip, int po
>  	return (chip->info->invalid_port_mask & BIT(port)) !=3D 0;
>  }
> =20
> +static inline void mv88e6xxx_port_set_mab(struct mv88e6xxx_chip *chip,
> +					  int port, bool mab)
> +{
> +	chip->ports[port].mab =3D mab;
> +}
> +
>  int mv88e6xxx_read(struct mv88e6xxx_chip *chip, int addr, int reg, u16 *=
val);
>  int mv88e6xxx_write(struct mv88e6xxx_chip *chip, int addr, int reg, u16 =
val);
>  int mv88e6xxx_wait_mask(struct mv88e6xxx_chip *chip, int addr, int reg,
> @@ -802,6 +811,12 @@ static inline void mv88e6xxx_reg_unlock(struct mv88e=
6xxx_chip *chip)
>  	mutex_unlock(&chip->reg_lock);
>  }
> =20
> +int mv88e6xxx_vtu_walk(struct mv88e6xxx_chip *chip,
> +		       int (*cb)(struct mv88e6xxx_chip *chip,
> +				 const struct mv88e6xxx_vtu_entry *entry,
> +				 void *priv),
> +		       void *priv);
> +
>  int mv88e6xxx_fid_map(struct mv88e6xxx_chip *chip, unsigned long *bitmap=
);
> =20
>  #endif /* _MV88E6XXX_CHIP_H */
> diff --git a/drivers/net/dsa/mv88e6xxx/global1_atu.c b/drivers/net/dsa/mv=
88e6xxx/global1_atu.c
> index 34203e112eef..fc020161b7cf 100644
> --- a/drivers/net/dsa/mv88e6xxx/global1_atu.c
> +++ b/drivers/net/dsa/mv88e6xxx/global1_atu.c
> @@ -12,6 +12,7 @@
> =20
>  #include "chip.h"
>  #include "global1.h"
> +#include "switchdev.h"
>  #include "trace.h"
> =20
>  /* Offset 0x01: ATU FID Register */
> @@ -443,6 +444,13 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_=
fn(int irq, void *dev_id)
>  						   entry.portvec, entry.mac,
>  						   fid);
>  		chip->ports[spid].atu_miss_violation++;
> +
> +		if (fid !=3D MV88E6XXX_FID_STANDALONE && chip->ports[spid].mab) {
> +			err =3D mv88e6xxx_handle_miss_violation(chip, spid,
> +							      &entry, fid);
> +			if (err)
> +				goto out;
> +		}
>  	}
> =20
>  	if (val & MV88E6XXX_G1_ATU_OP_FULL_VIOLATION) {

In your earlier patch you had made it sound like you were encountering
an issue with the existing code. Now I realize that this is what you
needed to move the lock for. You might call that out in your earlier
patch as the description made it sound like it was solving an existing
deadlock instead of one that could be introduced with this change.

> diff --git a/drivers/net/dsa/mv88e6xxx/switchdev.c b/drivers/net/dsa/mv88=
e6xxx/switchdev.c
> new file mode 100644
> index 000000000000..4c346a884fb2
> --- /dev/null
> +++ b/drivers/net/dsa/mv88e6xxx/switchdev.c
> @@ -0,0 +1,83 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * switchdev.c
> + *
> + *	Authors:
> + *	Hans J. Schultz		<netdev@kapio-technology.com>
> + *
> + */
> +
> +#include <net/switchdev.h>
> +#include "chip.h"
> +#include "global1.h"
> +#include "switchdev.h"
> +
> +struct mv88e6xxx_fid_search_ctx {
> +	u16 fid_search;
> +	u16 vid_found;
> +};
> +
> +static int __mv88e6xxx_find_vid(struct mv88e6xxx_chip *chip,
> +				const struct mv88e6xxx_vtu_entry *entry,
> +				void *priv)
> +{
> +	struct mv88e6xxx_fid_search_ctx *ctx =3D priv;
> +
> +	if (ctx->fid_search =3D=3D entry->fid) {
> +		ctx->vid_found =3D entry->vid;
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +static int mv88e6xxx_find_vid(struct mv88e6xxx_chip *chip, u16 fid, u16 =
*vid)
> +{
> +	struct mv88e6xxx_fid_search_ctx ctx;
> +	int err;
> +
> +	ctx.fid_search =3D fid;
> +	mv88e6xxx_reg_lock(chip);
> +	err =3D mv88e6xxx_vtu_walk(chip, __mv88e6xxx_find_vid, &ctx);
> +	mv88e6xxx_reg_unlock(chip);
> +	if (err < 0)
> +		return err;
> +	if (err =3D=3D 1)
> +		*vid =3D ctx.vid_found;
> +	else
> +		return -ENOENT;
> +
> +	return 0;
> +}
> +
> +int mv88e6xxx_handle_miss_violation(struct mv88e6xxx_chip *chip, int por=
t,
> +				    struct mv88e6xxx_atu_entry *entry, u16 fid)
> +{
> +	struct switchdev_notifier_fdb_info info =3D {
> +		.addr =3D entry->mac,
> +		.locked =3D true,
> +	};
> +	struct net_device *brport;
> +	struct dsa_port *dp;
> +	u16 vid;
> +	int err;
> +
> +	err =3D mv88e6xxx_find_vid(chip, fid, &vid);
> +	if (err)
> +		return err;
> +
> +	info.vid =3D vid;
> +	dp =3D dsa_to_port(chip->ds, port);
> +
> +	rtnl_lock();
> +	brport =3D dsa_port_to_bridge_port(dp);
> +	if (!brport) {
> +		rtnl_unlock();
> +		return -ENODEV;
> +	}
> +	err =3D call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_BRIDGE,
> +				       brport, &info.info, NULL);
> +	rtnl_unlock();
> +
> +	return err;
> +}
> diff --git a/drivers/net/dsa/mv88e6xxx/switchdev.h b/drivers/net/dsa/mv88=
e6xxx/switchdev.h
> new file mode 100644
> index 000000000000..62214f9d62b0
> --- /dev/null
> +++ b/drivers/net/dsa/mv88e6xxx/switchdev.h
> @@ -0,0 +1,19 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later
> + *
> + * switchdev.h
> + *
> + *	Authors:
> + *	Hans J. Schultz		<netdev@kapio-technology.com>
> + *
> + */
> +
> +#ifndef _MV88E6XXX_SWITCHDEV_H_
> +#define _MV88E6XXX_SWITCHDEV_H_
> +
> +#include "chip.h"
> +
> +int mv88e6xxx_handle_miss_violation(struct mv88e6xxx_chip *chip, int por=
t,
> +				    struct mv88e6xxx_atu_entry *entry,
> +				    u16 fid);
> +
> +#endif /* _MV88E6XXX_SWITCHDEV_H_ */

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

