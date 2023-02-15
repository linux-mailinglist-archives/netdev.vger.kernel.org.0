Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E53E697955
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 10:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234079AbjBOJ4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 04:56:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231750AbjBOJ4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 04:56:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A52A5D6;
        Wed, 15 Feb 2023 01:56:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5C7EB81EA2;
        Wed, 15 Feb 2023 09:56:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0D9C433D2;
        Wed, 15 Feb 2023 09:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676454992;
        bh=Mhzn31nQdDKsY1ctp4wkAayZ1BiQ+dYMtZa58ORaOG8=;
        h=From:To:Cc:Subject:Date:From;
        b=LABpf0R8n1UwmD2tjAYpv+sfqrdsyuYqtdryRt9zpTK81hXA/ll7fdLpKOj8IhArB
         6ftxbKKcVZ1+zalsNqxDd1pF1+lG+5wVcTSa7bcVqFN/ivb1yuLkTLn+B0Sq8D5HSB
         3H/B7HIXPebVPYmtN/NXT0FNhU3qrsOj8xnwLjpDbbFEHg8mXWaMwo4DOza4SNpFKx
         vhQnrDPEHIyJoK6rXH9y47KOTFQZkOo8oEQubpBKyL4TFvwchxLpWmm1REpD2BwPV4
         gIzQM+XX0BqW94yqGTivIOypl3H0I2UpqR1unju87yFiGIColT0lvTtqt+O//ziOUw
         l98gfn03Ydtxw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [GIT PULL] Please pull mlx5-next changes
Date:   Wed, 15 Feb 2023 11:56:24 +0200
Message-Id: <20230215095624.1365200-1-leon@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jason,

Following previous conversations [1] and our clear commitment to do the TC work [2],
please pull mlx5-next shared branch, which includes low-level steering logic to allow
RoCEv2 traffic to be encrypted/decrypted through IPsec.

Thanks

[1] https://lore.kernel.org/all/20230126230815.224239-1-saeed@kernel.org/
[2] https://lore.kernel.org/all/Y+Z7lVVWqnRBiPh2@nvidia.com/

----------------------------------------------------------------


The following changes since commit dca55da0a15717dde509d17163946e951bad56c4:

  RDMA/mlx5: Track netdev to avoid deadlock during netdev notifier unregister (2023-02-08 20:40:57 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/ mlx5-next

for you to fetch changes up to 22551e77e5507a06114c0af2b92bbf1a66ec33c5:

  net/mlx5: Configure IPsec steering for egress RoCEv2 traffic (2023-02-15 11:30:07 +0200)

----------------------------------------------------------------
Mark Zhang (4):
      net/mlx5: Implement new destination type TABLE_TYPE
      net/mlx5: Add IPSec priorities in RDMA namespaces
      net/mlx5: Configure IPsec steering for ingress RoCEv2 traffic
      net/mlx5: Configure IPsec steering for egress RoCEv2 traffic

Patrisious Haddad (1):
      net/mlx5: Introduce new destination type TABLE_TYPE

 drivers/net/ethernet/mellanox/mlx5/core/Makefile                 |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c     |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h                  |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h         |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c      |  54 ++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c |   5 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c                 |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c                |  44 +++++-
 drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.c      | 368 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.h      |  25 +++
 include/linux/mlx5/fs.h                                          |   3 +
 include/linux/mlx5/mlx5_ifc.h                                    |  12 +-
 12 files changed, 511 insertions(+), 15 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.h
