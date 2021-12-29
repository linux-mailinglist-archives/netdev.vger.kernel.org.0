Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BABB4815FD
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 19:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbhL2SKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 13:10:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhL2SKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 13:10:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C6CC061574;
        Wed, 29 Dec 2021 10:10:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 569F9B819C9;
        Wed, 29 Dec 2021 18:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 00A00C36AE1;
        Wed, 29 Dec 2021 18:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640801410;
        bh=55O5hAxQWm338Eao4qkp9HAY+FvCNX8YKDO7ZyodgL8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Hu0yEVZlemPkRNk5IawZzOVM5RtSt5zA/zT/ar0K/bZmJGF2aIVt/QEvj0GCWkI0y
         fNn4Y7yqeD42u5GO/56WOxj5y7CAae/gIHtJp1jopKvIKBFu5jbHph4NHdyxLq+R3g
         hmMb7nCpxu/rgXdO49/WQgY9i0QvqkX6IP4U3RNGddlcfUQhyUynPli1HTTDpWk2Fk
         CzDkaFlp5ABEKebXIY0ArUuAj98b6PieVUPRjUwI0ZpOgsRnQTyD266yxBKNUzOt53
         CxUrg234o2LSxiA4psEEyNnfYQ/m4sBkJxUl7fhDei0rK/qrwQ8HA7Ais+bGiG2i+g
         Rr7ZvEEevFjWw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D73F1C395E4;
        Wed, 29 Dec 2021 18:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] xsk: Initialise xskb free_list_node
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164080140987.31074.14355340530861949666.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Dec 2021 18:10:09 +0000
References: <20211220155250.2746-1-ciara.loftus@intel.com>
In-Reply-To: <20211220155250.2746-1-ciara.loftus@intel.com>
To:     Loftus@ci.codeaurora.org, Ciara <ciara.loftus@intel.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 20 Dec 2021 15:52:50 +0000 you wrote:
> This commit initialises the xskb's free_list_node when the xskb is
> allocated. This prevents a potential false negative returned from a call
> to list_empty for that node, such as the one introduced in commit
> 199d983bc015 ("xsk: Fix crash on double free in buffer pool")
> 
> In my environment this issue caused packets to not be received by
> the xdpsock application if the traffic was running prior to application
> launch. This happened when the first batch of packets failed the xskmap
> lookup and XDP_PASS was returned from the bpf program. This action is
> handled in the i40e zc driver (and others) by allocating an skbuff,
> freeing the xdp_buff and adding the associated xskb to the
> xsk_buff_pool's free_list if it hadn't been added already. Without this
> fix, the xskb is not added to the free_list because the check to determine
> if it was added already returns an invalid positive result. Later, this
> caused allocation errors in the driver and the failure to receive packets.
> 
> [...]

Here is the summary with links:
  - [bpf] xsk: Initialise xskb free_list_node
    https://git.kernel.org/netdev/net/c/5bec7ca2be69

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


