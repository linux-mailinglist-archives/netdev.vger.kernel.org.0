Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A04A4D9FD5
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 17:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350019AbiCOQVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 12:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349052AbiCOQVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 12:21:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4696156C16;
        Tue, 15 Mar 2022 09:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D405B81772;
        Tue, 15 Mar 2022 16:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 22C17C340F4;
        Tue, 15 Mar 2022 16:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647361211;
        bh=ZilEAn8dlD9HKNmOu4TQz3vWQ2hPlOepo9zfB+DWwoY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Fed/iZdlm2FfdNqiJAaI0+T/BEfmLZ0wszt+qrx98C9tMBJbdwlk/4ec4rlvrnJ4c
         Co7q89+YyiJh/BcBcSAKG+9jhIOAOQTjq9FTlKSCu2WkFWUIZn9YLxboS1pz5zQRMT
         kLC7D8tv/6FlsPmSkHoVqgtsY3LJXICtjDsZtRhZQ7bQcDwND5VmxwVnNMzYYu1Er1
         qp5r2nggFyzSHOwvNqiHTF5LDC+6DWjbWKVjOWQJoVRiF7pG7WsFNfV/Lq3EtEiT1h
         B1MNA9NmnWs4DCQEF51Q6VKRj/OfndkXGUE0zLEcFA9CbLHHNK7HS2DNb9w47xbE8P
         77Eq8YuAvFpjg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F1DA4E6D44B;
        Tue, 15 Mar 2022 16:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] selftests/bpf: fix array_size.cocci warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164736121098.20903.8168794402759679622.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Mar 2022 16:20:10 +0000
References: <20220315130143.2403-1-guozhengkui@vivo.com>
In-Reply-To: <20220315130143.2403-1-guozhengkui@vivo.com>
To:     Guo Zhengkui <guozhengkui@vivo.com>
Cc:     shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        davemarchevsky@fb.com, sunyucong@gmail.com, christylee@fb.com,
        delyank@fb.com, toke@redhat.com, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhengkui_guo@outlook.com
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

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue, 15 Mar 2022 21:01:26 +0800 you wrote:
> Fix the array_size.cocci warning in tools/testing/selftests/bpf/
> 
> Use `ARRAY_SIZE(arr)` instead of forms like `sizeof(arr)/sizeof(arr[0])`.
> 
> tools/testing/selftests/bpf/test_cgroup_storage.c uses ARRAY_SIZE() defined
> in tools/include/linux/kernel.h (sys/sysinfo.h -> linux/kernel.h), while
> others use ARRAY_SIZE() in bpf_util.h.
> 
> [...]

Here is the summary with links:
  - [v3] selftests/bpf: fix array_size.cocci warning
    https://git.kernel.org/bpf/bpf-next/c/f98d6dd1e79d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


