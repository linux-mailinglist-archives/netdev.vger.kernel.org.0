Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1C440C369
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 12:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237390AbhIOKOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 06:14:45 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:41049 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232154AbhIOKOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 06:14:44 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 088275C010D;
        Wed, 15 Sep 2021 06:13:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 15 Sep 2021 06:13:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=+AOpHsMEHgFdhLLVv
        F9SBsPksGrMhJhojcBVYI65YJw=; b=hkHWonDSt1S80PABYY09MoVxDz8/PtKAw
        t+QGURh42s4pzIkFVICk8v9pJY+RxRu7Sw1S1Erj64essIGIRcQA4gS/5m+v8LED
        f++ezqf9od7ZeEWhrr+e08Z0CKEQ53XLoaIiMP7ExTmcwESgaiIZRYxSGgmuHcgN
        kkMey1HQIMgNt63CAV45Q2mvCFww2XsT2GM0t2nOyjPdlP8JWujfsV6iGxHZkxlP
        eu3FtJV2AlOdrK0gf58sNvJ03nJyVE1IduzAYXerg++zAkwTuq9IoxxKU2cuH/Mg
        k7XLZXYA7fhi0HBBVZufc6tPD3mdgHNtsWCmVkvX3s8CeDANESJpQ==
X-ME-Sender: <xms:RMdBYSUYKRSqULFhj5c15zZKHHnrYz_Y_Q9R5BjV6B2rxSU4PQjBRg>
    <xme:RMdBYemhQiGsCOqhQJleetnVO1WLWcDhwraXgqerg-FbWNXHR1h_RWedysMFXOCW4
    O7NWFl9E-mq8QU>
X-ME-Received: <xmr:RMdBYWaeAk9dgcbOhb8LLkIkC5uQWGJ6JwyyJi27a1miL9Ye97bD72zU-cUDNH78l0PKI7Nd5lOG2QAZZMJRRbhshTH0qWjtEw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudehuddgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepleeuffeukeejteeugfdvgfdtheefgfejud
    ethfdtveeujedvkefguddvudfhjeefnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:RMdBYZWBWL2Q3-Vje84WC0lBps2Jd3oWT8AXNMb8VoGcXhypPnNxNw>
    <xmx:RMdBYcnOugoOs0CPBaAqHzCI_7BNP-RIGsDA1yJfRUNnw-38_skDCQ>
    <xmx:RMdBYec9hdfAWm3qO0OUBF4p1jFYGAOG9EVEzVHjozE-rc2g2lsZBg>
    <xmx:RcdBYbtOaRHeNuVQT7o5IEBbPdD4dto5q5swEank0gtP3tFfGoHUDg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Sep 2021 06:13:22 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 00/10] mlxsw: Add support for transceiver modules reset
Date:   Wed, 15 Sep 2021 13:13:04 +0300
Message-Id: <20210915101314.407476-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This patchset prepares mlxsw for future transceiver modules related [1]
changes and adds reset support via the existing 'ETHTOOL_RESET'
interface.

Patches #1-#6 are relatively straightforward preparations.

Patch #7 tracks the number of logical ports that are mapped to the
transceiver module and the number of logical ports using it that are
administratively up. Needed for both reset support and power mode policy
support.

Patches #8-#9 add required fields in device registers.

Patch #10 implements support for ethtool_ops::reset in order to reset
transceiver modules.

[1] https://lore.kernel.org/netdev/20210824130344.1828076-1-idosch@idosch.org/

Ido Schimmel (10):
  mlxsw: core: Initialize switch driver last
  mlxsw: core: Remove mlxsw_core_is_initialized()
  mlxsw: core_env: Defer handling of module temperature warning events
  mlxsw: core_env: Convert 'module_info_lock' to a mutex
  mlxsw: spectrum: Do not return an error in ndo_stop()
  mlxsw: spectrum: Do not return an error in
    mlxsw_sp_port_module_unmap()
  mlxsw: Track per-module port status
  mlxsw: reg: Add fields to PMAOS register
  mlxsw: Make PMAOS pack function more generic
  mlxsw: Add support for transceiver modules reset

 drivers/net/ethernet/mellanox/mlxsw/core.c    |  29 +--
 drivers/net/ethernet/mellanox/mlxsw/core.h    |   1 -
 .../net/ethernet/mellanox/mlxsw/core_env.c    | 183 +++++++++++++++---
 .../net/ethernet/mellanox/mlxsw/core_env.h    |  13 ++
 drivers/net/ethernet/mellanox/mlxsw/minimal.c |  30 ++-
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  31 ++-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  42 +++-
 .../mellanox/mlxsw/spectrum_ethtool.c         |  10 +
 8 files changed, 281 insertions(+), 58 deletions(-)

-- 
2.31.1

