Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1298955F013
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 23:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbiF1VAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 17:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiF1VAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 17:00:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD59381A9;
        Tue, 28 Jun 2022 14:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3FCDB82048;
        Tue, 28 Jun 2022 21:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 734C5C341CA;
        Tue, 28 Jun 2022 21:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656450014;
        bh=gHzT6F/edl+As3rF8zbKdZdULO58PiwHR//I1JE8aes=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JirHjzc+URxAcD1GXOuYXAGb3d2L/UjgzMEvI6eWnnNhmLZfM4iwxcCrc6pT8CBcC
         s8pslBsAPj9Sq3E8vsXVbHrp6bi58/PIg0oReN5mIHAwkHSD3Acjcykz2Ierqw3JJy
         ff/bhvsnB0kcTQH5AyzeHfh3TCP0T+wb+LAzNna4eabBKgob14Poye01C780iSlU51
         Ft25yDXUvowuMNvrsJOl2Dv4pTvBSotgwSM4609+QHGihTEtzHV7HzGG/NlekvaT13
         hvzg0AeNFhHM6/bQC4tjwJatsP+kKlIbog8pD7ydaM0X/J4kWuC9DtvtQ7z8hMfPHs
         YaByI26LzPRhA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 54A78E49BBA;
        Tue, 28 Jun 2022 21:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 1/1] xsk: clear page contiguity bit when unmapping pool
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165645001434.24528.16734258366303906334.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Jun 2022 21:00:14 +0000
References: <20220628091848.534803-1-ivan.malov@oktetlabs.ru>
In-Reply-To: <20220628091848.534803-1-ivan.malov@oktetlabs.ru>
To:     Ivan Malov <ivan.malov@oktetlabs.ru>
Cc:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        netdev@vger.kernel.org, andrew.rybchenko@oktetlabs.ru,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        bjorn@kernel.org, maciej.fijalkowski@intel.com,
        jonathan.lemon@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        maximmi@mellanox.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue, 28 Jun 2022 12:18:48 +0300 you wrote:
> When a XSK pool gets mapped, xp_check_dma_contiguity() adds bit 0x1
> to pages' DMA addresses that go in ascending order and at 4K stride.
> The problem is that the bit does not get cleared before doing unmap.
> As a result, a lot of warnings from iommu_dma_unmap_page() are seen
> in dmesg, which indicates that lookups by iommu_iova_to_phys() fail.
> 
> Fixes: 2b43470add8c ("xsk: Introduce AF_XDP buffer allocation API")
> Signed-off-by: Ivan Malov <ivan.malov@oktetlabs.ru>
> 
> [...]

Here is the summary with links:
  - [net,v3,1/1] xsk: clear page contiguity bit when unmapping pool
    https://git.kernel.org/bpf/bpf/c/512d1999b8e9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


