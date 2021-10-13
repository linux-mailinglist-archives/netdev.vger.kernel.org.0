Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 616CB42BD2C
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 12:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbhJMKkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 06:40:22 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:60969 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229524AbhJMKkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 06:40:21 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 3C05C5C018D;
        Wed, 13 Oct 2021 06:38:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 13 Oct 2021 06:38:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=uboDZAdUflxodDKfv
        1im+GJQXdE6mF2I0591siJEA7Q=; b=lnJP9RnA5jS4hmmEK6f6WRsYR4hW+D8C0
        G5UmY26TKsTw2DEEV9W5CbyHNki5nwRt360wezUeB6qBztIIuyyHwMJ5uvDMMQqd
        Dijwpd4V41l3TGX/K8zzBeA5qf7fhm9kC7Xspq5yiQDyUAZmEvN/Um/QIoVnUAdd
        bxUhgrLh/EZbMnd2kFR+6q6jn9LZw6EzEzqkE+sAxzqS9vNgxyn45oaQmUlJIHAC
        wHMn1DWYRCS7P2B/6y97DbtvbDFk3q4MgcgcLL057cOXmNGBl+L6c5PHIYFcSi0t
        GvVKYmcrreyS2Qe4P3RX8GZ0hJMHsvlgpwfLraZKEhmsWNcHhJaXw==
X-ME-Sender: <xms:GrdmYQ4wBH1cd-zfWD79ehT0zTzFYM4lJ690v8iYPK5Mwqw3isvCZQ>
    <xme:GrdmYR4m07beJcBL_jtM8PIhj2E_eZemgPhGKteplbYfTtm9xm_Mq192WJJl4iNOg
    Icwl015hmsm5o8>
X-ME-Received: <xmr:GrdmYfeGLqtWi6mcfCGfaicpb2aVkTV2gWnr704_egUEcQz97CtlJJx488FrnHVMOkWiuxUxiL04EOHE-hxSijJDpNiz42UJ9bkvHG-S2UoDkA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddutddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghr
    rghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:GrdmYVLNqJLbphzydA9NAAiE2THjsky2NDzACM2S5JgBRop_SYn6ow>
    <xmx:GrdmYULcMrqdZ0hevFEpZCgHJEuE83GpkEExsKnkiyHv2WhuYwZV-g>
    <xmx:GrdmYWywScOtwRdXRAHnzcsDddFOGuxH22DzjsQ7_vORUPGCS6-4jg>
    <xmx:GrdmYZH0mvcHIbbsrh5iNqdbBQl-3ALaRGS9gLAnx0AdH_vlKUvOEQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 13 Oct 2021 06:38:15 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/5] mlxsw: Show per-band ECN-marked counter on qdisc
Date:   Wed, 13 Oct 2021 13:37:43 +0300
Message-Id: <20211013103748.492531-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Petr says:

The RED qdisc can expose number of packets that it has marked through
the prob_marked counter (shown in iproute2 as "marked"). This counter
currently just shows number of packets marked in the SW datapath, which
in a switch deployment likely means zero.

Spectrum-3 does support per-TC counters, and in this patchset, mlxsw
supports this RED statistic properly.

Patches #1 and #2 fix typos.

Patch #3 adds a field ecn_marked_tc to the PPCNT register.

Patch #4 adds the support to publish the value of ecn_marked_tc through
the prob_marked RED qdisc counter.

Patch #5 adds selftests.

Petr Machata (5):
  mlxsw: reg: Fix a typo in a group heading
  mlxsw: reg: Rename MLXSW_REG_PPCNT_TC_CONG_TC to _CNT
  mlxsw: reg: Add ecn_marked_tc to Per-TC Congestion Counters
  mlxsw: spectrum_qdisc: Introduce per-TC ECN counters
  selftests: mlxsw: RED: Test per-TC ECN counters

 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 10 +++-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 12 +++--
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  1 +
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  |  9 +++-
 .../drivers/net/mlxsw/sch_red_core.sh         | 51 +++++++++++++++----
 .../drivers/net/mlxsw/sch_red_ets.sh          | 11 ++++
 .../drivers/net/mlxsw/sch_red_root.sh         |  8 +++
 7 files changed, 84 insertions(+), 18 deletions(-)

-- 
2.31.1

