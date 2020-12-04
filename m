Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B95062CF416
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 19:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730231AbgLDSa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 13:30:57 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:8651 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728129AbgLDSa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 13:30:57 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fca80390001>; Fri, 04 Dec 2020 10:30:17 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 4 Dec
 2020 18:30:10 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [pull request][for-next] mlx5-next auxbus support
Date:   Fri, 4 Dec 2020 10:29:52 -0800
Message-ID: <20201204182952.72263-1-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607106617; bh=w5n7Wtnj+4PvD2QvWMeg7FYapvk8hnjZsIPpT1vswAI=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=LvIPTzcRQ39Ik7vwBCOzZ7znwVbbvws0ApsNlZgAe91VbYMTDyO0cykwvuao5c5Br
         aHeLvigFr44YOefDRculSwXv+6KIaoDGvzSCVAQgKsK3AXXx+a/BlYJfZazL+ceMqd
         2VLA77vyNIoh5A+DMBQfHlukLK45ZDhLaL7N5Ry5gxHqLxm7HoRU+9NOqYdMGu1Ltv
         DCpKfu9mcq+Wu9zr+TUnUD8wvVT8+zJoO65HhbUIqn/6lSuWPIN3Zfk4Nblh8/IlVm
         f/gAlgeU6FDeiLmBOIir5SMleHoTU16qlmpq5grSzU8fB+hHTJkX+xFDhT3y4Fkegh
         XyorBYfSsufJw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub, Jason

This pull request is targeting net-next and rdma-next branches.

This series provides mlx5 support for auxiliary bus devices.

It starts with a merge commit of tag 'auxbus-5.11-rc1' from
gregkh/driver-core into mlx5-next, then the mlx5 patches that will convert
mlx5 ulp devices (netdev, rdma, vdpa) to use the proper auxbus
infrastructure instead of the internal mlx5 device and interface management
implementation, which Leon is deleting at the end of this patchset.

Link: https://lore.kernel.org/alsa-devel/20201026111849.1035786-1-leon@kern=
el.org/

Thanks to everyone for the joint effort !

Please pull and let me know if there's any problem.

Thanks,
Saeed.

---

The following changes since commit b65054597872ce3aefbc6a666385eabdf9e288da=
:

  Linux 5.10-rc6 (2020-11-29 15:50:50 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git mlx5-nex=
t

for you to fetch changes up to 940d816e44b83c62eec0bf8a5dcd087eec6532cb:

  RDMA/mlx5: Remove IB representors dead code (2020-12-04 14:46:56 +0200)

----------------------------------------------------------------
Dave Ertman (1):
      Add auxiliary bus support

Greg Kroah-Hartman (3):
      driver core: auxiliary bus: move slab.h from include file
      driver core: auxiliary bus: make remove function return void
      driver core: auxiliary bus: minor coding style tweaks

Leon Romanovsky (11):
      Merge tag 'auxbus-5.11-rc1' of https://git.kernel.org/.../gregkh/driv=
er-core into mlx5-next
      net/mlx5: Properly convey driver version to firmware
      net/mlx5_core: Clean driver version and name
      vdpa/mlx5: Make hardware definitions visible to all mlx5 devices
      net/mlx5: Register mlx5 devices to auxiliary virtual bus
      vdpa/mlx5: Connect mlx5_vdpa to auxiliary bus
      net/mlx5e: Connect ethernet part to auxiliary bus
      RDMA/mlx5: Convert mlx5_ib to use auxiliary bus
      net/mlx5: Delete custom device management logic
      net/mlx5: Simplify eswitch mode check
      RDMA/mlx5: Remove IB representors dead code

 Documentation/driver-api/auxiliary_bus.rst         | 234 +++++++++
 Documentation/driver-api/index.rst                 |   1 +
 drivers/base/Kconfig                               |   3 +
 drivers/base/Makefile                              |   1 +
 drivers/base/auxiliary.c                           | 274 ++++++++++
 drivers/infiniband/hw/mlx5/counters.c              |   7 -
 drivers/infiniband/hw/mlx5/ib_rep.c                | 113 ++--
 drivers/infiniband/hw/mlx5/ib_rep.h                |  45 +-
 drivers/infiniband/hw/mlx5/main.c                  | 155 ++++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig    |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/dev.c      | 567 ++++++++++++++---=
----
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 135 ++---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  42 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  21 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag.c      |  58 +--
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  49 +-
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |  33 +-
 drivers/vdpa/mlx5/Makefile                         |   2 +-
 drivers/vdpa/mlx5/net/main.c                       |  76 ---
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |  53 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.h                  |  24 -
 include/linux/auxiliary_bus.h                      |  77 +++
 include/linux/mlx5/driver.h                        |  34 +-
 include/linux/mlx5/eswitch.h                       |   8 +-
 .../linux/mlx5/mlx5_ifc_vdpa.h                     |   8 +-
 include/linux/mod_devicetable.h                    |   8 +
 scripts/mod/devicetable-offsets.c                  |   3 +
 scripts/mod/file2alias.c                           |   8 +
 34 files changed, 1418 insertions(+), 650 deletions(-)
 create mode 100644 Documentation/driver-api/auxiliary_bus.rst
 create mode 100644 drivers/base/auxiliary.c
 delete mode 100644 drivers/vdpa/mlx5/net/main.c
 delete mode 100644 drivers/vdpa/mlx5/net/mlx5_vnet.h
 create mode 100644 include/linux/auxiliary_bus.h
 rename drivers/vdpa/mlx5/core/mlx5_vdpa_ifc.h =3D> include/linux/mlx5/mlx5=
_ifc_vdpa.h (96%)
