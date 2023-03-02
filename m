Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8C1E6A7A90
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 05:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbjCBEkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 23:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjCBEkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 23:40:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85FC714EBC;
        Wed,  1 Mar 2023 20:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 265A6614B9;
        Thu,  2 Mar 2023 04:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 71DC4C433EF;
        Thu,  2 Mar 2023 04:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677732018;
        bh=+aQQajenD/3xZjC/sO5anyHnziI4cfQqlfKO5Hty9vY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dzEL0CU3xxPkVWQ+kD905V11ypmUad5dW3CirSjrocM9jalq7I6xkFNDNI0K8d6GB
         MRIfeZOxfBAMAfryXBTP255yJVrWAKaLO1tQxCo+5IyRJ1YMBhGuKJS5BU0P+Iqmfr
         UWxeCEmUH0CkEyXHdOrHtPG1KUIgP/kXsoY78jYcvvUI+vYQT7DYXc3U2uQfiC2tl1
         ew4/4TWvrzCabGjwBXfxICoBna4I9noWDuDNpS28u11JzntOdcqYqmtkdqdF7cGSKC
         EQHV6c0+LB+7uFjTpxpZ8BtDZ9Lr5fzM0IkZGbeScWqHfwpOweKu5CvgxuTE6r62eu
         t93RB92iW+x+w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4784BC43161;
        Thu,  2 Mar 2023 04:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: tls: fix possible race condition between
 do_tls_getsockopt_conf() and do_tls_setsockopt_conf()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167773201828.21303.36408834016427721.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Mar 2023 04:40:18 +0000
References: <20230228023344.9623-1-hbh25y@gmail.com>
In-Reply-To: <20230228023344.9623-1-hbh25y@gmail.com>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     borisp@nvidia.com, john.fastabend@gmail.com, kuba@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        davejwatson@fb.com, aviadye@mellanox.com, ilyal@mellanox.com,
        fw@strlen.de, sd@queasysnail.net, netdev@vger.kernel.org,
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

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 28 Feb 2023 10:33:44 +0800 you wrote:
> ctx->crypto_send.info is not protected by lock_sock in
> do_tls_getsockopt_conf(). A race condition between do_tls_getsockopt_conf()
> and do_tls_setsockopt_conf() can cause a NULL point dereference or
> use-after-free read when memcpy.
> 
> Please check the following link for pre-information:
>  https://lore.kernel.org/all/Y/ht6gQL+u6fj3dG@hog/
> 
> [...]

Here is the summary with links:
  - [v2] net: tls: fix possible race condition between do_tls_getsockopt_conf() and do_tls_setsockopt_conf()
    https://git.kernel.org/netdev/net/c/49c47cc21b5b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


