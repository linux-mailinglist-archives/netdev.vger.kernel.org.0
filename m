Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCD3D540C78
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 20:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345525AbiFGShD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 14:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352067AbiFGSdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 14:33:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F3B15E4AF;
        Tue,  7 Jun 2022 10:57:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CCA1B81F38;
        Tue,  7 Jun 2022 17:57:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3F60FC3411C;
        Tue,  7 Jun 2022 17:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624637;
        bh=R2dVgNJ/3SDd5uqU6/UZP/No/vPIIEFEtOdqYoUkRB4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q00qZaAjdwluPok8IbCEk53hdTP6UvGmxfXDuDg3pl5hEs0FOI6OmyOOr2m2jey5d
         9XJmLFeTKNxgQAvH4RvQQ3DmPPsSj3tQK1v4DQv+TclmSAwzunI/vSZxGkKQwj3xae
         30K2JLsT4QaFiOS4p0P29+pZiFYvlKb2huWmkKFy2USzfH2A+3to3Q0Yn/TjNzWPdM
         8zmOZLIF3ASGBTfLI2nF65bECq7zjGvmPFvbx5MGS2NJIvWSTOQXevO2G9cffjx8zU
         lBxlU80nTToP7/x5wOp5G+fag/Eaj2h4tMb1CQrpMjaSY/q7EwzrqFapkl4ZdzzuAH
         B/MqqBzYq6omQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 20532E737FC;
        Tue,  7 Jun 2022 17:57:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf v2 1/2] bpf: Fix calling global functions from
 BPF_PROG_TYPE_EXT programs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165462463712.11355.13615369109121225276.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Jun 2022 17:57:17 +0000
References: <20220606075253.28422-1-toke@redhat.com>
In-Reply-To: <20220606075253.28422-1-toke@redhat.com>
To:     =?utf-8?b?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIDx0b2tlQHJlZGhhdC5jb20+?=@ci.codeaurora.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, memxor@gmail.com,
        simon.sundberg@kau.se, netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Mon,  6 Jun 2022 09:52:51 +0200 you wrote:
> The verifier allows programs to call global functions as long as their
> argument types match, using BTF to check the function arguments. One of the
> allowed argument types to such global functions is PTR_TO_CTX; however the
> check for this fails on BPF_PROG_TYPE_EXT functions because the verifier
> uses the wrong type to fetch the vmlinux BTF ID for the program context
> type. This failure is seen when an XDP program is loaded using
> libxdp (which loads it as BPF_PROG_TYPE_EXT and attaches it to a global XDP
> type program).
> 
> [...]

Here is the summary with links:
  - [bpf,v2,1/2] bpf: Fix calling global functions from BPF_PROG_TYPE_EXT programs
    https://git.kernel.org/bpf/bpf/c/f858c2b2ca04
  - [bpf,v2,2/2] selftests/bpf: Add selftest for calling global functions from freplace
    https://git.kernel.org/bpf/bpf/c/2cf7b7ffdae5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


