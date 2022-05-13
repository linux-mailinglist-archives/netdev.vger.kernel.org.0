Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23AA052687D
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 19:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383080AbiEMRaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 13:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383092AbiEMRaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 13:30:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEAAB7222B;
        Fri, 13 May 2022 10:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97E67B83128;
        Fri, 13 May 2022 17:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5201AC34100;
        Fri, 13 May 2022 17:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652463012;
        bh=p6JNG7AOQ3fv1hDszD1l1tbLXZYZtdhcr16krCpZb1c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZMEapzJT1OpGoablwjUpkyNiAxDB+y8bGMMC69AORuuGvj9Yxsz4JgDBBT+VI9ZUE
         K01WnisDzkw4wq7QkGxJfARxXjJZVBl07/cm9WPSSzKR8D6dk4sVAJ30fC0E39OpWq
         Sfs0m3IJXK9ZdOa3TQ3b79wVO8yKjnwYoE1s3xxH1LXYlIHAN3b/EOsAcRmfQb1N4g
         yOmI2pR+aZjFRiQy932pb3j9qdLh6DKHF8oxVYsghUxpCMHMwZZkSdrkqeInPs83EE
         7wBU2TCp2ekizs6wBPJk0915LrUFb/ExTlwRW44dqt60tRV7jFthoQQaKg00hAxLxM
         mVKgR9cWyCEnQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 33DC2F03936;
        Fri, 13 May 2022 17:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] sfc: siena: Fix Kconfig dependencies
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165246301220.15380.9977189278947403618.git-patchwork-notify@kernel.org>
Date:   Fri, 13 May 2022 17:30:12 +0000
References: <20220513012721.140871-1-renzhijie2@huawei.com>
In-Reply-To: <20220513012721.140871-1-renzhijie2@huawei.com>
To:     Ren Zhijie <renzhijie2@huawei.com>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 13 May 2022 09:27:21 +0800 you wrote:
> If CONFIG_PTP_1588_CLOCK=m and CONFIG_SFC_SIENA=y, the siena driver will fail to link:
> 
> drivers/net/ethernet/sfc/siena/ptp.o: In function `efx_ptp_remove_channel':
> ptp.c:(.text+0xa28): undefined reference to `ptp_clock_unregister'
> drivers/net/ethernet/sfc/siena/ptp.o: In function `efx_ptp_probe_channel':
> ptp.c:(.text+0x13a0): undefined reference to `ptp_clock_register'
> ptp.c:(.text+0x1470): undefined reference to `ptp_clock_unregister'
> drivers/net/ethernet/sfc/siena/ptp.o: In function `efx_ptp_pps_worker':
> ptp.c:(.text+0x1d29): undefined reference to `ptp_clock_event'
> drivers/net/ethernet/sfc/siena/ptp.o: In function `efx_siena_ptp_get_ts_info':
> ptp.c:(.text+0x301b): undefined reference to `ptp_clock_index'
> 
> [...]

Here is the summary with links:
  - [-next] sfc: siena: Fix Kconfig dependencies
    https://git.kernel.org/netdev/net-next/c/f9a210c72d70

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


