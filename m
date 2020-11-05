Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59FFD2A789A
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 09:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729149AbgKEIME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 03:12:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725287AbgKEIMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 03:12:02 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F472C0613CF;
        Thu,  5 Nov 2020 00:12:01 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id a15so587673edy.1;
        Thu, 05 Nov 2020 00:12:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lIJ/NfoYGaY62kFbhdYxSBnChfzCT4l2UF0cAPvhbUg=;
        b=h0MygNY1Eqn6MZ5UYm5Xe05T1t/miHcjndLj7/xuhHOk4Oqt/x2W8NGdluE0IWsoCb
         OBtDSHGp4nAu4UYCoowoqMjVd5LtMEWO+WSl7u9AvGqwzDkpEkIeERe1+aTLaubebg1J
         hvCSMCHM5KIYwm/lTLinnhWkV2PwLfOJ6+FZhD8/S/JH3rfT5QJk/nCM4oM6lUImOGCR
         1zU+XLWX91TJ+L0S+qC0nZGUjyEVJeyh3zW1iH5tFQpckUhnswwfdBB1EgNy5rrUl7wX
         r4bWlBNSSX5/TjkyKmQ7AlpMSRdG67GUvNiIykxeMPQuvixdWL5HlK5bq5qGoKuUjnNS
         ZNig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lIJ/NfoYGaY62kFbhdYxSBnChfzCT4l2UF0cAPvhbUg=;
        b=sLAYdak+IM6J7crnX0svIycAHBEklxh6NZbXXKLnIHvbyFVteGbumb4nksuUDoTHI4
         Y1cHsT5FhwUb1owGBINjrhb8AWbLkueWFO9e+/BUTVG3dSaIMbhrKWACmOSg/cg/JbWX
         aXEj0nYI62qgs+hWsd9jInO+VbD15ymYY5rA5X56C4I6QDM8EeG3N/TwENJzr5WW2p8M
         BslZ+PG4oegph5E7bdEBIxCbiQQgma9SWMxUHVyU/u+FuHwGCctsvHlD+l1VJ4pM2nHx
         Oqk/DnOcnmpsfzCSIVYal8qNE+KpNuucLWX0ZW2LBHe3OGgfjdjv66TdPyzI85jPHtog
         j7eg==
X-Gm-Message-State: AOAM530E3Oe6V6SQjKJlsKWUSMvQpEUbkV6jbm05GXbomvd8er38y8Zm
        hh24ASm5z1DXW2sGrb9wtFM=
X-Google-Smtp-Source: ABdhPJyD9o6nGDeaX2ulmZ+ghiuMN4BxZ3RuGRfBO1LHekJrHdNvZOaXiXuM1xYiUFkDb8dz37N26w==
X-Received: by 2002:aa7:cacb:: with SMTP id l11mr1327778edt.332.1604563919740;
        Thu, 05 Nov 2020 00:11:59 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id y2sm257247edu.48.2020.11.05.00.11.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 00:11:59 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Thu, 5 Nov 2020 10:11:58 +0200
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Ioana Ciornei <ciorneiioana@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [RFC 6/9] staging: dpaa2-switch: add .ndo_start_xmit() callback
Message-ID: <20201105081158.5cusnoxpj4iasbzy@skbuf>
References: <20201104165720.2566399-1-ciorneiioana@gmail.com>
 <20201104165720.2566399-7-ciorneiioana@gmail.com>
 <20201104212700.sdf3sx2kjayicvkl@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104212700.sdf3sx2kjayicvkl@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 04, 2020 at 11:27:00PM +0200, Vladimir Oltean wrote:
> On Wed, Nov 04, 2020 at 06:57:17PM +0200, Ioana Ciornei wrote:
> > From: Ioana Ciornei <ioana.ciornei@nxp.com>
> > 
> > Implement the .ndo_start_xmit() callback for the switch port interfaces.
> > For each of the switch ports, gather the corresponding queue
> > destination ID (QDID) necessary for Tx enqueueing.
> > 
> > We'll reserve 64 bytes for software annotations, where we keep a skb
> > backpointer used on the Tx confirmation side for releasing the allocated
> > memory. At the moment, we only support linear skbs.
> > 
> > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > ---
> > @@ -554,8 +560,10 @@ static int dpaa2_switch_port_open(struct net_device *netdev)
> >  	struct ethsw_core *ethsw = port_priv->ethsw_data;
> >  	int err;
> >  
> > -	/* No need to allow Tx as control interface is disabled */
> > -	netif_tx_stop_all_queues(netdev);
> > +	if (!dpaa2_switch_has_ctrl_if(port_priv->ethsw_data)) {
> > +		/* No need to allow Tx as control interface is disabled */
> > +		netif_tx_stop_all_queues(netdev);
> 
> Personal taste probably, but you could remove the braces here.

Usually checkpatch complains about this kind of thing but not this time.
Maybe it takes into account the comment as well..

I'll remove the braces.

> 
> > +	}
> >  
> >  	/* Explicitly set carrier off, otherwise
> >  	 * netif_carrier_ok() will return true and cause 'ip link show'
> > @@ -610,15 +618,6 @@ static int dpaa2_switch_port_stop(struct net_device *netdev)
> >  	return 0;
> >  }
> >  
> > +static netdev_tx_t dpaa2_switch_port_tx(struct sk_buff *skb,
> > +					struct net_device *net_dev)
> > +{
> > +	struct ethsw_port_priv *port_priv = netdev_priv(net_dev);
> > +	struct ethsw_core *ethsw = port_priv->ethsw_data;
> > +	int retries = DPAA2_SWITCH_SWP_BUSY_RETRIES;
> > +	struct dpaa2_fd fd;
> > +	int err;
> > +
> > +	if (!dpaa2_switch_has_ctrl_if(ethsw))
> > +		goto err_free_skb;
> > +
> > +	if (unlikely(skb_headroom(skb) < DPAA2_SWITCH_NEEDED_HEADROOM)) {
> > +		struct sk_buff *ns;
> > +
> > +		ns = skb_realloc_headroom(skb, DPAA2_SWITCH_NEEDED_HEADROOM);
> 
> Looks like this passion for skb_realloc_headroom runs in the company?

Not really, ocelot and sja1105 are safe :)

> Few other drivers use it, and Claudiu just had a bug with that in gianfar.
> Luckily what saves you from the same bug is the skb_unshare from right below.
> Maybe you could use skb_cow_head and simplify this a bit?
> 
> > +		if (unlikely(!ns)) {
> > +			netdev_err(net_dev, "Error reallocating skb headroom\n");
> > +			goto err_free_skb;
> > +		}
> > +		dev_kfree_skb(skb);
> 
> Please use dev_consume_skb_any here, as it's not error path. Or, if you
> use skb_cow_head, only the skb data will be reallocated, not the skb
> structure itself, so there will be no consume_skb in that case at all,
> another reason to simplify.

Ok, I can try that.

How dpaa2-eth deals now with this is to just create a S/G FD when the
headroom is less than what's necessary, so no skb_realloc_headroom() or
skb_cow_head(). But I agree that it's best to make it as simple as
possible.

> 
> > +		skb = ns;
> > +	}
> > +
> > +	/* We'll be holding a back-reference to the skb until Tx confirmation */
> > +	skb = skb_unshare(skb, GFP_ATOMIC);
> > +	if (unlikely(!skb)) {
> > +		/* skb_unshare() has already freed the skb */
> > +		netdev_err(net_dev, "Error copying the socket buffer\n");
> > +		goto err_exit;
> > +	}
> > +
> > +	if (skb_is_nonlinear(skb)) {
> > +		netdev_err(net_dev, "No support for non-linear SKBs!\n");
> 
> Rate-limit maybe?

Yep, that probably should be rate-limited.

> And what is the reason for no non-linear skb's? Too much code to copy
> from dpaa2-eth?

Once this is out of staging, dpaa2-eth and dpaa2-switch could share
the Tx/Rx code path so, as you said, I just didn't want to duplicate
everything if it's not specifically needed.

> > diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
> > index bd24be2c6308..b267c04e2008 100644
> > --- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
> > +++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
> > @@ -66,6 +66,19 @@
> >   */
> >  #define DPAA2_SWITCH_SWP_BUSY_RETRIES		1000
> >  
> > +/* Hardware annotation buffer size */
> > +#define DPAA2_SWITCH_HWA_SIZE		64
> > +/* Software annotation buffer size */
> > +#define DPAA2_SWITCH_SWA_SIZE		64
> > +
> > +#define DPAA2_SWITCH_TX_BUF_ALIGN	64
> 
> Could you align all of these to the "1000" from DPAA2_SWITCH_SWP_BUSY_RETRIES?
> 

Sure.

> > +
> > +#define DPAA2_SWITCH_TX_DATA_OFFSET \
> > +	(DPAA2_SWITCH_HWA_SIZE + DPAA2_SWITCH_SWA_SIZE)
> > +
> > +#define DPAA2_SWITCH_NEEDED_HEADROOM \
> > +	(DPAA2_SWITCH_TX_DATA_OFFSET + DPAA2_SWITCH_TX_BUF_ALIGN)
> > +
> 
> Ironically, you create a definition for NEEDED_HEADROOM but you do not
> set dev->needed_headroom.
