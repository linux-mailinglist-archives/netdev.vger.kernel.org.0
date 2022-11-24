Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8458637108
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 04:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiKXDaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 22:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiKXDaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 22:30:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC905C74C
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 19:30:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19F8961EC7
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 03:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C3F8C433D7;
        Thu, 24 Nov 2022 03:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669260616;
        bh=fcIsg6oiHw/QmnYXIkBe6Bo47soqjtVPZdllslE4lBo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gRlhQUCB2dCUeYcSig6adCx/TLXqq3sV6ZC1jzfTPatYIXC4K4BAKqRo5Nes37xu0
         t3puBW36aIq1nWTRav1zIIjYn/IHkbW26CmqtJXcVyk8Yb+1mtAWCGp7dP3k11cXlP
         izXDr2z3gYFXsJ26o0Uto0IcDT/FMzIX9h8xvffU71FInuRcHqXWSsDuOSCoSsjeM+
         PPWLQiTzjja9zBRNMjcqmjBBlPlGQ/uB3ukCB9jrG7Ocs+yT0qm7jjU+zYHhqFCStx
         fauQBfOxmR4LsbrsUZV04lO8C2Dm1vAx8XBGJ8NMV1Cz8my9m9gjfqzEi7awpiZB9x
         DF3hPlJ6G4Jrw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 62EEEE270C7;
        Thu, 24 Nov 2022 03:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/6] xfrm: fix "disable_policy" on ipv4 early demux
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166926061640.30024.8199237047903306511.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Nov 2022 03:30:16 +0000
References: <20221123093117.434274-2-steffen.klassert@secunet.com>
In-Reply-To: <20221123093117.434274-2-steffen.klassert@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Steffen Klassert <steffen.klassert@secunet.com>:

On Wed, 23 Nov 2022 10:31:11 +0100 you wrote:
> From: Eyal Birger <eyal.birger@gmail.com>
> 
> The commit in the "Fixes" tag tried to avoid a case where policy check
> is ignored due to dst caching in next hops.
> 
> However, when the traffic is locally consumed, the dst may be cached
> in a local TCP or UDP socket as part of early demux. In this case the
> "disable_policy" flag is not checked as ip_route_input_noref() was only
> called before caching, and thus, packets after the initial packet in a
> flow will be dropped if not matching policies.
> 
> [...]

Here is the summary with links:
  - [1/6] xfrm: fix "disable_policy" on ipv4 early demux
    https://git.kernel.org/netdev/net/c/3a5913183aa1
  - [2/6] xfrm: lwtunnel: squelch kernel warning in case XFRM encap type is not available
    https://git.kernel.org/netdev/net/c/d83f7040e184
  - [3/6] xfrm: replay: Fix ESN wrap around for GSO
    https://git.kernel.org/netdev/net/c/4b549ccce941
  - [4/6] af_key: Fix send_acquire race with pfkey_register
    https://git.kernel.org/netdev/net/c/7f57f8165cb6
  - [5/6] xfrm: Fix oops in __xfrm_state_delete()
    https://git.kernel.org/netdev/net/c/b97df039a68b
  - [6/6] xfrm: Fix ignored return value in xfrm6_init()
    https://git.kernel.org/netdev/net/c/40781bfb836e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


