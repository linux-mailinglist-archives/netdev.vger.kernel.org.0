Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBCE6C217
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 22:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbfGQU36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 16:29:58 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:48087 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727166AbfGQU36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 16:29:58 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 4976822303;
        Wed, 17 Jul 2019 16:29:55 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 17 Jul 2019 16:29:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=x02OkbuWpFxW9gS5g
        9vxfdNB+3ZSjKwKfD4G+YYazic=; b=RxvoDZNV6+/sbnCUiNegg0KRBjUuA7moE
        pJ0NvKPGZOUXuYd8AMLnTIekE8bQ2xaco174KllHtKgSdZFBpst/Sx9CT4IRtVwp
        +ZqwSPjVAVb0mxDgoxny9mmC5gOw8NBWvf7NOXKWIF5H+o3uKEvvEl41OAEl9+XH
        avGgPI8hJ9Xz2KAYPZU7Q4G1Kyq8/6JJBzJsz4e0pRY0rk9X9XJ41S+cwuJA6UZ9
        QlaWDGsvF1jDYUX+XrtfIfKhsVzsFGON73h4oXPsDaoyg8CVNy6qnSeagXVKuFW2
        i0X8IbqElfcNfYKMug7eIfFBVsfenKLicrLZQ74meyt8WRbLgaGgg==
X-ME-Sender: <xms:QoUvXX-OWALP1YzGtoZ2cd7FEeLM-667P49Qe2LjsMYKOk8DtGtIdw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrieefgdduvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeejjedrudefkedrvdegledrvddtleenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:QoUvXUbSFvQfNh3qQbOcVsLY0bccvPgFlH55pdbecGkxEEnJvs9FvA>
    <xmx:QoUvXQHTISpbUCWh3aB_vqV9XeufZau0TfbZjtoFcPpwGSOI4R7YLA>
    <xmx:QoUvXTePthnW9eTgLqu1zgTwsh8F2rLWmuDObb8LAKyO3wsBrLFpxQ>
    <xmx:Q4UvXZ9HhU-RBs_rLSf9plzSsGPSGGI6HIugynqGu9d46-ZOfgy4OA>
Received: from localhost.localdomain (unknown [77.138.249.209])
        by mail.messagingengine.com (Postfix) with ESMTPA id CE850380074;
        Wed, 17 Jul 2019 16:29:52 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 0/2] mlxsw: Two fixes
Date:   Wed, 17 Jul 2019 23:29:06 +0300
Message-Id: <20190717202908.1547-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This patchset contains two fixes for mlxsw.

Patch #1 from Petr fixes an issue in which DSCP rewrite can occur even
if the egress port was switched to Trust L2 mode where priority mapping
is based on PCP.

Patch #2 fixes a problem where packets can be learned on a non-existing
FID if a tc filter with a redirect action is configured on a bridged
port. The problem and fix are explained in detail in the commit message.

Please consider both patches for 5.2.y

Ido Schimmel (1):
  mlxsw: spectrum: Do not process learned records with a dummy FID

Petr Machata (1):
  mlxsw: spectrum_dcb: Configure DSCP map as the last rule is removed

 drivers/net/ethernet/mellanox/mlxsw/spectrum.h   |  1 +
 .../net/ethernet/mellanox/mlxsw/spectrum_dcb.c   | 16 ++++++++--------
 .../net/ethernet/mellanox/mlxsw/spectrum_fid.c   | 10 ++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_switchdev.c |  6 ++++++
 4 files changed, 25 insertions(+), 8 deletions(-)

-- 
2.21.0

