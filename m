Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC23C6C1D83
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 18:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbjCTRPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 13:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233663AbjCTRP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 13:15:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 775867DB7;
        Mon, 20 Mar 2023 10:11:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91F3D6171D;
        Mon, 20 Mar 2023 17:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EACD9C4339B;
        Mon, 20 Mar 2023 17:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679332218;
        bh=AdWbRcFzE/2uJj7rERHEyavQ7IFjXu6nLUNbp/HSMh4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k2XY4fYsb+xvJM9i75WFa1FvzHLzaBMpr+K58NtS1hmpcXDbMnko5QKReKe7PJqhK
         +bGqHK+ppPokp75w8NRPWcTsuQos+9VgR79yKkdlkc/V6Pt3I2NbTF70WofuG+Xsso
         gYoY8qTp6xvdPIM6/z0EErhiXQqI4t33lCYttLi2bJNKUdzVe7WOOmPFH9/25rYikw
         Ihbx7i8ay7BuZwjUZpR/n+gLMyT4FYRB7ChhgcwhQLNeZquqhTs7XrZBX8Mbjw9sUk
         UbtIbNXtyWgE5wQf7TVroH1ujX6p7+pIMi9nuwVC+WZvn5P+RclowbqcllVEI866Bl
         Qftlkxhb44Opg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D0264E4F0D9;
        Mon, 20 Mar 2023 17:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next 1/2] libbpf: Fix ld_imm64 copy logic for ksym in
 light skeleton.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167933221784.21251.7059999522754844144.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Mar 2023 17:10:17 +0000
References: <20230319203014.55866-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20230319203014.55866-1-alexei.starovoitov@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, void@manifault.com, davemarchevsky@meta.com,
        tj@kernel.org, memxor@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
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
by Andrii Nakryiko <andrii@kernel.org>:

On Sun, 19 Mar 2023 13:30:13 -0700 you wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Unlike normal libbpf the light skeleton 'loader' program is doing
> btf_find_by_name_kind() call at run-time to find ksym in the kernel and
> populate its {btf_id, btf_obj_fd} pair in ld_imm64 insn. To avoid doing the
> search multiple times for the same ksym it remembers the first patched ld_imm64
> insn and copies {btf_id, btf_obj_fd} from it into subsequent ld_imm64 insn.
> Fix a bug in copying logic, since it may incorrectly clear BPF_PSEUDO_BTF_ID flag.
> 
> [...]

Here is the summary with links:
  - [bpf-next,1/2] libbpf: Fix ld_imm64 copy logic for ksym in light skeleton.
    https://git.kernel.org/bpf/bpf-next/c/a506d6ce1dd1
  - [bpf-next,2/2] selftest/bpf: Add a test case for ld_imm64 copy logic.
    https://git.kernel.org/bpf/bpf-next/c/bb4a6a923729

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


