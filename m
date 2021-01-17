Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A6B2F914F
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 09:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbhAQIH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 03:07:27 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:39291 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726906AbhAQIEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 03:04:00 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id E4A2F180B;
        Sun, 17 Jan 2021 03:02:54 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 17 Jan 2021 03:02:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=LHYPHz1XxlpyIaQ+mIz1GPadM/4v/UJewmr3IARsO0I=; b=qA/fLYg+
        rrhey6tOQG2NTy4Ef9X6Q6Py/1htiFWQ+tvZMiNe3O/JUQxlKR27j8DaLuNDMp56
        7XyoS2K4pyqG87vec5cY8Ub55HSeHaFgcj6cC7ptL+gj0Hj9DlALDsu5PNI6M99J
        wRbzgX2noOExaFUWSrVBYeep6K1ysPeiINZVBogLNU/zNyjNmro+I/dzqIcYPEbA
        oJ0hld++JU68ySeobgQqa3SRqG3TyFD4Ro3vIIF8sg2gJ0PzvvqITx6OiGgBq5o1
        WafI1lnjf3p2NTVgo/DGCpfR/ceBdo3aWCoVX/MT8IYg4xqNYCElYotZmR0uiBin
        C/xfiHq3l3xRJw==
X-ME-Sender: <xms:Lu8DYKLEjM7hzpuAuhjSLMhj9IX8diP3csWJ0-lURXbQx6711B3D8Q>
    <xme:Lu8DYCJh53O3u48UJBotudVBHKnLFUIwK00z30waVI5orTqm86aI83ucCAvg3KK1P
    egd4Uqj7pxTieg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdehgdduudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Lu8DYKs_gTkigiZT_ihIJchzh_R4--tNkz3Jx9d-HtbzCelbGgTbkg>
    <xmx:Lu8DYPYpw9t2m7hqjibfadB4pssIsoE0wX_0WnnoFQlmPx1BjWxHzQ>
    <xmx:Lu8DYBam1yh11LHuiXdRjvNgKgTs2znMxsJkrEG4OWIKNKoWSYXxkQ>
    <xmx:Lu8DYAWP4jLk_ejFNAgEEcYLpDFdaO2-YeJRl8oqlv8thPge7FVm_A>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6EFA024005C;
        Sun, 17 Jan 2021 03:02:52 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/5] mlxsw: spectrum_trap: Add ecn_mark trap
Date:   Sun, 17 Jan 2021 10:02:20 +0200
Message-Id: <20210117080223.2107288-3-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210117080223.2107288-1-idosch@idosch.org>
References: <20210117080223.2107288-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

Register with devlink a new buffer drop trap, ecn_mark. Since Spectrum-1
does not support the ecn_mark trap, do it only for Spectrum-2 and above.

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 4ef12e3e021a..45cf6c027cac 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -51,6 +51,8 @@ enum {
 enum {
 	/* Packet was early dropped. */
 	MLXSW_SP_MIRROR_REASON_INGRESS_WRED = 9,
+	/* Packet was ECN marked. */
+	MLXSW_SP_MIRROR_REASON_EGRESS_ECN = 13,
 };
 
 static int mlxsw_sp_rx_listener(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
@@ -1760,6 +1762,13 @@ mlxsw_sp2_trap_items_arr[] = {
 		},
 		.is_source = true,
 	},
+	{
+		.trap = MLXSW_SP_TRAP_BUFFER_DROP(ECN_MARK),
+		.listeners_arr = {
+			MLXSW_SP_RXL_BUFFER_DISCARD(EGRESS_ECN),
+		},
+		.is_source = true,
+	},
 };
 
 static int
-- 
2.29.2

