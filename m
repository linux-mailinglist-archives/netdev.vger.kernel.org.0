Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B5A481D1E
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 15:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240319AbhL3Oes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 09:34:48 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:34805 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236320AbhL3Oes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 09:34:48 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 8EDFE58022D;
        Thu, 30 Dec 2021 09:34:47 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 30 Dec 2021 09:34:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=yzlgB8
        XIOvQXiHtWWQJs75kHAHk6VoEHY/ppAUEJ+o8=; b=g/Vw3DIK2mDMn9+0umfE0p
        UkvdAzZl6NGoFtihiBo825vbM50CPaiX6dlHVbFFk9gLwaVviNgJekLWZmrGJuXo
        uneE269GyNISGDgpGD8HrncaYyqWz4+O+rPrlOeFHac0zPtbfee/nmD7xMf5iMSC
        8jg44a9NkjU6edhGzv3v41iMIrTICU/CXSrsXY+wTePINj3NfnAh79JM1pvwtDfp
        SQuXo6YzHBMoexXYjbSJieIsXmUXccZyTX6e33o1BpL6IvkVQvZneovBkTcdpMe3
        1NXu9jkgQJOoPYwAZEWyXLgEdDtN5wLxO+hd/mDs+dc4N3UWSCLNga8XNLVKwsDA
        ==
X-ME-Sender: <xms:h8PNYSZkfED9gPpLp3m7BtiiS3Ia93OnzcU3I1mey5FE54teNLyqlQ>
    <xme:h8PNYVbk7sWS-i_D2q_zGTSpEGz4buI2RAjmqE74Aus5rMh3mDLlITezLR5E-eTTR
    VMFVOZfp7xDIoc>
X-ME-Received: <xmr:h8PNYc_UhPIBO72fCM13a8ojyTB0l9BFwPXV-gyHtnbLxu2o6lE5XQH-rBLIQ7E0ghh3tL8sjNqZ4f0ZZrZwrYDzqHQECg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddruddvfedgieejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:h8PNYUoCeI8snbNt6KAFYuljT2KuRkPA3FtOVJpfKUHRxjdqLdlZMA>
    <xmx:h8PNYdo5o2zgWMhciV2vtDLjyWAVzXdD9kdlU7eAZXYhnG6IPIDCnQ>
    <xmx:h8PNYSQaWMl6sn1RY84A0vlXwHpsmocOhnBiix1ZhmOzRKv7ANGV5A>
    <xmx:h8PNYaj2E2MjHWo6nKvcTlJApfV2k1_drrBchKp94qwUM1A1jv5qzA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 30 Dec 2021 09:34:46 -0500 (EST)
Date:   Thu, 30 Dec 2021 16:34:42 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Yevhen Orlov <yevhen.orlov@plvision.eu>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org, andrew@lunn.ch,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 5/6] net: marvell: prestera: Register
 inetaddr stub notifiers
Message-ID: <Yc3DgqvTqHANUQcp@shredder>
References: <20211227215233.31220-1-yevhen.orlov@plvision.eu>
 <20211227215233.31220-6-yevhen.orlov@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211227215233.31220-6-yevhen.orlov@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 27, 2021 at 11:52:30PM +0200, Yevhen Orlov wrote:
> Initial implementation of notification handlers. For now this is just
> stub.
> So that we can move forward and add prestera_router_hw's objects
> manipulations.
> 
> We support several addresses on interface. We just have nothing to do for
> second address, because rif is already enabled on this interface, after
> first one.
> 
> Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
> Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
> Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
> ---
> v1-->v2
> * Update commit message: explanation about addresses on rif
> ---
>  .../net/ethernet/marvell/prestera/prestera.h  |   4 +
>  .../ethernet/marvell/prestera/prestera_main.c |   2 +-
>  .../marvell/prestera/prestera_router.c        | 105 ++++++++++++++++++
>  3 files changed, 110 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
> index 7160da678457..a0a5a8e6bd8c 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera.h
> +++ b/drivers/net/ethernet/marvell/prestera/prestera.h
> @@ -281,6 +281,8 @@ struct prestera_router {
>  	struct prestera_switch *sw;
>  	struct list_head vr_list;
>  	struct list_head rif_entry_list;
> +	struct notifier_block inetaddr_nb;
> +	struct notifier_block inetaddr_valid_nb;
>  	bool aborted;
>  };
>  
> @@ -328,6 +330,8 @@ int prestera_port_pvid_set(struct prestera_port *port, u16 vid);
>  
>  bool prestera_netdev_check(const struct net_device *dev);
>  
> +int prestera_is_valid_mac_addr(struct prestera_port *port, const u8 *addr);
> +
>  bool prestera_port_is_lag_member(const struct prestera_port *port);
>  
>  struct prestera_lag *prestera_lag_by_id(struct prestera_switch *sw, u16 id);
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
> index 242904fcd866..5e45a4cda8cc 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
> @@ -159,7 +159,7 @@ static netdev_tx_t prestera_port_xmit(struct sk_buff *skb,
>  	return prestera_rxtx_xmit(netdev_priv(dev), skb);
>  }
>  
> -static int prestera_is_valid_mac_addr(struct prestera_port *port, u8 *addr)
> +int prestera_is_valid_mac_addr(struct prestera_port *port, const u8 *addr)
>  {
>  	if (!is_valid_ether_addr(addr))
>  		return -EADDRNOTAVAIL;
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
> index 2a32831df40f..0eb5f5e00e4e 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
> @@ -3,10 +3,98 @@
>  
>  #include <linux/kernel.h>
>  #include <linux/types.h>
> +#include <linux/inetdevice.h>
>  
>  #include "prestera.h"
>  #include "prestera_router_hw.h"
>  
> +static int __prestera_inetaddr_port_event(struct net_device *port_dev,
> +					  unsigned long event,
> +					  struct netlink_ext_ack *extack)
> +{
> +	struct prestera_port *port = netdev_priv(port_dev);
> +	int err;
> +
> +	err = prestera_is_valid_mac_addr(port, port_dev->dev_addr);
> +	if (err) {
> +		NL_SET_ERR_MSG_MOD(extack, "RIF MAC must have the same prefix");
> +		return err;
> +	}
> +
> +	switch (event) {
> +	case NETDEV_UP:
> +	case NETDEV_DOWN:
> +		break;
> +	}

If you are only implementing these in the next patch, then add these
then

> +
> +	return 0;
> +}
> +
> +static int __prestera_inetaddr_event(struct prestera_switch *sw,
> +				     struct net_device *dev,
> +				     unsigned long event,
> +				     struct netlink_ext_ack *extack)
> +{
> +	if (prestera_netdev_check(dev) && !netif_is_bridge_port(dev) &&
> +	    !netif_is_lag_port(dev) && !netif_is_ovs_port(dev))

Your netdev notifier doesn't allow linking to an OVS bridge, so I'm not
sure what is the purpose of this check

Also, better use early return

What happens to that RIF when the port is linked to a bridge or unlinked
from one?

> +		return __prestera_inetaddr_port_event(dev, event, extack);
> +
> +	return 0;
> +}
> +
> +static int __prestera_inetaddr_cb(struct notifier_block *nb,
> +				  unsigned long event, void *ptr)
> +{
> +	struct in_ifaddr *ifa = (struct in_ifaddr *)ptr;
> +	struct net_device *dev = ifa->ifa_dev->dev;
> +	struct prestera_router *router = container_of(nb,
> +						      struct prestera_router,
> +						      inetaddr_nb);
> +	struct in_device *idev;
> +	int err = 0;
> +
> +	if (event != NETDEV_DOWN)
> +		goto out;
> +
> +	/* Ignore if this is not latest address */
> +	idev = __in_dev_get_rtnl(dev);
> +	if (idev && idev->ifa_list)
> +		goto out;
> +
> +	err = __prestera_inetaddr_event(router->sw, dev, event, NULL);
> +out:
> +	return notifier_from_errno(err);
> +}
> +
> +static int __prestera_inetaddr_valid_cb(struct notifier_block *nb,
> +					unsigned long event, void *ptr)
> +{
> +	struct in_validator_info *ivi = (struct in_validator_info *)ptr;
> +	struct net_device *dev = ivi->ivi_dev->dev;
> +	struct prestera_router *router = container_of(nb,
> +						      struct prestera_router,
> +						      inetaddr_valid_nb);
> +	struct in_device *idev;
> +	int err = 0;
> +
> +	if (event != NETDEV_UP)
> +		goto out;
> +
> +	/* Ignore if this is not first address */
> +	idev = __in_dev_get_rtnl(dev);
> +	if (idev && idev->ifa_list)
> +		goto out;
> +
> +	if (ipv4_is_multicast(ivi->ivi_addr)) {
> +		err = -EINVAL;

Use extack

> +		goto out;
> +	}
> +
> +	err = __prestera_inetaddr_event(router->sw, dev, event, ivi->extack);
> +out:
> +	return notifier_from_errno(err);
> +}
> +
>  int prestera_router_init(struct prestera_switch *sw)
>  {
>  	struct prestera_router *router;
> @@ -23,8 +111,22 @@ int prestera_router_init(struct prestera_switch *sw)
>  	if (err)
>  		goto err_router_lib_init;
>  
> +	router->inetaddr_valid_nb.notifier_call = __prestera_inetaddr_valid_cb;
> +	err = register_inetaddr_validator_notifier(&router->inetaddr_valid_nb);
> +	if (err)
> +		goto err_register_inetaddr_validator_notifier;
> +
> +	router->inetaddr_nb.notifier_call = __prestera_inetaddr_cb;
> +	err = register_inetaddr_notifier(&router->inetaddr_nb);
> +	if (err)
> +		goto err_register_inetaddr_notifier;
> +
>  	return 0;
>  
> +err_register_inetaddr_notifier:
> +	unregister_inetaddr_validator_notifier(&router->inetaddr_valid_nb);
> +err_register_inetaddr_validator_notifier:
> +	/* prestera_router_hw_fini */

Just create this function

>  err_router_lib_init:
>  	kfree(sw->router);
>  	return err;
> @@ -32,6 +134,9 @@ int prestera_router_init(struct prestera_switch *sw)
>  
>  void prestera_router_fini(struct prestera_switch *sw)
>  {
> +	unregister_inetaddr_notifier(&sw->router->inetaddr_nb);
> +	unregister_inetaddr_validator_notifier(&sw->router->inetaddr_valid_nb);
> +	/* router_hw_fini */

Likewise

>  	kfree(sw->router);
>  	sw->router = NULL;
>  }
> -- 
> 2.17.1
> 
