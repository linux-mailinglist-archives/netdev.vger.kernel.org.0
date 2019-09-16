Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 601DBB3370
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 04:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbfIPCjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 22:39:17 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:46969 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726057AbfIPCjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 22:39:17 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 3331D2129D;
        Sun, 15 Sep 2019 22:39:15 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sun, 15 Sep 2019 22:39:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        mendozajonas.com; h=message-id:subject:from:to:cc:date
        :in-reply-to:references:content-type:mime-version
        :content-transfer-encoding; s=fm1; bh=6OpW8HhbwXo2Hu8BU/I+PUQwOL
        AKU3qwgteJ0dZGU8o=; b=IEINNKSgO8ShfY+A4d1BkHyLrBwA9OBy53JmyZKN7s
        n73E6XtYLolR3IinvnY5aqi9DSQgbnYtqz5vooqDHeutFkfUQEJhXM50cO+O7iQO
        1r9h2LEDH5aJS3ezGUMb/wmOteT0SRRt2HOi8uMsCMHcZz56rPYDsMKAfkfIHhuP
        d+G66OVk5O5hM4FTVs9yeaA8fdEtXfSPCN7wvIQ2t9eVoTXUBIBO9V/rOuq0PU2Y
        2h6cuKSjM3UzgZUdzas70bdtF96C4gGkPakteE5A0bB+j/+GWdejKUvbfEBeTJgY
        6e4ZSPIFtkutMsmMPsNfdf5vWgEWI3G2JH9mbn7qBmpw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=6OpW8HhbwXo2Hu8BU/I+PUQwOLAKU3qwgteJ0dZGU
        8o=; b=WzsJzHq8WWewUfKjmIcDQy9RodGsgZDWraYlrFH2hOm93T6P8VhemdQw2
        ZbgVccEupijtXIrlibI6nX0p+P39de9p06zT0Yj8uLKYwoZymgjDe79tSrWpWIKv
        OGF3ZWQhhsc3MsR52p30qiFuwXuK7OC2lYKRzP/96rZzcSphAnkujT22OFDvBl3n
        q/BQYjj6ef5rsVbUX8pCtBKjprfimCBUogiSxueUgcLfII2jYzM6UcgMYAjyCKSf
        GGTqll/SRT9MGgoulMG0GQBdpsGWxTWzVj+PU8EP+yymzXa2kxqMSluHUf7aJA4H
        XY2/nSJY+9FBjWsSf5W/nX6hHzi3g==
X-ME-Sender: <xms:0vV-XahDiBp_lIMZE2_IbMJvCBukrZKd6IVOAHVTQrnjP2yK7aHX6w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddvgdeivdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefurghmuhgv
    lhcuofgvnhguohiirgdqlfhonhgrshcuoehsrghmsehmvghnughoiigrjhhonhgrshdrtg
    homheqnecukfhppedujeegrdduvdejrdduieegrdegheenucfrrghrrghmpehmrghilhhf
    rhhomhepshgrmhesmhgvnhguohiirghjohhnrghsrdgtohhmnecuvehluhhsthgvrhfuih
    iivgeptd
X-ME-Proxy: <xmx:0vV-XdbkH6vMXjioTXH0Xh0FGix2YVyhyQk6FIZ8aWv8xIybEBQE9g>
    <xmx:0vV-XbW0BwcUWot_7z3FiIzeR_K9T76IfJ8j4jLYlmvBkmJO9-O49Q>
    <xmx:0vV-XWY6PwOGubhdKqUOiyVHcCQQiJFOA3OEdtdrkU3iN0LriU0nhQ>
    <xmx:0_V-XSj2Tix6C29ADYYCeAY837sL9-l-OfCYkj5c37WrykGZQZ-9rA>
Received: from Singularity (unknown [174.127.164.45])
        by mail.messagingengine.com (Postfix) with ESMTPA id D930DD60057;
        Sun, 15 Sep 2019 22:39:13 -0400 (EDT)
Message-ID: <eb370d3280327b512828adc62b64656e65b22745.camel@mendozajonas.com>
Subject: Re: [PATCH] net/ncsi: Disable global multicast filter
From:   Samuel Mendoza-Jonas <sam@mendozajonas.com>
To:     Vijay Khemka <vijaykhemka@fb.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "openbmc @ lists . ozlabs . org" <openbmc@lists.ozlabs.org>,
        joel@jms.id.au, linux-aspeed@lists.ozlabs.org, sdasari@fb.com,
        Christian Svensson <bluecmd@google.com>
Date:   Sun, 15 Sep 2019 19:39:13 -0700
In-Reply-To: <20190912190451.2362220-1-vijaykhemka@fb.com>
References: <20190912190451.2362220-1-vijaykhemka@fb.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-09-12 at 12:04 -0700, Vijay Khemka wrote:
> Disabling multicast filtering from NCSI if it is supported. As it
> should not filter any multicast packets. In current code, multicast
> filter is enabled and with an exception of optional field supported
> by device are disabled filtering.
> 
> Mainly I see if goal is to disable filtering for IPV6 packets then
> let
> it disabled for every other types as well. As we are seeing issues
> with
> LLDP not working with this enabled filtering. And there are other
> issues
> with IPV6.
> 
> By Disabling this multicast completely, it is working for both IPV6
> as
> well as LLDP.
> 
> Signed-off-by: Vijay Khemka <vijaykhemka@fb.com>

Hi Vijay,

There are definitely some current issues with multicast filtering and
IPv6 when behind NC-SI at the moment. It would be nice to make this
configurable instead of disabling the component wholesale but I don't
believe this actually *breaks* anyone's configuration. It would be nice
to see some Tested-By's from the OpenBMC people though.

I'll have a look at the multicast issues, CC'ing in Chris too who IIRC
was looking at similar issues for u-bmc in case he got further.

Acked-by: Samuel Mendoza-Jonas <sam@mendozajonas.com>

> ---
>  net/ncsi/internal.h    |  7 +--
>  net/ncsi/ncsi-manage.c | 98 +++++-----------------------------------
> --
>  2 files changed, 12 insertions(+), 93 deletions(-)
> 
> diff --git a/net/ncsi/internal.h b/net/ncsi/internal.h
> index 0b3f0673e1a2..ad3fd7f1da75 100644
> --- a/net/ncsi/internal.h
> +++ b/net/ncsi/internal.h
> @@ -264,9 +264,7 @@ enum {
>  	ncsi_dev_state_config_ev,
>  	ncsi_dev_state_config_sma,
>  	ncsi_dev_state_config_ebf,
> -#if IS_ENABLED(CONFIG_IPV6)
> -	ncsi_dev_state_config_egmf,
> -#endif
> +	ncsi_dev_state_config_dgmf,
>  	ncsi_dev_state_config_ecnt,
>  	ncsi_dev_state_config_ec,
>  	ncsi_dev_state_config_ae,
> @@ -295,9 +293,6 @@ struct ncsi_dev_priv {
>  #define NCSI_DEV_RESET		8            /* Reset state of
> NC          */
>  	unsigned int        gma_flag;        /* OEM GMA
> flag               */
>  	spinlock_t          lock;            /* Protect the NCSI
> device    */
> -#if IS_ENABLED(CONFIG_IPV6)
> -	unsigned int        inet6_addr_num;  /* Number of IPv6
> addresses   */
> -#endif
>  	unsigned int        package_probe_id;/* Current ID during
> probe    */
>  	unsigned int        package_num;     /* Number of
> packages         */
>  	struct list_head    packages;        /* List of
> packages           */
> diff --git a/net/ncsi/ncsi-manage.c b/net/ncsi/ncsi-manage.c
> index 755aab66dcab..bce8b443289d 100644
> --- a/net/ncsi/ncsi-manage.c
> +++ b/net/ncsi/ncsi-manage.c
> @@ -14,7 +14,6 @@
>  #include <net/sock.h>
>  #include <net/addrconf.h>
>  #include <net/ipv6.h>
> -#include <net/if_inet6.h>
>  #include <net/genetlink.h>
>  
>  #include "internal.h"
> @@ -978,9 +977,7 @@ static void ncsi_configure_channel(struct
> ncsi_dev_priv *ndp)
>  	case ncsi_dev_state_config_ev:
>  	case ncsi_dev_state_config_sma:
>  	case ncsi_dev_state_config_ebf:
> -#if IS_ENABLED(CONFIG_IPV6)
> -	case ncsi_dev_state_config_egmf:
> -#endif
> +	case ncsi_dev_state_config_dgmf:
>  	case ncsi_dev_state_config_ecnt:
>  	case ncsi_dev_state_config_ec:
>  	case ncsi_dev_state_config_ae:
> @@ -1033,23 +1030,23 @@ static void ncsi_configure_channel(struct
> ncsi_dev_priv *ndp)
>  		} else if (nd->state == ncsi_dev_state_config_ebf) {
>  			nca.type = NCSI_PKT_CMD_EBF;
>  			nca.dwords[0] = nc->caps[NCSI_CAP_BC].cap;
> -			if (ncsi_channel_is_tx(ndp, nc))
> +			/* if multicast global filtering is supported
> then
> +			 * disable it so that all multicast packet will
> be
> +			 * forwarded to management controller
> +			 */
> +			if (nc->caps[NCSI_CAP_GENERIC].cap &
> +			     NCSI_CAP_GENERIC_MC)
> +				nd->state = ncsi_dev_state_config_dgmf;
> +			else if (ncsi_channel_is_tx(ndp, nc))
>  				nd->state = ncsi_dev_state_config_ecnt;
>  			else
>  				nd->state = ncsi_dev_state_config_ec;
> -#if IS_ENABLED(CONFIG_IPV6)
> -			if (ndp->inet6_addr_num > 0 &&
> -			    (nc->caps[NCSI_CAP_GENERIC].cap &
> -			     NCSI_CAP_GENERIC_MC))
> -				nd->state = ncsi_dev_state_config_egmf;
> -		} else if (nd->state == ncsi_dev_state_config_egmf) {
> -			nca.type = NCSI_PKT_CMD_EGMF;
> -			nca.dwords[0] = nc->caps[NCSI_CAP_MC].cap;
> +		} else if (nd->state == ncsi_dev_state_config_dgmf) {
> +			nca.type = NCSI_PKT_CMD_DGMF;
>  			if (ncsi_channel_is_tx(ndp, nc))
>  				nd->state = ncsi_dev_state_config_ecnt;
>  			else
>  				nd->state = ncsi_dev_state_config_ec;
> -#endif /* CONFIG_IPV6 */
>  		} else if (nd->state == ncsi_dev_state_config_ecnt) {
>  			if (np->preferred_channel &&
>  			    nc != np->preferred_channel)
> @@ -1483,70 +1480,6 @@ int ncsi_process_next_channel(struct
> ncsi_dev_priv *ndp)
>  	return -ENODEV;
>  }
>  
> -#if IS_ENABLED(CONFIG_IPV6)
> -static int ncsi_inet6addr_event(struct notifier_block *this,
> -				unsigned long event, void *data)
> -{
> -	struct inet6_ifaddr *ifa = data;
> -	struct net_device *dev = ifa->idev->dev;
> -	struct ncsi_dev *nd = ncsi_find_dev(dev);
> -	struct ncsi_dev_priv *ndp = nd ? TO_NCSI_DEV_PRIV(nd) : NULL;
> -	struct ncsi_package *np;
> -	struct ncsi_channel *nc;
> -	struct ncsi_cmd_arg nca;
> -	bool action;
> -	int ret;
> -
> -	if (!ndp || (ipv6_addr_type(&ifa->addr) &
> -	    (IPV6_ADDR_LINKLOCAL | IPV6_ADDR_LOOPBACK)))
> -		return NOTIFY_OK;
> -
> -	switch (event) {
> -	case NETDEV_UP:
> -		action = (++ndp->inet6_addr_num) == 1;
> -		nca.type = NCSI_PKT_CMD_EGMF;
> -		break;
> -	case NETDEV_DOWN:
> -		action = (--ndp->inet6_addr_num == 0);
> -		nca.type = NCSI_PKT_CMD_DGMF;
> -		break;
> -	default:
> -		return NOTIFY_OK;
> -	}
> -
> -	/* We might not have active channel or packages. The IPv6
> -	 * required multicast will be enabled when active channel
> -	 * or packages are chosen.
> -	 */
> -	np = ndp->active_package;
> -	nc = ndp->active_channel;
> -	if (!action || !np || !nc)
> -		return NOTIFY_OK;
> -
> -	/* We needn't enable or disable it if the function isn't
> supported */
> -	if (!(nc->caps[NCSI_CAP_GENERIC].cap & NCSI_CAP_GENERIC_MC))
> -		return NOTIFY_OK;
> -
> -	nca.ndp = ndp;
> -	nca.req_flags = 0;
> -	nca.package = np->id;
> -	nca.channel = nc->id;
> -	nca.dwords[0] = nc->caps[NCSI_CAP_MC].cap;
> -	ret = ncsi_xmit_cmd(&nca);
> -	if (ret) {
> -		netdev_warn(dev, "Fail to %s global multicast filter
> (%d)\n",
> -			    (event == NETDEV_UP) ? "enable" :
> "disable", ret);
> -		return NOTIFY_DONE;
> -	}
> -
> -	return NOTIFY_OK;
> -}
> -
> -static struct notifier_block ncsi_inet6addr_notifier = {
> -	.notifier_call = ncsi_inet6addr_event,
> -};
> -#endif /* CONFIG_IPV6 */
> -
>  static int ncsi_kick_channels(struct ncsi_dev_priv *ndp)
>  {
>  	struct ncsi_dev *nd = &ndp->ndev;
> @@ -1725,11 +1658,6 @@ struct ncsi_dev *ncsi_register_dev(struct
> net_device *dev,
>  	}
>  
>  	spin_lock_irqsave(&ncsi_dev_lock, flags);
> -#if IS_ENABLED(CONFIG_IPV6)
> -	ndp->inet6_addr_num = 0;
> -	if (list_empty(&ncsi_dev_list))
> -		register_inet6addr_notifier(&ncsi_inet6addr_notifier);
> -#endif
>  	list_add_tail_rcu(&ndp->node, &ncsi_dev_list);
>  	spin_unlock_irqrestore(&ncsi_dev_lock, flags);
>  
> @@ -1896,10 +1824,6 @@ void ncsi_unregister_dev(struct ncsi_dev *nd)
>  
>  	spin_lock_irqsave(&ncsi_dev_lock, flags);
>  	list_del_rcu(&ndp->node);
> -#if IS_ENABLED(CONFIG_IPV6)
> -	if (list_empty(&ncsi_dev_list))
> -		unregister_inet6addr_notifier(&ncsi_inet6addr_notifier)
> ;
> -#endif
>  	spin_unlock_irqrestore(&ncsi_dev_lock, flags);
>  
>  	ncsi_unregister_netlink(nd->dev);

