Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DAEA58F2A9
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 21:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbiHJTAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 15:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbiHJTAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 15:00:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D190D4;
        Wed, 10 Aug 2022 12:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5F5EB81B5E;
        Wed, 10 Aug 2022 19:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7E676C433D6;
        Wed, 10 Aug 2022 19:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660158015;
        bh=k0Q5bajyKIBZrWFSLzKBSZvdrKWfsZKmcC5siRp1c0w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TV3qfwUGXag23WG4dxqwR9udyhw8A5M8Y1hupIx/CWwxuecwpuPF/1AezMKvZw/xI
         H57skQhMgF69xUG1dx2E8Cg87BLdchlBuHJrl+k3LczP/CRdql2jE3HJb7mXD46NRE
         DbB6l1R9iYbgLLuxcM3Bk8TuhppRdRNTz3zrq2hwoq0ZRqyK4Ft2PiQZgPhcF93kMw
         RKKvwKpFbwX2n21YoPEH4CgCX9qWWWZmRX5kM8nv++ZcjsMPHf0J2p5/6cGsX74deG
         VFXUGwz1p9TqSR36GYRVRWWk7Twi5HZck0sM2nVnvnbaLx2ibPHPifPjbftsZ5yQwz
         Ym66wL35EiJNA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 59FD6C43143;
        Wed, 10 Aug 2022 19:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next 00/15] bpf: Introduce selectable memcg for bpf map 
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166015801536.14189.14692203185396182235.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Aug 2022 19:00:15 +0000
References: <20220810151840.16394-1-laoar.shao@gmail.com>
In-Reply-To: <20220810151840.16394-1-laoar.shao@gmail.com>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org
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

On Wed, 10 Aug 2022 15:18:25 +0000 you wrote:
> On our production environment, we may load, run and pin bpf programs and
> maps in containers. For example, some of our networking bpf programs and
> maps are loaded and pinned by a process running in a container on our
> k8s environment. In this container, there're also running some other
> user applications which watch the networking configurations from remote
> servers and update them on this local host, log the error events, monitor
> the traffic, and do some other stuffs. Sometimes we may need to update
> these user applications to a new release, and in this update process we
> will destroy the old container and then start a new genration. In order not
> to interrupt the bpf programs in the update process, we will pin the bpf
> programs and maps in bpffs. That is the background and use case on our
> production environment.
> 
> [...]

Here is the summary with links:
  - [bpf-next,01/15] bpf: Remove unneeded memset in queue_stack_map creation
    https://git.kernel.org/bpf/bpf-next/c/083818156d1e
  - [bpf-next,02/15] bpf: Use bpf_map_area_free instread of kvfree
    https://git.kernel.org/bpf/bpf-next/c/8f58ee54c2ea
  - [bpf-next,03/15] bpf: Make __GFP_NOWARN consistent in bpf map creation
    https://git.kernel.org/bpf/bpf-next/c/992c9e13f593
  - [bpf-next,04/15] bpf: Use bpf_map_area_alloc consistently on bpf map creation
    https://git.kernel.org/bpf/bpf-next/c/73cf09a36bf7
  - [bpf-next,05/15] bpf: Fix incorrect mem_cgroup_put
    (no matching commit)
  - [bpf-next,06/15] bpf: Define bpf_map_{get,put}_memcg for !CONFIG_MEMCG_KMEM
    (no matching commit)
  - [bpf-next,07/15] bpf: Call bpf_map_init_from_attr() immediately after map creation
    (no matching commit)
  - [bpf-next,08/15] bpf: Save memcg in bpf_map_init_from_attr()
    (no matching commit)
  - [bpf-next,09/15] bpf: Use scoped-based charge in bpf_map_area_alloc
    (no matching commit)
  - [bpf-next,10/15] bpf: Introduce new helpers bpf_ringbuf_pages_{alloc,free}
    (no matching commit)
  - [bpf-next,11/15] bpf: Use bpf_map_kzalloc in arraymap
    (no matching commit)
  - [bpf-next,12/15] bpf: Use bpf_map_kvcalloc in bpf_local_storage
    (no matching commit)
  - [bpf-next,13/15] mm, memcg: Add new helper get_obj_cgroup_from_cgroup
    (no matching commit)
  - [bpf-next,14/15] bpf: Add return value for bpf_map_init_from_attr
    (no matching commit)
  - [bpf-next,15/15] bpf: Introduce selectable memcg for bpf map
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


