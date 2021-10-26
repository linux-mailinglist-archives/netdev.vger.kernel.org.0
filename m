Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCA7943AF42
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 11:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234374AbhJZJpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 05:45:19 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:34047 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233382AbhJZJpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 05:45:19 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 7345D5C00FF;
        Tue, 26 Oct 2021 05:42:55 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 26 Oct 2021 05:42:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=bSAsgfvNjrDE2Tx7N
        PgtPNPSLYCKD76OqJopj3qo8b0=; b=jnxByoMcZVw+QrlHlVJMyK9DkOMcnYZpZ
        H7SGzvaiotHNLWJIzVpE5U97vsfP6+ejjRcnvldDVaaFp4snpDCMXPAc/CA0Qq3c
        ZP4jw0OZBPigqvxCa0d87J2KKy1RrGJKDrtMyNp9VGMRJx3K57zdhIrRW9sYl/Ur
        w3nLXak5yMECxaslFpr34gXVuC8ea/xF6YmckY0En8FYZcsif9ovWQqCWq/rDoLQ
        5wOA8nx2Io6EHn4A0G0ip36Q7B/mVFqKUce2R6A9AL+/OQ9kjE2RlN6VOAYN8bVu
        h7mXR30GMibzrcao9oYzQEUVFC0IAuvHrptXyCHMP5qIapbPdxbfw==
X-ME-Sender: <xms:ns13YdqmNzdwKGMMI2u6x0x98UYx9rbYj4vFmFxK5xBmVcOhN6LsqA>
    <xme:ns13YfoCiKc8ornQX0SJbq4zNvGde7BWpPAT9LNTqDdVKB2l7BpSxevNA5SRFrzcF
    ufcDoWrMNz4biw>
X-ME-Received: <xmr:ns13YaM4bglfilM3X-3bcC8RAVljeIbT8D3UKKrxhHUL06wS0ZrP0bDdlmcuAYAbLN2qocbaiyb8-dVsy9278m_33AV_DlbRExU7XOlf5c4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdefjedgudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghr
    rghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ns13YY7799_iNrIgNEQ2-7HPpGcvZSSg8Os6-KQkmZSSt6NPADhgnw>
    <xmx:ns13Yc5zw296lKPyHFkPg16Pc4Gr_XgS3TWs9Hy6VCQrhiRV0GFUEA>
    <xmx:ns13YQj_ERcJCUMQEyUKy1XaTrdqIcfO1e-MaBrydPh4QpupNCNT0w>
    <xmx:n813YWT3gWvwRUlOMxhlJJ-giMqFE83TqFyB5KCQSxMapRtwPU-9SA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 Oct 2021 05:42:52 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/9] mlxsw: Support multiple RIF MAC prefixes
Date:   Tue, 26 Oct 2021 12:42:16 +0300
Message-Id: <20211026094225.1265320-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Currently, mlxsw enforces that all the netdevs used as router interfaces
(RIFs) have the same MAC prefix (e.g., same 38 MSBs in Spectrum-1).
Otherwise, an error is returned to user space with extack. This patchset
relaxes the limitation through the use of RIF MAC profiles.

A RIF MAC profile is a hardware entity that represents a particular MAC
prefix which multiple RIFs can reference. Therefore, the number of
possible MAC prefixes is no longer one, but the number of profiles
supported by the device.

The ability to change the MAC of a particular netdev is useful, for
example, for users who use the netdev to connect to an upstream provider
that performs MAC filtering. Currently, such users are either forced to
negotiate with the provider or change the MAC address of all other
netdevs so that they share the same prefix.

Patchset overview:

Patches #1-#3 are preparations.

Patch #4 adds actual support for RIF MAC profiles.

Patch #5 exposes RIF MAC profiles as a devlink resource, so that user
space has visibility into the maximum number of profiles and current
occupancy. Useful for debugging and testing (next 3 patches).

Patches #6-#8 add both scale and functional tests.

Patch #9 removes tests that validated the previous limitation. It is now
covered by patch #6 for devices that support a single profile.

Danielle Ratson (9):
  mlxsw: reg: Add MAC profile ID field to RITR register
  mlxsw: resources: Add resource identifier for RIF MAC profiles
  mlxsw: spectrum_router: Propagate extack further
  mlxsw: spectrum_router: Add RIF MAC profiles support
  mlxsw: spectrum_router: Expose RIF MAC profiles to devlink resource
  selftests: mlxsw: Add a scale test for RIF MAC profiles
  selftests: mlxsw: Add forwarding test for RIF MAC profiles
  selftests: Add an occupancy test for RIF MAC profiles
  selftests: mlxsw: Remove deprecated test cases

 drivers/net/ethernet/mellanox/mlxsw/reg.h     |   6 +
 .../net/ethernet/mellanox/mlxsw/resources.h   |   2 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  40 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   1 +
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 347 +++++++++++++++---
 .../ethernet/mellanox/mlxsw/spectrum_router.h |   3 +
 .../net/mlxsw/rif_mac_profile_scale.sh        |  72 ++++
 .../drivers/net/mlxsw/rif_mac_profiles.sh     | 213 +++++++++++
 .../drivers/net/mlxsw/rif_mac_profiles_occ.sh | 117 ++++++
 .../selftests/drivers/net/mlxsw/rtnetlink.sh  |  90 -----
 .../net/mlxsw/spectrum-2/resource_scale.sh    |   2 +-
 .../mlxsw/spectrum-2/rif_mac_profile_scale.sh |  16 +
 .../net/mlxsw/spectrum/resource_scale.sh      |   2 +-
 .../mlxsw/spectrum/rif_mac_profile_scale.sh   |  16 +
 14 files changed, 778 insertions(+), 149 deletions(-)
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/rif_mac_profile_scale.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/rif_mac_profiles.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/rif_mac_profiles_occ.sh
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/spectrum-2/rif_mac_profile_scale.sh
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/spectrum/rif_mac_profile_scale.sh

-- 
2.31.1

