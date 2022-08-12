Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62843590F79
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 12:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238472AbiHLKa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 06:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238141AbiHLKaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 06:30:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A23BDF;
        Fri, 12 Aug 2022 03:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9EB26168E;
        Fri, 12 Aug 2022 10:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D41EFC43144;
        Fri, 12 Aug 2022 10:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660300216;
        bh=3UdYeGSkfRt7bhIUCMvtX7SLzRbUb9e/hzXAFHyI4IA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NMUHoqip6g7aWom9aOi1sXK3c8rcqSIwBcf3IRo+kLkSjSi0J4lGgq3dGuO219xQq
         qD4t3MVU+rRUM+waEW73+JLuTQTHTuC0RQBs7euKvgc3lLB3/Y+xC1FbGTN+mGCL11
         K5OX1KseYPNFUokabPZIzmUCvxMpsUlxjuz5jVd3+wSOPX1AdO/oIIvd3XhwVTILqS
         f5MO75VlNGKrScuv5UphXzgyVKDvNOdPXNFgX1OS2UH95Bds8bl8I9E2TV87fRY2h6
         9Y754A7cfvKN+mQ7HPURSrpKRoqPGkCEqNsyQKlkUmMhBMRhxDECgWzMWlHqr+ofoa
         tgWCJ8EuuphPg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AF549C43148;
        Fri, 12 Aug 2022 10:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/sunrpc: fix potential memory leaks in
 rpc_sysfs_xprt_state_change()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166030021671.10916.13511850314728459485.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Aug 2022 10:30:16 +0000
References: <20220810152909.25149-1-xiongx18@fudan.edu.cn>
In-Reply-To: <20220810152909.25149-1-xiongx18@fudan.edu.cn>
To:     Xin Xiong <xiongx18@fudan.edu.cn>
Cc:     trond.myklebust@hammerspace.com, anna@kernel.org,
        chuck.lever@oracle.com, jlayton@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        kolga@netapp.com, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yuanxzhang@fudan.edu.cn, tanxin.ctf@gmail.com
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 10 Aug 2022 23:29:13 +0800 you wrote:
> The issue happens on some error handling paths. When the function
> fails to grab the object `xprt`, it simply returns 0, forgetting to
> decrease the reference count of another object `xps`, which is
> increased by rpc_sysfs_xprt_kobj_get_xprt_switch(), causing refcount
> leaks. Also, the function forgets to check whether `xps` is valid
> before using it, which may result in NULL-dereferencing issues.
> 
> [...]

Here is the summary with links:
  - net/sunrpc: fix potential memory leaks in rpc_sysfs_xprt_state_change()
    https://git.kernel.org/netdev/net/c/bfc48f1b0505

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


