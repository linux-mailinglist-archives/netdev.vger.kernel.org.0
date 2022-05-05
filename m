Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A16051B6B8
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 05:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241748AbiEEDyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 23:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241715AbiEEDxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 23:53:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904FFDA9;
        Wed,  4 May 2022 20:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0AA861977;
        Thu,  5 May 2022 03:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 27EECC385B1;
        Thu,  5 May 2022 03:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651722614;
        bh=4dZ1A8x6z9o0xBW3mvbt9kERx1ptdza+ot3uRKX85RI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OINEX8NI+m2lY6VcIdMmGXP5yNQYrvaFkv7urohtnNjDBW0aWA+cj6gG+BBc3i1GP
         FFN88R4csBepant6j0jIZPS3L2NiKKB1HBgOdzVeRPzqIRNEE+aeg1vtdDrWPifriN
         hfKLpxlHiCYT8Con3AUFMziOpsTSmUeAazo06Glp+BItdUaBuBTgQXcDP+PYlbfLVF
         h9ikV4IJDCk38DKh3XhfBTrgKcB8OVioOP7LDWdflpEf8i/bCAN2kxXpG1jXCPt1oe
         jS2rolX5yyJnw11AMUXwgrrpv1D8rpnkjzLHrKXTBJQaugOHIUlPwY6Hbksz0VQEV2
         kvXTYPvWU3wgQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 07962F03877;
        Thu,  5 May 2022 03:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH memcg v2] memcg: accounting for objects allocated for new
 netdevice
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165172261402.3043.8768888843456379249.git-patchwork-notify@kernel.org>
Date:   Thu, 05 May 2022 03:50:14 +0000
References: <354a0a5f-9ec3-a25c-3215-304eab2157bc@openvz.org>
In-Reply-To: <354a0a5f-9ec3-a25c-3215-304eab2157bc@openvz.org>
To:     Vasily Averin <vvs@openvz.org>
Cc:     shakeelb@google.com, kernel@openvz.org, fw@strlen.de,
        linux-kernel@vger.kernel.org, roman.gushchin@linux.dev,
        vbabka@suse.cz, mhocko@suse.com, cgroups@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, mcgrof@kernel.org, keescook@chromium.org,
        yzaikin@google.com, linux-fsdevel@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 2 May 2022 15:15:51 +0300 you wrote:
> Creating a new netdevice allocates at least ~50Kb of memory for various
> kernel objects, but only ~5Kb of them are accounted to memcg. As a result,
> creating an unlimited number of netdevice inside a memcg-limited container
> does not fall within memcg restrictions, consumes a significant part
> of the host's memory, can cause global OOM and lead to random kills of
> host processes.
> 
> [...]

Here is the summary with links:
  - [memcg,v2] memcg: accounting for objects allocated for new netdevice
    https://git.kernel.org/netdev/net-next/c/425b9c7f51c9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


