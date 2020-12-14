Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEC552D975F
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 12:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437722AbgLNLbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 06:31:50 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60191 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2436805AbgLNLbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 06:31:48 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id F18A25C008F;
        Mon, 14 Dec 2020 06:31:00 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 14 Dec 2020 06:31:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=mrLhKLARbzGrNYWI7
        qEYfccp29vbdHc3uUyTtaF4yPE=; b=gc5bxyC/wDRWGjTXcdKla2zNR2yAt9/7q
        jQdm156HhOOYJrxajVR1n0ugJkZxGOCoC4f1kNgXLZgLOvqNR6k1ocPxY/DHDPkF
        V9ETondx6ZppVvWu5s0g07KEvv1aw/dv4Bww8z1Fo8zZOfAUjaakLQyon1Vc3WAc
        hwZlppq1tUA8U5/7DpZpVkQ6mMs2p2ewZui3krouOpbsm9mKtSVLfur8oquuCrqT
        VNUrX0i7kHpMsCv9zeXa0VpgiEqpkxqwlCTpa+xI3z6LFoepu802zxd/phASoS47
        c6yBO4S3Chjds6iH5EqLFkgTTqeLSGInlK3wPBAvr9x0zXOOk5n4Q==
X-ME-Sender: <xms:9EzXX7j3bddgZKVRnXeRWFZh8b0L3gr2BiW2V-9LUcqN8TEDLgQz1w>
    <xme:9EzXX4Dl97tyuXqoPELMQ36gOmkTz8hGEa0szepddNSevM_zbqEEO6oYFXSAtz7iJ
    WFx0ZMm2aZteAw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekkedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepleeuffeukeejteeugfdvgfdtheefgfejud
    ethfdtveeujedvkefguddvudfhjeefnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghen
    ucfkphepkeegrddvvdelrdduhedvrdefudenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:9EzXX7EPHkqID2B9Q5NQIFFtIWB4jDzXBwbT1aYfCySVy9J_VQYyeg>
    <xmx:9EzXX4Qg9cras2SLUPWSGoDzFOH7irfaX8_M0hn1YeGeLqmNzCI7Dg>
    <xmx:9EzXX4w0iVPH0p6TWMRXKmMuHuLio78jwVSDRfTnCf-XIfJRBrOJmA>
    <xmx:9EzXXz_HWUXRsZ3vXnDYptP65N33frg0E3cElMzUsnV3eRqk8z5BKw>
Received: from shredder.mtl.com (igld-84-229-152-31.inter.net.il [84.229.152.31])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9C3F71080067;
        Mon, 14 Dec 2020 06:30:59 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 00/15] mlxsw: Introduce initial XM router support
Date:   Mon, 14 Dec 2020 13:30:26 +0200
Message-Id: <20201214113041.2789043-1-idosch@idosch.org>
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

v2:
* Patch #13: Fix GENMASK() high bit to build correctly on 32 bits
  (Jakub)

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

