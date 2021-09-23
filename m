Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFC3415E77
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 14:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240959AbhIWMji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 08:39:38 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56851 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232201AbhIWMjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 08:39:35 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id DA2EF5C00EB;
        Thu, 23 Sep 2021 08:38:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 23 Sep 2021 08:38:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=pAQKnumKSgsDNMZsu
        j1flwnfYn62yWROAi+rXlc2p7U=; b=FIB7320lKqr1Zsx1sIY6FiZ3XxqQ1hErx
        ZCesAaBlna5DCezHhIRzSVcU7wr4g7lLmgdQPbMcN9tFpl8lr69BEBjjXAFeyDSh
        qihQwN10M3XgY6STXIg5gqRTSIEZ8nksubuZm/3BLRncIInUEvAkprZXbDPSw5nB
        6HU3K5IN0hcqFFc9qftNxjn8gGkAnHGZWycr9IHFh6fcHXOS5k7KXRVM/6BxoboT
        hB2r+nplRWvSkSv/Odea0XGoXCMtUcJviDXb21hTuez8X/W/bvO8v6dqSxNov0X0
        dqAEnrG7hNNozjOqX4sFDIQeY2mVbGJqzWqVzShyJWd2C4hjuEo4w==
X-ME-Sender: <xms:K3VMYe773g6j53jVk45PdJbaExACT-v4HWpPX1VgVvJjozV9OK1uTg>
    <xme:K3VMYX40p5Y9UiWxd40oOgPKIp-siEZ-2cGCzqSzvZQoAypLvo3BhSCGkfVYRHbgF
    8rlefUhklAuPsw>
X-ME-Received: <xmr:K3VMYdfl4v0-0NxMAV6azrBdsJ9ZFqBXq0Ml1AAW0xrsAXK96HlJaVXOMViFTBw0Zc8NTwdwUpWZilU-dPWAvepmUXC5e1tcUDImxV8acWjMFQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudeiledgheefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghr
    rghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:K3VMYbJyMo3BJriAZ8tElzwRUB2aGxJaMgIvtt-4psaeHIjMjlqxlQ>
    <xmx:K3VMYSKG4sWT1-rhR1j1MpJll28cnJaBYqnJI3t8TpIblsTkYmNstg>
    <xmx:K3VMYcxENGoZr-75VmnrpL-qfOF4s6WEj6sNkJgNW1OmsYIQdYdhWw>
    <xmx:K3VMYUgFYASYiLyPSOWIOELFti7v5zfwig6gdPO4drhlBcsK4KKSsA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Sep 2021 08:38:01 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        petrm@nvidia.com, jiri@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 00/14] mlxsw: Add support for IP-in-IP with IPv6 underlay
Date:   Thu, 23 Sep 2021 15:36:46 +0300
Message-Id: <20210923123700.885466-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Currently, mlxsw only supports IP-in-IP with IPv4 underlay. Traffic
routed through 'gre' netdevs is encapsulated with IPv4 and GRE headers.
Similarly, incoming IPv4 GRE packets are decapsulated and routed in the
overlay VRF (which can be the same as the underlay VRF).

This patchset adds support for IPv6 underlay using the 'ip6gre' netdev.
Due to architectural differences between Spectrum-1 and later ASICs,
this functionality is only supported on Spectrum-2 onwards (the software
data path is used for Spectrum-1).

Patchset overview:

Patches #1-#5 are preparations.

Patches #6-#9 add and extend required device registers.

Patches #10-#14 gradually add IPv6 underlay support.

A follow-up patchset will add net/forwarding/ selftests.

Amit Cohen (14):
  mlxsw: spectrum_router: Create common function for
    fib_entry_type_unset() code
  mlxsw: spectrum_ipip: Pass IP tunnel parameters by reference and as
    'const'
  mlxsw: spectrum_router: Fix arguments alignment
  mlxsw: spectrum_ipip: Create common function for
    mlxsw_sp_ipip_ol_netdev_change_gre()
  mlxsw: Take tunnel's type into account when searching underlay device
  mlxsw: reg: Add Router IP version Six Register
  mlxsw: reg: Add support for rtdp_ipip6_pack()
  mlxsw: reg: Add support for ratr_ipip6_entry_pack()
  mlxsw: reg: Add support for ritr_loopback_ipip6_pack()
  mlxsw: Create separate ipip_ops_arr for different ASICs
  mlxsw: spectrum_ipip: Add mlxsw_sp_ipip_gre6_ops
  mlxsw: Add IPV6_ADDRESS kvdl entry type
  mlxsw: spectrum_router: Increase parsing depth for IPv6 decapsulation
  mlxsw: Add support for IP-in-IP with IPv6 underlay for Spectrum-2 and
    above

 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  86 +++-
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   2 +
 .../ethernet/mellanox/mlxsw/spectrum2_kvdl.c  |   1 +
 .../ethernet/mellanox/mlxsw/spectrum_ipip.c   | 432 ++++++++++++++++--
 .../ethernet/mellanox/mlxsw/spectrum_ipip.h   |  27 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 186 ++++++--
 .../ethernet/mellanox/mlxsw/spectrum_router.h |   2 +
 7 files changed, 641 insertions(+), 95 deletions(-)

-- 
2.31.1

