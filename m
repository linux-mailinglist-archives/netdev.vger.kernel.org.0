Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF4040A692
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 08:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240108AbhINGPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 02:15:48 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:42677 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237875AbhINGPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 02:15:44 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id DA15F5C00AF;
        Tue, 14 Sep 2021 02:14:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 14 Sep 2021 02:14:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=0LOJlCkefbXIul8NBM47Jo/b0rEaOZQ8jYXxAN8rq5w=; b=c3i24gIu
        WthKOrxvXI/KD5wtd0boRz5Cf6iJJVJS+H5gP9aIqovxmAZKf0wcZaPbxaJZaWao
        E4AWoihgoVUz9uVwiw+YcnffA1eqPiC1bmVgzMgXvFA2+9KfOTHLPjCDszBzid7M
        8yEkyrJNbFohKGuaPlo9AF8dSjTwS5n47a27EIWgSEeMldrAm3TrO6Y/DgAvvKEx
        1sIhOABSy0GqVCxZiUE7nVARwcUvuDPkjyiJ09PNCunuuDJUTHsEy6I4JZcwUFZ/
        waw7ko8R9T1arwQ9+Et0xGKDQtjP1dolqsDP1mz7RGzj+7k+joYSLAS9JDSkJDpK
        rUhnEi8/JqMFZA==
X-ME-Sender: <xms:wz1AYYqQhbfHOQT50k_J1e2NcHgTFdp7K0Alcd4MuKrdlt6p7Asefw>
    <xme:wz1AYeqi6FZuVAOqprdhD7cJEFc6Gi6sMJMkFoCG1BrtFTu_vuHDhmu-y9lNTL5kO
    GGk4UbG95y2HG8>
X-ME-Received: <xmr:wz1AYdPxgxaVm9h963HvzghvTtUkeegHaTGd0qihcexJLFdYVuyt1H4DyVYwMS0kjBVRvTLH-xXk7bexLExn2767EQ-_G2gsTQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudegkedguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:wz1AYf702E7FU1uPA95vTAucaiJbUh2iDJgG5_ZrPAICrdCiMLl9Dw>
    <xmx:wz1AYX5I6NhvE_GgAwE8YE7py8Xqfi7cNCNIgXnryN3qpzBMMRWjVw>
    <xmx:wz1AYfitFqVOBIICqsc8eSreQTFcdpyPEinlEbsqaSVqKH1-_SeqUQ>
    <xmx:wz1AYZnaeXBcajh_xlt90_6PPfgSsheACOmwbkm__2HO-m9msdCcAg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Sep 2021 02:14:26 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/8] mlxsw: reg: Add Port Local port to Label Port mapping Register
Date:   Tue, 14 Sep 2021 09:13:26 +0300
Message-Id: <20210914061330.226000-5-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914061330.226000-1-idosch@idosch.org>
References: <20210914061330.226000-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

The PLLP register returns the mapping from Local Port into Label Port.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 48 +++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 6fbda6ebd590..97f46c468c6d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5860,6 +5860,53 @@ static inline void mlxsw_reg_pddr_pack(char *payload, u8 local_port,
 	mlxsw_reg_pddr_page_select_set(payload, page_select);
 }
 
+/* PLLP - Port Local port to Label Port mapping Register
+ * -----------------------------------------------------
+ * The PLLP register returns the mapping from Local Port into Label Port.
+ */
+#define MLXSW_REG_PLLP_ID 0x504A
+#define MLXSW_REG_PLLP_LEN 0x10
+
+MLXSW_REG_DEFINE(pllp, MLXSW_REG_PLLP_ID, MLXSW_REG_PLLP_LEN);
+
+/* reg_pllp_local_port
+ * Local port number.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, pllp, local_port, 0x00, 16, 8);
+
+/* reg_pllp_label_port
+ * Front panel label of the port.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, pllp, label_port, 0x00, 0, 8);
+
+/* reg_pllp_split_num
+ * Label split mapping for local_port.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, pllp, split_num, 0x04, 0, 4);
+
+/* reg_pllp_slot_index
+ * Slot index (0: Main board).
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, pllp, slot_index, 0x08, 0, 4);
+
+static inline void mlxsw_reg_pllp_pack(char *payload, u8 local_port)
+{
+	MLXSW_REG_ZERO(pllp, payload);
+	mlxsw_reg_pllp_local_port_set(payload, local_port);
+}
+
+static inline void mlxsw_reg_pllp_unpack(char *payload, u8 *label_port,
+					 u8 *split_num, u8 *slot_index)
+{
+	*label_port = mlxsw_reg_pllp_label_port_get(payload);
+	*split_num = mlxsw_reg_pllp_split_num_get(payload);
+	*slot_index = mlxsw_reg_pllp_slot_index_get(payload);
+}
+
 /* PMTM - Port Module Type Mapping Register
  * ----------------------------------------
  * The PMTM allows query or configuration of module types.
@@ -12202,6 +12249,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(pplr),
 	MLXSW_REG(pmpe),
 	MLXSW_REG(pddr),
+	MLXSW_REG(pllp),
 	MLXSW_REG(pmtm),
 	MLXSW_REG(htgt),
 	MLXSW_REG(hpkt),
-- 
2.31.1

