Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F17015F3A8D
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 02:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiJDAZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 20:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiJDAZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 20:25:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4252A12AA3;
        Mon,  3 Oct 2022 17:25:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECC42B817B1;
        Tue,  4 Oct 2022 00:25:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 977DAC433D7;
        Tue,  4 Oct 2022 00:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664843101;
        bh=VIZttZb/zMhzlIUWpKbXFwmIY7omqBgI7A8DlZxtLsU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aa36JtlP61iScmU/pNcvBze0podyNnQsdLK00Gw+CU0Paa3GTNYFy3g4b3vREyCDi
         SWxNCSUbxQPbFq9OpDhWEARl/42UwgsGaoneDLCWxhHJYR3XbCMTDFyIFMrEpdoFPy
         w3svViwMgj4KWRFNiTvfB4NiAKrOK5S4GS3/2XYOKNfTYa6l9EjNu6j/SZmhxMc/j0
         LdaXJ394rqjMlEGCUQi3wX60FQMHRK8qoxJvkR71A34yBfm6UgAXxLpd5Q9iXkz47o
         1FjYcbC76efci8HfcwFhIP+noW5+Jr2TAi1lK/flYIS1+TauvRkLF7KM8w9lXeUiDF
         ewjspsyv7/Myg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7D50BE4D013;
        Tue,  4 Oct 2022 00:25:01 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v7 0/9] net: marvell: prestera: add nexthop routes
 offloading
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166484310150.14032.12288807461799255097.git-patchwork-notify@kernel.org>
Date:   Tue, 04 Oct 2022 00:25:01 +0000
References: <20221001093417.22388-1-yevhen.orlov@plvision.eu>
In-Reply-To: <20221001093417.22388-1-yevhen.orlov@plvision.eu>
To:     Yevhen Orlov <yevhen.orlov@plvision.eu>
Cc:     netdev@vger.kernel.org, volodymyr.mytnyk@plvision.eu,
        taras.chornyi@plvision.eu, mickeyr@marvell.com,
        serhiy.pshyk@plvision.eu, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, andrew@lunn.ch,
        stephen@networkplumber.org, linux-kernel@vger.kernel.org,
        tchornyi@marvell.com, oleksandr.mazur@plvision.eu
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat,  1 Oct 2022 12:34:08 +0300 you wrote:
> Add support for nexthop routes for Marvell Prestera driver.
> Subscribe on NEIGH_UPDATE events.
> 
> Add features:
>  - Support connected route adding
>    e.g.: "ip address add 1.1.1.1/24 dev sw1p1"
>    e.g.: "ip route add 6.6.6/24 dev sw1p1"
>  - Support nexthop route adding
>    e.g.: "ip route add 5.5.5/24 via 1.1.1.2"
>  - Support ECMP route adding
>    e.g.: "ip route add 5.5.5/24 nexthop via 1.1.1.2 nexthop via 1.1.1.3"
>  - Support "offload" and "trap" flags per each nexthop
>  - Support "offload" flag for neighbours
> 
> [...]

Here is the summary with links:
  - [net-next,v7,1/9] net: marvell: prestera: Add router nexthops ABI
    https://git.kernel.org/netdev/net-next/c/0a23ae237171
  - [net-next,v7,2/9] net: marvell: prestera: Add cleanup of allocated fib_nodes
    https://git.kernel.org/netdev/net-next/c/1e7313e83ef7
  - [net-next,v7,3/9] net: marvell: prestera: Add strict cleanup of fib arbiter
    https://git.kernel.org/netdev/net-next/c/333fe4d033fa
  - [net-next,v7,4/9] net: marvell: prestera: add delayed wq and flush wq on deinit
    https://git.kernel.org/netdev/net-next/c/90b6f9c09851
  - [net-next,v7,5/9] net: marvell: prestera: Add length macros for prestera_ip_addr
    https://git.kernel.org/netdev/net-next/c/59b44ea8aa56
  - [net-next,v7,6/9] net: marvell: prestera: Add heplers to interact with fib_notifier_info
    https://git.kernel.org/netdev/net-next/c/04f24a1e6de6
  - [net-next,v7,7/9] net: marvell: prestera: add stub handler neighbour events
    https://git.kernel.org/netdev/net-next/c/8b1ef4911a41
  - [net-next,v7,8/9] net: marvell: prestera: Add neighbour cache accounting
    https://git.kernel.org/netdev/net-next/c/396b80cb5cc8
  - [net-next,v7,9/9] net: marvell: prestera: Propagate nh state from hw to kernel
    https://git.kernel.org/netdev/net-next/c/ae15ed6e40c9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


