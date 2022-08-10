Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1488058E935
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 11:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbiHJJAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 05:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbiHJJAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 05:00:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C3CBC96;
        Wed, 10 Aug 2022 02:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07A1AB81B08;
        Wed, 10 Aug 2022 09:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B46C9C433B5;
        Wed, 10 Aug 2022 09:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660122014;
        bh=rSuRxfEqlZ8zI+ECBZXfhLDe5fNiCaTkUU61OdmY+Ko=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ic6Rdwe8VHhvWu3Ual5WaZ8Dpxkdbh5p1VeIflQ4z0KxwXv2M8oi+LwWzXeRJLKvK
         Bvf40q56Kgvy3SALVFOE8OGeiiG72u4nCh6qX2kzFa0o2m+a5FOID/+Ze1OyVH6Jij
         PPIqNoNN+WJbASBpOFk5pW2feXG+OTPLWRgLp/GhxjZfLW1q74e37b11fGlC2dH2GY
         1VY1EUxcpcM5j2uRAS+qxYFk3QmZRtl9vgezbb+qA8CmiGnt3vdSLGWNU+x59RCcWt
         HiYYUdyCdxkkzCSvQueXHbyXfMYBZ0BpjvkEFFPmaL51jvHYXuDcJKevlIOrTz6H0A
         v0c8hFrHoi23g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9B884C43143;
        Wed, 10 Aug 2022 09:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 1/2] vsock: Fix memory leak in vsock_connect()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166012201463.839.9698231460105357128.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Aug 2022 09:00:14 +0000
References: <fd0dc1aa3a78df22d64de59333e1d47ee60ed3e8.1659981325.git.peilin.ye@bytedance.com>
In-Reply-To: <fd0dc1aa3a78df22d64de59333e1d47ee60ed3e8.1659981325.git.peilin.ye@bytedance.com>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     sgarzare@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, peilin.ye@bytedance.com,
        georgezhang@vmware.com, dtor@vmware.com, acking@vmware.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon,  8 Aug 2022 11:04:47 -0700 you wrote:
> From: Peilin Ye <peilin.ye@bytedance.com>
> 
> An O_NONBLOCK vsock_connect() request may try to reschedule
> @connect_work.  Imagine the following sequence of vsock_connect()
> requests:
> 
>   1. The 1st, non-blocking request schedules @connect_work, which will
>      expire after 200 jiffies.  Socket state is now SS_CONNECTING;
> 
> [...]

Here is the summary with links:
  - [net,v3,1/2] vsock: Fix memory leak in vsock_connect()
    https://git.kernel.org/netdev/net/c/7e97cfed9929
  - [net,v3,2/2] vsock: Set socket state back to SS_UNCONNECTED in vsock_connect_timeout()
    https://git.kernel.org/netdev/net/c/a3e7b29e3085

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


