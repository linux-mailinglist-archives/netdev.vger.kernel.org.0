Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC78961E366
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 17:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbiKFQY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 11:24:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiKFQY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 11:24:26 -0500
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7CB3640F;
        Sun,  6 Nov 2022 08:24:25 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 29539320069B;
        Sun,  6 Nov 2022 11:24:21 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 06 Nov 2022 11:24:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1667751860; x=1667838260; bh=X5pQ4r+k2kEYG5/TFIF1oqBuQuZp
        cws5RpLX4N1nD+w=; b=OzxoD/dI5Q3YlOu7PHmRpU9ZvqSaKdfs6IS5TUFcRtDy
        TzVO398h/5yu4HradbUHrD3mgO9CBDZw9U97co6VZSnvAblwq7YBoKvpgahhvs6z
        xDstaChr3Jb7HU3Ebtz+2hRZzZN3xvEcAnjAdVnCKcoI0Xa4vr4D3jr/WNjgZoji
        B+cUb1DR55Ir91aZjr6uYSurjyO3e3J2sbM+tKF4E8wYTN+Mr1e7n1qnnjahGJGu
        OCIQnR+eRiYLPUZQF1R+7il/c0KL0FiPKg9vR6D9TmQZ3fe9rQ9BJYT+poDgF0a4
        qOIHJbpJA9/vyMVkF4UDnHTNPXCRuLFu/dbu59FxFw==
X-ME-Sender: <xms:s99nY9kBaOxNkWkivKi3jdenPaH-8GrF-7oLW9pX39-vmiMlaSjMvA>
    <xme:s99nY43b80ND-fcitns0afkz9xzfTBUF6ei8aTW9dr8w_FnMkiXlODlzODfC0I13m
    TxuRlI8n67hQnA>
X-ME-Received: <xmr:s99nYzqBcamJICH4lfJ-WfsbnfK9AwKXvA61Sljw5xkqq5k2ddhI8FxGbhIG>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrvdeigdekudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeehhfdtjedviefffeduuddvffegteeiieeguefgudffvdfftdefheeijedthfej
    keenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:s99nY9mNydGfvpkHlb7S-OQzkX5gqhmYsM9EnGxC2ao5PhbRAzgHlw>
    <xmx:s99nY70fkpbD2Jv8tPmg1i4LEpdxBNU1hJvLFK8mX9rlFKMQYQ5V0Q>
    <xmx:s99nY8vt3Q3sjIv8hJHWIEUX7BjNpaKgp9zCy5NRAEue4Vk7ODgJgw>
    <xmx:tN9nY1NI3dWkewMG6t2FYRW0_YkoMFkK1HqyaXAvfJGC19XuuyxnVg>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 6 Nov 2022 11:24:18 -0500 (EST)
Date:   Sun, 6 Nov 2022 18:24:16 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Andy Ren <andy.ren@getcruise.com>
Cc:     netdev@vger.kernel.org, richardbgobert@gmail.com,
        davem@davemloft.net, wsa+renesas@sang-engineering.com,
        edumazet@google.com, petrm@nvidia.com, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, andrew@lunn.ch,
        dsahern@gmail.com, sthemmin@microsoft.com,
        sridhar.samudrala@intel.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, roman.gushchin@linux.dev
Subject: Re: [PATCH net-next v2] net/core: Allow live renaming when an
 interface is up
Message-ID: <Y2ffsF0Q4uLsS0+Z@shredder>
References: <20221104175434.458177-1-andy.ren@getcruise.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104175434.458177-1-andy.ren@getcruise.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 04, 2022 at 10:54:34AM -0700, Andy Ren wrote:
> We should allow a network interface to be renamed when the interface
> is up.

The motivation for this change (netconsole) is missing. I suggest:

"
As explained in the netconsole documentation [1], when netconsole is
used as a built-in it will bring up the specified interface as soon as
possible. As a result, user space will not be able to rename the
interface since the kernel disallows renaming of interfaces that are
administratively up unless the 'IFF_LIVE_RENAME_OK' private flag was set
by the kernel.

The original solution [2] to this problem was to augment the netconsole
configuration parameters with a new parameter that allows renaming of
the interface used by netconsole while it is administratively up.
However, during the discussion that followed it became apparent that we
have no reason to keep the current restriction and instead we should
allow user space to rename interfaces regardless of their administrative
state:

1. The restriction was put in place over 20 years ago when renaming was
only possible via IOCTL and before rtnetlink started notifying user
space about such changes like it does today.

2. The 'IFF_LIVE_RENAME_OK' flag was added over 3 years ago in version
5.2 and no regressions were reported.

3. In-kernel listeners to 'NETDEV_CHANGENAME' do not seem to care about
the administrative state of interface.

Therefore, allow user space to rename running interfaces by removing the
restriction and the associated 'IFF_LIVE_RENAME_OK' flag. Help in
possible triage by emitting a message to the kernel log that an
interface was renamed while running.

[1] https://www.kernel.org/doc/Documentation/networking/netconsole.rst
[2] https://lore.kernel.org/netdev/20221102002420.2613004-1-andy.ren@getcruise.com/
"

> 
> Live renaming was added as a failover in the past, and there has been no
> arising issues of the user space breaking. Furthermore, it seems that this
> flag was added because in the past, IOCTL was used for renaming, which
> would not notify the user space. Nowadays, it appears that the user
> space receives notifications regardless of the state of the network
> device (e.g. rtnetlink_event()). The listeners for NETDEV_CHANGENAME
> also do not strictly ensure that the netdev is up or not.
> 
> Hence, we should remove the live renaming flag and checks due
> to the aforementioned reasons.
> 
> The changes are as the following:
> - Remove IFF_LIVE_RENAME_OK flag declarations
> - Remove check in dev_change_name that checks whether device is up and
> if IFF_LIVE_RENAME_OK is set by the network device's priv_flags
> - Remove references of IFF_LIVE_RENAME_OK in the failover module
> 
> Changes from v1->v2
> - Added placeholder comment in place of removed IFF_LIVE_RENAME_OK flag
> - Added extra logging hints to indicate whether a network interface was
> renamed while UP

I believe that nowadays the recommendation is to put the changelog under
the "---" (or just use git-notes) since patches are applied with a
"Link:" to lore.

The code itself looks fine to me.

Thanks

> 
> Signed-off-by: Andy Ren <andy.ren@getcruise.com>
> ---
>  include/linux/netdevice.h |  4 +---
>  net/core/dev.c            | 19 ++-----------------
>  net/core/failover.c       |  6 +++---
>  3 files changed, 6 insertions(+), 23 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index d45713a06568..4be87b89e481 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1650,7 +1650,6 @@ struct net_device_ops {
>   * @IFF_FAILOVER: device is a failover master device
>   * @IFF_FAILOVER_SLAVE: device is lower dev of a failover master device
>   * @IFF_L3MDEV_RX_HANDLER: only invoke the rx handler of L3 master device
> - * @IFF_LIVE_RENAME_OK: rename is allowed while device is up and running
>   * @IFF_TX_SKB_NO_LINEAR: device/driver is capable of xmitting frames with
>   *	skb_headlen(skb) == 0 (data starts from frag0)
>   * @IFF_CHANGE_PROTO_DOWN: device supports setting carrier via IFLA_PROTO_DOWN
> @@ -1686,7 +1685,7 @@ enum netdev_priv_flags {
>  	IFF_FAILOVER			= 1<<27,
>  	IFF_FAILOVER_SLAVE		= 1<<28,
>  	IFF_L3MDEV_RX_HANDLER		= 1<<29,
> -	IFF_LIVE_RENAME_OK		= 1<<30,
> +	/* was IFF_LIVE_RENAME_OK */
>  	IFF_TX_SKB_NO_LINEAR		= BIT_ULL(31),
>  	IFF_CHANGE_PROTO_DOWN		= BIT_ULL(32),
>  };
> @@ -1721,7 +1720,6 @@ enum netdev_priv_flags {
>  #define IFF_FAILOVER			IFF_FAILOVER
>  #define IFF_FAILOVER_SLAVE		IFF_FAILOVER_SLAVE
>  #define IFF_L3MDEV_RX_HANDLER		IFF_L3MDEV_RX_HANDLER
> -#define IFF_LIVE_RENAME_OK		IFF_LIVE_RENAME_OK
>  #define IFF_TX_SKB_NO_LINEAR		IFF_TX_SKB_NO_LINEAR
>  
>  /* Specifies the type of the struct net_device::ml_priv pointer */
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 3bacee3bee78..707de6b841d0 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -1163,22 +1163,6 @@ int dev_change_name(struct net_device *dev, const char *newname)
>  
>  	net = dev_net(dev);
>  
> -	/* Some auto-enslaved devices e.g. failover slaves are
> -	 * special, as userspace might rename the device after
> -	 * the interface had been brought up and running since
> -	 * the point kernel initiated auto-enslavement. Allow
> -	 * live name change even when these slave devices are
> -	 * up and running.
> -	 *
> -	 * Typically, users of these auto-enslaving devices
> -	 * don't actually care about slave name change, as
> -	 * they are supposed to operate on master interface
> -	 * directly.
> -	 */
> -	if (dev->flags & IFF_UP &&
> -	    likely(!(dev->priv_flags & IFF_LIVE_RENAME_OK)))
> -		return -EBUSY;
> -
>  	down_write(&devnet_rename_sem);
>  
>  	if (strncmp(newname, dev->name, IFNAMSIZ) == 0) {
> @@ -1195,7 +1179,8 @@ int dev_change_name(struct net_device *dev, const char *newname)
>  	}
>  
>  	if (oldname[0] && !strchr(oldname, '%'))
> -		netdev_info(dev, "renamed from %s\n", oldname);
> +		netdev_info(dev, "renamed from %s%s\n", oldname,
> +			    dev->flags & IFF_UP ? " (while UP)" : "");
>  
>  	old_assign_type = dev->name_assign_type;
>  	dev->name_assign_type = NET_NAME_RENAMED;
> diff --git a/net/core/failover.c b/net/core/failover.c
> index 864d2d83eff4..655411c4ca51 100644
> --- a/net/core/failover.c
> +++ b/net/core/failover.c
> @@ -80,14 +80,14 @@ static int failover_slave_register(struct net_device *slave_dev)
>  		goto err_upper_link;
>  	}
>  
> -	slave_dev->priv_flags |= (IFF_FAILOVER_SLAVE | IFF_LIVE_RENAME_OK);
> +	slave_dev->priv_flags |= IFF_FAILOVER_SLAVE;
>  
>  	if (fops && fops->slave_register &&
>  	    !fops->slave_register(slave_dev, failover_dev))
>  		return NOTIFY_OK;
>  
>  	netdev_upper_dev_unlink(slave_dev, failover_dev);
> -	slave_dev->priv_flags &= ~(IFF_FAILOVER_SLAVE | IFF_LIVE_RENAME_OK);
> +	slave_dev->priv_flags &= ~IFF_FAILOVER_SLAVE;
>  err_upper_link:
>  	netdev_rx_handler_unregister(slave_dev);
>  done:
> @@ -121,7 +121,7 @@ int failover_slave_unregister(struct net_device *slave_dev)
>  
>  	netdev_rx_handler_unregister(slave_dev);
>  	netdev_upper_dev_unlink(slave_dev, failover_dev);
> -	slave_dev->priv_flags &= ~(IFF_FAILOVER_SLAVE | IFF_LIVE_RENAME_OK);
> +	slave_dev->priv_flags &= ~IFF_FAILOVER_SLAVE;
>  
>  	if (fops && fops->slave_unregister &&
>  	    !fops->slave_unregister(slave_dev, failover_dev))
> -- 
> 2.38.1
> 
