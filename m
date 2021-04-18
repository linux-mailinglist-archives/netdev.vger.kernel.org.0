Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F068B36347E
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 11:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbhDRJql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 05:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhDRJqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 05:46:40 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D152C06174A;
        Sun, 18 Apr 2021 02:46:12 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id h10so37163499edt.13;
        Sun, 18 Apr 2021 02:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SZD9ISYyFNxls1va1MMhi3xtcaos7JYeMVMNOTtDIwc=;
        b=rcNp3eAjoJt+w3NHe3+QMvsNajvTsIJINjm+vaIKpBYhJd+iOox9NIs3nw2y/BxiAg
         K3h/Ht0mE8dZPYZmikCs7r5PlA0jpW2CP5LBYG8Qc6gdiCbE85reugnk6rno8GK5Qbtj
         iImXCU7vLDeYmS485tzD7sYBoWNUFPl43tdvUN1IZSqEGIS34yILQaz9LX5P5xzf7o+a
         qKRMsi/CATnVUIO8W3EV/9scqmyjTxzQfchwz/ow59zCTzlwa36P52jEySm5/fSkzI0I
         gzAIYcAVxkMeeILPKbfqvX9VcujNXCjGy0idZY5CkuSFuUQ30ron9v8f7iYdB9S5qE0X
         Kqbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SZD9ISYyFNxls1va1MMhi3xtcaos7JYeMVMNOTtDIwc=;
        b=kjS+W9nFdvu2YhJW+UsB/qtD8OvWerWgwAXXbdYbMFRw1c5wvDeg5dZbjtl7zB1CT9
         aooL4V6yqEu6beCln5GQZtrXIuiCdtqnV4pbGbOzMZLXCJSS+IAws5aM6U3N6ebU0XBJ
         v4my6CSnNhmL+eEBLb19YaQh+tFQLA89ZSG5OGVHiR81vb0lNAW17ybaujP9bFhPd9RM
         DWDVVSWxhuXvc9oc4fVK8B0lLXr7u3MCX1BYdjOcVkBI6BV34n9Z+dAGLUV0sDPRJrGY
         +cL7VOIwwTvYROrwrGezl0juibyOwUFiHmQfzx+/2nragqcwPbZsJdq2UJev6zDil3OL
         IUSQ==
X-Gm-Message-State: AOAM530ultmlpKGH5L9lVzAnChOVKK3ucg6ee/YjdvsjwmEp18HZG8dP
        Kp/a+/JhwLLEK76f5xfku5M=
X-Google-Smtp-Source: ABdhPJxjGVgHkkUlJQXNbDc3be5gMTCsz8v9bcQEB4gVY8B/a4qe4vxMAfstAjV03DwzZvsLhOOHnw==
X-Received: by 2002:a05:6402:2290:: with SMTP id cw16mr7511643edb.162.1618739170814;
        Sun, 18 Apr 2021 02:46:10 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id g20sm10221067edu.91.2021.04.18.02.46.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 02:46:10 -0700 (PDT)
Date:   Sun, 18 Apr 2021 12:46:09 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
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
Subject: Re: [net-next 3/3] net: mscc: ocelot: support PTP Sync one-step
 timestamping
Message-ID: <20210418094609.xijzcg6g6zfcxucp@skbuf>
References: <20210416123655.42783-1-yangbo.lu@nxp.com>
 <20210416123655.42783-4-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210416123655.42783-4-yangbo.lu@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 08:36:55PM +0800, Yangbo Lu wrote:
> Although HWTSTAMP_TX_ONESTEP_SYNC existed in ioctl for hardware timestamp
> configuration, the PTP Sync one-step timestamping had never been supported.
> 
> This patch is to truely support it.

Actually the ocelot switchdev driver does support one-step timestamping,
just the felix DSA driver does not.

> The hardware timestamp request type is
> stored in DSA_SKB_CB_PRIV first byte per skb, so that corresponding
> configuration could be done during transmitting. Non-onestep-Sync packet
> with one-step timestamp request should fall back to use two-step timestamp.
> 
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> ---
>  drivers/net/ethernet/mscc/ocelot.c     | 57 ++++++++++++++++++++++++++
>  drivers/net/ethernet/mscc/ocelot_net.c |  5 +--
>  include/soc/mscc/ocelot.h              |  1 +
>  net/dsa/tag_ocelot.c                   | 25 ++---------
>  net/dsa/tag_ocelot_8021q.c             | 39 +++++-------------
>  5 files changed, 72 insertions(+), 55 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> index 541d3b4076be..69d36b6241ff 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -6,6 +6,7 @@
>   */
>  #include <linux/dsa/ocelot.h>
>  #include <linux/if_bridge.h>
> +#include <linux/ptp_classify.h>
>  #include <soc/mscc/ocelot_vcap.h>
>  #include "ocelot.h"
>  #include "ocelot_vcap.h"
> @@ -546,6 +547,50 @@ static void ocelot_port_add_txtstamp_skb(struct ocelot *ocelot, int port,
>  	spin_unlock(&ocelot_port->ts_id_lock);
>  }
>  
> +bool ocelot_ptp_rew_op(struct sk_buff *skb, struct sk_buff *clone, u32 *rew_op)
> +{
> +	/* For two-step timestamp, retrieve ptp_cmd in DSA_SKB_CB_PRIV
> +	 * and timestamp ID in clone->cb[0].
> +	 * For one-step timestamp, retrieve ptp_cmd in DSA_SKB_CB_PRIV.
> +	 */
> +	u8 *ptp_cmd = DSA_SKB_CB_PRIV(skb);

This is fine in the sense that it works, but please consider creating
something similar to sja1105:

struct ocelot_skb_cb {
	u8 ptp_cmd; /* For both one-step and two-step timestamping */
	u8 ts_id; /* Only for two-step timestamping */
};

#define OCELOT_SKB_CB(skb) \
	((struct ocelot_skb_cb *)DSA_SKB_CB_PRIV(skb))

And then access as OCELOT_SKB_CB(skb)->ptp_cmd, OCELOT_SKB_CB(clone)->ts_id.

and put a comment to explain that this is done in order to have common
code between Felix DSA and Ocelot switchdev. Basically Ocelot will not
use the first 8 bytes of skb->cb, but there's enough space for this to
not make any difference. The original skb will hold only ptp_cmd, the
clone will only hold ts_id, but it helps to have the same structure in
place.

If you create this ocelot_skb_cb structure, I expect the comment above
to be fairly redundant, you can consider removing it.

> +
> +	if (clone) {
> +		*rew_op = *ptp_cmd;
> +		*rew_op |= clone->cb[0] << 3;
> +	} else if (*ptp_cmd) {
> +		*rew_op = *ptp_cmd;
> +	} else {
> +		return false;
> +	}
> +
> +	return true;

Just make this function return an u32. If the packet isn't PTP, the
rew_op will be 0.

> +}
> +EXPORT_SYMBOL(ocelot_ptp_rew_op);
> +
> +static bool ocelot_ptp_is_onestep_sync(struct sk_buff *skb)
> +{
> +	struct ptp_header *hdr;
> +	unsigned int ptp_class;
> +	u8 msgtype, twostep;
> +
> +	ptp_class = ptp_classify_raw(skb);
> +	if (ptp_class == PTP_CLASS_NONE)
> +		return false;
> +
> +	hdr = ptp_parse_header(skb, ptp_class);
> +	if (!hdr)
> +		return false;
> +
> +	msgtype = ptp_get_msgtype(hdr, ptp_class);
> +	twostep = hdr->flag_field[0] & 0x2;
> +
> +	if (msgtype == PTP_MSGTYPE_SYNC && twostep == 0)
> +		return true;
> +
> +	return false;
> +}
> +

This is generic, but if you were to move it to net/core/ptp_classifier.c,
I think you would have to pass the output of ptp_classify_raw() as an
"unsigned int type" argument. So I think I would leave it the way it is
for now - inside of ocelot - until somebody else needs something
similar, and we see what is the required prototype.

>  int ocelot_port_txtstamp_request(struct ocelot *ocelot, int port,
>  				 struct sk_buff *skb,
>  				 struct sk_buff **clone)
> @@ -553,12 +598,24 @@ int ocelot_port_txtstamp_request(struct ocelot *ocelot, int port,
>  	struct ocelot_port *ocelot_port = ocelot->ports[port];
>  	u8 ptp_cmd = ocelot_port->ptp_cmd;
>  
> +	/* Store ptp_cmd in first byte of DSA_SKB_CB_PRIV per skb */
> +	if (ptp_cmd == IFH_REW_OP_ORIGIN_PTP) {
> +		if (ocelot_ptp_is_onestep_sync(skb)) {
> +			*(u8 *)DSA_SKB_CB_PRIV(skb) = ptp_cmd;
> +			return 0;
> +		}
> +
> +		/* Fall back to two-step timestamping */
> +		ptp_cmd = IFH_REW_OP_TWO_STEP_PTP;
> +	}
> +
>  	if (ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
>  		*clone = skb_clone_sk(skb);
>  		if (!(*clone))
>  			return -ENOMEM;
>  
>  		ocelot_port_add_txtstamp_skb(ocelot, port, *clone);
> +		*(u8 *)DSA_SKB_CB_PRIV(skb) = ptp_cmd;
>  	}
>  
>  	return 0;
> diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
> index 8293152a6dc1..eb3d525731da 100644
> --- a/drivers/net/ethernet/mscc/ocelot_net.c
> +++ b/drivers/net/ethernet/mscc/ocelot_net.c
> @@ -514,10 +514,7 @@ static netdev_tx_t ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
>  			return NETDEV_TX_OK;
>  		}
>  
> -		if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
> -			rew_op = ocelot_port->ptp_cmd;
> -			rew_op |= clone->cb[0] << 3;
> -		}
> +		ocelot_ptp_rew_op(skb, clone, &rew_op);
>  	}
>  
>  	ocelot_port_inject_frame(ocelot, port, 0, rew_op, skb);
> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index 9cdaf1d9199f..19413532db0b 100644
> --- a/include/soc/mscc/ocelot.h
> +++ b/include/soc/mscc/ocelot.h
> @@ -820,6 +820,7 @@ int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
>  int ocelot_vlan_del(struct ocelot *ocelot, int port, u16 vid);
>  int ocelot_hwstamp_get(struct ocelot *ocelot, int port, struct ifreq *ifr);
>  int ocelot_hwstamp_set(struct ocelot *ocelot, int port, struct ifreq *ifr);
> +bool ocelot_ptp_rew_op(struct sk_buff *skb, struct sk_buff *clone, u32 *rew_op);
>  int ocelot_port_txtstamp_request(struct ocelot *ocelot, int port,
>  				 struct sk_buff *skb,
>  				 struct sk_buff **clone);
> diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
> index f9df9cac81c5..d5c73b36f0c1 100644
> --- a/net/dsa/tag_ocelot.c
> +++ b/net/dsa/tag_ocelot.c
> @@ -5,25 +5,6 @@
>  #include <soc/mscc/ocelot.h>
>  #include "dsa_priv.h"
>  
> -static void ocelot_xmit_ptp(struct dsa_port *dp, void *injection,
> -			    struct sk_buff *clone)
> -{
> -	struct ocelot *ocelot = dp->ds->priv;
> -	struct ocelot_port *ocelot_port;
> -	u64 rew_op;
> -
> -	ocelot_port = ocelot->ports[dp->index];
> -	rew_op = ocelot_port->ptp_cmd;
> -
> -	/* Retrieve timestamp ID populated inside skb->cb[0] of the
> -	 * clone by ocelot_port_add_txtstamp_skb
> -	 */
> -	if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP)
> -		rew_op |= clone->cb[0] << 3;
> -
> -	ocelot_ifh_set_rew_op(injection, rew_op);
> -}
> -
>  static void ocelot_xmit_common(struct sk_buff *skb, struct net_device *netdev,
>  			       __be32 ifh_prefix, void **ifh)
>  {
> @@ -32,6 +13,7 @@ static void ocelot_xmit_common(struct sk_buff *skb, struct net_device *netdev,
>  	struct dsa_switch *ds = dp->ds;
>  	void *injection;
>  	__be32 *prefix;
> +	u32 rew_op = 0;
>  
>  	injection = skb_push(skb, OCELOT_TAG_LEN);
>  	prefix = skb_push(skb, OCELOT_SHORT_PREFIX_LEN);
> @@ -42,9 +24,8 @@ static void ocelot_xmit_common(struct sk_buff *skb, struct net_device *netdev,
>  	ocelot_ifh_set_src(injection, ds->num_ports);
>  	ocelot_ifh_set_qos_class(injection, skb->priority);
>  
> -	/* TX timestamping was requested */
> -	if (clone)
> -		ocelot_xmit_ptp(dp, injection, clone);
> +	if (ocelot_ptp_rew_op(skb, clone, &rew_op))
> +		ocelot_ifh_set_rew_op(injection, rew_op);
>  
>  	*ifh = injection;
>  }
> diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
> index 5f3e8e124a82..bf32649a5a7b 100644
> --- a/net/dsa/tag_ocelot_8021q.c
> +++ b/net/dsa/tag_ocelot_8021q.c
> @@ -13,32 +13,6 @@
>  #include <soc/mscc/ocelot_ptp.h>
>  #include "dsa_priv.h"
>  
> -static struct sk_buff *ocelot_xmit_ptp(struct dsa_port *dp,
> -				       struct sk_buff *skb,
> -				       struct sk_buff *clone)
> -{
> -	struct ocelot *ocelot = dp->ds->priv;
> -	struct ocelot_port *ocelot_port;
> -	int port = dp->index;
> -	u32 rew_op;
> -
> -	if (!ocelot_can_inject(ocelot, 0))
> -		return NULL;
> -
> -	ocelot_port = ocelot->ports[port];
> -	rew_op = ocelot_port->ptp_cmd;
> -
> -	/* Retrieve timestamp ID populated inside skb->cb[0] of the
> -	 * clone by ocelot_port_add_txtstamp_skb
> -	 */
> -	if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP)
> -		rew_op |= clone->cb[0] << 3;
> -
> -	ocelot_port_inject_frame(ocelot, port, 0, rew_op, skb);
> -
> -	return NULL;
> -}
> -
>  static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
>  				   struct net_device *netdev)
>  {
> @@ -47,10 +21,17 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
>  	u16 queue_mapping = skb_get_queue_mapping(skb);
>  	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
>  	struct sk_buff *clone = DSA_SKB_CB(skb)->clone;
> +	struct ocelot *ocelot = dp->ds->priv;
> +	int port = dp->index;
> +	u32 rew_op = 0;
> +
> +	if (ocelot_ptp_rew_op(skb, clone, &rew_op)) {
> +		if (!ocelot_can_inject(ocelot, 0))
> +			return NULL;
>  
> -	/* TX timestamping was requested, so inject through MMIO */
> -	if (clone)
> -		return ocelot_xmit_ptp(dp, skb, clone);
> +		ocelot_port_inject_frame(ocelot, port, 0, rew_op, skb);
> +		return NULL;
> +	}
>  
>  	return dsa_8021q_xmit(skb, netdev, ETH_P_8021Q,
>  			      ((pcp << VLAN_PRIO_SHIFT) | tx_vid));
> -- 
> 2.25.1
> 
