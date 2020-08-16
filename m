Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF932459CC
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 00:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729377AbgHPWMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 18:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgHPWMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 18:12:09 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BFBAC061786
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 15:12:09 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id c10so10796777edk.6
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 15:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FDcLxexKZKLwgoxK0Sy+rvVbOQMh3hDHVKo1TiBrh/o=;
        b=PnhJ9eoMrZ3E+O84TIIRQ0rgLcfGEiTblyMwMR1zcPlPJkZW1MyDSGn7Fg7yfH1P4r
         4300OHz6xhANfOZt2pInBCn2UIVGWelSaGbPNu89hS1yiYzqtuxwSdp4mI4V5BFTVpd9
         /JPH0KKZmJ9bEsI/JjP8BzVNkwEZPbsrkbRnAneuZH3tziodXIEGOq0TlGFitSuqp7Fc
         rhHRH9oX7nZ1EGar6G4m6mgto7w1sx6rjpLjONeKorYSRaExBhoRKmFsCOgj2EH7d8pc
         A9zUKRPQcXU3Oz0hOBzw2b8IVTIiptHE4W554ObqNqyi++1mH4oZ8YDWhamTEEHcqZvU
         28oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FDcLxexKZKLwgoxK0Sy+rvVbOQMh3hDHVKo1TiBrh/o=;
        b=SzBizcXXuS3rbI1uICtqgA9R9Yy6jn8o4Tl2IO3bZO9XWNfwxParENmfSU1dM5VO1i
         Zt6d3FMPw+GwPrD8O/rPAEYamfOAEIoS7GvQpBR5SlwCGnI3gb+PzJvltzPJIDNMVu/P
         ojsipzmnJIP/bvxu0jebO+AfBhK3RmssR8CUfxf/q1oplBdJIy36ToHCf1R5Jpb11OLX
         z/CIUSzP2OMe0aMa/DRa2WYpyHVRDElkJZA4k2uO1MSg09aOmoxU8EFGXcDQbxXHtXT3
         i4NMVIIFIcdQsm6reF8ocador2M6ixu15VaiyBqLX+hnW5DZQG5jxlevj38IHiHWxxta
         caIg==
X-Gm-Message-State: AOAM531ecRjzFxNmg535qzR7AMyh3ssQ1g304AIZu3dwojtiXrs2sl2q
        C03Z3p+XeY3OmoVkR6okcgDt+QqULVw=
X-Google-Smtp-Source: ABdhPJx3eDOc1jMxrY0zwu8m8b9jkHhLft9WRtTjFqLPpVu45f6j0hKkQxvKJvoy6ji4yx90PbL9+A==
X-Received: by 2002:a05:6402:8c3:: with SMTP id d3mr12567583edz.187.1597615928156;
        Sun, 16 Aug 2020 15:12:08 -0700 (PDT)
Received: from skbuf ([86.126.22.216])
        by smtp.gmail.com with ESMTPSA id c2sm10446670edl.28.2020.08.16.15.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2020 15:12:07 -0700 (PDT)
Date:   Mon, 17 Aug 2020 01:12:05 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 5/7] net: dsa: mv88e6xxx: Add devlink regions
Message-ID: <20200816221205.mspo63dohn7pvxg4@skbuf>
References: <20200816194316.2291489-1-andrew@lunn.ch>
 <20200816194316.2291489-6-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200816194316.2291489-6-andrew@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 16, 2020 at 09:43:14PM +0200, Andrew Lunn wrote:
> Allow ports, the global registers, and the ATU to be snapshot via
> devlink regions.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c    |  14 +-
>  drivers/net/dsa/mv88e6xxx/chip.h    |  12 +
>  drivers/net/dsa/mv88e6xxx/devlink.c | 413 ++++++++++++++++++++++++++++
>  drivers/net/dsa/mv88e6xxx/devlink.h |   2 +
>  4 files changed, 440 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 2b3ddf2bfcea..33e4518736a2 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -2838,6 +2838,7 @@ static void mv88e6xxx_teardown(struct dsa_switch *ds)
>  {
>  	mv88e6xxx_teardown_devlink_params(ds);
>  	dsa_devlink_resources_unregister(ds);
> +	mv88e6xxx_teardown_devlink_regions(ds);
>  }
>  
>  static int mv88e6xxx_setup(struct dsa_switch *ds)
> @@ -2970,7 +2971,18 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
>  
>  	err = mv88e6xxx_setup_devlink_params(ds);
>  	if (err)
> -		dsa_devlink_resources_unregister(ds);
> +		goto out_resources;
> +
> +	err = mv88e6xxx_setup_devlink_regions(ds);
> +	if (err)
> +		goto out_params;
> +
> +	return 0;
> +
> +out_params:
> +	mv88e6xxx_teardown_devlink_params(ds);
> +out_resources:
> +	dsa_devlink_resources_unregister(ds);
>  
>  	return err;
>  }
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
> index 77d81aa99f37..d8bd211afcec 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.h
> +++ b/drivers/net/dsa/mv88e6xxx/chip.h
> @@ -238,6 +238,15 @@ struct mv88e6xxx_port {
>  	bool mirror_egress;
>  	unsigned int serdes_irq;
>  	char serdes_irq_name[64];
> +	struct devlink_region *region;
> +};
> +
> +enum mv88e6xxx_region_id {
> +	MV88E6XXX_REGION_GLOBAL1 = 0,
> +	MV88E6XXX_REGION_GLOBAL2,
> +	MV88E6XXX_REGION_ATU,
> +
> +	_MV88E6XXX_REGION_MAX,
>  };
>  
>  struct mv88e6xxx_chip {
> @@ -334,6 +343,9 @@ struct mv88e6xxx_chip {
>  
>  	/* Array of port structures. */
>  	struct mv88e6xxx_port ports[DSA_MAX_PORTS];
> +
> +	/* devlink regions */
> +	struct devlink_region *regions[_MV88E6XXX_REGION_MAX];
>  };
>  
>  struct mv88e6xxx_bus_ops {
> diff --git a/drivers/net/dsa/mv88e6xxx/devlink.c b/drivers/net/dsa/mv88e6xxx/devlink.c
> index 91e02024c5cf..c6ebadcfa63f 100644
> --- a/drivers/net/dsa/mv88e6xxx/devlink.c
> +++ b/drivers/net/dsa/mv88e6xxx/devlink.c
> @@ -5,6 +5,7 @@
>  #include "devlink.h"
>  #include "global1.h"
>  #include "global2.h"
> +#include "port.h"
>  
>  static int mv88e6xxx_atu_get_hash(struct mv88e6xxx_chip *chip, u8 *hash)
>  {
> @@ -33,6 +34,8 @@ int mv88e6xxx_devlink_param_get(struct dsa_switch *ds, u32 id,
>  	struct mv88e6xxx_chip *chip = ds->priv;
>  	int err;
>  
> +	dev_info(ds->dev, "%s: enter\n", __func__);

Debugging leftovers (although it's curious that this patch is not about devlink
params...).

> +
>  	mv88e6xxx_reg_lock(chip);
>  
>  	switch (id) {
> @@ -55,6 +58,8 @@ int mv88e6xxx_devlink_param_set(struct dsa_switch *ds, u32 id,
>  	struct mv88e6xxx_chip *chip = ds->priv;
>  	int err;
>  
> +	dev_info(ds->dev, "%s: enter\n", __func__);

Likewise.

> +
>  	mv88e6xxx_reg_lock(chip);
>  
>  	switch (id) {
> @@ -260,3 +265,411 @@ int mv88e6xxx_setup_devlink_resources(struct dsa_switch *ds)
>  	return err;
>  }
>  
> +static int mv88e6xxx_region_port_snapshot(struct devlink *dl,
> +					  struct netlink_ext_ack *extack,
> +					  u8 **data,
> +					  int port)
> +{
> +	struct dsa_switch *ds = dsa_devlink_to_ds(dl);
> +	struct mv88e6xxx_chip *chip = ds->priv;
> +	u16 *registers;
> +	int i, err;
> +
> +	registers = kmalloc_array(32, sizeof(u16), GFP_KERNEL);
> +	if (!registers)
> +		return -ENOMEM;
> +
> +	mv88e6xxx_reg_lock(chip);
> +	for (i = 0; i < 32; i++) {
> +		err = mv88e6xxx_port_read(chip, port, i, &registers[i]);
> +		if (err) {
> +			kfree(registers);
> +			goto out;
> +		}
> +	}
> +	*data = (u8 *)registers;
> +out:
> +	mv88e6xxx_reg_unlock(chip);
> +
> +	return err;
> +}
> +
> +#define PORT_SNAPSHOT(_X_)						\
> +static int mv88e6xxx_region_port_ ## _X_ ## _snapshot(		\
> +	struct devlink *dl,						\
> +	struct netlink_ext_ack *extack,					\
> +	u8 **data)							\
> +{									\
> +	return mv88e6xxx_region_port_snapshot(dl, extack, data, _X_);	\
> +}
> +
> +PORT_SNAPSHOT(0);
> +PORT_SNAPSHOT(1);
> +PORT_SNAPSHOT(2);
> +PORT_SNAPSHOT(3);
> +PORT_SNAPSHOT(4);
> +PORT_SNAPSHOT(5);
> +PORT_SNAPSHOT(6);
> +PORT_SNAPSHOT(7);
> +PORT_SNAPSHOT(8);
> +PORT_SNAPSHOT(9);
> +PORT_SNAPSHOT(10);
> +PORT_SNAPSHOT(11);
> +
> +#define PORT_REGION_OPS(_X_)						\
> +static struct devlink_region_ops mv88e6xxx_region_port_ ## _X_ ## _ops = { \
> +	.name = "port" #_X_,						\
> +	.snapshot = mv88e6xxx_region_port_ ## _X_ ## _snapshot,		\
> +	.destructor = kfree,						\
> +}
> +
> +PORT_REGION_OPS(0);
> +PORT_REGION_OPS(1);
> +PORT_REGION_OPS(2);
> +PORT_REGION_OPS(3);
> +PORT_REGION_OPS(4);
> +PORT_REGION_OPS(5);
> +PORT_REGION_OPS(6);
> +PORT_REGION_OPS(7);
> +PORT_REGION_OPS(8);
> +PORT_REGION_OPS(9);
> +PORT_REGION_OPS(10);
> +PORT_REGION_OPS(11);
> +
> +static const struct devlink_region_ops *mv88e6xxx_region_port_ops[] = {
> +	&mv88e6xxx_region_port_0_ops,
> +	&mv88e6xxx_region_port_1_ops,
> +	&mv88e6xxx_region_port_2_ops,
> +	&mv88e6xxx_region_port_3_ops,
> +	&mv88e6xxx_region_port_4_ops,
> +	&mv88e6xxx_region_port_5_ops,
> +	&mv88e6xxx_region_port_6_ops,
> +	&mv88e6xxx_region_port_7_ops,
> +	&mv88e6xxx_region_port_8_ops,
> +	&mv88e6xxx_region_port_9_ops,
> +	&mv88e6xxx_region_port_10_ops,
> +	&mv88e6xxx_region_port_11_ops,
> +};
> +

Sounds like there should maybe be an abstraction for 'per-port regions' in
devlink? I think your approach hardly scales if you start having
switches with more than 11 ports.

> +static int mv88e6xxx_region_global1_snapshot(struct devlink *dl,
> +					     struct netlink_ext_ack *extack,
> +					     u8 **data)
> +{
> +	struct dsa_switch *ds = dsa_devlink_to_ds(dl);
> +	struct mv88e6xxx_chip *chip = ds->priv;
> +	u16 *registers;
> +	int i, err;
> +
> +	registers = kmalloc_array(32, sizeof(u16), GFP_KERNEL);
> +	if (!registers)
> +		return -ENOMEM;
> +
> +	mv88e6xxx_reg_lock(chip);
> +	for (i = 0; i < 32; i++) {
> +		err = mv88e6xxx_g1_read(chip, i, &registers[i]);
> +		if (err) {
> +			kfree(registers);
> +			goto out;
> +		}
> +	}
> +	*data = (u8 *)registers;
> +out:
> +	mv88e6xxx_reg_unlock(chip);
> +
> +	return err;
> +}
> +
> +static int mv88e6xxx_region_global2_snapshot(struct devlink *dl,
> +					     struct netlink_ext_ack *extack,
> +					     u8 **data)
> +{
> +	struct dsa_switch *ds = dsa_devlink_to_ds(dl);
> +	struct mv88e6xxx_chip *chip = ds->priv;
> +	u16 *registers;
> +	int i, err;
> +
> +	registers = kmalloc_array(32, sizeof(u16), GFP_KERNEL);
> +	if (!registers)
> +		return -ENOMEM;
> +
> +	mv88e6xxx_reg_lock(chip);
> +	for (i = 0; i < 32; i++) {
> +		err = mv88e6xxx_g2_read(chip, i, &registers[i]);
> +		if (err) {
> +			kfree(registers);
> +			goto out;
> +		}
> +	}
> +	*data = (u8 *)registers;
> +out:
> +	mv88e6xxx_reg_unlock(chip);
> +
> +	return err;
> +}
> +
> +/* The ATU entry varies between chipset generations. Define a generic
> + * format which covers all the current and hopefully future
> + * generations
> + */

Could you please present this generic format to us? Maybe my interpretation of
the word "generic" is incorrect in this context? Is it even desirable to expose
regions like the ATU in a really generic (cross-vendor) fashion?

> +
> +struct mv88e6xxx_devlink_atu_entry {
> +	/* The FID is scattered over multiple registers. */
> +	u16 fid;
> +	u16 atu_op;
> +	u16 atu_data;
> +	u16 atu_01;
> +	u16 atu_23;
> +	u16 atu_45;
> +};
> +
> +static int mv88e6xxx_region_atu_snapshot_fid(struct mv88e6xxx_chip *chip,
> +					     int fid,
> +					     struct mv88e6xxx_devlink_atu_entry *table,
> +					     int *count)
> +{
> +	u16 atu_op, atu_data, atu_01, atu_23, atu_45;
> +	struct mv88e6xxx_atu_entry addr;
> +	int err;
> +
> +	addr.state = 0;
> +	eth_broadcast_addr(addr.mac);
> +
> +	do {
> +		err = mv88e6xxx_g1_atu_getnext(chip, fid, &addr);
> +		if (err)
> +			return err;
> +
> +		if (!addr.state)
> +			break;
> +
> +		err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_ATU_OP, &atu_op);
> +		if (err)
> +			return err;
> +
> +		err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_ATU_DATA, &atu_data);
> +		if (err)
> +			return err;
> +
> +		err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_ATU_MAC01, &atu_01);
> +		if (err)
> +			return err;
> +
> +		err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_ATU_MAC23, &atu_23);
> +		if (err)
> +			return err;
> +
> +		err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_ATU_MAC45, &atu_45);
> +		if (err)
> +			return err;
> +
> +		table[*count].fid = fid;
> +		table[*count].atu_op = atu_op;
> +		table[*count].atu_data = atu_data;
> +		table[*count].atu_01 = atu_01;
> +		table[*count].atu_23 = atu_23;
> +		table[*count].atu_45 = atu_45;
> +		(*count)++;
> +	} while (!is_broadcast_ether_addr(addr.mac));
> +
> +	return 0;
> +}
> +
> +static int mv88e6xxx_region_atu_snapshot(struct devlink *dl,
> +					 struct netlink_ext_ack *extack,
> +					 u8 **data)
> +{
> +	struct dsa_switch *ds = dsa_devlink_to_ds(dl);
> +	DECLARE_BITMAP(fid_bitmap, MV88E6XXX_N_FID);
> +	struct mv88e6xxx_devlink_atu_entry *table;
> +	struct mv88e6xxx_chip *chip = ds->priv;
> +	int fid = -1, count, err;
> +
> +	table = kmalloc_array(mv88e6xxx_num_databases(chip),
> +			      sizeof(struct mv88e6xxx_devlink_atu_entry),
> +			      GFP_KERNEL);
> +	if (!table)
> +		return -ENOMEM;
> +
> +	memset(table, 0, mv88e6xxx_num_databases(chip) *
> +	       sizeof(struct mv88e6xxx_devlink_atu_entry));
> +
> +	count = 0;
> +
> +	mv88e6xxx_reg_lock(chip);
> +
> +	err = mv88e6xxx_fid_map(chip, fid_bitmap);
> +	if (err)
> +		goto out;
> +
> +	while (1) {
> +		fid = find_next_bit(fid_bitmap, MV88E6XXX_N_FID, fid + 1);
> +		if (fid == MV88E6XXX_N_FID)
> +			break;
> +
> +		err =  mv88e6xxx_region_atu_snapshot_fid(chip, fid, table,
> +							 &count);
> +		if (err) {
> +			kfree(table);
> +			goto out;
> +		}
> +	}
> +	*data = (u8 *)table;
> +out:
> +	mv88e6xxx_reg_unlock(chip);
> +
> +	return err;
> +}
> +
> +static struct devlink_region_ops mv88e6xxx_region_global1_ops = {
> +	.name = "global1",
> +	.snapshot = mv88e6xxx_region_global1_snapshot,
> +	.destructor = kfree,
> +};
> +
> +static struct devlink_region_ops mv88e6xxx_region_global2_ops = {
> +	.name = "global2",
> +	.snapshot = mv88e6xxx_region_global2_snapshot,
> +	.destructor = kfree,
> +};
> +
> +static struct devlink_region_ops mv88e6xxx_region_atu_ops = {
> +	.name = "atu",
> +	.snapshot = mv88e6xxx_region_atu_snapshot,
> +	.destructor = kfree,
> +};
> +
> +struct mv88e6xxx_region {
> +	struct devlink_region_ops *ops;
> +	u64 size;
> +};
> +
> +static struct mv88e6xxx_region mv88e6xxx_regions[] = {
> +	[MV88E6XXX_REGION_GLOBAL1] = {
> +		.ops = &mv88e6xxx_region_global1_ops,
> +		.size = 32 * sizeof(u16)
> +	},
> +	[MV88E6XXX_REGION_GLOBAL2] = {
> +		.ops = &mv88e6xxx_region_global2_ops,
> +		.size = 32 * sizeof(u16) },
> +	[MV88E6XXX_REGION_ATU] = {
> +		.ops = &mv88e6xxx_region_atu_ops
> +	  /* calculated at runtime */
> +	},
> +};
> +
> +static void
> +mv88e6xxx_teardown_devlink_regions_port(struct mv88e6xxx_chip *chip, int port)
> +{
> +	dsa_devlink_region_destroy(chip->ports[port].region);
> +}
> +
> +static void
> +mv88e6xxx_teardown_devlink_regions_ports(struct mv88e6xxx_chip *chip)
> +{
> +	int port;
> +
> +	for (port = 0; port < mv88e6xxx_num_ports(chip); port++)
> +		mv88e6xxx_teardown_devlink_regions_port(chip, port);
> +}
> +
> +static void
> +mv88e6xxx_teardown_devlink_regions_global(struct mv88e6xxx_chip *chip)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(mv88e6xxx_regions); i++)
> +		dsa_devlink_region_destroy(chip->regions[i]);
> +}
> +
> +void mv88e6xxx_teardown_devlink_regions(struct dsa_switch *ds)
> +{
> +	struct mv88e6xxx_chip *chip = ds->priv;
> +
> +	mv88e6xxx_teardown_devlink_regions_ports(chip);
> +	mv88e6xxx_teardown_devlink_regions_global(chip);
> +}
> +
> +static int mv88e6xxx_setup_devlink_regions_port(struct dsa_switch *ds,
> +						struct mv88e6xxx_chip *chip,
> +						int port)
> +{
> +	struct devlink_region *region;
> +
> +	region = dsa_devlink_region_create(ds,
> +					   mv88e6xxx_region_port_ops[port], 1,
> +					   32 * sizeof(u16));
> +	if (IS_ERR(region))
> +		return PTR_ERR(region);
> +
> +	chip->ports[port].region = region;
> +	return 0;
> +}
> +
> +static int mv88e6xxx_setup_devlink_regions_ports(struct dsa_switch *ds,
> +						 struct mv88e6xxx_chip *chip)
> +{
> +	int port, port_err;
> +	int err;
> +
> +	for (port = 0; port < mv88e6xxx_num_ports(chip); port++) {
> +		err = mv88e6xxx_setup_devlink_regions_port(ds, chip, port);
> +		if (err)
> +			goto out;
> +	}
> +	return 0;
> +
> +out:
> +	for (port_err = 0; port_err < port; port_err++)
> +		mv88e6xxx_teardown_devlink_regions_port(chip, port_err);
> +
> +	return err;
> +}
> +
> +static int mv88e6xxx_setup_devlink_regions_global(struct dsa_switch *ds,
> +						  struct mv88e6xxx_chip *chip)
> +{
> +	struct devlink_region_ops *ops;
> +	struct devlink_region *region;
> +	u64 size;
> +	int i, j;
> +
> +	for (i = 0; i < ARRAY_SIZE(mv88e6xxx_regions); i++) {
> +		ops = mv88e6xxx_regions[i].ops;
> +		size = mv88e6xxx_regions[i].size;
> +
> +		if (i == MV88E6XXX_REGION_ATU)
> +			size = mv88e6xxx_num_databases(chip) *
> +				sizeof(struct mv88e6xxx_devlink_atu_entry);
> +
> +		region = dsa_devlink_region_create(ds, ops, 1, size);
> +		if (IS_ERR(region))
> +			goto out;
> +		chip->regions[i] = region;
> +	}
> +	return 0;
> +
> +out:
> +	for (j = 0; j < i; j++)
> +		dsa_devlink_region_destroy(chip->regions[j]);
> +
> +	return PTR_ERR(region);
> +}
> +
> +int mv88e6xxx_setup_devlink_regions(struct dsa_switch *ds)
> +{
> +	struct mv88e6xxx_chip *chip = ds->priv;
> +	int err;
> +
> +	err = mv88e6xxx_setup_devlink_regions_ports(ds, chip);
> +	if (err)
> +		return err;
> +
> +	err = mv88e6xxx_setup_devlink_regions_global(ds, chip);
> +	if (err) {
> +		mv88e6xxx_teardown_devlink_regions_ports(chip);
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +
> diff --git a/drivers/net/dsa/mv88e6xxx/devlink.h b/drivers/net/dsa/mv88e6xxx/devlink.h
> index f6254e049653..da83c25d944b 100644
> --- a/drivers/net/dsa/mv88e6xxx/devlink.h
> +++ b/drivers/net/dsa/mv88e6xxx/devlink.h
> @@ -12,5 +12,7 @@ int mv88e6xxx_devlink_param_get(struct dsa_switch *ds, u32 id,
>  				struct devlink_param_gset_ctx *ctx);
>  int mv88e6xxx_devlink_param_set(struct dsa_switch *ds, u32 id,
>  				struct devlink_param_gset_ctx *ctx);
> +int mv88e6xxx_setup_devlink_regions(struct dsa_switch *ds);
> +void mv88e6xxx_teardown_devlink_regions(struct dsa_switch *ds);
>  
>  #endif /* _MV88E6XXX_DEVLINK_H */
> -- 
> 2.28.0
> 

Thanks,
-Vladimir
