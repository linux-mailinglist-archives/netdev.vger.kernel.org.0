Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3F6913610E
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 20:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730164AbgAIT1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 14:27:44 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:41577 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730151AbgAIT1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 14:27:42 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 1BD4A21583;
        Thu,  9 Jan 2020 14:27:42 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 09 Jan 2020 14:27:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=Mg4vJ3yOb3E5C4cx8UghWS+tUDz0iPK1BXqY3XMXkPc=; b=Azf9NOUQ
        Pq+2PshH9CIU+WEiWx5UVZ4iHWbWjsWj/zZv0PazJ79eLEgd34nmVLLaSjn2OUuD
        hByoj5QT5dIxEEHOeOQ0eHBgt6hsiq0IBIsUHukbq5UH5LytO5q0oTcbWvc4pKq/
        ikkuWIv3fnzQRSs+V+sHU6w7UC7gRN5YUCGy6SVZuIXRxnb0CyKiGiYTc32uwmrA
        72AqMa08lWIiO7H6CjSrCEYqsH9IIGoo9oNhRq1ZzFSjt4cB9/elu4LmCZ8ZNHSL
        Tlti5aJBdNe+465feGnN3RqLiAkB1DJsmOjwXxsBjcZgwFgv3wCGSYDQ54dn62KJ
        VUSEXkRMnP8Tjw==
X-ME-Sender: <xms:rn4XXliK4Ltyqkw4W0NpaIhJOrdPDXQD_cEUJYwUfusIUP_EqHSjNw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeiuddgledtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:rn4XXjMBt-NiRW70xWOYkLEy9CYllMcpvSgrJ_HOPtk1zKwzVZGkhA>
    <xmx:rn4XXvM1sbL8fyfzPTF6dBymdg0-fdTNnFTG1ejhjgivZhFWcDfJBg>
    <xmx:rn4XXrKdE_-jPrnbsLP-wfeDMNNgLDiHkWpjQukkZNwg0pt4vJxszA>
    <xmx:rn4XXjoxMOsnGP33iMk7ehvHE3FSMTJnJcUaSFg24dpbbWETtr86Vg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0996330602DE;
        Thu,  9 Jan 2020 14:27:40 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/2] mlxsw: spectrum: Only require minimum firmware version
Date:   Thu,  9 Jan 2020 21:27:22 +0200
Message-Id: <20200109192722.297496-3-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200109192722.297496-1-idosch@idosch.org>
References: <20200109192722.297496-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Currently, the driver ensures that the firmware version found on the
device matches the branch of the required version.

Remove this limitation so that the driver will accept the required
version or a newer version, from any branch.

This will allow us to reduce the frequency in which we need to update
the required version. New firmware versions that include necessary bug
fixes will be able to work with the driver, even if they are not from
the required branch.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 38d16042e7a8..2f0b516ee03f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -45,8 +45,6 @@
 #include "spectrum_ptp.h"
 #include "../mlxfw/mlxfw.h"
 
-#define MLXSW_SP_FWREV_MINOR_TO_BRANCH(minor) ((minor) / 100)
-
 #define MLXSW_SP1_FWREV_MAJOR 13
 #define MLXSW_SP1_FWREV_MINOR 2000
 #define MLXSW_SP1_FWREV_SUBMINOR 2714
@@ -423,13 +421,12 @@ static int mlxsw_sp_fw_rev_validate(struct mlxsw_sp *mlxsw_sp)
 		     rev->major, req_rev->major);
 		return -EINVAL;
 	}
-	if (MLXSW_SP_FWREV_MINOR_TO_BRANCH(rev->minor) ==
-	    MLXSW_SP_FWREV_MINOR_TO_BRANCH(req_rev->minor) &&
-	    mlxsw_core_fw_rev_minor_subminor_validate(rev, req_rev))
+	if (mlxsw_core_fw_rev_minor_subminor_validate(rev, req_rev))
 		return 0;
 
-	dev_info(mlxsw_sp->bus_info->dev, "The firmware version %d.%d.%d is incompatible with the driver\n",
-		 rev->major, rev->minor, rev->subminor);
+	dev_err(mlxsw_sp->bus_info->dev, "The firmware version %d.%d.%d is incompatible with the driver (required >= %d.%d.%d)\n",
+		rev->major, rev->minor, rev->subminor, req_rev->major,
+		req_rev->minor, req_rev->subminor);
 	dev_info(mlxsw_sp->bus_info->dev, "Flashing firmware using file %s\n",
 		 fw_filename);
 
-- 
2.24.1

