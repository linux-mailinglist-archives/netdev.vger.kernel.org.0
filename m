Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA9F660C3D
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 04:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236748AbjAGDkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 22:40:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236595AbjAGDkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 22:40:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456D6392FA;
        Fri,  6 Jan 2023 19:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2574B81F69;
        Sat,  7 Jan 2023 03:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A130AC43398;
        Sat,  7 Jan 2023 03:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673062816;
        bh=UpPvmBZ/3uKf6H9B1YivTCuwPZPhCdDuPzTR9p3eAh0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DT7+qx0hVXR2+wbBiTIeGD4lF0LROCBh/jtgLJ2u3MfC7ExL3diexmaWMLiD6pM9+
         mJ1sHsgiZdqBy5ypq/V4zhsf4u0w6UzNmO9X+uNgNv2sbRIVLLLSJ4LNJy+VLRTsDR
         aMOtAEL1GFqkUdwYVCrogyycJAuShdJ7qy7zyP7FfAbDTUgtAO7Iro8MOGPEnXd4Oo
         q9ig6D4QwhtM0hDaElfZI9+32ScU7KSv7wu8Rn7bGVMQ35LLmQ3MyohGLoUAf3FHRh
         CtcrfH/OWwfymOHDkJhjkE78XNdeVH5grCyPDq8zapU+6fPEnq6XNBSpgfPZ8UDv1h
         WujaBK6uEtVTg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 878AEE270ED;
        Sat,  7 Jan 2023 03:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ipv6: rpl_iptunnel: Replace 0-length arrays with
 flexible arrays
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167306281655.4583.686951198014366097.git-patchwork-notify@kernel.org>
Date:   Sat, 07 Jan 2023 03:40:16 +0000
References: <20230105221533.never.711-kees@kernel.org>
In-Reply-To: <20230105221533.never.711-kees@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  5 Jan 2023 14:15:37 -0800 you wrote:
> Zero-length arrays are deprecated[1]. Replace struct ipv6_rpl_sr_hdr's
> "segments" union of 0-length arrays with flexible arrays. Detected with
> GCC 13, using -fstrict-flex-arrays=3:
> 
> In function 'rpl_validate_srh',
>     inlined from 'rpl_build_state' at ../net/ipv6/rpl_iptunnel.c:96:7:
> ../net/ipv6/rpl_iptunnel.c:60:28: warning: array subscript <unknown> is outside array bounds of 'struct in6_addr[0]' [-Warray-bounds=]
>    60 |         if (ipv6_addr_type(&srh->rpl_segaddr[srh->segments_left - 1]) &
>       |                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from ../include/net/rpl.h:12,
>                  from ../net/ipv6/rpl_iptunnel.c:13:
> ../include/uapi/linux/rpl.h: In function 'rpl_build_state':
> ../include/uapi/linux/rpl.h:40:33: note: while referencing 'addr'
>    40 |                 struct in6_addr addr[0];
>       |                                 ^~~~
> 
> [...]

Here is the summary with links:
  - net: ipv6: rpl_iptunnel: Replace 0-length arrays with flexible arrays
    https://git.kernel.org/netdev/net-next/c/e8d283b6cf0e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


