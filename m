Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7765F341
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 09:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727391AbfGDHJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 03:09:06 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:51779 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727382AbfGDHJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 03:09:05 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 24A4F2177A;
        Thu,  4 Jul 2019 03:09:04 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 04 Jul 2019 03:09:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=nPTNmBcLOAzXsPYkYe37RaHdElLIY/lQjS3FISSm3rY=; b=eoAuWEqb
        PRURMOjCq+JDMxzDk7xDr9O1WlxTEDN117QVMP7iuDBYNsSzZZuNOfD0XawlevJN
        TJU3AmQQXq8IDR9EwgUGqUlYRsSTwFjpb3Qt6uwX6uZ6rvxpAgpmrbfF7AGFycd5
        8ASgQ/DjeOe5UFEBI0h8dmg55fAY4vYUE4on6dvkMW8Kv1q1tBs0mKF1KUGsuT1W
        tTOIOst5VqxUwuyAehjMfb0PzbXH8XeASmfFxCb7hr9TmswKEF0eHsuPIBX5VKfn
        BXNiKfE09DE7jvryq1QJ+2FEfwWOdl5/MiMgUBbSy7btV5jxt8GwqResBMLKYaPp
        //ew+WzaxN3ubw==
X-ME-Sender: <xms:D6YdXa-kGPLlbrCOrVQ921zY16R6vlSgAEUYK-a2LZ32r1oTp2Z0NA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfedugdduudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeef
X-ME-Proxy: <xmx:D6YdXfwmybj4IdTmylv8iywTLsEaOh6x3ufbP0bFFxnR5V1J_hw8Vw>
    <xmx:D6YdXdBGIsoabbVBTJ8ZBxxLcfaU2OMIPJ_7AuW-D1ZbWXf5wFUl5g>
    <xmx:D6YdXQKoJfkzNWUVmgKzR9ImMfbcZ7b7j9ZZ55vUKPeKYCbKVyml4Q>
    <xmx:EKYdXToJjxXhF2cV63xSbyys_1Id8uJyvrfL4811FLF836ARenwpcA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7807A380075;
        Thu,  4 Jul 2019 03:09:02 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, richardcochran@gmail.com, jiri@mellanox.com,
        petrm@mellanox.com, shalomt@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 4/8] mlxsw: spectrum_ptp: Set the PTP shaper parameters
Date:   Thu,  4 Jul 2019 10:07:36 +0300
Message-Id: <20190704070740.302-5-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190704070740.302-1-idosch@idosch.org>
References: <20190704070740.302-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shalom Toledo <shalomt@mellanox.com>

Set the PTP shaper parameters during the ptp_init(). For different
speeds, there are different parameters.

When the port's speed changes and PTP shaper is enabled, the firmware
changes the ETS shaper values according to the PTP shaper parameters for
this new speed.

The PTP shaper parameters array is left empty for now, will be filled in
a follow-up patch.

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    | 45 +++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index 437023d67a3b..08e62cb3d7f2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -753,12 +753,57 @@ static int mlxsw_sp1_ptp_mtpppc_set(struct mlxsw_sp *mlxsw_sp,
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(mtpppc), mtpppc_pl);
 }
 
+struct mlxsw_sp1_ptp_shaper_params {
+	u32 ethtool_speed;
+	enum mlxsw_reg_qpsc_port_speed port_speed;
+	u8 shaper_time_exp;
+	u8 shaper_time_mantissa;
+	u8 shaper_inc;
+	u8 shaper_bs;
+	u8 port_to_shaper_credits;
+	int ing_timestamp_inc;
+	int egr_timestamp_inc;
+};
+
+static const struct mlxsw_sp1_ptp_shaper_params
+mlxsw_sp1_ptp_shaper_params[] = {
+};
+
+#define MLXSW_SP1_PTP_SHAPER_PARAMS_LEN ARRAY_SIZE(mlxsw_sp1_ptp_shaper_params)
+
+static int mlxsw_sp1_ptp_shaper_params_set(struct mlxsw_sp *mlxsw_sp)
+{
+	const struct mlxsw_sp1_ptp_shaper_params *params;
+	char qpsc_pl[MLXSW_REG_QPSC_LEN];
+	int i, err;
+
+	for (i = 0; i < MLXSW_SP1_PTP_SHAPER_PARAMS_LEN; i++) {
+		params = &mlxsw_sp1_ptp_shaper_params[i];
+		mlxsw_reg_qpsc_pack(qpsc_pl, params->port_speed,
+				    params->shaper_time_exp,
+				    params->shaper_time_mantissa,
+				    params->shaper_inc, params->shaper_bs,
+				    params->port_to_shaper_credits,
+				    params->ing_timestamp_inc,
+				    params->egr_timestamp_inc);
+		err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(qpsc), qpsc_pl);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 struct mlxsw_sp_ptp_state *mlxsw_sp1_ptp_init(struct mlxsw_sp *mlxsw_sp)
 {
 	struct mlxsw_sp_ptp_state *ptp_state;
 	u16 message_type;
 	int err;
 
+	err = mlxsw_sp1_ptp_shaper_params_set(mlxsw_sp);
+	if (err)
+		return ERR_PTR(err);
+
 	ptp_state = kzalloc(sizeof(*ptp_state), GFP_KERNEL);
 	if (!ptp_state)
 		return ERR_PTR(-ENOMEM);
-- 
2.20.1

