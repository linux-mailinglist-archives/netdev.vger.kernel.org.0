Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 338453E43D7
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 12:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234342AbhHIKXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 06:23:00 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:55951 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234478AbhHIKWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 06:22:49 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 925CE5C00DB;
        Mon,  9 Aug 2021 06:22:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 09 Aug 2021 06:22:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=l9YGg2Yfk86TixqcGojB4/U6R6PGKzckUIyCiOSaVEo=; b=s7eloP7B
        IOARDJydjE5lUlHDMLuIsDtCmNz3NsoSQdVVbSx2g6QQ5abNMHSHj4go88+/pAJq
        ySabZU35TIvZfaW9i7olZhQ0iCynW43eg7FZiGvUBG5FwBHc8f95EFFHMeysDeHR
        K1ZvlFR6oZUDDt3/KEKHblelHMwcAB04rhn3wc0z06/6rtBXlgd4RZn8H8cX5Ca8
        f7c42BFKaMs90UaxrP1KdMOTk/VTnxGnNE3mQ/MGFo2l7hJLj0xhx4oEOg3P1R6N
        Qi1V3LuhWR5Ae8RN+5OwKHuHf2mNo8uTkdD84sbLr133hkpk5Xvexxl4esHPgHCv
        TnPtlwewOehWpg==
X-ME-Sender: <xms:5AERYQoutYNvpr5zNwfjQhLwU8TQ-44TfiqliCiliS3bhPEBIBjMCw>
    <xme:5AERYWqyr0AmTX5l26A4m_UIA76bnNImM3Q8DQyCB6693fg8SKYKYV6jxzOZiFKMy
    e6XH-O__ofDUHY>
X-ME-Received: <xmr:5AERYVOLMsLdD7jrMhpdA8ogNT6_agV6kddv2EiR_8YqQwmI5h-YcJY-zxih9KZS5Vn9BLYjl53y76MIyyHa3UXcjfNXk2Y5_6b5pRpmQC77Hg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrjeejgddvkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:5AERYX5QGcj4Uf3csrvNhLTQXlz3CfO2hbPm47k71y-0fqv7hXkyIw>
    <xmx:5AERYf49hKVSvQi1rekPBlPuXLr72Vu67-iXbEiE-7zTjgp6zXBZWw>
    <xmx:5AERYXg1DzQspPKLZ8H9lGB4FtkmiaOzOkLfKt6n1wFh3gWHxR8i7Q>
    <xmx:5AERYcspUiN1ISB4qfzVXSwyHOaWpN5pxN9JDnFUmUKNCZzTxQ5eNA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 Aug 2021 06:22:26 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 5/8] mlxsw: reg: Add Port Module Memory Map Properties register
Date:   Mon,  9 Aug 2021 13:21:49 +0300
Message-Id: <20210809102152.719961-6-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210809102152.719961-1-idosch@idosch.org>
References: <20210809102152.719961-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add the Port Module Memory Map Properties register. It will be used to
force a module into low power mode in subsequent patches.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 44 +++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index d0361f60d70d..7808b308e7af 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5915,6 +5915,49 @@ static inline void mlxsw_reg_pddr_pack(char *payload, u8 local_port,
 	mlxsw_reg_pddr_page_select_set(payload, page_select);
 }
 
+/* PMMP - Port Module Memory Map Properties Register
+ * -------------------------------------------------
+ * The PMMP register allows to override the module memory map advertisement.
+ * The register can only be set when the module is disabled by PMAOS register.
+ */
+#define MLXSW_REG_PMMP_ID 0x5044
+#define MLXSW_REG_PMMP_LEN 0x2C
+
+MLXSW_REG_DEFINE(pmmp, MLXSW_REG_PMMP_ID, MLXSW_REG_PMMP_LEN);
+
+/* reg_pmmp_module
+ * Module number.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, pmmp, module, 0x00, 16, 8);
+
+/* reg_pmmp_eeprom_override_mask
+ * Write mask bit (negative polarity).
+ * 0 - Allow write
+ * 1 - Ignore write
+ * On write, indicates which of the bits from eeprom_override field are
+ * updated.
+ * Access: WO
+ */
+MLXSW_ITEM32(reg, pmmp, eeprom_override_mask, 0x04, 16, 16);
+
+enum {
+	/* Set module to low power mode */
+	MLXSW_REG_PMMP_EEPROM_OVERRIDE_LOW_POWER_MASK = BIT(8),
+};
+
+/* reg_pmmp_eeprom_override
+ * Override / ignore EEPROM advertisement properties bitmask
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, pmmp, eeprom_override, 0x04, 0, 16);
+
+static inline void mlxsw_reg_pmmp_pack(char *payload, u8 module)
+{
+	MLXSW_REG_ZERO(pmmp, payload);
+	mlxsw_reg_pmmp_module_set(payload, module);
+}
+
 /* PMTM - Port Module Type Mapping Register
  * ----------------------------------------
  * The PMTM allows query or configuration of module types.
@@ -12257,6 +12300,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(pplr),
 	MLXSW_REG(pmpe),
 	MLXSW_REG(pddr),
+	MLXSW_REG(pmmp),
 	MLXSW_REG(pmtm),
 	MLXSW_REG(htgt),
 	MLXSW_REG(hpkt),
-- 
2.31.1

