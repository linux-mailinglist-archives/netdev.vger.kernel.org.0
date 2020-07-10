Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36F9D21B753
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 15:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbgGJN6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 09:58:07 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:56737 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726965AbgGJN6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 09:58:07 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 355C858058B;
        Fri, 10 Jul 2020 09:58:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 10 Jul 2020 09:58:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=mqaXeefT+RT+euyy7dSPY6o0V/kL+Npk1B4vDO8I/Vw=; b=GSowZ7GG
        6mCIVhP3bkzBIbR0c0DJLBqpIn1IMruStIpZvkeJPwbgfLmio/X3i6bTelz1HitU
        w/hLm20478399r01NCMbWvNgSQGUgGEWe4cMEofpvIyiokeW7DAjqlsSgxqEOtSb
        7Wzv6S7eJT0noD5OFuAuKsPotVck4oSb1HeV8q7FRIgUokK54mw0AfPlTRRb2Iq2
        SWQMlT4Eu9AXN5zCUFT6Q7o1X/SRlSzCksHejo/fb+wyPvVooHSft6jVP46K3+kj
        ezZNH8i7t3YGyivPfGpZTvaj65J9R53R1yK5CliD137Bsbv1c2GOHTZjWgb4BOjn
        wjbbKA5OKMi/xQ==
X-ME-Sender: <xms:7nMIX2vPtVnsLZL8eobVdPKLPJ4RdoCcuMUMbLAKOhfFXQ6CPBD6Yg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrvddugdejgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepudetieevffffveelkeeljeffkefhkeehgfdtffethfelvdejgffghefgveejkefh
    necukfhppedutdelrdeiiedrudelrddufeefnecuvehluhhsthgvrhfuihiivgepvdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:7nMIX7eOXdMmW7AesC3wRh5j-yHeXG3wKotkW0WpOMlgGCl9e9-YBw>
    <xmx:7nMIXxyGIkeTCiw3Q0L0X5tKHZUdQRzmUEeUCJWwpqw_uzTya6jbCA>
    <xmx:7nMIXxOu43wUoaVbwMwBs7DCceGl8vIMRzzsnINiWSlKw-JtIrw74w>
    <xmx:7nMIXxVQBo5kZcrR5NfJ5KExrmn0-OKrN-7w_Mrx8hmygP2Teel0Rw>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id E98923280064;
        Fri, 10 Jul 2020 09:58:01 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com, michael.chan@broadcom.com,
        saeedm@mellanox.com, leon@kernel.org, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, simon.horman@netronome.com,
        Amit Cohen <amitc@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 03/13] mlxsw: reg: Add Monitoring Port Analyzer Global Register
Date:   Fri, 10 Jul 2020 16:56:56 +0300
Message-Id: <20200710135706.601409-4-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200710135706.601409-1-idosch@idosch.org>
References: <20200710135706.601409-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

This register is used for global port analyzer configurations.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 52 +++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index aa2fd7debec2..76f61bef03f8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -9502,6 +9502,57 @@ MLXSW_ITEM32(reg, mogcr, ptp_iftc, 0x00, 1, 1);
  */
 MLXSW_ITEM32(reg, mogcr, ptp_eftc, 0x00, 0, 1);
 
+/* MPAGR - Monitoring Port Analyzer Global Register
+ * ------------------------------------------------
+ * This register is used for global port analyzer configurations.
+ * Note: This register is not supported by current FW versions for Spectrum-1.
+ */
+#define MLXSW_REG_MPAGR_ID 0x9089
+#define MLXSW_REG_MPAGR_LEN 0x0C
+
+MLXSW_REG_DEFINE(mpagr, MLXSW_REG_MPAGR_ID, MLXSW_REG_MPAGR_LEN);
+
+enum mlxsw_reg_mpagr_trigger {
+	MLXSW_REG_MPAGR_TRIGGER_EGRESS,
+	MLXSW_REG_MPAGR_TRIGGER_INGRESS,
+	MLXSW_REG_MPAGR_TRIGGER_INGRESS_WRED,
+	MLXSW_REG_MPAGR_TRIGGER_INGRESS_SHARED_BUFFER,
+	MLXSW_REG_MPAGR_TRIGGER_INGRESS_ING_CONG,
+	MLXSW_REG_MPAGR_TRIGGER_INGRESS_EGR_CONG,
+	MLXSW_REG_MPAGR_TRIGGER_EGRESS_ECN,
+	MLXSW_REG_MPAGR_TRIGGER_EGRESS_HIGH_LATENCY,
+};
+
+/* reg_mpagr_trigger
+ * Mirror trigger.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, mpagr, trigger, 0x00, 0, 4);
+
+/* reg_mpagr_pa_id
+ * Port analyzer ID.
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, mpagr, pa_id, 0x04, 0, 4);
+
+/* reg_mpagr_probability_rate
+ * Sampling rate.
+ * Valid values are: 1 to 3.5*10^9
+ * Value of 1 means "sample all". Default is 1.
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, mpagr, probability_rate, 0x08, 0, 32);
+
+static inline void mlxsw_reg_mpagr_pack(char *payload,
+					enum mlxsw_reg_mpagr_trigger trigger,
+					u8 pa_id, u32 probability_rate)
+{
+	MLXSW_REG_ZERO(mpagr, payload);
+	mlxsw_reg_mpagr_trigger_set(payload, trigger);
+	mlxsw_reg_mpagr_pa_id_set(payload, pa_id);
+	mlxsw_reg_mpagr_probability_rate_set(payload, probability_rate);
+}
+
 /* MOMTE - Monitoring Mirror Trigger Enable Register
  * -------------------------------------------------
  * This register is used to configure the mirror enable for different mirror
@@ -10902,6 +10953,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(mgpc),
 	MLXSW_REG(mprs),
 	MLXSW_REG(mogcr),
+	MLXSW_REG(mpagr),
 	MLXSW_REG(momte),
 	MLXSW_REG(mtpppc),
 	MLXSW_REG(mtpptr),
-- 
2.26.2

