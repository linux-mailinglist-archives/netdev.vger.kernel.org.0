Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD546DA9C1
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 10:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239409AbjDGIKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 04:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbjDGIKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 04:10:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99D7A271;
        Fri,  7 Apr 2023 01:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5607F64F77;
        Fri,  7 Apr 2023 08:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AA27EC433EF;
        Fri,  7 Apr 2023 08:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680855018;
        bh=vINl0lPg8DSk3x3DsYiCNOE7MhbQ+ie0j6bnteHngsI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lzfHbqd7dQ26glqRvArGNoCyx9xXUg4MQs1x1mJddKXsZGF6y7zQyN79D22m6/ItA
         njzUWh/zoYxV6q9KIicG7NnNEu00j8GHa9soduFnnWbPR0sAh0kCO1fXNaUKSTWDm7
         qOqGboQ9GK4eaeyILtCYx5GaiLm0gtizfx8HPMXBoNhfn4eH1PYfuOjQRPmlZm421w
         ACfDFxzNR/YxPZ2sI4euQhuD3aBKn5cDxCxetFR7HYQmldP3NbNE6hJyhpjkNRLPdJ
         BBDfTfes2DvUSw0ayocdGf0B/2W7A7NozZlBTbPMr6Hx0xIIR4JMRMTtDntAQ1oZAp
         5CDNs0PkNFTvg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8EA99C395C5;
        Fri,  7 Apr 2023 08:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tcp: restrict net.ipv4.tcp_app_win
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168085501858.4864.5890586221086478006.git-patchwork-notify@kernel.org>
Date:   Fri, 07 Apr 2023 08:10:18 +0000
References: <20230406063450.19572-1-yuehaibing@huawei.com>
In-Reply-To: <20230406063450.19572-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, dsahern@kernel.org,
        kuniyu@amazon.com, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 6 Apr 2023 14:34:50 +0800 you wrote:
> UBSAN: shift-out-of-bounds in net/ipv4/tcp_input.c:555:23
> shift exponent 255 is too large for 32-bit type 'int'
> CPU: 1 PID: 7907 Comm: ssh Not tainted 6.3.0-rc4-00161-g62bad54b26db-dirty #206
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x136/0x150
>  __ubsan_handle_shift_out_of_bounds+0x21f/0x5a0
>  tcp_init_transfer.cold+0x3a/0xb9
>  tcp_finish_connect+0x1d0/0x620
>  tcp_rcv_state_process+0xd78/0x4d60
>  tcp_v4_do_rcv+0x33d/0x9d0
>  __release_sock+0x133/0x3b0
>  release_sock+0x58/0x1b0
> 
> [...]

Here is the summary with links:
  - [net] tcp: restrict net.ipv4.tcp_app_win
    https://git.kernel.org/netdev/net/c/dc5110c2d959

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


