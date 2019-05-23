Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E13F827749
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 09:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730598AbfEWHit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 03:38:49 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:43568 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730040AbfEWHha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 03:37:30 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 9AF22C018F;
        Thu, 23 May 2019 07:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1558597057; bh=ba+qVB/NWZuxByW3v1MuTmJSb5+zgkCiAXkRuR1pCXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=VMIT+JhM338H7xLyO0N4kUqOWaf/LOcGMzU2YKI0lK+GJimfW519xUFFr7xC3KWoo
         s54FeOi9INCz30rjqo9Ok22lDcadqnLIoLwwvRCicX9qcH5ZQmqwRZtk5rcb3XXdmi
         7LH0d2oVuDkrMtlpQvRwvjqTxB/Qsg1IcYwv+u1a5sShXZfHbYU+X3Iucpdjt4WhIk
         JFOeI2A22slljFkUnern94C5coIF2k66bKFhh6ZOWmjHiuWz/2amXVeLGQS85qTR6z
         landdhP5UR9nK80RamSTrqfBGwbgD6HuXV0bUgu8FQIBhJntLear+DUEYQT1N5w1C1
         L33hSVFPNjtCA==
Received: from de02.synopsys.com (germany.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 0B1DFA0242;
        Thu, 23 May 2019 07:37:30 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id C8E503D95E;
        Thu, 23 May 2019 09:37:28 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next 12/18] net: stmmac: dwmac1000: Fix Hash Filter
Date:   Thu, 23 May 2019 09:37:02 +0200
Message-Id: <df83ff2279c39b5ef9a57a149be128a544e97e9b.1558596600.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1558596599.git.joabreu@synopsys.com>
References: <cover.1558596599.git.joabreu@synopsys.com>
In-Reply-To: <cover.1558596599.git.joabreu@synopsys.com>
References: <cover.1558596599.git.joabreu@synopsys.com>
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

