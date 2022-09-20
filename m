Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 350405BF0FF
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 01:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbiITXUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 19:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbiITXUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 19:20:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D956FA04;
        Tue, 20 Sep 2022 16:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 804A8B82D81;
        Tue, 20 Sep 2022 23:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3EE19C433B5;
        Tue, 20 Sep 2022 23:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663716018;
        bh=jSDU7z+DfMk994+rWCGyS11qd9s+VKIKfL5H3gFC1+s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rxkNtW+4kOozbxITd0msNqPliRKpY00SFmcsLlHmPlThOFfMmtArcd1gaJvAYx7kl
         DLavtX146xPwd554SXe19t/X5UBVrH4CwwUPUU8JsD2mSPOj+VxmzJqVhzPPrTKECB
         0FwliItjCBDpBahT/5i4J+Wwdu3giRnwa+NoMS8yd0M1DHirLhc/3HC3cvxQsm0PFq
         m0LkNCo/osTjuTflucm74uWxNtYBo1uiPEFX3EcZ4xxcGHEVXRnl0o3cev5vTKiAJA
         08HiZ9Ev07ZEP/wYg/BOiFrg8nKSqxK0GS5Qw1yR20cGEnCIIJtoDdYkm2/FvsKOld
         RRfH8eCLKsLCQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1BE50E21EE2;
        Tue, 20 Sep 2022 23:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next,v4 0/9] refactor duplicate codes in the tc cls walk
 function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166371601810.30252.3169134367339015145.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 23:20:18 +0000
References: <20220916020251.190097-1-shaozhengchao@huawei.com>
In-Reply-To: <20220916020251.190097-1-shaozhengchao@huawei.com>
To:     shaozhengchao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        shuah@kernel.org, victor@mojatatu.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, weiyongjun1@huawei.com, yuehaibing@huawei.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 16 Sep 2022 10:02:42 +0800 you wrote:
> The walk implementation of most tc cls modules is basically the same.
> That is, the values of count and skip are checked first. If count is
> greater than or equal to skip, the registered fn function is executed.
> Otherwise, increase the value of count. So the code can be refactored.
> Then use helper function to replace the code of each cls module in
> alphabetical order.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/9] net/sched: cls_api: add helper for tc cls walker stats dump
    https://git.kernel.org/netdev/net-next/c/fe0df81df51e
  - [net-next,v4,2/9] net/sched: use tc_cls_stats_dump() in filter
    https://git.kernel.org/netdev/net-next/c/5508ff7cf375
  - [net-next,v4,3/9] selftests/tc-testings: add selftests for bpf filter
    https://git.kernel.org/netdev/net-next/c/93f3f2eaa4c9
  - [net-next,v4,4/9] selftests/tc-testings: add selftests for cgroup filter
    https://git.kernel.org/netdev/net-next/c/33c411927615
  - [net-next,v4,5/9] selftests/tc-testings: add selftests for flow filter
    https://git.kernel.org/netdev/net-next/c/58f82b3a0b05
  - [net-next,v4,6/9] selftests/tc-testings: add selftests for route filter
    https://git.kernel.org/netdev/net-next/c/67107e7fcfbe
  - [net-next,v4,7/9] selftests/tc-testings: add selftests for rsvp filter
    https://git.kernel.org/netdev/net-next/c/23020350eb6a
  - [net-next,v4,8/9] selftests/tc-testings: add selftests for tcindex filter
    https://git.kernel.org/netdev/net-next/c/fa8dfba59e78
  - [net-next,v4,9/9] selftests/tc-testings: add list case for basic filter
    https://git.kernel.org/netdev/net-next/c/972e88611240

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


