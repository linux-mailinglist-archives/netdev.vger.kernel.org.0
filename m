Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 254E458D291
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 06:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233941AbiHIEAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 00:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbiHIEAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 00:00:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7343E7A;
        Mon,  8 Aug 2022 21:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D559B81190;
        Tue,  9 Aug 2022 04:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 91DAAC433B5;
        Tue,  9 Aug 2022 04:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660017614;
        bh=0uHjm+KGcXAlJ7V6LXwNtiG4SVeDoNJSDLlk7EbtmWI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h9pGFWPb+hUeNR7eRF3hmP03hcVneB+7HEaCkkxDhbfCeWuxgUPDoIOs9xJ8ANI6t
         Uc0O3YbWZz9vT1PzadqJCQZp4UG3qu+iqHI3mCDLigXh+nIOa9ZlsUBzeWn2gIqDjz
         CrZ/qsd28oJGfzAZJNv+MuxS6xvauIeTtLM7AJHjSBfykx8JSudfZiXP8sSCKW5bQW
         f6pbwKZOhPWd2GlleTMcR9fwKx4CW//+/PocSzinSIkyi5TBuFcxLQlvSZcyaxfJVL
         cvkDJ5uCKKFBgzzLT791fOpp3hDG/qiAOBWCTA8PbrO3jGXltAOqu9YeescmAv6prH
         P5LEv0PVhg4KQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 753FAC43144;
        Tue,  9 Aug 2022 04:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/x25: fix call timeouts in blocking connects
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166001761447.6286.4599664715576942070.git-patchwork-notify@kernel.org>
Date:   Tue, 09 Aug 2022 04:00:14 +0000
References: <20220805061810.10824-1-ms@dev.tdt.de>
In-Reply-To: <20220805061810.10824-1-ms@dev.tdt.de>
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-x25@vger.kernel.org, netdev@vger.kernel.org,
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  5 Aug 2022 08:18:10 +0200 you wrote:
> When a userspace application starts a blocking connect(), a CALL REQUEST
> is sent, the t21 timer is started and the connect is waiting in
> x25_wait_for_connection_establishment(). If then for some reason the t21
> timer expires before any reaction on the assigned logical channel (e.g.
> CALL ACCEPT, CLEAR REQUEST), there is sent a CLEAR REQUEST and timer
> t23 is started waiting for a CLEAR confirmation. If we now receive a
> CLEAR CONFIRMATION from the peer, x25_disconnect() is called in
> x25_state2_machine() with reason "0", which means "normal" call
> clearing. This is ok, but the parameter "reason" is used as sk->sk_err
> in x25_disconnect() and sock_error(sk) is evaluated in
> x25_wait_for_connection_establishment() to check if the call is still
> pending. As "0" is not rated as an error, the connect will stuck here
> forever.
> 
> [...]

Here is the summary with links:
  - [net] net/x25: fix call timeouts in blocking connects
    https://git.kernel.org/netdev/net/c/944e594cfa84

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


