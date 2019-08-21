Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1759733A
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 09:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbfHUHUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 03:20:23 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:58903 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727537AbfHUHUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 03:20:23 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 447D3220AA;
        Wed, 21 Aug 2019 03:20:22 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 21 Aug 2019 03:20:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Zyb5c7rjrqQ5Ud1xl
        lbDyE5mlXmCbiPXoLYvEXjRvQo=; b=vIRQFSrTsgJw5tNL3H4Yagblv8Gvbr8FB
        1DNRRzFwNUVeFtijurGadorbk3to+cYZnTpJrJ9yXMvuEVnysO+3edCAtTFuabOU
        MhoYssiBaN8jjetjyKeolN9MrEwxM40xgjg355N9K4dgmwT/53pb15N6aszM3Q8V
        Yg1saqcVMi6y3XaQlsePUFi4HvgNc63fg0I++K0lpUp4QHN8EGSdJhQFhDknULPP
        q2L/gCPg24JInWJAwZaH+ZLOu8h57mhHJWqm20PltiIVDbpCP9DFxT+cRXcK6QNS
        s5JposIcxbrQEJooTNLzrlEIh86PNXRaC2wy/U42k6RhJXPsTY53Q==
X-ME-Sender: <xms:tfBcXWI8yjIWkryDWNSzrEsnqcmQpJrYr3VCcecOEk0N8S14Nyd7Hw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudegvddguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:tfBcXdfv3BkgpXAOKEzephGg1XS2YOGU_9XABsW8XxsSlDRrNuPvvQ>
    <xmx:tfBcXdoCCkPrjnWJKR9cSTF6UzmIIl4tlvVgbEBDuG9hCeHtWgxlrg>
    <xmx:tfBcXWvYb1Z0nGdBi0CkQJvAv_unAgBC4sY2SKts-iAZak9HJFqzPw>
    <xmx:tvBcXSxLAFUuSVkAIs-m25XDMED8UFQI20JlUQlI8pTMTfD94X-WIw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id E8E8FD6005B;
        Wed, 21 Aug 2019 03:20:19 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, dsahern@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/7] mlxsw: Add devlink-trap support
Date:   Wed, 21 Aug 2019 10:19:30 +0300
Message-Id: <20190821071937.13622-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This patchset adds devlink-trap support in mlxsw.

Patches #1-#4 add the necessary APIs and defines in mlxsw.

Patch #5 implements devlink-trap support for layer 2 drops. More drops
will be added in the future.

Patches #6-#7 add selftests to make sure that all the new code paths are
exercised and that the feature is working as expected.

Ido Schimmel (7):
  mlxsw: core: Add API to set trap action
  mlxsw: reg: Add new trap actions
  mlxsw: Add layer 2 discard trap IDs
  mlxsw: Add trap group for layer 2 discards
  mlxsw: spectrum: Add devlink-trap support
  selftests: mlxsw: Add test cases for devlink-trap L2 drops
  selftests: mlxsw: Add a test case for devlink-trap

 drivers/net/ethernet/mellanox/mlxsw/Makefile  |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  64 +++
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  12 +
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  12 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  21 +
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  13 +
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 267 ++++++++++
 drivers/net/ethernet/mellanox/mlxsw/trap.h    |   7 +
 .../drivers/net/mlxsw/devlink_trap.sh         | 129 +++++
 .../net/mlxsw/devlink_trap_l2_drops.sh        | 484 ++++++++++++++++++
 10 files changed, 1010 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/devlink_trap.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l2_drops.sh

-- 
2.21.0

