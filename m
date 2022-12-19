Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7D68651610
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 00:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbiLSXAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 18:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbiLSXAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 18:00:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E09614D2D;
        Mon, 19 Dec 2022 15:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36D3861171;
        Mon, 19 Dec 2022 23:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7ADF4C433F0;
        Mon, 19 Dec 2022 23:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671490817;
        bh=Ao5cJ/XHRCJ8jNxmWyiMORU/FtBVu4BJ44roVRBX4Ak=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nsGKk5ZmlYY4wekJoGzfXiIZbaiS8C1KCLaDWKDELVctoooYlnXaADp8MRsCoHjrK
         RVsxISI8uo/2IrehO3bIzTZxwKOvd9dp9p94z/Ldu34FboEPi5zSTy57pxzdCQwRST
         h9zZIufPJNr7QS+9q4NZuMjwST+WFTfiVZKlQrrpDiJkYBAHr8G9N1szp0DpeeJ0x0
         aAq8YFSfEAVKrmR9M8VjcoGPJZqXJGKlMPagxHndy4j5Iui8bOgVks/ghemAM357Sg
         rD796PgUn4bQd7JwqZn4LJsM9qw/GGJ4TZp8UKsKdQ5E0hBdiB5G/KSsLDKPvk5DzQ
         pIW3XLzNI/tOg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5B645E29F4C;
        Mon, 19 Dec 2022 23:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next 1/2] bpf: Add flag BPF_F_NO_TUNNEL_KEY to
 bpf_skb_set_tunnel_key()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167149081736.13591.13985957363117157690.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Dec 2022 23:00:17 +0000
References: <20221218051734.31411-1-cehrig@cloudflare.com>
In-Reply-To: <20221218051734.31411-1-cehrig@cloudflare.com>
To:     Christian Ehrig <cehrig@cloudflare.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        sdf@google.com, haoluo@google.com, jolsa@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mykolal@fb.com, shuah@kernel.org,
        joannelkoong@gmail.com, kuifeng@fb.com, maximmi@nvidia.com,
        fankaixi.li@bytedance.com, shmulik@metanetworks.com,
        paul@isovalent.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Sun, 18 Dec 2022 06:17:31 +0100 you wrote:
> This patch allows to remove TUNNEL_KEY from the tunnel flags bitmap
> when using bpf_skb_set_tunnel_key by providing a BPF_F_NO_TUNNEL_KEY
> flag. On egress, the resulting tunnel header will not contain a tunnel
> key if the protocol and implementation supports it.
> 
> At the moment bpf_tunnel_key wants a user to specify a numeric tunnel
> key. This will wrap the inner packet into a tunnel header with the key
> bit and value set accordingly. This is problematic when using a tunnel
> protocol that supports optional tunnel keys and a receiving tunnel
> device that is not expecting packets with the key bit set. The receiver
> won't decapsulate and drop the packet.
> 
> [...]

Here is the summary with links:
  - [bpf-next,1/2] bpf: Add flag BPF_F_NO_TUNNEL_KEY to bpf_skb_set_tunnel_key()
    https://git.kernel.org/bpf/bpf-next/c/e26aa600ba6a
  - [bpf-next,2/2] selftests/bpf: Add BPF_F_NO_TUNNEL_KEY test
    https://git.kernel.org/bpf/bpf-next/c/ac6e45e05857

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


