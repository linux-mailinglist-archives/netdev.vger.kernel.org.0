Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7826EDE80
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 10:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbjDYIuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 04:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjDYIuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 04:50:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181671700
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 01:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 986B762CE3
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 08:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 00B80C4339B;
        Tue, 25 Apr 2023 08:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682412619;
        bh=zgxSSz7a610ogue6OzT+CSQxyuuHU99D7tHY+odX9lI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aGo3Mj2jDYbb9eow8cAX/yzDRsD/bElxg+zpSh5KC+U4NDgql7/+DZyauY7fOFt02
         YiLAxU36PxBPoRwexcEugaM3kfWISpJZcy95NpVzL2i1/PtELBs6pL+UbxWFPX+izl
         olzJGxBzuElmRzU6J5wA5flI0B6DYK6BgrjbdKtzNnn1YNt+tLUJywCx2/Xzp6sCg5
         OHTjeu0lIYsXQmc7gd9F95VPvA5sHomBWvgs4g64pZV5RD+T/paBJ5damAxxgp/1IP
         2mhdZ+oGI9B16qveQrR2qQkqQW9xpqU6yCrEb8a7xoQ4U2f/qJrJz6zsita0sQXoN4
         GCnL7/q5Eq6+A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DA811E5FFC9;
        Tue, 25 Apr 2023 08:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net] tcp/udp: Fix memleaks of sk and zerocopy skbs with TX
 timestamp.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168241261889.1225.15716144082558476556.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Apr 2023 08:50:18 +0000
References: <20230424222022.46681-1-kuniyu@amazon.com>
In-Reply-To: <20230424222022.46681-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, willemb@google.com, kuni1840@gmail.com,
        netdev@vger.kernel.org, syzkaller@googlegroups.com
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 24 Apr 2023 15:20:22 -0700 you wrote:
> syzkaller reported [0] memory leaks of an UDP socket and ZEROCOPY
> skbs.  We can reproduce the problem with these sequences:
> 
>   sk = socket(AF_INET, SOCK_DGRAM, 0)
>   sk.setsockopt(SOL_SOCKET, SO_TIMESTAMPING, SOF_TIMESTAMPING_TX_SOFTWARE)
>   sk.setsockopt(SOL_SOCKET, SO_ZEROCOPY, 1)
>   sk.sendto(b'', MSG_ZEROCOPY, ('127.0.0.1', 53))
>   sk.close()
> 
> [...]

Here is the summary with links:
  - [v4,net] tcp/udp: Fix memleaks of sk and zerocopy skbs with TX timestamp.
    https://git.kernel.org/netdev/net/c/50749f2dd685

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


