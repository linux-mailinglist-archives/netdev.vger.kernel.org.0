Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFEA291743
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 14:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgJRMCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 08:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbgJRMCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 08:02:54 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC065C061755
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 05:02:52 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id t21so7394257eds.6
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 05:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1oL6wKbpdBggAADbjDTs5ZMpMJ3k/Fw83Q1im9LBzAY=;
        b=Iabi3WI7qaRPzMpBZfFjZ/IcUe8tsdTpmmTKrNGba9a7gSNMcmXT8L1EEUWxOKhIng
         82JJo5afh38V4GnpJv0s4zg4xa/OwpwvlMw0o2uNZCCsiaMIas8KpAkH6lvk0Wh0X+Bg
         SdzK5c1OcH+Gt9KfTtJoBsXLPPF4+g50VT2xNJ5Jc4l6mw/+TjJtHGNYe+DUPwSSvlR/
         nlj5FZgkVxXGFI3IC7BTzfHTrzyCEbgYLxL/pR+G5qoHU1kixpGqxn7eD7/6U8NxJKHV
         7vorIWHs0kwbNHDHFBgKIxcLEPQ/Mpo7hWXUKW8SAv4dJooKrRkkRI8qibHE2tIqMmtf
         As/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1oL6wKbpdBggAADbjDTs5ZMpMJ3k/Fw83Q1im9LBzAY=;
        b=e8H51POxr99tiYktNuZFT0kZPqel57ptIerddDXB7kwRVULOazIwj2KiVhi6mcUJH1
         nt5BHJAy4OzGo/XrqvLOpRSG0R6MAWOv9q4nRGqfg/FQebCgugMoqOYqGvBvKN1IDl4s
         AiclFf3OsZTiIBN0w0owy9fTzj0HctG4nysJ8YfPNgZijGfyGkp4AuX0+kz0lfvgCxDJ
         ZdnihJQBwgRLm5YHp9I6zaXfxuN71NB466/YmuJ6y3N2qQqGRI303qrAm1jgIy/yIibN
         rQXGDElAVvcTcMjf50AAS3riVje12NyTWYSVq1ejGOOgKJ4UL3a2DVS9vM8XYeCzngC2
         JSgA==
X-Gm-Message-State: AOAM530bRwXjNsmO91gNJjMjM20Aq73AlzpfmPI52EaxbcyfwhiMpioP
        5JFlrnaVNKXcfNeIH8ERXaY=
X-Google-Smtp-Source: ABdhPJzO2SeOkiw8aVnde7vph4h1f2VkaMofPNU//RRCMmKCMvunJVkTjNXpyuS1Ua2QRBvHhG+jtw==
X-Received: by 2002:a50:ee0a:: with SMTP id g10mr13278982eds.248.1603022571400;
        Sun, 18 Oct 2020 05:02:51 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:2800:8821:97f2:24b4:2f18? (p200300ea8f232800882197f224b42f18.dip0.t-ipconnect.de. [2003:ea:8f23:2800:8821:97f2:24b4:2f18])
        by smtp.googlemail.com with ESMTPSA id rn10sm7205233ejb.8.2020.10.18.05.02.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Oct 2020 05:02:50 -0700 (PDT)
Subject: Re: [RFC PATCH 01/13] net: dsa: add plumbing for custom netdev
 statistics
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
 <20201017213611.2557565-2-vladimir.oltean@nxp.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <06538edb-65a9-c27f-2335-9213322bed3a@gmail.com>
Date:   Sun, 18 Oct 2020 14:02:46 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201017213611.2557565-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.10.2020 23:35, Vladimir Oltean wrote:
> DSA needs to push a header onto every packet on TX, and this might cause
> reallocation under certain scenarios, which might affect, for example,
> performance.
> 
> But reallocated packets are not standardized in struct pcpu_sw_netstats,
> struct net_device_stats or anywhere else, it seems, so we need to roll
> our own extra netdevice statistics and expose them to ethtool.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/dsa/dsa_priv.h |  9 +++++++++
>  net/dsa/slave.c    | 25 ++++++++++++++++++++++---
>  2 files changed, 31 insertions(+), 3 deletions(-)
> 
> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> index 12998bf04e55..d39db7500cdd 100644
> --- a/net/dsa/dsa_priv.h
> +++ b/net/dsa/dsa_priv.h
> @@ -73,12 +73,21 @@ struct dsa_notifier_mtu_info {
>  	int mtu;
>  };
>  
> +/* Driver statistics, other than those in struct rtnl_link_stats64.
> + * These are collected per-CPU and aggregated by ethtool.
> + */
> +struct dsa_slave_stats {
> +	__u64			tx_reallocs;
> +	struct u64_stats_sync	syncp;
> +} __aligned(1 * sizeof(u64));
> +

Wouldn't a simple unsigned long (like in struct net_device_stats) be
sufficient here? This would make handling the counter much simpler.
And as far as I understand we talk about a packet counter that is
touched in certain scenarios only.

>  struct dsa_slave_priv {
>  	/* Copy of CPU port xmit for faster access in slave transmit hot path */
>  	struct sk_buff *	(*xmit)(struct sk_buff *skb,
>  					struct net_device *dev);
>  
>  	struct pcpu_sw_netstats	__percpu *stats64;
> +	struct dsa_slave_stats	__percpu *extra_stats;
>  
>  	struct gro_cells	gcells;
>  
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 3bc5ca40c9fb..d4326940233c 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -668,9 +668,10 @@ static void dsa_slave_get_strings(struct net_device *dev,
>  		strncpy(data + len, "tx_bytes", len);
>  		strncpy(data + 2 * len, "rx_packets", len);
>  		strncpy(data + 3 * len, "rx_bytes", len);
> +		strncpy(data + 4 * len, "tx_reallocs", len);
>  		if (ds->ops->get_strings)
>  			ds->ops->get_strings(ds, dp->index, stringset,
> -					     data + 4 * len);
> +					     data + 5 * len);
>  	}
>  }
>  
> @@ -682,11 +683,13 @@ static void dsa_slave_get_ethtool_stats(struct net_device *dev,
>  	struct dsa_slave_priv *p = netdev_priv(dev);
>  	struct dsa_switch *ds = dp->ds;
>  	struct pcpu_sw_netstats *s;
> +	struct dsa_slave_stats *e;
>  	unsigned int start;
>  	int i;
>  
>  	for_each_possible_cpu(i) {
>  		u64 tx_packets, tx_bytes, rx_packets, rx_bytes;
> +		u64 tx_reallocs;
>  
>  		s = per_cpu_ptr(p->stats64, i);
>  		do {
> @@ -696,13 +699,21 @@ static void dsa_slave_get_ethtool_stats(struct net_device *dev,
>  			rx_packets = s->rx_packets;
>  			rx_bytes = s->rx_bytes;
>  		} while (u64_stats_fetch_retry_irq(&s->syncp, start));
> +
> +		e = per_cpu_ptr(p->extra_stats, i);
> +		do {
> +			start = u64_stats_fetch_begin_irq(&e->syncp);
> +			tx_reallocs	= e->tx_reallocs;
> +		} while (u64_stats_fetch_retry_irq(&e->syncp, start));
> +
>  		data[0] += tx_packets;
>  		data[1] += tx_bytes;
>  		data[2] += rx_packets;
>  		data[3] += rx_bytes;
> +		data[4] += tx_reallocs;
>  	}
>  	if (ds->ops->get_ethtool_stats)
> -		ds->ops->get_ethtool_stats(ds, dp->index, data + 4);
> +		ds->ops->get_ethtool_stats(ds, dp->index, data + 5);
>  }
>  
>  static int dsa_slave_get_sset_count(struct net_device *dev, int sset)
> @@ -713,7 +724,7 @@ static int dsa_slave_get_sset_count(struct net_device *dev, int sset)
>  	if (sset == ETH_SS_STATS) {
>  		int count;
>  
> -		count = 4;
> +		count = 5;
>  		if (ds->ops->get_sset_count)
>  			count += ds->ops->get_sset_count(ds, dp->index, sset);
>  
> @@ -1806,6 +1817,12 @@ int dsa_slave_create(struct dsa_port *port)
>  		free_netdev(slave_dev);
>  		return -ENOMEM;
>  	}
> +	p->extra_stats = netdev_alloc_pcpu_stats(struct dsa_slave_stats);
> +	if (!p->extra_stats) {
> +		free_percpu(p->stats64);
> +		free_netdev(slave_dev);
> +		return -ENOMEM;
> +	}
>  
>  	ret = gro_cells_init(&p->gcells, slave_dev);
>  	if (ret)
> @@ -1864,6 +1881,7 @@ int dsa_slave_create(struct dsa_port *port)
>  out_gcells:
>  	gro_cells_destroy(&p->gcells);
>  out_free:
> +	free_percpu(p->extra_stats);
>  	free_percpu(p->stats64);
>  	free_netdev(slave_dev);
>  	port->slave = NULL;
> @@ -1886,6 +1904,7 @@ void dsa_slave_destroy(struct net_device *slave_dev)
>  	dsa_slave_notify(slave_dev, DSA_PORT_UNREGISTER);
>  	phylink_destroy(dp->pl);
>  	gro_cells_destroy(&p->gcells);
> +	free_percpu(p->extra_stats);
>  	free_percpu(p->stats64);
>  	free_netdev(slave_dev);
>  }
> 

