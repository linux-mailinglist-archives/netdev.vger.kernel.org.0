Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 869484C431B
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 12:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239947AbiBYLKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 06:10:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239902AbiBYLKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 06:10:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D91C239317
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 03:10:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DE6B61831
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 11:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CE18AC36AE3;
        Fri, 25 Feb 2022 11:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645787413;
        bh=t+CqSXm11bCFqCYWUH5uiJzaFxzrWmgnFOQxHuJ1opI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YjthYuKu7pMBCaQtDl4yZNhqb7KZZyv/hW0e5ruJ2nTmgC/50swhXa0MlRo7Y3QV2
         tL+dQPl6F/DySSgmRz1e2Dtl5O/USN7hu3KKSiAAsW+CzaWYQ5vd56BzDO6VnuqogP
         6XrO7jviQxcfKoVC1j8exdEM5HoivSjoMXnxQIEZT6XhTFuA96uXj5kgXTm0WqNPVp
         GTNgtOjIUWoppGybKjDWAjVzzzBqIZaRfRCYwGjBFV28d9eWLHL7uHLiy3J0K8NxXt
         dM6Y0TfTrP+y0UEvSoitz0r5eWsX2E62IxPWzYf0A70T/SbcklCgi89z3s6/OSGgkf
         veNfP6N6KpXew==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B4140EAC09C;
        Fri, 25 Feb 2022 11:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/8] ibmvnic: Fix a race in ibmvnic_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164578741373.30964.8251549870847069766.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Feb 2022 11:10:13 +0000
References: <20220225062358.1435652-1-sukadev@linux.ibm.com>
In-Reply-To: <20220225062358.1435652-1-sukadev@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, brking@linux.ibm.com, drt@linux.ibm.com,
        ricklind@linux.ibm.com
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

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 24 Feb 2022 22:23:50 -0800 you wrote:
> If we get a transport (reset) event right after a successful CRQ_INIT
> during ibmvnic_probe() but before we set the adapter state to VNIC_PROBED,
> we will throw away the reset assuming that the adapter is still in the
> probing state. But since the adapter has completed the CRQ_INIT any
> subsequent CRQs the we send will be ignored by the vnicserver until
> we release/init the CRQ again. This can leave the adapter unconfigured.
> 
> [...]

Here is the summary with links:
  - [net,1/8] ibmvnic: free reset-work-item when flushing
    https://git.kernel.org/netdev/net/c/8d0657f39f48
  - [net,2/8] ibmvnic: initialize rc before completing wait
    https://git.kernel.org/netdev/net/c/765559b10ce5
  - [net,3/8] ibmvnic: define flush_reset_queue helper
    https://git.kernel.org/netdev/net/c/83da53f7e4bd
  - [net,4/8] ibmvnic: complete init_done on transport events
    https://git.kernel.org/netdev/net/c/36491f2df9ad
  - [net,5/8] ibmvnic: register netdev after init of adapter
    https://git.kernel.org/netdev/net/c/570425f8c7c1
  - [net,6/8] ibmvnic: init init_done_rc earlier
    https://git.kernel.org/netdev/net/c/ae16bf15374d
  - [net,7/8] ibmvnic: clear fop when retrying probe
    https://git.kernel.org/netdev/net/c/f628ad531b4f
  - [net,8/8] ibmvnic: Allow queueing resets during probe
    https://git.kernel.org/netdev/net/c/fd98693cb072

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


