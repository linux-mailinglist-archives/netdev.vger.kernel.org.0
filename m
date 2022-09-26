Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3E515EAFAB
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 20:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiIZSXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 14:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiIZSXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 14:23:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A16B36142;
        Mon, 26 Sep 2022 11:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AE2B6117D;
        Mon, 26 Sep 2022 18:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 90FE3C43470;
        Mon, 26 Sep 2022 18:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664216415;
        bh=viuqePXCGnH7z0k++m2z0uTaFEHkpA1vsPfVwaLgR7I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QYYt5/LcBESbTkKdBFTaXzlDkiZvVut12kEkF56tr4t9KPEV7igq7AVXjnScU+k/9
         9NO1U6x9cSHNtf072V5uVysAlvgAzKEcU16KCAOJd0z8az8MsyZibC8g7CrSDigfM3
         8ohL0BWTq/KFBQa7UhyXo4p7ZhxgeHQk2TaBUPvnuQRh6fkoTkf1U01J5DAyV0bj3Q
         NBm829ryDESmKkBkT+4QUuzioRMe9mRgQYkwfU2Ptq08P1/TSqUkqaW8ACd47uzlQ4
         +bPLSq+dXEVsdkO8Ne5bYQhQrrr9pdb5RFUKrcVIujC8JMlPpz9TEwJFqbRWah6F3D
         q1YKCA8kfpd7g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 765EDE21EC4;
        Mon, 26 Sep 2022 18:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next RESEND 1/2] udp: Refactor udp_read_skb()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166421641547.6513.16307057090337321581.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Sep 2022 18:20:15 +0000
References: <343b5d8090a3eb764068e9f1d392939e2b423747.1663909008.git.peilin.ye@bytedance.com>
In-Reply-To: <343b5d8090a3eb764068e9f1d392939e2b423747.1663909008.git.peilin.ye@bytedance.com>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com,
        peilin.ye@bytedance.com, cong.wang@bytedance.com,
        kuniyu@amazon.com, ast@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 22 Sep 2022 21:59:13 -0700 you wrote:
> From: Peilin Ye <peilin.ye@bytedance.com>
> 
> Delete the unnecessary while loop in udp_read_skb() for readability.
> Additionally, since recv_actor() cannot return a value greater than
> skb->len (see sk_psock_verdict_recv()), remove the redundant check.
> 
> Suggested-by: Cong Wang <cong.wang@bytedance.com>
> Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
> 
> [...]

Here is the summary with links:
  - [net-next,RESEND,1/2] udp: Refactor udp_read_skb()
    https://git.kernel.org/netdev/net-next/c/31f1fbcb346c
  - [net-next,RESEND,2/2] af_unix: Refactor unix_read_skb()
    https://git.kernel.org/netdev/net-next/c/d6e3b27cbd2d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


