Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7AE50687A
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 12:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240336AbiDSKQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 06:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiDSKQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 06:16:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D31825C53
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 03:14:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9F3EB815D8
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 10:13:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4013C385A7;
        Tue, 19 Apr 2022 10:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650363238;
        bh=s/gKmqAuzdty+kGylc0lVYpcfR5z/aek1ZDpCxeOUkU=;
        h=From:To:Cc:Subject:Date:From;
        b=kgsITyojMLCyI0znJFglm4sdlP2lRZB3Ituid0HNmfydbmkH1mfc1t7pVuUKRt42n
         h8sXKSbqXOWO1QbN89zdc8B+/J9AQ2QjITgyGY8cX+H7u2LnMSn4UmXuNLSaHYfRQG
         pOKTmWj8PssD5mn4oE1VLIss3cZxvyNR3XKCn/HwFja80NVocdSxHC3BP9LGjJ6c+e
         hXdDnl3R7H03ouVZDmGc+7AS81G7JxbS7fyvYO6193wxoraUj67PAguwhticH/tzgs
         yfx0OdOJcMKY4Y8Rz583oXUZIS/NTlKe6FSTw+CH6yG7FsxpBUGo8IWWejbriveS8g
         l5dNlK2Cacxdw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH net-next v1 00/17] Extra IPsec cleanup
Date:   Tue, 19 Apr 2022 13:13:36 +0300
Message-Id: <cover.1650363043.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Changelog:
v1:
 * changed target from mlx5-next to net-next.
 * Improved commit message in patch #1
 * Left function names intact, with _accel_ word in it.
v0: https://lore.kernel.org/all/cover.1649578827.git.leonro@nvidia.com

--------------------
After FPGA IPsec removal, we can go further and make sure that flow
steering logic is aligned to mlx5_core standard together with deep
cleaning of whole IPsec path.

Thanks

Leon Romanovsky (17):
  net/mlx5: Simplify IPsec flow steering init/cleanup functions
  net/mlx5: Check IPsec TX flow steering namespace in advance
  net/mlx5: Don't hide fallback to software IPsec in FS code
  net/mlx5: Reduce useless indirection in IPsec FS add/delete flows
  net/mlx5: Store IPsec ESN update work in XFRM state
  net/mlx5: Remove useless validity check
  net/mlx5: Merge various control path IPsec headers into one file
  net/mlx5: Remove indirections from esp functions
  net/mlx5: Simplify HW context interfaces by using SA entry
  net/mlx5: Clean IPsec FS add/delete rules
  net/mlx5: Make sure that no dangling IPsec FS pointers exist
  net/mlx5: Don't advertise IPsec netdev support for non-IPsec device
  net/mlx5: Simplify IPsec capabilities logic
  net/mlx5: Remove not-supported ICV length
  net/mlx5: Cleanup XFRM attributes struct
  net/mlx5: Allow future addition of IPsec object modifiers
  net/mlx5: Don't perform lookup after already known sec_path

 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |   1 -
 .../ethernet/mellanox/mlx5/core/en/params.c   |   2 +-
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 174 +++------
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  85 +++-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 362 ++++++------------
 .../mellanox/mlx5/core/en_accel/ipsec_fs.h    |   4 +-
 .../mlx5/core/en_accel/ipsec_offload.c        | 331 +++-------------
 .../mlx5/core/en_accel/ipsec_offload.h        |  14 -
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c  |   6 +-
 .../mellanox/mlx5/core/en_accel/ipsec_stats.c |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   1 -
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |   2 +-
 include/linux/mlx5/accel.h                    | 153 --------
 include/linux/mlx5/mlx5_ifc.h                 |   2 -
 15 files changed, 320 insertions(+), 823 deletions(-)
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.h
 delete mode 100644 include/linux/mlx5/accel.h

-- 
2.35.1

