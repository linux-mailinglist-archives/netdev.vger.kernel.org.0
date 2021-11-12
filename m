Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50EB344E958
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 16:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235144AbhKLPC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 10:02:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:59852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231553AbhKLPC6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Nov 2021 10:02:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 4683460FDA;
        Fri, 12 Nov 2021 15:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636729207;
        bh=FV8jwTFbCJmlhaac0NczCRG2uWBxTbxV8Qr9tE7mnSo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QTvRnk/KIXbVvFzOdZMq7yUdiOeV6nK+2VJWK3EpcRaJ6l2KlVW4HAX0Wbxa781US
         cNOUT3orzNrMT5tYl0VCxUBzGepJyIfhChVywzhH6r9InTknJ+7yFqhMmjk/RLM6BB
         3ud9ZQ21aSIItkSC5P0AM3oHIfn49i6DGnwnVoxFBsrkbTMDa9HKVI27YfgenV/Ca/
         6lDlKocsIS3+BZ5uGW9/ZSdEANeqrp6WBAaBKFJ6w7F+wtSoZPtncljGr3Vu1j7y1z
         czx6pwx3ZLVN2Ueu+z5Xphx4E6Zwc4wc8xidKWEQmR8h0iOAmvuPj4mcPd7n/cv3DB
         9Y60b5wGS4mfw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3AAEE609F7;
        Fri, 12 Nov 2021 15:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] xsk: fix crash on double free in buffer pool
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163672920723.2811.854129217519334722.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Nov 2021 15:00:07 +0000
References: <20211111075707.21922-1-magnus.karlsson@gmail.com>
In-Reply-To: <20211111075707.21922-1-magnus.karlsson@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Thu, 11 Nov 2021 08:57:07 +0100 you wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Fix a crash in the buffer pool allocator when a buffer is double
> freed. It is possible to trigger this behavior not only from a faulty
> driver, but also from user space like this: Create a zero-copy AF_XDP
> socket. Load an XDP program that will issue XDP_DROP for all
> packets. Put the same umem buffer into the fill ring multiple times,
> then bind the socket and send some traffic. This will crash the kernel
> as the XDP_DROP action triggers one call to xsk_buff_free()/xp_free()
> for every packet dropped. Each call will add the corresponding buffer
> entry to the free_list and increase the free_list_cnt. Some entries
> will have been added multiple times due to the same buffer being
> freed. The buffer allocation code will then traverse this broken list
> and since the same buffer is in the list multiple times, it will try
> to delete the same buffer twice from the list leading to a crash.
> 
> [...]

Here is the summary with links:
  - [bpf] xsk: fix crash on double free in buffer pool
    https://git.kernel.org/bpf/bpf/c/199d983bc015

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


