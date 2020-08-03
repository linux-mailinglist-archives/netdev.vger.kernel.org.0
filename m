Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95B423AE13
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 22:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgHCU1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 16:27:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40994 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgHCU1l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 16:27:41 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k2h3X-0086cf-8N; Mon, 03 Aug 2020 22:27:35 +0200
Date:   Mon, 3 Aug 2020 22:27:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 2/5] net: dsa: loop: Support 4K VLANs
Message-ID: <20200803202735.GB1919070@lunn.ch>
References: <20200803200354.45062-1-f.fainelli@gmail.com>
 <20200803200354.45062-3-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803200354.45062-3-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 03, 2020 at 01:03:51PM -0700, Florian Fainelli wrote:
> Allocate a 4K array of VLANs instead of limiting ourselves to just 5
> which is arbitrary.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/net/dsa/dsa_loop.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
> index 4a57238cdfd8..6e97b44c6f3f 100644
> --- a/drivers/net/dsa/dsa_loop.c
> +++ b/drivers/net/dsa/dsa_loop.c
> @@ -48,12 +48,10 @@ struct dsa_loop_port {
>  	u16 pvid;
>  };
>  
> -#define DSA_LOOP_VLANS	5
> -
>  struct dsa_loop_priv {
>  	struct mii_bus	*bus;
>  	unsigned int	port_base;
> -	struct dsa_loop_vlan vlans[DSA_LOOP_VLANS];
> +	struct dsa_loop_vlan vlans[VLAN_N_VID];
>  	struct net_device *netdev;
>  	struct dsa_loop_port ports[DSA_MAX_PORTS];

That is 4K x (2 x u16) = 16K RAM. I suppose for a test driver which is
never expected to be used in production, that is O.K.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
