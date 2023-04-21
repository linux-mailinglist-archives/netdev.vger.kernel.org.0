Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89DAE6EA1A3
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 04:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233486AbjDUCaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 22:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232030AbjDUCaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 22:30:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89AAD2680
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 19:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 211BC64D1F
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 02:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 82D0CC433A4;
        Fri, 21 Apr 2023 02:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682044219;
        bh=Cjsv+uf+jtMN4iBu9PKCIMIMaTJ/a9ZRQMkq/Jd7cWw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qCiNM2JX0DHZ0pBymK5AxrNmD1qQO6RLwPePz3wF4haa2sxkr9l+rGvrvu2NMI1PY
         +0gSlnxAkhTVvtuUbYz1QVMa3c+NSLNIgYvTDZg0tFRQXAZ5IntDV5gvNDfdAWSHSZ
         VhaVdHOGvu1p80+3RQQlPTuzjSmRo9ki+r4ruU3C1HF+9UYNRHrgwk9YnjzsK829ER
         6bmb0O3b5WnM+rgivVx239KnZ4Fl//fbBbTVDWV6Q68qWUdNayf4w/yjADQ5AYnozF
         9tKDWbqu5YzeNOkVVR19U08tx1xcyKxw74xZ9nN6/kO2JQkt9hulFX1B8FCHWvLRqG
         qLovYluGYAqOA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6EC9EE501E3;
        Fri, 21 Apr 2023 02:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] page_pool: unlink from napi during destroy
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168204421944.9555.9530880882119320000.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Apr 2023 02:30:19 +0000
References: <20230419182006.719923-1-kuba@kernel.org>
In-Reply-To: <20230419182006.719923-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jbrouer@redhat.com, hawk@kernel.org,
        ilias.apalodimas@linaro.org, tariqt@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 19 Apr 2023 11:20:06 -0700 you wrote:
> Jesper points out that we must prevent recycling into cache
> after page_pool_destroy() is called, because page_pool_destroy()
> is not synchronized with recycling (some pages may still be
> outstanding when destroy() gets called).
> 
> I assumed this will not happen because NAPI can't be scheduled
> if its page pool is being destroyed. But I missed the fact that
> NAPI may get reused. For instance when user changes ring configuration
> driver may allocate a new page pool, stop NAPI, swap, start NAPI,
> and then destroy the old pool. The NAPI is running so old page
> pool will think it can recycle to the cache, but the consumer
> at that point is the destroy() path, not NAPI.
> 
> [...]

Here is the summary with links:
  - [net-next] page_pool: unlink from napi during destroy
    https://git.kernel.org/netdev/net-next/c/dd64b232deb8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


