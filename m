Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C325344A04
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbhCVP7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 11:59:46 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:50219 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230358AbhCVP7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 11:59:38 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 91F345C0193;
        Mon, 22 Mar 2021 11:59:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 22 Mar 2021 11:59:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=crFmg59aAXKahKf4Q
        HNAz8LqZeT08R6igBAxuOotSkY=; b=VM8OWjP5KKMr8IZXEppLoP3lAwcSkJ+cA
        3z2dj/RAWTwV0HPsDTtr/NtkQ6eWKKg8IOCQVIXLKeX/YOfsgpuLOTYp4GZYlPdr
        7mOsZATBX2uDLDhTvW+tduYjUIRTuT8FQFtDKlWB4GVIym0nN9vyydPsHw0Ii0nF
        gwTO8VVpG1NjpMNkuR83s3VuPYtM3/rN6zJOerVaFT0HL/L2eLT2YBhVANH1N34h
        z4QNbxV+TcQyG/U1rgRdR3XHq72TKzbSvrvgYj2tXe5fTOcEeYAFt2zDPt4NgHYA
        tW2qJeEXeYgUBWX1OV40AlED/TkopfurG60snR1TTdPLoccHGWYug==
X-ME-Sender: <xms:6L5YYEsioIj8Nm8KxazaA_YGe_Kvm-WH0mRNiFbu73jTQIRYdN3beg>
    <xme:6L5YYBcYGPqzgWVganz2RYs6MxMuiVV1TIy-pK_4zok_ClkW4GBNFgYBAzsxcHNHH
    xlP-Kyw0U_Qsmk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeggedgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeekgedrvddvledrudehfedrgeegnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:6b5YYPxDe0B9mUIBdxqb7qwijusD4wh_1Vq_GwZybaZeFcaBYHe4BQ>
    <xmx:6b5YYHPGw6xql1ZIYMbHs8iy2ZW05QluVjle3jOBQ5QvVGQBs3konQ>
    <xmx:6b5YYE-V7lvZtypRaAR8WExtHkmATiTWwW2FB9mjFNSyuIXYF4gUkA>
    <xmx:6b5YYIYy91Xu8flmj5RtrxJhHkyUC_hOKjNJM83ojBSqA_Pjej64AA>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id CE207108005C;
        Mon, 22 Mar 2021 11:59:34 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 00/14] mlxsw: Preparations for resilient nexthop groups
Date:   Mon, 22 Mar 2021 17:58:41 +0200
Message-Id: <20210322155855.3164151-1-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This patchset contains preparations for resilient nexthop groups support in
mlxsw. A follow-up patchset will add support and selftests. Most of the
patches are trivial and small to make review easier.

Patchset overview:

Patch #1 removes RTNL assertion in nexthop notifier block since it is
not needed. The assertion will trigger when mlxsw starts processing
notifications related to resilient groups as not all are emitted with
RTNL held.

Patches #2-#9 gradually add support for nexthops with trap action. Up
until now mlxsw did not program nexthops whose neighbour entry was not
resolved. This will not work with resilient groups as their size is
fixed and the nexthop mapped to each bucket is determined by the nexthop
code. Therefore, nexthops whose neighbour entry is not resolved will be
programmed to trap packets to the CPU in order to trigger neighbour
resolution.

Patch #10 is a non-functional change to allow for code reuse between
regular nexthop groups and resilient ones.

Patch #11 avoids unnecessary neighbour updates in hardware. See the
commit message for a detailed explanation.

Patches #12-#14 add support for additional nexthop group sizes that are
supported by Spectrum-{2,3} ASICs.

Ido Schimmel (14):
  mlxsw: spectrum_router: Remove RTNL assertion
  mlxsw: spectrum_router: Consolidate nexthop helpers
  mlxsw: spectrum_router: Only provide MAC address for valid nexthops
  mlxsw: spectrum_router: Adjust comments on nexthop fields
  mlxsw: spectrum_router: Introduce nexthop action field
  mlxsw: spectrum_router: Prepare for nexthops with trap action
  mlxsw: spectrum_router: Add nexthop trap action support
  mlxsw: spectrum_router: Rename nexthop update function to reflect its
    type
  mlxsw: spectrum_router: Encapsulate nexthop update in a function
  mlxsw: spectrum_router: Break nexthop group entry validation to a
    separate function
  mlxsw: spectrum_router: Avoid unnecessary neighbour updates
  mlxsw: spectrum_router: Create per-ASIC router operations
  mlxsw: spectrum_router: Encode adjacency group size ranges in an array
  mlxsw: spectrum_router: Add Spectrum-{2, 3} adjacency group size
    ranges

 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   6 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   8 +-
 .../ethernet/mellanox/mlxsw/spectrum_dpipe.c  |  19 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 277 +++++++++++++-----
 .../ethernet/mellanox/mlxsw/spectrum_router.h |   9 +-
 5 files changed, 218 insertions(+), 101 deletions(-)

-- 
2.29.2

