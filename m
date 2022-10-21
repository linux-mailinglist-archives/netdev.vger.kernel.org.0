Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 529B3607BCF
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 18:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbiJUQKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 12:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbiJUQKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 12:10:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960AA182C74;
        Fri, 21 Oct 2022 09:10:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71DD5B82C9C;
        Fri, 21 Oct 2022 16:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2A55DC433D7;
        Fri, 21 Oct 2022 16:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666368618;
        bh=nYztXilJidiwuNQXGMBogrDzoLmO1qqdokwpRA9JrZg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d64BIImt8+RKbGieSA+k1Gi1Pe350xYcc8exflCocjhoixI24Pc9dzHuguQp8i8LM
         DOUo3NBzrZiNqoqKxTWo9QE1tRR4/wiv/3fo0kgOPxCusTxvxnK962FGycrLYCl2Gf
         XzPlcNIK9bmG0nnJwa2nKviHpcIl5JQasDj0fPODqYp6tTfrn6VYe1H+ziEqOsM++i
         SJmsbM2Mq0x9PRNPE8BYEDS8RbzcjbUZQ6ZJrtxvqrlUpiaa7dmuqIyQAMjhWnK9mU
         cIlM/kkObg1fADlWGIExYMWWeqTSujpSER2fm6s1Ce66zNsho8J/Nj/2VHtib8tp+c
         4394N+5bNS02w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 08CF5E270DF;
        Fri, 21 Oct 2022 16:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [bpf-next v9 0/3] bpftool: Add autoattach for bpf prog load|loadall
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166636861803.30010.17887941246508343977.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Oct 2022 16:10:18 +0000
References: <1665736275-28143-1-git-send-email-wangyufen@huawei.com>
In-Reply-To: <1665736275-28143-1-git-send-email-wangyufen@huawei.com>
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     quentin@isovalent.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        sdf@google.com, haoluo@google.com, jolsa@kernel.org,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, trix@redhat.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 14 Oct 2022 16:31:12 +0800 you wrote:
> This patchset add "autoattach" optional for "bpftool prog load(_all)" to support
> one-step load-attach-pin_link.
> 
> v8 -> v9: fix link leak, and change pathname_concat(specify not just buffer
> 	  pointer, but also it's size)
> v7 -> v8: for the programs not supporting autoattach, fall back to reguler pinning
> 	  instead of skipping
> v6 -> v7: add info msg print and update doc for the skip program
> v5 -> v6: skip the programs not supporting auto-attach,
> 	  and change optional name from "auto_attach" to "autoattach"
> v4 -> v5: some formatting nits of doc
> v3 -> v4: rename functions, update doc, bash and do_help()
> v2 -> v3: switch to extend prog load command instead of extend perf
> v2: https://patchwork.kernel.org/project/netdevbpf/patch/20220824033837.458197-1-weiyongjun1@huawei.com/
> v1: https://patchwork.kernel.org/project/netdevbpf/patch/20220816151725.153343-1-weiyongjun1@huawei.com/
> 
> [...]

Here is the summary with links:
  - [bpf-next,v9,1/3] bpftool: Add autoattach for bpf prog load|loadall
    https://git.kernel.org/bpf/bpf-next/c/19526e701ea0
  - [bpf-next,v9,2/3] bpftool: Update doc (add autoattach to prog load)
    https://git.kernel.org/bpf/bpf-next/c/ff0e9a579ec9
  - [bpf-next,v9,3/3] bpftool: Update the bash completion(add autoattach to prog load)
    https://git.kernel.org/bpf/bpf-next/c/b81a67740075

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


