Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84AE9EACC2
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 10:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbfJaJnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 05:43:10 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:41427 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727365AbfJaJnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 05:43:08 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 4EF97210D8;
        Thu, 31 Oct 2019 05:43:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 31 Oct 2019 05:43:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=nU2vucza2VT4r2IXnM2tTsSwi6g6eMNcz73I495QPi4=; b=Is0xekAD
        33B/AXJjsgFkYlsYfbNDDpwChz/MBbq0boJYLzynlXPXW35JLkiQWQzTWjDB1tWv
        JockmsSSEhQ1DW0EGg/ZZQXPcvit5ZzUpwt6ekbXSCdnndXmBCpAfQeDQ2xBVhr/
        ZtcEYAh80ZKpTbRyVkH+Om3+3U8LCF74j2Gyl7ZdD0EyOEs77wELdEWpktsMmdGi
        qsAERH0GGO+SVXx93aoLCmh/xIvGjZg5VmllVVEUXWrtQF2Zr5xZrklp285URwwI
        I7PLSqIA/TZ2Fbsz1+0f+sVM0jyKlQnje9+RdRaqaGhwvi+ctylFUKgMvyHQbwUX
        pdA2kNtzzR5kbw==
X-ME-Sender: <xms:rKy6XdgMeH0od7DUTWth078JGKkRQu8B__Nz4xwxphtChz0iXOA4FA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddthedgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeduge
X-ME-Proxy: <xmx:rKy6Xd3y-CvnFBG-yQNv9Ig3O-W-oPqAf5kwUNLJq-lDxo_VJ51pkQ>
    <xmx:rKy6XYcvP7VZvgrqqBEXdhmU2Yj2fHD9B3vc3nx09TIH2LhfRXx-Dg>
    <xmx:rKy6XbzDvAUYOdmG5Xy39hGGqczYpFK-LInkfr7hfKGwde6oDON9WQ>
    <xmx:rKy6XUvOiIJLQYrMMOj-cqxy7sK1e-Iez8q--S26PICRYqP2TFL_0w>
Received: from localhost.localdomain (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id BD3B980061;
        Thu, 31 Oct 2019 05:43:06 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 16/16] mlxsw: spectrum: Generalize split count check
Date:   Thu, 31 Oct 2019 11:42:21 +0200
Message-Id: <20191031094221.17526-17-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191031094221.17526-1-idosch@idosch.org>
References: <20191031094221.17526-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Make the check generic for any possible value, not only 2 and 4.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Shalom Toledo <shalomt@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 3ce48d0df37f..ea4cc2aa99e0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4215,9 +4215,9 @@ static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u8 local_port,
 		return -EINVAL;
 	}
 
-	if (count != 2 && count != 4) {
-		netdev_err(mlxsw_sp_port->dev, "Port can only be split into 2 or 4 ports\n");
-		NL_SET_ERR_MSG_MOD(extack, "Port can only be split into 2 or 4 ports");
+	if (count == 1 || !is_power_of_2(count) || count > max_width) {
+		netdev_err(mlxsw_sp_port->dev, "Invalid split count\n");
+		NL_SET_ERR_MSG_MOD(extack, "Invalid split count");
 		return -EINVAL;
 	}
 
-- 
2.21.0

