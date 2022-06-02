Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0E7853BDF7
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 20:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238104AbiFBSUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 14:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238022AbiFBSUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 14:20:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F8685E15C
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 11:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43D74616F8
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 18:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 992E8C3411E;
        Thu,  2 Jun 2022 18:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654194014;
        bh=J7lFFlCv7ODu1asXQ+yY80WhrDMq/s3tCMaC8aDwrHM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=myPGIznYk4UGkDBHW7V7Vby+oMhr1SgIuKVGJLj89dBwv7PjuVDEGV2PnrcFC/V+U
         G4IxMGA8V4che5Z71KIDcOH3IfmNze2v3ZViClN+bYU5PmDlB0zQ0UMc4BhpC+JBCu
         aCiI2lpMobC4D8lzyeIMkwj9K+nRdfJ5bfSjHX/4UY++ncSBFtDFLMQju1n4iVLWrU
         g3M/TkjnaUf2Y49JoPjC/XA+zrh9qL2sL17EAd6a3WoCYw1k4S4LGYrbIazzSo03HR
         3L13I2FCTAhtKWX8HjDLw66Bi23XLjkyjl0I1VooShS7TChLB/1rfw1el6B323QgWd
         c3rZhkGyIt4dw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7A8ADF03950;
        Thu,  2 Jun 2022 18:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net v3] tipc: check attribute length for bearer name
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165419401449.24492.4715631176420067438.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Jun 2022 18:20:14 +0000
References: <20220602063053.5892-1-hoang.h.le@dektech.com.au>
In-Reply-To: <20220602063053.5892-1-hoang.h.le@dektech.com.au>
To:     Hoang Le <hoang.h.le@dektech.com.au>
Cc:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        tung.q.nguyen@dektech.com.au, kuba@kernel.org,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        syzbot+e820fdc8ce362f2dea51@syzkaller.appspotmail.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu,  2 Jun 2022 13:30:53 +0700 you wrote:
> syzbot reported uninit-value:
> =====================================================
> BUG: KMSAN: uninit-value in string_nocheck lib/vsprintf.c:644 [inline]
> BUG: KMSAN: uninit-value in string+0x4f9/0x6f0 lib/vsprintf.c:725
>  string_nocheck lib/vsprintf.c:644 [inline]
>  string+0x4f9/0x6f0 lib/vsprintf.c:725
>  vsnprintf+0x2222/0x3650 lib/vsprintf.c:2806
>  vprintk_store+0x537/0x2150 kernel/printk/printk.c:2158
>  vprintk_emit+0x28b/0xab0 kernel/printk/printk.c:2256
>  vprintk_default+0x86/0xa0 kernel/printk/printk.c:2283
>  vprintk+0x15f/0x180 kernel/printk/printk_safe.c:50
>  _printk+0x18d/0x1cf kernel/printk/printk.c:2293
>  tipc_enable_bearer net/tipc/bearer.c:371 [inline]
>  __tipc_nl_bearer_enable+0x2022/0x22a0 net/tipc/bearer.c:1033
>  tipc_nl_bearer_enable+0x6c/0xb0 net/tipc/bearer.c:1042
>  genl_family_rcv_msg_doit net/netlink/genetlink.c:731 [inline]
> 
> [...]

Here is the summary with links:
  - [net,v3] tipc: check attribute length for bearer name
    https://git.kernel.org/netdev/net/c/7f36f798f89b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


