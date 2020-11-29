Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 721E22C7926
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 13:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387406AbgK2Mzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 07:55:47 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:53617 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727210AbgK2Mzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 07:55:46 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 8140758051A;
        Sun, 29 Nov 2020 07:54:40 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 29 Nov 2020 07:54:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=JWvE4wkdTHgXND6Y4
        bjPsbiWmIMG3ggvyGEu9Fq8aWI=; b=mi1BAUBb2QpKhInOgWPOSFHzvFCiJqYGC
        qbJMVarRepEk5V9ansX6hKbMXL1PsT2qtJI69kiPrfKf2K4HeAO6f/F+ulhvAyJ4
        EeHFYttDKYEr2rQVxjYXR14/nYB7ybcyLavALnAyA3Sw/ra0MqJQO7yLbEX6VIli
        HjMhdO0+mAZDnfgEg3L07pLBoCXzBI8oa79ISmv2MCBbaJdCzzH7KACooBxzz/tR
        UppIAECK7BBzmpdFZxWoVEFlOdL6PEtiY3ZokiECl3EeBRejRgHVsKyh4c7ItnqG
        J9Zlw/tGrngbC8VHbPBegWpfnrggGdOGRxJ6t++DnAAwsmaO6jjcg==
X-ME-Sender: <xms:EJrDXz9vQLxvb1P2VsfMKmXQIaP6EUZvoY9CP0Z-oJYGDdJic6Lnyw>
    <xme:EJrDX_sTbIMpsTldC1ySUGsYxlXYBhWzSBzyjVTsPUmIzwPu77UJMezYAi_vbIlDj
    bxQsSjRaZViIo8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudehkedggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeekgedrvddvledrudehgedrudegjeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:EJrDXxBcvBvfBoNAXgEH7tRl50E80ngJB0C9g7lApZvCvxs-ERNajw>
    <xmx:EJrDX_f-jA3T67PROoMYwCjpp2b_s2kjsTt1ZeyqwIX4vnyMEEyuHg>
    <xmx:EJrDX4M9Euw8MiNvXIkkUlOaGwllAEBlLqTJD4c9_Qr-3crNQ88v1Q>
    <xmx:EJrDX3rLy8-kx3DOyx0rG3tOPbQMjYzj63cWKFi6NpzGMG9MlsmbMg>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 278683064AB2;
        Sun, 29 Nov 2020 07:54:38 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        ivecera@redhat.com, roopa@nvidia.com, nikolay@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, petrm@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/9] mlxsw: Add support for 802.1ad bridging
Date:   Sun, 29 Nov 2020 14:53:58 +0200
Message-Id: <20201129125407.1391557-1-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

802.1ad, also known as QinQ, is an extension to the 802.1q standard,
which is concerned with passing possibly 802.1q-tagged packets through
another VLAN-like tunnel. The format of 802.1ad tag is the same as
802.1q, except it uses the EtherType of 0x88a8, unlike 802.1q's 0x8100.

Currently, mlxsw supports bridging with VLAN-unaware (802.1d) bridges
and with VLAN-aware bridges whose VLAN protocol is 802.1q. This set adds
support for VLAN-aware bridges whose VLAN protocol is 802.1ad.

From mlxsw perspective, 802.1ad support entails two main changes:

1. Ports member in an 802.1ad bridge need to be configured to classify
802.1ad packets as tagged and all other packets as untagged

2. When pushing a VLAN at ingress (PVID), its EtherType needs to be
0x88a8 instead of 802.1q's 0x8100

The rest stays the same as with 802.1q bridges.

A follow-up patch set will add support for QinQ with VXLAN, also known
as QinVNI. Currently, linking of a VXLAN netdev to an 802.1ad bridge is
vetoed and an error is returned to user space.

Patch set overview:

Patches #1-#2 add the registers required to configure the two changes
described above.

Patch #3 changes the device to only treat 802.1q packets as tagged by
default, as opposed to both 802.1q and 802.1ad packets. This is more
inline with the behavior supported by the driver.

Patch #4 adds the ability to configure the EtherType when pushing a PVID
at ingress.

Patch #5 performs small refactoring to allow for code re-use in the next
patch.

Patch #6 adds support for 802.1ad bridging and allows mlxsw ports and
their uppers to join such a bridge.

Patch #7 changes the bridge driver to notify about changes to its VLAN
protocol, so that these could be vetoed by mlxsw in the next patch.

Patches #8-#9 teach mlxsw to veto unsupported 802.1ad configurations and
add a corresponding selftest to make sure such configurations are indeed
vetoed.

Amit Cohen (6):
  mlxsw: reg: Add Switch Port VLAN Classification Register
  mlxsw: reg: Add et_vlan field to SPVID register
  mlxsw: spectrum: Only treat 802.1q packets as tagged packets
  mlxsw: Make EtherType configurable when pushing VLAN at ingress
  mlxsw: spectrum_switchdev: Create common functions for VLAN-aware
    bridge
  mlxsw: spectrum_switchdev: Add support of QinQ traffic

Danielle Ratson (3):
  bridge: switchdev: Notify about VLAN protocol changes
  mlxsw: Add QinQ configuration vetoes
  selftests: forwarding: Add QinQ veto testing

 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 114 ++++++-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 111 ++++++-
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   7 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.c |   9 +
 .../mellanox/mlxsw/spectrum_switchdev.c       | 123 +++++++-
 include/net/switchdev.h                       |   2 +
 net/bridge/br_vlan.c                          |  16 +-
 .../drivers/net/mlxsw/q_in_q_veto.sh          | 296 ++++++++++++++++++
 8 files changed, 657 insertions(+), 21 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/q_in_q_veto.sh

-- 
2.28.0

