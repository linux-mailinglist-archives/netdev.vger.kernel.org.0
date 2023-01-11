Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 931696653CF
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 06:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236146AbjAKFi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 00:38:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbjAKFhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 00:37:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B64CB7
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 21:30:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 022B4B81A6B
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 05:30:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF86C433D2;
        Wed, 11 Jan 2023 05:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673415048;
        bh=WJDqnZPPW5wp7T8w2YHHC4+MQRDgFdUmL3qYIa/YpSE=;
        h=From:To:Cc:Subject:Date:From;
        b=SRs16qjW92RblbDH1hShbgt6pT05imNKgwJQWahesV4nR/zA1AQHDJOYi7a3G/gEI
         IFAtEI/YE8qe76TwJT3NAF7MX5rraPgGxU444C/b7PBDnCtvHP2M3SPqHjNmylWerO
         gpqH38vBB4yGwTtY/SQH9GCSZKoE7u7ARLQuENKd8v+cWIZwYfqpz3s5VeGqmEAcji
         Hz6nWltOG3lCN8aeFNQLp8kYJo10CrcFo4M/xLiLq8cCVQ2uY/gOk+fSouOkLAwhPs
         U7H/rnoAZJtxLe8p6aBh+P9AcQdUYcPUd2peLmwuDbYi18mGdKmJluS8lUmuFTYA91
         4C1CJ9QWpM4tg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2023-01-10
Date:   Tue, 10 Jan 2023 21:30:30 -0800
Message-Id: <20230111053045.413133-1-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

This series provides updates to mlx5 driver.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit a6f536063b69102adf3588fbc0bb4f08d6c8cb82:

  qed: fix a typo in comment (2023-01-10 18:13:22 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2023-01-10

for you to fetch changes up to 96c31b5b2caecae2eebb1ed0fba5dc082b2fb740:

  net/mlx5e: Use kzalloc() in mlx5e_accel_fs_tcp_create() (2023-01-10 21:24:43 -0800)

----------------------------------------------------------------
mlx5-updates-2023-01-10

1) From Gal: Add debugfs entries for netdev nic driver
   - ktls, flow steering and hairpin info
   - useful for debug and performance analysis
   - e.g hairpin queue attributes, dump ktls tx pool size, etc

2) From Maher: Update shared buffer configuration on PFC commands
   2.1) For every change of buffer's headroom, recalculate the size of shared
       buffer to be equal to "total_buffer_size" - "new_headroom_size".
       The new shared buffer size will be split in ratio of 3:1 between
       lossy and lossless pools, respectively.

   2.2) For each port buffer change, count the number of lossless buffers.
       If there is only one lossless buffer, then set its lossless pool
       usage threshold to be infinite. Otherwise, if there is more than
       one lossless buffer, set a usage threshold for each lossless buffer.

    While at it, add more verbosity to debug prints when handling user
    commands, to assist in future debug.

3) From Tariq: Throttle high rate FW commands

4) From Shay: Properly initialize management PF

5) Various cleanup patches

----------------------------------------------------------------
Gal Pressman (4):
      net/mlx5e: Add Ethernet driver debugfs
      net/mlx5e: Add hairpin params structure
      net/mlx5e: Add flow steering debugfs directory
      net/mlx5e: Add hairpin debugfs files

Gustavo A. R. Silva (1):
      net/mlx5e: Replace zero-length array with flexible-array member

Kees Cook (1):
      net/mlx5e: Replace 0-length array with flexible array

Maher Sanalla (3):
      net/mlx5: Expose shared buffer registers bits and structs
      net/mlx5e: Add API to query/modify SBPR and SBCM registers
      net/mlx5e: Update shared buffer along with device buffer changes

Shay Drory (1):
      net/mlx5: Enable management PF initialization

Tariq Toukan (3):
      net/mlx5e: kTLS, Add debugfs
      net/mlx5: Introduce and use opcode getter in command interface
      net/mlx5: Prevent high-rate FW commands from populating all slots

YueHaibing (1):
      net/mlx5e: Use kzalloc() in mlx5e_accel_fs_tcp_create()

zhang songyi (1):
      net/mlx5: remove redundant ret variable

 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      | 118 ++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/dev.c      |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/ecpf.c     |   8 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c  |  72 +++++++
 drivers/net/ethernet/mellanox/mlx5/core/en/port.h  |   6 +
 .../ethernet/mellanox/mlx5/core/en/port_buffer.c   | 222 ++++++++++++++++++++-
 .../ethernet/mellanox/mlx5/core/en/port_buffer.h   |   1 +
 .../net/ethernet/mellanox/mlx5/core/en/tc/meter.c  |   2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c  |   6 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.c    |  22 ++
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.h    |   8 +
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |  22 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |  22 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 169 ++++++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |   3 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |   5 +-
 include/linux/mlx5/driver.h                        |   8 +
 include/linux/mlx5/mlx5_ifc.h                      |  61 ++++++
 23 files changed, 706 insertions(+), 83 deletions(-)
