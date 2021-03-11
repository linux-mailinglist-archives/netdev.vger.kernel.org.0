Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45022337285
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 13:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbhCKMZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 07:25:16 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:47957 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232852AbhCKMZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 07:25:09 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id D0E775C0172;
        Thu, 11 Mar 2021 07:25:08 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 11 Mar 2021 07:25:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=Cb3+om5RAAa7c3PNJJROdYZ8rN4poKp87At/vyrcFKg=; b=KCh9GgpD
        tNvH40YLKD5tckEeThsN47IQThmAoovey3OcWb5sAucgLa8eUBaggUutHx6RHF7N
        g4eejS6nRFrqftl/wasYnCgxgKUVjtvxThWu9vXGf+zwhVlMg23+JPvdJoawCicb
        Z7cxj4O9JLd2fzT4nS0bUkfjx9whKkypM4X6pC+bUVaB9w64ZpdiqXZATPBiGM3H
        o0kfmzIoon2CsBzXCB8UZeG4XZ2FfG++pF0Ln/094r37f1QmNUFKcS0PydhHuakz
        IsM8jb9plXiOMPG7jSPhm+bfQaUGGVyfRUo9n8kAOdU8fNxWfVVg2qSQZvaXe15Q
        W1DfQWffsDb5Fw==
X-ME-Sender: <xms:JAxKYJti30m8KTK7jGYmMwSCTi_VnQcWWnswA3QbHxeH_sakEWbtBA>
    <xme:JAxKYCdajr_vHgZQHYueGRKTQ39bZdZLiONJYUWlNxPcPReEMtWCsgBGmDW55fpmk
    vABEc7EA00uyFo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvtddggedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:JAxKYMzE71kp6p09qdMy1mheHKswxEQplrE3SEGesW2JyQ3vSFftMw>
    <xmx:JAxKYAN_2U56LtGKp5wIT54n4lMyxIMoe7Odnjh-50o2xkjEq9YwsA>
    <xmx:JAxKYJ-Kv-eYoU-tbDSD1UUFegbbHoeEwzcGBiHhniye0W7umgN3lg>
    <xmx:JAxKYLKsj118XMpOknDri2PrhC2f2WuRJiYPmiG3p3kIW3IqLzj4Zg>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6DED91080057;
        Thu, 11 Mar 2021 07:25:07 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/6] mlxsw: reg: Extend mirroring registers with probability rate field
Date:   Thu, 11 Mar 2021 14:24:12 +0200
Message-Id: <20210311122416.2620300-3-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311122416.2620300-1-idosch@idosch.org>
References: <20210311122416.2620300-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The MPAR and MPAGR registers are used to configure the binding between
the mirroring trigger (e.g., received packet) and the SPAN agent. Add
probability rate field, which will allow us to support sampling by
mirroring to the CPU.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h       | 17 ++++++++++++++++-
 .../net/ethernet/mellanox/mlxsw/spectrum_span.c |  2 +-
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 2f7f691f85ff..44f836246e33 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -9925,15 +9925,28 @@ MLXSW_ITEM32(reg, mpar, enable, 0x04, 31, 1);
  */
 MLXSW_ITEM32(reg, mpar, pa_id, 0x04, 0, 4);
 
+#define MLXSW_REG_MPAR_RATE_MAX 3500000000UL
+
+/* reg_mpar_probability_rate
+ * Sampling rate.
+ * Valid values are: 1 to 3.5*10^9
+ * Value of 1 means "sample all". Default is 1.
+ * Reserved when Spectrum-1.
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, mpar, probability_rate, 0x08, 0, 32);
+
 static inline void mlxsw_reg_mpar_pack(char *payload, u8 local_port,
 				       enum mlxsw_reg_mpar_i_e i_e,
-				       bool enable, u8 pa_id)
+				       bool enable, u8 pa_id,
+				       u32 probability_rate)
 {
 	MLXSW_REG_ZERO(mpar, payload);
 	mlxsw_reg_mpar_local_port_set(payload, local_port);
 	mlxsw_reg_mpar_enable_set(payload, enable);
 	mlxsw_reg_mpar_i_e_set(payload, i_e);
 	mlxsw_reg_mpar_pa_id_set(payload, pa_id);
+	mlxsw_reg_mpar_probability_rate_set(payload, probability_rate);
 }
 
 /* MGIR - Management General Information Register
@@ -10577,6 +10590,8 @@ MLXSW_ITEM32(reg, mpagr, trigger, 0x00, 0, 4);
  */
 MLXSW_ITEM32(reg, mpagr, pa_id, 0x04, 0, 4);
 
+#define MLXSW_REG_MPAGR_RATE_MAX 3500000000UL
+
 /* reg_mpagr_probability_rate
  * Sampling rate.
  * Valid values are: 1 to 3.5*10^9
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index 3287211819df..7711ace07ec8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -1232,7 +1232,7 @@ __mlxsw_sp_span_trigger_port_bind(struct mlxsw_sp_span *span,
 	}
 
 	mlxsw_reg_mpar_pack(mpar_pl, trigger_entry->local_port, i_e, enable,
-			    trigger_entry->parms.span_id);
+			    trigger_entry->parms.span_id, 1);
 	return mlxsw_reg_write(span->mlxsw_sp->core, MLXSW_REG(mpar), mpar_pl);
 }
 
-- 
2.29.2

