Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD10A1DCCA0
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 14:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgEUML7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 08:11:59 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60099 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727949AbgEUML7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 08:11:59 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 36DEF5C0089;
        Thu, 21 May 2020 08:11:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 21 May 2020 08:11:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=h7Nx2Wv2Fpq0G2fux
        vSN7Yr8/I33I3D2JUK/HekUyJM=; b=M7o6mJRQUc3smiylgyy+PDqai9BGdQhwQ
        7psAXGeZDFWtWahIQSReFcxkAODKTxMHWlqgZnusaFrXQsUYgSBdfdXhxrjIep1c
        c6qI/ocfXoBOIRGhZG94BTTjLtD0w3sZauEa/SHKcplJPbprhgTYW78G8dDbc15L
        cNAYAoztuhLs7WGB5vM3Z0vcHuuW/TuRAxlfQpg24hFgxNYwxGBlhMXgQqesxdlu
        PpL85GUceM5mrmp9wQhFC+Y1DAE/Btaf4XLrk9nkHsMOyDD2+TnrDQRh2FVE+yAP
        +vj0ID9S74heDudDB7zHXDMPjNl4SfF80/AdbfW+LrelV8sRTcREQ==
X-ME-Sender: <xms:DXDGXkWu6p3xKmeNbtMMYpcbwHfBLvOXU5nFw3txfzx-Xk3tqcp1pA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudduuddggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeejledrudejiedrvdegrddutdejnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:DXDGXolNENuvxYVi3-zpbMSOWF5fpo7LxE7Tu5OmMMgu4-9_FvQGEg>
    <xmx:DXDGXoZxRiutCbDiuyE24vI2hz1u6V4nqC5u5mYOi_WMtGHdgEp0Tg>
    <xmx:DXDGXjUmaNeHTzGxkizZz5zGR5_4btxWDMGgESn0ZmluwZyGgNEyug>
    <xmx:DnDGXivjJwCv4XDIoDTAyhTAzIIzCBraokFTTmT2H7kTN2GWireVqA>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 439E8306647D;
        Thu, 21 May 2020 08:11:56 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 0/2] mlxsw: Various fixes
Date:   Thu, 21 May 2020 15:11:43 +0300
Message-Id: <20200521121145.1076075-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Patch #1 from Jiri fixes a use-after-free discovered while fuzzing mlxsw
/ devlink with syzkaller.

Patch #2 from Amit works around a limitation in new versions of arping,
which is used in several selftests.

Amit Cohen (1):
  selftests: mlxsw: qos_mc_aware: Specify arping timeout as an integer

Jiri Pirko (1):
  mlxsw: spectrum: Fix use-after-free of split/unsplit/type_set in case
    reload fails

 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     | 14 ++++++++++++--
 drivers/net/ethernet/mellanox/mlxsw/switchx2.c     |  8 ++++++++
 .../selftests/drivers/net/mlxsw/qos_mc_aware.sh    |  2 +-
 3 files changed, 21 insertions(+), 3 deletions(-)

-- 
2.26.2

