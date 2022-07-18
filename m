Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21A98577FE5
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 12:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234338AbiGRKkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 06:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234343AbiGRKkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 06:40:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D63D1EAF7
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 03:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AD4E6113B
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 10:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A7F30C341CB;
        Mon, 18 Jul 2022 10:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658140816;
        bh=vx1uimKd1W8vmr5mrvySSBVe2LYM3NKQHIZhdnmZ7EA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kiIoRzwPf2FhQPKple1eYskmtah+r1KUceCEsPoyueci/eI69dFKL2j0J4kx26VGm
         +naBDijxm79eN1q9vz71vzK+C3BTS0Xvd6t2fqSmQa0g51zQ6nxvqRTK8T5nX+vTUn
         WGdGHiC93rpk5jjhcCsXm+1ynoMpPLnzjj/fXcMAlo0XH8sdIA/eBastY1/J7JZYEC
         aC6faXBW9VpLjCs/hQ2xuo6onMvIoqBqZi7hf1yHPWQzrqP0bD84EdMdWGWolpC0iK
         zAHbYBBouQ/vFIZuDihQmwhRtRB4meFUnmWV+s7s+hk6gDI/zYnTLgIE0nxsI3A+qE
         I3obijChFP09Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 91443E451B0;
        Mon, 18 Jul 2022 10:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 00/11] tls: rx: avoid skb_cow_data()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165814081659.19605.1888713493982195445.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Jul 2022 10:40:16 +0000
References: <20220715052235.1452170-1-kuba@kernel.org>
In-Reply-To: <20220715052235.1452170-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, borisp@nvidia.com, john.fastabend@gmail.com,
        maximmi@nvidia.com, tariqt@nvidia.com, vfedorenko@novek.ru
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 14 Jul 2022 22:22:24 -0700 you wrote:
> TLS calls skb_cow_data() on the skb it received from strparser
> whenever it needs to hold onto the skb with the decrypted data.
> (The alternative being decrypting directly to a user space buffer
> in whic case the input skb doesn't get modified or used after.)
> TLS needs the decrypted skb:
>  - almost always with TLS 1.3 (unless the new NoPad is enabled);
>  - when user space buffer is too small to fit the record;
>  - when BPF sockmap is enabled.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/11] tls: rx: allow only one reader at a time
    https://git.kernel.org/netdev/net-next/c/4cbc325ed6b4
  - [net-next,v2,02/11] tls: rx: don't try to keep the skbs always on the list
    https://git.kernel.org/netdev/net-next/c/008141de8557
  - [net-next,v2,03/11] tls: rx: don't keep decrypted skbs on ctx->recv_pkt
    https://git.kernel.org/netdev/net-next/c/abb47dc95dc6
  - [net-next,v2,04/11] tls: rx: remove the message decrypted tracking
    https://git.kernel.org/netdev/net-next/c/53d57999fe02
  - [net-next,v2,05/11] tls: rx: factor out device darg update
    https://git.kernel.org/netdev/net-next/c/8a958732818b
  - [net-next,v2,06/11] tls: rx: read the input skb from ctx->recv_pkt
    https://git.kernel.org/netdev/net-next/c/541cc48be3b1
  - [net-next,v2,07/11] tls: rx: return the decrypted skb via darg
    https://git.kernel.org/netdev/net-next/c/6bd116c8c654
  - [net-next,v2,08/11] tls: rx: async: adjust record geometry immediately
    https://git.kernel.org/netdev/net-next/c/6ececdc51369
  - [net-next,v2,09/11] tls: rx: async: hold onto the input skb
    https://git.kernel.org/netdev/net-next/c/c618db2afe7c
  - [net-next,v2,10/11] tls: rx: async: don't put async zc on the list
    https://git.kernel.org/netdev/net-next/c/cbbdee9918a2
  - [net-next,v2,11/11] tls: rx: decrypt into a fresh skb
    https://git.kernel.org/netdev/net-next/c/fd31f3996af2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


