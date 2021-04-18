Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69211363471
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 11:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbhDRJ2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 05:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhDRJ2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 05:28:03 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 469AAC06174A;
        Sun, 18 Apr 2021 02:27:34 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id j7so253792eds.8;
        Sun, 18 Apr 2021 02:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v/1M/L499hZyI5mn763mhocGrkehyzJ4CL0gqtMtDDM=;
        b=uT1F1EgjLkeQQbIEx9YANIteIS7ppt5WXtaUy+UwfYnJK4YLxRo3a4qCJ98WIUSviK
         O827UdpPE+1p8kZG23t0fZ61gNLMD6lJluDR56Fk860fl8sAwQitVenM+T0EGPfcligE
         /jOficIOYSPeJj2B02msKciWADzdJJdve6aCZAE7Y968cPpbZWEjmM6qndN4aS32WSz9
         pCtQJCW+HbCMnRT5XxlIitYc31w6hP9Lcv+E1zOEWftiU5vq+AXwcGpB031LEkei7yhJ
         cxIuv05ETQev6gvNYf2xmwv93GP4rRv3vxxMvBHK3DelmfigCqzn3eKM0wC7LczeCkBz
         0RBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v/1M/L499hZyI5mn763mhocGrkehyzJ4CL0gqtMtDDM=;
        b=Wgw4+47dzbQOMfRH9ceBTjRpNCNR1hlzUe2dO1atBnKEPL5H94yWvtJJjGMFQ3go0U
         q5ty65FneVfTU4p087ZI/XpJWWfRlGh19F9WEx8/JQQIRQlfYIDchEE6IZ/0CPjMa758
         9gaiVte2sJpt3IdWRQehm569t0Jel/BP8//kNipjPYgdT7TyriEnxd8voGOjNz/Ctjqh
         LliFjxwSv7zpimt6kKj9olUp0udLlV8U5fdoZ25dzdszHUqRAp9ngia93o6ovbzGl0Lc
         RM3VjAE1lL+tgVnepw1pZntrIqZQJ97jm5aSHRjTIabWjPnllwzp99kGnh6in6G7Id2P
         CxEw==
X-Gm-Message-State: AOAM5328k8GBP3k/rOt7bD+lOtuxvWw5FweP1Jk5n/90m1hg2p/Lwm0M
        UxEHLgQZn/PVYQLfRP22Uio=
X-Google-Smtp-Source: ABdhPJwqvWC4bfaorNhUzhlOa4VttbWivaZEbQjpBpQDhVq19wkotkNYZy3dKw+DDyRRTwehEDX2sg==
X-Received: by 2002:a05:6402:1685:: with SMTP id a5mr19523633edv.185.1618738052983;
        Sun, 18 Apr 2021 02:27:32 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id n12sm3476887edw.95.2021.04.18.02.27.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 02:27:32 -0700 (PDT)
Date:   Sun, 18 Apr 2021 12:27:31 +0300
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
Subject: Re: [net-next 2/3] net: mscc: ocelot: convert to
 ocelot_port_txtstamp_request()
Message-ID: <20210418092731.jmuio2terv2spa3h@skbuf>
References: <20210416123655.42783-1-yangbo.lu@nxp.com>
 <20210416123655.42783-3-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210416123655.42783-3-yangbo.lu@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 08:36:54PM +0800, Yangbo Lu wrote:
> Convert to a common ocelot_port_txtstamp_request() for TX timestamp
> request handling.
> 
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> ---
>  drivers/net/dsa/ocelot/felix.c         | 14 +++++---------
>  drivers/net/ethernet/mscc/ocelot.c     | 24 +++++++++++++++++++++---
>  drivers/net/ethernet/mscc/ocelot_net.c | 18 +++++++-----------
>  include/soc/mscc/ocelot.h              |  5 +++--
>  4 files changed, 36 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
> index cdec2f5e271c..5f2cf0f31253 100644
> --- a/drivers/net/dsa/ocelot/felix.c
> +++ b/drivers/net/dsa/ocelot/felix.c
> @@ -1399,18 +1399,14 @@ static bool felix_txtstamp(struct dsa_switch *ds, int port,
>  			   struct sk_buff *skb, struct sk_buff **clone)
>  {
>  	struct ocelot *ocelot = ds->priv;
> -	struct ocelot_port *ocelot_port = ocelot->ports[port];
>  
> -	if (ocelot->ptp && ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
> -		*clone = skb_clone_sk(skb);
> -		if (!(*clone))
> -			return false;
> +	if (!ocelot->ptp)
> +		return false;
>  
> -		ocelot_port_add_txtstamp_skb(ocelot, port, *clone);
> -		return true;
> -	}
> +	if (ocelot_port_txtstamp_request(ocelot, port, skb, clone))
> +		return false;
>  
> -	return false;
> +	return true;

Considering the changes you'll have to make to patch 1 (changing the
return value and populating DSA_SKB_CB(skb)->clone at the end of this
function:

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
