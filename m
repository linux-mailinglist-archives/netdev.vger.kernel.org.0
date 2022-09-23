Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24BF65E7CC1
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 16:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232516AbiIWOUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 10:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232544AbiIWOUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 10:20:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C9CE171F;
        Fri, 23 Sep 2022 07:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA1F662373;
        Fri, 23 Sep 2022 14:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 242A2C433D7;
        Fri, 23 Sep 2022 14:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663942818;
        bh=Rhvv+Iydenk8ACiYitJE/oTrMmj9xntYcGCGLQuTFUc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=krV+S6MfQFKQRI2XALFhC2dlaOOIbe74ALI+MiAIuzAFuHRvMUus15qmSsnMf6U/q
         6EKcCYqjwwECIBVPxHhzIYuwloxtJcrtq4Q6a2MhcWdIjM3ZLOOHU5pBJqG7ZnrVvw
         1vSkyl6tkwtDdlwK9MSUaSX3mOsjy03uZR7SeumCIddF/+GWqGQJmuOx+aqo/LUypr
         nUi33/UT5J3W5t4GVCGwCMpiugc0+mv85BgJPl0q293eV11SmVCgZnift0KOIon5+S
         Q1AnCS9U4p41npDHit984nN3jE8fdXGaO9u+0X3weo3mSTjdHRScL1NosZMvh19TQ8
         KioT668NReJoQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 11515E4D03D;
        Fri, 23 Sep 2022 14:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/11] can: bcm: registration process optimization in
 bcm_module_init()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166394281805.25768.3506928119698170613.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Sep 2022 14:20:18 +0000
References: <20220923120859.740577-2-mkl@pengutronix.de>
In-Reply-To: <20220923120859.740577-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        william.xuanziyang@huawei.com, socketcan@hartkopp.net
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Fri, 23 Sep 2022 14:08:49 +0200 you wrote:
> From: Ziyang Xuan <william.xuanziyang@huawei.com>
> 
> Now, register_netdevice_notifier() and register_pernet_subsys() are both
> after can_proto_register(). It can create CAN_BCM socket and process socket
> once can_proto_register() successfully, so it is possible missing notifier
> event or proc node creation because notifier or bcm proc directory is not
> registered or created yet. Although this is a low probability scenario, it
> is not impossible.
> 
> [...]

Here is the summary with links:
  - [net-next,01/11] can: bcm: registration process optimization in bcm_module_init()
    https://git.kernel.org/netdev/net-next/c/edd1a7e42f1d
  - [net-next,02/11] can: bcm: check the result of can_send() in bcm_can_tx()
    https://git.kernel.org/netdev/net-next/c/3fd7bfd28cfd
  - [net-next,03/11] can: gs_usb: gs_usb_get_timestamp(): fix endpoint parameter for usb_control_msg_recv()
    https://git.kernel.org/netdev/net-next/c/593b5e2f5a4a
  - [net-next,04/11] can: gs_usb: add missing lock to protect struct timecounter::cycle_last
    https://git.kernel.org/netdev/net-next/c/29a8c9ec9090
  - [net-next,05/11] can: gs_usb: gs_can_open(): initialize time counter before starting device
    https://git.kernel.org/netdev/net-next/c/103108cb9673
  - [net-next,06/11] can: gs_usb: gs_cmd_reset(): rename variable holding struct gs_can pointer to dev
    https://git.kernel.org/netdev/net-next/c/002467518688
  - [net-next,07/11] can: gs_usb: convert from usb_control_msg() to usb_control_msg_{send,recv}()
    https://git.kernel.org/netdev/net-next/c/3814ed27548a
  - [net-next,08/11] can: gs_usb: gs_make_candev(): clean up error handling
    https://git.kernel.org/netdev/net-next/c/68822f4e74f3
  - [net-next,09/11] can: gs_usb: add switchable termination support
    https://git.kernel.org/netdev/net-next/c/906e0e6886af
  - [net-next,10/11] can: gs_usb: remove dma allocations
    https://git.kernel.org/netdev/net-next/c/62f102c0d156
  - [net-next,11/11] can: ctucanfd: Remove redundant dev_err call
    https://git.kernel.org/netdev/net-next/c/6eed756408c6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


