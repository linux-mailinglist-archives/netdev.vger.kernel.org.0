Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB4F63FF7E
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 05:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbiLBEa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 23:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiLBEaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 23:30:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EDB3CEF99;
        Thu,  1 Dec 2022 20:30:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCD2CB820F3;
        Fri,  2 Dec 2022 04:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5A2D4C433D7;
        Fri,  2 Dec 2022 04:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669955422;
        bh=S9i9zp1uh0wQ3iE76BOu2N95OCSQY5GNhfgtNtD7u0c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZlOAHL1lQFq6yLzAWgfAjtqHIJvDIaDox+V3G4/KG8goUIw6atEWwpiy8NCCdL4JS
         lXXyp0SmXwkKOCsZKEPADqwf7WJ9hHUHzqUGAs9FqSswnct+UnM9q+cBSuPptuiFbC
         SswbJWPazdkn4lkXt/QYfVvlOtBxlWXv7GPzD41E6jpysmi7Uos15MjuzLVazqr0hu
         MyIXcprX2zowWXCrPUX0swsNcqByDxhmu3u/VvApnHbl+NEAUn0kSekXvUxWhOycNd
         tqNpqvsuajyhJPtvRJDBqvFpK/N4qNVtaSzgKrSjt6yS2O0mhEsOuaKWT4BJxaB1hk
         JQR6qwAg6CvPQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 19330C395EC;
        Fri,  2 Dec 2022 04:30:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] sctp: delete free member from struct sctp_sched_ops
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166995542208.28954.2692340404836658489.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Dec 2022 04:30:22 +0000
References: <e10aac150aca2686cb0bd0570299ec716da5a5c0.1669849471.git.lucien.xin@gmail.com>
In-Reply-To: <e10aac150aca2686cb0bd0570299ec716da5a5c0.1669849471.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, marcelo.leitner@gmail.com, nhorman@tuxdriver.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 30 Nov 2022 18:04:31 -0500 you wrote:
> After commit 9ed7bfc79542 ("sctp: fix memory leak in
> sctp_stream_outq_migrate()"), sctp_sched_set_sched() is the only
> place calling sched->free(), and it can actually be replaced by
> sched->free_sid() on each stream, and yet there's already a loop
> to traverse all streams in sctp_sched_set_sched().
> 
> This patch adds a function sctp_sched_free_sched() where it calls
> sched->free_sid() for each stream to replace sched->free() calls
> in sctp_sched_set_sched() and then deletes the unused free member
> from struct sctp_sched_ops.
> 
> [...]

Here is the summary with links:
  - [net-next] sctp: delete free member from struct sctp_sched_ops
    https://git.kernel.org/netdev/net-next/c/7d802c8098c5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


