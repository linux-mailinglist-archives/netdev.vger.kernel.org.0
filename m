Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C26649D24A
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 20:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244151AbiAZTLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 14:11:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54952 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiAZTLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 14:11:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79C0D615C1
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 19:11:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90394C36AE3;
        Wed, 26 Jan 2022 19:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643224273;
        bh=qQ2cYyFbP8QkWoeTmwn9Y+fcJAeCWET6d5Rgb0+P8Js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MY5l3QrwAD5tm7khKvP4cfCocB+1Yav8xOai7ThP48qTDIhCuWasFq2TxygNIkRYB
         4S3gIa2EnhU81vChy+LlmT6wWf7WOpQQIXekMc5vAJ/wjEJ7rX7nMyuoZYvwZVJxxc
         CXapEfDmr7GV3bCDPfFk6i+1WseoUbnI2tzRjP4m5BRVIqJQN0viT6LPVuXXyAKTMz
         70JZ0Xjnv3SR4honZrvT/tL3bX7ArQU8+8fiwy6nZzztCyDr9wB0yXp1BoZb2r5qYq
         QcQWgHjPjifFk62w+hS+Wv61lBfSyGOhkyDA0T81AsvVILI2dPrsreBGyodo8yXxCu
         zwbVpqIzwHoNQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH net-next 01/15] mii: remove mii_lpa_to_linkmode_lpa_sgmii()
Date:   Wed, 26 Jan 2022 11:10:55 -0800
Message-Id: <20220126191109.2822706-2-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126191109.2822706-1-kuba@kernel.org>
References: <20220126191109.2822706-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only caller of mii_lpa_to_linkmode_lpa_sgmii()
disappeared in v5.10.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
--
CC: Vladimir Oltean <olteanv@gmail.com>
CC: Andrew Lunn <andrew@lunn.ch>
CC: Heiner Kallweit <hkallweit1@gmail.com>
CC: Russell King <linux@armlinux.org.uk>
---
 include/linux/mii.h | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/include/linux/mii.h b/include/linux/mii.h
index 12ea29e04293..b8a1a17a87dd 100644
--- a/include/linux/mii.h
+++ b/include/linux/mii.h
@@ -387,23 +387,6 @@ mii_lpa_mod_linkmode_lpa_sgmii(unsigned long *lp_advertising, u32 lpa)
 			 speed_duplex == LPA_SGMII_10FULL);
 }
 
-/**
- * mii_lpa_to_linkmode_adv_sgmii
- * @advertising: pointer to destination link mode.
- * @lpa: value of the MII_LPA register
- *
- * A small helper function that translates MII_ADVERTISE bits
- * to linkmode advertisement settings when in SGMII mode.
- * Clears the old value of advertising.
- */
-static inline void mii_lpa_to_linkmode_lpa_sgmii(unsigned long *lp_advertising,
-						 u32 lpa)
-{
-	linkmode_zero(lp_advertising);
-
-	mii_lpa_mod_linkmode_lpa_sgmii(lp_advertising, lpa);
-}
-
 /**
  * mii_adv_mod_linkmode_adv_t
  * @advertising:pointer to destination link mode.
-- 
2.34.1

