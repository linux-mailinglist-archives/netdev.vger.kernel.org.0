Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47C36292EE
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 10:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389897AbfEXIWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 04:22:03 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:38320 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389461AbfEXIUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 04:20:38 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id C6C67C0138;
        Fri, 24 May 2019 08:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1558686023; bh=ba+qVB/NWZuxByW3v1MuTmJSb5+zgkCiAXkRuR1pCXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=c1AbjN+g7+yTlfF+qGY/aYr+vxFZpE3WuDBIRY3LQ6n8f2R9019T28OZF5p4ar2Eg
         VmAprbFDVhFdl5l0N4zVGooJYH4jjUZ6KF6yi1kgA5hnFbYMzRt/gx1HkQaE8b6rcO
         1vNTgaN315Ca/fepQtVQzn+WuRxThD6zH6vGxSsABWkkaQ+GueA/NR1G4lCeDSyAZJ
         dH27cuRhYQVQlmWa40Beu4Da2J1sLdP6MZsKz5yURMoLQSSAE1Tz74sfnc33fHibDs
         +s3uuZF1a+F1/vI3zOhPLyB744lph6YGiyFA0TYLFG6eBg9/Nkqq4e9k6N/J3lyJGx
         PexkdOGpwQ+TA==
Received: from de02.synopsys.com (germany.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 9BC83A0253;
        Fri, 24 May 2019 08:20:37 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 422C53FB15;
        Fri, 24 May 2019 10:20:36 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next v2 12/18] net: stmmac: dwmac1000: Fix Hash Filter
Date:   Fri, 24 May 2019 10:20:20 +0200
Message-Id: <468493e3b5e7ea96a0bfa14b36d3c9bd7a47b65d.1558685828.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1558685827.git.joabreu@synopsys.com>
References: <cover.1558685827.git.joabreu@synopsys.com>
In-Reply-To: <cover.1558685827.git.joabreu@synopsys.com>
References: <cover.1558685827.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order for hash filter to work we need to set the HPF bit.

Found out while running stmmac selftests.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
index 8ca73bd15e07..bc91af6c01b6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
@@ -198,6 +198,7 @@ static void dwmac1000_set_filter(struct mac_device_info *hw,
 		}
 	}
 
+	value |= GMAC_FRAME_FILTER_HPF;
 	dwmac1000_set_mchash(ioaddr, mc_filter, mcbitslog2);
 
 	/* Handle multiple unicast addresses (perfect filtering) */
-- 
2.7.4

