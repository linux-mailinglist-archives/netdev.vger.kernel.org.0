Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6CA862D806
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 11:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234808AbiKQKaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 05:30:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233899AbiKQKa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 05:30:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A0B61EACA
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 02:30:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5603B81FE9
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 10:30:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6D250C4347C;
        Thu, 17 Nov 2022 10:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668681025;
        bh=Vg7quE/8x4Ta4nHFOBMva1wXp3agpIaJsxJXQPjdAGs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gQEG0F+DsuXOcMturtrqqfD9Q7juq0r6jwroDXaFC7DbfvsbTrAaiKifH751Zxens
         MkNhbD3elQP41vnNWGB0oZCn0XQp7goU5dol7f4l2emEPvQddTIXqNvU3PE4TX/yIP
         9QP6GrEYMGY3xXAU9ZWOEqpVpSndCuCuOrAnpRxhvtYMcKr/ZR32gvPJ0mg6PPMnTq
         w+SuEpTBELF86R7C9eFJWqj1vvNP8mYqcZ+/unLFqaT9QZEfHCcTwPi+nfn3M+KSx4
         alK7H6NE2k/anOuAxyqqmO+i7wAV8nnH+oVCKKKT8/wGn8XuCJl5gVZ+iuwy50tixK
         kCBnKTE0fukkA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4B4BEE29F45;
        Thu, 17 Nov 2022 10:30:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv3 net] net: use struct_group to copy ip/ipv6 header addresses
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166868102530.4691.12181309882001372822.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Nov 2022 10:30:25 +0000
References: <20221115142400.1204786-1-liuhangbin@gmail.com>
In-Reply-To: <20221115142400.1204786-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com, davem@davemloft.net,
        kuba@kernel.org, jtoppins@redhat.com, pabeni@redhat.com,
        dsahern@gmail.com, tom@herbertland.com, edumazet@google.com,
        lkp@intel.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 15 Nov 2022 22:24:00 +0800 you wrote:
> kernel test robot reported warnings when build bonding module with
> make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/net/bonding/:
> 
>                  from ../drivers/net/bonding/bond_main.c:35:
> In function ‘fortify_memcpy_chk’,
>     inlined from ‘iph_to_flow_copy_v4addrs’ at ../include/net/ip.h:566:2,
>     inlined from ‘bond_flow_ip’ at ../drivers/net/bonding/bond_main.c:3984:3:
> ../include/linux/fortify-string.h:413:25: warning: call to ‘__read_overflow2_field’ declared with attribute warning: detected read beyond size of f
> ield (2nd parameter); maybe use struct_group()? [-Wattribute-warning]
>   413 |                         __read_overflow2_field(q_size_field, size);
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In function ‘fortify_memcpy_chk’,
>     inlined from ‘iph_to_flow_copy_v6addrs’ at ../include/net/ipv6.h:900:2,
>     inlined from ‘bond_flow_ip’ at ../drivers/net/bonding/bond_main.c:3994:3:
> ../include/linux/fortify-string.h:413:25: warning: call to ‘__read_overflow2_field’ declared with attribute warning: detected read beyond size of f
> ield (2nd parameter); maybe use struct_group()? [-Wattribute-warning]
>   413 |                         __read_overflow2_field(q_size_field, size);
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> [...]

Here is the summary with links:
  - [PATCHv3,net] net: use struct_group to copy ip/ipv6 header addresses
    https://git.kernel.org/netdev/net/c/58e0be1ef611

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


