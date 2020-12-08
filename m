Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7CF2D2775
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 10:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728812AbgLHJYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 04:24:36 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53899 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726114AbgLHJYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 04:24:35 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id C1FA95C01E4;
        Tue,  8 Dec 2020 04:23:49 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 08 Dec 2020 04:23:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=9T0AnTyN8NFgA7nQV
        pl3OEzGVyHpvEy1+TinI38szLc=; b=kee9grSI0CtSEDRFfgBfnK5nGlp7bE/Im
        i9YxZHxeHq4xzf4Hs85Xa8D+5DNObFQ/eJj+vdQr3H1BPSr8TYDWTluZcvnCcWlW
        MDy20Khg5iNy4F64mdT+jdeRPEFba3fyI9WrzoaSYcHp9NtKLfu5Rovzh/Tkm0Qh
        Yxn9vcXPGA5WHrCFiNOcVa43X+3YSw7iahKs/vvLUQ3djhOao5NfqbiC6+n70wjK
        abJZNjg/0rhPfJL8PyK8Sghb9Nb2rLmUtg2mP5+AMS9HETiaRzsYCd+DFyhjA7Ay
        X5HWYauQrDdefczrE+lmTiwPilGzus7Bmg0sugUnrNXCzOC022pbw==
X-ME-Sender: <xms:JUbPXyL8mu6VvntyJfJlV6DAXffUjqOgwOsSDR_CKQoHi-gtNLb3fQ>
    <xme:JUbPXxnerXMMwtEn4eKB30fL0bLJM2SpmxdcM4667qea2s244mE4Jko1UALzjr0kH
    k5mLPbVCAWZKnI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejiedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeekgedrvddvledrudehfedrjeeknecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:JUbPXwEPHBiFE1oHqa1s-TMfee8EQ-oPAduGAIOUnPhjBNkLCFeWkA>
    <xmx:JUbPXxHNIxX_E3qiIIpDh_ysxXsWtHl1aH0zsYJ-xNobpP0f0jXMQA>
    <xmx:JUbPX9MRiV75PX4dIFsQsT772OCJw3wGWXz8beJVpJL0l_oz1PeGVg>
    <xmx:JUbPX9uNEECctLfqLPVNOFIitT9Errv9OV9smzbGEwj8yvRU6B2ccg>
Received: from shredder.lan (igld-84-229-153-78.inter.net.il [84.229.153.78])
        by mail.messagingengine.com (Postfix) with ESMTPA id A1B0E1080064;
        Tue,  8 Dec 2020 04:23:47 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 00/13] mlxsw: Add support for Q-in-VNI
Date:   Tue,  8 Dec 2020 11:22:40 +0200
Message-Id: <20201208092253.1996011-1-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This patch set adds support for Q-in-VNI over Spectrum-{2,3} ASICs.
Q-in-VNI is like regular VxLAN encapsulation with the sole difference
that overlay packets can contain a VLAN tag. In Linux, this is achieved
by adding the VxLAN device to a 802.1ad bridge instead of a 802.1q
bridge.

From mlxsw perspective, Q-in-VNI support entails two main changes:

1. An outer VLAN tag should always be pushed to the overlay packet
during decapsulation

2. The EtherType used during decapsulation should be 802.1ad (0x88a8)
instead of the default 802.1q (0x8100)

Patch set overview:

Patches #1-#3 add required device registers and fields

Patch #4 performs small refactoring to allow code re-use

Patches #5-#7 make the EtherType used during decapsulation a property of
the tunnel port (i.e., VxLAN). This leads to the driver vetoing
configurations in which VxLAN devices are member in both 802.1ad and
802.1q/802.1d bridges. Will be handled in the future by determining the
overlay EtherType on the egress port instead

Patch #8 adds support for Q-in-VNI for Spectrum-2 and newer ASICs

Patches #9-#10 veto Q-in-VNI for Spectrum-1 ASICs due to some hardware
limitations. Can be worked around, but decided not to support it for now

Patch #11 adjusts mlxsw to stop vetoing addition of VXLAN devices to
802.1ad bridges

Patch #12 adds a generic forwarding test that can be used with both veth
pairs and physical ports with a loopback

Patch #13 adds a test to make sure mlxsw vetoes unsupported Q-in-VNI
configurations

Amit Cohen (12):
  mlxsw: Use one enum for all registers that contain tunnel_port field
  mlxsw: reg: Add Switch Port VLAN Stacking Register
  mlxsw: reg: Add support for tunnel port in SPVID register
  mlxsw: spectrum_switchdev: Create common function for joining VxLAN to
    VLAN-aware bridge
  mlxsw: Save EtherType as part of mlxsw_sp_nve_params
  mlxsw: Save EtherType as part of mlxsw_sp_nve_config
  mlxsw: spectrum: Publish mlxsw_sp_ethtype_to_sver_type()
  mlxsw: spectrum_nve_vxlan: Add support for Q-in-VNI for Spectrum-2
    ASIC
  mlxsw: spectrum_switchdev: Use ops->vxlan_join() when adding VLAN to
    VxLAN device
  mlxsw: Veto Q-in-VNI for Spectrum-1 ASIC
  mlxsw: spectrum_switchdev: Allow joining VxLAN to 802.1ad bridge
  selftests: mlxsw: Add Q-in-VNI veto tests

Petr Machata (1):
  selftests: forwarding: Add Q-in-VNI test

 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 146 ++++++--
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   2 +
 .../ethernet/mellanox/mlxsw/spectrum_nve.c    |   6 +-
 .../ethernet/mellanox/mlxsw/spectrum_nve.h    |   5 +-
 .../mellanox/mlxsw/spectrum_nve_vxlan.c       |  67 +++-
 .../mellanox/mlxsw/spectrum_switchdev.c       |  32 +-
 .../net/mlxsw/spectrum-2/q_in_vni_veto.sh     |  77 ++++
 .../net/mlxsw/spectrum/q_in_vni_veto.sh       |  66 ++++
 .../selftests/net/forwarding/q_in_vni.sh      | 347 ++++++++++++++++++
 10 files changed, 703 insertions(+), 47 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/spectrum-2/q_in_vni_veto.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/spectrum/q_in_vni_veto.sh
 create mode 100755 tools/testing/selftests/net/forwarding/q_in_vni.sh

-- 
2.28.0

