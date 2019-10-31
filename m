Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74304EACBF
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 10:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbfJaJnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 05:43:05 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:41659 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727337AbfJaJnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 05:43:04 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 3C1EB20C69;
        Thu, 31 Oct 2019 05:43:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 31 Oct 2019 05:43:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=6ZMLaACA0WYCGzs5KwYmDNTMFiwrR0vKuCsECdj4L/w=; b=XDcVQdvT
        Wtjen8vvH4xM/H59fVJS4IQJDuMGA+banEv91I/xYviAbWNwLeCRw32ew/QUUWTO
        O/cw0mbGZHMpYsAfsvJftIIx0g/Ui0mFtP6eo2ofbtDysPyJzIvkRF5y4qE+/zBa
        026vKK/cEhQhlZGvwk9zoqWPokg/SP53D6Vt3Vd83ET1Swi7boeZGg5u8V6F5qMi
        OH7/2FeLovDqDfswfr7YPlAlQQVC9BLqEnt4koDHFflssasjBRIlxoN4KupCvLYR
        kHNGjve/ZsIOogIH3ijpq6TCwiL266m5IPjs1uq7W04o6Yp7keru9AK8LU5YbTAa
        vCG55qdAcJIKGQ==
X-ME-Sender: <xms:p6y6XSDR9_5ElkydC6JwVxjSzXzlac9Kz0I6k0b1cTbBXmoBfPJuAA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddthedgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedutd
X-ME-Proxy: <xmx:qKy6XQzAC2BoDb9a0TKf689fiH51yR3TYNlPQngHM3rLTGxDPsDxMQ>
    <xmx:qKy6XQl6RqjOVPncDPxBjRs_iWAZGuOjn2u0h2Jmgkl9jBYcPOUR3A>
    <xmx:qKy6XVEV8VTHpZ5RwCDRMO7YTM9WVPmKrEAQPdkF0iLYjzjugmIuqQ>
    <xmx:qKy6XeSD1jhLyhyAjvwupNFblVdPUuFzm0r9d6k4-AWT0gt8r34HDQ>
Received: from localhost.localdomain (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8C9DC80060;
        Thu, 31 Oct 2019 05:43:02 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 13/16] mlxsw: spectrum: Use port_module_max_width to compute base port index
Date:   Thu, 31 Oct 2019 11:42:18 +0200
Message-Id: <20191031094221.17526-14-idosch@idosch.org>
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

Instead of using constant value, use port_module_max_width which is
aligned with the cluster size.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Shalom Toledo <shalomt@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index ec6c9756791d..347bec9d1ecf 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -32,8 +32,6 @@
 
 #define MLXSW_SP_MID_MAX 7000
 
-#define MLXSW_SP_PORTS_PER_CLUSTER_MAX 4
-
 #define MLXSW_SP_PORT_BASE_SPEED_25G 25000 /* Mb/s */
 #define MLXSW_SP_PORT_BASE_SPEED_50G 50000 /* Mb/s */
 
-- 
2.21.0

