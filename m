Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 285225E604E
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 13:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbiIVLAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 07:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiIVLAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 07:00:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A18B86894;
        Thu, 22 Sep 2022 04:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBCE661378;
        Thu, 22 Sep 2022 11:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 415C4C433C1;
        Thu, 22 Sep 2022 11:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663844415;
        bh=/nDuAkxffLxwSnNaChsoOns5y5I+Tn66KG5BIB3vunM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XbeADh0LG1F7g19cPXtkCmmqDLfNqOh3xNEbNFGlc1m3mknxNkNbHsACD4zI/uMmS
         MnagftY2MLnajfybYYG+9dx90rYIRJ92LlyWN5Hl8LS4CUYFyQyAU6V2vRX+nPdZgh
         X5ohozo/yOlANRBLL2TfhbGbqULtV5E7oBeamFx09y24AHxGVmdBtDSXukQAd/K/eX
         021/wSd0YIk7jtMBq9Mkt3LCcSLyv/H5knJyDTCtB78GLs3W2DHKs8zVUTvxJft4P2
         DyuamhSknHvzJoRxODbp9L6ZPRbXI/jwZssHHS0eZzZV9BxJla+PDEheXCdYBy9QmR
         uyCWFV3FcHhTg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 241BCE4D03C;
        Thu, 22 Sep 2022 11:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/smc: Stop the CLC flow if no link to map buffers on
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166384441514.19700.3392239951153800895.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Sep 2022 11:00:15 +0000
References: <1663656189-32090-1-git-send-email-guwen@linux.alibaba.com>
In-Reply-To: <1663656189-32090-1-git-send-email-guwen@linux.alibaba.com>
To:     Wen Gu <guwen@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
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

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 20 Sep 2022 14:43:09 +0800 you wrote:
> There might be a potential race between SMC-R buffer map and
> link group termination.
> 
> smc_smcr_terminate_all()     | smc_connect_rdma()
> --------------------------------------------------------------
>                              | smc_conn_create()
> for links in smcibdev        |
>         schedule links down  |
>                              | smc_buf_create()
>                              |  \- smcr_buf_map_usable_links()
>                              |      \- no usable links found,
>                              |         (rmb->mr = NULL)
>                              |
>                              | smc_clc_send_confirm()
>                              |  \- access conn->rmb_desc->mr[]->rkey
>                              |     (panic)
> 
> [...]

Here is the summary with links:
  - [net] net/smc: Stop the CLC flow if no link to map buffers on
    https://git.kernel.org/netdev/net/c/e738455b2c6d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


