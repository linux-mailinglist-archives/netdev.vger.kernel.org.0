Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D40F4FA541
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 07:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238205AbiDIFzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 01:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbiDIFzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 01:55:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD5B338AF;
        Fri,  8 Apr 2022 22:53:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29707B82E55;
        Sat,  9 Apr 2022 05:53:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A5FC385A4;
        Sat,  9 Apr 2022 05:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649483588;
        bh=R0GA89PbrGrsoi3AypvLUQwcOEYAMuypdXieOHPZwDc=;
        h=From:To:Cc:Subject:Date:From;
        b=coxS1EbBtBF6rVslIX83DyOYpS9Pjv26vBY2Hz+w54C1/F9nCutTuRssHp0i5HETc
         GJZOUg8U1YAsKVp8GCAvsozLXLgrFpo4vNn7vY3Y4LTKDohvc4RkQ4vmM2DOpR04Ra
         D8c+g6dqB7YkczlmVxubURMj5GNwl4LVyb2+vRUqzd4cMEuepmJohmUW4WkWuWu1zI
         aabqZemcwwxJBd9ebZJn5EmX5OlwiCQGhcxuJQKOXG+wizfbhr4zbGVU+p3LW1bLj0
         s+IsbrrXO7DajZb5czcuX3VCqJ2iPyDNZR8Zshi5/0bKuQISpza3zZZ56RN4sFFqnL
         uEK/NaSRgNdZw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [GIT PULL] Please pull mlx5-next changes
Date:   Sat,  9 Apr 2022 08:53:03 +0300
Message-Id: <20220409055303.1223644-1-leon@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 3123109284176b1532874591f7c81f3837bbdc17:

  Linux 5.18-rc1 (2022-04-03 14:08:21 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git mlx5-next

for you to fetch changes up to 2984287c4c19949d7eb451dcad0bd5c54a2a376f:

net/mlx5: Remove not-implemented IPsec capabilities (2022-04-09 08:25:07 +0300)
----------------------------------------------------------------
Mellanox shared branch that includes:
 * Removal of FPGA TLS code https://lore.kernel.org/all/cover.1649073691.git.leonro@nvidia.com

  Mellanox INNOVA TLS cards are EOL in May, 2018 [1]. As such, the code
  is unmaintained, untested and not in-use by any upstream/distro oriented
  customers. In order to reduce code complexity, drop the kernel code,
  clean build config options and delete useless kTLS vs. TLS separation.

  [1] https://network.nvidia.com/related-docs/eol/LCR-000286.pdf

 * Removal of FPGA IPsec code https://lore.kernel.org/all/cover.1649232994.git.leonro@nvidia.com

  Together with FPGA TLS, the IPsec went to EOL state in the November of
  2019 [1]. Exactly like FPGA TLS, no active customers exist for this
  upstream code and all the complexity around that area can be deleted.

  [2] https://network.nvidia.com/related-docs/eol/LCR-000535.pdf
   
 * Fix to undefined behavior from Borislav https://lore.kernel.org/all/20220405151517.29753-11-bp@alien8.de

Signed-of-by: Leon Romanovsky <leonro@nvidia.com>
----------------------------------------------------------------
Borislav Petkov (1):
      IB/mlx5: Fix undefined behavior due to shift overflowing the constant

Leon Romanovsky (22):
      net/mlx5_fpga: Drop INNOVA TLS support
      net/mlx5: Reliably return TLS device capabilities
      net/mlx5: Remove indirection in TLS build
      net/mlx5: Remove tls vs. ktls separation as it is the same
      net/mlx5: Cleanup kTLS function names and their exposure
      net/mlx5_fpga: Drop INNOVA IPsec support
      net/mlx5: Delete metadata handling logic
      net/mlx5: Remove not-used IDA field from IPsec struct
      net/mlx5: Remove XFRM no_trailer flag
      net/mlx5: Remove FPGA ipsec specific statistics
      RDMA/mlx5: Delete never supported IPsec flow action
      RDMA/mlx5: Drop crypto flow steering API
      RDMA/core: Delete IPsec flow action logic from the core
      net/mlx5: Remove ipsec vs. ipsec offload file separation
      net/mlx5: Remove useless IPsec device checks
      net/mlx5: Unify device IPsec capabilities check
      net/mlx5: Align flow steering allocation namespace to common style
      net/mlx5: Remove not-needed IPsec config
      net/mlx5: Move IPsec file to relevant directory
      net/mlx5: Reduce kconfig complexity while building crypto support
      net/mlx5: Remove ipsec_ops function table
      net/mlx5: Remove not-implemented IPsec capabilities

 drivers/infiniband/core/device.c                   |    2 -
 .../infiniband/core/uverbs_std_types_flow_action.c |  383 +----
 drivers/infiniband/hw/mlx5/fs.c                    |  223 +--
 drivers/infiniband/hw/mlx5/main.c                  |   31 -
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig    |   58 +-
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   12 +-
 .../net/ethernet/mellanox/mlx5/core/accel/accel.h  |   36 -
 .../net/ethernet/mellanox/mlx5/core/accel/ipsec.c  |  179 ---
 .../net/ethernet/mellanox/mlx5/core/accel/ipsec.h  |   96 --
 .../mellanox/mlx5/core/accel/ipsec_offload.h       |   38 -
 .../net/ethernet/mellanox/mlx5/core/accel/tls.c    |  125 --
 .../net/ethernet/mellanox/mlx5/core/accel/tls.h    |  156 --
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |    1 -
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |   19 +-
 .../mellanox/mlx5/core/en_accel/en_accel.h         |   11 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |   30 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.h   |   31 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         |    5 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.h         |    7 +-
 .../mlx5/core/{accel => en_accel}/ipsec_offload.c  |   95 +-
 .../mellanox/mlx5/core/en_accel/ipsec_offload.h    |   14 +
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c       |  245 +--
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h       |    3 -
 .../mellanox/mlx5/core/en_accel/ipsec_stats.c      |   63 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.c    |   71 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.h    |   86 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |    2 +-
 .../core/en_accel/{tls_stats.c => ktls_stats.c}    |   51 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |   20 +-
 .../mellanox/mlx5/core/en_accel/ktls_txrx.h        |   28 +-
 .../mellanox/mlx5/core/en_accel/ktls_utils.h       |    1 -
 .../net/ethernet/mellanox/mlx5/core/en_accel/tls.c |  247 ---
 .../net/ethernet/mellanox/mlx5/core/en_accel/tls.h |  132 --
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c         |  390 -----
 .../mellanox/mlx5/core/en_accel/tls_rxtx.h         |   91 --
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   24 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |    1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   61 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |    9 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |    1 -
 .../net/ethernet/mellanox/mlx5/core/fpga/core.h    |    3 -
 .../net/ethernet/mellanox/mlx5/core/fpga/ipsec.c   | 1582 --------------------
 .../net/ethernet/mellanox/mlx5/core/fpga/ipsec.h   |   62 -
 drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c |  622 --------
 drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.h |   74 -
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |    2 -
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   15 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |    3 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   18 +-
 include/linux/mlx5/accel.h                         |   35 +-
 include/linux/mlx5/driver.h                        |    3 -
 include/linux/mlx5/mlx5_ifc_fpga.h                 |  211 ---
 include/linux/mlx5/port.h                          |    2 +-
 include/rdma/ib_verbs.h                            |    8 -
 54 files changed, 364 insertions(+), 5354 deletions(-)
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/accel/accel.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/accel/tls.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h
 rename drivers/net/ethernet/mellanox/mlx5/core/{accel => en_accel}/ipsec_offload.c (84%)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.h
 rename drivers/net/ethernet/mellanox/mlx5/core/en_accel/{tls_stats.c => ktls_stats.c} (63%)
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.h
