Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2296E0A05
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 11:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjDMJUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 05:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjDMJUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 05:20:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37692708;
        Thu, 13 Apr 2023 02:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91A7463CED;
        Thu, 13 Apr 2023 09:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EEC6BC4339C;
        Thu, 13 Apr 2023 09:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681377617;
        bh=zTbohHnhZ+E+WF9ytqc+sqgp8zGneGfCVvSptQFgzo8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rk+bQIdJYHhpVswOOqOmSi+k5FVHAqTTXS1gqoDiydkWJRQyPc782lD6K3l/OTng/
         yHysuZexUAiEAgPYp9iCoj7s1/0/Um6ckq3pE/0Y9raNsTDZF1K5n/uS9vmK2szokG
         C+SCH+GCQ9+/Xz1/Bwz14q36f4bOD2B5jnTDZAQIRFH4kfat4nAL3Tsa3XOdInrJJ9
         oJydSY50dtS3MRUx1nKvv8oOHAKp8scukuUjIwGKxTXWh7fFvPZyRzu76vT0u3Ieao
         bEqYVJB7IyK7GiarXv64+onqigFu7qSB9mh5gSTUxs0O4p+/GlyYq11LgzZRLTXEPt
         j3dBAmbocpOdg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D6735E4508E;
        Thu, 13 Apr 2023 09:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] bnxt_en: Allow to set switchdev mode without
 existing VFs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168137761687.8748.1628157821797232653.git-patchwork-notify@kernel.org>
Date:   Thu, 13 Apr 2023 09:20:16 +0000
References: <20230411120443.126055-1-ivecera@redhat.com>
In-Reply-To: <20230411120443.126055-1-ivecera@redhat.com>
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     netdev@vger.kernel.org, mschmidt@redhat.com,
        michael.chan@broadcom.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 11 Apr 2023 14:04:42 +0200 you wrote:
> Remove an inability of bnxt_en driver to set eswitch to switchdev
> mode without existing VFs by:
> 
> 1. Allow to set switchdev mode in bnxt_dl_eswitch_mode_set() so
>    representors are created only when num_vfs > 0 otherwise just
>    set bp->eswitch_mode
> 2. Do not automatically change bp->eswitch_mode during
>    bnxt_vf_reps_create() and bnxt_vf_reps_destroy() calls so
>    the eswitch mode is managed only by an user by devlink.
>    Just set temporarily bp->eswitch_mode to legacy to avoid
>    re-opening of representors during destroy.
> 3. Create representors in bnxt_sriov_enable() if current eswitch
>    mode is switchdev one
> 
> [...]

Here is the summary with links:
  - [net-next,v2] bnxt_en: Allow to set switchdev mode without existing VFs
    https://git.kernel.org/netdev/net-next/c/f032d8a9c8b3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


