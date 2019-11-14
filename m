Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C535CFC57A
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 12:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfKNLm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 06:42:57 -0500
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:56924 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726106AbfKNLm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 06:42:56 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id E8972C04CE;
        Thu, 14 Nov 2019 11:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1573731775; bh=YXLJfn/0yUG2/3omTVU/b/Ru9qVL71FIWquDK8WQkNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=kk+svtXN+TKjI5uygnNbtb3Rq0IxEStC1fuV8WYCmKGh5hMm9ssaVuddopzyv93zA
         ezsFOfvvVgZQmZq2F4j3phQfj1xMopK6hIZnwio/yTPaGBkWxxqG5gImrp0ainrFb9
         XLI4FrcCbR+brVNM/pL+ju74wZCUiisN0G55/BBXcELLu1Ty8c5BBrlRt/x3DMKe1f
         MqQV9c7Oo15SMY8La4VqwCwXUVpnnTi6Rbyn9Sg8JWjBQhoABx8uEEjqv88j3wW9wl
         USnD/rKaslxA464Z1zextNK6IwCqg+rn/B7usFM2rUntMsATUVa/SRcocUxSs9cinH
         qxiFDkGJ3QhHA==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id A336CA009A;
        Thu, 14 Nov 2019 11:42:53 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 7/7] net: stmmac: xgmac: Do not enable TBU interrupt
Date:   Thu, 14 Nov 2019 12:42:51 +0100
Message-Id: <8b462f80863dc66f2b14e0db9e9e309b4870d4ba.1573731453.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1573731453.git.Jose.Abreu@synopsys.com>
References: <cover.1573731453.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1573731453.git.Jose.Abreu@synopsys.com>
References: <cover.1573731453.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that TX Coalesce has been rewritten we no longer need this
additional interrupt enabled. This reduces CPU usage.

Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
index 99037386080a..e908d80a1d6f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
@@ -360,7 +360,7 @@
 #define XGMAC_TBUE			BIT(2)
 #define XGMAC_TIE			BIT(0)
 #define XGMAC_DMA_INT_DEFAULT_EN	(XGMAC_NIE | XGMAC_AIE | XGMAC_RBUE | \
-					XGMAC_RIE | XGMAC_TBUE | XGMAC_TIE)
+					XGMAC_RIE | XGMAC_TIE)
 #define XGMAC_DMA_CH_Rx_WATCHDOG(x)	(0x0000313c + (0x80 * (x)))
 #define XGMAC_RWT			GENMASK(7, 0)
 #define XGMAC_DMA_CH_STATUS(x)		(0x00003160 + (0x80 * (x)))
-- 
2.7.4

