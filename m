Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F2227B9EC
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 03:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbgI2BeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 21:34:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727677AbgI2Bbl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 21:31:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77BDA2080A;
        Tue, 29 Sep 2020 01:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601343094;
        bh=PEntYgy3zPKWLs6qDtTuYLVAggIkX2FQwDO5O3lLVWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lki/C2z0FSJAI2PEk5j5CB/qQm4c/CAzLqwNPvMxLfteXFN3vdGnVA49zQiN470mm
         ante7hIhB4inpo0zBvLewms2cLBON4zYPILW3s5mT9GPVHFgv4g//bsM+r3eZcebNT
         IUo86ek1XFs/jH9bcRO5tNpHsxtAE/+Rg2rwW214=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lucy Yan <lucyyan@google.com>, Moritz Fischer <mdf@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 03/11] net: dec: de2104x: Increase receive ring size for Tulip
Date:   Mon, 28 Sep 2020 21:31:21 -0400
Message-Id: <20200929013129.2406832-3-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929013129.2406832-1-sashal@kernel.org>
References: <20200929013129.2406832-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lucy Yan <lucyyan@google.com>

[ Upstream commit ee460417d254d941dfea5fb7cff841f589643992 ]

Increase Rx ring size to address issue where hardware is reaching
the receive work limit.

Before:

[  102.223342] de2104x 0000:17:00.0 eth0: rx work limit reached
[  102.245695] de2104x 0000:17:00.0 eth0: rx work limit reached
[  102.251387] de2104x 0000:17:00.0 eth0: rx work limit reached
[  102.267444] de2104x 0000:17:00.0 eth0: rx work limit reached

Signed-off-by: Lucy Yan <lucyyan@google.com>
Reviewed-by: Moritz Fischer <mdf@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/dec/tulip/de2104x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/dec/tulip/de2104x.c b/drivers/net/ethernet/dec/tulip/de2104x.c
index 13430f75496cc..b312cd9bce169 100644
--- a/drivers/net/ethernet/dec/tulip/de2104x.c
+++ b/drivers/net/ethernet/dec/tulip/de2104x.c
@@ -91,7 +91,7 @@ MODULE_PARM_DESC (rx_copybreak, "de2104x Breakpoint at which Rx packets are copi
 #define DSL			CONFIG_DE2104X_DSL
 #endif
 
-#define DE_RX_RING_SIZE		64
+#define DE_RX_RING_SIZE		128
 #define DE_TX_RING_SIZE		64
 #define DE_RING_BYTES		\
 		((sizeof(struct de_desc) * DE_RX_RING_SIZE) +	\
-- 
2.25.1

