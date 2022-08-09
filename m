Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E65758D290
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 06:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233327AbiHIEAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 00:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbiHIEAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 00:00:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86E1DE8;
        Mon,  8 Aug 2022 21:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A3A26116D;
        Tue,  9 Aug 2022 04:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9A4A1C433D7;
        Tue,  9 Aug 2022 04:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660017614;
        bh=YbaggHnkYCkQCElYHsuMP7gDnyd5an29AMsoniF8E78=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SnboNQ2sJTllcwCrdDnmiFayx3WhxgEsyTXEHDPOlGXaOp7NG9InhqueLAjdoJ9IY
         ZnJaWXJf9adpt21Xe+Ek9ZZhGjy5QhrskKBw3XBMFgqrFTgFz5onoz5kyqnx2t7i/h
         BA/u8K91JXzu8VQ+Wz058TWzOB0MostuZtH/AF6ekO85iGNMz2uhauclHOpidrYecT
         iosbLTn19Gth24GOFJyv+CyZEZfUmhTpXV0lXzwFxBg3BYmYO+wgnPOOY6f2gCGkFb
         wJG9pG5U3uGrL4hQecXmMWHyXqj98SBGUHHadHmzn6kr6mfy7dp3OQY53E6fPL1ydg
         0rvhYbm5OtbHQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7D8C9C43143;
        Tue,  9 Aug 2022 04:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] atm: idt77252: fix use-after-free bugs caused by tst_timer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166001761451.6286.6866647099440696539.git-patchwork-notify@kernel.org>
Date:   Tue, 09 Aug 2022 04:00:14 +0000
References: <20220805070008.18007-1-duoming@zju.edu.cn>
In-Reply-To: <20220805070008.18007-1-duoming@zju.edu.cn>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-atm-general@lists.sourceforge.net, 3chas3@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  5 Aug 2022 15:00:08 +0800 you wrote:
> There are use-after-free bugs caused by tst_timer. The root cause
> is that there are no functions to stop tst_timer in idt77252_exit().
> One of the possible race conditions is shown below:
> 
>     (thread 1)          |        (thread 2)
>                         |  idt77252_init_one
>                         |    init_card
>                         |      fill_tst
>                         |        mod_timer(&card->tst_timer, ...)
> idt77252_exit           |  (wait a time)
>                         |  tst_timer
>                         |
>                         |    ...
>   kfree(card) // FREE   |
>                         |    card->soft_tst[e] // USE
> 
> [...]

Here is the summary with links:
  - atm: idt77252: fix use-after-free bugs caused by tst_timer
    https://git.kernel.org/netdev/net/c/3f4093e2bf46

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


