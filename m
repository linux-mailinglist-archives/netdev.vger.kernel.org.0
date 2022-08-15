Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E117E592CB7
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 12:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242526AbiHOKuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 06:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231523AbiHOKuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 06:50:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157E61D6;
        Mon, 15 Aug 2022 03:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA4BD6109E;
        Mon, 15 Aug 2022 10:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 03431C433D7;
        Mon, 15 Aug 2022 10:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660560614;
        bh=xvaFwU0tj0bxbd5ElgktdMPzwyIg8WHWBLi0zgQ3Khs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O/gvU5uX+SlI2ccZfQGFtEet4D/e5DVnZZOwC8s/lVvVap1G7s7hshLnL8o/P3CxJ
         /jTA614Dnx1IxCcm14O52b/mCtTz+1hZhE+F49xy0VY77EUksrnJnq6vWjHyAY06vl
         +j2qTYTDtcMHl2s0xRrwNLMLusj0tACGwfhor5ub5/GzPxFZFLm6GLNIDP3ZowSRVU
         PKGqqhs8r48aFnbR/FikabmrCw5zcFWxh9/kvIFgQThBoAtNl8uQA4BAP/NPR12Xzi
         R+F6W8MrK7ZES8s6JT/Ezk0/9Vw00RrN0HdBG1FOBweB7cMCBDXzMI1n7xs3pqj0No
         HuenPgmt3CZFw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DDA6CE2A050;
        Mon, 15 Aug 2022 10:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: fix potential refcount leak in ndisc_router_discovery()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166056061390.20212.5869065400117600776.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Aug 2022 10:50:13 +0000
References: <20220813124907.3396-1-xiongx18@fudan.edu.cn>
In-Reply-To: <20220813124907.3396-1-xiongx18@fudan.edu.cn>
To:     Xin Xiong <xiongx18@fudan.edu.cn>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        praveen5582@gmail.com, zxu@linkedin.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yuanxzhang@fudan.edu.cn,
        tanxin.ctf@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sat, 13 Aug 2022 20:49:08 +0800 you wrote:
> The issue happens on specific paths in the function. After both the
> object `rt` and `neigh` are grabbed successfully, when `lifetime` is
> nonzero but the metric needs change, the function just deletes the
> route and set `rt` to NULL. Then, it may try grabbing `rt` and `neigh`
> again if above conditions hold. The function simply overwrite `neigh`
> if succeeds or returns if fails, without decreasing the reference
> count of previous `neigh`. This may result in memory leaks.
> 
> [...]

Here is the summary with links:
  - net: fix potential refcount leak in ndisc_router_discovery()
    https://git.kernel.org/netdev/net/c/7396ba87f1ed

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


