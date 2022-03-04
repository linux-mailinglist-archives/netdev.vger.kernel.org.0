Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C98C54CD447
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 13:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239703AbiCDMbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 07:31:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbiCDMbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 07:31:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 330711B2ADB;
        Fri,  4 Mar 2022 04:30:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB251B8288E;
        Fri,  4 Mar 2022 12:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8F6C5C340E9;
        Fri,  4 Mar 2022 12:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646397011;
        bh=QA8RCFymaLyeZeKiUg1NVuIP/Pi6PirolXYtEgX5gjY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lwWrslfh9fx+fLjOIhOy0o32JPUMw7IrLXbPnbKIHh9w4pYAfVdCYawxM5AOD65Jn
         UiwH/K3Oy6UInVx6dgnqJun1slSvmzlCsBEW4qseaI3MrIPn68RGKBUcb4448JZt0N
         wL4aY79C7XDW/2uOSOEDBzslPIGtwDRXAwn0hB6qcKmTFBmkrsT5Wu0YOLbbxXIVni
         RLFvLIy6z5UEIaN3p2xupH0EQpXZ451VcTDidvz91oRDsom257h7Xc6bxtGLG+AkOn
         lai2y34Pq9J7t3P8NV6Qt1PpslJeH1C4s0WH6HRobuR02mjZTBDuCVVAguBH2C6END
         Xl2hn9oeAahpw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 727E4E6D4BB;
        Fri,  4 Mar 2022 12:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/7] net: dev: add skb drop reasons to
 net/core/dev.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164639701146.17360.7146529640103224533.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Mar 2022 12:30:11 +0000
References: <20220304060046.115414-1-imagedong@tencent.com>
In-Reply-To: <20220304060046.115414-1-imagedong@tencent.com>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     dsahern@kernel.org, kuba@kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        imagedong@tencent.com, edumazet@google.com, talalahmad@google.com,
        keescook@chromium.org, ilias.apalodimas@linaro.org, alobakin@pm.me,
        flyingpeng@tencent.com, mengensun@tencent.com, atenart@kernel.org,
        bigeasy@linutronix.de, memxor@gmail.com, arnd@arndb.de,
        pabeni@redhat.com, willemb@google.com, vvs@virtuozzo.com,
        cong.wang@bytedance.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  4 Mar 2022 14:00:39 +0800 you wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> In the commit c504e5c2f964 ("net: skb: introduce kfree_skb_reason()"),
> we added the support of reporting the reasons of skb drops to kfree_skb
> tracepoint. And in this series patches, reasons for skb drops are added
> to the link layer, which means that 'net/core/dev.c' is our target.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/7] net: dev: use kfree_skb_reason() for sch_handle_egress()
    https://git.kernel.org/netdev/net-next/c/98b4d7a4e737
  - [net-next,v2,2/7] net: skb: introduce the function kfree_skb_list_reason()
    https://git.kernel.org/netdev/net-next/c/215b0f1963d4
  - [net-next,v2,3/7] net: dev: add skb drop reasons to __dev_xmit_skb()
    https://git.kernel.org/netdev/net-next/c/7faef0547f4c
  - [net-next,v2,4/7] net: dev: use kfree_skb_reason() for enqueue_to_backlog()
    https://git.kernel.org/netdev/net-next/c/44f0bd40803c
  - [net-next,v2,5/7] net: dev: use kfree_skb_reason() for do_xdp_generic()
    https://git.kernel.org/netdev/net-next/c/7e726ed81e1d
  - [net-next,v2,6/7] net: dev: use kfree_skb_reason() for sch_handle_ingress()
    https://git.kernel.org/netdev/net-next/c/a568aff26ac0
  - [net-next,v2,7/7] net: dev: use kfree_skb_reason() for __netif_receive_skb_core()
    https://git.kernel.org/netdev/net-next/c/6c2728b7c141

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


