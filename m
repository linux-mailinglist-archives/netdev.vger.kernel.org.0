Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B63DE52AFA7
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 03:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233265AbiERBKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 21:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233249AbiERBKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 21:10:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9514439827;
        Tue, 17 May 2022 18:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EA60FCE1B93;
        Wed, 18 May 2022 01:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3028FC34117;
        Wed, 18 May 2022 01:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652836211;
        bh=Mlf+JQxtcblO8vpAyrXONR6+01PBr+ZZX3N++M427so=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tLH9Qq5+1wXfiIgl37G67W1Nw9OF6T+evhcCOZpp/5qe4yM2xnkHjyUwxCwDtvNVJ
         sUMSgIkknPd4jZGR1bMI9BFXo31J6Wan6A5FdUcGV98rlzxd6ZQwNBLeL2kmmCJoMM
         lytQZ1BlLHR0eWyK+473yZduMlEEr/22qYwZAhCgZh425072kUcUAvBfTEMuvDLahR
         e2+1DIu4ErzH26EgfnFkPl0EC4cYxCa9aqLetmE9DWg5lgOrPqMI5pdtiY1DrAsAoa
         basjqzGc024kIVqZA0SzXugKRlLRhb1fTToHCCtLD0YFWFSOEl1OdKOE6j/K42pQFp
         GdQ2NVj8juEBw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 162B6F0389D;
        Wed, 18 May 2022 01:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] NFC: nci: fix sleep in atomic context bugs caused by
 nci_skb_alloc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165283621108.1572.15945498055980926666.git-patchwork-notify@kernel.org>
Date:   Wed, 18 May 2022 01:10:11 +0000
References: <20220517012530.75714-1-duoming@zju.edu.cn>
In-Reply-To: <20220517012530.75714-1-duoming@zju.edu.cn>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-kernel@vger.kernel.org, kuba@kernel.org,
        krzysztof.kozlowski@linaro.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, gregkh@linuxfoundation.org,
        alexander.deucher@amd.com, broonie@kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 17 May 2022 09:25:30 +0800 you wrote:
> There are sleep in atomic context bugs when the request to secure
> element of st-nci is timeout. The root cause is that nci_skb_alloc
> with GFP_KERNEL parameter is called in st_nci_se_wt_timeout which is
> a timer handler. The call paths that could trigger bugs are shown below:
> 
>     (interrupt context 1)
> st_nci_se_wt_timeout
>   nci_hci_send_event
>     nci_hci_send_data
>       nci_skb_alloc(..., GFP_KERNEL) //may sleep
> 
> [...]

Here is the summary with links:
  - [net,v2] NFC: nci: fix sleep in atomic context bugs caused by nci_skb_alloc
    https://git.kernel.org/netdev/net/c/23dd4581350d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


