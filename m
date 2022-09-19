Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65D0C5BD788
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 00:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbiISWjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 18:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbiISWjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 18:39:41 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744D16319
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 15:39:38 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id r18so1958110eja.11
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 15:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=flII6jc+9rFGPIF+0ocnwjB3/ZI53heED66sFgBxVRw=;
        b=qffjn2oxOHRbGpfXGnUSzxOmYP9FUdpk8CmiqDkoowfX4oKhPJd8irs/LuthLPpBwj
         fyPN8/OoVwNixIvuF4VFMI8+uPMKLEskXs7KLBrMaXakgXX7ObMuAnnP4HKbcfMpY5Uy
         cgTuGhVGv6ZpHg4zECc0K48qcX/Z7++KMOtgF9lFOi3UiUZUQecxIY0Yqcn90sszHz3i
         43scoIx3CuyHEjA7P0cm1RjPJScwkOkYVj11O64ilJKMLHz9cqZI9+Har4nJkRQK5wTM
         37xwmuFEgPovUQGAFxNPwqeFQGdNUP1wLfhCHVuV2v3sgEmBDYyu8JtqOzanPSQnFq0N
         sAxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=flII6jc+9rFGPIF+0ocnwjB3/ZI53heED66sFgBxVRw=;
        b=w6pgh0xYl8vHacgYI+ZTxqKkDQnkZB7N7igrVDYeByFs0zfTVXmIw7sKIYEHfAY8TV
         QgXMB80PxQ5usnXR1UNi93cQEOrw0LuCx24GrTu53syK3bgQ3Kl8JG/gAiRDI82X+z3a
         z+LlQ25krutz9SE1Br2ij0CZ/gYSDjyJ8/bHdDCp9+zbeDZsxttZNZ0jKa/+3CtWh1nb
         cjWihfCmgTgNC8ela2AuLodzyBCuQO0bnBMskqGBvjdkNSX3mTiQZcjkvK3c0YhBa94/
         JejgUhUZPsKmh4IQYu4zeBa5ipsi6GBKdYBNMb9f4TodZCBmGuk0UBJf/sWUoGFCx1qu
         /I8Q==
X-Gm-Message-State: ACrzQf2cKSnSfFgw86h+toNAtPjPa+QZRoOAztncFpOijR2HXkIBvMqN
        1FmabOnoAzW27ogexfrIA5w=
X-Google-Smtp-Source: AMsMyM5P5n4BgoaMOZXiUACuTPbY5yrs90TB3Aqy7ajnOwmHmcSnQiCFKjm5nbb0HdD+VE9oRHb1yw==
X-Received: by 2002:a17:907:2d0d:b0:77c:d528:70b8 with SMTP id gs13-20020a1709072d0d00b0077cd52870b8mr14193566ejc.681.1663627176847;
        Mon, 19 Sep 2022 15:39:36 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id lb22-20020a170907785600b0073bdf71995dsm10479726ejc.139.2022.09.19.15.39.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 15:39:36 -0700 (PDT)
Date:   Tue, 20 Sep 2022 01:39:33 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk,
        ansuelsmth@gmail.com
Subject: Re: [PATCH net-next v14 4/7] net: dsa: mv88e6xxxx: Add RMU
 functionality.
Message-ID: <20220919223933.2hh4hhci3pj33lrj@skbuf>
References: <20220919110847.744712-1-mattias.forsblad@gmail.com>
 <20220919110847.744712-1-mattias.forsblad@gmail.com>
 <20220919110847.744712-5-mattias.forsblad@gmail.com>
 <20220919110847.744712-5-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220919110847.744712-5-mattias.forsblad@gmail.com>
 <20220919110847.744712-5-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 19, 2022 at 01:08:44PM +0200, Mattias Forsblad wrote:
>  struct mv88e6xxx_bus_ops {
> diff --git a/drivers/net/dsa/mv88e6xxx/rmu.c b/drivers/net/dsa/mv88e6xxx/rmu.c
> new file mode 100644
> index 000000000000..c5b3c156de40
> --- /dev/null
> +++ b/drivers/net/dsa/mv88e6xxx/rmu.c
> @@ -0,0 +1,263 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Marvell 88E6xxx Switch Remote Management Unit Support
> + *
> + * Copyright (c) 2022 Mattias Forsblad <mattias.forsblad@gmail.com>
> + *
> + */
> +
> +#include <asm/unaligned.h>

Nothing in this file uses asm/unaligned.h. On the other hand, it uses
struct dsa_switch, struct sk_buff, struct net_device, etc etc, which are
nowhere to be found in included headers. Don't rely on transitive header
inclusion. What rmu.h and global1.h include are just for the data
structures referenced within those headers to make sense when included
from any C file.

> +#include "rmu.h"
> +#include "global1.h"
> +
> +static const u8 mv88e6xxx_rmu_dest_addr[ETH_ALEN] = { 0x01, 0x50, 0x43, 0x00, 0x00, 0x00 };
> +
> +static void mv88e6xxx_rmu_create_l2(struct dsa_switch *ds, struct sk_buff *skb)
> +{
> +	struct mv88e6xxx_chip *chip = ds->priv;
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
> +	dsa_header[0] |= FIELD_PREP(MV88E6XXX_TRG_DEV_MASK, ds->index);
> +	dsa_header[1] = FIELD_PREP(MV88E6XXX_RMU_CODE_MASK, 1);
> +	dsa_header[1] |= FIELD_PREP(MV88E6XXX_RMU_L2_BYTE1_RESV, MV88E6XXX_RMU_L2_BYTE1_RESV_VAL);
> +	dsa_header[2] = FIELD_PREP(MV88E6XXX_RMU_PRIO_MASK, MV88E6XXX_RMU_PRIO);
> +	dsa_header[2] |= MV88E6XXX_RMU_L2_BYTE2_RESV;
> +	dsa_header[3] = ++chip->rmu.seqno;
> +	dsa_header[4] = 0;
> +	dsa_header[5] = 0;
> +
> +	/* Insert RMU MAC destination address /w extra if needed */
> +	eth = skb_push(skb, ETH_ALEN * 2 + extra);
> +	memcpy(eth->h_dest, mv88e6xxx_rmu_dest_addr, ETH_ALEN);
> +	ether_addr_copy(eth->h_source, chip->rmu.master_netdev->dev_addr);

Come on.... really? Do I need to spell out "ether_addr_copy()" twice
during review, for consecutive lines?

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
> +static int mv88e6xxx_rmu_send_wait(struct mv88e6xxx_chip *chip,
> +				   const void *req, int req_len,
> +				   void *resp, unsigned int *resp_len)
> +{
> +	struct sk_buff *skb;
> +	unsigned char *data;
> +	int ret = 0;
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
> +	mv88e6xxx_rmu_create_l2(chip->ds, skb);
> +
> +	mutex_lock(&chip->rmu.mutex);
> +
> +	ret = dsa_switch_inband_tx(chip->ds, skb, NULL, MV88E6XXX_RMU_WAIT_TIME_MS);
> +	if (!ret) {
> +		dev_err(chip->dev, "RMU: error waiting for request (%pe)\n",
> +			ERR_PTR(ret));
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
> +	kfree_skb(chip->rmu.resp);
> +	chip->rmu.resp = NULL;
> +
> +out:
> +	mutex_unlock(&chip->rmu.mutex);
> +
> +	return ret > 0 ? 0 : ret;
> +}

This function is mixing return values from dsa_switch_inband_tx()
(really wait_for_completion_timeout(), where 0 is timeout) with negative
return values. What should the caller check for success? Yes.

> +
> +static int mv88e6xxx_rmu_validate_response(struct mv88e6xxx_rmu_header *resp, int code)
> +{
> +	if (be16_to_cpu(resp->format) != MV88E6XXX_RMU_RESP_FORMAT_1 &&
> +	    be16_to_cpu(resp->format) != MV88E6XXX_RMU_RESP_FORMAT_2 &&
> +	    be16_to_cpu(resp->code) != code) {
> +		net_dbg_ratelimited("RMU: received unknown format 0x%04x code 0x%04x",
> +				    resp->format, resp->code);
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int mv88e6xxx_rmu_get_id(struct mv88e6xxx_chip *chip, int port)
> +{
> +	const u16 req[4] = { MV88E6XXX_RMU_REQ_FORMAT_GET_ID,
> +			     MV88E6XXX_RMU_REQ_PAD,
> +			     MV88E6XXX_RMU_REQ_CODE_GET_ID,
> +			     MV88E6XXX_RMU_REQ_DATA};
> +	struct mv88e6xxx_rmu_header resp;
> +	int resp_len;
> +	int ret = -1;

Don't initialize variables you'll overwrite immediately afterwards.

There is at least one other place in this patch which does that and
which should therefore also be changed. I won't say where that is,
I want to force you to read your changes.

> +
> +	resp_len = sizeof(resp);
> +	ret = mv88e6xxx_rmu_send_wait(chip, req, sizeof(req),
> +				      &resp, &resp_len);
> +	if (ret) {
> +		dev_dbg(chip->dev, "RMU: error for command GET_ID %pe\n", ERR_PTR(ret));
> +		return ret;
> +	}
> +
> +	/* Got response */
> +	ret = mv88e6xxx_rmu_validate_response(&resp, MV88E6XXX_RMU_RESP_CODE_GOT_ID);
> +	if (ret)
> +		return ret;
> +
> +	chip->rmu.prodnr = be16_to_cpu(resp.prodnr);
> +
> +	return ret;

return 0.

> +}
> +
> +static void mv88e6xxx_disable_rmu(struct mv88e6xxx_chip *chip)
> +{
> +	chip->smi_ops = chip->rmu.smi_ops;
> +	chip->ds->ops = chip->rmu.ds_rmu_ops;

Who modifies chip->ds->ops? This smells trouble. Big, big trouble.

> +	chip->rmu.master_netdev = NULL;
> +
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

It's really nice that in the mv88e6xxx_enable_check_rmu() ->
mv88e6xxx_rmu_get_id() -> mv88e6xxx_rmu_send_wait() call path, first you
check for ret != 0 as meaning error, then for ret == 0 as meaning error.
So you catch a bit of everything.

> +
> +	chip->ds->ops = chip->rmu.ds_rmu_ops;
> +	chip->smi_ops = chip->rmu.smi_rmu_ops;
> +
> +	return 0;
> +}
> +
> +void mv88e6xxx_master_state_change(struct dsa_switch *ds, const struct net_device *master,
> +				   bool operational)
> +{
> +	struct dsa_port *cpu_dp = master->dsa_ptr;
> +	struct mv88e6xxx_chip *chip = ds->priv;
> +	int port;
> +	int ret;
> +
> +	port = dsa_towards_port(ds, cpu_dp->ds->index, cpu_dp->index);
> +
> +	mv88e6xxx_reg_lock(chip);
> +
> +	if (operational && chip->info->ops->rmu_enable) {

This all needs to be rewritten. Like here, if the master is operational
but the chip->info->ops->rmu_enable method is not populated, you call
mv88e6xxx_disable_rmu(). Why?

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

Or here, if this fails, you goto out, which does nothing special
compared to simply not checking the return code. But you don't disable
the RMU back.

> +
> +		} else {
> +			dev_err(chip->dev, "RMU: Unable to enable on port %d %pe",
> +				port, ERR_PTR(ret));
> +			goto out;
> +		}
> +	} else {
> +		mv88e6xxx_disable_rmu(chip);
> +	}
> +
> +out:
> +	mv88e6xxx_reg_unlock(chip);
> +}
