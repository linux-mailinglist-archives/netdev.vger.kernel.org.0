Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141EE30AB26
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 16:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbhBAPYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 10:24:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbhBAPYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 10:24:00 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9409C061573
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 07:23:19 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id c2so19272830edr.11
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 07:23:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lfwN7DjSmJtYRU6+oZYNoOQ2ss7UjOg+nSQKhtlL1WA=;
        b=NUmTPjAmjlwEIeLksy5G2bCIlgHceHcDr3LS4BOfHCQIIRDEl8FSYo5Dc2X/7YU0Zi
         MsgDF5ffTpHOUMg/NNIZrlhlAtygXPW4fK90xv6qdDt0mPdjbfiIfiYTfa9lN7lWHDAH
         crdoJuHr1Xonpq1JPB+U8Re4X2qeeDk5RAmWT+O+Bzaz7cHXfFQ6zKZB5N8YaGXRHumo
         OHUMOGNIqHIXqfu3OkueQ8AzuMVW780u0xj4GHG3NnsYBbf/ql/xdMMlq/pwBmD77FDm
         dT1EKqR2EBJadlocCNypU+qTzTHPay2EUa3l/BfGz9Q/mISwxP1nBATHVRt8Fe2TPzBU
         EAnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lfwN7DjSmJtYRU6+oZYNoOQ2ss7UjOg+nSQKhtlL1WA=;
        b=rrnA5sfV2c+CWz8HugyUb6hHqD9xxZuLUjmN/KPVBZjPEAxEWT+tj18P0BCBXfGD2f
         I19H2YWuda6qeUhRgaavSfkkTgqG0wi8PBT055X4n6jv2HZo4qiiwa6l540P10FTk8+j
         OTeNqKrpPkbEHWAnzg3kOtbRWDZjJtxY4BiC2qgiJkESP4NZB/tyV9kNGN/zyCu+22/o
         c1oZaH+cG8xukQHombsW/wiZEO3y59gYCWlgy59u++Zw8oMWM5P7Z4tJM2ll64iatwWS
         CTQqrBuVmK9hidtSopqkNUKZ+E26zBfX7EwH9zTXeM5zZFpTmffEDsH+FjjSLGkfRdXz
         xAQg==
X-Gm-Message-State: AOAM530jj5+Ju279gNIJsgt7f7ahls5xnWTbiwMbs3Ocf+xKPwzrBoAo
        2GGzb751skspHl27IwYzVGHPHyXlrSY=
X-Google-Smtp-Source: ABdhPJwTzEjsZIu/zsPfWnJRtOXNPp7pnXzvhpoGEv94j0MujNY9Qz26emOGWxgvlyYYRp3lbFLoSA==
X-Received: by 2002:aa7:dd16:: with SMTP id i22mr19201496edv.215.1612192998449;
        Mon, 01 Feb 2021 07:23:18 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id h15sm8094137ejj.43.2021.02.01.07.23.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 07:23:17 -0800 (PST)
Date:   Mon, 1 Feb 2021 17:23:16 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org
Subject: Re: [RESEND PATCH net-next 2/4] net: hsr: add offloading support
Message-ID: <20210201152316.5tienmoueezr4ptj@skbuf>
References: <20210201140503.130625-1-george.mccollister@gmail.com>
 <20210201140503.130625-3-george.mccollister@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210201140503.130625-3-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 01, 2021 at 08:05:01AM -0600, George McCollister wrote:
> Add support for offloading of HSR/PRP (IEC 62439-3) tag insertion
> tag removal, duplicate generation and forwarding.
> 
> Use a new netdev_priv_flag IFF_HSR to indicate that a device is an HSR
> device so DSA can tell them apart from other devices in
> dsa_slave_changeupper.

My opinion can easily be overridden by somebody with more experience,
but for the purposes of determining whether a net_device is DSA or not,
DSA did not use a priv_flags bit, but simply exported dsa_slave_dev_check
which looks at its netdev_ops.

I am not sure what is the history of the IFF_EBRIDGE/BONDING/... bits,
but it seems a bit wasteful to me to consume the last bit of priv_flags
on something that can be derived from other sources.

I am basing this comment on the fact that your patch series does not
make use of the IFF_SLAVE bit and of netif_is_hsr_slave, and therefore
that you should probably not add a function that is not used, or the
mechanism for it.

> 
> For HSR, insertion involves the switch adding a 6 byte HSR header after
> the 14 byte Ethernet header. For PRP it adds a 6 byte trailer.
> 
> Tag removal involves automatically stripping the HSR/PRP header/trailer
> in the switch. This is possible when the switch also preforms auto
                                                       ~~~~~~~~
                                                       performs
> deduplication using the HSR/PRP header/trailer (making it no longer
> required).
> 
> Forwarding involves automatically forwarding between redundant ports in
> an HSR. This is crucial because delay is accumulated as a frame passes
> through each node in the ring.
> 
> Duplication involves the switch automatically sending a single frame
> from the CPU port to both redundant ports. This is required because the
> inserted HSR/PRP header/trailer must contain the same sequence number
> on the frames sent out both redundant ports.
> 
> Signed-off-by: George McCollister <george.mccollister@gmail.com>
> ---
>  Documentation/networking/netdev-features.rst | 20 ++++++++++++++++++++
>  include/linux/if_hsr.h                       | 22 ++++++++++++++++++++++
>  include/linux/netdev_features.h              |  9 +++++++++
>  include/linux/netdevice.h                    | 13 +++++++++++++
>  net/ethtool/common.c                         |  4 ++++
>  net/hsr/hsr_device.c                         | 12 +++---------
>  net/hsr/hsr_forward.c                        | 27 ++++++++++++++++++++++++---
>  net/hsr/hsr_forward.h                        |  1 +
>  net/hsr/hsr_main.c                           | 14 ++++++++++++++
>  net/hsr/hsr_main.h                           |  8 +-------
>  net/hsr/hsr_slave.c                          | 13 +++++++++----
>  11 files changed, 120 insertions(+), 23 deletions(-)
>  create mode 100644 include/linux/if_hsr.h
> 
> diff --git a/Documentation/networking/netdev-features.rst b/Documentation/networking/netdev-features.rst
> index a2d7d7160e39..4eab45405031 100644
> --- a/Documentation/networking/netdev-features.rst
> +++ b/Documentation/networking/netdev-features.rst
> @@ -182,3 +182,23 @@ stricter than Hardware LRO.  A packet stream merged by Hardware GRO must
>  be re-segmentable by GSO or TSO back to the exact original packet stream.
>  Hardware GRO is dependent on RXCSUM since every packet successfully merged
>  by hardware must also have the checksum verified by hardware.
> +
> +* hsr-tag-ins-offload
> +
> +This should be set for devices which insert an HSR (highspeed ring) tag
                                                       ~~~~~~~~~~~~~~

The one thing I know about HSR is that it stands for High-availability
Seamless Redundancy, not High Speed Ring.

Also, it would be good to mention that these features apply to PRP too.

> +automatically when in HSR mode.
> +
> +* hsr-tag-rm-offload
> +
> +This should be set for devices which remove HSR (highspeed ring) tags
> +automatically when in HSR mode.
> +
> +* hsr-fwd-offload
> +
> +This should be set for devices which forward HSR (highspeed ring) frames from
> +one port to another in hardware.
> +
> +* hsr-dup-offload
> +
> +This should be set for devices which duplicate outgoing HSR (highspeed ring)
> +frames in hardware.

I don't have a strong opinion on creating ethtool features that are so
fine-grained, but do we really expect to see a net_device capable of
hsr-tag-rm-offload but not hsr-tag-ins-offload, or hsr-dup-offload but
not hsr-fwd-offload?

> diff --git a/include/linux/if_hsr.h b/include/linux/if_hsr.h
> new file mode 100644
> index 000000000000..eec9079efab0
> --- /dev/null
> +++ b/include/linux/if_hsr.h
> @@ -0,0 +1,22 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_IF_HSR_H_
> +#define _LINUX_IF_HSR_H_
> +
> +/* used to differentiate various protocols */
> +enum hsr_version {
> +	HSR_V0 = 0,
> +	HSR_V1,
> +	PRP_V1,
> +};
> +
> +#if IS_ENABLED(CONFIG_HSR)
> +extern int hsr_get_version(struct net_device *dev, enum hsr_version *ver);
> +#else
> +static inline int hsr_get_version(struct net_device *dev,
> +				  enum hsr_version *ver)
> +{
> +	return -EINVAL;
> +}
> +#endif /* CONFIG_HSR */
> +
> +#endif /*_LINUX_IF_HSR_H_*/
> diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
> index c06d6aaba9df..3de38d6a0aea 100644
> --- a/include/linux/netdev_features.h
> +++ b/include/linux/netdev_features.h
> @@ -86,6 +86,11 @@ enum {
>  	NETIF_F_HW_MACSEC_BIT,		/* Offload MACsec operations */
>  	NETIF_F_GRO_UDP_FWD_BIT,	/* Allow UDP GRO for forwarding */
>  
> +	NETIF_F_HW_HSR_TAG_INS_BIT,	/* Offload HSR tag insertion */
> +	NETIF_F_HW_HSR_TAG_RM_BIT,	/* Offload HSR tag removal */
> +	NETIF_F_HW_HSR_FWD_BIT,		/* Offload HSR forwarding */
> +	NETIF_F_HW_HSR_DUP_BIT,		/* Offload HSR duplication */
> +
>  	/*
>  	 * Add your fresh new feature above and remember to update
>  	 * netdev_features_strings[] in net/core/ethtool.c and maybe
> @@ -159,6 +164,10 @@ enum {
>  #define NETIF_F_GSO_FRAGLIST	__NETIF_F(GSO_FRAGLIST)
>  #define NETIF_F_HW_MACSEC	__NETIF_F(HW_MACSEC)
>  #define NETIF_F_GRO_UDP_FWD	__NETIF_F(GRO_UDP_FWD)
> +#define NETIF_F_HW_HSR_TAG_INS	__NETIF_F(HW_HSR_TAG_INS)
> +#define NETIF_F_HW_HSR_TAG_RM	__NETIF_F(HW_HSR_TAG_RM)
> +#define NETIF_F_HW_HSR_FWD	__NETIF_F(HW_HSR_FWD)
> +#define NETIF_F_HW_HSR_DUP	__NETIF_F(HW_HSR_DUP)
>  
>  /* Finds the next feature with the highest number of the range of start till 0.
>   */
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index e9e7ada07ea1..9ac6f30c4a51 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1526,6 +1526,7 @@ struct net_device_ops {
>   * @IFF_FAILOVER_SLAVE: device is lower dev of a failover master device
>   * @IFF_L3MDEV_RX_HANDLER: only invoke the rx handler of L3 master device
>   * @IFF_LIVE_RENAME_OK: rename is allowed while device is up and running
> + * @IFF_HSR: device is an hsr device
>   */
>  enum netdev_priv_flags {
>  	IFF_802_1Q_VLAN			= 1<<0,
> @@ -1559,6 +1560,7 @@ enum netdev_priv_flags {
>  	IFF_FAILOVER_SLAVE		= 1<<28,
>  	IFF_L3MDEV_RX_HANDLER		= 1<<29,
>  	IFF_LIVE_RENAME_OK		= 1<<30,
> +	IFF_HSR				= 1<<31,
>  };
>  
>  #define IFF_802_1Q_VLAN			IFF_802_1Q_VLAN
> @@ -1591,6 +1593,7 @@ enum netdev_priv_flags {
>  #define IFF_FAILOVER_SLAVE		IFF_FAILOVER_SLAVE
>  #define IFF_L3MDEV_RX_HANDLER		IFF_L3MDEV_RX_HANDLER
>  #define IFF_LIVE_RENAME_OK		IFF_LIVE_RENAME_OK
> +#define IFF_HSR				IFF_HSR
>  
>  /**
>   *	struct net_device - The DEVICE structure.
> @@ -5003,6 +5006,16 @@ static inline bool netif_is_failover_slave(const struct net_device *dev)
>  	return dev->priv_flags & IFF_FAILOVER_SLAVE;
>  }
>  
> +static inline bool netif_is_hsr_master(const struct net_device *dev)
> +{
> +	return dev->flags & IFF_MASTER && dev->priv_flags & IFF_HSR;
> +}
> +
> +static inline bool netif_is_hsr_slave(const struct net_device *dev)
> +{
> +	return dev->flags & IFF_SLAVE && dev->priv_flags & IFF_HSR;
> +}
> +
>  /* This device needs to keep skb dst for qdisc enqueue or ndo_start_xmit() */
>  static inline void netif_keep_dst(struct net_device *dev)
>  {
> diff --git a/net/ethtool/common.c b/net/ethtool/common.c
> index 181220101a6e..0298e5635ace 100644
> --- a/net/ethtool/common.c
> +++ b/net/ethtool/common.c
> @@ -69,6 +69,10 @@ const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN] = {
>  	[NETIF_F_GRO_FRAGLIST_BIT] =	 "rx-gro-list",
>  	[NETIF_F_HW_MACSEC_BIT] =	 "macsec-hw-offload",
>  	[NETIF_F_GRO_UDP_FWD_BIT] =	 "rx-udp-gro-forwarding",
> +	[NETIF_F_HW_HSR_TAG_INS_BIT] =	 "hsr-tag-ins-offload",
> +	[NETIF_F_HW_HSR_TAG_RM_BIT] =	 "hsr-tag-rm-offload",
> +	[NETIF_F_HW_HSR_FWD_BIT] =	 "hsr-fwd-offload",
> +	[NETIF_F_HW_HSR_DUP_BIT] =	 "hsr-dup-offload",
>  };
>  
>  const char
> diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
> index 161b8da6a21d..d9b033e9b18c 100644
> --- a/net/hsr/hsr_device.c
> +++ b/net/hsr/hsr_device.c
> @@ -418,6 +418,7 @@ static struct hsr_proto_ops hsr_ops = {
>  	.send_sv_frame = send_hsr_supervision_frame,
>  	.create_tagged_frame = hsr_create_tagged_frame,
>  	.get_untagged_frame = hsr_get_untagged_frame,
> +	.drop_frame = hsr_drop_frame,
>  	.fill_frame_info = hsr_fill_frame_info,
>  	.invalid_dan_ingress_frame = hsr_invalid_dan_ingress_frame,
>  };
> @@ -521,15 +522,8 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
>  
>  	hsr->prot_version = protocol_version;
>  
> -	/* FIXME: should I modify the value of these?
> -	 *
> -	 * - hsr_dev->flags - i.e.
> -	 *			IFF_MASTER/SLAVE?
> -	 * - hsr_dev->priv_flags - i.e.
> -	 *			IFF_EBRIDGE?
> -	 *			IFF_TX_SKB_SHARING?
> -	 *			IFF_HSR_MASTER/SLAVE?
> -	 */
> +	hsr_dev->flags |= IFF_MASTER;
> +	hsr_dev->priv_flags |= IFF_HSR;
>  
>  	/* Make sure the 1st call to netif_carrier_on() gets through */
>  	netif_carrier_off(hsr_dev);
> diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
> index a5566b2245a0..9c79d602c4e0 100644
> --- a/net/hsr/hsr_forward.c
> +++ b/net/hsr/hsr_forward.c
> @@ -247,6 +247,8 @@ struct sk_buff *hsr_create_tagged_frame(struct hsr_frame_info *frame,
>  		/* set the lane id properly */
>  		hsr_set_path_id(hsr_ethhdr, port);
>  		return skb_clone(frame->skb_hsr, GFP_ATOMIC);
> +	} else if (port->dev->features & NETIF_F_HW_HSR_TAG_INS) {
> +		return skb_clone(frame->skb_std, GFP_ATOMIC);
>  	}
>  
>  	/* Create the new skb with enough headroom to fit the HSR tag */
> @@ -341,6 +343,14 @@ bool prp_drop_frame(struct hsr_frame_info *frame, struct hsr_port *port)
>  		 port->type ==  HSR_PT_SLAVE_A));
>  }
>  
> +bool hsr_drop_frame(struct hsr_frame_info *frame, struct hsr_port *port)
> +{
> +	if (port->dev->features & NETIF_F_HW_HSR_FWD)
> +		return prp_drop_frame(frame, port);
> +
> +	return false;
> +}
> +
>  /* Forward the frame through all devices except:
>   * - Back through the receiving device
>   * - If it's a HSR frame: through a device where it has passed before
> @@ -357,6 +367,7 @@ static void hsr_forward_do(struct hsr_frame_info *frame)
>  {
>  	struct hsr_port *port;
>  	struct sk_buff *skb;
> +	bool sent = false;
>  
>  	hsr_for_each_port(frame->port_rcv->hsr, port) {
>  		struct hsr_priv *hsr = port->hsr;
> @@ -372,6 +383,12 @@ static void hsr_forward_do(struct hsr_frame_info *frame)
>  		if (port->type != HSR_PT_MASTER && frame->is_local_exclusive)
>  			continue;
>  
> +		/* If hardware duplicate generation is enabled, only send out
> +		 * one port.
> +		 */
> +		if ((port->dev->features & NETIF_F_HW_HSR_DUP) && sent)
> +			continue;
> +

Is this right? It looks to me that you are not bypassing only duplicate
generation, but also duplicate elimination.

I think this is duplicate elimination:

		/* Don't send frame over port where it has been sent before.
		 * Also fro SAN, this shouldn't be done.
		 */
		if (!frame->is_from_san &&
		    hsr_register_frame_out(port, frame->node_src,
					   frame->sequence_nr))
			continue;

and this is duplicate generation:

	hsr_for_each_port(frame->port_rcv->hsr, port) {
		...
		skb->dev = port->dev;
		if (port->type == HSR_PT_MASTER)
			hsr_deliver_master(skb, port->dev, frame->node_src);
		else
			hsr_xmit(skb, port, frame);
	}

So if this is the description of NETIF_F_HW_HSR_DUP:

| Duplication involves the switch automatically sending a single frame
| from the CPU port to both redundant ports. This is required because the
| inserted HSR/PRP header/trailer must contain the same sequence number
| on the frames sent out both redundant ports.

then NETIF_F_HW_HSR_DUP is a misnomer. You should think of either
grouping duplicate elimination and generation together, or rethinking
the whole features system.

>  		/* Don't send frame over port where it has been sent before.
>  		 * Also fro SAN, this shouldn't be done.
>  		 */
> @@ -403,10 +420,12 @@ static void hsr_forward_do(struct hsr_frame_info *frame)
>  		}
>  
>  		skb->dev = port->dev;
> -		if (port->type == HSR_PT_MASTER)
> +		if (port->type == HSR_PT_MASTER) {
>  			hsr_deliver_master(skb, port->dev, frame->node_src);
> -		else
> -			hsr_xmit(skb, port, frame);
> +		} else {
> +			if (!hsr_xmit(skb, port, frame))
> +				sent = true;
> +		}
>  	}
>  }
>  
> @@ -457,6 +476,7 @@ void hsr_fill_frame_info(__be16 proto, struct sk_buff *skb,
>  	struct hsr_port *port = frame->port_rcv;
>  
>  	if (port->type != HSR_PT_MASTER &&
> +	    !(port->dev->features & NETIF_F_HW_HSR_TAG_RM) &&
>  	    (proto == htons(ETH_P_PRP) || proto == htons(ETH_P_HSR))) {
>  		/* HSR tagged frame :- Data or Supervision */
>  		frame->skb_std = NULL;
> @@ -478,6 +498,7 @@ void prp_fill_frame_info(__be16 proto, struct sk_buff *skb,
>  	struct hsr_port *port = frame->port_rcv;
>  
>  	if (port->type != HSR_PT_MASTER &&
> +	    !(port->dev->features & NETIF_F_HW_HSR_TAG_RM) &&
>  	    rct &&
>  	    prp_check_lsdu_size(skb, rct, frame->is_supervision)) {
>  		frame->skb_hsr = NULL;
> diff --git a/net/hsr/hsr_forward.h b/net/hsr/hsr_forward.h
> index 618140d484ad..b6acaafa83fc 100644
> --- a/net/hsr/hsr_forward.h
> +++ b/net/hsr/hsr_forward.h
> @@ -23,6 +23,7 @@ struct sk_buff *hsr_get_untagged_frame(struct hsr_frame_info *frame,
>  struct sk_buff *prp_get_untagged_frame(struct hsr_frame_info *frame,
>  				       struct hsr_port *port);
>  bool prp_drop_frame(struct hsr_frame_info *frame, struct hsr_port *port);
> +bool hsr_drop_frame(struct hsr_frame_info *frame, struct hsr_port *port);
>  void prp_fill_frame_info(__be16 proto, struct sk_buff *skb,
>  			 struct hsr_frame_info *frame);
>  void hsr_fill_frame_info(__be16 proto, struct sk_buff *skb,
> diff --git a/net/hsr/hsr_main.c b/net/hsr/hsr_main.c
> index 2fd1976e5b1c..0e7b5b18b5e3 100644
> --- a/net/hsr/hsr_main.c
> +++ b/net/hsr/hsr_main.c
> @@ -131,6 +131,20 @@ struct hsr_port *hsr_port_get_hsr(struct hsr_priv *hsr, enum hsr_port_type pt)
>  	return NULL;
>  }
>  
> +int hsr_get_version(struct net_device *dev, enum hsr_version *ver)
> +{
> +	struct hsr_priv *hsr;
> +
> +	if (!(dev->priv_flags & IFF_HSR))
> +		return -EINVAL;
> +
> +	hsr = netdev_priv(dev);
> +	*ver = hsr->prot_version;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(hsr_get_version);
> +
>  static struct notifier_block hsr_nb = {
>  	.notifier_call = hsr_netdev_notify,	/* Slave event notifications */
>  };
> diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
> index 7dc92ce5a134..7369b2febe0f 100644
> --- a/net/hsr/hsr_main.h
> +++ b/net/hsr/hsr_main.h
> @@ -13,6 +13,7 @@
>  #include <linux/netdevice.h>
>  #include <linux/list.h>
>  #include <linux/if_vlan.h>
> +#include <linux/if_hsr.h>
>  
>  /* Time constants as specified in the HSR specification (IEC-62439-3 2010)
>   * Table 8.
> @@ -171,13 +172,6 @@ struct hsr_port {
>  	enum hsr_port_type	type;
>  };
>  
> -/* used by driver internally to differentiate various protocols */
> -enum hsr_version {
> -	HSR_V0 = 0,
> -	HSR_V1,
> -	PRP_V1,
> -};
> -
>  struct hsr_frame_info;
>  struct hsr_node;
>  
> diff --git a/net/hsr/hsr_slave.c b/net/hsr/hsr_slave.c
> index 36d5fcf09c61..59f8d2b68376 100644
> --- a/net/hsr/hsr_slave.c
> +++ b/net/hsr/hsr_slave.c
> @@ -48,12 +48,14 @@ static rx_handler_result_t hsr_handle_frame(struct sk_buff **pskb)
>  		goto finish_consume;
>  	}
>  
> -	/* For HSR, only tagged frames are expected, but for PRP
> -	 * there could be non tagged frames as well from Single
> -	 * attached nodes (SANs).
> +	/* For HSR, only tagged frames are expected (unless the device offloads
> +	 * HSR tag removal), but for PRP there could be non tagged frames as
> +	 * well from Single attached nodes (SANs).
>  	 */
>  	protocol = eth_hdr(skb)->h_proto;
> -	if (hsr->proto_ops->invalid_dan_ingress_frame &&
> +
> +	if (!(port->dev->features & NETIF_F_HW_HSR_TAG_RM) &&
> +	    hsr->proto_ops->invalid_dan_ingress_frame &&
>  	    hsr->proto_ops->invalid_dan_ingress_frame(protocol))
>  		goto finish_pass;
>  
> @@ -137,6 +139,9 @@ static int hsr_portdev_setup(struct hsr_priv *hsr, struct net_device *dev,
>  	master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
>  	hsr_dev = master->dev;
>  
> +	dev->flags |= IFF_SLAVE;
> +	dev->priv_flags |= IFF_HSR;
> +
>  	res = netdev_upper_dev_link(dev, hsr_dev, extack);
>  	if (res)
>  		goto fail_upper_dev_link;
> -- 
> 2.11.0
> 
