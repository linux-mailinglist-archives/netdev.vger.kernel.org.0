Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D30D626311
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 21:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234177AbiKKUkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 15:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231840AbiKKUkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 15:40:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 583BE845E7;
        Fri, 11 Nov 2022 12:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0229EB827DA;
        Fri, 11 Nov 2022 20:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C47FC433D7;
        Fri, 11 Nov 2022 20:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668199215;
        bh=MGPnWxh4tvBV+1Xxqjdq4EQiObbEg9pDz4uCpUSJLNo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mRuuOmyXMHI1QHMbT3zpN17jMVaLaBPt6FvdljFLSd3lcCIyh4UgGWWchn+qS2CcU
         04ZTzYEHH+4kRUavuFE8eQs2CxbqZrK5XgUt91ATkJULZRxgI/ZtZWzaabMUoLTZIJ
         jRjDz/6nZXGFQ6EcBSHAP6ssihzHTh0Pfaxz46Br5tfBDgZB+ohoTcsqeQfnlpdbe7
         N84if0ljui7fqzZJQ3Ojy/SIX5UQXoF7jpsAT2TM4Dd+STr0edSTwVVsH6+8rpXNzV
         bJ8HVjN4w/YXUWf1xed3S/6aQPwTvfLNJ+izjQTRoxyMbEMnMoPxaIDxI+sE2zRSMX
         wiQcB0bN6dl+w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 61F68E270EF;
        Fri, 11 Nov 2022 20:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf v2] selftests/bpf: Fix xdp_synproxy compilation failure in
 32-bit arch
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166819921539.1528.5255567846899299026.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Nov 2022 20:40:15 +0000
References: <20221111030836.37632-1-yangjihong1@huawei.com>
In-Reply-To: <20221111030836.37632-1-yangjihong1@huawei.com>
To:     Yang Jihong <yangjihong1@huawei.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, mykolal@fb.com, shuah@kernel.org,
        tariqt@nvidia.com, maximmi@nvidia.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by Andrii Nakryiko <andrii@kernel.org>:

On Fri, 11 Nov 2022 11:08:36 +0800 you wrote:
> xdp_synproxy fails to be compiled in the 32-bit arch, log is as follows:
> 
>   xdp_synproxy.c: In function 'parse_options':
>   xdp_synproxy.c:175:36: error: left shift count >= width of type [-Werror=shift-count-overflow]
>     175 |                 *tcpipopts = (mss6 << 32) | (ttl << 24) | (wscale << 16) | mss4;
>         |                                    ^~
>   xdp_synproxy.c: In function 'syncookie_open_bpf_maps':
>   xdp_synproxy.c:289:28: error: cast from pointer to integer of different size [-Werror=pointer-to-int-cast]
>     289 |                 .map_ids = (__u64)map_ids,
>         |                            ^
> 
> [...]

Here is the summary with links:
  - [bpf,v2] selftests/bpf: Fix xdp_synproxy compilation failure in 32-bit arch
    https://git.kernel.org/bpf/bpf-next/c/e4c9cf0ce8c4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


