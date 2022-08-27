Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4E55A33A7
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 04:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345265AbiH0CAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 22:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345226AbiH0CAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 22:00:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCAC12AEB;
        Fri, 26 Aug 2022 19:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF31BB83382;
        Sat, 27 Aug 2022 02:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 77F4CC43470;
        Sat, 27 Aug 2022 02:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661565615;
        bh=UWdPil+KjpEYVZEksMsL3lsjUYL8yLDXNxRbLUzMmug=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WPG6tsWN/gdiGHzgfKvsdOkORbLfuVYdtjKgvR7Q5nYeC05Tf7YQQ8gpjNE0BLK33
         pnpbVjql5z/fNlIHI+JYddqxrcV+iALNbXtMwhLnl+M3lFrJw6Csl3XfR1StahRddM
         2zxuq68TmyLU6Vu5sLf+L4eqh6KwcN++OOX2JTSxYwqwwvUo+RBo3TOn/VMvgfgSyE
         6zAesBqv6R+yRxzKi6rl7ZZ8pnxIUwX5uslr4B+UGcEykCUbHmvzHny2TOYBvlDQGK
         8e+dJOf4F06VoUsSuYGAD8N8ORYZOOWtkK5hQfBzZ4l+EEH7LwAB3q3D81Lcw2Qk4S
         +mR296GHM57lQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 53C28E2A042;
        Sat, 27 Aug 2022 02:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] tg3: Disable tg3 device on system reboot to avoid
 triggering AER
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166156561533.8692.13682494208882962174.git-patchwork-notify@kernel.org>
Date:   Sat, 27 Aug 2022 02:00:15 +0000
References: <20220826002530.1153296-1-kai.heng.feng@canonical.com>
In-Reply-To: <20220826002530.1153296-1-kai.heng.feng@canonical.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     siva.kallam@broadcom.com, prashant@broadcom.com,
        mchan@broadcom.com, josef@toxicpanda.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 26 Aug 2022 08:25:30 +0800 you wrote:
> Commit d60cd06331a3 ("PM: ACPI: reboot: Use S5 for reboot") caused a
> reboot hang on one Dell servers so the commit was reverted.
> 
> Someone managed to collect the AER log and it's caused by MSI:
> [ 148.762067] ACPI: Preparing to enter system sleep state S5
> [ 148.794638] {1}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 5
> [ 148.803731] {1}[Hardware Error]: event severity: recoverable
> [ 148.810191] {1}[Hardware Error]: Error 0, type: fatal
> [ 148.816088] {1}[Hardware Error]: section_type: PCIe error
> [ 148.822391] {1}[Hardware Error]: port_type: 0, PCIe end point
> [ 148.829026] {1}[Hardware Error]: version: 3.0
> [ 148.834266] {1}[Hardware Error]: command: 0x0006, status: 0x0010
> [ 148.841140] {1}[Hardware Error]: device_id: 0000:04:00.0
> [ 148.847309] {1}[Hardware Error]: slot: 0
> [ 148.852077] {1}[Hardware Error]: secondary_bus: 0x00
> [ 148.857876] {1}[Hardware Error]: vendor_id: 0x14e4, device_id: 0x165f
> [ 148.865145] {1}[Hardware Error]: class_code: 020000
> [ 148.870845] {1}[Hardware Error]: aer_uncor_status: 0x00100000, aer_uncor_mask: 0x00010000
> [ 148.879842] {1}[Hardware Error]: aer_uncor_severity: 0x000ef030
> [ 148.886575] {1}[Hardware Error]: TLP Header: 40000001 0000030f 90028090 00000000
> [ 148.894823] tg3 0000:04:00.0: AER: aer_status: 0x00100000, aer_mask: 0x00010000
> [ 148.902795] tg3 0000:04:00.0: AER: [20] UnsupReq (First)
> [ 148.910234] tg3 0000:04:00.0: AER: aer_layer=Transaction Layer, aer_agent=Requester ID
> [ 148.918806] tg3 0000:04:00.0: AER: aer_uncor_severity: 0x000ef030
> [ 148.925558] tg3 0000:04:00.0: AER: TLP Header: 40000001 0000030f 90028090 00000000
> 
> [...]

Here is the summary with links:
  - [v2] tg3: Disable tg3 device on system reboot to avoid triggering AER
    https://git.kernel.org/netdev/net/c/2ca1c94ce0b6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


