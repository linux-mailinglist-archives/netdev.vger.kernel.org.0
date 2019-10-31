Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C104FEACB5
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 10:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbfJaJmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 05:42:51 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:43171 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727196AbfJaJmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 05:42:50 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 94B1F21FBC;
        Thu, 31 Oct 2019 05:42:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 31 Oct 2019 05:42:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=6nV0otdl04YKV0DwweiT5n2AzC2hZT2toVa6oZjNSRo=; b=TT8SDD+X
        M9Wx0I4wfNfl8/bsjwgDlAkbfOE0/OMYG3xqwPL530Vrs+7ONMD+JTZdVqCvUjEV
        HdkwNMUd1jiLbo1to11OL/bNIUUcSB69ZoPZmcJlTX6YXDDfitnB/+3DZrdDYfBs
        uouHTENbIiLLpaNXZ3JwrxERlBifhnoQ33LYnHT1JLve7gWKfdzAYraAFJrgknHV
        Xt/80WaD/Oo701dFFhxumPTrGQ5cj130phYRfO0VW5pQs9k6O+3OPsaA40+u8Ejp
        NprAZu2XAOUO0Dc9kO2C9TXi8eXH6jjX2R7+1wIAZSSr/xF6Qb7Gb/ZHcewCD/HY
        VewoxqMVcbQl5Q==
X-ME-Sender: <xms:may6XRBQ1zIvOWyz_s2sD_guGvm1N9wh1fwQfoivzJ6ZPCoqAn0v7Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddthedgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeef
X-ME-Proxy: <xmx:may6XWieS-1OyZwWZg_B2OgIDpK5v9tXTwYxQsykmqBwRCqorzaJ7g>
    <xmx:may6XY4f0E5LPk07ejzcdNxhDz6QpiPM2pOub0StKHVAzy2spzszMg>
    <xmx:may6XSqaXKQuuZ-UNC9ZBgBm2bhFM6qLPIHMr9DWTHLg9MYSWEpcwg>
    <xmx:may6Xb2pu18t8VULu6ad9Zff2zcIe67cQEWss_RmYFakyTG504CfTg>
Received: from localhost.localdomain (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9AD9B80061;
        Thu, 31 Oct 2019 05:42:47 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 04/16] mlxsw: spectrum: Move max_width check up before count check
Date:   Thu, 31 Oct 2019 11:42:09 +0200
Message-Id: <20191031094221.17526-5-idosch@idosch.org>
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

The fact that the port cannot be split further should be checked before
checking the count, so move it.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Shalom Toledo <shalomt@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 149b2cc2b4fd..e0111e0a1a35 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4128,12 +4128,6 @@ static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u8 local_port,
 		return max_width;
 	}
 
-	if (count != 2 && count != 4) {
-		netdev_err(mlxsw_sp_port->dev, "Port can only be split into 2 or 4 ports\n");
-		NL_SET_ERR_MSG_MOD(extack, "Port can only be split into 2 or 4 ports");
-		return -EINVAL;
-	}
-
 	/* Split port with non-max module width cannot be split. */
 	if (mlxsw_sp_port->mapping.width != max_width) {
 		netdev_err(mlxsw_sp_port->dev, "Port cannot be split further\n");
@@ -4141,6 +4135,12 @@ static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u8 local_port,
 		return -EINVAL;
 	}
 
+	if (count != 2 && count != 4) {
+		netdev_err(mlxsw_sp_port->dev, "Port can only be split into 2 or 4 ports\n");
+		NL_SET_ERR_MSG_MOD(extack, "Port can only be split into 2 or 4 ports");
+		return -EINVAL;
+	}
+
 	/* Make sure we have enough slave (even) ports for the split. */
 	if (count == 2) {
 		offset = local_ports_in_2x;
-- 
2.21.0

