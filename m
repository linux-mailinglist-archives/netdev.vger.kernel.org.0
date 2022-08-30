Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 605975A687E
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 18:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbiH3Qf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 12:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiH3Qf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 12:35:26 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6513175A0
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 09:35:20 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id se27so15581289ejb.8
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 09:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=G9S5+6JTKfT2pv+MY28EW63DFCK84ghrIIQ4Jbf/efs=;
        b=PSGT5ehoFEUcYChNwclH9qn/mm9RvCYVHOJU5sCFkOpJwvSlFcVWoaTOO2dTy+6Awx
         P7fzmtdSL58vE/RBvtEA+0ewW2G7TjvOKRjN3+5wb2HulCrRn6w+J7Y275o8zV3q1WP4
         4Egpu8lB//n1hH1xvLiTZ9CDnRSMgc4vwqjaUN/8FipEYBeVOm/MBGVdhIwmbrGGzoPX
         i6GGYaeKmNYr5KfkQgc0o15axixkQ0iTffgtMfq+TGwibNB9zYWH8F9hl1WMXEJpNS5V
         xiJRx00sAyDzMRGpKcgbds3L5m+ZLmQatl4V/Dz7AalgPHInadRfVKDvbzh0cEguroGs
         Z/ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=G9S5+6JTKfT2pv+MY28EW63DFCK84ghrIIQ4Jbf/efs=;
        b=Qri5m6QmnLD5nNhf3evBmxOf06Fu9FsNuPAWci2vjAPEJUbMgK4+SYTqzyXNcgysi/
         7FMlmpVTG3C7Wnb47oj3fz/KLL14ZrHnTCwnHPBR0Hm1qPaQ8TgF47fH8tEHv3I/1kNu
         Lk8U5AMUmxeFZCYMsYAO3gK5YEhPoSi/cspz3Kt4N6cENzMYPcLdX1Aqt6paGBVxDisK
         w9QWZxdXMoH2csS4bqlZq1MoKpPwb6GAm75gNTxzaJmoWE8Jx3rlQU1c4pU8uU2sdIyu
         kVSujrh64g6Wy7f95pvAk/Q9wkczJAghAav6Dib8bMLzLvNOJbi01X7HGjgHmEfnKQsJ
         P2yQ==
X-Gm-Message-State: ACgBeo0OMWJfefyWxmTSI7AnzTPjPXIA8ys8b9y4Xvfm4SrsYUJfEY/C
        E7vH03unZLLzdfA2Zqya7EA=
X-Google-Smtp-Source: AA6agR4JIOiT7SwWXXzqXis3StulAKvb+qIsiQWdtiHmTO2K/tVlJ0HvwzioyKSBCMUprjSPtyXAkQ==
X-Received: by 2002:a17:906:6a03:b0:730:a20e:cf33 with SMTP id qw3-20020a1709066a0300b00730a20ecf33mr18254775ejc.620.1661877318801;
        Tue, 30 Aug 2022 09:35:18 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id c17-20020a17090618b100b007311eb42e40sm6035318ejf.54.2022.08.30.09.35.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 09:35:18 -0700 (PDT)
Date:   Tue, 30 Aug 2022 19:35:15 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v2 2/3] dsa: mv88e6xxx: Add support for RMU in
 select switches
Message-ID: <20220830163515.3d2lzzc55vmko325@skbuf>
References: <20220826063816.948397-1-mattias.forsblad@gmail.com>
 <20220826063816.948397-3-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826063816.948397-3-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 26, 2022 at 08:38:15AM +0200, Mattias Forsblad wrote:
>  static int mv88e6xxx_rmu_setup(struct mv88e6xxx_chip *chip)
>  {
> +	if (chip->info->ops->rmu_enable)
> +		if (!chip->info->ops->rmu_enable(chip))
> +			return mv88e6xxx_rmu_init(chip);
> +
>  	if (chip->info->ops->rmu_disable)
>  		return chip->info->ops->rmu_disable(chip);

I think it's very important for the RMU to still start as disabled.
You enable it dynamically when the master goes up.

> diff --git a/drivers/net/dsa/mv88e6xxx/rmu.c b/drivers/net/dsa/mv88e6xxx/rmu.c
> new file mode 100644
> index 000000000000..b7d850c099c5
> --- /dev/null
> +++ b/drivers/net/dsa/mv88e6xxx/rmu.c
> @@ -0,0 +1,273 @@
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
> +static int mv88e6xxx_validate_port_mac(struct dsa_switch *ds, struct sk_buff *skb)
> +{
> +	unsigned char *ethhdr;
> +	struct dsa_port *dp;
> +	u8 pkt_port;
> +
> +	pkt_port = (skb->data[7] >> 3) & 0xf;
> +	dp = dsa_to_port(ds, pkt_port);
> +	if (!dp) {
> +		dev_dbg_ratelimited(ds->dev, "RMU: couldn't find port for %d\n", pkt_port);
> +		return -ENXIO;
> +	}
> +
> +	/* Check matching MAC */
> +	ethhdr = skb_mac_header(skb);
> +	if (memcmp(dp->slave->dev_addr, ethhdr, ETH_ALEN)) {

ether_addr_equal()

Also, what happens if you don't validate the MAC DA of the response, and
in general, if you just put your MAC SA as the MAC address of the
operationally active RMU DSA master? I guess the whole idea is to
provide a MAC address which the DSA master won't drop with its RX
filter, and its own MAC address is just fine for that.

> +		dev_dbg_ratelimited(ds->dev, "RMU: mismatching MAC address for request. Rx %pM expecting %pM\n",
> +				    ethhdr, dp->slave->dev_addr);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +int mv88e6xxx_inband_rcv(struct dsa_switch *ds, struct sk_buff *skb, int seq_no)
> +{
> +	struct mv88e6xxx_chip *chip = ds->priv;
> +	struct mv88e6xxx_port *port;
> +	u16 prodnum;
> +	u16 format;
> +	u8 pkt_dev;
> +	u8 pkt_prt;
> +	u16 code;
> +	int i;
> +
> +	/* Extract response data */
> +	format = get_unaligned_be16(&skb->data[0]);
> +	if (format != htons(MV88E6XXX_RMU_RESP_FORMAT_1) &&
> +	    format != htons(MV88E6XXX_RMU_RESP_FORMAT_2)) {
> +		dev_err_ratelimited(chip->dev, "RMU: received unknown format 0x%04x", format);
> +		goto out;
> +	}
> +
> +	code = get_unaligned_be16(&skb->data[4]);
> +	if (code == ntohs(MV88E6XXX_RMU_RESP_ERROR)) {

Please build with sparse, "make W=1 C=1". These are all wrong. The
variables retrieved from packet headers should be __be16, and "htohs"
(network to host) should be "htons" (host to network).

> +		dev_err_ratelimited(chip->dev, "RMU: error response code 0x%04x", code);
> +		goto out;
> +	}
> +
> +	pkt_dev = skb->data[6] & 0x1f;
> +	if (!dsa_switch_find(ds->dst->index, pkt_dev)) {

What is the relation between the pkt_dev from here, the RMU header, and
the source_device from dsa_inband_rcv_ll()? Are they always the same?
Can they be different? You throw away the result from dsa_switch_find()
in any case.

> +		dev_err_ratelimited(chip->dev, "RMU: response from unknown chip with index %d\n",
> +				    pkt_dev);
> +		goto out;
> +	}
> +
> +	/* Check sequence number */
> +	if (seq_no != chip->rmu.seq_no) {
> +		dev_err_ratelimited(chip->dev, "RMU: wrong seqno received %d, expected %d",
> +				    seq_no, chip->rmu.seq_no);
> +		goto out;
> +	}
> +
> +	/* Check response code */
> +	switch (chip->rmu.request_cmd) {
> +	case MV88E6XXX_RMU_REQ_GET_ID: {
> +		if (code == MV88E6XXX_RMU_RESP_CODE_GOT_ID) {

I'd expect htons to be used even here, with 0, for type consistency.
The compiler should figure things out and not add extra code.

> +			prodnum = get_unaligned_be16(&skb->data[2]);
> +			chip->rmu.got_id = prodnum;
> +			dev_info_ratelimited(chip->dev, "RMU: received id OK with product number: 0x%04x\n",
> +					     chip->rmu.got_id);
> +		} else {
> +			dev_dbg_ratelimited(chip->dev,
> +					    "RMU: unknown response for GET_ID format 0x%04x code 0x%04x",
> +					    format, code);
> +		}
> +		break;
> +	}
> +	case MV88E6XXX_RMU_REQ_DUMP_MIB:
> +		if (code == MV88E6XXX_RMU_RESP_CODE_DUMP_MIB &&
> +		    !mv88e6xxx_validate_port_mac(ds, skb)) {
> +			pkt_prt = (skb->data[7] & 0x78) >> 3;
> +			port = &chip->ports[pkt_prt];

It would be good if you could structure the code in such a way that you
don't parse stuff from the packet twice, once in mv88e6xxx_validate_port_mac()
and once here.

> +			if (!port) {
> +				dev_err_ratelimited(chip->dev, "RMU: illegal port number in response: %d\n",
> +						    pkt_prt);
> +				goto out;
> +			}
> +
> +			/* Copy whole array for further
> +			 * processing according to chip type
> +			 */
> +			for (i = 0; i < MV88E6XXX_RMU_MAX_RMON; i++)
> +				port->rmu_raw_stats[i] = get_unaligned_be32(&skb->data[12 + i * 4]);
> +		}
> +		break;
> +	default:
> +		dev_err_ratelimited(chip->dev,
> +				    "RMU: unknown response format 0x%04x and code 0x%04x from chip %d\n",
> +				    format, code, chip->ds->index);
> +		break;
> +	}
> +
> +out:
> +	complete(&chip->rmu.completion);
> +
> +	return 0;
> +}
> +
> +static int mv88e6xxx_rmu_tx(struct mv88e6xxx_chip *chip, int port,
> +			    const char *msg, int len)
> +{
> +	const struct dsa_device_ops *tag_ops;
> +	const struct dsa_port *dp;
> +	unsigned char *data;
> +	struct sk_buff *skb;
> +
> +	dp = dsa_to_port(chip->ds, port);
> +	if (!dp || !dp->cpu_dp)
> +		return 0;
> +
> +	tag_ops = dp->cpu_dp->tag_ops;
> +	if (!tag_ops)
> +		return -ENODEV;
> +
> +	skb = netdev_alloc_skb(chip->rmu.netdev, 64);
> +	if (!skb)
> +		return -ENOMEM;
> +
> +	skb_reserve(skb, 2 * ETH_HLEN + tag_ops->needed_headroom);

If you decide to rework this using the master netdev, you can use
dsa_tag_protocol_overhead(master->dsa_ptr->tag_ops). Or even reserve
enough headroom for the larger header (EDSA) and be done with it.
But then you need to construct a different header depending on whether
DSA or EDSA is used.

> +	skb_reset_network_header(skb);
> +	skb->pkt_type = PACKET_OUTGOING;

Could you please explain for me what will setting skb->pkt_type to
PACKET_OUTGOING achieve?

> +	skb->dev = chip->rmu.netdev;
> +
> +	/* Create RMU L3 message */
> +	data = skb_put(skb, len);
> +	memcpy(data, msg, len);
> +
> +	return tag_ops->inband_xmit(skb, dp->slave, ++chip->rmu.seq_no);
> +}
> +
> +static int mv88e6xxx_rmu_send_wait(struct mv88e6xxx_chip *chip, int port,
> +				   int request, const char *msg, int len)
> +{
> +	const struct dsa_port *dp;
> +	int ret = 0;
> +
> +	dp = dsa_to_port(chip->ds, port);
> +	if (!dp)
> +		return 0;
> +
> +	mutex_lock(&chip->rmu.mutex);
> +
> +	chip->rmu.request_cmd = request;
> +
> +	ret = mv88e6xxx_rmu_tx(chip, port, msg, len);
> +	if (ret == -ENODEV) {
> +		/* Device not ready yet? Try again later */
> +		ret = 0;

All the code paths in mv88e6xxx_rmu_tx() that return -ENODEV are
fabricated reasons to have errors, IMO, and in a correct implementation
we should never even get there. Please drop the special casing.

> +		goto out;
> +	}
> +
> +	if (ret) {
> +		dev_dbg(chip->dev, "RMU: error transmitting request (%d)", ret);

Please have a normal log level for an error, dev_err().
Also you can print the symbolic name for the error:

		dev_err(chip->dev, "RMU: error transmitting request (%pe)",
			ERR_PTR(ret));

> +		goto out;
> +	}
> +
> +	ret = wait_for_completion_timeout(&chip->rmu.completion,
> +					  msecs_to_jiffies(MV88E6XXX_WAIT_POLL_TIME_MS));
> +	if (ret == 0) {
> +		dev_dbg(chip->dev,
> +			"RMU: timeout waiting for request %d (%d) on dev:port %d:%d\n",
> +			request, ret, chip->ds->index, port);

Again, please increase the log level of the error condition.
Also, chip->ds->index is useless information, we have info about the
switch via dev_dbg/dev_err.

> +		ret = -ETIMEDOUT;
> +	}
> +
> +out:
> +	mutex_unlock(&chip->rmu.mutex);
> +
> +	return ret > 0 ? 0 : ret;
> +}
> +
> +static int mv88e6xxx_rmu_get_id(struct mv88e6xxx_chip *chip, int port)
> +{
> +	const u8 get_id[8] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
> +	int ret = -1;
> +
> +	if (chip->rmu.got_id)
> +		return 0;
> +
> +	chip->rmu.netdev = dev_get_by_name(&init_net, "chan0");

What if I don't have a slave device called "chan0"? I can't use the RMU?

> +	if (!chip->rmu.netdev) {
> +		dev_dbg(chip->dev, "RMU: unable to get interface");
> +		return -ENODEV;
> +	}
> +
> +	ret = mv88e6xxx_rmu_send_wait(chip, port, MV88E6XXX_RMU_REQ_GET_ID, get_id, 8);
> +	if (ret) {
> +		dev_dbg(chip->dev, "RMU: error for command GET_ID %d index %d\n", ret,
> +			chip->ds->index);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int mv88e6xxx_rmu_stats_get(struct mv88e6xxx_chip *chip, int port, uint64_t *data)
> +{
> +	u8 dump_mib[8] = { 0x00, 0x01, 0x00, 0x00, 0x10, 0x20, 0x00, 0x00 };
> +	int ret;
> +
> +	if (!chip)
> +		return 0;

How can "chip" be NULL?

> +
> +	ret = mv88e6xxx_rmu_get_id(chip, port);
> +	if (ret)
> +		return ret;
> +
> +	/* Send a GET_MIB command */
> +	dump_mib[7] = port;
> +	ret = mv88e6xxx_rmu_send_wait(chip, port, MV88E6XXX_RMU_REQ_DUMP_MIB, dump_mib, 8);
> +	if (ret) {
> +		dev_dbg(chip->dev, "RMU: error for command DUMP_MIB %d dev %d:%d\n", ret,
> +			chip->ds->index, port);
> +		return ret;
> +	}
> +
> +	/* Update MIB for port */
> +	if (chip->info->ops->stats_get_stats)
> +		return chip->info->ops->stats_get_stats(chip, port, data);
> +
> +	return 0;
> +}
> +
> +static struct mv88e6xxx_bus_ops mv88e6xxx_bus_ops = {

static const struct

> +	.get_rmon = mv88e6xxx_rmu_stats_get,
> +};
> +
> +int mv88e6xxx_rmu_init(struct mv88e6xxx_chip *chip)
> +{
> +	dev_info(chip->dev, "RMU: setting up for switch@%d", chip->sw_addr);

Not a whole lotta useful information brought by this. Also,
chip->sw_addr is already visible via dev_info(chip->dev).
I would just drop this.

> +
> +	init_completion(&chip->rmu.completion);
> +
> +	mutex_init(&chip->rmu.mutex);

I would just move these to mv88e6xxx_rmu_setup(), and move
mv88e6xxx_rmu_setup() to rmu.c.

> +
> +	chip->rmu.ops = &mv88e6xxx_bus_ops;

By doing this (combined with the way in which chip->rmu.ops is actually
tested for), you are saying that RMU is available since driver probe time.
But it isn't. It's only available when the master goes up and is
operational. So you're setting yourself up for lots of I/O failures in
the beginning.

> +
> +	return 0;
> +}
> +
> +void mv88e6xxx_rmu_master_change(struct dsa_switch *ds, const struct net_device *master,
> +				 bool operational)
> +{
> +	struct mv88e6xxx_chip *chip = ds->priv;
> +
> +	if (operational)
> +		chip->rmu.ops = &mv88e6xxx_bus_ops;
> +	else
> +		chip->rmu.ops = NULL;
> +}

There is a subtle but very important point to be careful about here,
which is compatibility with multiple CPU ports. If there is a second DSA
master whose state flaps from up to down, this should not affect the
fact that you can still use RMU over the first DSA master. But in your
case it does, so this is a case of how not to write code that accounts
for that.

In fact, given this fact, I think your function prototypes for
chip->info->ops->rmu_enable() are all wrong / not sufficiently
reflective of what the hardware can do. If the hardware has a bit mask
of ports on which RMU operations are possible, why hardcode using
dsa_switch_upstream_port() and not look at which DSA masters/CPU ports
are actually up? At least for the top-most switch. For downstream
switches we can use dsa_switch_upstream_port(), I guess (even that can
be refined, but I'm not aware of setups using multiple DSA links, where
each DSA link ultimately goes to a different upstream switch).
