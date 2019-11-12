Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 658B3F88BC
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 07:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfKLGtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 01:49:36 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:37917 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725283AbfKLGte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 01:49:34 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 12CCE220E7;
        Tue, 12 Nov 2019 01:49:34 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 12 Nov 2019 01:49:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=b2Eahe3eQP1d8QEPRzy70iVnWwmndYTBugbCigCcTjk=; b=B6/SlVYp
        vB6j1km/zxuUV/gnNuAsmRcpaxLmfqs4ILhVV6e6L4UiBKCrCst2ocJRwTBVdcpW
        SBwl494OAcVbxdDP9LfY6OE4sDKLDXHtEds9lSFsS4aX7XQ2gXKNBIFvySgQ5kjY
        h8OJg/PTcRmLdAQ3hBspAJdhbM17YBAvKASpgVJomNAm+MZkbGhGQP7LjoL3bdt5
        Iq+IXqJkObvMFS9jeoUEmDtDJmRIQ1d0l6wznIGslJzN4r2ONFs/y+hp+7YUOmSH
        cPC4k3i6DnWWW4+OV73uMlL/XoQQnNDhAgMSxcYlZOXDIYBTgKwcVTHS3B/HiNFX
        O+gzlGybj/ITsQ==
X-ME-Sender: <xms:_VXKXV-VeKtyeCn_cFDhu4tSAJZ6rez-4og02dm3VcVRHRYcwYwCDQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddvkedggeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:_VXKXYPgCK45ehVnY-RsYsSaWZhubsPFl-iGBjojPAy9KnpidP6UoQ>
    <xmx:_VXKXbY_Nw_KNeLnG91-4QfaVIvyF8w43_tjtnzSDZefKNFfl4NpHw>
    <xmx:_VXKXbS4zgyCXDXqU1Da56vXMzHAj29TqTOggxzcACvQa9qYGEpY9Q>
    <xmx:_lXKXZRjweRBM2yw8H8-lp7_j2Yp0pXbec1qtd1Haej_MzdqS3ouAw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 71E7680068;
        Tue, 12 Nov 2019 01:49:32 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        jakub.kicinski@netronome.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 3/7] mlxsw: core: Add EMAD string TLV
Date:   Tue, 12 Nov 2019 08:48:26 +0200
Message-Id: <20191112064830.27002-4-idosch@idosch.org>
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

Add EMAD string TLV, an ASCII string the driver can receive from the
firmware in case of an error.

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 19 +++++++++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/emad.h |  6 +++++-
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 698c7bcb1aad..a50a36f9584b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -249,6 +249,25 @@ MLXSW_ITEM32(emad, op_tlv, class, 0x04, 0, 8);
  */
 MLXSW_ITEM64(emad, op_tlv, tid, 0x08, 0, 64);
 
+/* emad_string_tlv_type
+ * Type of the TLV.
+ * Must be set to 0x2 (string TLV).
+ */
+MLXSW_ITEM32(emad, string_tlv, type, 0x00, 27, 5);
+
+/* emad_string_tlv_len
+ * Length of the string TLV in u32.
+ */
+MLXSW_ITEM32(emad, string_tlv, len, 0x00, 16, 11);
+
+#define MLXSW_EMAD_STRING_TLV_STRING_LEN 128
+
+/* emad_string_tlv_string
+ * String provided by the device's firmware in case of erroneous register access
+ */
+MLXSW_ITEM_BUF(emad, string_tlv, string, 0x04,
+	       MLXSW_EMAD_STRING_TLV_STRING_LEN);
+
 /* emad_reg_tlv_type
  * Type of the TLV.
  * Must be set to 0x3 (register TLV).
diff --git a/drivers/net/ethernet/mellanox/mlxsw/emad.h b/drivers/net/ethernet/mellanox/mlxsw/emad.h
index 5d7c78419fa7..acfbbec52424 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/emad.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/emad.h
@@ -19,7 +19,8 @@
 enum {
 	MLXSW_EMAD_TLV_TYPE_END,
 	MLXSW_EMAD_TLV_TYPE_OP,
-	MLXSW_EMAD_TLV_TYPE_REG = 0x3,
+	MLXSW_EMAD_TLV_TYPE_STRING,
+	MLXSW_EMAD_TLV_TYPE_REG,
 };
 
 /* OP TLV */
@@ -86,6 +87,9 @@ enum {
 	MLXSW_EMAD_OP_TLV_METHOD_EVENT = 5,
 };
 
+/* STRING TLV */
+#define MLXSW_EMAD_STRING_TLV_LEN 33	/* Length in u32 */
+
 /* END TLV */
 #define MLXSW_EMAD_END_TLV_LEN 1	/* Length in u32 */
 
-- 
2.21.0

