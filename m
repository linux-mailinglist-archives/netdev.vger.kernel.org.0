Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCFC34F5C50
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 13:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233094AbiDFLgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 07:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238395AbiDFLec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 07:34:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C0355F367;
        Wed,  6 Apr 2022 01:26:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 227CCB8217A;
        Wed,  6 Apr 2022 08:25:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC5AC385A1;
        Wed,  6 Apr 2022 08:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649233557;
        bh=Bfxjf4WvYY6KvwHW1ji2+YyT/mfjbCo5tCbTTJgJQf8=;
        h=From:To:Cc:Subject:Date:From;
        b=TLjPuOvEYlUJaoXO9pIkz+mz62q2gsdSai0vRxWrwxJX8NvMBbvYLhYMDQzuYXp5C
         rSRNyOwoUrtqIvD2UKLgxX8Vl8Fr8+3kLP+wb1d2MRdiRtnrkOtJOjVqMlb9r1N2UZ
         6tG9IhMLAvvvuHj5on8o++QDXKW8jtI9WIjHiS2REmAsht27ezg5FyjLvd1tgo3fZN
         aOfUP9mJ03qJ9vVnezbM0Dcz51nrzAxrxRbPaSfr/JUBiF9hQJROuvmKBseEipHp5s
         /uP5JYqhtrNgW3d+NhfG32HucwxzsaLcu5ulC2PpATcg0VfXaQoWBsHtYK0UpE1HTv
         sZFiPO4/OgeAw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH mlx5-next 00/17] Drop Mellanox FPGA IPsec support from the kernel
Date:   Wed,  6 Apr 2022 11:25:35 +0300
Message-Id: <cover.1649232994.git.leonro@nvidia.com>
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

From: Leon Romanovsky <leonro@nvidia.com>

Together with FPGA TLS, the IPsec went to EOL state in the November of
2019 [1]. Exactly like FPGA TLS, no active customers exist for this
upstream code and all the complexity around that area can be deleted.
    
[1] https://network.nvidia.com/related-docs/eol/LCR-000535.pdf

Thanks

Leon Romanovsky (17):
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

 drivers/infiniband/core/device.c              |    2 -
 .../core/uverbs_std_types_flow_action.c       |  383 +---
 drivers/infiniband/hw/mlx5/fs.c               |  223 +--
 drivers/infiniband/hw/mlx5/main.c             |   31 -
 .../net/ethernet/mellanox/mlx5/core/Kconfig   |   33 +-
 .../net/ethernet/mellanox/mlx5/core/Makefile  |    9 +-
 .../ethernet/mellanox/mlx5/core/accel/accel.h |   36 -
 .../ethernet/mellanox/mlx5/core/accel/ipsec.c |  179 --
 .../ethernet/mellanox/mlx5/core/accel/ipsec.h |   96 -
 .../mellanox/mlx5/core/accel/ipsec_offload.h  |   38 -
 .../ethernet/mellanox/mlx5/core/en/params.c   |   13 +-
 .../mellanox/mlx5/core/en_accel/ipsec.c       |   30 +-
 .../mellanox/mlx5/core/en_accel/ipsec.h       |   31 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    |    5 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.h    |    7 +-
 .../core/{accel => en_accel}/ipsec_offload.c  |   95 +-
 .../mlx5/core/en_accel/ipsec_offload.h        |   14 +
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c  |  245 +--
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h  |    3 -
 .../mellanox/mlx5/core/en_accel/ipsec_stats.c |   63 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   12 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |    1 -
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   56 +-
 .../ethernet/mellanox/mlx5/core/en_stats.c    |    1 -
 .../ethernet/mellanox/mlx5/core/en_stats.h    |    1 -
 .../ethernet/mellanox/mlx5/core/fpga/core.h   |    2 -
 .../ethernet/mellanox/mlx5/core/fpga/ipsec.c  | 1582 -----------------
 .../ethernet/mellanox/mlx5/core/fpga/ipsec.h  |   62 -
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  |    2 -
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |   15 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |    8 +-
 include/linux/mlx5/accel.h                    |   35 +-
 include/linux/mlx5/driver.h                   |    3 -
 include/linux/mlx5/mlx5_ifc_fpga.h            |  148 --
 include/rdma/ib_verbs.h                       |    8 -
 35 files changed, 143 insertions(+), 3329 deletions(-)
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/accel/accel.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.h
 rename drivers/net/ethernet/mellanox/mlx5/core/{accel => en_accel}/ipsec_offload.c (84%)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.h

-- 
2.35.1

