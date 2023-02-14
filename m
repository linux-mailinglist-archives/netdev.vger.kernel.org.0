Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C620D695D5A
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 09:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjBNImO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 03:42:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjBNImM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 03:42:12 -0500
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFBC023331
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 00:41:46 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 1A5123200392;
        Tue, 14 Feb 2023 03:41:41 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 14 Feb 2023 03:41:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1676364100; x=1676450500; bh=fnHb054GFMqKi8+w4HYFEpJf/7Zi
        Mm6KxHGQB5PopQg=; b=Sb+2pfp6evy8g/e1APISXs51LZwzNf4E0nUdDvGBPVsw
        fXY97QOI+sbNtD7MgECt5Gu8MbHfX478VtkiKtef4OXUepfBJ/7pzztgMMZoEDVt
        XeM/RXG+uS17kpE4i01Gxbslj+Ibmk7vCS1QHDfch5wvLqGcKLc3cQrFd/pmWdxI
        a2+vPmazEJTavwcwX3m5wyzOxEmfh1BHF9FfZSpLndeCrrJKwpOltTIVDhhqreQ3
        hUcGuihZGLSB1qZ/8s3fYJxvM/sEmU3N+tXomvXH8//HYtUfoCKenrldGAlWUKoe
        BUk2pIEW/+EFTdVnobC2bh3N60r/KdLi1P1jGwQIiA==
X-ME-Sender: <xms:REnrY_LSWwfQ5RAD5a1-wm8kg6Ww3ymkLSpoWiQ0AMHLLeTtBAErxg>
    <xme:REnrYzJZrDwBTleMPnlUvri-wSrAU0wrEDWKaC3FYSIXpI5sB9wk_lMuwb-h7Cg7z
    QYhkEFxgSFlJYs>
X-ME-Received: <xmr:REnrY3s-_ToeaIvhY5xE8jF72q_CKpYcSekWcNsNTzFzHBtdss7ToLQSjkPvGMXIdlr7qyth9JpqrSECGRs0WoZPHqQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudeivddguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvudefveekheeugeeftddvveefgfduieefudeifefgleekheegleegjeej
    geeghfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:REnrY4aIPSwa3RZ0uxBpnGEEjbmDahmfHF-97r3KlstDRKeeUfa5Jg>
    <xmx:REnrY2ZJp2oAeC61U_8QBBM8cInxNtkTB9vpNsXPmQ9URmqR0LYxPg>
    <xmx:REnrY8CAGlSzCtYJ7MghCDoj1xHZG50ii6NuJmCC0rfhkSDUNsnfPw>
    <xmx:REnrY9VUJ3iD-ynbMOc-kVplU8LZN4YiRUExU1ZviCERqFtmI-wySw>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Feb 2023 03:41:39 -0500 (EST)
Date:   Tue, 14 Feb 2023 10:41:36 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, jacob.e.keller@intel.com
Subject: Re: [patch net] devlink: change port event netdev notifier from
 per-net to global
Message-ID: <Y+tJQJqyEekxIYdE@shredder>
References: <20230206094151.2557264-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206094151.2557264-1-jiri@resnulli.us>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 10:41:51AM +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Currently only the network namespace of devlink instance is monitored
> for port events. If netdev is moved to a different namespace and then
> unregistered, NETDEV_PRE_UNINIT is missed which leads to trigger
> following WARN_ON in devl_port_unregister().
> WARN_ON(devlink_port->type != DEVLINK_PORT_TYPE_NOTSET);
> 
> Fix this by changing the netdev notifier from per-net to global so no
> event is missed.
> 
> Fixes: 02a68a47eade ("net: devlink: track netdev with devlink_port assigned")
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> ---
>  net/core/devlink.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 032d6d0a5ce6..909a10e4b0dd 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -9979,7 +9979,7 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
>  		goto err_xa_alloc;
>  
>  	devlink->netdevice_nb.notifier_call = devlink_netdevice_event;
> -	ret = register_netdevice_notifier_net(net, &devlink->netdevice_nb);
> +	ret = register_netdevice_notifier(&devlink->netdevice_nb);
>  	if (ret)
>  		goto err_register_netdevice_notifier;
>  
> @@ -10171,8 +10171,7 @@ void devlink_free(struct devlink *devlink)
>  	xa_destroy(&devlink->snapshot_ids);
>  	xa_destroy(&devlink->ports);
>  
> -	WARN_ON_ONCE(unregister_netdevice_notifier_net(devlink_net(devlink),
> -						       &devlink->netdevice_nb));
> +	WARN_ON_ONCE(unregister_netdevice_notifier(&devlink->netdevice_nb));
>  
>  	xa_erase(&devlinks, devlink->index);
>  
> @@ -10503,6 +10502,8 @@ static int devlink_netdevice_event(struct notifier_block *nb,
>  		break;
>  	case NETDEV_REGISTER:
>  	case NETDEV_CHANGENAME:
> +		if (devlink_net(devlink) != dev_net(netdev))
> +			return NOTIFY_OK;
>  		/* Set the netdev on top of previously set type. Note this
>  		 * event happens also during net namespace change so here
>  		 * we take into account netdev pointer appearing in this
> @@ -10512,6 +10513,8 @@ static int devlink_netdevice_event(struct notifier_block *nb,
>  					netdev);
>  		break;
>  	case NETDEV_UNREGISTER:
> +		if (devlink_net(devlink) != dev_net(netdev))
> +			return NOTIFY_OK;
>  		/* Clear netdev pointer, but not the type. This event happens
>  		 * also during net namespace change so we need to clear
>  		 * pointer to netdev that is going to another net namespace.

Since the notifier block is no longer registered per-netns it shouldn't
be moved to a different netns on reload. I'm testing the following diff
[1] against net-next (although it should be eventually submitted to
net).

[1]
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d9cdbc047b49..efbee940bb03 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2858,8 +2858,6 @@ int unregister_netdevice_notifier(struct notifier_block *nb);
 int register_netdevice_notifier_net(struct net *net, struct notifier_block *nb);
 int unregister_netdevice_notifier_net(struct net *net,
 				      struct notifier_block *nb);
-void move_netdevice_notifier_net(struct net *src_net, struct net *dst_net,
-				 struct notifier_block *nb);
 int register_netdevice_notifier_dev_net(struct net_device *dev,
 					struct notifier_block *nb,
 					struct netdev_net_notifier *nn);
diff --git a/net/core/dev.c b/net/core/dev.c
index 7307a0c15c9f..709b1a02820b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1870,14 +1870,6 @@ static void __move_netdevice_notifier_net(struct net *src_net,
 	__register_netdevice_notifier_net(dst_net, nb, true);
 }
 
-void move_netdevice_notifier_net(struct net *src_net, struct net *dst_net,
-				 struct notifier_block *nb)
-{
-	rtnl_lock();
-	__move_netdevice_notifier_net(src_net, dst_net, nb);
-	rtnl_unlock();
-}
-
 int register_netdevice_notifier_dev_net(struct net_device *dev,
 					struct notifier_block *nb,
 					struct netdev_net_notifier *nn)
diff --git a/net/devlink/dev.c b/net/devlink/dev.c
index ab4e0f3c4e3d..c879c3c78e18 100644
--- a/net/devlink/dev.c
+++ b/net/devlink/dev.c
@@ -343,8 +343,6 @@ static void devlink_reload_netns_change(struct devlink *devlink,
 	 * reload process so the notifications are generated separatelly.
 	 */
 	devlink_notify_unregister(devlink);
-	move_netdevice_notifier_net(curr_net, dest_net,
-				    &devlink->netdevice_nb);
 	write_pnet(&devlink->_net, dest_net);
 	devlink_notify_register(devlink);
 }
