Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 017A25BE3C3
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 12:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbiITKuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 06:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiITKuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 06:50:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9B52529A;
        Tue, 20 Sep 2022 03:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 080796292A;
        Tue, 20 Sep 2022 10:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5AB10C433D7;
        Tue, 20 Sep 2022 10:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663671016;
        bh=9a2t3wK0Ru1r5Ca3Rlk5Zy7DcfMhJsKYI36+wzQ7dQk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=crQzKBxeoICwDwkTO9YQ2MXDXqoQXACdCcVUsndi7qn+dV0acDsW6hx/vxNJV4fZH
         yUKl2EWmHnQikiD+WkQq62S5oTGw4qVcqtVPjo2EBgnbs/cGm+RgHzq4leKuYq7PRG
         LTghvYiTGEqu6TnU1ld3sc3x8MxqSGrUBitkOtPuWAU4Vlgh/LCWnaDfUx/5ylsvZV
         2jXT0ZZBV72Kf/q6xS6+859FOJ7fWzGyKifkCBmsmNhdyCsx7ZIkWl2gF42pytnYW5
         LyGdE9JJ/CvGA+F0xKqXcjJz0YCPWCDz6vYGUnL4Wu4mWhbN98RBkfB35nvwqK4HAv
         QJP695XBA9WEA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3D419E21EE0;
        Tue, 20 Sep 2022 10:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next v2 0/3] seg6: add NEXT-C-SID support for SRv6 End behavior
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166367101624.31197.16175014864853693907.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 10:50:16 +0000
References: <20220912171619.16943-1-andrea.mayer@uniroma2.it>
In-Reply-To: <20220912171619.16943-1-andrea.mayer@uniroma2.it>
To:     Andrea Mayer <andrea.mayer@uniroma2.it>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        shuah@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        bpf@vger.kernel.org, stefano.salsano@uniroma2.it,
        paolo.lungaroni@uniroma2.it, ahabdels.dev@gmail.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 12 Sep 2022 19:16:16 +0200 you wrote:
> The Segment Routing (SR) architecture is based on loose source routing.
> A list of instructions, called segments, can be added to the packet headers to
> influence the forwarding and processing of the packets in an SR enabled
> network.
> In SRv6 (Segment Routing over IPv6 data plane) [1], the segment identifiers
> (SIDs) are IPv6 addresses (128 bits) and the segment list (SID List) is carried
> in the Segment Routing Header (SRH). A segment may correspond to a "behavior"
> that is executed by a node when the packet is received.
> The Linux kernel currently supports a large subset of the behaviors described
> in [2] (e.g., End, End.X, End.T and so on).
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/3] seg6: add netlink_ext_ack support in parsing SRv6 behavior attributes
    https://git.kernel.org/netdev/net-next/c/e2a8ecc45165
  - [net-next,v2,2/3] seg6: add NEXT-C-SID support for SRv6 End behavior
    https://git.kernel.org/netdev/net-next/c/848f3c0d4769
  - [net-next,v2,3/3] selftests: seg6: add selftest for NEXT-C-SID flavor in SRv6 End behavior
    https://git.kernel.org/netdev/net-next/c/19d6356ab3f0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


