Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 233C2629FFD
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 18:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbiKORKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 12:10:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiKORKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 12:10:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 201EC5580;
        Tue, 15 Nov 2022 09:10:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEABF61953;
        Tue, 15 Nov 2022 17:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 04B3CC433C1;
        Tue, 15 Nov 2022 17:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668532218;
        bh=L2O/E3koqdhzJACXM253As4jVBD2NyNxwg/yxsZEhOQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MHjK2LSwzkO6fZvJBHuXC/h4XSPqBQqbxw/koePcfi7NCSyPv74zWkepY4ThJTlk3
         RBRqXmLYzJs7HFg8zghFGjMrmZkOVtEYBzIAmUQb7iVqTXxXgLQi9hspJaWCscs63A
         x9wdezov3tLjWr1jwCuTjL6Y7gk5qGWs6UcPFWx1X7Mj8HBU2YFaF/ts0NqA0D4VDU
         FkWjDohlvb+jxvFfIsTN3jrn3zW4S58VwnvcPtYID5ahoptqDOx91AqNpz0LgYMFfm
         YLJZ5b8gPicCQBOkRkpo2oA3ONDxXScrJbBrvnjwowBuqo2JyaYwTHZ2hMPNf30rwK
         hVpj6+JZuVBtQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DA0FEE21EFA;
        Tue, 15 Nov 2022 17:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v3 0/3] A couple of small refactorings of BPF program
 call sites
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166853221788.31958.13418869641264991274.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Nov 2022 17:10:17 +0000
References: <20221108140601.149971-1-toke@redhat.com>
In-Reply-To: <20221108140601.149971-1-toke@redhat.com>
To:     =?utf-8?b?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIDx0b2tlQHJlZGhhdC5jb20+?=@ci.codeaurora.org
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
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

On Tue,  8 Nov 2022 15:05:58 +0100 you wrote:
> Stanislav suggested[0] that these small refactorings could be split out from the
> XDP queueing RFC series and merged separately. The first change is a small
> repacking of struct softnet_data, the others change the BPF call sites to
> support full 64-bit values as arguments to bpf_redirect_map() and as the return
> value of a BPF program, relying on the fact that BPF registers are always 64-bit
> wide to maintain backwards compatibility.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v3,1/3] dev: Move received_rps counter next to RPS members in softnet data
    https://git.kernel.org/bpf/bpf-next/c/14d898f3c1b3
  - [bpf-next,v3,2/3] bpf: Expand map key argument of bpf_redirect_map to u64
    https://git.kernel.org/bpf/bpf-next/c/32637e33003f
  - [bpf-next,v3,3/3] bpf: Use 64-bit return value for bpf_prog_run
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


