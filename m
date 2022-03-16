Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A98E4DBAAC
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 23:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbiCPWbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 18:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbiCPWb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 18:31:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A5B13E88;
        Wed, 16 Mar 2022 15:30:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00D586163B;
        Wed, 16 Mar 2022 22:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 52DD6C340F2;
        Wed, 16 Mar 2022 22:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647469811;
        bh=91fkmxSb1pvQE9JDxQ8Dj/eCY9OVBFse3NUMi86SZY8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gMjMRxTwAvE4fRnH8acXfolPUT07RmGygxQBgFbfDSdXOEyxOwku7fCIo5j+b1aqo
         aq7yhzNXzCEs0gOEwP+sOaa0T5Kt5K3LToG209BO/4ZK/VRxaTmSIUGUEomJaxXrSd
         +Aop+58wJM8O/TwduSFevjYdsfEZLcvch9rObhC8cEF8AzNTDHuxDih2r6xBH2KTHq
         Cwhf2m3C4NkrOKJl+8CWJ+6Rb0uVSzeF7N9GcqJP43jARc9hcagJJolPqLLQ6QyE0u
         nvJGphbUeuOm2XBm54s2n51QFqg4+M39Ic01nS2QEjzvzabf7I+pEOWd+hHjFmdTS1
         AruYkRyi/QbMA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3621BF0383E;
        Wed, 16 Mar 2022 22:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next 0/4] fixes for bpf_jit_harden race
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164746981121.15463.13534885591917729201.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Mar 2022 22:30:11 +0000
References: <20220309123321.2400262-1-houtao1@huawei.com>
In-Reply-To: <20220309123321.2400262-1-houtao1@huawei.com>
To:     Hou Tao <houtao1@huawei.com>
Cc:     ast@kernel.org, kafai@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, yhs@fb.com, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 9 Mar 2022 20:33:17 +0800 you wrote:
> Hi,
> 
> Now bpf_jit_harden will be tested twice for each subprog if there are
> subprogs in bpf program and constant blinding may increase the length of
> program, so when running "./test_progs -t subprogs" and toggling
> bpf_jit_harden between 0 and 2, extra pass in bpf_int_jit_compile() may
> fail because constant blinding increases the length of subprog and
> the length is mismatched with the first pass.
> 
> [...]

Here is the summary with links:
  - [bpf-next,1/4] bpf, x86: Fall back to interpreter mode when extra pass fails
    https://git.kernel.org/bpf/bpf-next/c/73e14451f39e
  - [bpf-next,2/4] bpf: Introduce bpf_int_jit_abort()
    (no matching commit)
  - [bpf-next,3/4] bpf: Fix net.core.bpf_jit_harden race
    https://git.kernel.org/bpf/bpf-next/c/d2a3b7c5becc
  - [bpf-next,4/4] selftests/bpf: Test subprog jit when toggle bpf_jit_harden repeatedly
    https://git.kernel.org/bpf/bpf-next/c/ad13baf45691

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


