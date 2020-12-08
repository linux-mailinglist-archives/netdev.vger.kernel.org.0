Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 676D72D2788
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 10:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728907AbgLHJZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 04:25:46 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41025 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728889AbgLHJZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 04:25:45 -0500
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id 0E7EB5C01E1;
        Tue,  8 Dec 2020 04:24:08 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute7.internal (MEProxy); Tue, 08 Dec 2020 04:24:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=lzGEkppfujGmRwDDuenhv0i/HaVWfWPr33BeNIt8xKw=; b=cZ/KYkd4
        Zt/YMFGga89vDc6lEWz4nt1pINpmtjduLOuVQ21D2yEmq5NtuzqbOF8qKY1kIW7N
        3uNK1Fzj9D7QjfPcj8wAS0EjkCt8Em6UFcX6Oysaj2o+qAmwN50JZcvqVBbPDvGr
        GerGGwi1DU64B0Dgl2/I2PTjmy+8ExFX+wrNwUzMkU15jvcZBwQpRntEO4rmzNzI
        EpC29Q9Wo5921dWyEIqtlOeT891SvjivFzT6RpOOojpUSF55WUkQZcmcwgn6we3n
        ILvTBjKsHM1/KRnb0q81sBnx1udpboY+b4tcH4eLo285hqlSTNepb4bF/P8zBhVq
        VnCquIMhx9C41Q==
X-ME-Sender: <xms:N0bPXwuEUwj5eYLOKrYpdNcmnFr0hBPZldYSOahBk8JGiVihO4r5RQ>
    <xme:N0bPX9abykCg4aEhAv7U1gZzQBWUvbZ1er59awFZiVezUpMszSW6FUWGooRKciXx9
    6_5hN4M-UZP6xE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejiedgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrjeek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:N0bPX4qTs3xBFrEX-eIWhgL_T-dXu0MEbtKXvIk_Nv8k6FFxVTOSpA>
    <xmx:N0bPX6-65t8TReQAaJTkx95W-I2xW9j5Rg-k5ZAvXE6FOkrERemYJA>
    <xmx:N0bPX_-_SYuBq5T2ao4TXGJa6qKz-fn1EkmM06ei_BX0NyqR8s7JDw>
    <xmx:OEbPX3iRqee6h7w38HJVmZG0Fh-0-ekOR0BGqbemBWjkDeD5kHKWiw>
Received: from shredder.lan (igld-84-229-153-78.inter.net.il [84.229.153.78])
        by mail.messagingengine.com (Postfix) with ESMTPA id 89DF71080064;
        Tue,  8 Dec 2020 04:24:06 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 11/13] mlxsw: spectrum_switchdev: Allow joining VxLAN to 802.1ad bridge
Date:   Tue,  8 Dec 2020 11:22:51 +0200
Message-Id: <20201208092253.1996011-12-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201208092253.1996011-1-idosch@idosch.org>
References: <20201208092253.1996011-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The previous patches added support for VxLAN device enslaved to 802.1ad
bridge in Spectrum-2 ASIC and vetoed it in Spectrum-1.

Do not veto VxLAN with 802.1ad bridge.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 73290f71eb9c..cea42f6ed89b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -2347,8 +2347,8 @@ mlxsw_sp_bridge_8021ad_vxlan_join(struct mlxsw_sp_bridge_device *bridge_device,
 				  const struct net_device *vxlan_dev, u16 vid,
 				  struct netlink_ext_ack *extack)
 {
-	NL_SET_ERR_MSG_MOD(extack, "VXLAN is not supported with 802.1ad");
-	return -EOPNOTSUPP;
+	return mlxsw_sp_bridge_vlan_aware_vxlan_join(bridge_device, vxlan_dev,
+						     vid, ETH_P_8021AD, extack);
 }
 
 static const struct mlxsw_sp_bridge_ops mlxsw_sp_bridge_8021ad_ops = {
-- 
2.28.0

