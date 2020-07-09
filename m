Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0609321A0A3
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 15:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgGINTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 09:19:02 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:58851 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726315AbgGINTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 09:19:01 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id B613C5804CA;
        Thu,  9 Jul 2020 09:19:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 09 Jul 2020 09:19:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=aSqi1/sH4SHEGVuqn
        qwC/G/6rLysTDqlpKG6+HZIF44=; b=awEhSVoa4KQMUQxhtAeVA/MCWKLeOsEN5
        +wGtfh/6XYgRYK9/+10wLNxOeR5dhUjBeLUceg69cT1pJL24pRISWIlYHMoAQpi8
        b+iJjR9En/FJUCG1YiOovbtFGdDmhagAIMgsDIkgAWKt3RjmgYNLjj2d4rC+h+wT
        7tOG3m9QrgPYScqY8E+oF+PQMoK21YkFwjCYvdO1LTKEtJyCduaRtEH+sdbHb63S
        HpdaIsqUyioU07RO5Y/eVGFj4NRD2JHYMJRMPlSBNfuK70AzHNSJ8OYmvFlvuDvr
        K/GoGX1xfPM57wz15qUppm+P2xvdy1HIbLgDXlpjZCO5qp+U3OC2A==
X-ME-Sender: <xms:QhkHX2_CqsucofgITTprQi2QCMfdYa0vStEnNOaPrA6RxEKKIIepvQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudelgdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuheehte
    ffieekgeehveefvdegledvffduhfenucfkphepuddtledrieeirdduledrudeffeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthh
    esihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:QhkHX2ufruo4wEo0NJQxRhuyRb8QQe8vJweNuPP4_s8RfG5J0VHUfw>
    <xmx:QhkHX8BamIfR7zdoF5lty6yqiM7cxoXlF0TjM5j0kqwGGFIKl0oM6w>
    <xmx:QhkHX-ePSgu8z3hG3SQwV44KdhCzaT8faCBzJQZeGq1UbAPEHcfZsA>
    <xmx:RBkHX8F4D_I8-rO00hJgAVXiqeub69iAkJqCgrCCm0b9nWSE6fMj-w>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8B8C7328005A;
        Thu,  9 Jul 2020 09:18:54 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, michael.chan@broadcom.com,
        jeffrey.t.kirsher@intel.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, snelson@pensando.io, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        danieller@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 0/9] Expose port split attributes
Date:   Thu,  9 Jul 2020 16:18:13 +0300
Message-Id: <20200709131822.542252-1-idosch@idosch.org>
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
into how many ports. Among other things, this makes it impossible to
write generic tests for port split functionality.

Therefore, this set exposes two new devlink port attributes to user
space: Number of lanes and whether the port can be split or not.

Patch set overview:

Patches #1-#4 cleanup 'struct devlink_port_attrs' and reduce the number
of parameters passed between drivers and devlink via
devlink_port_attrs_set()

Patch #5 adds devlink port lanes attributes

Patches #6-#7 add devlink port splittable attribute

Patch #8 exploits the fact that devlink is now aware of port's number of
lanes and whether the port can be split or not and moves some checks
from drivers to devlink

Patch #9 adds a port split test

Changes since v2:
* Remove some local variables from patch #3
* Reword function description in patch #5
* Fix a bug in patch #8
* Add a test for the splittable attribute in patch #9

Changes since v1:
* Rename 'width' attribute to 'lanes'
* Add 'splittable' attribute
* Move checks from drivers to devlink

Danielle Ratson (9):
  devlink: Move set attribute of devlink_port_attrs to devlink_port
  devlink: Move switch_port attribute of devlink_port_attrs to
    devlink_port
  devlink: Replace devlink_port_attrs_set parameters with a struct
  mlxsw: Set number of port lanes attribute in driver
  devlink: Add a new devlink port lanes attribute and pass to netlink
  mlxsw: Set port split ability attribute in driver
  devlink: Add a new devlink port split ability attribute and pass to
    netlink
  devlink: Move input checks from driver to devlink
  selftests: net: Add port split test

 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |   9 +-
 drivers/net/ethernet/intel/ice/ice_devlink.c  |   6 +-
 .../ethernet/mellanox/mlx5/core/en/devlink.c  |  19 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  16 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  18 +-
 drivers/net/ethernet/mellanox/mlxsw/core.h    |   4 +-
 drivers/net/ethernet/mellanox/mlxsw/minimal.c |   4 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  23 +-
 .../net/ethernet/mellanox/mlxsw/switchib.c    |   2 +-
 .../net/ethernet/mellanox/mlxsw/switchx2.c    |   2 +-
 .../net/ethernet/netronome/nfp/nfp_devlink.c  |  17 +-
 .../ethernet/pensando/ionic/ionic_devlink.c   |   5 +-
 drivers/net/netdevsim/dev.c                   |  10 +-
 include/net/devlink.h                         |  30 +-
 include/uapi/linux/devlink.h                  |   3 +
 net/core/devlink.c                            |  93 +++---
 net/dsa/dsa2.c                                |  17 +-
 tools/testing/selftests/net/Makefile          |   1 +
 .../selftests/net/devlink_port_split.py       | 277 ++++++++++++++++++
 19 files changed, 424 insertions(+), 132 deletions(-)
 create mode 100755 tools/testing/selftests/net/devlink_port_split.py

-- 
2.26.2

