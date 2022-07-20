Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECCD057B3A8
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 11:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiGTJUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 05:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbiGTJUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 05:20:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01AA06575
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 02:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6531661B09
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 09:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BC47DC341CE;
        Wed, 20 Jul 2022 09:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658308813;
        bh=LIGbF1wJiVpRfb0WtEq6t4kqAGth7ytmgSKeXNEBtSg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VsdY+Jd9Sdn6T6xsb6mdfHeurPQCc5OhS2VGKNcmnvQh6PxI/iqlEOwCb/fVBFLHR
         l2yY+kT5hzQCmRjTYw97R2SVvYCsvirNdfs4KT3/j4cszOQ3CAQAh2+0jcVHw7Zj1q
         g1PjBjDZItg4hvPd3cKyB+/oMUS4C72XZVz7C6EvI4eXM802VNq4XrTeDeWie4DHqQ
         X4RwwV+NwLmauv9bNq/UucJingbnq9MkzaXD9/JB9WFnBKaz3PPOaw1xyoEK+Oz001
         lJYtL6CEAUJg+4a5YiW1MF7cA60pBpndf+PWmR6DRqQh7FTHrjt3w0e24dkCoDbT5H
         k+Y7ljZg9o7QA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9EA00D9DDDD;
        Wed, 20 Jul 2022 09:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] xfrm: xfrm_policy: fix a possible double xfrm_pols_put()
 in xfrm_bundle_lookup()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165830881364.15784.15063193828003797442.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Jul 2022 09:20:13 +0000
References: <20220720080912.1183369-2-steffen.klassert@secunet.com>
In-Reply-To: <20220720080912.1183369-2-steffen.klassert@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Steffen Klassert <steffen.klassert@secunet.com>:

On Wed, 20 Jul 2022 10:09:11 +0200 you wrote:
> From: Hangyu Hua <hbh25y@gmail.com>
> 
> xfrm_policy_lookup() will call xfrm_pol_hold_rcu() to get a refcount of
> pols[0]. This refcount can be dropped in xfrm_expand_policies() when
> xfrm_expand_policies() return error. pols[0]'s refcount is balanced in
> here. But xfrm_bundle_lookup() will also call xfrm_pols_put() with
> num_pols == 1 to drop this refcount when xfrm_expand_policies() return
> error.
> 
> [...]

Here is the summary with links:
  - [1/2] xfrm: xfrm_policy: fix a possible double xfrm_pols_put() in xfrm_bundle_lookup()
    https://git.kernel.org/netdev/net/c/f85daf0e7253
  - [2/2] net: ipv4: fix clang -Wformat warnings
    https://git.kernel.org/netdev/net/c/e79b9473e9b5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


