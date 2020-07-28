Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B91E230788
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 12:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728708AbgG1KUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 06:20:48 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:33727 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728305AbgG1KUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 06:20:47 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 839375C018A;
        Tue, 28 Jul 2020 06:20:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 28 Jul 2020 06:20:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=5o1V8k13Vd/pPnhq6
        Mb7hKBr04IwiygevUaV6dz1emE=; b=gybBOB839vdcifMDvjKCqgKnORAVVATtA
        ll6QHiFDLfnbW54f3/a7mRd7GWES0m6ytaIod9x+GwabCaaeFa87OFJiHeosBc7h
        D5lOU6k4W3fyLe5wf79DVRUn6O6z2VcYqVv13uJ67V5RGvGG4JPcjx9XFpMNIx81
        v/YGoh/OJhiWWmzekBo2z1GxmFuPe/sbWAVW2NTvDIh4/yak51y+lcwZo0Nqg9oJ
        hf4WTiybBWhBwKYwRlWCyO21rp0KRQvn7DZIUIiDPzJgHqGbYbla7O/lf1Q1m/Zb
        hl0COfDmjuuqTuHEfTb0FYwNMu/Sq1neUVgfFJIiu+/zsrMN2avJQ==
X-ME-Sender: <xms:_fsfXwEgjz-TjWH6KW1eTy0UqvXwmirsb88UaXxjbbludut6CgO_xQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedriedvgddvhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeelueffueekjeetuefgvdfgtdehfefgjedute
    fhtdevueejvdekgfduvdduhfejfeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecu
    kfhppeejledrudekuddrvddrudejleenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:_fsfX5Wik016vx-hL5j1_FtOZNyPm3HYxSkMtiY-OlZJHYsNP6EmJQ>
    <xmx:_fsfX6JvqrrCyiN75kVoVnfJ0FYkZjODbDHa6Yyel-3CRpZWKV1Hog>
    <xmx:_fsfXyGAGEXSQ3BwJF5PMYmiI3DC2QrMlg8Dfo7Mv4M-1JD0PBeamg>
    <xmx:_vsfX0xtxeh270gcHDUWBiHoCL9fjnD6gw0h0MW4j9puglQ8f_CsJQ>
Received: from shredder.mtl.com (bzq-79-181-2-179.red.bezeqint.net [79.181.2.179])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5B07A306005F;
        Tue, 28 Jul 2020 06:20:43 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        vadimp@mellanox.com, andrew@lunn.ch, popadrian1996@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 0/2] mlxsw: Add support for QSFP-DD transceiver type
Date:   Tue, 28 Jul 2020 13:20:14 +0300
Message-Id: <20200728102016.1960193-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This patch set from Vadim adds support for Quad Small Form Factor
Pluggable Double Density (QSFP-DD) modules in mlxsw.

Patch #1 enables dumping of QSFP-DD module information through ethtool.

Patch #2 enables reading of temperature thresholds from QSFP-DD modules
for hwmon and thermal zone purposes.

Changes since v1 [1]:

Only rebase on top of net-next. After discussing with Andrew and Adrian
we agreed that current approach is OK and that in the future we can
follow Andrew's suggestion to "make a new API where user space can
request any pages it want, and specify the size of the page". This
should allow us "to work around known issues when manufactures get their
EEPROM wrong".

[1] https://lore.kernel.org/netdev/20200626144724.224372-1-idosch@idosch.org/#t

Vadim Pasternak (2):
  mlxsw: core: Add ethtool support for QSFP-DD transceivers
  mlxsw: core: Add support for temperature thresholds reading for
    QSFP-DD transceivers

 .../net/ethernet/mellanox/mlxsw/core_env.c    | 53 ++++++++++++++-----
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  3 ++
 2 files changed, 44 insertions(+), 12 deletions(-)

-- 
2.26.2

