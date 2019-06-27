Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 612E057843
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfF0Adh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:33:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727802AbfF0Adg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:33:36 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89E492083B;
        Thu, 27 Jun 2019 00:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595615;
        bh=DD7s0PggG5Kufj9HifqYebayPNijjqvzTuFlPMaGYvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yp6GKmeSA/wan8QaVQlMX2uVxFA7lu/k2mw81sYiwdGS6qbfnM2cikZD2M4oV9miF
         0rq1fdWZ1UKLdMKiniTTUzZ2Jb7IbDpyv6JzLY5k/eZ9m8PSVTbAJfPLYifclVT2pY
         4h4gCXjK4KC5VY7sewCpDgulmZ5/SEizY/zRvX3M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ido Schimmel <idosch@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 56/95] mlxsw: spectrum: Disallow prio-tagged packets when PVID is removed
Date:   Wed, 26 Jun 2019 20:29:41 -0400
Message-Id: <20190627003021.19867-56-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

[ Upstream commit 4b14cc313f076c37b646cee06a85f0db59cf216c ]

When PVID is removed from a bridge port, the Linux bridge drops both
untagged and prio-tagged packets. Align mlxsw with this behavior.

Fixes: 148f472da5db ("mlxsw: reg: Add the Switch Port Acceptable Frame Types register")
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index eb4c5e8964cd..5865597577d6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -997,7 +997,7 @@ static inline void mlxsw_reg_spaft_pack(char *payload, u8 local_port,
 	MLXSW_REG_ZERO(spaft, payload);
 	mlxsw_reg_spaft_local_port_set(payload, local_port);
 	mlxsw_reg_spaft_allow_untagged_set(payload, allow_untagged);
-	mlxsw_reg_spaft_allow_prio_tagged_set(payload, true);
+	mlxsw_reg_spaft_allow_prio_tagged_set(payload, allow_untagged);
 	mlxsw_reg_spaft_allow_tagged_set(payload, true);
 }
 
-- 
2.20.1

