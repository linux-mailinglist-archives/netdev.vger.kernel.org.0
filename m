Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42E844DE2F9
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 21:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240877AbiCRUyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 16:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238196AbiCRUyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 16:54:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84EEDDECE
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 13:53:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3837DB82504
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 20:53:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F83DC340E8;
        Fri, 18 Mar 2022 20:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647636789;
        bh=ZCPzJ3W7tMKG1xUS32CW6I13+nBQcsdtTJmCElMF/rA=;
        h=From:To:Cc:Subject:Date:From;
        b=lpSMaNodvWI6RfdUzfueoxb+0+pFElhJB8fzknM1FamTeRmGMfOucxH8MnFwZCynL
         vSu2j5kj3FiMmyqzlATnzI3+stw7rYUrC78EBD2eiNkNx3uXtxxU5M32lbMEcH7ieE
         DNVpYShHXfx/8t5w43sVyHsQOL2eXaOjYsa+Ic2jyyoHZNmP29ihHo511trypm8xdd
         A8mvOxw+yusYZqK5bq7TTsGti6RjepK3Xx8cJJvxk/S7UH9Hy1WLJBaFYMabXB7zL5
         0ZyTVrh6xslPdGL+8e9Y5ixeL2qesG9zWZqiZof4/umEKGgfa2X8FlkEFLFlFXWjc0
         NUHByk4o2bSHg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2022-03-18
Date:   Fri, 18 Mar 2022 13:52:33 -0700
Message-Id: <20220318205248.33367-1-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Hi Jakub,

This series adds XDP multi-buffer support to mlx5.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit e89600ebeeb14d18c0b062837a84196f72542830:

  af_vsock: SOCK_SEQPACKET broken buffer test (2022-03-18 15:13:19 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2022-03-18

for you to fetch changes up to 5dc2b581cd2cf518d28d0c703478a0c1fd54436c:

  net/mlx5e: HTB, remove unused function declaration (2022-03-18 13:51:16 -0700)

----------------------------------------------------------------
mlx5-updates-2022-03-18

1) XDP multi buffer support

This series enables XDP on non-linear legacy RQ in multi buffer mode.

When XDP is enabled, fragmentation scheme on non-linear legacy RQ is
adjusted to comply to limitations of XDP multi buffer (fragments of the
same size). DMA addresses of fragments are stored in struct page for the
completion handler to be able to unmap them. XDP_TX is supported.

XDP_REDIRECT is not yet supported, the XDP core blocks it for multi
buffer packets at the moment.

2) Trivial cleanups

----------------------------------------------------------------
Maxim Mikityanskiy (13):
      net/mlx5e: Prepare non-linear legacy RQ for XDP multi buffer support
      net/mlx5e: Use fragments of the same size in non-linear legacy RQ with XDP
      net/mlx5e: Use page-sized fragments with XDP multi buffer
      net/mlx5e: Add XDP multi buffer support to the non-linear legacy RQ
      net/mlx5e: Store DMA address inside struct page
      net/mlx5e: Move mlx5e_xdpi_fifo_push out of xmit_xdp_frame
      net/mlx5e: Remove assignment of inline_hdr.sz on XDP TX
      net/mlx5e: Don't prefill WQEs in XDP SQ in the multi buffer mode
      net/mlx5e: Implement sending multi buffer XDP frames
      net/mlx5e: Unindent the else-block in mlx5e_xmit_xdp_buff
      net/mlx5e: Support multi buffer XDP_TX
      net/mlx5e: Permit XDP with non-linear legacy RQ
      net/mlx5e: Remove MLX5E_XDP_TX_DS_COUNT

Saeed Mahameed (1):
      net/mlx5e: HTB, remove unused function declaration

Tariq Toukan (1):
      net/mlx5e: Statify function mlx5_cmd_trigger_completions

 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   5 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |  34 ++--
 .../net/ethernet/mellanox/mlx5/core/en/params.h    |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.h   |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   | 198 ++++++++++++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h   |   7 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  53 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    | 126 +++++++++----
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |   1 -
 13 files changed, 329 insertions(+), 113 deletions(-)
