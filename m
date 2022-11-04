Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1427618E75
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 03:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbiKDCul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 22:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiKDCuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 22:50:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD1A65FE;
        Thu,  3 Nov 2022 19:50:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A1C462066;
        Fri,  4 Nov 2022 02:50:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B30C433D6;
        Fri,  4 Nov 2022 02:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667530238;
        bh=xUMe7WcxDjcNixtO8e13bMn6UtwNVzh9mKBW9tU/MGQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DIZ8XoqQ63peEAmLWU+06RPEkk6UMsZYWqwmehfcyi21ly9/D3DTh4I8iKBQUA9+A
         F62lb6dYmFMtA1bdhMYY4goCon/xg/fwfAyjUcSmR1kRXZonD+mXwbGgC7DXRDGQkg
         hRcSVaj4RMSxZI2aRXulEtH0U6px8fJvqDVfmkoCHx7Ls970BAAiYQP5QloC0PMMHu
         IoPZCsmUw/NX2MkBQuqljeOW2TiSeughtHG8Kksw4Ub5/s+rdb1JSxFicKhRfhHCv7
         2PCt5Fwi17WPmM5ynQLjX/57ogldynNlpT8ZxoWTajF9XeJUbLC4CjR1chUARUnxN1
         xMb/ioviiXHbQ==
Date:   Thu, 3 Nov 2022 19:50:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andy Ren <andy.ren@getcruise.com>
Cc:     netdev@vger.kernel.org, richardbgobert@gmail.com,
        davem@davemloft.net, wsa+renesas@sang-engineering.com,
        edumazet@google.com, petrm@nvidia.com, pabeni@redhat.com,
        corbet@lwn.net, andrew@lunn.ch, dsahern@gmail.com,
        sthemmin@microsoft.com, idosch@idosch.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        roman.gushchin@linux.dev
Subject: Re: [PATCH net-next] net/core: Allow live renaming when an
 interface is up
Message-ID: <20221103195037.13ff8caf@kernel.org>
In-Reply-To: <20221103235847.3919772-1-andy.ren@getcruise.com>
References: <20221103235847.3919772-1-andy.ren@getcruise.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Nov 2022 16:58:47 -0700 Andy Ren wrote:
> @@ -1691,7 +1690,6 @@ enum netdev_priv_flags {
>  	IFF_FAILOVER			= 1<<27,
>  	IFF_FAILOVER_SLAVE		= 1<<28,
>  	IFF_L3MDEV_RX_HANDLER		= 1<<29,
> -	IFF_LIVE_RENAME_OK		= 1<<30,

As Stephen says the hole should be somehow noted.
Comment saying what it was, or just a comment saying there 
is a hole that can be reused.

>  	IFF_TX_SKB_NO_LINEAR		= BIT_ULL(31),
>  	IFF_CHANGE_PROTO_DOWN		= BIT_ULL(32),
>  };
> @@ -1726,7 +1724,6 @@ enum netdev_priv_flags {
>  #define IFF_FAILOVER			IFF_FAILOVER
>  #define IFF_FAILOVER_SLAVE		IFF_FAILOVER_SLAVE
>  #define IFF_L3MDEV_RX_HANDLER		IFF_L3MDEV_RX_HANDLER
> -#define IFF_LIVE_RENAME_OK		IFF_LIVE_RENAME_OK
>  #define IFF_TX_SKB_NO_LINEAR		IFF_TX_SKB_NO_LINEAR
>  
>  /* Specifies the type of the struct net_device::ml_priv pointer */
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 2e4f1c97b59e..a2d650ae15d7 100644
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

Let's leave a hint for potential triage and add something extra to the
netdev_info() print a few lines down in case the interface is renamed
while UP. Perhaps:

	netdev_info(dev, "renamed from %s%s\n", oldname,
		    dev->flags & IFF_UP ? " (while UP)" : "");

or some such.
