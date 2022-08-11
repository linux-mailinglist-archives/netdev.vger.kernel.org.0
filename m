Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81D22590490
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238570AbiHKQck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 12:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238984AbiHKQbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 12:31:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BADD310FD;
        Thu, 11 Aug 2022 09:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06EFE61422;
        Thu, 11 Aug 2022 16:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 601BCC43143;
        Thu, 11 Aug 2022 16:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660234215;
        bh=iigHs5CKz4tUKOya26DgKcCC5RT3PcsM+dArmcfDSQ4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Nj/YE0EMcqSvG2GoUVb2LvW7c6fSOnyUELlVcesVL5s+ZoUPoAibdgTtJAXgcXh0v
         FeRw4CEt1Ox2CVEW5KPnbi+YxuE+b3CzsEDIzG8pf3G3wpBg46jZS5CAbTWzQ6nlxK
         0hRrLH6n3vZmfWuVlyrYPwZ2ujIOXUyXq5MBIEP0YZwtkGZ96L7V3Kdm10XPFi+tXp
         taVg26jZRP2IkGU+NOesHej7RHNWaBE+Yqrr5KoukgMYRoHNjtu1YsJzy2VJe/EG9J
         dDvWm7oFGttMiIU602lM22HgxaI11TFPuqvq+t9LwJhV3t+Wrqeq/BSzACmSwp2rXZ
         qmIxjP1mg4qNw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3E1D6C43147;
        Thu, 11 Aug 2022 16:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] nfp: fix use-after-free in area_cache_get()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166023421525.9507.12428200165169561355.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Aug 2022 16:10:15 +0000
References: <20220810073057.4032-1-wangjialiang0806@163.com>
In-Reply-To: <20220810073057.4032-1-wangjialiang0806@163.com>
To:     Jialiang Wang <wangjialiang0806@163.com>
Cc:     simon.horman@corigine.com, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, niejianglei2021@163.com,
        oss-drivers@corigine.com, netdev@vger.kernel.org,
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

On Wed, 10 Aug 2022 15:30:57 +0800 you wrote:
> area_cache_get() is used to distribute cache->area and set cache->id,
>  and if cache->id is not 0 and cache->area->kref refcount is 0, it will
>  release the cache->area by nfp_cpp_area_release(). area_cache_get()
>  set cache->id before cpp->op->area_init() and nfp_cpp_area_acquire().
> 
> But if area_init() or nfp_cpp_area_acquire() fails, the cache->id is
>  is already set but the refcount is not increased as expected. At this
>  time, calling the nfp_cpp_area_release() will cause use-after-free.
> 
> [...]

Here is the summary with links:
  - [v3] nfp: fix use-after-free in area_cache_get()
    https://git.kernel.org/netdev/net/c/02e1a114fdb7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


