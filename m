Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13D813687BB
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 22:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239136AbhDVUMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 16:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236822AbhDVUMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 16:12:06 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B8DC06174A;
        Thu, 22 Apr 2021 13:11:31 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id h15so14827337pfv.2;
        Thu, 22 Apr 2021 13:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=o1bdsgj0k+gS+FLRzDHxPgUt/k37rAe6KsVVfAMKkys=;
        b=YQvpfd2gPRnx3i3XOCLgf9rAzjVORicJKYWqqhW7IDO1uMdArB0IdSZkdSlkv1mDbx
         TzzZMD0cs7sQvrYJZym0dLgeEdpR6b1skkhbMPucLHPDUwNCS6nJhYAK0lHhMs54QUgo
         mn3qGXmWxIjrNqd0Ers78skj9W3RoNRABxTpyIhDvxGM+xspWYHnNCk/pDysjF7v97Ns
         qE18ub6htE+agJb2ynN1KS9/4s9NyCX/jOgpWjo1Bfk/uFejB1MXA2ViJANcO5e5qz6H
         GwNszhBjHsW3qRoEhaAMZO03qbFrnacCok8QNwYmmDz8oUEFrpS2Vsr09tEHSSfZeQT2
         16Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o1bdsgj0k+gS+FLRzDHxPgUt/k37rAe6KsVVfAMKkys=;
        b=GrwIvPzN0kp98SloqCb0GJKhHVkY+noHworz57dwKG1rN19vCl+rB5FiTN+V4lqhmr
         kN+0Q+g4twgNEDMB8c6029ONRJ6k4PEuxUXFL80XIRxovxHkqdLxTYlV4pwMQPnx/qzk
         lILi0qJjHChfdXF0xo4yc20UjPABGLJylRbdnibzldVtPI9WJJEciv1Xptuhp/HTKMvn
         atxl0uSW5lMRFvUGl/sG9eJQpe2GQ9J8nRvPbrtHeZ5V2ZUa45mVBgqKSsPqwRNcj+Af
         p7JVJGfFmBJo4WKYwV/eef0OF55+31GMURwwrGaELszyCO+ViZv5BaR5PqFo+64ZHwVU
         NLpA==
X-Gm-Message-State: AOAM532DEceKS3pQs7zQoBdH5ZuFERAcP8XT4FnGqvYAVI/vmHsIXXnk
        QreFYDLnLYF7dm7nRoo5XDk=
X-Google-Smtp-Source: ABdhPJzijbgo+xVg3DynbJ7EutAVeumAci0HONlG8uD8KHL6VawzsBPTEA/pXqrJOTI+BfkSp/W94w==
X-Received: by 2002:a63:4c4b:: with SMTP id m11mr356234pgl.245.1619122291035;
        Thu, 22 Apr 2021 13:11:31 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id i22sm3073060pgj.90.2021.04.22.13.11.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 13:11:30 -0700 (PDT)
Date:   Thu, 22 Apr 2021 23:11:19 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 net-next 7/9] net: dsa: microchip: add support for
 port mirror operations
Message-ID: <20210422201119.kalmeag53yun2j5x@skbuf>
References: <20210422094257.1641396-1-prasanna.vengateshan@microchip.com>
 <20210422094257.1641396-8-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210422094257.1641396-8-prasanna.vengateshan@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 03:12:55PM +0530, Prasanna Vengateshan wrote:
> Added support for port_mirror_add() and port_mirror_del operations
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> ---
>  drivers/net/dsa/microchip/lan937x_main.c | 50 ++++++++++++++++++++++++
>  1 file changed, 50 insertions(+)
> 
> diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
> index 573d2dd906f5..bfce5098ea69 100644
> --- a/drivers/net/dsa/microchip/lan937x_main.c
> +++ b/drivers/net/dsa/microchip/lan937x_main.c
> @@ -128,6 +128,54 @@ static void lan937x_port_stp_state_set(struct dsa_switch *ds, int port,
>  	mutex_unlock(&dev->dev_mutex);
>  }
>  
> +static int lan937x_port_mirror_add(struct dsa_switch *ds, int port,
> +				   struct dsa_mall_mirror_tc_entry *mirror,
> +				   bool ingress)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	int rc;
> +
> +	if (ingress)
> +		rc = lan937x_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_RX, true);
> +	else
> +		rc = lan937x_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_TX, true);
> +
> +	if (rc < 0)
> +		return rc;
> +
> +	rc = lan937x_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_SNIFFER, false);
> +	if (rc < 0)
> +		return rc;

This is odd, you shouldn't have to say 'the port which I'm sniffing is
not a sniffer'.

> +
> +	/* configure mirror port */
> +	rc = lan937x_port_cfg(dev, mirror->to_local_port, P_MIRROR_CTRL,
> +			      PORT_MIRROR_SNIFFER, true);
> +	if (rc < 0)
> +		return rc;
> +
> +	rc = lan937x_cfg(dev, S_MIRROR_CTRL, SW_MIRROR_RX_TX, false);
> +
> +	return rc;
> +}
> +
> +static void lan937x_port_mirror_del(struct dsa_switch *ds, int port,
> +				    struct dsa_mall_mirror_tc_entry *mirror)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	u8 data;
> +
> +	if (mirror->ingress)
> +		lan937x_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_RX, false);
> +	else
> +		lan937x_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_TX, false);
> +
> +	lan937x_pread8(dev, port, P_MIRROR_CTRL, &data);
> +
> +	if (!(data & (PORT_MIRROR_RX | PORT_MIRROR_TX)))
> +		lan937x_port_cfg(dev, mirror->to_local_port, P_MIRROR_CTRL,
> +				 PORT_MIRROR_SNIFFER, false);
> +}
> +

So let me understand. You have a PORT_MIRROR_SNIFFER setting per port.
Presumably the mirrored traffic inside the switch is sent to the ports
which have PORT_MIRROR_SNIFFER = true.
But this isn't the interpretation of the tc utility.

Instead, let's say you have the following sequence of commands:

tc filter add dev lan0 ingress matchall skip_sw action mirred egress mirror dev lan1
tc filter add dev lan2 ingress matchall skip_sw action mirred egress mirror dev lan3

What in your hardware configuration makes traffic from lan0 be mirrored
to lan1 but not to lan3?

>  static phy_interface_t lan937x_get_interface(struct ksz_device *dev, int port)
>  {
>  	phy_interface_t interface;
> @@ -396,6 +444,8 @@ const struct dsa_switch_ops lan937x_switch_ops = {
>  	.port_bridge_flags	= lan937x_port_bridge_flags,
>  	.port_stp_state_set	= lan937x_port_stp_state_set,
>  	.port_fast_age		= ksz_port_fast_age,
> +	.port_mirror_add	= lan937x_port_mirror_add,
> +	.port_mirror_del	= lan937x_port_mirror_del,
>  	.port_max_mtu		= lan937x_get_max_mtu,
>  	.port_change_mtu	= lan937x_change_mtu,
>  	.phylink_validate	= lan937x_phylink_validate,
> -- 
> 2.27.0
> 

