Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E17333417C6
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 09:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbhCSIwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 04:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbhCSIwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 04:52:43 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3AEC06174A;
        Fri, 19 Mar 2021 01:52:43 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id j25so5413517pfe.2;
        Fri, 19 Mar 2021 01:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yj5tTnJ8P9q/A1HgbomrJhBjWZxZL3eXt/rcHcWqOEg=;
        b=dON2vulw4crJKBs9JyRGQdhFRRJEy94aos/Uu6zJDTtO8GRAq7pKd1lTKAsrXzgSOp
         VJkiaG7n4kB/ujSJ39iGEWb7T3jEUL2SJVH/r004HMAbgO/eYKU0iwfeRzrOMmMiYeCq
         KeYi8o4aWFdMRR92dp+yZLUDSyHRSden31vosjHR8zQtSat1cZdKDsQ5wKQj2zmwRKlt
         Ega8NMs6oboer4TRCKu5OYahTgPuRwFl2act8L33Eoaul7GEObRbtJH8j+4ciny5WTvc
         gqTQA9On5qcQPxQr7BzOBfD44VhKMxWuSZoEb60xJcEj5sRKIFdRHojheHrGt8z5QeiH
         jctA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yj5tTnJ8P9q/A1HgbomrJhBjWZxZL3eXt/rcHcWqOEg=;
        b=loF4WroFm72SCAzZSTUNwDrYZacf0q9zGboQY4tiRVmoWotRP5F/xEjxzSX7uhmgi2
         nhA/zTQoSD/ODOIlDGrVn2sa4hLbydto9VOa4OrZmYUu1y28Y+v2FAGsb7sEC+2U3osr
         /gSlFzB08jY7p9xv5WtdAkRv0qTc8RG9xtY5x4kqK+cgB+IjqQ74PZGCVACmwmYxg2+k
         jjqQVQHxxDfiYD95BVTvqiAuGhjyIPRbkHcBpO796WTlwZ5HQc5LMzaNBJa2bPYpNmXA
         YiPb9Iwoj/Lb5kqQUPFMIybxxcgo/6O9c/89+rvyU/fixjDBsamamDc6MPWSrXHfchvi
         tcLQ==
X-Gm-Message-State: AOAM5307bS9ZcJ398+mLz81hCmMxy3Fq6cq35riZfjmABcaxA1FrAUeG
        lHAp8+Y467deQEjRe0YtQd9o+61DwjGR8FWm
X-Google-Smtp-Source: ABdhPJxiPORLP5tLhZ+mxP0U8I2VtATH84sYmSkvSHt6rl1ObiZfjCN00t0fXByzQEooFRUhbYin2A==
X-Received: by 2002:a65:5281:: with SMTP id y1mr10202697pgp.12.1616143962944;
        Fri, 19 Mar 2021 01:52:42 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id z8sm4529013pjr.57.2021.03.19.01.52.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 01:52:42 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH v2 net-next 14/16] net: dsa: don't set skb->offload_fwd_mark when not offloading the bridge
Date:   Fri, 19 Mar 2021 16:52:31 +0800
Message-Id: <20210319084025.GA2152639@haswell-ubuntu20>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210318231829.3892920-15-olteanv@gmail.com>
References: <20210318231829.3892920-1-olteanv@gmail.com> <20210318231829.3892920-15-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 01:18:27AM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> DSA has gained the recent ability to deal gracefully with upper
> interfaces it cannot offload, such as the bridge, bonding or team
> drivers. When such uppers exist, the ports are still in standalone mode
> as far as the hardware is concerned.
> 
> But when we deliver packets to the software bridge in order for that to
> do the forwarding, there is an unpleasant surprise in that the bridge
> will refuse to forward them. This is because we unconditionally set
> skb->offload_fwd_mark = true, meaning that the bridge thinks the frames
> were already forwarded in hardware by us.
> 
> Since dp->bridge_dev is populated only when there is hardware offload
> for it, but not in the software fallback case, let's introduce a new
> helper that can be called from the tagger data path which sets the
> skb->offload_fwd_mark accordingly to zero when there is no hardware
> offload for bridging. This lets the bridge forward packets back to other
> interfaces of our switch, if needed.
> 
> Without this change, sending a packet to the CPU for an unoffloaded
> interface triggers this WARN_ON:
> 
> void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
> 			      struct sk_buff *skb)
> {
> 	if (skb->offload_fwd_mark && !WARN_ON_ONCE(!p->offload_fwd_mark))
> 		BR_INPUT_SKB_CB(skb)->offload_fwd_mark = p->offload_fwd_mark;
> }
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  net/dsa/dsa_priv.h         | 14 ++++++++++++++
>  net/dsa/tag_brcm.c         |  2 +-
>  net/dsa/tag_dsa.c          | 15 +++++++++++----
>  net/dsa/tag_hellcreek.c    |  2 +-
>  net/dsa/tag_ksz.c          |  2 +-
>  net/dsa/tag_lan9303.c      |  3 ++-
>  net/dsa/tag_mtk.c          |  2 +-
>  net/dsa/tag_ocelot.c       |  2 +-
>  net/dsa/tag_ocelot_8021q.c |  2 +-
>  net/dsa/tag_rtl4_a.c       |  2 +-
>  net/dsa/tag_sja1105.c      |  4 ++--
>  net/dsa/tag_xrs700x.c      |  2 +-
>  12 files changed, 37 insertions(+), 15 deletions(-)
> 
> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> index 92282de54230..b61bef79ce84 100644
> --- a/net/dsa/dsa_priv.h
> +++ b/net/dsa/dsa_priv.h
> @@ -349,6 +349,20 @@ static inline struct sk_buff *dsa_untag_bridge_pvid(struct sk_buff *skb)
>  	return skb;
>  }
>  
> +/* If the ingress port offloads the bridge, we mark the frame as autonomously
> + * forwarded by hardware, so the software bridge doesn't forward in twice, back
> + * to us, because we already did. However, if we're in fallback mode and we do
> + * software bridging, we are not offloading it, therefore the dp->bridge_dev
> + * pointer is not populated, and flooding needs to be done by software (we are
> + * effectively operating in standalone ports mode).
> + */
> +static inline void dsa_default_offload_fwd_mark(struct sk_buff *skb)
> +{
> +	struct dsa_port *dp = dsa_slave_to_port(skb->dev);
> +
> +	skb->offload_fwd_mark = !!(dp->bridge_dev);
> +}

So offload_fwd_mark is set iff the ingress port offloads the bridge.
Consider this set up on a switch which does NOT support LAG offload:

        +----- br0 -----+
        |               |
      bond0             |
        |               |         (Linux interfaces)
    +---+---+       +---+---+
    |       |       |       |
+-------+-------+-------+-------+
| sw0p0 | sw0p1 | sw0p2 | sw0p3 |
+-------+-------+-------+-------+
    |       |       |       |
    +---A---+       B       C     (LAN clients)


sw0p0 and sw0p1 should be in standalone mode (offload_fwd_mark = 0),
while sw0p2 and sw0p3 are offloaded (offload_fwd_mark = 1).

When a frame is sent into sw0p2 or sw0p3, can it be forwarded to sw0p0 or
sw0p1?

Setting offload_fwd_mark to 0 could also cause potential packet loss on
switches that perform learning on the CPU port:

When client C is talking to client A, frames from C will:
1. Enter sw0p3, where the switch will learn C is reachable via sw0p3.
2. Be sent to the CPU port and bounced back, where the switch will learn C is
   reachable via the CPU port, overwriting the previous learned FDB entry.
3. Be sent out of either sw0p0 or sw0p1, and reach its destination - A.

During step 2, if client B sends a frame to C, the frame will be forwarded to
the CPU, which will think it is already forwarded by the switch, and refuse to
forward it back, resulting in packet loss.

Many switch TX tags (mtk, qca, rtl) have a bit to disable source address
learning on a per-frame basis. We should utilise that.

> +
>  /* switch.c */
>  int dsa_switch_register_notifier(struct dsa_switch *ds);
>  void dsa_switch_unregister_notifier(struct dsa_switch *ds);
> diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
> index e2577a7dcbca..a8880b3bb106 100644
> --- a/net/dsa/tag_brcm.c
> +++ b/net/dsa/tag_brcm.c
> @@ -150,7 +150,7 @@ static struct sk_buff *brcm_tag_rcv_ll(struct sk_buff *skb,
>  	/* Remove Broadcom tag and update checksum */
>  	skb_pull_rcsum(skb, BRCM_TAG_LEN);
>  
> -	skb->offload_fwd_mark = 1;
> +	dsa_default_offload_fwd_mark(skb);
>  
>  	return skb;
>  }
> diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
> index 7e7b7decdf39..09ab9c25e686 100644
> --- a/net/dsa/tag_dsa.c
> +++ b/net/dsa/tag_dsa.c
> @@ -162,8 +162,8 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
>  static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
>  				  u8 extra)
>  {
> +	bool trap = false, trunk = false;
>  	int source_device, source_port;
> -	bool trunk = false;
>  	enum dsa_code code;
>  	enum dsa_cmd cmd;
>  	u8 *dsa_header;
> @@ -174,8 +174,6 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
>  	cmd = dsa_header[0] >> 6;
>  	switch (cmd) {
>  	case DSA_CMD_FORWARD:
> -		skb->offload_fwd_mark = 1;
> -
>  		trunk = !!(dsa_header[1] & 7);
>  		break;
>  
> @@ -194,7 +192,6 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
>  			 * device (like a bridge) that forwarding has
>  			 * already been done by hardware.
>  			 */
> -			skb->offload_fwd_mark = 1;
>  			break;
>  		case DSA_CODE_MGMT_TRAP:
>  		case DSA_CODE_IGMP_MLD_TRAP:
> @@ -202,6 +199,7 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
>  			/* Traps have, by definition, not been
>  			 * forwarded by hardware, so don't mark them.
>  			 */
> +			trap = true;
>  			break;
>  		default:
>  			/* Reserved code, this could be anything. Drop
> @@ -235,6 +233,15 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
>  	if (!skb->dev)
>  		return NULL;
>  
> +	/* When using LAG offload, skb->dev is not a DSA slave interface,
> +	 * so we cannot call dsa_default_offload_fwd_mark and we need to
> +	 * special-case it.
> +	 */
> +	if (trunk)
> +		skb->offload_fwd_mark = true;
> +	else if (!trap)
> +		dsa_default_offload_fwd_mark(skb);
> +
>  	/* If the 'tagged' bit is set; convert the DSA tag to a 802.1Q
>  	 * tag, and delete the ethertype (extra) if applicable. If the
>  	 * 'tagged' bit is cleared; delete the DSA tag, and ethertype
> diff --git a/net/dsa/tag_hellcreek.c b/net/dsa/tag_hellcreek.c
> index a09805c8e1ab..c1ee6eefafe4 100644
> --- a/net/dsa/tag_hellcreek.c
> +++ b/net/dsa/tag_hellcreek.c
> @@ -44,7 +44,7 @@ static struct sk_buff *hellcreek_rcv(struct sk_buff *skb,
>  
>  	pskb_trim_rcsum(skb, skb->len - HELLCREEK_TAG_LEN);
>  
> -	skb->offload_fwd_mark = true;
> +	dsa_default_offload_fwd_mark(skb);
>  
>  	return skb;
>  }
> diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
> index 4820dbcedfa2..8eee63a5b93b 100644
> --- a/net/dsa/tag_ksz.c
> +++ b/net/dsa/tag_ksz.c
> @@ -24,7 +24,7 @@ static struct sk_buff *ksz_common_rcv(struct sk_buff *skb,
>  
>  	pskb_trim_rcsum(skb, skb->len - len);
>  
> -	skb->offload_fwd_mark = true;
> +	dsa_default_offload_fwd_mark(skb);
>  
>  	return skb;
>  }
> diff --git a/net/dsa/tag_lan9303.c b/net/dsa/tag_lan9303.c
> index aa1318dccaf0..3a5494d2f7b1 100644
> --- a/net/dsa/tag_lan9303.c
> +++ b/net/dsa/tag_lan9303.c
> @@ -115,7 +115,8 @@ static struct sk_buff *lan9303_rcv(struct sk_buff *skb, struct net_device *dev,
>  	skb_pull_rcsum(skb, 2 + 2);
>  	memmove(skb->data - ETH_HLEN, skb->data - (ETH_HLEN + LAN9303_TAG_LEN),
>  		2 * ETH_ALEN);
> -	skb->offload_fwd_mark = !(lan9303_tag1 & LAN9303_TAG_RX_TRAPPED_TO_CPU);
> +	if (!(lan9303_tag1 & LAN9303_TAG_RX_TRAPPED_TO_CPU))
> +		dsa_default_offload_fwd_mark(skb);
>  
>  	return skb;
>  }
> diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
> index f9b2966d1936..92ab21d2ceca 100644
> --- a/net/dsa/tag_mtk.c
> +++ b/net/dsa/tag_mtk.c
> @@ -92,7 +92,7 @@ static struct sk_buff *mtk_tag_rcv(struct sk_buff *skb, struct net_device *dev,
>  	if (!skb->dev)
>  		return NULL;
>  
> -	skb->offload_fwd_mark = 1;
> +	dsa_default_offload_fwd_mark(skb);
>  
>  	return skb;
>  }
> diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
> index f9df9cac81c5..1deba3f1bb82 100644
> --- a/net/dsa/tag_ocelot.c
> +++ b/net/dsa/tag_ocelot.c
> @@ -123,7 +123,7 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
>  		 */
>  		return NULL;
>  
> -	skb->offload_fwd_mark = 1;
> +	dsa_default_offload_fwd_mark(skb);
>  	skb->priority = qos_class;
>  
>  	/* Ocelot switches copy frames unmodified to the CPU. However, it is
> diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
> index 5f3e8e124a82..447e1eeb357c 100644
> --- a/net/dsa/tag_ocelot_8021q.c
> +++ b/net/dsa/tag_ocelot_8021q.c
> @@ -81,7 +81,7 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
>  	if (!skb->dev)
>  		return NULL;
>  
> -	skb->offload_fwd_mark = 1;
> +	dsa_default_offload_fwd_mark(skb);
>  	skb->priority = qos_class;
>  
>  	return skb;
> diff --git a/net/dsa/tag_rtl4_a.c b/net/dsa/tag_rtl4_a.c
> index e9176475bac8..1864e3a74df8 100644
> --- a/net/dsa/tag_rtl4_a.c
> +++ b/net/dsa/tag_rtl4_a.c
> @@ -114,7 +114,7 @@ static struct sk_buff *rtl4a_tag_rcv(struct sk_buff *skb,
>  		skb->data - ETH_HLEN - RTL4_A_HDR_LEN,
>  		2 * ETH_ALEN);
>  
> -	skb->offload_fwd_mark = 1;
> +	dsa_default_offload_fwd_mark(skb);
>  
>  	return skb;
>  }
> diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
> index 50496013cdb7..45cdf64f0e88 100644
> --- a/net/dsa/tag_sja1105.c
> +++ b/net/dsa/tag_sja1105.c
> @@ -295,8 +295,6 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
>  	is_link_local = sja1105_is_link_local(skb);
>  	is_meta = sja1105_is_meta_frame(skb);
>  
> -	skb->offload_fwd_mark = 1;
> -
>  	if (is_tagged) {
>  		/* Normal traffic path. */
>  		skb_push_rcsum(skb, ETH_HLEN);
> @@ -339,6 +337,8 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
>  		return NULL;
>  	}
>  
> +	dsa_default_offload_fwd_mark(skb);
> +
>  	if (subvlan)
>  		sja1105_decode_subvlan(skb, subvlan);
>  
> diff --git a/net/dsa/tag_xrs700x.c b/net/dsa/tag_xrs700x.c
> index 858cdf9d2913..1208549f45c1 100644
> --- a/net/dsa/tag_xrs700x.c
> +++ b/net/dsa/tag_xrs700x.c
> @@ -46,7 +46,7 @@ static struct sk_buff *xrs700x_rcv(struct sk_buff *skb, struct net_device *dev,
>  		return NULL;
>  
>  	/* Frame is forwarded by hardware, don't forward in software. */
> -	skb->offload_fwd_mark = 1;
> +	dsa_default_offload_fwd_mark(skb);
>  
>  	return skb;
>  }
> -- 
> 2.25.1
> 

