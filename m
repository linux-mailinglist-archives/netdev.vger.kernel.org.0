Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45EC069E597
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 18:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234400AbjBURK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 12:10:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233749AbjBURKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 12:10:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1A01632D;
        Tue, 21 Feb 2023 09:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EE126115A;
        Tue, 21 Feb 2023 17:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A63A6C433D2;
        Tue, 21 Feb 2023 17:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676999417;
        bh=kK78z4bWKAAxcaxJWLlgsjSksFhMw/HP4nqefcJ+2BI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DmkJpgAhljZEhIRhcJPTqV1Vb/bPO+bMg40A0d7Kc+z6mjkW4zBF+qtHv+RYo684K
         eiKbRM5r4n/piR0gwCVuTFrbSQMMipqGtaofmVG4uVYLqYEHKnFG3Is5PeBI5QGjrH
         AFLLR3FwqDzBGTiIEbH4oNDWRpGCO2cOGNhxsQ8N3EH0LZSqQTkWHFg3hU/79qXBTu
         IBNdSQ7tWD7rmc+/EwEW5MQ70NF+WtK6CMaVVFPVVHnV+qKJHiKVSJhxdgr6CxEl07
         MXG8aXRSxA8RS10iIYFhoTnlesyOnKkv6M8tYOdCaUgnTSlvAsHb2cdz8VSkEg5+Zo
         ie6oEJC/osa6g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8B64DC43159;
        Tue, 21 Feb 2023 17:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] xsk: add linux/vmalloc.h to xsk.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167699941756.22649.18072227084430799997.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Feb 2023 17:10:17 +0000
References: <20230221075140.46988-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20230221075140.46988-1-xuanzhuo@linux.alibaba.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, bjorn@kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        jonathan.lemon@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        aleksander.lobakin@intel.com, bpf@vger.kernel.org, lkp@intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 21 Feb 2023 15:51:40 +0800 you wrote:
> Fix the failure of the compilation under the sh4.
> 
> Because we introduced remap_vmalloc_range() earlier, this has caused
> the compilation failure on the sh4 platform. So this introduction of the
> header file of linux/vmalloc.h.
> 
> config: sh-allmodconfig (https://download.01.org/0day-ci/archive/20230221/202302210041.kpPQLlNQ-lkp@intel.com/config)
> compiler: sh4-linux-gcc (GCC) 12.1.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=9f78bf330a66cd400b3e00f370f597e9fa939207
>         git remote add net-next https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
>         git fetch --no-tags net-next master
>         git checkout 9f78bf330a66cd400b3e00f370f597e9fa939207
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sh olddefconfig
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sh SHELL=/bin/bash net/
> 
> [...]

Here is the summary with links:
  - [net-next] xsk: add linux/vmalloc.h to xsk.c
    https://git.kernel.org/bpf/bpf-next/c/951bce29c898

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


