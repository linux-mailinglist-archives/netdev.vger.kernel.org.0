Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E61B54F20B9
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 04:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiDEB0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 21:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiDEB0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 21:26:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F456282560;
        Mon,  4 Apr 2022 17:38:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F128B81ACE;
        Tue,  5 Apr 2022 00:33:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB376C2BBE4;
        Tue,  5 Apr 2022 00:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649118805;
        bh=YSFtuUAqB2/ReZ8hG4SKRlDqnAPGKpbCyB9tK2n6JDg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hLVyFlpfDATmZr5XGDrA5o2tW4Uc/njYc3HnyYS97SwPrMihRlv8F5i9GKUHv9kE7
         zuttzYRilaN1bC1amXThpboMBXg4PIlW6SpLPDvBv419u6QE2v+W+GR15gxy6UeYS6
         X2hb+RmYygXnGkr11tkfWxwYtokTT8Qwh6W/z/fGwwJsQsm70tYw7LX+MFkBGyeZHq
         RLIQzG+ChmmiQFwcbQwh1ZSTlQyNJAg+9yr+DEx8Xgz+mWdPXi7Ut+28690acjXHYD
         D7DdIVKxpJGnqbSTkM5/eWReADCF099Mnj5mMmvVeIjzeJ5tJ64kftaaFGD7CfOygJ
         j7a0KanXvwr4Q==
Date:   Mon, 4 Apr 2022 17:33:22 -0700
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH mlx5-next 4/5] net/mlx5: Remove tls vs. ktls separation
 as it is the same
Message-ID: <20220405003322.afko7uo527w5j3zu@sx1>
References: <cover.1649073691.git.leonro@nvidia.com>
 <67e596599edcffb0de43f26551208dfd34ac777e.1649073691.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <67e596599edcffb0de43f26551208dfd34ac777e.1649073691.git.leonro@nvidia.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04 Apr 15:08, Leon Romanovsky wrote:
>From: Leon Romanovsky <leonro@nvidia.com>
>
>After removal FPGA TLS, we can remove tls->ktls indirection too,
>as it is the same thing.
>
>Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
>Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>---
> .../net/ethernet/mellanox/mlx5/core/Makefile  |  2 +-
> .../ethernet/mellanox/mlx5/core/en/params.c   |  2 +-
> .../mellanox/mlx5/core/en_accel/en_accel.h    | 11 +--
> .../mellanox/mlx5/core/en_accel/ktls.c        | 22 ++++-
> .../mellanox/mlx5/core/en_accel/ktls.h        | 32 +++++++
> .../mellanox/mlx5/core/en_accel/ktls_rx.c     |  2 +-
> .../en_accel/{tls_stats.c => ktls_stats.c}    | 38 ++++-----
> .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 18 +++-
> .../mellanox/mlx5/core/en_accel/ktls_txrx.h   | 28 +++++-
> .../mellanox/mlx5/core/en_accel/tls.c         | 70 ---------------
> .../mellanox/mlx5/core/en_accel/tls.h         | 85 -------------------
> .../mellanox/mlx5/core/en_accel/tls_rxtx.c    | 70 ---------------
> .../mellanox/mlx5/core/en_accel/tls_rxtx.h    | 85 -------------------
> .../net/ethernet/mellanox/mlx5/core/en_main.c |  8 +-
> .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  5 +-
> .../ethernet/mellanox/mlx5/core/en_stats.c    |  8 +-
> 16 files changed, 130 insertions(+), 356 deletions(-)
> rename drivers/net/ethernet/mellanox/mlx5/core/en_accel/{tls_stats.c => ktls_stats.c} (76%)

Why not ktls_*.c => tls_*.c ? 

Since we now have one TLS implementation, it would've been easier to maybe
repurpose TLS to be KTLS only and avoid renaming every TLS to KTLS in all
functions and files.

So just keep tls.c and all mlx5_tls_xyz functions and implement ktls
directly in them, the renaming will be done only on the ktls implementation
part of the code rather than in every caller.

> delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
> delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
> delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
> delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
>

