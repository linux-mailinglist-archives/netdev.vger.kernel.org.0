Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCE3865189D
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 03:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232798AbiLTCAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 21:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232789AbiLTCAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 21:00:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 441B52ACE
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 18:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE66761237
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 02:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 321AFC433F0;
        Tue, 20 Dec 2022 02:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671501618;
        bh=zLWCQmamV7gMLFPJaguVR7feWaADEFp4224KTD8bZu8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t/WV8hCv72ulRi6zgrioMiivK05wLNRQwxmUpRYIxvDQKoR6c5wYvObmOaH2FBo2K
         vfgfFUnSTR04Q5+jogd8vl5RJCva6+qGZUv67aEQkjpqGQrG7NQEvFfMjsQLdI299U
         cTdjBJ8uonKxBqKs7Jnox6h1tLHgRZfOylldihxhzXrnYBjvmmY5+akK7KovnJgrEu
         Bhs4LGThfFd+Caw9UoYkIKoL9dB0VSCWeRKBhtQT9cQdiv0hsWML964Yjwg5KZxaGY
         B2y+kHQHrEzduOooU0F6XT/QDhuW1r/4qjdkqvmPb1biUKeVjeKubvewk/Xg+WbIuR
         rHFRanxixfEVA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0C19BC43141;
        Tue, 20 Dec 2022 02:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v4 0/3] Stop corrupting socket's task_frag
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167150161804.12144.10678918322363818868.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Dec 2022 02:00:18 +0000
References: <cover.1671194454.git.bcodding@redhat.com>
In-Reply-To: <cover.1671194454.git.bcodding@redhat.com>
To:     Benjamin Coddington <bcodding@redhat.com>
Cc:     kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net,
        edumazet@google.com, gnault@redhat.com, philipp.reisner@linbit.com,
        lars.ellenberg@linbit.com, christoph.boehmwalder@linbit.com,
        axboe@kernel.dk, josef@toxicpanda.com, kbusch@kernel.org,
        hch@lst.de, sagi@grimberg.me, lduncan@suse.com, cleech@redhat.com,
        michael.christie@oracle.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, valentina.manea.m@gmail.com,
        shuah@kernel.org, gregkh@linuxfoundation.org, dhowells@redhat.com,
        marc.dionne@auristor.com, sfrench@samba.org, ccaulfie@redhat.com,
        teigland@redhat.com, mark@fasheh.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, ericvh@gmail.com, lucho@ionkov.net,
        asmadeus@codewreck.org, idryomov@gmail.com, xiubli@redhat.com,
        chuck.lever@oracle.com, jlayton@kernel.org,
        trond.myklebust@hammerspace.com, anna@kernel.org,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 16 Dec 2022 07:45:25 -0500 you wrote:
> The networking code uses flags in sk_allocation to determine if it can use
> current->task_frag, however in-kernel users of sockets may stop setting
> sk_allocation when they convert to the preferred memalloc_nofs_save/restore,
> as SUNRPC has done in commit a1231fda7e94 ("SUNRPC: Set memalloc_nofs_save()
> on all rpciod/xprtiod jobs").
> 
> This will cause corruption in current->task_frag when recursing into the
> network layer for those subsystems during page fault or reclaim.  The
> corruption is difficult to diagnose because stack traces may not contain the
> offending subsystem at all.  The corruption is unlikely to show up in
> testing because it requires memory pressure, and so subsystems that
> convert to memalloc_nofs_save/restore are likely to continue to run into
> this issue.
> 
> [...]

Here is the summary with links:
  - [net,v4,1/3] net: Introduce sk_use_task_frag in struct sock.
    https://git.kernel.org/netdev/net/c/fb87bd47516d
  - [net,v4,2/3] Treewide: Stop corrupting socket's task_frag
    https://git.kernel.org/netdev/net/c/98123866fcf3
  - [net,v4,3/3] net: simplify sk_page_frag
    https://git.kernel.org/netdev/net/c/08f65892c5ee

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


