Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E910F27736
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 09:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730477AbfEWHiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 03:38:13 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:43586 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730135AbfEWHhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 03:37:31 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 8EFE1C018A;
        Thu, 23 May 2019 07:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1558597057; bh=lIKxXg1RXJcwgYIT22UO3sRPedxBt/awS1mUiwd62oU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=eVCsOiupF4b5JMOIg8oc1S0WoXlYV/AIZD5HOVoHkPpME7hwFF3cC+7n0yBexXhHe
         zZFjaHROrYYPZQCQekei9iMVl8gZ0He9PiGKuo1+xVZPzmfbHwlkztZrSX/ZQCm0S2
         c9cmiCdIcfUEZmL7tatL0cHtGhtruB66NUcSrqX4XIq1wFrzFWNqeqg6GW5cQ8nXih
         Joom2uflsuEtAizx76Z+kq1UZBJQzdVkfnyLv3172v6hdyzXurdYGxYgDIAUR87nIM
         pM5XtdmN1ub7mYjTzsavuHrgmURuFO80r/wdO2JllRWXkfC0QLjVxu1ZvSsN9l+WES
         NKXE7sQf6XQMw==
Received: from de02.synopsys.com (germany.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id EE28DA00A5;
        Thu, 23 May 2019 07:37:29 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 75E443D94A;
        Thu, 23 May 2019 09:37:28 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next 08/18] net: stmmac: dwmac1000: Also pass control frames while in promisc mode
Date:   Thu, 23 May 2019 09:36:58 +0200
Message-Id: <01b51a808bb53e80543810cbb2b223248ef00682.1558596600.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1558596599.git.joabreu@synopsys.com>
References: <cover.1558596599.git.joabreu@synopsys.com>
In-Reply-To: <cover.1558596599.git.joabreu@synopsys.com>
References: <cover.1558596599.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order for the selftests to run the Flow Control selftest we need to
also pass pause frames to the stack.

Pass this type of frames while in promiscuous mode.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac1000.h      | 1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h b/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
index 184ca13c8f79..56a69fb6f0b9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
@@ -146,6 +146,7 @@ enum inter_frame_gap {
 #define GMAC_FRAME_FILTER_DAIF	0x00000008	/* DA Inverse Filtering */
 #define GMAC_FRAME_FILTER_PM	0x00000010	/* Pass all multicast */
 #define GMAC_FRAME_FILTER_DBF	0x00000020	/* Disable Broadcast frames */
+#define GMAC_FRAME_FILTER_PCF	0x00000080	/* Pass Control frames */
 #define GMAC_FRAME_FILTER_SAIF	0x00000100	/* Inverse Filtering */
 #define GMAC_FRAME_FILTER_SAF	0x00000200	/* Source Address Filter */
 #define GMAC_FRAME_FILTER_HPF	0x00000400	/* Hash or perfect Filter */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
index 398303c783f4..8ca73bd15e07 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
@@ -172,7 +172,7 @@ static void dwmac1000_set_filter(struct mac_device_info *hw,
 	memset(mc_filter, 0, sizeof(mc_filter));
 
 	if (dev->flags & IFF_PROMISC) {
-		value = GMAC_FRAME_FILTER_PR;
+		value = GMAC_FRAME_FILTER_PR | GMAC_FRAME_FILTER_PCF;
 	} else if (dev->flags & IFF_ALLMULTI) {
 		value = GMAC_FRAME_FILTER_PM;	/* pass all multi */
 	} else if (!netdev_mc_empty(dev)) {
-- 
2.7.4

