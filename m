Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E9F24EC1C
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 10:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbgHWIHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 04:07:46 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:46693 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725876AbgHWIHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 04:07:45 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 0D176AF7;
        Sun, 23 Aug 2020 04:07:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 23 Aug 2020 04:07:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=vm5ryNCwzvJfSovg/
        GHSK0SzIdp7e5uoXN8FSGsK/SM=; b=dIeAQNuakWQFKPi1T9PzVWWOvIPPe+HDc
        h0LWq1simqDSH5SoaG3TByAJ+2t2VQ6C3Ou57kFjGwB+cl8lRDothnkNtWH/wn6g
        FU+Rawk7Q05D3d1go59DgwA70NegTJheC+r40rIBDluWWj8FFFgCafixu57nUW5Q
        IsaTP8YTkVqzjaytPmGFP1boIb93oiarc7hCWuuhsahOl+7uwZo1UyHHI83Nfk9M
        pbalLNrxr3whuZFoISMcCROlimeSs0DQvbmubkbQYg8D6d7+8CZ7ZGPX9GXAQc1o
        jDvAJBnLF6Va/K4/KUkABbEiReGuwJPMVMii4LWl15IQcoeq068zw==
X-ME-Sender: <xms:zyNCX8VpNIkORfNsKqijh8tsdkDzb3cTwdwHKz6JkCJg0QpxF4hg0w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudduiecutefuodetggdotefrodftvfcurf
    hrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertddtne
    cuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdho
    rhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuheehteffie
    ekgeehveefvdegledvffduhfenucfkphepjeelrddujeekrddufedurdefheenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesih
    guohhstghhrdhorhhg
X-ME-Proxy: <xmx:zyNCXwkj6iHm9sT5GUBH7spMrOITkUpjAa23rPLm66FsNbFRMPminA>
    <xmx:zyNCXwZZ193zhnNfe_JsSzzJMoqqHRJnhTbkGPsRYIKGYxboiawvhQ>
    <xmx:zyNCX7W3F3lcjrFkgkOQ94132Ieb_IAHjO0bKxgfh9gDgRgeYjODIw>
    <xmx:zyNCX6skqGqKbtXq_dSyVlD8FSFrWkrBawLk2jufHK6bEEx507s3pQ>
Received: from shredder.mtl.com (bzq-79-178-131-35.red.bezeqint.net [79.178.131.35])
        by mail.messagingengine.com (Postfix) with ESMTPA id B63243280059;
        Sun, 23 Aug 2020 04:07:41 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/7] mlxsw: Misc updates
Date:   Sun, 23 Aug 2020 11:06:21 +0300
Message-Id: <20200823080628.407637-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This patch set includes various updates for mlxsw.

Patches #1-#4 adjust the default burst size of packet trap policers to
conform to Spectrum-{2,3} requirements. The corresponding selftest is
also adjusted so that it could reliably pass on these platforms.

Patch #5 adjusts a selftest so that it could pass with both old and new
versions of mausezahn.

Patch #6 significantly reduces the runtime of tc-police scale test by
changing the preference and masks of the used tc filters.

Patch #7 prevents the driver from trying to set invalid ethtool link
modes.

Danielle Ratson (2):
  selftests: forwarding: Fix mausezahn delay parameter in mirror_test()
  mlxsw: spectrum_ethtool: Remove internal speeds from PTYS register

Ido Schimmel (5):
  mlxsw: spectrum_trap: Adjust default policer burst size for
    Spectrum-{2, 3}
  selftests: mlxsw: Decrease required rate accuracy
  selftests: mlxsw: Increase burst size for rate test
  selftests: mlxsw: Increase burst size for burst test
  selftests: mlxsw: Reduce runtime of tc-police scale test

 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  6 ---
 .../mellanox/mlxsw/spectrum_ethtool.c         | 38 -------------------
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 22 +++++------
 .../net/ethernet/mellanox/mlxsw/switchx2.c    | 25 +-----------
 .../drivers/net/mlxsw/devlink_trap_policer.sh | 33 +++-------------
 .../drivers/net/mlxsw/tc_police_scale.sh      | 12 +++++-
 .../selftests/net/forwarding/mirror_lib.sh    |  2 +-
 7 files changed, 28 insertions(+), 110 deletions(-)

-- 
2.26.2

