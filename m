Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B39C236ED23
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 17:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234862AbhD2PMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 11:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233480AbhD2PMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 11:12:50 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0ECAC06138C;
        Thu, 29 Apr 2021 08:12:02 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id y2so654730plr.5;
        Thu, 29 Apr 2021 08:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=urOZ54Mg1cmoNZmjFQzvnwOawoI87jANODUmX35WKC8=;
        b=RwiEFNSGhUocD7dfZLOKMqrH+PNVrgj50Gl9o8APCzKvbxEjlDW779RFFFbIFxOS2y
         snRG+5dl4yPkzTt4BlJ1k2u4AOG9IF2dNvb01aaoVPvcuOu86Xe4I7giO/xim1EKn7iz
         DmxOkU043Oyd1PQFKWOSxUylsvY82k5WK5ImvVFciI1g0HNepOX20elXFyI+xIobfaPC
         xQxD/hp3cOw72CjuHz+mPW132vq6HrODLqNNT8G4YbBmIq5TUyntreEh2b8ackCXpQcz
         pBAHY6fQhH7iWyDijjyz6Iempi4G3+0Bagj82RZPU1TlUio51KFWdYiTuAdsn4rbHIgu
         UjeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=urOZ54Mg1cmoNZmjFQzvnwOawoI87jANODUmX35WKC8=;
        b=VojMqaqxcoJqwR7cYAtHLpF0ZfMTw8j3DioMT8H8jpNKsWMqJIMYeHFwWRHmmmnB5n
         WuCUyqoKrbgsfXhT8Ua82TFqNCqs9qOxH5RPZN9QwiyI/NQumEDNlkpAjinl0bFfKwUw
         HzuGU4xwtldRsf7fR+5C9NN5dpRlH43o1nWnZaFX+98s4/62jIZ2o6euEPG9YSq0Y7UB
         EI9mEyQS0gPLLh0Qdz/IGOxPHh2teETUkPZBLWvlvbDCdh3Rhujwq9XOmLARdZligAG/
         qNZstj0RyQSK5Dhs0mUy9euU8mOVnCo9VyO4Dpz2Ez/sCd+Ku/xJOcVSt8GHPVZ7v9/B
         o2XQ==
X-Gm-Message-State: AOAM532/CXHXopJcAiV/PBvVdkJCGjh0ykCxHQplbqXVXoD6UVcpYqoZ
        iyn37OuW3/paOklivADVUvg=
X-Google-Smtp-Source: ABdhPJzaNHynb80amTCXC4lJJaKMOkH9CwEt8wnKkUjgkIUy92FmwQccJ3jC3TDDIEHFWxfOvBzTtg==
X-Received: by 2002:a17:90a:be10:: with SMTP id a16mr9460584pjs.112.1619709122215;
        Thu, 29 Apr 2021 08:12:02 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id a7sm8514174pjm.0.2021.04.29.08.12.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 08:12:01 -0700 (PDT)
Date:   Thu, 29 Apr 2021 08:11:59 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] phy: nxp-c45-tja11xx: add timestamping support
Message-ID: <20210429151159.GA11108@hoboy.vegasvil.org>
References: <20210428123013.127571-1-radu-nicolae.pirea@oss.nxp.com>
 <20210428123013.127571-3-radu-nicolae.pirea@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210428123013.127571-3-radu-nicolae.pirea@oss.nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 28, 2021 at 03:30:13PM +0300, Radu Pirea (NXP OSS) wrote:

> +#define VEND1_LTC_WR_NSEC_0		0x1106
> +#define VEND1_LTC_WR_NSEC_1		0x1107
> +#define VEND1_LTC_WR_SEC_0		0x1108
> +#define VEND1_LTC_WR_SEC_1		0x1109
> +
> +#define VEND1_LTC_RD_NSEC_0		0x110A
> +#define VEND1_LTC_RD_NSEC_1		0x110B
> +#define VEND1_LTC_RD_SEC_0		0x110C
> +#define VEND1_LTC_RD_SEC_1		0x110D

Weird ...

>  struct nxp_c45_phy {
> +	struct phy_device *phydev;
> +	struct mii_timestamper mii_ts;
> +	struct ptp_clock *ptp_clock;
> +	struct ptp_clock_info caps;
> +	struct sk_buff_head tx_queue;
> +	struct sk_buff_head rx_queue;
> +	/* used to read the LTC counter atomic */
> +	struct mutex ltc_read_lock;
> +	/* used to write the LTC counter atomic */
> +	struct mutex ltc_write_lock;

You are sure that the RD and WR banks are completely independent?  In
any case, I think a single lock would be fine, because contention is
normally very low.

> +	int hwts_tx;
> +	int hwts_rx;
>  	u32 tx_delay;
>  	u32 rx_delay;
>  };
> @@ -110,6 +211,353 @@ struct nxp_c45_phy_stats {
>  	u16		mask;
>  };
>  
> +static bool nxp_c45_poll_txts(struct phy_device *phydev)
> +{
> +	return phydev->irq <= 0;
> +}
> +
> +static int nxp_c45_ptp_gettimex64(struct ptp_clock_info *ptp,
> +				  struct timespec64 *ts,
> +				  struct ptp_system_timestamp *sts)
> +{
> +	struct nxp_c45_phy *priv = container_of(ptp, struct nxp_c45_phy, caps);
> +
> +	mutex_lock(&priv->ltc_read_lock);
> +	phy_write_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_LTC_LOAD_CTRL,
> +		      READ_LTC);
> +	ts->tv_nsec = phy_read_mmd(priv->phydev, MDIO_MMD_VEND1,
> +				   VEND1_LTC_RD_NSEC_0);
> +	ts->tv_nsec |= phy_read_mmd(priv->phydev, MDIO_MMD_VEND1,
> +				    VEND1_LTC_RD_NSEC_1) << 16;
> +	ts->tv_sec = phy_read_mmd(priv->phydev, MDIO_MMD_VEND1,
> +				  VEND1_LTC_RD_SEC_0);
> +	ts->tv_sec |= phy_read_mmd(priv->phydev, MDIO_MMD_VEND1,
> +				   VEND1_LTC_RD_SEC_1) << 16;
> +	mutex_unlock(&priv->ltc_read_lock);
> +
> +	return 0;
> +}
> +
> +static int nxp_c45_ptp_settime64(struct ptp_clock_info *ptp,
> +				 const struct timespec64 *ts)
> +{
> +	struct nxp_c45_phy *priv = container_of(ptp, struct nxp_c45_phy, caps);
> +
> +	mutex_lock(&priv->ltc_write_lock);
> +	phy_write_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_LTC_WR_NSEC_0,
> +		      ts->tv_nsec);
> +	phy_write_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_LTC_WR_NSEC_1,
> +		      ts->tv_nsec >> 16);
> +	phy_write_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_LTC_WR_SEC_0,
> +		      ts->tv_sec);
> +	phy_write_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_LTC_WR_SEC_1,
> +		      ts->tv_sec >> 16);
> +	phy_write_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_LTC_LOAD_CTRL,
> +		      LOAD_LTC);
> +	mutex_unlock(&priv->ltc_write_lock);
> +
> +	return 0;
> +}
> +
> +static int nxp_c45_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
> +{
> +	struct nxp_c45_phy *priv = container_of(ptp, struct nxp_c45_phy, caps);
> +	s32 ppb = scaled_ppm_to_ppb(scaled_ppm);
> +	u64 subns_inc_val;
> +	bool inc;
> +
> +	inc = ppb >= 0 ? true : false;
> +	ppb = abs(ppb);
> +
> +	subns_inc_val = PPM_TO_SUBNS_INC(ppb);
> +
> +	phy_write_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_RATE_ADJ_SUBNS_0,
> +		      subns_inc_val);
> +	subns_inc_val >>= 16;
> +	subns_inc_val |= CLK_RATE_ADJ_LD;
> +	if (inc)
> +		subns_inc_val |= CLK_RATE_ADJ_DIR;
> +
> +	phy_write_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_RATE_ADJ_SUBNS_1,
> +		      subns_inc_val);

This needs a mutex to protect against concurrent callers.

> +	return 0;
> +}
> +
> +static int nxp_c45_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
> +{
> +	struct timespec64 now, then;
> +
> +	then = ns_to_timespec64(delta);
> +	nxp_c45_ptp_gettimex64(ptp, &now, NULL);
> +	now = timespec64_add(now, then);
> +	nxp_c45_ptp_settime64(ptp, &now);

Locking needed here, too.  You will need an unlocked version of
nxp_c45_ptp_settime64(), named like _nxp_c45_ptp_settime64() for
example.

> +	return 0;
> +}
> +
> +static void nxp_c45_reconstruct_ts(struct timespec64 *ts,
> +				   struct nxp_c45_hwts *hwts)
> +{
> +	ts->tv_nsec = hwts->nsec;
> +	if ((ts->tv_sec & TS_SEC_MASK) < (hwts->sec & TS_SEC_MASK))
> +		ts->tv_sec -= BIT(2);
> +	ts->tv_sec &= ~TS_SEC_MASK;
> +	ts->tv_sec |= hwts->sec & TS_SEC_MASK;
> +}
> +
> +static bool nxp_c45_match_ts(struct ptp_header *header,
> +			     struct nxp_c45_hwts *hwts,
> +			     unsigned int type)
> +{
> +	return ntohs(header->sequence_id) == hwts->sequence_id &&
> +	       ptp_get_msgtype(header, type) == hwts->msg_type &&
> +	       header->domain_number  == hwts->domain_number;
> +}
> +
> +static bool nxp_c45_get_hwtxts(struct nxp_c45_phy *priv,
> +			       struct nxp_c45_hwts *hwts)
> +{
> +	bool valid;
> +	u16 reg;

This function is called from both interrupt and thread context.  It
needs locking.  I suggest a single mutex that protects concurrent
access to any PHY registers.

> +	phy_write_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_EGR_RING_CTRL,
> +		      RING_DONE);
> +	reg = phy_read_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_EGR_RING_DATA_0);
> +	valid = !!(reg & RING_DATA_0_TS_VALID);
> +	if (!valid)
> +		return valid;
> +
> +	hwts->domain_number = reg;
> +	hwts->msg_type = (reg & RING_DATA_0_MSG_TYPE) >> 8;
> +	hwts->sec = (reg & RING_DATA_0_SEC_4_2) >> 10;
> +	hwts->sequence_id = phy_read_mmd(priv->phydev, MDIO_MMD_VEND1,
> +					 VEND1_EGR_RING_DATA_1_SEQ_ID);
> +	hwts->nsec = phy_read_mmd(priv->phydev, MDIO_MMD_VEND1,
> +				  VEND1_EGR_RING_DATA_2_NSEC_15_0);
> +	reg = phy_read_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_EGR_RING_DATA_3);
> +	hwts->nsec |= (reg & RING_DATA_3_NSEC_29_16) << 16;
> +	hwts->sec |= (reg & RING_DATA_3_SEC_1_0) >> 14;
> +
> +	return valid;
> +}
> +
> +static void nxp_c45_process_txts(struct nxp_c45_phy *priv,
> +				 struct nxp_c45_hwts *txts)
> +{
> +	struct sk_buff *skb, *tmp, *skb_match = NULL;
> +	struct skb_shared_hwtstamps shhwtstamps;
> +	struct timespec64 ts;
> +	unsigned long flags;
> +	bool ts_match;
> +	s64 ts_ns;
> +
> +	spin_lock_irqsave(&priv->tx_queue.lock, flags);
> +	skb_queue_walk_safe(&priv->tx_queue, skb, tmp) {
> +		ts_match = nxp_c45_match_ts(NXP_C45_SKB_CB(skb)->header, txts,
> +					    NXP_C45_SKB_CB(skb)->type);
> +		if (!ts_match)
> +			continue;
> +		skb_match = skb;
> +		__skb_unlink(skb, &priv->tx_queue);
> +		break;
> +	}
> +	spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
> +
> +	if (skb_match) {
> +		nxp_c45_ptp_gettimex64(&priv->caps, &ts, NULL);
> +		nxp_c45_reconstruct_ts(&ts, txts);
> +		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
> +		ts_ns = timespec64_to_ns(&ts);
> +		shhwtstamps.hwtstamp = ns_to_ktime(ts_ns);
> +		skb_complete_tx_timestamp(skb_match, &shhwtstamps);
> +	} else {
> +		phydev_warn(priv->phydev,
> +			    "the tx timestamp doesn't match with any skb\n");
> +	}
> +}
> +
> +static long nxp_c45_do_aux_work(struct ptp_clock_info *ptp)
> +{
> +	struct nxp_c45_phy *priv = container_of(ptp, struct nxp_c45_phy, caps);
> +	bool poll_txts = nxp_c45_poll_txts(priv->phydev);
> +	struct skb_shared_hwtstamps *shhwtstamps_rx;
> +	struct nxp_c45_hwts hwts;
> +	bool reschedule = false;
> +	struct timespec64 ts;
> +	struct sk_buff *skb;
> +	bool txts_valid;
> +	u32 ts_raw;
> +
> +	while (!skb_queue_empty_lockless(&priv->tx_queue) && poll_txts) {
> +		txts_valid = nxp_c45_get_hwtxts(priv, &hwts);
> +		if (unlikely(!txts_valid)) {
> +			/* Still more skbs in the queue */
> +			reschedule = true;
> +			break;
> +		}
> +
> +		nxp_c45_process_txts(priv, &hwts);
> +	}
> +
> +	while ((skb = skb_dequeue(&priv->rx_queue)) != NULL) {
> +		nxp_c45_ptp_gettimex64(&priv->caps, &ts, NULL);

Probably better to to move this call before the 'while' loop.

> +		ts_raw = __be32_to_cpu(NXP_C45_SKB_CB(skb)->header->reserved2);
> +		hwts.sec = ts_raw >> 30;
> +		hwts.nsec = ts_raw & GENMASK(29, 0);
> +		nxp_c45_reconstruct_ts(&ts, &hwts);
> +		shhwtstamps_rx = skb_hwtstamps(skb);
> +		shhwtstamps_rx->hwtstamp = ns_to_ktime(timespec64_to_ns(&ts));
> +		NXP_C45_SKB_CB(skb)->header->reserved2 = 0;
> +		netif_rx_ni(skb);
> +	}
> +
> +	return reschedule ? 1 : -1;
> +}

Thanks,
Richard
