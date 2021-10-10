Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0271A4280DC
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 13:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbhJJLmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 07:42:37 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47359 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230059AbhJJLmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 07:42:36 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 039505C00AA;
        Sun, 10 Oct 2021 07:40:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 10 Oct 2021 07:40:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=p4+oEv4I4CRhYFGdV
        GZT2eFh4QWNnUzh8ddTRfTdl/o=; b=WAeJpes+EwkxqJAai6ss160oe86Qb+gku
        ltVfMTIPpXqmsx46O6VYA0FYdfSho2G0XPMVN8GD0PWYZAph5QJznLOlrSQdlG7/
        YS3/LmOWU49FTLGRa5M4wdBJYbaQdISozCSAdAKpRaR9uK6OMN68ee1hPPhWjjAn
        1jLnuYh3zWGbKDiZ6VwRmpuTOdHaqIle+VAtPIlqjESqrLEPnpSdxfiIjwVqqcV0
        m/wxZv0FIZLAk04NOxwDRApa5VJROqe/6BT3FwK4mgQiKJ19IlwNmJ4b3RNcnHpF
        BtxCf6Y5o5nyg8KkBh8P/h0dWbTujYytSnPNfsLpyZ7QwZQWykgrA==
X-ME-Sender: <xms:NdFiYUtzZhMjSEfRMVG0XQKXJbr0K4Mt1glZ9xCBO21RQ2yXOjk5aQ>
    <xme:NdFiYReVTuknS4DLlrJdjjK_i15_vrZUGtGyX11erLtJ4nWwxUGHOSIZUaTOYV6FD
    Yi3R8Ei2uyPH2M>
X-ME-Received: <xmr:NdFiYfx8_ErpBCkX9GRtJIhNPqoPN-pRfUFPCzmHzFyGJds1HnCL1ZZxiowWYjRiBwqSn7Az9xq7NDpjlOJaYMyVJvJd0toWoL9oh0mGadbVXw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddtgedggeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghr
    rghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:NdFiYXML_8rUimtq0uKcddbs9yOv4rZA6uCS_QTkznbxeAKCII7dTg>
    <xmx:NdFiYU_2KBfmg6nZdKGliFv8e-_egCgPJ2Z2ZX0QXXGNne8mZC6JVg>
    <xmx:NdFiYfV1dr3HxMhjWObIjB0C7PrHxWDh-IfGwu0zncklPlg8mhlDrA>
    <xmx:NdFiYYYbA89LWTVQL8Vi0kWqSVTd_eEIN-BRs3a4LZ_aAUk6eUyqiQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 10 Oct 2021 07:40:35 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/6] mlxsw: Add support for ECN mirroring
Date:   Sun, 10 Oct 2021 14:40:12 +0300
Message-Id: <20211010114018.190266-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Petr says:

Patches in this set have been floating around for some time now together
with trap_fwd support. That will however need more work, time for which is
nowhere to be found, apparently. Instead, this patchset enables offload of
only packet mirroring on RED mark qevent, enabling mirroring of ECN-marked
packets.

Formally it enables offload of filters added to blocks bound to the RED
qevent mark if:

- The switch ASIC is Spectrum-2 or above.
- Only a single filter is attached at the block, at chain 0 (the default),
  and its classifier is matchall.
- The filter has hw_stats set to disabled.
- The filter has a single action, which is mirror.

This differs from early_drop qevent offload, which supports mirroring and
trapping. However trapping in context of ECN-marked packets is not
suitable, because the HW does not drop the packet, as the trap action
implies. And there is as of now no way to express only the part of trapping
that transfers the packet to the SW datapath, sans the HW-datapath drop.

The patchset progresses as follows:

Patch #1 is an extack propagation.

Mirroring of ECN-marked packets is configured in the ASIC through an ECN
trigger, which is considered "egress", unlike the EARLY_DROP trigger.
In patch #2, add a helper to classify triggers as ingress.

As clarified above, traps cannot be offloaded on mark qevent. Similarly,
given a trap_fwd action, it would not be offloadable on early_drop qevent.
In patch #3, introduce support for tracking actions permissible on a given
block.

Patch #4 actually adds the mark qevent offload.

In patch #5, fix a small style issue in one of the selftests, and in
patch #6 add mark offload selftests.

Petr Machata (6):
  mlxsw: spectrum_qdisc: Pass extack to
    mlxsw_sp_qevent_entry_configure()
  mlxsw: spectrum_qdisc: Distinguish between ingress and egress triggers
  mlxsw: spectrum_qdisc: Track permissible actions per binding
  mlxsw: spectrum_qdisc: Offload RED qevent mark
  selftests: mlxsw: sch_red_core: Drop two unused variables
  selftests: mlxsw: RED: Add selftests for the mark qevent

 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   2 +
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   2 +
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 106 +++++++++++++-----
 .../ethernet/mellanox/mlxsw/spectrum_span.c   |  16 +++
 .../ethernet/mellanox/mlxsw/spectrum_span.h   |   1 +
 .../drivers/net/mlxsw/sch_red_core.sh         |  76 ++++++++++++-
 .../drivers/net/mlxsw/sch_red_ets.sh          |  53 ++++++++-
 7 files changed, 220 insertions(+), 36 deletions(-)

-- 
2.31.1

