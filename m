Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFD61279F5F
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 09:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730412AbgI0Hur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 03:50:47 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:48533 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727263AbgI0Huq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 03:50:46 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 37BFB46D;
        Sun, 27 Sep 2020 03:50:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 27 Sep 2020 03:50:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=i4aqzqTrXu/2xJu5KmyH0oTXfcyfSHq2QOTxQR7uRYU=; b=fikMggtw
        mMSo1iX+iXE12VylerNrDhMbvyNIHA5jSUqKJ771xkiBDIPweUvaDzTB4N5oYUjP
        6yjlGOPY82pdhaSgAMei92RRQJN3eb2oTD9CaMBpqAwDxx2MauP+2oUgVbvLmqMx
        eu0xJMBZxK6rwaAmiCzrE5A89DzvFLo0pLnVkcIethxIWXyvioX5KTIPinUpCqaA
        u9dS4PA9rn7nFQSE7ThDqZncxIwpxXtn/ZIc20kOX/atyTHYuZLr2ChqKC2HxdlB
        nyIzy977mKMEhxBR7mLDkWmS0Gh6nCrViUimtGCr7ufu7FJHn71erH40/je0Ocna
        dKswSYj3NDh4KQ==
X-ME-Sender: <xms:VERwXw5c-PPGFTin5ZRiAh4qm1fgTbCyTcr1K1cM2GJhAVmcepCZdA>
    <xme:VERwXx7iUUzLdxCxEJ88htYHo1IQc72T_Bo_ld0lgmdibffaGxAHV_l9CZOWIRySf
    PRP1vIbAUes1qo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdefgdduudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeejrddugeek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:VERwX_eSDH9X2sh-lpen9OqHzXgyn49WK9fPFrWu2cz7J4FHafUeXg>
    <xmx:VERwX1Lp-1YyL-w8Xb9Djhgjh5x4jxTwTkN6JXzRubtUBF8UvpvADg>
    <xmx:VERwX0LIvczR5cY8CEG5VnolPb5WijHGLD_wXpKm92E-f-eV4SN1-Q>
    <xmx:VERwX40zWSBnhF0666L01A_DFj-QZBZF6XVXTGrzNbzXD4vj6_KakQ>
Received: from shredder.lan (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id E68F3328005A;
        Sun, 27 Sep 2020 03:50:42 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 01/10] mlxsw: reg: Add Management Temperature Warning Event Register
Date:   Sun, 27 Sep 2020 10:50:06 +0300
Message-Id: <20200927075015.1417714-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200927075015.1417714-1-idosch@idosch.org>
References: <20200927075015.1417714-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Add MTWE (Management Temperature Warning Event) register, which is used
for over temperature warning.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 6e3d55006089..e04eb7576ca6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -8466,6 +8466,23 @@ static inline void mlxsw_reg_mtmp_unpack(char *payload, int *p_temp,
 		mlxsw_reg_mtmp_sensor_name_memcpy_from(payload, sensor_name);
 }
 
+/* MTWE - Management Temperature Warning Event
+ * -------------------------------------------
+ * This register is used for over temperature warning.
+ */
+#define MLXSW_REG_MTWE_ID 0x900B
+#define MLXSW_REG_MTWE_LEN 0x10
+
+MLXSW_REG_DEFINE(mtwe, MLXSW_REG_MTWE_ID, MLXSW_REG_MTWE_LEN);
+
+/* reg_mtwe_sensor_warning
+ * Bit vector indicating which of the sensor reading is above threshold.
+ * Address 00h bit31 is sensor_warning[127].
+ * Address 0Ch bit0 is sensor_warning[0].
+ * Access: RO
+ */
+MLXSW_ITEM_BIT_ARRAY(reg, mtwe, sensor_warning, 0x0, 0x10, 1);
+
 /* MTBR - Management Temperature Bulk Register
  * -------------------------------------------
  * This register is used for bulk temperature reading.
@@ -11071,6 +11088,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(fore),
 	MLXSW_REG(mtcap),
 	MLXSW_REG(mtmp),
+	MLXSW_REG(mtwe),
 	MLXSW_REG(mtbr),
 	MLXSW_REG(mcia),
 	MLXSW_REG(mpat),
-- 
2.26.2

