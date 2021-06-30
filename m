Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B97AD3B87E1
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 19:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbhF3Rpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 13:45:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232951AbhF3Rpq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 13:45:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFA6D61492;
        Wed, 30 Jun 2021 17:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625074996;
        bh=jjpwq4DiiV6Tw0TiAqoVFXVJkJWEmOyQDm/HuzSo0os=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XCnuwptzGITPeg09IKspTZXZvam4LnieS2ASxZlZPiJWvG/9wkrerL8ZhHKQpeDny
         mGpObzOmr1c8RYx22wiVT9yaSQlyDUfbak4uj4mJDLPJ/Me3QKWLFdiN45fRzkxb0U
         l0UaHO1lB/Fv9GYCGvrevF6mvOSpo9l7BOr3ZBCq3gQEigbhCwxoc3mYgodW9+fcrk
         OYcDZ3LDBm2eH/opYotdtaOD6kIT1vdJcasCIJy0l50LxuCS2p8JBH/y/Jpmp/r1a5
         GmW+ulS0ZX8DxwmcEzxiPRDE1N1ete+VXFcFrqi1y+mIFelRhihx4Lexfj2Or2mzmR
         oJKHkpWQto56g==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net 3/6] net: dsa: mv88e6xxx: enable .rmu_disable() on Topaz
Date:   Wed, 30 Jun 2021 19:43:05 +0200
Message-Id: <20210630174308.31831-4-kabel@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210630174308.31831-1-kabel@kernel.org>
References: <20210630174308.31831-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 9e5baf9b36367 ("net: dsa: mv88e6xxx: add RMU disable op")
introduced .rmu_disable() method with implementation for several models,
but forgot to add Topaz, which can use the Peridot implementation.

Use the Peridot implementation of .rmu_disable() on Topaz.

Signed-off-by: Marek Behún <kabel@kernel.org>
Fixes: 9e5baf9b36367 ("net: dsa: mv88e6xxx: add RMU disable op")
---
 drivers/net/dsa/mv88e6xxx/chip.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index b125d3227dbd..d4b05c10e5f2 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3607,6 +3607,7 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.mgmt_rsvd2cpu =  mv88e6390_g1_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
+	.rmu_disable = mv88e6390_g1_rmu_disable,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
@@ -4408,6 +4409,7 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.mgmt_rsvd2cpu =  mv88e6390_g1_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
+	.rmu_disable = mv88e6390_g1_rmu_disable,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
-- 
2.31.1

