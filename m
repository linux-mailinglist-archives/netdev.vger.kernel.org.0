Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F10C73B8A68
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 00:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233484AbhF3WZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 18:25:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:56294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233131AbhF3WZL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 18:25:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFF8661476;
        Wed, 30 Jun 2021 22:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625091761;
        bh=shjbxzD13k4eSgUBRrDrOkxybGaiYTT/RZAYeK1hRCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GazN6VDy8A0uOXihZoI+5etmFpIWzpb+F9iBYoN+f/3UzYy/bvAPQJa6aOggZAwfD
         uou3BHHbs9G2/rqkXg1QOphhFiIUIJDtYbP8TimNNzKip82e/cAKKzuaaFGIu2bRGt
         w9Qlr8v6Q15iOMlhhrFfMwW6D6wdMtGC5BYsCBa5+48t2jm/B6RwpKDk6d5TFj+r/P
         V0Bmyo6+uO86Rp6KZPX03Zfa6ZJnsNvRGvMRaygIh0s6dzdrkqVJrDm2brv97QYn33
         bRMn1nBmWC+m7ZPTx0okLyn1gS4ZHvQYV9M005RPvhCPDubOU/9yyWedLqFQ6NEQCg
         D0leHhzRxxDYQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net v2 4/6] net: dsa: mv88e6xxx: enable devlink ATU hash param for Topaz
Date:   Thu,  1 Jul 2021 00:22:29 +0200
Message-Id: <20210630222231.2297-5-kabel@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210630222231.2297-1-kabel@kernel.org>
References: <20210630222231.2297-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 23e8b470c7788 ("net: dsa: mv88e6xxx: Add devlink param for ATU
hash algorithm.") introduced ATU hash algorithm access via devlink, but
did not enable it for Topaz.

Enable this feature also for Topaz.

Signed-off-by: Marek Behún <kabel@kernel.org>
Fixes: 23e8b470c7788 ("net: dsa: mv88e6xxx: Add devlink param for ATU hash algorithm.")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index d4b05c10e5f2..354ff0b84b7f 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3608,6 +3608,8 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
@@ -4410,6 +4412,8 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
-- 
2.31.1

