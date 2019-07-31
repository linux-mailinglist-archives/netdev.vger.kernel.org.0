Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB41F7B9B7
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 08:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387409AbfGaGeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 02:34:11 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:34191 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726196AbfGaGeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 02:34:10 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A57C622385;
        Wed, 31 Jul 2019 02:34:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 31 Jul 2019 02:34:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=eaFRx2EdQevBw89j0
        49YFHfUiWx+02jKuSFp2Dl8UZo=; b=AxWouxAXgHGwymKDnrBIm5s4qMfMt3nh/
        aH5huMWS1wdn9YF2RoYhe3iHWFefQjYnppfbt8Gd5gOoGlFkSFt310c87ArfalME
        GgS2IfjAQw3qa0hZDKaau0Hm7iFaji25vrvIdkdGavt+nMdUtM6uTZo4DuJBRrgU
        jHsMOWD83Iu4Z5giRkl9WI1tg29i8Y4KpRIQTMiXQidTdNH4llH/S1XzALOq4JVB
        Ndzi1XN5k3J7z0K8yu152CtevXVOw7jfCn11TvoEWMypo3A1I9m0m0YIpbs/y7Qm
        Q1QWNtgZawtltBzD2jkeyvy9Rfo3xJdZ7U6Lh8EPqbK8e8H9+d2DQ==
X-ME-Sender: <xms:YTZBXWaR6DcmEuC4vSsoq4kjWYsKyaz611-S0p-zQtypo5HzsTgrNQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrleeggddutdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:YTZBXR3ncodVY3pnLn0z5G60UZjvkjPFpMEAbRQVpVNnW5et7ExQNQ>
    <xmx:YTZBXRblOQBxLbX1i44KkKMYzHnszE6Whp7vVEKETMR4GB5Uxuhzzw>
    <xmx:YTZBXZIdNsfeI6HBT4UQDBJMLLXAWLTawz8x1cPKtnMNc_ZRbLJqKA>
    <xmx:YTZBXZPX92Y7dXdUbweudBRUSDfls3VV2RNVKy5jDBCOFvcGj52Ayw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 87546380076;
        Wed, 31 Jul 2019 02:34:07 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 0/2] mlxsw: Two small fixes
Date:   Wed, 31 Jul 2019 09:33:13 +0300
Message-Id: <20190731063315.9381-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Patch #1 from Jiri fixes the error path of the module initialization
function. Found during manual code inspection.

Patch #2 from Petr further reduces the default shared buffer pool sizes
in order to work around a problem that was originally described in
commit e891ce1dd2a5 ("mlxsw: spectrum_buffers: Reduce pool size on
Spectrum-2").

Jiri Pirko (1):
  mlxsw: spectrum: Fix error path in mlxsw_sp_module_init()

Petr Machata (1):
  mlxsw: spectrum_buffers: Further reduce pool size on Spectrum-2

 drivers/net/ethernet/mellanox/mlxsw/spectrum.c         | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

-- 
2.21.0

