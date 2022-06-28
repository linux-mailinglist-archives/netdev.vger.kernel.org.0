Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 067AA55DA37
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244588AbiF1FAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 01:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbiF1FAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 01:00:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B7025C6C;
        Mon, 27 Jun 2022 22:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 562E0B808C0;
        Tue, 28 Jun 2022 05:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0FEC7C341C6;
        Tue, 28 Jun 2022 05:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656392415;
        bh=qGZe+ejHbGYf++Nv+InVQVdxCtp1qdpdb8Fwn+VNK1E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mZBJ/fzyd8mT2914urcaywKNC9xwYGclLYHn+GOQFNRh3SVr9OrQIKa828ajqthYK
         JBAtnW8ETi4BIHDcoV4qyZOI5hhaMSsuliXHcymMHupy7iU7iAso5XAIZE6sa5EDgk
         pR8Zts5Q6fi7Cdgy+sFiihfBDa7VpVacVUNc6jHbLwA2+XuDDHwYvItl+Ml8pHsunV
         glNI0orcmHLb9AYS3aSF54SdXLJZDtJQNXTZmdjtDip3OH/I/Gbbc0H8V31eGKyn9M
         ywRnDo8L+I9XYl8UgnmARUD9jD8AcboYdr8PeI6Ibm1Jr2rcqXsXADgV1O/IULHK9W
         ZK2GH1OrAXf8g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E5CE3E49BBA;
        Tue, 28 Jun 2022 05:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] epic100: fix use after free on rmmod
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165639241493.25506.6577886408154853926.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Jun 2022 05:00:14 +0000
References: <20220627043351.25615-1-ztong0001@gmail.com>
In-Reply-To: <20220627043351.25615-1-ztong0001@gmail.com>
To:     Tong Zhang <ztong0001@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, f.fainelli@gmail.com, jgg@ziepe.ca,
        arnd@arndb.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yiluwu@cs.stonybrook.edu,
        romieu@fr.zoreil.com
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 26 Jun 2022 21:33:48 -0700 you wrote:
> epic_close() calls epic_rx() and uses dma buffer, but in epic_remove_one()
> we already freed the dma buffer. To fix this issue, reorder function calls
> like in the .probe function.
> 
> BUG: KASAN: use-after-free in epic_rx+0xa6/0x7e0 [epic100]
> Call Trace:
>  epic_rx+0xa6/0x7e0 [epic100]
>  epic_close+0xec/0x2f0 [epic100]
>  unregister_netdev+0x18/0x20
>  epic_remove_one+0xaa/0xf0 [epic100]
> 
> [...]

Here is the summary with links:
  - [v2] epic100: fix use after free on rmmod
    https://git.kernel.org/netdev/net/c/8ee9d82cd0a4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


