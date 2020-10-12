Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A11FE28C0FA
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 21:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391633AbgJLTIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 15:08:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:52510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390548AbgJLTD0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 15:03:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDCC2221EB;
        Mon, 12 Oct 2020 19:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602529400;
        bh=jo2Y3XhqQPp30WQEqhZBXmg+qDWrXbP3ry7sxWeq1L8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QUBNUX8J6ORYpMuUMBJJvTh6vaV/ZeDTUnOKD2/hCuaNFsQBCAHj03kTqkFR+SM+z
         20xX4OzdWEuJVe2pEbGsRxpMIs7LEgDTBWeToaMF8TQcpr37C2j6pLybBbMTtgefqX
         3aYIRT4h43TiT4xBnqYvg2Sq0awFuONjqBjdFNNw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 05/15] net: mscc: ocelot: fix fields offset in SG_CONFIG_REG_3
Date:   Mon, 12 Oct 2020 15:03:02 -0400
Message-Id: <20201012190313.3279397-5-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201012190313.3279397-1-sashal@kernel.org>
References: <20201012190313.3279397-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>

[ Upstream commit 4ab810a4e04ab6c851007033d39c13e6d3f55110 ]

INIT_IPS and GATE_ENABLE fields have a wrong offset in SG_CONFIG_REG_3.
This register is used by stream gate control of PSFP, and it has not
been used before, because PSFP is not implemented in ocelot driver.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot_ana.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_ana.h b/drivers/net/ethernet/mscc/ocelot_ana.h
index 841c6ec22b641..1669481d97794 100644
--- a/drivers/net/ethernet/mscc/ocelot_ana.h
+++ b/drivers/net/ethernet/mscc/ocelot_ana.h
@@ -252,10 +252,10 @@
 #define ANA_SG_CONFIG_REG_3_LIST_LENGTH_M                 GENMASK(18, 16)
 #define ANA_SG_CONFIG_REG_3_LIST_LENGTH_X(x)              (((x) & GENMASK(18, 16)) >> 16)
 #define ANA_SG_CONFIG_REG_3_GATE_ENABLE                   BIT(20)
-#define ANA_SG_CONFIG_REG_3_INIT_IPS(x)                   (((x) << 24) & GENMASK(27, 24))
-#define ANA_SG_CONFIG_REG_3_INIT_IPS_M                    GENMASK(27, 24)
-#define ANA_SG_CONFIG_REG_3_INIT_IPS_X(x)                 (((x) & GENMASK(27, 24)) >> 24)
-#define ANA_SG_CONFIG_REG_3_INIT_GATE_STATE               BIT(28)
+#define ANA_SG_CONFIG_REG_3_INIT_IPS(x)                   (((x) << 21) & GENMASK(24, 21))
+#define ANA_SG_CONFIG_REG_3_INIT_IPS_M                    GENMASK(24, 21)
+#define ANA_SG_CONFIG_REG_3_INIT_IPS_X(x)                 (((x) & GENMASK(24, 21)) >> 21)
+#define ANA_SG_CONFIG_REG_3_INIT_GATE_STATE               BIT(25)
 
 #define ANA_SG_GCL_GS_CONFIG_RSZ                          0x4
 
-- 
2.25.1

