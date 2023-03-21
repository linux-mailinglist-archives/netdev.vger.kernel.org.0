Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 559956C2B3F
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 08:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbjCUHTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 03:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbjCUHS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 03:18:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1933119D
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 00:18:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD092B811A3
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 07:18:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC86C433EF;
        Tue, 21 Mar 2023 07:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679383114;
        bh=ODMcJJbFDmvJ3LEuaGJLOI+SRJHbP9iRs8n5aME7ZSg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IH501S1rvixdD/k7Nq6I+7/+0Lfm+qOrluzNJ+p7BftFuHA13o3zeRW0llmbUdU+p
         6msfTiXpiUkwsQSayqjqgATpq2BtVyfej466tojn0FDcFz88ecvzb03x7Hk0QEqKFa
         bgKNnmHck4DhgUNR0GA5W6ZHchGSDAau4LrGJHfXYrpsVFp3kMq3jeBSXZRrgGSlf1
         tPhV9iur8lcAYqf4SZZd7Qyan8fxsA509oeAzi9Vh/ShWDZ92hsps74cKhbRpwvJmC
         ZH3WRKlZA/O2HoAPidDmQTsm/QcPTGSCA2Bc74sfJDnJaNN9PVufwjHGEf4aX3/EsD
         WTWL/TItRy8+A==
Date:   Tue, 21 Mar 2023 09:18:30 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Paul Blakey <paulb@nvidia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>
Subject: Re: [GIT PULL] Extend packet offload to fully support libreswan
Message-ID: <20230321071830.GN36557@unreal>
References: <20230320094722.1009304-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230320094722.1009304-1-leon@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 11:47:22AM +0200, Leon Romanovsky wrote:
> The following patches are an outcome of Raed's work to add packet
> offload support to libreswan [1].
> 
> The series includes:
>  * Priority support to IPsec policies
>  * Statistics per-SA (visible through "ip -s xfrm state ..." command)
>  * Support to IKE policy holes
>  * Fine tuning to acquire logic.
> 
> Thanks
> 
> [1] https://github.com/libreswan/libreswan/pull/986
> Link: https://lore.kernel.org/all/cover.1678714336.git.leon@kernel.org
> Signed-off-by: Leon Romanovsky <leon@kernel.org>
> 
> ----------------------------------------------------------------
> 
> The following changes since commit eeac8ede17557680855031c6f305ece2378af326:
> 
>   Linux 6.3-rc2 (2023-03-12 16:36:44 -0700)
> 
> are available in the Git repository at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/ tags/ipsec-libreswan-mlx5
> 
> for you to fetch changes up to 5a6cddb89b51d99a7702e63829644a5860dd9c41:
> 
>   net/mlx5e: Update IPsec per SA packets/bytes count (2023-03-20 11:29:52 +0200)
> 
> ----------------------------------------------------------------
> Paul Blakey (3):
>       net/mlx5: fs_chains: Refactor to detach chains from tc usage
>       net/mlx5: fs_core: Allow ignore_flow_level on TX dest
>       net/mlx5e: Use chains for IPsec policy priority offload
> 
> Raed Salem (6):
>       xfrm: add new device offload acquire flag
>       xfrm: copy_to_user_state fetch offloaded SA packets/bytes statistics
>       net/mlx5e: Allow policies with reqid 0, to support IKE policy holes
>       net/mlx5e: Support IPsec acquire default SA
>       net/mlx5e: Use one rule to count all IPsec Tx offloaded traffic
>       net/mlx5e: Update IPsec per SA packets/bytes count
> 
>  drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c         |  71 ++++--
>  drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h         |  13 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c      | 528 +++++++++++++++++++++++++++++++++++----------
>  drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c |  32 ++-
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                  |  20 +-
>  drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c       |   6 +-
>  drivers/net/ethernet/mellanox/mlx5/core/fs_core.c                |   5 +-
>  drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c          |  89 ++++----
>  drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.h          |   9 +-
>  include/net/xfrm.h                                               |   5 +
>  net/xfrm/xfrm_state.c                                            |   1 +
>  net/xfrm/xfrm_user.c                                             |   2 +
>  12 files changed, 553 insertions(+), 228 deletions(-)

Hi,

I see that this PR is marked as "Needs ACK" in patchworks:
https://patchwork.kernel.org/project/netdevbpf/patch/20230320094722.1009304-1-leon@kernel.org/

Steffen already acked on XFRM patches:
https://lore.kernel.org/netdev/ZBgjsw8exj1c46lW@gauss3.secunet.de/
https://lore.kernel.org/netdev/ZBgj07C1o39NFJW5@gauss3.secunet.de/
https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/commit/?h=ipsec-libreswan-mlx5&id=c9fa320b00cff04980b8514d497068e59a8ee131
https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/commit/?h=ipsec-libreswan-mlx5&id=e0aeb9b90acf6ee7c2d11141522ffbb5481734d3

and mlx5 ipsec is my responsibility.

So who should extra ack on this series?

Thanks
