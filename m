Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1827D420079
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 09:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbhJCHfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 03:35:47 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:56517 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229872AbhJCHfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Oct 2021 03:35:43 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 295B8580E3D;
        Sun,  3 Oct 2021 03:33:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 03 Oct 2021 03:33:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=zc8Q+43wKUcyoDL0z+m1s+vsEK7hCqxPE4CLgBiFhA8=; b=datWHOOY
        VCdWMP2PZW5gI27wbXyiLMprJNb6QVWfiuVDq1lALFNQ4YBprqRHuGyTQKHF6Dyt
        6YnxV1FlcHqMABud6X5/PG1pbfgO3d/LTJKhhUHitBiOsemJmZeni3woSInf5tMD
        E5OFZWfufG4g7D7qspQ2i4QK+LlPWkL/EVZMIc+25sXXwx5LMJ42rY2hv7Eo+NFe
        yvFQiM6NUFuA+ub/dsqFRdOzKmY94PwoyTmdpNmyHcmipvDhY00nLBWLnsf/SRLk
        UOy2jOtBS02TAx009THdpwj2NNZwpsCIdFeH8jTIPCA7zhrwnQ54braUJEUK8m0f
        k79XfsJlzQP4GQ==
X-ME-Sender: <xms:5FxZYaNdUmVEYoTeXX-Nn7B3f2IbvaRzY-mCdSwGjPNbG8ZN12SBxQ>
    <xme:5FxZYY9sbBh1EayxDrhxLr3xp1_SzNXTq1YqILoP6qNy6ClZt7MfL0hmQV9bGysJa
    JiksIJIcqnWcEU>
X-ME-Received: <xmr:5FxZYRQL59wf8eWoxzdrAnfVdb1tmXvxD4CTX6jKO3Eo-MyhwOjWfdrpG7chWicEzy3NsED8wBOHBbCwuzcUjV5inrY5rdYJcjkB2bflfUlsNA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudekledguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedunecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:5FxZYasbp3XC02bRfPwohBnzT8n9UrAHDKEKEDKtPbv9CyhmDNcJEw>
    <xmx:5FxZYScu6kKdDjNN_jI2ptF8X24fkLr8YIW3V2SGTi-njFRob22I2Q>
    <xmx:5FxZYe1MB8IStlOzCAV2dG94iVnfVP0eYY9FQwxs8o1c2fGoY1OvOA>
    <xmx:5FxZYZzgfqHcmFpSRjdznYzeocdR88tvn-sRRpUsKSEARyCGIofiTA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 3 Oct 2021 03:33:53 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/6] mlxsw: reg: Add Management Cable IO and Notifications register
Date:   Sun,  3 Oct 2021 10:32:16 +0300
Message-Id: <20211003073219.1631064-4-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211003073219.1631064-1-idosch@idosch.org>
References: <20211003073219.1631064-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add the Management Cable IO and Notifications register. It will be used
to retrieve the power mode status of a module in subsequent patches and
whether a module is present in a cage or not.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 34 +++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index bff05a0a2f7a..ed6c3356e4eb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -10402,6 +10402,39 @@ static inline void mlxsw_reg_mlcr_pack(char *payload, u8 local_port,
 					   MLXSW_REG_MLCR_DURATION_MAX : 0);
 }
 
+/* MCION - Management Cable IO and Notifications Register
+ * ------------------------------------------------------
+ * The MCION register is used to query transceiver modules' IO pins and other
+ * notifications.
+ */
+#define MLXSW_REG_MCION_ID 0x9052
+#define MLXSW_REG_MCION_LEN 0x18
+
+MLXSW_REG_DEFINE(mcion, MLXSW_REG_MCION_ID, MLXSW_REG_MCION_LEN);
+
+/* reg_mcion_module
+ * Module number.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, mcion, module, 0x00, 16, 8);
+
+enum {
+	MLXSW_REG_MCION_MODULE_STATUS_BITS_PRESENT_MASK = BIT(0),
+	MLXSW_REG_MCION_MODULE_STATUS_BITS_LOW_POWER_MASK = BIT(8),
+};
+
+/* reg_mcion_module_status_bits
+ * Module IO status as defined by SFF.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mcion, module_status_bits, 0x04, 0, 16);
+
+static inline void mlxsw_reg_mcion_pack(char *payload, u8 module)
+{
+	MLXSW_REG_ZERO(mcion, payload);
+	mlxsw_reg_mcion_module_set(payload, module);
+}
+
 /* MTPPS - Management Pulse Per Second Register
  * --------------------------------------------
  * This register provides the device PPS capabilities, configure the PPS in and
@@ -12446,6 +12479,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(mgir),
 	MLXSW_REG(mrsr),
 	MLXSW_REG(mlcr),
+	MLXSW_REG(mcion),
 	MLXSW_REG(mtpps),
 	MLXSW_REG(mtutc),
 	MLXSW_REG(mpsc),
-- 
2.31.1

