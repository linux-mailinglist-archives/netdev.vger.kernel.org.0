Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D46606374D9
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 10:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiKXJKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 04:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiKXJKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 04:10:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C480970AF
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 01:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA53B62043
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 09:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 38939C433C1;
        Thu, 24 Nov 2022 09:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669281016;
        bh=TFtTvvKo17JeDkkZEteNkMjAmlC3tQKkpVScInbnD40=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SiGRoJoCxWxj/DSSW8x/G5dE2qlwOHF2/ggF5BYmDgeBtq4K2/Lfg2cOCRZn0dpZR
         JH5iEOUEwjE2QJQ/fL4bzNyX3aBTZNr7qPiQ5uvlfnGrIi7WN9Zjx9/0FkG9NUPJUD
         4e97pnLjXGCmIrdEDxsPRx//NpopW7JGexG4jLSXUmurr8K7iE8x9Q5aalsRLUUMbv
         FK4FwTM8oa2fdfPlq1CPH0dB8U+vHSkJjmsUwmSOlwGAuM/V2dr62Vldo3CbCdkM6I
         8XoLGFBw7UfeCiBWcCGh0LqEX2ax+iBWmHV3MRYreK2UqjGo4J4hKcIF9SXkJSfeG5
         DqoTNbQknR7WA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0C50AE29F53;
        Thu, 24 Nov 2022 09:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] octeontx2-af: Fix reference count issue in rvu_sdp_init()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166928101604.31076.14156851234378226224.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Nov 2022 09:10:16 +0000
References: <20221123065919.31499-1-wangxiongfeng2@huawei.com>
In-Reply-To: <20221123065919.31499-1-wangxiongfeng2@huawei.com>
To:     Xiongfeng Wang <wangxiongfeng2@huawei.com>
Cc:     saeed@kernel.org, sgoutham@marvell.com, lcherian@marvell.com,
        gakula@marvell.com, jerinj@marvell.com, hkelam@marvell.com,
        sbhatta@marvell.com, davem@davemloft.net, radhac@marvell.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        pnalla@marvell.com, snilla@marvell.com, netdev@vger.kernel.org,
        yangyingliang@huawei.com
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

On Wed, 23 Nov 2022 14:59:19 +0800 you wrote:
> pci_get_device() will decrease the reference count for the *from*
> parameter. So we don't need to call put_device() to decrease the
> reference. Let's remove the put_device() in the loop and only decrease
> the reference count of the returned 'pdev' for the last loop because it
> will not be passed to pci_get_device() as input parameter. We don't need
> to check if 'pdev' is NULL because it is already checked inside
> pci_dev_put(). Also add pci_dev_put() for the error path.
> 
> [...]

Here is the summary with links:
  - [v2] octeontx2-af: Fix reference count issue in rvu_sdp_init()
    https://git.kernel.org/netdev/net/c/ad17c2a3f11b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


