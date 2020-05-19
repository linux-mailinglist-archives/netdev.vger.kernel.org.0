Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 280441D9803
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 15:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbgESNlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 09:41:11 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:42355 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729038AbgESNlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 09:41:10 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 3AEAF581892;
        Tue, 19 May 2020 09:41:09 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 19 May 2020 09:41:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=A45vWjpT23qUibhmX
        T7wFMbS8i4moAhv4qZIfY1ex1w=; b=naqFhB55IpsUL5kaf89at21CEgDPnKY26
        Fu8C1TBwK0ecVZHN9bYUXf62Gwj8guVH7K295NFyAw5nWh9oOB/Ad9bsPK7uviER
        cOq/U3zL/8K2Rt0XsuKa7XuUFocpH3FWSBve0PZL6C5F8RnNSOqtq2qCzgf7fEP3
        qHW5PcHc600Nu9G4dV6jh5GStcUGrhUGlCsxIzfOeVx/lI1QQphThklev/G289ex
        n50DhFQx1DASJpmrkoCBPUbiLd1LHYb06/3UDGpLdT/qjEsajN6KzW1ZX5QecPpO
        3KIUUz76F5tZVyFu+1nvTVZ/or2IXiV/2xdTDcTwjOG9Ym6HEuOEQ==
X-ME-Sender: <xms:8uHDXgm-S6kRW5CuSBhLQvNgvZ8JUQ4eT2Ew3JmfpKONimyzIkNH9g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddtjedgieejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeejledrudejiedrvdegrddutdejnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:8uHDXv0bPmgcoxbRG6s6DUkeAZgPMn10dGbNUUQMVVXoYFMhtjSnBw>
    <xmx:8uHDXuqQM1pzH64f4ZeUcenT72k3UJJu2JUUQGiLy098kiM4LqOfMg>
    <xmx:8uHDXslbwoTapSpmnIwes9WuX5xxtFwOaKPcaGn4e8wy9sC1W9ZEiQ>
    <xmx:9eHDXrucQ86OWZjsxYnfDYqFJee7qb6AQj8Bll6cF6RNl3uOrDqkMg>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A17543280070;
        Tue, 19 May 2020 09:41:03 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        danieller@mellanox.com, mlxsw@mellanox.com,
        michael.chan@broadcom.com, jeffrey.t.kirsher@intel.com,
        saeedm@mellanox.com, leon@kernel.org, snelson@pensando.io,
        drivers@pensando.io, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/3] devlink: Add port width attribute
Date:   Tue, 19 May 2020 16:40:29 +0300
Message-Id: <20200519134032.1006765-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Danielle says:

Currently, user space has no way of knowing if a port can be split and
into how many ports. This makes it impossible to write generic tests for
port split.

This patch set adds the port's width as an attribute of a devlink port
and exposes the information to user space using a new attribute.

Patch #1 prepares mlxsw to pass width information to devlink
Patch #2 changes device drivers to pass width information to devlink and
exposes it to user space
Patch #3 adds a port split test

Danielle Ratson (3):
  mlxsw: Set port width attribute in driver
  devlink: Add a new devlink port width attribute and pass to netlink
  selftests: net: Add port split test

 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |   2 +-
 drivers/net/ethernet/intel/ice/ice_devlink.c  |   2 +-
 .../ethernet/mellanox/mlx5/core/en/devlink.c  |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c    |   8 +-
 drivers/net/ethernet/mellanox/mlxsw/core.h    |   1 +
 drivers/net/ethernet/mellanox/mlxsw/minimal.c |   2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   1 +
 .../net/ethernet/mellanox/mlxsw/switchib.c    |   2 +-
 .../net/ethernet/mellanox/mlxsw/switchx2.c    |   2 +-
 .../net/ethernet/netronome/nfp/nfp_devlink.c  |   2 +-
 .../ethernet/pensando/ionic/ionic_devlink.c   |   2 +-
 drivers/net/netdevsim/dev.c                   |   2 +-
 include/net/devlink.h                         |   2 +
 include/uapi/linux/devlink.h                  |   2 +
 net/core/devlink.c                            |   7 +
 net/dsa/dsa2.c                                |   6 +-
 tools/testing/selftests/net/Makefile          |   1 +
 .../selftests/net/devlink_port_split.py       | 259 ++++++++++++++++++
 19 files changed, 292 insertions(+), 17 deletions(-)
 create mode 100755 tools/testing/selftests/net/devlink_port_split.py

-- 
2.26.2

