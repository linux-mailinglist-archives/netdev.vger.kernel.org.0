Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D581128A20A
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 00:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388423AbgJJWxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:53:55 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:41071 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730423AbgJJSzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 14:55:51 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 5F2AF5C0097;
        Sat, 10 Oct 2020 11:41:50 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 10 Oct 2020 11:41:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=UeqnZmTdMjHOUmEPi
        DF5UDllHFWj7HshBvxS/dKhjlw=; b=PKFcCTarZXTfLeXH60OsWpSYXOejp6JcU
        LEbeaQKtbKwikGnNSWX9eVMRwdWrWHePJrN7OPJnoHuo7HkWAqaYLaK3w0L1POZ8
        yTzcIqkXfvvJKtpNguMTDLYESRHdruXl2gt/8ocb3C27wk9+KLmP/TS3vpehrtT7
        a4WLIJwZl0UaqM4M+pQzLi+zzlptM9lWYxJDF/NRlaDFIa5D0KzeW5FLVPKR95e5
        UDB0rp1vV0izmfDstdnE9eD6lnIcSOKknvA1s1Wxghnj4Idz++RJ1uPTF8c3+Bf2
        sO6LQH0RQYS9Sm3Cd0JqJ8x2vM5GUtqYEWlgH1W23PpqDXRKYcSJA==
X-ME-Sender: <xms:PdaBX09ntviAb0hE-rSW7_-1NspMCp_V0MjXJMENx38SEr6VhyHyPQ>
    <xme:PdaBX8sSRc0kf4cIm1EEIClhRbArErbhlN1l1Xe0ou0vA5m9B4K13U_7O9kZeX4qj
    3qa8prs0CKYn2g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrheefgdelvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuheehte
    ffieekgeehveefvdegledvffduhfenucfkphepkeegrddvvdelrdefjedrudegkeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthh
    esihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:PdaBX6C6z8lWkJUX5mE1fv3ZOShX8cMHfuJcyVwZxqDDksjGO9JJEQ>
    <xmx:PdaBX0eigZ8cI6IA8BNI_HI-HXsvJgFA0hhJMJgKQlLN25d4t6AOaA>
    <xmx:PdaBX5OmtclHVHRX40p082ohtpBMkJwg6RIShdZ3xYeP7wNUMuCgPQ>
    <xmx:PtaBX1A-WK6C8AfbeN6zEGBus14BRveW7gn3-OEsjKRh-2McCv6MPw>
Received: from shredder.mtl.com (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5DC67328005D;
        Sat, 10 Oct 2020 11:41:47 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        danieller@nvidia.com, andrew@lunn.ch, f.fainelli@gmail.com,
        mkubecek@suse.cz, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/6] Support setting lanes via ethtool
Date:   Sat, 10 Oct 2020 18:41:13 +0300
Message-Id: <20201010154119.3537085-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Danielle says:

Some speeds can be achieved with different number of lanes. For example,
100Gbps can be achieved using two lanes of 50Gbps or four lanes of
25Gbps. This patch set adds a new selector that allows ethtool to
advertise link modes according to their number of lanes and also force a
specific number of lanes when autonegotiation is off.

Advertising all link modes with a speed of 100Gbps that use two lanes:

# ethtool -s swp1 speed 100000 lanes 2 autoneg on

Forcing a speed of 100Gbps using four lanes:

# ethtool -s swp1 speed 100000 lanes 4 autoneg off

Patch set overview:

Patch #1 allows user space to configure the desired number of lanes.

Patch #2 adjusts ethtool to dump to user space the number of lanes
currently in use.

Patches #3-#5 add support for lanes configuration in mlxsw.

Patch #6 adds a selftest.

Danielle Ratson (6):
  ethtool: Extend link modes settings uAPI with lanes
  ethtool: Expose the number of lanes in use
  mlxsw: ethtool: Remove max lanes filtering
  mlxsw: ethtool: Add support for setting lanes when autoneg is off
  mlxsw: ethtool: Expose the number of lanes in use
  net: selftests: Add lanes setting test

 Documentation/networking/ethtool-netlink.rst  |  16 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  13 +-
 .../mellanox/mlxsw/spectrum_ethtool.c         | 156 ++++++++----
 include/linux/ethtool.h                       |   4 +
 include/uapi/linux/ethtool.h                  |   8 +
 include/uapi/linux/ethtool_netlink.h          |   1 +
 net/ethtool/linkmodes.c                       | 232 +++++++++++-------
 net/ethtool/netlink.h                         |   2 +-
 .../selftests/net/forwarding/ethtool_lanes.sh | 224 +++++++++++++++++
 .../selftests/net/forwarding/ethtool_lib.sh   |  34 +++
 tools/testing/selftests/net/forwarding/lib.sh |  28 +++
 11 files changed, 571 insertions(+), 147 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/ethtool_lanes.sh

-- 
2.26.2

