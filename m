Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5038297C9A
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 15:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1761749AbgJXNiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Oct 2020 09:38:05 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:49705 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1761745AbgJXNiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Oct 2020 09:38:04 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id D3E4ECA0;
        Sat, 24 Oct 2020 09:38:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 24 Oct 2020 09:38:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=9VhfKkf4TZt/Dhse8
        rYzKhvWCI/sTY6VEBzM7zb0JRU=; b=lNb/AY1tpcHowLOCE8AZuzaJhu2dZReuC
        ePc0gp+8qzIbRXyggxOnsW/tCUisC1zxd3VpO70TF2aWiYq1uONyb5hGYrl1e6fP
        /7i+z/PwvzvJZfffbx6rY0vtMYz1ix3MEq458Ed3WWbnFJfM9P4KVq2iBNYQ3+e0
        nS2jxcASIygx1fw1QlFiqoLig9u1cnSSLh7fEBGZ3s/6Pr+GNcTI47N7DfB+nkir
        rj0ysuPZuNPYaIRdEZKeePe/JTJoDe00Y0oMga1pS58WexTyT5QSw+/0U5ybJInW
        idYQALqFC67kHvAGg31PqZdVjhBYe+aFxLLuEho7ixMBictJpUH5A==
X-ME-Sender: <xms:Oi6UXwC_ubnVBHOzTaQ3guNH5OBWdefE1XUHV8L_N9xs8yYjaUxsYg>
    <xme:Oi6UXyhvplFqfBS1gyDJbe3Fw2gFstp00zIJT9WpZYZEiZ3zzQrUvfLTHaX2RrIfQ
    24MFSfPU-Jx-jo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrkedvgdeijecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuheehte
    ffieekgeehveefvdegledvffduhfenucfkphepkeegrddvvdelrdefjedrvddvkeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthh
    esihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Oi6UXzmc-2vj38KStp2Ga8X9nTf9GOPHdO-EUS5Xapr4BASrNcUx7Q>
    <xmx:Oi6UX2wm7L-8fYwOAss5MKt3I7O3SBc_xZDjR3sFycSe0GhIOqj7tg>
    <xmx:Oi6UX1Qo5TFRSsaDR0K4kdes_FeWvrWWTPUCn-iuCjOfbWK3Xdav6w>
    <xmx:Oy6UX3dSUOJ-KLFTrTSlXQ7fO5WWfKkS0pDu7SH5dw5GrPUIjgcHYA>
Received: from shredder.mtl.com (igld-84-229-37-228.inter.net.il [84.229.37.228])
        by mail.messagingengine.com (Postfix) with ESMTPA id 77FE03280059;
        Sat, 24 Oct 2020 09:38:01 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 0/3] mlxsw: Various fixes
Date:   Sat, 24 Oct 2020 16:37:30 +0300
Message-Id: <20201024133733.2107509-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This patch set contains various fixes for mlxsw.

Patch #1 ensures that only link modes that are supported by both the
device and the driver are advertised. When a link mode that is not
supported by the driver is negotiated by the device, it will be
presented as an unknown speed by ethtool, causing the bond driver to
wrongly assume that the link is down.

Patch #2 fixes a trivial memory leak upon module removal.

Patch #3 fixes a use-after-free that syzkaller was able to trigger once
on a slow emulator after a few months of fuzzing.

Amit Cohen (2):
  mlxsw: Only advertise link modes supported by both driver and device
  mlxsw: core: Fix use-after-free in mlxsw_emad_trans_finish()

Ido Schimmel (1):
  mlxsw: core: Fix memory leak on module removal

 drivers/net/ethernet/mellanox/mlxsw/core.c    |  5 ++++
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  9 ++++--
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  1 +
 .../mellanox/mlxsw/spectrum_ethtool.c         | 30 +++++++++++++++++++
 4 files changed, 43 insertions(+), 2 deletions(-)

-- 
2.26.2

