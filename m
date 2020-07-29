Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB017231C0E
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 11:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbgG2J1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 05:27:20 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:55269 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726536AbgG2J1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 05:27:20 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 5A7345C017C;
        Wed, 29 Jul 2020 05:27:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 29 Jul 2020 05:27:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=GlKGxkHsDbJmHSKPa
        3IM9VY8bVOaztU5oZB0KHdKoBI=; b=WAYXRZ0NDVt8waA+wMKy0TGnZ3yIT7ovz
        Q9QuGXulLGMU2HqxZtqTt1b3Er34C10iSatXZriNfAtGelxZjwRYNgN84NV0I2T+
        jPtr9duTF07JTwd4H2XCBRQUPTWSOdtgIW2iSBXvovnYwtRQ6p8UTRFfE41mKfx+
        JkODAlD1hvwTGObeA458NusLam8DvwIH2cOZTyiSxbBz+Dm+WVEgj0fOwri4JzHN
        0hO25dg2Vew36WcHSXH2N5gwGVC9vLT7URPUR1J4sXSB+orqBTMn9o/QeS8PhOzX
        cfghx0po8IdElkX9HR/0nlf4tHpdHXBmqv3TFysPRkrwdYzZUIiwQ==
X-ME-Sender: <xms:90AhXzuSCp_I6HRC4ePiLi09C0Xmd-ikoavdaqrMLyMw1zeC_1Gw8A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrieeggdduiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuheehte
    ffieekgeehveefvdegledvffduhfenucfkphepuddtledrieehrddufeejrddvhedtnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:90AhX0dhO3fubrPAX14t1m5PJ0We5LLUbn5wwUn4g5i0NAUZa4bEuA>
    <xmx:90AhX2yNglS-96r1sTrkhvZeB41RqPovZNlfATi0kTsOuW4I1C7Oqg>
    <xmx:90AhXyOrGJNfJ55eiVQqA21PedMI2GgMmEZ0cglHOFDBN3Xw6NeENA>
    <xmx:90AhX2baU9d7lt5AAI8sGm39AFwvEZKZxVekJjPIMoAJvpfI5i4EWA>
Received: from shredder.mtl.com (bzq-109-65-137-250.red.bezeqint.net [109.65.137.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id D98E13280060;
        Wed, 29 Jul 2020 05:27:16 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        amitc@mellanox.com, alexve@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 0/6] mlxsw fixes
Date:   Wed, 29 Jul 2020 12:26:42 +0300
Message-Id: <20200729092648.2055488-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This patch set contains various fixes for mlxsw.

Patches #1-#2 fix two trap related issues introduced in previous cycle.

Patches #3-#5 fix rare use-after-frees discovered by syzkaller. After
over a week of fuzzing with the fixes, the bugs did not reproduce.

Patch #6 from Amit fixes an issue in the ethtool selftest that was
recently discovered after running the test on a new platform that
supports only 1Gbps and 10Gbps speeds.

Amit Cohen (1):
  selftests: ethtool: Fix test when only two speeds are supported

Ido Schimmel (5):
  mlxsw: spectrum_router: Allow programming link-local host routes
  mlxsw: spectrum: Use different trap group for externally routed
    packets
  mlxsw: core: Increase scope of RCU read-side critical section
  mlxsw: core: Free EMAD transactions using kfree_rcu()
  mlxsw: spectrum_router: Fix use-after-free in router init / de-init

 .../networking/devlink/devlink-trap.rst       |  4 ++
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  8 ++-
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  1 +
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 59 ++++++++-----------
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 14 ++++-
 include/net/devlink.h                         |  3 +
 net/core/devlink.c                            |  1 +
 .../selftests/net/forwarding/ethtool.sh       |  2 -
 8 files changed, 51 insertions(+), 41 deletions(-)

-- 
2.26.2

