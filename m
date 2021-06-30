Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD03C3B87E2
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 19:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbhF3Rpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 13:45:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232971AbhF3Rpr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 13:45:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CE5C6147E;
        Wed, 30 Jun 2021 17:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625074998;
        bh=ShxbbGzNPnQd4E6L1XB7BPE5uzTV5xLXWOEaNJk8mN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KSeJKfGcYfR+zV+ooXu4esQugd5gHt7EROf30dhYk7qpKihM+sKHgfZEjyBkc/bJd
         LuVcarkxmmLlL3KeTIAlR5yTyZR9Q/MrOfbbI7A8872owbhlmW9qOGHNW+GUYQWilD
         kxxfKsgTvpQK80iHP+7wn666kvJyKSUZ4KJEWEloPjy6oHLw6dqEvZxaOMIMWWlWid
         ussL9Bn8+EVeWjJBSoD8G5y5b9QG+fnQSYoY70bgvUMZ17fvWjhSrUNgT0YdAkhiIV
         poNRRuv1BC1TSvGM6+aSg1EQc/enOCAKroWbD7ZscPgp9l/m0l0xXDmlccZmK49dez
         ItF4pFLMXPJ6g==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net 4/6] net: dsa: mv88e6xxx: enable devlink ATU hash param for Topaz
Date:   Wed, 30 Jun 2021 19:43:06 +0200
Message-Id: <20210630174308.31831-5-kabel@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210630174308.31831-1-kabel@kernel.org>
References: <20210630174308.31831-1-kabel@kernel.org>
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

