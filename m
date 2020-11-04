Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351B82A6FA2
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 22:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731457AbgKDV1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 16:27:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727013AbgKDV1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 16:27:04 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A98C0613D3;
        Wed,  4 Nov 2020 13:27:03 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id e18so12875744edy.6;
        Wed, 04 Nov 2020 13:27:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vfE1IqRCYiE0CZMi79I4uPjwgehp8QRBufcR/qRCDgQ=;
        b=XDaAcHKSWp5sDDrnGOYjCpu17WwiapO2RKbQLCJ58sJdxA05v7/58f/GyCcMelB24b
         9nfldYWLQoWr25EsMHwJaVePrulE3I2ntD+5Cgjab95T9BvjGz5p9ebAWcBn1sQtXlUB
         t4m7MRRlfOOo7hGfYiXxNFEmgXWNKeCh+eDwxVa6Q9PmqtkQO98gcSw/Iuf7NsDANyCV
         sOqjcB4VGLKJ/Dcetdp0f8yt/FQpCOhOCsiTwGnErzwdreS7s8Fg4lYhGgJENLWiAWb8
         GzhYN5cKGGld/2meOCAT1oxUNbAlCGms/VAE+iL9rO4daHABB7gp6iGumi1CYibWMaYo
         qXYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vfE1IqRCYiE0CZMi79I4uPjwgehp8QRBufcR/qRCDgQ=;
        b=iLQjLOMVmcwlVSekNLwjtsav01caXrn1mrZBzSZHgT9evwPOz32UemT8T3g7e4ukkI
         lgJ9Dd8l9E4wGRpn8S2ji/WpcBRqemxPfThgww069cn41J9zC4XZXHybOREBkgjfES3k
         zd+yLz44imEUbEOCBY1l9e4dPYlc89yQqBNJwVr+v9rdCX0a5xalCgOnLK6HsEwS5tU/
         h4zQ7pj1ZXN8EJHYWDZN5l8iEihdA/FT6h9gGmxpK6b87ZQV00R+NOemZhkXOAZOON2T
         XgMrk7Cw9CVDBqQnqWXoD6NLYpdl5mMCaqTpmAegFlav1ruomrMTTruCWQ1qgu+bKeRi
         dtnw==
X-Gm-Message-State: AOAM531Zutmcp8Qw5eeqLSi22Jh7E3HemBdimYqUbsbxGV+Pa+gyZT2O
        qNXSeeUXMZwS+wlvBvuZe4Q=
X-Google-Smtp-Source: ABdhPJw2pYF2Xfkb/EhHCmTmQ6haQCTef+SHr0FoCczL6wDTp+WbScf5aop8Y50h83IZ1KDWwmA9eg==
X-Received: by 2002:aa7:d9ce:: with SMTP id v14mr29437492eds.203.1604525222483;
        Wed, 04 Nov 2020 13:27:02 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id q9sm1535196ejd.66.2020.11.04.13.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 13:27:02 -0800 (PST)
Date:   Wed, 4 Nov 2020 23:27:00 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [RFC 6/9] staging: dpaa2-switch: add .ndo_start_xmit() callback
Message-ID: <20201104212700.sdf3sx2kjayicvkl@skbuf>
References: <20201104165720.2566399-1-ciorneiioana@gmail.com>
 <20201104165720.2566399-7-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104165720.2566399-7-ciorneiioana@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 04, 2020 at 06:57:17PM +0200, Ioana Ciornei wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> Implement the .ndo_start_xmit() callback for the switch port interfaces.
> For each of the switch ports, gather the corresponding queue
> destination ID (QDID) necessary for Tx enqueueing.
> 
> We'll reserve 64 bytes for software annotations, where we keep a skb
> backpointer used on the Tx confirmation side for releasing the allocated
> memory. At the moment, we only support linear skbs.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
> @@ -554,8 +560,10 @@ static int dpaa2_switch_port_open(struct net_device *netdev)
>  	struct ethsw_core *ethsw = port_priv->ethsw_data;
>  	int err;
>  
> -	/* No need to allow Tx as control interface is disabled */
> -	netif_tx_stop_all_queues(netdev);
> +	if (!dpaa2_switch_has_ctrl_if(port_priv->ethsw_data)) {
> +		/* No need to allow Tx as control interface is disabled */
> +		netif_tx_stop_all_queues(netdev);

Personal taste probably, but you could remove the braces here.

> +	}
>  
>  	/* Explicitly set carrier off, otherwise
>  	 * netif_carrier_ok() will return true and cause 'ip link show'
> @@ -610,15 +618,6 @@ static int dpaa2_switch_port_stop(struct net_device *netdev)
>  	return 0;
>  }
>  
> +static netdev_tx_t dpaa2_switch_port_tx(struct sk_buff *skb,
> +					struct net_device *net_dev)
> +{
> +	struct ethsw_port_priv *port_priv = netdev_priv(net_dev);
> +	struct ethsw_core *ethsw = port_priv->ethsw_data;
> +	int retries = DPAA2_SWITCH_SWP_BUSY_RETRIES;
> +	struct dpaa2_fd fd;
> +	int err;
> +
> +	if (!dpaa2_switch_has_ctrl_if(ethsw))
> +		goto err_free_skb;
> +
> +	if (unlikely(skb_headroom(skb) < DPAA2_SWITCH_NEEDED_HEADROOM)) {
> +		struct sk_buff *ns;
> +
> +		ns = skb_realloc_headroom(skb, DPAA2_SWITCH_NEEDED_HEADROOM);

Looks like this passion for skb_realloc_headroom runs in the company?
Few other drivers use it, and Claudiu just had a bug with that in gianfar.
Luckily what saves you from the same bug is the skb_unshare from right below.
Maybe you could use skb_cow_head and simplify this a bit?

> +		if (unlikely(!ns)) {
> +			netdev_err(net_dev, "Error reallocating skb headroom\n");
> +			goto err_free_skb;
> +		}
> +		dev_kfree_skb(skb);

Please use dev_consume_skb_any here, as it's not error path. Or, if you
use skb_cow_head, only the skb data will be reallocated, not the skb
structure itself, so there will be no consume_skb in that case at all,
another reason to simplify.

> +		skb = ns;
> +	}
> +
> +	/* We'll be holding a back-reference to the skb until Tx confirmation */
> +	skb = skb_unshare(skb, GFP_ATOMIC);
> +	if (unlikely(!skb)) {
> +		/* skb_unshare() has already freed the skb */
> +		netdev_err(net_dev, "Error copying the socket buffer\n");
> +		goto err_exit;
> +	}
> +
> +	if (skb_is_nonlinear(skb)) {
> +		netdev_err(net_dev, "No support for non-linear SKBs!\n");

Rate-limit maybe?
And what is the reason for no non-linear skb's? Too much code to copy
from dpaa2-eth?

> +		goto err_free_skb;
> +	}
> +
> +	err = dpaa2_switch_build_single_fd(ethsw, skb, &fd);
> +	if (unlikely(err)) {
> +		netdev_err(net_dev, "ethsw_build_*_fd() %d\n", err);
> +		goto err_free_skb;
> +	}
> +
> +	do {
> +		err = dpaa2_io_service_enqueue_qd(NULL,
> +						  port_priv->tx_qdid,
> +						  8, 0, &fd);
> +		retries--;
> +	} while (err == -EBUSY && retries);
> +
> +	if (unlikely(err < 0)) {
> +		dpaa2_switch_free_fd(ethsw, &fd);
> +		goto err_exit;
> +	}
> +
> +	return NETDEV_TX_OK;
> +
> +err_free_skb:
> +	dev_kfree_skb(skb);
> +err_exit:
> +	return NETDEV_TX_OK;
> +}
> +
> diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
> index bd24be2c6308..b267c04e2008 100644
> --- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
> +++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
> @@ -66,6 +66,19 @@
>   */
>  #define DPAA2_SWITCH_SWP_BUSY_RETRIES		1000
>  
> +/* Hardware annotation buffer size */
> +#define DPAA2_SWITCH_HWA_SIZE		64
> +/* Software annotation buffer size */
> +#define DPAA2_SWITCH_SWA_SIZE		64
> +
> +#define DPAA2_SWITCH_TX_BUF_ALIGN	64

Could you align all of these to the "1000" from DPAA2_SWITCH_SWP_BUSY_RETRIES?

> +
> +#define DPAA2_SWITCH_TX_DATA_OFFSET \
> +	(DPAA2_SWITCH_HWA_SIZE + DPAA2_SWITCH_SWA_SIZE)
> +
> +#define DPAA2_SWITCH_NEEDED_HEADROOM \
> +	(DPAA2_SWITCH_TX_DATA_OFFSET + DPAA2_SWITCH_TX_BUF_ALIGN)
> +

Ironically, you create a definition for NEEDED_HEADROOM but you do not
set dev->needed_headroom.
