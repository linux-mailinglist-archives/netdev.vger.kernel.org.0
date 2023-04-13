Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 953556E08CD
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 10:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbjDMIUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 04:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbjDMIUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 04:20:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C4A86BC;
        Thu, 13 Apr 2023 01:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A489E63B1D;
        Thu, 13 Apr 2023 08:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 04244C4339C;
        Thu, 13 Apr 2023 08:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681374018;
        bh=9qRiTnPw3SjldYXMI+u4r64MI274VuebgRbzX+bBWKc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nSVeaCC6DwaSJ7qMCjCRTI4rDD8IjoJmGc+E3K0UlEGaBF2iT7A6VU+U9apMhIUW/
         QyZtx/9BMhONeI15EElwbfEWTJ6OOusg+DEkDObwEnpQETYIl5BH0iZLsumn2ati6Y
         6/o+/sCAOSGrqq9hIqldAdyLRTjbWp/ZpY6SgQmvL4MYzVw+oT1xSv7tOqQKiD3KK3
         jpxQS+9kXSjQ61fldxOSJVEmKI2N4flr1kVXk6ZqrOASwl57x4n7fFy8aWSbjqBSp7
         WJ+8fI1hFclgBBb5bg2fqo4Y5WgBZxi3f9sfOlXTWoJt4YnrYLV50sw8kzSU2wa2cX
         Fo3OBihAPW8qg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E056AE4508E;
        Thu, 13 Apr 2023 08:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sctp: fix a potential overflow in sctp_ifwdtsn_skip
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168137401791.27296.7483755007672474522.git-patchwork-notify@kernel.org>
Date:   Thu, 13 Apr 2023 08:20:17 +0000
References: <2a71bffcd80b4f2c61fac6d344bb2f11c8fd74f7.1681155810.git.lucien.xin@gmail.com>
In-Reply-To: <2a71bffcd80b4f2c61fac6d344bb2f11c8fd74f7.1681155810.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, marcelo.leitner@gmail.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 10 Apr 2023 15:43:30 -0400 you wrote:
> Currently, when traversing ifwdtsn skips with _sctp_walk_ifwdtsn, it only
> checks the pos against the end of the chunk. However, the data left for
> the last pos may be < sizeof(struct sctp_ifwdtsn_skip), and dereference
> it as struct sctp_ifwdtsn_skip may cause coverflow.
> 
> This patch fixes it by checking the pos against "the end of the chunk -
> sizeof(struct sctp_ifwdtsn_skip)" in sctp_ifwdtsn_skip, similar to
> sctp_fwdtsn_skip.
> 
> [...]

Here is the summary with links:
  - [net] sctp: fix a potential overflow in sctp_ifwdtsn_skip
    https://git.kernel.org/netdev/net/c/32832a2caf82

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


