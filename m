Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 448EBBAE83
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 09:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393570AbfIWHbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 03:31:03 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:33332 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2393547AbfIWHbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 03:31:03 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 423F3C0389;
        Mon, 23 Sep 2019 07:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1569223863; bh=Xe7pJOKmi9PdaROLmoA5GLu3+ELilg5mJJ8WIbPwsjM=;
        h=From:To:Cc:Subject:Date:From;
        b=SLNeZWRKs9a98d13s37oxkygB2cM6X8LCVDsxufZJaTgnV48wee/FlPvgEglew6TJ
         TIlR3RHbDQH+jlUROGsyU3BdEo5T/ejWA2fmmIzy236/VGQRt/EJm3G5hWI151Pabf
         67lKHOybZbEb38u2qP6KnLGdFjzxUih1YNgcthppD82QF3Dk6xWx12ZttWMXfk841L
         nor99mvPb2CCynvVXMvAzPxfFaNoYqnWiHJGal7pnNSLvElNjQUUZqLAqwEXmbHkKv
         LhUxbwFpbicOBOyhUmR0sDQlmR/cYqMu8XAVK1jaCJeBgXEHonUQb5JQmXcwKVcyoc
         RZ8BCftF8VMgw==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id BFD84A005F;
        Mon, 23 Sep 2019 07:30:59 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] net: stmmac: selftests: Flow Control test can also run with ASYM Pause
Date:   Mon, 23 Sep 2019 09:30:43 +0200
Message-Id: <da7e2fb08061b4b89332c0ef014e053f98832894.1569223775.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <joabreu@synopsys.com>

The Flow Control selftest is also available with ASYM Pause. Lets add
this check to the test and fix eventual false positive failures.

Fixes: 091810dbded9 ("net: stmmac: Introduce selftests support")
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
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index 9c8d210b2d6a..5f66f6161629 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -670,7 +670,7 @@ static int stmmac_test_flowctrl(struct stmmac_priv *priv)
 	unsigned int pkt_count;
 	int i, ret = 0;
 
-	if (!phydev || !phydev->pause)
+	if (!phydev || (!phydev->pause && !phydev->asym_pause))
 		return -EOPNOTSUPP;
 
 	tpriv = kzalloc(sizeof(*tpriv), GFP_KERNEL);
-- 
2.7.4

