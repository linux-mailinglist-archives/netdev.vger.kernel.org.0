Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23B3344322E
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 17:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbhKBQCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 12:02:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:35650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231314AbhKBQCc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 12:02:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EB1660C49;
        Tue,  2 Nov 2021 15:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635868797;
        bh=1Hq5ItXDrHTWuBsJArbMq2j83yEqVW5mb6hrKPKb9SQ=;
        h=From:To:Cc:Subject:Date:From;
        b=J4fhJKCzvGYRKRrNgF+QZZhG93Ds/HMoKg6N+dIsNV45ZYL0C62HIaiPZxvf2f6gr
         vTsfc95e7xrzXBzCP4G705zxIoC+AAePaZaNjwAMx1xL7KWTS0p7OyRUm/xfdFVlxS
         b2ulnKgNGs5lDS4Q6QsNP9u5SU2+TRNRjo/ANMBGYEqJPyO9QE95qEO1d7ASgENqZY
         7eT/uf6ky4Cd6ANfvwDo+l62PSxlGThtgeaOC42pOM3s+jNTlPLybERzZ4YZHcw4DB
         SKeumHi6nBUeOXqkaKJUQDCvl/dfI4PWPhq+LVf8YktWoHxTLrfSDIBUX8J07gLKqf
         /Onf45IGoVshg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next v2 0/7] mlx5 updates 2021-11-01
Date:   Tue,  2 Nov 2021 08:59:41 -0700
Message-Id: <20211102155948.1143487-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub,

v1->v2:
  - Fix build error

This small pull request includes few updates to mlx5 driver,
Mainly:
1) Support ethtool cq mode
2) Static allocation of mod header object for the common case

Please pull and let me know if there is any problem.

Thanks,
Saeed.

The following changes since commit cc0356d6a02e064387c16a83cb96fe43ef33181e:

  Merge tag 'x86_core_for_v5.16_rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2021-11-02 07:56:47 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-11-01

for you to fetch changes up to 5eb1f9a57b31fd543e871ac1e743ed4a01d158ec:

  net/mlx5e: TC, Remove redundant action stack var (2021-11-02 08:56:35 -0700)

----------------------------------------------------------------
mlx5-updates-2021-11-01

Small updates for mlx5 driver:

1) Support ethtool cq mode
2) Static allocation of mod header object for the common case
3) minor code improvements

----------------------------------------------------------------
Paul Blakey (2):
      net/mlx5e: Refactor mod header management API
      net/mlx5: CT: Allow static allocation of mod headers

Roi Dayan (3):
      net/mlx5e: TC, Destroy nic flow counter if exists
      net/mlx5e: TC, Move kfree() calls after destroying all resources
      net/mlx5e: TC, Remove redundant action stack var

Saeed Mahameed (2):
      net/mlx5e: Support ethtool cq mode
      net/mlx5: Print more info on pci error handlers

 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   7 +-
 .../net/ethernet/mellanox/mlx5/core/en/mod_hdr.c   |  58 +++++++
 .../net/ethernet/mellanox/mlx5/core/en/mod_hdr.h   |  26 +++
 .../net/ethernet/mellanox/mlx5/core/en/tc/sample.c |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  34 ++--
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  49 +++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 191 +++++++--------------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |   6 -
 .../ethernet/mellanox/mlx5/core/esw/indir_table.c  |   5 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c    |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  51 ++++--
 13 files changed, 259 insertions(+), 183 deletions(-)
