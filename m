Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84EBE464952
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 09:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347800AbhLAIQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 03:16:49 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45383 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347714AbhLAIQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 03:16:45 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 2D3285C0278;
        Wed,  1 Dec 2021 03:13:25 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 01 Dec 2021 03:13:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=63HVSckxVh6A7Xvzrb21LTfURVEuX3Nd4Quf8ni/92A=; b=EYQ6Pv8t
        v+abstzpOES1s6y8eRTeRBHDXreOTOTPAITvXXumHxY7inwVks/ell1BKgrSHbGA
        LqbKXV0jJ0a3g+3BkLagqKYDRSKouAsRcfSR7YX2RRDcQhDbal6G8eZvJpt5m9dF
        cpUIfiv4etrowndHW3WijT5DVOJgbgkmtUdc4cLRDgNLIYt/k7MREIHd8BZan+Cd
        GDL2zUnie1M+NCZfE8/SL7vYtzVt3Rrg4e8FSoma6XYT/WH7UwvFJEq+2kPwnksG
        J/gHispCY5cuwv/ZglzT9yxaTtdbl5XAIIs/dhTP+v+hwJ9uKwq0sln3Emmlqbv0
        zVrEZEKe5Cfw6Q==
X-ME-Sender: <xms:pC6nYbtj6YhYJtaLMlCVjd2ss-xPLQ8Y2D_Xj9ad2otj_HYUaC-pkA>
    <xme:pC6nYceUU12yVV2-bZtXkGnTD0xqI3nC_lSTkXbAtBJlvRQe6Jy5GIUlH_VCzI9DB
    aIBCVPxz_XLV6c>
X-ME-Received: <xmr:pC6nYex6FYVkU8wWIhVC1x-9xU_3a-hf2MJ1dPnoIIFuYk_63WOq_fFb1qguPLzqsvd26D2kfQgWOiwV6c8_71KIxVB5D666zO9834HWaQTAyg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddriedvgdduudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:pC6nYaPKCDWK9xUsiTz9DVxgDSyK3MemcR7g1eG14rAwweDD0IROrg>
    <xmx:pC6nYb99VN-Gyk6z7bsWbCtUYNGJ4fMbslS6UgSKFJmeCgn53RhJfw>
    <xmx:pC6nYaXA7Q6Wv2E8IFbV2m1VQ6CjnQaJhHt9tYxyui39hcIm7n_fNw>
    <xmx:pS6nYXa2nkiNGG5zZvASwBi6JudS7aAcMO4x-a4eJOIDOam-Vy8VbQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Dec 2021 03:13:23 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 03/10] mlxsw: item: Add support for local_port field in a split form
Date:   Wed,  1 Dec 2021 10:12:33 +0200
Message-Id: <20211201081240.3767366-4-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211201081240.3767366-1-idosch@idosch.org>
References: <20211201081240.3767366-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Currently, local_port field uses 8 bits, which means that maximum 256
ports can be used.

As preparation for the next ASIC, which will support more than 256
ports, local_port field should be extended to 10 bits.

It is not possible to use 10 consecutive bits in all registers, and
therefore, the field is split into 2 fields:
1. local_port - the existing 8 bits, represent LSB of the extended
   field.
2. lp_msb - extra 2 bits, represent MSB of the extended field.

To avoid complex programming when reading/writing local_port, add a
dedicated macro which creates get and set functions which handle both parts
of local_port.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/item.h | 36 ++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/item.h b/drivers/net/ethernet/mellanox/mlxsw/item.h
index ab70a873a01a..cfafbeb42586 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/item.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/item.h
@@ -367,6 +367,42 @@ mlxsw_##_type##_##_cname##_##_iname##_set(char *buf, u32 val)			\
 	__mlxsw_item_set32(buf, &__ITEM_NAME(_type, _cname, _iname), 0, val);	\
 }
 
+#define LOCAL_PORT_LSB_SIZE 8
+#define LOCAL_PORT_MSB_SIZE 2
+
+#define MLXSW_ITEM32_LP(_type, _cname, _offset1, _shift1, _offset2, _shift2)	\
+static struct mlxsw_item __ITEM_NAME(_type, _cname, local_port) = {		\
+	.offset = _offset1,							\
+	.shift = _shift1,							\
+	.size = {.bits = LOCAL_PORT_LSB_SIZE,},					\
+	.name = #_type "_" #_cname "_local_port",				\
+};										\
+static struct mlxsw_item __ITEM_NAME(_type, _cname, lp_msb) = {			\
+	.offset = _offset2,							\
+	.shift = _shift2,							\
+	.size = {.bits = LOCAL_PORT_MSB_SIZE,},					\
+	.name = #_type "_" #_cname "_lp_msb",					\
+};										\
+static inline u32 __maybe_unused						\
+mlxsw_##_type##_##_cname##_local_port_get(const char *buf)			\
+{										\
+	u32 local_port, lp_msb;							\
+										\
+	local_port = __mlxsw_item_get32(buf, &__ITEM_NAME(_type, _cname,	\
+					local_port), 0);			\
+	lp_msb = __mlxsw_item_get32(buf, &__ITEM_NAME(_type, _cname, lp_msb),	\
+				   0);						\
+	return (lp_msb << LOCAL_PORT_LSB_SIZE) + local_port;			\
+}										\
+static inline void __maybe_unused						\
+mlxsw_##_type##_##_cname##_local_port_set(char *buf, u32 val)			\
+{										\
+	__mlxsw_item_set32(buf, &__ITEM_NAME(_type, _cname, local_port), 0,	\
+			   val & ((1 << LOCAL_PORT_LSB_SIZE) - 1));		\
+	__mlxsw_item_set32(buf, &__ITEM_NAME(_type, _cname, lp_msb), 0,		\
+			   val >> LOCAL_PORT_LSB_SIZE);				\
+}
+
 #define MLXSW_ITEM32_INDEXED(_type, _cname, _iname, _offset, _shift, _sizebits,	\
 			     _step, _instepoffset, _norealshift)		\
 static struct mlxsw_item __ITEM_NAME(_type, _cname, _iname) = {			\
-- 
2.31.1

