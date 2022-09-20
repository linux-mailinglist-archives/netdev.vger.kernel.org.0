Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8F95BE261
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 11:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbiITJub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 05:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiITJuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 05:50:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1378C6B8D8;
        Tue, 20 Sep 2022 02:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E51D562831;
        Tue, 20 Sep 2022 09:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4FD20C433D7;
        Tue, 20 Sep 2022 09:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663667414;
        bh=kX2EBvWZ7BlQJA8Sgf4mtTIkaLClscQRwqoplzn8F+w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iGLipXrYNs2g8myoZN31AF5AMVDi9F7fpr2rQbYV9xIkXKvb5U5f9OmhsyoUXxxma
         TK7TZCi5lUTncUgdCTP0k0a/7gb+JCEFUrokJrVKSqJo3LAA/O4TBp3nIbgOz+PdEZ
         B5sq27tZD50rlW6Dgl5bSEePtETNennnxGl7LeDvXHqbiKGMLq1SJT4iyHqSepLoyl
         dGUyZDZNc4VRweknhSSq74Ui9ZnnJBH+dP/5We0Kx1zpPwJlSiObzQW8NwZgFnM2n7
         Vz6VYdmMXf1KKap52E2b8UQ9COnXhdLwZz8G/CtP/qko1QCpoSvLjHG/5a1n/QnScV
         eZajxpUjQH9nQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 36080E21EE2;
        Tue, 20 Sep 2022 09:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net/mlx5e: Ensure macsec_rule is always
 initiailized in macsec_fs_{r,t}x_add_rule()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166366741421.25964.18299631498168125673.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 09:50:14 +0000
References: <20220911085748.461033-1-nathan@kernel.org>
In-Reply-To: <20220911085748.461033-1-nathan@kernel.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     saeedm@nvidia.com, leon@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ndesaulniers@google.com, trix@redhat.com, borisp@nvidia.com,
        raeds@nvidia.com, liorna@nvidia.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 11 Sep 2022 01:57:50 -0700 you wrote:
> Clang warns:
> 
>   drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c:539:6: error: variable 'macsec_rule' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
>           if (err)
>               ^~~
>   drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c:598:9: note: uninitialized use occurs here
>           return macsec_rule;
>                 ^~~~~~~~~~~
>   drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c:539:2: note: remove the 'if' if its condition is always false
>           if (err)
>           ^~~~~~~~
>   drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c:523:38: note: initialize the variable 'macsec_rule' to silence this warning
>           union mlx5e_macsec_rule *macsec_rule;
>                                               ^
>                                               = NULL
>   drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c:1131:6: error: variable 'macsec_rule' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
>           if (err)
>               ^~~
>   drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c:1215:9: note: uninitialized use occurs here
>           return macsec_rule;
>                 ^~~~~~~~~~~
>   drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c:1131:2: note: remove the 'if' if its condition is always false
>           if (err)
>           ^~~~~~~~
>   drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c:1118:38: note: initialize the variable 'macsec_rule' to silence this warning
>           union mlx5e_macsec_rule *macsec_rule;
>                                               ^
>                                               = NULL
>   2 errors generated.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net/mlx5e: Ensure macsec_rule is always initiailized in macsec_fs_{r,t}x_add_rule()
    https://git.kernel.org/netdev/net-next/c/2e50e9bf328f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


