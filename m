Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31B544DD170
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 00:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiCQXvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 19:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbiCQXvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 19:51:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167E12AD5DA;
        Thu, 17 Mar 2022 16:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F28C61336;
        Thu, 17 Mar 2022 23:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E0014C340F5;
        Thu, 17 Mar 2022 23:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647561013;
        bh=0ITraNNpynPQoRSsjkBEPpV1O+S+Z0SgVeIiMRBR9xU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VFnpf1il5OC/s+QgH54g+alZ4RR9KhpuQvDuuqCMyGZjOmCZpH9BNZImEt7oLMuxM
         tbwBhupqrgrxd2KhriBFWisqp007hoz0SDu7gfzRhmmHMXHXsqXNyfelx/6WX2bHqq
         q80bW09a91lti7lKUNJ1kk4L0SaMNzEwo93VSsHBFWHMINTOr8P6HG2lUvKbvsiaCU
         mkjTBdtOSZZzuFRlDORjQElOl8ddTbs/l3rBXiBktekwXKosNS688aMGpJgbfZPgFa
         v5LhBBj6Te98yn3TnWLaItmUEv8TYifVQ/g9XHL95fbVrr81DH9PQgkbVWV83v0YTE
         mFzN390o3cqvw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C9282F03845;
        Thu, 17 Mar 2022 23:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bnx2x: use correct format characters
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164756101282.14093.261670913592232770.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Mar 2022 23:50:12 +0000
References: <20220316213104.2351651-1-morbo@google.com>
In-Reply-To: <20220316213104.2351651-1-morbo@google.com>
To:     Bill Wendling <morbo@google.com>
Cc:     aelior@marvell.com, skalluru@marvell.com, manishc@marvell.com,
        davem@davemloft.net, kuba@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 16 Mar 2022 14:31:04 -0700 you wrote:
> When compiling with -Wformat, clang emits the following warnings:
> 
> drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c:6181:40: warning: format
> specifies type 'unsigned short' but the argument has type 'u32'
> (aka 'unsigned int') [-Wformat]
>         ret = scnprintf(str, *len, "%hx.%hx", num >> 16, num);
>                                     ~~~       ^~~~~~~~~
>                                     %x
> drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c:6181:51: warning: format
> specifies type 'unsigned short' but the argument has type 'u32'
> (aka 'unsigned int') [-Wformat]
>         ret = scnprintf(str, *len, "%hx.%hx", num >> 16, num);
>                                         ~~~              ^~~
>                                         %x
> drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c:6196:47: warning: format
> specifies type 'unsigned char' but the argument has type 'u32'
> (aka 'unsigned int') [-Wformat]
>         ret = scnprintf(str, *len, "%hhx.%hhx.%hhx", num >> 16, num >> 8, num);
>                                     ~~~~             ^~~~~~~~~
>                                     %x
> drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c:6196:58: warning: format
> specifies type 'unsigned char' but the argument has type 'u32'
> (aka 'unsigned int') [-Wformat]
>         ret = scnprintf(str, *len, "%hhx.%hhx.%hhx", num >> 16, num >> 8, num);
>                                          ~~~~                   ^~~~~~~~
>                                          %x
> drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c:6196:68: warning: format
> specifies type 'unsigned char' but the argument has type 'u32'
> (aka 'unsigned int') [-Wformat]
>         ret = scnprintf(str, *len, "%hhx.%hhx.%hhx", num >> 16, num >> 8, num);
>                                               ~~~~                        ^~~
>                                               %x
> 
> [...]

Here is the summary with links:
  - bnx2x: use correct format characters
    https://git.kernel.org/netdev/net-next/c/d65aea8e8298

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


