Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F24667C493
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 07:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235965AbjAZGub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 01:50:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbjAZGuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 01:50:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 475ED2916F
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 22:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2E70616FA
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 06:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 34706C4339C;
        Thu, 26 Jan 2023 06:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674715817;
        bh=r9UsS2OCN5qyuR33P54+22pi0MpqNVWmCpxTrkek2oo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VZc+kUKadWzfdMhOtz2qheNSepU/7pwkJ+nlRJtiKyG1xYInVwWZ+zhYS6yT+9SxQ
         ksULGhqnFYqtpM2gCzkOUnDkqkgs3UQfdDzTZUcIg6IJp9X0WtAiAjUsxmUteM/K1X
         X0LdDO6nRNeMKGbtElXvTGOf1V0tArgbdYID9/b+HyTkZ0PnLKk1nifpyxoiiY8Rx1
         KI2oNsfEN5U3GSaMSg48IPtxpteSad6iHnLco1R9VRAqwJMqlVALLVYV2Bz1+9JTL4
         3YJk7/o8Kb3ShokorwzNHPEc1L0EuMwS/k5asHAOO6KCRyimk/W+MwrSgDla5vfnrg
         quSeWVq/LPREw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 15700E52508;
        Thu, 26 Jan 2023 06:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net/tg3: resolve deadlock in tg3_reset_task() during EEH
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167471581708.15959.4004093373936873252.git-patchwork-notify@kernel.org>
Date:   Thu, 26 Jan 2023 06:50:17 +0000
References: <20230124185339.225806-1-drc@linux.vnet.ibm.com>
In-Reply-To: <20230124185339.225806-1-drc@linux.vnet.ibm.com>
To:     David Christensen <drc@linux.vnet.ibm.com>
Cc:     netdev@vger.kernel.org, siva.kallam@broadcom.com,
        prashant@broadcom.com, mchan@broadcom.com,
        pavan.chebbi@broadcom.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 24 Jan 2023 13:53:39 -0500 you wrote:
> During EEH error injection testing, a deadlock was encountered in the tg3
> driver when tg3_io_error_detected() was attempting to cancel outstanding
> reset tasks:
> 
> crash> foreach UN bt
> ...
> PID: 159    TASK: c0000000067c6000  CPU: 8   COMMAND: "eehd"
> ...
>  #5 [c00000000681f990] __cancel_work_timer at c00000000019fd18
>  #6 [c00000000681fa30] tg3_io_error_detected at c00800000295f098 [tg3]
>  #7 [c00000000681faf0] eeh_report_error at c00000000004e25c
> ...
> 
> [...]

Here is the summary with links:
  - [v2] net/tg3: resolve deadlock in tg3_reset_task() during EEH
    https://git.kernel.org/netdev/net/c/6c4ca03bd890

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


