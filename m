Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1A53F087B
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 17:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240208AbhHRPxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 11:53:24 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:51357 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240164AbhHRPxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 11:53:19 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 7D5E2582FD7;
        Wed, 18 Aug 2021 11:52:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 18 Aug 2021 11:52:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=yO1RD8/gY9S4VnN9Syc09wFicjFOX2UT78DT1b33Ol8=; b=agwg2wrJ
        jQlCvarlkD8uR8TRXbMlXQ8iUEgbI7ZZcxVobK9K/SR/x9zDmYNQWVOMI+PZdt1f
        w4Zn0qxlZcUQ/JYBWHf5Tj/+S2TY6iJUyxH0BQOvQT69CpnanspseFYoGaPs7Onn
        PB1vsL0ITrmk8Ka/CyWaEH78haaJX5uD8QHqylQskF6M0vraRXRyGejWEeuCPdqU
        ATIFfgrFbFviTBuMTZY1JJh1Dx9+CQOa8U3DbEFa5xJQjiCqSLrhReMaTJlWRt08
        vBqyYgSZfTnnhlVcYlE70RAik26Yu1ejtxdI6vHmblEPRoiQt1n0pDVQYJHOugh0
        BsJmnxIZwOM2wA==
X-ME-Sender: <xms:yywdYVX4cUVWJiiNB-iKTfD9o6YJEuOg1B38Z50PRdsUpKlVT06ygQ>
    <xme:yywdYVk29eKdpLDKfkpjFwduwuD_taqRs8PDbDGskIjT3AWgqtwJyJn1rW-c_TNB3
    U-VEWPCFA-rTOU>
X-ME-Received: <xmr:yywdYRZyqDC_PkbXXBNzhh5Ik_5V7yJbFnSZvjZ-A0U04MpCqRae5YbC5HN4J5Gu8J5guMDOvDDsnu3vdDzUtQUOneoUft7mQ9pigZYgF5077A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrleehgdelvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:yywdYYXDY5MNQpEzw8DbZqaDolCV7QuzyShG4NcHmtXSFock7J98tw>
    <xmx:yywdYfmBAzT9mSnfkvj615iaNP66_2uIlRNFhjX-63zyJMhvLHuWNA>
    <xmx:yywdYVeptozHEseviSccpW2kD_pUkxaFd27Yxo2sVj9aZ78KsPaq7Q>
    <xmx:zCwdYR4MUNX8vc2BuRONUDsGc-rspDDsOBrJE-oiaAd-yEvnKe3VBw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 18 Aug 2021 11:52:40 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next v2 2/6] mlxsw: reg: Add Port Module Memory Map Properties register
Date:   Wed, 18 Aug 2021 18:51:58 +0300
Message-Id: <20210818155202.1278177-3-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210818155202.1278177-1-idosch@idosch.org>
References: <20210818155202.1278177-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add the Port Module Memory Map Properties register. It will be used to
set the power mode of a module in subsequent patches.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 44 +++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 16092a1f68bb..e30e6d3482f6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5883,6 +5883,49 @@ static inline void mlxsw_reg_pddr_pack(char *payload, u8 local_port,
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
@@ -12225,6 +12268,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(pplr),
 	MLXSW_REG(pmpe),
 	MLXSW_REG(pddr),
+	MLXSW_REG(pmmp),
 	MLXSW_REG(pmtm),
 	MLXSW_REG(htgt),
 	MLXSW_REG(hpkt),
-- 
2.31.1

