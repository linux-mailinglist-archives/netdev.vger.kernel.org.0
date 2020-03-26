Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED8F193908
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgCZG5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:57:53 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40019 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgCZG5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 02:57:53 -0400
Received: by mail-pl1-f194.google.com with SMTP id h11so1784677plk.7
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 23:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7x3QeeMWKJYNIVI9FfHpthgtVpeH+ht2mj6cmuNiW4E=;
        b=bclY54GI3tmc0uThs/mbfk0mddcHnhKk+9GT3V1oCYOvxGc4BU0qKemHLmrM7tj/UQ
         KisM+OtW8eht5VzmbWQCQxXCe0azEXTKvywniRtcMM36E4KrJjEjBfwV1udod1mS0UM0
         6h5cavdQjrv1kszbpPnnmwdYvyH5CwQ6BND2YuIta2vORQ5H3ches8vCP7ptuVlNIO6v
         DinQ5MU0bGr64X0SXr0woeGbIPGiNcq2P3Mp7+mnw/F9ZXvnPUCctfvJCnDk5IJZwpLk
         poBPYoEXdldm+G/5EDJ3fr2xjebC6JYS+qbFDBwv/2eOFukbZkOcb0WHYeiwp//fPGBl
         tcHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7x3QeeMWKJYNIVI9FfHpthgtVpeH+ht2mj6cmuNiW4E=;
        b=jyWK9SDofntDQupggkEcz8XtHcHNyIDEx4ByeREPq2v8t1i+sOKdJMq8brxL4K7bkZ
         fnVq+P9jAiK8AtAcIhTWK+SfMdsEIQ6JmFAeCBQpILChQoh/FLMDjO2bjnFimt2Gy9l3
         Lj8kVQcvyJ8iKdK4n3nGIu5igRrBU18EEh80KEzhRLAmsfdlcQIsK/58g31bSB5IbQlD
         9zbrtJSJ1+JIxI2+72hMoVcDt50p5Z2DAflRty58ofDWotu8ZGFZM58oNabbq0onF+dU
         kFhSpQEadHaI+6QFJJH51KHb0B4R8Gtvn8g23xhsnCyxYU6iKYGFa9HCm2IHF4356r7b
         qk/w==
X-Gm-Message-State: ANhLgQ3gkneiolcKvO59f7aDvPc7taXMmuru3CKShLCKwsCHfBBRKBTg
        2IFG0aVGqHfDk3PmskwYDro=
X-Google-Smtp-Source: ADFU+vvQETs1sOgRTtGUCNstYB6nSPIrlXzh0ITC98BATpBzk1/ubvcLxzFUj4rL+z4tvBzlAxnLYw==
X-Received: by 2002:a17:90a:24c5:: with SMTP id i63mr1486855pje.177.1585205871801;
        Wed, 25 Mar 2020 23:57:51 -0700 (PDT)
Received: from [192.168.1.18] (i223-218-245-204.s42.a013.ap.plala.or.jp. [223.218.245.204])
        by smtp.googlemail.com with ESMTPSA id a13sm869083pgi.77.2020.03.25.23.57.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2020 23:57:51 -0700 (PDT)
Subject: Re: [PATCH net-next 2/2] veth: rely on peer veth_rq for ndo_xdp_xmit
 accounting
To:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, brouer@redhat.com, dsahern@gmail.com,
        lorenzo.bianconi@redhat.com, toke@redhat.com
References: <cover.1585163874.git.lorenzo@kernel.org>
 <4d4f1772e71ba7ad67e416646f5d9357caf60a42.1585163874.git.lorenzo@kernel.org>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <06d1e872-9d61-89bc-4b35-6f0193010b08@gmail.com>
Date:   Thu, 26 Mar 2020 15:57:48 +0900
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <4d4f1772e71ba7ad67e416646f5d9357caf60a42.1585163874.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/03/26 4:22, Lorenzo Bianconi wrote:
> Rely on 'remote' veth_rq to account ndo_xdp_xmit ethtool counters.
> Move XDP_TX accounting to veth_xdp_flush_bq routine.
> Remove 'rx' prefix in rx xdp ethool counters
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>   drivers/net/veth.c | 113 +++++++++++++++++++++++++++++----------------
>   1 file changed, 74 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index 2041152da716..1b95ed0c6d67 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -92,17 +92,22 @@ struct veth_q_stat_desc {
>   static const struct veth_q_stat_desc veth_rq_stats_desc[] = {
>   	{ "xdp_packets",	VETH_RQ_STAT(xdp_packets) },
>   	{ "xdp_bytes",		VETH_RQ_STAT(xdp_bytes) },
> -	{ "rx_drops",		VETH_RQ_STAT(rx_drops) },
> -	{ "rx_xdp_redirect",	VETH_RQ_STAT(xdp_redirect) },
> -	{ "rx_xdp_drops",	VETH_RQ_STAT(xdp_drops) },
> -	{ "rx_xdp_tx",		VETH_RQ_STAT(xdp_tx) },
> -	{ "rx_xdp_tx_errors",	VETH_RQ_STAT(xdp_tx_err) },
> -	{ "tx_xdp_xmit",	VETH_RQ_STAT(xdp_xmit) },
> -	{ "tx_xdp_xmit_errors",	VETH_RQ_STAT(xdp_xmit_err) },
> +	{ "drops",		VETH_RQ_STAT(rx_drops) },
> +	{ "xdp_redirect",	VETH_RQ_STAT(xdp_redirect) },
> +	{ "xdp_drops",		VETH_RQ_STAT(xdp_drops) },
> +	{ "xdp_tx",		VETH_RQ_STAT(xdp_tx) },
> +	{ "xdp_tx_errors",	VETH_RQ_STAT(xdp_tx_err) },
>   };
>   
>   #define VETH_RQ_STATS_LEN	ARRAY_SIZE(veth_rq_stats_desc)
>   
> +static const struct veth_q_stat_desc veth_tq_stats_desc[] = {
> +	{ "xdp_xmit",		VETH_RQ_STAT(xdp_xmit) },
> +	{ "xdp_xmit_errors",	VETH_RQ_STAT(xdp_xmit_err) },
> +};
> +
> +#define VETH_TQ_STATS_LEN	ARRAY_SIZE(veth_tq_stats_desc)
> +
>   static struct {
>   	const char string[ETH_GSTRING_LEN];
>   } ethtool_stats_keys[] = {
> @@ -142,6 +147,14 @@ static void veth_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
>   				p += ETH_GSTRING_LEN;
>   			}
>   		}
> +		for (i = 0; i < dev->real_num_tx_queues; i++) {
> +			for (j = 0; j < VETH_TQ_STATS_LEN; j++) {
> +				snprintf(p, ETH_GSTRING_LEN,
> +					 "tx_queue_%u_%.18s",
> +					 i, veth_tq_stats_desc[j].desc);
> +				p += ETH_GSTRING_LEN;
> +			}
> +		}
>   		break;
>   	}
>   }
> @@ -151,7 +164,8 @@ static int veth_get_sset_count(struct net_device *dev, int sset)
>   	switch (sset) {
>   	case ETH_SS_STATS:
>   		return ARRAY_SIZE(ethtool_stats_keys) +
> -		       VETH_RQ_STATS_LEN * dev->real_num_rx_queues;
> +		       VETH_RQ_STATS_LEN * dev->real_num_rx_queues +
> +		       VETH_TQ_STATS_LEN * dev->real_num_tx_queues;
>   	default:
>   		return -EOPNOTSUPP;
>   	}
> @@ -160,7 +174,7 @@ static int veth_get_sset_count(struct net_device *dev, int sset)
>   static void veth_get_ethtool_stats(struct net_device *dev,
>   		struct ethtool_stats *stats, u64 *data)
>   {
> -	struct veth_priv *priv = netdev_priv(dev);
> +	struct veth_priv *rcv_priv, *priv = netdev_priv(dev);
>   	struct net_device *peer = rtnl_dereference(priv->peer);
>   	int i, j, idx;
>   
> @@ -181,6 +195,26 @@ static void veth_get_ethtool_stats(struct net_device *dev,
>   		} while (u64_stats_fetch_retry_irq(&rq_stats->syncp, start));
>   		idx += VETH_RQ_STATS_LEN;
>   	}
> +
> +	if (!peer)
> +		return;
> +
> +	rcv_priv = netdev_priv(peer);
> +	for (i = 0; i < peer->real_num_rx_queues; i++) {
> +		const struct veth_rq_stats *rq_stats = &rcv_priv->rq[i].stats;
> +		const void *base = (void *)&rq_stats->vs;
> +		unsigned int start, tx_idx = idx;
> +		size_t offset;
> +
> +		tx_idx += (i % dev->real_num_tx_queues) * VETH_TQ_STATS_LEN;
> +		do {
> +			start = u64_stats_fetch_begin_irq(&rq_stats->syncp);
> +			for (j = 0; j < VETH_TQ_STATS_LEN; j++) {
> +				offset = veth_tq_stats_desc[j].offset;
> +				data[tx_idx + j] += *(u64 *)(base + offset);
> +			}
> +		} while (u64_stats_fetch_retry_irq(&rq_stats->syncp, start));
> +	}
>   }
>   
>   static const struct ethtool_ops veth_ethtool_ops = {
> @@ -340,8 +374,8 @@ static void veth_get_stats64(struct net_device *dev,
>   	tot->tx_packets = packets;
>   
>   	veth_stats_rx(&rx, dev);
> -	tot->tx_dropped += rx.xdp_xmit_err + rx.xdp_tx_err;
> -	tot->rx_dropped = rx.rx_drops;
> +	tot->tx_dropped += rx.xdp_tx_err;
> +	tot->rx_dropped = rx.rx_drops + rx.xdp_xmit_err;

This looks confusing.
How about changing the variable name a bit?

  struct veth_stats {
  	u64	rx_drops;
  	/* xdp */
  	u64	xdp_packets;
  	u64	xdp_bytes;
  	u64	xdp_redirect;
  	u64	xdp_drops;
  	u64	xdp_tx;
  	u64	xdp_tx_err;
-	u64	xdp_xmit;
-	u64	xdp_xmit_err;
+	u64	peer_tq_xdp_xmit;
+	u64	peer_tq_xdp_xmit_err;
  };

+static const struct veth_q_stat_desc veth_tq_stats_desc[] = {
+	{ "xdp_xmit",		VETH_RQ_STAT(peer_tq_xdp_xmit) },
+	{ "xdp_xmit_errors",	VETH_RQ_STAT(peer_tq_xdp_xmit_err) },
+};

And then,
  tot->rx_dropped = rx.rx_drops + rx.peer_tq_xdp_xmit_err;

Otherwise looks good.

Thanks!
Toshiaki Makita


>   	tot->rx_bytes = rx.xdp_bytes;
>   	tot->rx_packets = rx.xdp_packets;
>   
> @@ -353,7 +387,8 @@ static void veth_get_stats64(struct net_device *dev,
>   		tot->rx_packets += packets;
>   
>   		veth_stats_rx(&rx, peer);
> -		tot->rx_dropped += rx.xdp_xmit_err + rx.xdp_tx_err;
> +		tot->tx_dropped += rx.xdp_xmit_err;
> +		tot->rx_dropped += rx.xdp_tx_err;
>   		tot->tx_bytes += rx.xdp_bytes;
>   		tot->tx_packets += rx.xdp_packets;
>   	}
> @@ -394,38 +429,28 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
>   			 u32 flags, bool ndo_xmit)
>   {
>   	struct veth_priv *rcv_priv, *priv = netdev_priv(dev);
> -	unsigned int qidx, max_len;
> +	int i, ret = -ENXIO, drops = 0;
>   	struct net_device *rcv;
> -	int i, ret, drops = n;
> +	unsigned int max_len;
>   	struct veth_rq *rq;
>   
> -	rcu_read_lock();
> -	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK)) {
> -		rcu_read_unlock();
> -		atomic64_add(drops, &priv->dropped);
> +	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
>   		return -EINVAL;
> -	}
>   
> +	rcu_read_lock();
>   	rcv = rcu_dereference(priv->peer);
> -	if (unlikely(!rcv)) {
> -		rcu_read_unlock();
> -		atomic64_add(drops, &priv->dropped);
> -		return -ENXIO;
> -	}
> +	if (unlikely(!rcv))
> +		goto out;
>   
>   	rcv_priv = netdev_priv(rcv);
> -	qidx = veth_select_rxq(rcv);
> -	rq = &rcv_priv->rq[qidx];
> +	rq = &rcv_priv->rq[veth_select_rxq(rcv)];
>   	/* Non-NULL xdp_prog ensures that xdp_ring is initialized on receive
>   	 * side. This means an XDP program is loaded on the peer and the peer
>   	 * device is up.
>   	 */
> -	if (!rcu_access_pointer(rq->xdp_prog)) {
> -		ret = -ENXIO;
> -		goto drop;
> -	}
> +	if (!rcu_access_pointer(rq->xdp_prog))
> +		goto out;
>   
> -	drops = 0;
>   	max_len = rcv->mtu + rcv->hard_header_len + VLAN_HLEN;
>   
>   	spin_lock(&rq->xdp_ring.producer_lock);
> @@ -445,18 +470,14 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
>   		__veth_xdp_flush(rq);
>   
>   	ret = n - drops;
> -drop:
> -	rq = &priv->rq[qidx];
> -	u64_stats_update_begin(&rq->stats.syncp);
>   	if (ndo_xmit) {
> +		u64_stats_update_begin(&rq->stats.syncp);
>   		rq->stats.vs.xdp_xmit += n - drops;
>   		rq->stats.vs.xdp_xmit_err += drops;
> -	} else {
> -		rq->stats.vs.xdp_tx += n - drops;
> -		rq->stats.vs.xdp_tx_err += drops;
> +		u64_stats_update_end(&rq->stats.syncp);
>   	}
> -	u64_stats_update_end(&rq->stats.syncp);
>   
> +out:
>   	rcu_read_unlock();
>   
>   	return ret;
> @@ -465,7 +486,16 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
>   static int veth_ndo_xdp_xmit(struct net_device *dev, int n,
>   			     struct xdp_frame **frames, u32 flags)
>   {
> -	return veth_xdp_xmit(dev, n, frames, flags, true);
> +	int err;
> +
> +	err = veth_xdp_xmit(dev, n, frames, flags, true);
> +	if (err < 0) {
> +		struct veth_priv *priv = netdev_priv(dev);
> +
> +		atomic64_add(n, &priv->dropped);
> +	}
> +
> +	return err;
>   }
>   
>   static void veth_xdp_flush_bq(struct veth_rq *rq, struct veth_xdp_tx_bq *bq)
> @@ -481,6 +511,11 @@ static void veth_xdp_flush_bq(struct veth_rq *rq, struct veth_xdp_tx_bq *bq)
>   	}
>   	trace_xdp_bulk_tx(rq->dev, sent, bq->count - sent, err);
>   
> +	u64_stats_update_begin(&rq->stats.syncp);
> +	rq->stats.vs.xdp_tx += sent;
> +	rq->stats.vs.xdp_tx_err += bq->count - sent;
> +	u64_stats_update_end(&rq->stats.syncp);
> +
>   	bq->count = 0;
>   }
>   
> 
