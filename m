Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13FEC6E02DE
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 01:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbjDLXv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 19:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbjDLXvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 19:51:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36878A75;
        Wed, 12 Apr 2023 16:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65FD263A30;
        Wed, 12 Apr 2023 23:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C5FF9C4339B;
        Wed, 12 Apr 2023 23:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681343418;
        bh=angAFoe+U5xzPv6FtCzpncMETyYAO11hbIA8vnTdZOA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IHB3h4vaPOl8b9jSXH/HAj7zOEPnH5Gnov1QPGis+NGLPdC7Xod8E1xGszrwtldw2
         7ReDWaAgHkQ81m8cJM+c9SaafoWUBoWQefs2rDrj4MT8z/9LO5e/5n/R1iTryBQA0a
         7R3BCC3PE3xvG8ymIqXmOg0deK8sceZGw++QrzTlhRQ2F8QG7mrQsLKKgD2Fl63TJk
         eRUowQJwheaqoaB5zo86LOKjtZziNk0dt3IDWGXNrgqlv2RjPZRWyDmtIOJWffIO77
         R/0N3CkZ2Q2Ttb6CUP1Xomu5P/KW61xKVxQ8bxeJ5zNFvuor9KeZee0/BcrODb2Ees
         /V11XXnFTW9Yw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AD618E52446;
        Wed, 12 Apr 2023 23:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v3 0/3] Add FOU support for externally controlled
 ipip devices
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168134341870.18395.11210740779039610735.git-patchwork-notify@kernel.org>
Date:   Wed, 12 Apr 2023 23:50:18 +0000
References: <cover.1680874078.git.cehrig@cloudflare.com>
In-Reply-To: <cover.1680874078.git.cehrig@cloudflare.com>
To:     Christian Ehrig <cehrig@cloudflare.com>
Cc:     bpf@vger.kernel.org, kernel-team@cloudflare.com, ast@kernel.org,
        andrii@kernel.org, daniel@iogearbox.net, davemarchevsky@fb.com,
        void@manifault.com, liuhangbin@gmail.com, haoluo@google.com,
        jolsa@kernel.org, john.fastabend@gmail.com,
        fankaixi.li@bytedance.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        martin.lau@linux.dev, mykolal@fb.com, netdev@vger.kernel.org,
        paul@isovalent.com, song@kernel.org, sdf@google.com, yhs@fb.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Fri,  7 Apr 2023 15:38:52 +0200 you wrote:
> This patch set adds support for using FOU or GUE encapsulation with
> an ipip device operating in collect-metadata mode and a set of kfuncs
> for controlling encap parameters exposed to a BPF tc-hook.
> 
> BPF tc-hooks allow us to read tunnel metadata (like remote IP addresses)
> in the ingress path of an externally controlled tunnel interface via
> the bpf_skb_get_tunnel_{key,opt} bpf-helpers. Packets can then be
> redirected to the same or a different externally controlled tunnel
> interface by overwriting metadata via the bpf_skb_set_tunnel_{key,opt}
> helpers and a call to bpf_redirect. This enables us to redirect packets
> between tunnel interfaces - and potentially change the encapsulation
> type - using only a single BPF program.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v3,1/3] ipip,ip_tunnel,sit: Add FOU support for externally controlled ipip devices
    https://git.kernel.org/bpf/bpf-next/c/ac931d4cdec3
  - [bpf-next,v3,2/3] bpf,fou: Add bpf_skb_{set,get}_fou_encap kfuncs
    https://git.kernel.org/bpf/bpf-next/c/c50e96099edb
  - [bpf-next,v3,3/3] selftests/bpf: Test FOU kfuncs for externally controlled ipip devices
    https://git.kernel.org/bpf/bpf-next/c/d9688f898c08

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


