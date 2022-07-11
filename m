Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 708655703DF
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 15:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbiGKNKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 09:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiGKNKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 09:10:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5223246F
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 06:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCE88B80EE4
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 13:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7B28BC341C0;
        Mon, 11 Jul 2022 13:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657545012;
        bh=J/z+bl2RLtQHiekuPY3nkif7x6NnR1wDYUMUtdLi7C0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KZg8AaN7+VdXBEkWiIgvexLNzorCU6AJBVKhZjUnhUEOxtZCewhvjRT6bgnFf/nw8
         1oMxGJqmDOpR6vLaUXDpPCLC4jkZfM9k3BoPXC7NBNvMWItgFSN2UxXinL3IpRENK5
         lOagRIW4S6I+l/gfUinHx6iXCe2Z0Gpv4fwGn9nfqnDwR+d+1avXMCfaDB4X7xWdSG
         O1cD8WZ4JheBvKkR/ElSu00hiEBmNNWzFo/GWsKozZPqpSiZrH7whb8CrE/rt2GLtR
         jzBXaYF/uZJ9qKrw++5Ff6qAFRX5Nrg6OKpJVEGmNIgP7t/md/R3/5m2YQ1l8pCi47
         G2tRYQw1WihIg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 60AE8E45226;
        Mon, 11 Jul 2022 13:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 net-next] net: Find dst with sk's xfrm policy not ctl_sk
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165754501239.30308.12114903372158946352.git-patchwork-notify@kernel.org>
Date:   Mon, 11 Jul 2022 13:10:12 +0000
References: <20220707100139.3748417-1-ssewook@gmail.com>
In-Reply-To: <20220707100139.3748417-1-ssewook@gmail.com>
To:     Sewook Seo <ssewook@gmail.com>
Cc:     sewookseo@google.com, netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, maze@google.com, edumazet@google.com,
        steffen.klassert@secunet.com, seheele@google.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  7 Jul 2022 10:01:39 +0000 you wrote:
> From: sewookseo <sewookseo@google.com>
> 
> If we set XFRM security policy by calling setsockopt with option
> IPV6_XFRM_POLICY, the policy will be stored in 'sock_policy' in 'sock'
> struct. However tcp_v6_send_response doesn't look up dst_entry with the
> actual socket but looks up with tcp control socket. This may cause a
> problem that a RST packet is sent without ESP encryption & peer's TCP
> socket can't receive it.
> This patch will make the function look up dest_entry with actual socket,
> if the socket has XFRM policy(sock_policy), so that the TCP response
> packet via this function can be encrypted, & aligned on the encrypted
> TCP socket.
> 
> [...]

Here is the summary with links:
  - [v5,net-next] net: Find dst with sk's xfrm policy not ctl_sk
    https://git.kernel.org/netdev/net-next/c/e22aa1486668

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


