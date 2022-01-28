Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9EF049F261
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 05:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345990AbiA1EUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 23:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345994AbiA1EUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 23:20:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2F8C061747;
        Thu, 27 Jan 2022 20:20:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B6BF60C6F;
        Fri, 28 Jan 2022 04:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 92222C340EC;
        Fri, 28 Jan 2022 04:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643343612;
        bh=F7CUMzOC/FXhhI220Gt83QTOXYmawf15qGJY1aOSoKw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Nshi/2ZNcsVq6aLhCif+Rnm7XMobY64X/3V0gsNVbuS0tIM2EYo59aM4qjEeAp1k7
         E+Vq3G68+ZCiLZ7NfJsz0fiHoSV9ytAEg5if5XEvA6kw7XzYkBHHH0TZZ1zlmj7wLU
         Ynlaf7cDGUH7pewkFfORZ87Z1Hdy6KpAnwtxpSKdWws4lJEAjB5Pxi3eI8qZRkZkJw
         3hmlc8BzyZDqgJzp5d0Q5f+OSTTx7OQRPEolPKRRfsLcEopZxsIw3xn0T6Io8RhrHD
         8T6zFheK6PvBIRsBlFXhWIlFEL+DbUTI/wZXhmERXpoxGSefUFqDAgpYV8cY8Ak42R
         +arsdNB7fxDJg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7A6A7E5D089;
        Fri, 28 Jan 2022 04:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 00/10] udp/ipv6 optimisations
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164334361249.28006.3733418624266490544.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Jan 2022 04:20:12 +0000
References: <cover.1643243772.git.asml.silence@gmail.com>
In-Reply-To: <cover.1643243772.git.asml.silence@gmail.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, willemdebruijn.kernel@gmail.com,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 27 Jan 2022 00:36:21 +0000 you wrote:
> Shed some weight from udp/ipv6. Zerocopy benchmarks over dummy showed
> ~5% tx/s improvement, should be similar for small payload non-zc
> cases.
> 
> The performance comes from killing 4 atomics and a couple of big struct
> memcpy/memset. 1/10 removes a pair of atomics on dst refcounting for
> cork->skb setup, 9/10 saves another pair on cork init. 5/10 and 8/10
> kill extra 88B memset and memcpy respectively.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/10] ipv6: optimise dst refcounting on skb init
    https://git.kernel.org/netdev/net-next/c/cd3c74807736
  - [net-next,v2,02/10] udp6: shuffle up->pending AF_INET bits
    https://git.kernel.org/netdev/net-next/c/406c4a0af010
  - [net-next,v2,03/10] ipv6: remove daddr temp buffer in __ip6_make_skb
    https://git.kernel.org/netdev/net-next/c/b60d4e58c615
  - [net-next,v2,04/10] ipv6: clean up cork setup/release
    https://git.kernel.org/netdev/net-next/c/d656b2ea5fa7
  - [net-next,v2,05/10] ipv6: don't zero inet_cork_full::fl after use
    https://git.kernel.org/netdev/net-next/c/940ea00b0646
  - [net-next,v2,06/10] ipv6: pass full cork into __ip6_append_data()
    https://git.kernel.org/netdev/net-next/c/f3b46a3e8c40
  - [net-next,v2,07/10] udp6: pass flow in ip6_make_skb together with cork
    https://git.kernel.org/netdev/net-next/c/f37a4cc6bb0b
  - [net-next,v2,08/10] udp6: don't make extra copies of iflow
    https://git.kernel.org/netdev/net-next/c/5298953e742d
  - [net-next,v2,09/10] ipv6: optimise dst refcounting on cork init
    https://git.kernel.org/netdev/net-next/c/40ac240c2e06
  - [net-next,v2,10/10] ipv6: partially inline ipv6_fixup_options
    https://git.kernel.org/netdev/net-next/c/31ed2261e88f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


