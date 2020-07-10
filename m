Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B28421B750
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 15:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728118AbgGJN6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 09:58:03 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:60771 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726965AbgGJN6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 09:58:02 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id CA27658058A;
        Fri, 10 Jul 2020 09:58:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 10 Jul 2020 09:58:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=EYN9v2G1qiA5xza4vBdLgOUVmxeku6BsokFrmDC/8qQ=; b=bC8Fi+Ou
        M0RA2+20+eXZ5GtJOYwXzRGEnNmzEDHWTk55pFcvZyeTPI//mwSriUxc6w2fYjmK
        oEU5CvAmgS3AvY6t+6eFfMgZ8x43IsQmq/5BeCFyBOw2+oQGGeyJEm7s+D8QbM+Z
        wtjtTRDZrkSdfr8ysvH2ybnvHJ0JmN7fu7yoH6B8f7lMXmiFLFFTzzL1s0MQN1gX
        Z9DF9SkrDOI8eJq9miHGYEDZwuZxNdlaBFXitwN+edjO8do4XYVG4DiEsK7dIu3F
        qDq2iVwdsY2Eykl31BIj0l2T+iMPh37xL1ARGbVwB3FvQSzRPktmyDhusat9HBVN
        5QEXELMb5ICi0w==
X-ME-Sender: <xms:6XMIXykwziajzI-8sTgAYWc9NQWMdH_FJJSaNuObOCi9d680E79Tow>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrvddugdejgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepudetieevffffveelkeeljeffkefhkeehgfdtffethfelvdejgffghefgveejkefh
    necukfhppedutdelrdeiiedrudelrddufeefnecuvehluhhsthgvrhfuihiivgepudenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:6XMIX51z0QAFPJYdNdcbWoCC9AuOZj_4XeuA1cfBVbtvywuIPZzbJg>
    <xmx:6XMIXwqgKTkp35nkP_-LEKAm6wRI573y94tbsRainSgJ66wk3e1Xww>
    <xmx:6XMIX2mMnTZv6iKlba0m_qps50bRFIl9Gf24TlSrrtKaPSKiYqjOrA>
    <xmx:6XMIX2Oqdn-Y_r7SuBIJvrUjun25YaZZkaNmvTVQ7G37MhfKbgSuTQ>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 37143328005D;
        Fri, 10 Jul 2020 09:57:58 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com, michael.chan@broadcom.com,
        saeedm@mellanox.com, leon@kernel.org, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, simon.horman@netronome.com,
        Amit Cohen <amitc@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 02/13] mlxsw: reg: Add Monitoring Mirror Trigger Enable Register
Date:   Fri, 10 Jul 2020 16:56:55 +0300
Message-Id: <20200710135706.601409-3-idosch@idosch.org>
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

This register is used to configure the mirror enable for different
mirror reasons.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 50 +++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index b76c839223b5..aa2fd7debec2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -9502,6 +9502,55 @@ MLXSW_ITEM32(reg, mogcr, ptp_iftc, 0x00, 1, 1);
  */
 MLXSW_ITEM32(reg, mogcr, ptp_eftc, 0x00, 0, 1);
 
+/* MOMTE - Monitoring Mirror Trigger Enable Register
+ * -------------------------------------------------
+ * This register is used to configure the mirror enable for different mirror
+ * reasons.
+ */
+#define MLXSW_REG_MOMTE_ID 0x908D
+#define MLXSW_REG_MOMTE_LEN 0x10
+
+MLXSW_REG_DEFINE(momte, MLXSW_REG_MOMTE_ID, MLXSW_REG_MOMTE_LEN);
+
+/* reg_momte_local_port
+ * Local port number.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, momte, local_port, 0x00, 16, 8);
+
+enum mlxsw_reg_momte_type {
+	MLXSW_REG_MOMTE_TYPE_WRED = 0x20,
+	MLXSW_REG_MOMTE_TYPE_SHARED_BUFFER_TCLASS = 0x31,
+	MLXSW_REG_MOMTE_TYPE_SHARED_BUFFER_TCLASS_DESCRIPTORS = 0x32,
+	MLXSW_REG_MOMTE_TYPE_SHARED_BUFFER_EGRESS_PORT = 0x33,
+	MLXSW_REG_MOMTE_TYPE_ING_CONG = 0x40,
+	MLXSW_REG_MOMTE_TYPE_EGR_CONG = 0x50,
+	MLXSW_REG_MOMTE_TYPE_ECN = 0x60,
+	MLXSW_REG_MOMTE_TYPE_HIGH_LATENCY = 0x70,
+};
+
+/* reg_momte_type
+ * Type of mirroring.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, momte, type, 0x04, 0, 8);
+
+/* reg_momte_tclass_en
+ * TClass/PG mirror enable. Each bit represents corresponding tclass.
+ * 0: disable (default)
+ * 1: enable
+ * Access: RW
+ */
+MLXSW_ITEM_BIT_ARRAY(reg, momte, tclass_en, 0x08, 0x08, 1);
+
+static inline void mlxsw_reg_momte_pack(char *payload, u8 local_port,
+					enum mlxsw_reg_momte_type type)
+{
+	MLXSW_REG_ZERO(momte, payload);
+	mlxsw_reg_momte_local_port_set(payload, local_port);
+	mlxsw_reg_momte_type_set(payload, type);
+}
+
 /* MTPPPC - Time Precision Packet Port Configuration
  * -------------------------------------------------
  * This register serves for configuration of which PTP messages should be
@@ -10853,6 +10902,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(mgpc),
 	MLXSW_REG(mprs),
 	MLXSW_REG(mogcr),
+	MLXSW_REG(momte),
 	MLXSW_REG(mtpppc),
 	MLXSW_REG(mtpptr),
 	MLXSW_REG(mtptpt),
-- 
2.26.2

