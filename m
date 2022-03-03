Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B324CB6B3
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 07:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbiCCGLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 01:11:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiCCGK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 01:10:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EBCA165C2E;
        Wed,  2 Mar 2022 22:10:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6AC96184A;
        Thu,  3 Mar 2022 06:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 148D6C340F1;
        Thu,  3 Mar 2022 06:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646287813;
        bh=TU7DuLmOUOXBIjeGYJd3zB0+Q4BLMX5PtrBjAzuK8Mo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iNynvhI4uNhPWhh2pPT7f0HtuhnBRH+MJALrvOl1BspEsqnAB0AgJW5MPnQM+FBAV
         seUGQWk7qRwF1o/5aSbjwTAV5bt1KnUKJwfZAy96UwHGi8CzJnn+eCyPX5VALtsPQy
         ibGPWVUP2hsKk2WqAyXhVx/o99k+30ilZ7vZYO9JtsxJszIj3evCJi/Wlxaqokgfwv
         0bOLoPgx0ZyQJ+OujqQDMARLyD9zYZIk5cB14dOFQcopACcGggStlKHDv6BdR/fNC+
         uBDKuseskgf60ByoKhMbZdGdXwI/GvbV58p/wj1WjB6AxBzBj+ccOWtZj2Zx+mPNby
         T3S4ZActdfIZw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EB8D2EAC09D;
        Thu,  3 Mar 2022 06:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tuntap: add sanity checks about msg_controllen in
 sendmsg
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164628781296.31171.2633658939059325470.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Mar 2022 06:10:12 +0000
References: <20220303022441.383865-1-baymaxhuang@gmail.com>
In-Reply-To: <20220303022441.383865-1-baymaxhuang@gmail.com>
To:     Harold Huang <baymaxhuang@gmail.com>
Cc:     netdev@vger.kernel.org, jasowang@redhat.com, edumazet@google.com,
        eric.dumazet@gmail.com, davem@davemloft.net, kuba@kernel.org,
        mst@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  3 Mar 2022 10:24:40 +0800 you wrote:
> In patch [1], tun_msg_ctl was added to allow pass batched xdp buffers to
> tun_sendmsg. Although we donot use msg_controllen in this path, we should
> check msg_controllen to make sure the caller pass a valid msg_ctl.
> 
> [1]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fe8dd45bb7556246c6b76277b1ba4296c91c2505
> 
> Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> Suggested-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Harold Huang <baymaxhuang@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] tuntap: add sanity checks about msg_controllen in sendmsg
    https://git.kernel.org/netdev/net-next/c/74a335a07a17

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


