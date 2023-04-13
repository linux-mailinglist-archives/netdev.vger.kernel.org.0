Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9F5C6E135E
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 19:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbjDMRUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 13:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjDMRUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 13:20:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A0426A6
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 10:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D62764065
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 17:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B2645C4339B;
        Thu, 13 Apr 2023 17:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681406417;
        bh=7SJt92UKuNK4TwabKfZk2XAxxfzqCSncJjl1hGXgNC8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=l37i37Hz28xVt53UvC76JEODfA79O7PPAWoE9uKarv3cgxSRHDgguQqAQCPT//QHg
         5MqYE0VAUG2xfXWXYLTwVl5Ej3YJE2V9cBtZcTVcLn9pHa5yiyKjA2iWZn1yGl9ih8
         ZGCRQmVKDGOux0AAqmbY0s5oxVW/kw5n7XxftxnmAETf20O62tfnB/Bhy5KvyherJx
         W4jYtOFFRa1ANVLblBWNWTa69W1EaccN9tIGktX2WkFbL/r3XZCaqW3jwFdZEB2Ar/
         nERK2l45Zg7FjUOQHUo/pg67qU2rDYRpknbw7hI//kO7xLZRYCG1G55plipzYos40P
         CgEi06S0BCH3g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 99648E52443;
        Thu, 13 Apr 2023 17:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] udp6: fix potential access to stale information
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168140641762.8255.15958713357480902639.git-patchwork-notify@kernel.org>
Date:   Thu, 13 Apr 2023 17:20:17 +0000
References: <20230412130308.1202254-1-edumazet@google.com>
In-Reply-To: <20230412130308.1202254-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        lena.wang@mediatek.com, maze@google.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 12 Apr 2023 13:03:08 +0000 you wrote:
> lena wang reported an issue caused by udpv6_sendmsg()
> mangling msg->msg_name and msg->msg_namelen, which
> are later read from ____sys_sendmsg() :
> 
> 	/*
> 	 * If this is sendmmsg() and sending to current destination address was
> 	 * successful, remember it.
> 	 */
> 	if (used_address && err >= 0) {
> 		used_address->name_len = msg_sys->msg_namelen;
> 		if (msg_sys->msg_name)
> 			memcpy(&used_address->name, msg_sys->msg_name,
> 			       used_address->name_len);
> 	}
> 
> [...]

Here is the summary with links:
  - [net] udp6: fix potential access to stale information
    https://git.kernel.org/netdev/net/c/1c5950fc6fe9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


