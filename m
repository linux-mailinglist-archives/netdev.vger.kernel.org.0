Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04301694F1F
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 19:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbjBMSVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 13:21:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjBMSVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 13:21:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67779CA36;
        Mon, 13 Feb 2023 10:21:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F23D661243;
        Mon, 13 Feb 2023 18:21:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 579ABC433EF;
        Mon, 13 Feb 2023 18:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676312489;
        bh=Wjq9Ia19EDI9+v8JHu5xn5wLa+vD17hTxwI+UDgDsM8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Cu6IM1g4BmrNn8SjLyyqzGjVlAveg3fs7I7tHvBz/CEXWwR4X7S96TXoaV/v6w9x3
         /R0eSogMbN4UaPnNh8ePcL+n/rGskddt+nMpTTd0hqBDfL3lTbxH5+XvoesYxqawU8
         kdYVV7kXKchSfIgJSlo9JGpI9FnKMRMjfKN4ihaDEi4d3XM6D6g0h4x/1dXWWofiHw
         QXDKsF6RnLUp8HvcOdA/5P13d+9QnLIyVAZPwswN/UY5qZg0E8pgKgfiDN+2aT82vF
         +3A/f9Q0CsFImr5licGa3k3eWxNxJIPHesIDC4ome0E5b2Km1dPDNDSC9fSqhrvRn6
         VFasHdoDYEM4w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 390A1E68D34;
        Mon, 13 Feb 2023 18:21:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next 0/6] ice: post-mbuf fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167631248922.3913.6892327229286800422.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Feb 2023 18:21:29 +0000
References: <20230210170618.1973430-1-alexandr.lobakin@intel.com>
In-Reply-To: <20230210170618.1973430-1-alexandr.lobakin@intel.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        toke@redhat.com, martin.lau@linux.dev, song@kernel.org,
        hawk@kernel.org, kuba@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Fri, 10 Feb 2023 18:06:12 +0100 you wrote:
> The set grew from the poor performance of %BPF_F_TEST_XDP_LIVE_FRAMES
> when the ice-backed device is a sender. Initially there were around
> 3.3 Mpps / thread, while I have 5.5 on skb-based pktgen...
> 
> After fixing 0005 (0004 is a prereq for it) first (strange thing nobody
> noticed that earlier), I started catching random OOMs. This is how 0002
> (and partially 0001) appeared.
> 0003 is a suggestion from Maciej to not waste time on refactoring dead
> lines. 0006 is a "cherry on top" to get away with the final 6.7 Mpps.
> 4.5 of 6 are fixes, but only the first three are tagged, since it then
> starts being tricky. I may backport them manually later on.
> 
> [...]

Here is the summary with links:
  - [bpf-next,1/6] ice: fix ice_tx_ring::xdp_tx_active underflow
    https://git.kernel.org/bpf/bpf-next/c/bc4db8347003
  - [bpf-next,2/6] ice: fix XDP Tx ring overrun
    https://git.kernel.org/bpf/bpf-next/c/0bd939b60cea
  - [bpf-next,3/6] ice: remove two impossible branches on XDP Tx cleaning
    https://git.kernel.org/bpf/bpf-next/c/923096b5cec3
  - [bpf-next,4/6] ice: robustify cleaning/completing XDP Tx buffers
    https://git.kernel.org/bpf/bpf-next/c/aa1d3faf71a6
  - [bpf-next,5/6] ice: fix freeing XDP frames backed by Page Pool
    https://git.kernel.org/bpf/bpf-next/c/055d0920685e
  - [bpf-next,6/6] ice: micro-optimize .ndo_xdp_xmit() path
    https://git.kernel.org/bpf/bpf-next/c/ad07f29b9c9a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


