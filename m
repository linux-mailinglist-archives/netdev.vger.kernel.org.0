Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E82650CDC7
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 23:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbiDWVnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 17:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiDWVnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 17:43:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2835DF66;
        Sat, 23 Apr 2022 14:40:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DD9A61118;
        Sat, 23 Apr 2022 21:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A4D57C385A9;
        Sat, 23 Apr 2022 21:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650750010;
        bh=m4LY2NLUTma2Fsk9bX9Jy0B0qFNEXbVzIk1njK/r90c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BRcmmVmRz9lXSQZtjb0W+bGsKQaUIiuDy5j//kCrquYUBtMJsXPLQWBkKk3yzQFUx
         mbxctzxi9UpAhuZ8GujJjJMm8iaowMDF8Kt2JUvRy62fHGJsIVCYaaQ97277rzAxiY
         OwNA6RjBo/BGNEqVpazX68Bp4x8Rshss/IPXi6jJmfZ55fHn2h2NP5BX+Y5l1if5Aj
         GchK6uKfT5Rcr0HLZZrdOMnauDT4ifUqFhndw2pNl1t4IUIpnnJxjHvHoSg1h/jh/M
         bLT9UFallvIB02TZZDCaUa1lNoG/yehuk2lYA4mVgmLYteV9wGSzdtccH50EIKfd8Y
         F/vKuu1uWDhsg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 85DB0E8DBD4;
        Sat, 23 Apr 2022 21:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sctp: check asoc strreset_chunk in
 sctp_generate_reconf_event
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165075001054.4343.8485395307076127833.git-patchwork-notify@kernel.org>
Date:   Sat, 23 Apr 2022 21:40:10 +0000
References: <3000f8b12920ae81b84dceead6dcc90bb00c0403.1650487961.git.lucien.xin@gmail.com>
In-Reply-To: <3000f8b12920ae81b84dceead6dcc90bb00c0403.1650487961.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, marcelo.leitner@gmail.com,
        nhorman@tuxdriver.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 20 Apr 2022 16:52:41 -0400 you wrote:
> A null pointer reference issue can be triggered when the response of a
> stream reconf request arrives after the timer is triggered, such as:
> 
>   send Incoming SSN Reset Request --->
>   CPU0:
>    reconf timer is triggered,
>    go to the handler code before hold sk lock
>                             <--- reply with Outgoing SSN Reset Request
>   CPU1:
>    process Outgoing SSN Reset Request,
>    and set asoc->strreset_chunk to NULL
>   CPU0:
>    continue the handler code, hold sk lock,
>    and try to hold asoc->strreset_chunk, crash!
> 
> [...]

Here is the summary with links:
  - [net] sctp: check asoc strreset_chunk in sctp_generate_reconf_event
    https://git.kernel.org/netdev/net/c/165e3e17fe8f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


