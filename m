Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAC3B5027CF
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 12:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351910AbiDOKDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 06:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352081AbiDOKCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 06:02:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 044C6AAB4A;
        Fri, 15 Apr 2022 03:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DA9DB82DD7;
        Fri, 15 Apr 2022 10:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D082FC385A5;
        Fri, 15 Apr 2022 10:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650016811;
        bh=6YTrzaHGEsmvJ0nmJ7Cy3+mQmP9AmA93PRcrH8n/JMU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LzffhBeK3fFhnWpJczvYbxnIMxy5W0I8nhpxlDs7Z6NDBOhiMhYwDiTJ+on1sykpc
         A40bMPaS0cSd2HgzQKnOQTjZnQY8rL3ULCM4PcGGV83yik27V6XNSADuSbdZ/Q2Vv7
         hNr6PoWwTPB5VTY5xcgVfktjhAiJa59ox8SciNtqVLDYSDLFDSFeC5wjDZA0ZHAx3a
         ilxMjkzwdN/SeukbJHyKs6Iz6LeFQK6D694obejkR/a4EX2iUco+pJ7Nf8cwJrDOeu
         btYJEs11lrdaKBALhZqbk3kJG3IR+LSvn63WEOqPilZjjIzcOTkopXz7iPpDG3UGhp
         ENWfzGalKDrfg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B34E7E8DBD4;
        Fri, 15 Apr 2022 10:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] rxrpc: Restore removed timer deletion
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165001681173.2816.15053036697858965608.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Apr 2022 10:00:11 +0000
References: <164984498582.2000115.4023190177137486137.stgit@warthog.procyon.org.uk>
In-Reply-To: <164984498582.2000115.4023190177137486137.stgit@warthog.procyon.org.uk>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        marc.dionne@auristor.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Wed, 13 Apr 2022 11:16:25 +0100 you wrote:
> A recent patch[1] from Eric Dumazet flipped the order in which the
> keepalive timer and the keepalive worker were cancelled in order to fix a
> syzbot reported issue[2].  Unfortunately, this enables the mirror image bug
> whereby the timer races with rxrpc_exit_net(), restarting the worker after
> it has been cancelled:
> 
> 	CPU 1		CPU 2
> 	===============	=====================
> 			if (rxnet->live)
> 			<INTERRUPT>
> 	rxnet->live = false;
>  	cancel_work_sync(&rxnet->peer_keepalive_work);
> 			rxrpc_queue_work(&rxnet->peer_keepalive_work);
> 	del_timer_sync(&rxnet->peer_keepalive_timer);
> 
> [...]

Here is the summary with links:
  - [net] rxrpc: Restore removed timer deletion
    https://git.kernel.org/netdev/net/c/ee3b0826b476

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


