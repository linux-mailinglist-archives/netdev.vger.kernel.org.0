Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF9047684F
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 03:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232936AbhLPCuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 21:50:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbhLPCuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 21:50:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B89BC061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 18:50:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0A0461BCE
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 02:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 178B1C36AE1;
        Thu, 16 Dec 2021 02:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639623010;
        bh=Kuh71+rmMKz4/3raDLHIix2cCC6IcAdXfy6waACvb8U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NSTfAg8jnWOROs83pMh3WlEP25aRRZ8GIIQTwAzHQ6d2KquLR5PVtqJdeelp7PdFg
         dEDSrQ/BOroKGXntuZaKzaavuXPqtD086kYXxWyYk9h9SHBgymsOgjQblsX8LurR5g
         nB/YTF0xguWcgdr6hlBm4dwTamJK6YX7CG75BFzIhQMq2XU4ohOMnasiW6jnqKIrYb
         pUoX1LHm+BBeuR5d+IZG1TV0CLlPM5jytxpNEcZXCUlUNZB+L9Tc0nd6sSNdEjhRKX
         ICN+DsBoyy9yw1bagd3oJft/56F7PAP3N3ngLbgqBnsDUMVhrc7xyxUaBgfSUzt9Z5
         ZxLmUIYQHf2vA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EAFDF60984;
        Thu, 16 Dec 2021 02:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4] netdevsim: Zero-initialize memory for new map's value in
 function nsim_bpf_map_alloc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163962300995.8380.8008869422888743193.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Dec 2021 02:50:09 +0000
References: <20211215111530.72103-1-tcs.kernel@gmail.com>
In-Reply-To: <20211215111530.72103-1-tcs.kernel@gmail.com>
To:     Haimin Zhang <tcs.kernel@gmail.com>
Cc:     greg@kroah.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kuba@kernel.org, security@kernel.org,
        elijahbai@tencent.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 15 Dec 2021 19:15:30 +0800 you wrote:
> Zero-initialize memory for new map's value in function nsim_bpf_map_alloc
> since it may cause a potential kernel information leak issue, as follows:
> 1. nsim_bpf_map_alloc calls nsim_map_alloc_elem to allocate elements for
> a new map.
> 2. nsim_map_alloc_elem uses kmalloc to allocate map's value, but doesn't
> zero it.
> 3. A user application can use IOCTL BPF_MAP_LOOKUP_ELEM to get specific
> element's information in the map.
> 4. The kernel function map_lookup_elem will call bpf_map_copy_value to get
> the information allocated at step-2, then use copy_to_user to copy to the
> user buffer.
> This can only leak information for an array map.
> 
> [...]

Here is the summary with links:
  - [v4] netdevsim: Zero-initialize memory for new map's value in function nsim_bpf_map_alloc
    https://git.kernel.org/netdev/net/c/481221775d53

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


