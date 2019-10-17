Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA320DA5CF
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 08:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392643AbfJQG4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 02:56:12 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:53711 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389363AbfJQG4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 02:56:11 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 9EB3520D12;
        Thu, 17 Oct 2019 02:56:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 17 Oct 2019 02:56:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=//FuUEmNiq9wd5eek
        x6chat7AKEHAXd3eiaIqMeusec=; b=nsroYq53ubVbY4in8sVkjMh0g9l0A1V+d
        LJeXhXDHO0Q3mYBOATUF0xCkbutuRfPFPI6g3DFvUDt0JsbGrZ0XnmnQ/2E2h0md
        eQuxHbNMutTWwUGGrg7W/2NETZ/m64qPjZLtMdbQNdwPQCKrs89N1qLOCv9A2Mr/
        nxBfJNOkslLXbHR+n/91j2UAfNy0+hycH7PN1NolnSKQQBWaWbhCNLjDzKnAYLt4
        /gKSXjm1kGYmKsV0KGsMibiFfn7jqxmy4+4mM+LrU+6xzHWjSeFty+itKtUcQUGv
        Zmpx16x2D25OO/pFwQmNzk8uyN1AeDGw5jpXa5zf/WUogOg54nx8Q==
X-ME-Sender: <xms:iRCoXU4NUDlatkMxB5kerR63aU7RQBCI2cyehL68mhPO1ymv_pL_Vw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrjeeigdduuddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:ihCoXe0X7j5hN2fmjc2y_KnBEI034vh2_QnPsQd91o5VfFqR8LCeSQ>
    <xmx:ihCoXfBllJ-5PI-3aLZqCdn4U8F2JHLngQXh5K-NtVaA-Bn_ccE2Bg>
    <xmx:ihCoXZNIdlYSNdxJvp4skGmBRH0z6heFMAcBqU1W3srOiuTUrW81Qw>
    <xmx:ihCoXWCCgzH01sEWxV1VGVaZNwQVBolCbRnGOv-UqpXK0qRsBRkf_g>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id D3EAAD60057;
        Thu, 17 Oct 2019 02:56:08 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, danieller@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/5] selftests: mlxsw: Add scale tests for Spectrum-2
Date:   Thu, 17 Oct 2019 09:55:13 +0300
Message-Id: <20191017065518.27008-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This series from Danielle adds two scale tests for the Spectrum-2 ASIC.

The first scale test (patches #1-#4) validates the number of mirroring
sessions (using tc-mirred) that can be supported by the device. As a
preparatory step, patch #1 exposes the maximum number and current usage
of mirroring agents via devlink-resource. This allows us to avoid
hard-coding the limits later in the test.

The second scale test (patch #5) validates the number of tc-flower
filters that can be supported by the device.

Danielle Ratson (5):
  mlxsw: spectrum: Register switched port analyzers (SPAN) as resource
  selftests: mlxsw: Generalize the parameters of mirror_gre test
  selftests: mlxsw: Add Spectrum-2 mirror-to-gretap target scale test
  selftests: mlxsw: Add a resource scale test for Spectrum-2
  selftests: mlxsw: Add Spectrum-2 target scale for tc flower scale test

 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 51 ++++++++++++++++++-
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  3 ++
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 21 ++++++++
 .../net/mlxsw/spectrum-2/mirror_gre_scale.sh  | 16 ++++++
 .../net/mlxsw/spectrum-2/resource_scale.sh    | 46 +++++++++++++++++
 .../net/mlxsw/spectrum-2/tc_flower_scale.sh   | 20 ++++++++
 .../net/mlxsw/spectrum/mirror_gre_scale.sh    |  7 ++-
 7 files changed, 160 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/spectrum-2/mirror_gre_scale.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/spectrum-2/tc_flower_scale.sh

-- 
2.21.0

