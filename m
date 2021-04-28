Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421CF36E043
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 22:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241950AbhD1Uaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 16:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241927AbhD1Uan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 16:30:43 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFB2C06138B
        for <netdev@vger.kernel.org>; Wed, 28 Apr 2021 13:29:57 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id y4so61101841lfl.10
        for <netdev@vger.kernel.org>; Wed, 28 Apr 2021 13:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=LE0enDSjx5SBAwc8jTV1hMjj+NkvsrSs52VosOJV7m8=;
        b=X69m1Gjwp5M2Ztfgm9Dv9Uovr4Vdlzc/3Z4n92n++tUu5Hr/Qk8tXppEs8K3dOPJrP
         46TfFVarwG3yq5i9qhXhGbvj9kl4CFPj1fMRBZPX8/DgktId+SAVKfX29JsQ8RObupqG
         ItSYTSzkq3KnhZiNpCHi39vcg42/lQtaf+se5PaYQsFB+5ZhDc2RGmeWCiuuYySiiHai
         NihUqtDft2I9JCvhiWy57jSDV/2P/3FtXqqg3XrhidcqXdfEKYcDvzXWvlz/+TBAwUSM
         3IA//P19DI43Neiq7RtMycNYzMe69bug/x0Xc36phv2SYIfSRNPd0D+7P1vMxCKbZ2BA
         wEog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=LE0enDSjx5SBAwc8jTV1hMjj+NkvsrSs52VosOJV7m8=;
        b=Lf/vA6MScP6H83cF/G5XwdbpfczN6JGx+Ojzeck9OhdnuhpiicOIQrsfXqg7OM4e56
         u80GpFZYEAM360PHWuAU1Ov6xnnfXyIjUjkKLqcWtRGU+uXkO0xYhhz09zTylkdkQHZ9
         g+NC+UqGj93rYyBDv9QT1JBEmduK5sm0Irn6/3hUJw42cSdXjKZr2PnxZDqtMfFSNA7O
         lLDlEKmij4PiEft6y0YJ9WYHtlWQ2cQ8/dPx2vIIHauSQGLvHIuxtdMlTgENNrfkcMbc
         vZawiHVlkEq8iplsxdBAgYezfiVNio75ImB5u8n0hXdUshHtY3zNNQWz1FRXr5QE0fxE
         qdUQ==
X-Gm-Message-State: AOAM531FBnjAEH0wMSfeFcWZpvkUFKpWqjNw84+kn10prari6IhE2OXN
        aZfHPmzvVLolJM8KTUqDAk524g==
X-Google-Smtp-Source: ABdhPJxlPc+JLIsXZKhGaXN4QIKL39GgAt24sOcQYznod660K/S9Hs5jMS1uH6T/3WtZpK1O6jZvTQ==
X-Received: by 2002:a19:4888:: with SMTP id v130mr4657701lfa.53.1619641795632;
        Wed, 28 Apr 2021 13:29:55 -0700 (PDT)
Received: from wkz-x280 (h-90-88.A259.priv.bahnhof.se. [212.85.90.88])
        by smtp.gmail.com with ESMTPSA id n5sm205355lfh.25.2021.04.28.13.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 13:29:55 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>, netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next, v2, 3/7] net: dsa: free skb->cb usage in core driver
In-Reply-To: <20210426093802.38652-4-yangbo.lu@nxp.com>
References: <20210426093802.38652-1-yangbo.lu@nxp.com> <20210426093802.38652-4-yangbo.lu@nxp.com>
Date:   Wed, 28 Apr 2021 22:29:54 +0200
Message-ID: <87y2d2noe5.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 17:37, Yangbo Lu <yangbo.lu@nxp.com> wrote:
> Free skb->cb usage in core driver and let device drivers decide to
> use or not. The reason having a DSA_SKB_CB(skb)->clone was because
> dsa_skb_tx_timestamp() which may set the clone pointer was called
> before p->xmit() which would use the clone if any, and the device
> driver has no way to initialize the clone pointer.
>
> Although for now putting memset(skb->cb, 0, 48) at beginning of
> dsa_slave_xmit() by this patch is not very good, there is still way
> to improve this. Otherwise, some other new features, like one-step

Could you please expand on this improvement?

This memset makes it impossible to carry control buffer information from
driver callbacks that run before .ndo_start_xmit, for example
.ndo_select_queue, to a tagger's .xmit.

It seems to me that if the drivers are to handle the CB internally from
now on, that should go for both setting and clearing of the required
fields.

> timestamp which needs a flag of skb marked in dsa_skb_tx_timestamp(),
> and handles as one-step timestamp in p->xmit() will face same
> situation.
>
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> ---
> Changes for v2:
> 	- Added this patch.
> ---
>  drivers/net/dsa/ocelot/felix.c         |  1 +
>  drivers/net/dsa/sja1105/sja1105_main.c |  2 +-
>  drivers/net/dsa/sja1105/sja1105_ptp.c  |  4 +++-
>  drivers/net/ethernet/mscc/ocelot.c     |  6 +++---
>  drivers/net/ethernet/mscc/ocelot_net.c |  2 +-
>  include/linux/dsa/sja1105.h            |  3 ++-
>  include/net/dsa.h                      | 14 --------------
>  include/soc/mscc/ocelot.h              |  8 ++++++++
>  net/dsa/slave.c                        |  3 +--
>  net/dsa/tag_ocelot.c                   |  8 ++++----
>  net/dsa/tag_ocelot_8021q.c             |  8 ++++----
>  11 files changed, 28 insertions(+), 31 deletions(-)
>
> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
> index d679f023dc00..8980d56ee793 100644
> --- a/drivers/net/dsa/ocelot/felix.c
> +++ b/drivers/net/dsa/ocelot/felix.c
> @@ -1403,6 +1403,7 @@ static bool felix_txtstamp(struct dsa_switch *ds, int port,
>  
>  	if (ocelot->ptp && ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
>  		ocelot_port_add_txtstamp_skb(ocelot, port, clone);
> +		OCELOT_SKB_CB(skb)->clone = clone;
>  		return true;
>  	}
>  
> diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
> index d9c198ca0197..405024b637d6 100644
> --- a/drivers/net/dsa/sja1105/sja1105_main.c
> +++ b/drivers/net/dsa/sja1105/sja1105_main.c
> @@ -3137,7 +3137,7 @@ static void sja1105_port_deferred_xmit(struct kthread_work *work)
>  	struct sk_buff *skb;
>  
>  	while ((skb = skb_dequeue(&sp->xmit_queue)) != NULL) {
> -		struct sk_buff *clone = DSA_SKB_CB(skb)->clone;
> +		struct sk_buff *clone = SJA1105_SKB_CB(skb)->clone;
>  
>  		mutex_lock(&priv->mgmt_lock);
>  
> diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
> index 72d052de82d8..0832368aaa96 100644
> --- a/drivers/net/dsa/sja1105/sja1105_ptp.c
> +++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
> @@ -432,7 +432,7 @@ bool sja1105_port_rxtstamp(struct dsa_switch *ds, int port,
>  }
>  
>  /* Called from dsa_skb_tx_timestamp. This callback is just to make DSA clone
> - * the skb and have it available in DSA_SKB_CB in the .port_deferred_xmit
> + * the skb and have it available in SJA1105_SKB_CB in the .port_deferred_xmit
>   * callback, where we will timestamp it synchronously.
>   */
>  bool sja1105_port_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb)
> @@ -443,6 +443,8 @@ bool sja1105_port_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb)
>  	if (!sp->hwts_tx_en)
>  		return false;
>  
> +	SJA1105_SKB_CB(skb)->clone = clone;
> +
>  	return true;
>  }
>  
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> index 8d06ffaf318a..7da2dd1632b1 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -538,8 +538,8 @@ void ocelot_port_add_txtstamp_skb(struct ocelot *ocelot, int port,
>  	spin_lock(&ocelot_port->ts_id_lock);
>  
>  	skb_shinfo(clone)->tx_flags |= SKBTX_IN_PROGRESS;
> -	/* Store timestamp ID in cb[0] of sk_buff */
> -	clone->cb[0] = ocelot_port->ts_id;
> +	/* Store timestamp ID in OCELOT_SKB_CB(clone)->ts_id */
> +	OCELOT_SKB_CB(clone)->ts_id = ocelot_port->ts_id;
>  	ocelot_port->ts_id = (ocelot_port->ts_id + 1) % 4;
>  	skb_queue_tail(&ocelot_port->tx_skbs, clone);
>  
> @@ -604,7 +604,7 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
>  		spin_lock_irqsave(&port->tx_skbs.lock, flags);
>  
>  		skb_queue_walk_safe(&port->tx_skbs, skb, skb_tmp) {
> -			if (skb->cb[0] != id)
> +			if (OCELOT_SKB_CB(skb)->ts_id != id)
>  				continue;
>  			__skb_unlink(skb, &port->tx_skbs);
>  			skb_match = skb;
> diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
> index 36f32a4d9b0f..789a5fba146c 100644
> --- a/drivers/net/ethernet/mscc/ocelot_net.c
> +++ b/drivers/net/ethernet/mscc/ocelot_net.c
> @@ -520,7 +520,7 @@ static netdev_tx_t ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
>  
>  			ocelot_port_add_txtstamp_skb(ocelot, port, clone);
>  
> -			rew_op |= clone->cb[0] << 3;
> +			rew_op |= OCELOT_SKB_CB(clone)->ts_id << 3;
>  		}
>  	}
>  
> diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
> index dd93735ae228..1eb84562b311 100644
> --- a/include/linux/dsa/sja1105.h
> +++ b/include/linux/dsa/sja1105.h
> @@ -47,11 +47,12 @@ struct sja1105_tagger_data {
>  };
>  
>  struct sja1105_skb_cb {
> +	struct sk_buff *clone;
>  	u32 meta_tstamp;
>  };
>  
>  #define SJA1105_SKB_CB(skb) \
> -	((struct sja1105_skb_cb *)DSA_SKB_CB_PRIV(skb))
> +	((struct sja1105_skb_cb *)((skb)->cb))
>  
>  struct sja1105_port {
>  	u16 subvlan_map[DSA_8021Q_N_SUBVLAN];
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 905066055b08..5685e60cb082 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -117,20 +117,6 @@ struct dsa_netdevice_ops {
>  #define MODULE_ALIAS_DSA_TAG_DRIVER(__proto)				\
>  	MODULE_ALIAS(DSA_TAG_DRIVER_ALIAS __stringify(__proto##_VALUE))
>  
> -struct dsa_skb_cb {
> -	struct sk_buff *clone;
> -};
> -
> -struct __dsa_skb_cb {
> -	struct dsa_skb_cb cb;
> -	u8 priv[48 - sizeof(struct dsa_skb_cb)];
> -};
> -
> -#define DSA_SKB_CB(skb) ((struct dsa_skb_cb *)((skb)->cb))
> -
> -#define DSA_SKB_CB_PRIV(skb)			\
> -	((void *)(skb)->cb + offsetof(struct __dsa_skb_cb, priv))
> -
>  struct dsa_switch_tree {
>  	struct list_head	list;
>  
> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index 68cdc7ceaf4d..f075aaf70eee 100644
> --- a/include/soc/mscc/ocelot.h
> +++ b/include/soc/mscc/ocelot.h
> @@ -689,6 +689,14 @@ struct ocelot_policer {
>  	u32 burst; /* bytes */
>  };
>  
> +struct ocelot_skb_cb {
> +	struct sk_buff *clone;
> +	u8 ts_id;
> +};
> +
> +#define OCELOT_SKB_CB(skb) \
> +	((struct ocelot_skb_cb *)((skb)->cb))
> +
>  #define ocelot_read_ix(ocelot, reg, gi, ri) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
>  #define ocelot_read_gix(ocelot, reg, gi) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi))
>  #define ocelot_read_rix(ocelot, reg, ri) __ocelot_read_ix(ocelot, reg, reg##_RSZ * (ri))
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index acaa52e60d7f..2211894c2381 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -568,7 +568,6 @@ static void dsa_skb_tx_timestamp(struct dsa_slave_priv *p,
>  		return;
>  
>  	if (ds->ops->port_txtstamp(ds, p->dp->index, clone)) {
> -		DSA_SKB_CB(skb)->clone = clone;
>  		return;
>  	}
>  
> @@ -624,7 +623,7 @@ static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
>  
>  	dev_sw_netstats_tx_add(dev, 1, skb->len);
>  
> -	DSA_SKB_CB(skb)->clone = NULL;
> +	memset(skb->cb, 0, 48);
>  
>  	/* Handle tx timestamp if any */
>  	dsa_skb_tx_timestamp(p, skb);
> diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
> index f9df9cac81c5..1100a16f1032 100644
> --- a/net/dsa/tag_ocelot.c
> +++ b/net/dsa/tag_ocelot.c
> @@ -15,11 +15,11 @@ static void ocelot_xmit_ptp(struct dsa_port *dp, void *injection,
>  	ocelot_port = ocelot->ports[dp->index];
>  	rew_op = ocelot_port->ptp_cmd;
>  
> -	/* Retrieve timestamp ID populated inside skb->cb[0] of the
> -	 * clone by ocelot_port_add_txtstamp_skb
> +	/* Retrieve timestamp ID populated inside OCELOT_SKB_CB(clone)->ts_id
> +	 * by ocelot_port_add_txtstamp_skb
>  	 */
>  	if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP)
> -		rew_op |= clone->cb[0] << 3;
> +		rew_op |= OCELOT_SKB_CB(clone)->ts_id << 3;
>  
>  	ocelot_ifh_set_rew_op(injection, rew_op);
>  }
> @@ -28,7 +28,7 @@ static void ocelot_xmit_common(struct sk_buff *skb, struct net_device *netdev,
>  			       __be32 ifh_prefix, void **ifh)
>  {
>  	struct dsa_port *dp = dsa_slave_to_port(netdev);
> -	struct sk_buff *clone = DSA_SKB_CB(skb)->clone;
> +	struct sk_buff *clone = OCELOT_SKB_CB(skb)->clone;
>  	struct dsa_switch *ds = dp->ds;
>  	void *injection;
>  	__be32 *prefix;
> diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
> index 5f3e8e124a82..a001a7e3f575 100644
> --- a/net/dsa/tag_ocelot_8021q.c
> +++ b/net/dsa/tag_ocelot_8021q.c
> @@ -28,11 +28,11 @@ static struct sk_buff *ocelot_xmit_ptp(struct dsa_port *dp,
>  	ocelot_port = ocelot->ports[port];
>  	rew_op = ocelot_port->ptp_cmd;
>  
> -	/* Retrieve timestamp ID populated inside skb->cb[0] of the
> -	 * clone by ocelot_port_add_txtstamp_skb
> +	/* Retrieve timestamp ID populated inside OCELOT_SKB_CB(clone)->ts_id
> +	 * by ocelot_port_add_txtstamp_skb
>  	 */
>  	if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP)
> -		rew_op |= clone->cb[0] << 3;
> +		rew_op |= OCELOT_SKB_CB(clone)->ts_id << 3;
>  
>  	ocelot_port_inject_frame(ocelot, port, 0, rew_op, skb);
>  
> @@ -46,7 +46,7 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
>  	u16 tx_vid = dsa_8021q_tx_vid(dp->ds, dp->index);
>  	u16 queue_mapping = skb_get_queue_mapping(skb);
>  	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
> -	struct sk_buff *clone = DSA_SKB_CB(skb)->clone;
> +	struct sk_buff *clone = OCELOT_SKB_CB(skb)->clone;
>  
>  	/* TX timestamping was requested, so inject through MMIO */
>  	if (clone)
> -- 
> 2.25.1
