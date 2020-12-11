Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4B82D7C71
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 18:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394288AbgLKRHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 12:07:01 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:59547 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732146AbgLKRGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 12:06:18 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 76DC4AD5;
        Fri, 11 Dec 2020 12:05:12 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 11 Dec 2020 12:05:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=DKeDNyWEfxSJexRMw
        /bQpCDiE0tQYfrSt4JLmK7Fx4c=; b=Sn1NR3OF0pDLbJVFuyiUlhEBLvYVkc3rN
        HsgAEMes4vuZTyJuBJGKkW1/DulUelKre6u7rJ0YXwxonYPjTwrE3FtjtGdvGdrO
        rZA78wDnqEBOIHu1TSw1AsE98Rlh2u4+qsNSEdMLzj4/LsELhtWpPxlCH3ON3xXZ
        H0xuT5ExIeY+LP/L3vsSFuxFF4uj5KATnlE3BydUUl5xy3FjS6sqrsY3hghyQ0jO
        yRtgJkI4uNusIEos1h9qygfjS/mUHEYW46b4dBEWaqfDVO6R5wu0ppaU5Gx5ox0A
        k7xH4816hCe6NG6ftfnyB8J/Q2DTYJsWgvEjiNeuoTsvfCDRqbk8Q==
X-ME-Sender: <xms:x6bTX7xwBdsfvA2taVrQX6RmRcJ_BW_kaZEcGGXtSd_G6vq15O7OLA>
    <xme:x6bTXzQE4GHMKeD75pvs9OsZisJ_NqozFk0j7xHt1DD_FrRkX_OBOAHhbhkElsT0l
    PUdXpm0eXNraqc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekvddgleekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepleeuffeukeejteeugfdvgfdtheefgfejud
    ethfdtveeujedvkefguddvudfhjeefnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghen
    ucfkphepkeegrddvvdelrdduheefrdejkeenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:x6bTX1XaeN-4lBDXg2qzbJHnVqdNBQGv51r0b3VoamLLo2PjoL5KMA>
    <xmx:x6bTX1jA3PvilwrzSKGxeG3O2J3oYoH23r7d54VeFtHMNtAv4pGfWg>
    <xmx:x6bTX9C5MG9vQ8QxZyVZTmyrc6OEn_DwlndbSPUlJURuMydnguvdXA>
    <xmx:yKbTXwMxi2AdavJK_KM30uCud77HkDZX3r1PsNMV_18akahWACc1WQ>
Received: from shredder.lan (igld-84-229-153-78.inter.net.il [84.229.153.78])
        by mail.messagingengine.com (Postfix) with ESMTPA id 780BB1080069;
        Fri, 11 Dec 2020 12:05:10 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 00/15] mlxsw: Introduce initial XM router support
Date:   Fri, 11 Dec 2020 19:03:58 +0200
Message-Id: <20201211170413.2269479-1-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This patch set implements initial eXtended Mezzanine (XM) router
support.

The XM is an external device connected to the Spectrum-{2,3} ASICs using
dedicated Ethernet ports. Its purpose is to increase the number of
routes that can be offloaded to hardware. This is achieved by having the
ASIC act as a cache that refers cache misses to the XM where the FIB is
stored and LPM lookup is performed.

Future patch sets will add more sophisticated cache flushing and
selftests that utilize cache counters on the ASIC, which we plan to
expose via devlink-metric [1].

Patch set overview:

Patches #1-#2 add registers to insert/remove routes to/from the XM and
to enable/disable it. Patch #3 utilizes these registers in order to
implement XM-specific router low-level operations.

Patches #4-#5 query from firmware the availability of the XM and the
local ports that are used to connect the ASIC to the XM, so that netdevs
will not be created for them.

Patches #6-#8 initialize the XM by configuring its cache parameters.

Patch #9-#10 implement cache management, so that LPM lookup will be
correctly cached in the ASIC.

Patches #11-#13 implement cache flushing, so that routes
insertions/removals to/from the XM will flush the affected entries in
the cache.

Patch #14 configures the ASIC to allocate half of its memory for the
cache, so that room will be left for other entries (e.g., FDBs,
neighbours).

Patch #15 starts using the XM for IPv4 route offload, when available.

[1] https://lore.kernel.org/netdev/20200817125059.193242-1-idosch@idosch.org/

Jiri Pirko (15):
  mlxsw: reg: Add XM Direct Register
  mlxsw: reg: Add Router XLT Enable Register
  mlxsw: spectrum_router: Introduce XM implementation of router
    low-level ops
  mlxsw: pci: Obtain info about ports used by eXtended mezanine
  mlxsw: Ignore ports that are connected to eXtended mezanine
  mlxsw: reg: Add Router XLT M select Register
  mlxsw: reg: Add XM Lookup Table Query Register
  mlxsw: spectrum_router: Introduce per-ASIC XM initialization
  mlxsw: reg: Add XM Router M Table Register
  mlxsw: spectrum_router_xm: Implement L-value tracking for M-index
  mlxsw: reg: Add Router LPM Cache ML Delete Register
  mlxsw: reg: Add Router LPM Cache Enable Register
  mlxsw: spectrum_router_xm: Introduce basic XM cache flushing
  mlxsw: spectrum: Set KVH XLT cache mode for Spectrum2/3
  mlxsw: spectrum_router: Use eXtended mezzanine to offload IPv4 router

 drivers/net/ethernet/mellanox/mlxsw/Makefile  |   1 +
 drivers/net/ethernet/mellanox/mlxsw/cmd.h     |  30 +
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  12 +
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  12 +-
 drivers/net/ethernet/mellanox/mlxsw/minimal.c |   3 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.c     |  33 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 585 ++++++++++++-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   5 +
 .../ethernet/mellanox/mlxsw/spectrum_router.c |  23 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.h |  10 +
 .../mellanox/mlxsw/spectrum_router_xm.c       | 812 ++++++++++++++++++
 11 files changed, 1518 insertions(+), 8 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c

-- 
2.29.2

