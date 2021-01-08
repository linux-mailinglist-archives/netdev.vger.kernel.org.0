Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34282EED0A
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 06:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbhAHFbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 00:31:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:35728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725308AbhAHFbh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 00:31:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C4DF233EE;
        Fri,  8 Jan 2021 05:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610083856;
        bh=m8DujMaTWKriWDC4d4Xo8kDxDkr9L34I9sJJLssKP48=;
        h=From:To:Cc:Subject:Date:From;
        b=BE0TQOJZtGbpDIGbbU4O6QdoUJSYQLBUagf3xGJxjuvr425N2G3D702yLs40a2oCK
         JX+jkJ5bGKxK0vziK+RuPES+hWoSkjXEIr791u+hXMpZej5L+Ml9V2ZjSEgBZBUXxb
         lI/HBmUXu4J19BhEpOGT6k/S2NYjuiVZYZ4Dm9Rg8kWbaLadvTTiqFqXTQNgKjNe8a
         9Kjpam8RdRiwi1Ke8osln06GJ2Hull6LhTuHUSTRX+mQq3BcmRJwFKyNcW2GctVEvo
         ir4WJc2HuUyl2AznRIC9N42/99adMZMp/4hDk/yE+NKXUMdKPkLaFgerX/Tf++KVTU
         DPoflEOAOLycw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2021-01-07
Date:   Thu,  7 Jan 2021 21:30:39 -0800
Message-Id: <20210108053054.660499-1-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub

This series provides misc updates to mlx5 plus the +trk+new TC 
connection tracking rules support for UDP.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 58334e7537278793c86baa88b70c48b0d50b00ae:

  Merge branch 'generic-zcopy_-functions' (2021-01-07 16:08:38 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-01-07

for you to fetch changes up to 29c9b5c4ed42ca9d7c8f8f6c34a7ef7ab787ad6e:

  net/mlx5e: IPsec, Remove unnecessary config flag usage (2021-01-07 21:27:08 -0800)

----------------------------------------------------------------
mlx5-updates-2021-01-07

Misc updates series for mlx5 driver:

1) From Eli and Jianbo, E-Switch cleanups and usage of new
   FW capability for mpls over udp

2) Paul Blakey, Adds support for mirroring with Connection tracking
by splitting rules to pre and post Connection tracking to perform the
mirroring.

3) Roi Dayan, Adds support for +trk+new connection tracking rules
 3.1) cleanups to connection tracking
 3.2) to support +trk+new feature of connection tracking, Roi adds another
     flow table that catches all missed packets from the original CT table
     (The table that handles stateful established flows)
 3.3) Add support to offload +trk+new rules for terminating flows for udp
    protocols using source port entropy.
    We support only the default registered vxlan, RoCE and Geneve ports.
    Using the registered ports assume the traffic is that of the
    registered protocol.

4) From Tariq, Cleanups and improvements to IPSec

----------------------------------------------------------------
Eli Cohen (2):
      net/mlx5e: Simplify condition on esw_vport_enable_qos()
      net/mlx5: E-Switch, use new cap as condition for mpls over udp

Jianbo Liu (1):
      net/mlx5e: E-Switch, Offload all chain 0 priorities when modify header and forward action is not supported

Paul Blakey (2):
      net/mlx5: Add HW definition of reg_c_preserve
      net/mlx5e: CT: Add support for mirroring

Roi Dayan (6):
      net/mlx5e: CT: Pass null instead of zero spec
      net/mlx5e: Remove redundant initialization to null
      net/mlx5e: CT: Remove redundant usage of zone mask
      net/mlx5e: CT: Preparation for offloading +trk+new ct rules
      net/mlx5e: CT: Support offload of +trk+new ct rules
      net/mlx5e: CT, Avoid false lock depenency warning

Tariq Toukan (4):
      net/mlx5e: IPsec, Enclose csum logic under ipsec config
      net/mlx5e: IPsec, Avoid unreachable return
      net/mlx5e: IPsec, Inline feature_check fast-path function
      net/mlx5e: IPsec, Remove unnecessary config flag usage

 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 353 +++++++++++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h |   6 +
 .../mellanox/mlx5/core/en/tc_tun_mplsoudp.c        |   4 +-
 .../mellanox/mlx5/core/en_accel/en_accel.h         |   4 +-
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c       |  14 -
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h       |  29 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   4 -
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   2 -
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  47 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   3 +-
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.c    |   7 +-
 include/linux/mlx5/mlx5_ifc.h                      |   4 +-
 13 files changed, 399 insertions(+), 81 deletions(-)
