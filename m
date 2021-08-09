Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4CC3E43D9
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 12:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234412AbhHIKXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 06:23:06 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40699 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234597AbhHIKWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 06:22:52 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id BC05A5C00E7;
        Mon,  9 Aug 2021 06:22:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 09 Aug 2021 06:22:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=nO9kRBp2X0GUH0GXIeBd+0FGgjAX3QvpoASO+AyL5ng=; b=j+Iwa422
        QRDRAe22WOxgn9s82g6TC7kmOY6ojujeXabG9nNGM1lM7DKbgmEkbZhRyWfXiqsB
        mhe0OlD3BLUVSQAgvEeGbz/TJaqaazS/HffuQJx83+tTGJaMtcFPdxQYXws7yZ75
        37asWrr9dYpJ3speZKvhZcdewwHQJiSmEHqVdkVwhtHzTlCeyMscC/WJRzDSSHND
        ZFbFMessikMnyrjmtU8B7NfG4zp9HXL/FOnsFN+GGpjdhCtt4ln4PiBJIssn1N8N
        mZT1LMlfUkmAk/MfbhrqmIOyggeuUoZvKNUeHQcScNxLy65tvzE+DYTtdXQ72XuF
        X2lXdGIaguGW3A==
X-ME-Sender: <xms:5wERYTxpFU2qGfpw6LVYy3I0tYJFOd5ahVClTGGp5BC5SxdEuS_ZSw>
    <xme:5wERYbTS72GcQwh9bJ0n6tGqD4r9vLULCmC592-PCVBDMXUfUqcKnV4oD3arswN7-
    ugKdMW1NzCdC4M>
X-ME-Received: <xmr:5wERYdXGundi6bA3EnWmDH1NNlHtPT-yuWHmQYy7BZTlzavGLTG8y6BG4zf1MrftzYrF12E19-hFuq0rCiFjxgIoMqqS3FlQkPIk_cSxE3dvkQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrjeejgddvkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:5wERYdhyaRCowemVEJarySd01l1USeVy_1fRq1m9hLQ1NLRmoyVNFw>
    <xmx:5wERYVC6dyVnRbG4ICNUZFLY4DCc9jGPKVqdtu2AG07nWtwq69fSgA>
    <xmx:5wERYWLQBCh7dh08n1iATBrjQ64y3b0Hur-SKCSrcQSR-pGjXcHrmA>
    <xmx:5wERYX2V35ddmGP_nmaIrJ9Sr6cuWYUqN67UCZwI5LBHTKXuUyxSEA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 Aug 2021 06:22:28 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 6/8] mlxsw: reg: Add Management Cable IO and Notifications register
Date:   Mon,  9 Aug 2021 13:21:50 +0300
Message-Id: <20210809102152.719961-7-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210809102152.719961-1-idosch@idosch.org>
References: <20210809102152.719961-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add the Management Cable IO and Notifications register. It will be used
to retrieve the low power mode status of a module in subsequent patches.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 33 +++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 7808b308e7af..d25ca5f714f4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -10306,6 +10306,38 @@ static inline void mlxsw_reg_mlcr_pack(char *payload, u8 local_port,
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
@@ -12348,6 +12380,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(mgir),
 	MLXSW_REG(mrsr),
 	MLXSW_REG(mlcr),
+	MLXSW_REG(mcion),
 	MLXSW_REG(mtpps),
 	MLXSW_REG(mtutc),
 	MLXSW_REG(mpsc),
-- 
2.31.1

