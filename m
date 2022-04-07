Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0594F757D
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 07:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238016AbiDGFwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 01:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbiDGFwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 01:52:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936AB5F96;
        Wed,  6 Apr 2022 22:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB9E6B826B9;
        Thu,  7 Apr 2022 05:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7E1DAC385A5;
        Thu,  7 Apr 2022 05:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649310612;
        bh=3YWLrpiFSvH6ZQ0daUuwV7CgfI5cVUWuqVsYagCDuEM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mh56rolN2SW5Y963J6o+m2zt0nSv9N5/ui1QuKEYGsuONE/YZYVoeRQczA0+xzJ3z
         1EDi3IkB1Wos7IRMSmS9P6mzovTPL7CapRiJFvLT7r6QHmPnTYmh5l96k7kdovFt48
         dBj6rBn1eXfsPGd1EIYnzdt394rj8J42OtMWaRTsVJwPIEVFwpPU64zdX3wgQMdU08
         briKBV29XA6Itn4VuHrFyfb4uieIDEQdj4lf4daNAhCJnTi9qDrTJdHVaRsGLCFFIx
         B9jw7ECUzTRY3oPQgc5QTEXOtuW9cc5hZsMWtbukUQ+Tcl8tppPaQmi/DlkUzzw3Iw
         XlV0+aQkTApTA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 61B64E85B8C;
        Thu,  7 Apr 2022 05:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] ipv6: fix locking issues with loops over
 idev->addr_list
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164931061239.16262.17688495506884085480.git-patchwork-notify@kernel.org>
Date:   Thu, 07 Apr 2022 05:50:12 +0000
References: <20220403231523.45843-1-dossche.niels@gmail.com>
In-Reply-To: <20220403231523.45843-1-dossche.niels@gmail.com>
To:     Niels Dossche <dossche.niels@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  4 Apr 2022 01:15:24 +0200 you wrote:
> idev->addr_list needs to be protected by idev->lock. However, it is not
> always possible to do so while iterating and performing actions on
> inet6_ifaddr instances. For example, multiple functions (like
> addrconf_{join,leave}_anycast) eventually call down to other functions
> that acquire the idev->lock. The current code temporarily unlocked the
> idev->lock during the loops, which can cause race conditions. Moving the
> locks up is also not an appropriate solution as the ordering of lock
> acquisition will be inconsistent with for example mc_lock.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] ipv6: fix locking issues with loops over idev->addr_list
    https://git.kernel.org/netdev/net-next/c/51454ea42c1a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


