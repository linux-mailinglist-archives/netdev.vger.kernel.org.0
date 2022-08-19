Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6F885991AE
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 02:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236186AbiHSAUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 20:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiHSAUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 20:20:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E32CD50A;
        Thu, 18 Aug 2022 17:20:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 383ECB824C5;
        Fri, 19 Aug 2022 00:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C18F1C433B5;
        Fri, 19 Aug 2022 00:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660868418;
        bh=yx70KrwfnfCMvE+PDHRy6VHB/MeiZV40kvte15rPUAg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fAALv8eB67EUqcNOjbvie7p126L+9FtJWOslpdbMmE0LG9hvisG2PTVWp8Z6RPxdy
         r6/xfSkoqBqUv+UGswRMdVmRB5fFaPvcNsnsW/Ggjisz2yHzhqTqfBLgwBcn48m7bO
         Ve2/tdQejWHt6J7CS8Nb7Hzt9X3fT5MjuwkgMK3i/PACzptbQmgqS/GzJKiD7YyziS
         9+Kv5ekGyK206r1DIgWjYLfV9YXSuId7zijVip/0O58bR5S6wGahl72JOm3BRjjKxz
         Zluv6hHcSXzW7/gXx4zyittAOyCZURV6h6VOHT6wZn/HONGTn/CwMAgnLxMKO8Q3r7
         2UfX4yHLsgORQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A442CE2A05E;
        Fri, 19 Aug 2022 00:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 bpf-next 00/15] bpf: net: Remove duplicated code from
 bpf_setsockopt()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166086841866.5147.15942725423319277338.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Aug 2022 00:20:18 +0000
References: <20220817061704.4174272-1-kafai@fb.com>
In-Reply-To: <20220817061704.4174272-1-kafai@fb.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        andrii@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, kernel-team@fb.com,
        pabeni@redhat.com, sdf@google.com
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

This series was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Tue, 16 Aug 2022 23:17:04 -0700 you wrote:
> The code in bpf_setsockopt() is mostly a copy-and-paste from
> the sock_setsockopt(), do_tcp_setsockopt(), do_ipv6_setsockopt(),
> and do_ip_setsockopt().  As the allowed optnames in bpf_setsockopt()
> grows, so are the duplicated code.  The code between the copies
> also slowly drifted.
> 
> This set is an effort to clean this up and reuse the existing
> {sock,do_tcp,do_ipv6,do_ip}_setsockopt() as much as possible.
> 
> [...]

Here is the summary with links:
  - [v4,bpf-next,01/15] net: Add sk_setsockopt() to take the sk ptr instead of the sock ptr
    https://git.kernel.org/bpf/bpf-next/c/4d748f991607
  - [v4,bpf-next,02/15] bpf: net: Avoid sk_setsockopt() taking sk lock when called from bpf
    https://git.kernel.org/bpf/bpf-next/c/24426654ed3a
  - [v4,bpf-next,03/15] bpf: net: Consider has_current_bpf_ctx() when testing capable() in sk_setsockopt()
    https://git.kernel.org/bpf/bpf-next/c/e42c7beee71d
  - [v4,bpf-next,04/15] bpf: net: Change do_tcp_setsockopt() to use the sockopt's lock_sock() and capable()
    https://git.kernel.org/bpf/bpf-next/c/cb388e7ee3a8
  - [v4,bpf-next,05/15] bpf: net: Change do_ip_setsockopt() to use the sockopt's lock_sock() and capable()
    https://git.kernel.org/bpf/bpf-next/c/1df055d3c7d9
  - [v4,bpf-next,06/15] bpf: net: Change do_ipv6_setsockopt() to use the sockopt's lock_sock() and capable()
    https://git.kernel.org/bpf/bpf-next/c/40cd308ea57c
  - [v4,bpf-next,07/15] bpf: Initialize the bpf_run_ctx in bpf_iter_run_prog()
    https://git.kernel.org/bpf/bpf-next/c/2b5a2ecbfdc5
  - [v4,bpf-next,08/15] bpf: Embed kernel CONFIG check into the if statement in bpf_setsockopt
    https://git.kernel.org/bpf/bpf-next/c/ebf9e8e65366
  - [v4,bpf-next,09/15] bpf: Change bpf_setsockopt(SOL_SOCKET) to reuse sk_setsockopt()
    https://git.kernel.org/bpf/bpf-next/c/29003875bd5b
  - [v4,bpf-next,10/15] bpf: Refactor bpf specific tcp optnames to a new function
    https://git.kernel.org/bpf/bpf-next/c/57db31a1a3ad
  - [v4,bpf-next,11/15] bpf: Change bpf_setsockopt(SOL_TCP) to reuse do_tcp_setsockopt()
    https://git.kernel.org/bpf/bpf-next/c/0c751f7071ef
  - [v4,bpf-next,12/15] bpf: Change bpf_setsockopt(SOL_IP) to reuse do_ip_setsockopt()
    https://git.kernel.org/bpf/bpf-next/c/ee7f1e1302f5
  - [v4,bpf-next,13/15] bpf: Change bpf_setsockopt(SOL_IPV6) to reuse do_ipv6_setsockopt()
    https://git.kernel.org/bpf/bpf-next/c/75b64b68ee3f
  - [v4,bpf-next,14/15] bpf: Add a few optnames to bpf_setsockopt
    https://git.kernel.org/bpf/bpf-next/c/7e41df5dbba2
  - [v4,bpf-next,15/15] selftests/bpf: bpf_setsockopt tests
    https://git.kernel.org/bpf/bpf-next/c/31123c0360e0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


