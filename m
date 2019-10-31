Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E25EAEACC0
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 10:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbfJaJnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 05:43:07 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:37149 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727360AbfJaJnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 05:43:06 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 900C221FBC;
        Thu, 31 Oct 2019 05:43:05 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 31 Oct 2019 05:43:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=CHeoaBZSp1vmgEm6D+vKXLS31L9kdAzF4OEXiXZ3rrc=; b=SSn4kxe4
        eQx3xWl9CdKNEblWeiEIbM7BdyDhwJXuhDAueq2pXkBY9Eng20goc/VjwoySv/He
        cbqj0b1SqiNiDNWP3sqwJneuzd+bj7IFe03hO4FiZ3kP+05XXGjWp5JMGb+PWhAI
        kmiFwri82xE/onBwsLmeawB6CF1fDeueS5yzsd3ElcsrqN72og+R/VbkHedP526C
        RvkTgl4veAW9Tr8cBfFxLWhUvBKGspYl/L+uJM+JcYKFIGhkXvM8c2BocqH/d5jE
        +TJamAJcH3VdfCaC5Xdtqvt3sETa2Aq+kamJ+i/XgE0LUl8QuKWAzN23+bguzcY1
        NrYQ7PRG9p6aag==
X-ME-Sender: <xms:qay6XfalhCawPXHnGEq4f9KscLczziu0rjaNJvhx9LivAQvwhKmLtw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddthedgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedutd
X-ME-Proxy: <xmx:qay6XSGhI4TKSzs96nmfWQd3JcXZP62DL0Ct0orcfl8hN5AlQ3pyZw>
    <xmx:qay6XamO0jVvIX4NmPkxxv_IDCPc2A4hYShj0vMQ8G98CyU2vDr05A>
    <xmx:qay6XXDbHll-YbdHnF5bvoJ4Zn4j5PVSSRm4Ox5URG7dBWWt1sHVlg>
    <xmx:qay6XTnOSCtWXkMkjwIggHXwZTBj7yrtBF3IJKN2tOnvAFXxS5rsTA>
Received: from localhost.localdomain (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 119988006A;
        Thu, 31 Oct 2019 05:43:03 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 14/16] mlxsw: spectrum: Fix base port get for split count 4 and 8
Date:   Thu, 31 Oct 2019 11:42:19 +0200
Message-Id: <20191031094221.17526-15-idosch@idosch.org>
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

The current code considers only split by 2 or 4. Make the base port
getting generic and allow split by 8 to be handled correctly. Generalize
the used port checks as well.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Shalom Toledo <shalomt@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 28 ++++++++++---------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index db05118adc44..0a5a4a252248 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4233,19 +4233,21 @@ static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u8 local_port,
 		return -EINVAL;
 	}
 
-	/* Make sure we have enough slave (even) ports for the split. */
-	if (count == 2) {
-		base_port = local_port;
-		if (mlxsw_sp->ports[base_port + offset]) {
-			netdev_err(mlxsw_sp_port->dev, "Invalid split configuration\n");
-			NL_SET_ERR_MSG_MOD(extack, "Invalid split configuration");
-			return -EINVAL;
-		}
-	} else {
-		base_port = mlxsw_sp_cluster_base_port_get(local_port,
-							   max_width);
-		if (mlxsw_sp->ports[base_port + 1] ||
-		    mlxsw_sp->ports[base_port + 3]) {
+	/* Only in case max split is being done, the local port and
+	 * base port may differ.
+	 */
+	base_port = count == max_width ?
+		    mlxsw_sp_cluster_base_port_get(local_port, max_width) :
+		    local_port;
+
+	for (i = 0; i < count * offset; i++) {
+		/* Expect base port to exist and also the one in the middle in
+		 * case of maximal split count.
+		 */
+		if (i == 0 || (count == max_width && i == count / 2))
+			continue;
+
+		if (mlxsw_sp_port_created(mlxsw_sp, base_port + i)) {
 			netdev_err(mlxsw_sp_port->dev, "Invalid split configuration\n");
 			NL_SET_ERR_MSG_MOD(extack, "Invalid split configuration");
 			return -EINVAL;
-- 
2.21.0

