Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E394E58DBC1
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 18:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236852AbiHIQUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 12:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244870AbiHIQUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 12:20:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55139E7D;
        Tue,  9 Aug 2022 09:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E91C561309;
        Tue,  9 Aug 2022 16:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 45B1BC433D7;
        Tue,  9 Aug 2022 16:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660062014;
        bh=ScEACFHLlKmH2umhHgKsjorXBX1s/jwBBv3ait+GCJM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gd+0JTLWdSDr1QAWnY2yZOr/xz/qgEsGQGGiFDTaFifk5SJSs9fOcqVFvgk9IW5xb
         /LGGFd7fPvFqNSgmxk8vrbZjv3/T7jeM42OL+5l8/C64BTWaG1p2saKNrCM7FRmFmv
         rEkVvoYJh+lDbloG6HsWTNoQQ/z6JZHKLWzw8XwSwHcR29V458YWlDuO8y/lGhhSNm
         QKmkQNl26KfpY4wVeJLftN5De0Xtq6kWxIoMAk3GlLkXasJ0Rn+UM6GuHNd74DrZmw
         2XZQ1ubBi8fzMFIHIOLQBTTxod7SJEdHtaL497tTxki40tVevXtBfZEVz4cGRCpxLD
         ARxcoAcICOPKg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2CD8CC43143;
        Tue,  9 Aug 2022 16:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v7 0/8] bpf: rstat: cgroup hierarchical stats
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166006201418.29142.16195047594672738404.git-patchwork-notify@kernel.org>
Date:   Tue, 09 Aug 2022 16:20:14 +0000
References: <20220805214821.1058337-1-haoluo@google.com>
In-Reply-To: <20220805214821.1058337-1-haoluo@google.com>
To:     Hao Luo <haoluo@google.com>
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        cgroups@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        andrii@kernel.org, daniel@iogearbox.net, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, tj@kernel.org,
        lizefan.x@bytedance.com, kpsingh@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, benjamin.tissoires@redhat.com,
        john.fastabend@gmail.com, mkoutny@suse.com,
        roman.gushchin@linux.dev, rientjes@google.com, sdf@google.com,
        shakeelb@google.com, yosryahmed@google.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri,  5 Aug 2022 14:48:13 -0700 you wrote:
> This patch series allows for using bpf to collect hierarchical cgroup
> stats efficiently by integrating with the rstat framework. The rstat
> framework provides an efficient way to collect cgroup stats percpu and
> propagate them through the cgroup hierarchy.
> 
> The stats are exposed to userspace in textual form by reading files in
> bpffs, similar to cgroupfs stats by using a cgroup_iter program.
> cgroup_iter is a type of bpf_iter. It walks over cgroups in four modes:
> - walking a cgroup's descendants in pre-order.
> - walking a cgroup's descendants in post-order.
> - walking a cgroup's ancestors.
> - process only a single object.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v7,1/8] btf: Add a new kfunc flag which allows to mark a function to be sleepable
    https://git.kernel.org/bpf/bpf-next/c/fa96b24204af
  - [bpf-next,v7,2/8] cgroup: enable cgroup_get_from_file() on cgroup1
    https://git.kernel.org/bpf/bpf-next/c/f3a2aebdd6fb
  - [bpf-next,v7,3/8] bpf, iter: Fix the condition on p when calling stop.
    https://git.kernel.org/bpf/bpf-next/c/be3bb83dab2d
  - [bpf-next,v7,4/8] bpf: Introduce cgroup iter
    (no matching commit)
  - [bpf-next,v7,5/8] selftests/bpf: Test cgroup_iter.
    (no matching commit)
  - [bpf-next,v7,6/8] cgroup: bpf: enable bpf programs to integrate with rstat
    (no matching commit)
  - [bpf-next,v7,7/8] selftests/bpf: extend cgroup helpers
    (no matching commit)
  - [bpf-next,v7,8/8] selftests/bpf: add a selftest for cgroup hierarchical stats collection
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


