Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A30446C12
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 03:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbhKFCit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 22:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbhKFCiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 22:38:46 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678B8C061570;
        Fri,  5 Nov 2021 19:36:06 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id v40-20020a056830092800b0055591caa9c6so15856663ott.4;
        Fri, 05 Nov 2021 19:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=3bFRxCam3i65FImjCKBxmhDn6/CmRNClifkkaqSDC2I=;
        b=ip6BmWwFoB5FlK0MzqK1lCYiJJXjponK/qZ3A2kVuY6LgJJWBvYMjAf4k58jLzHBik
         rnBNlxR5fMmAiUvEQNRLdDT2IQR4KdwSo1UFKip5SoUsa6W3bwWAAQJm/JNVtultAZBg
         peN5SYDEhA95VPaF8b4+52DG8ArTmievJf4HCOOEuYWca1HwkFV6TtQFz5DJLZxpqSzl
         h5vru6jwUeQd/glpGWt1sND/Ifoki6wmLxKeAzlDNUmnZk1SCeFHAXZM8BAvXS3XiNJ4
         6is8CoxZcs+RbKAM3gSFSlrxJHbVvOglGFbEhIdsZm1bqUCpYTMxPEDVwhIxQJ2LkTyy
         3lzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3bFRxCam3i65FImjCKBxmhDn6/CmRNClifkkaqSDC2I=;
        b=WrtvbUUhA+jhsWvcKTd/sR5Wg4VgHRvT3fKoI2ZYThdVMc57cFXomr5OaoSx6XF8du
         VfiY5mB3qFWmznK1BrWA+FjdnIfEEgxGmaigWuwgEHb1QSika9TnbCaXjMca0irjEndY
         GvH2zm8C+BqDOra3WTyNaHWwD4huYRoyvfM44x9N6cfkiEf5RNFwj/xQIG85BGzyFHLz
         jr3T4KLvAfeBrNU1+Twwfoav42EdH6p4MBUgu/POV7OmURhbBryEV45ZwkvXs1Hna2yo
         A2pxwreXKzk0FZhFt2qk406F67h/s0hDF8pa1MnGOL57PzneNPN04UVY0ekcXVi4pgDL
         N6Qw==
X-Gm-Message-State: AOAM530RRjbcRRSlGlSHmml0AuIwxDvjJgbShH1takd1qla69aPEKhkM
        Zzbgq75OkZUgES7d0vVeX7c=
X-Google-Smtp-Source: ABdhPJw56Xol+rvOBcQAZs39mp23MSFD9qz/J8kwsqXVRiK231PXNcJC9QWpzUS/mEjvmvqEjflsAQ==
X-Received: by 2002:a05:6830:1514:: with SMTP id k20mr13426963otp.208.1636166165752;
        Fri, 05 Nov 2021 19:36:05 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:14e0:e534:f753:ba71? ([2600:1700:dfe0:49f0:14e0:e534:f753:ba71])
        by smtp.gmail.com with ESMTPSA id k22sm3207578otn.44.2021.11.05.19.36.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Nov 2021 19:36:05 -0700 (PDT)
Message-ID: <fdf46c6e-b5bc-403c-cca9-4131bd7b74f2@gmail.com>
Date:   Fri, 5 Nov 2021 19:36:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH 5/7] net: dsa: b53: Add logic for RX timestamping
Content-Language: en-US
To:     Martin Kaistra <martin.kaistra@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20211104133204.19757-1-martin.kaistra@linutronix.de>
 <20211104133204.19757-6-martin.kaistra@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211104133204.19757-6-martin.kaistra@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/4/2021 6:31 AM, Martin Kaistra wrote:
> Packets received by the tagger with opcode=1 contain the 32-bit timestamp
> according to the timebase register. This timestamp is saved in
> BRCM_SKB_CB(skb)->meta_tstamp. b53_port_rxtstamp() takes this
> and puts the full time information from the timecounter into
> shwt->hwtstamp.
> 
> Signed-off-by: Martin Kaistra <martin.kaistra@linutronix.de>
> ---
>   drivers/net/dsa/b53/b53_common.c |  1 +
>   drivers/net/dsa/b53/b53_ptp.c    | 28 ++++++++++++++++++++++++++
>   drivers/net/dsa/b53/b53_ptp.h    | 10 ++++++++++
>   include/linux/dsa/b53.h          | 30 ++++++++++++++++++++++++++++
>   net/dsa/tag_brcm.c               | 34 ++++++++++++++++++++++----------
>   5 files changed, 93 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
> index ed590efbd3bf..a9408f9cd414 100644
> --- a/drivers/net/dsa/b53/b53_common.c
> +++ b/drivers/net/dsa/b53/b53_common.c
> @@ -2300,6 +2300,7 @@ static const struct dsa_switch_ops b53_switch_ops = {
>   	.port_max_mtu		= b53_get_max_mtu,
>   	.port_change_mtu	= b53_change_mtu,
>   	.get_ts_info		= b53_get_ts_info,
> +	.port_rxtstamp		= b53_port_rxtstamp,
>   };
>   
>   struct b53_chip_data {
> diff --git a/drivers/net/dsa/b53/b53_ptp.c b/drivers/net/dsa/b53/b53_ptp.c
> index 324335465232..86ebaa522084 100644
> --- a/drivers/net/dsa/b53/b53_ptp.c
> +++ b/drivers/net/dsa/b53/b53_ptp.c
> @@ -6,6 +6,8 @@
>    * Copyright (C) 2021 Linutronix GmbH
>    */
>   
> +#include <linux/ptp_classify.h>
> +
>   #include "b53_priv.h"
>   #include "b53_ptp.h"
>   
> @@ -107,6 +109,32 @@ static void b53_ptp_overflow_check(struct work_struct *work)
>   	schedule_delayed_work(&dev->overflow_work, B53_PTP_OVERFLOW_PERIOD);
>   }
>   
> +bool b53_port_rxtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb,
> +		       unsigned int type)
> +{
> +	struct b53_device *dev = ds->priv;
> +	struct b53_port_hwtstamp *ps = &dev->ports[port].port_hwtstamp;
> +	struct skb_shared_hwtstamps *shwt;
> +	u64 ns;
> +
> +	if (type != PTP_CLASS_V2_L2)
> +		return false;
> +
> +	if (!test_bit(B53_HWTSTAMP_ENABLED, &ps->state))
> +		return false;
> +
> +	mutex_lock(&dev->ptp_mutex);
> +	ns = BRCM_SKB_CB(skb)->meta_tstamp;
> +	ns = timecounter_cyc2time(&dev->tc, ns);

Why not fold this directly:

	ns = timecoutner_cyc2time(&dev->tc, (u64)BRCM_SKB_CB(skb)->meta_stamp)

> +	mutex_unlock(&dev->ptp_mutex);
> +
> +	shwt = skb_hwtstamps(skb);
> +	memset(shwt, 0, sizeof(*shwt));
> +	shwt->hwtstamp = ns_to_ktime(ns);
> +
> +	return false;
> +}
> +
>   int b53_ptp_init(struct b53_device *dev)
>   {
>   	mutex_init(&dev->ptp_mutex);
> diff --git a/drivers/net/dsa/b53/b53_ptp.h b/drivers/net/dsa/b53/b53_ptp.h
> index 5cd2fd9621a2..3b3437870c55 100644
> --- a/drivers/net/dsa/b53/b53_ptp.h
> +++ b/drivers/net/dsa/b53/b53_ptp.h
> @@ -9,11 +9,15 @@
>   
>   #include "b53_priv.h"
>   
> +#define SKB_PTP_TYPE(__skb) (*(unsigned int *)((__skb)->cb))
> +
>   #ifdef CONFIG_B53_PTP
>   int b53_ptp_init(struct b53_device *dev);
>   void b53_ptp_exit(struct b53_device *dev);
>   int b53_get_ts_info(struct dsa_switch *ds, int port,
>   		    struct ethtool_ts_info *info);
> +bool b53_port_rxtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb,
> +		       unsigned int type);
>   #else /* !CONFIG_B53_PTP */
>   
>   static inline int b53_ptp_init(struct b53_device *dev)
> @@ -31,5 +35,11 @@ static inline int b53_get_ts_info(struct dsa_switch *ds, int port,
>   	return -EOPNOTSUPP;
>   }
>   
> +static inline bool b53_port_rxtstamp(struct dsa_switch *ds, int port,
> +				     struct sk_buff *skb, unsigned int type)
> +{
> +	return false;
> +}
> +
>   #endif
>   #endif
> diff --git a/include/linux/dsa/b53.h b/include/linux/dsa/b53.h
> index 85aa6d9dc53d..542e5e3040d6 100644
> --- a/include/linux/dsa/b53.h
> +++ b/include/linux/dsa/b53.h
> @@ -46,9 +46,32 @@ struct b53_io_ops {
>   					struct phylink_link_state *state);
>   };
>   
> +/* state flags for b53_port_hwtstamp::state */
> +enum {
> +	B53_HWTSTAMP_ENABLED,
> +	B53_HWTSTAMP_TX_IN_PROGRESS,
> +};
> +
> +struct b53_port_hwtstamp {
> +	/* Port index */
> +	int port_id;
> +
> +	/* Timestamping state */
> +	unsigned long state;
> +
> +	/* Resources for transmit timestamping */
> +	unsigned long tx_tstamp_start;
> +	struct sk_buff *tx_skb;
> +
> +	/* Current timestamp configuration */
> +	struct hwtstamp_config tstamp_config;
> +};
> +
>   struct b53_port {
>   	u16 vlan_ctl_mask;
>   	struct ethtool_eee eee;
> +	/* Per-port timestamping resources */
> +	struct b53_port_hwtstamp port_hwtstamp;
>   };
>   
>   struct b53_vlan {
> @@ -112,3 +135,10 @@ struct b53_device {
>   #define B53_PTP_OVERFLOW_PERIOD (HZ / 2)
>   	struct delayed_work overflow_work;
>   };
> +
> +struct brcm_skb_cb {
> +	struct sk_buff *clone;
> +	u32 meta_tstamp;
> +};
> +
> +#define BRCM_SKB_CB(skb) ((struct brcm_skb_cb *)(skb)->cb)
> diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
> index 96dbb8ee2fee..85dc47c22008 100644
> --- a/net/dsa/tag_brcm.c
> +++ b/net/dsa/tag_brcm.c
> @@ -9,6 +9,7 @@
>   #include <linux/etherdevice.h>
>   #include <linux/list.h>
>   #include <linux/slab.h>
> +#include <linux/dsa/b53.h>
>   
>   #include "dsa_priv.h"
>   
> @@ -31,7 +32,10 @@
>   /* 6th byte in the tag */
>   #define BRCM_LEG_PORT_ID	(0xf)
>   
> -/* Newer Broadcom tag (4 bytes) */
> +/* Newer Broadcom tag (4 bytes)
> + * For egress, when opcode = 0001, additional 4 bytes are used for
> + * the time stamp.
> + */
>   #define BRCM_TAG_LEN	4
>   
>   /* Tag is constructed and desconstructed using byte by byte access
> @@ -136,19 +140,26 @@ static struct sk_buff *brcm_tag_xmit_ll(struct sk_buff *skb,
>    */
>   static struct sk_buff *brcm_tag_rcv_ll(struct sk_buff *skb,
>   				       struct net_device *dev,
> -				       unsigned int offset)
> +				       unsigned int offset,
> +				       int *tag_len)
>   {
>   	int source_port;
>   	u8 *brcm_tag;
> +	u32 tstamp;
> +
> +	*tag_len = 8;

I believe you have to do this in a two step process, first check that 
you can pull 4 bytes, read the Broadcom tag's opcode, then pull the 
additional 4 bytes if the opcode is 1.

>   
> -	if (unlikely(!pskb_may_pull(skb, BRCM_TAG_LEN)))
> +	if (unlikely(!pskb_may_pull(skb, *tag_len)))
>   		return NULL;
>   
>   	brcm_tag = skb->data - offset;
>   
> -	/* The opcode should never be different than 0b000 */
> -	if (unlikely((brcm_tag[0] >> BRCM_OPCODE_SHIFT) & BRCM_OPCODE_MASK))
> -		return NULL;
> +	if ((brcm_tag[0] >> BRCM_OPCODE_SHIFT) & BRCM_OPCODE_MASK) {
> +		tstamp = brcm_tag[4] << 24 | brcm_tag[5] << 16 | brcm_tag[6] << 8 | brcm_tag[7];
> +		BRCM_SKB_CB(skb)->meta_tstamp = tstamp;
> +	} else {
> +		*tag_len = BRCM_TAG_LEN;
> +	}
>   
>   	/* We should never see a reserved reason code without knowing how to
>   	 * handle it
> @@ -164,7 +175,7 @@ static struct sk_buff *brcm_tag_rcv_ll(struct sk_buff *skb,
>   		return NULL;
>   
>   	/* Remove Broadcom tag and update checksum */
> -	skb_pull_rcsum(skb, BRCM_TAG_LEN);
> +	skb_pull_rcsum(skb, *tag_len);
>   
>   	dsa_default_offload_fwd_mark(skb);
>   
> @@ -184,13 +195,14 @@ static struct sk_buff *brcm_tag_xmit(struct sk_buff *skb,
>   static struct sk_buff *brcm_tag_rcv(struct sk_buff *skb, struct net_device *dev)
>   {
>   	struct sk_buff *nskb;
> +	int tag_len;
>   
>   	/* skb->data points to the EtherType, the tag is right before it */
> -	nskb = brcm_tag_rcv_ll(skb, dev, 2);
> +	nskb = brcm_tag_rcv_ll(skb, dev, 2, &tag_len);
>   	if (!nskb)
>   		return nskb;
>   
> -	dsa_strip_etype_header(skb, BRCM_TAG_LEN);
> +	dsa_strip_etype_header(skb, tag_len);
>   
>   	return nskb;
>   }
> @@ -295,8 +307,10 @@ static struct sk_buff *brcm_tag_xmit_prepend(struct sk_buff *skb,
>   static struct sk_buff *brcm_tag_rcv_prepend(struct sk_buff *skb,
>   					    struct net_device *dev)
>   {
> +	int tag_len;
> +
>   	/* tag is prepended to the packet */
> -	return brcm_tag_rcv_ll(skb, dev, ETH_HLEN);
> +	return brcm_tag_rcv_ll(skb, dev, ETH_HLEN, &tag_len);
>   }
>   
>   static const struct dsa_device_ops brcm_prepend_netdev_ops = {
> 

-- 
Florian
