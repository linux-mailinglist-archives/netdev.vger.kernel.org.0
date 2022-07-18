Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97AC4577FEB
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 12:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234347AbiGRKkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 06:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234213AbiGRKkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 06:40:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909B91EC52;
        Mon, 18 Jul 2022 03:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1AD93B8110A;
        Mon, 18 Jul 2022 10:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B6A3CC341CA;
        Mon, 18 Jul 2022 10:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658140816;
        bh=o/iNYuCxsqaOD6DG3Ys5y1hjwGO/7SAuL8oZv5IPMVo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sVW81oosS4rw6qrJ7WBs04TO7fHzIht3pHAbwtcVtV5cix0TEt6DXIL7NCZK0rCiV
         PQsEq5ok7aTdTAEPHmXSNsInlUUOTpiijk68bet89DjNprSLoxtXK7ySuECWfK70zg
         b8yHB7N4q/h8Yc5NCpjKHQ25NgVqnlNLS6lewyrNyw9QoJwrFa/9cqUCyqQKezw5T1
         l3KxDeHJaSu/v7skPEIOGJ7desXCLoGGWRQRQTIt4ZK9Cp06C81Ojh1ZWXgVTrzB7f
         hydKDOsiJ/5jkh6We5aDjZn3LQgiT7wXS/F5OsOBf3VNd5XVjn9NKUjxRr4h6BBrFE
         4WnBuBinXjtGQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 98863E451AF;
        Mon, 18 Jul 2022 10:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/6] net/smc: Introduce virtually contiguous
 buffers for SMC-R
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165814081662.19605.4498154287965722155.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Jul 2022 10:40:16 +0000
References: <1657791845-1060-1-git-send-email-guwen@linux.alibaba.com>
In-Reply-To: <1657791845-1060-1-git-send-email-guwen@linux.alibaba.com>
To:     Wen Gu <guwen@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 14 Jul 2022 17:43:59 +0800 you wrote:
> On long-running enterprise production servers, high-order contiguous
> memory pages are usually very rare and in most cases we can only get
> fragmented pages.
> 
> When replacing TCP with SMC-R in such production scenarios, attempting
> to allocate high-order physically contiguous sndbufs and RMBs may result
> in frequent memory compaction, which will cause unexpected hung issue
> and further stability risks.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/6] net/smc: remove redundant dma sync ops
    https://git.kernel.org/netdev/net-next/c/6d52e2de6415
  - [net-next,v2,2/6] net/smc: optimize for smc_sndbuf_sync_sg_for_device and smc_rmb_sync_sg_for_cpu
    https://git.kernel.org/netdev/net-next/c/0ef69e788411
  - [net-next,v2,3/6] net/smc: Introduce a sysctl for setting SMC-R buffer type
    https://git.kernel.org/netdev/net-next/c/4bc5008e4387
  - [net-next,v2,4/6] net/smc: Use sysctl-specified types of buffers in new link group
    https://git.kernel.org/netdev/net-next/c/b984f370ed51
  - [net-next,v2,5/6] net/smc: Allow virtually contiguous sndbufs or RMBs for SMC-R
    https://git.kernel.org/netdev/net-next/c/b8d199451c99
  - [net-next,v2,6/6] net/smc: Extend SMC-R link group netlink attribute
    https://git.kernel.org/netdev/net-next/c/ddefb2d20553

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


