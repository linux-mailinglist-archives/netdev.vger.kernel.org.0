Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 644366BDDC5
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 01:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbjCQAkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 20:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbjCQAkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 20:40:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91836286A;
        Thu, 16 Mar 2023 17:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C818B823D9;
        Fri, 17 Mar 2023 00:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 26E31C433D2;
        Fri, 17 Mar 2023 00:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679013618;
        bh=OKXUwTbzC/17Wf7o7bOtNYIHy4Vrf1K2zdx97pPz7dk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HeWREbnoyAE2JLzeXit3cfKI1bho97ARXisOHhrwR3FPSk+SRVoUH6eDc4YyM1xDK
         /xv9rVfnnQ2XxBk7sumCPSQklQoH2OxzpcUZGSIFXBR2d0FdmwI8VlDL4OJEeAjlQd
         sgy4Egjab/ObkvZ9I2+IwIs5xXUR2MuFx4g9a3LpNAsrta2pGhusZQJ9Ncw0FHjO0N
         xc0+PIjsSPyoL+JoZN/OtgayzqotNyPUaCIQjoVVQfTqqzzhJe/FocRRNdUxkbKvwl
         IlFq2oczjP3Q+catbC1Bc8Ktnh3UR6VidmTEmFntL1fSwIjMS8RxGeJoPZ55VNkfr/
         zKPPlKklgdG3Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0627FE66CBF;
        Fri, 17 Mar 2023 00:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: atlantic: Fix crash when XDP is enabled but no
 program is loaded
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167901361801.32704.18387361961611425279.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Mar 2023 00:40:18 +0000
References: <20230315125539.103319-1-toke@redhat.com>
In-Reply-To: <20230315125539.103319-1-toke@redhat.com>
To:     =?utf-8?b?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIDx0b2tlQHJlZGhhdC5jb20+?=@ci.codeaurora.org
Cc:     irusskikh@marvell.com, ast@kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        john.fastabend@gmail.com, ap420073@gmail.com,
        Freysteinn.Alfredsson@kau.se, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 15 Mar 2023 13:55:38 +0100 you wrote:
> The aq_xdp_run_prog() function falls back to the XDP_ABORTED action
> handler (using a goto) if the operations for any of the other actions fail.
> The XDP_ABORTED handler in turn calls the bpf_warn_invalid_xdp_action()
> tracepoint. However, the function also jumps into the XDP_PASS helper if no
> XDP program is loaded on the device, which means the XDP_ABORTED handler
> can be run with a NULL program pointer. This results in a NULL pointer
> deref because the tracepoint dereferences the 'prog' pointer passed to it.
> 
> [...]

Here is the summary with links:
  - [net] net: atlantic: Fix crash when XDP is enabled but no program is loaded
    https://git.kernel.org/netdev/net/c/37d010399f75

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


