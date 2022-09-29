Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84F335EEBA3
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 04:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234470AbiI2CU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 22:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233931AbiI2CUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 22:20:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E07A1D19;
        Wed, 28 Sep 2022 19:20:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C80161F67;
        Thu, 29 Sep 2022 02:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6FC7DC433B5;
        Thu, 29 Sep 2022 02:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664418021;
        bh=CqP6AJQBgb3mLDY8tX8RWjFHzQtZGZK5lDjmqSz457Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jxWk6v5Ze0QvpoE73wtK36/dRnzL8GjGUNrU8TpMTWm4lo3rPFLDWHHwWntlXm1Bf
         zwzubAi+xqy50lByLS5Spj2NoK9l1v4OrzaDe8PGS8VMjs36AQueBm+CUueKtsiveF
         4eNtAajPYESx6utyzoaTcXyVgWhW4SVVDdLwvPvzGgVDUw1blcHveV/AlzGdVelXOO
         5NgYV4NRwrA8dezfB5NC/HdgIJg763M8c1peVPDYcBJXHIAFMTKfjxMw5qWNChz5Fk
         0trMS3n5BXHlAGmFXHD2HfF5+nr9dRTvu6VQVan0eG10zxJWSaHv7XPMWcPrGlfMlL
         UXDN+FP6zgN7w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 56BDAE21EC6;
        Thu, 29 Sep 2022 02:20:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] shrink struct ubuf_info
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166441802135.18961.14047192093792393033.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Sep 2022 02:20:21 +0000
References: <cover.1663892211.git.asml.silence@gmail.com>
In-Reply-To: <cover.1663892211.git.asml.silence@gmail.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        wei.liu@kernel.org, paul@xen.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, mst@redhat.com,
        jasowang@redhat.com
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

On Fri, 23 Sep 2022 17:39:00 +0100 you wrote:
> struct ubuf_info is large but not all fields are needed for all
> cases. We have limited space in io_uring for it and large ubuf_info
> prevents some struct embedding, even though we use only a subset
> of the fields. It's also not very clean trying to use this typeless
> extra space.
> 
> Shrink struct ubuf_info to only necessary fields used in generic paths,
> namely ->callback, ->refcnt and ->flags, which take only 16 bytes. And
> make MSG_ZEROCOPY and some other users to embed it into a larger struct
> ubuf_info_msgzc mimicking the former ubuf_info.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net: introduce struct ubuf_info_msgzc
    https://git.kernel.org/netdev/net-next/c/6eaab4dfdd30
  - [net-next,2/4] xen/netback: use struct ubuf_info_msgzc
    https://git.kernel.org/netdev/net-next/c/b63ca3e822e7
  - [net-next,3/4] vhost/net: use struct ubuf_info_msgzc
    https://git.kernel.org/netdev/net-next/c/dfff202be5ea
  - [net-next,4/4] net: shrink struct ubuf_info
    https://git.kernel.org/netdev/net-next/c/e7d2b510165f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


