Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 155F04553A8
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 05:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242871AbhKRESN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 23:18:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:36130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242860AbhKRESF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 23:18:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46E0861B5F;
        Thu, 18 Nov 2021 04:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637208906;
        bh=8YAYzBsW5TBJX/LKnj9CZhme7bBl1n5wCV/T0AIiT3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gz1FLyvKMWdqmFqwxOsVj1mLx7TESrSEZmy3HtxN6vEFdMz7/jUcAaKgxNovCEcxB
         KJd8aCVCtUQunEpz/sjK2edQK0tlP6nNg550YExZEBvtYaBIJRiMZxRbH7Jlr+odPL
         nqhHUkXXIZWdeiPrNDEsHwJhuesJmJjQu8kPWyDgWetEHT316Gfk2oOW2T/ZbkIApU
         kHvD3QhirgZ30mKeHujfpVDBXaWgabWwUqhJKnAYwML9Z0jw3vXCjCt0xjx8Q78RVd
         vh4jE3DsWtTht66WaYrzkLOGkuP0KrZUhdfKu5qcNIHjVAoLmO6FWl3f0l29J/svDn
         Py4Q7Yg4Bqi+g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        jiri@nvidia.com, idosch@nvidia.com
Subject: [PATCH net-next 2/9] mlxsw: constify address in mlxsw_sp_port_dev_addr_set
Date:   Wed, 17 Nov 2021 20:14:54 -0800
Message-Id: <20211118041501.3102861-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211118041501.3102861-1-kuba@kernel.org>
References: <20211118041501.3102861-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Argument comes from netdev->dev_addr directly, it needs a const.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: jiri@nvidia.com
CC: idosch@nvidia.com
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 5925db386b1b..4ce07f9905f6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -303,7 +303,7 @@ int mlxsw_sp_port_admin_status_set(struct mlxsw_sp_port *mlxsw_sp_port,
 }
 
 static int mlxsw_sp_port_dev_addr_set(struct mlxsw_sp_port *mlxsw_sp_port,
-				      unsigned char *addr)
+				      const unsigned char *addr)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	char ppad_pl[MLXSW_REG_PPAD_LEN];
-- 
2.31.1

