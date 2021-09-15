Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0A140C376
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 12:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237526AbhIOKPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 06:15:10 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:51685 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237540AbhIOKPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 06:15:03 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 055FC5C0193;
        Wed, 15 Sep 2021 06:13:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 15 Sep 2021 06:13:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=TAJO6ZoSzx4d6w9AWKNHTYsxrdORz+1fJBUrBh37QYA=; b=s2ZNPo9U
        xjnOLVLDj/DBpyeoB91ZCwGbT6280QoXL6U20b6KdR8fITKY3lQAv9lA0DdiivCe
        fcyYEEjA6qxooxO0GXTiJF8XDufm9+OoVs9Fqz5byYgncsaKkZay6WbEi+ymtKQs
        HFSmyh/1gVAqzU3jTLqs6e2ndEGkPptP1xO+T2g23T1tK+Q6piFDzeD1JwZTzygE
        RD+aR1PGwMCoF7PegTL4RC1SPURb72xXSu3f7Ip03ZGuT/LEZqS8wnCr3pFd3TFb
        yKg3z2cZAPtVf99fM7XHEozCXzBsrsahPNTXkPjri1OYbg3ZZuvXi09XUMpewTWy
        v6QYeDCsf9sVTw==
X-ME-Sender: <xms:WMdBYZRKUd3GW946xf7Rls9WVt6cFVie-P_zoigEeKA4Xiu9KFkMVA>
    <xme:WMdBYSzVA6UWu6fVuVc2IonOPWTiEpjE6lXhIpp-KVHIH_DNJ97j43XMYPdXCtJOy
    9HzaGt9My7lPj8>
X-ME-Received: <xmr:WMdBYe2jF1jcvYkyNU79XS7WDHOFmm1qbgDxSnXSR_ckd5rJtahGt5xC6zKVfUJuPylRHb2WbNzaIfC6OtI2oh1tIeF9ChzlRg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudehuddgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:WMdBYRAmt6jB6e4KSoGcLN0oXmyBq3bMm8IoeIzfbF84F3suwx7Y2Q>
    <xmx:WMdBYShZMZUpnqjW2kMygqeDIWy4Fu8fIiA8tnE38PnmpRTCKBAaPA>
    <xmx:WMdBYVqC4z3vCJI0lULio5ZI_L5K226Dmm8RBUaO1Zj4Ec7bJ9tfDQ>
    <xmx:WcdBYUa6EufPEdgikIWXFGRE07eMni-as79xrnA_Nmn81CgXmvtEpg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Sep 2021 06:13:42 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 09/10] mlxsw: Make PMAOS pack function more generic
Date:   Wed, 15 Sep 2021 13:13:13 +0300
Message-Id: <20210915101314.407476-10-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210915101314.407476-1-idosch@idosch.org>
References: <20210915101314.407476-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The PMAOS register has enable bits (e.g., PMAOS.ee) that allow changing
only a subset of the fields, which is exactly what subsequent patches
will need to do. Instead of passing multiple arguments to its pack
function, only pass the module index and let the rest be set by the
different callers.

No functional changes intended.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core_env.c | 6 ++++--
 drivers/net/ethernet/mellanox/mlxsw/reg.h      | 5 +----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index c7b7254061ee..a474629643aa 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -684,8 +684,10 @@ mlxsw_env_module_oper_state_event_enable(struct mlxsw_core *mlxsw_core,
 	for (i = 0; i < module_count; i++) {
 		char pmaos_pl[MLXSW_REG_PMAOS_LEN];
 
-		mlxsw_reg_pmaos_pack(pmaos_pl, i,
-				     MLXSW_REG_PMAOS_E_GENERATE_EVENT);
+		mlxsw_reg_pmaos_pack(pmaos_pl, i);
+		mlxsw_reg_pmaos_e_set(pmaos_pl,
+				      MLXSW_REG_PMAOS_E_GENERATE_EVENT);
+		mlxsw_reg_pmaos_ee_set(pmaos_pl, true);
 		err = mlxsw_reg_write(mlxsw_core, MLXSW_REG(pmaos), pmaos_pl);
 		if (err)
 			return err;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 667856f00728..6c96e124e4c8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5747,13 +5747,10 @@ enum mlxsw_reg_pmaos_e {
  */
 MLXSW_ITEM32(reg, pmaos, e, 0x04, 0, 2);
 
-static inline void mlxsw_reg_pmaos_pack(char *payload, u8 module,
-					enum mlxsw_reg_pmaos_e e)
+static inline void mlxsw_reg_pmaos_pack(char *payload, u8 module)
 {
 	MLXSW_REG_ZERO(pmaos, payload);
 	mlxsw_reg_pmaos_module_set(payload, module);
-	mlxsw_reg_pmaos_e_set(payload, e);
-	mlxsw_reg_pmaos_ee_set(payload, true);
 }
 
 /* PPLR - Port Physical Loopback Register
-- 
2.31.1

