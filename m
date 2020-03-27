Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76E30195366
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 09:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbgC0I4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 04:56:55 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:58479 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726027AbgC0I4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 04:56:54 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id C39C85C046C;
        Fri, 27 Mar 2020 04:56:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 27 Mar 2020 04:56:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=1QXAkC
        gKQzp5MWt/QbUBbtO4C3mfnwqq8yaRNp9064g=; b=vGuljl774FiT21I976ksbo
        xNhNSgK3rwpRqYu20M2XaXq1tsjzsi8eAd0N9l6nrlvn2UeYSQCXRUwUdzIdYk+H
        EhToOL6HCIU8VtSMnXMxRdqvQ11dxcEl8DXY7poPJ7Y1/5AtzsD1hZeUZagZmNdG
        +aeHCD7oA4oiG3irRP+BtlhfDaaHEuDo/OBVlr8ckvh4xuiTD/Aqp2c59LsxGPhj
        3FdAi2fu14uaJZUtZ+vY6u1+q8mi4zJGGaeJQNMF4dFqVpaA6abD7T7QqokCibYZ
        FpFPNT8hN0D0nHfI/roi4WGyyvrXMD4xa6moKN8loG0NRTzal7zBfI4rpCXeZmYw
        ==
X-ME-Sender: <xms:1b99Xrf-e2x_e0fWzFfGTdpnp7S_JVdHzNO0caz3BFhAbsqEbmwO_Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehkedgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofggtgfgsehtkeertd
    ertdejnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeelrddukedurddufedvrdduledunecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:1b99Xrd7k9T01K9uGEBps7GXu3MH46BkkiPA5jZoIyNyGZYbHWuJ-g>
    <xmx:1b99XmTlp69KTfyt1rA0_PLueSVUCeCeiKbP2CgPdLEcANN61vnv0Q>
    <xmx:1b99XhjJ6r0JaGTPOaz2VrjcV_lAPj5XFBSi5oOGYH1H5pFS4k0zfw>
    <xmx:1b99XjI1d-fp7ATrayFUIfhywKW_jhxGosah9jCnqUvRLGaXrgxsOQ>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id 06038306BD54;
        Fri, 27 Mar 2020 04:56:51 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, kuba@kernel.org,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/6] mlxsw: Various static checkers fixes
Date:   Fri, 27 Mar 2020 11:55:19 +0300
Message-Id: <20200327085525.1906170-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Jakub told me he gets some warnings with W=1, so I decided to check with
sparse, smatch and coccinelle as well. This patch set fixes all the
issues found. None are actual bugs / regressions and therefore not
targeted at net.

Patches #1-#2 add missing kernel-doc comments.

Patch #3 removes dead code.

Patch #4 reworks the ACL code to avoid defining a static variable in a
header file.

Patch #5 removes unnecessary conversion to bool that coccinelle warns
about.

Patch #6 avoids false-positive uninitialized symbol errors emitted by
smatch.

Ido Schimmel (6):
  mlxsw: i2c: Add missing field documentation
  mlxsw: spectrum_router: Add proper function documentation
  mlxsw: spectrum: Remove unused RIF and FID families
  mlxsw: core_acl: Avoid defining static variable in header file
  mlxsw: switchx2: Remove unnecessary conversion to bool
  mlxsw: spectrum_router: Avoid uninitialized symbol errors

 .../mellanox/mlxsw/core_acl_flex_keys.c       |  50 +++++-
 .../mellanox/mlxsw/core_acl_flex_keys.h       |  36 +---
 drivers/net/ethernet/mellanox/mlxsw/i2c.c     |   1 +
 .../ethernet/mellanox/mlxsw/spectrum_fid.c    | 152 +---------------
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 164 ++++++------------
 .../net/ethernet/mellanox/mlxsw/switchx2.c    |   2 +-
 6 files changed, 109 insertions(+), 296 deletions(-)

-- 
2.24.1

