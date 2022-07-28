Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB33583673
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 03:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234004AbiG1BkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 21:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiG1BkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 21:40:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC33711A2F;
        Wed, 27 Jul 2022 18:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B23456185C;
        Thu, 28 Jul 2022 01:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 17A0CC433D6;
        Thu, 28 Jul 2022 01:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658972413;
        bh=GUi7ZyFyozK9eXXzAOnqX72WWxHg2DqUeftrjPIzGfE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=etch3J2LOV45+ihycHLt4mZNxVk945WcrRvi/ARVD3ggyj5vIoob1k68IHJohhDzK
         ncjYoBHOlA2BHKVnPayAZhUVhX5zsPwBSs8mpU7leHatxQ3jMnip2mznYNybedVpK+
         G5r+8FUnGcXLAFeLl8jzmPOYbF764NbRNkk3yNYF8XlVLUvJBZS7CmRpb1flCD/N9B
         jS2zambUrm6hhw5DbTq20WVnWpSqcfQCpwEkEfilu1EDB43TxhNkbbFakcrpK/PR9X
         XIvJnVcQgBKbC6JOZJDqlqBBGz46kr3MK9vfaBLNK1Lp7Asq/6PogN+2/wGUgYJt1L
         NHamjSHnapZPw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F0636C43143;
        Thu, 28 Jul 2022 01:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sctp: leave the err path free in sctp_stream_init to
 sctp_stream_free
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165897241298.6801.11007831047781840248.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jul 2022 01:40:12 +0000
References: <831a3dc100c4908ff76e5bcc363be97f2778bc0b.1658787066.git.lucien.xin@gmail.com>
In-Reply-To: <831a3dc100c4908ff76e5bcc363be97f2778bc0b.1658787066.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, marcelo.leitner@gmail.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 25 Jul 2022 18:11:06 -0400 you wrote:
> A NULL pointer dereference was reported by Wei Chen:
> 
>   BUG: kernel NULL pointer dereference, address: 0000000000000000
>   RIP: 0010:__list_del_entry_valid+0x26/0x80
>   Call Trace:
>    <TASK>
>    sctp_sched_dequeue_common+0x1c/0x90
>    sctp_sched_prio_dequeue+0x67/0x80
>    __sctp_outq_teardown+0x299/0x380
>    sctp_outq_free+0x15/0x20
>    sctp_association_free+0xc3/0x440
>    sctp_do_sm+0x1ca7/0x2210
>    sctp_assoc_bh_rcv+0x1f6/0x340
> 
> [...]

Here is the summary with links:
  - [net] sctp: leave the err path free in sctp_stream_init to sctp_stream_free
    https://git.kernel.org/netdev/net/c/181d8d2066c0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


