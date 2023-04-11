Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6D056DE414
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 20:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbjDKSkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 14:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjDKSkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 14:40:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A063955BB;
        Tue, 11 Apr 2023 11:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C93162AE1;
        Tue, 11 Apr 2023 18:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 63474C4339B;
        Tue, 11 Apr 2023 18:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681238418;
        bh=EjKgf2PTCczgYBkSi2vxGlcp9usrVW2XMZByy441xuc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AMnVIsM36I8/GWgy1z6Qr2j2pErNx/CpftijK2ABaEbrA/YLacoA1zqUtKhZuMPuU
         M/j1jEa0ggQtWtONh0B1KSzbbeG5cCQ/xJyQI8PJDq+SjwDXXSwWYWyAyg1E1++dBt
         13Y22U5BUsN0bV2H9S9BJycgu5gcGmspgSP/7rJW0KMYG3Ac5lxSwtAfn1RsaccOrj
         mDHU+0yGwn6C6x6xu/jlMCzdw/h56TUZDWf2wBoVexvw2Za5HhapBic5aIc/EWJMA4
         9ORK0LhP5FG7NddahxYFRhc0rh8BaGTraI80WWdVDCkXEqOoHxQFBqy9NqAwyeloyR
         KBCYnQVt5angQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3F0BBC395C3;
        Tue, 11 Apr 2023 18:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 0/2] Fix failure to access u32* argument of tracked
 function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168123841824.29369.17941066959560460270.git-patchwork-notify@kernel.org>
Date:   Tue, 11 Apr 2023 18:40:18 +0000
References: <20230410085908.98493-1-zhoufeng.zf@bytedance.com>
In-Reply-To: <20230410085908.98493-1-zhoufeng.zf@bytedance.com>
To:     Feng zhou <zhoufeng.zf@bytedance.com>
Cc:     martin.lau@linux.dev, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        mykolal@fb.com, shuah@kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, yangzhenze@bytedance.com,
        wangdongdong.6@bytedance.com, zhouchengming@bytedance.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Mon, 10 Apr 2023 16:59:06 +0800 you wrote:
> From: Feng Zhou <zhoufeng.zf@bytedance.com>
> 
> When access traced function arguments with type is u32*, bpf verifier failed.
> Because u32 have typedef, needs to skip modifier. Add btf_type_is_modifier in
> is_int_ptr. Add a selftest to check it.
> 
> Feng Zhou (2):
>   bpf/btf: Fix is_int_ptr()
>   selftests/bpf: Add test to access u32 ptr argument in tracing program
> 
> [...]

Here is the summary with links:
  - [v3,1/2] bpf/btf: Fix is_int_ptr()
    https://git.kernel.org/bpf/bpf-next/c/91f2dc6838c1
  - [v3,2/2] selftests/bpf: Add test to access u32 ptr argument in tracing program
    https://git.kernel.org/bpf/bpf-next/c/75dcef8d3609

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


