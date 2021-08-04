Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3713DFF27
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 12:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237470AbhHDKKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 06:10:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237460AbhHDKKU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 06:10:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3472960BD3;
        Wed,  4 Aug 2021 10:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628071807;
        bh=2nV34d/niZhgfoNa1iOIJJ9+yNStB4FRv8xNZoTBvc4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gmF0g/Zi+laee6Eo6fZjvk4qkY1s+57lPROW60GELK27P3X8MffpaVwoD3JRSh6Jy
         BzP2gr4eV7mHdOmxwtDj+SH7u5sAFaMQYKl519OjMfrsyJ0cV91YxI8BsqJkVx4aJC
         P4MHQI6qo/ufBSRzr9lf8ChAan07lmSWS3DaWtEg9F5dp3wvaztjWJxFMRGZuxOiaF
         RpqMctkV5ROGMHZBxWor9Liwud9K7s3b8U2jctna9A7DBwDtJzZqGRFCXMgBdRs+Vg
         lADlgLBaqw/Ueavx1BY03E3ZzOL5FSJU7zdetXSIb92U9b0jrHL/V6PHnbOm0XXMHd
         cmh727KcQyuWA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2587160A49;
        Wed,  4 Aug 2021 10:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/6] net: xfrm: fix memory leak in xfrm_user_rcv_msg
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162807180714.12271.8843307893569328928.git-patchwork-notify@kernel.org>
Date:   Wed, 04 Aug 2021 10:10:07 +0000
References: <20210804070329.1357123-2-steffen.klassert@secunet.com>
In-Reply-To: <20210804070329.1357123-2-steffen.klassert@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed, 4 Aug 2021 09:03:24 +0200 you wrote:
> From: Pavel Skripkin <paskripkin@gmail.com>
> 
> Syzbot reported memory leak in xfrm_user_rcv_msg(). The
> problem was is non-freed skb's frag_list.
> 
> In skb_release_all() skb_release_data() will be called only
> in case of skb->head != NULL, but netlink_skb_destructor()
> sets head to NULL. So, allocated frag_list skb should be
> freed manualy, since consume_skb() won't take care of it
> 
> [...]

Here is the summary with links:
  - [1/6] net: xfrm: fix memory leak in xfrm_user_rcv_msg
    https://git.kernel.org/netdev/net/c/7c1a80e80cde
  - [2/6] Revert "xfrm: policy: Read seqcount outside of rcu-read side in xfrm_policy_lookup_bytype"
    https://git.kernel.org/netdev/net/c/eaf228263921
  - [3/6] xfrm: Fix RCU vs hash_resize_mutex lock inversion
    https://git.kernel.org/netdev/net/c/2580d3f40022
  - [4/6] net/xfrm/compat: Copy xfrm_spdattr_type_t atributes
    https://git.kernel.org/netdev/net/c/4e9505064f58
  - [5/6] selftests/net/ipsec: Add test for xfrm_spdattr_type_t
    https://git.kernel.org/netdev/net/c/70bfdf62e93a
  - [6/6] net: xfrm: Fix end of loop tests for list_for_each_entry
    https://git.kernel.org/netdev/net/c/480e93e12aa0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


