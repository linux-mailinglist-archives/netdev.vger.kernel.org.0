Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88FE1FFFC6
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 08:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbfKRHug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 02:50:36 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:52559 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726316AbfKRHuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 02:50:35 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 047F622431;
        Mon, 18 Nov 2019 02:50:35 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 18 Nov 2019 02:50:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=nsFD8pzFaI8VF7GMm
        14Xr2Vsp+Ka/7XaGCrNyN1SDvA=; b=GbbxXITKxu9zM6CGSGAUPSxya06M2gaSO
        jKnoSLCGdghhGywX5u4H//cN6CSvq87YBKKmCEwLVQ+t38mD5KAXt5YvOd2aS1cL
        8espdyouHk6BWYTg8SWW1D8+vMbBskbVyxq2UD6GLrigQaXBHEzITF26Ri60OAYU
        kjMxZx8rXEBKVIZqgBteYkBF91O+oEEd/kRrPg6RncyTK5nINoB4An7VFfmQgAfP
        89ofRTrqBFNHN1ngbezV7e84ZoTL+LeTwCGH3jkPneHuSyF8YC1gTPT1E3Q7+xwe
        YXDtIf2c7mcnKTxaSwv6SPJE/KNPi/Ef9HcGAltYeAaEkPRJFKPpg==
X-ME-Sender: <xms:SU3SXcVcBMAWwxcFTM9R60p1G0XODpMmo3ImNtC-tMJtrCGa02QsXQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeggedguddugecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucffohhmrghinhepohiilhgrsghsrdhorhhgnecukfhppeduleefrd
    egjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehi
    ughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:SU3SXZ6YWjM31RTT-eQONNKH30E4S6FfpbKD6fSdC5WcLoPSdA2jMw>
    <xmx:SU3SXcyunvhtXAd6wT5dmnIKnEM9UXl1hhsDBa0zNA-e0d-dlBogUA>
    <xmx:SU3SXS7VcxSMZpd3XhTXlLBYQbEkrFCuyC6zXOYsVbyJQL-HYVCaMw>
    <xmx:Sk3SXXAqnAGKCXr5_7A_153gBCDXtaixggtbSy-nlYz-c--0j48Arw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id AE4D3306005E;
        Mon, 18 Nov 2019 02:50:32 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/5] selftests: Add ethtool and scale tests
Date:   Mon, 18 Nov 2019 09:49:57 +0200
Message-Id: <20191118075002.1699-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This patch set adds generic ethtool tests and a mlxsw-specific router
scale test for Spectrum-2.

Patches #1-#2 from Danielle add the router scale test for Spectrum-2. It
re-uses the same test as Spectrum-1, but it is invoked with a different
scale, according to what it is queried from devlink-resource.

Patches #3-#5 from Amit are a re-work of the ethtool tests that were
posted in the past [1]. Patches #3-#4 add the necessary library
routines, whereas patch #5 adds the test itself. The test checks both
good and bad flows with autoneg on and off. The test plan it detailed in
the commit message.

Last time Andrew and Florian (copied) provided very useful feedback that
is incorporated in this set. Namely:

* Parse the value of the different link modes from
  /usr/include/linux/ethtool.h
* Differentiate between supported and advertised speeds and use the
  latter in autoneg tests
* Make the test generic and move it to net/forwarding/ instead of being
  mlxsw-specific

[1] https://patchwork.ozlabs.org/cover/1112903/

Amit Cohen (3):
  selftests: forwarding: Add ethtool_lib.sh
  selftests: forwarding: lib.sh: Add wait for dev with timeout
  selftests: forwarding: Add speed and auto-negotiation test

Danielle Ratson (2):
  selftests: mlxsw: Add router scale test for Spectrum-2
  selftests: mlxsw: Check devlink device before running test

 .../net/mlxsw/spectrum-2/resource_scale.sh    |  10 +-
 .../net/mlxsw/spectrum-2/router_scale.sh      |  18 +
 .../selftests/net/forwarding/ethtool.sh       | 318 ++++++++++++++++++
 .../selftests/net/forwarding/ethtool_lib.sh   |  69 ++++
 tools/testing/selftests/net/forwarding/lib.sh |  29 +-
 5 files changed, 440 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/spectrum-2/router_scale.sh
 create mode 100755 tools/testing/selftests/net/forwarding/ethtool.sh
 create mode 100755 tools/testing/selftests/net/forwarding/ethtool_lib.sh

-- 
2.21.0

