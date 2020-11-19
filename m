Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB942B932D
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 14:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbgKSNJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 08:09:24 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:56343 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726958AbgKSNJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 08:09:23 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id B0D5DED4;
        Thu, 19 Nov 2020 08:09:22 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 19 Nov 2020 08:09:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=G8he3nUWdLN/4cqGw
        egCVclknA74Z5cKG8gW7L7yU2o=; b=V2T7/SsvljC8cSwTlH0eAlrkLOH4UzQpA
        xPETYS92OZnj174Hwg91UP12nk4oS82I0CIeacaYr1BSwmsaVuYRfHdPG+LmSd7N
        YPHsQpzsZleuYKDyKe0bSKipukEoTkVkDPGyJQICxmDcvOkx/9Pa6e5ws2QkuyBT
        Csb4PKZsCgaSoPVFFdcrmbocDELuay1MgCQcBvwAbvV0dZXHoywUX/53RpPqZ0VW
        CkPsyvR9Z65Us51Ow0auxBKFrXdQe0HFjrTY1JdyZYQDlthl4e9B92D0MvI9YWNn
        YIAkHfI4ZABXXQxWT3Ixmceu108v2lRgfeTyeJkIqgJosPl7DsHTg==
X-ME-Sender: <xms:gm62X4hAQpCLJvxtx_7DEy7NgD2XD-8_gOJ-nRlAXwiXERi8vDnw0w>
    <xme:gm62XxDGhadHw6FLZj-SyR41dB3Ouym-c9vEMz__JEeK87Uuy61oWoBA_VP-lzQ7V
    OnVBTLBA8oCxJE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudefjedggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeekgedrvddvledrudehgedrudegjeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:gm62XwENCPIpwR6_4ecLBqdBXff7_nRpQoAr-y5d6nLRvU0y-YFtfA>
    <xmx:gm62X5Tb62jwP6p3vX4iBigwxsu1xK9u3jqt7fQH1SYFA_QzSV3Nng>
    <xmx:gm62X1w6Z5Tue8Cy4mK1hDcJ9GLn6eyBNPlAVxCOJMmaverh3DRAXA>
    <xmx:gm62X990bItbTZXEKPggxqSxvDd_IoNXZo_-dGaSM1Co7PbEMcu2FA>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 393953280063;
        Thu, 19 Nov 2020 08:09:20 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/8] mlxsw: Add support for nexthop objects
Date:   Thu, 19 Nov 2020 15:08:40 +0200
Message-Id: <20201119130848.407918-1-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This patch set adds support for nexthop objects in mlxsw. Nexthop
objects are treated as another front-end for programming nexthops, in
addition to the existing IPv4 and IPv6 front-ends.

Patch #1 registers a listener to the nexthop notification chain and
parses the nexthop information into the existing mlxsw data structures
that are already used by the IPv4 and IPv6 front-ends. Blackhole
nexthops are currently rejected. Support will be added in a follow-up
patch set.

Patch #2 extends mlxsw to resolve its internal nexthop objects from the
nexthop identifier encoded in the FIB info of the notified routes.

Patch #3 finally removes the limitation of rejecting routes that use
nexthop objects.

Patch #4 adds a selftest.

Patches #5-#8 add generic forwarding selftests that can be used with
veth pairs or physical loopbacks.

Ido Schimmel (8):
  mlxsw: spectrum_router: Add support for nexthop objects
  mlxsw: spectrum_router: Enable resolution of nexthop groups from
    nexthop objects
  mlxsw: spectrum_router: Allow programming routes with nexthop objects
  selftests: mlxsw: Add nexthop objects configuration tests
  selftests: forwarding: Do not configure nexthop objects twice
  selftests: forwarding: Test IPv4 routes with IPv6 link-local nexthops
  selftests: forwarding: Add device-only nexthop test
  selftests: forwarding: Add multipath tunneling nexthop test

 .../ethernet/mellanox/mlxsw/spectrum_router.c | 498 +++++++++++++++++-
 .../ethernet/mellanox/mlxsw/spectrum_router.h |   1 +
 .../selftests/drivers/net/mlxsw/rtnetlink.sh  | 189 +++++++
 .../net/forwarding/gre_multipath_nh.sh        | 356 +++++++++++++
 .../net/forwarding/router_mpath_nh.sh         |  12 +-
 .../selftests/net/forwarding/router_nh.sh     | 160 ++++++
 6 files changed, 1201 insertions(+), 15 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/gre_multipath_nh.sh
 create mode 100755 tools/testing/selftests/net/forwarding/router_nh.sh

-- 
2.28.0

