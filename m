Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC02536C32B
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 12:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235304AbhD0KXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 06:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235620AbhD0KXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 06:23:25 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796A0C061247
        for <netdev@vger.kernel.org>; Tue, 27 Apr 2021 03:17:50 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id g10so1322570edb.0
        for <netdev@vger.kernel.org>; Tue, 27 Apr 2021 03:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jS8mRrVLDbaMyDpr/LGOADIkfzJVPQFO2ymhmDViSxs=;
        b=SC93pnBiT+4OyRyZhIROJviKb++caWsXnBmTV1wQ3TZY6NhVBd3et/G1sQ3466kKlS
         vAQ+JgWSgaMdsbFZKGMNbUh+l96p3DbPA/WmAPgGgi/N01hmElZhWWo1XWB9GDFADatC
         elGzzyKuwK7ZTM030Aw91J4T4nk14zB/GxCDnoXma3eGbamlrTlfiKTzIeRIEK58x7Za
         0Z4Nm1Xuu0oiH3HQZiJniOr8oU+BEod+mP3BC41o0dWG1GOj6tyQAW/9qFp+kBpnRHgH
         IOT2w+kMPC39nE7DvPfoF8AHoAWN5o1BR3+iP0vataH6fDt2i0nznbLqBPqU1YPTv5+k
         fTgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jS8mRrVLDbaMyDpr/LGOADIkfzJVPQFO2ymhmDViSxs=;
        b=AFjAxBJw9qO73ar1jGlSzCQck46H+7f3TB84ivR8Oh5OWXKl69iTGEEMpR2D8NAXpr
         y1H6uKhlFVxrTNmHWk3Xfo7gIC7EaNpY/qM/bYIQKhSv4d9wLO9iHsbhsRpQe0506vPh
         PR4t7RgtbrtbCid7iC0wOxD6uziE3aOrLxGI+VhrwILSHEa1VDBQjxLxqUp+lURNf4A6
         VqatFWZCCG8xE3fCo8DXWHvG2TrNCUG/xlM0PuMhskupfenazJ0QcMoe2MCferl47a9f
         UG1/xLtFfDRkqu0fiRDzKmzhfpsJmcHNOJA0bvWU5DAvjp4XIYN0tvkaPvVtcoLyrOIL
         tJlg==
X-Gm-Message-State: AOAM5327HtBsphIyg8Ifu8hbMmGPfYMYiRBPQp8sbsV+oIcksBNHfFfH
        ijeWFulrgSIATzlIVe/iwM4=
X-Google-Smtp-Source: ABdhPJxjDMDMo8VcnQL2Lb0Y87IRi8VmuUXJgxrC2XEChV1z2EakDAQrLKfRhoUSxPxoMjtQYcjMQg==
X-Received: by 2002:aa7:cdcc:: with SMTP id h12mr3415621edw.273.1619518669191;
        Tue, 27 Apr 2021 03:17:49 -0700 (PDT)
Received: from skbuf ([86.127.41.210])
        by smtp.gmail.com with ESMTPSA id n21sm7583832ejx.74.2021.04.27.03.17.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 03:17:48 -0700 (PDT)
Date:   Tue, 27 Apr 2021 13:17:47 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, roopa@nvidia.com,
        nikolay@nvidia.com, jiri@resnulli.us, idosch@idosch.org,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [RFC net-next 6/9] net: dsa: Forward offloading
Message-ID: <20210427101747.n3y6w6o7thl5cz3r@skbuf>
References: <20210426170411.1789186-1-tobias@waldekranz.com>
 <20210426170411.1789186-7-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426170411.1789186-7-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 07:04:08PM +0200, Tobias Waldekranz wrote:
> Allow DSA drivers to support forward offloading from a bridge by:
> 
> - Passing calls to .ndo_dfwd_{add,del}_station to the drivers.
> 
> - Recording the subordinate device of offloaded skbs in the control
>   buffer so that the tagger can take the appropriate action.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  include/net/dsa.h |  7 +++++++
>  net/dsa/slave.c   | 36 ++++++++++++++++++++++++++++++++++--
>  2 files changed, 41 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 1f9ba9889034..77d4df819299 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -119,6 +119,7 @@ struct dsa_netdevice_ops {
>  
>  struct dsa_skb_cb {
>  	struct sk_buff *clone;
> +	struct net_device *sb_dev;
>  };
>  
>  struct __dsa_skb_cb {
> @@ -828,6 +829,12 @@ struct dsa_switch_ops {
>  					  const struct switchdev_obj_ring_role_mrp *mrp);
>  	int	(*port_mrp_del_ring_role)(struct dsa_switch *ds, int port,
>  					  const struct switchdev_obj_ring_role_mrp *mrp);
> +
> +	/* L2 forward offloading */
> +	void *	(*dfwd_add_station)(struct dsa_switch *ds, int port,
> +				    struct net_device *sb_dev);
> +	void	(*dfwd_del_station)(struct dsa_switch *ds, int port,
> +				    struct net_device *sb_dev);
>  };
>  
>  #define DSA_DEVLINK_PARAM_DRIVER(_id, _name, _type, _cmodes)		\
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 77b33bd161b8..3689ffa2dbb8 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -657,6 +657,13 @@ static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
>  	return dsa_enqueue_skb(nskb, dev);
>  }
>  
> +static u16 dsa_slave_select_queue(struct net_device *dev, struct sk_buff *skb,
> +				  struct net_device *sb_dev)
> +{
> +	DSA_SKB_CB(skb)->sb_dev = sb_dev;
> +	return netdev_pick_tx(dev, skb, sb_dev);
> +}
> +

DSA_SKB_CB is going away:
https://patchwork.kernel.org/project/netdevbpf/patch/20210427042203.26258-5-yangbo.lu@nxp.com/

Let's either negotiate with Yangbo on keeping it, or make
.ndo_select_queue a bypass towards the tagger, where it can use its own
SKB_CB structure and be more flexible in general (I think I'm leaning
towards the latter).
