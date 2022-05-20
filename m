Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F350752F580
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 00:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353836AbiETWKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 18:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353796AbiETWKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 18:10:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E5061A075F;
        Fri, 20 May 2022 15:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A01D4B82E29;
        Fri, 20 May 2022 22:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5CA44C34115;
        Fri, 20 May 2022 22:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653084612;
        bh=clr5/eeqDOssSIb7q2BDlSM1acoinPQZnJpbFkRjumo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TvP2S582NxDvAdUUOztoxtb6+Sq6arO/UZX0OwrvX1hz6DHBni8C+xpp4bb3GEma/
         Bn7HLxdekdU43LVXsBviOS3pWP/hKPeptTOvmRE0csak7KcDhiCQMUeRCEuSAOfRkN
         NTvrTEFghdeWoarIGz3MiTaXKD1dL+yn0TsJCnYuN1mghhEI80g1FkZ9biMGZ+e4ba
         tmQUQX/JgdJ2vGFqlUifg13K5p679yA1D3ZRrs0tUSUUBuMK9qm8UY6YZgxSu4IunC
         3TS08TW4gsSTzXPEcFf5WFFQocV79RwjVHgjMYTwvoALuGutbQXlD1tv1X6eJ4subf
         VTTSrHw/rxClQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3B42AF03935;
        Fri, 20 May 2022 22:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2] selftests/bpf: fix some bugs in
 map_lookup_percpu_elem testcase
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165308461223.21331.279651299076160105.git-patchwork-notify@kernel.org>
Date:   Fri, 20 May 2022 22:10:12 +0000
References: <20220518025053.20492-1-zhoufeng.zf@bytedance.com>
In-Reply-To: <20220518025053.20492-1-zhoufeng.zf@bytedance.com>
To:     Feng Zhou <zhoufeng.zf@bytedance.com>
Cc:     shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, jolsa@kernel.org, davemarchevsky@fb.com,
        joannekoong@fb.com, geliang.tang@suse.com,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        duanxiongchun@bytedance.com, songmuchun@bytedance.com,
        wangdongdong.6@bytedance.com, cong.wang@bytedance.com,
        zhouchengming@bytedance.com, yosryahmed@google.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Andrii Nakryiko <andrii@kernel.org>:

On Wed, 18 May 2022 10:50:53 +0800 you wrote:
> From: Feng Zhou <zhoufeng.zf@bytedance.com>
> 
> comments from Andrii Nakryiko, details in here:
> https://lore.kernel.org/lkml/20220511093854.411-1-zhoufeng.zf@bytedance.com/T/
> 
> use /* */ instead of //
> use libbpf_num_possible_cpus() instead of sysconf(_SC_NPROCESSORS_ONLN)
> use 8 bytes for value size
> fix memory leak
> use ASSERT_EQ instead of ASSERT_OK
> add bpf_loop to fetch values on each possible CPU
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2] selftests/bpf: fix some bugs in map_lookup_percpu_elem testcase
    https://git.kernel.org/bpf/bpf-next/c/7aa424e02a04

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


