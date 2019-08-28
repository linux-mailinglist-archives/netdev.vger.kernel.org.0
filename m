Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82236A06AD
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 17:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbfH1PzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 11:55:06 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:58765 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726410AbfH1PzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 11:55:05 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6190E22189;
        Wed, 28 Aug 2019 11:55:04 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 28 Aug 2019 11:55:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=O4atCehQyJoX9ZhhG
        jb3W1gVL75CqBUsldkQCVqgT1o=; b=CjlBvEhjqhOaeFAPazCOAxrL77AlhhOmL
        lr1no4pMoWmNSVbiVxxak72l+DIpzfyQlfGf2qKAuQpoWChIzfuiKBEZKpNxWku2
        WyStNQT+Mkg1WZGtoUGNhkY917XAHuMAPrVeC5ZzPVNOSqdOoBJ5+E0UDdwPDa+2
        TH48IG6HLhcjeQYniwnDQAKrxczPncDlobI0BrOWtbZe9cDntgkVkIbLd3OABDNz
        VXqhv6t6IzWmg4BOk13+jv08RN7uViErssN89Ai12XmFmnsrs0BFZetJ/hirdWpm
        Q32S3axslu/QkJkmmpP7wtfH+lehhxcZrX0omDBBKeijLYPGCXoXg==
X-ME-Sender: <xms:16NmXbFDY-X2hHg04nCygeTlXEWvOvlxiptJcHsqeIGMF9cRfXmY-w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudeitddgleegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:16NmXc65dczPK_TD4Yg5e35qIY7cn0XVOmju-5Qp94SsMDeL2TEoog>
    <xmx:16NmXZAh3jcPH7QajCh-Nm2z_rIVXjZeszcn4_BfzbqzPPIC1C5Osw>
    <xmx:16NmXVza7wNaESzezhaeyMysR3zW9qy2gCkdjxxR-J66_iJsB3GdkA>
    <xmx:2KNmXdmZLSm7nq-bzU-E5GIA3uZ6XGbaW5gW3lnjvUU0b9J7moZTtA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id DDEA1D6005B;
        Wed, 28 Aug 2019 11:55:02 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/4] mlxsw: Various updates
Date:   Wed, 28 Aug 2019 18:54:33 +0300
Message-Id: <20190828155437.9852-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Patch #1 from Amit removes 56G speed support. The reasons for this are
detailed in the commit message.

Patch #2 from Shalom ensures that the hardware does not auto negotiate
the number of used lanes. For example, if a four lane port supports 100G
over both two and four lanes, it will not advertise the two lane link
mode.

Patch #3 bumps the firmware version supported by the driver.

Patch #4 from Petr adds ethtool counters to help debug the internal PTP
implementation in mlxsw. I copied Richard on this patch in case he has
comments.

Amit Cohen (1):
  mlxsw: Remove 56G speed support

Ido Schimmel (1):
  mlxsw: Bump firmware version to 13.2000.1886

Petr Machata (1):
  mlxsw: spectrum_ptp: Add counters for GC events

Shalom Toledo (1):
  mlxsw: spectrum: Prevent auto negotiation on number of lanes

 drivers/net/ethernet/mellanox/mlxsw/reg.h     |   1 -
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 140 ++++++++++++------
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  17 ++-
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    |  67 +++++++++
 .../ethernet/mellanox/mlxsw/spectrum_ptp.h    |  32 ++++
 .../net/ethernet/mellanox/mlxsw/switchx2.c    |   6 -
 6 files changed, 210 insertions(+), 53 deletions(-)

-- 
2.21.0

