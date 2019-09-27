Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39924C005C
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 09:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbfI0HtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 03:49:13 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:49692 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726255AbfI0HtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 03:49:12 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id EB3CAC0CEE;
        Fri, 27 Sep 2019 07:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1569570551; bh=w6MXqfF4WO8Qi/JIy8H5/V4nJcusg0KueWRh6mbOpiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=eXuXOmm4keIvNntZUoY0pTVRk7mhBflETDmGyDIHWQqATcgAqZ+FkZA2fKQq0K4uc
         7qRGIPncvU/d3q13h+YZmiiHlFtLdFeLmRuLQx0eHA0Kd+LLdQUNn6iAw2AgsTsMWh
         /UjTT4pu/nX/lEx4ERoMko/zvSpU5N5qJutC75CqvPcomQgNK7/dPcScvT3gkAcbf7
         +ZwTmY71tapk3aNjWEz8cfwIZnemOl+bvLrmrRXFc46QNLb5m6ZwXY5jWhKY2fqRps
         Hbi3MR9yENixtbONW9Nf2PhjmJKs2MDLknu43zjYGbRb5zNQZg0pxQ/9vyuDTHnZjn
         2QOTq3iAbf2Bw==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 95262A0091;
        Fri, 27 Sep 2019 07:49:09 +0000 (UTC)
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
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH net 8/8] net: stmmac: xgmac: Fix RSS not writing all Keys to HW
Date:   Fri, 27 Sep 2019 09:48:56 +0200
Message-Id: <80dd26ecf7fc82c88dc378d78210df5dd4138812.1569569778.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1569569778.git.Jose.Abreu@synopsys.com>
References: <cover.1569569778.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1569569778.git.Jose.Abreu@synopsys.com>
References: <cover.1569569778.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sizeof(cfg->key) is != ARRAY_SIZE(cfg->key). Fix it.

Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Fixes: 76067459c686 ("net: stmmac: Implement RSS and enable it in XGMAC core")
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
Cc: Nick Desaulniers <ndesaulniers@google.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index 6d8ac2ef4fc2..4a1f52474dbc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -533,7 +533,7 @@ static int dwxgmac2_rss_configure(struct mac_device_info *hw,
 		return 0;
 	}
 
-	for (i = 0; i < (sizeof(cfg->key) / sizeof(u32)); i++) {
+	for (i = 0; i < (ARRAY_SIZE(cfg->key) / sizeof(u32)); i++) {
 		ret = dwxgmac2_rss_write_reg(ioaddr, true, i, cfg->key[i]);
 		if (ret)
 			return ret;
-- 
2.7.4

