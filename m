Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70CCB6D68E6
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 18:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235398AbjDDQao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 12:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235415AbjDDQag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 12:30:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C43E4685
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 09:30:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05E2E63389
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 16:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE73EC433A7;
        Tue,  4 Apr 2023 16:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680625823;
        bh=x2mSMBQJLRcoqQfqxefNRBMRs5XAOfvjpYvpFERuwtE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f5dpZp9T4Yj7R5LCBU4KNotcymMbP8TjI79K7RQhJ0oKoayKGhmUVl/6ukNalewL4
         5V9FB4CuD9h7SI1wH+HWJxWyQUNGYi0XQnDkUHtlT356XAKDo6Sw0lT7R1DwKz5hhc
         XTjeCv7ZCP6FNhrvbYOMs98sVI+YD51c04TEFo0D/u18jhu6WB2EHTnCBuWYNH1ezG
         YJz4u2OzKuwxRRHkgBwvHxYFk3/NiWGd98WQa2elx2N2kRQuYFnZcosODGkk690Aif
         /e0I3ytLPCIcdhPWrSZxfM7B3Nl4UQpq/iXfzCb1T7At2ynnbs+u8leiamt8Fv54st
         AwvlfsTmFUlrg==
Date:   Tue, 4 Apr 2023 19:30:18 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>
Subject: Re: [GIT PULL] Improve IPsec limits, ESN and replay window
Message-ID: <20230404163018.GJ4514@unreal>
References: <20230403064154.12443-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403064154.12443-1-leon@kernel.org>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 09:41:54AM +0300, Leon Romanovsky wrote:
> This series overcomes existing hardware limitations in Mellanox ConnectX
> devices around handling IPsec soft and hard limits.
> 
> In addition, the ESN logic is tied and added an interface to configure
> replay window sequence numbers through existing iproute2 interface.
> 
>   ip xfrm state ... [ replay-seq SEQ ] [ replay-oseq SEQ ]
>                     [ replay-seq-hi SEQ ] [ replay-oseq-hi SEQ ]
> 
> Link: https://lore.kernel.org/all/cover.1680162300.git.leonro@nvidia.com
> Signed-off-by: Leon Romanovsky <leon@kernel.org>
> 
> ----------------------------------------------------------------
> 
> The following changes since commit 5a6cddb89b51d99a7702e63829644a5860dd9c41:
> 
>   net/mlx5e: Update IPsec per SA packets/bytes count (2023-03-20 11:29:52 +0200)
> 
> are available in the Git repository at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/ tags/ipsec-esn-replay
> 
> for you to fetch changes up to 9f758558e309d11ef31dbdabdb1e3aa1003aebf9:
> 
>   net/mlx5e: Simulate missing IPsec TX limits hardware functionality (2023-04-03 09:29:47 +0300)
> 
> ----------------------------------------------------------------
> Leon Romanovsky (10):
>       net/mlx5e: Factor out IPsec ASO update function
>       net/mlx5e: Prevent zero IPsec soft/hard limits
>       net/mlx5e: Add SW implementation to support IPsec 64 bit soft and hard limits
>       net/mlx5e: Overcome slow response for first IPsec ASO WQE
>       xfrm: don't require advance ESN callback for packet offload

Hi Steffen,

Can you please provide your Acked-by for this patch?
https://lore.kernel.org/all/9f3dfc3fef2cfcd191f0c5eee7cf0aa74e7f7786.1680162300.git.leonro@nvidia.com

Thanks


>       net/mlx5e: Remove ESN callbacks if it is not supported
>       net/mlx5e: Set IPsec replay sequence numbers
>       net/mlx5e: Reduce contention in IPsec workqueue
>       net/mlx5e: Generalize IPsec work structs
>       net/mlx5e: Simulate missing IPsec TX limits hardware functionality
> 
>  .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   | 329 ++++++++++++++++++---
>  .../ethernet/mellanox/mlx5/core/en_accel/ipsec.h   |  47 ++-
>  .../mellanox/mlx5/core/en_accel/ipsec_fs.c         |  31 +-
>  .../mellanox/mlx5/core/en_accel/ipsec_offload.c    | 198 ++++++++++---
>  net/xfrm/xfrm_device.c                             |   2 +-
>  5 files changed, 496 insertions(+), 111 deletions(-)
