Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAAA617537
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 04:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbiKCDuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 23:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiKCDuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 23:50:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB3215708;
        Wed,  2 Nov 2022 20:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35E90B8265D;
        Thu,  3 Nov 2022 03:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B60C0C433B5;
        Thu,  3 Nov 2022 03:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667447416;
        bh=mUg/edvevTa+cRLGFzbQAxK/x7aY4ixITYU/GGFZ8yI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mujp9UsT1bZbHRDT0enBQ+lULMth/vAXrGI9cwXF8YFd/42jwg6sGoYFsPtjfexqS
         JNJ97JdcsJwJmzgLxDGeRpk0bMPPs7z/+XzIxHYMwk7yu6DPb5df578L/2uJ5EvbIK
         oSB/RSG7myaJYfotGob29bnnHVAP+emH4SLMRVjt59Y8FUUMGTKk2peHA7cEffyMRJ
         keCD9INkvJtKvor0VtH32Ag4X5NIyRCgc7NRBdKWRyWz4O7mmkuCp1bjTSVQrD3Uwj
         MvAupJWLOMrxcJJD3MWlRbGMxuT0DEvMRL0JjqBOBtS25JttPNY/hw6mOYxPOtXBuA
         B3m8nQ740IfOQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 94950C41620;
        Thu,  3 Nov 2022 03:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/smc: Fix possible leaked pernet namespace in smc_init()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166744741660.12191.13112390295729778693.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Nov 2022 03:50:16 +0000
References: <20221101093722.127223-1-chenzhongjin@huawei.com>
In-Reply-To: <20221101093722.127223-1-chenzhongjin@huawei.com>
To:     Chen Zhongjin <chenzhongjin@huawei.com>
Cc:     linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, kgraul@linux.ibm.com, wenjia@linux.ibm.com,
        jaka@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, guvenc@linux.ibm.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 1 Nov 2022 17:37:22 +0800 you wrote:
> In smc_init(), register_pernet_subsys(&smc_net_stat_ops) is called
> without any error handling.
> If it fails, registering of &smc_net_ops won't be reverted.
> And if smc_nl_init() fails, &smc_net_stat_ops itself won't be reverted.
> 
> This leaves wild ops in subsystem linkedlist and when another module
> tries to call register_pernet_operations() it triggers page fault:
> 
> [...]

Here is the summary with links:
  - net/smc: Fix possible leaked pernet namespace in smc_init()
    https://git.kernel.org/netdev/net/c/62ff373da253

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


