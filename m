Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4DE4CE124
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 14:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbfJGMDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 08:03:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47000 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727490AbfJGMDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 08:03:12 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iHRjI-0000kj-96; Mon, 07 Oct 2019 12:03:08 +0000
From:   Colin King <colin.king@canonical.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: phy: mscc: make arrays static, makes object smaller
Date:   Mon,  7 Oct 2019 13:03:08 +0100
Message-Id: <20191007120308.2392-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate const arrays on the stack but instead make them
static. Makes the object code smaller by 1058 bytes.

Before:
   text	   data	    bss	    dec	    hex	filename
  29879	   6144	      0	  36023	   8cb7	drivers/net/phy/mscc.o

After:
   text	   data	    bss	    dec	    hex	filename
  28437	   6528	      0	  34965	   8895	drivers/net/phy/mscc.o

(gcc version 9.2.1, amd64)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/phy/mscc.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/mscc.c b/drivers/net/phy/mscc.c
index 7ada1fd9ca71..805cda3465d7 100644
--- a/drivers/net/phy/mscc.c
+++ b/drivers/net/phy/mscc.c
@@ -895,7 +895,7 @@ static void vsc85xx_tr_write(struct phy_device *phydev, u16 addr, u32 val)
 static int vsc8531_pre_init_seq_set(struct phy_device *phydev)
 {
 	int rc;
-	const struct reg_val init_seq[] = {
+	static const struct reg_val init_seq[] = {
 		{0x0f90, 0x00688980},
 		{0x0696, 0x00000003},
 		{0x07fa, 0x0050100f},
@@ -939,7 +939,7 @@ static int vsc8531_pre_init_seq_set(struct phy_device *phydev)
 
 static int vsc85xx_eee_init_seq_set(struct phy_device *phydev)
 {
-	const struct reg_val init_eee[] = {
+	static const struct reg_val init_eee[] = {
 		{0x0f82, 0x0012b00a},
 		{0x1686, 0x00000004},
 		{0x168c, 0x00d2c46f},
@@ -1224,7 +1224,7 @@ static bool vsc8574_is_serdes_init(struct phy_device *phydev)
 /* bus->mdio_lock should be locked when using this function */
 static int vsc8574_config_pre_init(struct phy_device *phydev)
 {
-	const struct reg_val pre_init1[] = {
+	static const struct reg_val pre_init1[] = {
 		{0x0fae, 0x000401bd},
 		{0x0fac, 0x000f000f},
 		{0x17a0, 0x00a0f147},
@@ -1272,7 +1272,7 @@ static int vsc8574_config_pre_init(struct phy_device *phydev)
 		{0x0fee, 0x0004a6a1},
 		{0x0ffe, 0x00b01807},
 	};
-	const struct reg_val pre_init2[] = {
+	static const struct reg_val pre_init2[] = {
 		{0x0486, 0x0008a518},
 		{0x0488, 0x006dc696},
 		{0x048a, 0x00000912},
@@ -1427,7 +1427,7 @@ static int vsc8574_config_pre_init(struct phy_device *phydev)
 /* bus->mdio_lock should be locked when using this function */
 static int vsc8584_config_pre_init(struct phy_device *phydev)
 {
-	const struct reg_val pre_init1[] = {
+	static const struct reg_val pre_init1[] = {
 		{0x07fa, 0x0050100f},
 		{0x1688, 0x00049f81},
 		{0x0f90, 0x00688980},
@@ -1451,7 +1451,7 @@ static int vsc8584_config_pre_init(struct phy_device *phydev)
 		{0x16b2, 0x00007000},
 		{0x16b4, 0x00000814},
 	};
-	const struct reg_val pre_init2[] = {
+	static const struct reg_val pre_init2[] = {
 		{0x0486, 0x0008a518},
 		{0x0488, 0x006dc696},
 		{0x048a, 0x00000912},
@@ -1786,7 +1786,7 @@ static int vsc8514_config_pre_init(struct phy_device *phydev)
 	 * values to handle hardware performance of PHY. They
 	 * are set at Power-On state and remain until PHY Reset.
 	 */
-	const struct reg_val pre_init1[] = {
+	static const struct reg_val pre_init1[] = {
 		{0x0f90, 0x00688980},
 		{0x0786, 0x00000003},
 		{0x07fa, 0x0050100f},
-- 
2.20.1

