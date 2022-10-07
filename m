Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63D255F74DD
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 09:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiJGHuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 03:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJGHuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 03:50:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC74F6566F
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 00:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58A53B82273
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 07:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0F7E2C433C1;
        Fri,  7 Oct 2022 07:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665129016;
        bh=5++3S05RD0S3Au9xnAxUSkC4LKNSaKXirBIj/ykBn+c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jeAsY8PEcQR66IsW4TWItiHH6vrL1XRuiCxNAy0QneAQ2CBrVrL70nlyN2KRTLtgp
         5Ztc1m02UldZnmQ0ZE83h9z0P54PZ/46Vg82mwxKjTiJWt8mO3yqk7leKXkb8CVPW4
         EpDtOtT0/eKX3rM8YJgxEktZH1mhKu2A5jXnjF1fs0uDMtsAQj9MINvTPe//urgXq4
         OobM49gQX52r/4qQO1/XCcaBH0bU8WAGYery4av0nY+rL8gMl7OyqH0YZZPSfMyd+G
         370xzplCXa4uOfW9nu3lTAZrCvd99OItJJFq0mlN4RedV6vXenAbsuOrivRpSEFT91
         g5TXGY1Jb57nA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DE3E4E2A05D;
        Fri,  7 Oct 2022 07:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net] ipv4: Handle attempt to delete multipath route when
 fib_info contains an nh reference
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166512901590.847.15819501464797229185.git-patchwork-notify@kernel.org>
Date:   Fri, 07 Oct 2022 07:50:15 +0000
References: <20221006164849.9386-1-dsahern@kernel.org>
In-Reply-To: <20221006164849.9386-1-dsahern@kernel.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        netdev@vger.kernel.org, idosch@idosch.org, exsociety@gmail.com
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
by David S. Miller <davem@davemloft.net>:

On Thu,  6 Oct 2022 10:48:49 -0600 you wrote:
> Gwangun Jung reported a slab-out-of-bounds access in fib_nh_match:
>     fib_nh_match+0xf98/0x1130 linux-6.0-rc7/net/ipv4/fib_semantics.c:961
>     fib_table_delete+0x5f3/0xa40 linux-6.0-rc7/net/ipv4/fib_trie.c:1753
>     inet_rtm_delroute+0x2b3/0x380 linux-6.0-rc7/net/ipv4/fib_frontend.c:874
> 
> Separate nexthop objects are mutually exclusive with the legacy
> multipath spec. Fix fib_nh_match to return if the config for the
> to be deleted route contains a multipath spec while the fib_info
> is using a nexthop object.
> 
> [...]

Here is the summary with links:
  - [v3,net] ipv4: Handle attempt to delete multipath route when fib_info contains an nh reference
    https://git.kernel.org/netdev/net/c/61b91eb33a69

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


