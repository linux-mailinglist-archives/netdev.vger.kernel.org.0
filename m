Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9BFFF88BD
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 07:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726978AbfKLGth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 01:49:37 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:49469 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726955AbfKLGtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 01:49:36 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 8579021EAE;
        Tue, 12 Nov 2019 01:49:35 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 12 Nov 2019 01:49:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=lwFfCoKMm8wGod0vCtoyj+wM4H0TE3HchN6+/LTnEaE=; b=Rjl1ynjw
        TdHxT4XrbvekBHoKh7hc/V7U2TzJmapZcFaqXjP3D665sFkWTWGGzcDknDcVYJD6
        UzJpaFaCS7T0oCI/91D76SoEtFCuYUI0853BoewAsruB4zZQI9Pl2md9ws/8uSmk
        +KP7rXCIYLBT+eLKa1ZY/p6l3z6yA6Jfz5O+N51IrzkJxpDV7wiqsDHHmX35X4ju
        aZTUjkxmXkil9wst4t3/n292L0Afkur7BEcd2MwUdGVav7eJeoY4PsxWMc7xx4Gh
        xHU47YIVP00u9GP0m9+bKqQeqULXqZn5UBdxxZKSipW+SzHuWYNFU4Pi1O4bO3E9
        1m0IJKrpBl6GRw==
X-ME-Sender: <xms:_1XKXdPh5-0HgR-QwCIQGMJL1QJYJApk8ezYnpgzXhUn46I2Q9ilBg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddvkedggeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeef
X-ME-Proxy: <xmx:_1XKXbxY6XUxOrOEQ22kaxP9eazZH8IuLMkscZiSx9nQncv6721hwQ>
    <xmx:_1XKXSvUysqBsNlbtzcPp_m5JDdvVIQebV7825TMPp8w65S_SHcq9w>
    <xmx:_1XKXWb9yQgajW3m4uY35HJici16Lkm0_VHvnMNW6kNx8ss0CNzTxA>
    <xmx:_1XKXUTLUwdCs0POn826-wHNbtKfCGCf-KnRnJEk00eCXDsKxjbLfw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 085D180059;
        Tue, 12 Nov 2019 01:49:33 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        jakub.kicinski@netronome.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 4/7] mlxsw: core: Add support for EMAD string TLV parsing
Date:   Tue, 12 Nov 2019 08:48:27 +0200
Message-Id: <20191112064830.27002-5-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191112064830.27002-1-idosch@idosch.org>
References: <20191112064830.27002-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shalom Toledo <shalomt@mellanox.com>

During parsing of incoming EMADs, fill the string TLV's offset when it is
used.

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index a50a36f9584b..d834bdc632ef 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -382,17 +382,32 @@ static void mlxsw_emad_construct(struct sk_buff *skb,
 
 struct mlxsw_emad_tlv_offsets {
 	u16 op_tlv;
+	u16 string_tlv;
 	u16 reg_tlv;
 };
 
+static bool mlxsw_emad_tlv_is_string_tlv(const char *tlv)
+{
+	u8 tlv_type = mlxsw_emad_string_tlv_type_get(tlv);
+
+	return tlv_type == MLXSW_EMAD_TLV_TYPE_STRING;
+}
+
 static void mlxsw_emad_tlv_parse(struct sk_buff *skb)
 {
 	struct mlxsw_emad_tlv_offsets *offsets =
 		(struct mlxsw_emad_tlv_offsets *) skb->cb;
 
 	offsets->op_tlv = MLXSW_EMAD_ETH_HDR_LEN;
+	offsets->string_tlv = 0;
 	offsets->reg_tlv = MLXSW_EMAD_ETH_HDR_LEN +
 			   MLXSW_EMAD_OP_TLV_LEN * sizeof(u32);
+
+	/* If string TLV is present, it must come after the operation TLV. */
+	if (mlxsw_emad_tlv_is_string_tlv(skb->data + offsets->reg_tlv)) {
+		offsets->string_tlv = offsets->reg_tlv;
+		offsets->reg_tlv += MLXSW_EMAD_STRING_TLV_LEN * sizeof(u32);
+	}
 }
 
 static char *mlxsw_emad_op_tlv(const struct sk_buff *skb)
-- 
2.21.0

