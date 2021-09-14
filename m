Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48DAE40A68E
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 08:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240054AbhINGPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 02:15:44 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:34699 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237875AbhINGPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 02:15:37 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 2E88A5C00AF;
        Tue, 14 Sep 2021 02:14:20 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 14 Sep 2021 02:14:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=5g6rNfPFO0w75scfB
        g1+WHDKK6CS7jA7faBPfpMic1A=; b=hS+EvHrFSyAe+PytvW5UjHj9E98m+C/hd
        rKiNXVnZe1aZvJwKuZz+8asV51pPE7Yvqppmy0PCs9YfK1Q8KY3bfVUpGBQeNWQh
        vg7RbwOGRPa54hma5IrLAc8bLG1N6e8pRpytrl8RLBpqKMbX2Ep72LqOs+rouZBT
        EUNQPwGOMqsov2IWtxvmF6qDK84NR5RQ14KPSD4J+VBoYk1MurdWhvM41hubnb6H
        cJkwXN/KxISePq8Ew7R8UoLtpIQITk9U76TKwvpdh7SPOui/MYsJCcDX1D57Hz8x
        Sef5v8ibmuVk0cnzA8P/mJMukzdVLM3aN66IF4YZNeSM0TsRrryeg==
X-ME-Sender: <xms:uz1AYZD_UbuBYDZ3bb3PIO5u5OpAJC5rzlULKvtYtM5HvPsG-Z6HCg>
    <xme:uz1AYXhMOy4wHtwdT4yg7fOEyCi53nxbdgkVFKEgP7yw9CwOBOeg3pTaLIAKNnG0j
    FsGT3gZjTDk1No>
X-ME-Received: <xmr:uz1AYUm383tR6FLKkB4ua0z0Nknth6OUFsoB8V6bJ-qF7tIZBRnyR-iZrCFwElo2tk-NCwlxcKNp-0lnFlXaXGOTu77XzcT6zA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudegkedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuhe
    ehteffieekgeehveefvdegledvffduhfenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:uz1AYTwMoEcZTso4k9YBgixPl3DhaSk_GdmbRTa-tvsqEXmRvt47aQ>
    <xmx:uz1AYeThttXd_W3GNFasWKiSegblyQFDBUPWY1Zu984BbTymBjGX9A>
    <xmx:uz1AYWai58Sqf4Zira7eaCaHPOz6J6_sMQlTdagNAdYW5bOntVQWrw>
    <xmx:vD1AYceuH_hoiz6igg97ygUl-SNFzXPtL77FWevFYHEoZsgV321VLw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Sep 2021 02:14:18 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/8] mlxsw: spectrum: Adjustments to port split and label port
Date:   Tue, 14 Sep 2021 09:13:22 +0300
Message-Id: <20210914061330.226000-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Jiri says:

This patchset includes patches that prepare the driver to support modular
systems.

PLLP register is introduced to get front panel port label which is no
longer equivalent to "module + 1" for modular systems, where the
numbering is per line card.

So far for all systems all front panel ports had same format and could
be split to the same number of subports. This is no longer true for
modular systems, where every line card can have different types of front
panel ports.

The PMTDB register is introduced to easily query FW for split
capabilities of particular front panel port. It is generic for use in
modular and non-modular systems.

Jiri Pirko (8):
  mlxsw: spectrum: Bump minimum FW version to xx.2008.3326
  mlxsw: spectrum: Move port module mapping before core port init
  mlxsw: spectrum: Move port SWID set before core port init
  mlxsw: reg: Add Port Local port to Label Port mapping Register
  mlxsw: spectrum: Use PLLP to get front panel number and split number
  mlxsw: reg: Add Port Module To local DataBase Register
  mlxsw: spectrum: Use PMTDB register to obtain split info
  mlxsw: reg: Remove PMTM register

 drivers/net/ethernet/mellanox/mlxsw/core.c    |  38 ---
 drivers/net/ethernet/mellanox/mlxsw/core.h    |   1 -
 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 146 ++++++---
 .../net/ethernet/mellanox/mlxsw/resources.h   |   6 -
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 290 +++++++++---------
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   4 +-
 6 files changed, 239 insertions(+), 246 deletions(-)

-- 
2.31.1

