Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8C9767633A
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 04:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjAUDAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 22:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjAUDAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 22:00:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D18FF3F
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 19:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F6D062173
        for <netdev@vger.kernel.org>; Sat, 21 Jan 2023 03:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 65F1CC433D2;
        Sat, 21 Jan 2023 03:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674270017;
        bh=V5dd8daQ7OFOCxSi7WWWhQM4QcZIg3g7rZHJbzexRSc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HYZX4Nfotz9cMh8+5nxr7M92BDOxXmprZ6FcaqhvyDsWxQ12Y1SvOcvvDCq6pi1hr
         D3xg/js2mYHAD55giW5BwyAStVBUMGbs8eFe50iR4OjH0uzFgLsgR74Ber3pkiVt99
         i+kHGapb7TNREuuKN4JkGRiiu+oeKAdPuIn0tmUBsPqeIYDkOb/lQ3+hrr+/FfB3hy
         mpYAO5fosVg/uiFfb/ry95TrbCrdf787zp4wjabSfx2c07TdWkCvau4RgZuMWZURab
         t2M3oKytxRulou+kWwrPKntSpLWPfQMRiSQ18Zmw1HtSjs7j/ZqNp22GxQn7ERSISG
         8G3KvH8NVU8rw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 51AF8C395DC;
        Sat, 21 Jan 2023 03:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: fix UaF in netns ops registration error path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167427001733.13800.12531147943265395936.git-patchwork-notify@kernel.org>
Date:   Sat, 21 Jan 2023 03:00:17 +0000
References: <cec4e0f3bb2c77ac03a6154a8508d3930beb5f0f.1674154348.git.pabeni@redhat.com>
In-Reply-To: <cec4e0f3bb2c77ac03a6154a8508d3930beb5f0f.1674154348.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, edumazet@google.com, davem@davemloft.net,
        kuba@kernel.org, shaozhengchao@huawei.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 19 Jan 2023 19:55:45 +0100 you wrote:
> If net_assign_generic() fails, the current error path in ops_init() tries
> to clear the gen pointer slot. Anyway, in such error path, the gen pointer
> itself has not been modified yet, and the existing and accessed one is
> smaller than the accessed index, causing an out-of-bounds error:
> 
>  BUG: KASAN: slab-out-of-bounds in ops_init+0x2de/0x320
>  Write of size 8 at addr ffff888109124978 by task modprobe/1018
> 
> [...]

Here is the summary with links:
  - [net] net: fix UaF in netns ops registration error path
    https://git.kernel.org/netdev/net/c/71ab9c3e2253

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


