Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC0C6E9EF9
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 16:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbfJ3P3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 11:29:07 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:39130 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727039AbfJ3P3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 11:29:05 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 33041C0DE5;
        Wed, 30 Oct 2019 15:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1572449345; bh=scoltA+WigVvTzqdJe03QvtfADm3p97oUkWlWeL7UFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=C0JfV5wftejE2Zrc7hs298DB1il00674wv+0PaRxFtNkoGvpmkNNtTFYJ56xnidN1
         ASC+0Bp+rlLpTP8I5d7QuzkcAsG8LsLqVr0WY9fooMt95yhVFfTGQKasuHDyYjAFpd
         wwfn7bGENArpW0UOcDBE43gaHU0+tMDashY/KkBJDGcAmRF5rNJJbxCsmPPUvxX8fa
         BJNIN7zlxrFGqowRw3UQkFZrHvZVMTqV8jGG+EGOSMYOpdzXOt63EQebBLYhhnOjpU
         oT/PRO+FlNRz0SXTEuChQ4TlDTskk1uulbWMQ/eeu6HOAT5NzFA1YPWAUx1EC5D1l4
         7MiGLNceonL9w==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id DD1DCA0064;
        Wed, 30 Oct 2019 15:28:58 +0000 (UTC)
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
Subject: [PATCH net-next 3/3] net: stmmac: tc: Remove the speed dependency
Date:   Wed, 30 Oct 2019 16:28:50 +0100
Message-Id: <e376abc1b9511f9196977b7b4bb2f871dcbd44fe.1572449009.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1572449009.git.Jose.Abreu@synopsys.com>
References: <cover.1572449009.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1572449009.git.Jose.Abreu@synopsys.com>
References: <cover.1572449009.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XGMAC3 supports full CBS features with speeds that can go up to 10G so
we can now remove the maximum speed check of CBS.

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
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index f9a9a9d82233..7d972e0fd2b0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -321,8 +321,6 @@ static int tc_setup_cbs(struct stmmac_priv *priv,
 		return -EINVAL;
 	if (!priv->dma_cap.av)
 		return -EOPNOTSUPP;
-	if (priv->speed != SPEED_100 && priv->speed != SPEED_1000)
-		return -EOPNOTSUPP;
 
 	mode_to_use = priv->plat->tx_queues_cfg[queue].mode_to_use;
 	if (mode_to_use == MTL_QUEUE_DCB && qopt->enable) {
-- 
2.7.4

