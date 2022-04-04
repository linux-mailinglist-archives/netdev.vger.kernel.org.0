Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1EBB4F1F15
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 00:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245514AbiDDW0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 18:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238406AbiDDWYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 18:24:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08EA637BD1;
        Mon,  4 Apr 2022 14:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 942396153A;
        Mon,  4 Apr 2022 21:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DB9A5C36AE3;
        Mon,  4 Apr 2022 21:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649109013;
        bh=6vOg6Y61pC8IK5u3St1oSJBWUoDwTq0vLU1UxtbyiqY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=T59GEs2f+WifRv1plp1HdqnldNU3IMhCJfAAMj84HOV1U5fRWUjnnB4DC30JSqBaZ
         dxKAZY8k7Obu3ZkxNeB9uy4e0sR7nfa1Exy6qxTfk4rboykD9Cz3xwqbUcNPRHCJA9
         20nKzfze6whYXcCkqBg8oRlNzlpljcLmJr3YB8OPUTZGY4cpYzWlqteLX0a27h+Oza
         7A89CFi/L4XDjRtk/V3TsuZ/S1+Ej9efZh35a94JozSQjMuMEDh8s6yvsuKWiaTYh5
         5uNG+HcBiFZ7cr1jEwSF1IMvknPexd6kQyxu9+4Y0RpVrQ7z9HUZh2BKhuFSBXTl+v
         ygLYNZ9f5LvQw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BCC8BE85DB6;
        Mon,  4 Apr 2022 21:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] samples: bpf: fix linking xdp_router_ipv4 after
 migration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164910901276.3906.153593045174428970.git-patchwork-notify@kernel.org>
Date:   Mon, 04 Apr 2022 21:50:12 +0000
References: <20220404115451.1116478-1-alexandr.lobakin@intel.com>
In-Reply-To: <20220404115451.1116478-1-alexandr.lobakin@intel.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, lorenzo@kernel.org,
        maciej.fijalkowski@intel.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Mon,  4 Apr 2022 13:54:51 +0200 you wrote:
> Users of the xdp_sample_user infra should be explicitly linked
> with the standard math library (`-lm`). Otherwise, the following
> happens:
> 
> /usr/bin/ld: xdp_sample_user.c:(.text+0x59fc): undefined reference to `ceil'
> /usr/bin/ld: xdp_sample_user.c:(.text+0x5a0d): undefined reference to `ceil'
> /usr/bin/ld: xdp_sample_user.c:(.text+0x5adc): undefined reference to `floor'
> /usr/bin/ld: xdp_sample_user.c:(.text+0x5b01): undefined reference to `ceil'
> /usr/bin/ld: xdp_sample_user.c:(.text+0x5c1e): undefined reference to `floor'
> /usr/bin/ld: xdp_sample_user.c:(.text+0x5c43): undefined reference to `ceil
> [...]
> 
> [...]

Here is the summary with links:
  - [bpf-next] samples: bpf: fix linking xdp_router_ipv4 after migration
    https://git.kernel.org/bpf/bpf-next/c/fc843ccd8e4c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


