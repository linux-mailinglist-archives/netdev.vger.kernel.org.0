Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2E883B8A6A
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 00:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233727AbhF3WZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 18:25:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:56352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233336AbhF3WZO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 18:25:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C00446147E;
        Wed, 30 Jun 2021 22:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625091764;
        bh=4uWCrW7McsS6Rg1FgUC+m+llNKgmulxnudse+VqZFd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lKPl4KrU7uA1GDJIZkVOadMybqLWVoxnVKjC6HPT/Q2nMPQZmbSy2Yo3DydbP00MV
         ydmUIIWq+WW7EVBfvYQHEUCPcU33bt/TUxjZujzMJULrke/xTEbLpu+Dy1b4dzAYPT
         08dYBwygAmoLnZZLojRq9u/OBve/h2A/EOs7A/MkY5tWMChQDPhDhfM6hLCp6tMu0V
         up3TQsjw+HcOkXDLKqbLFbShx3ytvG+oBc5zxVbRoVqFMSiXTp/ehZ4SRjyPDfjmMc
         5adBJSxyFgcI9zP0WDKmu+P2F7GGezssR5oyZpwYoIcTcTWiL6scHdSuaDihD1DdDv
         w1wzfLMYAy+og==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net v2 6/6] net: dsa: mv88e6xxx: enable SerDes PCS register dump via ethtool -d on Topaz
Date:   Thu,  1 Jul 2021 00:22:31 +0200
Message-Id: <20210630222231.2297-7-kabel@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210630222231.2297-1-kabel@kernel.org>
References: <20210630222231.2297-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit bf3504cea7d7e ("net: dsa: mv88e6xxx: Add 6390 family PCS
registers to ethtool -d") added support for dumping SerDes PCS registers
via ethtool -d for Peridot.

The same implementation is also valid for Topaz, but was not
enabled at the time.

Signed-off-by: Marek Behún <kabel@kernel.org>
Fixes: bf3504cea7d7e ("net: dsa: mv88e6xxx: Add 6390 family PCS registers to ethtool -d")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 1e95a0facbd4..beb41572d04e 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3626,6 +3626,8 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.serdes_get_sset_count = mv88e6390_serdes_get_sset_count,
 	.serdes_get_strings = mv88e6390_serdes_get_strings,
 	.serdes_get_stats = mv88e6390_serdes_get_stats,
+	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
+	.serdes_get_regs = mv88e6390_serdes_get_regs,
 	.phylink_validate = mv88e6341_phylink_validate,
 };
 
@@ -4435,6 +4437,8 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.serdes_get_sset_count = mv88e6390_serdes_get_sset_count,
 	.serdes_get_strings = mv88e6390_serdes_get_strings,
 	.serdes_get_stats = mv88e6390_serdes_get_stats,
+	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
+	.serdes_get_regs = mv88e6390_serdes_get_regs,
 	.phylink_validate = mv88e6341_phylink_validate,
 };
 
-- 
2.31.1

