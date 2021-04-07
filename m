Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A41D35601C
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 02:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347469AbhDGARN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 20:17:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37058 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347459AbhDGAQl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 20:16:41 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lTvrx-00FDZF-Oq; Wed, 07 Apr 2021 02:16:29 +0200
Date:   Wed, 7 Apr 2021 02:16:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] include: net: add dsa_cpu_ports function
Message-ID: <YGz53WOsrZ0lVfyL@lunn.ch>
References: <20210406034903.14329-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406034903.14329-1-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 05:49:03AM +0200, Ansuel Smith wrote:
> In preparation for the future when dsa will support multi cpu port,
> dsa_cpu_ports can be useful for switch that has multiple cpu port to
> retrieve the cpu mask for ACL and bridge table.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  include/net/dsa.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 83a933e563fe..d71b1acd9c3e 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -446,6 +446,18 @@ static inline u32 dsa_user_ports(struct dsa_switch *ds)
>  	return mask;
>  }
>  
> +static inline u32 dsa_cpu_ports(struct dsa_switch *ds)
> +{
> +	u32 mask = 0;
> +	int p;
> +
> +	for (p = 0; p < ds->num_ports; p++)
> +		if (dsa_is_cpu_port(ds, p))
> +			mask |= BIT(p);
> +
> +	return mask;
> +}

Hi Ansuel

We don't add a function unless it has a user. Please call it from somewhere.

   Andrew
