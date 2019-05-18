Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD2A022400
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 17:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729366AbfERP7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 11:59:17 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46313 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727380AbfERP7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 11:59:16 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 82AEF292AC;
        Sat, 18 May 2019 11:59:13 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 18 May 2019 11:59:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=8/aba0WZWsSOBkgC1
        59wW8EbpviZQFREeGsZYcR7i8o=; b=iRJ1FcYDGZMzHADb+vqwlXXVAw5lT5Jmh
        N80JJanMfggBXJuMC50zJ2QnzjX3PUYSNtXFEB/8yfsLOAzdf05uhbw3sO5I++xn
        b5uZEjIJVm3V7htGWrzxJCQOa8ZPCNCNvMyR+qCiQGSrN/0DmRNq0C92qLR3cSu4
        yfVSGi2vJ27BSQrRC7aQIpxLHLlt3Iz8698wwu+qQonVGPDs61ZSRUsh9M4mC4HJ
        B9e5Sit7Bp1+nv4AM1zWc3WnreZzEXLPsawg3xrBmij6y1+aUJp7N5ZmjVWrS7iK
        ciasB5uz0Cqj2blvmATn+Axxux2A5aiLoJF7S0nSmG7Ng4Pd/MpVQ==
X-ME-Sender: <xms:0SvgXE07ZEj-e1tuXj7medrRRFnLgHkdJjviuB9KwpcgziownhFJGg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtgedgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppedutdelrdeihedrfeefrddufedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihii
    vgeptd
X-ME-Proxy: <xmx:0SvgXGr1It4iBiPTgHAUjDydRmc2PNYDM1iS_QyyAgbD9GhfU1-7lA>
    <xmx:0SvgXJ0SII6TqJ0ETYlJsPr08SCRTknQ19Kx5bwwHEu4JLTcqZIc2Q>
    <xmx:0SvgXLzRaT6RsJxDYmXTTbkgJGKT4D408G9oDWuNJbEhe9wO6ZuZew>
    <xmx:0SvgXH3qf9seN0xJfhhbQZl-uyt4x5JKQCRRLpMqLEbJiN2ukGVYwA>
Received: from splinter.mtl.com (bzq-109-65-33-130.red.bezeqint.net [109.65.33.130])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6A0C98005C;
        Sat, 18 May 2019 11:59:11 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, vadimp@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 0/2] mlxsw: Two port module fixes
Date:   Sat, 18 May 2019 18:58:27 +0300
Message-Id: <20190518155829.31055-1-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Patch #1 fixes driver initialization failure on old ASICs due to
unsupported register access. This is fixed by first testing if the
register is supported.

Patch #2 fixes reading of certain modules' EEPROM. The problem and
solution are explained in detail in the commit message.

Please consider both patches for stable.

Vadim Pasternak (2):
  mlxsw: core: Prevent QSFP module initialization for old hardware
  mlxsw: core: Prevent reading unsupported slave address from SFP EEPROM

 drivers/net/ethernet/mellanox/mlxsw/core.c     |  6 ++++++
 drivers/net/ethernet/mellanox/mlxsw/core.h     |  2 ++
 drivers/net/ethernet/mellanox/mlxsw/core_env.c | 18 ++++++++++++++++--
 .../net/ethernet/mellanox/mlxsw/core_hwmon.c   |  3 +++
 .../net/ethernet/mellanox/mlxsw/core_thermal.c |  6 ++++++
 5 files changed, 33 insertions(+), 2 deletions(-)

-- 
2.20.1

