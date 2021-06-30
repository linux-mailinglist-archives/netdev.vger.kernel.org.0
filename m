Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69D543B87E4
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 19:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233052AbhF3Rp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 13:45:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:58784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232982AbhF3Rpu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 13:45:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D05261492;
        Wed, 30 Jun 2021 17:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625075001;
        bh=EVOuX2FKsnVIMhfxrq3t90W3JWqNi2iI26XH+tp0QRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E7TFlNy0Vw1VadLXVXmojJZjg/0gmcMABrHH21+TOjrwQK9zBmvYfWJEPZ/2J3DEt
         Nuo04MiPhswelr9QSkl6r6bSa43QdVaTdX7g+7LrpNCop/i4AFrt+ysfKL5QWWq2Rz
         ZHZr4vLVUWAf3tlNFQ8mRY5Vqn7PDsEIrYSOk8Qcro1IskHbGHnKC1PiNz4IxZVzNf
         cCwfG01FUL15a2Aj8+JuI6d81dDH5dnoa3d4NURK8owovFzFrYGWGiWALHoNGEZwUs
         wPldkLh2BB1HRZFLyYePst5MK4S3YEbNSlW9idmvrp6127WSs6HXs2bzeaAmnXAIWj
         oVvbPcTjXCF4g==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net 6/6] net: dsa: mv88e6xxx: enable SerDes PCS register dump via ethtool -d on Topaz
Date:   Wed, 30 Jun 2021 19:43:08 +0200
Message-Id: <20210630174308.31831-7-kabel@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210630174308.31831-1-kabel@kernel.org>
References: <20210630174308.31831-1-kabel@kernel.org>
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

