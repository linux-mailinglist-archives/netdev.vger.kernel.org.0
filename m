Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0D412AD2C2
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 10:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgKJJuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 04:50:18 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:49741 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726467AbgKJJuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 04:50:18 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 52B90367;
        Tue, 10 Nov 2020 04:50:17 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 10 Nov 2020 04:50:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Ms1fW1EcuYjinJ5+H
        NZ0w9Hb42fjkIFTjLLiVHw6IMY=; b=baJ/Vcr4E14DmU2IHKJIHUq43CblVW8Hw
        EB1JdKIxl5S1Jzx6PYJFX6vk84qmuQeWb/edwIeQAbDmi8ct99VKALxAjA1ShoSx
        L2s2dfewpFlaTP57ZAtboqZE010FZBKm9gGP4eG2xE+T9WH3A0qhafj+5ii1nzoq
        SB+UPWnXDLYbXhAEulNXf+jgnvkZjsq6cZSUxMzKf5/WR14y7zxVIpxpezfbLwWk
        N9BI9sH9nh2i11Zo0j0i/YxN0AHSHjn+S1pD1G5D3HhDlnHRdYfXiMkv21pzzGQk
        VYqXedcGEY/y+fc79xwV/AMwWn4ArPbHH0DlvLYB5VdImxnauk0lg==
X-ME-Sender: <xms:WGKqX65rn44xTcO9oUxlShDMNd24CylrM2-pXRDzFY-g4cMYACAVYQ>
    <xme:WGKqXz5J_WSFuDKJ8v26CbaVqUuZU4ITEGCSP249iSY59VowCowbFDBRFzf-QqpLU
    sPsxyNLQ4dyU5w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddujedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeekgedrvddvledrudehgedrudegjeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:WGKqX5c7LtD-3QnGG93l1OjWsOckefRdbjtiCNIl2yoAdwUtU1Aeig>
    <xmx:WGKqX3J1UFMNsWfKpcpucZLDXUmZNU_rFZUIonyWx8PaA2vfxBO2_w>
    <xmx:WGKqX-IxIiD7__i6ta01wbxGPXrHZPKqyWQVfmIOt5WxhMdv85b3SA>
    <xmx:WGKqX1XZ2LFfy6K3_UHlugteT8wckDYYdvHQtrLpwcU8ewQdVpAgAg>
Received: from shredder.mtl.com (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7CDEE3280060;
        Tue, 10 Nov 2020 04:50:15 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 00/15] mlxsw: spectrum: Prepare for XM implementation - prefix insertion and removal
Date:   Tue, 10 Nov 2020 11:48:45 +0200
Message-Id: <20201110094900.1920158-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Jiri says:

This is a preparation patchset for follow-up support of boards with
extended mezzanine (XM), which is going to allow extended (scale-wise)
router offload.

XM requires a separate PRM register named XMDR to be used instead of
RALUE to insert/update/remove FIB entries. Therefore, this patchset
extends the previously introduces low-level ops to be able to have
XM-specific FIB entry config implementation.

Currently the existing original RALUE implementation is moved to "basic"
low-level ops.

Unlike legacy router, insertion/update/removal of FIB entries into XM
could be done in bulks up to 4 items in a single PRM register write.
That is why this patchset implements "an op context", that allows the
future XM ops implementation to squash multiple FIB events to single
register write. For that, the way in which the FIB events are processed
by the work queue has to be changed.

The conversion from 1:1 FIB event - work callback call to event queue is
implemented in patch #3.

Patch #4 introduces "an op context" that will allow in future to squash
multiple FIB events into one XMDR register write. Patch #12 converts it
from stack to be allocated per instance.

Existing RALUE manipulations are pushed to ops in patch #10.

Patch #13 is introducing a possibility for low-level implementation to
have per FIB entry private memory.

The rest of the patches are either cosmetics or smaller preparations.

Jiri Pirko (15):
  mlxsw: spectrum_router: Pass non-register proto enum to
    __mlxsw_sp_router_set_abort_trap()
  mlxsw: spectrum_router: Use RALUE-independent op arg
  mlxsw: spectrum_router: Introduce FIB event queue instead of separate
    works
  mlxsw: spectrum: Propagate context from work handler containing RALUE
    payload
  mlxsw: spectrum_router: Push out RALUE pack into separate helper
  mlxsw: spectrum: Export RALUE pack helper and use it from IPIP
  mlxsw: spectrum_router: Pass destination IP as a pointer to
    mlxsw_reg_ralue_pack4()
  mlxsw: reg: Allow to pass NULL pointer to mlxsw_reg_ralue_pack4/6()
  mlxsw: spectrum_router: Use RALUE pack helper from abort function
  mlxsw: spectrum: Push RALUE packing and writing into low-level router
    ops
  mlxsw: spectrum_router: Prepare work context for possible bulking
  mlxsw: spectrum_router: Have FIB entry op context allocated for the
    instance
  mlxsw: spectrum_router: Introduce fib_entry priv for low-level ops
  mlxsw: spectrum_router: Track FIB entry committed state and skip
    uncommitted on delete
  mlxsw: spectrum_router: Introduce FIB entry update op

 drivers/net/ethernet/mellanox/mlxsw/reg.h     |   8 +-
 .../ethernet/mellanox/mlxsw/spectrum_ipip.c   |  34 +-
 .../ethernet/mellanox/mlxsw/spectrum_ipip.h   |   7 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 761 +++++++++++++-----
 .../ethernet/mellanox/mlxsw/spectrum_router.h |  59 ++
 5 files changed, 635 insertions(+), 234 deletions(-)

-- 
2.26.2

