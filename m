Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 971EF1E0370
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 23:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388207AbgEXVvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 17:51:25 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45371 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387970AbgEXVvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 17:51:25 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 11EDD5C00A3;
        Sun, 24 May 2020 17:51:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 24 May 2020 17:51:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=zELtsC0UGYg9ROw6Y
        Lz5OoemNl56tUjmvuMtSZl6Rmw=; b=dGvuqhnBBY7PSIbrmuSNJPqHHnoAxtmE6
        n6dyMJe/rhupS4V5RMnjtEXn1iZ0Z5Bc2uFbwgEgnQR6yVAOGMH4CO7OI9qXKcxV
        vN/tNdw4j0aYiLWNHt4CjikHbzmXxPnAR4CPAWwG/jtGwgfC1mxfpQg+GUXMmKEi
        SWNaqgNdXsFYpxOFCHIwR6fdWWEe7MW3AAAXZcsofFlfi1I2VTIGWIxG7Z54eIpB
        UM47fe2jRaEl0/bJqPIy+LOz8euxXrRCn/AvUY7TRPkjuTi/okYA2GmwhrCzR6s8
        qwXQBqNNcjMq9PvfqxDahDRRDhZJgrfNfiFLkwGrrd2UdSqWdhkvw==
X-ME-Sender: <xms:W-zKXq3W_Ou2U4IdoDw54Fy756Ui84gW8_pgbgqIEQkNY5QioftLMQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudduledgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeejledrudejiedrvdegrddutdejnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:W-zKXtHx-Ni9SXIiuvcfdmAYO_MQI6ngUBFlNJp5PaqSO-khle5-dA>
    <xmx:W-zKXi4UTS1LSjtCuBIOalNCDqIxSHrralRox3JLVcJgJ5JcB4Ep-w>
    <xmx:W-zKXr1XPk3z47zowtWR870L7A0QlurD4-ot6BfLlGjaaRMpIBB9Pg>
    <xmx:XOzKXrO9L9qnepkzrUoVaHQpbl8uHeV0h_PJV3I94HnpojQWjDZjQA>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 879DA306651E;
        Sun, 24 May 2020 17:51:22 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 00/11] mlxsw: Various trap changes - part 1
Date:   Mon, 25 May 2020 00:50:56 +0300
Message-Id: <20200524215107.1315526-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This patch set contains various changes in mlxsw trap configuration.
Another set will perform similar changes before exposing control traps
(e.g., IGMP query, ARP request) via devlink-trap.

Tested with existing devlink-trap selftests. Please see individual
patches for a detailed changelog.

Ido Schimmel (11):
  mlxsw: spectrum: Rename IGMP trap group
  mlxsw: spectrum: Use same trap group for MLD and IGMP packets
  mlxsw: spectrum: Trap IPv4 DHCP packets in router
  mlxsw: spectrum: Change default rate and priority of DHCP packets
  mlxsw: spectrum_buffers: Assign non-zero quotas to TC 0 of the CPU
    port
  mlxsw: spectrum: Align TC and trap priority
  mlxsw: spectrum_trap: Remove unnecessary field
  mlxsw: spectrum: Rename ARP trap group
  mlxsw: spectrum: Use same trap group for IPv6 ND and ARP packets
  mlxsw: spectrum: Use dedicated trap group for sampled packets
  mlxsw: spectrum: Fix spelling mistake in trap's name

 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  6 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 64 +++++++++----------
 .../mellanox/mlxsw/spectrum_buffers.c         |  2 +-
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   |  7 +-
 drivers/net/ethernet/mellanox/mlxsw/trap.h    |  5 +-
 5 files changed, 40 insertions(+), 44 deletions(-)

-- 
2.26.2

