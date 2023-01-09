Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB0FA661F5B
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 08:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233260AbjAIHka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 02:40:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233238AbjAIHkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 02:40:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D7612AE5;
        Sun,  8 Jan 2023 23:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD304B80D1A;
        Mon,  9 Jan 2023 07:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4BA77C433F1;
        Mon,  9 Jan 2023 07:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673250016;
        bh=TN07+vD/SnTIBZSHGqRC3RoFx+3nZk0Ja9sAyNZBimU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sCjHjg72NoNCkg67Awqex1+Il9Q0GkgKy5kLHFgoLa6qWqpQ2Yp8H0YrwK52xwxbf
         knMk6S5K0+f3Q4r/ZSPvN+y7f3nRAloQPX47yHb86KcquKtuEZD+BRS7Xx9GMotCqk
         zznVtKn2/4mQ5KdkApMcW/eyJXp7u4pOLFF7t2SpGLNg4kX09d+15+6Ags+XKDvdzc
         edukG8cMMg24uFO3L/G1JRfUplhse+hhfIQBRX6K7hqbhkiiIRk8U/8xkf9rUxp9jg
         htGLI+7gQZXIV64wlsDUUywglBomsFVWqfcVAqz/vZiUFrtedThL6/O3gcN1cmis6R
         U+i4v90locjsA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2B73EE21EEA;
        Mon,  9 Jan 2023 07:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mlxsw: spectrum_router: Replace 0-length array with flexible
 array
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167325001617.30057.7118452714297454499.git-patchwork-notify@kernel.org>
Date:   Mon, 09 Jan 2023 07:40:16 +0000
References: <20230105232224.never.150-kees@kernel.org>
In-Reply-To: <20230105232224.never.150-kees@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     idosch@nvidia.com, petrm@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        gustavoars@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
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

On Thu,  5 Jan 2023 15:22:29 -0800 you wrote:
> Zero-length arrays are deprecated[1]. Replace struct
> mlxsw_sp_nexthop_group_info's "nexthops" 0-length array with a flexible
> array. Detected with GCC 13, using -fstrict-flex-arrays=3:
> 
> drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c: In function 'mlxsw_sp_nexthop_group_hash_obj':
> drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:3278:38: warning: array subscript i is outside array bounds of 'struct mlxsw_sp_nexthop[0]' [-Warray-bounds=]
>  3278 |                         val ^= jhash(&nh->ifindex, sizeof(nh->ifindex), seed);
>       |                                      ^~~~~~~~~~~~
> drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:2954:33: note: while referencing 'nexthops'
>  2954 |         struct mlxsw_sp_nexthop nexthops[0];
>       |                                 ^~~~~~~~
> 
> [...]

Here is the summary with links:
  - mlxsw: spectrum_router: Replace 0-length array with flexible array
    https://git.kernel.org/netdev/net/c/2ab6478d1266

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


