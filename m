Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F353E13AE98
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 17:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729346AbgANQJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 11:09:47 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:40754 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729010AbgANQJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 11:09:43 -0500
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 8BBB0C0622;
        Tue, 14 Jan 2020 16:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1579018181; bh=ZUcejPObu8oHBPIY+jDHZmtqjrP/NpkNh9B+0IOcr6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=CSJ1TE9Da/2Cwv52ZJtVkmhg0oeulSS5Z1nmTFqNa1dItw/2WpgwT8ylC5h1Minmj
         qvdPb3KAvc6lHu3r2QSM9PJCeUFOwb4A8p0cfPNAOnkY+d58kbdk8P4xADU/z3N83b
         arX9mSmc5CfoRMOxj5dJrLJGwDIqtpgLpdbbtpcG01XSQv1XN6F+GVngvA1VVrwNVw
         FDbT6mtUQzN8eA6UtVp9vJwSq5O5Be3f6M2d1bTXuJ8IwGyiexWbrOC9v6ObU77kyc
         dzRVdO5teG6TPopscRVdxmJl3UfJhKmIOR8cazKNCmsHEmBKwwzx4PpvSY8u8O759A
         PkgnepzRaPYQQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 32E86A0072;
        Tue, 14 Jan 2020 16:09:35 +0000 (UTC)
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
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        linux-snps-arc@lists.infradead.org
Subject: [PATCH net 3/4] net: stmmac: selftests: Guard VLAN Perfect test against non supported HW
Date:   Tue, 14 Jan 2020 17:09:23 +0100
Message-Id: <8dd7b44a9daa12301b34c3cb4b393c6d0e4a104a.1579017787.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1579017787.git.Jose.Abreu@synopsys.com>
References: <cover.1579017787.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1579017787.git.Jose.Abreu@synopsys.com>
References: <cover.1579017787.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When HW does not support perfect filtering the feature will not be
enabled in the net_device. Add a check for this to prevent failures.

Fixes: 1b2250a04c1f ("net: stmmac: selftests: Add tests for VLAN Perfect Filtering")
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
Cc: Alexey Brodkin <abrodkin@synopsys.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: linux-snps-arc@lists.infradead.org
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index 7edee3c87ac9..450d7dac3ea6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -971,6 +971,9 @@ static int stmmac_test_vlanfilt_perfect(struct stmmac_priv *priv)
 {
 	int ret, prev_cap = priv->dma_cap.vlhash;
 
+	if (!(priv->dev->features & NETIF_F_HW_VLAN_CTAG_FILTER))
+		return -EOPNOTSUPP;
+
 	priv->dma_cap.vlhash = 0;
 	ret = __stmmac_test_vlanfilt(priv);
 	priv->dma_cap.vlhash = prev_cap;
@@ -1063,6 +1066,9 @@ static int stmmac_test_dvlanfilt_perfect(struct stmmac_priv *priv)
 {
 	int ret, prev_cap = priv->dma_cap.vlhash;
 
+	if (!(priv->dev->features & NETIF_F_HW_VLAN_STAG_FILTER))
+		return -EOPNOTSUPP;
+
 	priv->dma_cap.vlhash = 0;
 	ret = __stmmac_test_dvlanfilt(priv);
 	priv->dma_cap.vlhash = prev_cap;
-- 
2.7.4

