Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5D2B3F3F10
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 13:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233487AbhHVLjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 07:39:10 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:55589 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233189AbhHVLjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 07:39:09 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 78E405C008B;
        Sun, 22 Aug 2021 07:38:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 22 Aug 2021 07:38:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=nJm6ngqsA8YMrat9w
        ArOnDz2+JauEApu8vtWR6i1bSc=; b=mlv2BIvv7Kz3jsVl7vpoTjwLkBjVeE0Yw
        qY5NO6XWZQllkbadstjAL8frZ4a2aIvo8GKkkkfNZ8GLlBk1GVE1xdjgz36j/Loc
        BXqJbp+kvc4onM1WirBH+IrYXZaMl0xbqB8WiYX6EriJ0QA2IRCQRFhnDzX8+6LU
        0bZIWktai+rxCVe3Trf0d3A2dPwyE/bWI+E3z8OPxWiTCsjvXP9wXXi25nHaz/mI
        8ZSyZtABsHoPiRnLLo3xyBt9uTZ1cIKfAdyXQnPJ650/cndqB6E0wQ8tXc+BzI85
        70wRuehy0EUpC/pvZBUF9tHoqNWQIvi7qanj7KzmeEvE84djInQOg==
X-ME-Sender: <xms:MjciYdmuYgNcHbybQhrc7rIpKRcpE6m-e0-uRmz6Hx3tVt6JJnzVvg>
    <xme:MjciYY2EHcCxtoIY5VKvuDb0gLccmn6v8ChL_FyNhf-4bUN4VvF44gbC43PWOuyOK
    mDuh4NOZ5cHICc>
X-ME-Received: <xmr:MjciYTp2BME5IDvA31ekJZ971C7OXlhVby5AWI3fZfVr0GTG7c3uDzXF9IMHaTQfOyogxZorxO_DErRtOZuNvqwruCNjn0sWgqdVd2q6iMA3xA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtfedggeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghr
    rghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:MjciYdneeb-qSnvvZkNFf2asJITX7LoSWQoUvKwzozB9BpSHPQ8BOw>
    <xmx:MjciYb2cat-fV0Y2Xvq1tLZ_aTvUm5z6P69voVcBePVflDaUl4ewVw>
    <xmx:MjciYcsmWc5gD-_bZrxOA2lTdJesTMCKq-1cjAew5QxmTDmy0BHHnQ>
    <xmx:MzciYWQwnPb2oCtRDZ5SQJQnZNgBcqHDkUQadOXYdCgU5K7ZEc75jg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 22 Aug 2021 07:38:24 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/4] mlxsw: Refactor parsing configuration
Date:   Sun, 22 Aug 2021 14:37:12 +0300
Message-Id: <20210822113716.1440716-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The Spectrum ASIC has a configurable limit on how deep into the packet
it parses. By default, the limit is 96 bytes.

There are several cases where this parsing depth is not enough and there
is a need to increase it: Decapsulation of VxLAN packets and
timestamping of PTP packets.

Currently, parsing depth API is maintained as part of VxLAN module,
because the MPRS register which configures parsing depth also configures
UDP destination port number used for VxLAN encapsulation and
decapsulation.

However, in addition to two above mentioned users of this API, the
multipath hash code also needs to invoke it in order to correctly hash
based on inner fields of IPv6-in-IPv6 packets.

Upcoming support for IPv6-in-IPv6 tunneling will add another user, as
without increasing the parsing depth such packets cannot be properly
decapsulated.

Therefore, this patchset refactors the parsing configuration API and
moves it out of the VxLAN module to the main driver code.

Tested using existing selftests.

Patch set overview:

Patch #1 adds the new parsing configuration infrastructure.
Patch #2 converts existing users to the new infrastructure.
Patch #3 deletes the old infrastructure.
Patch #4 calls the new infrastructure from the multipath hash code.

Amit Cohen (4):
  mlxsw: spectrum: Add infrastructure for parsing configuration
  mlxsw: Convert existing consumers to use new API for parsing
    configuration
  mlxsw: Remove old parsing depth infrastructure
  mlxsw: spectrum_router: Increase parsing depth for multipath hash

 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 82 ++++++++++++++++
 .../net/ethernet/mellanox/mlxsw/spectrum.h    | 12 +++
 .../ethernet/mellanox/mlxsw/spectrum_nve.h    |  1 -
 .../mellanox/mlxsw/spectrum_nve_vxlan.c       | 94 ++++---------------
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    |  4 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 44 ++++++++-
 .../ethernet/mellanox/mlxsw/spectrum_router.h |  1 +
 7 files changed, 160 insertions(+), 78 deletions(-)

-- 
2.31.1

