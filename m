Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7387F6AC25F
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 15:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbjCFOIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 09:08:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbjCFOH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 09:07:29 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 643B130B3B;
        Mon,  6 Mar 2023 06:07:00 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id ay14so35330667edb.11;
        Mon, 06 Mar 2023 06:07:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678111614;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=o18xGJE6G8VHczzh6g7gWOmbuvdeK4kZly98pWL+YIw=;
        b=C0tZblsfBKXEXQDTu8AQ9okK72sV10Lj8fUtLen79rRP162xxFh6V80y/fOLsZOrUv
         aoHDmPA98fa7ofgjq51pzVJXdPhbXcsL+3o/Egcy+vVjkBNCHrmE34+KmNrJ9c+T5Car
         9SXz+jiEPcvaA5xQh9c4we0yljrlzp1hOyOfSWz8cTULp39u9LDkl5UFX7twglzQ2ZU9
         fz0guwViJopyltAnAlI7qp2/xEjcMR747eZRmaup6GdwysFtxXnizbSBhCiKgms6zLsd
         b+fI1SmKu/TCP67OfLycQjoNzE52FjLw9erjJDvSLxELYiucZuxcC64xU8X56wu3Efuf
         ycjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678111614;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o18xGJE6G8VHczzh6g7gWOmbuvdeK4kZly98pWL+YIw=;
        b=324OduprLAn3PteELvKxJeB8r1hUb/M0T+fV+a+uLkmQ6zO/P+ZPK0muwN6cPDsvPD
         MQh0Swqc1N4HXNm+7Lf6AcoIfuReZYySF/haQCXNjggSXU0tKpIWy+yLqv8hrBD+pYWf
         DN+MVUEXDCS5fLvYpY/xN81wg/bvmi65YaxF4fd9Etcw/hKbEpW6Ql+/OzvIYGHUto24
         ycD4XjpobMt2xRx1gprCxlUcDrDkDzWUS/6Kp5l8nRxeEyrCOVOydO7puP1dNGXywhSn
         WuQN0hvBnzvXWEe5j2O4Tu/zCu2jV6NohVbr9Xa4gMcE/gloSiKrlI1NIUs+BgjE9fli
         8mIw==
X-Gm-Message-State: AO0yUKVD/3kz0CsCUkrxX1rU0Nsx8lp6V9lwKYshb5fVCO+/ewyBD0p3
        dMoQy52jc+tfrbHXaylB4bs=
X-Google-Smtp-Source: AK7set+o8V/2NfbY3mB0VxCHYW8A5t6Xr5+22VYb8HihbEy/mp9ayI8JgmGQ1ZnL5Zz08T0vy4QP6g==
X-Received: by 2002:a17:906:ceca:b0:8c0:386e:6693 with SMTP id si10-20020a170906ceca00b008c0386e6693mr10149194ejb.63.1678111614021;
        Mon, 06 Mar 2023 06:06:54 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id le16-20020a170907171000b008da6a37de1bsm4711947ejc.10.2023.03.06.06.06.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 06:06:53 -0800 (PST)
Date:   Mon, 6 Mar 2023 16:06:51 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Woojung Huh <woojung.huh@microchip.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v1 2/2] net: dsa: microchip: add ETS Qdisc
 support for KSZ9477 series
Message-ID: <20230306140651.kqayqatlrccfky2b@skbuf>
References: <20230306124940.865233-1-o.rempel@pengutronix.de>
 <20230306124940.865233-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306124940.865233-2-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij,

On Mon, Mar 06, 2023 at 01:49:40PM +0100, Oleksij Rempel wrote:
> Add ETS Qdisc support for KSZ9477 of switches. Current implementation is
> limited to strict priority mode.
> 
> Tested on KSZ8563R with following configuration:
> tc qdisc replace dev lan2 root handle 1: ets strict 4 \
>   priomap 3 3 2 2 1 1 0 0
> ip link add link lan2 name v1 type vlan id 1 \
>   egress-qos-map 0:0 1:1 2:2 3:3 4:4 5:5 6:6 7:7
> 
> and patched iperf3 version:
> https://github.com/esnet/iperf/pull/1476
> iperf3 -c 172.17.0.1 -b100M  -l1472 -t100 -u -R --sock-prio 2
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/dsa/microchip/ksz_common.c | 178 +++++++++++++++++++++++++
>  drivers/net/dsa/microchip/ksz_common.h |  12 ++
>  2 files changed, 190 insertions(+)
> 
> diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> index ae05fe0b0a81..f32ad39c1d8d 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -3172,12 +3172,190 @@ static int ksz_setup_tc_cbs(struct dsa_switch *ds, int port,
>  				 MTI_SHAPING_SRP);
>  }
>  
> +static int ksz_ets_band_to_queue(struct tc_ets_qopt_offload_replace_params *p,
> +				 int band)
> +{
> +	/* Compared to queues, bands prioritize packets differently. In strict
> +	 * priority mode, the lowest priority is assigned to Queue 0 while the
> +	 * highest priority is given to Band 0.
> +	 */
> +	return p->bands - 1 - band;
> +}
> +
> +static int ksz_queue_set_strict(struct ksz_device *dev, int port, int queue)
> +{
> +	int ret;
> +
> +	/* In order to ensure proper prioritization, it is necessary to set the
> +	 * rate limit for the related queue to zero. Otherwise strict priority
> +	 * mode will not work.
> +	 */
> +	ret = ksz_pwrite8(dev, port, KSZ9477_REG_PORT_OUT_RATE_0 + queue,
> +			  KSZ9477_OUT_RATE_NO_LIMIT);
> +	if (ret)
> +		return ret;
> +
> +	ret = ksz_pwrite32(dev, port, REG_PORT_MTI_QUEUE_INDEX__4, queue);
> +	if (ret)
> +		return ret;
> +
> +	return ksz_setup_tc_mode(dev, port, MTI_SCHEDULE_STRICT_PRIO,
> +				 MTI_SHAPING_OFF);
> +}
> +
> +static int ksz_queue_set_wrr(struct ksz_device *dev, int port, int queue,
> +			     int weight)
> +{
> +	int ret;
> +
> +	/* In order to ensure proper prioritization, it is necessary to set the
> +	 * rate limit for the related queue to zero. Otherwise weighted round
> +	 * robin mode will not work.
> +	 */
> +	ret = ksz_pwrite8(dev, port, KSZ9477_REG_PORT_OUT_RATE_0 + queue,
> +			  KSZ9477_OUT_RATE_NO_LIMIT);
> +	if (ret)
> +		return ret;
> +
> +	ret = ksz_pwrite32(dev, port, REG_PORT_MTI_QUEUE_INDEX__4, queue);
> +	if (ret)
> +		return ret;
> +
> +	ret = ksz_setup_tc_mode(dev, port, MTI_SCHEDULE_WRR,
> +				MTI_SHAPING_OFF);
> +	if (ret)
> +		return ret;
> +
> +	return ksz_pwrite8(dev, port, KSZ9477_PORT_MTI_QUEUE_CTRL_1, weight);
> +}
> +
> +static int ksz_tc_ets_add(struct ksz_device *dev, int port,
> +			  struct tc_ets_qopt_offload_replace_params *p)
> +{
> +	int ret, band, tc_prio;
> +	u32 queue_map = 0;
> +
> +	/* Configure queue scheduling mode for all bands. Currently only strict
> +	 * prio mode is supported.
> +	 */
> +	for (band = 0; band < p->bands; band++) {
> +		int queue = ksz_ets_band_to_queue(p, band);
> +
> +		ret = ksz_queue_set_strict(dev, port, queue);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	/* Configure the mapping between traffic classes and queues. Note:
> +	 * priomap variable support 16 traffic classes, but the chip can handle
> +	 * only 8 classes.
> +	 */
> +	for (tc_prio = 0; tc_prio < ARRAY_SIZE(p->priomap); tc_prio++) {
> +		int queue;
> +
> +		if (tc_prio > KSZ9477_MAX_TC_PRIO)
> +			break;
> +
> +		queue = ksz_ets_band_to_queue(p, p->priomap[tc_prio]);
> +		queue_map |= queue << (tc_prio * KSZ9477_PORT_TC_MAP_S);
> +	}
> +
> +	return ksz_pwrite32(dev, port, KSZ9477_PORT_MRI_TC_MAP__4, queue_map);
> +}
> +
> +static int ksz_tc_ets_del(struct ksz_device *dev, int port)
> +{
> +	int ret, queue;
> +
> +	/* To restore the default chip configuration, set all queues to use the
> +	 * WRR scheduler with a weight of 1.
> +	 */
> +	for (queue = 0; queue < dev->info->num_tx_queues; queue++) {
> +		ret = ksz_queue_set_wrr(dev, port, queue,
> +					KSZ9477_DEFAULT_WRR_WEIGHT);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	/* Revert the queue mapping for TC-priority to its default setting on
> +	 * the chip.
> +	 */
> +	return ksz_pwrite32(dev, port, KSZ9477_PORT_MRI_TC_MAP__4,
> +			    KSZ9477_DEFAULT_TC_MAP);
> +}
> +
> +static int ksz_tc_ets_validate(struct ksz_device *dev, int port,
> +			       struct tc_ets_qopt_offload_replace_params *p)
> +{
> +	int band;
> +
> +	/* Since it is not feasible to share one port among multiple qdisc,
> +	 * the user must configure all available queues appropriately.
> +	 */
> +	if (p->bands != dev->info->num_tx_queues) {
> +		dev_err(dev->dev, "Not supported amount of bands. It should be %d\n",
> +			dev->info->num_tx_queues);
> +		return -EOPNOTSUPP;
> +	}
> +
> +	for (band = 0; band < p->bands; ++band) {
> +		/* The KSZ switches utilize a weighted round robin configuration
> +		 * where a certain number of packets can be transmitted from a
> +		 * queue before the next queue is serviced. For more information
> +		 * on this, refer to section 5.2.8.4 of the KSZ8565R
> +		 * documentation on the Port Transmit Queue Control 1 Register.
> +		 * However, the current ETS Qdisc implementation (as of February
> +		 * 2023) assigns a weight to each queue based on the number of
> +		 * bytes or extrapolated bandwidth in percentages. Since this
> +		 * differs from the KSZ switches' method and we don't want to
> +		 * fake support by converting bytes to packets, we have decided
> +		 * to return an error instead.
> +		 */
> +		if (p->quanta[band]) {
> +			dev_err(dev->dev, "Quanta/weights configuration is not supported.\n");
> +			return -EOPNOTSUPP;
> +		}

So what does the user gain using tc-ets over tc-mqprio? That has a way
to set up strict prioritization and prio:tc maps as well, and to my
knowledge mqprio is vastly more popular in non-DCB setups than tc-ets.
The only thing is that with mqprio, AFAIK, the round robin between TXQs
belonging to the same traffic class is not weighted.

> +	}
> +
> +	return 0;
> +}
> +
> +static int ksz_tc_setup_qdisc_ets(struct dsa_switch *ds, int port,
> +				  struct tc_ets_qopt_offload *qopt)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	int ret;
> +
> +	if (qopt->parent != TC_H_ROOT) {
> +		dev_err(dev->dev, "Parent should be \"root\"\n");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	switch (qopt->command) {
> +	case TC_ETS_REPLACE:
> +		ret = ksz_tc_ets_validate(dev, port, &qopt->replace_params);
> +		if (ret)
> +			return ret;
> +
> +		return ksz_tc_ets_add(dev, port, &qopt->replace_params);
> +	case TC_ETS_DESTROY:
> +		return ksz_tc_ets_del(dev, port);
> +	case TC_ETS_STATS:
> +	case TC_ETS_GRAFT:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return -EOPNOTSUPP;
> +}
> +
>  static int ksz_setup_tc(struct dsa_switch *ds, int port,
>  			enum tc_setup_type type, void *type_data)
>  {
>  	switch (type) {
>  	case TC_SETUP_QDISC_CBS:
>  		return ksz_setup_tc_cbs(ds, port, type_data);
> +	case TC_SETUP_QDISC_ETS:
> +		return ksz_tc_setup_qdisc_ets(ds, port, type_data);
>  	default:
>  		return -EOPNOTSUPP;
>  	}
> diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
> index f53834bbe896..7618a4714e06 100644
> --- a/drivers/net/dsa/microchip/ksz_common.h
> +++ b/drivers/net/dsa/microchip/ksz_common.h
> @@ -657,6 +657,15 @@ static inline int is_lan937x(struct ksz_device *dev)
>  #define KSZ8_LEGAL_PACKET_SIZE		1518
>  #define KSZ9477_MAX_FRAME_SIZE		9000
>  
> +#define KSZ9477_REG_PORT_OUT_RATE_0	0x0420
> +#define KSZ9477_OUT_RATE_NO_LIMIT	0
> +
> +#define KSZ9477_PORT_MRI_TC_MAP__4	0x0808
> +#define KSZ9477_DEFAULT_TC_MAP		0x33221100
> +
> +#define KSZ9477_PORT_TC_MAP_S		4
> +#define KSZ9477_MAX_TC_PRIO		7
> +
>  /* CBS related registers */
>  #define REG_PORT_MTI_QUEUE_INDEX__4	0x0900
>  
> @@ -670,6 +679,9 @@ static inline int is_lan937x(struct ksz_device *dev)
>  #define MTI_SHAPING_SRP			1
>  #define MTI_SHAPING_TIME_AWARE		2
>  
> +#define KSZ9477_PORT_MTI_QUEUE_CTRL_1	0x0915
> +#define KSZ9477_DEFAULT_WRR_WEIGHT	1
> +
>  #define REG_PORT_MTI_HI_WATER_MARK	0x0916
>  #define REG_PORT_MTI_LO_WATER_MARK	0x0918
>  
> -- 
> 2.30.2
> 
