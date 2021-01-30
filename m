Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F2F3091CD
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 05:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233651AbhA3EOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 23:14:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:36296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233650AbhA3DtC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 22:49:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5F2E64DF5;
        Sat, 30 Jan 2021 02:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611973586;
        bh=/XlwGQWfNArvuAvbMt/zmmirdIEHc51oN41zEWV5kSg=;
        h=From:To:Cc:Subject:Date:From;
        b=qgX4h+D5Mdp8ONSs1KMAS7EVNdaX8jwvImQWNGrH1Zzh9rK595Qfe/cnZdCT9FSRK
         MoNf2/wvHNVlmANvUwwcRt/klm6xomfMayd0Gzq8XaU4yvZeFO2EbQxoz1ta1eM3k8
         GpXwQkOk5LegbGu+sRUz79nFwY6iXRe4z7mlbcaAxARj0dKHleWw/6Xk/kVzKnMoDj
         h4gJlYazFkIUzrJvZ6nJCtFZYTK93nPTlJPrUDd2f8n/9YgqRd7MnZreyAoHdzbc5J
         7KlIlUS0TGgYIRSANCGAK+6omDSxOJBlobiMGYYMG2l+t23STUxT/pXWK4aD53QTH5
         F2ftcTd1Uqitg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/11] mlx5 SW steering for ConnectX-6DX
Date:   Fri, 29 Jan 2021 18:26:07 -0800
Message-Id: <20210130022618.317351-1-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Jakub, Dave.

This series adds support for ConnectX-6DX Software steering.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 46eb3c108fe1744d0a6abfda69ef8c1d4f0e92d4:

  octeontx2-af: Fix 'physical' typos (2021-01-28 21:24:47 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-dr-2021-01-29

for you to fetch changes up to 64f45c0fc4c71f577506c5a7a7956ae3bc3388ea:

  net/mlx5: DR, Allow SW steering for sw_owner_v2 devices (2021-01-29 18:13:00 -0800)

----------------------------------------------------------------
mlx5-dr-2021-01-29

Add support for Connect-X6DX Software steering

This series adds SW Steering support for Connect-X6DX.

Since the STE and actions formats are different on this new HW,
we implemented the HW specific STEv1 layer on the infrastructure
implemented in previous mlx5 DR patchset to support all the
functionalities as previous devices.

Most of the code in this series very is low level HW specific, we
implement the function pointers for the generic SW steering layer.

----------------------------------------------------------------
Yevgeny Kliteynik (11):
      net/mlx5: DR, Fix potential shift wrapping of 32-bit value
      net/mlx5: DR, Add match STEv1 structs to ifc
      net/mlx5: DR, Add HW STEv1 match logic
      net/mlx5: DR, Allow native protocol support for HW STEv1
      net/mlx5: DR, Add STEv1 setters and getters
      net/mlx5: DR, Add STEv1 action apply logic
      net/mlx5: DR, Add STEv1 modify header logic
      net/mlx5: DR, Use the right size when writing partial STE into HW
      net/mlx5: DR, Use HW specific logic API when writing STE
      net/mlx5: DR, Copy all 64B whenever replacing STE in the head of miss-list
      net/mlx5: DR, Allow SW steering for sw_owner_v2 devices

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |    2 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_cmd.c  |   17 +-
 .../mellanox/mlx5/core/steering/dr_domain.c        |   17 +-
 .../mellanox/mlx5/core/steering/dr_matcher.c       |   12 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |   17 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |   29 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  |   30 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.h  |    4 +
 .../mellanox/mlx5/core/steering/dr_ste_v0.c        |    4 +-
 .../mellanox/mlx5/core/steering/dr_ste_v1.c        | 1633 ++++++++++++++++++++
 .../mellanox/mlx5/core/steering/dr_types.h         |    9 +-
 .../mlx5/core/steering/mlx5_ifc_dr_ste_v1.h        |  434 ++++++
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h  |    5 +-
 13 files changed, 2169 insertions(+), 44 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr_ste_v1.h
