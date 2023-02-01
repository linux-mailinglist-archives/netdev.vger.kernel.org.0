Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0738F68720B
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 00:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjBAXuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 18:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjBAXuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 18:50:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306B713DD7;
        Wed,  1 Feb 2023 15:50:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE6B3B821C8;
        Wed,  1 Feb 2023 23:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5ACF8C4339B;
        Wed,  1 Feb 2023 23:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675295417;
        bh=ZdgDvFkVnbmWnbwbWYR2gWCh8PAGZgIOoNtC+PHBQnE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bDf4qA4J6HGlnm+R7mCMtznGGTt/wumv7JHDQvJZ0o92vCJyXpke+Ue0M7umpgmbl
         zSUJm0uIc4T5/XwGWoeAjJG8htFvvx0aiKt39MWf4FAn52n30Q2oBsPaJAVYQWuSFm
         PgjhViRbPWoxGH68rOpxDXQBPFyOm4cEgvR7FJJupoOq6kkjKwwFPbSI1v6UiiIfp7
         3dq/92bwKLlsOvmS7xHdtRHD6kErQQePSP9f4eHdnmo4yTur8Py/JbMfrGYARUE4o4
         X2XlQZUCq3Adi+g7TGpwTx8OIzvn5QIPUNe4sQfc+o0gPkHCQtxIYEHyRA3vnLBG7f
         uyCrTrknz+HkQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 38884E21EEC;
        Wed,  1 Feb 2023 23:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next V1] selftests/bpf: fix unmap bug in
 prog_tests/xdp_metadata.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167529541722.452.2094492229750071530.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Feb 2023 23:50:17 +0000
References: <167527517464.938135.13750760520577765269.stgit@firesoul>
In-Reply-To: <167527517464.938135.13750760520577765269.stgit@firesoul>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, sdf@google.com, netdev@vger.kernel.org,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, dsahern@gmail.com,
        willemb@google.com, void@manifault.com, kuba@kernel.org,
        xdp-hints@xdp-project.net
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Wed, 01 Feb 2023 19:12:54 +0100 you wrote:
> The function close_xsk() unmap via munmap() the wrong memory pointer.
> 
> The call xsk_umem__delete(xsk->umem) have already freed xsk->umem.
> Thus the call to munmap(xsk->umem, UMEM_SIZE) will have unpredictable
> behavior that can lead to Segmentation fault elsewhere, as man page
> explain subsequent references to these pages will generate SIGSEGV.
> 
> [...]

Here is the summary with links:
  - [bpf-next,V1] selftests/bpf: fix unmap bug in prog_tests/xdp_metadata.c
    https://git.kernel.org/bpf/bpf-next/c/f2922f77a6a6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


