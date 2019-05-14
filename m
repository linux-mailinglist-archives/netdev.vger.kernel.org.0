Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCE7A1CC32
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 17:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbfENPrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 11:47:08 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:35814 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726295AbfENPpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 11:45:41 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 294AEC0A69;
        Tue, 14 May 2019 15:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1557848732; bh=RHZJ7Nly+6eIj6TH+Vtugodh6n+S3lZDgZgpUVtcHXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=SOPr6xSgA/QAN5kpOeqPUDuqv2FNLiDYgDQHqGYuY2yC9bHxMQ4Gv3RMvFL1jytpk
         BBK+sKLHPt4FyghFV7Ya3ZWjkiDcWA5TgVVbdVJsfN94GQ3+kitzr5v3eNEiwbn2mt
         WFgrkSz6FiHKfrEugZCpN2naX4A2lsNC7CRJ74pNCFyUuJ2H8WH8bJ942OxA2GOljv
         JV+PsGzDI24JqlAHcTW+e8cyyRbvSFqOtJT8szY3l3y+jYQMg1Y/bmQVaURMeWmg79
         ho3fEtOSTh0r4XujxZgEIQaXYQE0ise9PhoxQ/ViI/RPDE8gCCtvWmROf7Ae44y4e7
         9pWn6smw1wmOw==
Received: from de02.synopsys.com (de02.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 549A7A0253;
        Tue, 14 May 2019 15:45:41 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 026883EA3A;
        Tue, 14 May 2019 17:45:40 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [RFC net-next v2 12/14] net: stmmac: dwmac1000: Fix Hash Filter
Date:   Tue, 14 May 2019 17:45:34 +0200
Message-Id: <ba44d3e21e1174642c3905903c39b0e94da3f57a.1557848472.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1557848472.git.joabreu@synopsys.com>
References: <cover.1557848472.git.joabreu@synopsys.com>
In-Reply-To: <cover.1557848472.git.joabreu@synopsys.com>
References: <cover.1557848472.git.joabreu@synopsys.com>
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
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>
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

