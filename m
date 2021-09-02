Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92CA63FF3C9
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 21:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347299AbhIBTHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 15:07:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:54990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347145AbhIBTHD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 15:07:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 204CD6054E;
        Thu,  2 Sep 2021 19:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630609564;
        bh=OK1I1ljv97aDJpO4TLoeUkN6xQ3I8MeYQOTwlzKmrY8=;
        h=From:To:Cc:Subject:Date:From;
        b=D7YAJxrX4d0uGPxsgMYAJeIbB9q14Y8xLTJc5konznpDb5JVuudjj5XhZCSX8BoCj
         GkYtiaXkucchTr3TvLk85WydFSz5nS+kX3xlxizA3PFN2Iznav31vppWqgSRjcEF1e
         9nW3NVFYfJcxkKWLLbXhRB8Im+dbdKB4esNArYiNo1dMNPWmqvSXKqjfLk6YScjgB/
         GH6z/mjWhHSBN1rIfiyN2bqqc0Lr47f+A6ewvW4ZgwvMRm8rl+eGYrJG9j0PkRoig0
         zWsCg5o+gunR1vrj0tDSPy8nx8+YPGWc7ZjqDV6qK9vBOO83+81QGJ3Zc0C8uhSHhz
         CgsyAfQTinJaQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2021-09-02
Date:   Thu,  2 Sep 2021 12:05:39 -0700
Message-Id: <20210902190554.211497-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave and Jakub 

This small series provides some misc updates and fixes to net-next.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 9e9fb7655ed585da8f468e29221f0ba194a5f613:

  Merge tag 'net-next-5.15' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next (2021-08-31 16:43:06 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-09-02

for you to fetch changes up to 34a8cf8445266a0c09a76cffd893cafe708bd626:

  net/mlx5e: Add TX max rate support for MQPRIO channel mode (2021-09-02 12:03:49 -0700)

----------------------------------------------------------------
mlx5-updates-2021-09-02

mlx5 misc updates and fixes to net-next branch:

1) Roi Dayan provided some cleanups in mlx5e TC module, and some
   code improvements to fwd/drop actions handling.

2) lag fix from Mark

3) Fix rdma aux device load in switchdev mode, fix by Parav.

4) Vlad fixes uninitialized variable usage in bridge lag.

5) Dima adds the support for TC egress/ingress offload of macvlan
   interfaces

6) Tariq, Add TX max rate support for MQPRIO channel mode

----------------------------------------------------------------
Dima Chumak (2):
      net/mlx5e: Enable TC offload for egress MACVLAN
      net/mlx5e: Enable TC offload for ingress MACVLAN

Mark Bloch (1):
      net/mlx5: Lag, don't update lag if lag isn't supported

Parav Pandit (1):
      net/mlx5: Fix rdma aux device on devlink reload

Roi Dayan (7):
      net/mlx5e: Use correct return type
      net/mlx5e: Remove incorrect addition of action fwd flag
      net/mlx5e: Set action fwd flag when parsing tc action goto
      net/mlx5e: Check action fwd/drop flag exists also for nic flows
      net/mlx5e: Remove redundant priv arg from parse_pedit_to_reformat()
      net/mlx5e: Use tc sample stubs instead of ifdefs in source file
      net/mlx5e: Use NL_SET_ERR_MSG_MOD() for errors parsing tunnel attributes

Tariq Toukan (3):
      net/mlx5e: Improve MQPRIO resiliency
      net/mlx5e: Allow specifying SQ stats struct for mlx5e_open_txqsq()
      net/mlx5e: Add TX max rate support for MQPRIO channel mode

Vlad Buslov (1):
      net/mlx5: Bridge, fix uninitialized variable usage

 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c   | 102 +++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.h   |   9 +
 .../ethernet/mellanox/mlx5/core/en/rep/bridge.c    |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |  20 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc/sample.h |  27 +++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 205 +++++++++++++++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 113 +++++-------
 drivers/net/ethernet/mellanox/mlx5/core/lag.c      |  10 +-
 10 files changed, 390 insertions(+), 115 deletions(-)
