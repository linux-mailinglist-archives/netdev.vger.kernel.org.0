Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 270B667907E
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 06:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbjAXFxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 00:53:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232183AbjAXFxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 00:53:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295C23CE3E
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 21:52:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA44BB81084
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 05:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3EA45C433AF;
        Tue, 24 Jan 2023 05:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674539418;
        bh=Wq3UP2ojC0GcVaVt3+nomR7kTJuomYcGwkgun97IfEg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eUpeSBFwq5jYf+xMeX6Yg63a8Apgw5RPwqvluCtM4HftJx7kGV2ZstMc/pNIZ0Vi6
         /H+5bLpPL6g5Md4oUZVLlO5t7dWN3sohLG5qvogP0O2NpvbXm9+kkXusaGT+vGrMEa
         unZTy4SfUXTqcJzuC/MYb9K7qAuOAaA2/JGO3kN3YDUcx99fAXEugXpBYTryFeHaYi
         frB0XQv/LeVderngKlPql83t+mz0Xlk/wP/68Et22E1YTvqz7urn67ISJPkCZ010vB
         wfy1h70Sq4bpqxLeUJ2yQLucTN43BjctDSlh12Gl+6EVl1rspKDhYQwvJFAPckehED
         Dc+sqfSA7Ip9g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 29DA5C04E33;
        Tue, 24 Jan 2023 05:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next V2] net: fix kfree_skb_list use of
 skb_mark_not_on_list
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167453941816.4419.3173739226608329808.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Jan 2023 05:50:18 +0000
References: <167421088417.1125894.9761158218878962159.stgit@firesoul>
In-Reply-To: <167421088417.1125894.9761158218878962159.stgit@firesoul>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com,
        syzbot+c8a2e66e37eee553c4fd@syzkaller.appspotmail.com
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

On Fri, 20 Jan 2023 11:34:44 +0100 you wrote:
> A bug was introduced by commit eedade12f4cb ("net: kfree_skb_list use
> kmem_cache_free_bulk"). It unconditionally unlinked the SKB list via
> invoking skb_mark_not_on_list().
> 
> In this patch we choose to remove the skb_mark_not_on_list() call as it
> isn't necessary. It would be possible and correct to call
> skb_mark_not_on_list() only when __kfree_skb_reason() returns true,
> meaning the SKB is ready to be free'ed, as it calls/check skb_unref().
> 
> [...]

Here is the summary with links:
  - [net-next,V2] net: fix kfree_skb_list use of skb_mark_not_on_list
    https://git.kernel.org/netdev/net-next/c/f72ff8b81ebc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


