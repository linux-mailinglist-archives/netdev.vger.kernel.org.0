Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58E3A6C0DAC
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 10:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbjCTJro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 05:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbjCTJrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 05:47:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A0D1ABC9
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 02:47:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5B3C61309
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 09:47:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4A2C433A0;
        Mon, 20 Mar 2023 09:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679305661;
        bh=WZHZrwIv1S++fNkRd2S93tFg8EhFChTqeHwHai4vQ3M=;
        h=From:To:Cc:Subject:Date:From;
        b=fnP/7BXVpHX1GKpB/qCVvqHmiKtrXfWEbWvq+UlAx5GbSijT3yUfbdZY8i94bQuPh
         dMermqANLhPL8SypN8S4KB7T6xHNMa8njxsxNOpGv3rTBoCGLHEJmLD5vd1bbhniM4
         Uw9n3h7iUC4YYDKRlWO6JMsA/0xv/Zv8gblYS/59bkfbrEkLbwLGno5VaouZVOFCXt
         ERNLmdZ1JTZVNNhgqsv+UISR1M9nnMliu2aH1wsbcJGeviC3JbWngQv6XYpcA7pXav
         XqqWgxz5li86j3YELlPE/EJKpS2mrhblRWqL/L3rk/iaxngEKuR2qZJVvOdcpLIGbo
         MTesYD+dIcbwg==
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
Subject: [GIT PULL] Extend packet offload to fully support libreswan
Date:   Mon, 20 Mar 2023 11:47:22 +0200
Message-Id: <20230320094722.1009304-1-leon@kernel.org>
X-Mailer: git-send-email 2.39.2
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

The following patches are an outcome of Raed's work to add packet
offload support to libreswan [1].

The series includes:
 * Priority support to IPsec policies
 * Statistics per-SA (visible through "ip -s xfrm state ..." command)
 * Support to IKE policy holes
 * Fine tuning to acquire logic.

Thanks

[1] https://github.com/libreswan/libreswan/pull/986
Link: https://lore.kernel.org/all/cover.1678714336.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>

----------------------------------------------------------------

The following changes since commit eeac8ede17557680855031c6f305ece2378af326:

  Linux 6.3-rc2 (2023-03-12 16:36:44 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/ tags/ipsec-libreswan-mlx5

for you to fetch changes up to 5a6cddb89b51d99a7702e63829644a5860dd9c41:

  net/mlx5e: Update IPsec per SA packets/bytes count (2023-03-20 11:29:52 +0200)

----------------------------------------------------------------
Paul Blakey (3):
      net/mlx5: fs_chains: Refactor to detach chains from tc usage
      net/mlx5: fs_core: Allow ignore_flow_level on TX dest
      net/mlx5e: Use chains for IPsec policy priority offload

Raed Salem (6):
      xfrm: add new device offload acquire flag
      xfrm: copy_to_user_state fetch offloaded SA packets/bytes statistics
      net/mlx5e: Allow policies with reqid 0, to support IKE policy holes
      net/mlx5e: Support IPsec acquire default SA
      net/mlx5e: Use one rule to count all IPsec Tx offloaded traffic
      net/mlx5e: Update IPsec per SA packets/bytes count

 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c         |  71 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h         |  13 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c      | 528 +++++++++++++++++++++++++++++++++++----------
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c |  32 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                  |  20 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c       |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c                |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c          |  89 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.h          |   9 +-
 include/net/xfrm.h                                               |   5 +
 net/xfrm/xfrm_state.c                                            |   1 +
 net/xfrm/xfrm_user.c                                             |   2 +
 12 files changed, 553 insertions(+), 228 deletions(-)
