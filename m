Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 230536D2A18
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 23:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbjCaVox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 17:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231195AbjCaVow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 17:44:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F5F21EFE3;
        Fri, 31 Mar 2023 14:44:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0A50B8326D;
        Fri, 31 Mar 2023 21:44:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD57C433EF;
        Fri, 31 Mar 2023 21:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680299086;
        bh=+5nkMzk4XF1mEch/NXrBSoh9zf1M4pjm5mjpqjHViZ4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PQFHqIwLOSXa4x7uxH2cN7a5xhvNL9z88Fnke4mLW6FFd/Ez+3bk9EWGsygKdWTC0
         vP4v1hMiiiE/L+NSvahqx6xK5C4TAaM5Bxc0oVpKxRscXdaxMO0sBJAJP5CNjGT6hv
         1W0SLzV63/7Lm8IVg5WRcM2VOF4w4FeXzZpGHehMlAhwLDglAV6Onn1iMNHuGbKrig
         dSxielhu8ei13QUH9NySnpnAq9w460Pju1sbgN8lrcxKgiafQTlqDEiMSWeCo5UCye
         i2VD+4HrW2ufrLGWa0IFWNUmIEVp7HtkWtbStAr20L0lDy15PhV8lajVKfFkXXQcL2
         H9/kb5HndRXEg==
Date:   Fri, 31 Mar 2023 14:44:44 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Arnd Bergmann <arnd@kernel.org>, kuba@kernel.org, arnd@arndb.de,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        razor@blackwall.org, kerneljasonxing@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: netcp: MAX_SKB_FRAGS is now 'int'
Message-ID: <20230331214444.GA1426512@dev-arch.thelio-3990X>
References: <20230331074919.1299425-1-arnd@kernel.org>
 <168025201885.3875.15510680598248652530.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168025201885.3875.15510680598248652530.git-patchwork-notify@kernel.org>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 08:40:18AM +0000, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This patch was applied to netdev/net.git (main)
> by David S. Miller <davem@davemloft.net>:
> 
> On Fri, 31 Mar 2023 09:48:56 +0200 you wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> > 
> > The type of MAX_SKB_FRAGS has changed recently, so the debug printk
> > needs to be updated:
> > 
> > drivers/net/ethernet/ti/netcp_core.c: In function 'netcp_create_interface':
> > drivers/net/ethernet/ti/netcp_core.c:2084:30: error: format '%ld' expects argument of type 'long int', but argument 3 has type 'int' [-Werror=format=]
> >  2084 |                 dev_err(dev, "tx-pool size too small, must be at least %ld\n",
> >       |                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > 
> > [...]
> 
> Here is the summary with links:
>   - net: netcp: MAX_SKB_FRAGS is now 'int'
>     https://git.kernel.org/netdev/net/c/c5b959eeb7f9

net now warns:

  In file included from include/linux/device.h:15,
                   from include/linux/dma-mapping.h:7,
                   from include/linux/skbuff.h:28,
                   from include/linux/if_ether.h:19,
                   from include/linux/ethtool.h:18,
                   from include/linux/phy.h:16,
                   from include/linux/of_net.h:9,
                   from drivers/net/ethernet/ti/netcp_core.c:16:
  drivers/net/ethernet/ti/netcp_core.c: In function 'netcp_create_interface':
  drivers/net/ethernet/ti/netcp_core.c:2084:30: error: format '%d' expects argument of type 'int', but argument 3 has type 'long unsigned int' [-Werror=format=]
   2084 |                 dev_err(dev, "tx-pool size too small, must be at least %d\n",
        |                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  include/linux/dev_printk.h:110:30: note: in definition of macro 'dev_printk_index_wrap'
    110 |                 _p_func(dev, fmt, ##__VA_ARGS__);                       \
        |                              ^~~
  include/linux/dev_printk.h:144:56: note: in expansion of macro 'dev_fmt'
    144 |         dev_printk_index_wrap(_dev_err, KERN_ERR, dev, dev_fmt(fmt), ##__VA_ARGS__)
        |                                                        ^~~~~~~
  drivers/net/ethernet/ti/netcp_core.c:2084:17: note: in expansion of macro 'dev_err'
   2084 |                 dev_err(dev, "tx-pool size too small, must be at least %d\n",
        |                 ^~~~~~~
  drivers/net/ethernet/ti/netcp_core.c:2084:73: note: format string is defined here
   2084 |                 dev_err(dev, "tx-pool size too small, must be at least %d\n",
        |                                                                        ~^
        |                                                                         |
        |                                                                         int
        |                                                                        %ld
  cc1: all warnings being treated as errors

The commit this patch is fixing is only in net-next and my patch to fix
this warning is already applied:

https://git.kernel.org/netdev/net-next/c/3292004c90c8

c5b959eeb7f9 should be reverted in net (I am running out of time today
otherwise I would just send a patch).

Cheers,
Nathan
