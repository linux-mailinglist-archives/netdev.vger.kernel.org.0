Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 668AE5B4F62
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 16:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbiIKOMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 10:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbiIKOMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 10:12:00 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D9E193CB
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 07:11:58 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id go34so14605984ejc.2
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 07:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=SzUU6SD7GQJVYL+wpP+tjwZcPeMa0N+jzUwqNcvrAco=;
        b=DMBnFzz5r1dtU24SWnaWwitQP1GM5rLKdocWaq1m+jHbHCXYotOITVZ2snT7uk5Hm4
         8v0E3ctESJdZQEdC3uzLeztrGeOE+RNstHTybQN/JYTA1NW8LVXldbX4JSFDO9MWPuxB
         Pb2WtNmUftUQOUITTk53Q3MrVm4mJpzPEc9uiGGjKoL4pjHb0ZvEWHXZGMNFM7BF+j0s
         nZh0KY2Inbk8AP+GpEd9wiAImcwunMgUs6TZocTLjua9vTnYFkUCvbYklahSA8+Zvn4E
         MaI+fpcyKdqOQPn6nAp3x65D4aapbqXjO9FN0PPQkrSegQldMS0pj5hcKJjDtiU5ZI0H
         Wuhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=SzUU6SD7GQJVYL+wpP+tjwZcPeMa0N+jzUwqNcvrAco=;
        b=sG4MsaueDAjol6O+Zoql+cToDL1gwadGAyAGcIeENgZsmzpm1VZesQCWD5sY0XsM1B
         JKyFx2RAs73WF328Ck+x6PTlbP/6QWdAyKtYqIFS3VKHPLk1oMehyYvS92hdKbL1eVk1
         K+gYxFX0k13Eb893GvoseDscF5qX5YyI2hhaITLb5H7Ie4ulDPvAcDplaMOgCIFvDPHM
         vDpJRyJsajvhr3Y53Ovu1HqhNZLscUvWkLKbColzL6lHO+fD10q9EiDuNBTB3kV4gk6r
         quh4T5YlYYgDiNUVm9OQfr4s+YPd0zCaXyKkHySpgufsp9f+BlUHg/6Ks8qmAI3ZFePQ
         pa4A==
X-Gm-Message-State: ACgBeo3n4YSd1QD/fSk64FX+KJZoRMvXA2E9sVLS5gx4ZmYbOtg2T6Ij
        EefavsTg9Hg3qrkFGtief1E=
X-Google-Smtp-Source: AA6agR62Os+sRPFe5Fq3OIT2+5okX30Z9g7jX51LjEzr5LRztB6MWSn7zkH4hUunyKoISk+WhHgImA==
X-Received: by 2002:a17:907:94c6:b0:77d:7ad3:d063 with SMTP id dn6-20020a17090794c600b0077d7ad3d063mr672916ejc.330.1662905516441;
        Sun, 11 Sep 2022 07:11:56 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id r9-20020a1709061ba900b007413360a48fsm2997865ejg.50.2022.09.11.07.11.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Sep 2022 07:11:54 -0700 (PDT)
Date:   Sun, 11 Sep 2022 17:11:51 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v8 4/6] net: dsa: mv88e6xxxx: Add RMU
 functionality.
Message-ID: <20220911141151.lvkpzcnxkrhrzxb6@skbuf>
References: <20220909085138.3539952-1-mattias.forsblad@gmail.com>
 <20220909085138.3539952-1-mattias.forsblad@gmail.com>
 <20220909085138.3539952-5-mattias.forsblad@gmail.com>
 <20220909085138.3539952-5-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909085138.3539952-5-mattias.forsblad@gmail.com>
 <20220909085138.3539952-5-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 09, 2022 at 10:51:36AM +0200, Mattias Forsblad wrote:
> The Marvell SOHO switches supports a secondary control
> channel for accessing data in the switch. Special crafted
> ethernet frames can access functions in the switch.
> These frames is handled by the Remote Management Unit (RMU)
> in the switch. Accessing data structures is specially
> efficient and lessens the access contention on the MDIO
> bus.
> 
> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
> ---

This is not the whole feedback I have, just a part of it. But I think it
is enough for now. I'd like to see this addressed before I review in
more depth.

>  drivers/net/dsa/mv88e6xxx/Makefile |   1 +
>  drivers/net/dsa/mv88e6xxx/chip.c   |  28 ++-
>  drivers/net/dsa/mv88e6xxx/chip.h   |  19 ++
>  drivers/net/dsa/mv88e6xxx/rmu.c    | 270 +++++++++++++++++++++++++++++
>  drivers/net/dsa/mv88e6xxx/rmu.h    |  76 ++++++++
>  5 files changed, 386 insertions(+), 8 deletions(-)
>  create mode 100644 drivers/net/dsa/mv88e6xxx/rmu.c
>  create mode 100644 drivers/net/dsa/mv88e6xxx/rmu.h
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/Makefile b/drivers/net/dsa/mv88e6xxx/Makefile
> index c8eca2b6f959..105d7bd832c9 100644
> --- a/drivers/net/dsa/mv88e6xxx/Makefile
> +++ b/drivers/net/dsa/mv88e6xxx/Makefile
> @@ -15,3 +15,4 @@ mv88e6xxx-objs += port_hidden.o
>  mv88e6xxx-$(CONFIG_NET_DSA_MV88E6XXX_PTP) += ptp.o
>  mv88e6xxx-objs += serdes.o
>  mv88e6xxx-objs += smi.o
> +mv88e6xxx-objs += rmu.o
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 46e12b53a9e4..bbdf229c9e71 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -42,6 +42,7 @@
>  #include "ptp.h"
>  #include "serdes.h"
>  #include "smi.h"
> +#include "rmu.h"
>  
>  static void assert_reg_lock(struct mv88e6xxx_chip *chip)
>  {
> @@ -1535,14 +1536,6 @@ static int mv88e6xxx_trunk_setup(struct mv88e6xxx_chip *chip)
>  	return 0;
>  }
>  
> -static int mv88e6xxx_rmu_setup(struct mv88e6xxx_chip *chip)
> -{
> -	if (chip->info->ops->rmu_disable)
> -		return chip->info->ops->rmu_disable(chip);
> -
> -	return 0;
> -}
> -
>  static int mv88e6xxx_pot_setup(struct mv88e6xxx_chip *chip)
>  {
>  	if (chip->info->ops->pot_clear)
> @@ -6867,6 +6860,23 @@ static int mv88e6xxx_crosschip_lag_leave(struct dsa_switch *ds, int sw_index,
>  	return err_sync ? : err_pvt;
>  }
>  
> +static int mv88e6xxx_connect_tag_protocol(struct dsa_switch *ds,
> +					  enum dsa_tag_protocol proto)
> +{
> +	struct dsa_tagger_data *tagger_data = ds->tagger_data;
> +
> +	switch (proto) {
> +	case DSA_TAG_PROTO_DSA:
> +	case DSA_TAG_PROTO_EDSA:
> +		tagger_data->decode_frame2reg = mv88e6xxx_decode_frame2reg_handler;
> +		break;
> +	default:
> +		return -EOPNOTSUPP;

-EPROTONOSUPPORT

> +	}
> +
> +	return 0;
> +}
> +
>  static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
>  	.get_tag_protocol	= mv88e6xxx_get_tag_protocol,
>  	.change_tag_protocol	= mv88e6xxx_change_tag_protocol,
> @@ -6932,6 +6942,8 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
>  	.crosschip_lag_change	= mv88e6xxx_crosschip_lag_change,
>  	.crosschip_lag_join	= mv88e6xxx_crosschip_lag_join,
>  	.crosschip_lag_leave	= mv88e6xxx_crosschip_lag_leave,
> +	.master_state_change	= mv88e6xxx_master_change,

mv88e6xxx_master_state_change, please. "master_change" will have quite a
different meaning when moving DSA user ports to different DSA masters
will be supported.

> +	.connect_tag_protocol	= mv88e6xxx_connect_tag_protocol,
>  };
>  
>  static int mv88e6xxx_register_switch(struct mv88e6xxx_chip *chip)
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
> index 7ce3c41f6caf..566d18cf5170 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.h
> +++ b/drivers/net/dsa/mv88e6xxx/chip.h
> @@ -282,6 +282,18 @@ struct mv88e6xxx_port {
>  	struct devlink_region *region;
>  };
>  
> +struct mv88e6xxx_rmu {
> +	/* RMU resources */
> +	struct net_device *master_netdev;
> +	const struct mv88e6xxx_bus_ops *smi_ops;
> +	struct mv88e6xxx_bus_ops *rmu_ops;
> +	/* Mutex for RMU operations */
> +	struct mutex mutex;
> +	u16 prodnr;
> +	struct sk_buff *resp;
> +	int seqno;
> +};
> +
>  enum mv88e6xxx_region_id {
>  	MV88E6XXX_REGION_GLOBAL1 = 0,
>  	MV88E6XXX_REGION_GLOBAL2,
> @@ -410,6 +422,9 @@ struct mv88e6xxx_chip {
>  
>  	/* Bridge MST to SID mappings */
>  	struct list_head msts;
> +
> +	/* RMU resources */
> +	struct mv88e6xxx_rmu rmu;
>  };
>  
>  struct mv88e6xxx_bus_ops {
> @@ -805,4 +820,8 @@ static inline void mv88e6xxx_reg_unlock(struct mv88e6xxx_chip *chip)
>  
>  int mv88e6xxx_fid_map(struct mv88e6xxx_chip *chip, unsigned long *bitmap);
>  
> +static inline bool mv88e6xxx_rmu_available(struct mv88e6xxx_chip *chip)
> +{
> +	return chip->rmu.master_netdev ? 1 : 0;
> +}
>  #endif /* _MV88E6XXX_CHIP_H */
> diff --git a/drivers/net/dsa/mv88e6xxx/rmu.c b/drivers/net/dsa/mv88e6xxx/rmu.c
> new file mode 100644
> index 000000000000..20a91629e72b
> --- /dev/null
> +++ b/drivers/net/dsa/mv88e6xxx/rmu.c
> @@ -0,0 +1,270 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Marvell 88E6xxx Switch Remote Management Unit Support
> + *
> + * Copyright (c) 2022 Mattias Forsblad <mattias.forsblad@gmail.com>
> + *
> + */
> +
> +#include <asm/unaligned.h>
> +#include "rmu.h"
> +#include "global1.h"
> +
> +static void mv88e6xxx_rmu_create_l2(struct sk_buff *skb, struct dsa_port *dp)

struct dsa_port *dp is not what this function needs as argument, but
struct dsa_switch *ds. In turn, this makes all of mv88e6xxx_rmu_send_wait()
not need an "int port".

> +{
> +	struct mv88e6xxx_chip *chip = dp->ds->priv;
> +	struct ethhdr *eth;
> +	u8 *edsa_header;
> +	u8 *dsa_header;
> +	u8 extra = 0;
> +
> +	if (chip->tag_protocol == DSA_TAG_PROTO_EDSA)
> +		extra = 4;
> +
> +	/* Create RMU L2 header */
> +	dsa_header = skb_push(skb, 6);
> +	dsa_header[0] = FIELD_PREP(MV88E6XXX_CPU_CODE_MASK, MV88E6XXX_RMU);
> +	dsa_header[0] |= FIELD_PREP(MV88E6XXX_TRG_DEV_MASK, dp->ds->index);
> +	dsa_header[1] = FIELD_PREP(MV88E6XXX_RMU_CODE_MASK, 1);
> +	dsa_header[1] |= FIELD_PREP(MV88E6XXX_RMU_L2_BYTE1_RESV, MV88E6XXX_RMU_L2_BYTE1_RESV_VAL);
> +	dsa_header[2] = FIELD_PREP(MV88E6XXX_RMU_PRIO_MASK, MV88E6XXX_RMU_PRIO);
> +	dsa_header[2] |= MV88E6XXX_RMU_L2_BYTE2_RESV;
> +	dsa_header[3] = ++chip->rmu.seqno;
> +	dsa_header[4] = 0;
> +	dsa_header[5] = 0;
> +
> +	/* Insert RMU MAC destination address /w extra if needed */
> +	skb_push(skb, ETH_ALEN * 2 + extra);
> +	eth = (struct ethhdr *)skb->data;

No need to type-cast a void *. Also, this can simply be: "eth = skb_push()".

> +	memcpy(eth->h_dest, rmu_dest_addr, ETH_ALEN);
> +	memcpy(eth->h_source, chip->rmu.master_netdev->dev_addr, ETH_ALEN);

ether_addr_copy()

> +
> +	if (extra) {
> +		edsa_header = (u8 *)&eth->h_proto;
> +		edsa_header[0] = (ETH_P_EDSA >> 8) & 0xff;
> +		edsa_header[1] = ETH_P_EDSA & 0xff;
> +		edsa_header[2] = 0x00;
> +		edsa_header[3] = 0x00;
> +	}
> +}
> +
> +static int mv88e6xxx_rmu_send_wait(struct mv88e6xxx_chip *chip, int port,
> +				   const void *req, int req_len,
> +				   void *resp, unsigned int *resp_len)
> +{
> +	struct dsa_port *dp;
> +	struct sk_buff *skb;
> +	unsigned char *data;
> +	int ret = 0;
> +
> +	dp = dsa_to_port(chip->ds, port);
> +	if (!dp)
> +		return -EINVAL;
> +
> +	skb = netdev_alloc_skb(chip->rmu.master_netdev, 64);
> +	if (!skb)
> +		return -ENOMEM;
> +
> +	/* Take height for an eventual EDSA header */
> +	skb_reserve(skb, 2 * ETH_HLEN + 4);
> +	skb_reset_network_header(skb);
> +
> +	/* Insert RMU request message */
> +	data = skb_put(skb, req_len);
> +	memcpy(data, req, req_len);
> +
> +	mv88e6xxx_rmu_create_l2(skb, dp);
> +
> +	mutex_lock(&chip->rmu.mutex);
> +
> +	ret = dsa_switch_inband_tx(dp->ds, skb, NULL, MV88E6XXX_RMU_WAIT_TIME_MS);
> +	if (ret < 0) {
> +		dev_err(chip->dev, "RMU: timeout waiting for request (%pe) on port %d\n",
> +			ERR_PTR(ret), port);
> +		goto out;
> +	}
> +
> +	if (chip->rmu.resp->len > *resp_len) {
> +		ret = -EMSGSIZE;
> +	} else {
> +		*resp_len = chip->rmu.resp->len;
> +		memcpy(resp, chip->rmu.resp->data, chip->rmu.resp->len);
> +	}
> +
> +	/* We're done with the received data copy, discard it */
> +	kfree_skb(chip->rmu.resp);
> +	chip->rmu.resp = NULL;
> +
> +out:
> +	mutex_unlock(&chip->rmu.mutex);
> +
> +	return ret > 0 ? 0 : ret;
> +}
> +
> +static int mv88e6xxx_rmu_get_id(struct mv88e6xxx_chip *chip, int port)
> +{
> +	const u16 req[4] = { MV88E6XXX_RMU_REQ_FORMAT_GET_ID,
> +			     MV88E6XXX_RMU_REQ_PAD,
> +			     MV88E6XXX_RMU_REQ_CODE_GET_ID,
> +			     MV88E6XXX_RMU_REQ_DATA};
> +	struct rmu_header resp;
> +	int resp_len;
> +	int ret = -1;
> +	u16 format;
> +	u16 code;
> +
> +	resp_len = sizeof(resp);
> +	ret = mv88e6xxx_rmu_send_wait(chip, port, req, sizeof(req),
> +				      &resp, &resp_len);
> +	if (ret) {
> +		dev_dbg(chip->dev, "RMU: error for command GET_ID %pe\n", ERR_PTR(ret));
> +		return ret;
> +	}
> +
> +	/* Got response */
> +	format = get_unaligned_be16(&resp.format);
> +	code = get_unaligned_be16(&resp.code);

Once you memcpy the RMU response to an on-stack structure, it becomes
aligned and you can get rid of get_unaligned_*

> +
> +	if (format != MV88E6XXX_RMU_RESP_FORMAT_1 &&
> +	    format != MV88E6XXX_RMU_RESP_FORMAT_2 &&
> +	    code != MV88E6XXX_RMU_RESP_CODE_GOT_ID) {
> +		net_dbg_ratelimited("RMU: received unknown format 0x%04x code 0x%04x",
> +				    format, code);
> +		return -EIO;
> +	}
> +
> +	chip->rmu.prodnr = get_unaligned_be16(&resp.prodnr);
> +
> +	return 0;
> +}
> +
> +static void mv88e6xxx_disable_rmu(struct mv88e6xxx_chip *chip)
> +{
> +	chip->smi_ops = chip->rmu.smi_ops;
> +	chip->rmu.master_netdev = NULL;
> +	if (chip->info->ops->rmu_disable)
> +		chip->info->ops->rmu_disable(chip);
> +}
> +
> +static int mv88e6xxx_enable_check_rmu(const struct net_device *master,
> +				      struct mv88e6xxx_chip *chip, int port)
> +{
> +	int ret;
> +
> +	chip->rmu.master_netdev = (struct net_device *)master;
> +
> +	/* Check if chip is alive */
> +	ret = mv88e6xxx_rmu_get_id(chip, port);
> +	if (!ret)
> +		return ret;
> +
> +	chip->smi_ops = chip->rmu.rmu_ops;
> +
> +	return 0;
> +}
> +
> +void mv88e6xxx_master_change(struct dsa_switch *ds, const struct net_device *master,
> +			     bool operational)
> +{
> +	struct mv88e6xxx_chip *chip = ds->priv;
> +	struct dsa_port *cpu_dp;
> +	int port;
> +	int ret;
> +
> +	cpu_dp = master->dsa_ptr;

The assignment could be made as part of the variable declaration here.

> +	port = dsa_towards_port(ds, cpu_dp->ds->index, cpu_dp->index);
> +
> +	mv88e6xxx_reg_lock(chip);
> +
> +	if (operational && chip->info->ops->rmu_enable) {
> +		ret = chip->info->ops->rmu_enable(chip, port);
> +
> +		if (ret == -EOPNOTSUPP)
> +			goto out;
> +
> +		if (!ret) {
> +			dev_dbg(chip->dev, "RMU: Enabled on port %d", port);
> +
> +			ret = mv88e6xxx_enable_check_rmu(master, chip, port);
> +			if (!ret)
> +				goto out;
> +
> +		} else {
> +			dev_err(chip->dev, "RMU: Unable to enable on port %d %pe",
> +				port, ERR_PTR(ret));
> +			goto out;
> +		}
> +	}
> +
> +	mv88e6xxx_disable_rmu(chip);

This looks wrong. Why is mv88e6xxx_disable_rmu() called
if (operational && chip->info->ops->rmu_enable) is true?

> +
> +out:
> +	mv88e6xxx_reg_unlock(chip);
> +}
> +
> +static int mv88e6xxx_validate_mac(struct dsa_switch *ds, struct sk_buff *skb)
> +{
> +	struct mv88e6xxx_chip *chip = ds->priv;
> +	unsigned char *ethhdr;
> +
> +	/* Check matching MAC */
> +	ethhdr = skb_mac_header(skb);
> +	if (!ether_addr_equal(chip->rmu.master_netdev->dev_addr, ethhdr)) {
> +		dev_dbg_ratelimited(ds->dev, "RMU: mismatching MAC address for request. Rx %pM expecting %pM\n",
> +				    ethhdr, chip->rmu.master_netdev->dev_addr);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +void mv88e6xxx_decode_frame2reg_handler(struct net_device *dev, struct sk_buff *skb)
> +{
> +	struct dsa_port *dp = dev->dsa_ptr;
> +	struct dsa_switch *ds = dp->ds;
> +	struct mv88e6xxx_chip *chip;
> +	int source_device;
> +	u8 *dsa_header;
> +	u8 seqno;
> +
> +	/* Decode Frame2Reg DSA portion */
> +	dsa_header = skb->data - 2;
> +
> +	source_device = FIELD_GET(MV88E6XXX_SOURCE_DEV, dsa_header[0]);
> +	ds = dsa_switch_find(ds->dst->index, source_device);
> +	if (!ds) {
> +		net_err_ratelimited("RMU: Didn't find switch with index %d", source_device);
> +		return;
> +	}
> +
> +	if (mv88e6xxx_validate_mac(ds, skb))
> +		return;

What's the worst that will happen if you don't validate this?

> +
> +	chip = ds->priv;
> +	seqno = dsa_header[3];
> +	if (seqno != chip->rmu.seqno) {
> +		net_err_ratelimited("RMU: wrong seqno received. Was %d, expected %d",
> +				    seqno, chip->rmu.seqno);
> +		return;
> +	}
> +
> +	/* Pull DSA L2 data */
> +	skb_pull(skb, MV88E6XXX_DSA_HLEN);
> +
> +	/* Make an copy for further processing in initiator */
> +	chip->rmu.resp = skb_copy(skb, GFP_ATOMIC);

I don't think you need an actual copy, skb_get() will do just fine.

> +	if (!chip->rmu.resp)
> +		return;
> +
> +	dsa_switch_inband_complete(ds, NULL);
> +}
> +
> +int mv88e6xxx_rmu_setup(struct mv88e6xxx_chip *chip)
> +{
> +	mutex_init(&chip->rmu.mutex);
> +
> +	if (chip->info->ops->rmu_disable)
> +		return chip->info->ops->rmu_disable(chip);
> +
> +	return 0;
> +}
> diff --git a/drivers/net/dsa/mv88e6xxx/rmu.h b/drivers/net/dsa/mv88e6xxx/rmu.h
> new file mode 100644
> index 000000000000..1dd533361661
> --- /dev/null
> +++ b/drivers/net/dsa/mv88e6xxx/rmu.h
> @@ -0,0 +1,76 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
> +/*
> + * Marvell 88E6xxx Switch Remote Management Unit Support
> + *
> + * Copyright (c) 2022 Mattias Forsblad <mattias.forsblad@gmail.com>
> + *
> + */
> +
> +#ifndef _MV88E6XXX_RMU_H_
> +#define _MV88E6XXX_RMU_H_
> +
> +#include "chip.h"
> +
> +#define MV88E6XXX_DSA_HLEN	4
> +
> +#define MV88E6XXX_RMU_MAX_RMON			64
> +
> +#define MV88E6XXX_RMU_WAIT_TIME_MS		20
> +
> +static const u8 rmu_dest_addr[ETH_ALEN] = { 0x01, 0x50, 0x43, 0x00, 0x00, 0x00 };

mv88e6xxx_rmu_dest_addr

> +
> +#define MV88E6XXX_RMU_L2_BYTE1_RESV_VAL		0x3e
> +#define MV88E6XXX_RMU				1
> +#define MV88E6XXX_RMU_PRIO			6
> +#define MV88E6XXX_RMU_RESV2			0xf
> +
> +#define MV88E6XXX_SOURCE_PORT			GENMASK(6, 3)
> +#define MV88E6XXX_SOURCE_DEV			GENMASK(5, 0)
> +#define MV88E6XXX_CPU_CODE_MASK			GENMASK(7, 6)
> +#define MV88E6XXX_TRG_DEV_MASK			GENMASK(4, 0)
> +#define MV88E6XXX_RMU_CODE_MASK			GENMASK(1, 1)
> +#define MV88E6XXX_RMU_PRIO_MASK			GENMASK(7, 5)
> +#define MV88E6XXX_RMU_L2_BYTE1_RESV		GENMASK(7, 2)
> +#define MV88E6XXX_RMU_L2_BYTE2_RESV		GENMASK(3, 0)
> +
> +#define MV88E6XXX_RMU_REQ_GET_ID		1
> +#define MV88E6XXX_RMU_REQ_DUMP_MIB		2
> +
> +#define MV88E6XXX_RMU_REQ_FORMAT_GET_ID		0x0000
> +#define MV88E6XXX_RMU_REQ_FORMAT_SOHO		0x0001
> +#define MV88E6XXX_RMU_REQ_PAD			0x0000
> +#define MV88E6XXX_RMU_REQ_CODE_GET_ID		0x0000
> +#define MV88E6XXX_RMU_REQ_CODE_DUMP_MIB		0x1020
> +#define MV88E6XXX_RMU_REQ_DATA			0x0000
> +
> +#define MV88E6XXX_RMU_REQ_DUMP_MIB_PORT_MASK	GENMASK(4, 0)
> +
> +#define MV88E6XXX_RMU_RESP_FORMAT_1		0x0001
> +#define MV88E6XXX_RMU_RESP_FORMAT_2		0x0002
> +#define MV88E6XXX_RMU_RESP_ERROR		0xffff
> +
> +#define MV88E6XXX_RMU_RESP_CODE_GOT_ID		0x0000
> +#define MV88E6XXX_RMU_RESP_CODE_DUMP_MIB	0x1020
> +
> +struct rmu_header {

struct mv88e6xxx_rmu_header

> +	u16 format;
> +	u16 prodnr;
> +	u16 code;

__be16, not u16.

> +} __packed;
> +
> +struct dump_mib_resp {

struct mv88e6xxx_dump_mib_resp

> +	struct rmu_header rmu_header;
> +	u8 devnum;
> +	u8 portnum;
> +	u32 timestamp;
> +	u32 mib[MV88E6XXX_RMU_MAX_RMON];

__be32.

> +} __packed;
> +
> +int mv88e6xxx_rmu_setup(struct mv88e6xxx_chip *chip);
> +
> +void mv88e6xxx_master_change(struct dsa_switch *ds, const struct net_device *master,
> +			     bool operational);
> +
> +void mv88e6xxx_decode_frame2reg_handler(struct net_device *dev, struct sk_buff *skb);
> +
> +#endif /* _MV88E6XXX_RMU_H_ */
> -- 
> 2.25.1
> 

